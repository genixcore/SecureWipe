#include "certificate.h"
#include <sstream>
#include <fstream>
#include <iomanip>
#include <ctime>
#include <vector>
#include <openssl/bio.h>
#include <openssl/evp.h>
#include <openssl/buffer.h>

#ifdef HPDF_H
#include <hpdf.h>
#endif

static std::string base64_encode(const std::vector<uint8_t> &in) {
    BIO *bmem = BIO_new(BIO_s_mem());
    BIO *b64 = BIO_new(BIO_f_base64());
    BIO_set_flags(b64, BIO_FLAGS_BASE64_NO_NL);
    BIO_push(b64, bmem);
    BIO_write(b64, in.data(), in.size());
    BIO_flush(b64);
    BUF_MEM *bptr;
    BIO_get_mem_ptr(b64, &bptr);
    std::string out(bptr->data, bptr->length);
    BIO_free_all(b64);
    return out;
}

std::string make_cert_canonical_json(const WipeCert &c) {
    std::ostringstream oss;
    oss << "{\n";
    oss << "  \"device\": \"" << c.device << "\",\n";
    oss << "  \"operator\": \"" << c.operator_name << "\",\n";
    oss << "  \"timestamp\": \"" << c.timestamp_iso << "\",\n";
    oss << "  \"passes\": " << c.passes << ",\n";
    oss << "  \"pattern\": \"" << c.pattern << "\",\n";
    oss << "  \"hash_after\": \"" << c.hash_after << "\"\n";
    oss << "}\n";
    return oss.str();
}

bool write_signed_certificate_json(const WipeCert &cert, const std::string &privkey_pem, const std::string &out_path) {
    // create canonical JSON and sign it
    WipeCert tmp = cert;
    tmp.signature.clear();
    std::string canonical = make_cert_canonical_json(tmp);
    std::vector<uint8_t> buf(canonical.begin(), canonical.end());
    std::vector<uint8_t> sig;
    if (!sign_buffer_pem(buf, privkey_pem, sig)) {
        return false;
    }
    // build final JSON with signature base64
    std::ostringstream oss;
    oss << "{\n";
    oss << "  \"device\": \"" << cert.device << "\",\n";
    oss << "  \"operator\": \"" << cert.operator_name << "\",\n";
    oss << "  \"timestamp\": \"" << cert.timestamp_iso << "\",\n";
    oss << "  \"passes\": " << cert.passes << ",\n";
    oss << "  \"pattern\": \"" << cert.pattern << "\",\n";
    oss << "  \"hash_after\": \"" << cert.hash_after << "\",\n";
    oss << "  \"signature_base64\": \"" << base64_encode(sig) << "\"\n";
    oss << "}\n";
    std::ofstream ofs(out_path, std::ios::binary);
    if (!ofs) return false;
    ofs << oss.str();
    ofs.close();
    return true;
}

bool write_certificate_pdf_if_possible(const WipeCert &cert, const std::string &out_pdf_path) {
#ifdef HPDF_H
    HPDF_Doc pdf = HPDF_New(nullptr, nullptr);
    if (!pdf) return false;
    HPDF_UseUTFEncodings(pdf);
    HPDF_Page page = HPDF_AddPage(pdf);
    HPDF_Page_SetSize(page, HPDF_PAGE_SIZE_A4, HPDF_PAGE_PORTRAIT);
    HPDF_Font font = HPDF_GetFont(pdf, "Helvetica", "WinAnsiEncoding");
    float y = HPDF_Page_GetHeight(page) - 50;
    float x = 50;

    std::ostringstream ss;
    ss << "Wipe Certificate\n\n";
    ss << "Device: " << cert.device << "\n";
    ss << "Operator: " << cert.operator_name << "\n";
    ss << "Timestamp: " << cert.timestamp_iso << "\n";
    ss << "Passes: " << cert.passes << "\n";
    ss << "Pattern: " << cert.pattern << "\n";
    ss << "Hash(after): " << cert.hash_after << "\n";
    ss << "Signature (hex): " << (cert.signature.empty() ? std::string("<not embedded>") : to_hex(cert.signature)) << "\n";

    std::string text = ss.str();
    HPDF_Page_BeginText(page);
    HPDF_Page_SetTextLeading(page, 14);
    HPDF_Page_SetFontAndSize(page, font, 11);
    HPDF_Page_TextOut(page, x, y, "Wipe Certificate");
    y -= 22;

    std::istringstream lines(text);
    std::string line;
    while (std::getline(lines, line)) {
        HPDF_Page_TextOut(page, x, y, line.c_str());
        y -= 14;
        if (y < 40) {
            HPDF_Page_EndText(page);
            page = HPDF_AddPage(pdf);
            HPDF_Page_BeginText(page);
            HPDF_Page_SetFontAndSize(page, font, 11);
            y = HPDF_Page_GetHeight(page) - 50;
        }
    }
    HPDF_Page_EndText(page);
    HPDF_SaveToFile(pdf, out_pdf_path.c_str());
    HPDF_Free(pdf);
    return true;
#else
    (void)cert; (void)out_pdf_path;
    return false;
#endif
}
