pageextension 50075 "CIR VAT Posting Setup" extends "VAT Posting Setup"
{
    layout
    {
        addlast(Control1)
        {
            field("VAT Label"; Rec."VAT Label")
            {
                ToolTip = 'Specifies the value of the VAT Label', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur pour le libellé TVA"}]}';
                ApplicationArea = All;
            }
        }
    }
}