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
        if !filereadable(loc_entry['filename'])
            let loc_entry['bufnr'] = bufnr("%")
            let text_list = getbufline(loc_entry['bufnr'], loc_entry['lnum'])
            let loc_entry['text'] .= " ".text_list[0]
        else
            let loc_entry['text'] .= " ".getbufline(loc_entry['filename'], loc_entry['lnum'])[0]
        endif
        call add(loc_entries, loc_entry)
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
