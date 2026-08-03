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
    qml/pages/QuickScreenPage.qml
    qml/pages/AboutPage.qml
    qml/pages/AboutLicensesPage.qml

    qml/components/SetViewItems.qml
    qml/components/TablicaScreen.qml
    qml/components/CategoryPanel.qml
    qml/components/HymnPanel.qml
    qml/components/ScreenPanel.qml
    qml/components/SetPanel.qml
    qml/components/HymnPickerDialog.qml
    qml/components/SlimScreenPanel.qml
    qml/components/ScreenSwitcherDialog.qml
    qml/components/MenuTile.qml
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
    VERSION ${PROJECT_VERSION}

    QML_FILES
        ${APP_QML}

    SOURCES
        ${APP_SOURCES}
        ${APP_HEADERS}
)

target_include_directories(prezenter PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${CMAKE_CURRENT_SOURCE_DIR}/src/core/
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
    QT_ANDROID_APP_ICON "@mipmap/ic_launcher"
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
# Windows resources
# --------------------------------------

if(WIN32)

    target_sources(prezenter PRIVATE
        resources/windows/version.rc
    )

endif()

# --------------------------------------
# Application installation
# --------------------------------------

include(GNUInstallDirs)

install(TARGETS prezenter
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    COMPONENT prezenter
)

qt_generate_deploy_qml_app_script(
    TARGET prezenter
    OUTPUT_SCRIPT deploy_script
    NO_UNSUPPORTED_PLATFORM_ERROR
)

install(SCRIPT ${deploy_script}
    COMPONENT prezenter
)

# --------------------------------------
# CPack configuration
# --------------------------------------

if(NOT WIN32)
        set(CPACK_PACKAGE_NAME "${APP_PACKAGE_NAME}")
else()
        set(CPACK_PACKAGE_NAME "${APP_NAME}")
endif()
set(CPACK_PACKAGE_VENDOR "${APP_COMPANY}")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")

set(CPACK_PACKAGE_DESCRIPTION_SUMMARY
        "${APP_NAME} to otwartoźródłowa alternatywa dla oprogramowania obsługującego tablicę LED firmy MKEiA.")
set(CPACK_PACKAGE_HOMEPAGE_URL "https://zupanet.pl")
set(CPACK_PACKAGE_CONTACT "devel@zupanet.pl")
set(CPACK_PACKAGE_FILE_NAME "${APP_PACKAGE_NAME}-${PROJECT_VERSION}-${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_PROCESSOR}")
if(NOT WIN32)
        set(CPACK_PACKAGE_INSTALL_DIRECTORY "prezenter")
else()
        set(CPACK_PACKAGE_INSTALL_DIRECTORY "${APP_NAME}")
endif()
set(CPACK_PACKAGE_CHECKSUM SHA256)

set(CPACK_PACKAGE_EXECUTABLES "prezenter;${APP_NAME}")
set(CPACK_CREATE_DESKTOP_LINKS prezenter)
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_SOURCE_DIR}/LICENSE")

# IFW
# set(CPACK_IFW_PACKAGE_TITLE "${APP_NAME}")
# set(CPACK_IFW_PRODUCT_URL "${CPACK_PACKAGE_HOMEPAGE_URL}")
# set(CPACK_IFW_PACKAGE_WIZARD_STYLE "Classic")
# set(CPACK_IFW_ARCHIVE_COMPRESSION 9)
# set(CPACK_IFW_PACKAGE_START_MENU_DIRECTORY
#     "${APP_NAME}"
# )
# set(CPACK_IFW_PACKAGE_CONTROL_SCRIPT
#     "${CMAKE_SOURCE_DIR}/resources/windows/installer.qs"
# )

# InnoSetup
set(CPACK_INNOSETUP_ALLOW_CUSTOM_DIRECTORY ON)
set(CPACK_INNOSETUP_LANGUAGES "english;polish")
set(CPACK_INNOSETUP_IGNORE_README_PAGE ON)
set(CPACK_INNOSETUP_USE_MODERN_WIZARD ON)
set(CPACK_INNOSETUP_PROGRAM_MENU_FOLDER "${APP_NAME}")
set(CPACK_INNOSETUP_headers_INSTALL_DIRECTORY "")
set(CPACK_INNOSETUP_SETUP_DisableProgramGroupPage ON)
set(CPACK_INNOSETUP_SETUP_PrivilegesRequired "lowest")
set(CPACK_INNOSETUP_SETUP_PrivilegesRequiredOverridesAllowed "dialog")
set(CPACK_INNOSETUP_SETUP_AllowNoIcons ON)
set(CPACK_INNOSETUP_SETUP_UninstallDisplayIcon "{app}/prezenter.exe")
set(CPACK_INNOSETUP_SETUP_VersionInfoCompany "${APP_COMPANY}")
set(CPACK_INNOSETUP_SETUP_VersionInfoVersion "${PROJECT_VERSION}")
set(CPACK_INNOSETUP_SETUP_VersionInfoDescription "${APP_NAME}")
set(CPACK_INNOSETUP_SETUP_VersionInfoTextVersion "${PROJECT_VERSION}")
set(CPACK_INNOSETUP_SETUP_VersionInfoProductName "${APP_NAME}")
set(CPACK_INNOSETUP_SETUP_VersionInfoCopyright "Copyright (c) ${APP_COMPANY}")
set(CPACK_INNOSETUP_SETUP_AppPublisherURL "${CPACK_PACKAGE_HOMEPAGE}")
set(CPACK_INNOSETUP_SETUP_AppSupportURL "${CPACK_PACKAGE_HOMEPAGE}")
set(CPACK_INNOSETUP_SETUP_AppUpdatesURL "${CPACK_PACKAGE_HOMEPAGE}")


set(CPACK_GENERATOR "ZIP;INNOSETUP")
set(CPACK_STRIP_FILES TRUE)

include(CPack)
