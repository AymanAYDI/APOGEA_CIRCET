xmlport 50003 "Import Production Progress"
{
    Caption = 'Import Production Progress', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Import de l''avancement de production"}]}';
    Direction = Import;
    FieldDelimiter = '<None>';
    FieldSeparator = ';';
    Format = VariableText;
    TextEncoding = WINDOWS;

    schema
    {
        textelement(Root)
        {
            tableelement(Integer; Integer)
            {
                AutoSave = false;
                XmlName = 'ImportProdProgress';
                SourceTableView = SORTING(Number);
                textelement(jobno)
                {
                    XmlName = 'JobNo';
                }
                textelement(situationstatus)
                {
                    XmlName = 'SituationStatus';
                }
                textelement(estimatedprodprogress)
                {
                    XmlName = 'EstimatedProdProgress';
                }

                trigger OnBeforeInsertRecord()
                var
                    Job: Record "Job";
                    JobSituationMgt: Codeunit "Job Situation Mgt.";
                begin
                    IntGLineNo += 1;

                    DecGEstimatedProdProgress := 0;
                    OptGStatusSituation := OptGStatusSituation::Active;
                    //Update Job
                    Job.GET(JobNo);

                    // Test si l'utilisateur en cours de connexion a les droits de modification du projet
                    IF NOT JobSituationMgt.GetEditableJobSituation(Job) THEN
                        ERROR(InfoLine_Err, FORMAT(IntGLineNo), STRSUBSTNO(NotAllowToModifyJob_Err, jobno));

                    //Check Values
                    CLEARLASTERROR();
                    IF NOT FctCheckField() THEN
                        ERROR(CounterOfLines_Lbl, FORMAT(IntGLineNo), GETLASTERRORTEXT);

                    IF OptGStatusSituation <> OptGStatusSituation::"In Progress" THEN
                        DecGEstimatedProdProgress := JobSituationMgt.GetDefaultValueEstimateProd();

                    // Test modification du chantier
                    IF (OptGStatusSituation <> Job."Situation Status") OR (DecGEstimatedProdProgress <> Job."Estimate Production Progress") THEN BEGIN
                        // Actualisation du chantier
                        Job."Situation Status" := OptGStatusSituation;
                        Job."Estimate Production Progress" := DecGEstimatedProdProgress;
                        Job."Last Date Modified" := TODAY();
                        Job.ARBCIRFRLastUserModified := CopyStr(USERID, 1, MaxStrLen(Job.ARBCIRFRLastUserModified));
                        Job.MODIFY(FALSE);
                    END;
                end;
            }
        }
    }

    trigger OnPostXmlPort()
    begin
        MESSAGE(NumberLinesImported_Msg, IntGLineNo);
    end;

    trigger OnPreXmlPort()
    begin
        IntGLineNo := 0;
        GeneralApplicationSetup.GET();
        GeneralApplicationSetup.TESTFIELD("Evaluation Period Situation", TRUE);
    end;

    var
        GeneralApplicationSetup: Record "General Application Setup";
        IntGLineNo: Integer;
        OptGStatusSituation: Enum ARBCIRFRJobStatus;
        DecGEstimatedProdProgress: Decimal;
        InfoLine_Err: Label 'Line %1 : %2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : %2"}]}';
        NotAllowToModifyJob_Err: Label 'Only the manager or his assistant, the salesperson or his assistant, the quality department and the controller have the right to modify the project %1.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Seuls le responsable ou son assistant, le vendeur ou son assistant, le service qualité et le contrôleur de gestion ont le droit de modifier le projet %1."}]}';
        OnlyOneOptionPossible_Msg: Label 'Situation Status: You can choose only one option from "In progress", "PV recovery", and "Completed / Invoiced".', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Statut de Situation : Vous pouvez choisir une seule option possible parmi « En cours », « Récupération PV », et « Terminé / Facturé »."}]}';
        CounterOfLines_Lbl: Label 'Line %1 : %2.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ligne %1 : %2"}]}';
        NumberLinesImported_Msg: Label '%1 line(s) imported.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"%1 ligne(s) importée(s)."}]}';
        BadStatusProdProgression_Err: Label 'Production progress can only be specified on a construction site in an "In progress" status.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Un avancement de production peut être spécifié uniquement sur un chantier dans un statut de situation « En cours »."}]}';

    [TryFunction]
    local procedure FctCheckField()
    var
        RecLJob: Record "Job";
    begin
        //Check Values
        RecLJob.GET(JobNo);
        RecLJob.TESTFIELD(ARBVRNJobMatrixWork, RecLJob.ARBVRNJobMatrixWork::"Work Job");
        IF (SituationStatus <> FORMAT(OptGStatusSituation::"In Progress")) AND (SituationStatus <> FORMAT(OptGStatusSituation::"PV Recovery")) AND
           (SituationStatus <> FORMAT(OptGStatusSituation::"Completed/Invoiced")) THEN
            ERROR(OnlyOneOptionPossible_Msg);

        EVALUATE(OptGStatusSituation, SituationStatus);

        IF EstimatedProdProgress <> '' THEN
            EVALUATE(DecGEstimatedProdProgress, EstimatedProdProgress);

        // Autorisation de spécification d'un montant d'avancement de production uniquement sur un chantier dans un statut de situation "En cours".
        IF (OptGStatusSituation <> OptGStatusSituation::"In Progress") AND (DecGEstimatedProdProgress <> 0) THEN
            ERROR(BadStatusProdProgression_Err);
    end;
}