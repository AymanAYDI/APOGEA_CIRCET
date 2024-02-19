pageextension 50005 "CIR User Setup" extends "User Setup"
{
    layout
    {
        modify(ARBVRNRelatedResourceNo)
        {
            Caption = 'Resource No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° ressource"}]}';
        }
        modify(ARBVRNRelatedVendorNo)
        {
            Visible = false;
        }
        modify("Salespers./Purch. Code")
        {
            Visible = false;
        }
    }
}