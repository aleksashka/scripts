# Colorize console prompt

# User colors are Blueish
cursor_color='#0087FF'
prompt_color='33'

# Root prompt is Red
root_cursor_color='#FF0000'
root_prompt_color='196'

case "$TERM" in
xterm*|rxvt*|vte*|linux*)
    PS1='\[\e[38;5;'$prompt_color'm\]\t \u@\h \w\n'
    [[ $UID == 0 ]] && { prompt_color=$root_prompt_color;cursor_color=$root_cursor_color; }
    PS1="$PS1"'\[\e[m\e]12;'$cursor_color'\a\e[38;5;'$prompt_color'm\]\$ \[\e[m\]'
    ;;
*)
    PS1='\t \u@\h \w\n\$ '
    ;;
esac
