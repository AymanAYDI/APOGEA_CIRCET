codeunit 50014 "Job Mgt."
{
    [EventSubscriber(ObjectType::Table, DATABASE::Job, 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEvent(var Rec: Record Job)
    begin
        InitValueOnInsertNewProject(Rec);
    end;

    //Event pour autoriser la saisie de ligne autre que compte généraux dans les feuilles compta avec un numéro projet saisi
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnBeforeCheckAccountTypeOnJobValidation', '', false, false)]
    local procedure OnBeforeCheckAccountTypeOnJobValidation(var Sender: Record "Gen. Journal Line"; var IsHandled: Boolean);
    begin
        IsHandled := true;
    end;

    //Event pour autoriser la saisie de ligne autre que compte généraux dans les feuilles compta avec un numéro projet saisi
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnBeforeCheckBalAccountNoOnJobNoValidation', '', false, false)]
    local procedure OnBeforeCheckBalAccountNoOnJobNoValidation(var Sender: Record "Gen. Journal Line"; var IsHandled: Boolean);
    begin
        IsHandled := true;
    end;

    //Event pour valider la feuille compta avec un numéro projet saisi et un type de compte différent de compte généraux
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", 'OnBeforeCheckJobNoIsEmpty', '', false, false)]
    local procedure OnBeforeCheckJobNoIsEmpty(GenJnlLine: Record "Gen. Journal Line"; var IsHandled: Boolean);
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Transfer Line", 'OnAfterFromJnlLineToLedgEntry', '', false, false)]
    local procedure OnAfterFromJnlLineToLedgEntry(var JobLedgerEntry: Record "Job Ledger Entry"; JobJournalLine: Record "Job Journal Line");
    begin
        TransferNewFieldFromJobJnlLineToJobLedgerEntry(JobLedgerEntry, JobJournalLine);
    end;

    local procedure InitValueOnInsertNewProject(var Rec: Record Job)
    var
        JobSituationMgt: Codeunit "Job Situation Mgt.";
    begin
        if Rec.ARBVRNJobMatrixWork = Rec.ARBVRNJobMatrixWork::"Work Job" then begin
            Rec.ARBCIRFRJobStatus := Rec.ARBCIRFRJobStatus::"In Progress";
            Rec."Situation Status" := Rec."Situation Status"::"In Progress";

            GetGeneralApplicationSetup();
            if GeneralApplicationSetup."Evaluation Period Situation" then begin
                Rec."Estimate Production Progress" := JobSituationMgt.GetDefaultValueEstimateProd();
                Rec.Inventory := 0;
            end;

            Rec.MODIFY();
        end;
    end;

    procedure UpdateDefaultDimension(var pFixedAsset: Record "Fixed Asset")
    var
        Job: Record job;
    begin
        if Job.Get(pFixedAsset."Job No.") then begin
            pFixedAsset.ValidateShortcutDimCode(1, Job."Global Dimension 1 Code");
            pFixedAsset.ValidateShortcutDimCode(2, Job."Global Dimension 2 Code");
            pFixedAsset.ValidateShortcutDimCode(4, Job."No.");
        end;
    end;

    procedure InitDim1CodeLine(var JobJnlLine: Record "Job Journal Line")
    var
        Job: Record Job;
        Resource: Record Resource;
        CodeDept: Code[20];
    begin
        if JobJnlLine."Job No." <> '' then
            if Job.GET(JobJnlLine."Job No.") then begin
                CodeDept := Job."Global Dimension 1 Code";
                // Lecture du code département de la ressource dans le cas ou la ligne est une ligne d'activité et que le projet est
                // rattaché à une souche qui impose le code département de la ressource.
                if (JobJnlLine.Type = JobJnlLine.Type::Resource) and
                    (JobJnlLine."No." <> '') and
                    (Resource.GET(JobJnlLine."No.")) then
                    CodeDept := Resource."Global Dimension 1 Code";

                // Initialisation du code département de la ligne
                JobJnlLine.VALIDATE("Shortcut Dimension 1 Code", CodeDept);
            end;
    end;

    local procedure TransferNewFieldFromJobJnlLineToJobLedgerEntry(var JobLedgerEntry: Record "Job Ledger Entry"; JobJournalLine: Record "Job Journal Line")
    begin
        JobLedgerEntry."Start Date" := JobJournalLine."Start Date";
    end;

    internal procedure ControlOnJobStatus(piJob: Record Job; pixJob: Record Job)
    var
        Job: Record Job;
        SalesLine: Record "Sales Line";
        PurchaseLine: Record "Purchase Line";
        ItemJournalLine: Record "Item Journal Line";
        ARBCIRFRCommercialJob: Record ARBCIRFRCommercialJob;
        JobJournalLine: Record "Job Journal Line";
        DisplayError: Boolean;
        JobFilterLbl: Label '%1-*', Locked = true;
        NoChangeStatusAuthorizedErr: Label 'You are not authorized to make this change of status.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous n''êtes pas autorisé à effectuer ce changement de statut."}]}';
        LinkedJobNotFinishErr: Label 'All job linked are not completed', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Tous les projets rattachés ne sont pas terminés"}]}';
        ExistedLineToInvOnSalesErr: Label 'There are lines to be invoiced on the project sales orders.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Il existe des lignes à facturer sur les commandes de vente du projet."}]}';
        ExistedLineToInvOnPurchErr: Label 'There are lines to be invoiced on the project purchase orders.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Il existe des lignes à facturer sur les commandes d''achat du projet."}]}';
        ExistedLineOnLineInventoryErr: Label 'Prohibition to complete a project in the presence of inventory during a situation period', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Interdiction de terminer un projet en présence d''inventaire en période de situation"}]}';
        ExistedLineToInvOnJobJournalLineErr: Label 'You can''t close the project because there is still some unreleased activity', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous ne pouvez pas clôturer le projet car, il reste de l''activité non validée."}]}';
        UserNotAuthorizedErr: Label 'You are not authorized to change status, please contact an administrator.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous n''êtes pas autorisé à changer le statut, veuillez contacter un administrateur."}]}';
        StatusNotAuthorizedErr: Label 'Status not authorized.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Statut non autorisé"}]}';
    begin
        // Verification changement de statut sur les projets commeciaux (K)
        if ARBCIRFRCommercialJob.GET(piJob."No.") then begin

            // Seul le contrôle de gestion est autorisé à modifier le statut
            if not CIRUsermanagement.CheckRightUserByGroup(UserGroup.FieldNo("Financial Controller")) then
                ERROR(UserNotAuthorizedErr);

            // les statuts autorisés sont : 
            if not (piJob.ARBCIRFRJobStatus in [piJob.ARBCIRFRJobStatus::Active, piJob.ARBCIRFRJobStatus::"Completed"]) then
                ERROR(StatusNotAuthorizedErr);

            // Interdiction de terminer un projet commercial (K) si tous les projets rattachés ne sont pas terminés.
            if piJob.ARBCIRFRJobStatus = piJob.ARBCIRFRJobStatus::Completed then begin
                Job.SETFILTER("No.", STRSUBSTNO(JobFilterLbl, piJob."No."));
                Job.SETFILTER(ARBCIRFRJobStatus, '<>%1', ARBCIRFRJobStatus::Completed);
                if not Job.IsEmpty then
                    Error('%1 \ %2', NoChangeStatusAuthorizedErr, LinkedJobNotFinishErr);
            end;
        end;

        // Vérification changement de statut sur les chantiers
        if (piJob.ARBCIRFRJobType = piJob.ARBCIRFRJobType::"Workside Job") then begin
            // les statuts autorisés sont :
            if not (piJob.ARBCIRFRJobStatus in [piJob.ARBCIRFRJobStatus::"In Progress", piJob.ARBCIRFRJobStatus::"Completed/Invoiced", piJob.ARBCIRFRJobStatus::"PV Recovery"]) then
                ERROR(StatusNotAuthorizedErr);

            // Seul le control de gestion est autorisé à modifier le statut pour le terminer
            if ((pixJob.ARBCIRFRJobStatus = pixJob.ARBCIRFRJobStatus::"Completed/Invoiced") and (piJob.ARBCIRFRJobStatus = piJob.ARBCIRFRJobStatus::"In Progress"))
                or ((pixJob.ARBCIRFRJobStatus = pixJob.ARBCIRFRJobStatus::"Completed/Invoiced") and (piJob.ARBCIRFRJobStatus = piJob.ARBCIRFRJobStatus::"PV Recovery")) then
                if not CIRUsermanagement.CheckRightUserByGroup(UserGroup.FieldNo("Financial Controller")) then
                    ERROR(UserNotAuthorizedErr);

            // Interdiction de terminer/facturer un chantier en présence de ligne de vente non facturée intégralement
            if piJob.ARBCIRFRJobStatus = piJob.ARBCIRFRJobStatus::"Completed/Invoiced" then begin
                SalesLine.SETRANGE(ARBVRNVeronaJobNo, piJob."No.");
                SalesLine.SETFILTER("Qty. Shipped Not Invoiced", '>0');
                DisplayError := not SalesLine.ISEMPTY();
                if not DisplayError then begin
                    SalesLine.SETRANGE("Qty. Shipped Not Invoiced");
                    SalesLine.SETFILTER("Qty. to Invoice", '>0');
                    DisplayError := not SalesLine.ISEMPTY();
                end;
                if DisplayError then
                    Error('%1 \ %2', NoChangeStatusAuthorizedErr, ExistedLineToInvOnSalesErr);
            end;
        end;

        // Vérification changement de statut sur les regroupements
        if (piJob.ARBCIRFRJobType = piJob.ARBCIRFRJobType::"Production Job") then begin
            // les statuts autorisés sont : 
            if not (piJob.ARBCIRFRJobStatus in [piJob.ARBCIRFRJobStatus::Active, piJob.ARBCIRFRJobStatus::"Completed"]) then
                ERROR(StatusNotAuthorizedErr);

            // Seul le control de gestion est autorisé à modifier le statut pour le terminer
            if ((pixJob.ARBCIRFRJobStatus = pixJob.ARBCIRFRJobStatus::Completed) and (piJob.ARBCIRFRJobStatus = piJob.ARBCIRFRJobStatus::"Active")) then
                if not CIRUsermanagement.CheckRightUserByGroup(UserGroup.FieldNo("Financial Controller")) then
                    ERROR(UserNotAuthorizedErr);

            // Interdiction de terminer un projet si tous les projets rattachés ne sont pas terminés.
            if (piJob.ARBCIRFRJobStatus = piJob.ARBCIRFRJobStatus::Completed) then begin
                Job.SETFILTER("No.", STRSUBSTNO(JobFilterLbl, piJob."No."));
                Job.SETFILTER(ARBCIRFRJobStatus, '<>%1', ARBCIRFRJobStatus::"Completed/Invoiced");
                if not Job.IsEmpty then
                    Error('%1 \ %2', NoChangeStatusAuthorizedErr, LinkedJobNotFinishErr);
            end;

            // Interdiction de terminer un projet sur lequel il reste de l'activité non validée
            if (piJob.ARBCIRFRJobStatus = piJob.ARBCIRFRJobStatus::Completed) then begin
                JobJournalLine.SETRANGE("Job No.", piJob."No.");
                if not JobJournalLine.IsEmpty then
                    Error(ExistedLineToInvOnJobJournalLineErr);
            end;

            // Interdiction de terminer un projet si il reste des achats non facturés.
            if (piJob.ARBCIRFRJobStatus = piJob.ARBCIRFRJobStatus::Completed) then begin
                PurchaseLine.SETRANGE("Job No.", piJob."No.");
                PurchaseLine.SETFILTER("Qty. Rcd. Not Invoiced", '>0');
                DisplayError := not PurchaseLine.ISEMPTY();

                if not DisplayError then begin
                    PurchaseLine.SETRANGE("Qty. Rcd. Not Invoiced");
                    PurchaseLine.SETFILTER("Qty. to Invoice", '>0');
                    DisplayError := not PurchaseLine.ISEMPTY();
                end;

                if DisplayError then
                    Error('%1 \ %2', NoChangeStatusAuthorizedErr, ExistedLineToInvOnPurchErr);

                // Interdiction de terminer un projet en présence d'inventaire en période de situation
                GetGeneralApplicationSetup();
                if GeneralApplicationSetup."Evaluation Period Situation" then begin
                    ItemJournalLine.SETRANGE("Job No.", piJob."No.");
                    if not ItemJournalLine.ISEMPTY() then
                        Error(ExistedLineOnLineInventoryErr);
                end;
            end;
        end;
    end;

    internal procedure ControlStatusOnSalesDocument(pSalesHeader: Record "Sales Header")
    var
        Job: Record Job;
    begin
        if Job.Get(pSalesHeader.ARBVRNJobNo) then
            if (Job.ARBCIRFRJobStatus = Job.ARBCIRFRJobStatus::"Completed/Invoiced") and (pSalesHeader."Document Type" = pSalesHeader."Document Type"::"Credit Memo") then
                Error(StatusInErrorErr, FORMAT(Job.ARBCIRFRJobStatus), pSalesHeader.ARBVRNJobNo);
    end;

    internal procedure ControlStatusOnSalesLineDocument(pSalesLine: Record "Sales Line")
    var
        Job: Record Job;
    begin
        if Job.Get(pSalesLine.ARBVRNVeronaJobNo) then
            if (Job.ARBCIRFRJobStatus = Job.ARBCIRFRJobStatus::"Completed/Invoiced") and (pSalesLine."Document Type" = pSalesLine."Document Type"::"Credit Memo") then
                Error(StatusInErrorErr, FORMAT(Job.ARBCIRFRJobStatus), pSalesLine.ARBVRNVeronaJobNo);
    end;

    local procedure GetGeneralApplicationSetup()
    begin
        GeneralApplicationSetup.GET();
    end;

    var
        GeneralApplicationSetup: Record "General Application Setup";
        UserGroup: Record "User Group";
        CirUserManagement: Codeunit "CIR User Management";
        StatusInErrorErr: Label 'Status must not be %1 for project %2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Statut ne doit pas être %1 pour le projet %2."}]}';
}