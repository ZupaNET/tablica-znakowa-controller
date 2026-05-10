cmake_minimum_required(VERSION 3.16)

project(TablicaZnakowa VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Core Gui Qml QuickControls2 Sql)

qt_standard_project_setup(REQUIRES 6.10)

qt_add_executable(appTablicaZnakowa
    main.cpp
)

set_source_files_properties(navigation/Navigation.qml
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(appTablicaZnakowa
    URI TablicaZnakowa
    QML_FILES
        Main.qml
        SOURCES connectors/tablicaconnector.h connectors/tablicaconnector.cpp
        QML_FILES ui/PresenterMode.qml
        SOURCES ui/PresenterMode.cpp
        RESOURCES ui/resources/fonts/MiniForma2.ttf
        SOURCES connectors/databaseconnector.h connectors/databaseconnector.cpp
        SOURCES models/dto.h
        SOURCES repositories/hymnrepository.h repositories/hymnrepository.cpp
        SOURCES repositories/screenrepository.h repositories/screenrepository.cpp
        SOURCES repositories/setrepository.h repositories/setrepository.cpp
        SOURCES repositories/categoryrepository.h repositories/categoryrepository.cpp
        SOURCES models/baselistmodel.h models/baselistmodel.cpp
        SOURCES models/hymnlistmodel.h models/hymnlistmodel.cpp
        SOURCES models/screenlistmodel.h models/screenlistmodel.cpp
        SOURCES models/sethymnlistmodel.h models/sethymnlistmodel.cpp
        RESOURCES ui/resources/fonts/ARIAL.TTF
        RESOURCES ui/resources/fonts/ARIALBD.TTF
        QML_FILES ui/SetViewItems.qml
        QML_FILES ui/SetsManager.qml
        QML_FILES ui/TablicaScreen.qml
        QML_FILES navigation/Navigation.qml
        SOURCES settings/appsettings.h settings/appsettings.cpp
        RESOURCES tablica.db
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appTablicaZnakowa PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appTablicaZnakowa
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android"

    QT_ANDROID_APP_NAME "Tablica Znakowa"
)

target_link_libraries(appTablicaZnakowa
    PRIVATE
    Qt6::Quick
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::QuickControls2
    Qt6::Sql
)

install(TARGETS appTablicaZnakowa
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
