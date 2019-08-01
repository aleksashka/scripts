# Colorize console prompt

# User colors are Blueish
cursor_color='#0087FF'
prompt_color='33'

# Root prompt is Red
root_cursor_color='#FF0000'
root_prompt_color='196'

# Inspired by this article
# https://zork.net/~st/jottings/How_to_limit_the_length_of_your_bash_prompt.html
function trimmed_pwd {
    TRIM_CHARS=".."
    TRIMMED_PWD=${PWD:${#1}-$(tput cols)-1}
    if [ ! -z $TRIMMED_PWD ]; then
        echo -n "$TRIM_CHARS"
        TRIMMED_PWD=${PWD:${#1}+${#TRIM_CHARS}-$(tput cols)}
    fi
    TRIMMED_PWD=${TRIMMED_PWD:-$PWD}
    echo "$TRIMMED_PWD"
}

case "$TERM" in
xterm*|rxvt*|vte*|linux*)
    PS1='\[\e[38;5;'$prompt_color'm\]\t \u@\h $(trimmed_pwd "\t \u@\h ")\n'
    [[ $UID == 0 ]] && { prompt_color=$root_prompt_color;cursor_color=$root_cursor_color; }
    PS1="$PS1"'\[\e[m\e]12;'$cursor_color'\a\e[38;5;'$prompt_color'm\]\$ \[\e[m\]'
    ;;
*)
    PS1='\t \u@\h $(trimmed_pwd "\t \u@\h ")\n\$ '
    ;;
esac
