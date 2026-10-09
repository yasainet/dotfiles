import { spawn } from "node:child_process";
import { existsSync } from "node:fs";

const MACISM = "/opt/homebrew/bin/macism";
const ABC_LAYOUT = "com.apple.keylayout.ABC";

export const name = "abc-layout";

export function apply(ctx) {
  const switchToABC = () => {
    if (process.platform !== "darwin" || !existsSync(MACISM)) return;
    const child = spawn(MACISM, [ABC_LAYOUT], { stdio: "ignore" });
    child.on("error", () => {});
  };

  ctx.on("agent/pre-step", ({ messages }, next) => {
    if (messages.some((message) => message.source?.kind === "user"))
      switchToABC();
    return next();
  });
  ctx.on("approval/request", (_req, next) => {
    switchToABC();
    return next();
  });
  ctx.on("user-questions/request", (_request, next) => {
    switchToABC();
    return next();
  });
}
