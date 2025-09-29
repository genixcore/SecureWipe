// Simple console UI to tie together file wipe, free-space wipe, HPA probe, and certificate creation.
// This file assumes other modules exist (FileWiper, FreeSpaceWiper, HpaDcoWiper, certificate, crypto, utils).

#include <iostream>
#include <string>
#include <chrono>
#include <iomanip>
#include "wiper.h"
#include "utils.h"
#include "hpa_dco_wiper.h"
#include "certificate.h"
#include "crypto.h"

using namespace std;

static string iso_now() {
    auto t = chrono::system_clock::now();
    time_t tt = chrono::system_clock::to_time_t(t);
    std::tm tm{};
#ifdef _WIN32
    gmtime_s(&tm, &tt);
#else
    gmtime_r(&tt, &tm);
#endif
    char buf[64];
    strftime(buf, sizeof(buf), "%Y-%m-%dT%H:%M:%SZ", &tm);
    return string(buf);
}

static void one_click_file_wipe() {
    cout << "Enter path to file to wipe: ";
    string path; getline(cin, path);
    if (path.empty()) { cout << "Aborted.\n"; return; }

    cout << "Number of passes (default 3): ";
    string passes_s; getline(cin, passes_s);
    int passes = 3;
    if (!passes_s.empty()) passes = stoi(passes_s);

    WipeOptions opt;
    opt.passes = passes;
    opt.pattern = OverwritePattern::Pseudorandom;
    opt.block_size = 1024 * 1024;
    opt.verify = true;
    opt.remove_after = true;
    opt.verbose = true;

    cout << "\n!!! Confirm wipe of file (IRREVERSIBLE). Type 'YES' to proceed: ";
    string confirm; getline(cin, confirm);
    if (confirm != "YES") { cout << "Cancelled by user.\n"; return; }

    bool ok = FileWiper::wipe_file(path, opt);
    if (!ok) { cout << "Wipe failed.\n"; return; }

    // Build certificate
    WipeCert cert;
    cert.device = path;
    cert.operator_name = "operator"; // replace with UI input if desired
    cert.timestamp_iso = iso_now();
    cert.passes = opt.passes;
    cert.pattern = "Pseudorandom";
    string digest;
    if (sha256_file_hex(path, digest)) cert.hash_after = digest;
    else cert.hash_after = "<unreadable>";

    cout << "Enter path to private key PEM to sign certificate (or leave blank to skip): ";
    string priv; getline(cin, priv);
    if (!priv.empty()) {
        // create signed JSON
        bool wrote = write_signed_certificate_json(cert, priv, path + ".wipe-cert.json");
        if (wrote) cout << "Signed JSON written: " << path << ".wipe-cert.json\n";
        else cout << "Failed to write signed JSON certificate.\n";
    } else {
        // write unsigned canonical JSON
        string cjson = make_cert_canonical_json(cert);
        string out = path + ".wipe-cert.json";
        ofstream ofs(out, ios::binary);
        ofs << cjson;
        ofs.close();
        cout << "Unsigned JSON written: " << out << "\n";
    }
}

static void free_space_menu() {
    cout << "Directory to target for free-space wipe (e.g. / or /home): ";
    string dir; getline(cin, dir);
    if (dir.empty()) { cout << "Aborted.\n"; return; }
    WipeOptions opt;
    opt.passes = 1;
    opt.pattern = OverwritePattern::Random;
    opt.block_size = 1024 * 1024;
    opt.verify = false;
    opt.remove_after = true;
    opt.verbose = true;

    cout << "Confirm free-space wipe on '" << dir << "' (type YES): ";
    string c; getline(cin, c);
    if (c != "YES") { cout << "Cancelled.\n"; return; }
    bool ok = FreeSpaceWiper::wipe_free_space(dir, opt);
    cout << (ok ? "Done.\n" : "Failed.\n");
}

static void hpa_menu() {
    cout << "Device path to probe for HPA/DCO (e.g. /dev/sdb): ";
    string dev; getline(cin, dev);
    if (dev.empty()) { cout << "Aborted.\n"; return; }
    WipeOptions opt;
    opt.verbose = true;
    if (!HpaDcoWiper::supported_on_platform()) {
        cout << "HPA/DCO operations not supported on this platform in demo.\n";
        return;
    }
    cout << "This will only probe and report. Changing HPA/DCO is disabled.\n";
    bool ok = HpaDcoWiper::wipe_hpa_dco(dev, opt);
    cout << (ok ? "Probe complete.\n" : "Probe failed.\n");
}

int main_console_ui() {
    while (true) {
        cout << "====== Secure Wiper - One Click Console ======\n";
        cout << "1) Wipe a file (one-click)\n";
        cout << "2) Wipe free space\n";
        cout << "3) Probe HPA/DCO (safe probe)\n";
        cout << "4) Exit\n";
        cout << "Select: ";
        string sel; getline(cin, sel);
        if (sel == "1") one_click_file_wipe();
        else if (sel == "2") free_space_menu();
        else if (sel == "3") hpa_menu();
        else if (sel == "4") { cout << "Bye.\n"; break; }
        else cout << "Invalid selection.\n";
    }
    return 0;
}

// If compiled standalone, provide a small main guard. Otherwise call main_console_ui() from main.
#ifdef BUILD_CONSOLE_UI
int main() {
    return main_console_ui();
}
#endif
