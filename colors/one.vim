" Name:    one vim colorscheme
" Author:  Ramzi Akremi
" License: MIT
" Version: 1.1.1-pre

" Global setup =============================================================={{{



map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
map <F9> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

if exists("*<SID>X")
  delf <SID>X
  delf <SID>rgb
  delf <SID>color
  delf <SID>rgb_color
  delf <SID>rgb_level
  delf <SID>rgb_number
  delf <SID>grey_color
  delf <SID>grey_level
  delf <SID>grey_number
endif

hi clear
syntax reset


if exists('g:colors_name')
  unlet g:colors_name
endif
let g:colors_name = 'one'

if !exists('g:one_allow_italics')
  let g:one_allow_italics = 0
endif

if has('gui_running') || &t_Co == 88 || &t_Co == 256
  " functions
  " returns an approximate grey index for the given grey level

  " Utility functions -------------------------------------------------------{{{
  fun <SID>grey_number(x)
    if &t_Co == 88
      if a:x < 23
        return 0
      elseif a:x < 69
        return 1
      elseif a:x < 103
        return 2
      elseif a:x < 127
        return 3
      elseif a:x < 150
        return 4
      elseif a:x < 173
        return 5
      elseif a:x < 196
        return 6
      elseif a:x < 219
        return 7
      elseif a:x < 243
        return 8
      else
        return 9
      endif
    else
      if a:x < 14
        return 0
      else
        let l:n = (a:x - 8) / 10
        let l:m = (a:x - 8) % 10
        if l:m < 5
          return l:n
        else
          return l:n + 1
        endif
      endif
    endif
  endfun

  " returns the actual grey level represented by the grey index
  fun <SID>grey_level(n)
    if &t_Co == 88
      if a:n == 0
        return 0
      elseif a:n == 1
        return 46
      elseif a:n == 2
        return 92
      elseif a:n == 3
        return 115
      elseif a:n == 4
        return 139
      elseif a:n == 5
        return 162
      elseif a:n == 6
        return 185
      elseif a:n == 7
        return 208
      elseif a:n == 8
        return 231
      else
        return 255
      endif
    else
      if a:n == 0
        return 0
      else
        return 8 + (a:n * 10)
      endif
    endif
  endfun

  " returns the palette index for the given grey index
  fun <SID>grey_color(n)
    if &t_Co == 88
      if a:n == 0
        return 16
      elseif a:n == 9
        return 79
      else
        return 79 + a:n
      endif
    else
      if a:n == 0
        return 16
      elseif a:n == 25
        return 231
      else
        return 231 + a:n
      endif
    endif
  endfun

  " returns an approximate color index for the given color level
  fun <SID>rgb_number(x)
    if &t_Co == 88
      if a:x < 69
        return 0
      elseif a:x < 172
        return 1
      elseif a:x < 230
        return 2
      else
        return 3
      endif
    else
      if a:x < 75
        return 0
      else
        let l:n = (a:x - 55) / 40
        let l:m = (a:x - 55) % 40
        if l:m < 20
          return l:n
        else
          return l:n + 1
        endif
      endif
    endif
  endfun

  " returns the actual color level for the given color index
  fun <SID>rgb_level(n)
    if &t_Co == 88
      if a:n == 0
        return 0
      elseif a:n == 1
        return 139
      elseif a:n == 2
        return 205
      else
        return 255
      endif
    else
      if a:n == 0
        return 0
      else
        return 55 + (a:n * 40)
      endif
    endif
  endfun

  " returns the palette index for the given R/G/B color indices
  fun <SID>rgb_color(x, y, z)
    if &t_Co == 88
      return 16 + (a:x * 16) + (a:y * 4) + a:z
    else
      return 16 + (a:x * 36) + (a:y * 6) + a:z
    endif
  endfun

  " returns the palette index to approximate the given R/G/B color levels
  fun <SID>color(r, g, b)
    " get the closest grey
    let l:gx = <SID>grey_number(a:r)
    let l:gy = <SID>grey_number(a:g)
    let l:gz = <SID>grey_number(a:b)

    " get the closest color
    let l:x = <SID>rgb_number(a:r)
    let l:y = <SID>rgb_number(a:g)
    let l:z = <SID>rgb_number(a:b)

    if l:gx == l:gy && l:gy == l:gz
      " there are two possibilities
      let l:dgr = <SID>grey_level(l:gx) - a:r
      let l:dgg = <SID>grey_level(l:gy) - a:g
      let l:dgb = <SID>grey_level(l:gz) - a:b
      let l:dgrey = (l:dgr * l:dgr) + (l:dgg * l:dgg) + (l:dgb * l:dgb)
      let l:dr = <SID>rgb_level(l:gx) - a:r
      let l:dg = <SID>rgb_level(l:gy) - a:g
      let l:db = <SID>rgb_level(l:gz) - a:b
      let l:drgb = (l:dr * l:dr) + (l:dg * l:dg) + (l:db * l:db)
      if l:dgrey < l:drgb
        " use the grey
        return <SID>grey_color(l:gx)
      else
        " use the color
        return <SID>rgb_color(l:x, l:y, l:z)
      endif
    else
      " only one possibility
      return <SID>rgb_color(l:x, l:y, l:z)
    endif
  endfun

  " returns the palette index to approximate the 'rrggbb' hex string
  fun <SID>rgb(rgb)
    let l:r = ('0x' . strpart(a:rgb, 0, 2)) + 0
    let l:g = ('0x' . strpart(a:rgb, 2, 2)) + 0
    let l:b = ('0x' . strpart(a:rgb, 4, 2)) + 0

    return <SID>color(l:r, l:g, l:b)
  endfun

  " sets the highlighting for the given group
  fun <sid>X(group, fg, bg, attr)
    let l:attr = a:attr
    if g:one_allow_italics == 0 && l:attr ==? 'italic'
      let l:attr= 'none'
    endif

    let l:bg = ""
    let l:fg = ""
    let l:decoration = ""

    if a:bg != ''
      let l:bg = " ctermbg=" . a:bg . " guibg=NONE"
    endif

    if a:fg != ''
      let l:fg = " ctermfg=" . a:fg . " guifg=NONE"
    endif

    if a:attr != ''
      let l:decoration = " gui=" . l:attr . " cterm=" . l:attr
    endif

    let l:exec = l:fg . l:bg . l:decoration

    if l:exec != ''
      exec "hi " . a:group . l:exec
    endif

  endfun

  "}}}



  " Color definition --------------------------------------------------------{{{
  let s:dark = 0
  if &background ==# 'dark'
    let s:dark = 1
    let s:mono_1 = '00'
    let s:mono_2 = '08'
    let s:mono_3 = '07'
    let s:mono_4 = '15'

    let s:syntax_bg     = ''
    let s:syntax_gutter = '08'
    let s:syntax_cursor = '01'

    let s:red            = '01'
    let s:b_red          = '09'
    let s:green          = '02'
    let s:b_green        = '10'
    let s:yellow         = '03'
    let s:b_yellow       = '11'
    let s:blue           = '04'
    let s:b_blue         = '12'
    let s:magenta        = '05'
    let s:b_magenta      = '13'
    let s:cyan           = '06'
    let s:b_cyan         = '14'
    let s:comment = '00'

    let s:hue_1  = '14' " cyan
    let s:hue_2  = '04' " blue
    let s:hue_3  = '13'  " purple
    let s:hue_4  = '10' " green

     let s:hue_5   = '01' " red 1
    let s:hue_5_2 = '09' " red 2

    let s:hue_6   = '03' " orange 1
    let s:hue_6_2 = '11' " orange 2


    let s:syntax_accent = '04'

    let s:vertsplit    = '01'
    let s:special_grey = '08'
    let s:visual_grey  = '01'
    let s:pmenu        = '01'
  else
    let s:syntax_bg     = ''
    let s:syntax_gutter = '08'
    let s:syntax_cursor = '01'

    let s:syntax_accent = '12'
    let s:syntax_accent_2 = '04'

    let s:vertsplit    = '01'
    let s:special_grey = '08'
    let s:visual_grey  = '01'
    let s:pmenu        = '01'
  endif

  let s:syntax_fg = s:mono_4
  let s:syntax_fold_bg = s:mono_3

  "}}}

  " Vim editor color --------------------------------------------------------{{{
  call <sid>X('Normal',       s:syntax_fg,     s:syntax_bg,      '')
  call <sid>X('bold',         '',              '',               'bold')
  call <sid>X('ColorColumn',  '',              s:syntax_cursor,  '')
  call <sid>X('Conceal',      s:mono_4,        s:syntax_bg,      '')
  call <sid>X('Cursor',       '',              s:syntax_accent,  '')
  call <sid>X('CursorIM',     '',              '',               '')
  call <sid>X('CursorColumn', '',              s:syntax_cursor,  '')
  call <sid>X('CursorLine',   '',              s:syntax_cursor,  'none')
  call <sid>X('Directory',    s:hue_2,         '',               '')
  call <sid>X('ErrorMsg',     s:hue_5,         s:syntax_bg,      'none')
  call <sid>X('VertSplit',    s:vertsplit,     '',               'none')
  call <sid>X('Folded',       s:syntax_bg,     s:syntax_fold_bg, 'none')
  call <sid>X('FoldColumn',   s:mono_3,        s:syntax_cursor,  '')
  call <sid>X('IncSearch',    s:hue_6,         '',               '')
  call <sid>X('LineNr',       s:mono_2,        '',               '')
  call <sid>X('CursorLineNr', s:syntax_fg,     s:syntax_cursor,  'none')
  call <sid>X('MatchParen',   s:hue_5,         s:syntax_cursor,  'underline,bold')
  call <sid>X('Italic',       '',              '',               'italic')
  call <sid>X('ModeMsg',      s:syntax_fg,     '',               '')
  call <sid>X('MoreMsg',      s:syntax_fg,     '',               '')
  call <sid>X('NonText',      s:mono_1,        '',               'none')
  call <sid>X('PMenu',        '',              s:pmenu,          '')
  call <sid>X('PMenuSel',     '',              s:mono_4,         '')
  call <sid>X('PMenuSbar',    '',              s:syntax_bg,      '')
  call <sid>X('PMenuThumb',   '',              s:mono_1,         '')
  call <sid>X('Question',     s:hue_2,         '',               '')
  call <sid>X('Search',       s:syntax_bg,     s:hue_6_2,        '')
  call <sid>X('SpecialKey',   s:special_grey,  '',               'none')
  call <sid>X('Whitespace',   s:special_grey,  '',               'none')
  call <sid>X('StatusLine',   s:syntax_fg,     s:syntax_cursor,  'none')
  call <sid>X('StatusLineNC', s:mono_3,        '',               '')
  call <sid>X('TabLine',      s:mono_1,        s:syntax_bg,      '')
  call <sid>X('TabLineFill',  s:mono_3,        s:visual_grey,    'none')
  call <sid>X('TabLineSel',   s:syntax_bg,     s:hue_2,          '')
  call <sid>X('Title',        s:syntax_fg,     '',               'bold')
  call <sid>X('Visual',       '',              s:visual_grey,    '')
  call <sid>X('VisualNOS',    '',              s:visual_grey,    '')
  call <sid>X('WarningMsg',   s:hue_5,         '',               '')
  call <sid>X('TooLong',      s:hue_5,         '',               '')
  call <sid>X('WildMenu',     s:syntax_fg,     s:mono_3,         '')
  call <sid>X('SignColumn',   s:mono_2,        s:syntax_bg,      '')
  call <sid>X('Special',      s:hue_2,         '',               '')
  " }}}

  " Vim Help highlighting ---------------------------------------------------{{{
  call <sid>X('helpCommand',      s:hue_6_2, '', '')
  call <sid>X('helpExample',      s:hue_6_2, '', '')
  call <sid>X('helpHeader',       s:mono_1,  '', 'bold')
  call <sid>X('helpSectionDelim', s:mono_3,  '', '')
  " }}}

  " Standard syntax highlighting --------------------------------------------{{{
  call <sid>X('Comment',        s:comment,        '',          'italic')
  call <sid>X('Constant',       s:red,         '',          '')
  call <sid>X('String',         s:green,         '',          '')
  call <sid>X('Character',      s:green,         '',          '')
  call <sid>X('Number',         s:b_magenta,         '',          '')
  call <sid>X('Boolean',        s:b_magenta,         '',          '')
  call <sid>X('Float',          s:b_magenta,         '',          '')
  call <sid>X('Identifier',     s:red,         '',          'none')
  call <sid>X('Function',       s:blue,         '',          '')
  call <sid>X('Statement',      s:b_blue,         '',          'none')
  call <sid>X('Conditional',    s:b_blue,         '',          '')
  call <sid>X('Repeat',         s:b_blue,         '',          '')
  call <sid>X('Label',          s:b_blue,         '',          '')
  call <sid>X('Operator',       s:b_blue, '',          'none')
  call <sid>X('Keyword',        s:green,         '',          '')
  call <sid>X('Exception',      s:hue_3,         '',          '')
  call <sid>X('PreProc',        s:syntax_fg,       '',          '')
  call <sid>X('Include',        s:hue_2,         '',          '')
  call <sid>X('Define',         s:hue_3,         '',          'none')
  call <sid>X('Macro',          s:hue_3,         '',          '')
  call <sid>X('PreCondit',      s:red,       '',          '')
  call <sid>X('Type',           s:red,       '',          'none')
  call <sid>X('StorageClass',   s:red,       '',          '')
  call <sid>X('Structure',      s:red,       '',          '')
  call <sid>X('Typedef',        s:red,       '',          '')
  call <sid>X('Special',        s:b_magenta,         '',          '')
  call <sid>X('SpecialChar',    s:b_magenta,              '',          '')
  call <sid>X('Noise',    s:mono_2,              '',          '')
  call <sid>X('Tag',            '',              '',          '')
  call <sid>X('Delimiter',      '',              '',          '')
  call <sid>X('SpecialComment', '',              '',          '')
  call <sid>X('Debug',          '',              '',          '')
  call <sid>X('Underlined',     '',              '',          'underline')
  call <sid>X('Ignore',         '',              '',          '')
  call <sid>X('Error',          s:b_red,         s:syntax_bg, 'bold')
  call <sid>X('Todo',           s:b_magenta,         s:syntax_bg, '')
  " }}}

  " Diff highlighting -------------------------------------------------------{{{
  call <sid>X('DiffAdd',     s:hue_4, s:visual_grey, '')
  call <sid>X('DiffChange',  s:hue_6, s:visual_grey, '')
  call <sid>X('DiffDelete',  s:hue_5, s:visual_grey, '')
  call <sid>X('DiffText',    s:hue_2, s:visual_grey, '')
  call <sid>X('DiffAdded',   s:hue_4, s:visual_grey, '')
  call <sid>X('DiffFile',    s:hue_5, s:visual_grey, '')
  call <sid>X('DiffNewFile', s:hue_4, s:visual_grey, '')
  call <sid>X('DiffLine',    s:hue_2, s:visual_grey, '')
  call <sid>X('DiffRemoved', s:hue_5, s:visual_grey, '')
  " }}}

  " Asciidoc highlighting ---------------------------------------------------{{{
  call <sid>X('asciidocListingBlock',   s:mono_2,  '', '')
  " }}}

  " C/C++ highlighting ------------------------------------------------------{{{
  call <sid>X('cInclude',           s:hue_3,  '', '')
  call <sid>X('cPreCondit',         s:hue_3,  '', '')
  call <sid>X('cPreConditMatch',    s:hue_3,  '', '')

  call <sid>X('cType',              s:hue_3,  '', '')
  call <sid>X('cStorageClass',      s:hue_3,  '', '')
  call <sid>X('cStructure',         s:hue_3,  '', '')
  call <sid>X('cOperator',          s:hue_3,  '', '')
  call <sid>X('cStatement',         s:hue_3,  '', '')
  call <sid>X('cTODO',              s:hue_3,  '', '')
  call <sid>X('cConstant',          s:hue_6,  '', '')
  call <sid>X('cSpecial',           s:hue_1,  '', '')
  call <sid>X('cSpecialCharacter',  s:hue_1,  '', '')
  call <sid>X('cString',            s:hue_4,  '', '')

  call <sid>X('cppType',            s:hue_3,  '', '')
  call <sid>X('cppStorageClass',    s:hue_3,  '', '')
  call <sid>X('cppStructure',       s:hue_3,  '', '')
  call <sid>X('cppModifier',        s:hue_3,  '', '')
  call <sid>X('cppOperator',        s:hue_3,  '', '')
  call <sid>X('cppAccess',          s:hue_3,  '', '')
  call <sid>X('cppStatement',       s:hue_3,  '', '')
  call <sid>X('cppConstant',        s:hue_5,  '', '')
  call <sid>X('cCppString',         s:hue_4,  '', '')
  " }}}

  " Cucumber highlighting ---------------------------------------------------{{{
  call <sid>X('cucumberGiven',           s:hue_2,  '', '')
  call <sid>X('cucumberWhen',            s:hue_2,  '', '')
  call <sid>X('cucumberWhenAnd',         s:hue_2,  '', '')
  call <sid>X('cucumberThen',            s:hue_2,  '', '')
  call <sid>X('cucumberThenAnd',         s:hue_2,  '', '')
  call <sid>X('cucumberUnparsed',        s:hue_6,  '', '')
  call <sid>X('cucumberFeature',         s:hue_5,  '', 'bold')
  call <sid>X('cucumberBackground',      s:hue_3,  '', 'bold')
  call <sid>X('cucumberScenario',        s:hue_3,  '', 'bold')
  call <sid>X('cucumberScenarioOutline', s:hue_3,  '', 'bold')
  call <sid>X('cucumberTags',            s:mono_3, '', 'bold')
  call <sid>X('cucumberDelimiter',       s:mono_3, '', 'bold')
  " }}}

  " CSS/Sass highlighting ---------------------------------------------------{{{
  call <sid>X('cssAttrComma',         s:hue_3,  '', '')
  call <sid>X('cssAttributeSelector', s:hue_4,  '', '')
  call <sid>X('cssBraces',            s:mono_2, '', '')
  call <sid>X('cssClassName',         s:hue_6,  '', '')
  call <sid>X('cssClassNameDot',      s:hue_6,  '', '')
  call <sid>X('cssDefinition',        s:hue_3,  '', '')
  call <sid>X('cssFontAttr',          s:hue_6,  '', '')
  call <sid>X('cssFontDescriptor',    s:hue_3,  '', '')
  call <sid>X('cssFunctionName',      s:hue_2,  '', '')
  call <sid>X('cssIdentifier',        s:hue_2,  '', '')
  call <sid>X('cssImportant',         s:hue_3,  '', '')
  call <sid>X('cssInclude',           s:mono_1, '', '')
  call <sid>X('cssIncludeKeyword',    s:hue_3,  '', '')
  call <sid>X('cssMediaType',         s:hue_6,  '', '')
  call <sid>X('cssProp',              s:hue_1,  '', '')
  call <sid>X('cssPseudoClassId',     s:hue_6,  '', '')
  call <sid>X('cssSelectorOp',        s:hue_3,  '', '')
  call <sid>X('cssSelectorOp2',       s:hue_3,  '', '')
  call <sid>X('cssStringQ',           s:hue_4,  '', '')
  call <sid>X('cssStringQQ',          s:hue_4,  '', '')
  call <sid>X('cssTagName',           s:hue_5,  '', '')
  call <sid>X('cssAttr',              s:hue_6,  '', '')

  call <sid>X('sassAmpersand',      s:hue_5,   '', '')
  call <sid>X('sassClass',          s:hue_6_2, '', '')
  call <sid>X('sassControl',        s:hue_3,   '', '')
  call <sid>X('sassExtend',         s:hue_3,   '', '')
  call <sid>X('sassFor',            s:mono_1,  '', '')
  call <sid>X('sassProperty',       s:hue_1,   '', '')
  call <sid>X('sassFunction',       s:hue_1,   '', '')
  call <sid>X('sassId',             s:hue_2,   '', '')
  call <sid>X('sassInclude',        s:hue_3,   '', '')
  call <sid>X('sassMedia',          s:hue_3,   '', '')
  call <sid>X('sassMediaOperators', s:mono_1,  '', '')
  call <sid>X('sassMixin',          s:hue_3,   '', '')
  call <sid>X('sassMixinName',      s:hue_2,   '', '')
  call <sid>X('sassMixing',         s:hue_3,   '', '')

  call <sid>X('scssSelectorName',   s:hue_6_2, '', '')
  " }}}

  " Elixir highlighting------------------------------------------------------{{{
  hi link elixirModuleDefine Define
  call <sid>X('elixirAlias',             s:hue_6_2, '', '')
  call <sid>X('elixirAtom',              s:hue_1,   '', '')
  call <sid>X('elixirBlockDefinition',   s:hue_3,   '', '')
  call <sid>X('elixirModuleDeclaration', s:hue_6,   '', '')
  call <sid>X('elixirInclude',           s:hue_5,   '', '')
  call <sid>X('elixirOperator',          s:hue_6,   '', '')
  " }}}

  " Git and git related plugins highlighting --------------------------------{{{
  call <sid>X('gitcommitComment',       s:comment,  '', '')
  call <sid>X('gitcommitUnmerged',      s:hue_4,   '', '')
  call <sid>X('gitcommitOnBranch',      '',        '', '')
  call <sid>X('gitcommitBranch',        s:hue_3,   '', '')
  call <sid>X('gitcommitDiscardedType', s:hue_5,   '', '')
  call <sid>X('gitcommitSelectedType',  s:hue_4,   '', '')
  call <sid>X('gitcommitHeader',        '',        '', '')
  call <sid>X('gitcommitUntrackedFile', s:hue_1,   '', '')
  call <sid>X('gitcommitDiscardedFile', s:hue_5,   '', '')
  call <sid>X('gitcommitSelectedFile',  s:hue_4,   '', '')
  call <sid>X('gitcommitUnmergedFile',  s:hue_6_2, '', '')
  call <sid>X('gitcommitFile',          '',        '', '')
  hi link gitcommitNoBranch       gitcommitBranch
  hi link gitcommitUntracked      gitcommitComment
  hi link gitcommitDiscarded      gitcommitComment
  hi link gitcommitSelected       gitcommitComment
  hi link gitcommitDiscardedArrow gitcommitDiscardedFile
  hi link gitcommitSelectedArrow  gitcommitSelectedFile
  hi link gitcommitUnmergedArrow  gitcommitUnmergedFile

  call <sid>X('SignifySignAdd',    s:hue_4,   '', '')
  call <sid>X('SignifySignChange', s:hue_6_2, '', '')
  call <sid>X('SignifySignDelete', s:hue_5,   '', '')
  hi link GitGutterAdd    SignifySignAdd
  hi link GitGutterChange SignifySignChange
  hi link GitGutterDelete SignifySignDelete
  call <sid>X('diffAdded',         s:hue_4,   '', '')
  call <sid>X('diffRemoved',       s:hue_5,   '', '')
  " }}}

  " Go highlighting ---------------------------------------------------------{{{
  call <sid>X('goDeclaration',         s:hue_3, '', '')
  call <sid>X('goField',               s:hue_5, '', '')
  call <sid>X('goMethod',              s:hue_1, '', '')
  call <sid>X('goType',                s:hue_3, '', '')
  call <sid>X('goUnsignedInts',        s:hue_1, '', '')
  " }}}

  " HTML highlighting -------------------------------------------------------{{{
  call <sid>X('htmlArg',            s:hue_6,  '', '')
  call <sid>X('htmlTagName',        s:hue_5,  '', '')
  call <sid>X('htmlTagN',           s:hue_5,  '', '')
  call <sid>X('htmlSpecialTagName', s:hue_5,  '', '')
  call <sid>X('htmlTag',            s:mono_2, '', '')
  call <sid>X('htmlEndTag',         s:mono_2, '', '')

  call <sid>X('MatchTag',   s:hue_5,         s:syntax_cursor,  'underline,bold')
  " }}}

  " JavaScript highlighting -------------------------------------------------{{{
  call <sid>X('coffeeString',           s:hue_4,   '', '')
  call <sid>X('javaScriptBraces',       s:mono_2,  '', '')
  call <sid>X('javascriptDotNotation',  s:mono_2,   '', '')
  
  
  call <sid>X('javascriptFuncCall',     s:b_green,   '', '')
  call <sid>X('javaScriptFunction',     s:red,   '', '')
  call <sid>X('javaScriptIdentifier',   s:hue_3,   '', '')
  call <sid>X('javaScriptNull',         s:b_magenta,   '', '')
  call <sid>X('javaScriptNumber',       s:b_magenta,   '', '')
  call <sid>X('javaScriptRequire',      s:hue_1,   '', '')
  call <sid>X('javaScriptReserved',     s:hue_3,   '', '')
  
  " https://github.com/pangloss/vim-javascript
  call <sid>X('jsNoise',                s:mono_2,  '', '')
  call <sid>X('jsArrowFunction',        s:hue_3,   '', '')
  call <sid>X('jsBraces',               s:mono_2,  '', '')
  call <sid>X('jsBrackets',             s:mono_2,  '', '')
  call <sid>X('jsParens',               s:mono_2,  '', '')
  call <sid>X('javascriptParens',       s:mono_2,  '', '')
  call <sid>X('jsObjectColon',          s:mono_2,  '', '')
  call <sid>X('jsClassBraces',          s:mono_2,  '', '')
  call <sid>X('jsClassKeywords',        s:hue_3,   '', '')
  call <sid>X('jsDocParam',             s:hue_2,   '', '')
  call <sid>X('jsDocTags',              s:hue_3,   '', '')
  call <sid>X('jsFuncBraces',           s:mono_2,  '', '')
  call <sid>X('jsFuncCall',             s:b_green,   '', '')
  call <sid>X('jsFuncArgs',           s:yellow,  '', '')
  call <sid>X('jsFuncParens',           s:mono_2,  '', '')
  call <sid>X('jsFunction',             s:red,   '', '')
  call <sid>X('jsGlobalObjects',        s:yellow, '', '')
  call <sid>X('jsIfElseBraces',         s:mono_2, '', '')
  call <sid>X('jsModuleWords',          s:hue_3,   '', '')
  call <sid>X('jsModules',              s:hue_3,   '', '')
  call <sid>X('jsNoise',                s:mono_2,  '', '')
   call <sid>X('jsReturn',                s:b_cyan,  '', '')
  call <sid>X('jsRegexpGroup',          s:syntax_fg,  '', '')
  call <sid>X('jsRegexpCharClass',          s:mono_2,  '', '')
