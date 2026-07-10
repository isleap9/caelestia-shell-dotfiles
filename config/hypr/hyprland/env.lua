local vars = require("variables")

-- Themes
hl.env("QT_QPA_PLATFORMTHEME", "qtengine")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("XCURSOR_THEME", vars.cursorTheme)
hl.env("XCURSOR_SIZE", vars.cursorSize)

-- Toolkit backends
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland,x11,windows")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- XDG specifications
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Others
hl.env("_JAVA_AWT_WM_NONREPARENTING", "1")

-- Cursor
hl.env("XCURSOR_SIZE",    "20")
hl.env("HYPRCURSOR_SIZE", "20")
hl.env("XCURSOR_THEME",   "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_THEME","Bibata-Modern-Ice")

-- Nvidia
hl.env("GBM_BACKEND",              "nvidia-drm")
hl.env("LIBVA_DRIVER_NAME",        "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME","nvidia")
hl.env("NVD_BACKEND",              "direct")
hl.env("WLR_NO_HARDWARE_CURSORS",  "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("HYPRLAND_NO_SD_NOTIFY",    "1")
