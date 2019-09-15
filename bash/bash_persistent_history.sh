# Put this script in /etc/profile.d/ to apply to all users
# Or add it to your .bashrc to apply to your user

# https://github.com/eliben/code-for-blog/blob/master/2016/persistent-history/add-persistent-history.sh
# https://eli.thegreenplace.net/2013/06/11/keeping-persistent-history-in-bash
log_bash_persistent_history()
{
    local rc=$?
    [[ $(history 1) =~ ^\ *[0-9]+\ +([^\ ]+\ [^\ ]+)\ +(.*)$ ]]
    local date_part="${BASH_REMATCH[1]}"
    local command_part="${BASH_REMATCH[2]}"
    if [ "$command_part" != "$PERSISTENT_HISTORY_LAST" ]
    then
        echo $date_part "|" "$command_part" >> ~/.persistent_history
        export PERSISTENT_HISTORY_LAST="$command_part"
    fi
}

# Stuff to do on PROMPT_COMMAND
run_on_prompt_command()
{
    log_bash_persistent_history
}

if [ "$PROMPT_COMMAND" = "" ]
then
    PROMPT_COMMAND="run_on_prompt_command"
else
    PROMPT_COMMAND="run_on_prompt_command; ""$PROMPT_COMMAND"
fi

export HISTTIMEFORMAT="%F %T  "

# Alias to grep persistent history: phgrep SEARCH_THIS_COMMAND
alias phgrep='grep ~/.persistent_history -e'
