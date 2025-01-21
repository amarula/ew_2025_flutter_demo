include(GNUInstallDirs)

install(
  TARGETS ${PROJECT_NAME}
  EXPORT ${PROJECT_NAME}-config
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/include/${PROJECT_NAME}
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})

set(config_install_destination ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME})

install(
  EXPORT ${PROJECT_NAME}-config
  DESTINATION ${config_install_destination}
  NAMESPACE ${PROJECT_NAME}::)

include(CMakePackageConfigHelpers)
configure_package_config_file(
  ${CMAKE_CURRENT_LIST_DIR}/Config.cmake.in
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
  INSTALL_DESTINATION ${config_install_destination})

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME})

export(EXPORT ${PROJECT_NAME}-config
       FILE "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}-config.cmake")
