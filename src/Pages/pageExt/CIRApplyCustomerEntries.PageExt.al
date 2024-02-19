pageextension 50073 "CIR Apply Customer Entries" extends "Apply Customer Entries"
{
    layout
    {
        addafter("Remaining Amount")
        {
            field("Last Issued Reminder Level"; Rec."Last Issued Reminder Level")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Last Issued Reminder Level ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie le dernier niveau de relance"}]}';
            }
        }
        addafter(Description)
        {
            field("Comment"; rec.Comment)
            {
                ApplicationArea = All;
                ToolTip = 'Comment', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Commentaire"}]}';
            }
        }
    }
}