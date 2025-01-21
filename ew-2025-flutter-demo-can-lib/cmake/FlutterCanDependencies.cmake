# pkg-config
find_package(PkgConfig REQUIRED)

# protobuff
find_package(Protobuf REQUIRED)

# jsoncpp
pkg_check_modules(JSONCPP REQUIRED IMPORTED_TARGET jsoncpp)

# boost
find_package(Boost REQUIRED COMPONENTS system log program_options)

# libsocketcan
pkg_check_modules(LIBSOCKETCAN REQUIRED libsocketcan)
