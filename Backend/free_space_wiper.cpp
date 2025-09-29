#include "wiper.h"
#include "utils.h"
#include <filesystem>
#include <fstream>
#include <iostream>
#include <chrono>
#include <thread>

using namespace std;
namespace fs = std::filesystem;
static constexpr size_t TMP_BLOCK = 1024 * 1024;

bool FreeSpaceWiper::wipe_free_space(const std::string &path, const WipeOptions &opt) {
    if (opt.verbose) cout << "[*] Free-space wipe for filesystem with: " << path << endl;
    fs::path dir(path);
    if (!fs::exists(dir)) { cerr << "[!] Path does not exist\n"; return false; }

    uint64_t available = 0;
    try {
        auto sp = fs::space(dir);
        available = static_cast<uint64_t>(sp.available);
    } catch (...) {
        cerr << "[!] Could not determine filesystem space\n";
        return false;
    }
    if (available < 4096) { cerr << "[!] Not enough space\n"; return false; }
    if (opt.verbose) cout << "  available: " << available << " bytes\n";

    auto stamp = chrono::steady_clock::now().time_since_epoch().count();
    fs::path base = dir / ("__wipe_tmp_" + to_string(stamp));
    uint64_t remaining = available;
    int idx = 0;
    while (remaining > 1024) {
        size_t chunk = static_cast<size_t>(std::min<uint64_t>(remaining, TMP_BLOCK * 8));
        fs::path tmp = base;
        tmp += ("_" + to_string(idx++));
        ofstream ofs(tmp, std::ios::binary);
        if (!ofs) break;
        auto block = generate_pattern_block(TMP_BLOCK, idx, opt.pattern);
        size_t written = 0;
        while (written < chunk) {
            size_t tw = std::min<size_t>(TMP_BLOCK, chunk - written);
            ofs.write(reinterpret_cast<const char*>(block.data()), tw);
            if (!ofs) break;
            written += tw;
            remaining -= tw;
        }
        ofs.flush();
        ofs.close();
        std::this_thread::sleep_for(std::chrono::milliseconds(20));
    }

    // remove temp files
    for (int i = 0; i < idx; ++i) {
        fs::path tmp = base;
        tmp += ("_" + to_string(i));
        std::error_code ec;
        fs::remove(tmp, ec);
    }
    if (opt.verbose) cout << "[+] Free-space wipe finished. Created " << idx << " temp files.\n";
    return true;
}
