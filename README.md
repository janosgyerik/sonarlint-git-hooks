SonarLint Git hooks
===================

Git hook scripts to trigger SonarLint on VCS actions.

Requirements
------------

To run SonarLint analysis, you need the `sonarlint` command line tool.

http://www.sonarlint.org/commandline/

However, the current official release doesn't support multiple `--src` and `--tests` options,
which is essential for the hook scripts to work reasonably fast on multiple files.
The general installation instructions are the same as the official release,
but use this custom unofficial build instead:

https://github.com/janosgyerik/sonarlint-cli/releases/tag/2.1.0-multi-src

Download and install it, for example like this:

    # create a `tools` sub-directory in your home if doesn't exist and go inside
    mkdir -p ~/tools
    cd ~/tools

    # download and extract the zip, go inside the extracted directory
    wget https://github.com/janosgyerik/sonarlint-cli/releases/download/2.1.0-multi-src/sonarlint-cli-2.1.0-multi-src.zip
    unzip sonarlint-cli-2.1.0-multi-src.zip
    cd sonarlint-cli-2.1.0-multi-src

    # create `bin` directory in your `$HOME` if doesn't exist
    mkdir -p ~/bin

    # create symbolic link to sonarlint from ~/bin
    ln -s "$PWD"/bin/sonarlint ~/bin

This assumes that `~/bin` is on `PATH`, which is usually the case by default.
If it isn't, then add this line in your `~/.bashrc` file:

    PATH=$PATH:$HOME/bin

Installing
----------

To install a hook script, simply copy it to the `.git/hooks` directory of the project where you want to activate it. Make sure it has the executable bit set.

Alternatively,
for easier upgrades,
you can symlink to the hook script:

    ln -s absolute/path/to/hook/script path/to/your/repo/.git/hooks

Hooks
-----

See the hook scripts inside the `hooks` directory.

- `pre-push`: run analysis before `git push`, on files that were added or modified compared to `origin/master`, after some basic filtering applied:
    - If the file path contains `src/`, analyze it as source code
    - If the file path contains `src/` and also `test` or `Test`, analyze it as test code
    - Otherwise skip the file and print a warning

You can easily run the hook scripts "standalone",
without actually running a Git command.
For example, to analyze files in the current branch that were added or modified compared to `origin/master`,
you can run the pre-push hook script directly:

    .git/hooks/pre-push

To temporarily disable a hook, run with `SKIPSONARLINT=1` set,
for example:

    SKIPSONARLINT=1 git push

Tip: here's an example Git alias to `git push` without analysis:

    pushf = "!f() { SKIPSONARLINT=1 git push \"$@\"; }; f \"$@\""

To permanently disable the hook, you can simply rename the script file.

Limitations
-----------

If there are too many files to analyze,
the argument list might exceed the length limit of the operating system.
