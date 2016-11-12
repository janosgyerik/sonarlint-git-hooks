SonarLint Git hooks
===================

Git hook scripts to run SonarLint.

*Beware: highly experimental stuff*

Requirements
------------

To run SonarLint analysis, you need the `sonarlint` command line tool.

http://www.sonarlint.org/commandline/

Download and install it, and put `sonarlint` somewhere on `PATH`.

Scripts
-------

- `hooks/pre-push`: run analysis before `git push`, for each changed file compared to `origin/master`. Currently only files matching the pattern `src/main/java` are analyzed, others are skipped with a warning. To temporarily disable the hook, run with `SKIPSONARLINT=1 git push`.

Installing
----------

To install a script, simply copy it to the `.git/hooks` directory of the project where you want to activate it. Make sure it has the executable bit set.

Limitations
-----------

In addition to the limitations explained with each script,
there are some common global limitations.

- The `sonarlint` tool requires a GLOB to select source files. To avoid analyzing more files than necessary, the scripts run one analysis per file. If there is more than one file to analyze, this quickly becomes very slow.

- The `sonarlint` tool cannot analyze test files alone. When a test file is specified but no source files, the tool assumes the entire project as source files. That's not so good for hooks, so they try to omit test files.
