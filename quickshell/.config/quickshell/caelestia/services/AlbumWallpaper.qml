pragma Singleton

import Quickshell
import Quickshell.Io
import qs.services

Singleton {
    id: root

    property alias enabled: props.enabled

    readonly property string artUrl: Players.getArtUrl(Players.active)
    readonly property string tmpPath: "/tmp/caelestia-now-playing-art.jpg"

    // Same script the manual wallpaper-picker keybind uses (~/scripts/setwallpaper.sh),
    // so this stays in sync with the swww set + full pywal recolour cascade instead of
    // reimplementing any of that here.
    function applyWallpaper(path: string): void {
        Quickshell.execDetached(["bash", "-lc", `~/scripts/setwallpaper.sh '${path}'`]);
    }

    function onArtChanged(): void {
        if (!enabled || !artUrl)
            return;

        if (artUrl.startsWith("file://")) {
            applyWallpaper(artUrl.slice("file://".length));
        } else if (artUrl.startsWith("http://") || artUrl.startsWith("https://")) {
            downloadProc.command = ["curl", "-sL", artUrl, "-o", tmpPath];
            downloadProc.running = true;
        }
    }

    onArtUrlChanged: onArtChanged()
    onEnabledChanged: {
        if (enabled) {
            // Don't clobber the saved wallpaper if re-enabling without ever
            // having changed it manually in between
            if (Wallpapers.actualCurrent !== tmpPath)
                props.previousWallpaper = Wallpapers.actualCurrent;
            onArtChanged();
        } else if (props.previousWallpaper) {
            applyWallpaper(props.previousWallpaper);
        }
    }

    PersistentProperties {
        id: props

        property bool enabled: false
        property string previousWallpaper: ""

        reloadableId: "albumWallpaper"
    }

    Process {
        id: downloadProc

        onExited: code => {
            if (code === 0)
                root.applyWallpaper(root.tmpPath);
        }
    }

    IpcHandler {
        function isEnabled(): bool {
            return props.enabled;
        }

        function toggle(): void {
            props.enabled = !props.enabled;
        }

        function enable(): void {
            props.enabled = true;
        }

        function disable(): void {
            props.enabled = false;
        }

        target: "albumWallpaper"
    }
}
