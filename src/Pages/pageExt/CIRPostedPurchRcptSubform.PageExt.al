pageextension 50094 "CIR Posted Purch Rcpt. Subform" extends "Posted Purchase Rcpt. Subform"
{
    layout
    {
        addafter(Description)
        {
            field(Site; Rec.Site)
            {
                ToolTip = 'Specifies the value of the Site ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Site"}]}';
                ApplicationArea = All;
            }
        }
    }
}