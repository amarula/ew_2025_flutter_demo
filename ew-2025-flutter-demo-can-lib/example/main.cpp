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

    can.on_rx([&](const can_frame& frame) {
        const auto frame_str = CanUtils::can_frame_to_string(frame);

        BOOST_LOG_TRIVIAL(info) << "New CAN frame: " << frame_str;

        Measurement measurement_proto;
        if (!measurement_proto.ParseFromString(frame_str)) {
            BOOST_LOG_TRIVIAL(error) << "Failed data deserialization";
            return;
        }

        BOOST_LOG_TRIVIAL(info) << "New measurement:";
        BOOST_LOG_TRIVIAL(info)
            << "temperature: " << measurement_proto.temperature();
        BOOST_LOG_TRIVIAL(info) << "humidity:" << measurement_proto.humidity();
        BOOST_LOG_TRIVIAL(info) << "pressure: " << measurement_proto.pressure();
    });

    BOOST_LOG_TRIVIAL(info) << "Starting...";

    can.start_rx();
}
