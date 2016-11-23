#!/usr/bin/env bash

info() {
    echo info: "$@"
}

set -e

cd "$(dirname "$0")"

info "downloading sonarlint into $PWD/work ..."
mkdir -p work
cd work

release=2.1.1
dirname=sonarlint-cli-$release
wget -c -O $dirname.zip https://github.com/janosgyerik/sonarlint-cli/releases/download/$release/$dirname.zip
rm -fr $dirname
unzip $dirname.zip
cd $dirname

info "creating symbolic link to sonarlint from ~/bin/sonarlint ..."
mkdir -p ~/bin
ln -sf "$PWD"/bin/sonarlint ~/bin/

info "checking sonarlint executability"
if ! type sonarlint &>/dev/null; then
    cat << "EOF" >&2

*******************************************************************************
fatal: it seems ~/bin is not on PATH
You can add it temporarily for the current shell by running this command:

    PATH=$HOME/bin:$PATH

To make that permanent, add this line to your ~/.bashrc or ~/.bash_profile
or ~/.profile, as appropriate for your environment.
*******************************************************************************
EOF
    exit 1
fi
