import QtQuick
import QtQuick.Shapes
import qs.Commons

// Monochrome SparkDown bolt for the Omarchy bar — filled with the bar
// foreground so it matches other icon widgets (Dropbox/Tailscale pattern).
Item {
  id: root

  property real iconSize: Style.font.icon
  property color color: Color.foreground

  width: iconSize
  height: iconSize
  implicitWidth: iconSize
  implicitHeight: iconSize

  // Official bolt silhouette from the SparkDown mark, normalized into the slot.
  readonly property real pad: iconSize * 0.08
  readonly property real bx: pad
  readonly property real by: pad
  readonly property real bw: iconSize - pad * 2
  readonly property real bh: iconSize - pad * 2
  // Source path bbox: x 3..17, y 2..22
  function px(x) { return bx + ((x - 3) / 14) * bw }
  function py(y) { return by + ((y - 2) / 20) * bh }

  Shape {
    anchors.fill: parent
    antialiasing: true
    preferredRendererType: Shape.CurveRenderer

    ShapePath {
      fillColor: root.color
      strokeWidth: 0
      startX: root.px(13)
      startY: root.py(2)
      PathLine { x: root.px(3);  y: root.py(14) }
      PathLine { x: root.px(10); y: root.py(14) }
      PathLine { x: root.px(7);  y: root.py(22) }
      PathLine { x: root.px(17); y: root.py(10) }
      PathLine { x: root.px(10); y: root.py(10) }
      PathLine { x: root.px(13); y: root.py(2) }
    }
  }
}
