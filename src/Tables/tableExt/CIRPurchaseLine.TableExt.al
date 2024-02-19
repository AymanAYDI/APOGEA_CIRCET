/*
Version------Trigramme-------Date------- N° REF   -    Domain : Comments
AC.FAB011       JCO       16/06/2021     F10325        FAB011 : Affectation automatique du code affaire en fonction de l'article
AC.ACH012       JCO       19/07/2021                   ACH012 : gestion des paiements directs
*/
tableextension 50007 "CIR Purchase Line" extends "Purchase Line"
{
    fields
    {
        field(50000; Applicant; Code[20])
        {
            Caption = 'Applicant', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Demandeur" }, { "lang": "FRB", "txt": "Demandeur" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
            TableRelation = Resource."No.";
        }
        field(50001; Site; Text[50])
        {
            Caption = 'Site', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Site" }, { "lang": "FRB", "txt": "Site" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            DataClassification = CustomerContent;
        }
        field(50010; "Accrue"; Boolean)
        {
            Caption = 'Accrue', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"FNP"}]}';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                ControlChangeAccrue();
            end;
        }
        field(50020; "Line Weight"; Decimal)
        {
            Caption = 'Line Weight', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Poids ligne"}]}';
            DataClassification = CustomerContent;
            DecimalPlaces = 0 : 5;
            MinValue = 0;
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
            begin
                if Type = Type::Item then
                    if Item.Get("No.") then begin
                        if ((Item."Business Code by Default")) and (GeneralApplicationSetup.Get()) then begin
                            GeneralApplicationSetup.TestField("Location Code");
                            GeneralApplicationSetup.TESTFIELD("Default ShorCut Dim. 3 Code");
                            Validate("Location Code", GeneralApplicationSetup."Location Code");
                            ValidateShortcutDimCode(3, GeneralApplicationSetup."Default ShorCut Dim. 3 Code");
                        end;
                        "Net Weight" := Item."Net Weight";
                    end;
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            var
                Item: Record Item;
            begin
                if Type = Type::Item then
                    if Item.Get("No.") then
                        "Line Weight" := Item."Net Weight" * Quantity;
            end;
        }
    }

    trigger OnInsert()
    begin
        InsertDefautShortCutDim3Code();
        checkAccrue();
    end;

    trigger OnModify()
    begin
        InsertDefautShortCutDim3Code();
    end;

    local procedure InsertDefautShortCutDim3Code()
        Item: Record Item;
    begin
        if ((rec."No." <> xRec."No.") and (rec."No." <> '')) then
            If (Rec.Type = rec.Type::Item) then begin
                Item.GET("No.");
                If Item."Business Code by Default" THEN BEGIN
                    GetGeneralApplicationSetup();
                    GeneralApplicationSetup.TESTFIELD("Default ShorCut Dim. 3 Code");
                    ValidateShortcutDimCode(3, GeneralApplicationSetup."Default ShorCut Dim. 3 Code");
                END;
            end;
    end;

    local procedure GetGeneralApplicationSetup()
    begin
        GeneralApplicationSetup.GET();
    end;

    local procedure checkAccrue()
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseHeader.GET(rec."Document Type", rec."Document No.");
        rec."Accrue" := PurchaseHeader."Direct Customer Payment";
    end;

    local procedure ControlChangeAccrue()
    var
        PurchaseHeader: Record "Purchase Header";
        lNotAuthorizedToChangeAccrueErr: Label 'Not change value', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous ne pouvez pas changer la valeur"}]}';
    begin
        TestStatusOpen();
        GeneralApplicationSetup.GET();

        // L'indicateur FNP sur une ligne d'achat ne devrait pas pouvoir être coché hors période de situation
        IF NOT GeneralApplicationSetup."Evaluation Period Situation" THEN
            Error(lNotAuthorizedToChangeAccrueErr);

        // L'indicateur FNP ne devrait pas pouvoir être coché pour une ligne autre que Article d'autant qu'à la sortie de la période de situation le reset de l'indicateur ne se produit que sur les lignes de type Article
        TESTFIELD(Type, Type::Item);

        // L'indicateur FNP ne devrait pas pouvoir être côché pour une ligne réceptionnée intégralement ou partiellement
        TestField("Qty. Received (Base)", 0);

        // Lorsque l'indicateur "Paiement direct client" est coché au niveau de l'entête de la commande achat, il ne devrait pas être possible de décocher l'indicateur FNP sur une ligne
        IF PurchaseHeader.GET("Document Type", "Document No.") THEN
            IF PurchaseHeader."Direct Customer Payment" THEN
                TESTFIELD(Accrue);
    end;

    var
        GeneralApplicationSetup: Record "General Application Setup";
}