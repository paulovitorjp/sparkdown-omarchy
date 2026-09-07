import QtQuick
import QtQuick.Shapes
import qs.Commons

// Official SparkDown bolt silhouette (path1 from sparkdown-icon-source.svg /
// website/assets/logo.svg), filled with the bar foreground for Omarchy.
Item {
  id: root

  property real iconSize: Style.font.icon
  property color color: Color.foreground

  width: iconSize
  height: iconSize
  implicitWidth: iconSize
  implicitHeight: iconSize

  // Source art is 512×512; scale the vector into the bar slot.
  readonly property real artSize: 512

  Shape {
    id: shape
    width: root.artSize
    height: root.artSize
    antialiasing: true
    preferredRendererType: Shape.CurveRenderer
    transformOrigin: Item.TopLeft
    scale: root.iconSize / root.artSize

    ShapePath {
      fillColor: root.color
      strokeWidth: 0
      PathSvg {
        // Exact d= from sparkdown-icon-source.svg path#path1
        path: "M248.6 78.0 L350.6 78.0 Q358.6 78.0 354.6 84.9 L295.7 187.1 Q291.7 194.0 299.7 194.0 L375.7 194.0 Q383.7 194.0 379.7 200.9 L250.3 425.1 Q246.3 432.0 242.3 425.1 L176.4 310.9 Q172.4 304.0 180.4 304.0 L220.2 304.0 Q228.2 304.0 232.2 297.1 L240.3 282.9 Q244.3 276.0 236.3 276.0 L134.3 276.0 Q126.3 276.0 130.3 269.1 L236.6 84.9 Q240.6 78.0 248.6 78.0 Z"
      }
    }
  }
}
