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

    function downloadArt(url: string): void {
        downloadProc.command = ["curl", "-sL", url, "-o", tmpPath];
        downloadProc.running = true;
    }

    function onArtChanged(): void {
        if (!enabled || !artUrl)
            return;

        // iTunes has much higher-res art than most players' own MPRIS thumbs
        // (Spotify's is often 300-640px). Try it first, fall back to trackArtUrl.
        const player = Players.active;
        const artist = player?.trackArtist ?? "";
        const title = player?.trackTitle ?? "";
        if (artist && title) {
            const term = encodeURIComponent(`${artist} ${title}`);
            lookupProc.command = ["curl", "-sL", `https://itunes.apple.com/search?term=${term}&media=music&limit=1`];
            lookupProc.running = true;
        } else {
            applyArtUrl();
        }
    }

    function applyArtUrl(): void {
        if (artUrl.startsWith("file://")) {
            applyWallpaper(artUrl.slice("file://".length));
        } else if (artUrl.startsWith("http://") || artUrl.startsWith("https://")) {
            downloadArt(artUrl);
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

    Process {
        id: lookupProc

        stdout: StdioCollector {
            id: lookupStdout
        }

        onExited: code => {
            let hiRes = "";
            if (code === 0) {
                try {
                    const result = JSON.parse(lookupStdout.text).results?.[0];
                    if (result?.artworkUrl100)
                        hiRes = result.artworkUrl100.replace("100x100bb", "3000x3000bb");
                } catch (e) {
                    // fall through to trackArtUrl below
                }
            }

            if (hiRes)
                root.downloadArt(hiRes);
            else
                root.applyArtUrl();
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
