Attribute VB_Name = "NewMacros"
Sub InsertFormattedEquation()
    Dim tbl As Table
    
    ' Insert a new table
    Selection.Tables.Add Range:=Selection.Range, NumRows:=1, NumColumns:=3
    Set tbl = Selection.Tables(1)
    
    ' Insert a new equation
    tbl.Cell(1, 2).Range.Select
    Selection.TypeText Text:=""
    Set objRange = Selection.Range
    Set objEquation = ActiveDocument.OMaths.Add(objRange)
    
    ' Insert a new reference
    Selection.EndKey Unit:=wdStory
    Selection.TypeParagraph
    Selection.InsertCaption Label:="Equation"
    Selection.HomeKey Unit:=wdLine
    Selection.EndKey Unit:=wdLine, Extend:=True
    Selection.Cut
    tbl.Cell(1, 3).Range.Select
    Selection.Paste
    
    ' Format table
    With tbl
        .PreferredWidthType = wdPreferredWidthPoints
        .PreferredWidth = Selection.Document.PageSetup.PageWidth - _
                         Selection.Document.PageSetup.LeftMargin - _
                         Selection.Document.PageSetup.RightMargin
        
        ' Set column widths
        .Columns(1).PreferredWidth = 50
        .Columns(3).PreferredWidth = 50
        
        ' Remove borders
        .Borders.Enable = False
        
        .Cell(1, 2).Range.ParagraphFormat.Alignment = wdAlignParagraphCenter
        .Cell(1, 2).VerticalAlignment = wdCellAlignVerticalCenter
        .Cell(1, 3).Range.ParagraphFormat.Alignment = wdAlignParagraphRight
        .Cell(1, 3).VerticalAlignment = wdCellAlignVerticalCenter
    End With
         ' Remove equation text
    With tbl.Cell(1, 3).Range
        .MoveStart wdCharacter, 0
        .Find.Text = "Equation "
        If .Find.Execute Then
            .SetRange .Start, .Start + Len("Equation ")
            .Delete
        End If
        .Find.Text = "^p"
        If .Find.Execute Then
            .SetRange .Start, .Start + 1
            .Delete
        End If
     End With
    
    ActiveDocument.Fields.Update
    ' Move cursor back to equation cell
    tbl.Cell(1, 2).Range.Select
End Sub
