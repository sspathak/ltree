# ltree: Oh My Zsh plugin for a truncated directory tree

_ltree_walk() {
  local dir="$1"
  local limit="$2"
  local max_depth="$3"
  local show_all="$4"
  local prefix="$5"
  local depth="$6"

  if (( max_depth >= 0 && depth >= max_depth )); then
    return
  fi

  if [[ ! -r "$dir" ]]; then
    print -r -- "${prefix}└── [Permission Denied]"
    return
  fi

  local -a dirs files
  if (( show_all )); then
    dirs=("$dir"/*(ND/on))
    files=("$dir"/*(ND^/on))
  else
    dirs=("$dir"/*(N/on))
    files=("$dir"/*(N^/on))
  fi

  local total_files=${#files}
  local extra=$(( total_files > limit ? total_files - limit : 0 ))
  local -a shown_files=("${files[@]:0:$limit}")

  local -a kinds items
  local d f
  for d in "${dirs[@]}"; do
    kinds+=("dir")
    items+=("$d")
  done
  for f in "${shown_files[@]}"; do
    kinds+=("file")
    items+=("$f")
  done
  if (( extra > 0 )); then
    kinds+=("more")
    items+=("$extra")
  fi

  local count=${#items}
  local i kind item is_last connector child_prefix label
  for (( i = 1; i <= count; i++ )); do
    kind="${kinds[$i]}"
    item="${items[$i]}"
    is_last=$(( i == count ))

    if (( is_last )); then
      connector="└── "
      child_prefix="${prefix}    "
    else
      connector="├── "
      child_prefix="${prefix}│   "
    fi

    if [[ "$kind" == "dir" ]]; then
      print -r -- "${prefix}${connector}${item:t}/"
      _ltree_walk "$item" "$limit" "$max_depth" "$show_all" "$child_prefix" $(( depth + 1 ))
    elif [[ "$kind" == "file" ]]; then
      print -r -- "${prefix}${connector}${item:t}"
    else
      label="files"
      (( item == 1 )) && label="file"
      print -r -- "${prefix}${connector}... ${item} more ${label}"
    fi
  done
}

ltree() {
  local limit=5
  local max_depth=-1
  local show_all=0
  local -a opt_n opt_L opt_a opt_h

  zparseopts -D -E \
    n:=opt_n -limit:=opt_n \
    L:=opt_L -level:=opt_L \
    a=opt_a -all=opt_a \
    h=opt_h -help=opt_h

  if (( ${#opt_h} )); then
    print -r -- "Usage: ltree [OPTIONS] [DIR]"
    print -r -- "  -n, --limit NUM   Max files per directory (default: 5)"
    print -r -- "  -L, --level NUM   Max depth to descend"
    print -r -- "  -a, --all         Include hidden files"
    return 0
  fi

  (( ${#opt_n} )) && limit="${opt_n[-1]}"
  (( ${#opt_L} )) && max_depth="${opt_L[-1]}"
  (( ${#opt_a} )) && show_all=1

  local target="${1:-.}"
  if [[ ! -d "$target" ]]; then
    print -u2 -r -- "ltree: '$target' is not a directory"
    return 1
  fi

  print -r -- "${target%/}/"
  _ltree_walk "${target%/}" "$limit" "$max_depth" "$show_all" "" 0
}
