#pragma once

#ifdef WIN32
#define EXPORT __declspec(dllexport)
#else
#define EXPORT \
    extern "C" __attribute__((visibility("default"))) __attribute__((used))
#endif