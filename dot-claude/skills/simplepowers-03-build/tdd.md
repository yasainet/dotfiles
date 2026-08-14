# TDD

期待挙動を assertion として書ける変更は、この順で作れ。

red は test が失敗する状態、green は成功する状態を指す。red から始めよ。

1. red: 失敗する test を先に書け
2. test を実行し、失敗を自分の目で確認せよ。いきなり通ったらその test は何も証明していない。書き直せ
3. green: test を通す最小の code を書け
4. test を実行し、成功を確認せよ。落ちたら test でなく code を直せ

assertion が書けない変更は、この手順を飛ばして作れ。迷ったら `user` に聞け。

ここでの test 実行は red/green の確認だけだ。全体の検証は `Verify` の仕事だ。
