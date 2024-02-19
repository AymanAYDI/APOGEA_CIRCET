pageextension 50077 "CIR Purch. Invoice Subform" extends "Purch. Invoice Subform"
{
    layout
    {
        addafter("Tax Area Code")
        {
            field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
            {
                ApplicationArea = All;
                Width = 8;
                ToolTip = 'Specifies the value of the Gen. Prod. Posting Group ';
            }
            field("VAT Prod. Posting Group99165"; Rec."VAT Prod. Posting Group")
            {
                ApplicationArea = All;
                Width = 7;
                ToolTip = 'Specifies the value of the VAT Prod. Posting Group ';
            }
        }
        modify("Line Amount")
        {
            Editable = false;
        }
    }
}