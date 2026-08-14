# Skill Format

simplepowers の各 skill 本文の共通フォーマット。SOP (Standard Operating Procedure) に従う。

## SOP とは

作業を誰がやっても同じ品質で再現するための標準手順書。
ISO 9001 や FDA GMP などの品質管理分野で数十年使われてきた枯れた形式。

標準構成は Purpose → Scope → Responsibilities → Procedure → References。

1. Purpose: 文書の意図を 1〜2 文で述べる
2. Scope: 何に適用され、何に適用されないかの境界を引く
3. Responsibilities: 誰が何を担うかを定める
4. Procedure: 手順を段階的に記述する
5. References: 参照する文書や資料を列挙する

借用した理由は 2 つ。

- Scope が「適用条件」と「扱わない範囲」を書く場所として最初から定義されている。Golden Circle や OGSM など戦略系フレームにはこの置き場が無い
- 実行者を制約する手順書という目的が、skill と同じ

## Sections

| Section          | 書くこと                                       | 書かないこと |
| ---------------- | ---------------------------------------------- | ------------ |
| Purpose          | phase の意図と完了状態を 1〜2 行               | 手順         |
| Scope            | 適用条件 (いつ入るか)、扱わない範囲、禁止の境界 | how          |
| Responsibilities | Tools 表 (When → Tools)。担い手 = tool         | 手順         |
| Procedure        | 手順と規範。最終 step で報告し、止まる         | 範囲の話     |
| References       | 参照文書                                       | -            |

該当が無い section は省く。

## Background

旧形式は Scope と Goal の 2 section に、性質の異なる 4 種の記述が混在していた。

1. 範囲の制約 → Scope へ
2. 行動規範 (how) → Procedure へ
3. 完了条件と報告 → Purpose と Procedure の最終 step へ
4. 遷移規則 → 00-bootstrap に一元化

## Notes

- Why (いつこの skill を使うか) は frontmatter の description が担う
- Responsibilities の担い手は tool と見なす。単一エージェント前提で、人の役割分担は無い
- 遷移規則 (次の phase、自分から入るな) は 00-bootstrap が持つ。各 skill には書かない
