function! CommandOutputToLocationList(command)
    redir => l:command_output
    silent execute a:command
    redir END
    let lines = split(l:command_output, '\n')
    let [header, line_info] = [lines[0], lines[1:-2]]
    let loc_entries = []
    for line in line_info
        let split_line = split(line)
        let loc_entry = {
                    \'lnum': split_line[1],
                    \'col': split_line[2],
                    \'text': split_line[0]
                    \}
        if len(split_line) > 3
            let loc_entry['filename'] = split_line[3]
        endif

        if !has_key(loc_entry, 'filename')
            let buffer = ''
        elseif !filereadable(loc_entry['filename'])
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

command! Lchanges call CommandOutputToLocationList("changes")
command! Ljumps call CommandOutputToLocationList("jumps")
