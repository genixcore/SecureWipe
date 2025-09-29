#include "utils.h"
#include <filesystem>
#include <fstream>
#include <random>
#include <system_error>

using namespace std;
namespace fs = std::filesystem;

uint64_t get_file_size(const std::string &path) {
    std::error_code ec;
    auto sz = fs::file_size(path, ec);
    if (ec) return 0;
    return static_cast<uint64_t>(sz);
}

bool secure_remove_file(const std::string &path) {
    std::error_code ec;
    bool removed = fs::remove(path, ec);
    return removed && !ec;
}

static std::mt19937_64 make_rng_for_pass(int pass) {
    std::seed_seq seq{static_cast<uint32_t>(std::random_device{}()), static_cast<uint32_t>(pass)};
    return std::mt19937_64(seq);
}

std::vector<uint8_t> generate_pattern_block(size_t block_size, int pass, OverwritePattern pattern) {
    std::vector<uint8_t> buf(block_size);
    if (pattern == OverwritePattern::Zero) {
        std::fill(buf.begin(), buf.end(), 0x00);
    } else if (pattern == OverwritePattern::One) {
        std::fill(buf.begin(), buf.end(), 0xFF);
    } else if (pattern == OverwritePattern::Random) {
        std::random_device rd;
        std::mt19937_64 rng(rd());
        for (size_t i=0;i<block_size;i++) buf[i] = static_cast<uint8_t>(rng() & 0xFF);
    } else {
        auto rng = make_rng_for_pass(pass);
        for (size_t i=0;i<block_size;i++) buf[i] = static_cast<uint8_t>(rng() & 0xFF);
    }
    return buf;
}
