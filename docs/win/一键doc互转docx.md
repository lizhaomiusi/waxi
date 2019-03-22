一键将doc互转docx，新建宏

Sub docx2doc() 'docx文件转doc文件

Dim myDialog As FileDialog, oFile As Variant

Set myDialog = Application.FileDialog(msoFileDialogFilePicker)

With myDialog

.Filters.Clear '清除所有文件筛选器中的项目

.Filters.Add "所有 WORD2007 文件", "\*.docx", 1
'增加筛选器的项目为所有WORD2007文件

.AllowMultiSelect = True '允许多项选择

If .Show = -1 Then '确定

For Each oFile In .SelectedItems '在所有选取项目中循环

With Documents.Open(oFile)

.SaveAs FileName:=Replace(oFile, "docx", "doc"), FileFormat:=0

.Close

End With

Next

End If

End With

End Sub

\---

Sub doc2docx() 'doc文件转docx文件

Dim myDialog As FileDialog, oFile As Variant

Set myDialog = Application.FileDialog(msoFileDialogFilePicker)

With myDialog

.Filters.Clear '清除所有文件筛选器中的项目

.Filters.Add "所有 WORD97-2003 文件", "\*.doc", 1
'增加筛选器的项目为所有WORD97-2003文件

.AllowMultiSelect = True '允许多项选择

If .Show = -1 Then '确定

For Each oFile In .SelectedItems '在所有选取项目中循环

With Documents.Open(oFile)

.SaveAs FileName:=Replace(oFile, "doc", "docx"), FileFormat:=12

.Close

End With

Next

End If

End With

End Sub
