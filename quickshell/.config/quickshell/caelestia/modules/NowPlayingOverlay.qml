pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Caelestia.Config
import qs.components
import qs.components.containers
import qs.modules.dashboard.dash
import qs.modules.dashboard.media
import qs.services

Variants {
    model: Screens.screens

    StyledWindow {
        id: win

        required property ShellScreen modelData

        readonly property bool workspaceEmpty: (Hypr.monitorFor(modelData)?.activeWorkspace?.toplevels.values.length ?? 0) === 0

        screen: modelData
        name: "nowPlayingOverlay"
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Bottom
        color: "transparent"

        anchors.top: true
        anchors.bottom: true
        anchors.left: true
        anchors.right: true

        RowLayout {
            anchors.centerIn: parent
            spacing: Tokens.spacing.extraLargeIncreased
            visible: win.workspaceEmpty && Players.active !== null

            Item {
                Layout.preferredWidth: Tokens.sizes.dashboard.mediaWidth
                Layout.preferredHeight: 640

                Media {
                    anchors.fill: parent
                }
            }

            Item {
                Layout.preferredWidth: 500
                Layout.preferredHeight: 640

                LyricList {
                    anchors.fill: parent
                }
            }
        }
    }
}
