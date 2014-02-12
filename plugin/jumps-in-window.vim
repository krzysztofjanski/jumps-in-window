function! CommandOutputToLocationList(command)
    redir => l:command_output
    silent execute a:command
    redir END
    let lines = split(l:command_output, '\n')
    let [header, line_info] = [lines[0], lines[1:-2]]
    let loc_entries = []
    for line in line_info
        let loc_entry = {
                    \'filename': split(line)[3],
                    \'lnum': split(line)[1],
                    \'col': split(line)[2],
                    \'text': copy(line)
                    \}
        call add(loc_entries, loc_entry)
    endfor
    for entry in loc_entries
        if !filereadable(entry['filename'])
            "let entry['text'] += entry['filename']
            "let entry['filename'] =  eval("%")
            let entry['bufnr'] = bufnr("%")
        endif
    endfor
    call setloclist(0, loc_entries)
    lopen
endfunction

function! ChangesInLocationList()
    call CommandOutputToLocationList("changes")
endfunction

function! JumpsInLocationList()
    call CommandOutputToLocationList("jumps")
endfunction
