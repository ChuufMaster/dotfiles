import QtQuick

QtObject {
    property string currentName
    property bool hasCurrent
    property var currentData

    signal detachRequested(mode: string)
}
