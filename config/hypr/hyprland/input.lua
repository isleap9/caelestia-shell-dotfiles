local vars = require("variables")

hl.config({
    input = {
        kb_layout          = "gb,it",
        kb_options = "grp:alt_shift_toggle",
        numlock_by_default = false,
        repeat_delay       = 250,
        repeat_rate        = 35,
        focus_on_close     = 1,
        
        follow_mouse = 1,

        sensitivity   = 0,
        accel_profile = "flat",
        force_no_accel = true,


        touchpad           = {
            natural_scroll       = true,
            disable_while_typing = vars.touchpadDisableTyping,
            scroll_factor        = vars.touchpadScrollFactor,
        },
    },

    binds = {
        scroll_event_delay = 0,
    },

    cursor = {
        hotspot_padding = 1,
    },
})
