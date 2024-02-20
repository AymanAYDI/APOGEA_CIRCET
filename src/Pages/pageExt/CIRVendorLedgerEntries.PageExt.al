pageextension 50036 "CIR Vendor Ledger Entries" extends "Vendor Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field(CountComments; CountComments)
            {
                Caption = 'Comments', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Commentaires"}]}';
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of comments', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Commentaires"}]}';
            }
        }
        addafter("Document No.")
        {
            field("CIR Document Date"; Rec."Document Date")
            {
                Width = 13;
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Document Date ';
            }
        }
        addfirst(FactBoxes)
        {
            systempart(VendorLedgerEntriesNotes; Notes)
            {
                ApplicationArea = Notes;
            }
        }
        modify("On Hold")
        {
            Width = 6;
        }
        modify("Currency Code")
        {
            Width = 2;
        }
        modify("Payment Method Code")
        {
            Width = 5;
        }
        modify("Debit Amount")
        {
            Width = 7;
        }
        modify("Debit Amount (LCY)")
        {
            Width = 6;
        }
        modify("Credit Amount")
        {
            Width = 7;
        }
        modify("Credit Amount (LCY)")
        {
            Width = 8;
        }
        modify("Remaining Amount")
        {
            Width = 8;
        }
        modify("Remaining Amt. (LCY)")
        {
            Width = 8;
        }
        modify("Original Amount")
        {
            Width = 9;
        }
        modify(Amount)
        {
            Width = 8;
        }
        moveafter("Debit Amount"; "Credit Amount")
        moveafter("Credit Amount"; "Remaining Amount")
        moveafter("Remaining Amount"; "Amount (LCY)")
        moveafter("Remaining Amount"; "Due Date")
        moveafter("Due Date"; Open)
        moveafter(Open; "On Hold")
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