-- md2adoc：把上游 mdBook 的 Markdown（或與其逐段對齊的譯稿）整理成這本書用的 AsciiDoc。
-- 由 scripts/md2adoc.rb 呼叫：pandoc -f gfm -t asciidoc --lua-filter scripts/md2adoc/filter.lua
-- 需要 pandoc 3.x（pandoc.Figure、pandoc.json、pandoc.utils.sha1）。
--
-- 中繼資料（-M key=value）：
--   chapter_id     本章的 ID（例如 ch08），也是本章各小節 ID 的前綴
--   chapter_ids    JSON 檔路徑：{ "chapter_7.md": "ch07", ... }，把章節之間的連結改成交互參照
--   ids_in         譯稿模式：英文原稿各標題的 ID 清單（JSON 檔路徑），依出現順序套用
--   ids_out        把本章各標題的層級、ID 與文字寫到這個 JSON 檔
--   math_overrides JSON 檔路徑：{ "<MathML 的 sha1>": "<LaTeX>" }，自動轉換不理想的公式改用這裡的寫法
--
-- 處理三輪：
--   1. 結構：圖說、表格與範例標題、Note/Tip/Warning 提示、MathML 公式
--   2. 行內：強調、程式碼、連結一律輸出非受限寫法（受限寫法緊貼中文時不會渲染）
--   3. 標題：去掉「Chapter N.」前綴，指定穩定的 ID

local meta_str = function(meta, key)
  local v = meta[key]
  return v and pandoc.utils.stringify(v) or nil
end

local function read_json_file(path)
  if not path or path == '' then return nil end
  local f = assert(io.open(path, 'r'), 'cannot open ' .. path)
  local s = f:read('a')
  f:close()
  return pandoc.json.decode(s, false)
end

local stringify = pandoc.utils.stringify

-- 「Figure 4-1. 說明」「圖 4-1. 說明」「圖 4-1．說明」→ 說明的 inline；不符合就回傳 nil
-- 全形句點不能放進 [] 字元類別：Lua 的樣式按位元組比對，會只吃掉一個位元組
local function caption_patterns(en, zh)
  return { '^' .. en .. '%s+%d+%-%d+%.%s*', '^' .. zh .. '%s*%d+%-%d+%.%s*', '^' .. zh .. '%s*%d+%-%d+．%s*' }
end
local CAPTION_PATTERNS = {
  figure = caption_patterns('Figure', '圖'),
  table = caption_patterns('Table', '表'),
  example = caption_patterns('Example', '範例'),
}

-- 從 inline 串列開頭移除符合 patterns 的前綴，回傳剩下的 inline（找不到前綴回傳 nil）
local function strip_prefix(inlines, patterns)
  local text = stringify(inlines)
  local prefix
  for _, p in ipairs(patterns) do
    local s, e = text:find(p)
    if s == 1 then prefix = text:sub(1, e); break end
  end
  if not prefix then return nil end

  -- 逐個 inline 吃掉前綴的字元數；前綴只會落在開頭的 Str 與 Space
  local need = #prefix
  local out = pandoc.List()
  local i = 1
  while i <= #inlines and need > 0 do
    local el = inlines[i]
    local t = stringify(el)
    if el.t == 'Space' or el.t == 'SoftBreak' then t = ' ' end
    if #t <= need then
      need = need - #t
    else
      out:insert(pandoc.Str(t:sub(need + 1)))
      need = 0
    end
    i = i + 1
  end
  for j = i, #inlines do out:insert(inlines[j]) end
  while #out > 0 and (out[1].t == 'Space' or out[1].t == 'SoftBreak') do out:remove(1) end
  return out
end

-- Para 只包著一個 Strong（或整段就是說明文字）時，取出裡面的 inline；
-- 範例說明偶爾寫成標題（第 2 章的「##### Example 2-1.」），一併接受
local function caption_inlines(block, kind, allow_plain)
  if block.t == 'Header' and kind == 'example' then return strip_prefix(block.content, CAPTION_PATTERNS[kind]) end
  if block.t ~= 'Para' then return nil end
  local c = block.content
  if #c == 1 and c[1].t == 'Strong' then return strip_prefix(c[1].content, CAPTION_PATTERNS[kind]) end
  if allow_plain then return strip_prefix(c, CAPTION_PATTERNS[kind]) end
  return nil
end

local function lone_image(block)
  if (block.t == 'Para' or block.t == 'Plain') and #block.content == 1 and block.content[1].t == 'Image' then
    return block.content[1]
  end
  return nil
