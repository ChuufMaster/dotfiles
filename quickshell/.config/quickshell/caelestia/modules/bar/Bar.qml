pragma ComponentBehavior: Bound

import "popouts" as BarPopouts
import "components"
import "components/workspaces"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Caelestia
import Caelestia.Blobs
import Caelestia.Config
import qs.components
import qs.services

Item {
    id: root

    required property ShellScreen screen
    required property ScreenState screenState
    required property BarPopouts.Wrapper popouts
    required property bool fullscreen
    required property BlobGroup blobGroup
    readonly property int hPadding: Tokens.padding.small

    readonly property var enabledEntries: Config.bar.entries.values.filter(e => e.enabled)

    // Groups of entry indices between "spacer" entries, each rendered as its own
    // flat-top/round-bottom island background
    readonly property var islandRanges: {
        const roles = root.enabledEntries.map(e => e.id);
        const ranges = [];
        let start = -1;
        for (let i = 0; i < roles.length; i++) {
            if (roles[i] === "spacer") {
                if (start >= 0)
                    ranges.push([start, i - 1]);
                start = -1;
            } else if (start < 0) {
                start = i;
            }
        }
        if (start >= 0)
            ranges.push([start, roles.length - 1]);
        return ranges;
    }

    function isIslandStart(index: int): bool {
        return root.islandRanges.some(r => r[0] === index);
    }

    function isIslandEnd(index: int): bool {
        return root.islandRanges.some(r => r[1] === index);
    }

    function closeTray(): void {
        if (!Config.bar.tray.compact)
            return;

        for (let i = 0; i < repeater.count; i++) {
            const tray = (repeater.itemAt(i) as EntryWrapper)?.item as Tray;
            if (tray)
                tray.expanded = false;
        }
    }

    function checkPopout(pos: real): void {
        const ch = row.childAt(pos, row.height / 2) as EntryWrapper;

        if (ch?.entryId !== "tray")
            closeTray();

        if (!ch) {
            popouts.hasCurrent = false;
            return;
        }

        const id = ch.entryId;
        const left = ch.x;

        if (id === "statusIcons" && Config.bar.popouts.statusIcons) {
            const items = (ch.item as StatusIcons).items;
            const icon = items.childAt(row.mapToItem(items, pos, 0).x, items.height / 2);
            if (icon) {
                popouts.currentName = icon.name;
                popouts.currentCenter = Qt.binding(() => icon.mapToItem(root, icon.implicitWidth / 2, 0).x);
                popouts.hasCurrent = true;
            }
        } else if (id === "tray" && Config.bar.popouts.tray) {
            const tray = ch.item as Tray;
            if (!Config.bar.tray.compact || (tray.expanded && !tray.expandIcon.contains(row.mapToItem(tray.expandIcon, pos, tray.implicitHeight / 2)))) {
                const index = Math.floor(((pos - left - tray.padding * 2 + tray.spacing) / tray.layout.implicitWidth) * tray.items.count);
                const trayItem = tray.items.itemAt(index);
                if (trayItem) {
                    popouts.currentName = `traymenu${index}`;
                    popouts.currentCenter = Qt.binding(() => trayItem.mapToItem(root, trayItem.implicitWidth / 2, 0).x);
                    popouts.hasCurrent = true;
                } else {
                    popouts.hasCurrent = false;
                }
            } else {
                popouts.hasCurrent = false;
                tray.expanded = true;
            }
        } else if (id === "activeWindow" && Config.bar.popouts.activeWindow && Config.bar.activeWindow.showOnHover) {
            popouts.currentName = id.toLowerCase();
            popouts.currentCenter = (ch.item as Item).mapToItem(root, (ch.item as Item).implicitWidth / 2, 0).x ?? 0;
            popouts.hasCurrent = true;
        }
    }

    function handleWheel(pos: real, angleDelta: point): void {
        const ch = row.childAt(pos, row.height / 2) as EntryWrapper;
        if (ch?.entryId === "workspaces" && Config.bar.scrollActions.workspaces) {
            // Workspace scroll
            const mon = Hypr.monitorFor(screen);
            const specialWs = mon?.lastIpcObject.specialWorkspace.name;
            if (specialWs?.length > 0)
                Hypr.dispatch(Hypr.usingLua ? `hl.dsp.workspace.toggle_special("${specialWs.slice(8)}")` : `togglespecialworkspace ${specialWs.slice(8)}`);
            else if (angleDelta.y < 0 || mon.activeWorkspace?.id > 1)
                Hypr.dispatch(Hypr.usingLua ? `hl.dsp.focus({ workspace = "r${angleDelta.y > 0 ? "-" : "+"}1" })` : `workspace r${angleDelta.y > 0 ? "-" : "+"}1`);
        } else if (pos < screen.width / 2 && Config.bar.scrollActions.volume) {
            // Volume scroll on left half
            if (angleDelta.y > 0)
                Audio.incrementVolume();
            else if (angleDelta.y < 0)
                Audio.decrementVolume();
        } else if (Config.bar.scrollActions.brightness) {
            // Brightness scroll on right half
            const monitor = Brightness.getMonitorForScreen(screen);
            if (angleDelta.y > 0)
                monitor.setBrightness(monitor.brightness + GlobalConfig.services.brightnessIncrement);
            else if (angleDelta.y < 0)
                monitor.setBrightness(monitor.brightness - GlobalConfig.services.brightnessIncrement);
        }
    }

    Repeater {
        id: islandRepeater

        model: root.islandRanges

        BlobRect {
            id: island

            required property var modelData
            required property int index

            readonly property Item startItem: repeater.itemAt(modelData[0])
            readonly property Item endItem: repeater.itemAt(modelData[1])
            readonly property bool isFirst: index === 0
            readonly property bool isLast: index === islandRepeater.count - 1

            // Registered in the same BlobGroup as the screen border and every
            // other drawer panel, so it merges/smooths into the border the same
            // way they do instead of being a disconnected flat shape
            group: root.blobGroup
            deformScale: 0

            x: isFirst ? Config.border.thickness : (startItem?.x ?? 0)
            y: 0
            width: (isLast ? root.width - Config.border.thickness : ((endItem?.x ?? 0) + (endItem?.width ?? 0) + root.hPadding)) - x
            height: row.height
            radius: Tokens.rounding.large
        }
    }

    RowLayout {
        id: row

        property alias hPadding: root.hPadding
        property alias popouts: root.popouts

        anchors.fill: parent
        spacing: Tokens.spacing.small

        Repeater {
            id: repeater

            model: ScriptModel {
                values: root.enabledEntries
            }

            DelegateChooser {
                role: "id"

                DelegateChoice {
                    roleValue: "spacer"
                    delegate: EntryWrapper {
                        Layout.fillWidth: true
                    }
                }
                DelegateChoice {
                    roleValue: "logo"
                    delegate: EntryWrapper {
                        OsIcon {
                            objectName: "taskbarLogo"
                        }
                    }
                }
                DelegateChoice {
                    roleValue: "workspaces"
                    delegate: EntryWrapper {
                        Workspaces {
                            objectName: "taskbarWorkspaces"
                            screen: root.screen
                            fullscreen: root.fullscreen
                            popouts: root.popouts
                            barRoot: root
                        }
                    }
                }
                DelegateChoice {
                    roleValue: "activeWindow"
                    delegate: EntryWrapper {
                        ActiveWindow {
                            objectName: "taskbarActiveWindow"
                            bar: row
                            monitor: Brightness.getMonitorForScreen(root.screen)
                        }
                    }
                }
                DelegateChoice {
                    roleValue: "tray"
                    delegate: EntryWrapper {
                        Tray {
                            objectName: "taskbarTray"
                        }
                    }
                }
                DelegateChoice {
                    roleValue: "clock"
                    delegate: EntryWrapper {
                        Clock {
                            objectName: "taskbarClock"
                        }
                    }
                }
                DelegateChoice {
                    roleValue: "statusIcons"
                    delegate: EntryWrapper {
                        StatusIcons {
                            objectName: "taskbarStatusIcons"
                        }
                    }
                }
                DelegateChoice {
                    roleValue: "power"
                    delegate: EntryWrapper {
                        Power {
                            objectName: "taskbarPowerButton"
                            screenState: root.screenState
                        }
                    }
                }
            }
        }
    }

    component EntryWrapper: Item {
        required property var modelData
        required property int index
        default property Item item
        readonly property string entryId: modelData.id

        Layout.leftMargin: root.isIslandStart(index) ? root.hPadding : 0
        Layout.rightMargin: root.isIslandEnd(index) ? root.hPadding : 0
        Layout.alignment: Qt.AlignVCenter

        implicitWidth: item?.implicitWidth ?? 0
        implicitHeight: item?.implicitHeight ?? 0

        children: item
    }
}
