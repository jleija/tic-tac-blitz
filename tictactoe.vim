let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/projects/tic-tac-toe
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +13 src/App.svelte
badd +10 src/lib/Counter.svelte
badd +12 src/lib/pocketbase.ts
badd +0 src/lib/Login.svelte
badd +0 src/lib/TicTacToe.svelte
badd +1 ~/.config/nvim
badd +1 ~/.config/nvim/lua/jleija/set.lua
badd +0 ~/.config/nvim/lua/jleija/remap.lua
badd +1 ~/projects/pocketbase-hello/main.go
argglobal
%argdel
$argadd src/App.svelte
set stal=2
tabnew +setlocal\ bufhidden=wipe
tabnew +setlocal\ bufhidden=wipe
tabrewind
edit src/App.svelte
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd w
wincmd _ | wincmd |
split
1wincmd k
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe '1resize ' . ((&lines * 30 + 31) / 62)
exe 'vert 1resize ' . ((&columns * 97 + 97) / 195)
exe '2resize ' . ((&lines * 28 + 31) / 62)
exe 'vert 2resize ' . ((&columns * 97 + 97) / 195)
exe '3resize ' . ((&lines * 30 + 31) / 62)
exe 'vert 3resize ' . ((&columns * 97 + 97) / 195)
exe '4resize ' . ((&lines * 28 + 31) / 62)
exe 'vert 4resize ' . ((&columns * 97 + 97) / 195)
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 13 - ((12 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 13
normal! 05|
lcd ~/projects/tic-tac-toe
wincmd w
argglobal
if bufexists(fnamemodify("~/projects/tic-tac-toe/src/lib/TicTacToe.svelte", ":p")) | buffer ~/projects/tic-tac-toe/src/lib/TicTacToe.svelte | else | edit ~/projects/tic-tac-toe/src/lib/TicTacToe.svelte | endif
if &buftype ==# 'terminal'
  silent file ~/projects/tic-tac-toe/src/lib/TicTacToe.svelte
endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 5 - ((4 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 5
normal! 026|
lcd ~/projects/tic-tac-toe
wincmd w
argglobal
if bufexists(fnamemodify("~/projects/tic-tac-toe/src/lib/pocketbase.ts", ":p")) | buffer ~/projects/tic-tac-toe/src/lib/pocketbase.ts | else | edit ~/projects/tic-tac-toe/src/lib/pocketbase.ts | endif
if &buftype ==# 'terminal'
  silent file ~/projects/tic-tac-toe/src/lib/pocketbase.ts
endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 9 - ((8 * winheight(0) + 15) / 30)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 9
normal! 05|
lcd ~/projects/tic-tac-toe
wincmd w
argglobal
if bufexists(fnamemodify("~/projects/tic-tac-toe/src/lib/Login.svelte", ":p")) | buffer ~/projects/tic-tac-toe/src/lib/Login.svelte | else | edit ~/projects/tic-tac-toe/src/lib/Login.svelte | endif
if &buftype ==# 'terminal'
  silent file ~/projects/tic-tac-toe/src/lib/Login.svelte
endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 29 - ((4 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 29
normal! 0
lcd ~/projects/tic-tac-toe
wincmd w
3wincmd w
exe '1resize ' . ((&lines * 30 + 31) / 62)
exe 'vert 1resize ' . ((&columns * 97 + 97) / 195)
exe '2resize ' . ((&lines * 28 + 31) / 62)
exe 'vert 2resize ' . ((&columns * 97 + 97) / 195)
exe '3resize ' . ((&lines * 30 + 31) / 62)
exe 'vert 3resize ' . ((&columns * 97 + 97) / 195)
exe '4resize ' . ((&lines * 28 + 31) / 62)
exe 'vert 4resize ' . ((&columns * 97 + 97) / 195)
tabnext
edit ~/projects/pocketbase-hello/main.go
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe 'vert 1resize ' . ((&columns * 97 + 97) / 195)
exe 'vert 2resize ' . ((&columns * 97 + 97) / 195)
argglobal
balt ~/projects/tic-tac-toe/src/App.svelte
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 26 - ((25 * winheight(0) + 29) / 59)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 26
normal! 014|
lcd ~/projects/tic-tac-toe
wincmd w
argglobal
if bufexists(fnamemodify("~/projects/pocketbase-hello", ":p")) | buffer ~/projects/pocketbase-hello | else | edit ~/projects/pocketbase-hello | endif
if &buftype ==# 'terminal'
  silent file ~/projects/pocketbase-hello
endif
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 10 - ((9 * winheight(0) + 29) / 59)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 10
normal! 0
lcd ~/projects/tic-tac-toe
wincmd w
exe 'vert 1resize ' . ((&columns * 97 + 97) / 195)
exe 'vert 2resize ' . ((&columns * 97 + 97) / 195)
tabnext
edit ~/.config/nvim/lua/jleija/remap.lua
argglobal
setlocal fdm=manual
setlocal fde=0
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=0
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
let &fdl = &fdl
let s:l = 5 - ((4 * winheight(0) + 29) / 59)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 5
normal! 033|
lcd ~/projects/tic-tac-toe
tabnext 1
set stal=1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
