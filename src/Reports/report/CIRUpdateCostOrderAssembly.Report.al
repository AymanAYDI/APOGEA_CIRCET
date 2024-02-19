report 50008 "CIR Update Cost Order Assembly"
{
    Caption = 'Update Cost Order Assembly', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"MAJ coût Ordre d''assemblage NV"}]}';
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(AssemblyHeader; "Assembly Header")
        {
            trigger OnPreDataItem()
            begin
                CountOA := 0;
                nbrOA := Count;
                ProgressDlg.OPEN(UpdateAssmbLbl);
            end;

            trigger OnAfterGetRecord()
            var
                AssemblyLine: Record "Assembly Line";
                GeneralApplicationSetup: Record "General Application Setup";
                Item: Record Item;
            begin
                CountOA += 1;
                ProgressDlg.Update(1, ROUND(10000 * CountOA / nbrOA, 1));
                AssemblyLine.Reset();
                AssemblyLine.SetCurrentKey("Document Type", "Document No.", Type, "Location Code");
                AssemblyLine.SetRange("Document Type", AssemblyHeader."Document Type");
                AssemblyLine.SetRange("Document No.", AssemblyHeader."No.");
                AssemblyLine.SetRange(Type, AssemblyLine.Type::Item);
                AssemblyLine.SetFilter("No.", '<>%1', '');

                if not AssemblyLine.IsEmpty() then begin
                    AssemblyLine.FindSet();
                    repeat
                        Item.Reset();
                        if (Item.Get(AssemblyLine."No.")) and (GeneralApplicationSetup.Get()) then
                            if (GeneralApplicationSetup."Item Category Code" <> '') and
                               (Item."Item Category Code" <> GeneralApplicationSetup."Item Category Code") then
                                AssemblyLine.UpdateUnitCost();
                    until AssemblyLine.Next() = 0;
                end;
                AssemblyHeader.UpdateUnitCost();
            end;

            trigger OnPostDataItem()
            begin
                ProgressDlg.Close();
            end;
        }
    }
    var
        ProgressDlg: Dialog;
        CountOA: Integer;
        nbrOA: Integer;
        UpdateAssmbLbl: Label 'Update of assembly order costs @1@', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Actualisation des coûts des ordres d''assemblages @1@"}]}';
}