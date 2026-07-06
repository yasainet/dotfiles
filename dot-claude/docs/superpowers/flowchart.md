# Superpowers Workflow Flowchart v6.1.1

## Main Workflow

```mermaid
flowchart TD
    START([Session 開始])
    B[brainstorming<br/>要件と設計の対話]
    GW[using-git-worktrees<br/>作業環境を隔離]
    WP[writing-plans<br/>実装プラン作成]
    CH{実装方式を選ぶ}
    SDD[subagent-driven-development<br/>同一セッション + subagent]
    EP[executing-plans<br/>別セッション + checkpoint]
    RCR[requesting-code-review<br/>最終レビューを依頼]
    JG{レビュー結果}
    RVC[receiving-code-review<br/>盲従せず技術検証]
    FIN[finishing-a-development-branch<br/>merge / PR / 破棄]
    END([完了])

    START --> B
    B -.worktree が必要な時.-> GW
    B ==>|強制 chain| WP
    GW --> WP
    WP ==>|REQUIRED SUB-SKILL| CH
    CH -->|Recommended| SDD
    CH -->|別 session| EP
    SDD ==> RCR
    EP ==> FIN
    RCR --> JG
    JG -->|指摘あり| RVC
    RVC --> SDD
    JG -->|OK| FIN
    FIN --> END

    classDef workflow fill:#e3f2fd,stroke:#1976d2,color:#000
    classDef terminal fill:#c8e6c9,stroke:#2e7d32,color:#000
    classDef choice fill:#fff9c4,stroke:#f9a825,color:#000
    class B,GW,WP,SDD,EP,RCR,RVC,FIN workflow
    class START,END terminal
    class CH,JG choice
```

## Discipline

```mermaid
flowchart TD
    IMPL([実装 or 修正の作業中])
    TDD[test-driven-development<br/>実装より先にテスト]
    SD[systematic-debugging<br/>修正案の前に切り分け]
    VBC[verification-before-completion<br/>完了主張前に検証]
    NEXT([次の task へ])

    IMPL -->|新機能を書く前| TDD
    IMPL -->|バグを発見| SD
    IMPL -->|完了を宣言する前| VBC
    SD -.失敗テスト作成に.-> TDD
    SD -.修正の裏付けに.-> VBC
    TDD --> NEXT
    VBC --> NEXT

    classDef discipline fill:#ffe0b2,stroke:#e65100,color:#000
    classDef terminal fill:#c8e6c9,stroke:#2e7d32,color:#000
    class TDD,SD,VBC discipline
    class IMPL,NEXT terminal
```

## Meta / Tactic

```mermaid
flowchart TD
    WS[writing-skills<br/>Meta: skill 新規作成 / 編集]
    DPA[dispatching-parallel-agents<br/>Tactic: 2 つ以上の独立 task]
    NOTE([main workflow から独立して呼ぶ])

    WS --> NOTE
    DPA --> NOTE

    classDef meta fill:#f3e5f5,stroke:#7b1fa2,color:#000
    classDef tactic fill:#e1bee7,stroke:#6a1b9a,color:#000
    classDef terminal fill:#c8e6c9,stroke:#2e7d32,color:#000
    class WS meta
    class DPA tactic
    class NOTE terminal
```
