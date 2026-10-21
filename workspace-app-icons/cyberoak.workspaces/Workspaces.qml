import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "omarchy.workspaces"

  function workspaceById(id) {
    var values = Hyprland.workspaces.values
    for (var i = 0; i < values.length; i++) {
      if (values[i].id === id) return values[i]
    }

    return null
  }

  function workspaceIds() {
    var ids = [1, 2, 3, 4, 5]
    var values = Hyprland.workspaces.values

    for (var i = 0; i < values.length; i++) {
      var id = values[i].id
      if (id > 0 && id <= 10 && ids.indexOf(id) === -1) ids.push(id)
    }

    ids.sort(function(left, right) { return left - right })
    return ids
  }

  function focusWorkspace(id) {
    if (!root.bar) return
    root.bar.run("hyprctl dispatch " + Util.shellQuote("hl.dsp.focus({ workspace = \"" + id + "\" })"))
  }

  // Window class/app id for a Hyprland toplevel.
  function appIdOf(toplevel) {
    if (toplevel.wayland && toplevel.wayland.appId) return String(toplevel.wayland.appId)
    var ipc = toplevel.lastIpcObject
    return ipc && ipc.class ? String(ipc.class) : ""
  }

  // Icon for a window: desktop entry icon, with fallbacks for Chromium/Brave
  // web apps (class "brave-<host>__...") and reverse-DNS desktop ids
  // (class "BambuStudio" -> com.bambulab.BambuStudio).
  function iconFor(appId) {
    var entries = DesktopEntries.applications.values || []
    var icon = ""
    var web = appId.match(/^(?:brave|chrome|chromium|google-chrome|msedge)-(.+?)__/)
    if (web) {
      var host = web[1].replace(/_/g, "/")
      for (var i = 0; i < entries.length && !icon; i++) {
        if (String(entries[i].execString || "").indexOf(host) !== -1) icon = entries[i].icon
      }
    }
    if (!icon && appId) {
      var entry = DesktopEntries.heuristicLookup(appId)
      if (entry) icon = entry.icon
    }
    if (!icon && appId) {
      var suffix = "." + appId.toLowerCase()
      for (var j = 0; j < entries.length && !icon; j++) {
        var id = String(entries[j].id || "").toLowerCase()
        if (id.slice(-suffix.length) === suffix) icon = entries[j].icon
      }
    }
    if (icon && icon.charAt(0) === "/") return "file://" + icon
    var themed = Quickshell.iconPath(icon || appId.toLowerCase(), true)
    return themed.length > 0 ? themed : Quickshell.iconPath("application-x-executable", true)
  }

  readonly property real trailingGap: root.vertical ? 0 : Style.spaceReal(1.5)

  implicitWidth: grid.implicitWidth + trailingGap
  implicitHeight: grid.implicitHeight

  GridLayout {
    id: grid
    anchors.fill: parent
    anchors.rightMargin: root.trailingGap
    columns: root.vertical ? 1 : root.workspaceIds().length
    columnSpacing: root.vertical ? 0 : Style.space(1)
    rowSpacing: root.vertical ? Style.space(2) : 0

    Repeater {
      model: root.workspaceIds()

      WidgetButton {
        required property int modelData

        readonly property var workspace: root.workspaceById(modelData)
        readonly property bool occupied: workspace !== null && workspace.toplevels.values.length > 0
        readonly property bool focused: Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === modelData

        readonly property var windows: workspace ? workspace.toplevels.values : []
        readonly property real iconSize: 16

        bar: root.bar
        hasVisualContent: true
        labelVisible: false
        opacity: occupied || focused ? 1 : 0.5
        horizontalMargin: 6
        verticalPadding: 6
        fixedWidth: root.vertical ? root.barSize : Math.max(Style.space(20), content.implicitWidth + Style.spaceReal(6) * 2)
        fixedHeight: root.vertical ? Math.max(root.barSize, content.implicitHeight + Style.spaceReal(6) * 2) : root.barSize

        Grid {
          id: content
          anchors.centerIn: parent
          rows: root.vertical ? -1 : 1
          columns: root.vertical ? 1 : -1
          spacing: Style.spaceReal(1.5)
          horizontalItemAlignment: Grid.AlignHCenter
          verticalItemAlignment: Grid.AlignVCenter

          Text {
            textFormat: Text.PlainText
            text: focused ? "\uDB85\uDCFB" : (modelData === 10 ? "0" : String(modelData))
            color: root.bar ? root.bar.barForeground : Color.foreground
            font.family: root.bar ? root.bar.fontFamily : Style.font.family
            font.pixelSize: Style.font.body
            renderType: Text.NativeRendering
          }

          Repeater {
            model: windows

            Image {
              required property var modelData
              width: iconSize
              height: iconSize
              sourceSize.width: iconSize * 2
              sourceSize.height: iconSize * 2
              fillMode: Image.PreserveAspectFit
              smooth: true
              source: root.iconFor(root.appIdOf(modelData))
            }
          }
        }
        onPressed: function() { root.focusWorkspace(modelData) }
      }
    }
  }
}
