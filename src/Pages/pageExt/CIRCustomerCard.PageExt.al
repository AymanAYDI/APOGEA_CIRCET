pageextension 50021 "CIR Customer Card" extends "Customer Card"
{
    layout
    {
        addafter("IC Partner Code")
        {
            field("Generic Customer No."; Rec."Generic Customer No.")
            {
                ToolTip = 'Specifies the value of the Generic Customer No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° client générique" }, { "lang": "FRB", "txt": "N° client générique" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
            }
            field("Generic Customer Name"; Rec."Generic Customer Name")
            {
                ToolTip = 'Specifies the value of the Generic Customer Name', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Nom client générique" }, { "lang": "FRB", "txt": "Nom client générique" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
            }
        }
        addafter("Responsibility Center")
        {
            field("Doubtful Customer"; Rec."Doubtful Customer")
            {
                ToolTip = 'Specifies the value of the Doubtful Customer', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Douteux" }, { "lang": "FRB", "txt": "Douteux" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
            }
        }
        addafter(Blocked)
        {
            field("Bank Account No."; Rec."Bank Account No.")
            {
                ToolTip = 'Specifies the value of the Bank Account No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° compte banque" }, { "lang": "FRB", "txt": "N° compte banque" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
            }
        }
        addafter("Bill-to Customer No.")
        {

            field("Receipt Slip Mandatory"; Rec."Receipt Slip Mandatory")
            {
                ToolTip = 'Specifies the value of the Receipt Slip Mandatory ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "PV recette obligatoire" }, { "lang": "FRB", "txt": "PV recette obligatoire" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
            }
            field("Paperless Type"; Rec."Paperless Type")
            {
                ToolTip = 'Specifies the value of the Paperless Type ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Type dématérialisation" }, { "lang": "FRB", "txt": "Type dématérialisation" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
            }
        }
        addafter("Salesperson Code")
        {
            field("APE Code"; Rec."APE Code")
            {
                ToolTip = 'Specifies the value of the APE Code ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code APE"}]}';
                ApplicationArea = All;
                Importance = Additional;
            }
            field("Legal Form"; Rec."Legal Form")
            {
                ToolTip = 'Specifies the value of the Legal Form ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Forme juridique"}]}';
                ApplicationArea = All;
                Importance = Additional;
            }
        }
    }
}