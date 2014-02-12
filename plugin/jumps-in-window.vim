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
            let buffer = loc_entry['bufnr']
        else
            let buffer = loc_entry['filename']
        endif
        if bufexists(buffer)
            let loc_entry['text'] .= " ".getbufline(buffer, loc_entry['lnum'])[0]
        else
            let loc_entry['text'] .= " ".buffer
        endif
        call add(loc_entries, loc_entry)
    endfor
    call setloclist(0, loc_entries)
    lopen
endfunction

command Lchanges call CommandOutputToLocationList("changes")
command Ljumps call CommandOutputToLocationList("jumps")
