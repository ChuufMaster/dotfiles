# zsh parameter completion for the dotnet CLI
# source ~/.fastlane/completions/completion.zsh
source ~/qmk_firmware/util/qmk_tab_complete.sh
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

_dotnet_zsh_complete() 
{
  local completions=("$(dotnet complete "$words")")

  # If the completion list is empty, just continue with filename selection
  if [ -z "$completions" ]
  then
    _arguments '*::arguments: _normal'
    return
  fi

  # This is not a variable assignment, don't remove spaces!
  _values = "${(ps:\n:)completions}"
}

# "
_dotnet_suggest_zsh_complete()
{
    # debug lines, uncomment to get state variables passed to this function
    # echo "\n\n\nstate:\t'$state'"
    # echo "line:\t'$line'"
    # echo "words:\t$words"

    # Get full path to script because dotnet-suggest needs it
    # NOTE: this requires a command registered with dotnet-suggest be
    # on the PATH
    full_path=$(realpath $(which ${words[1]})) # zsh arrays are 1-indexed
    # Get the full line
    # $words array when quoted like this gets expanded out into the full line
    full_line="$words"

    # Get the completion results, will be newline-delimited
    completions=$(dotnet-suggest get --executable "$full_path" -- "$full_line")
    # explode the completions by linefeed instead of by spaces into the descriptions for the
    # _values helper function.

    # If the completion list is empty, just continue with filename selection
    if [ -z "$completions" ]
    then
      _arguments '*::arguments: _normal'
      return
    fi
    
    exploded=(${(f)completions})
    # for later - once we have descriptions from dotnet suggest, we can stitch them
    # together like so:
    # described=()
    # for i in {1..$#exploded}; do
    #     argument="${exploded[$i]}"
    #     description="hello description $i"
    #     entry=($argument"["$description"]")
    #     described+=("$entry")
    # done
    _values 'suggestions' $exploded
}

compdef _dotnet_suggest_zsh_complete $(dotnet-suggest list)
compdef _dotnet_zsh_complete dotnet

export DOTNET_SUGGEST_SCRIPT_VERSION="1.0.0"

#
# Installation:
#
# Via shell config file  ~/.bashrc  (or ~/.zshrc)
#
#   Append the contents to config file
#   'source' the file in the config file
#
# You may also have a directory on your system that is configured
#    for completion files, such as:
#
#    /usr/local/etc/bash_completion.d/

###-begin-flutter-completion-###

