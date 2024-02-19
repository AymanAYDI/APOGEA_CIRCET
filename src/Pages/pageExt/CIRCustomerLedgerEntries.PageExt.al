pageextension 50037 "CIR Customer Ledger Entries" extends "Customer Ledger Entries"
{
    layout
    {
        addlast(Control1)
        {
            field("Bank Account No."; Rec."Bank Account No.")
            {
                ToolTip = 'Specifies the value of the Bank Account No. ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° compte banque" }, { "lang": "FRB", "txt": "N° compte banque" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
            }
        }
        addafter("Remaining Amt. (LCY)")
        {
            field("Last Issued Reminder Level"; Rec."Last Issued Reminder Level")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Last Issued Reminder Level ';
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
        addafter("Document No.")
        {
            field("Document Date"; Rec."Document Date")
            {
                ToolTip = 'Specifies the value of the Document Date ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur de la date de document"}]}';
                ApplicationArea = All;
            }
        }
        modify("External Document No.")
        {
            Visible = true;
        }
        moveafter("Document No."; "External Document No.")
    }
}