end

-- ---------------------------------------------------------------------------
-- 公式：上游以 MathML 寫在 Markdown 裡，pandoc 的 gfm 讀取器把它當成原始 HTML，
-- 輸出 AsciiDoc 時會被直接丟掉。這裡改用 HTML 讀取器把 MathML 轉成 LaTeX。
-- ---------------------------------------------------------------------------

local math_overrides = {}
local math_count = 0

local function mathml_to_tex(raw)
  local key = pandoc.utils.sha1((raw:gsub('%s+', ' ')))
  math_count = math_count + 1
  if math_overrides[key] then return math_overrides[key] end
  local tex
  pandoc.read(raw, 'html'):walk({ Math = function(m) tex = tex or m.text end })
  if not tex then error('MathML 轉換失敗（sha1 ' .. key .. '）：' .. raw:sub(1, 80)) end
  -- MD2ADOC_MATH=1 時列出每條公式的 sha1 與自動轉換結果，用來撰寫 translation/math-overrides.json
  if os.getenv('MD2ADOC_MATH') then io.stderr:write('MATH ', key, ' ', (tex:gsub('\n', ' ')), '\n') end
  return tex
end

-- 行內的 <sup>/<sub>（例如「10<sup>18</sup> wei」）改成上下標；writer 會把原始 HTML 直接丟掉
local HTML_SCRIPT = { sup = pandoc.Superscript, sub = pandoc.Subscript }

local function join_scripts(inlines)
  local out = pandoc.List()
  local i = 1
  while i <= #inlines do
    local el = inlines[i]
    local tag = el.t == 'RawInline' and el.format == 'html' and el.text:match('^<(%a+)>$')
    if tag and HTML_SCRIPT[tag] then
      local body = pandoc.List()
      local j = i + 1
      while j <= #inlines and not (inlines[j].t == 'RawInline' and inlines[j].text == '</' .. tag .. '>') do
        body:insert(inlines[j])
        j = j + 1
      end
      if j > #inlines then error('沒有結束的 <' .. tag .. '>') end
      out:insert(HTML_SCRIPT[tag](body))
      i = j + 1
    else
      out:insert(el)
      i = i + 1
    end
  end
  return out
end

-- 其他原始 HTML 一律報錯，不讓內容被靜默丟掉
local function reject_html(el)
  if el.format == 'html' then
    error('不支援的原始 HTML：' .. el.text:sub(1, 60) .. '（請在 filter.lua 加上處理）')
  end
end

