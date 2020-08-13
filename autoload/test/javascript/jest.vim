if !exists('g:test#javascript#jest#file_pattern')
  let g:test#javascript#jest#file_pattern = '\v(__tests__/.*|(spec|test))\.(js|jsx|coffee|ts|tsx)$'
endif

function! test#javascript#jest#test_file(file) abort
  return a:file =~# g:test#javascript#jest#file_pattern
    \ && test#javascript#has_package('jest')
endfunction

function! test#javascript#jest#build_position(type, position) abort
  if a:type ==# 'nearest'
    let name = s:nearest_test(a:position)
    if !empty(name)
      let name = shellescape(name, 1)
      let name = name[2:-3]
    endif
      call SendMsg(["{\"type\":\"title\", \"value\":\"".name."\"}"])
    return [2, ["{\"type\":\"title\", \"value\":\"".name."\"}"]]
    "return ['--no-coverage', name, '--', a:position['file']]
  elseif a:type ==# 'file'
      call SendMsg(["{\"type\":\"file\", \"value\":\"".a:position['file']."\"}"])
      return [2, ["{\"type\":\"file\", \"value\":\"".a:position['file']."\"}"]]
    "return ['--no-coverage', '--', a:position['file']]
  else
      call SendMsg(["{\"type\":\"allfile\"}"])
      return [2, ["{\"type\":\"allfile\"}"]]
  endif
endfunction

let s:yarn_command = '\<yarn\>'
function! test#javascript#jest#build_args(args) abort
  if exists('g:test#javascript#jest#executable')
    \ && g:test#javascript#jest#executable =~# s:yarn_command
    return filter(a:args, 'v:val != "--"')
  else
    return a:args
  endif
endfunction

function! test#javascript#jest#executable() abort
  if filereadable('node_modules/.bin/jest')
    return 'node_modules/.bin/jest'
  else
    return 'jest'
  endif
endfunction

function! s:nearest_test(position) abort
  let name = test#base#nearest_test(a:position, g:test#javascript#patterns)
  return (len(name['namespace']) ? '^' : '') .
       \ test#base#escape_regex(join(name['namespace'] + name['test'])) .
       \ (len(name['test']) ? '$' : '')
endfunction
