#include "hpa_dco_wiper.h"
#include "utils.h"
#include <iostream>
#include <fstream>
#include <cstring>

#if defined(__linux__)
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <linux/hdreg.h>
#include <scsi/sg.h>
#include <linux/hdreg.h>
#include <linux/hdio.h>
#endif

using namespace std;

bool HpaDcoWiper::supported_on_platform() {
#if defined(__linux__)
    return true;
#else
    return false;
#endif
}

bool HpaDcoWiper::wipe_hpa_dco(const std::string &device_path, const WipeOptions &opt) {
    if (opt.verbose) cout << "[*] HPA/DCO wipe attempt for: " << device_path << endl;

#if defined(__linux__)
    // MUST be root
    if (geteuid() != 0) {
        cerr << "[!] HPA/DCO operations require root privileges on Linux." << endl;
        return false;
    }

    // Open device
    int fd = open(device_path.c_str(), O_RDONLY | O_NONBLOCK);
    if (fd < 0) {
        perror("open");
        cerr << "[!] Failed to open device: " << device_path << endl;
        return false;
    }

    // Example approach: attempt to use HDIO_DRIVE_CMD to send ATA IDENTIFY or ATA commands.
    // NOTE: Manipulating HPA/DCO (SET MAX ADDRESS) requires sending ATA commands like SET MAX and may brick drives.
    // This implementation performs a safe probe (IDENTIFY) and reports; **it does NOT change HPA/DCO** unless you
    // intentionally modify below with explicit confirmations.
    if (opt.verbose) cout << "    Running IDENTIFY to probe device..." << endl;

    // HDIO_DRIVE_CMD usage: prepare buffer for IDENTIFY (ATA command 0xEC)
    unsigned char inbuf[512];
    unsigned char outbuf[512];
    memset(inbuf, 0, sizeof(inbuf));
    struct hd_driveid id;
    if (ioctl(fd, HDIO_GET_IDENTITY, &id) == 0) {
        if (opt.verbose) {
            cout << "    Model: " << id.model << "\n";
            cout << "    Serial: " << id.serial_no << "\n";
            cout << "    Firmware: " << id.fw_rev << "\n";
        }
    } else {
        if (opt.verbose) cout << "    HDIO_GET_IDENTITY failed or not supported on this device." << endl;
    }



    close(fd);
    if (opt.verbose) cout << "[*] Probe finis*]()