if type complete &>/dev/null; then
  __flutter_completion() {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           flutter completion -- "${COMP_WORDS[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -F __flutter_completion flutter
elif type compdef &>/dev/null; then
  __flutter_completion() {
    si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 flutter completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef __flutter_completion flutter
elif type compctl &>/dev/null; then
  __flutter_completion() {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       flutter completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K __flutter_completion flutter
fi

###-end-flutter-completion-###

## Generated 2024-09-22 09:20:31.963062Z
## By /usr/lib/flutter/bin/cache/flutter_tools.snapshot%

#compdef delta

autoload -U is-at-least

_delta() {
    typeset -A opt_args
    typeset -a _arguments_options
    local ret=1

    if is-at-least 5.2; then
        _arguments_options=(-s -S -C)
    else
        _arguments_options=(-s -C)
    fi

    local context curcontext="$curcontext" state line
    _arguments "${_arguments_options[@]}" \
'--blame-code-style=[Style string for the code section of a git blame line]:STYLE: ' \
'--blame-format=[Format string for git blame commit metadata]:FMT: ' \
'--blame-palette=[Background colors used for git blame lines (space-separated string)]:COLORS: ' \
'--blame-separator-format=[Separator between the blame format and the code section of a git blame line]:FMT: ' \
'--blame-separator-style=[Style string for the blame-separator-format]:STYLE: ' \
'--blame-timestamp-format=[Format of \`git blame\` timestamp in raw git output received by delta]:FMT: ' \
'--blame-timestamp-output-format=[Format string for git blame timestamp output]:FMT: ' \
'--config=[Load the config file at PATH instead of ~/.gitconfig]:PATH:_files' \
'--commit-decoration-style=[Style string for the commit hash decoration]:STYLE: ' \
'--commit-regex=[Regular expression used to identify the commit line when parsing git output]:REGEX: ' \
'--commit-style=[Style string for the commit hash line]:STYLE: ' \
'--default-language=[Default language used for syntax highlighting]:LANG: ' \
'--detect-dark-light=[Detect whether or not the terminal is dark or light by querying for its colors]:DETECT_DARK_LIGHT:((auto\:"Only query the terminal for its colors if the output is not redirected"
always\:"Always query the terminal for its colors"
never\:"Never query the terminal for its colors"))' \
'-@+[Extra arguments to pass to \`git diff\` when using delta to diff two files]:STRING: ' \
'--diff-args=[Extra arguments to pass to \`git diff\` when using delta to diff two files]:STRING: ' \
'--diff-stat-align-width=[Width allocated for file paths in a diff stat section]:N: ' \
'--features=[Names of delta features to activate (space-separated)]:FEATURES: ' \
'--file-added-label=[Text to display before an added file path]:STRING: ' \
'--file-copied-label=[Text to display before a copied file path]:STRING: ' \
'--file-decoration-style=[Style string for the file decoration]:STYLE: ' \
'--file-modified-label=[Text to display before a modified file path]:STRING: ' \
'--file-removed-label=[Text to display before a removed file path]:STRING: ' \
'--file-renamed-label=[Text to display before a renamed file path]:STRING: ' \
'--file-style=[Style string for the file section]:STYLE: ' \
'--file-transformation=[Sed-style command transforming file paths for display]:SED_CMD: ' \
'--generate-completion=[Print completion file for the given shell]:GENERATE_COMPLETION:(bash elvish fish powershell zsh)' \
'--grep-context-line-style=[Style string for non-matching lines of grep output]:STYLE: ' \
'--grep-file-style=[Style string for file paths in grep output]:STYLE: ' \
'--grep-header-decoration-style=[Style string for the header decoration in grep output]:STYLE: ' \
'--grep-header-file-style=[Style string for the file path part of the header in grep output]:STYLE: ' \
'--grep-line-number-style=[Style string for line numbers in grep output]:STYLE: ' \
'--grep-output-type=[Grep output format. Possible values\: "ripgrep" - file name printed once, followed by matching lines within that file, each preceded by a line number. "classic" - file name\:line number, followed by matching line. Default is "ripgrep" if \`rg --json\` format is detected, otherwise "classic"]:OUTPUT_TYPE:(ripgrep classic)' \
'--grep-match-line-style=[Style string for matching lines of grep output]:STYLE: ' \
'--grep-match-word-style=[Style string for the matching substrings within a matching line of grep output]:STYLE: ' \
'--grep-separator-symbol=[Separator symbol printed after the file path and line number in grep output]:STRING: ' \
'--hunk-header-decoration-style=[Style string for the hunk-header decoration]:STYLE: ' \
'--hunk-header-file-style=[Style string for the file path part of the hunk-header]:STYLE: ' \
'--hunk-header-line-number-style=[Style string for the line number part of the hunk-header]:STYLE: ' \
'--hunk-header-style=[Style string for the hunk-header]:STYLE: ' \
'--hunk-label=[Text to display before a hunk header]:STRING: ' \
'--hyperlinks-commit-link-format=[Format string for commit hyperlinks (requires --hyperlinks)]:FMT: ' \
'--hyperlinks-file-link-format=[Format string for file hyperlinks (requires --hyperlinks)]:FMT: ' \
'--inline-hint-style=[Style string for short inline hint text]:STYLE: ' \
'--inspect-raw-lines=[Kill-switch for --color-moved support]:true|false:(true false)' \
'--line-buffer-size=[Size of internal line buffer]:N: ' \
'--line-fill-method=[Line-fill method in side-by-side mode]:STRING:(ansi spaces)' \
'--line-numbers-left-format=[Format string for the left column of line numbers]:FMT: ' \
'--line-numbers-left-style=[Style string for the left column of line numbers]:STYLE: ' \
'--line-numbers-minus-style=[Style string for line numbers in the old (minus) version of the file]:STYLE: ' \
'--line-numbers-plus-style=[Style string for line numbers in the new (plus) version of the file]:STYLE: ' \
'--line-numbers-right-format=[Format string for the right column of line numbers]:FMT: ' \
'--line-numbers-right-style=[Style string for the right column of line numbers]:STYLE: ' \
'--line-numbers-zero-style=[Style string for line numbers in unchanged (zero) lines]:STYLE: ' \
'--map-styles=[Map styles encountered in raw input to desired output styles]:STYLES_MAP: ' \
'--max-line-distance=[Maximum line pair distance parameter in within-line diff algorithm]:DIST: ' \
'--max-syntax-highlighting-length=[Stop syntax highlighting lines after this many characters]:N: ' \
'--max-line-length=[Truncate lines longer than this]:N: ' \
'--merge-conflict-begin-symbol=[String marking the beginning of a merge conflict region]:STRING: ' \
'--merge-conflict-end-symbol=[String marking the end of a merge conflict region]:STRING: ' \
'--merge-conflict-ours-diff-header-decoration-style=[Style string for the decoration of the header above the '\''ours'\'' merge conflict diff]:STYLE: ' \
'--merge-conflict-ours-diff-header-style=[Style string for the header above the '\''ours'\'' branch merge conflict diff]:STYLE: ' \
'--merge-conflict-theirs-diff-header-decoration-style=[Style string for the decoration of the header above the '\''theirs'\'' merge conflict diff]:STYLE: ' \
'--merge-conflict-theirs-diff-header-style=[Style string for the header above the '\''theirs'\'' branch merge conflict diff]:STYLE: ' \
'--minus-empty-line-marker-style=[Style string for removed empty line marker]:STYLE: ' \
'--minus-emph-style=[Style string for emphasized sections of removed lines]:STYLE: ' \
'--minus-non-emph-style=[Style string for non-emphasized sections of removed lines that have an emphasized section]:STYLE: ' \
'--minus-style=[Style string for removed lines]:STYLE: ' \
'--navigate-regex=[Regular expression defining navigation stop points]:REGEX: ' \
'--pager=[Which pager to use]:CMD: ' \
'--paging=[Whether to use a pager when displaying output]:auto|always|never:(auto always never)' \
'--plus-emph-style=[Style string for emphasized sections of added lines]:STYLE: ' \
'--plus-empty-line-marker-style=[Style string for added empty line marker]:STYLE: ' \
'--plus-non-emph-style=[Style string for non-emphasized sections of added lines that have an emphasized section]:STYLE: ' \
'--plus-style=[Style string for added lines]:STYLE: ' \
'--right-arrow=[Text to display with a changed file path]:STRING: ' \
'--syntax-theme=[The syntax-highlighting theme to use]:SYNTAX_THEME: ' \
'--tabs=[The number of spaces to replace tab characters with]:N: ' \
'--true-color=[Whether to emit 24-bit ("true color") RGB color codes]:auto|always|never:(auto always never)' \
'--whitespace-error-style=[Style string for whitespace errors]:STYLE: ' \
'-w+[The width of underline/overline decorations]:N: ' \
'--width=[The width of underline/overline decorations]:N: ' \
'--word-diff-regex=[Regular expression defining a '\''word'\'' in within-line diff algorithm]:REGEX: ' \
'--wrap-left-symbol=[End-of-line wrapped content symbol (left-aligned)]:STRING: ' \
'--wrap-max-lines=[How often a line should be wrapped if it does not fit]:N: ' \
'--wrap-right-percent=[Threshold for right-aligning wrapped content]:PERCENT: ' \
'--wrap-right-prefix-symbol=[Pre-wrapped content symbol (right-aligned)]:STRING: ' \
'--wrap-right-symbol=[End-of-line wrapped content symbol (right-aligned)]:STRING: ' \
'--zero-style=[Style string for unchanged lines]:STYLE: ' \
'--24-bit-color=[Deprecated\: use --true-color]:auto|always|never:(auto always never)' \
'--color-only[Do not alter the input structurally in any way]' \
'--dark[Use default colors appropriate for a dark terminal background]' \
'--diff-highlight[Emulate diff-highlight]' \
'--diff-so-fancy[Emulate diff-so-fancy]' \
'--hyperlinks[Render commit hashes, file names, and line numbers as hyperlinks]' \
'--keep-plus-minus-markers[Prefix added/removed lines with a +/- character, as git does]' \
'--light[Use default colors appropriate for a light terminal background]' \
'-n[Display line numbers next to the diff]' \
'--line-numbers[Display line numbers next to the diff]' \
'--list-languages[List supported languages and associated file extensions]' \
'--list-syntax-themes[List available syntax-highlighting color themes]' \
'--navigate[Activate diff navigation]' \
'--no-gitconfig[Do not read any settings from git config]' \
'--parse-ansi[Display ANSI color escape sequences in human-readable form]' \
'--raw[Do not alter the input in any way]' \
'--relative-paths[Output all file paths relative to the current directory]' \
'--show-colors[Show available named colors]' \
'--show-config[Display the active values for all Delta options]' \
'--show-syntax-themes[Show example diff for available syntax-highlighting themes]' \
'--show-themes[Show example diff for available delta themes]' \
'-s[Display diffs in side-by-side layout]' \
'--side-by-side[Display diffs in side-by-side layout]' \
'-h[Print help (see more with '\''--help'\'')]' \
'--help[Print help (see more with '\''--help'\'')]' \
'-V[Print version]' \
'--version[Print version]' \
'::minus_file -- First file to be compared when delta is being used to diff two files:_files' \
'::plus_file -- Second file to be compared when delta is being used to diff two files:_files' \
&& ret=0
}

(( $+functions[_delta_commands] )) ||
_delta_commands() {
    local commands; commands=()
    _describe -t commands 'delta commands' commands "$@"
}

if [ "$funcstack[1]" = "_delta" ]; then
    _delta "$@"
else
    compdef _delta delta
fi


#compdef gitlab-ci-local
###-begin-gitlab-ci-local-completions-###
#
# yargs command completion script
#
# Installation: gitlab-ci-local completion >> ~/.zshrc
#    or gitlab-ci-local completion >> ~/.zprofile on OSX.
#
_gitlab-ci-local_yargs_completions()
{
  local reply
  local si=$IFS
  IFS=$'
' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" gitlab-ci-local --get-yargs-completions "${words[@]}"))
  IFS=$si
  _describe 'values' reply
}
compdef _gitlab-ci-local_yargs_completions gitlab-ci-local
###-end-gitlab-ci-local-completions-###

compdef sshv='ssh'
setopt complete_aliases
