# tmp: manage temporary projects in ~/tmp
function tmp() {
  local cmd=$1
  shift 2>/dev/null

  case $cmd in
    new)
      local name=$1
      if [[ -z "$name" ]]; then
        echo "usage: tmp new <project_name>"
        return 1
      fi
      mkdir -p ~/tmp/"$name" && cd "$_"
      ;;
    ls)
      ls ~/tmp "$@"
      ;;
    cd)
      local dir
      dir=$(ls ~/tmp | fzf --reverse)
      [[ -n "$dir" ]] && cd ~/tmp/"$dir"
      ;;
    *)
      echo "usage: tmp <command>"
      echo ""
      echo "commands:"
      echo "  new <name>  Create a new tmp project and cd into it"
      echo "  ls          List tmp projects"
      echo "  cd          Select and cd into a tmp project"
      return 1
      ;;
  esac
}

# repo: ghq + fzf repository manager
function repo() {
  local cmd=$1
  shift 2>/dev/null

  case $cmd in
    ls)
      ghq list "$@"
      ;;
    cd)
      local dir
      dir=$(ghq list --full-path "$@" | fzf --reverse)
      [[ -n "$dir" ]] && cd "$dir"
      ;;
    *)
      echo "usage: repo <command>"
      echo ""
      echo "commands:"
      echo "  ls      List repositories"
      echo "  cd      Select and cd into a repository"
      return 1
      ;;
  esac
}
