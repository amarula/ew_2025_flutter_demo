#include <boost/log/core.hpp>
#include <boost/log/expressions.hpp>
#include <boost/log/trivial.hpp>
#include <filesystem>
#include <iostream>
#include <thread>

#include "fluttercan/can.hpp"
#include "fluttercan/can_settings.hpp"
#include "fluttercan/can_settings_parser.hpp"
#include "fluttercan/can_utils.hpp"
#include "fluttercan/ffi_export.hpp"
#include "measurement.pb.h"

#define STRINGIFY(x) #x
#define TO_STRING(x) STRINGIFY(x)

static float k_temperature = 1;
static float k_humidity = 2;
static float k_pressure = 3;

EXPORT float get_temperature() { return k_temperature; }

EXPORT float get_humidity() { return k_humidity; }

EXPORT float get_pressure() { return k_pressure; }

namespace logging = boost::log;

EXPORT bool can_start_rx() {
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
        return false;
    }

    CAN can(can_settings);

    try {
        can.init();
    } catch (const std::exception& e) {
        BOOST_LOG_TRIVIAL(error)
            << "Caught exception when init CAN: " << e.what();
        return false;
    }

    can.on_rx([&](const can_frame& frame) {
        const auto frame_str = CanUtils::can_frame_to_string(frame);

        BOOST_LOG_TRIVIAL(info) << "New CAN frame: " << frame_str;

        Measurement measurement_proto;
        if (!measurement_proto.ParseFromString(frame_str)) {
            BOOST_LOG_TRIVIAL(error) << "Failed data deserialization";
            return;
        }

        k_temperature = measurement_proto.temperature();
        k_humidity = measurement_proto.humidity();
        k_pressure = measurement_proto.pressure();
    });

    std::thread([&] {
        BOOST_LOG_TRIVIAL(info) << "Starting...";

        can.start_rx();
    }).detach();

    return true;
}
