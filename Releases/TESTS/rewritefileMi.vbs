Set objFS = CreateObject("Scripting.FileSystemObject")
strFile = "migracion.sql"
Set objFile = objFS.OpenTextFile(strFile)
strData = objFile.ReadAll
objFile.Close

strData = Replace(strData, vbCrLf, "")

Set objFile = objFS.CreateTextFile(strFile)
objFile.Write strData
objFile.Close

Wscript.Echo "Hecho"
