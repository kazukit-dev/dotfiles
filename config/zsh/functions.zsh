function dir() {
    mkdir "$1" && cd "$1"
}

# --------------------------------
# My special directories
# i: My projects dirs
# x: My experiments dirs
# --------------------------------

function i() {
    cd ~/i && cd "$1"
}

function x() {
    cd ~/x && cd "$1"
}

function xc() {
    cd ~/x && g clone "$@"
}
