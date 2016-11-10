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

- `scripts/pre-push`: run analysis before `git push`, for each changed file compared to `origin/master`. To temporarily disable the hook, run with `SKIPSONARLINT=1 git push`.

Installing
----------

To install a script, simply copy it to the `.git/hooks` directory of the project where you want to activate it. Make sure it has the executable bit set.

Limitations
-----------

- The `sonarlint` tool requires a GLOB to select source files. To avoid analyzing more files than necessary, the scripts run one analysis per file, which is very slow.
