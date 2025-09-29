#include "wiper.h"
#include "utils.h"
#include <fstream>
#include <iostream>
#include <vector>

using namespace std;

static constexpr size_t BUF_SIZE = 1024 * 1024;

bool FileWiper::wipe_file(const std::string &path, const WipeOptions &opt) {
    if (opt.verbose) cout << "[*] Wiping file: " << path << endl;

    uint64_t file_size = get_file_size(path);
    if (file_size == 0) {
        if (opt.verbose) cout << "[!] File size is 0. Removing directly." << endl;
        if (opt.remove_after) return secure_remove_file(path);
        return true;
    }

    for (int pass = 0; pass < opt.passes; ++pass) {
        if (opt.verbose) cout << "    pass " << (pass+1) << "/" << opt.passes << endl;
        std::ofstream ofs(path, ios::binary | ios::in | ios::out);
        if (!ofs) {
            ofs.open(path, ios::binary | ios::trunc);
            if (!ofs) { cerr << "[!] Failed to open file: " << path << endl; return false; }
        }
        uint64_t written = 0;
        auto buf = generate_pattern_block(BUF_SIZE, pass+1, opt.pattern);
        while (written < file_size) {
            size_t to_write = min<uint64_t>(BUF_SIZE, file_size - written);
            ofs.write(reinterpret_cast<const char*>(buf.data()), to_write);
            if (!ofs) { cerr << "[!] Write failed." << endl; return false; }
            written += to_write;
        }
        ofs.flush();
        ofs.close();
    }

    if (opt.remove_after) {
        if (opt.verbose) cout << "    removing file..." << endl;
        if (!secure_remove_file(path)) { cerr << "[!] Failed to remove file." << endl; return false; }
    }

    if (opt.verbose) cout << "[+] Wipe complete." << endl;
    return true;
}
