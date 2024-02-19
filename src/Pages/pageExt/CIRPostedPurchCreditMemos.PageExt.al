pageextension 50063 "CIR Posted Purch. Credit Memos" extends "Posted Purchase Credit Memos"
{
    layout
    {
        addafter("No.")
        {
            field("Vendor Cr. Memo No."; Rec."Vendor Cr. Memo No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Cr. Memo No. ';
            }
        }

        addlast(Control1)
        {
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = ALL;
                Editable = false;
                ToolTip = 'Specifies the value of the User ID', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code utilisateur"}]}';
            }
            field("ITESOFT User ID"; Rec."ITESOFT User ID")
            {
                ApplicationArea = ALL;
                Editable = false;
                ToolTip = 'Specifies the value of the ITESOFT User ID', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code utilisateur ITESOFT"}]}';
            }
        }
    }
}