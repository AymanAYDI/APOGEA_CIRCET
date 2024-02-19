pageextension 50083 "CIR Apply Vendor Entries" extends "Apply Vendor Entries"
{
    layout
    {
        addafter("Due Date")
        {
            field("Bal. Account Type19184"; Rec."Bal. Account Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bal. Account Type ';
            }
            field("Bal. Account Type20978"; Rec."Bal. Account Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bal. Account Type ';
            }
            field(CountComments; CountComments)
            {
                Caption = 'Comments', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Commentaires"}]}';
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of comments', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Commentaires"}]}';
            }
        }
        addafter(Open)
        {
            field("On Hold88728"; Rec."On Hold")
            {
                ApplicationArea = All;
                Width = 7;
                ToolTip = 'Specifies the value of the On Hold ';
            }
        }
        addafter(Description)
        {
            field("Bal. Account Type97526"; Rec."Bal. Account Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Bal. Account Type ';
            }
        }
        addfirst(FactBoxes)
        {
            systempart(VendorLedgerEntriesNotes; Notes)
            {
                ApplicationArea = Notes;
            }
        }
        moveafter("ApplyingVendLedgEntry.""Document Type"""; "ApplyingVendLedgEntry.""Posting Date""")
        moveafter("Due Date"; Open)
        modify("Currency Code")
        {
            Width = 4;
        }
        modify("Remaining Amount")
        {
            Width = 9;
        }
        modify("CalcApplnRemainingAmount(""Remaining Amount"")")
        {
            Width = 11;
        }
        modify("Amount to Apply")
        {
            Width = 11;
        }
        modify(ApplnAmountToApply)
        {
            Width = 10;
        }
    }

    trigger OnAfterGetRecord()
    begin
        CountComments := GetCountComments();
    end;

    local procedure GetCountComments(): integer
    var
        RecordLink: Record "Record Link";
    begin
        RecordLink.SETRANGE("Record ID", rec.RECORDID());
        EXIT(RecordLink.COUNT());
    end;

    var
        CountComments: Integer;
}