SetTitleMatchMode, 2
#IfWinActive likaciICO
Loop, %0%
{
	Gui, Destroy
	Path:=%A_Index%
	i=1
	icoName:=object()
	Loop, %Path%\*.ico { ;枚举ico，存入数组iconame
		Gui, Add, Picture, h50 w50,%Path%\%A_LoopFileName%
		icoName%i%:=A_LoopFileName
		i+=1
	}
	Loop, %Path%\*.exe { ;枚举exe，存入数组iconame
		Gui, Add, Picture, h50 w50,%Path%\%A_LoopFileName%
		icoName%i%:=A_LoopFileName
		i+=1
	}
	StringSplit, PathName, Path, \ ;分割路径，获取文件夹名字作为标题、长标题
	Title=% PathName%PathName0%
	LongTitle :=Title . "likaciICO"
	If i=1 ;没有ico或exe
	{
		TrayTip,失败 %Title%,没有发现*.exe或*.ico,1000,3
		continue
	}
	If i=2 ;有一个exe或ico 
	{
		gosub LabelOnlyOneICO
		continue
	}
	;有多个exe或ico,创建Gui供选择
	Gui, +ToolWindow
	Gui, Show, ,%LongTitle%
	WinWaitClose,%LongTitle%
}
FileSetAttrib,-HSR,%userprofile%\AppData\Local\IconCache.db
FileDelete,%userprofile%\AppData\Local\IconCache.db
FileSetAttrib,-HSR,%userprofile%\AppData\Local\Microsoft\Windows\Explorer\*
FileDelete, %userprofile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_32.db
FileDelete, %userprofile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_96.db
FileDelete, %userprofile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_102.db
FileDelete, %userprofile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_256.db
FileDelete, %userprofile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_1024.db
FileDelete, %userprofile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_idx.db
FileDelete, %userprofile%\AppData\Local\Microsoft\Windows\Explorer\thumbcache_sr.db
RegDelete, 
TrayTip,完成,全部操作已经完成,1000,1
Sleep 1000
ExitApp

~LButton::
LabelOnlyOneICO:
MouseGetPos, x, y
y:=y-24
;TrayTip, , %x% %y%
If (i=2)OR(x>0 AND x<74) {
	if (i<>2) {
		i:=y/56
		i:=Ceil(i)
	}
	else
		i=1
	ico=% icoName%i%
	;msgbox %i% %ico%
	FileSetAttrib, +R,%Path%,2
	FileDelete, %Path%\desktop.ini
	FileAppend,
	(
[.ShellClassInfo]
InfoTip=by likaci
IconFile=%ico%
IconIndex=0
 
	),%Path%\desktop.ini,
	FileSetAttrib, +SH,%Path%\desktop.ini,1
	file.Close()
	;FileAppend,likaci,%Path%\NoUse
	;FileDelete,%Path%\NoUse
TrayTip,成功 %Title%,设置图标为%ico%,1000,1
Gui, Destroy
}
Return

GuiClose:
ExitApp
