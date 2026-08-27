import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui
import "Launch.js" as Launch

Panel {
  id: root
  moduleName: "paulovitorjp.sparkdown"
  manageIpc: false

  property var anchorItem: null
  property var hostWidget: null

  function open() {
    root.controller.show()
  }

  function close() {
    root.controller.hide()
  }

  function launchApp() {
    Util.execDetached(Launch.openAppCommand())
    root.close()
  }

  function launchFolderPicker() {
    if (!picker.running) picker.running = true
  }

  function switchPanel(direction) {
    if (root.bar && typeof root.bar.switchPanelFrom === "function")
      return root.bar.switchPanelFrom(root.hostWidget || root, direction)
    return false
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

  KeyboardPanel {
    id: panel
    anchorItem: root.anchorItem
    owner: root.hostWidget || root
    bar: root.bar
    open: root.opened
    focusTarget: keyCatcher
    contentWidth: panel.fittedContentWidth(Style.space(240))
    contentHeight: panel.fittedContentHeight(content.implicitHeight)

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      onCloseRequested: root.close()
      onTabRequested: function(direction) { root.switchPanel(direction) }

      Column {
        id: content
        width: parent.width
        spacing: Style.space(8)

        Text {
          width: parent.width
          text: "SparkDown"
          color: root.barForeground
          font.family: root.bar ? root.bar.fontFamily : Style.font.family
          font.pixelSize: Style.font.subtitle
          font.bold: true
        }

        WidgetButton {
          bar: root.bar
          text: "Open SparkDown"
          onPressed: root.launchApp()
        }

        WidgetButton {
          bar: root.bar
          text: "Open folder…"
          onPressed: root.launchFolderPicker()
        }
      }
    }
  }
}
