源vim-test插件：https://github.com/vim-test/vim-test

本插件在vim-test上进行修改，可连接前端插件的服务来调用mocha测试工具

使用插件需要在自己的vim配置里面新增下面配置，还需要配合前端的包（还未发部）
``````````js

function! ConnectMocha() 
	try 
		if has('nvim')
			let g:channel = sockconnect('tcp', '127.0.0.1:40123')
		else
			let g:channel = ch_open('localhost:40123')
		endif

		echom "服务器连接成功"
	catch
		echom "服务端连接失败, 请开启服务"
	finally
	endtry
endfunction



nmap <space>cnm :call ConnectMocha()<cr>

function! SendMsg(message)
    try
		if has('nvim')
			let abc = chansend(g:channel, a:message)
		else
			let abc = ch_evalexpr(g:channel, a:message)
		endif
    catch
        echo 'error'
    finally
    endtry
endfunction


```
