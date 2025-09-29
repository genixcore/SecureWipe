#include "disk_wipe.h"
#include <fstream>
#include <iostream>
#include <cstdlib>

bool wipe_device(const std::string& device_path, uint64_t wipe_size_bytes) {
    std::ofstream device(device_path, std::ios::binary | std::ios::out);
    if (!device.is_open()) {
        std::cerr << "Failed to open device: " << device_path << std::endl;
        return false;
    }

    const size_t buffer_size = 4096;
    char zero_buffer[buffer_size] = {0};

    uint64_t total_written = 0;
    while (total_written < wipe_size_bytes) {
        size_t to_write = (wipe_size_bytes - total_written > buffer_size) ? buffer_size : (wipe_size_bytes - total_written);
        device.write(zero_buffer, to_write);
        if (!device) {
            std::cerr << "Write failure at " << total_written << " bytes" << std::endl;
            device.close();
            return false;
        }
        total_written += to_write;
    }
    device.close();
    return true;



    
}

bool erase_hpa_dco(const std::string& device_path) {
    // Linux example: uses hdparm to erase HPA/DCO areas
    std::string cmd = "hdparm --security-erase-enhanced NULL " + device_path;
    int ret = system(cmd.c_str());
    return (ret == 0);
}
