codeunit 50019 "Job Situation Mgt."
{
    internal procedure CheckQuantityByDocType(pJobNo: Code[20])
    var
        SalesLine: Record "Sales Line";
        ExistQuantity_Err: label 'There is a quantity on the document %1 of type %2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Il existe une quantité sur le document %1 de type %2"}]}';
    begin
        SalesLine.SetRange("Job No.", pJobNo);
        SalesLine.SetFilter("Document Type", '%1|%2|%3', SalesLine."Document Type"::Order, SalesLine."Document Type"::Invoice, SalesLine."Document Type"::"Credit Memo");
        if SalesLine.FindSet() then
            repeat
                Case SalesLine."Document Type" of
                    SalesLine."Document Type"::Order:
                        If SalesLine."Quantity Invoiced" <> SalesLine.Quantity then
                            Error(ExistQuantity_Err);
                    SalesLine."Document Type"::Invoice:
                        if SalesLine.Quantity <> 0 then
                            Error(ExistQuantity_Err);
                    SalesLine."Document Type"::"Credit Memo":
                        if SalesLine.Quantity <> 0 then
                            Error(ExistQuantity_Err);
                End
            until SalesLine.next() = 0;
    end;

    internal procedure GetDefaultValueEstimateProd(): Decimal
    begin
        exit(-99999)
    end;

    procedure OnClickEvaluationPeriodSituation(var pEvaluationPeriodSituation: Boolean)
    var
        UpdateJobSituation: Report "Update Job Situation";
        ConfirmEnterPeriod1_Msg: Label 'The beginning of the evaluation period of the situation causes \\', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"L''entrée de la période d''évaluation de la situation provoque \\"}]}';
        ConfirmEnterPeriod2_Msg: Label 'reset of the situation parameters.\\', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"le reset des paramètres de situation.\\"}]}';
        ConfirmEnterPeriod3_Msg: Label 'Do you confirm this input ?', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Confirmez-vous cette entrée ?"}]}';
        DropOutEnterPeriod_Err: Label 'Abandonment of the beginning of the evaluation period of the situation', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Abandon de l''entrée dans la période d''évaluation de la situation"}]}';
    begin
        // Test entrée de la période d'évaluation de la situation
        IF pEvaluationPeriodSituation THEN BEGIN
            // Demande de confirmation de l'entrée de la période d'évaluation
            IF NOT CONFIRM(ConfirmEnterPeriod1_Msg +
                           ConfirmEnterPeriod2_Msg +
                           ConfirmEnterPeriod3_Msg) THEN BEGIN
                MESSAGE(DropOutEnterPeriod_Err);
                pEvaluationPeriodSituation := false;
                EXIT;
            END;

            UpdateJobSituation.ActivatePeriodSituation(TRUE);
        end else
            UpdateJobSituation.ActivatePeriodSituation(FALSE);

        UpdateJobSituation.UseRequestPage(FALSE);
        UpdateJobSituation.Run();
    end;

    internal procedure GetEditableJobSituation(pJob: Record Job): Boolean
    var
        UserSetup: Record "User Setup";
        UserGroup: Record "User Group";
        CIRUserManagement: Codeunit "CIR User Management";
    begin
        UserSetup.SETRANGE("User ID", UserId());
        UserSetup.SETFILTER(ARBVRNRelatedResourceNo, '%1|%2|%3|%4', pJob.ARBCIRFRAssistBusinessManager, pJob.ARBCIRFRSalespersonCode,
                                                                    pJob.ARBCIRFRAssistanceSalesperson, pJob.ARBCIRFRTechnicalManager);
        if NOT UserSetup.ISEMPTY() then
            exit(true)
        ELSE
            // Autorisé pour ceux qui ont le droit de modifier tous les projets.
            EXIT(CIRUserManagement.CheckRightUserByGroup(UserGroup.FieldNo(ARBCIRFRProjectModification)));
    end;
}