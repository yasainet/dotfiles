#!/usr/bin/env bash
# Display preview of tmux windows/panes.
# Forked from tmux-sessionx (scripts/preview.sh) to inject Claude Code state symbol.
# Symlinked over the plugin's preview.sh by tmux.conf at startup.

single_mode() {
  if test -d "${1}"; then
    display_directory "${1}"
    return
  fi

	session_name="${1}"
	if test "${DISPLAY_TMUXP}" -eq 1; then
		if $(tmux has-session -t "${session_name}" >&/dev/null); then
			:
		else
			tmuxp_conf="${HOME}/.tmuxp/${session_name}.yaml"
			if test -e "${tmuxp_conf}"; then
				cat "${tmuxp_conf}"
				return
			fi
		fi
	fi
	display_session "${session_name}"
}

tmux_option_or_fallback() {
	local option_value
	option_value="$(tmux show-option -gqv "$1")"
	if [ -z "$option_value" ]; then
		option_value="$2"
	fi
	echo "$option_value"
}

display_directory() {
  directory_name="${1}"
  ls_command=$(tmux_option_or_fallback "@sessionx-ls-command" "ls")
  eval "${ls_command} ${directory_name}"
}

display_session() {
	session_name="${1}"
	session_id=$(tmux ls -F '#{session_id}' -f "#{==:#{session_name},${session_name}}")
	if test -z "${session_id}"; then
		return 1
	fi
	tmux capture-pane -ep -t "${session_id}"
}

window_mode() {
	args=($1)
	tmux capture-pane -ep -t "${args[0]}"
}

claude_state_symbol() {
	local state="$1"
	case "$state" in
		running)     printf '\033[36m●\033[0m' ;;
		needs-input) printf '\033[33m◐\033[0m' ;;
		done)        printf '\033[31m●\033[0m' ;;
		*)           printf ' ' ;;
	esac
}

tree_mode() {
	highlight="${1}"
	icon=$(tmux_option_or_fallback "@sessionx-tree-icon" "󰘍")
	tmux ls -F'#{session_id}' | while read -r s; do
		S=$(tmux ls -F'#{session_id}#{session_name}: #{T:tree_mode_format}' | grep ^"$s")
		session_info=${S##$s}
		session_name=$(echo "$session_info" | cut -d ':' -f 1)
		if [[ -n "$highlight" ]] && [[ "$highlight" == "$session_name" ]]; then
			echo -e "\033[1;34m$session_info\033[0m"
		else
			echo -e "\033[1m$session_info\033[0m"
		fi
		tmux lsw -t"$s" -F'#{window_id}' | while read -r w; do
			W=$(tmux lsw -t"$s" -F'#{window_id}#{T:tree_mode_format}' | grep ^"$w")
			state=$(tmux show-options -wqv -t "$w" @claude-state 2>/dev/null)
			sym=$(claude_state_symbol "$state")
			echo -e "  $icon $sym ${W##$w}"
		done
	done
}

usage() {
	cat <<-END
		Usage: $0 [<options>] [<session_name>]

		Options:
		  -h              Print help and exit.
		  -p              Display tmuxp configuration is session not running
		  -t              Display tree of sessions

		A session name of "*Last*" is replaced with the client's last session.
	END
}

mode="single"
DISPLAY_TMUXP=0

while getopts ":hptw" opt; do
	case $opt in
	h)
		usage
		exit 0
		;;
	p) DISPLAY_TMUXP=1 ;;
	t) mode="tree" ;;
	w) mode="window" ;;
	\?) echo "Invalid option: -$OPTARG" >&2 ;;
	esac
done

shift $(($OPTIND - 1))
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$HOME/.config/tmux/plugins/tmux-sessionx/scripts"
if [ -f "$PLUGIN_DIR/git-branch.sh" ]; then
	source "$PLUGIN_DIR/git-branch.sh"
elif [ -f "$CURRENT_DIR/git-branch.sh" ]; then
	source "$CURRENT_DIR/git-branch.sh"
fi
SESSION=$(strip_git_branch_info "$1")

if test "${SESSION}" == '*Last*'; then
	SESSION=$(tmux display-message -p "#{client_last_session}")
	if test -z "${SESSION}"; then
		echo "No last session."
		exit 0
	fi
fi

case "${mode}" in
single) single_mode "${SESSION}" ;;
tree) tree_mode "${SESSION}" ;;
window) window_mode "${SESSION}" ;;
*) echo "Unknown mode \"${mode}\"" ;;
esac

exit $status
