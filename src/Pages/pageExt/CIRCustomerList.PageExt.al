pageextension 50020 "CIR Customer List" extends "Customer List"
{
    layout
    {
        addfirst(Control1)
        {
            field("Generic Customer No."; Rec."Generic Customer No.")
            {
                ToolTip = 'Specifies the value of the Generic Customer No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° client générique" }, { "lang": "FRB", "txt": "N° client générique" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
                Visible = false;
            }
            field("Generic Customer Name"; Rec."Generic Customer Name")
            {
                ToolTip = 'Specifies the value of the Generic Customer Name', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Nom client générique" }, { "lang": "FRB", "txt": "Nom client générique" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
                Visible = false;
            }
        }
        addafter("Country/Region Code")
        {
            field("Doubtful Customer"; Rec."Doubtful Customer")
            {
                ToolTip = 'Specifies the value of the Doubtful Customer', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Douteux" }, { "lang": "FRB", "txt": "Douteux" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
                Visible = false;
            }
        }
        addafter("Search Name")
        {

            field("Paperless Type"; Rec."Paperless Type")
            {
                ToolTip = 'Specifies the value of the Paperless Type ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Type dématérialisation" }, { "lang": "FRB", "txt": "Type dématérialisation" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
            }
            field("Receipt Slip Mandatory"; Rec."Receipt Slip Mandatory")
            {
                ToolTip = 'Specifies the value of the Receipt Slip Mandatory ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "PV recette obligatoire" }, { "lang": "FRB", "txt": "PV recette obligatoire" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
            }
        }
        modify("No.")
        {
            Style = Strong;
            StyleExpr = BooGBold;
        }
        modify(Name)
        {
            Style = Strong;
            StyleExpr = BooGBold;
        }
    }
    trigger OnOpenPage()
    var
    begin
        // Reset de l'indicateur d'activation du filtre figé sur les clients génériques.
        genericCustomerFilter := FALSE;

        // Mise en place du filtre figé sur les clients génériques
        IF genericCustomerFilter THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Generic Customer", TRUE);
            Rec.FILTERGROUP(0);
        END;

        // Exclusion de l'affichage des clients qui ne doivent pas être exploités en production.
        //SETRANGE("Blocage Pour Production",FALSE);
        IF NOT genericCustomerFilter THEN
            Rec.SETRANGE(Blocked, Rec.Blocked::" ");

        OnFormat();
    end;

    procedure ShowGenericCustomerOnly()
    begin
        genericCustomerFilter := true;
    end;

    local procedure OnFormat()
    begin
        // Affichage en gras du numéro d'un client générique et décalage de
        // l'affichage du numéro d'un client rattaché à un client générique
        // lorsque la clef de tri est "N° client générique,Client générique,
        //                  N°" dans l'ordre décroissant.
        IF (Rec.CURRENTKEY() = 'Generic Customer No., Generic Customer') AND
           (Rec.ASCENDING() = FALSE) AND
           (Rec."Generic Customer No." <> '') THEN
            IF Rec."Generic Customer" THEN
                BooGBold := TRUE;
    end;

    var
        genericCustomerFilter: Boolean;
        BooGBold: Boolean;
}