import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { execFile } from "node:child_process";

const BASE_URL = process.env.LLM_URL ?? "http://queen:8080";
const SERVICE = "llama-server";

const ssh = (cmd: string) =>
  new Promise<void>((resolve) => {
    execFile("ssh", ["queen", cmd], { timeout: 15_000 }, () => resolve());
  });

const healthy = async () => {
  try {
    const res = await fetch(`${BASE_URL}/health`, {
      signal: AbortSignal.timeout(2000),
    });
    return res.ok;
  } catch {
    return false;
  }
};

export default function (pi: ExtensionAPI) {
  pi.on("session_start", async () => {
    if (await healthy()) return;
    await ssh(`systemctl --user start ${SERVICE}`);
    for (let i = 0; i < 600; i++) {
      if (await healthy()) return;
      await new Promise((r) => setTimeout(r, 1000));
    }
  });

  pi.on("session_shutdown", async (event) => {
    if (event.reason !== "quit") return;
    await ssh(`systemctl --user stop ${SERVICE}`);
  });
}
