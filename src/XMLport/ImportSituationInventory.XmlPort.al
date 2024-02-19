xmlport 50004 "Import Situation Inventory"
{
    // Description : XMLport créé à la demande du contrôle de gestion pour gérer l'import massif des inventaires de situation des projets de regroupement (évolution #28453).
    Direction = Import;
    FieldSeparator = ';';
    Format = VariableText;
    Caption = 'Import Situation Inventory', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Import inventaire situation"}]}';

    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                AutoSave = false;
                XmlName = 'ImportInventaireSitu';
                SourceTableView = SORTING(Number)
                                  ORDER(Ascending);
                textelement(inJobNo)
                {
                    trigger OnAfterAssignVariable()
                    var
                        Job: Record "Job";
                    begin
                        // Troncation du N° de projet à sa taille maximale
                        inJobNo := COPYSTR(inJobNo, 1, MAXSTRLEN(Job."No."));
                    end;
                }
                textelement(inInventory)
                {
                    trigger OnAfterAssignVariable()
                    begin
                        // Conversion du séparateur de décimales
                        inInventory := CONVERTSTR(inInventory, '.', ',');
                    end;
                }

                trigger OnAfterInitRecord()
                begin
                    // Reset des variables d'import
                    inJobNo := '';
                    inInventory := '';
                end;

                trigger OnBeforeInsertRecord()
                var
                    Job: Record "Job";
                    OperativeJob: Record Job;
                    ARBCIRFRCommercialJob: Record ARBCIRFRCommercialJob;
                    JobSituationMgt: Codeunit "Job Situation Mgt.";
                    inventaire: Decimal;
                begin
                    // Incrémentation du compteur de lignes importées
                    LineNo += 1;

                    // Lecture des caractéristiques du projet
                    IF NOT Job.GET(inJobNo) THEN
                        ERROR(CST_InfoLine_Err, FORMAT(LineNo), STRSUBSTNO(CST_NotExistJob_Err, inJobNo));

                    // Test existence du projet et/ou du projet commercial
                    IF (NOT Job.GET(inJobNo)) and (ARBCIRFRCommercialJob.Get(inJobNo))
                    THEN
                        ERROR(CST_InfoLine_Err, FORMAT(LineNo), STRSUBSTNO(CST_JobGrouping_Err, inJobNo))
                    else
                        If NOT Job.GET(inJobNo) then
                            ERROR(CST_InfoLine_Err, FORMAT(LineNo), STRSUBSTNO(CST_NotExistJob_Err, inJobNo));

                    // Test type du projet
                    OperativeJob.SETRANGE("No.", inJobNo);
                    OperativeJob.SETRANGE(ARBVRNJobMatrixWork, OperativeJob.ARBVRNJobMatrixWork::"Matrix Job");
                    IF OperativeJob.ISEMPTY() THEN
                        ERROR(CST_InfoLine_Err, FORMAT(LineNo), STRSUBSTNO(CST_JobGrouping_Err, inJobNo));

                    // Test si le projet est actif
                    IF Job.ARBCIRFRJobStatus <> Job.ARBCIRFRJobStatus::Active THEN
                        ERROR(CST_InfoLine_Err, FORMAT(LineNo), STRSUBSTNO(CST_JobNotActive_Err, inJobNo));

                    // Test validité du montant de l'inventaire
                    IF NOT EVALUATE(inventaire, inInventory) THEN
                        ERROR(CST_InfoLine_Err, FORMAT(LineNo), STRSUBSTNO(CST_JobInventory_Err, inJobNo));

                    // Test si l'utilisateur en cours de connexion a les droits de modification du projet
                    IF NOT JobSituationMgt.GetEditableJobSituation(Job) THEN
                        ERROR(CST_InfoLine_Err, FORMAT(LineNo), STRSUBSTNO(CST_NotAllowToModifyJob_Err, inJobNo));

                    // Mise à jour du projet
                    IF Job.Inventory <> inventaire THEN BEGIN
                        Job.VALIDATE(Inventory, inventaire);
                        Job."Last Date Modified" := TODAY();
                        EVALUATE(Job.ARBCIRFRLastUserModified, FORMAT(USERID()));
                        Job.MODIFY(FALSE);
                    END;
                end;
            }
        }
    }

    trigger OnPostXmlPort()
    begin
        // Notification fin du traitement
        IF GuiAllowed THEN
            MESSAGE(CST_SUCCES_Msg, LineNo);
    end;

    trigger OnPreXmlPort()
    begin
        // Reset du nombre de lignes importées
        LineNo := 0;

        // Test période de situation
        GeneralApplicationSetup.GET();
        GeneralApplicationSetup.TESTFIELD("Evaluation Period Situation", TRUE);
    end;

    var
        GeneralApplicationSetup: Record "General Application Setup";
        LineNo: Integer;
        CST_InfoLine_Err: Label 'Line %1 : %2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : %2"}]}';
        CST_NotAllowToModifyJob_Err: Label 'Only the manager or his assistant, the salesperson or his assistant, the quality department and the controller have the right to modify the project %1.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Seuls le responsable ou son assistant, le vendeur ou son assistant, le service qualité et le contrôleur de gestion ont le droit de modifier le projet %1."}]}';
        CST_NotExistJob_Err: Label 'The job %1 does not exist.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le projet %1 n''existe pas."}]}';
        CST_JobGrouping_Err: Label 'The job %1 is not a job grouping.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le projet %1 n''est pas un projet de regroupement."}]}';
        CST_JobNotActive_Err: Label 'The job %1 is not active.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le projet %1 n''est pas actif."}]}';
        CST_JobInventory_Err: Label 'The job inventory amount %1 is invalid.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le montant de l''inventaire du projet %1 est invalide."}]}';
        CST_SUCCES_Msg: Label '%1 lines have been successfully imported', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"%1 lignes ont été importées avec succès"}]}';
}