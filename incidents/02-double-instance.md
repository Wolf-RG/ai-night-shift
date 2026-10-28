# 02 · Unload returned 200, memory was still occupied

**Symptom.** After a reload cycle, two model server processes were resident: **9.17 GB + 8.01 GB**.

**Cause.** The reload sequence was unload → load, back to back. The unload call returned success immediately, but process exit is asynchronous. The load request arrived while the old instance was still holding memory, so a second instance started.

**Fix.** After unload, poll until the model is genuinely absent (API state empty and no matching pid), *then* load. Cost of the wait: a few seconds. Cost of not waiting: a machine that swaps all night and a lane that starves.

**Second-order lesson.** After loading, **verify the flags you asked for**. A model that was already resident ignores some load-time parameters; a later just-in-time reload by another lane can silently revert them. Poll the effective config, compare to intent, reinstall once if it drifted, and report if it drifts again.

**Rule.** An API saying "done" is a statement about the API, not about the resource.
