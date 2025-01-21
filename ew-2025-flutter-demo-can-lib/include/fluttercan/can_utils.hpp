#pragma once

#include <linux/can.h>
#include <sys/types.h>

#include <boost/format.hpp>
#include <cstdint>
#include <string>
#include <vector>

class CanUtils {
   public:
    static uint32_t fill_frame(can_frame &frame, uint32_t id,
                               const std::vector<uint8_t> &tx,
                               uint32_t start_tx) {
        uint8_t dlc = 0;

        frame.can_id = id;
        for (size_t d = start_tx; dlc < 8 && d < tx.size(); dlc++) {
            frame.data[dlc] = tx[d++];
        }

        frame.can_dlc = dlc;
        return dlc;
    }

    static std::string can_frame_to_string(const can_frame &frame) {
        std::string rx = (boost::format("%X") % frame.can_id).str() + "#";
        for (int i = 0; i < frame.can_dlc; ++i) {
            rx +=
                (boost::format("%02X") % static_cast<int>(frame.data[i])).str();
        }
        return rx;
    }
};
