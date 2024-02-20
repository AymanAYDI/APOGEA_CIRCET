codeunit 50029 "CIR Gen. Jnl Mgt"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", 'OnBeforeCheckAccountNo', '', false, false)]
    local procedure OnBeforeCheckAccountNoCheckReasonCode(var GenJnlLine: Record "Gen. Journal Line"; var CheckDone: Boolean);
    begin
        OnBeforeCheckAccountNoCheckReasonCodeMeth(GenJnlLine);
    end;

    [EventSubscriber(ObjectType::Report, Report::"Trans. Bank Rec. to Gen. Jnl.", 'OnBeforeGenJnlLineInsert', '', false, false)]
    local procedure OnBeforeGenJnlLineInsert(var GenJournalLine: Record "Gen. Journal Line"; BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line");
    begin
        InitFiedlOnGenJnlLineFromBankAccRecon(GenJournalLine, BankAccReconciliationLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CIR Gen. Jnl.-Post Line", 'OnBeforeCustLedgEntryInsert', '', false, false)]
    local procedure CIROnBeforeCustLedgEntryInsert(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line");
    begin
        CustLedgerEntry."Bank Account No." := GenJournalLine."Bank Account No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeCustLedgEntryInsert', '', false, false)]
    local procedure OnBeforeCustLedgEntryInsert(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line"; GLRegister: Record "G/L Register");
    begin
        CustLedgerEntry."Bank Account No." := GenJournalLine."Bank Account No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostCustomerEntry', '', false, false)]
    local procedure OnBeforePostCustomerEntry(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line");
    begin
        GenJnlLine."Bank Account No." := SalesHeader."Bank Account No.";
    end;

    [EventSubscriber(ObjectType::Page, Page::"General Journal", 'OnAfterValidateShortcutDimCode', '', false, false)]
    local procedure OnAfterValidateShortcutDimCode(var GenJournalLine: Record "Gen. Journal Line"; var ShortcutDimCode: array[8] of Code[20]; DimIndex: Integer)
    var
        SourceCodeSetup: Record "Source Code Setup";
        Job: Record Job;
        DimensionManagement: Codeunit DimensionManagement;
        DefaultDimSource: List of [Dictionary of [Integer, Code[20]]];
        ErrAccountType_Lbl: Label '%1 must be G/L Account or Bank Account.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"%1 doit être un compte général ou un compte bancaire."}]}';
    begin
        //la règle s'applique uniquement pour l'axe 4
        if DimIndex = 4 then begin
            if GenJournalLine."Source Code" <> SourceCodeSetup."Job G/L WIP" then
                GenJournalLine.Validate("Job Task No.", '');
            if ShortcutDimCode[DimIndex] = '' then begin
                DimensionManagement.AddDimSource(DefaultDimSource, Database::Job, ShortcutDimCode[DimIndex]);
                DimensionManagement.AddDimSource(DefaultDimSource, DimensionManagement.TypeToTableID1(GenJournalLine."Account Type".AsInteger()), GenJournalLine."Account No.");
                DimensionManagement.AddDimSource(DefaultDimSource, DimensionManagement.TypeToTableID1(GenJournalLine."Bal. Account Type".AsInteger()), GenJournalLine."Bal. Account No.");
                DimensionManagement.AddDimSource(DefaultDimSource, Database::"Salesperson/Purchaser", GenJournalLine."Salespers./Purch. Code");
                DimensionManagement.AddDimSource(DefaultDimSource, Database::Campaign, GenJournalLine."Campaign No.");
                GenJournalLine.CreateDim(DefaultDimSource);
                exit;
            end;
            if GenJournalLine."Bal. Account No." <> '' then
                if not (GenJournalLine."Bal. Account Type" in [GenJournalLine."Bal. Account Type"::"G/L Account", GenJournalLine."Bal. Account Type"::"Bank Account"]) then
                    Error(ErrAccountType_Lbl, GenJournalLine.FieldCaption("Bal. Account Type"));

            Job.Get(ShortcutDimCode[DimIndex]);
            Job.TestBlocked();
            GenJournalLine."Job Currency Code" := Job."Currency Code";
            DimensionManagement.AddDimSource(DefaultDimSource, Database::Job, ShortcutDimCode[DimIndex]);
            DimensionManagement.AddDimSource(DefaultDimSource, DimensionManagement.TypeToTableID1(GenJournalLine."Account Type".AsInteger()), GenJournalLine."Account No.");
            DimensionManagement.AddDimSource(DefaultDimSource, DimensionManagement.TypeToTableID1(GenJournalLine."Bal. Account Type".AsInteger()), GenJournalLine."Bal. Account No.");
            DimensionManagement.AddDimSource(DefaultDimSource, Database::"Salesperson/Purchaser", GenJournalLine."Salespers./Purch. Code");
            DimensionManagement.AddDimSource(DefaultDimSource, Database::Campaign, GenJournalLine."Campaign No.");
            GenJournalLine.CreateDim(DefaultDimSource);
        end;
    end;

    procedure OnBeforeCheckAccountNoCheckReasonCodeMeth(var GenJnlLine: Record "Gen. Journal Line");
    begin
        case GenJnlLine."Account Type" of
            GenJnlLine."Account Type"::"Bank Account":
                GenJnlLine.TestField("Reason Code");
        end;

        case GenJnlLine."Bal. Account Type" of
            GenJnlLine."Bal. Account Type"::"Bank Account":
                GenJnlLine.TestField("Reason Code");
        end;
    end;

    //Fonction pour alimenter les données de la feuille comptabilité depuis le rapprochement bancaire
    local procedure InitFiedlOnGenJnlLineFromBankAccRecon(var GenJournalLine: Record "Gen. Journal Line"; BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        NoSeriesMgt: codeunit NoSeriesManagement;
    begin
        IF GenJournalBatch.GET(GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name") THEN BEGIN
            GenJournalLine."Reason Code" := GenJournalBatch."Reason Code";

            if GenJournalBatch."No. Series" <> '' then
                GenJournalLine."Document No." := NoSeriesMgt.GetNextNo(GenJournalBatch."No. Series", BankAccReconciliationLine."Transaction Date", true);
        END;
    end;

    local procedure OnAfterSetupNewLine_ForCheckType(var GenJournalLine: Record "Gen. Journal Line"; var GenJournalBatch: Record "Gen. Journal Batch")
    begin
        IF GenJournalBatch.Check THEN BEGIN
            GenJournalLine."External Document No." := GenJournalLine."Document No.";
            GenJournalLine."Bank Payment Type" := GenJournalLine."Bank Payment Type"::"Computer Check";
        END;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterSetupNewLine', '', false, false)]
    local procedure OnAfterSetupNewLine(var GenJournalLine: Record "Gen. Journal Line"; GenJournalTemplate: Record "Gen. Journal Template"; GenJournalBatch: Record "Gen. Journal Batch"; LastGenJournalLine: Record "Gen. Journal Line"; Balance: Decimal; BottomLine: Boolean);
    begin
        OnAfterSetupNewLine_ForCheckType(GenJournalLine, GenJournalBatch);
    end;
}