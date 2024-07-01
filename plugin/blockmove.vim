
nnoremap <silent> <Plug>MoveLineUp      :<C-u>call blockmove#move_line('up', 'n')<CR>
vnoremap <silent> <Plug>MoveLineUp      :<C-u>call blockmove#move_line('up', 'v')<CR>
nnoremap <silent> <Plug>MoveLineDown    :<C-u>call blockmove#move_line('down', 'n')<CR>
vnoremap <silent> <Plug>MoveLineDown    :<C-u>call blockmove#move_line('down', 'v')<CR>

vnoremap <silent> <Plug>MoveBlockUp     :call blockmove#move_block('up')<CR>
vnoremap <silent> <Plug>MoveBlockDown   :call blockmove#move_block('down')<CR>
vnoremap <silent> <Plug>MoveBlockLeft   :call blockmove#move_block('left')<CR>
vnoremap <silent> <Plug>MoveBlockRight  :call blockmove#move_block('right')<CR>

