let s:cpo_save=&cpo
set cpo&vim
inoremap <silent> <C-T> <Cmd>ToggleTerm
inoremap <silent> <Plug>(table-mode-tableize) |:call tablemode#TableizeInsertMode()a
cnoremap <silent> <Plug>(TelescopeFuzzyCommandSearch) e "lua require('telescope.builtin').command_history { default_text = [=[" . escape(getcmdline(), '"') . "]=] }"
imap <M-Down> <Plug>(copilot-accept-line)
imap <M-Right> <Plug>(copilot-accept-word)
imap <M-Bslash> <Plug>(copilot-suggest)
imap <M-[> <Plug>(copilot-previous)
imap <M-]> <Plug>(copilot-next)
imap <Plug>(copilot-suggest) <Cmd>call copilot#Suggest()
imap <Plug>(copilot-previous) <Cmd>call copilot#Previous()
imap <Plug>(copilot-next) <Cmd>call copilot#Next()
imap <Plug>(copilot-dismiss) <Cmd>call copilot#Dismiss()
inoremap <C-W> u
xnoremap <silent>  <Cmd>lua require('neoscroll').scroll(-vim.fn.winheight(0), true, 450)
nnoremap <silent>  <Cmd>lua require('neoscroll').scroll(-vim.fn.winheight(0), true, 450)
xnoremap <silent>  <Cmd>lua require('neoscroll').scroll(vim.wo.scroll, true, 250)
nnoremap <silent>  <Cmd>lua require('neoscroll').scroll(vim.wo.scroll, true, 250)
xnoremap <silent>  <Cmd>lua require('neoscroll').scroll(0.10, false, 100)
nnoremap <silent>  <Cmd>lua require('neoscroll').scroll(0.10, false, 100)
xnoremap <silent>  <Cmd>lua require('neoscroll').scroll(vim.fn.winheight(0), true, 450)
nnoremap <silent>  <Cmd>lua require('neoscroll').scroll(vim.fn.winheight(0), true, 450)
nnoremap <NL> <Cmd>cprevzz
nnoremap  <Cmd>cnextzz
nnoremap  <Cmd>nohlsearch|diffupdate|normal! 
nnoremap <silent>  <Cmd>BufferPick
nnoremap <silent>  <Cmd>execute v:count . "ToggleTerm"
xnoremap <silent>  <Cmd>lua require('neoscroll').scroll(-vim.wo.scroll, true, 250)
nnoremap <silent>  <Cmd>lua require('neoscroll').scroll(-vim.wo.scroll, true, 250)
xnoremap <silent>  <Cmd>lua require('neoscroll').scroll(-0.10, false, 100)
nnoremap <silent>  <Cmd>lua require('neoscroll').scroll(-0.10, false, 100)
nnoremap  pt :Telescope luasnip
nnoremap  pv :NvimTreeFocus
nnoremap  e :NvimTreeToggle
nnoremap <silent>  bw <Cmd>BufferOrderByWindowNumber
nnoremap <silent>  bl <Cmd>BufferOrderByLanguage
nnoremap <silent>  bd <Cmd>BufferOrderByDirectory
nnoremap <silent>  bb <Cmd>BufferOrderByBufferNumber
nmap  tc :VimtexTocToggle
xmap  T <Plug>(table-mode-tableize-delimiter)
xmap  tt <Plug>(table-mode-tableize)
nmap  tt <Plug>(table-mode-tableize)
nnoremap <silent>  tm :call tablemode#Toggle()
nnoremap  <F5> <Cmd>TermExec cmd='./%:r' ji
nnoremap  mr <Cmd>CellularAutomaton make_it_rain
nnoremap  vpp <Cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua
nnoremap <silent>  x <Cmd>!chmod +x %
nnoremap  s :%s/\<\>//gI<Left><Left><Left>
nnoremap  j <Cmd>lprevzz
nnoremap  k <Cmd>lnextzz
vnoremap  d "_d
nnoremap  d "_d
nnoremap  Y "+Y
vnoremap  y "+y
nnoremap  y "+y
xnoremap  p "_dP
xnoremap # y?\V"
omap <silent> % <Plug>(MatchitOperationForward)
xmap <silent> % <Plug>(MatchitVisualForward)
nmap <silent> % <Plug>(MatchitNormalForward)
nnoremap & :&&
xnoremap * y/\V"
nnoremap J mzJ`z
vnoremap J :m '>+1gv=gv
vnoremap K :m '<-2gv=gv
nnoremap N Nzzzv
nnoremap Q <Nop>
nnoremap Y y$
omap <silent> [% <Plug>(MatchitOperationMultiBackward)
xmap <silent> [% <Plug>(MatchitVisualMultiBackward)
nmap <silent> [% <Plug>(MatchitNormalMultiBackward)
omap <silent> ]% <Plug>(MatchitOperationMultiForward)
xmap <silent> ]% <Plug>(MatchitVisualMultiForward)
nmap <silent> ]% <Plug>(MatchitNormalMultiForward)
xmap a% <Plug>(MatchitVisualTextObject)
xnoremap gb <Plug>(comment_toggle_blockwise_visual)
xnoremap gc <Plug>(comment_toggle_linewise_visual)
nnoremap gb <Plug>(comment_toggle_blockwise)
nnoremap gc <Plug>(comment_toggle_linewise)
xmap gx <Plug>NetrwBrowseXVis
nmap gx <Plug>NetrwBrowseX
omap <silent> g% <Plug>(MatchitOperationBackward)
xmap <silent> g% <Plug>(MatchitVisualBackward)
nmap <silent> g% <Plug>(MatchitNormalBackward)
nnoremap n nzzzv
xnoremap <silent> zb <Cmd>lua require('neoscroll').zb(250)
nnoremap <silent> zb <Cmd>lua require('neoscroll').zb(250)
xnoremap <silent> zt <Cmd>lua require('neoscroll').zt(250)
nnoremap <silent> zt <Cmd>lua require('neoscroll').zt(250)
xnoremap <silent> zz <Cmd>lua require('neoscroll').zz(250)
nnoremap <silent> zz <Cmd>lua require('neoscroll').zz(250)
nnoremap <F5> :let b:caret=winsaveview()  | :%SnipRun | :call winrestview(b:caret) 
nmap <silent> <Plug>SnipLive :lua require'sniprun.live_mode'.toggle()
xnoremap <silent> <C-U> <Cmd>lua require('neoscroll').scroll(-vim.wo.scroll, true, 250)
xnoremap <silent> <C-F> <Cmd>lua require('neoscroll').scroll(vim.fn.winheight(0), true, 450)
xnoremap <silent> <C-D> <Cmd>lua require('neoscroll').scroll(vim.wo.scroll, true, 250)
xnoremap <silent> <C-Y> <Cmd>lua require('neoscroll').scroll(-0.10, false, 100)
nnoremap <silent> <C-Y> <Cmd>lua require('neoscroll').scroll(-0.10, false, 100)
xnoremap <silent> <C-B> <Cmd>lua require('neoscroll').scroll(-vim.fn.winheight(0), true, 450)
nnoremap <silent> <C-B> <Cmd>lua require('neoscroll').scroll(-vim.fn.winheight(0), true, 450)
xnoremap <silent> <C-E> <Cmd>lua require('neoscroll').scroll(0.10, false, 100)
nnoremap <silent> <C-T> <Cmd>execute v:count . "ToggleTerm"
nnoremap <silent> <C-E> <Cmd>lua require('neoscroll').scroll(0.10, false, 100)
nnoremap <silent> <C-P> <Cmd>BufferPick
nnoremap <silent> <M-c> <Cmd>BufferClose
nnoremap <silent> <M-p> <Cmd>BufferPin
nnoremap <silent> <M-0> <Cmd>BufferLast
nnoremap <silent> <M-9> <Cmd>BufferGoto 9
nnoremap <silent> <M-8> <Cmd>BufferGoto 8
nnoremap <silent> <M-7> <Cmd>BufferGoto 7
nnoremap <silent> <M-6> <Cmd>BufferGoto 6
nnoremap <silent> <M-5> <Cmd>BufferGoto 5
nnoremap <silent> <M-4> <Cmd>BufferGoto 4
nnoremap <silent> <M-3> <Cmd>BufferGoto 3
nnoremap <silent> <M-2> <Cmd>BufferGoto 2
nnoremap <silent> <M-1> <Cmd>BufferGoto 1
nnoremap <silent> <M->> <Cmd>BufferMoveNext
nnoremap <silent> <M-lt> <Cmd>BufferMovePrevious
nnoremap <silent> <M-.> <Cmd>BufferNext
nnoremap <silent> <M-,> <Cmd>BufferPrevious
nnoremap <silent> <Plug>(table-mode-sort) :call tablemode#spreadsheet#Sort('')
nnoremap <silent> <Plug>(table-mode-echo-cell) :call tablemode#spreadsheet#EchoCell()
nnoremap <silent> <Plug>(table-mode-eval-formula) :call tablemode#spreadsheet#formula#EvaluateFormulaLine()
nnoremap <silent> <Plug>(table-mode-add-formula) :call tablemode#spreadsheet#formula#Add()
nnoremap <silent> <Plug>(table-mode-insert-column-after) :call tablemode#spreadsheet#InsertColumn(1)
nnoremap <silent> <Plug>(table-mode-insert-column-before) :call tablemode#spreadsheet#InsertColumn(0)
nnoremap <silent> <Plug>(table-mode-delete-column) :call tablemode#spreadsheet#DeleteColumn()
nnoremap <silent> <Plug>(table-mode-delete-row) :call tablemode#spreadsheet#DeleteRow()
xnoremap <silent> <Plug>(table-mode-cell-text-object-i) :call tablemode#spreadsheet#cell#TextObject(1)
xnoremap <silent> <Plug>(table-mode-cell-text-object-a) :call tablemode#spreadsheet#cell#TextObject(0)
onoremap <silent> <Plug>(table-mode-cell-text-object-i) :call tablemode#spreadsheet#cell#TextObject(1)
onoremap <silent> <Plug>(table-mode-cell-text-object-a) :call tablemode#spreadsheet#cell#TextObject(0)
nnoremap <silent> <Plug>(table-mode-motion-right) :call tablemode#spreadsheet#cell#Motion('l')
nnoremap <silent> <Plug>(table-mode-motion-left) :call tablemode#spreadsheet#cell#Motion('h')
nnoremap <silent> <Plug>(table-mode-motion-down) :call tablemode#spreadsheet#cell#Motion('j')
nnoremap <silent> <Plug>(table-mode-motion-up) :call tablemode#spreadsheet#cell#Motion('k')
nnoremap <silent> <Plug>(table-mode-realign) :call tablemode#table#Realign('.')
xnoremap <silent> <Plug>(table-mode-tableize-delimiter) :call tablemode#TableizeByDelimiter()
xnoremap <silent> <Plug>(table-mode-tableize) :Tableize
nnoremap <silent> <Plug>(table-mode-tableize) :Tableize
nmap <silent> <Plug>SnipClose :lua require'sniprun.display'.close_all()
nmap <silent> <Plug>SnipReplMemoryClean :lua require'sniprun'.clear_repl()
nmap <Plug>SnipInfo :lua require'sniprun'.info()
nmap <silent> <Plug>SnipReset :lua require'sniprun'.reset()
nmap <silent> <Plug>SnipRunOperator :set opfunc=SnipRunOperatorg@
nmap <silent> <Plug>SnipRun :lua require'sniprun'.run()
vmap <silent> <Plug>SnipRun :lua require'sniprun'.run('v')
nnoremap <Plug>PlenaryTestFile :lua require('plenary.test_harness').test_file(vim.fn.expand("%:p"))
xnoremap <Plug>(comment_toggle_blockwise_visual) <Cmd>lua require("Comment.api").locked("toggle.blockwise")(vim.fn.visualmode())
xnoremap <Plug>(comment_toggle_linewise_visual) <Cmd>lua require("Comment.api").locked("toggle.linewise")(vim.fn.visualmode())
xnoremap <silent> <Plug>NetrwBrowseXVis :call netrw#BrowseXVis()
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#BrowseX(netrw#GX(),netrw#CheckIfRemote(netrw#GX()))
xmap <silent> <Plug>(MatchitVisualTextObject) <Plug>(MatchitVisualMultiBackward)o<Plug>(MatchitVisualMultiForward)
onoremap <silent> <Plug>(MatchitOperationMultiForward) :call matchit#MultiMatch("W",  "o")
onoremap <silent> <Plug>(MatchitOperationMultiBackward) :call matchit#MultiMatch("bW", "o")
xnoremap <silent> <Plug>(MatchitVisualMultiForward) :call matchit#MultiMatch("W",  "n")m'gv``
xnoremap <silent> <Plug>(MatchitVisualMultiBackward) :call matchit#MultiMatch("bW", "n")m'gv``
nnoremap <silent> <Plug>(MatchitNormalMultiForward) :call matchit#MultiMatch("W",  "n")
nnoremap <silent> <Plug>(MatchitNormalMultiBackward) :call matchit#MultiMatch("bW", "n")
onoremap <silent> <Plug>(MatchitOperationBackward) :call matchit#Match_wrapper('',0,'o')
onoremap <silent> <Plug>(MatchitOperationForward) :call matchit#Match_wrapper('',1,'o')
xnoremap <silent> <Plug>(MatchitVisualBackward) :call matchit#Match_wrapper('',0,'v')m'gv``
xnoremap <silent> <Plug>(MatchitVisualForward) :call matchit#Match_wrapper('',1,'v'):if col("''") != col("$") | exe ":normal! m'" | endifgv``
nnoremap <silent> <Plug>(MatchitNormalBackward) :call matchit#Match_wrapper('',0,'n')
nnoremap <silent> <Plug>(MatchitNormalForward) :call matchit#Match_wrapper('',1,'n')
nnoremap <C-J> <Cmd>cprevzz
nnoremap <C-K> <Cmd>cnextzz
nnoremap <silent> <C-F> <Cmd>lua require('neoscroll').scroll(vim.fn.winheight(0), true, 450)
nnoremap <silent> <C-U> <Cmd>lua require('neoscroll').scroll(-vim.wo.scroll, true, 250)
nnoremap <silent> <C-D> <Cmd>lua require('neoscroll').scroll(vim.wo.scroll, true, 250)
nnoremap <C-L> <Cmd>nohlsearch|diffupdate|normal! 
inoremap <expr>  v:lua.MPairs.completion_confirm()
inoremap <silent>  <Cmd>ToggleTerm
inoremap  u
let &cpo=s:cpo_save
unlet s:cpo_save
set expandtab
set helplang=en
set nohlsearch
set isfname=#,$,%,+,,,-,.,/,48-57,=,@,_,~,@-@
set runtimepath=~/.config/nvim,/etc/xdg/nvim,~/.local/share/nvim/site,~/.local/share/nvim/site/pack/packer/start/packer.nvim,~/.local/share/nvim/site/pack/*/start/*,~/.local/share/flatpak/exports/share/nvim/site,/var/lib/flatpak/exports/share/nvim/site,/usr/local/share/nvim/site,/usr/share/nvim/site,/var/lib/snapd/desktop/nvim/site,/usr/share/nvim/runtime,/usr/share/nvim/runtime/pack/dist/opt/matchit,/usr/lib/nvim,~/.local/share/nvim/site/pack/*/start/*/after,/var/lib/snapd/desktop/nvim/site/after,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,/var/lib/flatpak/exports/share/nvim/site/after,~/.local/share/flatpak/exports/share/nvim/site/after,~/.local/share/nvim/site/after,/etc/xdg/nvim/after,~/.config/nvim/after,/usr/share/vim/vimfiles/
set scrolloff=8
set shiftwidth=2
set showtabline=2
set smartindent
set softtabstop=2
set statusline=%#Normal#
set noswapfile
set tabline=%4@barbar#events#main_click_handler@%#BufferCurrentSign#▎%#BufferCurrent#\ \ \ \ %#DevIconCCurrent#\ %4@barbar#events#main_click_handler@%#BufferCurrent#quiz5-2.c%#BufferCurrent#\ \ \ \ %4@barbar#events#close_click_handler@%#BufferCurrent#\ %4@barbar#events#main_click_handler@%#BufferCurrentSignRight#%#BufferInactiveSign#▎%#BufferTabpageFill#\ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ %0@barbar#events#main_click_handler@%#BufferTabpageFill#
set tabstop=2
set termguicolors
set undodir=~/.vim/undodir
set undofile
set updatetime=50
set window=43
" vim: set ft=vim :
