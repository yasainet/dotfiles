/**
 * Llama Shutdown Extension
 *
 * pi is a client of the llama-server running on mbp2023 (over Tailscale),
 * not its parent process. On real pi exit ("quit"), kill the remote
 * llama-server so its ~66GB mlocked model is freed instead of lingering.
 * session_shutdown also fires for /new, /resume, /fork, /reload; those are
 * excluded since the server should stay warm across those.
 */
import { execFile } from "node:child_process";
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

const REMOTE_HOST = "mbp2023";
const PROCESS_NAME = "llama-server";

export function shouldKillOnShutdown(reason: string): boolean {
  return reason === "quit";
}

export function buildSshKillArgs(host: string, processName: string): string[] {
  return ["-o", "BatchMode=yes", "-o", "ConnectTimeout=5", host, "killall", processName];
}

export default function (pi: ExtensionAPI) {
  pi.on("session_shutdown", async (event) => {
    if (!shouldKillOnShutdown(event.reason)) return;

    await new Promise<void>((resolve) => {
      execFile("ssh", buildSshKillArgs(REMOTE_HOST, PROCESS_NAME), { timeout: 8000 }, (error) => {
        if (error) {
          console.error(`llama-shutdown: failed to kill ${PROCESS_NAME} on ${REMOTE_HOST}: ${error.message}`);
        }
        resolve();
      });
    });
  });
}
