import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { spawn } from "node:child_process";
import { existsSync } from "node:fs";

const MACISM = "/opt/homebrew/bin/macism";
const ABC_LAYOUT = "com.apple.keylayout.ABC";

export default function (pi: ExtensionAPI) {
  const switchToABC = () => {
    if (process.platform !== "darwin" || !existsSync(MACISM)) return;
    const child = spawn(MACISM, [ABC_LAYOUT], { stdio: "ignore" });
    child.on("error", () => {});
  };

  pi.on("input", () => switchToABC());
}
