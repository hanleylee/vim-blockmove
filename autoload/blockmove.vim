" Author: Hanley Lee
" Website: https://www.hanleylee.com
" GitHub: https://github.com/hanleylee
" License:  MIT License

" 必须通过传入 mode 方式, 否则在方法内拿到的 mode() 永远是 'n'
function! blockmove#move_line(direction, mode)
    if a:mode == 'n'
        let start_line = line('.')
        let end_line = line('.')
    elseif a:mode == 'v'
        let l:visual_lines = [line("'<"), line("'>")]

        let start_line = min(l:visual_lines)
        let end_line = max(l:visual_lines)
    endif


    let move_count = max([0, v:count - 1])
    if a:direction == 'up'
        let dest_line_num = start_line - move_count - 2
    else
        let dest_line_num = end_line + move_count + 1
    endif

    " echom dest_line_num
    " :5,7m 21
    execute start_line . ',' . end_line . 'm' . dest_line_num

    if a:mode == 'v'
        normal! gv
    endif
endfunction

" direct: `up`, `down`, `left`, `right`
function! blockmove#move_block(direct) range
    let l:visual_lines = [line("'<"), line("'>")]
    let l:char_cols = [charcol("'<"), charcol("'>")]
    let l:visual_byte_cols = [col("'<"), col("'>")]

    let l:visual_start_line = min(l:visual_lines)
    let l:visual_end_line = max(l:visual_lines)
    let l:char_start_col = min(l:char_cols)
    let l:char_end_col = max(l:char_cols)

    if (l:visual_start_line <= 1 && a:direct == 'up')
                \ || (l:visual_end_line >= line('$') && a:direct == 'down')
                \ || (l:char_start_col <= 1 && a:direct == 'left')
        " \ || (l:char_end_col >= col('$') - 1 && a:direct == 'right')
        echom 'out of range'
        call setpos("'<", [bufnr(), l:visual_start_line, l:char_start_col, 0])
        call setpos("'>", [bufnr(), l:visual_end_line, l:char_start_col, 0])

        normal! gv
        return
    endif

    let l:visual_width = l:char_end_col - l:char_start_col + 1
    let l:visual_lines_count = l:visual_end_line - l:visual_start_line + 1

    " let move_count = max([0, v:count - 1])

    let l:replace_start_line = a:direct == 'up' ? l:visual_start_line - 1 : l:visual_start_line
    let l:replace_end_line = a:direct == 'down' ? l:visual_end_line + 1 : l:visual_end_line
    let l:replace_start_col = a:direct == 'left' ? l:char_start_col - 1 : l:char_start_col
    let l:replace_end_col = a:direct == 'right' ? l:char_end_col + 1 : l:char_end_col
    let l:replace_width = l:replace_end_col - l:replace_start_col + 1

    let full_replace_part = []

    " construct replace part str {{{
    for line in range(l:replace_start_line, l:replace_end_line)
        let part = strcharpart(getline(line), l:replace_start_col - 1, l:replace_width)
        call add(full_replace_part, part)
    endfor
    " }}}

    " echom full_replace_part
    if a:direct == 'up'
        let full_replace_part = blockmove#utils#MoveLastMToFront(full_replace_part, l:visual_lines_count)
    elseif a:direct == 'down'
        let full_replace_part = blockmove#utils#MoveFirstMToEnd(full_replace_part, l:visual_lines_count)
    elseif a:direct == 'left'
        let full_replace_part = map(full_replace_part, 'blockmove#utils#MoveLastMCharsToFront(v:val, l:visual_width)')
    elseif a:direct == 'right'
        " echom l:visual_width
        let full_replace_part = map(full_replace_part, 'blockmove#utils#MoveFirstMCharsToEnd(v:val, l:visual_width)')
        " echom full_replace_part
    else
        echoerr 'direct is wrong!'
    endif

    " set new content {{{
    for line in range(l:replace_start_line, l:replace_end_line)
        let before = strcharpart(getline(line), 0, l:replace_start_col - 1)
        let before = blockmove#utils#PadString(before, l:replace_start_col - 1, 'left')
        let between = full_replace_part[line - l:replace_start_line]
        let between = blockmove#utils#PadString(between, l:replace_width, 'right')
        let after = strcharpart(getline(line), l:replace_start_col + l:replace_width - 1)
        call setline(line, before . between . after)
    endfor
    " }}}

    " set new selection area {{{

    let l:visual_start_line = min(l:visual_lines)
    let l:visual_end_line = max(l:visual_lines)
    let l:visual_byte_start_col = min(l:visual_byte_cols)
    let l:visual_byte_end_col = max(l:visual_byte_cols)
    let l:new_visual_start_line = a:direct == 'up' ? l:visual_start_line - 1 : (a:direct == 'down' ? l:visual_start_line + 1 : l:visual_start_line)
    let l:new_visual_end_line = a:direct == 'up' ? l:visual_end_line - 1 : (a:direct == 'down' ? l:visual_end_line + 1 : l:visual_end_line)
    let l:new_visual_start_col = a:direct == 'left' ? l:visual_byte_start_col - 1 : (a:direct == 'right' ? l:visual_byte_start_col + 1 : l:visual_byte_start_col)
    let l:new_visual_end_col = a:direct == 'left' ? l:visual_byte_end_col - 1 : (a:direct == 'right' ? l:visual_byte_end_col + 1 : l:visual_byte_end_col)
    " echom 'visual_start_col: ' . l:visual_start_col
    " echom 'new_visual_start_col: ' . new_visual_start_col
    " echom 'visual_end_col: ' . l:visual_end_col
    " echom 'new_visual_end_col: ' . new_visual_end_col
    call setpos("'<", [bufnr(), l:new_visual_start_line, l:new_visual_start_col, 0])
    call setpos("'>", [bufnr(), l:new_visual_end_line, l:new_visual_end_col, 0])
    normal! gv
    " }}}
endfunction

