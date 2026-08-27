// Shared launch helpers. Keep commands as strings so QML can pass them to
// Util.execDetached / bar.run / a Process — the same launch path Omarchy uses
// for desktop apps (uwsm-app scope so the editor is not a child of the shell).
.pragma library

function shellQuote(value) {
  return "'" + String(value).replace(/'/g, "'\\''") + "'"
}

// gtk-launch needs the .desktop suffix. Fall back to PATH if the desktop
// file is not installed yet (install-linux.sh / AUR put it in place).
function openAppCommand() {
  return "uwsm-app -- gtk-launch sparkdown.desktop || uwsm-app -- sparkdown || sparkdown"
}

function openFolderCommand(folder) {
  var path = shellQuote(folder)
  return "uwsm-app -- sparkdown " + path + " || sparkdown " + path
}

function pickFolderCommand() {
  return "zenity --file-selection --directory --title='Open folder in SparkDown' 2>/dev/null || kdialog --getexistingdirectory \"$HOME\" 2>/dev/null"
}
