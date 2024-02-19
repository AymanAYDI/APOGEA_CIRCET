xmlport 50000 "Import Purchase Line"
{
    Caption = 'Import Purchase Lines', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Import des lignes d''achat"}]}';
    Direction = Import;
    FieldSeparator = ';';
    Format = VariableText;

    schema
    {
        textelement(root)
        {
            tableelement(Integer; Integer)
            {
                AutoSave = false;
                AutoUpdate = false;
                XmlName = 'Integer';
                SourceTableView = SORTING(Number)
                                  ORDER(Ascending)
                                  WHERE(Number = FILTER(>= 0));
                textelement(inOrderNo)
                {
                }
                textelement(inJobNo)
                {
                }
                textelement(inSite)
                {
                }
                textelement(inExpectedRcptDate)
                {
                }
                textelement(inItem)
                {
                }
                textelement(inDescription)
                {
                }
                textelement(inDescription2)
                {
                }
                textelement(inVendorItemNo)
                {
                }
                textelement(inQuantity)
                {
                }
                textelement(inUnitCost)
                {
                }
                textelement(inApplicant)
                {
                    MinOccurs = Zero;
                }
                textelement(inSuiviPresta)
                {
                    MinOccurs = Zero;
                }
                textelement(inUnit)
                {
                    MinOccurs = Zero;
                }

                trigger OnAfterInitRecord()
                begin
                    // Reset des variables d'import
                    inOrderNo := '';
                    inJobNo := '';
                    inSite := '';
                    inExpectedRcptDate := '';
                    inItem := '';
                    inDescription := '';
                    inDescription2 := '';
                    inVendorItemNo := '';
                    inQuantity := FORMAT(0);
                    inUnitCost := FORMAT(0);
                    inApplicant := '';
                    inSuiviPresta := FORMAT(FALSE);
                    inUnit := '';

                    // Initialisation du type de document et du type d'élément par défaut
                    typeDoc := typeDoc::Order;
                    typeLigne := typeLigne::Item;

                    DecGUnitCost := 0;
                    DecGQuantity := 0;
                    DatGExpectedRcptDate := 0D;
                end;

                trigger OnBeforeInsertRecord()
                var
                    recFixedAsset: Record "Fixed Asset";
                    recFADeprecBook: Record "FA Depreciation Book";
                    svgWorkDate: Date;
                    numLine: Integer;
                    loiAmortissement: Code[10];
                    DimensionValue: Code[20];
                    Text001Lbl: Label 'Line %1: Requested delivery date %2 invalid', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ligne %1 : Date de livraison demandée %2 invalide" }, { "lang": "FRB", "txt": "Ligne %1 : Date de livraison demandée %2 invalide" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    Text002Lbl: Label 'Line %1: Quantity %2 invalid', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ligne %1 : Quantité %2 invalide" }, { "lang": "FRB", "txt": "Ligne %1 : Quantité %2 invalide" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    Text003Lbl: Label 'Line %1: Invalid unit cost %2', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ligne %1 : Coût unitaire %2 invalide" }, { "lang": "FRB", "txt": "Ligne %1 : Coût unitaire %2 invalide" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    Text004Lbl: Label 'Line %1: inconsistent %2 quantity for an asset', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ligne %1 : quantité %2 incohérente pour une immobilisation" }, { "lang": "FRB", "txt": "Ligne %1 : quantité %2 incohérente pour une immobilisation" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    LineOrderdoesntExist_Err: Label 'Line %1 / Order %2 does not exist', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ligne %1 / Commande %2 inexistante" }, { "lang": "FRB", "txt": "Ligne %1 / Commande %2 inexistante" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    MissingProjectForDocument_Err: Label 'Line %1 / No project for document %2', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ligne %1 / Absence de projet pour le document %2" }, { "lang": "FRB", "txt": "Ligne %1 / Absence de projet pour le document %2" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    ProjectDoesntExist_Err: Label 'Line %1: No project %2', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ligne %1 : projet %2 inexistant" }, { "lang": "FRB", "txt": "Ligne %1 : projet %2 inexistant" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    ItemDoesntExist_Err: Label 'Line %1: item %2 does not exist', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ligne %1 : article %2 inexistant" }, { "lang": "FRB", "txt": "Ligne %1 : article %2 inexistant" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    ItemObsolete_Err: Label 'Line %1: item %2 obsolete', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ligne %1 : article %2 obsolète" }, { "lang": "FRB", "txt": "Ligne %1 : article %2 obsolète" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    ItemPuchasedBlocked_Err: Label 'Line %1: Item %2 is blocked in purchased', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ligne %1 : l''article %2 est bloqué en achat" }, { "lang": "FRB", "txt": "Ligne %1 : l''article %2 est bloqué en achat" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    UOMDoesntExistForThisItem_Err: Label 'Line %1: unit %2 does not exist for item %3', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ligne %1 : unité %2 inexistante pour l''article %3" }, { "lang": "FRB", "txt": "Ligne %1 : unité %2 inexistante pour l''article %3" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    ApplicantDoesntExist_Err: Label 'Line %1: no applicant %2', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ligne %1 : demandeur %2 inexistant" }, { "lang": "FRB", "txt": "Ligne %1 : demandeur %2 inexistant" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                begin

                    // Incrémentation du nombre de lignes lues dans le fichier
                    fileLine := fileLine + 1;

                    // Modification réalisée dans le cadre de l'ajout de la gestion de l'import des lignes d'immobilisation

                    loiAmortissement := '';

                    // Test validité du format des paramètres importés

                    // Date de livraison demandée
                    DatGExpectedRcptDate := 0D;
                    IF inExpectedRcptDate <> '' THEN
                        IF NOT EVALUATE(DatGExpectedRcptDate, inExpectedRcptDate) THEN
                            ERROR(Text001Lbl, fileLine, inExpectedRcptDate);

                    // Quantité
                    DecGQuantity := 0;
                    IF inQuantity <> '' THEN
                        IF NOT EVALUATE(DecGQuantity, inQuantity) THEN
                            ERROR(Text002Lbl, fileLine, inQuantity);

                    // Coût unitaire
                    DecGUnitCost := 0;
                    IF inUnitCost <> '' THEN
                        IF NOT EVALUATE(DecGUnitCost, inUnitCost) THEN
                            ERROR(Text003Lbl, fileLine, inUnitCost);

                    // Vérification de la validité des données importées

                    // Test existence de la facture achat à laquelle doit être rattachée la ligne à créer
                    IF recPurchaseHeader.GET(recPurchaseHeader."Document Type"::Invoice, inOrderNo) THEN
                        typeDoc := typeDoc::Invoice;

                    // Test existence de la commande achat à laquelle doit être rattachée la ligne à créer
                    IF typeDoc = typeDoc::Order THEN
                        IF NOT recPurchaseHeader.GET(recPurchaseHeader."Document Type"::Order, inOrderNo) THEN
                            ERROR(LineOrderdoesntExist_Err, fileLine, inOrderNo);

                    // Dans le cas ou la ligne doit être rattachée à une facture achat, test de l'existence du compte comptable
                    IF (inItem <> '') AND (typeDoc = typeDoc::Invoice) THEN
                        IF recGLAccount.GET(inItem) THEN
                            typeLigne := typeLigne::"G/L Account";

                    // Modification réalisée dans le cadre de l'ajout de la gestion de l'import des lignes d'immobilisation
                    IF (inItem <> '') AND (typeLigne = typeLigne::Item) THEN
                        IF recFixedAsset.GET(inItem) THEN BEGIN
                            typeLigne := typeLigne::"Fixed Asset";

                            // Test cohérence de la quantité
                            IF DecGQuantity <> 1 THEN
                                ERROR(Text004Lbl, fileLine, DecGQuantity);

                            // Identificaton de la loi d'amortissement associée à l'immobilisation
                            recFADeprecBook.RESET();
                            recFADeprecBook.SETRANGE("FA No.", inItem);
                            IF recFADeprecBook.COUNT = 1 THEN BEGIN
                                recFADeprecBook.FINDFIRST();
                                loiAmortissement := recFADeprecBook."Depreciation Book Code";
                            END;
                        END;

                    IF typeLigne = typeLigne::Item THEN BEGIN
                        // Test existence de l'article
                        IF inItem <> '' THEN BEGIN
                            IF NOT recItem.GET(inItem) THEN
                                ERROR(ItemDoesntExist_Err, fileLine, inItem);

                            // Test de l'obsolescence de l'article
                            IF recItem."Do Not Display" THEN
                                ERROR(ItemObsolete_Err, fileLine, inItem);

                            // Modification réalisée concernant la mise en place d'une contrainte de saisie d'un article achat au niveau d'une ligne achat.
                            IF recItem."Purchasing Blocked" THEN
                                ERROR(ItemPuchasedBlocked_Err, fileLine, inItem);
                        END;

                        // Test existence de l'unité
                        IF (inItem <> '') AND (inUnit <> '') THEN
                            IF NOT ItemUnitofMeasure.GET(inItem, inUnit) THEN
                                ERROR(UOMDoesntExistForThisItem_Err, fileLine, inUnit, inItem);
                    END;

                    // Test spécification d'un N° de projet au niveau de l'entête de la commande achat
                    IF NOT GeneralApplicationSetup."Control Over Company" THEN
                        IF typeLigne <> typeLigne::"Fixed Asset" THEN
                            IF recPurchaseHeader.ARBVRNJobNo = '' THEN
                                ERROR(MissingProjectForDocument_Err, fileLine, inOrderNo);

                    // Test existence du demandeur
                    IF (inItem <> '') AND (inApplicant <> '') AND (NOT recResource.GET(inApplicant)) THEN
                        ERROR(ApplicantDoesntExist_Err, fileLine, inApplicant);

                    // Sauvegarde de la date de travail
                    svgWorkDate := WORKDATE();

                    // Initialisation de la date de travail à la date de la commande
                    WORKDATE := recPurchaseHeader."Order Date";

                    // Evaluation du n° de la ligne de commande à créer
                    recPurchaseLine.RESET();
                    recPurchaseLine.INIT();
                    recPurchaseLine.SETRANGE("Document No.", inOrderNo);
                    recPurchaseLine.SETRANGE("Document Type", typeDoc);

                    IF recPurchaseLine.FindLast() THEN;
                    numLine := recPurchaseLine."Line No." + 10000;

                    // Création de la ligne
                    recPurchaseLine.INIT();

                    recPurchaseLine."Document Type" := typeDoc;
                    recPurchaseLine."Document No." := inOrderNo;
                    recPurchaseLine."Line No." := numLine;
                    recPurchaseLine.INSERT(TRUE);

                    // Initialisation de l'enregistrement
                    IF inItem <> '' THEN BEGIN
                        recPurchaseLine.VALIDATE(Type, typeLigne);
                        recPurchaseLine.VALIDATE("No.", inItem);
                        //On ne peut pas affecter de N° de projet pour ce type
                        if (typeLigne <> typeLigne::"Fixed Asset") then begin
                            // Test existence du projet
                            IF NOT recJob.GET(inJobNo) THEN
                                ERROR(ProjectDoesntExist_Err, fileLine, inJobNo);
                            recPurchaseLine.VALIDATE("Job No.", inJobNo);
                        end else begin
                            recPurchaseLine.VALIDATE("Job No.", '');
                            DimensionValue := GetDimensionValue(DATABASE::"Fixed Asset", 1, inItem);
                            recPurchaseLine."Shortcut Dimension 1 Code" := DimensionValue;
                            DimensionValue := GetDimensionValue(DATABASE::"Fixed Asset", 4, inItem);
                            recPurchaseLine.ValidateShortcutDimCode(4, DimensionValue);
                        end;

                        IF (inUnit <> '') AND (typeLigne = typeLigne::Item) THEN
                            recPurchaseLine.VALIDATE("Unit of Measure Code", inUnit);

                        recPurchaseLine.VALIDATE("Direct Unit Cost", DecGUnitCost);
                        recPurchaseLine.VALIDATE(Quantity, DecGQuantity);
                        recPurchaseLine.Applicant := inApplicant;

                        // Mise à jour de la date souhaitée de réception et du suivi de prestation uniquement pour les
                        //                                    lignes de commande.
                        IF typeDoc = typeDoc::Order THEN
                            IF inExpectedRcptDate <> '' THEN
                                recPurchaseLine.VALIDATE("Expected Receipt Date", DatGExpectedRcptDate);
                        recPurchaseLine.Site := inSite;

                        // Modification réalisée dans le cadre de l'ajout de la gestion de l'import des lignes d'immobilisation
                        // Initialisation de la référence fournisseur
                        IF typeLigne IN [typeLigne::Item, typeLigne::"Fixed Asset"] THEN
                            recPurchaseLine.VALIDATE("Vendor Item No.", inVendorItemNo);

                        // Modification réalisée dans le cadre de l'ajout de la gestion de l'import des lignes d'immobilisation
                        // Initialisation de la loi d'amortissement
                        IF loiAmortissement <> '' THEN
                            recPurchaseLine.VALIDATE("Depreciation Book Code", loiAmortissement);
                    END;
                    // Modification réalisée dans le cadre de l'ajout de la gestion de l'import des lignes d'immobilisation
                    // Désactivation de la mise à jour des descriptions de la ligne dans le cas où elle concerne une immobilisation.
                    IF typeLigne <> typeLigne::"Fixed Asset" THEN BEGIN
                        recPurchaseLine.Description := inDescription;
                        recPurchaseLine."Description 2" := inDescription2;
                    END;

                    // Sauvegarde de l'enregistrement
                    recPurchaseLine.MODIFY(TRUE);

                    // Restauration de la date de travail
                    WORKDATE := svgWorkDate;
                end;
            }
        }
    }

    trigger OnPostXmlPort()
    var
        TreatmentComplete_Msg: Label 'Treatment complete.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Traitement terminé." }, { "lang": "FRB", "txt": "Traitement terminé." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
    begin
        MESSAGE(TreatmentComplete_Msg);
    end;

    trigger OnPreXmlPort()
    begin
        // Reset du nombre de lignes importées
        fileLine := 0;

        IF GeneralApplicationSetup.GET() THEN;
    end;

    local procedure GetDimensionValue(piTable: Integer; piDimensionNo: Integer; piCode: Code[20]): Code[20]
    var
        DefaultDimension: Record "Default Dimension";
    begin
        IF DefaultDimension.GET(piTable, piCode, GetDimensionCode(piDimensionNo)) THEN
            EXIT(DefaultDimension."Dimension Value Code");
        EXIT('');
    end;

    //Get Dimension Code
    local procedure GetDimensionCode(piDimensionID: Option "1","2","3","4","5","6","7","8"): Code[20]
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        DimensionCode: Code[20];
    begin
        GeneralLedgerSetup.GET();
        piDimensionID -= 1;
        CASE piDimensionID OF
            piDimensionID::"1":
                DimensionCode := GeneralLedgerSetup."Shortcut Dimension 1 Code";
            piDimensionID::"2":
                DimensionCode := GeneralLedgerSetup."Shortcut Dimension 2 Code";
            piDimensionID::"3":
                DimensionCode := GeneralLedgerSetup."Shortcut Dimension 3 Code";
            piDimensionID::"4":
                DimensionCode := GeneralLedgerSetup."Shortcut Dimension 4 Code";
            piDimensionID::"5":
                DimensionCode := GeneralLedgerSetup."Shortcut Dimension 5 Code";
            piDimensionID::"6":
                DimensionCode := GeneralLedgerSetup."Shortcut Dimension 6 Code";
            piDimensionID::"7":
                DimensionCode := GeneralLedgerSetup."Shortcut Dimension 7 Code";
            piDimensionID::"8":
                DimensionCode := GeneralLedgerSetup."Shortcut Dimension 8 Code";
        END;
        EXIT(DimensionCode);
    end;


    var
        GeneralApplicationSetup: Record "General Application Setup";
        recPurchaseHeader: Record "Purchase Header";
        recPurchaseLine: Record "Purchase Line";
        recJob: Record Job;
        recItem: Record Item;
        recResource: Record Resource;
        ItemUnitofMeasure: Record "Item Unit of Measure";
        recGLAccount: Record "G/L Account";
        fileLine: Integer;
        typeDoc: Enum "Purchase Document Type";
        typeLigne: Enum "Purchase Line Type";
        DecGUnitCost: Decimal;
        DecGQuantity: Decimal;
        DatGExpectedRcptDate: Date;
}