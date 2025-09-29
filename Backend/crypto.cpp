#include "crypto.h"
#include <openssl/evp.h>
#include <openssl/pem.h>
#include <openssl/err.h>
#include <iostream>
#include <sstream>
#include <iomanip>
#include <vector>
#include <cstdio>

static void openssl_init() {
   
    ERR_load_crypto_strings();
    OpenSSL_add_all_algorithms();
}

static void openssl_cleanup() {
    EVP_cleanup();
    ERR_free_strings();
}

bool sign_buffer_pem(const std::vector<uint8_t> &data, const std::string &privkey_pem_path, std::vector<uint8_t> &out_signature) {
    openssl_init();
    out_signature.clear();

    FILE *fp = fopen(privkey_pem_path.c_str(), "rb");
    if (!fp) {
        std::cerr << "[!] Cannot open private key PEM: " << privkey_pem_path << std::endl;
        return false;
    }
    EVP_PKEY *pkey = PEM_read_PrivateKey(fp, nullptr, nullptr, nullptr);
    fclose(fp);
    if (!pkey) {
        std::cerr << "[!] PEM_read_PrivateKey failed\n";
        return false;
    }

    EVP_MD_CTX *mdctx = EVP_MD_CTX_new();
    if (!mdctx) { EVP_PKEY_free(pkey); return false; }

    const EVP_MD *md = EVP_sha256();
    if (EVP_DigestSignInit(mdctx, nullptr, md, nullptr, pkey) != 1) {
        EVP_MD_CTX_free(mdctx); EVP_PKEY_free(pkey); return false;
    }
    if (EVP_DigestSignUpdate(mdctx, data.data(), data.size()) != 1) {
        EVP_MD_CTX_free(mdctx); EVP_PKEY_free(pkey); return false;
    }
    size_t siglen = 0;
    if (EVP_DigestSignFinal(mdctx, nullptr, &siglen) != 1) {
        EVP_MD_CTX_free(mdctx); EVP_PKEY_free(pkey); return false;
    }
    out_signature.resize(siglen);
    if (EVP_DigestSignFinal(mdctx, out_signature.data(), &siglen) != 1) {
        EVP_MD_CTX_free(mdctx); EVP_PKEY_free(pkey); out_signature.clear(); return false;
    }
    out_signature.resize(siglen);

    EVP_MD_CTX_free(mdctx);
    EVP_PKEY_free(pkey);
    // no cleanup for OpenSSL global here (kept simple)
    return true;
}

bool verify_signature_pem(const std::vector<uint8_t> &data, const std::vector<uint8_t> &signature, const std::string &pubkey_pem_path) {
    openssl_init();
    FILE *fp = fopen(pubkey_pem_path.c_str(), "rb");
    if (!fp) { std::cerr << "[!] Cannot open public key PEM: " << pubkey_pem_path << std::endl; return false; }
    EVP_PKEY *pkey = PEM_read_PUBKEY(fp, nullptr, nullptr, nullptr);
    fclose(fp);
    if (!pkey) { std::cerr << "[!] PEM_read_PUBKEY failed\n"; return false; }

    EVP_MD_CTX *mdctx = EVP_MD_CTX_new();
    if (!mdctx) { EVP_PKEY_free(pkey); return false; }

    const EVP_MD *md = EVP_sha256();
    if (EVP_DigestVerifyInit(mdctx, nullptr, md, nullptr, pkey) != 1) {
        EVP_MD_CTX_free(mdctx); EVP_PKEY_free(pkey); return false;
    }
    if (EVP_DigestVerifyUpdate(mdctx, data.data(), data.size()) != 1) {
        EVP_MD_CTX_free(mdctx); EVP_PKEY_free(pkey); return false;
    }
    int ok = EVP_DigestVerifyFinal(mdctx, signature.data(), signature.size());
    EVP_MD_CTX_free(mdctx);
    EVP_PKEY_free(pkey);
    return ok == 1;
}

std::string to_hex(const std::vector<uint8_t> &buf) {
    std::ostringstream oss;
    for (auto b : buf) oss << std::hex << std::setw(2) << std::setfill('0') << (int)b;
    return oss.str();
}
