# 01 · The guard killed itself, twice, and kept reporting healthy

**Symptom.** The unattended window produced nothing, while the heartbeat file kept updating.

**Cause.** The guard script's restart step was:

```sh
pkill -f 'worker.sh --guard'
```

The guard *is* `worker.sh --guard`. `pgrep -f` matches the full command line of every process — including the shell that is executing the pkill. So "kill the previous instance" killed the bash running the guard itself.

Worse: the heartbeat was written *after* the kill step, by a `trap`. In the common case the trap survived long enough to stamp the file, so the watchdog saw a fresh heartbeat for a job that no longer existed. Monitoring was green; work was zero.

**Fix.** Resolve pids by reading `/proc/<pid>/cmdline` and comparing argv item by item, excluding your own pid and your parent's:

```sh
for p in /proc/[0-9]*; do
  pid=${p#/proc/}
  [ "$pid" = "$$" ] && continue
  tr '\0' ' ' < "$p/cmdline" 2>/dev/null | grep -qxF "$EXPECTED_ARGV" && kill "$pid"
done
```

**Rule.** Any script that kills "its own kind" must first prove it cannot match itself. `pgrep -f` cannot make that proof.
