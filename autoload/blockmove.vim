" Author: Hanley Lee
" Website: https://www.hanleylee.com
" GitHub: https://github.com/hanleylee
" License:  MIT License

" TODO: add `move_count` arg
" 必须通过传入 mode 方式, 否则在方法内拿到的 mode() 永远是 'n'
function! blockmove#move_line(direction, mode) range
    let move_count = max([0, v:count - 1])
    if a:direction == 'up'
        let dest_line_num = a:firstline - move_count - 2
    else
        let dest_line_num = a:lastline + move_count + 1
    endif

    " :5,7m 21
    execute a:firstline . ',' . a:lastline . 'm' . dest_line_num

    if a:mode == 'v'
        normal! gv
    endif
endfunction

" direct: `up`, `down`, `left`, `right`
function! blockmove#move_block(direct) range
    let l:visual_lines = [line("'<"), line("'>")]
    let l:visual_cols = [virtcol("'<"), virtcol("'>")]

    let l:visual_start_line = min(l:visual_lines)
    let l:visual_end_line = max(l:visual_lines)
    let l:visual_start_col = min(l:visual_cols)
    let l:visual_end_col = max(l:visual_cols)

    if (l:visual_start_line <= 1 && a:direct == 'up')
                \ || (l:visual_end_line >= line('$') && a:direct == 'down')
                \ || (l:visual_start_col <= 1 && a:direct == 'left')
        " \ || (l:visual_end_col >= col('$') - 1 && a:direct == 'right')
        echom 'out of range'
        call setpos("'<", [bufnr(), l:visual_start_line, visual_start_col, 0])
        call setpos("'>", [bufnr(), l:visual_end_line, visual_end_col, 0])

        normal! gv
        return
    endif

    let l:visual_width = l:visual_end_col - l:visual_start_col + 1
    let l:visual_lines_count = l:visual_end_line - l:visual_start_line + 1

    " let move_count = max([0, v:count - 1])

    let l:replace_start_line = a:direct == 'up' ? l:visual_start_line - 1 : l:visual_start_line
    let l:replace_end_line = a:direct == 'down' ? l:visual_end_line + 1 : l:visual_end_line
    let l:replace_start_col = a:direct == 'left' ? l:visual_start_col - 1 : l:visual_start_col
    let l:replace_end_col = a:direct == 'right' ? l:visual_end_col + 1 : l:visual_end_col
    let l:replace_width = l:replace_end_col - l:replace_start_col + 1

    let full_replace_part = []

    " construct replace part str {{{
    for line in range(l:replace_start_line, l:replace_end_line)
        let part = strpart(getline(line), l:replace_start_col - 1, l:replace_width)
        call add(full_replace_part, part)
    endfor
    " }}}

    if a:direct == 'up'
        let full_replace_part = blockmove#utils#MoveLastMToFront(full_replace_part, l:visual_lines_count)
    elseif a:direct == 'down'
        let full_replace_part = blockmove#utils#MoveFirstMToEnd(full_replace_part, l:visual_lines_count)
    elseif a:direct == 'left'
        let full_replace_part = map(full_replace_part, 'blockmove#utils#MoveLastMCharsToFront(v:val, l:visual_width)')
    elseif a:direct == 'right'
        let full_replace_part = map(full_replace_part, 'blockmove#utils#MoveFirstMCharsToEnd(v:val, l:visual_width)')
    else
        echoerr 'direct is wrong!'
    endif

    " set new content {{{
    for line in range(l:replace_start_line, l:replace_end_line)
        let before = strpart(getline(line), 0, l:replace_start_col - 1)
        let before = blockmove#utils#PadString(before, l:replace_start_col - 1, 'left')
        let between = full_replace_part[line - l:replace_start_line]
        let between = blockmove#utils#PadString(between, l:replace_width, 'right')
        let after = strpart(getline(line), l:replace_start_col + l:replace_width - 1)
        call setline(line, before . between . after)
    endfor
    " }}}

    " set new selection area {{{
    let new_visual_start_line = a:direct == 'up' ? l:visual_start_line - 1 : (a:direct == 'down' ? l:visual_start_line + 1 : l:visual_start_line)
    let new_visual_end_line = a:direct == 'up' ? l:visual_end_line - 1 : (a:direct == 'down' ? l:visual_end_line + 1 : l:visual_end_line)
    let new_visual_start_col = a:direct == 'left' ? l:visual_start_col - 1 : (a:direct == 'right' ? l:visual_start_col + 1 : l:visual_start_col)
    let new_visual_end_col = a:direct == 'left' ? l:visual_end_col - 1 : (a:direct == 'right' ? l:visual_end_col + 1 : l:visual_end_col)
    call setpos("'<", [bufnr(), new_visual_start_line, new_visual_start_col, 0])
    call setpos("'>", [bufnr(), new_visual_end_line, new_visual_end_col, 0])
    normal! gv
    " }}}
endfunction

