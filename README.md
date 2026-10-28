# ai-night-shift

Notes and templates for running an AI agent **unattended overnight**: the parts that break, and the guards that keep them from breaking *silently*.

Everything here was learned on one machine (WSL2, a local LLM behind a single-slot gate, `systemd --user` timers). The numbers are single-machine observations, not benchmarks — treat them as "this happened to me", not "this is the speed of the world".

## Three rules that actually mattered

1. **Kill carefully.** `pgrep -f 'worker.sh --guard'` matches the shell that is *running* that command — including the one doing the killing. Use `/proc/<pid>/cmdline` and compare argv item by item.
2. **Prove empty before you occupy.** An unload that returns `200` does not mean the memory is back. Poll until the process is really gone, then load.
3. **Lock before you mutate shared state.** Two paths touching the same model state produced `load -> 500` and a state stuck on `loading` for hours. `flock -n`, exit on contention, log one line.

## The failure mode nobody warns you about

An over-scoped task **does not error**. It degrades: the worker runs out of room and starts re-emitting its own input as if that were the deliverable. You wake up to a file that looks finished and contains nothing.

The countermeasure is boring: one task = one bounded slice (≈10 minutes of agent work), and if the entry implies more, split it — either one section per task, or a *read* task that produces an outline and a *write* task that only reads the outline.

## What's in here

| Path | What it is |
|---|---|
| `queue/template.md` | The four fields a queue entry needs so a worker with no context can execute it |
| `scope/rules.md` | What may run unattended, what may never, and the two ways to split an over-scoped task |
| `watchdog/design.md` | Making "did nothing" visible: idle proof, alert cooldown, `WARN` vs `RUNNING` |
| `incidents/` | Three things that went wrong, with the numbers |

## License

MIT.