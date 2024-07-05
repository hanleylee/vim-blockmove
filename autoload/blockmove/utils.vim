
function! blockmove#utils#MoveFirstMToEnd(arr, m)
    " 获取数组长度
    let n = len(a:arr)
    " 确保 m 小于或等于数组长度
    if a:m > n
        echoerr "m should be less than or equal to the length of the array"
        return a:arr
    endif

    " 获取前 m 项
    let first_m = a:arr[:a:m-1]
    " 获取后 n-m 项
    let last_n_minus_m = a:arr[a:m:]

    " 返回后 n-m 项在前，前 m 项在后的新数组
    return extend(last_n_minus_m, first_m)
endfunction

function! blockmove#utils#MoveLastMToFront(arr, m)
    " 获取数组长度
    let n = len(a:arr)
    " 确保 m 小于或等于数组长度
    if a:m > n
        echoerr "m should be less than or equal to the length of the array"
        return a:arr
    endif

    " 获取后 m 项
    let last_m = a:arr[-a:m:]
    " 获取前 n-m 项
    let first_n_minus_m = a:arr[:-a:m-1]

    " 返回后 m 项在前，前 n-m 项在后的新数组
    return extend(last_m, first_n_minus_m)
endfunction

function! blockmove#utils#MoveFirstMCharsToEnd(str, m)
    " 获取字符串的长度
    let n = strlen(a:str)

    " 确保 m 小于或等于字符串的长度
    if a:m > n
        echoerr "m should be less than or equal to the length of the string"
        return a:str
    endif

    " 获取前 m 个字符
    let first_m = strcharpart(a:str, 0, a:m)
    " 获取剩余的字符
    let remaining = strcharpart(a:str, a:m)

    " 返回新的字符串
    return remaining . first_m
endfunction

function! blockmove#utils#MoveLastMToFront(arr, m)
    " 获取数组长度
    let n = len(a:arr)
    " 确保 m 小于或等于数组长度
    if a:m > n
        echoerr "m should be less than or equal to the length of the array"
        return a:arr
    endif

    " 获取后 m 项
    let last_m = a:arr[-a:m:]
    " 获取前 n-m 项
    let first_n_minus_m = a:arr[:-a:m-1]

    " 返回后 m 项在前，前 n-m 项在后的新数组
    return extend(last_m, first_n_minus_m)
endfunction

function! blockmove#utils#MoveLastMCharsToFront(str, m)
    " 获取字符串的长度
    let n = strlen(a:str)

    " 确保 m 小于或等于字符串的长度
    if a:m > n
        echoerr "m should be less than or equal to the length of the string"
        return a:str
    endif

    " 获取后 m 个字符
    let last_m = strcharpart(a:str, n - a:m, a:m)
    " 获取前 n-m 个字符
    let first_n_minus_m = strcharpart(a:str, 0, n - a:m)

    " 返回新的字符串
    return last_m . first_n_minus_m
endfunction

function! blockmove#utils#PadString(str, length, align)
    " 获取字符串的当前长度
    let current_length = strlen(a:str)
    " 如果字符串长度小于指定值
    if current_length < a:length
        " 计算需要填充的空格数
        let padding = repeat(' ', a:length - current_length)
        " 将空格填充到字符串尾部
        if a:align == 'left'
            let padded_str = a:str . padding
        elseif a:align == 'right'
            let padded_str = padding . a:str
        else
            echoerr "align direction wrong!"
        endif
    else
        " 如果字符串长度已经大于或等于指定值，直接返回原字符串
        let padded_str = a:str
    endif
    " 返回填充后的字符串
    return padded_str
endfunction

