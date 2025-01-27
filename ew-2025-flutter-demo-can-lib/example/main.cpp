#include <boost/log/core.hpp>
#include <boost/log/expressions.hpp>
#include <boost/log/trivial.hpp>
#include <filesystem>

#include "fluttercan/can.hpp"
#include "fluttercan/can_settings.hpp"
#include "fluttercan/can_settings_parser.hpp"
#include "fluttercan/can_utils.hpp"
#include "measurement.pb.h"

#define STRINGIFY(x) #x
#define TO_STRING(x) STRINGIFY(x)

namespace logging = boost::log;

int main(int argc, char** argv) {
    logging::core::get()->set_filter(logging::trivial::severity >= 0);

    CanSettings can_settings;

    auto settings_file_path = "/home/root/can_settings.ini";

    if (!std::filesystem::exists(settings_file_path)) {
        settings_file_path =
            TO_STRING(PROJECT_SOURCE_DIR) "/cfg/can_settings.ini";
    }

    try {
        can_settings = CanSettingsParser::parseSettingsFile(settings_file_path);
    } catch (const std::exception& e) {
        BOOST_LOG_TRIVIAL(error)
            << "Caught exception when loading CAN settings: " << e.what();
        return 1;
    }

    CAN can(can_settings);

    try {
        can.init();
    } catch (const std::exception& e) {
        BOOST_LOG_TRIVIAL(error)
            << "Caught exception when init CAN: " << e.what();
        return 1;
    }

    can_frame frame_123;

    can.on_rx([&](const can_frame& frame) {
        BOOST_LOG_TRIVIAL(info)
            << "New CAN frame: " << CanUtils::can_frame_to_string(frame);

        if (frame.can_id == 0x123) {
            frame_123 = frame;
            return;
        }

        const auto data_len = frame_123.len + frame.len;
        unsigned char data_array[data_len];
        for (auto i = 0, j = 0; i < data_len; i++) {
            if (i >= frame_123.len) {
                data_array[i] = frame.data[j];
                j++;
            } else {
                data_array[i] = frame_123.data[i];
            }
        }

        Measurement measurement_proto;
        if (!measurement_proto.ParseFromArray(data_array, data_len)) {
            BOOST_LOG_TRIVIAL(error) << "Failed data deserialization";
            return;
        }

        BOOST_LOG_TRIVIAL(info) << "New measurement:";
        BOOST_LOG_TRIVIAL(info)
            << "temperature: " << measurement_proto.temperature();
        BOOST_LOG_TRIVIAL(info) << "humidity: " << measurement_proto.humidity();
        BOOST_LOG_TRIVIAL(info) << "pressure: " << measurement_proto.pressure();
    });

    BOOST_LOG_TRIVIAL(info) << "Starting...";

    can.start_rx();
}
