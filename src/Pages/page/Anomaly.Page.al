page 50007 "Anomaly"
{
    Caption = 'Anomaly', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Anomalie"}]}';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Anomaly;

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                field(Code; Rec.Code)
                {
                    ToolTip = 'Specifies the value of the Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie le code"}]}';
                    ApplicationArea = All;
                }
                field(Designation; Rec.Designation)
                {
                    ToolTip = 'Specifies the value of the designation', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur désignation"}]}';
                    ApplicationArea = All;
                }
            }
        }
    }
}