-- 行內的 MathML 被拆成一連串 RawInline 標籤與 Str，這裡把它們接回完整的 <math>…</math>
local function join_inline_math(inlines)
  local out = pandoc.List()
  local i = 1
  while i <= #inlines do
    local el = inlines[i]
    if el.t == 'RawInline' and el.format == 'html' and el.text:match('^<math[%s>]') then
      local buf = {}
      local j = i
      while j <= #inlines do
        local x = inlines[j]
        if x.t == 'RawInline' then buf[#buf + 1] = x.text
        elseif x.t == 'Space' then buf[#buf + 1] = ' '
        elseif x.t == 'SoftBreak' or x.t == 'LineBreak' then buf[#buf + 1] = '\n'
        else buf[#buf + 1] = stringify(x) end
        if x.t == 'RawInline' and x.text:match('^</math>') then break end
        j = j + 1
      end
      out:insert(pandoc.Math('InlineMath', mathml_to_tex(table.concat(buf))))
      i = j + 1
    else
      out:insert(el)
      i = i + 1
    end
  end
  return out
end

-- ---------------------------------------------------------------------------
-- 第 1 輪：結構
-- ---------------------------------------------------------------------------

local ADMONITIONS = { Note = 'note', Tip = 'tip', Warning = 'warning', ['備註'] = 'note', ['提示'] = 'tip', ['警告'] = 'warning' }

-- > **Note** 引言 → 提示區塊。標記後面可能接兩個空白（同一段內換行）或直接換段。
local function admonition(block)
  if block.t ~= 'BlockQuote' or #block.content == 0 then return nil end
  local first = block.content[1]
  if first.t ~= 'Para' or #first.content == 0 or first.content[1].t ~= 'Strong' then return nil end
  local kind = ADMONITIONS[stringify(first.content[1])]
  if not kind then return nil end

  local rest = pandoc.List()
  local tail = pandoc.List()
  for k = 2, #first.content do tail:insert(first.content[k]) end
  while #tail > 0 and (tail[1].t == 'LineBreak' or tail[1].t == 'SoftBreak' or tail[1].t == 'Space') do tail:remove(1) end
  if #tail > 0 then rest:insert(pandoc.Para(tail)) end
  for k = 2, #block.content do rest:insert(block.content[k]) end
  return pandoc.Div(rest, { class = kind })
end

local function structure(blocks)
  local out = pandoc.List()
  local i = 1
  while i <= #blocks do
    local b = blocks[i]
    local nxt = blocks[i + 1]
    local img = lone_image(b)
    local adm = admonition(b)

    if img then
      img.src = img.src:gsub('^%./', '')
      -- 替代文字含逗號時要加引號，否則 Asciidoctor 會把逗號後面當成寬度等參數（第 15 章）
      local alt = stringify(img.caption)
      if alt:find(',') and not alt:find('"') then img.caption = { pandoc.Str('"' .. alt .. '"') } end
      local cap = nxt and caption_inlines(nxt, 'figure', true)
      local caption = cap and { long = { pandoc.Plain(cap) } } or { long = {} }
      out:insert(pandoc.Figure({ pandoc.Plain { img } }, caption))
      i = i + (cap and 2 or 1)
    elseif adm then
      adm.content = structure(adm.content)
      out:insert(adm)
      i = i + 1
    elseif nxt and nxt.t == 'Table' and caption_inlines(b, 'table') then
      nxt.caption = { long = { pandoc.Plain(caption_inlines(b, 'table')) } }
      out:insert(nxt)
      i = i + 2
    elseif nxt and nxt.t == 'CodeBlock' and caption_inlines(b, 'example') then
      -- 範例標題放在 example 區塊上（閱讀器依 .exampleblock > .title 重新編號為「範例 N-M」）；
      -- 標題先當成 Div 的第一個區塊，讓第 2 輪也處理到它，第 3 輪再組成 AsciiDoc
      out:insert(pandoc.Div({ pandoc.Plain(caption_inlines(b, 'example')), nxt }, { class = 'adoc-example' }))
      i = i + 2
    elseif b.t == 'RawBlock' and b.format == 'html' and b.text:match('^%s*<math[%s>]') then
      out:insert(pandoc.Para { pandoc.Math('DisplayMath', mathml_to_tex(b.text)) })
      i = i + 1
    else
      if b.t == 'BlockQuote' then b.content = structure(b.content) end
      out:insert(b)
      i = i + 1
    end
  end
  return out
end

-- ---------------------------------------------------------------------------
-- 第 2 輪：行內（一律非受限寫法）
-- ---------------------------------------------------------------------------

local chapter_ids = {}
local function raw(s) return pandoc.RawInline('asciidoc', s) end

local function wrap(open, content, close)
  local out = pandoc.List { raw(open) }
  out:extend(content)
  out:insert(raw(close))
  return out
end

local SAFE_URL = '^[%w%-%._~:/%?#@!%$&\'%(%)%*%+,;=%%]+$'

local inline_pass = {
  Inlines = function(inlines) return join_scripts(join_inline_math(inlines)) end,
  Emph = function(el) return wrap('__', el.content, '__') end,
  Strong = function(el) return wrap('**', el.content, '**') end,
  Code = function(el)
    -- pass:c 讓內容原樣輸出（只跳脫 HTML 特殊字元），] 必須寫成 \]
    local text = el.text:gsub('%]', '\\]')
    return raw('``pass:c[' .. text .. ']``')
  end,
  Link = function(el)
    local target = el.target:gsub('^%./', '')
    local file, frag = target:match('^([%w_]+%.md)#?(.*)$')
    if file and chapter_ids[file] then
      local id = (frag ~= '' and (chapter_ids[file] .. '-' .. frag)) or chapter_ids[file]
      return wrap('xref:' .. id .. '[', el.content, ']')
    end
    if file then
      -- 指向書外的頁面（例如 intro.md）：只留文字
      return el.content
    end
    local url = el.target
    -- 含 -- 的網址也要包起來，否則 Asciidoctor 會把 -- 換成破折號（oreil.ly/JW--z）
    if not url:match(SAFE_URL) or url:find('--', 1, true) then url = '++' .. url .. '++' end
    if stringify(el.content) == el.target then return raw('link:' .. url .. '[]') end
    return wrap('link:' .. url .. '[', el.content, ']')
  end,
}

-- ---------------------------------------------------------------------------
-- 第 3 輪：標題 ID
-- ---------------------------------------------------------------------------

local CHAPTER_PREFIX = { '^Chapter%s+%d+[%.:]%s*', '^第%s*%d+%s*章[%.:]?%s*' }

local function strip_chapter_prefix(inlines)
  local out = strip_prefix(inlines, CHAPTER_PREFIX)
  if not out then return inlines end
  if #out > 0 and out[1].t == 'Str' then
    local t = out[1].text
    repeat
      local before = t
      t = t:gsub('^　', ''):gsub('^：', '')
    until t == before
    out[1].text = t
    if out[1].text == '' then out:remove(1) end
  end
  return out
end

return {
  {
    Meta = function(meta)
      local overrides = read_json_file(meta_str(meta, 'math_overrides'))
      if overrides then math_overrides = overrides end
      chapter_ids = read_json_file(meta_str(meta, 'chapter_ids')) or {}
    end,
  },
  { Blocks = structure },
  -- 連結文字本身是網址時，gfm 會把它再解析成一個內層連結；先攤平成文字
  { Link = function(el) el.content = el.content:walk({ Link = function(l) return l.content end }) return el end },
  -- 註腳內容在 footnote:[…] 裡。writer 把方括號寫成 ++[++、++]++，Asciidoctor 會把「[…]++…++」
  -- 誤讀成帶角色的行內原樣區段，整個註腳就壞了；改成 [ 照寫、] 寫成 footnote 巨集認得的 \]
  {
    Note = function(el)
      return el:walk({
        Str = function(s)
          if not s.text:find('[%[%]]') then return nil end
          local out = pandoc.List()
          for part, br in s.text:gmatch('([^%[%]]*)([%[%]]?)') do
            if part ~= '' then out:insert(pandoc.Str(part)) end
            if br == '[' then out:insert(raw('[')) elseif br == ']' then out:insert(raw('\\]')) end
          end
          return out
        end,
      })
    end,
  },
  inline_pass,
  { RawInline = reject_html, RawBlock = reject_html },
  {
    Pandoc = function(doc)
      local chapter_id = assert(meta_str(doc.meta, 'chapter_id'), '需要 -M chapter_id=')
      local ids_in = read_json_file(meta_str(doc.meta, 'ids_in'))
      local seen, list, n = {}, {}, 0

      doc = doc:walk({
        Header = function(h)
          n = n + 1
          if h.level == 1 then
            h.content = strip_chapter_prefix(h.content)
          end
          local id
          if ids_in then
            local want = ids_in[n]
            if not want or want.level ~= h.level then
              error(string.format('標題結構與原稿不符：第 %d 個標題（譯稿 %s「%s」，原稿 %s「%s」）',
                n, string.rep('#', h.level), stringify(h.content),
                want and string.rep('#', want.level) or '（無）', want and want.text or ''))
            end
            id = want.id
          else
            id = (h.level == 1) and chapter_id or (chapter_id .. '-' .. h.identifier)
          end
          if seen[id] then error('重複的標題 ID：' .. id) end
          seen[id] = true
          h.identifier = id
          list[#list + 1] = { level = h.level, id = id, text = stringify(h.content) }
          return h
        end,
      })

      if ids_in and #ids_in ~= n then
        error(string.format('標題數量與原稿不符：譯稿 %d 個，原稿 %d 個', n, #ids_in))
      end

      -- 提示區塊交給 writer；範例區塊在這裡組成 AsciiDoc
      doc = doc:walk({
        Div = function(d)
          if d.classes:includes('adoc-example') then
            local opts = { wrap_text = 'none' }
            local title = pandoc.write(pandoc.Pandoc { d.content[1] }, 'asciidoc', opts):gsub('%s+$', '')
            local body = pandoc.write(pandoc.Pandoc { table.unpack(d.content, 2) }, 'asciidoc', opts):gsub('%s+$', '')
            -- 結尾要換行：writer 不會在 RawBlock 後面補換行，下一個標題的錨點會黏在 ==== 後面
            return pandoc.RawBlock('asciidoc', '.' .. title .. '\n====\n' .. body .. '\n====\n')
          end
        end,
      })

      local out = meta_str(doc.meta, 'ids_out')
      if out then
        local f = assert(io.open(out, 'w'))
        f:write(pandoc.json.encode(list))
        f:close()
      end
      io.stderr:write(string.format('MATHCOUNT %d\n', math_count))
      return doc
    end,
  },
}
