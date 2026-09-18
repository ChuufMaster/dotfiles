pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import Quickshell.Widgets
import Caelestia.Config
import qs.components
import qs.components.controls
import qs.services

Item {
    id: root

    readonly property bool hasMedia: Players.active !== null

    clip: true
    implicitWidth: hasMedia ? layout.implicitWidth + Tokens.padding.small * 2 : 0
    implicitHeight: layout.implicitHeight

    Behavior on implicitWidth {
        Anim {}
    }

    StyledClippingRect {
        anchors.fill: parent
        radius: Tokens.rounding.large

        Image {
            id: artBg

            anchors.centerIn: parent
            width: parent.width * 1.3
            height: parent.height * 1.3
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            visible: false
            source: root.hasMedia ? Players.getArtUrl(Players.active) : ""
        }

        MultiEffect {
            anchors.fill: artBg
            source: artBg
            blurEnabled: true
            blur: 1
            blurMax: 64
            saturation: 0.1
        }

        Rectangle {
            anchors.fill: parent
            color: Colours.palette.m3scrim
            opacity: 0.4
        }
    }

    RowLayout {
        id: layout

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: Tokens.padding.small
        spacing: Tokens.spacing.small

        ClippingRectangle {
            Layout.preferredWidth: 44
            Layout.preferredHeight: 44
            Layout.alignment: Qt.AlignVCenter
            radius: 22
            color: "transparent"

            Image {
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                source: root.hasMedia ? Players.getArtUrl(Players.active) : ""

                Anim on rotation {
                    running: true
                    paused: !(Players.active?.isPlaying ?? false)
                    from: 0
                    to: 360
                    duration: 20000
                    easing.type: Easing.Linear
                    loops: Animation.Infinite
                }
            }
        }

        IconButton {
            isRound: true
            font: Tokens.font.icon.small
            padding: Tokens.padding.extraSmall
            icon: Players.active?.isPlaying ? "pause" : "play_arrow"
            disabled: !Players.active?.canTogglePlaying
            onClicked: Players.active?.togglePlaying()
        }

        StyledSlider {
            id: seek

            Layout.preferredWidth: 140
            Layout.alignment: Qt.AlignVCenter
            value: root.hasMedia ? Players.active.position / (Players.active.length || 1) : 0
            enabled: Players.active?.canSeek ?? false
            interactionOnMove: false
            onInteraction: value => {
                const active = Players.active;
                if (active?.canSeek && active?.positionSupported)
                    active.position = value * active.length;
            }
        }

        IconButton {
            isRound: true
            font: Tokens.font.icon.small
            padding: Tokens.padding.extraSmall
            icon: "skip_next"
            disabled: !Players.active?.canGoNext
            onClicked: Players.active?.next()
            Layout.rightMargin: Tokens.padding.small
        }
    }
}
