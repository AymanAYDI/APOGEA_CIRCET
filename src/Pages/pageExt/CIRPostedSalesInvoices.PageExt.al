pageextension 50022 "CIR Posted Sales Invoices" extends "Posted Sales Invoices"
{
    layout
    {
        addlast(Control1)
        {
            field("Reminder Level Max"; Rec."Reminder Level Max")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the max reminder level if the Type field contains Reminder', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie le max niveau relance si le champ Type contient Relance." }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            }
            field("Dimension Value"; Rec."Dimension Value")
            {
                ToolTip = 'Specifies the value of the Dimension Value ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° Affaire"}]}';
                ApplicationArea = All;
            }
            field("Dimension Value Name"; Rec."Dimension Value Name")
            {
                ToolTip = 'Specifies the value of the Dimension Value Name ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom Affaire"}]}';
                ApplicationArea = All;
            }
        }
        addafter("Sell-to Customer Name")
        {
            field(ARBVRNJobNo; Rec.ARBVRNJobNo)
            {
                ToolTip = 'Specifies the number of the related job.';
                ApplicationArea = All;
            }
        }
        modify("Posting Date")
        {
            Visible = true;
        }
        modify("Shortcut Dimension 1 Code")
        {
            Visible = true;
        }
    }
}