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
    if [ -n "$VIRTUAL_ENV" ]; then
        V_ENV="($(basename "$VIRTUAL_ENV")) "
    else
        V_ENV=""
    fi
    PROMPT="${V_ENV}${1}"
    TRIM_CHARS=".."
    TRIMMED_PWD=${PWD:${#PROMPT}-$(tput cols)-1}
    if [ ! -z "$TRIMMED_PWD" ]; then
        echo -n "$TRIM_CHARS"
        TRIMMED_PWD=${PWD:${#PROMPT}+${#TRIM_CHARS}-$(tput cols)}
    fi
    TRIMMED_PWD=${TRIMMED_PWD:-$PWD}
    echo "$TRIMMED_PWD"
}

case "$TERM" in
xterm*|rxvt*|vte*|linux*)
    PS1='\[\e[38;5;'$prompt_color'm\]\D{%F %T} \u@\h $(trimmed_pwd "\D{%F %T} \u@\h ")\n'
    [[ $UID == 0 ]] && { prompt_color=$root_prompt_color;cursor_color=$root_cursor_color; }
    PS1="$PS1"'\[\e[m\e]12;'$cursor_color'\a\e[38;5;'$prompt_color'm\]\$ \[\e[m\]'
    ;;
*)
    PS1='\D{%F %T} \u@\h $(trimmed_pwd "\D{%F %T} \u@\h ")\n\$ '
    ;;
esac
