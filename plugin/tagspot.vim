" tagspot.vim: Select tag nearby.
"
" Author: Daniel-Constantin Mierla (miconda at gmail dot com)
" Requires:    Vim-7.0+
" Version:     1.0.0
" Licence: This program is free software; you can redistribute it and/or
"          modify it under the terms of the GNU General Public License.
"          See http://www.gnu.org/copyleft/gpl.txt

if exists('g:loaded_tagspot') || &cp || v:version < 700
	finish
endif

let g:loaded_tagspot = '1.0.0' " version number

let s:oldcpo = &cpo
set cpo&vim

"
"
"

" sort function for tags
" - give priority to:
"   - same file
"   - same directory
"   - elsewhere
function! s:TagSpotCompare(t1, t2)
	let crt_file = expand("%:p")  " absolute path to the file
	let crt_dir  = expand("%:p:h")  " absolute path to the directory

	let t1_file = fnamemodify(a:t1.filename, ":p")
	let t1_dir  = fnamemodify(a:t1.filename, ":p:h")

	let t2_file = fnamemodify(a:t2.filename, ":p")
	let t2_dir  = fnamemodify(a:t2.filename, ":p:h")

	if t1_file == t2_file
		return 0
	endif

	if t1_file == crt_file
		return -1
	endif

	if t2_file == crt_file
		return 1
	endif

	if t1_dir == crt_dir
		return -1
	endif

	if t2_dir == crt_dir
		return 1
	endif

	return t1_file == t2_file ? 0 : t1_file > t2_file ? 1 : -1
endfunc

" select the tag for the word under the cursor
function! tagspot#SpotNearbyTag()
	let qflist = []
	" try to find a word under the cursor
	let tagWord = expand("<cword>")

	" check if there is one
	if tagWord == ''
		echomsg "No word under the cursor"
		return
	endif

	" find all tags for the given word
	let tags = taglist('^'.tagWord.'$')

	" if no tags are found, bail out
	if empty(tags)
		echomsg "No tags found for: ".tagWord
		return
	endif

	if len(tags)==1
		exec ":tag ".tagWord
		return
	endif

	" add initial index for each tag in the list
	let idx = 0
	for entry in tags
		let tags[idx].tidx = idx + 1
		let idx = idx + 1
	endfor

	let stags = sort(tags, "s:TagSpotCompare")

	" echo "-----"
	" for entry in stags
	" 	let filename = entry.filename
	" 	let kind = entry.kind
	" 	let tidx = entry.tidx
	" 	echo "----- | ".tidx." | ".kind." | ".filename." |"
	" endfor

	let tagidx = stags[0].tidx

	" trick to select desired tag index - map+exec+unmap
	exec 'nnoremap <Plug>TagSpotSelect :tselect '.tagWord.
				\ '<CR>'.tagidx.'<CR>'
	exec "normal \<Plug>TagSpotSelect"
	" avoid wating for <enter>
	redraw
	nunmap <Plug>TagSpotSelect

endfunction

" wrapper function to map from .vimrc
function! SpotTag()
	return tagspot#SpotNearbyTag()
endfunction

let &cpo = s:oldcpo
unlet s:oldcpo
