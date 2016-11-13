#!/usr/bin/env bash

hook_scripts_dir=$(cd "$(dirname "$0")"; pwd)

. "$hook_scripts_dir"/common.sh

git_work_tree=$(git rev-parse --show-toplevel)

for hook in "$hook_scripts_dir"/hooks/*; do
    basename=${hook##*/}
    local_script="$git_work_tree/.git/hooks/$basename"
    if test -f "$local_script"; then
        info skip: $basename hook already exists
    else
        info installing hook at: $local_script
        ln -s "$hook" "$local_script"
    fi
done

info "note: to disable a hook, simply rename the file"
