# herdr skill (vendored)

herdr 公式 SKILL.md について。

## Setup

```sh
npx skills add herdrdev/herdr --skill herdr -g
```

## Usage

- Upstream: https://github.com/herdrdev/herdr/blob/master/skills/herdr/SKILL.md
- Docs: https://herdr.dev/docs/agent-skill/

herdr 0.8.0 以降は skill がバイナリに同梱されている。差分確認と更新は CLI で行う。

Check diff:

```sh
herdr --skill | diff - SKILL.md
```

Update:

```sh
herdr --skill > SKILL.md
```
