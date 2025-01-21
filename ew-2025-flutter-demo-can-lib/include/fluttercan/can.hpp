#pragma once

#include <linux/can.h>

#include <boost/signals2/signal.hpp>
#include <cstdint>
#include <string>

#include "can_settings.hpp"

class CAN {
   public:
    explicit CAN(const CanSettings &settings);

    void init();

    boost::signals2::connection on_rx(
        const boost::signals2::signal<void(const can_frame &)>::slot_type
            &slot);

    void start_rx();
    void stop_rx();

    void tx(const can_frame &frame) const;

   private:
    std::string ifname_;
    BitTiming timing_;

    int sock_fd_{-1};
    uint32_t tx_timeout_ms_;
    int tx_queue_len_;

    boost::signals2::signal<void(const can_frame &)> on_rx_signal_;
};
