pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Hyprland
import Caelestia
import Caelestia.Components
import Caelestia.Config
import qs.components
import qs.services

StyledClippingRect {
    id: root

    required property ShellScreen screen
    required property bool fullscreen

    readonly property HyprlandMonitor monitor: Hypr.monitorFor(screen)
    readonly property bool onSpecial: monitor?.lastIpcObject.specialWorkspace?.name !== ""
    readonly property int activeWsId: monitor.activeWorkspace?.id ?? 1
    readonly property int shown: Math.max(1, Config.bar.workspaces.shown)

    // Per-monitor workspace ranges, matching the static assignment in
    // hypr/conf/workspace.lua and waybar's persistent-workspaces config
    readonly property var monitorWsRanges: ({
            "DP-1": [1, 5],
            "DP-2": [6, 8],
            "DP-3": [9, 11]
        })
    readonly property var ownWsRange: monitorWsRanges[monitor.name] ?? [1, shown]

    readonly property var wsIds: {
        if (Config.bar.workspaces.showUnoccupied) {
            const [start, end] = ownWsRange;
            return Array.from({
                length: end - start + 1
            }, (_, i) => start + i);
        }

        const ignoredTags = GlobalConfig.bar.workspaces.ignoredTags;
        const workspaces = Hypr.workspaces.values.filter(w => w.id > 0 && w.monitor === root.monitor && (w.id === activeWsId || w.toplevels.values.some(t => !Hypr.isToplevelIgnored(t, ignoredTags))));
        const currentIdx = workspaces.findIndex(w => w.id === activeWsId);
        if (currentIdx < 0)
            return [];

        const end = CUtils.clamp(currentIdx + 1, Math.min(shown, workspaces.length), workspaces.length);
        const start = Math.max(0, end - shown);

        return workspaces.slice(start, end).map(w => w.id);
    }

    property real blur: onSpecial ? 1 : 0

    implicitHeight: Tokens.sizes.bar.innerWidth
    implicitWidth: workspaces.implicitWidth + workspaces.anchors.margins * 2

    color: Colours.tPalette.m3surfaceContainer
    radius: Tokens.rounding.full

    Item {
        anchors.fill: parent
        scale: root.onSpecial ? 0.8 : 1
        opacity: root.onSpecial ? 0.5 : 1
        visible: !root.fullscreen

        layer.enabled: root.blur > 0
        layer.effect: MultiEffect {
            blurEnabled: true
            blur: root.blur
            blurMax: 32
        }

        Row {
            id: workspaces

            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.margins: Tokens.padding.extraSmall

            spacing: Tokens.spacing.extraSmall

            add: Transition {
                Anim {
                    property: "opacity"
                    from: 0
                    to: 1
                }
            }

            Repeater {
                model: ScriptModel {
                    values: root.wsIds
                }

                delegate: Workspace {
                    activeWsId: root.activeWsId
                    ws: modelData

                    displayType: Config.bar.workspaces.displayType
                    showWindows: Config.bar.workspaces.showWindows
                    iconRules: GlobalConfig.bar.workspaces.workspaceIcons
                    activeLabel: Config.bar.workspaces.activeLabel
                    occupiedLabel: Config.bar.workspaces.occupiedLabel
                    label: Config.bar.workspaces.label
                }
            }
        }

        MouseArea {
            anchors.fill: workspaces
            onClicked: event => {
                const ws = (workspaces.childAt(event.x, event.y) as Workspace)?.ws;
                if (!ws)
                    return;
                if (Hypr.activeWsId !== ws)
                    Hypr.focusWorkspace(ws);
                else
                    Hypr.toggleSpecial("special");
            }
        }

        Behavior on scale {
            Anim {}
        }

        Behavior on opacity {
            Anim {
                type: Anim.DefaultEffects
            }
        }
    }

    Loader {
        id: specialWs

        anchors.fill: parent

        asynchronous: true
        active: opacity > 0
        opacity: root.onSpecial ? 1 : 0

        sourceComponent: Item {
            StyledRect {
                anchors.fill: parent
                radius: Tokens.rounding.full
                color: Qt.alpha(Colours.palette.m3scrim, Colours.light ? 0 : 0.2)
            }

            SpecialWorkspaces {
                anchors.fill: parent
                anchors.margins: Tokens.padding.extraSmall
                screen: root.screen

                scale: 0.5
                Component.onCompleted: scale = Qt.binding(() => root.onSpecial ? 1 : 0.5)

                Behavior on scale {
                    Anim {}
                }
            }
        }

        Behavior on opacity {
            Anim {
                type: Anim.DefaultEffects
            }
        }
    }

    Behavior on blur {
        Anim {
            type: Anim.StandardSmall
        }
    }

    Behavior on implicitHeight {
        Anim {}
    }
}
