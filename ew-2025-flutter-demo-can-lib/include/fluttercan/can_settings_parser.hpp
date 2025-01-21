#pragma once

#include "can_settings.hpp"

class CanSettingsParser {
   public:
    static CanSettings parseSettingsFile(const std::string &file);
};
