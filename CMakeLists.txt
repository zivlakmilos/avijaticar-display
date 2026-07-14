cmake_minimum_required(VERSION 3.16)

project(avijaticar VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(QT_QML_GENERATE_QMLLS_INI ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Multimedia)

if (ANDROID)
  find_package(Qt6 REQUIRED COMPONENTS WebView)
endif()

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(avijaticar
    main.cpp
)

set_target_properties(avijaticar PROPERTIES
   QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")

set(PROJECT_QML_FILES
    Main.qml
)

if (ANDROID)
    list(APPEND PROJECT_QML_FILES
        Radar.qml
    )
endif()

qt_add_qml_module(avijaticar
    URI avijaticarui
    QML_FILES
        Main.qml
        MetarTaf.qml
        MassBalance.qml
        FlightPlan.qml
        Radar.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(avijaticar PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.avijaticar
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(avijaticar
    PRIVATE Qt6::Quick Qt6::Multimedia
)

if (ANDROID)
    target_link_libraries(avijaticar
        PRIVATE Qt6::WebView
    )
endif()

install(TARGETS avijaticar
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
