cmake_minimum_required(VERSION 3.16)

# --------------------------------------
# Version
# --------------------------------------

include(cmake/version.cmake)

# --------------------------------------
# Project settings
# --------------------------------------

project(TablicaPrezenter VERSION ${APP_VERSION_STRING} LANGUAGES CXX)

set(CMAKE_AUTORCC ON)
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

# --------------------------------------
# Application information
# --------------------------------------

set(APP_NAME "Tablica Znakowa")
set(APP_COMPANY "ŻupaNET Development")
set(APP_COMPANY_DOMAIN "zupanet.ddns.net")
string(TOLOWER "${APP_NAME}" APP_PACKAGE_NAME)
string(REGEX REPLACE "[^a-z0-9]+" "-" APP_PACKAGE_NAME "${APP_PACKAGE_NAME}")
string(REGEX REPLACE "^-|-$" "" APP_PACKAGE_NAME "${APP_PACKAGE_NAME}")

# --------------------------------------
# Qt packages and project configuration
# --------------------------------------

find_package(Qt6 REQUIRED COMPONENTS Quick Core Gui Qml QuickControls2 Sql)
qt_standard_project_setup(REQUIRES 6.10)

# --------------------------------------
# Application source files
# --------------------------------------

file(GLOB_RECURSE APP_SOURCES CONFIGURE_DEPENDS
    src/*.cpp
)

file(GLOB_RECURSE APP_HEADERS CONFIGURE_DEPENDS
    src/*.h
)

set(APP_QML_SINGLETONS
    qml/navigation/Navigation.qml
)

set(APP_QML
    qml/Main.qml
    qml/Icon.js

    ${APP_QML_SINGLETONS}

    qml/pages/MenuPage.qml
    qml/pages/SettingsPage.qml
    qml/pages/SetListPage.qml
    qml/pages/PresentationPage.qml
    qml/pages/HymnListPage.qml
    qml/pages/ScreenEditorPage.qml

    qml/components/SetViewItems.qml
    qml/components/TablicaScreen.qml
    qml/components/CategoryPanel.qml
    qml/components/HymnPanel.qml
    qml/components/ScreenPanel.qml
)

set(APP_RESOURCES
    resources/resources.qrc
)

# --------------------------------------
# Application executable definition
# --------------------------------------

qt_add_executable(prezenter
    src/main.cpp
    ${APP_RESOURCES}
)

set_source_files_properties(
    ${APP_QML_SINGLETONS}
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE
)

qt_add_qml_module(prezenter
    URI Prezenter

    QML_FILES
        ${APP_QML}

    SOURCES
        ${APP_SOURCES}
        ${APP_HEADERS}
)

target_include_directories(prezenter PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_SOURCE_DIR}/src/core/utils
    ${CMAKE_CURRENT_SOURCE_DIR}/src/database
    ${CMAKE_CURRENT_SOURCE_DIR}/src/models
    ${CMAKE_CURRENT_SOURCE_DIR}/src/networking
    ${CMAKE_CURRENT_SOURCE_DIR}/src/settings
)

# --------------------------------------
# Application compile definitions
# --------------------------------------

target_compile_definitions(prezenter PRIVATE
    APP_NAME="${APP_NAME}"
    APP_COMPANY="${APP_COMPANY}"
    APP_COMPANY_DOMAIN="${APP_COMPANY_DOMAIN}"
    APP_VERSION_STRING="${APP_VERSION_STRING}"
    APP_VERSION_MAJOR=${APP_VERSION_MAJOR}
    APP_VERSION_MINOR=${APP_VERSION_MINOR}
    APP_VERSION_PATCH=${APP_VERSION_PATCH}
)

# --------------------------------------
# Application target definitions
# --------------------------------------

set_target_properties(prezenter PROPERTIES
    WIN32_EXECUTABLE TRUE

    QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_SOURCE_DIR}/android"
    QT_ANDROID_APP_NAME "${APP_NAME}"
)

# --------------------------------------
# Application libraries
# --------------------------------------

target_link_libraries(prezenter
    PRIVATE
    Qt6::Quick
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::QuickControls2
    Qt6::Sql
)

# --------------------------------------
# Application installation
# --------------------------------------

install(TARGETS prezenter
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
