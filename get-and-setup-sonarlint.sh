#!/usr/bin/env bash

info() {
    echo info: "$@"
}

fatal() {
    echo fatal: "$@"
    exit 1
}

set -e

cd "$(dirname "$0")"

info "downloading sonarlint into $PWD/work ..."
mkdir -p work
cd work

release=2.1.0.566
dirname=sonarlint-cli-$release
archive=$dirname.zip
wget -c -O $archive https://bintray.com/sonarsource/Distribution/download_file?file_path=sonarlint-cli%2Fsonarlint-cli-$release.zip
rm -fr $dirname
unzip $archive || {
    rm -f $archive
    fatal 'failed to unzip the file, try to download again'
}
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
