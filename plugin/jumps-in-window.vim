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
                    \'text': split(line)[0]
                    \}
        call add(loc_entries, loc_entry)
    endfor
    for entry in loc_entries
        if !filereadable(entry['filename'])
            let entry['bufnr'] = bufnr("%")
            let text_list = getbufline(entry['bufnr'], entry['lnum'])
            let entry['text'] .= " ".text_list[0]
        else
            let entry['text'] .= " ".getbufline(entry['filename'], entry['lnum'])[0]
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
