### BEGIN_COMMON
#!/usr/bin/env bash

fatal() {
    echo fatal: "$@" >&2
    exit 1
}

info() {
    echo info: "$@"
}

print_files() {
    [[ $# != 1 ]] || return
    info $1
    shift
    for i; do
        info "  $i"
    done
}

if [ "$SKIPSONARLINT" ]; then
    info "SKIPSONARLINT is set, skipping verification..."
    exit 0
fi

if ! which sonarlint &>/dev/null; then
    fatal "cannot find sonarlint. Did you add to PATH?"
fi

run() {
    args=()
    sources=()
    tests=()
    for file; do
        if ! [ -f "$file" ]; then
            info "skip deleted file: $file"
            continue
        fi
        if [[ $file == *src/* ]]; then
            if [[ $file == *[tT]est* ]]; then
                tests+=("$file")
                args+=(--tests "$file")
            else
                sources+=("$file")
            fi
            args+=(--src "$file")
            continue
        fi
        info "skip unknown file: $file"
    done

    if [ ${#sources} = 0 -a ${#tests} = 0 ]; then
        info no files to analyze
        exit
    fi

    print_files "source files to analyze:" "${sources[@]}"
    print_files "test files to analyze:" "${tests[@]}"
    info "analyzing..."
    issues=$(sonarlint "${args[@]}" | sed -ne '/SonarLint Report/,/^---/p' -e '/Report generated/p')
    echo "$issues"

    if ! [[ $issues == *"No issues to display"* ]]; then
        fatal "hook abort: some analyses have failed"
    fi
}

### END_COMMON
