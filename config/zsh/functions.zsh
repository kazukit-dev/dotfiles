# Create a directory and immediately change into it
function dir() {
    mkdir "$1" && cd "$1"
}

# --------------------------------
# My special directories
# i: My projects dirs
# x: My experiments dirs
# --------------------------------

# Navigate to projects directory (~/i)
# Usage: i [subdirectory]
function i() {
    cd ~/i && cd "$1"
}

# Navigate to experiments directory (~/x)
# Usage: x [subdirectory]
function x() {
    cd ~/x && cd "$1"
}

# Clone a git repository into projects directory (~/i)
# Usage: ic <git-url> [git-clone-options]
function ic() {
    cd ~/i && git clone "$@"
}

# Clone a git repository into experiments directory (~/x)
# Usage: xc <git-url> [git-clone-options]
function xc() {
    cd ~/x && git clone "$@"
}
