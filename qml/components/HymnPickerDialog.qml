import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Prezenter

Dialog {
    id: root

    property var existingModel: null

    title: qsTr("Wybierz pieśń")

    modal: true

    width: Math.min(
        parent.width * 0.85,
        850
    )

    height: Math.min(
        parent.height * 0.75,
        650
    )

    padding: 16

    parent: Overlay.overlay
	anchors.centerIn: Overlay.overlay
    dim: true

    standardButtons: Dialog.Cancel

    signal selected(int hymnId)

    CategoryModel {
        id: categoryModel

        Component.onCompleted:
            reload()
    }

    CategoryHymnModel {
        id: hymnModel
    }

    property int selectedCategoryId: -2
    property string categorySearchText: ""
    property string hymnSearchText: ""


    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            spacing: 12


            ColumnLayout {
                Layout.minimumWidth: 250
                Layout.preferredWidth: 250
                Layout.maximumWidth: 250
                Layout.fillHeight: true

                Label {
                    text: qsTr("Kategorie")

                    font.pixelSize: 18
                    font.bold: true
                }

                TextField {
                    Layout.fillWidth: true

                    placeholderText: qsTr("Szukaj kategorii...")

                    onTextChanged: {
                        root.categorySearchText = text
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    color: "transparent"

                    border.color: "#cccccc"
                    border.width: 1

                    radius: 6

                    ListView {
                        anchors.fill: parent
                        anchors.margins: 6

                        model: categoryModel

                        clip: true

                        spacing: 0

                        delegate: Item {
                            width: ListView.view.width

                            property bool filteredOut: {
                                let filter = root.categorySearchText.trim().toLowerCase()
                                let text = model.name.toLowerCase()
                                let ok = text.indexOf(filter) !== -1

                                if (filter === "")
                                    return false

                                return !ok
                            }


                            height: filteredOut ? 0 : 49
                            visible: !filteredOut

                            Behavior on height {
                                NumberAnimation {
                                    duration: 150
                                }
                            }

                            Rectangle {
                                width: parent.width
                                height: 45

                                radius: 6

                                color:
                                    model.id === root.selectedCategoryId
                                    ? "#d7ecff"
                                    : "#f4f4f4"

                                border.color: "#dddddd"

                                Label {
                                    anchors.fill: parent
                                    anchors.leftMargin: 12

                                    verticalAlignment: Text.AlignVCenter

                                    text: model.name
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        root.selectedCategoryId = model.id

                                        hymnModel.parentId = model.id
                                        hymnModel.reload()
                                    }
                                }
                            }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Label {

                    text: qsTr("Pieśni")

                    font.pixelSize: 18
                    font.bold: true
                }

                TextField {
                    Layout.fillWidth: true

                    placeholderText: qsTr("Szukaj pieśni...")

                    onTextChanged: {
                        root.hymnSearchText = text
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    color: "transparent"

                    border.color: "#cccccc"
                    border.width: 1

                    radius: 6

                    ListView {
                        anchors.fill: parent
                        anchors.margins: 6

                        model: hymnModel

                        clip: true

                        spacing: 0

                        delegate: Item {
                            width: ListView.view.width

                            property bool isExisting: {

                                if (!root.existingModel)
                                    return false


                                for (let i = 0;
                                     i < root.existingModel.rowCount();
                                     i++)
                                {
                                    if (root.existingModel.get(i).hymnId === model.id)
                                        return true
                                }


                                return false
                            }

                            property bool filteredOut: {

                                if (root.hymnSearchText.length === 0)
                                    return false


                                return !model.name
                                    .toLowerCase()
                                    .includes(root.hymnSearchText.toLowerCase())
                            }

                            property bool hidden: isExisting || filteredOut

                            height: hidden ? 0 : 49
                            visible: !hidden

                            Behavior on height {
                                NumberAnimation {
                                    duration: 150
                                }
                            }

                            Rectangle {
                                width: parent.width
                                height: 45

                                radius: 6

                                color: "#f4f4f4"

                                border.color: "#dddddd"

                                Label {
                                    anchors.fill: parent
                                    anchors.leftMargin: 12

                                    verticalAlignment: Text.AlignVCenter

                                    text: model.name
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {

                                        root.selected(model.id)

                                        root.close()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}