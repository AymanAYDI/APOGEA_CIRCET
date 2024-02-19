xmlport 50007 "Import Sales Line"
{
    Caption = 'Import Sales Line', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Import des lignes de ventes"}]}';
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
                textelement(inCmd)
                {
                }
                textelement(inPoste)
                {
                }
                textelement(inArticle)
                {
                }
                textelement(inDescription)
                {
                }
                textelement(inDescription2)
                {
                }
                textelement(inChantier)
                {
                }
                textelement(inQte)
                {
                }
                textelement(inPrixUnitaire)
                {
                }

                trigger OnPreXmlItem()
                begin
                    // Reset du nombre de lignes importées
                    Integer.Number := 0;
                end;

                trigger OnAfterInitRecord()
                begin
                    // Reset des variables d'import
                    inCmd := '';
                    inPoste := '';
                    inArticle := '';
                    inDescription := '';
                    inDescription2 := '';
                    inChantier := '';
                    inQte := '';
                    inPrixUnitaire := '';
                end;

                trigger OnBeforeInsertRecord()
                var
                    recSalesHeader: Record "Sales Header";
                    recItem: Record Item;
                    // recSaleSetup: Record "Sales & Receivables Setup";
                    recJob: Record Job;
                    recLastSalesLine: Record "Sales Line";
                    recNewSalesLine: Record "Sales Line";
                    ControlStationRef_Err: Label 'Line %1 : Control Station Ref. (%2) invalid', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : Poste de commande (%2) invalide"}]}';
                    Quantity_Err: Label 'Line %1 : Quantity (%2) invalid', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : Quantité (%2) invalide"}]}';
                    UnitPrice_Err: Label 'Line %1 : Invalid unit price (%2)', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : Prix unitaire (%2) invalide"}]}';
                    SalesHeaderNo_Err: Label 'Line %1 : The sales order %2 does not exist', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : La commande vente %2 n''existe pas"}]}';
                    SalesHeaderNotOpen_Err: Label 'Line %1 : The sales order %2 is not open', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : La commande vente %2 n''est pas ouverte"}]}';
                    SalesHeaderJobNo_Err: Label 'Line %1 : Header %2 does not have a worksite job', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : L''entête de la commande %2 ne possède pas de chantier"}]}';
                    Item_Err: Label 'Line %1 : Item %2 does not exist', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : L''article %2 n''existe pas"}]}';
                    ItemBlocked_Err: Label 'Line %1 : Item %2 is blocked', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : L''article %2 est bloqué"}]}';
                    ItemOutdated_Err: Label 'Line %1 : Item %2 is outdated', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : L''article %2 est obsolète"}]}';
                    ItemNotForSale_Err: Label 'Line %1 : Item %2 is blocked for sale', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : L''article %2 est bloquée à la vente"}]}';
                    NotAJob_Err: Label 'Line %1 : Job %2 does not exist', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : Le chantier %2 n''existe pas"}]}';
                    JobType_Err: Label 'Line %1 : The job %2 is not a worksite job', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : Le projet %2 n''est pas un chantier"}]}';
                    JobStatus_Err: Label 'Line %1 : The status (%2) of job %3 is not valid', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : Le statut (%2) du projet %3 n''est pas valide"}]}';
                begin

                    // Incrémentation du nombre de lignes importées
                    Integer.Number += 1;

                    // Test validité du format du poste de commande
                    IF inPoste = '' THEN
                        inValPoste := 0
                    ELSE
                        IF NOT EVALUATE(inValPoste, inPoste) THEN
                            ERROR(ControlStationRef_Err, Integer.Number, inPoste);

                    // Test validité de la quantité
                    IF inQte = '' THEN
                        inValQte := 0
                    ELSE
                        IF NOT EVALUATE(inValQte, inQte) THEN
                            ERROR(Quantity_Err, Integer.Number, inQte);

                    // Test validité du format du prix unitaire
                    IF inPrixUnitaire = '' THEN
                        inValPrixUnitaire := 0
                    ELSE
                        IF NOT EVALUATE(inValPrixUnitaire, inPrixUnitaire) THEN
                            ERROR(UnitPrice_Err, Integer.Number, inPrixUnitaire);

                    // Test existence de la commande
                    IF NOT recSalesHeader.GET(recSalesHeader."Document Type"::Order, inCmd) THEN
                        ERROR(SalesHeaderNo_Err, Integer.Number, inCmd);

                    // Test ouverture de la commande
                    IF recSalesHeader.Status <> recSalesHeader.Status::Open THEN
                        ERROR(SalesHeaderNotOpen_Err, Integer.Number, inCmd);

                    // Test spécification d'un chantier sur l'entête de la commande
                    IF recSalesHeader.ARBVRNJobNo = '' THEN
                        ERROR(SalesHeaderJobNo_Err, Integer.Number, inCmd);

                    // Test validité de l'article
                    IF inArticle <> '' THEN BEGIN
                        // Test existence de l'article
                        IF NOT recItem.GET(inArticle) THEN
                            ERROR(Item_Err, Integer.Number, inArticle);

                        // Test blocage de l'article
                        IF recItem.Blocked THEN
                            ERROR(ItemBlocked_Err, Integer.Number, inArticle);

                        // Test obsolescence de l'article
                        IF recItem."Do Not Display" THEN
                            ERROR(ItemOutdated_Err, Integer.Number, inArticle);

                        // Test spécification d'un article de vente
                        IF recItem."Sales Blocked" THEN
                            ERROR(ItemNotForSale_Err, Integer.Number, inArticle);

                        // Test existence du projet
                        IF NOT recJob.GET(inChantier) THEN
                            ERROR(NotAJob_Err, Integer.Number, inChantier);

                        // Test spécificaton d'un chantier
                        IF recJob.ARBCIRFRJobType <> recJob.ARBCIRFRJobType::"Workside Job" THEN
                            ERROR(JobType_Err, Integer.Number, inChantier);

                        // Test validité du statut du chantier
                        IF NOT (recJob.ARBCIRFRJobStatus IN [recJob.ARBCIRFRJobStatus::"In Progress", recJob.ARBCIRFRJobStatus::"PV Recovery"]) THEN
                            ERROR(JobStatus_Err, Integer.Number, recJob.ARBCIRFRJobStatus, inChantier);
                    END;

                    // Recherche de la dernière ligne de la commande
                    recLastSalesLine.INIT();
                    recLastSalesLine."Line No." := 0;
                    recLastSalesLine.RESET();
                    recLastSalesLine.SETRANGE("Document Type", recLastSalesLine."Document Type"::Order);
                    recLastSalesLine.SETRANGE("Document No.", inCmd);
                    IF recLastSalesLine.FindLast() THEN;

                    // Création de la ligne de commande
                    recNewSalesLine.INIT();
                    recNewSalesLine."Document Type" := recNewSalesLine."Document Type"::Order;
                    recNewSalesLine."Document No." := inCmd;
                    recNewSalesLine."Line No." := recLastSalesLine."Line No." + 10000;
                    recNewSalesLine.INSERT(TRUE);
                    IF inArticle <> '' THEN BEGIN
                        recNewSalesLine.VALIDATE(Type, recNewSalesLine.Type::Item);
                        recNewSalesLine.VALIDATE("No.", inArticle);
                        recNewSalesLine.VALIDATE(ARBVRNVeronaJobNo, inChantier);
                        recNewSalesLine.VALIDATE(Quantity, inValQte);
                        recNewSalesLine.VALIDATE("Unit Price", inValPrixUnitaire);
                    END;
                    recNewSalesLine.VALIDATE("Control Station Ref.", inValPoste);
                    recNewSalesLine.VALIDATE(Description, inDescription);
                    recNewSalesLine.VALIDATE("Description 2", inDescription2);
                    recNewSalesLine.MODIFY(TRUE);
                end;
            }
        }
    }

    trigger OnPostXmlPort()
    var
        TreatmentComplete_Msg: Label 'Treatment complete.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Traitement terminé."}]}';
    begin
        MESSAGE(TreatmentComplete_Msg);
    end;

    var
        inValPoste: Integer;
        inValQte: Decimal;
        inValPrixUnitaire: Decimal;
}