-- 日本語入力中の Space を半角スペースに固定する
--
-- 設計: macOS 標準 IME は Shift+Space が半角スペースなので、Space の
-- イベントに shift フラグを立てて素通しする。キーを握り潰して再送すると
-- 取りこぼしが起きるため、フラグの書き換えだけで済ませる。
--
-- 書き換える条件は二つ。変換中でないこと、テキスト入力欄にフォーカスが
-- あること。前者は変換中の Space が「次候補」であって空白ではないため。
-- 後者は Space の意味がアプリごとに違うため (Finder の Quick Look、
-- Safari のスクロール、nvim の leader)。どちらも外すと日常操作を壊す。
--
-- IME の未確定状態を外部から知る API は無いので composing は自前で追う。
-- 追跡がずれたときは、全角スペースが一つ入る側へ倒す。逆方向にずれると
-- Space が Shift+Space になり変換候補が逆走して、入力が壊れる。

local JAPANESE = "com.apple.inputmethod.Kotoeri.RomajiTyping.Japanese"

local KEY_SPACE = 49

-- 未確定文字列が確定する契機のキー
--   36 return / 76 padenter: 確定
--   102 japanese_eisuu / 104 japanese_kana: 入力モード切替 (Karabiner が左右 Cmd から送る)
--
-- escape と tab は入れない。ことえりの escape は読みに戻すだけ、tab は予測候補を
-- 埋めるだけで、どちらも未確定のまま残る。確定扱いにすると候補が逆走する。
local RESET_KEYS = {
  [36] = true,
  [76] = true,
  [102] = true,
  [104] = true,
}

-- Space を書き換えてよいフォーカス先。判定できないときは書き換えない
local TEXT_ROLES = {
  AXTextField = true,
  AXTextArea = true,
  AXComboBox = true,
  AXSearchField = true,
}

local composing = false

-- 文字を生むキーだけを変換開始とみなす。矢印や F キーは keycodes.map が
-- "up" や "f1" のような名前を返すため、長さ 1 かどうかで判別できる
-- (`¥` のような多バイト文字を落とさないよう byte 数ではなく文字数で見る)
local function isCharacterKey(code)
  local name = hs.keycodes.map[code]
  return type(name) == "string" and utf8.len(name) == 1
end

-- Space 押下時にしか呼ばないので、AX の往復 (0.4ms 程度) は入力の妨げにならない
local function isTextFocused()
  local element = hs.uielement.focusedElement()
  return element ~= nil and TEXT_ROLES[element:role()] == true
end

local keyTap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, function(event)
  local code = event:getKeyCode()
  local f = event:getFlags()

  if code == KEY_SPACE then
    -- 修飾キー付きの Space (Cmd+Space など) には触れない
    if not composing and not (f.shift or f.cmd or f.ctrl or f.alt or f.fn) and isTextFocused() then
      event:setFlags({ shift = true })
    end
    return false
  end

  if RESET_KEYS[code] then
    composing = false
  elseif not (f.cmd or f.ctrl or f.alt) and isCharacterKey(code) then
    composing = true
  end

  return false -- イベントは消費しない
end)

-- マウスクリックによる確定は追跡しない。クリックが確定させるかは状況によって
-- 変わり、確定していないのに composing を倒すと候補が逆走するため。

-- 全キー入力に Lua を挟まないよう、日本語入力中だけ tap を有効化する
local function sync()
  composing = false
  if hs.keycodes.currentSourceID() == JAPANESE then
    keyTap:start()
  else
    keyTap:stop()
  end
end

hs.keycodes.inputSourceChanged(sync)
sync()

-- アプリを切り替えると未確定文字列は確定する
local appWatcher = hs.application.watcher.new(function(_, event)
  if event == hs.application.watcher.activated then
    composing = false
  end
end)
appWatcher:start()

-- GC に回収されないよう参照を返す (package.loaded が保持する)
return { keyTap = keyTap, appWatcher = appWatcher }
