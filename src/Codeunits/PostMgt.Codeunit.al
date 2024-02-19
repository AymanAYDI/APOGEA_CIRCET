codeunit 50020 "Post Mgt"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", 'OnBeforeCode', '', false, false)]
    local procedure OnBeforeCode_ValidationPostingDate(var GenJournalLine: Record "Gen. Journal Line"; var HideDialog: Boolean);
    begin
        ValidationGLPostingDate(GenJournalLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterValidatePostingAndDocumentDate', '', false, false)]
    local procedure OnAfterValidatePostingAndDocumentDate_ValidationSalesPostingDate(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; ReplacePostingDate: Boolean; ReplaceDocumentDate: Boolean);
    begin
        ValidationSalesPostingDate(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterValidatePostingAndDocumentDate', '', false, false)]
    local procedure OnAfterValidatePostingAndDocumentDate_ValidationPurchPostingDate(var PurchaseHeader: Record "Purchase Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean);
    begin
        ValidationPurchPostingDate(PurchaseHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Job Jnl.-Post Batch", 'OnCodeOnBeforeCheckLines', '', false, false)]
    local procedure OnCodeOnBeforeCheckLines_ValidationActivitesPostingDate(var JobJournalLine: Record "Job Journal Line");
    begin
        ValidationActivitiesPostingDate(JobJournalLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Payment Management", 'OnGenerInvPostingBufferOnBeforeUpdtBuffer', '', false, false)]
    local procedure OnGenerInvPostingBufferOnBeforeUpdtBuffer(var InvPostingBuffer: array[2] of Record "Payment Post. Buffer"; PaymentLine: Record "Payment Line"; StepLedger: Record "Payment Step Ledger");
    begin
        ModifyInvPostingBufferDescription(InvPostingBuffer, PaymentLine, StepLedger);
    end;

    // A supprimer en fonction de l'évolution du code de Verona
    [EventSubscriber(ObjectType::Table, Database::"Default Dimension", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertDefaultDimension(var Rec: Record "Default Dimension"; RunTrigger: Boolean)
    begin
        DeleteVeronaJobDefaultDimension(Rec);
    end;

    // A supprimer en fonction de l'évolution du code de Verona
    [EventSubscriber(ObjectType::Table, Database::"Default Dimension", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyDefaultDimension(var Rec: Record "Default Dimension"; RunTrigger: Boolean)
    begin
        DeleteVeronaJobDefaultDimension(Rec);
    end;

    internal procedure ValidationActivitiesPostingDate(var JobJournalLine: Record "Job Journal Line")
    var
        AccountingPeriod: Record "Accounting Period";
        GLClosingDateNo: Integer;
    begin
        CheckPeriodUserSetup();
        GLClosingDateNo := AccountingPeriod.FieldNo("Activity Closing Date");
        CheckAccountingPeriode(JobJournalLine."Posting Date", GLClosingDateNo);
    end;

    internal procedure ValidationGLPostingDate(var GenJournalLine: Record "Gen. Journal Line")
    var
        AccountingPeriod: Record "Accounting Period";
        GLClosingDateNo: Integer;
    begin
        CheckPeriodUserSetup();
        GLClosingDateNo := AccountingPeriod.FieldNo("GL Closing Date");
        CheckAccountingPeriode(GenJournalLine."Posting Date", GLClosingDateNo);
    end;

    internal procedure ValidationPurchPostingDate(var PurchaseHeader: Record "Purchase Header")
    var
        AccountingPeriod: Record "Accounting Period";
        PurchaseClosingDateNo: Integer;
    begin
        CheckPeriodUserSetup();
        PurchaseClosingDateNo := AccountingPeriod.FieldNo("Purchases Closing Date");
        CheckAccountingPeriode(PurchaseHeader."Posting Date", PurchaseClosingDateNo);
    end;

    internal procedure ValidationSalesPostingDate(var SalesHeader: Record "Sales Header")
    var
        AccountingPeriod: Record "Accounting Period";
        SalesClosingDateNo: Integer;
    begin
        CheckPeriodUserSetup();
        SalesClosingDateNo := AccountingPeriod.FieldNo("Sales Closing Date");
        CheckAccountingPeriode(SalesHeader."Posting Date", SalesClosingDateNo);
    end;

    local procedure CheckPeriodUserSetup()
    var
        UserSetup: Record "User Setup";
        UserSetupPostingErr: Label 'You cannot post on date %1 which is outside the allowed period(%2 - %3). Please change the posting date.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous ne pouvez pas comptabiliser à la date %1 qui est hors période autorisée(%2 au %3). Veuillez modifier la date comptabilisation."}]}';
        TodayDate: Date;
    begin
        TodayDate := Today();
        if UserSetup.Get(UserId()) then
            if (UserSetup."Allow Posting From" <> 0D) then
                if (UserSetup."Allow Posting To" <> 0D) then
                    if (TodayDate < UserSetup."Allow Posting From") Or (TodayDate > UserSetup."Allow Posting To") then
                        Error(UserSetupPostingErr, TodayDate, UserSetup."Allow Posting From", UserSetup."Allow Posting To");
    end;

    local procedure CheckAccountingPeriode(pPostingDate: Date; pFieldNo: Integer)
    var
        AccountingPeriod: Record "Accounting Period";
        lRecordRef: RecordRef;
        ClosedDate: Date;
        TodayDate: Date;
        AccountingPeriodClosedErr: Label 'This period is closed', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Cette période est clôturée"}]}';
        AccountingPeriodErr: Label 'You cannot post on date %1 which is outside the allowed period (%2 - %3). Please change the posting date.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous ne pouvez pas comptabiliser à la date %1 qui est hors période autorisée (%2 au %3). Veuillez modifier la date comptabilisation."}]}';
    begin
        if AccountingPeriod.Get(CalcDate('<-CM>', pPostingDate)) then begin
            if (AccountingPeriod.Closed and (pFieldNo <> AccountingPeriod.FieldNo("GL Closing Date"))) or AccountingPeriod."Fiscally Closed" then
                Error(AccountingPeriodClosedErr);

            lRecordRef.OPEN(DATABASE::"Accounting Period");
            lRecordRef.GET(AccountingPeriod.RecordId);
            ClosedDate := lRecordRef.FIELD(pFieldNo).value();
            TodayDate := Today();
            if ClosedDate <> 0D then
                if (TodayDate < AccountingPeriod."Starting Date") or (TodayDate > ClosedDate) then
                    Error(AccountingPeriodErr, TodayDate, AccountingPeriod."Starting Date", ClosedDate);
        end;
    end;

    local procedure ModifyInvPostingBufferDescription(var InvPostingBuffer: array[2] of Record "Payment Post. Buffer"; PaymentLine: Record "Payment Line"; StepLedger: Record "Payment Step Ledger")
    var
        Description: Text[98];
    begin
        Description := STRSUBSTNO(StepLedger.Description, PaymentLine."Due Date", PaymentLine."Account No.", PaymentLine."Document No."
                              , PaymentLine."Account Name");
        InvPostingBuffer[1].Description := COPYSTR(Description, 1, 50);
    end;

    // A supprimer en fonction de l'évolution du code de Verona
    //Fonction qui supprime le paramètrage créé automatiquement par Verona
    local procedure DeleteVeronaJobDefaultDimension(var Rec: Record "Default Dimension")
    begin
        IF (Rec."Table ID" = DATABASE::Job) AND (Rec."No." = '') AND (Rec."Value Posting" = Rec."Value Posting"::"Same Code") THEN
            Rec.Delete();
    end;
}