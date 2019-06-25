# colors.sh
# provides shell variables for color codes and PS1 escaping

eval_tty_effects() {
    local __tty_graphics_start='\e['
    local __tty_graphics_end=m

    local __tty_graphics_reset=0
    local __tty_graphics_effect_bold=1
    local __tty_graphics_effect_faint=2
    local __tty_graphics_effect_italic=3
    local __tty_graphics_effect_underline=4
    local __tty_graphics_effect_reverse=5
    local __tty_graphics_effect_conceal=6
    local __tty_graphics_effect_strikeout=7

    # even though these are only used once each, i think it's clearer to have them called out here
    local __tty_graphics_position_fg=3
    local __tty_graphics_position_bg=4

    local __tty_graphics_color_black=0
    local __tty_graphics_color_red=1
    local __tty_graphics_color_green=2
    local __tty_graphics_color_yellow=3
    local __tty_graphics_color_blue=4
    local __tty_graphics_color_magenta=5
    local __tty_graphics_color_cyan=6
    local __tty_graphics_color_white=7

    local __ps1_noprint_start='\['
    local __ps1_noprint_end='\]'

    eval __tty_reset="\$__tty_graphics_start\$__tty_graphics_reset\$__tty_graphics_end"
    eval __ps1_reset="\$__ps1_noprint_start\$__tty_reset\$__ps1_noprint_end"

    for effect in bold faint italic underline reverse conceal strikeout ; do
        eval __tty_$effect="\$__tty_graphics_start\$__tty_graphics_effect_$effect\$__tty_graphics_end"
        eval __ps1_$effect="\
\$__ps1_noprint_start\
\$__tty_graphics_start\
\$__tty_graphics_reset\
\;\
\$__tty_graphics_effect_$effect\
\$__tty_graphics_end\
\$__ps1_noprint_end"
    done
    for color in black red green yellow blue magenta cyan white ; do
        eval local __tty_graphics_bg_color_$color="\$__tty_graphics_position_bg\$__tty_graphics_color_$color"
        eval __tty_bg_$color="\$__tty_graphics_start\$__tty_graphics_bg_color_$color\$__tty_graphics_end"
        eval __ps1_bg_$color="\
\$__ps1_noprint_start\
\$__tty_graphics_start\
\$__tty_graphics_reset\
\;\
\$__tty_graphics_bg_color_$color\
\$__tty_graphics_end\
\$__ps1_noprint_end"
        eval local __tty_graphics_fg_color_$color="\$__tty_graphics_position_fg\$__tty_graphics_color_$color"
        eval __tty_$color="\$__tty_graphics_start\$__tty_graphics_fg_color_$color\$__tty_graphics_end"
        eval __ps1_$color="\
\$__ps1_noprint_start\
\$__tty_graphics_start\
\$__tty_graphics_reset\
\;\
\$__tty_graphics_fg_color_$color\
\$__tty_graphics_end\
\$__ps1_noprint_end"
        for effect in bold faint italic underline reverse conceal strikeout ; do
            eval __tty_${effect}_$color="\
\$__tty_graphics_start\
\$__tty_graphics_effect_$effect\
\;\
\$__tty_graphics_fg_color_$color\
\$__tty_graphics_end"
            eval __ps1_${effect}_$color="\
\$__ps1_noprint_start\
\$__tty_graphics_start\
\$__tty_graphics_reset\
\;\
\$__tty_graphics_effect_$effect\
\;\
\$__tty_graphics_fg_color_$color\
\$__tty_graphics_end\
\$__ps1_noprint_end"
        done
    done
}

eval_tty_effects
unset eval_tty_effects
