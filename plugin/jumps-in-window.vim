function! ChangesInLocationList()
    redir => l:jumps_output
    silent execute "changes"
    redir END
    let lines = split(l:jumps_output, '\n')
    let [header, line_info] = [lines[0], lines[1:-2]]
    let loc_entries = map(line_info, "{
                \ 'filename': split(v:val)[3],
                \ 'lnum': split(v:val)[1],
                \ 'col': split(v:val)[2],
                \ 'text': split(v:val)[0]
                \ }"
                \ )
    for entry in loc_entries
        if !filereadable(entry['filename'])
            let entry['text'] += entry['filename']
            "let entry['filename'] =  eval("%")
            let entry['bufnr'] = bufnr("%")
        endif
    endfor
    "if filereadable()
    call setloclist(0, loc_entries)
    lopen
endfunction

function! JumpsInLocationList()
    redir => l:jumps_output
    silent execute "jumps"
    redir END
    let lines = split(l:jumps_output, '\n')
    let [header, line_info] = [lines[0], lines[1:-2]]
    let loc_entries = map(line_info, "{
                \ 'filename': split(v:val)[3],
                \ 'lnum': split(v:val)[1],
                \ 'col': split(v:val)[2],
                \ 'text': split(v:val)[0]
                \ }"
                \ )
    for entry in loc_entries
        if !filereadable(entry['filename'])
            let entry['text'] += entry['filename']
            "let entry['filename'] =  eval("%")
            let entry['bufnr'] = bufnr("%")
        endif
    endfor
    "if filereadable()
    call setloclist(0, loc_entries)
    lopen
endfunction
