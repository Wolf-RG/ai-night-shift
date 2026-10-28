# Queue entry template

The worker that picks this up has never seen your conversation. It has the entry and whatever is already in your files. Four fields, all mandatory:

- **Source** — exactly where the inputs are: absolute paths, folder ids, file counts. Not "the report" — the file.
- **Output** — where results go, a naming convention, and one example filename.
- **Method** — step by step, specific enough to name the tool calls and parameters.
- **Done means** — the quality bar, and what to verify once it is written.

Two habits that save a night:

1. **Confirm reachable before queuing.** List the folder, check the files exist, spot-check one URL. Do it at the desk, not at 2am.
2. **One task, one bounded slice** (≈10 minutes of agent work). If the entry implies more, split it — see `../scope/rules.md`.

An entry that fails the reachability check is not a task, it is a hope.
