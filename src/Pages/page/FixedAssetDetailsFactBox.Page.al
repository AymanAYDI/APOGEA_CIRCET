page 50022 "Fixed Asset Details FactBox"
{
    Caption = 'Fixet Asset Details', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Détails"}]}';
    PageType = CardPart;
    Editable = false;
    SourceTable = "FA Depreciation Book";

    layout
    {
        area(content)
        {
            field("Disposal Date"; Rec."Disposal Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the FA posting date of the first posted disposal amount.';
            }
            field("Acquisition Cost"; Rec."Acquisition Cost")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the total acquisition cost for the fixed asset.';
            }
        }
    }
}