call <sid>X('jsRegexpString',          s:red,  '', '') 
 call <sid>X('jsSpecial',          s:b_blue,  '', '')
 
  call <sid>X('jsNull',                 s:b_magenta,   '', '')
  call <sid>X('jsOperator',             s:b_blue,   '', '')
  call <sid>X('jsParens',               s:mono_2,  '', '')
  call <sid>X('jsStorageClass',         s:red,   '', '')
  call <sid>X('jsTemplateBraces',       s:red, '', '')
  call <sid>X('jsThis',                 s:magenta,   '', '')
  call <sid>X('jsUndefined',            s:b_magenta,   '', '')
  " https://github.com/othree/yajs.vim
  call <sid>X('jsArrowFunction',    s:red,   '', '')
  call <sid>X('javascriptBraces',    s:mono_2,   '', '')
  call <sid>X('javascriptBrackets',    s:mono_2,   '', '')
  call <sid>X('javascriptParen',    s:mono_2,   '', '')
  call <sid>X('javascriptEndColons',    s:mono_2,   '', '')
  call <sid>X('javascriptClassExtends', s:b_red,   '', '')
  call <sid>X('javascriptClassKeyword', s:red,   '', '')
  call <sid>X('javascriptRegexpString ', s:b_red,   '', '')
  "call <sid>X('javascriptDocNotation',  s:hue_3,   '', '')
  "call <sid>X('javascriptDocParamName', s:yellow,   '', '')
  "call <sid>X('javascriptDocTags',      s:hue_3,   '', '')
  "call <sid>X('javascriptEndColons',    s:mono_3,  '', '')
  "call <sid>X('javascriptExport',       s:hue_3,   '', '')
  call <sid>X('javascriptFuncArg',      s:yellow,  '', '')
  call <sid>X('javascriptFuncKeyword',  s:red,   '', '')
  call <sid>X('javascriptIdentifier',   s:magenta,   '', '')
  "call <sid>X('javascriptImport',       s:hue_3,   '', '')
  "call <sid>X('javascriptObjectLabel',  s:mono_1,  '', '')
  call <sid>X('javascriptOpSymbol',     s:b_blue,   '', '')
  call <sid>X('javascriptOpSymbols',    s:b_blue,   '', '')
  call <sid>X('javascriptPropertyName', s:hue_4,   '', '')
  "call <sid>X('javascriptTemplateSB',   s:hue_5_2, '', '')
  "call <sid>X('javascriptVariable',     s:hue_3,   '', '')
  call <sid>X('javascriptFuncCall',     s:b_green,   '', '')

  " }}}

  " JSON highlighting -------------------------------------------------------{{{
  call <sid>X('jsonCommentError',         s:mono_1,  '', ''        )
  call <sid>X('jsonKeyword',              s:hue_5,   '', ''        )
  call <sid>X('jsonQuote',                s:mono_3,  '', ''        )
  call <sid>X('jsonTrailingCommaError',   s:hue_5,   '', 'reverse' )
  call <sid>X('jsonMissingCommaError',    s:hue_5,   '', 'reverse' )
  call <sid>X('jsonNoQuotesError',        s:hue_5,   '', 'reverse' )
  call <sid>X('jsonNumError',             s:hue_5,   '', 'reverse' )
  call <sid>X('jsonString',               s:hue_4,   '', ''        )
  call <sid>X('jsonBoolean',              s:hue_3,   '', ''        )
  call <sid>X('jsonNumber',               s:b_magenta,   '', ''        )
  call <sid>X('jsonStringSQError',        s:hue_5,   '', 'reverse' )
  call <sid>X('jsonSemicolonError',       s:hue_5,   '', 'reverse' )
  " }}}

  " Markdown highlighting ---------------------------------------------------{{{
  call <sid>X('markdownUrl',              s:mono_3,  '', '')
  call <sid>X('markdownBold',             s:hue_6,   '', 'bold')
  call <sid>X('markdownItalic',           s:hue_6,   '', 'bold')
  call <sid>X('markdownCode',             s:hue_4,   '', '')
  call <sid>X('markdownCodeBlock',        s:hue_5,   '', '')
  call <sid>X('markdownCodeDelimiter',    s:hue_4,   '', '')
  call <sid>X('markdownHeadingDelimiter', s:hue_5_2, '', '')
  call <sid>X('markdownH1',               s:hue_5,   '', '')
  call <sid>X('markdownH2',               s:hue_5,   '', '')
  call <sid>X('markdownH3',               s:hue_5,   '', '')
  call <sid>X('markdownH3',               s:hue_5,   '', '')
  call <sid>X('markdownH4',               s:hue_5,   '', '')
  call <sid>X('markdownH5',               s:hue_5,   '', '')
  call <sid>X('markdownH6',               s:hue_5,   '', '')
  call <sid>X('markdownListMarker',       s:hue_5,   '', '')
  " }}}

  " PHP highlighting --------------------------------------------------------{{{
  call <sid>X('phpClass',        s:hue_6_2, '', '')
  call <sid>X('phpFunction',     s:hue_2,   '', '')
  call <sid>X('phpFunctions',    s:hue_2,   '', '')
  call <sid>X('phpInclude',      s:hue_3,   '', '')
  call <sid>X('phpKeyword',      s:hue_3,   '', '')
  call <sid>X('phpParent',       s:mono_3,  '', '')
  call <sid>X('phpType',         s:hue_3,   '', '')
  call <sid>X('phpSuperGlobals', s:hue_5,   '', '')
  " }}}

  " Pug (Formerly Jade) highlighting ----------------------------------------{{{
  call <sid>X('pugAttributesDelimiter',   s:hue_6,    '', '')
  call <sid>X('pugClass',                 s:hue_6,    '', '')
  call <sid>X('pugDocType',               s:mono_3,   '', 'italic')
  call <sid>X('pugTag',                   s:hue_5,    '', '')
  " }}}

  " PureScript highlighting -------------------------------------------------{{{
  call <sid>X('purescriptKeyword',          s:hue_3,     '', '')
  call <sid>X('purescriptModuleName',       s:syntax_fg, '', '')
  call <sid>X('purescriptIdentifier',       s:syntax_fg, '', '')
  call <sid>X('purescriptType',             s:hue_6_2,   '', '')
  call <sid>X('purescriptTypeVar',          s:hue_5,     '', '')
  call <sid>X('purescriptConstructor',      s:hue_5,     '', '')
  call <sid>X('purescriptOperator',         s:syntax_fg, '', '')
  " }}}

  " Python highlighting -----------------------------------------------------{{{
  call <sid>X('pythonImport',               s:hue_3,     '', '')
  call <sid>X('pythonBuiltin',              s:hue_1,     '', '')
  call <sid>X('pythonStatement',            s:hue_3,     '', '')
  call <sid>X('pythonParam',                s:hue_6,     '', '')
  call <sid>X('pythonEscape',               s:hue_5,     '', '')
  call <sid>X('pythonSelf',                 s:mono_2,    '', 'italic')
  call <sid>X('pythonClass',                s:hue_2,     '', '')
  call <sid>X('pythonOperator',             s:hue_3,     '', '')
  call <sid>X('pythonEscape',               s:hue_5,     '', '')
  call <sid>X('pythonFunction',             s:hue_2,     '', '')
  call <sid>X('pythonKeyword',              s:hue_2,     '', '')
  call <sid>X('pythonModule',               s:hue_3,     '', '')
  call <sid>X('pythonStringDelimiter',      s:hue_4,     '', '')
  call <sid>X('pythonSymbol',               s:hue_1,     '', '')
  " }}}

  " Ruby highlighting -------------------------------------------------------{{{
  call <sid>X('rubyBlock',                     s:hue_3,   '', '')
  call <sid>X('rubyBlockParameter',            s:hue_5,   '', '')
  call <sid>X('rubyBlockParameterList',        s:hue_5,   '', '')
  call <sid>X('rubyCapitalizedMethod',         s:hue_3,   '', '')
  call <sid>X('rubyClass',                     s:hue_3,   '', '')
  call <sid>X('rubyConstant',                  s:hue_6_2, '', '')
  call <sid>X('rubyControl',                   s:hue_3,   '', '')
  call <sid>X('rubyDefine',                    s:hue_3,   '', '')
  call <sid>X('rubyEscape',                    s:hue_5,   '', '')
  call <sid>X('rubyFunction',                  s:hue_2,   '', '')
  call <sid>X('rubyGlobalVariable',            s:hue_5,   '', '')
  call <sid>X('rubyInclude',                   s:hue_2,   '', '')
  call <sid>X('rubyIncluderubyGlobalVariable', s:hue_5,   '', '')
  call <sid>X('rubyInstanceVariable',          s:hue_5,   '', '')
  call <sid>X('rubyInterpolation',             s:hue_1,   '', '')
  call <sid>X('rubyInterpolationDelimiter',    s:hue_5,   '', '')
  call <sid>X('rubyKeyword',                   s:hue_2,   '', '')
  call <sid>X('rubyModule',                    s:hue_3,   '', '')
  call <sid>X('rubyPseudoVariable',            s:hue_5,   '', '')
  call <sid>X('rubyRegexp',                    s:hue_1,   '', '')
  call <sid>X('rubyRegexpDelimiter',           s:hue_1,   '', '')
  call <sid>X('rubyStringDelimiter',           s:hue_4,   '', '')
  call <sid>X('rubySymbol',                    s:hue_1,   '', '')
  " }}}

  " Spelling highlighting ---------------------------------------------------{{{
  call <sid>X('SpellBad',     '', s:syntax_bg, 'undercurl')
  call <sid>X('SpellLocal',   '', s:syntax_bg, 'undercurl')
  call <sid>X('SpellCap',     '', s:syntax_bg, 'undercurl')
  call <sid>X('SpellRare',    '', s:syntax_bg, 'undercurl')
  " }}}

  " Vim highlighting --------------------------------------------------------{{{
  call <sid>X('vimCommand',      s:red,  '', '')
  call <sid>X('vimCommentTitle', s:comment, '', 'bold')
  call <sid>X('vimFunction',     s:b_red,  '', '')
  call <sid>X('vimFuncName',     s:blue,  '', '')
  call <sid>X('vimHighlight',    s:hue_2,  '', '')
  call <sid>X('vimLineComment',  s:comment, '', 'italic')
  call <sid>X('vimParenSep',     s:mono_2, '', '')
  call <sid>X('vimSep',          s:mono_2, '', '')
  call <sid>X('vimUserFunc',     s:hue_1,  '', '')
  call <sid>X('vimVar',          s:hue_5,  '', '')
  " }}}

  " XML highlighting --------------------------------------------------------{{{
  call <sid>X('xmlAttrib',  s:hue_6_2, '', '')
  call <sid>X('xmlEndTag',  s:hue_5,   '', '')
  call <sid>X('xmlTag',     s:hue_5,   '', '')
  call <sid>X('xmlTagName', s:hue_5,   '', '')
  " }}}

  " ZSH highlighting --------------------------------------------------------{{{
  call <sid>X('zshCommands',     s:syntax_fg, '', '')
  call <sid>X('zshDeref',        s:hue_5,     '', '')
  call <sid>X('zshShortDeref',   s:hue_5,     '', '')
  call <sid>X('zshFunction',     s:hue_1,     '', '')
  call <sid>X('zshKeyword',      s:hue_3,     '', '')
  call <sid>X('zshSubst',        s:hue_5,     '', '')
  call <sid>X('zshSubstDelim',   s:mono_3,    '', '')
  call <sid>X('zshTypes',        s:hue_3,     '', '')
  call <sid>X('zshVariableDef',  s:hue_6,     '', '')
  " }}}

  " Rust highlighting -------------------------------------------------------{{{
  call <sid>X('rustExternCrate',          s:hue_5,    '', 'bold')
  call <sid>X('rustIdentifier',           s:hue_2,    '', '')
  call <sid>X('rustDeriveTrait',          s:hue_4,    '', '')
  call <sid>X('SpecialComment',           s:comment,    '', '')
  call <sid>X('rustCommentLine',          s:comment,    '', '')
  call <sid>X('rustCommentLineDoc',       s:comment,    '', '')
  call <sid>X('rustCommentLineDocError',  s:comment,    '', '')
  call <sid>X('rustCommentBlock',         s:comment,    '', '')
  call <sid>X('rustCommentBlockDoc',      s:comment,    '', '')
  call <sid>X('rustCommentBlockDocError', s:comment,    '', '')
  " }}}

  " man highlighting --------------------------------------------------------{{{
  hi link manTitle String
  call <sid>X('manFooter', s:mono_3, '', '')
  " }}}

  " Neovim Terminal Colors --------------------------------------------------{{{
  let g:terminal_color_0  = "#48483e"
  let g:terminal_color_8  = "#75715e"
  let g:terminal_color_1  = "#dc2566"
  let g:terminal_color_9  = "#fa2772"
  let g:terminal_color_2  = "#8fc029"
  let g:terminal_color_10 = "#a7e22e"
  let g:terminal_color_3  = "#ffa827"
  let g:terminal_color_11 = "#e6db74"
  let g:terminal_color_4  = "#55bcce"
  let g:terminal_color_12 = "#66d9ee"
  let g:terminal_color_5  = "#9358fe"
  let g:terminal_color_13 = "#ae82ff"
  let g:terminal_color_6  = "#56b7a5"
  let g:terminal_color_14 = "#66efd5"
  let g:terminal_color_7  = "#cfcfc2"
  let g:terminal_color_15 = "#f8f8f2"
  "}}}

  " ALE (Asynchronous Lint Engine) highlighting -----------------------------{{{
  call <sid>X('ALEWarningSign', s:hue_6_2, '', '')
  call <sid>X('ALEErrorSign', s:hue_5,   '', '')
  " }}}

  " Delete functions =========================================================={{{
  " delf <SID>X
  " delf <SID>rgb
  " delf <SID>color
  " delf <SID>rgb_color
  " delf <SID>rgb_level
  " delf <SID>rgb_number
  " delf <SID>grey_color
  " delf <SID>grey_level
  " delf <SID>grey_number
  "}}}

endif
"}}}
" Public API --------------------------------------------------------------{{{
function! one#highlight(group, fg, bg, attr)
  call <sid>X(a:group, a:fg, a:bg, a:attr)
endfunction
"}}}

if s:dark
  set background=dark
endif

" vim: set fdl=0 fdm=marker:
