#pragma once

#include <cstdint>
#include <string>

struct BitTiming {
    uint32_t bitrate;
    uint32_t sample_point;
    uint32_t tq;
    uint32_t prop_seg;
    uint32_t phase_seg1;
    uint32_t phase_seg2;
    uint32_t sjw;
    uint32_t brp;
};

class CanSettings {
   public:
    CanSettings() = default;

    CanSettings(std::string ifname, BitTiming timings)
        : ifname_(std::move(ifname)), timings_(timings) {}

    [[nodiscard]] std::string ifname() const { return ifname_; }

    [[nodiscard]] BitTiming timings() const { return timings_; }

   private:
    std::string ifname_;
    BitTiming timings_;
};
