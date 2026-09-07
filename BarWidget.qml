import QtQuick
import Quickshell
import qs.Commons
import qs.Ui

// Bar button for SparkDown. Left click toggles the Open / Open folder panel
// (documented bar-widget + nested Panel pattern). Right click launches the
// app immediately. moduleName must match manifest.json id.
BarWidget {
  id: root
  moduleName: "paulovitorjp.sparkdown"

  readonly property bool opened: panelLoader.item
    ? panelLoader.item.opened === true
    : false
  readonly property bool popoutSwitchClosing: panelLoader.item
    ? panelLoader.item.popoutSwitchClosing === true
    : false

  function open() {
    if (panelLoader.item) panelLoader.item.open()
  }

  function close() {
    if (panelLoader.item) panelLoader.item.close()
  }

  function toggle() {
    if (panelLoader.item) panelLoader.item.toggle()
  }

  function closeForPopoutSwitch() {
    if (panelLoader.item) panelLoader.item.closeForPopoutSwitch()
  }

  function injectPanel() {
    if (!panelLoader.item) return
    panelLoader.item.bar = root.bar
    panelLoader.item.anchorItem = button
    panelLoader.item.hostWidget = root
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  onBarChanged: injectPanel()

  Loader {
    id: panelLoader
    active: true
    source: Qt.resolvedUrl("Panel.qml")
    visible: false
    onLoaded: {
      root.injectPanel()
      Qt.callLater(root.injectPanel)
    }
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    tooltipText: "SparkDown"
    slotSize: Style.bar.statusSlot
    iconComponent: Component {
      Item {
        SparkDownBolt {
          anchors.centerIn: parent
          iconSize: Style.space(12)
          color: button.foreground
        }
      }
    }
    onPressed: function(buttonCode) {
      if (!root.bar) return
      if (buttonCode === Qt.LeftButton) {
        root.toggle()
      } else if (buttonCode === Qt.RightButton) {
        if (panelLoader.item) panelLoader.item.launchApp()
      }
    }
  }
}
