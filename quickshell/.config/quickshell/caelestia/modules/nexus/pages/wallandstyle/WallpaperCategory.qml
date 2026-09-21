pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Caelestia.Config
import Caelestia.Models
import qs.services
import qs.modules.nexus.common

PageBase {
    id: root

    title: {
        const c = nState.selectedWallpaperCategory;
        return c.slice(0, 1).toUpperCase() + c.slice(1);
    }
    isSubPage: true

    GridView {
        id: grid

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        height: root.flickable.height
        clip: true
        cacheBuffer: height

        readonly property int columns: Config.nexus.wallpapersPerRow
        readonly property real columnSpacing: Tokens.spacing.large
        readonly property real rowSpacing: Tokens.spacing.medium

        cellWidth: (width + columnSpacing) / columns
        cellHeight: metrics.implicitHeight + rowSpacing

        model: ScriptModel {
            values: Wallpapers.list.filter(w => Wallpapers.getCategoryFor(w) === root.nState.selectedWallpaperCategory).sort((a, b) => a.name.localeCompare(b.name))
        }

        delegate: Item {
            id: cell

            required property FileSystemEntry modelData

            width: grid.cellWidth - grid.columnSpacing
            height: grid.cellHeight - grid.rowSpacing

            WallItem {
                anchors.fill: parent
                source: String(cell.modelData?.path ?? "")
                text: cell.modelData?.name ?? ""
                onClicked: {
                    Wallpapers.setWallpaper(cell.modelData.path);
                    root.nState.closeSubPage();
                    root.nState.closeSubPage();
                }
            }
        }

        WallItem {
            id: metrics

            visible: false
            width: grid.cellWidth - grid.columnSpacing
            text: "Ag"
        }
    }
}
