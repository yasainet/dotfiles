import { test } from "node:test";
import assert from "node:assert/strict";
import { shouldKillOnShutdown, buildSshKillArgs } from "../llama-shutdown.ts";

test("shouldKillOnShutdown: true for quit", () => {
  assert.equal(shouldKillOnShutdown("quit"), true);
});

test("shouldKillOnShutdown: false for reload/new/resume/fork", () => {
  assert.equal(shouldKillOnShutdown("reload"), false);
  assert.equal(shouldKillOnShutdown("new"), false);
  assert.equal(shouldKillOnShutdown("resume"), false);
  assert.equal(shouldKillOnShutdown("fork"), false);
});

test("buildSshKillArgs: ssh args target host and process name via killall", () => {
  assert.deepEqual(buildSshKillArgs("mbp2023", "llama-server"), [
    "-o",
    "BatchMode=yes",
    "-o",
    "ConnectTimeout=5",
    "mbp2023",
    "killall",
    "llama-server",
  ]);
});
