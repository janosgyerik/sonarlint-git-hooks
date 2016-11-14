SonarLint Git hooks
===================

Git hook scripts to trigger SonarLint on VCS actions.

Requirements
------------

To run SonarLint analysis, you need the `sonarlint` command line tool.

http://www.sonarlint.org/commandline/

However, the current official release doesn't support multiple `--src` and `--tests` options,
which is essential for the hook scripts to work reasonably fast on multiple files.
To work around that limitation, you can use this custom build instead:

https://github.com/janosgyerik/sonarlint-cli/releases/tag/2.1.0-multi-src

The installation steps are the same as the official version.
Alternatively, you can run a convenience script included in this repository:

    ./get-and-setup-sonarlint.sh

This will do:

1. Download the custom build and extract inside the repository
2. Create a symbolic link to `sonarlint` in your `~/bin`
3. Verify that `sonarlint` is ready to run

This assumes that your `~/bin` folder is on `PATH`.
If that's not the case, you need to add the following line
to your `~/.bashrc` or `~/.bash_profile` or `~/.profile`,
as appropriate for your environment:

    PATH=$HOME/bin:$PATH

Installing
----------

To install the hook scripts, you can use the `install.sh` script:

    cd your/git/project
    /path/to/sonarlint-git-hooks/install.sh

The script will create symbolic links to the hook scripts in the `hooks/` directory.
It will not overwrite existing files.
To disable a hook script, you can either rename it or delete it.

If symbolic links don't work well in your system,
you can copy the hook scripts manually.

Hooks
-----

See the hook scripts inside the `hooks` directory.

- `pre-push`: run analysis before `git push`, on files that were added or modified compared to `origin/master`, after some basic filtering applied:
    - If the file path contains `src/`, analyze it as source code
    - If the file path contains `src/` and also `test` or `Test`, analyze it as test code
    - Otherwise skip the file and print a warning
- `pre-commit`: run analysis before `git commit`, on files that were added or modified, after the same filtering applied as in `pre-push`.

You can easily run the hook scripts "standalone",
without actually running a Git command.
For example, to analyze files in the current branch that were added or modified compared to `origin/master`,
you can run the pre-push hook script directly:

    .git/hooks/pre-push

To temporarily disable a hook, run with `SKIPSONARLINT=1` set,
for example:

    SKIPSONARLINT=1 git push

Tip: here's an example Git alias to `git push` without analysis:

    pushf = "!f() { SKIPSONARLINT=1 git push \"$@\"; }; f"

To permanently disable the hook, you can simply rename the script file.

Limitations
-----------

If there are too many files to analyze,
the argument list might exceed the length limit of the operating system.
