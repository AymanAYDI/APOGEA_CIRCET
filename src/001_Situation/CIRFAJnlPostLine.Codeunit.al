codeunit 50500 "CIR FA Jnl.-Post Line"
{
    Permissions = TableData "FA Ledger Entry" = r,
                  TableData "FA Register" = rm,
                  TableData "Maintenance Ledger Entry" = r,
                  TableData "Ins. Coverage Ledger Entry" = r;

    var
        FixedAsset: Record "Fixed Asset";
        FixedAsset2: Record "Fixed Asset";
        DepreciationBook: Record "Depreciation Book";
        FADepreciationBook: Record "FA Depreciation Book";
        FALedgerEntry: Record "FA Ledger Entry";
        MaintenanceLedgerEntry: Record "Maintenance Ledger Entry";
        FAInsertLedgerEntry: Codeunit "FA Insert Ledger Entry";
        FAJnlCheckLine: Codeunit "FA Jnl.-Check Line";
        DuplicateDeprBook: Codeunit "Duplicate Depr. Book";
        CalculateDisposal: Codeunit "Calculate Disposal";
        CalculateDepreciation: Codeunit "Calculate Depreciation";
        CalculateAcqCostDepr: Codeunit "Calculate Acq. Cost Depr.";
        MakeFALedgerEntry: Codeunit "Make FA Ledger Entry";
        MakeMaintenanceLedgerEntry: Codeunit "Make Maintenance Ledger Entry";
        FANo: Code[20];
        BudgetNo: Code[20];
        DeprBookCode: Code[10];
        FAPostingType: Enum "FA Journal Line FA Posting Type";
        FAPostingDate: Date;
        Amount2: Decimal;
        SalvageValue: Decimal;
        DeprUntilDate: Boolean;
        DeprAcqCost: Boolean;
        ErrorEntryNo: Integer;
        ResultOnDisposal: Integer;
        Text000Lbl: Label '%2 must not be %3 in %4 %5 = %6 for %1.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "%2 ne doit pas être %3 dans %4 %5 = %6 pour %1." }, { "lang": "FRB", "txt": "%2 ne doit pas être %3 dans %4 %5 = %6 pour %1." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text001Lbl: Label '%2 = %3 must be canceled first for %1.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "%2 = %3 doit être annulé en premier pour %1." }, { "lang": "FRB", "txt": "%2 = %3 doit être annulé en premier pour %1." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text002Lbl: Label '%1 is not a %2.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "%1 n''est pas un %2." }, { "lang": "FRB", "txt": "%1 n''est pas un %2." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text003Lbl: Label '%1 = %2 already exists for %5 (%3 = %4).', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "%1 = %2 existe déjà pour %5 (%3 = %4)." }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';

    procedure FAJnlPostLine(FAJournalLine: Record "FA Journal Line"; CheckLine: Boolean)
    begin
        OnBeforeFAJnlPostLine(FAJournalLine);

        FAInsertLedgerEntry.SetGLRegisterNo(0);
        if FAJournalLine."FA No." = '' then
            exit;
        if FAJournalLine."Posting Date" = 0D then
            FAJournalLine."Posting Date" := FAJournalLine."FA Posting Date";
        if CheckLine then
            FAJnlCheckLine.CheckFAJnlLine(FAJournalLine);
        DuplicateDeprBook.DuplicateFAJnlLine(FAJournalLine);
        FANo := FAJournalLine."FA No.";
        BudgetNo := FAJournalLine."Budgeted FA No.";
        DeprBookCode := FAJournalLine."Depreciation Book Code";
        FAPostingType := FAJournalLine."FA Posting Type";
        FAPostingDate := FAJournalLine."FA Posting Date";
        Amount2 := FAJournalLine.Amount;
        SalvageValue := FAJournalLine."Salvage Value";
        DeprUntilDate := FAJournalLine."Depr. until FA Posting Date";
        DeprAcqCost := FAJournalLine."Depr. Acquisition Cost";
        ErrorEntryNo := FAJournalLine."FA Error Entry No.";
        if FAJournalLine."FA Posting Type" = FAJournalLine."FA Posting Type"::Maintenance then begin
            MakeMaintenanceLedgerEntry.CopyFromFAJnlLine(MaintenanceLedgerEntry, FAJournalLine);
            PostMaintenance();
        end else begin
            MakeFALedgerEntry.CopyFromFAJnlLine(FALedgerEntry, FAJournalLine);
            PostFixedAsset();
        end;

        OnAfterFAJnlPostLine(FAJournalLine);
    end;

    procedure GenJnlPostLine(GenJournalLine: Record "Gen. Journal Line"; FAAmount: Decimal; VATAmount: Decimal; NextTransactionNo: Integer; NextGLEntryNo: Integer; GLRegisterNo: Integer)
    begin
        OnBeforeGenJnlPostLine(GenJournalLine);

        FAInsertLedgerEntry.DeleteAllGLAcc();
        GenJnlPostLineContinue(GenJournalLine, FAAmount, VATAmount, NextTransactionNo, NextGLEntryNo, GLRegisterNo);
    end;


    procedure GenJnlPostLineContinue(GenJournalLine: Record "Gen. Journal Line"; FAAmount: Decimal; VATAmount: Decimal; NextTransactionNo: Integer; NextGLEntryNo: Integer; GLRegisterNo: Integer)
    begin
        FAInsertLedgerEntry.SetGLRegisterNo(GLRegisterNo);
        if GenJournalLine."Account No." = '' then
            exit;
        if GenJournalLine."FA Posting Date" = 0D then
            GenJournalLine."FA Posting Date" := GenJournalLine."Posting Date";
        if GenJournalLine."Journal Template Name" = '' then
            GenJournalLine.Quantity := 0;
        DuplicateDeprBook.DuplicateGenJnlLine(GenJournalLine, FAAmount);
        FANo := GenJournalLine."Account No.";
        BudgetNo := GenJournalLine."Budgeted FA No.";
        DeprBookCode := GenJournalLine."Depreciation Book Code";
        FAPostingType := "FA Journal Line FA Posting Type".FromInteger(GenJournalLine."FA Posting Type".AsInteger() - 1);
        FAPostingDate := GenJournalLine."FA Posting Date";
        Amount2 := FAAmount;
        SalvageValue := GenJournalLine.ConvertAmtFCYToLCYForSourceCurrency(GenJournalLine."Salvage Value");
        DeprUntilDate := GenJournalLine."Depr. until FA Posting Date";
        DeprAcqCost := GenJournalLine."Depr. Acquisition Cost";
        ErrorEntryNo := GenJournalLine."FA Error Entry No.";
        if GenJournalLine."FA Posting Type" = GenJournalLine."FA Posting Type"::Maintenance then begin
            MakeMaintenanceLedgerEntry.CopyFromGenJnlLine(MaintenanceLedgerEntry, GenJournalLine);
            MaintenanceLedgerEntry.Amount := FAAmount;
            MaintenanceLedgerEntry."VAT Amount" := VATAmount;
            MaintenanceLedgerEntry."Transaction No." := NextTransactionNo;
            MaintenanceLedgerEntry."G/L Entry No." := NextGLEntryNo;
            PostMaintenance();
        end else begin
            MakeFALedgerEntry.CopyFromGenJnlLine(FALedgerEntry, GenJournalLine);
            FALedgerEntry.Amount := FAAmount;
            FALedgerEntry."VAT Amount" := VATAmount;
            FALedgerEntry."Transaction No." := NextTransactionNo;
            FALedgerEntry."G/L Entry No." := NextGLEntryNo;
            OnBeforePostFixedAssetFromGenJnlLine(GenJournalLine, FALedgerEntry, FAAmount, VATAmount);
            PostFixedAsset();
        end;

        OnAfterGenJnlPostLine(GenJournalLine);
    end;

    local procedure PostFixedAsset()
    begin
        FixedAsset.LockTable();
        DepreciationBook.Get(DeprBookCode);
        FixedAsset.Get(FANo);
        FixedAsset.TestField(Blocked, false);
        FixedAsset.TestField(Inactive, false);
        FADepreciationBook.Get(FANo, DeprBookCode);
        MakeFALedgerEntry.CopyFromFACard(FALedgerEntry, FixedAsset, FADepreciationBook);
        FAInsertLedgerEntry.SetLastEntryNo(true);
        if (FALedgerEntry."FA Posting Group" = '') and (FALedgerEntry."G/L Entry No." > 0) then begin
            FADepreciationBook.TestField("FA Posting Group");
            FALedgerEntry."FA Posting Group" := FADepreciationBook."FA Posting Group";
        end;
        if DeprUntilDate then
            PostDeprUntilDate(FALedgerEntry, 0);
        if FAPostingType = FAPostingType::Disposal then
            PostDisposalEntry(FALedgerEntry)
        else begin
            if PostBudget() then
                SetBudgetAssetNo();
            if not DeprLine() then begin
                FAInsertLedgerEntry.SetOrgGenJnlLine(true);
                FAInsertLedgerEntry.InsertFA(FALedgerEntry);
                FAInsertLedgerEntry.SetOrgGenJnlLine(false);
            end;
            PostSalvageValue(FALedgerEntry);
        end;
        if DeprAcqCost then
            PostDeprUntilDate(FALedgerEntry, 1);
        FAInsertLedgerEntry.SetLastEntryNo(false);
        if PostBudget() then
            PostBudgetAsset();
    end;


    procedure InsertBalAcc(var pFALedgerEntry: Record "FA Ledger Entry")
    begin
        FAInsertLedgerEntry.SetOrgGenJnlLine(true);
        FAInsertLedgerEntry.InsertBalAcc(pFALedgerEntry);
        FAInsertLedgerEntry.SetOrgGenJnlLine(false);
    end;

    local procedure PostMaintenance()
    begin
        FixedAsset.LockTable();
        DepreciationBook.Get(DeprBookCode);
        FixedAsset.Get(FANo);
        FADepreciationBook.Get(FANo, DeprBookCode);
        MakeMaintenanceLedgerEntry.CopyFromFACard(MaintenanceLedgerEntry, FixedAsset, FADepreciationBook);
        if not DepreciationBook."Allow Identical Document No." and (MaintenanceLedgerEntry."Journal Batch Name" <> '') then
            CheckMaintDocNo(MaintenanceLedgerEntry);
        if (MaintenanceLedgerEntry."FA Posting Group" = '') and (MaintenanceLedgerEntry."G/L Entry No." > 0) then begin
            FADepreciationBook.TestField("FA Posting Group");
            MaintenanceLedgerEntry."FA Posting Group" := FADepreciationBook."FA Posting Group";
        end;
        if PostBudget() then
            SetBudgetAssetNo();
        FAInsertLedgerEntry.SetOrgGenJnlLine(true);
        FAInsertLedgerEntry.InsertMaintenance(MaintenanceLedgerEntry);
        FAInsertLedgerEntry.SetOrgGenJnlLine(false);
        if PostBudget() then
            PostBudgetAsset();
    end;

    local procedure PostDisposalEntry(var pFALedgerEntry: Record "FA Ledger Entry")
    var
        MaxDisposalNo: Integer;
        SalesEntryNo: Integer;
        DisposalType: Option FirstDisposal,SecondDisposal,ErrorDisposal,LastErrorDisposal;
        OldDisposalMethod: Option " ",Net,Gross;
        EntryAmounts: array[15] of Decimal;
        EntryNumbers: array[15] of Integer;
        i: Integer;
        j: Integer;
    begin
        pFALedgerEntry."Disposal Calculation Method" := DepreciationBook."Disposal Calculation Method" + 1;
        CalculateDisposal.GetDisposalType(
          FANo, DeprBookCode, ErrorEntryNo, DisposalType,
          OldDisposalMethod, MaxDisposalNo, SalesEntryNo);
        if (MaxDisposalNo > 0) and
           (pFALedgerEntry."Disposal Calculation Method" <> OldDisposalMethod)
        then
            Error(
              Text000Lbl,
              FAName(), DepreciationBook.FieldCaption("Disposal Calculation Method"), pFALedgerEntry."Disposal Calculation Method",
              DepreciationBook.TableCaption(), DepreciationBook.FieldCaption(Code), DepreciationBook.Code);
        if ErrorEntryNo = 0 then
            pFALedgerEntry."Disposal Entry No." := MaxDisposalNo + 1
        else
            if SalesEntryNo <> ErrorEntryNo then
                Error(Text001Lbl,
                  FAName(), pFALedgerEntry.FieldCaption("Disposal Entry No."), MaxDisposalNo);
        if DisposalType = DisposalType::FirstDisposal then
            PostReverseType(pFALedgerEntry);
        if DepreciationBook."Disposal Calculation Method" = DepreciationBook."Disposal Calculation Method"::Gross then
            FAInsertLedgerEntry.SetOrgGenJnlLine(true);
        FAInsertLedgerEntry.InsertFA(pFALedgerEntry);
        FAInsertLedgerEntry.SetOrgGenJnlLine(false);
        pFALedgerEntry."Automatic Entry" := true;
        FAInsertLedgerEntry.SetNetdisposal(false);
        if (DepreciationBook."Disposal Calculation Method" =
            DepreciationBook."Disposal Calculation Method"::Net) and
           DepreciationBook."VAT on Net Disposal Entries"
        then
            FAInsertLedgerEntry.SetNetdisposal(true);

        if DisposalType = DisposalType::FirstDisposal then begin
            CalculateDisposal.CalcGainLoss(FANo, DeprBookCode, EntryAmounts);
            for i := 1 to 15 do
                if EntryAmounts[i] <> 0 then begin
                    pFALedgerEntry."FA Posting Category" := CalculateDisposal.SetFAPostingCategory(i);
                    pFALedgerEntry."FA Posting Type" := "FA Ledger Entry FA Posting Type".FromInteger(CalculateDisposal.SetFAPostingType(i));
                    pFALedgerEntry.Amount := EntryAmounts[i];
                    if i = 1 then
                        pFALedgerEntry."Result on Disposal" := pFALedgerEntry."Result on Disposal"::Gain;
                    if i = 2 then
                        pFALedgerEntry."Result on Disposal" := pFALedgerEntry."Result on Disposal"::Loss;
                    if i > 2 then
                        pFALedgerEntry."Result on Disposal" := pFALedgerEntry."Result on Disposal"::" ";
                    if i = 10 then
                        SetResultOnDisposal(pFALedgerEntry);
                    FAInsertLedgerEntry.InsertFA(pFALedgerEntry);
                    PostAllocation(pFALedgerEntry);
                end;
        end;
        if DisposalType = DisposalType::SecondDisposal then begin
            CalculateDisposal.CalcSecondGainLoss(FANo, DeprBookCode, pFALedgerEntry.Amount, EntryAmounts);
            for i := 1 to 2 do
                if EntryAmounts[i] <> 0 then begin
                    pFALedgerEntry."FA Posting Category" := CalculateDisposal.SetFAPostingCategory(i);
                    pFALedgerEntry."FA Posting Type" := "FA Ledger Entry FA Posting Type".FromInteger(CalculateDisposal.SetFAPostingType(i));
                    pFALedgerEntry.Amount := EntryAmounts[i];
                    if i = 1 then
                        pFALedgerEntry."Result on Disposal" := pFALedgerEntry."Result on Disposal"::Gain;
                    if i = 2 then
                        pFALedgerEntry."Result on Disposal" := pFALedgerEntry."Result on Disposal"::Loss;
                    FAInsertLedgerEntry.InsertFA(pFALedgerEntry);
                    PostAllocation(pFALedgerEntry);
                end;
        end;
        if DisposalType in
           [DisposalType::ErrorDisposal, DisposalType::LastErrorDisposal]
        then begin
            CalculateDisposal.GetErrorDisposal(
              FANo, DeprBookCode, DisposalType = DisposalType::ErrorDisposal, MaxDisposalNo,
              EntryAmounts, EntryNumbers);
            if DisposalType = DisposalType::ErrorDisposal then
                j := 2
            else begin
                j := 14;
                ResultOnDisposal := CalcResultOnDisposal(FANo, DeprBookCode);
            end;
            for i := 1 to j do
                if EntryNumbers[i] <> 0 then begin
                    pFALedgerEntry.Amount := EntryAmounts[i];
                    pFALedgerEntry."Entry No." := EntryNumbers[i];
                    pFALedgerEntry."FA Posting Category" := CalculateDisposal.SetFAPostingCategory(i);
                    pFALedgerEntry."FA Posting Type" := "FA Ledger Entry FA Posting Type".FromInteger(CalculateDisposal.SetFAPostingType(i));
                    ;
                    if i = 1 then
                        pFALedgerEntry."Result on Disposal" := pFALedgerEntry."Result on Disposal"::Gain;
                    if i = 2 then
                        pFALedgerEntry."Result on Disposal" := pFALedgerEntry."Result on Disposal"::Loss;
                    if i > 2 then
                        pFALedgerEntry."Result on Disposal" := pFALedgerEntry."Result on Disposal"::" ";
                    if i = 10 then
                        pFALedgerEntry."Result on Disposal" := ResultOnDisposal;
                    FAInsertLedgerEntry.InsertFA(pFALedgerEntry);
                    PostAllocation(pFALedgerEntry);
                end;
        end;
        FAInsertLedgerEntry.CorrectEntries();
        FAInsertLedgerEntry.SetNetdisposal(false);
    end;

    local procedure PostDeprUntilDate(pFALedgerEntry: Record "FA Ledger Entry"; Type: Option UntilDate,AcqCost)
    var
        DepreciationAmount: Decimal;
        Custom1Amount: Decimal;
        NumberOfDays: Integer;
        Custom1NumberOfDays: Integer;
        DummyEntryAmounts: array[4] of Decimal;
    begin
        pFALedgerEntry."Automatic Entry" := true;
        pFALedgerEntry."FA No./Budgeted FA No." := '';
        pFALedgerEntry."FA Posting Category" := pFALedgerEntry."FA Posting Category"::" ";
        pFALedgerEntry."No. of Depreciation Days" := 0;
        if Type = Type::UntilDate then
            CalculateDepreciation.Calculate(
              DepreciationAmount, Custom1Amount, NumberOfDays, Custom1NumberOfDays,
              FANo, DeprBookCode, FAPostingDate, DummyEntryAmounts, 0D, 0)
        else
            CalculateAcqCostDepr.DeprCalc(
              DepreciationAmount, Custom1Amount, FANo, DeprBookCode,
              Amount2 + SalvageValue, Amount2);
        if Custom1Amount <> 0 then begin
            pFALedgerEntry."FA Posting Type" := pFALedgerEntry."FA Posting Type"::"Custom 1";
            pFALedgerEntry.Amount := Custom1Amount;
            pFALedgerEntry."No. of Depreciation Days" := Custom1NumberOfDays;
            FAInsertLedgerEntry.InsertFA(pFALedgerEntry);
            if pFALedgerEntry."G/L Entry No." > 0 then
                FAInsertLedgerEntry.InsertBalAcc(pFALedgerEntry);
        end;
        if DepreciationAmount <> 0 then begin
            pFALedgerEntry."FA Posting Type" := pFALedgerEntry."FA Posting Type"::Depreciation;
            pFALedgerEntry.Amount := DepreciationAmount;
            pFALedgerEntry."No. of Depreciation Days" := NumberOfDays;
            FAInsertLedgerEntry.InsertFA(pFALedgerEntry);
            if pFALedgerEntry."G/L Entry No." > 0 then
                FAInsertLedgerEntry.InsertBalAcc(pFALedgerEntry);
        end;
    end;

    local procedure PostSalvageValue(pFALedgerEntry: Record "FA Ledger Entry")
    begin
        if (SalvageValue = 0) or (FAPostingType <> FAPostingType::"Acquisition Cost") then
            exit;
        pFALedgerEntry."Entry No." := 0;
        pFALedgerEntry."Automatic Entry" := true;
        pFALedgerEntry.Amount := SalvageValue;
        pFALedgerEntry."FA Posting Type" := pFALedgerEntry."FA Posting Type"::"Salvage Value";
        FAInsertLedgerEntry.InsertFA(pFALedgerEntry);
    end;

    local procedure PostBudget(): Boolean
    begin
        exit(BudgetNo <> '');
    end;

    local procedure SetBudgetAssetNo()
    begin
        FixedAsset2.Get(BudgetNo);
        if not FixedAsset2."Budgeted Asset" then begin
            FixedAsset."No." := FixedAsset2."No.";
            DeprBookCode := '';
            Error(Text002Lbl, FAName(), FixedAsset.FieldCaption("Budgeted Asset"));
        end;
        if FAPostingType = FAPostingType::Maintenance then
            MaintenanceLedgerEntry."FA No./Budgeted FA No." := BudgetNo
        else
            FALedgerEntry."FA No./Budgeted FA No." := BudgetNo;
    end;

    local procedure PostBudgetAsset()
    var
        FixedAsset3: Record "Fixed Asset";
        FAPostingType2: Enum "FA Ledger Entry FA Posting Type";
    begin
        FixedAsset3.Get(BudgetNo);
        FixedAsset3.TestField(Blocked, false);
        FixedAsset3.TestField(Inactive, false);
        if FAPostingType = FAPostingType::Maintenance then begin
            MaintenanceLedgerEntry."Automatic Entry" := true;
            MaintenanceLedgerEntry."G/L Entry No." := 0;
            MaintenanceLedgerEntry."FA No./Budgeted FA No." := MaintenanceLedgerEntry."FA No.";
            MaintenanceLedgerEntry."FA No." := BudgetNo;
            MaintenanceLedgerEntry.Amount := -Amount2;
            FAInsertLedgerEntry.InsertMaintenance(MaintenanceLedgerEntry);
        end else begin
            FALedgerEntry."Automatic Entry" := true;
            FALedgerEntry."G/L Entry No." := 0;
            FALedgerEntry."FA No./Budgeted FA No." := FALedgerEntry."FA No.";
            FALedgerEntry."FA No." := BudgetNo;
            if SalvageValue <> 0 then begin
                FALedgerEntry.Amount := -SalvageValue;
                FAPostingType2 := FALedgerEntry."FA Posting Type";
                FALedgerEntry."FA Posting Type" := FALedgerEntry."FA Posting Type"::"Salvage Value";
                FAInsertLedgerEntry.InsertFA(FALedgerEntry);
                FALedgerEntry."FA Posting Type" := FAPostingType2;
            end;
            FALedgerEntry.Amount := -Amount2;
            FAInsertLedgerEntry.InsertFA(FALedgerEntry);
        end;
    end;

    local procedure PostReverseType(pFALedgerEntry: Record "FA Ledger Entry")
    var
        EntryAmounts: array[5] of Decimal;
        i: Integer;
    begin
        CalculateDisposal.CalcReverseAmounts(FANo, DeprBookCode, EntryAmounts);
        pFALedgerEntry."FA Posting Category" := pFALedgerEntry."FA Posting Category"::" ";
        pFALedgerEntry."Automatic Entry" := true;
        for i := 1 to 5 do
            if EntryAmounts[i] <> 0 then begin
                pFALedgerEntry.Amount := EntryAmounts[i];
                pFALedgerEntry."FA Posting Type" := "FA Ledger Entry FA Posting Type".FromInteger(CalculateDisposal.SetReverseType(i));
                FAInsertLedgerEntry.InsertFA(pFALedgerEntry);
                if pFALedgerEntry."G/L Entry No." > 0 then
                    FAInsertLedgerEntry.InsertBalAcc(pFALedgerEntry);
            end;
    end;

    local procedure PostGLBalAcc(pFALedgerEntry: Record "FA Ledger Entry"; AllocatedPct: Decimal)
    begin
        if AllocatedPct > 0 then begin
            pFALedgerEntry."Entry No." := 0;
            pFALedgerEntry."Automatic Entry" := true;
            pFALedgerEntry.Amount := -pFALedgerEntry.Amount;
            pFALedgerEntry.Correction := not pFALedgerEntry.Correction;
            FAInsertLedgerEntry.InsertBalDisposalAcc(pFALedgerEntry);
            pFALedgerEntry.Correction := not pFALedgerEntry.Correction;
            FAInsertLedgerEntry.InsertBalAcc(pFALedgerEntry);
        end;
    end;

    local procedure PostAllocation(var pFALedgerEntry: Record "FA Ledger Entry")
    var
        FAPostingGroup: Record "FA Posting Group";
    begin
        if pFALedgerEntry."G/L Entry No." = 0 then
            exit;
        case pFALedgerEntry."FA Posting Type" of
            pFALedgerEntry."FA Posting Type"::"Gain/Loss":
                if DepreciationBook."Disposal Calculation Method" = DepreciationBook."Disposal Calculation Method"::Net then begin
                    FAPostingGroup.Get(pFALedgerEntry."FA Posting Group");
                    FAPostingGroup.CalcFields("Allocated Gain %", "Allocated Loss %");
                    if pFALedgerEntry."Result on Disposal" = pFALedgerEntry."Result on Disposal"::Gain then
                        PostGLBalAcc(pFALedgerEntry, FAPostingGroup."Allocated Gain %")
                    else
                        PostGLBalAcc(pFALedgerEntry, FAPostingGroup."Allocated Loss %");
                end;
            pFALedgerEntry."FA Posting Type"::"Book Value on Disposal":
                begin
                    FAPostingGroup.Get(pFALedgerEntry."FA Posting Group");
                    FAPostingGroup.CalcFields("Allocated Book Value % (Gain)", "Allocated Book Value % (Loss)");
                    if pFALedgerEntry."Result on Disposal" = pFALedgerEntry."Result on Disposal"::Gain then
                        PostGLBalAcc(pFALedgerEntry, FAPostingGroup."Allocated Book Value % (Gain)")
                    else
                        PostGLBalAcc(pFALedgerEntry, FAPostingGroup."Allocated Book Value % (Loss)");
                end;
        end;
    end;

    local procedure DeprLine(): Boolean
    begin
        exit((Amount2 = 0) and (FAPostingType = FAPostingType::Depreciation) and DeprUntilDate);
    end;

    procedure FindFirstGLAcc(var FAGLPostingBuffer: Record "FA G/L Posting Buffer"): Boolean
    begin
        exit(FAInsertLedgerEntry.FindFirstGLAcc(FAGLPostingBuffer));
    end;

    procedure GetNextGLAcc(var FAGLPostingBuffer: Record "FA G/L Posting Buffer"): Integer
    begin
        exit(FAInsertLedgerEntry.GetNextGLAcc(FAGLPostingBuffer));
    end;

    local procedure FAName(): Text[200]
    var
        DepreciationCalculation: Codeunit "Depreciation Calculation";
    begin
        exit(DepreciationCalculation.FAName(FixedAsset, DeprBookCode));
    end;

    local procedure SetResultOnDisposal(var pFALedgerEntry: Record "FA Ledger Entry")
    var
        lFADepreciationBook: Record "FA Depreciation Book";
    begin
        lFADepreciationBook."FA No." := pFALedgerEntry."FA No.";
        lFADepreciationBook."Depreciation Book Code" := pFALedgerEntry."Depreciation Book Code";
        lFADepreciationBook.CalcFields("Gain/Loss");
        if lFADepreciationBook."Gain/Loss" <= 0 then
            pFALedgerEntry."Result on Disposal" := pFALedgerEntry."Result on Disposal"::Gain
        else
            pFALedgerEntry."Result on Disposal" := pFALedgerEntry."Result on Disposal"::Loss;
    end;

    local procedure CalcResultOnDisposal(pFANo: Code[20]; pDeprBookCode: Code[10]): Integer
    var
        lFADepreciationBook: Record "FA Depreciation Book";
        lFALedgerEntry: Record "FA Ledger Entry";
    begin
        lFADepreciationBook."FA No." := pFANo;
        lFADepreciationBook."Depreciation Book Code" := pDeprBookCode;
        lFADepreciationBook.CalcFields("Gain/Loss");
        if lFADepreciationBook."Gain/Loss" <= 0 then
            exit(lFALedgerEntry."Result on Disposal"::Gain);

        exit(lFALedgerEntry."Result on Disposal"::Loss);
    end;

    local procedure CheckMaintDocNo(pMaintenanceLedgerEntry: Record "Maintenance Ledger Entry")
    var
        OldMaintenanceLedgerEntry: Record "Maintenance Ledger Entry";
        FAJournalLine2: Record "FA Journal Line";
    begin
        OldMaintenanceLedgerEntry.SetCurrentKey("FA No.", "Depreciation Book Code", "Document No.");
        OldMaintenanceLedgerEntry.SetRange("FA No.", pMaintenanceLedgerEntry."FA No.");
        OldMaintenanceLedgerEntry.SetRange("Depreciation Book Code", pMaintenanceLedgerEntry."Depreciation Book Code");
        OldMaintenanceLedgerEntry.SetRange("Document No.", pMaintenanceLedgerEntry."Document No.");
        if OldMaintenanceLedgerEntry.FindFirst() then begin
            FAJournalLine2."FA Posting Type" := FAJournalLine2."FA Posting Type"::Maintenance;
            Error(
              Text003Lbl,
              OldMaintenanceLedgerEntry.FieldCaption("Document No."),
              OldMaintenanceLedgerEntry."Document No.",
              FAJournalLine2.FieldCaption("FA Posting Type"),
              FAJournalLine2."FA Posting Type",
              FAName());
        end;
    end;

    procedure UpdateRegNo(GLRegNo: Integer)
    var
        FARegister: Record "FA Register";
    begin
        if FARegister.FindLast() then begin
            FARegister."G/L Register No." := GLRegNo;
            FARegister.Modify();
        end;
    end;


    procedure GetNextMatchingFALedgEntry(SourceFAJournalLine: Record "FA Journal Line"; FromEntryNo: Integer; pDeprBookCode: Code[10]): Integer
    var
        lFALedgerEntry: Record "FA Ledger Entry";
    begin
        lFALedgerEntry.SetCurrentKey("Entry No.");
        lFALedgerEntry.SetFilter("Entry No.", '>%1', FromEntryNo);
        lFALedgerEntry.SetRange("Depreciation Book Code", pDeprBookCode);
#pragma warning disable AA0210
        lFALedgerEntry.SetRange(Amount, -SourceFAJournalLine.Amount);
#pragma warning restore AA0210
        lFALedgerEntry.SetRange("FA Posting Type", SourceFAJournalLine.ConvertToLedgEntry(SourceFAJournalLine));
        lFALedgerEntry.SetRange("FA No.", SourceFAJournalLine."FA No.");
        lFALedgerEntry.SetRange("FA Posting Date", SourceFAJournalLine."FA Posting Date");
        lFALedgerEntry.FindFirst();
        exit(lFALedgerEntry."Entry No.");
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFAJnlPostLine(var FAJournalLine: Record "FA Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGenJnlPostLine(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFAJnlPostLine(var FAJournalLine: Record "FA Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGenJnlPostLine(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostFixedAssetFromGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; var FALedgerEntry: Record "FA Ledger Entry"; FAAmount: Decimal; VATAmount: Decimal)
    begin
    end;
}
