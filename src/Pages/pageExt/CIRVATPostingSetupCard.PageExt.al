pageextension 50056 "CIR VAT Posting Setup Card" extends "VAT Posting Setup Card"
{
    layout
    {
        addlast("General")
        {
            field("VAT Label"; Rec."VAT Label")
            {
                ToolTip = 'Specifies the value of the VAT Label', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur pour le libellé TVA"}]}';
                ApplicationArea = All;
            }
        }
    }
}