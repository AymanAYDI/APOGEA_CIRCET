pageextension 50034 "CIR Salesperson/Purchaser Card" extends "Salesperson/Purchaser Card"
{
    layout
    {
        addlast(General)
        {
            field("E-Mail Service"; Rec."E-Mail Service")
            {
                ToolTip = 'Specifies the value of the E-mail Service ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Mail Service"}]}';
                ApplicationArea = All;
            }
            field("Fax No."; Rec."Fax No.")
            {
                ToolTip = 'Specifies the value of the Fax No. ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° de fax"}]}';
                ApplicationArea = All;
            }
            field(Salesperson; Rec."Salesperson")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Salesperson', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Vendeur" }]}';
            }
            field(Purchaser; Rec.Purchaser)
            {
                ToolTip = 'Specifies the value of the Purchaser ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Acheteur" }, { "lang": "FRB", "txt": "Acheteur" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast(navigation)
        {
            action(BuyerPreferences)
            {
                ApplicationArea = all;
                Caption = 'Buyer preferences', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Préférences approvisionneur"}]}';
                ToolTip = 'View the buyer preferences that are associated with the salesperson/purchaser', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Afficher les préférences approvisionneur associés au vendeur/acheteur"}]}';
                Image = SalesPerson;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "Buyer Preferences Card";
                RunPageLink = "Code" = FIELD(Code), "Purchaser" = const(true);
            }
        }
    }
}