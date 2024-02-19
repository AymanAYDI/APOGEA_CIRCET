pageextension 50065 "CIR Company Information" extends "Company Information"
{
    layout
    {
        addlast(Payments)
        {
            field("CIR RIB Key"; Rec."CIR RIB Key")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the RIB Key', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Clé banque"}]}';
            }
            field("CIR Agency Code"; Rec."CIR Agency Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Agency Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code guichet"}]}';
            }
        }
        addlast(General)
        {
            field("Manufacturing Mgt."; Rec."Manufacturing Mgt.")
            {
                ApplicationArea = All;
                ToolTip = 'Production management to activate the subcontracting distribution module', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Gestion production pour activer le module de distribution des sous-traitances"}]}';
            }
            field("Legal Text EML"; Rec."Legal Text EML")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Legal Text EML ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Texte loi LME"}]}';
            }
            field("Reverse Charge Text"; Rec."Reverse Charge Text")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Reverse Charge field.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Texte Autoliquidation"}]}';
            }
            field("Email Sales Accounting"; Rec."Email Sales Accounting")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Email Sales Accounting ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"E-mail compta vente"}]}';
            }
        }
    }
}