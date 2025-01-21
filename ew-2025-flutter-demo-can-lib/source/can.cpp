
#include "fluttercan/can.hpp"

#include <libsocketcan.h>
#include <net/if.h>
#include <poll.h>
#include <sys/ioctl.h>

#include <boost/log/trivial.hpp>

const int poll_timeout_ms = 500;

void ms_to_timeval(struct timeval &tv, uint32_t ms) {
    const uint32_t msec_per_sec = 1000;
    const uint32_t usec_per_msec = 1000;

    tv.tv_sec = ms / msec_per_sec;
    tv.tv_usec = (ms - tv.tv_sec * msec_per_sec) * usec_per_msec;
}

CAN::CAN(const CanSettings &settings)
    : ifname_(settings.ifname()), timing_(settings.timings()) {}

void CAN::init() {
    timeval tv;
    ifreq ifr;
    int err;

    strncpy(ifr.ifr_name, ifname_.c_str(), IFNAMSIZ - 1);
    ifr.ifr_name[IFNAMSIZ - 1] = '\0';
    ifr.ifr_ifindex = static_cast<int>(if_nametoindex(ifr.ifr_name));
    if (ifr.ifr_ifindex == 0) {
        throw std::invalid_argument("'" + ifname_ + "': interface not found");
    }

    struct can_bittiming bt {};
    bt.tq = timing_.tq;
    bt.prop_seg = timing_.prop_seg;
    bt.phase_seg1 = timing_.phase_seg1;
    bt.phase_seg2 = timing_.phase_seg2;
    bt.sjw = timing_.sjw;
    err = can_set_bittiming(ifname_.c_str(), &bt);
    if (err < 0) {
        throw std::runtime_error(std::string(__PRETTY_FUNCTION__) +
                                 " - failed  to set bit timing");
    }

    err = can_set_bitrate_samplepoint(ifname_.c_str(), timing_.bitrate,
                                      timing_.sample_point);
    if (err < 0) {
        throw std::runtime_error(std::string(__PRETTY_FUNCTION__) +
                                 " - failed  to set bit rate");
    }

    err = can_get_bittiming(ifname_.c_str(), &bt);
    if (err < 0) {
        throw std::runtime_error(std::string(__PRETTY_FUNCTION__) +
                                 " - failed  to set bit timing");
    }

    BOOST_LOG_TRIVIAL(info) << ifname_ << ".bitrate: " << bt.bitrate;
    BOOST_LOG_TRIVIAL(info) << ifname_ << ".sample_point: " << bt.sample_point;
    BOOST_LOG_TRIVIAL(info) << ifname_ << ".tq: " << bt.tq;
    BOOST_LOG_TRIVIAL(info) << ifname_ << ".prop_seg: " << bt.prop_seg;
    BOOST_LOG_TRIVIAL(info) << ifname_ << ".phase_seg1: " << bt.phase_seg1;
    BOOST_LOG_TRIVIAL(info) << ifname_ << ".phase_seg2: " << bt.phase_seg2;
    BOOST_LOG_TRIVIAL(info) << ifname_ << ".sjw: " << bt.sjw;
    BOOST_LOG_TRIVIAL(info) << ifname_ << ".brp: " << bt.brp;

    err = can_do_start(ifname_.c_str());
    if (err < 0) {
        throw std::runtime_error(std::string(__PRETTY_FUNCTION__) +
                                 " - failed to start the '" + ifname_ +
                                 "' interface");
    }

    sock_fd_ = socket(PF_CAN, SOCK_RAW, CAN_RAW);
    if (sock_fd_ < 0) {
        throw std::runtime_error(std::string(__PRETTY_FUNCTION__) +
                                 " - socket create error - " +
                                 std::strerror(errno));
    }

    ms_to_timeval(tv, tx_timeout_ms_);
    err = setsockopt(sock_fd_, SOL_SOCKET, SO_SNDTIMEO, &tv, sizeof(tv));
    if (err < 0) {
        stop_rx();
        throw std::runtime_error(std::string(__PRETTY_FUNCTION__) +
                                 " - socket option error - " +
                                 std::strerror(errno));
    }

    struct sockaddr_can addr;

    memset(&addr, 0, sizeof(addr));
    addr.can_family = AF_CAN;
    addr.can_ifindex = ifr.ifr_ifindex;

    err = bind(sock_fd_, reinterpret_cast<struct sockaddr *>(&addr),
               sizeof(addr));
    if (err < 0) {
        stop_rx();
        throw std::runtime_error(std::string(__PRETTY_FUNCTION__) +
                                 " - socket bind error - " +
                                 std::strerror(errno));
    }
}

boost::signals2::connection CAN::on_rx(
    const boost::signals2::signal<void(const can_frame &)>::slot_type &slot) {
    return on_rx_signal_.connect(slot);
}

void CAN::start_rx() {
    can_frame frame;
    std::vector<uint8_t> reply;
    pollfd fds[1];

    fds[0].fd = sock_fd_;
    fds[0].events = POLLIN;

    while (true) {
        int ret = poll(fds, 1, poll_timeout_ms);
        if (ret == -1) {
            BOOST_LOG_TRIVIAL(error)
                << __PRETTY_FUNCTION__ << " - poll error - "
                << std::strerror(errno);
            break;
        }

        if (ret == 0 || (fds[0].revents & POLLIN) == 0) {
            continue;
        }

        auto n = read(sock_fd_, &frame, sizeof(frame));
        if (n < 0) {
            BOOST_LOG_TRIVIAL(error)
                << __PRETTY_FUNCTION__ << " - read error - "
                << std::strerror(errno);
            continue;
        }

        on_rx_signal_(frame);
    }
}

void CAN::stop_rx() {
    close(sock_fd_);
    can_do_stop(ifname_.c_str());
}

void CAN::tx(const can_frame &frame) const {
    auto n = write(sock_fd_, &frame, sizeof(frame));
    if (n < 0) {
        BOOST_LOG_TRIVIAL(error)
            << __PRETTY_FUNCTION__ << " - write error - "
            << std::strerror(errno) << ", frame ID " << frame.can_id;
        return;
    }
}
