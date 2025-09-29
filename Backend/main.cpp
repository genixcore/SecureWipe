#include "wiper.h"
#include <iostream>
#include <string>

using namespace std;

static void print_usage() {
    cout << "secure_wiper - secure wiping tool\n";
    cout << "Usage:\n";
    cout << "  secure_wiper file <path> [passes]\n";
    cout << "  secure_wiper freesp <directory> [passes]\n";
}

int main(int argc, char **argv) {
    if (argc < 3) { print_usage(); return 1; }

    string cmd = argv[1];
    string target = argv[2];
    int passes = (argc >= 4) ? stoi(argv[3]) : 1;

    WipeOptions opt;
    opt.passes = passes;

    if (cmd == "file") {
        return FileWiper::wipe_file(target, opt) ? 0 : 2;
    } else if (cmd == "freesp") {
        return FreeSpaceWiper::wipe_free_space(target, opt) ? 0 : 3;
    } else {
        print_usage();
        return 1;
    }
}
