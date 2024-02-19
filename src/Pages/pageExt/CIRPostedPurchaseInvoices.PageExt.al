pageextension 50071 "CIR Posted Purchase Invoices" extends "Posted Purchase Invoices"
{
    layout
    {
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