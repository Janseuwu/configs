emulate -L zsh

_command_timer_preexec () {
	if [ -v ZSH_COMMAND_TIME_EXCLUDE ]; then
		for exc (${ZSH_COMMAND_TIME_EXCLUDE}) do;
			if [ $(echo $1 | grep -c ^$exc) -gt 0 ]; then
				return
			fi
		done
	fi

	_command_timer_command=${1:-???}
	_command_timer_start=$SECONDS
}

_command_timer_precmd () {
	local exit_code=$?

	if [ ! -v _command_timer_start ]; then
		# Finished either an empty prompt or an ignored command.
		return
	fi

	_command_timer_last_cmd=$((SECONDS - _command_timer_start))
	# ignore 130 (interrupted by user)
	if [ $_command_timer_last_cmd -ge ${ZSH_COMMAND_TIME_MIN:-3} -a $exit_code -ne 130 ]; then
		# FIXME: shorten _command_timer_command if too long
		echo "command-timer: $_command_timer_command: finished with code $exit_code in $(_command_timer_format_secs $_command_timer_last_cmd)"

		# FIXME: send a notification here if not in front

		# On MacOS, announce with voice command in (background subshell to not block typing)
		if command -v say awk >/dev/null 2>&1; then
			(
				local voices=( $(say -v \? | awk 'match($2, /^en_/) { print $1 }') )
				local voice=${voices[$(( $SECONDS % ${#voices[@]} + 1 ))]}
				local command_name=${${_command_timer_command##sudo }%% *}
				say -v $voice  "Command '$command_name' finished with exit code $exit_code." &
			)
		fi
	fi

	unset _command_timer_start
	unset _command_timer_command
}

_command_timer_format_secs () {
	local h=$((${1}/3600))
	local m=$(((${1}%3600)/60))
	local s=$((${1}%60))
	printf "%02d:%02d:%02d\n" $h $m $s
}

# Use this in prompt
zsh_command_timer_get_time () {
	_command_timer_format_secs $_command_timer_last_cmd
}

add-zsh-hook precmd _command_timer_precmd
add-zsh-hook preexec _command_timer_preexec
