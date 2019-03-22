打开WORD，在菜单的“视图”-\>“宏”-\>“查看宏”-\>“创建”

\---

Sub 宏1()

Dim MyFile As String

Dim Arr(1000) As String
'一次处理最大的文件数量，根据需要修改数字1000改为需要处理的数量

Dim count As Integer

MyFile = Dir("F:\\待处理的HTML目录\\" & "\*.html")

count = count + 1

Arr(count) = MyFile

Do While MyFile \<\> ""

MyFile = Dir

If MyFile = "" Then

Exit Do

End If

count = count + 1

Arr(count) = MyFile '将文件的名字存在数组中

Loop

For i = 1 To count

Documents.Open FileName:="F:\\待处理的HTML目录\\" & Arr(i),
ConfirmConversions:=False, ReadOnly:= \_

False, AddToRecentFiles:=False, PasswordDocument:="", PasswordTemplate:= \_

"", Revert:=False, WritePasswordDocument:="", WritePasswordTemplate:="", \_

Format:=wdOpenFormatAuto, XMLTransform:=""

ActiveDocument.SaveAs FileName:="F:\\处理后DOC保存的目录\\" & Replace(Arr(i),
".html", ".doc"), FileFormat:=wdFormatDocument, \_

LockComments:=False, Password:="", AddToRecentFiles:=True, WritePassword \_

:="", ReadOnlyRecommended:=False, EmbedTrueTypeFonts:=False, \_

SaveNativePictureFormat:=False, SaveFormsData:=False, SaveAsAOCELetter:= \_

False

ActiveDocument.Close

Next

End Sub

\---
