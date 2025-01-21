#include "fluttercan/can_settings_parser.hpp"

#include <boost/program_options.hpp>
#include <filesystem>
#include <fstream>

CanSettings CanSettingsParser::parseSettingsFile(const std::string &file) {
    namespace po = boost::program_options;

    if (!std::filesystem::exists(file)) {
        throw std::invalid_argument("'" + file + "': File not found");
    }

    std::string ifname;
    uint32_t bitrate;
    uint32_t sample_point;
    uint32_t tq;
    uint32_t prop_seg;
    uint32_t phase_seg1;
    uint32_t phase_seg2;
    uint32_t sjw;
    uint32_t brp;

    po::options_description desc("Settings");

    desc.add_options()("can_ifname", po::value<std::string>(&ifname),
                       "can_ifname");

    desc.add_options()("can_bitrate", po::value<uint32_t>(&bitrate),
                       "can_bitrate");

    desc.add_options()("can_sample_point", po::value<uint32_t>(&sample_point),
                       "can_sample_point");

    desc.add_options()("can_tq", po::value<uint32_t>(&tq), "can_tq");

    desc.add_options()("can_prop_seg", po::value<uint32_t>(&prop_seg),
                       "can_prop_seg");

    desc.add_options()("can_phase_seg1", po::value<uint32_t>(&phase_seg1),
                       "can_phase_seg1");

    desc.add_options()("can_phase_seg2", po::value<uint32_t>(&phase_seg2),
                       "can_phase_seg2");

    desc.add_options()("can_sjw", po::value<uint32_t>(&sjw), "can_sjw");

    desc.add_options()("can_brp", po::value<uint32_t>(&brp), "can_brp");

    po::variables_map vm;

    std::ifstream fstream(file);

    vm = po::variables_map();

    po::store(po::parse_config_file(fstream, desc, true), vm);
    po::notify(vm);

    return CanSettings(ifname, {
                                   bitrate,
                                   sample_point,
                                   tq,
                                   prop_seg,
                                   phase_seg1,
                                   phase_seg2,
                                   sjw,
                                   brp,
                               });
}
