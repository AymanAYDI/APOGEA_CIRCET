codeunit 50502 "CIR Gen. Jnl.-Post Batch"
{
    Permissions = TableData "Gen. Journal Batch" = imd;
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.Copy(Rec);
        GenJournalLine.SetAutoCalcFields();
        Code(GenJournalLine);
        Rec := GenJournalLine;
    end;

    var
        GenJournalTemplate: Record "Gen. Journal Template";
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJournalLine2: Record "Gen. Journal Line";
        GenJournalLine3: Record "Gen. Journal Line";
        TempGenJournalLine4: Record "Gen. Journal Line" temporary;
        GenJournalLine5: Record "Gen. Journal Line";
        GLEntry: Record "G/L Entry";
        GLRegister: Record "G/L Register";
        GLAccount: Record "G/L Account";
        GenJnlAllocation: Record "Gen. Jnl. Allocation";
        AccountingPeriod: Record "Accounting Period";
        TempNoSeries: Record "No. Series" temporary;
        GeneralLedgerSetup: Record "General Ledger Setup";
        FAJournalSetup: Record "FA Journal Setup";
        TempGenJournalLine: Record "Gen. Journal Line" temporary;
        SourceCode: Record "Source Code";
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        CIRGenJnlPostLine: Codeunit "CIR Gen. Jnl.-Post Line";
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        NoSeriesMgt2: array[10] of Codeunit NoSeriesManagement;
        ICInboxOutboxMgt: Codeunit ICInboxOutboxMgt;
        PostingSetupManagement: Codeunit PostingSetupManagement;
        Dialog: Dialog;
        GLRegNo: Integer;
        StartLineNo: Integer;
        StartLineNoReverse: Integer;
        LastDate: Date;
        LastDocType: Enum "Gen. Journal Document Type";
        LastDocNo: Code[20];
        LastPostedDocNo: Code[20];
        CurrentBalance: Decimal;
        CurrentBalanceReverse: Decimal;
        Day: Integer;
        Week: Integer;
        Month: Integer;
        MonthText: Text[30];
        NoOfRecords: Integer;
        NoOfReversingRecords: Integer;
        LineCount: Integer;
        NoOfPostingNoSeries: Integer;
        PostingNoSeriesNo: Integer;
        DocCorrection: Boolean;
        VATEntryCreated: Boolean;
        LastFAAddCurrExchRate: Decimal;
        LastCurrencyCode: Code[10];
        CurrencyBalance: Decimal;
        FirstLine: Boolean;
#pragma warning disable AA0470
        PostingStateMsg: Label 'Journal Batch Name    #1##########\\Posting @2@@@@@@@@@@@@@\#3#############';
#pragma warning restore AA0470
        CheckingLinesMsg: Label 'Checking lines', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Vérification des lignes" }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        CheckingBalanceMsg: Label 'Checking balance', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Vérification du solde" }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        UpdatingBalLinesMsg: Label 'Updating bal. lines', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Mise à jour des lignes d''équilibre" }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        PostingLinesMsg: Label 'Posting lines', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Validation des lignes" }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        PostingReversLinesMsg: Label 'Posting revers. lines', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Validation des lignes opposées" }, { "lang": "FRB", "txt": "Validation des lignes opposées" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        UpdatingLinesMsg: Label 'Updating lines', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Mise à jour des lignes" }, { "lang": "FRB", "txt": "Mise à jour des lignes" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text008Lbl: Label 'must be the same on all lines for the same document', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "doit être identique sur toutes les lignes d''un même document." }, { "lang": "FRB", "txt": "doit être identique sur toutes les lignes d''un même document." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text009Lbl: Label '%1 %2 posted on %3 includes more than one customer or vendor. ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "%1 %2 validé sur %3 comprend plusieurs clients ou fournisseurs." }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text010Lbl: Label 'In order for the program to calculate VAT, the entries must be separated by another document number or by an empty line.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Pour que le programme puisse calculer la TVA, les écritures doivent être séparées par un autre numéro de document ou par une ligne blanche." }, { "lang": "FRB", "txt": "Pour que le programme puisse calculer la TVA, les écritures doivent être séparées par un autre numéro de document ou par une ligne blanche." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text012Lbl: Label '%5 %2 is out of balance by %1. ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "%5 %2 présente un déséquilibre de compte de %1." }, { "lang": "FRB", "txt": "%5 %2 présente un déséquilibre de compte de %1." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text013Lbl: Label 'Please check that %3, %4, %5 and %6 are correct for each line.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Veuillez vérifier que %3, %4, %5 et %6 sont corrects pour chaque ligne." }, { "lang": "FRB", "txt": "Veuillez vérifier que %3, %4, %5 et %6 sont corrects pour chaque ligne." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text014Lbl: Label 'The lines in %1 are out of balance by %2. ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Les lignes, dans %1, présentent un déséquilibre de compte de %2. " }, { "lang": "FRB", "txt": "Les lignes, dans %1, présentent un déséquilibre de compte de %2. " }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text015Lbl: Label 'Check that %3 and %4 are correct for each line.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Veuillez vérifier que %3 et %4 sont corrects pour chaque ligne." }, { "lang": "FRB", "txt": "Veuillez vérifier que %3 et %4 sont corrects pour chaque ligne." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text016Lbl: Label 'Your reversing entries in %4 %2 are out of balance by %1. ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Vos écritures contrepassées dans %4 %2 présentent un déséquilibre de compte de %1. " }, { "lang": "FRB", "txt": "Vos écritures contrepassées dans %4 %2 présentent un déséquilibre de compte de %1. " }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text017Lbl: Label 'Please check whether %3 is correct for each line for this %4.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Vérifiez que %3 est correct pour chaque ligne pour ce %4." }, { "lang": "FRB", "txt": "Vérifiez que %3 est correct pour chaque ligne pour ce %4." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text018Lbl: Label 'Your reversing entries for %1 are out of balance by %2. ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Vos écritures contrepassées pour %1 présentent un déséquilibre de compte de %2. " }, { "lang": "FRB", "txt": "Vos écritures contrepassées pour %1 présentent un déséquilibre de compte de %2. " }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text019Lbl: Label '%3 %1 is out of balance due to the additional reporting currency. ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "%3 %1 n''est pas équilibré(e) à cause de la devise report. " }, { "lang": "FRB", "txt": "%3 %1 n''est pas équilibré(e) à cause de la devise report. " }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text020Lbl: Label 'Please check that %2 is correct for each line.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Vérifiez que %2 est correct pour chaque ligne." }, { "lang": "FRB", "txt": "Vérifiez que %2 est correct pour chaque ligne." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text021Lbl: Label 'cannot be specified when using recurring journals.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "ne peut pas être spécifié(e) lorsque vous utilisez une feuille abonnement." }, { "lang": "FRB", "txt": "ne peut pas être spécifié(e) lorsque vous utilisez une feuille abonnement." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text022Lbl: Label 'The Balance and Reversing Balance recurring methods can be used only for G/L accounts.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Les modes abonnement Solde et Solde inverse peuvent uniquement être utilisés pour les comptes généraux." }, { "lang": "FRB", "txt": "Les modes abonnement Solde et Solde inverse peuvent uniquement être utilisés pour les comptes généraux." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text023Lbl: Label 'Allocations can only be used with recurring journals.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Les ventilations ne peuvent être utilisées qu''avec des feuilles abonnement." }, { "lang": "FRB", "txt": "Les ventilations ne peuvent être utilisées qu''avec des feuilles abonnement." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text024Lbl: Label '<Month Text>', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "<Month Text>" }, { "lang": "FRB", "txt": "<Month Text>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text025Lbl: Label 'A maximum of %1 posting number series can be used in each journal.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Chaque feuille peut utiliser au maximum %1 souche(s) de numéros." }, { "lang": "FRB", "txt": "Chaque feuille peut utiliser au maximum %1 souche(s) de numéros." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text026Lbl: Label '%5 %2 is out of balance by %1 %7. ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "%5 %2 présente un déséquilibre de compte de %1 %7. " }, { "lang": "FRB", "txt": "%5 %2 présente un déséquilibre de compte de %1 %7. " }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text027Lbl: Label 'The lines in %1 are out of balance by %2 %5. ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Les lignes de %1 sont déséquilibrées par %2 %5. " }, { "lang": "FRB", "txt": "Les lignes de %1 sont déséquilibrées par %2 %5. " }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text028Lbl: Label 'The Balance and Reversing Balance recurring methods can be used only with Allocations.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Les modes abonnement Solde et Solde inverse ne peuvent être utilisés qu''avec des ventilations." }, { "lang": "FRB", "txt": "Les modes abonnement Solde et Solde inverse ne peuvent être utilisés qu''avec des ventilations." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text029Lbl: Label '%1 %2 posted on %3 includes more than one customer, vendor or IC Partner.', Comment = '{ "instructions": "%1 = Document Type;%2 = Document No.;%3=Posting Date", "translations": [ { "lang": "FRA", "txt": "La comptabilisation de %1 %2 sur %3 concerne plusieurs clients, fournisseurs ou partenaires IC. " }, { "lang": "FRB", "txt": "La comptabilisation de %1 %2 sur %3 concerne plusieurs clients, fournisseurs ou partenaires IC. " }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text030Lbl: Label 'You cannot enter G/L Account or Bank Account in both %1 and %2.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Vous ne pouvez pas entrer de compte général ni de compte bancaire dans les champs %1 et %2." }, { "lang": "FRB", "txt": "Vous ne pouvez pas entrer de compte général ni de compte bancaire dans les champs %1 et %2." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text031Lbl: Label 'Line No. %1 does not contain a G/L Account or Bank Account. When the %2 field contains an account number, either the %3 field or the %4 field must contain a G/L Account or Bank Account.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "La ligne %1 ne contient ni compte général ni compte bancaire. Lorsque le champ %2 affiche un numéro de compte, l''un des champs %3 ou %4 doit contenir un numéro de compte général ou bancaire." }, { "lang": "FRB", "txt": "La ligne %1 ne contient ni compte général ni compte bancaire. Lorsque le champ %2 affiche un numéro de compte, l''un des champs %3 ou %4 doit contenir un numéro de compte général ou bancaire." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        RefPostingState: Option "Checking lines","Checking balance","Updating bal. lines","Posting Lines","Posting revers. lines","Updating lines";
        PreviewMode: Boolean;
        SkippedLineMsg: Label 'One or more lines has not been posted because the amount is zero.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Une ou plusieurs lignes n''ont pas été validées car le montant est égal à zéro." }, { "lang": "FRB", "txt": "Une ou plusieurs lignes n''ont pas été validées car le montant est égal à zéro." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        ConfirmPostingAfterCurrentPeriodQst: Label 'The posting date of one or more journal lines is after the current calendar date. Do you want to continue?', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "La date comptabilisation d''une ou plusieurs lignes feuille se trouve en dehors de l''exercice fiscal. Souhaitez-vous continuer ?" }, { "lang": "FRB", "txt": "La date comptabilisation d''une ou plusieurs lignes feuille se trouve en dehors de l''exercice fiscal. Souhaitez-vous continuer ?" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        SuppressCommit: Boolean;

    local procedure "Code"(var GenJournalLine: Record "Gen. Journal Line")
    var
        TemplGenJournalLine: Record "Gen. Journal Line" temporary;
        RaiseError: Boolean;
    begin
        OnBeforeCode(GenJournalLine, PreviewMode, SuppressCommit);

        GenJournalLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");

        GenJournalLine.LockTable();
        GenJnlAllocation.LockTable();

        GenJournalTemplate.Get(GenJournalLine."Journal Template Name");
        GenJournalBatch.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name");

        OnBeforeRaiseExceedLengthError(GenJournalBatch, RaiseError);

        if GenJournalTemplate.Recurring then begin
            TemplGenJournalLine.Copy(GenJournalLine);
            CheckGenJnlLineDates(TemplGenJournalLine, GenJournalLine);
            TemplGenJournalLine.SetRange("Posting Date", 0D, WorkDate());
            GeneralLedgerSetup.Get();
        end;

        if GenJournalTemplate.Recurring then begin
            ProcessLines(TemplGenJournalLine);
            GenJournalLine.Copy(TemplGenJournalLine);
        end else
            ProcessLines(GenJournalLine);

        OnAfterCode(GenJournalLine, PreviewMode);
    end;

    local procedure ProcessLines(var GenJournalLine: Record "Gen. Journal Line")
    var
        TemplGenJournalLine: Record "Gen. Journal Line" temporary;
        GenJournalLineVATInfoSource: Record "Gen. Journal Line";
        recPostGenJournalLine: record "Posted Gen. Journal Line";
        UpdateAnalysisView: Codeunit "Update Analysis View";
        //ICOutboxExport: Codeunit ACYICOutboxExport;
        // ICLastDocNo: Code[20];
        CurrentICPartner: Code[20];
        LastLineNo: Integer;
        //LastICTransactionNo: Integer;
        ICTransactionNo: Integer;
        // ICLastDocType: Integer;
        // ICLastDate: Date;
        VATInfoSourceLineIsInserted: Boolean;
        SkippedLine: Boolean;
        PostingAfterCurrentFiscalYearConfirmed: Boolean;
        IsHandled: Boolean;
    begin
        OnBeforeProcessLines(GenJournalLine, PreviewMode, SuppressCommit);

        if not GenJournalLine.Find('=><') then begin
            GenJournalLine."Line No." := 0;
            if PreviewMode then
                GenJnlPostPreview.ThrowError();
            if not SuppressCommit then
                Commit();
            exit;
        end;

        Dialog.Open(PostingStateMsg);
        Dialog.Update(1, GenJournalLine."Journal Batch Name");

        // Check lines
        LineCount := 0;
        StartLineNo := GenJournalLine."Line No.";
        NoOfRecords := GenJournalLine.Count();
        GenJnlCheckLine.SetBatchMode(true);
        repeat
            LineCount := LineCount + 1;
            UpdateDialog(RefPostingState::"Checking lines", LineCount, NoOfRecords);
            CheckLine(GenJournalLine, PostingAfterCurrentFiscalYearConfirmed);
            TemplGenJournalLine := GenJournalLine5;
            TemplGenJournalLine.Insert();
            if GenJournalLine.Next() = 0 then
                GenJournalLine.FindFirst();
        until GenJournalLine."Line No." = StartLineNo;
        if GenJournalTemplate.Type = GenJournalTemplate.Type::Intercompany then
            CheckICDocument(TemplGenJournalLine);

#pragma warning disable AA0205
        ProcessBalanceOfLines(GenJournalLine, GenJournalLineVATInfoSource, VATInfoSourceLineIsInserted, LastLineNo, CurrentICPartner);
#pragma warning restore AA0205

        // Find next register no.
        GLEntry.LockTable();
        if GLEntry.FindLast() then;
        SourceCode.GET(GenJournalLine."Source Code");
        IF SourceCode."CIR Situation" THEN BEGIN
            IF GLEntry.FINDFIRST() THEN;
        END ELSE
            IF GLEntry.FINDLAST() THEN;
        FindNextGLRegisterNo();

        // Post lines
        LineCount := 0;
        LastDocNo := '';
        LastPostedDocNo := '';
        if GenJournalBatch."Copy to Posted Jnl. Lines" then begin
            recPostGenJournalLine.SETRANGE("G/L Register No.", GLRegNo);
            if recPostGenJournalLine.FINDSET() then
                recPostGenJournalLine.DeleteAll();
        end;

        //LastICTransactionNo := 0;
        TempGenJournalLine4.DeleteAll();
        NoOfReversingRecords := 0;
        GenJournalLine.FindSet();
        repeat
            //sProcessICLines(CurrentICPartner, ICTransactionNo, ICLastDocNo, ICLastDate, ICLastDocType, GenJournalLine, TempGenJnlLine);
            //ProcessICTransaction(LastICTransactionNo, ICTransactionNo);
            GenJournalLine3 := GenJournalLine;
#pragma warning disable AA0205
            if not PostGenJournalLine(GenJournalLine3, CurrentICPartner, ICTransactionNo) then
#pragma warning restore AA0205
                SkippedLine := true;
        until GenJournalLine.Next() = 0;

        /*if LastICTransactionNo > 0 then
            ICOutboxExport.ProcessAutoSendOutboxTransactionNo(ICTransactionNo);*/

        // Post reversing lines
        PostReversingLines(TempGenJournalLine4);

        OnProcessLinesOnAfterPostGenJnlLines(GenJournalLine, GLRegister, GLRegNo);

        // Copy register no. and current journal batch name to general journal
        IsHandled := false;
        OnProcessLinesOnBeforeSetGLRegNoToZero(GenJournalLine, GLRegNo, IsHandled);
        if not IsHandled then
            IF SourceCode."CIR Situation" THEN BEGIN
                IF NOT GLRegister.FINDFIRST() OR (GLRegister."No." <> GLRegNo) THEN
                    GLRegNo := 0;
            END ELSE
                IF NOT GLRegister.FINDLAST() OR (GLRegister."No." <> GLRegNo) THEN
                    GLRegNo := 0;

        GenJournalLine.Init();
        GenJournalLine."Line No." := GLRegNo;

        OnProcessLinesOnAfterAssignGLNegNo(GenJournalLine, GLRegister, GLRegNo);

        if PreviewMode then begin
            OnBeforeThrowPreviewError(GenJournalLine, GLRegNo);
            GenJnlPostPreview.ThrowError();
        end;

        // Update/delete lines
        if GLRegNo <> 0 then
            UpdateAndDeleteLines(GenJournalLine);

        if GenJournalBatch."No. Series" <> '' then
            NoSeriesManagement.SaveNoSeries();
        if TempNoSeries.FindSet() then
            repeat
                Evaluate(PostingNoSeriesNo, TempNoSeries.Description);
                NoSeriesMgt2[PostingNoSeriesNo].SaveNoSeries();
            until TempNoSeries.Next() = 0;

        OnBeforeCommit(GLRegNo, GenJournalLine, CIRGenJnlPostLine);

        if not SuppressCommit then
            Commit();
        Clear(GenJnlCheckLine);
        Clear(CIRGenJnlPostLine);
        GenJournalLine.ClearMarks();
        UpdateAnalysisView.UpdateAll(0, true);
        //GenJnlBatch.OnMoveGenJournalBatch(GLReg.RecordId);
        if not SuppressCommit then
            Commit();

        if SkippedLine and GuiAllowed() then
            Message(SkippedLineMsg);

        OnAfterProcessLines(TemplGenJournalLine);
    end;

#pragma warning disable AA0137
    local procedure ProcessBalanceOfLines(var GenJournalLine: Record "Gen. Journal Line"; var GenJournalLineVATInfoSource: Record "Gen. Journal Line"; var VATInfoSourceLineIsInserted: Boolean; var LastLineNo: Integer; CurrentICPartner: Code[20])
#pragma warning restore AA0137
    var
        VATPostingSetup: Record "VAT Posting Setup";
        BalVATPostingSetup: Record "VAT Posting Setup";
        ErrorMessage: Text;
        LastDocTypeOption: Option;
        ForceCheckBalance: Boolean;
        IsProcessingKeySet: Boolean;
    begin
        IsProcessingKeySet := false;
        OnBeforeProcessBalanceOfLines(GenJournalLine, GenJournalBatch, GenJournalTemplate, IsProcessingKeySet);
        if not IsProcessingKeySet then
            if (GenJournalBatch."No. Series" = '') and (GenJournalBatch."Posting No. Series" = '') and GenJournalTemplate."Force Doc. Balance" then
                GenJournalLine.SetCurrentKey("Document No.");

        LineCount := 0;
        LastDate := 0D;
        LastDocType := LastDocType::" ";
        LastDocNo := '';
        LastFAAddCurrExchRate := 0;
        TempGenJournalLine.Reset();
        TempGenJournalLine.DeleteAll();
        VATEntryCreated := false;
        CurrentBalance := 0;
        CurrentBalanceReverse := 0;
        CurrencyBalance := 0;

        GenJournalLine.FindSet();
        LastCurrencyCode := GenJournalLine."Currency Code";

        repeat
            LineCount := LineCount + 1;
            UpdateDialog(RefPostingState::"Checking balance", LineCount, NoOfRecords);

            if not GenJournalLine.EmptyLine() then begin
                if not PreviewMode then
                    GenJournalLine.CheckDocNoBasedOnNoSeries(LastDocNo, GenJournalBatch."No. Series", NoSeriesManagement);
                if GenJournalLine."Posting No. Series" <> '' then
                    GenJournalLine.TestField("Posting No. Series", GenJournalBatch."Posting No. Series");
                CheckCorrection(GenJournalLine);
            end;
            LastDocTypeOption := LastDocType.AsInteger();
            OnBeforeIfCheckBalance(GenJournalTemplate, GenJournalLine, LastDocTypeOption, LastDocNo, LastDate, ForceCheckBalance, SuppressCommit);
            LastDocType := "Gen. Journal Document Type".FromInteger(LastDocTypeOption);
            if ForceCheckBalance or (GenJournalLine."Posting Date" <> LastDate) or GenJournalTemplate."Force Doc. Balance" and
               ((GenJournalLine."Document Type" <> LastDocType) or (GenJournalLine."Document No." <> LastDocNo))
            then begin
                CheckBalance(GenJournalLine);
                CurrencyBalance := 0;
                LastCurrencyCode := GenJournalLine."Currency Code";
                TempGenJournalLine.Reset();
                TempGenJournalLine.DeleteAll();
            end;

            if IsNonZeroAmount(GenJournalLine) then begin
                if LastFAAddCurrExchRate <> GenJournalLine."FA Add.-Currency Factor" then
                    CheckAddExchRateBalance(GenJournalLine);
                if (CurrentBalance = 0) and (CurrentICPartner = '') then begin
                    TempGenJournalLine.Reset();
                    TempGenJournalLine.DeleteAll();
                    if VATEntryCreated and VATInfoSourceLineIsInserted then
                        UpdateGenJnlLineWithVATInfo(GenJournalLine, GenJournalLineVATInfoSource, StartLineNo, LastLineNo);
                    VATEntryCreated := false;
                    VATInfoSourceLineIsInserted := false;
                    StartLineNo := GenJournalLine."Line No.";
                end;
                if CurrentBalanceReverse = 0 then
                    StartLineNoReverse := GenJournalLine."Line No.";
                GenJournalLine.UpdateLineBalance();
                OnAfterUpdateLineBalance(GenJournalLine);
                CurrentBalance := CurrentBalance + GenJournalLine."Balance (LCY)";
                if GenJournalLine."Recurring Method".AsInteger() >= GenJournalLine."Recurring Method"::"RF Reversing Fixed".AsInteger() then
                    CurrentBalanceReverse := CurrentBalanceReverse + GenJournalLine."Balance (LCY)";

                UpdateCurrencyBalanceForRecurringLine(GenJournalLine);
            end;

            LastDate := GenJournalLine."Posting Date";
            LastDocType := GenJournalLine."Document Type";
            if not GenJournalLine.EmptyLine() then
                LastDocNo := GenJournalLine."Document No.";
            LastFAAddCurrExchRate := GenJournalLine."FA Add.-Currency Factor";
            if GenJournalTemplate."Force Doc. Balance" then begin
                if not VATPostingSetup.Get(GenJournalLine."VAT Bus. Posting Group", GenJournalLine."VAT Prod. Posting Group") then
                    Clear(VATPostingSetup);
                if not BalVATPostingSetup.Get(GenJournalLine."Bal. VAT Bus. Posting Group", GenJournalLine."Bal. VAT Prod. Posting Group") then
                    Clear(BalVATPostingSetup);
                VATEntryCreated :=
                  VATEntryCreated or
                  ((GenJournalLine."Account Type" = GenJournalLine."Account Type"::"G/L Account") and (GenJournalLine."Account No." <> '') and
                   (GenJournalLine."Gen. Posting Type" in [GenJournalLine."Gen. Posting Type"::Purchase, GenJournalLine."Gen. Posting Type"::Sale]) and
                   (VATPostingSetup."VAT %" <> 0)) or
                  ((GenJournalLine."Bal. Account Type" = GenJournalLine."Bal. Account Type"::"G/L Account") and (GenJournalLine."Bal. Account No." <> '') and
                   (GenJournalLine."Bal. Gen. Posting Type" in [GenJournalLine."Bal. Gen. Posting Type"::Purchase, GenJournalLine."Bal. Gen. Posting Type"::Sale]) and
                   (BalVATPostingSetup."VAT %" <> 0));
                if TempGenJournalLine.IsCustVendICAdded(GenJournalLine) then begin
                    GenJournalLineVATInfoSource := GenJournalLine;
                    VATInfoSourceLineIsInserted := true;
                end;
                if (TempGenJournalLine.Count() > 1) and VATEntryCreated then begin
                    ErrorMessage := Text009Lbl + Text010Lbl;
                    Error(ErrorMessage, GenJournalLine."Document Type", GenJournalLine."Document No.", GenJournalLine."Posting Date");
                end;
                if (TempGenJournalLine.Count() > 1) and (CurrentICPartner <> '') and
                   (GenJournalTemplate.Type = GenJournalTemplate.Type::Intercompany)
                then
                    Error(
                      Text029Lbl,
                      GenJournalLine."Document Type", GenJournalLine."Document No.", GenJournalLine."Posting Date");
                LastLineNo := GenJournalLine."Line No.";
            end;
        until GenJournalLine.Next() = 0;
        CheckBalance(GenJournalLine);
        CopyFields(GenJournalLine);
        if VATEntryCreated and VATInfoSourceLineIsInserted then
            UpdateGenJnlLineWithVATInfo(GenJournalLine, GenJournalLineVATInfoSource, StartLineNo, LastLineNo);

        OnAfterProcessBalanceOfLines(GenJournalLine);
    end;

#pragma warning disable AA0228
    local procedure ProcessICLines(var CurrentICPartner: Code[20]; var ICTransactionNo: Integer; var ICLastDocNo: Code[20]; var ICLastDate: Date; var ICLastDocType: Enum "Gen. Journal Document Type"; var GenJournalLine: Record "Gen. Journal Line"; var pTempGenJournalLine: Record "Gen. Journal Line" temporary)
#pragma warning restore AA0228
    var
        HandledICInboxTrans: Record "Handled IC Inbox Trans.";
    begin
        if (GenJournalTemplate.Type = GenJournalTemplate.Type::Intercompany) and not GenJournalLine.EmptyLine() and
   ((GenJournalLine."Posting Date" <> ICLastDate) or (GenJournalLine."Document Type" <> ICLastDocType) or (GenJournalLine."Document No." <> ICLastDocNo))
then begin
            CurrentICPartner := '';
            ICLastDate := GenJournalLine."Posting Date";
            ICLastDocType := GenJournalLine."Document Type";
            ICLastDocNo := GenJournalLine."Document No.";
            pTempGenJournalLine.Reset();
            pTempGenJournalLine.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
            pTempGenJournalLine.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
            pTempGenJournalLine.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
            pTempGenJournalLine.SetRange("Posting Date", GenJournalLine."Posting Date");
            pTempGenJournalLine.SetRange("Document No.", GenJournalLine."Document No.");
            pTempGenJournalLine.SetFilter("IC Partner Code", '<>%1', '');
            if pTempGenJournalLine.FindFirst() and (pTempGenJournalLine."IC Partner Code" <> '') then begin
                CurrentICPartner := pTempGenJournalLine."IC Partner Code";
                if pTempGenJournalLine."IC Direction" = pTempGenJournalLine."IC Direction"::Outgoing then
                    ICTransactionNo := ICInboxOutboxMgt.CreateOutboxJnlTransaction(pTempGenJournalLine, false)
                else
                    if HandledICInboxTrans.Get(
                         pTempGenJournalLine."IC Partner Transaction No.", pTempGenJournalLine."IC Partner Code",
                         HandledICInboxTrans."Transaction Source"::"Created by Partner", pTempGenJournalLine."Document Type")
                    then begin
                        HandledICInboxTrans.LockTable();
                        HandledICInboxTrans.Status := HandledICInboxTrans.Status::Posted;
                        HandledICInboxTrans.Modify();
                    end
            end
        end;
    end;

    local procedure CheckBalance(var GenJournalLine: Record "Gen. Journal Line")
    begin
        OnBeforeCheckBalance(
          GenJournalTemplate, GenJournalLine, CurrentBalance, CurrentBalanceReverse, CurrencyBalance,
          StartLineNo, StartLineNoReverse, LastDocType.AsInteger(), LastDocNo, LastDate, LastCurrencyCode, SuppressCommit);

        if CurrentBalance <> 0 then begin
            GenJournalLine.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name", StartLineNo);
            if GenJournalTemplate."Force Doc. Balance" then
                Error(
#pragma warning disable AA0231
                  Text012Lbl +
                  Text013Lbl,
#pragma warning restore AA0231
                  CurrentBalance, LastDocNo, GenJournalLine.FieldCaption("Posting Date"), GenJournalLine.FieldCaption("Document Type"),
                  GenJournalLine.FieldCaption("Document No."), GenJournalLine.FieldCaption(Amount));
            Error(
#pragma warning disable AA0231
              Text014Lbl +
              Text015Lbl,
#pragma warning restore AA0231
              LastDate, CurrentBalance, GenJournalLine.FieldCaption("Posting Date"), GenJournalLine.FieldCaption(Amount));
        end;
        if CurrentBalanceReverse <> 0 then begin
            GenJournalLine.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name", StartLineNoReverse);
            if GenJournalTemplate."Force Doc. Balance" then
                Error(
#pragma warning disable AA0231
                  Text016Lbl +
                  Text017Lbl,
#pragma warning restore AA0231
                  CurrentBalanceReverse, LastDocNo, GenJournalLine.FieldCaption("Recurring Method"), GenJournalLine.FieldCaption("Document No."));
            Error(
#pragma warning disable AA0231
              Text018Lbl +
              Text017Lbl,
#pragma warning restore AA0231
              LastDate, CurrentBalanceReverse, GenJournalLine.FieldCaption("Recurring Method"), GenJournalLine.FieldCaption("Posting Date"));
        end;
        if (LastCurrencyCode <> '') and (CurrencyBalance <> 0) then begin
            GenJournalLine.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name", StartLineNo);
            if GenJournalTemplate."Force Doc. Balance" then
                Error(
#pragma warning disable AA0231
                  Text026Lbl +
                  Text013Lbl,
#pragma warning restore AA0231
                  CurrencyBalance, LastDocNo, GenJournalLine.FieldCaption("Posting Date"), GenJournalLine.FieldCaption("Document Type"),
                  GenJournalLine.FieldCaption("Document No."), GenJournalLine.FieldCaption(Amount),
                  LastCurrencyCode);
            Error(
#pragma warning disable AA0231
              Text027Lbl +
              Text015Lbl,
#pragma warning restore AA0231
              LastDate, CurrencyBalance, GenJournalLine.FieldCaption("Posting Date"), GenJournalLine.FieldCaption(Amount), LastCurrencyCode);
        end;
    end;

    local procedure CheckCorrection(GenJournalLine: Record "Gen. Journal Line")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCheckCorrection(GenJournalLine, IsHandled);
        if IsHandled then
            exit;

        if (GenJournalLine."Posting Date" <> LastDate) or (GenJournalLine."Document Type" <> LastDocType) or (GenJournalLine."Document No." <> LastDocNo) then begin
            if GenJournalLine.Correction then
                GenJournalTemplate.TestField("Force Doc. Balance", true);
            DocCorrection := GenJournalLine.Correction;
        end else
            if GenJournalLine.Correction <> DocCorrection then
                GenJournalLine.FieldError(Correction, Text008Lbl);
    end;

    local procedure CheckAddExchRateBalance(GenJournalLine: Record "Gen. Journal Line")
    begin
        if CurrentBalance <> 0 then
            Error(
#pragma warning disable AA0231
              Text019Lbl +
              Text020Lbl,
#pragma warning restore AA0231
              LastDocNo, GenJournalLine.FieldCaption("FA Add.-Currency Factor"), GenJournalLine.FieldCaption("Document No."));
    end;

    local procedure CheckRecurringLine(var pGenJournalLine2: Record "Gen. Journal Line")
    var
        DummyDateFormula: DateFormula;
    begin
        if pGenJournalLine2."Account No." <> '' then
            if GenJournalTemplate.Recurring then begin
                pGenJournalLine2.TestField("Recurring Method");
                pGenJournalLine2.TestField("Recurring Frequency");
                if pGenJournalLine2."Bal. Account No." <> '' then
                    pGenJournalLine2.FieldError("Bal. Account No.", Text021Lbl);
                case pGenJournalLine2."Recurring Method" of
                    pGenJournalLine2."Recurring Method"::"V  Variable", pGenJournalLine2."Recurring Method"::"RV Reversing Variable",
                  pGenJournalLine2."Recurring Method"::"F  Fixed", pGenJournalLine2."Recurring Method"::"RF Reversing Fixed":
                        if not pGenJournalLine2."Allow Zero-Amount Posting" then
                            pGenJournalLine2.TestField(Amount);
                    pGenJournalLine2."Recurring Method"::"B  Balance", pGenJournalLine2."Recurring Method"::"RB Reversing Balance":
                        pGenJournalLine2.TestField(Amount, 0);
                end;
            end else begin
                pGenJournalLine2.TestField("Recurring Method", 0);
                pGenJournalLine2.TestField("Recurring Frequency", DummyDateFormula);
            end;
    end;

    local procedure UpdateRecurringAmt(var pGenJournalLine2: Record "Gen. Journal Line"): Boolean
    begin
        if (pGenJournalLine2."Account No." <> '') and
   (pGenJournalLine2."Recurring Method" in
    [pGenJournalLine2."Recurring Method"::"B  Balance", pGenJournalLine2."Recurring Method"::"RB Reversing Balance"])
then begin
            GLEntry.LockTable();
            if pGenJournalLine2."Account Type" = pGenJournalLine2."Account Type"::"G/L Account" then begin
                GLAccount."No." := pGenJournalLine2."Account No.";
                GLAccount.SetRange("Date Filter", 0D, pGenJournalLine2."Posting Date");
                if GeneralLedgerSetup."Additional Reporting Currency" <> '' then begin
                    pGenJournalLine2."Source Currency Code" := GeneralLedgerSetup."Additional Reporting Currency";
                    GLAccount.CalcFields("Additional-Currency Net Change");
                    pGenJournalLine2."Source Currency Amount" := -GLAccount."Additional-Currency Net Change";
                    GenJnlAllocation.UpdateAllocationsAddCurr(pGenJournalLine2, pGenJournalLine2."Source Currency Amount");
                end;
                GLAccount.CalcFields("Net Change");
                pGenJournalLine2.Validate(Amount, -GLAccount."Net Change");
                exit(true);
            end;
            Error(Text022Lbl);
        end;
        exit(false);
    end;

    local procedure CheckAllocations(var pGenJournalLine2: Record "Gen. Journal Line")
    begin
        if pGenJournalLine2."Account No." <> '' then begin
            if pGenJournalLine2."Recurring Method" in
               [pGenJournalLine2."Recurring Method"::"B  Balance",
                pGenJournalLine2."Recurring Method"::"RB Reversing Balance"]
            then begin
                GenJnlAllocation.Reset();
                GenJnlAllocation.SetRange("Journal Template Name", pGenJournalLine2."Journal Template Name");
                GenJnlAllocation.SetRange("Journal Batch Name", pGenJournalLine2."Journal Batch Name");
                GenJnlAllocation.SetRange("Journal Line No.", pGenJournalLine2."Line No.");
                if GenJnlAllocation.IsEmpty() then
                    Error(
                      Text028Lbl);
            end;

            GenJnlAllocation.Reset();
            GenJnlAllocation.SetRange("Journal Template Name", pGenJournalLine2."Journal Template Name");
            GenJnlAllocation.SetRange("Journal Batch Name", pGenJournalLine2."Journal Batch Name");
            GenJnlAllocation.SetRange("Journal Line No.", pGenJournalLine2."Line No.");
            GenJnlAllocation.SetFilter(Amount, '<>0');
            if not GenJnlAllocation.IsEmpty() then begin
                if not GenJournalTemplate.Recurring then
                    Error(Text023Lbl);
                GenJnlAllocation.SetRange("Account No.", '');
                if GenJnlAllocation.FindFirst() then
                    GenJnlAllocation.TestField("Account No.");
            end;
        end;
    end;

    local procedure MakeRecurringTexts(var pGenJournalLine2: Record "Gen. Journal Line")
    begin
        if (pGenJournalLine2."Account No." <> '') and (pGenJournalLine2."Recurring Method" <> "Gen. Journal Recurring Method"::" ") then begin
            Day := Date2DMY(pGenJournalLine2."Posting Date", 1);
            Week := Date2DWY(pGenJournalLine2."Posting Date", 2);
            Month := Date2DMY(pGenJournalLine2."Posting Date", 2);
            MonthText := Format(pGenJournalLine2."Posting Date", 0, Text024Lbl);
            AccountingPeriod.SetRange("Starting Date", 0D, pGenJournalLine2."Posting Date");
            if not AccountingPeriod.FindLast() then
                AccountingPeriod.Name := '';
            pGenJournalLine2."Document No." :=
              CopyStr(DelChr(
                PadStr(
                  StrSubstNo(pGenJournalLine2."Document No.", Day, Week, Month, MonthText, AccountingPeriod.Name),
                  MaxStrLen(pGenJournalLine2."Document No.")),
                '>'), 1, MaxStrLen(pGenJournalLine2."Document No."));
            pGenJournalLine2.Description :=
              CopyStr(DelChr(
                PadStr(
                  StrSubstNo(pGenJournalLine2.Description, Day, Week, Month, MonthText, AccountingPeriod.Name),
                  MaxStrLen(pGenJournalLine2.Description)),
                '>'), 1, MaxStrLen(pGenJournalLine2.Description));
            OnAfterMakeRecurringTexts(pGenJournalLine2, AccountingPeriod, Day, Week, Month, MonthText);
        end;
    end;

    local procedure PostAllocations(var AllocateGenJournalLine: Record "Gen. Journal Line"; Reversing: Boolean)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforePostAllocations(AllocateGenJournalLine, Reversing, IsHandled);
        if IsHandled then
            exit;

        if AllocateGenJournalLine."Account No." <> '' then begin
            GenJnlAllocation.Reset();
            GenJnlAllocation.SetRange("Journal Template Name", AllocateGenJournalLine."Journal Template Name");
            GenJnlAllocation.SetRange("Journal Batch Name", AllocateGenJournalLine."Journal Batch Name");
            GenJnlAllocation.SetRange("Journal Line No.", AllocateGenJournalLine."Line No.");
            GenJnlAllocation.SetFilter("Account No.", '<>%1', '');
            if GenJnlAllocation.FindSet() then begin
                GenJournalLine2.Init();
                GenJournalLine2."Account Type" := GenJournalLine2."Account Type"::"G/L Account";
                GenJournalLine2."Posting Date" := AllocateGenJournalLine."Posting Date";
                GenJournalLine2."Document Type" := AllocateGenJournalLine."Document Type";
                GenJournalLine2."Document No." := AllocateGenJournalLine."Document No.";
                GenJournalLine2.Description := AllocateGenJournalLine.Description;
                GenJournalLine2."Source Code" := AllocateGenJournalLine."Source Code";
                GenJournalLine2."Journal Batch Name" := AllocateGenJournalLine."Journal Batch Name";
                GenJournalLine2."Line No." := AllocateGenJournalLine."Line No.";
                GenJournalLine2."Reason Code" := AllocateGenJournalLine."Reason Code";
                GenJournalLine2.Correction := AllocateGenJournalLine.Correction;
                GenJournalLine2."Recurring Method" := AllocateGenJournalLine."Recurring Method";
                if AllocateGenJournalLine."Account Type" in [AllocateGenJournalLine."Account Type"::Customer, AllocateGenJournalLine."Account Type"::Vendor] then
                    CopyGenJnlLineBalancingData(GenJournalLine2, AllocateGenJournalLine);
                OnPostAllocationsOnBeforeCopyFromGenJnlAlloc(GenJournalLine2, AllocateGenJournalLine, Reversing);
                repeat
                    GenJournalLine2.CopyFromGenJnlAllocation(GenJnlAllocation);
                    GenJournalLine2."Shortcut Dimension 1 Code" := GenJnlAllocation."Shortcut Dimension 1 Code";
                    GenJournalLine2."Shortcut Dimension 2 Code" := GenJnlAllocation."Shortcut Dimension 2 Code";
                    GenJournalLine2."Dimension Set ID" := GenJnlAllocation."Dimension Set ID";
                    GenJournalLine2."Allow Zero-Amount Posting" := true;
                    OnPostAllocationsOnBeforePrepareGenJnlLineAddCurr(GenJournalLine2, AllocateGenJournalLine);
                    PrepareGenJnlLineAddCurr(GenJournalLine2);
                    if not Reversing then begin
                        OnPostAllocationsOnBeforePostNotReversingLine(GenJournalLine2, CIRGenJnlPostLine);
                        CIRGenJnlPostLine.RunWithCheck(GenJournalLine2);
                        if AllocateGenJournalLine."Recurring Method" in
                           [AllocateGenJournalLine."Recurring Method"::"V  Variable", AllocateGenJournalLine."Recurring Method"::"B  Balance"]
                        then begin
                            GenJnlAllocation.Amount := 0;
                            GenJnlAllocation."Additional-Currency Amount" := 0;
                            GenJnlAllocation.Modify();
                        end;
                    end else begin
                        MultiplyAmounts(GenJournalLine2, -1);
                        GenJournalLine2."Reversing Entry" := true;
                        OnPostAllocationsOnBeforePostReversingLine(GenJournalLine2, CIRGenJnlPostLine);
                        CIRGenJnlPostLine.RunWithCheck(GenJournalLine2);
                        if AllocateGenJournalLine."Recurring Method" in
                           [AllocateGenJournalLine."Recurring Method"::"RV Reversing Variable",
                            AllocateGenJournalLine."Recurring Method"::"RB Reversing Balance"]
                        then begin
                            GenJnlAllocation.Amount := 0;
                            GenJnlAllocation."Additional-Currency Amount" := 0;
                            GenJnlAllocation.Modify();
                        end;
                    end;
                until GenJnlAllocation.Next() = 0;
            end;
        end;

        OnAfterPostAllocations(AllocateGenJournalLine, Reversing, SuppressCommit);
    end;

    local procedure MultiplyAmounts(var pGenJournalLine2: Record "Gen. Journal Line"; Factor: Decimal)
    begin
        if pGenJournalLine2."Account No." <> '' then begin
            pGenJournalLine2.Amount := pGenJournalLine2.Amount * Factor;
            pGenJournalLine2."Debit Amount" := pGenJournalLine2."Debit Amount" * Factor;
            pGenJournalLine2."Credit Amount" := pGenJournalLine2."Credit Amount" * Factor;
            pGenJournalLine2."Amount (LCY)" := pGenJournalLine2."Amount (LCY)" * Factor;
            pGenJournalLine2."Balance (LCY)" := pGenJournalLine2."Balance (LCY)" * Factor;
            pGenJournalLine2."Sales/Purch. (LCY)" := pGenJournalLine2."Sales/Purch. (LCY)" * Factor;
            pGenJournalLine2."Profit (LCY)" := pGenJournalLine2."Profit (LCY)" * Factor;
            pGenJournalLine2."Inv. Discount (LCY)" := pGenJournalLine2."Inv. Discount (LCY)" * Factor;
            pGenJournalLine2.Quantity := pGenJournalLine2.Quantity * Factor;
            pGenJournalLine2."VAT Amount" := pGenJournalLine2."VAT Amount" * Factor;
            pGenJournalLine2."VAT Base Amount" := pGenJournalLine2."VAT Base Amount" * Factor;
            pGenJournalLine2."VAT Amount (LCY)" := pGenJournalLine2."VAT Amount (LCY)" * Factor;
            pGenJournalLine2."VAT Base Amount (LCY)" := pGenJournalLine2."VAT Base Amount (LCY)" * Factor;
            pGenJournalLine2."Source Currency Amount" := pGenJournalLine2."Source Currency Amount" * Factor;
            if pGenJournalLine2."Job No." <> '' then begin
                pGenJournalLine2."Job Quantity" := pGenJournalLine2."Job Quantity" * Factor;
                pGenJournalLine2."Job Total Cost (LCY)" := pGenJournalLine2."Job Total Cost (LCY)" * Factor;
                pGenJournalLine2."Job Total Price (LCY)" := pGenJournalLine2."Job Total Price (LCY)" * Factor;
                pGenJournalLine2."Job Line Amount (LCY)" := pGenJournalLine2."Job Line Amount (LCY)" * Factor;
                pGenJournalLine2."Job Total Cost" := pGenJournalLine2."Job Total Cost" * Factor;
                pGenJournalLine2."Job Total Price" := pGenJournalLine2."Job Total Price" * Factor;
                pGenJournalLine2."Job Line Amount" := pGenJournalLine2."Job Line Amount" * Factor;
                pGenJournalLine2."Job Line Discount Amount" := pGenJournalLine2."Job Line Discount Amount" * Factor;
                pGenJournalLine2."Job Line Disc. Amount (LCY)" := pGenJournalLine2."Job Line Disc. Amount (LCY)" * Factor;
            end;
        end;

        OnAfterMultiplyAmounts(pGenJournalLine2, Factor, SuppressCommit);
    end;

    local procedure CheckDocumentNo(var pGenJournalLine2: Record "Gen. Journal Line")
    begin
        if pGenJournalLine2."Posting No. Series" = '' then
            pGenJournalLine2."Posting No. Series" := GenJournalBatch."No. Series"
        else
            if not pGenJournalLine2.EmptyLine() then
                if pGenJournalLine2."Document No." = LastDocNo then
                    pGenJournalLine2."Document No." := LastPostedDocNo
                else begin
                    if not TempNoSeries.Get(pGenJournalLine2."Posting No. Series") then begin
                        NoOfPostingNoSeries := NoOfPostingNoSeries + 1;
                        if NoOfPostingNoSeries > ArrayLen(NoSeriesMgt2) then
                            Error(
                              Text025Lbl,
                              ArrayLen(NoSeriesMgt2));
                        TempNoSeries.Code := pGenJournalLine2."Posting No. Series";
                        TempNoSeries.Description := Format(NoOfPostingNoSeries);
                        TempNoSeries.Insert();
                    end;
                    LastDocNo := pGenJournalLine2."Document No.";
                    Evaluate(PostingNoSeriesNo, TempNoSeries.Description);
                    pGenJournalLine2."Document No." :=
                      NoSeriesMgt2[PostingNoSeriesNo].GetNextNo(pGenJournalLine2."Posting No. Series", pGenJournalLine2."Posting Date", true);
                    LastPostedDocNo := pGenJournalLine2."Document No.";
                end;
    end;

    local procedure PrepareGenJnlLineAddCurr(var GenJournalLine: Record "Gen. Journal Line")
    begin
        if (GeneralLedgerSetup."Additional Reporting Currency" <> '') and
           (GenJournalLine."Recurring Method" in
            [GenJournalLine."Recurring Method"::"B  Balance",
             GenJournalLine."Recurring Method"::"RB Reversing Balance"])
        then begin
            GenJournalLine."Source Currency Code" := GeneralLedgerSetup."Additional Reporting Currency";
            if (GenJournalLine.Amount = 0) and
               (GenJournalLine."Source Currency Amount" <> 0)
            then begin
                GenJournalLine."Additional-Currency Posting" :=
                  GenJournalLine."Additional-Currency Posting"::"Additional-Currency Amount Only";
                GenJournalLine.Amount := GenJournalLine."Source Currency Amount";
                GenJournalLine."Source Currency Amount" := 0;
            end;
        end;
    end;

    local procedure CopyFields(var GenJournalLine: Record "Gen. Journal Line")
    var
        GenJournalLine4: Record "Gen. Journal Line";
        GenJournalLine6: Record "Gen. Journal Line";
        TemplGenJournalLine: Record "Gen. Journal Line" temporary;
        JnlLineTotalQty: Integer;
        RefPostingSubState: Option "Check account","Check bal. account","Update lines";
    begin
        GenJournalLine6.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
        GenJournalLine4.FilterGroup(2);
        GenJournalLine4.Copy(GenJournalLine);
        GenJournalLine4.FilterGroup(0);
        GenJournalLine6.FilterGroup(2);
        GenJournalLine6.Copy(GenJournalLine);
        GenJournalLine6.FilterGroup(0);
        GenJournalLine6.SetFilter(
          "Account Type", '<>%1&<>%2', GenJournalLine6."Account Type"::Customer, GenJournalLine6."Account Type"::Vendor);
        GenJournalLine6.SetFilter(
          "Bal. Account Type", '<>%1&<>%2', GenJournalLine6."Bal. Account Type"::Customer, GenJournalLine6."Bal. Account Type"::Vendor);
        GenJournalLine4.SetFilter(
          "Account Type", '%1|%2', GenJournalLine4."Account Type"::Customer, GenJournalLine4."Account Type"::Vendor);
        GenJournalLine4.SetRange("Bal. Account No.", '');
        CheckAndCopyBalancingData(GenJournalLine4, GenJournalLine6, TemplGenJournalLine, false);

        GenJournalLine4.SetRange("Account Type");
        GenJournalLine4.SetRange("Bal. Account No.");
        GenJournalLine4.SetFilter(
          "Bal. Account Type", '%1|%2', GenJournalLine4."Bal. Account Type"::Customer, GenJournalLine4."Bal. Account Type"::Vendor);
        GenJournalLine4.SetRange("Account No.", '');
        CheckAndCopyBalancingData(GenJournalLine4, GenJournalLine6, TemplGenJournalLine, true);

        JnlLineTotalQty := TemplGenJournalLine.Count();
        LineCount := 0;
        if TemplGenJournalLine.FindSet() then
            repeat
                LineCount := LineCount + 1;
                UpdateDialogUpdateBalLines(RefPostingSubState::"Update lines", LineCount, JnlLineTotalQty);
                GenJournalLine4.Get(TemplGenJournalLine."Journal Template Name", TemplGenJournalLine."Journal Batch Name", TemplGenJournalLine."Line No.");
                CopyGenJnlLineBalancingData(GenJournalLine4, TemplGenJournalLine);
                GenJournalLine4.Modify();
            until TemplGenJournalLine.Next() = 0;
    end;

    local procedure CheckICDocument(var TempGenJournalLine1: Record "Gen. Journal Line" temporary)
    var
        TempGenJournalLine2: Record "Gen. Journal Line" temporary;
        CurrentICPartner: Code[20];
    begin
        TempGenJournalLine1.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
        TempGenJournalLine1.SetRange("Journal Template Name", TempGenJournalLine1."Journal Template Name");
        TempGenJournalLine1.SetRange("Journal Batch Name", TempGenJournalLine1."Journal Batch Name");
        TempGenJournalLine1.Find('-');
        repeat
            if (TempGenJournalLine1."Posting Date" <> LastDate) or (TempGenJournalLine1."Document Type" <> LastDocType) or (TempGenJournalLine1."Document No." <> LastDocNo) then begin
                TempGenJournalLine2 := TempGenJournalLine1;
                TempGenJournalLine1.SetRange("Posting Date", TempGenJournalLine1."Posting Date");
                TempGenJournalLine1.SetRange("Document No.", TempGenJournalLine1."Document No.");
                TempGenJournalLine1.SetFilter("IC Partner Code", '<>%1', '');
                if TempGenJournalLine1.Find('-') then
                    CurrentICPartner := TempGenJournalLine1."IC Partner Code"
                else
                    CurrentICPartner := '';
                TempGenJournalLine1.SetRange("Posting Date");
                TempGenJournalLine1.SetRange("Document No.");
                TempGenJournalLine1.SetRange("IC Partner Code");
                LastDate := TempGenJournalLine1."Posting Date";
                LastDocType := TempGenJournalLine1."Document Type";
                LastDocNo := TempGenJournalLine1."Document No.";
                TempGenJournalLine1 := TempGenJournalLine2;
            end;
            if (CurrentICPartner <> '') and (TempGenJournalLine1."IC Direction" = TempGenJournalLine1."IC Direction"::Outgoing) then begin
                if (TempGenJournalLine1."Account Type" in [TempGenJournalLine1."Account Type"::"G/L Account", TempGenJournalLine1."Account Type"::"Bank Account"]) and
                   (TempGenJournalLine1."Bal. Account Type" in [TempGenJournalLine1."Bal. Account Type"::"G/L Account", TempGenJournalLine1."Account Type"::"Bank Account"]) and
                   (TempGenJournalLine1."Account No." <> '') and
                   (TempGenJournalLine1."Bal. Account No." <> '')
                then
                    Error(Text030Lbl, TempGenJournalLine1.FieldCaption("Account No."), TempGenJournalLine1.FieldCaption("Bal. Account No."));
                if ((TempGenJournalLine1."Account Type" in [TempGenJournalLine1."Account Type"::"G/L Account", TempGenJournalLine1."Account Type"::"Bank Account"]) and (TempGenJournalLine1."Account No." <> '')) xor
                   ((TempGenJournalLine1."Bal. Account Type" in [TempGenJournalLine1."Bal. Account Type"::"G/L Account", TempGenJournalLine1."Account Type"::"Bank Account"]) and
                    (TempGenJournalLine1."Bal. Account No." <> ''))
                then
                    TempGenJournalLine1.TestField("IC Account No.")
                else
                    if TempGenJournalLine1."IC Account No." <> '' then
                        Error(Text031Lbl,
                          TempGenJournalLine1."Line No.", TempGenJournalLine1.FieldCaption("IC Account No."), TempGenJournalLine1.FieldCaption("Account No."),
                          TempGenJournalLine1.FieldCaption("Bal. Account No."));
            end else
                TempGenJournalLine1.TestField("IC Account No.", '');
        until TempGenJournalLine1.Next() = 0;
    end;

    local procedure UpdateIncomingDocument(var GenJournalLine: Record "Gen. Journal Line")
    var
        IncomingDocument: Record "Incoming Document";
    begin
        OnBeforeUpdateIncomingDocument(GenJournalLine);
        IncomingDocument.UpdateIncomingDocumentFromPosting(
          GenJournalLine."Incoming Document Entry No.", GenJournalLine."Posting Date", GenJournalLine."Document No.");
    end;

    local procedure CopyGenJnlLineBalancingData(var GenJournalLineTo: Record "Gen. Journal Line"; var GenJournalLineFrom: Record "Gen. Journal Line")
    begin
        GenJournalLineTo."Bill-to/Pay-to No." := GenJournalLineFrom."Bill-to/Pay-to No.";
        GenJournalLineTo."Ship-to/Order Address Code" := GenJournalLineFrom."Ship-to/Order Address Code";
        GenJournalLineTo."VAT Registration No." := GenJournalLineFrom."VAT Registration No.";
        GenJournalLineTo."Country/Region Code" := GenJournalLineFrom."Country/Region Code";
    end;

    local procedure CheckGenPostingType(GenJournalLine6: Record "Gen. Journal Line"; AccountType: Enum "Gen. Journal Account Type")
    var
        IsHandled: Boolean;
    begin
        OnBeforeCheckGenPostingType(GenJournalLine6, AccountType, IsHandled);
        if IsHandled then
            exit;

        if (AccountType = AccountType::Customer) and
           (GenJournalLine6."Gen. Posting Type" = GenJournalLine6."Gen. Posting Type"::Purchase) or
           (AccountType = AccountType::Vendor) and
           (GenJournalLine6."Gen. Posting Type" = GenJournalLine6."Gen. Posting Type"::Sale)
        then
            GenJournalLine6.FieldError("Gen. Posting Type");
        if (AccountType = AccountType::Customer) and
           (GenJournalLine6."Bal. Gen. Posting Type" = GenJournalLine6."Bal. Gen. Posting Type"::Purchase) or
           (AccountType = AccountType::Vendor) and
           (GenJournalLine6."Bal. Gen. Posting Type" = GenJournalLine6."Bal. Gen. Posting Type"::Sale)
        then
            GenJournalLine6.FieldError("Bal. Gen. Posting Type");
    end;

    local procedure CheckAndCopyBalancingData(var GenJournalLine4: Record "Gen. Journal Line"; var GenJournalLine6: Record "Gen. Journal Line"; var pTempGenJournalLine: Record "Gen. Journal Line" temporary; CheckBalAcount: Boolean)
    var
        TempGenJournalLineHistory: Record "Gen. Journal Line" temporary;
        AccountType: Enum "Gen. Journal Account Type";
        CheckAmount: Decimal;
        JnlLineTotalQty: Integer;
        RefPostingSubState: Option "Check account","Check bal. account","Update lines";
        LinesFound: Boolean;
    begin
        JnlLineTotalQty := GenJournalLine4.Count();
        LineCount := 0;
        if CheckBalAcount then
            RefPostingSubState := RefPostingSubState::"Check bal. account"
        else
            RefPostingSubState := RefPostingSubState::"Check account";
        if GenJournalLine4.FindSet() then
            repeat
                LineCount := LineCount + 1;
                UpdateDialogUpdateBalLines(RefPostingSubState, LineCount, JnlLineTotalQty);
                TempGenJournalLineHistory.SetRange("Posting Date", GenJournalLine4."Posting Date");
                TempGenJournalLineHistory.SetRange("Document No.", GenJournalLine4."Document No.");
                if TempGenJournalLineHistory.IsEmpty() then begin
                    TempGenJournalLineHistory := GenJournalLine4;
                    TempGenJournalLineHistory.Insert();
                    GenJournalLine6.SetRange("Posting Date", GenJournalLine4."Posting Date");
                    GenJournalLine6.SetRange("Document No.", GenJournalLine4."Document No.");
                    LinesFound := GenJournalLine6.FindSet();
                end;
                if LinesFound then begin
                    AccountType := GetPostingTypeFilter(GenJournalLine4, CheckBalAcount);
                    CheckAmount := 0;
                    repeat
                        if (GenJournalLine6."Account No." = '') <> (GenJournalLine6."Bal. Account No." = '') then begin
                            CheckGenPostingType(GenJournalLine6, AccountType);
                            if GenJournalLine6."Bill-to/Pay-to No." = '' then begin
                                pTempGenJournalLine := GenJournalLine6;
                                CopyGenJnlLineBalancingData(pTempGenJournalLine, GenJournalLine4);
                                if pTempGenJournalLine.Insert() then;
                            end;
                            CheckAmount := CheckAmount + GenJournalLine6.Amount;
                        end;
                        LinesFound := (GenJournalLine6.Next() <> 0);
                    until not LinesFound or (-GenJournalLine4.Amount = CheckAmount);
                end;
            until GenJournalLine4.Next() = 0;
    end;

    local procedure UpdateGenJnlLineWithVATInfo(var GenJournalLine: Record "Gen. Journal Line"; GenJournalLineVATInfoSource: Record "Gen. Journal Line"; pStartLineNo: Integer; LastLineNo: Integer)
    var
        GenJournalLineCopy: Record "Gen. Journal Line";
        Finish: Boolean;
        OldLineNo: Integer;
    begin
        OldLineNo := GenJournalLine."Line No.";
        GenJournalLine."Line No." := pStartLineNo;
        Finish := false;
        if GenJournalLine.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name", GenJournalLine."Line No.") then
            repeat
                if GenJournalLine."Line No." <> GenJournalLineVATInfoSource."Line No." then begin
                    GenJournalLine."Bill-to/Pay-to No." := GenJournalLineVATInfoSource."Bill-to/Pay-to No.";
                    GenJournalLine."Country/Region Code" := GenJournalLineVATInfoSource."Country/Region Code";
                    GenJournalLine."VAT Registration No." := GenJournalLineVATInfoSource."VAT Registration No.";
                    GenJournalLine.Modify();
                    if GenJournalLine.IsTemporary() then begin
                        GenJournalLineCopy.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name", GenJournalLine."Line No.");
                        GenJournalLineCopy."Bill-to/Pay-to No." := GenJournalLine."Bill-to/Pay-to No.";
                        GenJournalLineCopy."Country/Region Code" := GenJournalLine."Country/Region Code";
                        GenJournalLineCopy."VAT Registration No." := GenJournalLine."VAT Registration No.";
                        GenJournalLineCopy.Modify();
                    end;
                end;
                Finish := GenJournalLine."Line No." = LastLineNo;
            until (GenJournalLine.Next() = 0) or Finish;

        if GenJournalLine.Get(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name", OldLineNo) then;
    end;

    local procedure GetPostingTypeFilter(var GenJournalLine4: Record "Gen. Journal Line"; CheckBalAcount: Boolean): Enum "Gen. Journal Account Type"
    begin
        if CheckBalAcount then
            exit(GenJournalLine4."Bal. Account Type");
        exit(GenJournalLine4."Account Type");
    end;

    local procedure UpdateDialog(PostingState: Integer; LineNo: Integer; TotalLinesQty: Integer)
    begin
        UpdatePostingState(PostingState, LineNo);
        Dialog.Update(2, GetProgressBarValue(PostingState, LineNo, TotalLinesQty));
    end;

    local procedure UpdateDialogUpdateBalLines(PostingSubState: Integer; LineNo: Integer; TotalLinesQty: Integer)
    begin
        UpdatePostingState(RefPostingState::"Updating bal. lines", LineNo);
        Dialog.Update(
          2,
          GetProgressBarUpdateBalLinesValue(
            CalcProgressPercent(PostingSubState, 3, LineCount, TotalLinesQty)));
    end;

    local procedure UpdatePostingState(PostingState: Integer; LineNo: Integer)
    begin
#pragma warning disable AA0217
        Dialog.Update(3, StrSubstNo('%1 (%2)', GetPostingStateMsg(PostingState), LineNo));
#pragma warning restore AA0217
    end;

    local procedure UpdateCurrencyBalanceForRecurringLine(var GenJournalLine: Record "Gen. Journal Line")
    begin
        if GenJournalLine."Recurring Method" <> GenJournalLine."Recurring Method"::" " then
            GenJournalLine.CalcFields("Allocated Amt. (LCY)");
        if (GenJournalLine."Recurring Method" = GenJournalLine."Recurring Method"::" ") or (GenJournalLine."Amount (LCY)" <> -GenJournalLine."Allocated Amt. (LCY)") then
            if GenJournalLine."Currency Code" <> LastCurrencyCode then
                LastCurrencyCode := ''
            else
                if (GenJournalLine."Currency Code" <> '') and ((GenJournalLine."Account No." = '') xor (GenJournalLine."Bal. Account No." = '')) then
                    if GenJournalLine."Account No." <> '' then
                        CurrencyBalance := CurrencyBalance + GenJournalLine.Amount
                    else
                        CurrencyBalance := CurrencyBalance - GenJournalLine.Amount;
    end;

    local procedure GetPostingStateMsg(PostingState: Integer): Text
    begin
        case PostingState of
            RefPostingState::"Checking lines":
                exit(CheckingLinesMsg);
            RefPostingState::"Checking balance":
                exit(CheckingBalanceMsg);
            RefPostingState::"Updating bal. lines":
                exit(UpdatingBalLinesMsg);
            RefPostingState::"Posting Lines":
                exit(PostingLinesMsg);
            RefPostingState::"Posting revers. lines":
                exit(PostingReversLinesMsg);
            RefPostingState::"Updating lines":
                exit(UpdatingLinesMsg);
        end;
    end;

    local procedure GetProgressBarValue(PostingState: Integer; LineNo: Integer; TotalLinesQty: Integer): Integer
    begin
        exit(Round(100 * CalcProgressPercent(PostingState, GetNumberOfPostingStages(), LineNo, TotalLinesQty), 1));
    end;

    local procedure GetProgressBarUpdateBalLinesValue(PostingStatePercent: Decimal): Integer
    begin
        exit(Round((RefPostingState::"Updating bal. lines" * 100 + PostingStatePercent) / GetNumberOfPostingStages() * 100, 1));
    end;

    local procedure CalcProgressPercent(PostingState: Integer; NumberOfPostingStates: Integer; LineNo: Integer; TotalLinesQty: Integer): Decimal
    begin
        exit(100 / NumberOfPostingStates * (PostingState + LineNo / TotalLinesQty));
    end;

    local procedure GetNumberOfPostingStages(): Integer
    begin
        if GenJournalTemplate.Recurring then
            exit(6);

        exit(4);
    end;

    local procedure FindNextGLRegisterNo()
    begin
        GLRegister.LOCKTABLE();
        IF SourceCode."CIR Situation" THEN BEGIN
            IF GLRegister.FINDFIRST() THEN BEGIN
                GLRegNo := GLRegister."No." - 1;
                IF GLRegNo = 0 THEN
                    GLRegNo := -1;
            END ELSE
                GLRegNo := -1;
        END ELSE
            IF GLRegister.FINDLAST() THEN
                GLRegNo := GLRegister."No." + 1
            ELSE
                GLRegNo := 1;
    end;

    local procedure CheckGenJnlLineDates(var MarkedGenJournalLine: Record "Gen. Journal Line"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        if not GenJournalLine.Find() then
            GenJournalLine.FindSet();
        GenJournalLine.SetRange("Posting Date", 0D, WorkDate());
        if GenJournalLine.FindSet() then begin
            StartLineNo := GenJournalLine."Line No.";
            repeat
                if IsNotExpired(GenJournalLine) and IsPostingDateAllowed(GenJournalLine) then begin
                    MarkedGenJournalLine := GenJournalLine;
                    MarkedGenJournalLine.Insert();
                end;
                if GenJournalLine.Next() = 0 then
                    GenJournalLine.FindFirst();
            until GenJournalLine."Line No." = StartLineNo
        end;
        MarkedGenJournalLine := GenJournalLine;
    end;

    local procedure IsNotExpired(GenJournalLine: Record "Gen. Journal Line"): Boolean
    begin
        exit((GenJournalLine."Expiration Date" = 0D) or (GenJournalLine."Expiration Date" >= GenJournalLine."Posting Date"));
    end;

    local procedure IsPostingDateAllowed(GenJournalLine: Record "Gen. Journal Line"): Boolean
    begin
        exit(not GenJnlCheckLine.DateNotAllowed(GenJournalLine."Posting Date"));
    end;

    procedure SetPreviewMode(NewPreviewMode: Boolean)
    begin
        PreviewMode := NewPreviewMode;
    end;

    local procedure PostReversingLines(var pTempGenJournalLine: Record "Gen. Journal Line" temporary)
    var
        GenJournalLine1: Record "Gen. Journal Line";
        lGenJournalLine2: Record "Gen. Journal Line";
    begin
        LineCount := 0;
        LastDocNo := '';
        LastPostedDocNo := '';
        if pTempGenJournalLine.Find('-') then
            repeat
                GenJournalLine1 := pTempGenJournalLine;
                LineCount := LineCount + 1;
                UpdateDialog(RefPostingState::"Posting revers. lines", LineCount, NoOfReversingRecords);
                CheckDocumentNo(GenJournalLine1);
                lGenJournalLine2.Copy(GenJournalLine1);
                PrepareGenJnlLineAddCurr(lGenJournalLine2);
                OnPostReversingLinesOnBeforeGenJnlPostLine(lGenJournalLine2, CIRGenJnlPostLine);
                CIRGenJnlPostLine.RunWithCheck(lGenJournalLine2);
                PostAllocations(GenJournalLine1, true);
            until pTempGenJournalLine.Next() = 0;

        OnAfterPostReversingLines(pTempGenJournalLine, PreviewMode);
    end;

    local procedure UpdateAndDeleteLines(var GenJournalLine: Record "Gen. Journal Line")
    var
        TempGenJournalLine2: Record "Gen. Journal Line" temporary;
        OldVATAmount: Decimal;
        OldVATPct: Decimal;
    begin
        OnBeforeUpdateAndDeleteLines(GenJournalLine, SuppressCommit);

        ClearDataExchEntries(GenJournalLine);
        if GenJournalTemplate.Recurring then begin
            // Recurring journal
            LineCount := 0;
            GenJournalLine2.Copy(GenJournalLine);
            GenJournalLine2.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
            GenJournalLine2.FindSet();
            repeat
                LineCount := LineCount + 1;
                UpdateDialog(RefPostingState::"Updating lines", LineCount, NoOfRecords);
                OldVATAmount := GenJournalLine2."VAT Amount";
                OldVATPct := GenJournalLine2."VAT %";
                if GenJournalLine2."Posting Date" <> 0D then
                    GenJournalLine2.Validate(
                      "Posting Date", CalcDate(GenJournalLine2."Recurring Frequency", GenJournalLine2."Posting Date"));
                if not
                   (GenJournalLine2."Recurring Method" in
                    [GenJournalLine2."Recurring Method"::"F  Fixed",
                     GenJournalLine2."Recurring Method"::"RF Reversing Fixed"])
                then
                    MultiplyAmounts(GenJournalLine2, 0)
                else
                    if (GenJournalLine2."VAT %" = OldVATPct) and (GenJournalLine2."VAT Amount" <> OldVATAmount) then
                        GenJournalLine2.Validate("VAT Amount", OldVATAmount);
                GenJournalLine2.Modify();
            until GenJournalLine2.Next() = 0;
        end else begin
            // Not a recurring journal
            GenJournalLine2.Copy(GenJournalLine);
            GenJournalLine2.SetFilter("Account No.", '<>%1', '');
            if GenJournalLine2.FindLast() then; // Remember the last line
            GenJournalLine3.Copy(GenJournalLine);
            GenJournalLine3.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
            GenJournalLine3.DeleteAll();
            GenJournalLine3.Reset();
            GenJournalLine3.SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
            GenJournalLine3.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
            if GenJournalTemplate."Increment Batch Name" then
                if not GenJournalLine3.FindLast() then
                    if IncStr(GenJournalLine."Journal Batch Name") <> '' then begin
                        GenJournalBatch.Delete();
                        if GenJournalTemplate.Type = GenJournalTemplate.Type::Assets then
                            FAJournalSetup.IncGenJnlBatchName(GenJournalBatch);
                        GenJournalBatch.Name := IncStr(GenJournalLine."Journal Batch Name");
                        if GenJournalBatch.Insert() then;
                        GenJournalLine."Journal Batch Name" := GenJournalBatch.Name;
                        OnAfterIncrementBatchName(GenJournalBatch, GenJournalLine2."Journal Batch Name");
                    end;

            GenJournalLine3.SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
            if (GenJournalBatch."No. Series" = '') and not GenJournalLine3.FindLast() then begin
                GenJournalLine3.Init();
                GenJournalLine3."Journal Template Name" := GenJournalLine."Journal Template Name";
                GenJournalLine3."Journal Batch Name" := GenJournalLine."Journal Batch Name";
                GenJournalLine3."Line No." := 10000;
                GenJournalLine3.Insert();
                TempGenJournalLine2 := GenJournalLine2;
                TempGenJournalLine2."Balance (LCY)" := 0;
                GenJournalLine3.SetUpNewLine(TempGenJournalLine2, 0, true);
                GenJournalLine3.Modify();
            end;
        end;
    end;


    procedure Preview(var GenJournalLine: Record "Gen. Journal Line")
    var
        lGenJournalLine: Record "Gen. Journal Line";
    begin
        PreviewMode := true;
        lGenJournalLine.Copy(lGenJournalLine);
        lGenJournalLine.SetAutoCalcFields();
        Code(lGenJournalLine);
    end;


    local procedure ClearDataExchEntries(var PassedGenJournalLine: Record "Gen. Journal Line")
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.Copy(PassedGenJournalLine);
        if GenJournalLine.FindSet() then
            repeat
                GenJournalLine.ClearDataExchangeEntries(true);
            until GenJournalLine.Next() = 0;
    end;

    local procedure PostGenJournalLine(var GenJournalLine: Record "Gen. Journal Line"; CurrentICPartner: Code[20]; ICTransactionNo: Integer): Boolean
    var
        IsPosted: Boolean;
    begin
        if GenJournalLine.NeedCheckZeroAmount() and (GenJournalLine.Amount = 0) and GenJournalLine.IsRecurring() then
            exit(false);

        LineCount := LineCount + 1;
        if CurrentICPartner <> '' then
            GenJournalLine."IC Partner Code" := CurrentICPartner;
        UpdateDialog(RefPostingState::"Posting Lines", LineCount, NoOfRecords);
        MakeRecurringTexts(GenJournalLine);
        CheckDocumentNo(GenJournalLine);
        GenJournalLine5.Copy(GenJournalLine);
        PrepareGenJnlLineAddCurr(GenJournalLine5);
        UpdateIncomingDocument(GenJournalLine5);
        OnBeforePostGenJnlLine(GenJournalLine5, SuppressCommit, IsPosted, CIRGenJnlPostLine);
        if not IsPosted then begin
            CIRGenJnlPostLine.RunWithoutCheck(GenJournalLine5);
            InsertPostedGenJnlLine(GenJournalLine);
        end;
        OnAfterPostGenJnlLine(GenJournalLine5, SuppressCommit, CIRGenJnlPostLine);
        if (GenJournalTemplate.Type = GenJournalTemplate.Type::Intercompany) and (CurrentICPartner <> '') and
           (GenJournalLine."IC Direction" = GenJournalLine."IC Direction"::Outgoing) and (ICTransactionNo > 0)
        then
            ICInboxOutboxMgt.CreateOutboxJnlLine(ICTransactionNo, 1, GenJournalLine5);
        if (GenJournalLine."Recurring Method".AsInteger() >= GenJournalLine."Recurring Method"::"RF Reversing Fixed".AsInteger()) and (GenJournalLine."Posting Date" <> 0D) then begin
            GenJournalLine."Posting Date" := GenJournalLine."Posting Date" + 1;
            GenJournalLine."Document Date" := GenJournalLine."Posting Date";
            MultiplyAmounts(GenJournalLine, -1);
            TempGenJournalLine4 := GenJournalLine;
            TempGenJournalLine4."Reversing Entry" := true;
            TempGenJournalLine4.Insert();
            NoOfReversingRecords := NoOfReversingRecords + 1;
            GenJournalLine."Posting Date" := GenJournalLine."Posting Date" - 1;
            GenJournalLine."Document Date" := GenJournalLine."Posting Date";
        end;
        PostAllocations(GenJournalLine, false);
        exit(true);
    end;

    local procedure CheckLine(var GenJournalLine: Record "Gen. Journal Line"; var PostingAfterCurrentFiscalYearConfirmed: Boolean)
    var
        GenJournalLineToUpdate: Record "Gen. Journal Line";
        IsModified: Boolean;
    begin
        GenJournalLineToUpdate.Copy(GenJournalLine);
        CheckRecurringLine(GenJournalLineToUpdate);
        IsModified := UpdateRecurringAmt(GenJournalLineToUpdate);
        CheckAllocations(GenJournalLineToUpdate);
        GenJournalLine5.Copy(GenJournalLineToUpdate);
        if not PostingAfterCurrentFiscalYearConfirmed then
            PostingAfterCurrentFiscalYearConfirmed :=
              PostingSetupManagement.ConfirmPostingAfterWorkingDate(
                ConfirmPostingAfterCurrentPeriodQst, GenJournalLine5."Posting Date");
        PrepareGenJnlLineAddCurr(GenJournalLine5);
        GenJnlCheckLine.RunCheck(GenJournalLine5);
        GenJournalLine.Copy(GenJournalLineToUpdate);
        if IsModified then
            GenJournalLine.Modify();
    end;

    procedure SetSuppressCommit(NewSuppressCommit: Boolean)
    begin
        SuppressCommit := NewSuppressCommit;
    end;

    local procedure IsNonZeroAmount(GenJournalLine: Record "Gen. Journal Line") Result: Boolean
    begin
        Result := GenJournalLine.Amount <> 0;
        OnAfterIsNonZeroAmount(GenJournalLine, Result);
    end;

    local procedure InsertPostedGenJnlLine(GenJournalLine: Record "Gen. Journal Line")
    var
        PostedGenJournalBatch: Record "Posted Gen. Journal Batch";
        PostedGenJournalLine: Record "Posted Gen. Journal Line";
    begin
        if GenJournalTemplate.Recurring then
            exit;

        if not GenJournalBatch."Copy to Posted Jnl. Lines" then
            exit;

        if GenJournalLine.EmptyLine() then
            exit;

        if not PostedGenJournalBatch.Get(GenJournalBatch."Journal Template Name", GenJournalBatch.Name) then
            PostedGenJournalBatch.InsertFromGenJournalBatch(GenJournalBatch);

        PostedGenJournalLine.InsertFromGenJournalLine(GenJournalLine, GLRegNo, FirstLine);
        FirstLine := false;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCode(var GenJournalLine: Record "Gen. Journal Line"; PreviewMode: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
#pragma warning disable AA0228
    local procedure OnAfterPostGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; CommitIsSuppressed: Boolean; var CIRGenJnlPostLine: Codeunit "CIR Gen. Jnl.-Post Line")
#pragma warning restore AA0228
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterProcessLines(var TempGenJournalLine: Record "Gen. Journal Line" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckBalance(GenJournalTemplate: Record "Gen. Journal Template"; GenJournalLine: Record "Gen. Journal Line"; CurrentBalance: Decimal; CurrentBalanceReverse: Decimal; CurrencyBalance: Decimal; StartLineNo: Integer; StartLineNoReverse: Integer; LastDocType: Option; LastDocNo: Code[20]; LastDate: Date; LastCurrencyCode: Code[10]; CommitIsSuppressed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckCorrection(GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckGenPostingType(GenJournalLine: Record "Gen. Journal Line"; AccountType: Enum "Gen. Journal Account Type"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCode(var GenJournalLine: Record "Gen. Journal Line"; PreviewMode: Boolean; CommitIsSuppressed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
#pragma warning disable AA0228
    local procedure OnBeforeCommit(GLRegNo: Integer; var GenJournalLine: Record "Gen. Journal Line"; var CIRGenJnlPostLine: Codeunit "CIR Gen. Jnl.-Post Line")
#pragma warning restore AA0228
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeIfCheckBalance(GenJournalTemplate: Record "Gen. Journal Template"; GenJournalLine: Record "Gen. Journal Line"; var LastDocType: Option; var LastDocNo: Code[20]; var LastDate: Date; var CheckIfBalance: Boolean; CommitIsSuppressed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostAllocations(var AllocateGenJournalLine: Record "Gen. Journal Line"; Reversing: Boolean; IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
#pragma warning disable AA0228
    local procedure OnBeforePostGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; CommitIsSuppressed: Boolean; var Posted: Boolean; var CIRGenJnlPostLine: Codeunit "CIR Gen. Jnl.-Post Line")
#pragma warning restore AA0228
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeProcessLines(var GenJournalLine: Record "Gen. Journal Line"; PreviewMode: Boolean; CommitIsSuppressed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeProcessBalanceOfLines(var GenJournalLine: Record "Gen. Journal Line"; var GenJournalBatch: Record "Gen. Journal Batch"; var GenJournalTemplate: Record "Gen. Journal Template"; var IsKeySet: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeRaiseExceedLengthError(var GenJournalBatch: Record "Gen. Journal Batch"; var RaiseError: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeThrowPreviewError(var GenJournalLine: Record "Gen. Journal Line"; GLRegNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateAndDeleteLines(var GenJournalLine: Record "Gen. Journal Line"; CommitIsSuppressed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateIncomingDocument(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterIncrementBatchName(var GenJournalBatch: Record "Gen. Journal Batch"; OldBatchName: Code[10])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostAllocations(GenJournalLine: Record "Gen. Journal Line"; Reversing: Boolean; CommitIsSuppressed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterMakeRecurringTexts(var GenJournalLine: Record "Gen. Journal Line"; var AccountingPeriod: Record "Accounting Period"; var Day: Integer; var Week: Integer; var Month: Integer; var MonthText: Text[30])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostAllocationsOnBeforeCopyFromGenJnlAlloc(var GenJournalLine: Record "Gen. Journal Line"; var AllocateGenJournalLine: Record "Gen. Journal Line"; var Reversing: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterMultiplyAmounts(var GenJournalLine: Record "Gen. Journal Line"; Factor: Decimal; CommitIsSuppressed: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostReversingLines(var GenJournalLine: Record "Gen. Journal Line"; PreviewMode: Boolean)
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnAfterProcessBalanceOfLines(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateLineBalance(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
#pragma warning disable AA0228
    local procedure OnPostAllocationsOnBeforePostNotReversingLine(var GenJournalLine: Record "Gen. Journal Line"; var CIRGenJnlPostLine: Codeunit "CIR Gen. Jnl.-Post Line")
#pragma warning restore AA0228
    begin
    end;

    [IntegrationEvent(false, false)]
#pragma warning disable AA0228
    local procedure OnPostAllocationsOnBeforePostReversingLine(var GenJournalLine: Record "Gen. Journal Line"; var CIRGenJnlPostLine: Codeunit "CIR Gen. Jnl.-Post Line")
#pragma warning restore AA0228
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostAllocationsOnBeforePrepareGenJnlLineAddCurr(var GenJournalLine: Record "Gen. Journal Line"; AllocateGenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
#pragma warning disable AA0228
    local procedure OnPostReversingLinesOnBeforeGenJnlPostLine(var GenJournalLine: Record "Gen. Journal Line"; var CIRGenJnlPostLine: Codeunit "CIR Gen. Jnl.-Post Line")
#pragma warning restore AA0228
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnProcessLinesOnAfterAssignGLNegNo(var GenJournalLine: Record "Gen. Journal Line"; GLRegister: Record "G/L Register"; GLRegNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnProcessLinesOnAfterPostGenJnlLines(GenJournalLine: Record "Gen. Journal Line"; GLRegister: Record "G/L Register"; var GLRegNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnProcessLinesOnBeforeSetGLRegNoToZero(var GenJournalLine: Record "Gen. Journal Line"; var GLRegNo: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterIsNonZeroAmount(GenJournalLine: Record "Gen. Journal Line"; var Result: Boolean)
    begin
    end;
}
