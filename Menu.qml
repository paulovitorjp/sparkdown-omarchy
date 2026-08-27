import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import qs.Commons
import qs.Ui
import "Launch.js" as Launch

// Summoned menu surface (kind: menu). Same two actions as the bar panel.
// Payload shortcuts so a keybind can skip the UI:
//   omarchy-shell shell summon paulovitorjp.sparkdown '{"action":"open"}'
//   omarchy-shell shell summon paulovitorjp.sparkdown '{"folder":"/path"}'
Item {
  id: root

  property string omarchyPath: Quickshell.env("OMARCHY_PATH")
  property var shell: null
  property var manifest: null
  property bool opened: false

  function open(payloadJson) {
    var payload = ({})
    try { payload = JSON.parse(payloadJson || "{}") } catch (e) { payload = ({}) }

    if (payload.folder) {
      Util.execDetached(Launch.openFolderCommand(String(payload.folder)))
      root.opened = false
      return
    }
    if (payload.action === "open" || payload.action === "launch") {
      Util.execDetached(Launch.openAppCommand())
      root.opened = false
      return
    }
    if (payload.action === "folder") {
      root.launchFolderPicker()
      return
    }
    root.opened = true
    Qt.callLater(function() { keyCatcher.forceActiveFocus() })
  }

  function close() {
    root.opened = false
  }

  function launchApp() {
    Util.execDetached(Launch.openAppCommand())
    root.close()
  }

  function launchFolderPicker() {
    if (!picker.running) picker.running = true
  }

  Process {
    id: picker
    command: ["bash", "-lc", Launch.pickFolderCommand()]
    property string collected: ""
    stdout: SplitParser {
      onRead: function(data) { picker.collected += data + "\n" }
    }
    onRunningChanged: if (running) picker.collected = ""
    onExited: {
      var path = picker.collected.trim()
      if (path.length > 0) Util.execDetached(Launch.openFolderCommand(path))
      root.close()
    }
  }

  PanelWindow {
    id: panel
    visible: root.opened
    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    WlrLayershell.namespace: "paulovitorjp-sparkdown"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    exclusionMode: ExclusionMode.Ignore

    MouseArea {
      anchors.fill: parent
      onClicked: root.close()
    }

    Rectangle {
      id: card
      width: Style.space(280)
      height: content.implicitHeight + Style.space(32)
      radius: Style.cornerRadius
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.verticalCenter: parent.verticalCenter
      color: Color.menu ? Color.menu.background : "#1e1e1e"
      border.color: Color.menu ? Color.menu.border : "#444"
      border.width: 1

      MouseArea { anchors.fill: parent; onClicked: {} }

      Item {
        id: keyCatcher
        anchors.fill: parent
        focus: true
        Keys.onPressed: function(event) {
          if (event.key === Qt.Key_Escape) {
            root.close()
            event.accepted = true
          } else if (event.key === Qt.Key_1 || event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            root.launchApp()
            event.accepted = true
          } else if (event.key === Qt.Key_2) {
            root.launchFolderPicker()
            event.accepted = true
          }
        }

        Column {
          id: content
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.top: parent.top
          anchors.margins: Style.space(16)
          spacing: Style.space(10)

          Text {
            width: parent.width
            text: "SparkDown"
            color: Color.menu ? Color.menu.text : "#eee"
            font.pixelSize: Style.font.heading
            font.bold: true
          }

          Rectangle {
            width: parent.width
            height: Style.space(36)
            radius: Style.cornerRadius
            color: openHover.containsMouse ? (Color.menu ? Color.menu.selectedBackground : "#333") : "transparent"
            Text {
              anchors.verticalCenter: parent.verticalCenter
              anchors.left: parent.left
              anchors.leftMargin: Style.space(8)
              text: "Open SparkDown"
              color: Color.menu ? Color.menu.text : "#eee"
              font.pixelSize: Style.font.body
            }
            MouseArea {
              id: openHover
              anchors.fill: parent
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor
              onClicked: root.launchApp()
            }
          }

          Rectangle {
            width: parent.width
            height: Style.space(36)
            radius: Style.cornerRadius
            color: folderHover.containsMouse ? (Color.menu ? Color.menu.selectedBackground : "#333") : "transparent"
            Text {
              anchors.verticalCenter: parent.verticalCenter
              anchors.left: parent.left
              anchors.leftMargin: Style.space(8)
              text: "Open folder…"
              color: Color.menu ? Color.menu.text : "#eee"
              font.pixelSize: Style.font.body
            }
            MouseArea {
              id: folderHover
              anchors.fill: parent
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor
              onClicked: root.launchFolderPicker()
            }
          }
        }
      }
    }
  }
}
