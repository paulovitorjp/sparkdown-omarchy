# SparkDown for Omarchy

Omarchy shell plugin that **launches SparkDown** — it does not embed the editor
in Quickshell. Left-click the bar widget for Open / Open folder; right-click
opens the app immediately. The bar shows the SparkDown app icon (white lightning
bolt on black), same as the in-app toolbar — not `SD` text. The same two actions
are a summoned `menu`.

Plugin id: `paulovitorjp.sparkdown` (not `omarchy.*`).

## Install

The app and the plugin are separate. Install the Linux binary first (see
[SparkDown Linux / Omarchy notes](https://github.com/paulovitorjp/sparkdown/blob/main/docs/omarchy.md);
the app repo may still be private), then:

```sh
omarchy plugin add https://github.com/paulovitorjp/sparkdown-omarchy.git --enable
```

Place the widget if it did not land where you want it:

```sh
omarchy bar move paulovitorjp.sparkdown --section left
```

Summon the menu (same actions as the bar panel):

```sh
omarchy-shell shell summon paulovitorjp.sparkdown '{}'
omarchy-shell shell summon paulovitorjp.sparkdown '{"action":"open"}'
omarchy-shell shell summon paulovitorjp.sparkdown '{"folder":"/path/to/notes"}'
```

## Usage

- **Open SparkDown** — launches the desktop app (`uwsm-app` + `gtk-launch sparkdown.desktop`, falling back to `sparkdown` on PATH).
- **Open folder…** — zenity/kdialog directory picker, then `sparkdown /that/folder`. SparkDown treats a directory CLI argument as the workspace root.

## Remove

```sh
omarchy plugin remove paulovitorjp.sparkdown
```

## External dependencies

This plugin only launches SparkDown. It does not install the editor.

- SparkDown on PATH or as `sparkdown.desktop` (see the install script / AUR-ready PKGBUILD in the SparkDown repo)
- `uwsm-app` (Omarchy / UWSM)
- Optional: `zenity` or `kdialog` for the folder picker (without them, use the payload `{"folder":"..."}` or open a folder from inside SparkDown)

## License

MIT
