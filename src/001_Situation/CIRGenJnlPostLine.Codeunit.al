codeunit 50503 "CIR Gen. Jnl.-Post Line"
{
    Permissions = TableData "G/L Account" = r,
                  TableData "G/L Entry" = rimd,
                  TableData "Cust. Ledger Entry" = imd,
                  TableData "Vendor Ledger Entry" = imd,
                  TableData "G/L Register" = imd,
                  TableData "G/L Entry - VAT Entry Link" = rimd,
                  TableData "VAT Entry" = imd,
                  TableData "Bank Account Ledger Entry" = imd,
                  TableData "Check Ledger Entry" = imd,
                  TableData "Detailed Cust. Ledg. Entry" = imd,
                  TableData "Detailed Vendor Ledg. Entry" = imd,
                  TableData "Line Fee Note on Report Hist." = rim,
                  TableData "Employee Ledger Entry" = imd,
                  TableData "Detailed Employee Ledger Entry" = imd,
                  TableData "FA Ledger Entry" = rimd,
                  TableData "FA Register" = imd,
                  TableData "Maintenance Ledger Entry" = rimd;
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    begin
        GetGLSetup();
        RunWithCheck(Rec);
    end;

    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        GlobalGLEntry: Record "G/L Entry";
        TempGLEntryBuf: Record "G/L Entry" temporary;
        TempGLEntryVAT: Record "G/L Entry" temporary;
        GLRegister: Record "G/L Register";
        AddCurrency: Record Currency;
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        VATEntry: Record "VAT Entry";
        TaxDetail: Record "Tax Detail";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        GLEntryVATEntryLink: Record "G/L Entry - VAT Entry Link";
        TempVATEntry: Record "VAT Entry" temporary;
        UnrealCVLedgEntryBuffer: Record "Unreal. CV Ledg. Entry Buffer";
        SourceCode: Record "Source Code";
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        PaymentToleranceManagement: Codeunit "Payment Tolerance Management";
        CIRFAJnlPostLine: Codeunit "CIR FA Jnl.-Post Line";
        DeferralUtilities: Codeunit "Deferral Utilities";
        DeferralDocType: Option Purchase,Sales,"G/L";
        LastDocType: Enum "Gen. Journal Document Type";
        AddCurrencyCode: Code[10];
        GLSourceCode: Code[10];
        LastDocNo: Code[20];
        FiscalYearStartDate: Date;
        CurrencyDate: Date;
        LastDate: Date;
        BalanceCheckAmount: Decimal;
        BalanceCheckAmount2: Decimal;
        BalanceCheckAddCurrAmount: Decimal;
        BalanceCheckAddCurrAmount2: Decimal;
        CurrentBalance: Decimal;
        TotalAddCurrAmount: Decimal;
        TotalAmount: Decimal;
        UnrealizedRemainingAmountCust: Decimal;
        UnrealizedRemainingAmountVend: Decimal;
        AmountRoundingPrecision: Decimal;
        AddCurrGLEntryVATAmt: Decimal;
        CurrencyFactor: Decimal;
        FirstEntryNo: Integer;
        NextEntryNo: Integer;
        NextVATEntryNo: Integer;
        FirstNewVATEntryNo: Integer;
        FirstTransactionNo: Integer;
        NextTransactionNo: Integer;
        NextConnectionNo: Integer;
        NextCheckEntryNo: Integer;
        InsertedTempGLEntryVAT: Integer;
        GLEntryNo: Integer;
        UseCurrFactorOnly: Boolean;
        NonAddCurrCodeOccured: Boolean;
        FADimAlreadyChecked: Boolean;
        ResidualRoundingErr: Label 'Residual caused by rounding of %1', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Reliquat créé par l''arrondi de %1" }, { "lang": "FRB", "txt": "Reliquat créé par l''arrondi de %1" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        DimensionUsedErr: Label 'A dimension used in %1 %2, %3, %4 has caused an error. %5.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Un axe analytique utilisé dans %1 %2, %3, %4 a provoqué une erreur. %5." }, { "lang": "FRB", "txt": "Un axe analytique utilisé dans %1 %2, %3, %4 a provoqué une erreur. %5." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        OverrideDimErr: Boolean;
        JobLine: Boolean;
        CheckUnrealizedCust: Boolean;
        CheckUnrealizedVend: Boolean;
        GLSetupRead: Boolean;
        NeedsRoundingErr: Label '%1 needs to be rounded', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "%1 doit être arrondi" }, { "lang": "FRB", "txt": "%1 doit être arrondi" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        PurchaseAlreadyExistsErr: Label 'Purchase %1 %2 already exists for this vendor.', Comment = '{ "instructions": "%1 = Document Type; %2 = Document No.", "translations": [ { "lang": "FRA", "txt": "Le document %1 achat %2 existe déjà pour ce fournisseur." }, { "lang": "FRB", "txt": "Le document %1 achat %2 existe déjà pour ce fournisseur." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        BankPaymentTypeMustNotBeFilledErr: Label 'Bank Payment Type must not be filled if Currency Code is different in Gen. Journal Line and Bank Account.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Mode émission paiement ne doit pas être renseigné si Code devise est différent dans Ligne feuille comptabilité et Compte bancaire." }, { "lang": "FRB", "txt": "Mode émission paiement ne doit pas être renseigné si Code devise est différent dans Ligne feuille comptabilité et Compte bancaire." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        DocNoMustBeEnteredErr: Label 'Document No. must be entered when Bank Payment Type is %1.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° document doit être renseigné si Mode émission paiement correspond à %1." }, { "lang": "FRB", "txt": "N° document doit être renseigné si Mode émission paiement correspond à %1." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        CheckAlreadyExistsErr: Label 'Check %1 already exists for this Bank Account.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Le chèque %1 existe déjà pour ce compte bancaire." }, { "lang": "FRB", "txt": "Le chèque %1 existe déjà pour ce compte bancaire." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        Text10800Lbl: Label 'Not a derogatory line.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N''est pas une ligne dérogatoire." }, { "lang": "FRB", "txt": "N''est pas une ligne dérogatoire." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        OldTransactionNo: Integer;
        InvalidPostingDateErr: Label '%1 is not within the range of posting dates for your company.', Comment = '{ "instructions": "%1=The date passed in for the posting date.", "translations": [ { "lang": "FRA", "txt": "%1 n''est pas dans la plage de dates de comptabilisation de votre société." }, { "lang": "FRB", "txt": "%1 n''est pas dans la plage de dates de comptabilisation de votre société." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        DescriptionMustNotBeBlankErr: Label 'When %1 is selected for %2, %3 must have a value.', Comment = '{ "instructions": "%1: Field Omit Default Descr. in Jnl., %2 G/L Account No, %3 Description", "translations": [ { "lang": "FRA", "txt": "Si %1 est sélectionné pour %2, %3 doit avoir une valeur." }, { "lang": "FRB", "txt": "Si %1 est sélectionné pour %2, %3 doit avoir une valeur." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        NoDeferralScheduleErr: Label 'You must create a deferral schedule if a deferral template is selected. Line: %1, Deferral Template: %2.', Comment = '{ "instructions": "%1=The line number of the general ledger transaction, %2=The Deferral Template Code", "translations": [ { "lang": "FRA", "txt": "Vous devez créer un tableau d''échelonnement si vous sélectionnez un modèle d''échelonnement. Ligne : %1, Modèle d''échelonnement : %2." }, { "lang": "FRB", "txt": "Vous devez créer un tableau d''échelonnement si vous sélectionnez un modèle d''échelonnement. Ligne : %1, Modèle d''échelonnement : %2." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        ZeroDeferralAmtErr: Label 'Deferral amounts cannot be 0. Line: %1, Deferral Template: %2.', Comment = '{ "instructions": "%1=The line number of the general ledger transaction, %2=The Deferral Template Code", "translations": [ { "lang": "FRA", "txt": "Les montants d''échelonnement doivent être différents de 0. Ligne : %1, Modèle d''échelonnement : %2." }, { "lang": "FRB", "txt": "Les montants d''échelonnement doivent être différents de 0. Ligne : %1, Modèle d''échelonnement : %2." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
        IsGLRegInserted: Boolean;
        EntryType: Option;

    procedure GetGLReg(var NewGLRegister: Record "G/L Register")
    begin
        NewGLRegister := GLRegister;
    end;

    procedure RunWithCheck(var GenJournalLine2: Record "Gen. Journal Line"): Integer
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.Copy(GenJournalLine2);
        Code(GenJournalLine, true);
        OnAfterRunWithCheck(GenJournalLine);
        GenJournalLine2 := GenJournalLine;
        exit(GLEntryNo);
    end;

    procedure RunWithoutCheck(var GenJournalLine2: Record "Gen. Journal Line"): Integer
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.Copy(GenJournalLine2);
        Code(GenJournalLine, false);
        OnAfterRunWithoutCheck(GenJournalLine);
        GenJournalLine2 := GenJournalLine;
        exit(GLEntryNo);
    end;

    local procedure "Code"(var GenJournalLine: Record "Gen. Journal Line"; CheckLine: Boolean)
    var
        Balancing: Boolean;
        IsTransactionConsistent: Boolean;
        IsPosted: Boolean;
    begin
        IsPosted := false;
        OnBeforeCode(GenJournalLine, CheckLine, IsPosted, GLRegister);
        if IsPosted then
            exit;

        GetGLSourceCode();

        if GenJournalLine.EmptyLine() then begin
            InitLastDocDate(GenJournalLine);
            exit;
        end;

        if CheckLine then begin
            if OverrideDimErr then
                GenJnlCheckLine.SetOverDimErr();
            GenJnlCheckLine.RunCheck(GenJournalLine);
        end;

        SourceCode.GET(GenJournalLine."Source Code");
        IF SourceCode."CIR Situation" THEN
            EntryType := GenJournalLine."CIR Entry Type"::Situation
        ELSE
            EntryType := GenJournalLine."CIR Entry Type"::Definitive;

        AmountRoundingPrecision := InitAmounts(GenJournalLine);

        if GenJournalLine."Bill-to/Pay-to No." = '' then
            case true of
                GenJournalLine."Account Type" in [GenJournalLine."Account Type"::Customer, GenJournalLine."Account Type"::Vendor]:
                    GenJournalLine."Bill-to/Pay-to No." := GenJournalLine."Account No.";
                GenJournalLine."Bal. Account Type" in [GenJournalLine."Bal. Account Type"::Customer, GenJournalLine."Bal. Account Type"::Vendor]:
                    GenJournalLine."Bill-to/Pay-to No." := GenJournalLine."Bal. Account No.";
            end;
        if GenJournalLine."Document Date" = 0D then
            GenJournalLine."Document Date" := GenJournalLine."Posting Date";
        if GenJournalLine."Due Date" = 0D then
            GenJournalLine."Due Date" := GenJournalLine."Posting Date";

        JobLine := (GenJournalLine."Job No." <> '');

        OnBeforeStartOrContinuePosting(GenJournalLine, LastDocType.AsInteger(), LastDocNo, LastDate, NextEntryNo);

        if NextEntryNo = 0 then
            StartPosting(GenJournalLine)
        else
            ContinuePosting(GenJournalLine);

        if GenJournalLine."Account No." <> '' then begin
            if (GenJournalLine."Bal. Account No." <> '') and
               (not GenJournalLine."System-Created Entry") and
               (GenJournalLine."Account Type" in
                [GenJournalLine."Account Type"::Customer,
                 GenJournalLine."Account Type"::Vendor,
                 GenJournalLine."Account Type"::"Fixed Asset"])
            then begin
                CODEUNIT.Run(CODEUNIT::"Exchange Acc. G/L Journal Line", GenJournalLine);
                Balancing := true;
            end;

            PostGenJnlLine(GenJournalLine, Balancing);
        end;

        if GenJournalLine."Bal. Account No." <> '' then begin
            CODEUNIT.Run(CODEUNIT::"Exchange Acc. G/L Journal Line", GenJournalLine);
            PostGenJnlLine(GenJournalLine, not Balancing);
        end;

        CheckPostUnrealizedVAT(GenJournalLine, true);

        CreateDeferralScheduleFromGL(GenJournalLine, Balancing);

        OnCodeOnBeforeFinishPosting(GenJournalLine, Balancing);
        IsTransactionConsistent := FinishPosting(GenJournalLine);

        OnAfterGLFinishPosting(
          GlobalGLEntry, GenJournalLine, IsTransactionConsistent, FirstTransactionNo, GLRegister, TempGLEntryBuf, NextEntryNo, NextTransactionNo);
    end;

    local procedure PostGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean)
    begin
        OnBeforePostGenJnlLine(GenJournalLine, Balancing);

        case GenJournalLine."Account Type" of
            GenJournalLine."Account Type"::"G/L Account":
                PostGLAcc(GenJournalLine, Balancing);
            GenJournalLine."Account Type"::Customer:
                PostCust(GenJournalLine, Balancing);
            GenJournalLine."Account Type"::Vendor:
                PostVend(GenJournalLine, Balancing);
            GenJournalLine."Account Type"::Employee:
                PostEmployee(GenJournalLine);
            GenJournalLine."Account Type"::"Bank Account":
                PostBankAcc(GenJournalLine, Balancing);
            GenJournalLine."Account Type"::"Fixed Asset":
                PostFixedAsset(GenJournalLine);
            GenJournalLine."Account Type"::"IC Partner":
                PostICPartner(GenJournalLine);
        end;

        OnAfterPostGenJnlLine(GenJournalLine, Balancing);
    end;

    local procedure InitAmounts(var GenJournalLine: Record "Gen. Journal Line"): Decimal
    var
        Currency: Record Currency;
    begin
        if GenJournalLine."Currency Code" = '' then begin
            Currency.InitRoundingPrecision();
            GenJournalLine."Amount (LCY)" := GenJournalLine.Amount;
            GenJournalLine."VAT Amount (LCY)" := GenJournalLine."VAT Amount";
            GenJournalLine."VAT Base Amount (LCY)" := GenJournalLine."VAT Base Amount";
        end else begin
            Currency.Get(GenJournalLine."Currency Code");
            Currency.TestField("Amount Rounding Precision");
            if not GenJournalLine."System-Created Entry" then begin
                GenJournalLine."Source Currency Code" := GenJournalLine."Currency Code";
                GenJournalLine."Source Currency Amount" := GenJournalLine.Amount;
                GenJournalLine."Source Curr. VAT Base Amount" := GenJournalLine."VAT Base Amount";
                GenJournalLine."Source Curr. VAT Amount" := GenJournalLine."VAT Amount";
            end;
        end;
        if GenJournalLine."Additional-Currency Posting" = GenJournalLine."Additional-Currency Posting"::None then begin
            if GenJournalLine.Amount <> Round(GenJournalLine.Amount, Currency."Amount Rounding Precision") then
                GenJournalLine.FieldError(
                  Amount,
                  StrSubstNo(NeedsRoundingErr, GenJournalLine.Amount));
            if GenJournalLine."Amount (LCY)" <> Round(GenJournalLine."Amount (LCY)") then
                GenJournalLine.FieldError(
                  "Amount (LCY)",
                  StrSubstNo(NeedsRoundingErr, GenJournalLine."Amount (LCY)"));
        end;
        exit(Currency."Amount Rounding Precision");
    end;

    procedure InitLastDocDate(GenJournalLine: Record "Gen. Journal Line")
    begin
        LastDocType := GenJournalLine."Document Type";
        LastDocNo := GenJournalLine."Document No.";
        LastDate := GenJournalLine."Posting Date";

        OnAfterInitLastDocDate(GenJournalLine);
    end;

    local procedure InitNextEntryNo()
    var
        [SecurityFiltering(SecurityFilter::Ignored)]
        GLEntry: Record "G/L Entry";
    begin
        GLEntry.LockTable();
        if EntryType = GlobalGLEntry."CIR Entry Type"::Definitive then begin
            if GLEntry.FindLast() then begin
                NextEntryNo := GLEntry."Entry No." + 1;
                NextTransactionNo := GLEntry."Transaction No." + 1;
            end else begin
                NextEntryNo := 1;
                NextTransactionNo := 1;
            end;
        end else
            if GLEntry.FindFirst() then begin
                NextEntryNo := GLEntry."Entry No." - 1;
                if NextEntryNo = 0 then
                    NextEntryNo := -1;
                NextTransactionNo := GLEntry."Transaction No." - 1;
            end else begin
                NextEntryNo := -1;
                NextTransactionNo := -1;
            end;
    end;

    local procedure InitVAT(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; var VATPostingSetup: Record "VAT Posting Setup")
    var
        LCYCurrency: Record Currency;
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        IsHandled: Boolean;
    begin
        OnBeforeInitVAT(GenJournalLine, GLEntry, VATPostingSetup);

        LCYCurrency.InitRoundingPrecision();
        if GenJournalLine."Gen. Posting Type" <> GenJournalLine."Gen. Posting Type"::" " then begin // None
            VATPostingSetup.Get(GenJournalLine."VAT Bus. Posting Group", GenJournalLine."VAT Prod. Posting Group");
            IsHandled := false;
            OnInitVATOnBeforeVATPostingSetupCheck(GenJournalLine, GLEntry, VATPostingSetup, IsHandled);
            if not IsHandled then
                GenJournalLine.TestField("VAT Calculation Type", VATPostingSetup."VAT Calculation Type");
            case GenJournalLine."VAT Posting" of
                GenJournalLine."VAT Posting"::"Automatic VAT Entry":
                    begin
                        GLEntry.CopyPostingGroupsFromGenJnlLine(GenJournalLine);
                        case GenJournalLine."VAT Calculation Type" of
                            GenJournalLine."VAT Calculation Type"::"Normal VAT":
                                if GenJournalLine."VAT Difference" <> 0 then begin
                                    GLEntry.Amount := GenJournalLine."VAT Base Amount (LCY)";
                                    GLEntry."VAT Amount" := GenJournalLine."Amount (LCY)" - GLEntry.Amount;
                                    GLEntry."Additional-Currency Amount" := GenJournalLine."Source Curr. VAT Base Amount";
                                    if GenJournalLine."Source Currency Code" = AddCurrencyCode then
                                        AddCurrGLEntryVATAmt := GenJournalLine."Source Curr. VAT Amount"
                                    else
                                        AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GLEntry."VAT Amount");
                                end else begin
                                    GLEntry."VAT Amount" :=
                                      Round(
                                        GenJournalLine."Amount (LCY)" * VATPostingSetup."VAT %" / (100 + VATPostingSetup."VAT %"),
                                        LCYCurrency."Amount Rounding Precision", LCYCurrency.VATRoundingDirection());
                                    GLEntry.Amount := GenJournalLine."Amount (LCY)" - GLEntry."VAT Amount";
                                    if GenJournalLine."Source Currency Code" = AddCurrencyCode then
                                        AddCurrGLEntryVATAmt :=
                                          Round(
                                            GenJournalLine."Source Currency Amount" * VATPostingSetup."VAT %" / (100 + VATPostingSetup."VAT %"),
                                            AddCurrency."Amount Rounding Precision", AddCurrency.VATRoundingDirection())
                                    else
                                        AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GLEntry."VAT Amount");
                                    GLEntry."Additional-Currency Amount" := GenJournalLine."Source Currency Amount" - AddCurrGLEntryVATAmt;
                                end;
                            GenJournalLine."VAT Calculation Type"::"Reverse Charge VAT":
                                case GenJournalLine."Gen. Posting Type" of
                                    GenJournalLine."Gen. Posting Type"::Purchase:
                                        if GenJournalLine."VAT Difference" <> 0 then begin
                                            GLEntry."VAT Amount" := GenJournalLine."VAT Amount (LCY)";
                                            if GenJournalLine."Source Currency Code" = AddCurrencyCode then
                                                AddCurrGLEntryVATAmt := GenJournalLine."Source Curr. VAT Amount"
                                            else
                                                AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GLEntry."VAT Amount");
                                        end else begin
                                            GLEntry."VAT Amount" :=
                                              Round(
                                                GLEntry.Amount * VATPostingSetup."VAT %" / 100,
                                                LCYCurrency."Amount Rounding Precision", LCYCurrency.VATRoundingDirection());
                                            if GenJournalLine."Source Currency Code" = AddCurrencyCode then
                                                AddCurrGLEntryVATAmt :=
                                                  Round(
                                                    GLEntry."Additional-Currency Amount" * VATPostingSetup."VAT %" / 100,
                                                    AddCurrency."Amount Rounding Precision", AddCurrency.VATRoundingDirection())
                                            else
                                                AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GLEntry."VAT Amount");
                                        end;
                                    GenJournalLine."Gen. Posting Type"::Sale:
                                        begin
                                            GLEntry."VAT Amount" := 0;
                                            AddCurrGLEntryVATAmt := 0;
                                        end;
                                end;
                            GenJournalLine."VAT Calculation Type"::"Full VAT":
                                begin
                                    IsHandled := false;
                                    OnInitVATOnBeforeTestFullVATAccount(GenJournalLine, GLEntry, VATPostingSetup, IsHandled);
                                    if not IsHandled then
                                        case GenJournalLine."Gen. Posting Type" of
                                            GenJournalLine."Gen. Posting Type"::Sale:
                                                GenJournalLine.TestField("Account No.", VATPostingSetup.GetSalesAccount(false));
                                            GenJournalLine."Gen. Posting Type"::Purchase:
                                                GenJournalLine.TestField("Account No.", VATPostingSetup.GetPurchAccount(false));
                                        end;
                                    GLEntry.Amount := 0;
                                    GLEntry."Additional-Currency Amount" := 0;
                                    GLEntry."VAT Amount" := GenJournalLine."Amount (LCY)";
                                    if GenJournalLine."Source Currency Code" = AddCurrencyCode then
                                        AddCurrGLEntryVATAmt := GenJournalLine."Source Currency Amount"
                                    else
                                        AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GenJournalLine."Amount (LCY)");
                                end;
                            GenJournalLine."VAT Calculation Type"::"Sales Tax":
                                begin
                                    if (GenJournalLine."Gen. Posting Type" = GenJournalLine."Gen. Posting Type"::Purchase) and
                                       GenJournalLine."Use Tax"
                                    then begin
                                        GLEntry."VAT Amount" :=
                                          Round(
                                            SalesTaxCalculate.CalculateTax(
                                              GenJournalLine."Tax Area Code", GenJournalLine."Tax Group Code", GenJournalLine."Tax Liable",
                                              GenJournalLine."Posting Date", GenJournalLine."Amount (LCY)", GenJournalLine.Quantity, 0));
                                        OnAfterSalesTaxCalculateCalculateTax(GenJournalLine, GLEntry, LCYCurrency);
                                        GLEntry.Amount := GenJournalLine."Amount (LCY)";
                                    end else begin
                                        GLEntry.Amount :=
                                          Round(
                                            SalesTaxCalculate.ReverseCalculateTax(
                                              GenJournalLine."Tax Area Code", GenJournalLine."Tax Group Code", GenJournalLine."Tax Liable",
                                              GenJournalLine."Posting Date", GenJournalLine."Amount (LCY)", GenJournalLine.Quantity, 0));
                                        OnAfterSalesTaxCalculateReverseCalculateTax(GenJournalLine, GLEntry, LCYCurrency);
                                        GLEntry."VAT Amount" := GenJournalLine."Amount (LCY)" - GLEntry.Amount;
                                    end;
                                    GLEntry."Additional-Currency Amount" := GenJournalLine."Source Currency Amount";
                                    if GenJournalLine."Source Currency Code" = AddCurrencyCode then
                                        AddCurrGLEntryVATAmt := GenJournalLine."Source Curr. VAT Amount"
                                    else
                                        AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GLEntry."VAT Amount");
                                end;
                        end;
                    end;
                GenJournalLine."VAT Posting"::"Manual VAT Entry":
                    if GenJournalLine."Gen. Posting Type" <> GenJournalLine."Gen. Posting Type"::Settlement then begin
                        GLEntry.CopyPostingGroupsFromGenJnlLine(GenJournalLine);
                        GLEntry."VAT Amount" := GenJournalLine."VAT Amount (LCY)";
                        if GenJournalLine."Source Currency Code" = AddCurrencyCode then
                            AddCurrGLEntryVATAmt := GenJournalLine."Source Curr. VAT Amount"
                        else
                            AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GenJournalLine."VAT Amount (LCY)");
                    end;
            end;
        end;

        GLEntry."Additional-Currency Amount" :=
          GLCalcAddCurrency(GLEntry.Amount, GLEntry."Additional-Currency Amount", GLEntry."Additional-Currency Amount", true, GenJournalLine);

        OnAfterInitVAT(GenJournalLine, GLEntry, VATPostingSetup, AddCurrGLEntryVATAmt);
    end;

    local procedure PostVAT(GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; VATPostingSetup: Record "VAT Posting Setup")
    var
        TaxDetail2: Record "Tax Detail";
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        VATAmount: Decimal;
        VATAmount2: Decimal;
        VATBase: Decimal;
        VATBase2: Decimal;
        SrcCurrVATAmount: Decimal;
        SrcCurrVATBase: Decimal;
        SrcCurrSalesTaxBaseAmount: Decimal;
        RemSrcCurrVATAmount: Decimal;
        SalesTaxBaseAmount: Decimal;
        TaxDetailFound: Boolean;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforePostVAT(GenJournalLine, GLEntry, VATPostingSetup, IsHandled);
        if IsHandled then
            exit;

        // Post VAT
        // VAT for VAT entry
        case GenJournalLine."VAT Calculation Type" of
            GenJournalLine."VAT Calculation Type"::"Normal VAT",
            GenJournalLine."VAT Calculation Type"::"Reverse Charge VAT",
            GenJournalLine."VAT Calculation Type"::"Full VAT":
                begin
                    if GenJournalLine."VAT Posting" = GenJournalLine."VAT Posting"::"Automatic VAT Entry" then
                        GenJournalLine."VAT Base Amount (LCY)" := GLEntry.Amount;
                    if GenJournalLine."Gen. Posting Type" = GenJournalLine."Gen. Posting Type"::Settlement then
                        AddCurrGLEntryVATAmt := GenJournalLine."Source Curr. VAT Amount";
                    InsertVAT(
                      GenJournalLine, VATPostingSetup,
                      GLEntry.Amount, GLEntry."VAT Amount", GenJournalLine."VAT Base Amount (LCY)", GenJournalLine."Source Currency Code",
                      GLEntry."Additional-Currency Amount", AddCurrGLEntryVATAmt, GenJournalLine."Source Curr. VAT Base Amount");
                    NextConnectionNo := NextConnectionNo + 1;
                end;
            GenJournalLine."VAT Calculation Type"::"Sales Tax":
                begin
                    case GenJournalLine."VAT Posting" of
                        GenJournalLine."VAT Posting"::"Automatic VAT Entry":
                            SalesTaxBaseAmount := GLEntry.Amount;
                        GenJournalLine."VAT Posting"::"Manual VAT Entry":
                            SalesTaxBaseAmount := GenJournalLine."VAT Base Amount (LCY)";
                    end;
                    if (GenJournalLine."VAT Posting" = GenJournalLine."VAT Posting"::"Manual VAT Entry") and
                       (GenJournalLine."Gen. Posting Type" = GenJournalLine."Gen. Posting Type"::Settlement)
                    then
                        InsertVAT(
                          GenJournalLine, VATPostingSetup,
                          GLEntry.Amount, GLEntry."VAT Amount", GenJournalLine."VAT Base Amount (LCY)", GenJournalLine."Source Currency Code",
                          GenJournalLine."Source Curr. VAT Base Amount", GenJournalLine."Source Curr. VAT Amount", GenJournalLine."Source Curr. VAT Base Amount")
                    else begin
                        Clear(SalesTaxCalculate);
                        SalesTaxCalculate.InitSalesTaxLines(
                          GenJournalLine."Tax Area Code", GenJournalLine."Tax Group Code", GenJournalLine."Tax Liable",
                          SalesTaxBaseAmount, GenJournalLine.Quantity, GenJournalLine."Posting Date", GLEntry."VAT Amount");
                        OnAfterSalesTaxCalculateInitSalesTaxLines(GenJournalLine, GLEntry, SalesTaxBaseAmount);
                        SrcCurrVATAmount := 0;
                        SrcCurrSalesTaxBaseAmount := CalcLCYToAddCurr(SalesTaxBaseAmount);
                        RemSrcCurrVATAmount := AddCurrGLEntryVATAmt;
                        TaxDetailFound := false;
                        while SalesTaxCalculate.GetSalesTaxLine(TaxDetail2, VATAmount, VATBase) do begin
                            RemSrcCurrVATAmount := RemSrcCurrVATAmount - SrcCurrVATAmount;
                            if TaxDetailFound then
#pragma warning disable AA0205
                                InsertVAT(
                                  GenJournalLine, VATPostingSetup,
                                  SalesTaxBaseAmount, VATAmount2, VATBase2, GenJournalLine."Source Currency Code",
                                  SrcCurrSalesTaxBaseAmount, SrcCurrVATAmount, SrcCurrVATBase);
#pragma warning restore AA0205
                            TaxDetailFound := true;
                            TaxDetail := TaxDetail2;
                            VATAmount2 := VATAmount;
                            VATBase2 := VATBase;
                            SrcCurrVATAmount := CalcLCYToAddCurr(VATAmount);
                            SrcCurrVATBase := CalcLCYToAddCurr(VATBase);
                        end;
                        if TaxDetailFound then
                            InsertVAT(
                              GenJournalLine, VATPostingSetup,
                              SalesTaxBaseAmount, VATAmount2, VATBase2, GenJournalLine."Source Currency Code",
                              SrcCurrSalesTaxBaseAmount, RemSrcCurrVATAmount, SrcCurrVATBase);
                        InsertSummarizedVAT(GenJournalLine);
                    end;
                end;
        end;

        OnAfterPostVAT(GenJournalLine, GLEntry, VATPostingSetup);
    end;

    local procedure InsertVAT(GenJournalLine: Record "Gen. Journal Line"; VATPostingSetup: Record "VAT Posting Setup"; GLEntryAmount: Decimal; GLEntryVATAmount: Decimal; GLEntryBaseAmount: Decimal; SrcCurrCode: Code[10]; SrcCurrGLEntryAmt: Decimal; SrcCurrGLEntryVATAmt: Decimal; SrcCurrGLEntryBaseAmt: Decimal)
    var
        TaxJurisdiction: Record "Tax Jurisdiction";
        VATAmount: Decimal;
        VATBase: Decimal;
        SrcCurrVATAmount: Decimal;
        SrcCurrVATBase: Decimal;
        VATDifferenceLCY: Decimal;
        SrcCurrVATDifference: Decimal;
        UnrealizedVAT: Boolean;
    begin
        OnBeforeInsertVAT(
          GenJournalLine, VATEntry, UnrealizedVAT, AddCurrencyCode, VATPostingSetup, GLEntryAmount, GLEntryVATAmount, GLEntryBaseAmount,
          SrcCurrCode, SrcCurrGLEntryAmt, SrcCurrGLEntryVATAmt, SrcCurrGLEntryBaseAmt);

        // Post VAT
        // VAT for VAT entry
        VATEntry.Init();
        VATEntry.CopyFromGenJnlLine(GenJournalLine);
        VATEntry."Entry No." := NextVATEntryNo;
        VATEntry."EU Service" := VATPostingSetup."EU Service";
        VATEntry."Transaction No." := NextTransactionNo;
        VATEntry."Sales Tax Connection No." := NextConnectionNo;

        if GenJournalLine."VAT Difference" = 0 then
            VATDifferenceLCY := 0
        else
            if GenJournalLine."Currency Code" = '' then
                VATDifferenceLCY := GenJournalLine."VAT Difference"
            else
                VATDifferenceLCY :=
                  Round(
                    CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                      GenJournalLine."Posting Date", GenJournalLine."Currency Code", GenJournalLine."VAT Difference",
                      CurrencyExchangeRate.ExchangeRate(GenJournalLine."Posting Date", GenJournalLine."Currency Code")));

        if GenJournalLine."VAT Calculation Type" = GenJournalLine."VAT Calculation Type"::"Sales Tax" then
            UpdateVATEntryTaxDetails(GenJournalLine, VATEntry, TaxDetail, TaxJurisdiction);

        if AddCurrencyCode <> '' then
            if AddCurrencyCode <> SrcCurrCode then begin
                SrcCurrGLEntryAmt := ExchangeAmtLCYToFCY2(GLEntryAmount);
                SrcCurrGLEntryVATAmt := ExchangeAmtLCYToFCY2(GLEntryVATAmount);
                SrcCurrGLEntryBaseAmt := ExchangeAmtLCYToFCY2(GLEntryBaseAmount);
                SrcCurrVATDifference := ExchangeAmtLCYToFCY2(VATDifferenceLCY);
            end else
                SrcCurrVATDifference := GenJournalLine."VAT Difference";

        UnrealizedVAT :=
          (((VATPostingSetup."Unrealized VAT Type" > 0) and
            (VATPostingSetup."VAT Calculation Type" in
             [VATPostingSetup."VAT Calculation Type"::"Normal VAT",
              VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT",
              VATPostingSetup."VAT Calculation Type"::"Full VAT"])) or
           ((TaxJurisdiction."Unrealized VAT Type" > 0) and
            (VATPostingSetup."VAT Calculation Type" in
             [VATPostingSetup."VAT Calculation Type"::"Sales Tax"]))) and
          IsNotPayment(GenJournalLine."Document Type");
        if GeneralLedgerSetup."Prepayment Unrealized VAT" and not GeneralLedgerSetup."Unrealized VAT" and
           (VATPostingSetup."Unrealized VAT Type" > 0)
        then
            UnrealizedVAT := GenJournalLine.Prepayment;

        // VAT for VAT entry
        if GenJournalLine."Gen. Posting Type" <> GenJournalLine."Gen. Posting Type"::" " then begin
            case GenJournalLine."VAT Posting" of
                GenJournalLine."VAT Posting"::"Automatic VAT Entry":
                    begin
                        VATAmount := GLEntryVATAmount;
                        VATBase := GLEntryBaseAmount;
                        SrcCurrVATAmount := SrcCurrGLEntryVATAmt;
                        SrcCurrVATBase := SrcCurrGLEntryBaseAmt;
                    end;
                GenJournalLine."VAT Posting"::"Manual VAT Entry":
                    begin
                        if GenJournalLine."Gen. Posting Type" = GenJournalLine."Gen. Posting Type"::Settlement then begin
                            VATAmount := GLEntryAmount;
                            SrcCurrVATAmount := SrcCurrGLEntryVATAmt;
                            VATEntry.Closed := true;
                        end else begin
                            VATAmount := GLEntryVATAmount;
                            SrcCurrVATAmount := SrcCurrGLEntryVATAmt;
                        end;
                        VATBase := GLEntryBaseAmount;
                        SrcCurrVATBase := SrcCurrGLEntryBaseAmt;
                    end;
            end;

            if UnrealizedVAT then begin
                VATEntry.Amount := 0;
                VATEntry.Base := 0;
                VATEntry."Unrealized Amount" := VATAmount;
                VATEntry."Unrealized Base" := VATBase;
                VATEntry."Remaining Unrealized Amount" := VATEntry."Unrealized Amount";
                VATEntry."Remaining Unrealized Base" := VATEntry."Unrealized Base";
            end else begin
                VATEntry.Amount := VATAmount;
                VATEntry.Base := VATBase;
                VATEntry."Unrealized Amount" := 0;
                VATEntry."Unrealized Base" := 0;
                VATEntry."Remaining Unrealized Amount" := 0;
                VATEntry."Remaining Unrealized Base" := 0;
            end;

            if AddCurrencyCode = '' then begin
                VATEntry."Additional-Currency Base" := 0;
                VATEntry."Additional-Currency Amount" := 0;
                VATEntry."Add.-Currency Unrealized Amt." := 0;
                VATEntry."Add.-Currency Unrealized Base" := 0;
            end else
                if UnrealizedVAT then begin
                    VATEntry."Additional-Currency Base" := 0;
                    VATEntry."Additional-Currency Amount" := 0;
                    VATEntry."Add.-Currency Unrealized Base" := SrcCurrVATBase;
                    VATEntry."Add.-Currency Unrealized Amt." := SrcCurrVATAmount;
                end else begin
                    VATEntry."Additional-Currency Base" := SrcCurrVATBase;
                    VATEntry."Additional-Currency Amount" := SrcCurrVATAmount;
                    VATEntry."Add.-Currency Unrealized Base" := 0;
                    VATEntry."Add.-Currency Unrealized Amt." := 0;
                end;
            VATEntry."Add.-Curr. Rem. Unreal. Amount" := VATEntry."Add.-Currency Unrealized Amt.";
            VATEntry."Add.-Curr. Rem. Unreal. Base" := VATEntry."Add.-Currency Unrealized Base";
            VATEntry."VAT Difference" := VATDifferenceLCY;
            VATEntry."Add.-Curr. VAT Difference" := SrcCurrVATDifference;
            if GenJournalLine."System-Created Entry" then
                VATEntry."Base Before Pmt. Disc." := GenJournalLine."VAT Base Before Pmt. Disc."
            else
                VATEntry."Base Before Pmt. Disc." := GLEntryAmount;

            OnBeforeInsertVATEntry(VATEntry, GenJournalLine);
            VATEntry.Insert(true);
            GLEntryVATEntryLink.InsertLink(TempGLEntryBuf."Entry No.", VATEntry."Entry No.");
            NextVATEntryNo := NextVATEntryNo + 1;
            OnAfterInsertVATEntry(GenJournalLine, VATEntry, TempGLEntryBuf."Entry No.", NextVATEntryNo);
        end;

        // VAT for G/L entry/entries
        if (GLEntryVATAmount <> 0) or
           ((SrcCurrGLEntryVATAmt <> 0) and (SrcCurrCode = AddCurrencyCode))
        then
            case GenJournalLine."Gen. Posting Type" of
                GenJournalLine."Gen. Posting Type"::Purchase:
                    case VATPostingSetup."VAT Calculation Type" of
                        VATPostingSetup."VAT Calculation Type"::"Normal VAT",
                      VATPostingSetup."VAT Calculation Type"::"Full VAT":
                            CreateGLEntry(GenJournalLine, VATPostingSetup.GetPurchAccount(UnrealizedVAT),
                              GLEntryVATAmount, SrcCurrGLEntryVATAmt, true);
                        VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                            begin
                                OnInsertVATOnBeforeCreateGLEntryForReverseChargeVATToPurchAcc(
                                  GenJournalLine, VATPostingSetup, UnrealizedVAT, GLEntryVATAmount, SrcCurrGLEntryVATAmt, true);
                                CreateGLEntry(
                                  GenJournalLine, VATPostingSetup.GetPurchAccount(UnrealizedVAT), GLEntryVATAmount, SrcCurrGLEntryVATAmt, true);
                                OnInsertVATOnBeforeCreateGLEntryForReverseChargeVATToRevChargeAcc(
                                  GenJournalLine, VATPostingSetup, UnrealizedVAT, GLEntryVATAmount, SrcCurrGLEntryVATAmt, true);
                                CreateGLEntry(
                                  GenJournalLine, VATPostingSetup.GetRevChargeAccount(UnrealizedVAT), -GLEntryVATAmount, -SrcCurrGLEntryVATAmt, true);
                            end;
                        VATPostingSetup."VAT Calculation Type"::"Sales Tax":
                            if GenJournalLine."Use Tax" then begin
                                InitGLEntryVAT(GenJournalLine, TaxJurisdiction.GetPurchAccount(UnrealizedVAT), '',
                                  GLEntryVATAmount, SrcCurrGLEntryVATAmt, true);
                                InitGLEntryVAT(GenJournalLine, TaxJurisdiction.GetRevChargeAccount(UnrealizedVAT), '',
                                  -GLEntryVATAmount, -SrcCurrGLEntryVATAmt, true);
                            end else
                                InitGLEntryVAT(GenJournalLine, TaxJurisdiction.GetPurchAccount(UnrealizedVAT), '',
                                  GLEntryVATAmount, SrcCurrGLEntryVATAmt, true);
                    end;
                GenJournalLine."Gen. Posting Type"::Sale:
                    case VATPostingSetup."VAT Calculation Type" of
                        VATPostingSetup."VAT Calculation Type"::"Normal VAT",
                      VATPostingSetup."VAT Calculation Type"::"Full VAT":
                            CreateGLEntry(GenJournalLine, VATPostingSetup.GetSalesAccount(UnrealizedVAT),
                              GLEntryVATAmount, SrcCurrGLEntryVATAmt, true);
                        VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                            ;
                        VATPostingSetup."VAT Calculation Type"::"Sales Tax":
                            InitGLEntryVAT(GenJournalLine, TaxJurisdiction.GetSalesAccount(UnrealizedVAT), '',
                              GLEntryVATAmount, SrcCurrGLEntryVATAmt, true);
                    end;
            end;

        OnAfterInsertVAT(
          GenJournalLine, VATEntry, UnrealizedVAT, AddCurrencyCode, VATPostingSetup, GLEntryAmount, GLEntryVATAmount, GLEntryBaseAmount,
          SrcCurrCode, SrcCurrGLEntryAmt, SrcCurrGLEntryVATAmt, SrcCurrGLEntryBaseAmt, AddCurrGLEntryVATAmt,
          NextConnectionNo, NextVATEntryNo, NextTransactionNo, TempGLEntryBuf."Entry No.");
    end;

    local procedure SummarizeVAT(SummarizeGLEntries: Boolean; GLEntry: Record "G/L Entry")
    var
        InsertedTempVAT: Boolean;
    begin
        InsertedTempVAT := false;
        if SummarizeGLEntries then
            if TempGLEntryVAT.FindSet() then
                repeat
                    if (TempGLEntryVAT."G/L Account No." = GLEntry."G/L Account No.") and
                       (TempGLEntryVAT."Bal. Account No." = GLEntry."Bal. Account No.")
                    then begin
                        TempGLEntryVAT.Amount := TempGLEntryVAT.Amount + GLEntry.Amount;
                        TempGLEntryVAT."Additional-Currency Amount" :=
                          TempGLEntryVAT."Additional-Currency Amount" + GLEntry."Additional-Currency Amount";
                        TempGLEntryVAT.Modify();
                        InsertedTempVAT := true;
                    end;
                until (TempGLEntryVAT.Next() = 0) or InsertedTempVAT;
        if not InsertedTempVAT or not SummarizeGLEntries then begin
            TempGLEntryVAT := GLEntry;
            TempGLEntryVAT."Entry No." :=
              TempGLEntryVAT."Entry No." + InsertedTempGLEntryVAT;
            TempGLEntryVAT.Insert();
            InsertedTempGLEntryVAT := InsertedTempGLEntryVAT + 1;
        end;
    end;

    local procedure InsertSummarizedVAT(GenJournalLine: Record "Gen. Journal Line")
    begin
        if TempGLEntryVAT.FindSet() then begin
            repeat
                InsertGLEntry(GenJournalLine, TempGLEntryVAT, true);
            until TempGLEntryVAT.Next() = 0;
            TempGLEntryVAT.DeleteAll();
            InsertedTempGLEntryVAT := 0;
        end;
        NextConnectionNo := NextConnectionNo + 1;
    end;

    local procedure PostGLAcc(GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean)
    var
        GLAccount: Record "G/L Account";
        GLEntry: Record "G/L Entry";
        VATPostingSetup: Record "VAT Posting Setup";
        IsHandled: Boolean;
    begin
        OnBeforePostGLAcc(GenJournalLine, GLEntry);

        GLAccount.Get(GenJournalLine."Account No.");
        RealizeDelayedUnrealizedVAT(GenJournalLine);

        // G/L entry
        InitGLEntry(GenJournalLine, GLEntry,
          GenJournalLine."Account No.", GenJournalLine."Amount (LCY)",
          GenJournalLine."Source Currency Amount", true, GenJournalLine."System-Created Entry");
        if not GenJournalLine."System-Created Entry" then
            if GenJournalLine."Posting Date" = NormalDate(GenJournalLine."Posting Date") then
                GLAccount.TestField("Direct Posting", true);
        if GLAccount."Omit Default Descr. in Jnl." then
            if DelChr(GenJournalLine.Description, '=', ' ') = '' then
                Error(
                  DescriptionMustNotBeBlankErr,
                  GLAccount.FieldCaption("Omit Default Descr. in Jnl."),
                  GLAccount."No.",
                  GenJournalLine.FieldCaption(Description));
        GLEntry."Gen. Posting Type" := GenJournalLine."Gen. Posting Type";
        GLEntry."Bal. Account Type" := GenJournalLine."Bal. Account Type";
        GLEntry."Bal. Account No." := GenJournalLine."Bal. Account No.";
        GLEntry."No. Series" := GenJournalLine."Posting No. Series";
        if GenJournalLine."Additional-Currency Posting" =
           GenJournalLine."Additional-Currency Posting"::"Additional-Currency Amount Only"
        then begin
            GLEntry."Additional-Currency Amount" := GenJournalLine.Amount;
            GLEntry.Amount := 0;
        end;
        // Store Entry No. to global variable for return:
        GLEntryNo := GLEntry."Entry No.";
        InitVAT(GenJournalLine, GLEntry, VATPostingSetup);
        IsHandled := false;
        OnPostGLAccOnBeforeInsertGLEntry(GenJournalLine, GLEntry, IsHandled);
        if not IsHandled then
            InsertGLEntry(GenJournalLine, GLEntry, true);
        if EntryType = GLEntry."CIR Entry Type"::Definitive then begin
            PostJob(GenJournalLine, GLEntry);
            PostVAT(GenJournalLine, GLEntry, VATPostingSetup);
        end;
        DeferralPosting(GenJournalLine."Deferral Code", GenJournalLine."Source Code", GenJournalLine."Account No.", GenJournalLine, Balancing);

        OnMoveGenJournalLine(GenJournalLine, GLEntry.RecordId());
        OnAfterPostGLAcc(GenJournalLine, TempGLEntryBuf, NextEntryNo, NextTransactionNo, Balancing);
    end;

    local procedure PostCust(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean)
    var
        LineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist.";
        Customer: Record Customer;
        CustomerPostingGroup: Record "Customer Posting Group";
        lCustLedgerEntry: Record "Cust. Ledger Entry";
        CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer";
        TempDetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer" temporary;
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        ReceivablesAccount: Code[20];
        DtldLedgEntryInserted: Boolean;
    begin
        SalesReceivablesSetup.Get();
        Customer.Get(GenJournalLine."Account No.");
        Customer.CheckBlockedCustOnJnls(Customer, GenJournalLine."Document Type", true);

        if GenJournalLine."Posting Group" = '' then begin
            Customer.TestField("Customer Posting Group");
            GenJournalLine."Posting Group" := Customer."Customer Posting Group";
        end;
        CustomerPostingGroup.Get(GenJournalLine."Posting Group");
        ReceivablesAccount := CustomerPostingGroup.GetReceivablesAccount();

        DetailedCustLedgEntry.LockTable();
        lCustLedgerEntry.LockTable();

        InitCustLedgEntry(GenJournalLine, lCustLedgerEntry);

        if not Customer."Block Payment Tolerance" then
            CalcPmtTolerancePossible(
              GenJournalLine, lCustLedgerEntry."Pmt. Discount Date", lCustLedgerEntry."Pmt. Disc. Tolerance Date",
              lCustLedgerEntry."Max. Payment Tolerance");

        TempDetailedCVLedgEntryBuffer.DeleteAll();
        TempDetailedCVLedgEntryBuffer.Init();
        TempDetailedCVLedgEntryBuffer.CopyFromGenJnlLine(GenJournalLine);
        TempDetailedCVLedgEntryBuffer."CV Ledger Entry No." := lCustLedgerEntry."Entry No.";
        CVLedgerEntryBuffer.CopyFromCustLedgEntry(lCustLedgerEntry);
        TempDetailedCVLedgEntryBuffer.InsertDtldCVLedgEntry(TempDetailedCVLedgEntryBuffer, CVLedgerEntryBuffer, true);
        CVLedgerEntryBuffer.Open := CVLedgerEntryBuffer."Remaining Amount" <> 0;
        CVLedgerEntryBuffer.Positive := CVLedgerEntryBuffer."Remaining Amount" > 0;
        OnPostCustOnAfterCopyCVLedgEntryBuf(CVLedgerEntryBuffer, GenJournalLine);

        CalcPmtDiscPossible(GenJournalLine, CVLedgerEntryBuffer);

        if GenJournalLine."Currency Code" <> '' then begin
            GenJournalLine.TestField("Currency Factor");
            CVLedgerEntryBuffer."Original Currency Factor" := GenJournalLine."Currency Factor"
        end else
            CVLedgerEntryBuffer."Original Currency Factor" := 1;
        CVLedgerEntryBuffer."Adjusted Currency Factor" := CVLedgerEntryBuffer."Original Currency Factor";

        // Check the document no.
        if GenJournalLine."Recurring Method" = "Gen. Journal Recurring Method"::" " then
            if IsNotPayment(GenJournalLine."Document Type") then begin
                GenJnlCheckLine.CheckSalesDocNoIsNotUsed(GenJournalLine);
                CheckSalesExtDocNo(GenJournalLine);
            end;

        // Post application
        ApplyCustLedgEntry(CVLedgerEntryBuffer, TempDetailedCVLedgEntryBuffer, GenJournalLine, Customer);

        // Post customer entry
        lCustLedgerEntry.CopyFromCVLedgEntryBuffer(CVLedgerEntryBuffer);
        lCustLedgerEntry."Amount to Apply" := 0;
        lCustLedgerEntry."Applies-to Doc. No." := '';
        if SalesReceivablesSetup."Copy Customer Name to Entries" then
            lCustLedgerEntry."Customer Name" := Customer.Name;
        OnBeforeCustLedgEntryInsert(lCustLedgerEntry, GenJournalLine);
        lCustLedgerEntry.Insert(true);

        // Post detailed customer entries
        DtldLedgEntryInserted := PostDtldCustLedgEntries(GenJournalLine, TempDetailedCVLedgEntryBuffer, CustomerPostingGroup, true);

        OnAfterCustLedgEntryInsert(lCustLedgerEntry, GenJournalLine);

        // Post Reminder Terms - Note About Line Fee on Report
        LineFeeNoteOnReportHist.Save(lCustLedgerEntry);

        if DtldLedgEntryInserted then
            if IsTempGLEntryBufEmpty() then
                DetailedCustLedgEntry.SetZeroTransNo(NextTransactionNo);

        DeferralPosting(GenJournalLine."Deferral Code", GenJournalLine."Source Code", ReceivablesAccount, GenJournalLine, Balancing);

        OnMoveGenJournalLine(GenJournalLine, lCustLedgerEntry.RecordId());
        OnAfterPostCust(GenJournalLine, Balancing, TempGLEntryBuf, NextEntryNo, NextTransactionNo);
    end;

    local procedure PostVend(GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean)
    var
        Vendor: Record Vendor;
        VendorPostingGroup: Record "Vendor Posting Group";
        lVendorLedgerEntry: Record "Vendor Ledger Entry";
        CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer";
        TempDetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer" temporary;
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        PayablesAccount: Code[20];
        DtldLedgEntryInserted: Boolean;
        CheckExtDocNoHandled: Boolean;
    begin
        PurchasesPayablesSetup.Get();
        Vendor.Get(GenJournalLine."Account No.");
        Vendor.CheckBlockedVendOnJnls(Vendor, GenJournalLine."Document Type", true);

        if GenJournalLine."Posting Group" = '' then begin
            Vendor.TestField("Vendor Posting Group");
            GenJournalLine."Posting Group" := Vendor."Vendor Posting Group";
        end;
        VendorPostingGroup.Get(GenJournalLine."Posting Group");
        PayablesAccount := VendorPostingGroup.GetPayablesAccount();

        DetailedVendorLedgEntry.LockTable();
        lVendorLedgerEntry.LockTable();

        InitVendLedgEntry(GenJournalLine, lVendorLedgerEntry);

        if not Vendor."Block Payment Tolerance" then
            CalcPmtTolerancePossible(
              GenJournalLine, lVendorLedgerEntry."Pmt. Discount Date", lVendorLedgerEntry."Pmt. Disc. Tolerance Date",
              lVendorLedgerEntry."Max. Payment Tolerance");

        TempDetailedCVLedgEntryBuffer.DeleteAll();
        TempDetailedCVLedgEntryBuffer.Init();
        TempDetailedCVLedgEntryBuffer.CopyFromGenJnlLine(GenJournalLine);
        TempDetailedCVLedgEntryBuffer."CV Ledger Entry No." := lVendorLedgerEntry."Entry No.";
        CVLedgerEntryBuffer.CopyFromVendLedgEntry(lVendorLedgerEntry);
        TempDetailedCVLedgEntryBuffer.InsertDtldCVLedgEntry(TempDetailedCVLedgEntryBuffer, CVLedgerEntryBuffer, true);
        CVLedgerEntryBuffer.Open := CVLedgerEntryBuffer."Remaining Amount" <> 0;
        CVLedgerEntryBuffer.Positive := CVLedgerEntryBuffer."Remaining Amount" > 0;
        OnPostVendOnAfterCopyCVLedgEntryBuf(CVLedgerEntryBuffer, GenJournalLine);

        CalcPmtDiscPossible(GenJournalLine, CVLedgerEntryBuffer);

        if GenJournalLine."Currency Code" <> '' then begin
            GenJournalLine.TestField("Currency Factor");
            CVLedgerEntryBuffer."Adjusted Currency Factor" := GenJournalLine."Currency Factor"
        end else
            CVLedgerEntryBuffer."Adjusted Currency Factor" := 1;
        CVLedgerEntryBuffer."Original Currency Factor" := CVLedgerEntryBuffer."Adjusted Currency Factor";

        // Check the document no.
        if GenJournalLine."Recurring Method" = "Gen. Journal Recurring Method"::" " then
            if IsNotPayment(GenJournalLine."Document Type") then begin
                GenJnlCheckLine.CheckPurchDocNoIsNotUsed(GenJournalLine);
                OnBeforeCheckPurchExtDocNo(GenJournalLine, lVendorLedgerEntry, CVLedgerEntryBuffer, CheckExtDocNoHandled);
                if not CheckExtDocNoHandled then
                    CheckPurchExtDocNo(GenJournalLine);
            end;

        // Post application
        ApplyVendLedgEntry(CVLedgerEntryBuffer, TempDetailedCVLedgEntryBuffer, GenJournalLine, Vendor);

        // Post vendor entry
        lVendorLedgerEntry.CopyFromCVLedgEntryBuffer(CVLedgerEntryBuffer);
        lVendorLedgerEntry."Amount to Apply" := 0;
        lVendorLedgerEntry."Applies-to Doc. No." := '';
        if PurchasesPayablesSetup."Copy Vendor Name to Entries" then
            lVendorLedgerEntry."Vendor Name" := Vendor.Name;
        OnBeforeVendLedgEntryInsert(lVendorLedgerEntry, GenJournalLine);
        lVendorLedgerEntry.Insert(true);

        // Post detailed vendor entries
        DtldLedgEntryInserted := PostDtldVendLedgEntries(GenJournalLine, TempDetailedCVLedgEntryBuffer, VendorPostingGroup, true);

        OnAfterVendLedgEntryInsert(lVendorLedgerEntry, GenJournalLine);

        if DtldLedgEntryInserted then
            if IsTempGLEntryBufEmpty() then
                DetailedVendorLedgEntry.SetZeroTransNo(NextTransactionNo);
        DeferralPosting(GenJournalLine."Deferral Code", GenJournalLine."Source Code", PayablesAccount, GenJournalLine, Balancing);

        OnMoveGenJournalLine(GenJournalLine, lVendorLedgerEntry.RecordId());
        OnAfterPostVend(GenJournalLine, Balancing, TempGLEntryBuf, NextEntryNo, NextTransactionNo);
    end;

    local procedure PostEmployee(GenJournalLine: Record "Gen. Journal Line")
    var
        Employee: Record Employee;
        EmployeePostingGroup: Record "Employee Posting Group";
        EmployeeLedgerEntry: Record "Employee Ledger Entry";
        CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer";
        TempDetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer" temporary;
        DetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry";
        DtldLedgEntryInserted: Boolean;
    begin
        Employee.Get(GenJournalLine."Account No.");
        Employee.CheckBlockedEmployeeOnJnls(true);

        if GenJournalLine."Posting Group" = '' then begin
            Employee.TestField("Employee Posting Group");
            GenJournalLine."Posting Group" := Employee."Employee Posting Group";
        end;
        EmployeePostingGroup.Get(GenJournalLine."Posting Group");

        DetailedEmployeeLedgerEntry.LockTable();
        EmployeeLedgerEntry.LockTable();

        InitEmployeeLedgerEntry(GenJournalLine, EmployeeLedgerEntry);

        TempDetailedCVLedgEntryBuffer.DeleteAll();
        TempDetailedCVLedgEntryBuffer.Init();
        TempDetailedCVLedgEntryBuffer.CopyFromGenJnlLine(GenJournalLine);
        TempDetailedCVLedgEntryBuffer."CV Ledger Entry No." := EmployeeLedgerEntry."Entry No.";
        CVLedgerEntryBuffer.CopyFromEmplLedgEntry(EmployeeLedgerEntry);
        TempDetailedCVLedgEntryBuffer.InsertDtldCVLedgEntry(TempDetailedCVLedgEntryBuffer, CVLedgerEntryBuffer, true);
        CVLedgerEntryBuffer.Open := CVLedgerEntryBuffer."Remaining Amount" <> 0;
        CVLedgerEntryBuffer.Positive := CVLedgerEntryBuffer."Remaining Amount" > 0;

        // Post application
        ApplyEmplLedgEntry(CVLedgerEntryBuffer, TempDetailedCVLedgEntryBuffer, GenJournalLine, Employee);

        // Post vendor entry
        EmployeeLedgerEntry.CopyFromCVLedgEntryBuffer(CVLedgerEntryBuffer);
        EmployeeLedgerEntry."Amount to Apply" := 0;
        EmployeeLedgerEntry."Applies-to Doc. No." := '';
        EmployeeLedgerEntry.Insert(true);

        // Post detailed employee entries
        DtldLedgEntryInserted := PostDtldEmplLedgEntries(GenJournalLine, TempDetailedCVLedgEntryBuffer, EmployeePostingGroup, true);

        // Posting GL Entry
        if DtldLedgEntryInserted then
            if IsTempGLEntryBufEmpty() then
                DetailedEmployeeLedgerEntry.SetZeroTransNo(NextTransactionNo);
        OnMoveGenJournalLine(GenJournalLine, EmployeeLedgerEntry.RecordId());
    end;

    local procedure PostBankAcc(GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean)
    var
        BankAccount: Record "Bank Account";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        CheckLedgerEntry: Record "Check Ledger Entry";
        CheckLedgerEntry2: Record "Check Ledger Entry";
        BankAccountPostingGroup: Record "Bank Account Posting Group";
    begin
        BankAccount.Get(GenJournalLine."Account No.");
        BankAccount.TestField(Blocked, false);
        RealizeDelayedUnrealizedVAT(GenJournalLine);
        if GenJournalLine."Currency Code" = '' then
            BankAccount.TestField("Currency Code", '')
        else
            if BankAccount."Currency Code" <> '' then
                GenJournalLine.TestField("Currency Code", BankAccount."Currency Code");

        BankAccount.TestField("Bank Acc. Posting Group");
        BankAccountPostingGroup.Get(BankAccount."Bank Acc. Posting Group");

        BankAccountLedgerEntry.LockTable();

        OnPostBankAccOnBeforeInitBankAccLedgEntry(GenJournalLine, CurrencyFactor, NextEntryNo, NextTransactionNo);

        InitBankAccLedgEntry(GenJournalLine, BankAccountLedgerEntry);

        BankAccountLedgerEntry."Bank Acc. Posting Group" := BankAccount."Bank Acc. Posting Group";
        BankAccountLedgerEntry."Currency Code" := BankAccount."Currency Code";
        if BankAccount."Currency Code" <> '' then
            BankAccountLedgerEntry.Amount := GenJournalLine.Amount
        else
            BankAccountLedgerEntry.Amount := GenJournalLine."Amount (LCY)";
        BankAccountLedgerEntry."Amount (LCY)" := GenJournalLine."Amount (LCY)";
        BankAccountLedgerEntry.Open := GenJournalLine.Amount <> 0;
        BankAccountLedgerEntry."Remaining Amount" := BankAccountLedgerEntry.Amount;
        BankAccountLedgerEntry.Positive := GenJournalLine.Amount > 0;
        BankAccountLedgerEntry.UpdateDebitCredit(GenJournalLine.Correction);
        OnPostBankAccOnBeforeBankAccLedgEntryInsert(BankAccountLedgerEntry, GenJournalLine, BankAccount);
        BankAccountLedgerEntry.Insert(true);
        OnPostBankAccOnAfterBankAccLedgEntryInsert(BankAccountLedgerEntry, GenJournalLine, BankAccount);

        if ((GenJournalLine.Amount <= 0) and (GenJournalLine."Bank Payment Type" = GenJournalLine."Bank Payment Type"::"Computer Check") and GenJournalLine."Check Printed") or
           ((GenJournalLine.Amount < 0) and (GenJournalLine."Bank Payment Type" = GenJournalLine."Bank Payment Type"::"Manual Check"))
        then begin
            if BankAccount."Currency Code" <> GenJournalLine."Currency Code" then
                Error(BankPaymentTypeMustNotBeFilledErr);
            case GenJournalLine."Bank Payment Type" of
                GenJournalLine."Bank Payment Type"::"Computer Check":
                    begin
                        GenJournalLine.TestField("Check Printed", true);
                        CheckLedgerEntry.LockTable();
                        CheckLedgerEntry.Reset();
                        CheckLedgerEntry.SetCurrentKey("Bank Account No.", "Entry Status", "Check No.");
                        CheckLedgerEntry.SetRange("Bank Account No.", GenJournalLine."Account No.");
                        CheckLedgerEntry.SetRange("Entry Status", CheckLedgerEntry."Entry Status"::Printed);
                        CheckLedgerEntry.SetRange("Check No.", GenJournalLine."Document No.");
                        if CheckLedgerEntry.FindSet() then
                            repeat
                                CheckLedgerEntry2 := CheckLedgerEntry;
                                CheckLedgerEntry2."Entry Status" := CheckLedgerEntry2."Entry Status"::Posted;
                                CheckLedgerEntry2."Bank Account Ledger Entry No." := BankAccountLedgerEntry."Entry No.";
                                CheckLedgerEntry2.Modify();
                            until CheckLedgerEntry.Next() = 0;
                    end;
                GenJournalLine."Bank Payment Type"::"Manual Check":
                    begin
                        if GenJournalLine."Document No." = '' then
                            Error(DocNoMustBeEnteredErr, GenJournalLine."Bank Payment Type");
                        CheckLedgerEntry.Reset();
                        if NextCheckEntryNo = 0 then begin
                            CheckLedgerEntry.LockTable();
                            if CheckLedgerEntry.FindLast() then
                                NextCheckEntryNo := CheckLedgerEntry."Entry No." + 1
                            else
                                NextCheckEntryNo := 1;
                        end;

                        CheckLedgerEntry.SetRange("Bank Account No.", GenJournalLine."Account No.");
                        CheckLedgerEntry.SetFilter(
                          "Entry Status", '%1|%2|%3',
                          CheckLedgerEntry."Entry Status"::Printed,
                          CheckLedgerEntry."Entry Status"::Posted,
                          CheckLedgerEntry."Entry Status"::"Financially Voided");
                        CheckLedgerEntry.SetRange("Check No.", GenJournalLine."Document No.");
                        if not CheckLedgerEntry.IsEmpty() then
                            Error(CheckAlreadyExistsErr, GenJournalLine."Document No.");

                        InitCheckLedgEntry(BankAccountLedgerEntry, CheckLedgerEntry);
                        CheckLedgerEntry."Bank Payment Type" := CheckLedgerEntry."Bank Payment Type"::"Manual Check";
                        if BankAccount."Currency Code" <> '' then
                            CheckLedgerEntry.Amount := -GenJournalLine.Amount
                        else
                            CheckLedgerEntry.Amount := -GenJournalLine."Amount (LCY)";
                        OnPostBankAccOnBeforeCheckLedgEntryInsert(CheckLedgerEntry, BankAccountLedgerEntry, GenJournalLine, BankAccount);
                        CheckLedgerEntry.Insert(true);
                        OnPostBankAccOnAfterCheckLedgEntryInsert(CheckLedgerEntry, BankAccountLedgerEntry, GenJournalLine, BankAccount);
                        NextCheckEntryNo := NextCheckEntryNo + 1;
                    end;
            end;
        end;

        BankAccountPostingGroup.TestField("G/L Account No.");
        CreateGLEntryBalAcc(
          GenJournalLine, BankAccountPostingGroup."G/L Account No.", GenJournalLine."Amount (LCY)", GenJournalLine."Source Currency Amount",
          GenJournalLine."Bal. Account Type", GenJournalLine."Bal. Account No.");
        DeferralPosting(GenJournalLine."Deferral Code", GenJournalLine."Source Code", BankAccountPostingGroup."G/L Account No.", GenJournalLine, Balancing);
        OnMoveGenJournalLine(GenJournalLine, BankAccountLedgerEntry.RecordId());
    end;

    local procedure PostFixedAsset(GenJournalLine: Record "Gen. Journal Line")
    var
        GLEntry: Record "G/L Entry";
        GLEntry2: Record "G/L Entry";
        TempFAGLPostingBuffer: Record "FA G/L Posting Buffer" temporary;
        FAGLPostingBuffer: Record "FA G/L Posting Buffer";
        VATPostingSetup: Record "VAT Posting Setup";
        FAJournalLine: Record "FA Journal Line";
        //FALedgerEntry: Record "FA Ledger Entry";
        FAAutomaticEntry: Codeunit "FA Automatic Entry";
        ShortcutDim1Code: Code[20];
        ShortcutDim2Code: Code[20];
        Correction2: Boolean;
        NetDisposalNo: Integer;
        DimensionSetID: Integer;
        //FALedgEntryNo: Integer;
        VATEntryGLEntryNo: Integer;
        IsHandled: Boolean;
    begin
        InitGLEntry(GenJournalLine, GLEntry, '', GenJournalLine."Amount (LCY)", GenJournalLine."Source Currency Amount", true, GenJournalLine."System-Created Entry");
        GLEntry."Gen. Posting Type" := GenJournalLine."Gen. Posting Type";
        GLEntry."Bal. Account Type" := GenJournalLine."Bal. Account Type";
        GLEntry."Bal. Account No." := GenJournalLine."Bal. Account No.";
        InitVAT(GenJournalLine, GLEntry, VATPostingSetup);
        GLEntry2 := GLEntry;
        CIRFAJnlPostLine.GenJnlPostLine(
          GenJournalLine, GLEntry2.Amount, GLEntry2."VAT Amount", NextTransactionNo, NextEntryNo, GLRegister."No.");
        if GenJournalLine."Derogatory Line" then begin
            MakeDerogFAJnlLine(FAJournalLine, GenJournalLine);
            if GenJournalLine."FA Error Entry No." <> 0 then
                FAJournalLine."FA Error Entry No." := GetNextMatchingFALedgEntry(FAJournalLine, GenJournalLine."FA Error Entry No.", FAJournalLine."Depreciation Book Code");
            CIRFAJnlPostLine.FAJnlPostLine(FAJournalLine, true);
            CreateAndPostDerogatoryEntry(GenJournalLine);
        end;
        ShortcutDim1Code := GenJournalLine."Shortcut Dimension 1 Code";
        ShortcutDim2Code := GenJournalLine."Shortcut Dimension 2 Code";
        DimensionSetID := GenJournalLine."Dimension Set ID";
        Correction2 := GenJournalLine.Correction;
        if CIRFAJnlPostLine.FindFirstGLAcc(TempFAGLPostingBuffer) then
            repeat
                GenJournalLine."Shortcut Dimension 1 Code" := TempFAGLPostingBuffer."Global Dimension 1 Code";
                GenJournalLine."Shortcut Dimension 2 Code" := TempFAGLPostingBuffer."Global Dimension 2 Code";
                GenJournalLine."Dimension Set ID" := TempFAGLPostingBuffer."Dimension Set ID";
                GenJournalLine.Correction := TempFAGLPostingBuffer.Correction;
                FADimAlreadyChecked := TempFAGLPostingBuffer."FA Posting Group" <> '';
                CheckDimValueForDisposal(GenJournalLine, TempFAGLPostingBuffer."Account No.");
                if TempFAGLPostingBuffer."Original General Journal Line" then
                    InitGLEntry(GenJournalLine, GLEntry, TempFAGLPostingBuffer."Account No.", TempFAGLPostingBuffer.Amount, GLEntry2."Additional-Currency Amount", true, true)
                else begin
                    CheckNonAddCurrCodeOccurred('');
                    InitGLEntry(GenJournalLine, GLEntry, TempFAGLPostingBuffer."Account No.", TempFAGLPostingBuffer.Amount, 0, false, true);
                end;
                FADimAlreadyChecked := false;
                GLEntry.CopyPostingGroupsFromGLEntry(GLEntry2);
                GLEntry."VAT Amount" := GLEntry2."VAT Amount";
                GLEntry."Bal. Account Type" := GLEntry2."Bal. Account Type";
                GLEntry."Bal. Account No." := GLEntry2."Bal. Account No.";
                GLEntry."FA Entry Type" := TempFAGLPostingBuffer."FA Entry Type";
                GLEntry."FA Entry No." := TempFAGLPostingBuffer."FA Entry No.";
                if TempFAGLPostingBuffer."Net Disposal" then
                    NetDisposalNo := NetDisposalNo + 1
                else
                    NetDisposalNo := 0;
                if TempFAGLPostingBuffer."Automatic Entry" and not TempFAGLPostingBuffer."Net Disposal" then
                    FAAutomaticEntry.AdjustGLEntry(GLEntry);
                if NetDisposalNo > 1 then
                    GLEntry."VAT Amount" := 0;
                if TempFAGLPostingBuffer."FA Posting Group" <> '' then begin
                    FAGLPostingBuffer := TempFAGLPostingBuffer;
                    FAGLPostingBuffer."Entry No." := NextEntryNo;
                    FAGLPostingBuffer.Insert();
                end;
                IsHandled := false;
                OnPostFixedAssetOnBeforeInsertGLEntry(GenJournalLine, GLEntry, IsHandled, TempFAGLPostingBuffer);
                if not IsHandled then
                    InsertGLEntry(GenJournalLine, GLEntry, true);
#pragma warning disable AA0205
                if (VATEntryGLEntryNo = 0) and (GLEntry."Gen. Posting Type" <> GLEntry."Gen. Posting Type"::" ") then
#pragma warning restore AA0205
                    VATEntryGLEntryNo := GLEntry."Entry No.";
            until CIRFAJnlPostLine.GetNextGLAcc(TempFAGLPostingBuffer) = 0;
        GenJournalLine."Shortcut Dimension 1 Code" := ShortcutDim1Code;
        GenJournalLine."Shortcut Dimension 2 Code" := ShortcutDim2Code;
        GenJournalLine."Dimension Set ID" := DimensionSetID;
        GenJournalLine.Correction := Correction2;
        GLEntry := GLEntry2;
        if VATEntryGLEntryNo = 0 then
            VATEntryGLEntryNo := GLEntry."Entry No.";
        TempGLEntryBuf."Entry No." := VATEntryGLEntryNo; // Used later in InsertVAT(): GLEntryVATEntryLink.InsertLink(TempGLEntryBuf."Entry No.",VATEntry."Entry No.")
        PostVAT(GenJournalLine, GLEntry, VATPostingSetup);

        CIRFAJnlPostLine.UpdateRegNo(GLRegister."No.");
        OnMoveGenJournalLine(GenJournalLine, GLEntry.RecordId());
    end;

    local procedure PostICPartner(GenJournalLine: Record "Gen. Journal Line")
    var
        ICPartner: Record "IC Partner";
        AccountNo: Code[20];
    begin
        if GenJournalLine."Account No." <> ICPartner.Code then
            ICPartner.Get(GenJournalLine."Account No.");
        if (GenJournalLine."Document Type" = GenJournalLine."Document Type"::"Credit Memo") xor (GenJournalLine.Amount > 0) then begin
            ICPartner.TestField("Receivables Account");
            AccountNo := ICPartner."Receivables Account";
        end else begin
            ICPartner.TestField("Payables Account");
            AccountNo := ICPartner."Payables Account";
        end;

        CreateGLEntryBalAcc(
          GenJournalLine, AccountNo, GenJournalLine."Amount (LCY)", GenJournalLine."Source Currency Amount",
          GenJournalLine."Bal. Account Type", GenJournalLine."Bal. Account No.");
    end;

    local procedure PostJob(GenJournalLine: Record "Gen. Journal Line"; GLEntry: Record "G/L Entry")
    var
        JobPostLine: Codeunit "Job Post-Line";
    begin
        if JobLine then begin
            JobLine := false;
            JobPostLine.PostGenJnlLine(GenJournalLine, GLEntry);
        end;
    end;

    procedure StartPosting(GenJournalLine: Record "Gen. Journal Line")
    var
        GenJournalTemplate: Record "Gen. Journal Template";
        AccountingPeriodMgt: Codeunit "Accounting Period Mgt.";
    begin
        OnBeforeStartPosting(GenJournalLine);

        InitNextEntryNo();
        FirstTransactionNo := NextTransactionNo;

        InitLastDocDate(GenJournalLine);
        CurrentBalance := 0;

        FiscalYearStartDate := AccountingPeriodMgt.GetPeriodStartingDate();

        GetGLSetup();

        if not GenJournalTemplate.Get(GenJournalLine."Journal Template Name") then
            GenJournalTemplate.Init();

        VATEntry.LockTable();
        if VATEntry.FindLast() then
            NextVATEntryNo := VATEntry."Entry No." + 1
        else
            NextVATEntryNo := 1;
        NextConnectionNo := 1;
        FirstNewVATEntryNo := NextVATEntryNo;

        GLRegister.LockTable();
        if EntryType = GlobalGLEntry."CIR Entry Type"::Definitive then begin
            if GLRegister.FindLast() then
                GLRegister."No." := GLRegister."No." + 1
            else
                GLRegister."No." := 1;
        end else
            if GLRegister.FindFirst() then begin
                GLRegister."No." := GLRegister."No." - 1;
                if GLRegister."No." = 0 then
                    GLRegister."No." := -1;
            end else
                GLRegister."No." := -1;
        GLRegister.Init();
        GLRegister."From Entry No." := NextEntryNo;
        if EntryType = GlobalGLEntry."CIR Entry Type"::Definitive then
            GLRegister."From VAT Entry No." := NextVATEntryNo;
        GLRegister."Creation Date" := Today();
        GLRegister."Creation Time" := Time();
        GLRegister."Source Code" := GenJournalLine."Source Code";
        GLRegister."Journal Batch Name" := GenJournalLine."Journal Batch Name";
        GLRegister."User ID" := CopyStr(UserId(), 1, MaxStrLen(GLRegister."User ID"));
        IsGLRegInserted := false;

        OnAfterInitGLRegister(GLRegister, GenJournalLine);

        GetCurrencyExchRate(GenJournalLine);
        TempGLEntryBuf.DeleteAll();
        CalculateCurrentBalance(
          GenJournalLine."Account No.", GenJournalLine."Bal. Account No.", GenJournalLine.IncludeVATAmount(), GenJournalLine."Amount (LCY)", GenJournalLine."VAT Amount");
    end;

    procedure ContinuePosting(GenJournalLine: Record "Gen. Journal Line")
    begin
        OnBeforeContinuePosting(GenJournalLine, GLRegister, NextEntryNo, NextTransactionNo);

        if NextTransactionNoNeeded(GenJournalLine) then begin
            CheckPostUnrealizedVAT(GenJournalLine, false);
            if EntryType = GlobalGLEntry."CIR Entry Type"::Definitive then
                NextTransactionNo := NextTransactionNo + 1
            else
                NextTransactionNo := NextTransactionNo - 1;
            InitLastDocDate(GenJournalLine);
            FirstNewVATEntryNo := NextVATEntryNo;
        end;

        OnContinuePostingOnBeforeCalculateCurrentBalance(GenJournalLine, NextTransactionNo);

        GetCurrencyExchRate(GenJournalLine);
        TempGLEntryBuf.DeleteAll();
        CalculateCurrentBalance(
          GenJournalLine."Account No.", GenJournalLine."Bal. Account No.", GenJournalLine.IncludeVATAmount(),
          GenJournalLine."Amount (LCY)", GenJournalLine."VAT Amount");
    end;

    local procedure NextTransactionNoNeeded(GenJournalLine: Record "Gen. Journal Line"): Boolean
    var
        LastDocTypeOption: Option;
        NewTransaction: Boolean;
    begin
        NewTransaction :=
            (LastDocType <> GenJournalLine."Document Type") or (LastDocNo <> GenJournalLine."Document No.") or
            (LastDate <> GenJournalLine."Posting Date") or ((CurrentBalance = 0) and (TotalAddCurrAmount = 0)) and not GenJournalLine."System-Created Entry";
        LastDocTypeOption := LastDocType.AsInteger();
        OnNextTransactionNoNeeded(GenJournalLine, LastDocTypeOption, LastDocNo, LastDate, CurrentBalance, TotalAddCurrAmount, NewTransaction);
        LastDocType := "Gen. Journal Document Type".FromInteger(LastDocTypeOption);
        exit(NewTransaction);
    end;

    procedure FinishPosting(GenJournalLine: Record "Gen. Journal Line") IsTransactionConsistent: Boolean
    var
        CostAccountingSetup: Record "Cost Accounting Setup";
        TransferGlEntriesToCA: Codeunit "Transfer GL Entries to CA";
    begin
        OnBeforeFinishPosting(GenJournalLine);

        IsTransactionConsistent :=
          (BalanceCheckAmount = 0) and (BalanceCheckAmount2 = 0) and
          (BalanceCheckAddCurrAmount = 0) and (BalanceCheckAddCurrAmount2 = 0);

        OnAfterSettingIsTransactionConsistent(GenJournalLine, IsTransactionConsistent);

        //
        if SourceCode."CIR Situation" then begin
            if TempGLEntryBuf.FindLast() then begin
                repeat
                    GlobalGLEntry := TempGLEntryBuf;
                    if AddCurrencyCode = '' then begin
                        GlobalGLEntry."Additional-Currency Amount" := 0;
                        GlobalGLEntry."Add.-Currency Debit Amount" := 0;
                        GlobalGLEntry."Add.-Currency Credit Amount" := 0;
                    end;
                    GlobalGLEntry."Prior-Year Entry" := GlobalGLEntry."Posting Date" < FiscalYearStartDate;
                    OnBeforeInsertGlobalGLEntry(GlobalGLEntry, GenJournalLine);
                    GlobalGLEntry.Insert(true);
                    OnAfterInsertGlobalGLEntry(GlobalGLEntry, TempGLEntryBuf, NextEntryNo);
                until TempGLEntryBuf.Next(-1) = 0;

                if EntryType = GlobalGLEntry."CIR Entry Type"::Definitive then
                    GLRegister."To VAT Entry No." := NextVATEntryNo - 1;
                GLRegister."To Entry No." := GlobalGLEntry."Entry No.";
                if IsTransactionConsistent then
                    if IsGLRegInserted then
                        GLRegister.Modify()
                    else begin
                        GLRegister.Insert();
                        IsGLRegInserted := true;
                    end;
            end;
            GlobalGLEntry.Consistent(IsTransactionConsistent);
        end else begin
            if TempGLEntryBuf.FindSet() then begin
                repeat
                    GlobalGLEntry := TempGLEntryBuf;
                    if AddCurrencyCode = '' then begin
                        GlobalGLEntry."Additional-Currency Amount" := 0;
                        GlobalGLEntry."Add.-Currency Debit Amount" := 0;
                        GlobalGLEntry."Add.-Currency Credit Amount" := 0;
                    end;
                    GlobalGLEntry."Prior-Year Entry" := GlobalGLEntry."Posting Date" < FiscalYearStartDate;
                    OnBeforeInsertGlobalGLEntry(GlobalGLEntry, GenJournalLine);
                    GlobalGLEntry.Insert(true);
                    OnAfterInsertGlobalGLEntry(GlobalGLEntry, TempGLEntryBuf, NextEntryNo);
                until TempGLEntryBuf.Next() = 0;

                if EntryType = GlobalGLEntry."CIR Entry Type"::Definitive then
                    GLRegister."To VAT Entry No." := NextVATEntryNo - 1;
                GLRegister."To Entry No." := GlobalGLEntry."Entry No.";
                if IsTransactionConsistent then
                    if IsGLRegInserted then
                        GLRegister.Modify()
                    else begin
                        GLRegister.Insert();
                        IsGLRegInserted := true;
                    end;
            end;
            GlobalGLEntry.Consistent(IsTransactionConsistent);
        end;

        if CostAccountingSetup.Get() then
            if CostAccountingSetup."Auto Transfer from G/L" then
                TransferGlEntriesToCA.GetGLEntries();

        FirstEntryNo := 0;

        OnAfterFinishPosting(GlobalGLEntry, GLRegister, IsTransactionConsistent, GenJournalLine);
    end;

    local procedure PostUnrealizedVAT(GenJournalLine: Record "Gen. Journal Line")
    begin
        if CheckUnrealizedCust then begin
            CustUnrealizedVAT(GenJournalLine, CustLedgerEntry, UnrealizedRemainingAmountCust);
            CheckUnrealizedCust := false;
        end;
        if CheckUnrealizedVend then begin
            VendUnrealizedVAT(GenJournalLine, VendorLedgerEntry, UnrealizedRemainingAmountVend);
            CheckUnrealizedVend := false;
        end;
    end;

    local procedure CheckPostUnrealizedVAT(GenJournalLine: Record "Gen. Journal Line"; CheckCurrentBalance: Boolean)
    begin
        if CheckCurrentBalance and (CurrentBalance = 0) or not CheckCurrentBalance then
            PostUnrealizedVAT(GenJournalLine)
    end;

    procedure InitGLEntry(GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; GLAccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; UseAmountAddCurr: Boolean; SystemCreatedEntry: Boolean)
    var
        GLAccount: Record "G/L Account";
    begin
        OnBeforeInitGLEntry(GenJournalLine);

        if GLAccNo <> '' then begin
            GLAccount.Get(GLAccNo);
            GLAccount.TestField(Blocked, false);
            GLAccount.TestField("Account Type", GLAccount."Account Type"::Posting);

            // Check the Value Posting field on the G/L Account if it is not checked already in Codeunit 11
            if (not
                ((GLAccNo = GenJournalLine."Account No.") and
                 (GenJournalLine."Account Type" = GenJournalLine."Account Type"::"G/L Account")) or
                ((GLAccNo = GenJournalLine."Bal. Account No.") and
                 (GenJournalLine."Bal. Account Type" = GenJournalLine."Bal. Account Type"::"G/L Account"))) and
               not FADimAlreadyChecked
            then
                CheckGLAccDimError(GenJournalLine, GLAccNo);
        end;

        GLEntry.Init();
        GLEntry."CIR Entry Type" := EntryType;
        GLEntry.CopyFromGenJnlLine(GenJournalLine);
        GLEntry."Entry No." := NextEntryNo;
        GLEntry."Transaction No." := NextTransactionNo;
        GLEntry."G/L Account No." := GLAccNo;
        GLEntry."System-Created Entry" := SystemCreatedEntry;
        GLEntry.Amount := Amount;
        GLEntry."Additional-Currency Amount" :=
          GLCalcAddCurrency(Amount, AmountAddCurr, GLEntry."Additional-Currency Amount", UseAmountAddCurr, GenJournalLine);

        OnAfterInitGLEntry(GLEntry, GenJournalLine);
    end;

    local procedure InitGLEntryVAT(GenJournalLine: Record "Gen. Journal Line"; AccNo: Code[20]; BalAccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; UseAmtAddCurr: Boolean)
    var
        GLEntry: Record "G/L Entry";
    begin
        OnBeforeInitGLEntryVAT(GenJournalLine, GLEntry);
        if UseAmtAddCurr then
            InitGLEntry(GenJournalLine, GLEntry, AccNo, Amount, AmountAddCurr, true, true)
        else begin
            InitGLEntry(GenJournalLine, GLEntry, AccNo, Amount, 0, false, true);
            GLEntry."Additional-Currency Amount" := AmountAddCurr;
            GLEntry."Bal. Account No." := BalAccNo;
        end;
        SummarizeVAT(GeneralLedgerSetup."Summarize G/L Entries", GLEntry);
        OnAfterInitGLEntryVAT(GenJournalLine, GLEntry);
    end;

    local procedure InitGLEntryVATCopy(GenJournalLine: Record "Gen. Journal Line"; AccNo: Code[20]; BalAccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; pVATEntry: Record "VAT Entry"): Integer
    var
        GLEntry: Record "G/L Entry";
    begin
        OnBeforeInitGLEntryVATCopy(GenJournalLine, GLEntry, pVATEntry);
        InitGLEntry(GenJournalLine, GLEntry, AccNo, Amount, 0, false, true);
        GLEntry."Additional-Currency Amount" := AmountAddCurr;
        GLEntry."Bal. Account No." := BalAccNo;
        GLEntry.CopyPostingGroupsFromVATEntry(pVATEntry);
        SummarizeVAT(GeneralLedgerSetup."Summarize G/L Entries", GLEntry);
        OnAfterInitGLEntryVATCopy(GenJournalLine, GLEntry);

        exit(GLEntry."Entry No.");
    end;

    procedure InsertGLEntry(GenJournalLine: Record "Gen. Journal Line"; GLEntry: Record "G/L Entry"; CalcAddCurrResiduals: Boolean)
    begin
        GLEntry.TestField("G/L Account No.");

        if GLEntry.Amount <> Round(GLEntry.Amount) then
            GLEntry.FieldError(
              Amount,
              StrSubstNo(NeedsRoundingErr, GLEntry.Amount));

        UpdateCheckAmounts(
          GLEntry."Posting Date", GLEntry.Amount, GLEntry."Additional-Currency Amount",
          BalanceCheckAmount, BalanceCheckAmount2, BalanceCheckAddCurrAmount, BalanceCheckAddCurrAmount2);

        GLEntry.UpdateDebitCredit(GenJournalLine.Correction);

        TempGLEntryBuf := GLEntry;

        OnBeforeInsertGLEntryBuffer(TempGLEntryBuf, GenJournalLine,
          BalanceCheckAmount, BalanceCheckAmount2, BalanceCheckAddCurrAmount, BalanceCheckAddCurrAmount2, NextEntryNo);

        TempGLEntryBuf.Insert();

        if FirstEntryNo = 0 then
            FirstEntryNo := TempGLEntryBuf."Entry No.";
        IF EntryType = GLEntry."CIR Entry Type"::Definitive THEN
            NextEntryNo := NextEntryNo + 1
        ELSE
            NextEntryNo := NextEntryNo - 1;

        if CalcAddCurrResiduals then
            HandleAddCurrResidualGLEntry(GenJournalLine, GLEntry);
    end;

    procedure CreateGLEntry(GenJournalLine: Record "Gen. Journal Line"; AccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; UseAmountAddCurr: Boolean)
    var
        GLEntry: Record "G/L Entry";
    begin
        if UseAmountAddCurr then
            InitGLEntry(GenJournalLine, GLEntry, AccNo, Amount, AmountAddCurr, true, true)
        else begin
            InitGLEntry(GenJournalLine, GLEntry, AccNo, Amount, 0, false, true);
            GLEntry."Additional-Currency Amount" := AmountAddCurr;
        end;
        InsertGLEntry(GenJournalLine, GLEntry, true);
    end;

    local procedure CreateGLEntryBalAcc(GenJournalLine: Record "Gen. Journal Line"; AccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; BalAccType: Enum "Gen. Journal Account Type"; BalAccNo: Code[20])
    var
        GLEntry: Record "G/L Entry";
    begin
        InitGLEntry(GenJournalLine, GLEntry, AccNo, Amount, AmountAddCurr, true, true);
        GLEntry."Bal. Account Type" := BalAccType;
        GLEntry."Bal. Account No." := BalAccNo;
        InsertGLEntry(GenJournalLine, GLEntry, true);
        OnMoveGenJournalLine(GenJournalLine, GLEntry.RecordId());
    end;

    local procedure CreateGLEntryGainLoss(GenJournalLine: Record "Gen. Journal Line"; AccNo: Code[20]; Amount: Decimal; UseAmountAddCurr: Boolean)
    var
        GLEntry: Record "G/L Entry";
    begin
        InitGLEntry(GenJournalLine, GLEntry, AccNo, Amount, 0, UseAmountAddCurr, true);
        OnBeforeCreateGLEntryGainLossInsertGLEntry(GenJournalLine, GLEntry);
        InsertGLEntry(GenJournalLine, GLEntry, true);
    end;

    local procedure CreateGLEntryVAT(GenJournalLine: Record "Gen. Journal Line"; AccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; VATAmount: Decimal; DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer")
    var
        GLEntry: Record "G/L Entry";
    begin
        InitGLEntry(GenJournalLine, GLEntry, AccNo, Amount, 0, false, true);
        GLEntry."Additional-Currency Amount" := AmountAddCurr;
        GLEntry."VAT Amount" := VATAmount;
        GLEntry.CopyPostingGroupsFromDtldCVBuf(DetailedCVLedgEntryBuffer, DetailedCVLedgEntryBuffer."Gen. Posting Type".AsInteger());
        InsertGLEntry(GenJournalLine, GLEntry, true);
        InsertVATEntriesFromTemp(DetailedCVLedgEntryBuffer, GLEntry);
    end;

    local procedure CreateGLEntryVATCollectAdj(GenJournalLine: Record "Gen. Journal Line"; AccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; VATAmount: Decimal; DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var AdjAmount: array[4] of Decimal)
    var
        GLEntry: Record "G/L Entry";
    begin
        InitGLEntry(GenJournalLine, GLEntry, AccNo, Amount, 0, false, true);
        GLEntry."Additional-Currency Amount" := AmountAddCurr;
        GLEntry."VAT Amount" := VATAmount;
        GLEntry.CopyPostingGroupsFromDtldCVBuf(DetailedCVLedgEntryBuffer, DetailedCVLedgEntryBuffer."Gen. Posting Type".AsInteger());
        InsertGLEntry(GenJournalLine, GLEntry, true);
        CollectAdjustment(AdjAmount, GLEntry.Amount, GLEntry."Additional-Currency Amount");
        InsertVATEntriesFromTemp(DetailedCVLedgEntryBuffer, GLEntry);
    end;

    local procedure CreateGLEntryFromVATEntry(GenJournalLine: Record "Gen. Journal Line"; VATAccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; pVATEntry: Record "VAT Entry"): Integer
    var
        GLEntry: Record "G/L Entry";
    begin
        InitGLEntry(GenJournalLine, GLEntry, VATAccNo, Amount, 0, false, true);
        GLEntry."Additional-Currency Amount" := AmountAddCurr;
        GLEntry.CopyPostingGroupsFromVATEntry(pVATEntry);
        OnBeforeInsertGLEntryFromVATEntry(GLEntry, pVATEntry);
        InsertGLEntry(GenJournalLine, GLEntry, true);
        exit(GLEntry."Entry No.");
    end;

    local procedure CreateDeferralScheduleFromGL(var GenJournalLine: Record "Gen. Journal Line"; IsBalancing: Boolean)
    begin
        if (GenJournalLine."Account No." <> '') and (GenJournalLine."Deferral Code" <> '') then
            if ((GenJournalLine."Account Type" in [GenJournalLine."Account Type"::Customer, GenJournalLine."Account Type"::Vendor]) and (GenJournalLine."Source Code" = GLSourceCode)) or
               (GenJournalLine."Account Type" in [GenJournalLine."Account Type"::"G/L Account", GenJournalLine."Account Type"::"Bank Account"])
            then begin
                if not IsBalancing then
                    CODEUNIT.Run(CODEUNIT::"Exchange Acc. G/L Journal Line", GenJournalLine);
                DeferralUtilities.CreateScheduleFromGL(GenJournalLine, FirstEntryNo);
            end;
    end;

    local procedure UpdateCheckAmounts(PostingDate: Date; Amount: Decimal; AddCurrAmount: Decimal; var pBalanceCheckAmount: Decimal; var pBalanceCheckAmount2: Decimal; var pBalanceCheckAddCurrAmount: Decimal; var pBalanceCheckAddCurrAmount2: Decimal)
    begin
        if PostingDate = NormalDate(PostingDate) then begin
            pBalanceCheckAmount :=
              pBalanceCheckAmount + Amount * ((PostingDate - 00000101D) mod 99 + 1);
            pBalanceCheckAmount2 :=
              pBalanceCheckAmount2 + Amount * ((PostingDate - 00000101D) mod 98 + 1);
        end else begin
            pBalanceCheckAmount :=
              pBalanceCheckAmount + Amount * ((NormalDate(PostingDate) - 00000101D + 50) mod 99 + 1);
            pBalanceCheckAmount2 :=
              pBalanceCheckAmount2 + Amount * ((NormalDate(PostingDate) - 00000101D + 50) mod 98 + 1);
        end;

        if AddCurrencyCode <> '' then
            if PostingDate = NormalDate(PostingDate) then begin
                pBalanceCheckAddCurrAmount :=
                  pBalanceCheckAddCurrAmount + AddCurrAmount * ((PostingDate - 00000101D) mod 99 + 1);
                pBalanceCheckAddCurrAmount2 :=
                  pBalanceCheckAddCurrAmount2 + AddCurrAmount * ((PostingDate - 00000101D) mod 98 + 1);
            end else begin
                pBalanceCheckAddCurrAmount :=
                  pBalanceCheckAddCurrAmount +
                  AddCurrAmount * ((NormalDate(PostingDate) - 00000101D + 50) mod 99 + 1);
                pBalanceCheckAddCurrAmount2 :=
                  pBalanceCheckAddCurrAmount2 +
                  AddCurrAmount * ((NormalDate(PostingDate) - 00000101D + 50) mod 98 + 1);
            end
        else begin
            pBalanceCheckAddCurrAmount := 0;
            pBalanceCheckAddCurrAmount2 := 0;
        end;
    end;

    local procedure CalcPmtDiscPossible(GenJournalLine: Record "Gen. Journal Line"; var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer")
    begin
        if GenJournalLine."Amount (LCY)" <> 0 then begin
            if (CVLedgerEntryBuffer."Pmt. Discount Date" >= CVLedgerEntryBuffer."Posting Date") or
               (CVLedgerEntryBuffer."Pmt. Discount Date" = 0D)
            then begin
                if GeneralLedgerSetup."Pmt. Disc. Excl. VAT" then begin
                    if GenJournalLine."Sales/Purch. (LCY)" = 0 then
                        CVLedgerEntryBuffer."Original Pmt. Disc. Possible" :=
                          (GenJournalLine."Amount (LCY)" + TotalVATAmountOnJnlLines(GenJournalLine)) * GenJournalLine.Amount / GenJournalLine."Amount (LCY)"
                    else
                        CVLedgerEntryBuffer."Original Pmt. Disc. Possible" := GenJournalLine."Sales/Purch. (LCY)" * GenJournalLine.Amount / GenJournalLine."Amount (LCY)"
                end else
                    CVLedgerEntryBuffer."Original Pmt. Disc. Possible" := GenJournalLine.Amount;
                CVLedgerEntryBuffer."Original Pmt. Disc. Possible" :=
                  Round(
                    CVLedgerEntryBuffer."Original Pmt. Disc. Possible" * GenJournalLine."Payment Discount %" / 100, AmountRoundingPrecision);
            end;
            CVLedgerEntryBuffer."Remaining Pmt. Disc. Possible" := CVLedgerEntryBuffer."Original Pmt. Disc. Possible";
        end;
    end;

    local procedure CalcPmtTolerancePossible(GenJournalLine: Record "Gen. Journal Line"; PmtDiscountDate: Date; var PmtDiscToleranceDate: Date; var MaxPaymentTolerance: Decimal)
    begin
        if GenJournalLine."Document Type" in [GenJournalLine."Document Type"::Invoice, GenJournalLine."Document Type"::"Credit Memo"] then begin
            if PmtDiscountDate <> 0D then
                PmtDiscToleranceDate :=
                  CalcDate(GeneralLedgerSetup."Payment Discount Grace Period", PmtDiscountDate)
            else
                PmtDiscToleranceDate := PmtDiscountDate;

            case GenJournalLine."Account Type" of
                GenJournalLine."Account Type"::Customer:
                    PaymentToleranceManagement.CalcMaxPmtTolerance(
                      GenJournalLine."Document Type", GenJournalLine."Currency Code", GenJournalLine.Amount, GenJournalLine."Amount (LCY)", 1, MaxPaymentTolerance);
                GenJournalLine."Account Type"::Vendor:
                    PaymentToleranceManagement.CalcMaxPmtTolerance(
                      GenJournalLine."Document Type", GenJournalLine."Currency Code", GenJournalLine.Amount, GenJournalLine."Amount (LCY)", -1, MaxPaymentTolerance);
            end;
        end;
    end;

    local procedure CalcPmtTolerance(var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GenJournalLine: Record "Gen. Journal Line"; var PmtTolAmtToBeApplied: Decimal; pNextTransactionNo: Integer; pFirstNewVATEntryNo: Integer)
    var
        PmtTol: Decimal;
        PmtTolLCY: Decimal;
        PmtTolAddCurr: Decimal;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCalcPmtTolerance(
          NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2, DetailedCVLedgEntryBuffer, GenJournalLine, PmtTolAmtToBeApplied, IsHandled);
        if IsHandled then
            exit;

        if OldCVLedgerEntryBuffer2."Accepted Payment Tolerance" = 0 then
            exit;

        PmtTol := -OldCVLedgerEntryBuffer2."Accepted Payment Tolerance";
        PmtTolAmtToBeApplied := PmtTolAmtToBeApplied + PmtTol;
        PmtTolLCY :=
          Round(
            (NewCVLedgerEntryBuffer."Original Amount" + PmtTol) / NewCVLedgerEntryBuffer."Original Currency Factor") -
          NewCVLedgerEntryBuffer."Original Amt. (LCY)";

        OnCalcPmtToleranceOnAfterAssignPmtDisc(
          PmtTol, PmtTolLCY, PmtTolAmtToBeApplied, OldCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2,
          NewCVLedgerEntryBuffer, DetailedCVLedgEntryBuffer, pNextTransactionNo, pFirstNewVATEntryNo);

        OldCVLedgerEntryBuffer."Accepted Payment Tolerance" := 0;
        OldCVLedgerEntryBuffer."Pmt. Tolerance (LCY)" := -PmtTolLCY;

        if NewCVLedgerEntryBuffer."Currency Code" = AddCurrencyCode then
            PmtTolAddCurr := PmtTol
        else
            PmtTolAddCurr := CalcLCYToAddCurr(PmtTolLCY);

        if not GeneralLedgerSetup."Pmt. Disc. Excl. VAT" and GeneralLedgerSetup."Adjust for Payment Disc." and (PmtTolLCY <> 0) then
            CalcPmtDiscIfAdjVAT(
              NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2, DetailedCVLedgEntryBuffer, GenJournalLine, PmtTolLCY, PmtTolAddCurr,
              pNextTransactionNo, pFirstNewVATEntryNo, DetailedCVLedgEntryBuffer."Entry Type"::"Payment Tolerance (VAT Excl.)");

        DetailedCVLedgEntryBuffer.InitDetailedCVLedgEntryBuf(
          GenJournalLine, NewCVLedgerEntryBuffer, DetailedCVLedgEntryBuffer,
          DetailedCVLedgEntryBuffer."Entry Type"::"Payment Tolerance", PmtTol, PmtTolLCY, PmtTolAddCurr, 0, 0, 0);
    end;

    local procedure CalcPmtDisc(var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GenJournalLine: Record "Gen. Journal Line"; PmtTolAmtToBeApplied: Decimal; ApplnRoundingPrecision: Decimal; pNextTransactionNo: Integer; pFirstNewVATEntryNo: Integer)
    var
        PmtDisc: Decimal;
        PmtDiscLCY: Decimal;
        PmtDiscAddCurr: Decimal;
        MinimalPossibleLiability: Decimal;
        PaymentExceedsLiability: Boolean;
        ToleratedPaymentExceedsLiability: Boolean;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCalcPmtDisc(
          NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2, DetailedCVLedgEntryBuffer, GenJournalLine, PmtTolAmtToBeApplied, IsHandled);
        if IsHandled then
            exit;

        MinimalPossibleLiability := Abs(OldCVLedgerEntryBuffer2."Remaining Amount" - OldCVLedgerEntryBuffer2."Remaining Pmt. Disc. Possible");
        OnAfterCalcMinimalPossibleLiability(NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2, MinimalPossibleLiability);

        PaymentExceedsLiability := Abs(OldCVLedgerEntryBuffer2."Amount to Apply") >= MinimalPossibleLiability;
        OnAfterCalcPaymentExceedsLiability(
          NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2, MinimalPossibleLiability, PaymentExceedsLiability);

        ToleratedPaymentExceedsLiability :=
          Abs(NewCVLedgerEntryBuffer."Remaining Amount" + PmtTolAmtToBeApplied) >= MinimalPossibleLiability;
        OnAfterCalcToleratedPaymentExceedsLiability(
          NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2, MinimalPossibleLiability,
          ToleratedPaymentExceedsLiability, PmtTolAmtToBeApplied);

        if (PaymentToleranceManagement.CheckCalcPmtDisc(NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2, ApplnRoundingPrecision, true, true) and
            ((OldCVLedgerEntryBuffer2."Amount to Apply" = 0) or PaymentExceedsLiability) or
            (PaymentToleranceManagement.CheckCalcPmtDisc(NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2, ApplnRoundingPrecision, false, false) and
             (OldCVLedgerEntryBuffer2."Amount to Apply" <> 0) and PaymentExceedsLiability and ToleratedPaymentExceedsLiability))
        then begin
            PmtDisc := -OldCVLedgerEntryBuffer2."Remaining Pmt. Disc. Possible";
            PmtDiscLCY :=
              Round(
                (NewCVLedgerEntryBuffer."Original Amount" + PmtDisc) / NewCVLedgerEntryBuffer."Original Currency Factor") -
              NewCVLedgerEntryBuffer."Original Amt. (LCY)";

            OnCalcPmtDiscOnAfterAssignPmtDisc(PmtDisc, PmtDiscLCY, OldCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2);

            OldCVLedgerEntryBuffer."Pmt. Disc. Given (LCY)" := -PmtDiscLCY;

            if (NewCVLedgerEntryBuffer."Currency Code" = AddCurrencyCode) and (AddCurrencyCode <> '') then
                PmtDiscAddCurr := PmtDisc
            else
                PmtDiscAddCurr := CalcLCYToAddCurr(PmtDiscLCY);

            OnAfterCalcPmtDiscount(
              NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2, DetailedCVLedgEntryBuffer, GenJournalLine,
              PmtTolAmtToBeApplied, PmtDisc, PmtDiscLCY, PmtDiscAddCurr);

            if not GeneralLedgerSetup."Pmt. Disc. Excl. VAT" and GeneralLedgerSetup."Adjust for Payment Disc." and
               (PmtDiscLCY <> 0)
            then
                CalcPmtDiscIfAdjVAT(
                  NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2, DetailedCVLedgEntryBuffer, GenJournalLine, PmtDiscLCY, PmtDiscAddCurr,
                  pNextTransactionNo, pFirstNewVATEntryNo, DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount (VAT Excl.)");

            DetailedCVLedgEntryBuffer.InitDetailedCVLedgEntryBuf(
              GenJournalLine, NewCVLedgerEntryBuffer, DetailedCVLedgEntryBuffer,
              DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount", PmtDisc, PmtDiscLCY, PmtDiscAddCurr, 0, 0, 0);
        end;
    end;

    local procedure CalcPmtDiscIfAdjVAT(var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GenJournalLine: Record "Gen. Journal Line"; var PmtDiscLCY2: Decimal; var PmtDiscAddCurr2: Decimal; pNextTransactionNo: Integer; pFirstNewVATEntryNo: Integer; pEntryType: Enum "Detailed CV Ledger Entry Type")
    var
        VATEntry2: Record "VAT Entry";
        VATPostingSetup: Record "VAT Posting Setup";
        TaxJurisdiction: Record "Tax Jurisdiction";
        DetailedCVLedgEntryBuffer2: Record "Detailed CV Ledg. Entry Buffer";
        OriginalAmountAddCurr: Decimal;
        PmtDiscRounding: Decimal;
        PmtDiscRoundingAddCurr: Decimal;
        PmtDiscFactorLCY: Decimal;
        PmtDiscFactorAddCurr: Decimal;
        VATBase: Decimal;
        VATBaseAddCurr: Decimal;
        VATAmount: Decimal;
        VATAmountAddCurr: Decimal;
        TotalVATAmount: Decimal;
        LastConnectionNo: Integer;
        VATEntryModifier: Integer;
    begin
        if OldCVLedgerEntryBuffer."Original Amt. (LCY)" = 0 then
            exit;

        if (AddCurrencyCode = '') or (AddCurrencyCode = OldCVLedgerEntryBuffer."Currency Code") then
            OriginalAmountAddCurr := OldCVLedgerEntryBuffer.Amount
        else
            OriginalAmountAddCurr := CalcLCYToAddCurr(OldCVLedgerEntryBuffer."Original Amt. (LCY)");

        PmtDiscRounding := PmtDiscLCY2;
        PmtDiscFactorLCY := PmtDiscLCY2 / OldCVLedgerEntryBuffer."Original Amt. (LCY)";
        if OriginalAmountAddCurr <> 0 then
            PmtDiscFactorAddCurr := PmtDiscAddCurr2 / OriginalAmountAddCurr
        else
            PmtDiscFactorAddCurr := 0;
        VATEntry2.Reset();
        VATEntry2.SetCurrentKey("Transaction No.");
        VATEntry2.SetRange("Transaction No.", OldCVLedgerEntryBuffer."Transaction No.");
        if OldCVLedgerEntryBuffer."Transaction No." = pNextTransactionNo then
            VATEntry2.SetRange("Entry No.", 0, pFirstNewVATEntryNo - 1);
        if VATEntry2.FindSet() then begin
            TotalVATAmount := 0;
            LastConnectionNo := 0;
            repeat
                VATPostingSetup.Get(VATEntry2."VAT Bus. Posting Group", VATEntry2."VAT Prod. Posting Group");
                if VATEntry2."VAT Calculation Type" =
                   VATEntry2."VAT Calculation Type"::"Sales Tax"
                then begin
                    TaxJurisdiction.Get(VATEntry2."Tax Jurisdiction Code");
                    VATPostingSetup."Adjust for Payment Discount" :=
                      TaxJurisdiction."Adjust for Payment Discount";
                end;
                if VATPostingSetup."Adjust for Payment Discount" then begin
                    if LastConnectionNo <> VATEntry2."Sales Tax Connection No." then begin
                        if LastConnectionNo <> 0 then begin
                            DetailedCVLedgEntryBuffer := DetailedCVLedgEntryBuffer2;
                            DetailedCVLedgEntryBuffer."VAT Amount (LCY)" := -TotalVATAmount;
                            DetailedCVLedgEntryBuffer.InsertDtldCVLedgEntry(DetailedCVLedgEntryBuffer, NewCVLedgerEntryBuffer, false);
                            InsertSummarizedVAT(GenJournalLine);
                        end;

                        CalcPmtDiscVATBases(VATEntry2, VATBase, VATBaseAddCurr);

                        PmtDiscRounding := PmtDiscRounding + VATBase * PmtDiscFactorLCY;
                        VATBase := Round(PmtDiscRounding - PmtDiscLCY2);
                        PmtDiscLCY2 := PmtDiscLCY2 + VATBase;

                        PmtDiscRoundingAddCurr := PmtDiscRoundingAddCurr + VATBaseAddCurr * PmtDiscFactorAddCurr;
                        VATBaseAddCurr := Round(CalcLCYToAddCurr(VATBase), AddCurrency."Amount Rounding Precision");
                        PmtDiscAddCurr2 := PmtDiscAddCurr2 + VATBaseAddCurr;

                        DetailedCVLedgEntryBuffer2.Init();
                        DetailedCVLedgEntryBuffer2."Posting Date" := GenJournalLine."Posting Date";
                        DetailedCVLedgEntryBuffer2."Document Type" := GenJournalLine."Document Type";
                        DetailedCVLedgEntryBuffer2."Document No." := GenJournalLine."Document No.";
                        DetailedCVLedgEntryBuffer2.Amount := 0;
                        DetailedCVLedgEntryBuffer2."Amount (LCY)" := -VATBase;
                        DetailedCVLedgEntryBuffer2."Entry Type" := pEntryType;
                        case pEntryType of
                            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
                                VATEntryModifier := 1000000;
                            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Tolerance (VAT Excl.)":
                                VATEntryModifier := 2000000;
                            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount (VAT Excl.)":
                                VATEntryModifier := 3000000;
                        end;
                        DetailedCVLedgEntryBuffer2.CopyFromCVLedgEntryBuf(NewCVLedgerEntryBuffer);
                        // The total payment discount in currency is posted on the entry made in
                        // the function CalcPmtDisc.
                        DetailedCVLedgEntryBuffer2."User ID" := CopyStr(UserId(), 1, MaxStrLen(DetailedCVLedgEntryBuffer2."User ID"));
                        DetailedCVLedgEntryBuffer2."Additional-Currency Amount" := -VATBaseAddCurr;
                        OnCalcPmtDiscIfAdjVATCopyFields(DetailedCVLedgEntryBuffer2, OldCVLedgerEntryBuffer, GenJournalLine);
                        DetailedCVLedgEntryBuffer2.CopyPostingGroupsFromVATEntry(VATEntry2);
                        TotalVATAmount := 0;
                        LastConnectionNo := VATEntry2."Sales Tax Connection No.";
                    end;

                    CalcPmtDiscVATAmounts(
                      VATEntry2, VATBase, VATBaseAddCurr, VATAmount, VATAmountAddCurr,
                      PmtDiscRounding, PmtDiscFactorLCY, PmtDiscLCY2, PmtDiscAddCurr2);

                    TotalVATAmount := TotalVATAmount + VATAmount;

                    if (PmtDiscAddCurr2 <> 0) and (PmtDiscLCY2 = 0) then begin
                        VATAmountAddCurr := VATAmountAddCurr - PmtDiscAddCurr2;
                        PmtDiscAddCurr2 := 0;
                    end;

                    // Post VAT
                    // VAT for VAT entry
                    if VATEntry2.Type <> VATEntry2.Type::" " then
                        InsertPmtDiscVATForVATEntry(
                          GenJournalLine, TempVATEntry, VATEntry2, VATEntryModifier,
                          VATAmount, VATAmountAddCurr, VATBase, VATBaseAddCurr,
                          PmtDiscFactorLCY, PmtDiscFactorAddCurr);

                    // VAT for G/L entry/entries
                    InsertPmtDiscVATForGLEntry(
                      GenJournalLine, DetailedCVLedgEntryBuffer, NewCVLedgerEntryBuffer, VATEntry2,
                      VATPostingSetup, TaxJurisdiction, pEntryType, VATAmount, VATAmountAddCurr);
                end;
            until VATEntry2.Next() = 0;

            if LastConnectionNo <> 0 then begin
                DetailedCVLedgEntryBuffer := DetailedCVLedgEntryBuffer2;
                DetailedCVLedgEntryBuffer."VAT Amount (LCY)" := -TotalVATAmount;
                DetailedCVLedgEntryBuffer.InsertDtldCVLedgEntry(DetailedCVLedgEntryBuffer, NewCVLedgerEntryBuffer, true);
                InsertSummarizedVAT(GenJournalLine);
            end;
        end;
    end;

    local procedure CalcPmtDiscTolerance(var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GenJournalLine: Record "Gen. Journal Line"; pNextTransactionNo: Integer; pFirstNewVATEntryNo: Integer)
    var
        PmtDiscTol: Decimal;
        PmtDiscTolLCY: Decimal;
        PmtDiscTolAddCurr: Decimal;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCalcPmtDiscTolerance(
          NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2, DetailedCVLedgEntryBuffer, GenJournalLine, IsHandled);
        if IsHandled then
            exit;

        if not OldCVLedgerEntryBuffer2."Accepted Pmt. Disc. Tolerance" then
            exit;

        PmtDiscTol := -OldCVLedgerEntryBuffer2."Remaining Pmt. Disc. Possible";
        PmtDiscTolLCY :=
          Round(
            (NewCVLedgerEntryBuffer."Original Amount" + PmtDiscTol) / NewCVLedgerEntryBuffer."Original Currency Factor") -
          NewCVLedgerEntryBuffer."Original Amt. (LCY)";

        OnAfterCalcPmtDiscTolerance(
          NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2, DetailedCVLedgEntryBuffer, GenJournalLine,
          PmtDiscTol, PmtDiscTolLCY, PmtDiscTolAddCurr);

        OldCVLedgerEntryBuffer."Pmt. Disc. Given (LCY)" := -PmtDiscTolLCY;

        if NewCVLedgerEntryBuffer."Currency Code" = AddCurrencyCode then
            PmtDiscTolAddCurr := PmtDiscTol
        else
            PmtDiscTolAddCurr := CalcLCYToAddCurr(PmtDiscTolLCY);

        if not GeneralLedgerSetup."Pmt. Disc. Excl. VAT" and GeneralLedgerSetup."Adjust for Payment Disc." and (PmtDiscTolLCY <> 0) then
            CalcPmtDiscIfAdjVAT(
              NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2, DetailedCVLedgEntryBuffer, GenJournalLine, PmtDiscTolLCY, PmtDiscTolAddCurr,
              pNextTransactionNo, pFirstNewVATEntryNo, DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount Tolerance (VAT Excl.)");

        DetailedCVLedgEntryBuffer.InitDetailedCVLedgEntryBuf(
          GenJournalLine, NewCVLedgerEntryBuffer, DetailedCVLedgEntryBuffer,
          DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount Tolerance", PmtDiscTol, PmtDiscTolLCY, PmtDiscTolAddCurr, 0, 0, 0);
    end;

    local procedure CalcPmtDiscVATBases(VATEntry2: Record "VAT Entry"; var VATBase: Decimal; var VATBaseAddCurr: Decimal)
    var
        lVATEntry: Record "VAT Entry";
    begin
        case VATEntry2."VAT Calculation Type" of
            VATEntry2."VAT Calculation Type"::"Normal VAT",
            VATEntry2."VAT Calculation Type"::"Reverse Charge VAT",
            VATEntry2."VAT Calculation Type"::"Full VAT":
                begin
                    VATBase :=
                      VATEntry2.Base + VATEntry2."Unrealized Base";
                    VATBaseAddCurr :=
                      VATEntry2."Additional-Currency Base" +
                      VATEntry2."Add.-Currency Unrealized Base";
                end;
            VATEntry2."VAT Calculation Type"::"Sales Tax":
                begin
                    lVATEntry.Reset();
                    lVATEntry.SetCurrentKey("Transaction No.");
                    lVATEntry.SetRange("Transaction No.", VATEntry2."Transaction No.");
                    lVATEntry.SetRange("Sales Tax Connection No.", VATEntry2."Sales Tax Connection No.");
                    lVATEntry := VATEntry2;
                    repeat
                        if lVATEntry.Base < 0 then
                            lVATEntry.SetFilter(Base, '>%1', lVATEntry.Base)
                        else
                            lVATEntry.SetFilter(Base, '<%1', lVATEntry.Base);
                    until not lVATEntry.FindLast();
                    lVATEntry.Reset();
                    VATBase :=
                      lVATEntry.Base + lVATEntry."Unrealized Base";
                    VATBaseAddCurr :=
                      lVATEntry."Additional-Currency Base" +
                      lVATEntry."Add.-Currency Unrealized Base";
                end;
        end;
    end;

    local procedure CalcPmtDiscVATAmounts(VATEntry2: Record "VAT Entry"; VATBase: Decimal; VATBaseAddCurr: Decimal; var VATAmount: Decimal; var VATAmountAddCurr: Decimal; var PmtDiscRounding: Decimal; PmtDiscFactorLCY: Decimal; var PmtDiscLCY2: Decimal; var PmtDiscAddCurr2: Decimal)
    begin
        case VATEntry2."VAT Calculation Type" of
            VATEntry2."VAT Calculation Type"::"Normal VAT",
          VATEntry2."VAT Calculation Type"::"Full VAT":
                if (VATEntry2.Amount + VATEntry2."Unrealized Amount" <> 0) or
                   (VATEntry2."Additional-Currency Amount" + VATEntry2."Add.-Currency Unrealized Amt." <> 0)
                then begin
                    if (VATBase = 0) and
                       (VATEntry2."VAT Calculation Type" <> VATEntry2."VAT Calculation Type"::"Full VAT")
                    then
                        VATAmount := 0
                    else begin
                        PmtDiscRounding :=
                          PmtDiscRounding +
                          (VATEntry2.Amount + VATEntry2."Unrealized Amount") * PmtDiscFactorLCY;
                        VATAmount := Round(PmtDiscRounding - PmtDiscLCY2);
                        PmtDiscLCY2 := PmtDiscLCY2 + VATAmount;
                    end;
                    if (VATBaseAddCurr = 0) and
                       (VATEntry2."VAT Calculation Type" <> VATEntry2."VAT Calculation Type"::"Full VAT")
                    then
                        VATAmountAddCurr := 0
                    else begin
                        VATAmountAddCurr := Round(CalcLCYToAddCurr(VATAmount), AddCurrency."Amount Rounding Precision");
                        PmtDiscAddCurr2 := PmtDiscAddCurr2 + VATAmountAddCurr;
                    end;
                end else begin
                    VATAmount := 0;
                    VATAmountAddCurr := 0;
                end;
            VATEntry2."VAT Calculation Type"::"Reverse Charge VAT":
                begin
                    VATAmount :=
                      Round((VATEntry2.Amount + VATEntry2."Unrealized Amount") * PmtDiscFactorLCY);
                    VATAmountAddCurr := Round(CalcLCYToAddCurr(VATAmount), AddCurrency."Amount Rounding Precision");
                end;
            VATEntry2."VAT Calculation Type"::"Sales Tax":
                if (VATEntry2.Type = VATEntry2.Type::Purchase) and VATEntry2."Use Tax" then begin
                    VATAmount :=
                      Round((VATEntry2.Amount + VATEntry2."Unrealized Amount") * PmtDiscFactorLCY);
                    VATAmountAddCurr := Round(CalcLCYToAddCurr(VATAmount), AddCurrency."Amount Rounding Precision");
                end else
                    if (VATEntry2.Amount + VATEntry2."Unrealized Amount" <> 0) or
                       (VATEntry2."Additional-Currency Amount" + VATEntry2."Add.-Currency Unrealized Amt." <> 0)
                    then begin
                        if VATBase = 0 then
                            VATAmount := 0
                        else begin
                            PmtDiscRounding :=
                              PmtDiscRounding +
                              (VATEntry2.Amount + VATEntry2."Unrealized Amount") * PmtDiscFactorLCY;
                            VATAmount := Round(PmtDiscRounding - PmtDiscLCY2);
                            PmtDiscLCY2 := PmtDiscLCY2 + VATAmount;
                        end;

                        if VATBaseAddCurr = 0 then
                            VATAmountAddCurr := 0
                        else begin
                            VATAmountAddCurr := Round(CalcLCYToAddCurr(VATAmount), AddCurrency."Amount Rounding Precision");
                            PmtDiscAddCurr2 := PmtDiscAddCurr2 + VATAmountAddCurr;
                        end;
                    end else begin
                        VATAmount := 0;
                        VATAmountAddCurr := 0;
                    end;
        end;
    end;

    local procedure InsertPmtDiscVATForVATEntry(GenJournalLine: Record "Gen. Journal Line"; var pTempVATEntry: Record "VAT Entry" temporary; VATEntry2: Record "VAT Entry"; VATEntryModifier: Integer; VATAmount: Decimal; VATAmountAddCurr: Decimal; VATBase: Decimal; VATBaseAddCurr: Decimal; PmtDiscFactorLCY: Decimal; PmtDiscFactorAddCurr: Decimal)
    var
        TempVATEntryNo: Integer;
    begin
        pTempVATEntry.Reset();
        pTempVATEntry.SetRange("Entry No.", VATEntryModifier, VATEntryModifier + 999999);
        if pTempVATEntry.FindLast() then
            TempVATEntryNo := pTempVATEntry."Entry No." + 1
        else
            TempVATEntryNo := VATEntryModifier + 1;
        pTempVATEntry := VATEntry2;
        pTempVATEntry."Entry No." := TempVATEntryNo;
        pTempVATEntry."Posting Date" := GenJournalLine."Posting Date";
        pTempVATEntry."Document Date" := GenJournalLine."Document Date";
        pTempVATEntry."Document No." := GenJournalLine."Document No.";
        pTempVATEntry."External Document No." := GenJournalLine."External Document No.";
        pTempVATEntry."Document Type" := GenJournalLine."Document Type";
        pTempVATEntry."Source Code" := GenJournalLine."Source Code";
        pTempVATEntry."Reason Code" := GenJournalLine."Reason Code";
        pTempVATEntry."Transaction No." := NextTransactionNo;
        pTempVATEntry."Sales Tax Connection No." := NextConnectionNo;
        pTempVATEntry."Unrealized Amount" := 0;
        pTempVATEntry."Unrealized Base" := 0;
        pTempVATEntry."Remaining Unrealized Amount" := 0;
        pTempVATEntry."Remaining Unrealized Base" := 0;
        pTempVATEntry."User ID" := CopyStr(UserId(), 1, MaxStrLen(pTempVATEntry."User ID"));
        pTempVATEntry."Closed by Entry No." := 0;
        pTempVATEntry.Closed := false;
        pTempVATEntry."Internal Ref. No." := '';
        pTempVATEntry.Amount := VATAmount;
        pTempVATEntry."Additional-Currency Amount" := VATAmountAddCurr;
        pTempVATEntry."VAT Difference" := 0;
        pTempVATEntry."Add.-Curr. VAT Difference" := 0;
        pTempVATEntry."Add.-Currency Unrealized Amt." := 0;
        pTempVATEntry."Add.-Currency Unrealized Base" := 0;
        if VATEntry2."Tax on Tax" then begin
            pTempVATEntry.Base :=
              Round((VATEntry2.Base + VATEntry2."Unrealized Base") * PmtDiscFactorLCY);
            pTempVATEntry."Additional-Currency Base" :=
              Round(
                (VATEntry2."Additional-Currency Base" +
                 VATEntry2."Add.-Currency Unrealized Base") * PmtDiscFactorAddCurr,
                AddCurrency."Amount Rounding Precision");
        end else begin
            pTempVATEntry.Base := VATBase;
            pTempVATEntry."Additional-Currency Base" := VATBaseAddCurr;
        end;
        pTempVATEntry."Base Before Pmt. Disc." := VATEntry.Base;

        if AddCurrencyCode = '' then begin
            pTempVATEntry."Additional-Currency Base" := 0;
            pTempVATEntry."Additional-Currency Amount" := 0;
            pTempVATEntry."Add.-Currency Unrealized Amt." := 0;
            pTempVATEntry."Add.-Currency Unrealized Base" := 0;
        end;
        OnBeforeInsertTempVATEntry(pTempVATEntry, GenJournalLine, VATEntry2);
        pTempVATEntry.Insert();
    end;

    local procedure InsertPmtDiscVATForGLEntry(GenJournalLine: Record "Gen. Journal Line"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; VATEntry2: Record "VAT Entry"; var VATPostingSetup: Record "VAT Posting Setup"; var TaxJurisdiction: Record "Tax Jurisdiction"; pEntryType: Enum "Detailed CV Ledger Entry Type"; VATAmount: Decimal; VATAmountAddCurr: Decimal)
    begin
        DetailedCVLedgEntryBuffer.Init();
        DetailedCVLedgEntryBuffer.CopyFromCVLedgEntryBuf(NewCVLedgerEntryBuffer);
        case pEntryType of
            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount (VAT Excl.)":
                DetailedCVLedgEntryBuffer."Entry Type" :=
                  DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount (VAT Adjustment)";
            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
                DetailedCVLedgEntryBuffer."Entry Type" :=
                  DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)";
            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Tolerance (VAT Excl.)":
                DetailedCVLedgEntryBuffer."Entry Type" :=
                  DetailedCVLedgEntryBuffer."Entry Type"::"Payment Tolerance (VAT Adjustment)";
        end;
        DetailedCVLedgEntryBuffer."Posting Date" := GenJournalLine."Posting Date";
        DetailedCVLedgEntryBuffer."Document Type" := GenJournalLine."Document Type";
        DetailedCVLedgEntryBuffer."Document No." := GenJournalLine."Document No.";
        OnInsertPmtDiscVATForGLEntryOnAfterCopyFromGenJnlLine(DetailedCVLedgEntryBuffer, GenJournalLine);
        DetailedCVLedgEntryBuffer.Amount := 0;
        DetailedCVLedgEntryBuffer."VAT Bus. Posting Group" := VATEntry2."VAT Bus. Posting Group";
        DetailedCVLedgEntryBuffer."VAT Prod. Posting Group" := VATEntry2."VAT Prod. Posting Group";
        DetailedCVLedgEntryBuffer."Tax Jurisdiction Code" := VATEntry2."Tax Jurisdiction Code";
        // The total payment discount in currency is posted on the entry made in
        // the function CalcPmtDisc.
        DetailedCVLedgEntryBuffer."User ID" := CopyStr(UserId(), 1, MaxStrLen(DetailedCVLedgEntryBuffer."User ID"));
        DetailedCVLedgEntryBuffer."Use Additional-Currency Amount" := true;

        OnBeforeInsertPmtDiscVATForGLEntry(DetailedCVLedgEntryBuffer, GenJournalLine, VATEntry2);

        case VATEntry2.Type of
            VATEntry2.Type::Purchase:
                case VATEntry2."VAT Calculation Type" of
                    VATEntry2."VAT Calculation Type"::"Normal VAT",
                    VATEntry2."VAT Calculation Type"::"Full VAT":
                        begin
                            InitGLEntryVAT(GenJournalLine, VATPostingSetup.GetPurchAccount(false), '',
                              VATAmount, VATAmountAddCurr, false);
                            DetailedCVLedgEntryBuffer."Amount (LCY)" := -VATAmount;
                            DetailedCVLedgEntryBuffer."Additional-Currency Amount" := -VATAmountAddCurr;
                            DetailedCVLedgEntryBuffer.InsertDtldCVLedgEntry(DetailedCVLedgEntryBuffer, NewCVLedgerEntryBuffer, true);
                        end;
                    VATEntry2."VAT Calculation Type"::"Reverse Charge VAT":
                        begin
                            InitGLEntryVAT(GenJournalLine, VATPostingSetup.GetPurchAccount(false), '',
                              VATAmount, VATAmountAddCurr, false);
                            InitGLEntryVAT(GenJournalLine, VATPostingSetup.GetRevChargeAccount(false), '',
                              -VATAmount, -VATAmountAddCurr, false);
                        end;
                    VATEntry2."VAT Calculation Type"::"Sales Tax":
                        if VATEntry2."Use Tax" then begin
                            InitGLEntryVAT(GenJournalLine, TaxJurisdiction.GetPurchAccount(false), '',
                              VATAmount, VATAmountAddCurr, false);
                            InitGLEntryVAT(GenJournalLine, TaxJurisdiction.GetRevChargeAccount(false), '',
                              -VATAmount, -VATAmountAddCurr, false);
                        end else begin
                            InitGLEntryVAT(GenJournalLine, TaxJurisdiction.GetPurchAccount(false), '',
                              VATAmount, VATAmountAddCurr, false);
                            DetailedCVLedgEntryBuffer."Amount (LCY)" := -VATAmount;
                            DetailedCVLedgEntryBuffer."Additional-Currency Amount" := -VATAmountAddCurr;
                            DetailedCVLedgEntryBuffer.InsertDtldCVLedgEntry(DetailedCVLedgEntryBuffer, NewCVLedgerEntryBuffer, true);
                        end;
                end;
            VATEntry2.Type::Sale:
                case VATEntry2."VAT Calculation Type" of
                    VATEntry2."VAT Calculation Type"::"Normal VAT",
                    VATEntry2."VAT Calculation Type"::"Full VAT":
                        begin
                            InitGLEntryVAT(
                              GenJournalLine, VATPostingSetup.GetSalesAccount(false), '',
                              VATAmount, VATAmountAddCurr, false);
                            DetailedCVLedgEntryBuffer."Amount (LCY)" := -VATAmount;
                            DetailedCVLedgEntryBuffer."Additional-Currency Amount" := -VATAmountAddCurr;
                            DetailedCVLedgEntryBuffer.InsertDtldCVLedgEntry(DetailedCVLedgEntryBuffer, NewCVLedgerEntryBuffer, true);
                        end;
                    VATEntry2."VAT Calculation Type"::"Reverse Charge VAT":
                        ;
                    VATEntry2."VAT Calculation Type"::"Sales Tax":
                        begin
                            InitGLEntryVAT(
                              GenJournalLine, TaxJurisdiction.GetSalesAccount(false), '',
                              VATAmount, VATAmountAddCurr, false);
                            DetailedCVLedgEntryBuffer."Amount (LCY)" := -VATAmount;
                            DetailedCVLedgEntryBuffer."Additional-Currency Amount" := -VATAmountAddCurr;
                            DetailedCVLedgEntryBuffer.InsertDtldCVLedgEntry(DetailedCVLedgEntryBuffer, NewCVLedgerEntryBuffer, true);
                        end;
                end;
        end;
    end;

    local procedure CalcCurrencyApplnRounding(var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GenJournalLine: Record "Gen. Journal Line"; ApplnRoundingPrecision: Decimal)
    var
        ApplnRounding: Decimal;
        ApplnRoundingLCY: Decimal;
    begin
        if ((NewCVLedgerEntryBuffer."Document Type" <> NewCVLedgerEntryBuffer."Document Type"::Payment) and
            (NewCVLedgerEntryBuffer."Document Type" <> NewCVLedgerEntryBuffer."Document Type"::Refund)) or
           (NewCVLedgerEntryBuffer."Currency Code" = OldCVLedgerEntryBuffer."Currency Code")
        then
            exit;

        ApplnRounding := -(NewCVLedgerEntryBuffer."Remaining Amount" + OldCVLedgerEntryBuffer."Remaining Amount");
        ApplnRoundingLCY := Round(ApplnRounding / NewCVLedgerEntryBuffer."Adjusted Currency Factor");

        if (ApplnRounding = 0) or (Abs(ApplnRounding) > ApplnRoundingPrecision) then
            exit;

        DetailedCVLedgEntryBuffer.InitDetailedCVLedgEntryBuf(
          GenJournalLine, NewCVLedgerEntryBuffer, DetailedCVLedgEntryBuffer,
          DetailedCVLedgEntryBuffer."Entry Type"::"Appln. Rounding", ApplnRounding, ApplnRoundingLCY, ApplnRounding, 0, 0, 0);
    end;

    local procedure FindAmtForAppln(var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer"; var AppliedAmount: Decimal; var AppliedAmountLCY: Decimal; var OldAppliedAmount: Decimal; ApplnRoundingPrecision: Decimal)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeFindAmtForAppln(
          NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2, AppliedAmount, AppliedAmountLCY, OldAppliedAmount, IsHandled,
          ApplnRoundingPrecision);
        if IsHandled then
            exit;

        if OldCVLedgerEntryBuffer2.GetFilter(Positive) <> '' then begin
            if OldCVLedgerEntryBuffer2."Amount to Apply" <> 0 then begin
                if (PaymentToleranceManagement.CheckCalcPmtDisc(NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2, ApplnRoundingPrecision, false, false) and
                    (Abs(OldCVLedgerEntryBuffer2."Amount to Apply") >=
                     Abs(OldCVLedgerEntryBuffer2."Remaining Amount" - OldCVLedgerEntryBuffer2."Remaining Pmt. Disc. Possible")))
                then
                    AppliedAmount := -OldCVLedgerEntryBuffer2."Remaining Amount"
                else
                    AppliedAmount := -OldCVLedgerEntryBuffer2."Amount to Apply"
            end else
                AppliedAmount := -OldCVLedgerEntryBuffer2."Remaining Amount";
        end else
            if OldCVLedgerEntryBuffer2."Amount to Apply" <> 0 then
                if (PaymentToleranceManagement.CheckCalcPmtDisc(NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2, ApplnRoundingPrecision, false, false) and
                    (Abs(OldCVLedgerEntryBuffer2."Amount to Apply") >=
                     Abs(OldCVLedgerEntryBuffer2."Remaining Amount" - OldCVLedgerEntryBuffer2."Remaining Pmt. Disc. Possible")) and
                    (Abs(NewCVLedgerEntryBuffer."Remaining Amount") >=
                     Abs(
                       ABSMin(
                         OldCVLedgerEntryBuffer2."Remaining Amount" - OldCVLedgerEntryBuffer2."Remaining Pmt. Disc. Possible",
                         OldCVLedgerEntryBuffer2."Amount to Apply")))) or
                   OldCVLedgerEntryBuffer."Accepted Pmt. Disc. Tolerance"
                then begin
                    AppliedAmount := -OldCVLedgerEntryBuffer2."Remaining Amount";
                    OldCVLedgerEntryBuffer."Accepted Pmt. Disc. Tolerance" := false;
                end else
                    AppliedAmount := ABSMin(NewCVLedgerEntryBuffer."Remaining Amount", -OldCVLedgerEntryBuffer2."Amount to Apply")
            else
                AppliedAmount := ABSMin(NewCVLedgerEntryBuffer."Remaining Amount", -OldCVLedgerEntryBuffer2."Remaining Amount");

        if (Abs(OldCVLedgerEntryBuffer2."Remaining Amount" - OldCVLedgerEntryBuffer2."Amount to Apply") < ApplnRoundingPrecision) and
           (ApplnRoundingPrecision <> 0) and
           (OldCVLedgerEntryBuffer2."Amount to Apply" <> 0)
        then
            AppliedAmount := AppliedAmount - (OldCVLedgerEntryBuffer2."Remaining Amount" - OldCVLedgerEntryBuffer2."Amount to Apply");

        if NewCVLedgerEntryBuffer."Currency Code" = OldCVLedgerEntryBuffer2."Currency Code" then begin
            AppliedAmountLCY := Round(AppliedAmount / OldCVLedgerEntryBuffer."Original Currency Factor");
            OldAppliedAmount := AppliedAmount;
        end else begin
            // Management of posting in multiple currencies
            if AppliedAmount = -OldCVLedgerEntryBuffer2."Remaining Amount" then
                OldAppliedAmount := -OldCVLedgerEntryBuffer."Remaining Amount"
            else
                OldAppliedAmount :=
                  CurrencyExchangeRate.ExchangeAmount(
                    AppliedAmount, NewCVLedgerEntryBuffer."Currency Code",
                    OldCVLedgerEntryBuffer2."Currency Code", NewCVLedgerEntryBuffer."Posting Date");

            if NewCVLedgerEntryBuffer."Currency Code" <> '' then
                // Post the realized gain or loss on the NewCVLedgerEntryBuffer
                AppliedAmountLCY := Round(OldAppliedAmount / OldCVLedgerEntryBuffer."Original Currency Factor")
            else
                // Post the realized gain or loss on the OldCVLedgerEntryBuffer
                AppliedAmountLCY := Round(AppliedAmount / NewCVLedgerEntryBuffer."Original Currency Factor");
        end;

        OnAfterFindAmtForAppln(
          NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2, AppliedAmount, AppliedAmountLCY, OldAppliedAmount);
    end;

    local procedure CalcCurrencyUnrealizedGainLoss(var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var TempDetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer" temporary; GenJournalLine: Record "Gen. Journal Line"; AppliedAmount: Decimal; RemainingAmountBeforeAppln: Decimal)
    var
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        UnRealizedGainLossLCY: Decimal;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCalcCurrencyUnrealizedGainLoss(
          CVLedgerEntryBuffer, TempDetailedCVLedgEntryBuffer, GenJournalLine, AppliedAmount, RemainingAmountBeforeAppln, IsHandled);
        if IsHandled then
            exit;

        if (CVLedgerEntryBuffer."Currency Code" = '') or (RemainingAmountBeforeAppln = 0) then
            exit;

        // Calculate Unrealized GainLoss
        if GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer then
            UnRealizedGainLossLCY :=
              Round(
                DetailedCustLedgEntry.GetUnrealizedGainLossAmount(CVLedgerEntryBuffer."Entry No.") *
                Abs(AppliedAmount / RemainingAmountBeforeAppln))
        else
            UnRealizedGainLossLCY :=
              Round(
                DetailedVendorLedgEntry.GetUnrealizedGainLossAmount(CVLedgerEntryBuffer."Entry No.") *
                Abs(AppliedAmount / RemainingAmountBeforeAppln));

        if UnRealizedGainLossLCY <> 0 then
            if UnRealizedGainLossLCY < 0 then
                TempDetailedCVLedgEntryBuffer.InitDetailedCVLedgEntryBuf(
                  GenJournalLine, CVLedgerEntryBuffer, TempDetailedCVLedgEntryBuffer,
                  TempDetailedCVLedgEntryBuffer."Entry Type"::"Unrealized Loss", 0, -UnRealizedGainLossLCY, 0, 0, 0, 0)
            else
                TempDetailedCVLedgEntryBuffer.InitDetailedCVLedgEntryBuf(
                  GenJournalLine, CVLedgerEntryBuffer, TempDetailedCVLedgEntryBuffer,
                  TempDetailedCVLedgEntryBuffer."Entry Type"::"Unrealized Gain", 0, -UnRealizedGainLossLCY, 0, 0, 0, 0);
    end;

    local procedure CalcCurrencyRealizedGainLoss(var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var TempDetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer" temporary; GenJournalLine: Record "Gen. Journal Line"; AppliedAmount: Decimal; AppliedAmountLCY: Decimal)
    var
        RealizedGainLossLCY: Decimal;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCalcCurrencyRealizedGainLoss(
          CVLedgerEntryBuffer, TempDetailedCVLedgEntryBuffer, GenJournalLine, AppliedAmount, AppliedAmountLCY, IsHandled);
        if IsHandled then
            exit;

        if CVLedgerEntryBuffer."Currency Code" = '' then
            exit;

        RealizedGainLossLCY := AppliedAmountLCY - Round(AppliedAmount / CVLedgerEntryBuffer."Original Currency Factor");
        OnAfterCalcCurrencyRealizedGainLoss(CVLedgerEntryBuffer, AppliedAmount, AppliedAmountLCY, RealizedGainLossLCY);

        if RealizedGainLossLCY <> 0 then
            if RealizedGainLossLCY < 0 then
                TempDetailedCVLedgEntryBuffer.InitDetailedCVLedgEntryBuf(
                  GenJournalLine, CVLedgerEntryBuffer, TempDetailedCVLedgEntryBuffer,
                  TempDetailedCVLedgEntryBuffer."Entry Type"::"Realized Loss", 0, RealizedGainLossLCY, 0, 0, 0, 0)
            else
                TempDetailedCVLedgEntryBuffer.InitDetailedCVLedgEntryBuf(
                  GenJournalLine, CVLedgerEntryBuffer, TempDetailedCVLedgEntryBuffer,
                  TempDetailedCVLedgEntryBuffer."Entry Type"::"Realized Gain", 0, RealizedGainLossLCY, 0, 0, 0, 0);
    end;

    local procedure CalcApplication(var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GenJournalLine: Record "Gen. Journal Line"; AppliedAmount: Decimal; AppliedAmountLCY: Decimal; OldAppliedAmount: Decimal; PrevNewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; PrevOldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var AllApplied: Boolean)
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCalcAplication(
          NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer, DetailedCVLedgEntryBuffer, GenJournalLine,
          AppliedAmount, AppliedAmountLCY, OldAppliedAmount, PrevNewCVLedgerEntryBuffer, PrevOldCVLedgerEntryBuffer, AllApplied, IsHandled);
        if IsHandled then
            exit;

        if AppliedAmount = 0 then
            exit;

        DetailedCVLedgEntryBuffer.InitDetailedCVLedgEntryBuf(
          GenJournalLine, OldCVLedgerEntryBuffer, DetailedCVLedgEntryBuffer,
          DetailedCVLedgEntryBuffer."Entry Type"::Application, OldAppliedAmount, AppliedAmountLCY, 0,
          NewCVLedgerEntryBuffer."Entry No.", PrevOldCVLedgerEntryBuffer."Remaining Pmt. Disc. Possible",
          PrevOldCVLedgerEntryBuffer."Max. Payment Tolerance");

        OnAfterInitOldDtldCVLedgEntryBuf(
          DetailedCVLedgEntryBuffer, NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer, PrevNewCVLedgerEntryBuffer, PrevOldCVLedgerEntryBuffer, GenJournalLine);

        OldCVLedgerEntryBuffer.Open := OldCVLedgerEntryBuffer."Remaining Amount" <> 0;
        if not OldCVLedgerEntryBuffer.Open then
            OldCVLedgerEntryBuffer.SetClosedFields(
              NewCVLedgerEntryBuffer."Entry No.", GenJournalLine."Posting Date",
              -OldAppliedAmount, -AppliedAmountLCY, NewCVLedgerEntryBuffer."Currency Code", -AppliedAmount)
        else
            AllApplied := false;

        DetailedCVLedgEntryBuffer.InitDetailedCVLedgEntryBuf(
          GenJournalLine, NewCVLedgerEntryBuffer, DetailedCVLedgEntryBuffer,
          DetailedCVLedgEntryBuffer."Entry Type"::Application, -AppliedAmount, -AppliedAmountLCY, 0,
          NewCVLedgerEntryBuffer."Entry No.", PrevNewCVLedgerEntryBuffer."Remaining Pmt. Disc. Possible",
          PrevNewCVLedgerEntryBuffer."Max. Payment Tolerance");

        OnAfterInitNewDtldCVLedgEntryBuf(
          DetailedCVLedgEntryBuffer, NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer, PrevNewCVLedgerEntryBuffer, PrevOldCVLedgerEntryBuffer, GenJournalLine);

        NewCVLedgerEntryBuffer.Open := NewCVLedgerEntryBuffer."Remaining Amount" <> 0;
        if not NewCVLedgerEntryBuffer.Open and not AllApplied then
            NewCVLedgerEntryBuffer.SetClosedFields(
              OldCVLedgerEntryBuffer."Entry No.", GenJournalLine."Posting Date",
              AppliedAmount, AppliedAmountLCY, OldCVLedgerEntryBuffer."Currency Code", OldAppliedAmount);
    end;

    local procedure CalcAmtLCYAdjustment(var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GenJournalLine: Record "Gen. Journal Line")
    var
        AdjustedAmountLCY: Decimal;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCalcAmtLCYAdjustment(CVLedgerEntryBuffer, DetailedCVLedgEntryBuffer, GenJournalLine, IsHandled);
        if IsHandled then
            exit;

        if CVLedgerEntryBuffer."Currency Code" = '' then
            exit;

        AdjustedAmountLCY :=
          Round(CVLedgerEntryBuffer."Remaining Amount" / CVLedgerEntryBuffer."Adjusted Currency Factor");

        if AdjustedAmountLCY <> CVLedgerEntryBuffer."Remaining Amt. (LCY)" then begin
            DetailedCVLedgEntryBuffer.InitFromGenJnlLine(GenJournalLine);
            DetailedCVLedgEntryBuffer.CopyFromCVLedgEntryBuf(CVLedgerEntryBuffer);
            DetailedCVLedgEntryBuffer."Entry Type" :=
              DetailedCVLedgEntryBuffer."Entry Type"::"Correction of Remaining Amount";
            DetailedCVLedgEntryBuffer."Amount (LCY)" := AdjustedAmountLCY - CVLedgerEntryBuffer."Remaining Amt. (LCY)";
            DetailedCVLedgEntryBuffer.InsertDtldCVLedgEntry(DetailedCVLedgEntryBuffer, CVLedgerEntryBuffer, false);
        end;
    end;

    local procedure InitBankAccLedgEntry(GenJournalLine: Record "Gen. Journal Line"; var BankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    begin
        OnBeforeInitBankAccLedgEntry(BankAccountLedgerEntry, GenJournalLine);

        BankAccountLedgerEntry.Init();
        BankAccountLedgerEntry.CopyFromGenJnlLine(GenJournalLine);
        BankAccountLedgerEntry."Entry No." := NextEntryNo;
        BankAccountLedgerEntry."Transaction No." := NextTransactionNo;

        OnAfterInitBankAccLedgEntry(BankAccountLedgerEntry, GenJournalLine);
    end;

    local procedure InitCheckLedgEntry(BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var CheckLedgerEntry: Record "Check Ledger Entry")
    begin
        OnBeforeInitCheckEntry(BankAccountLedgerEntry, CheckLedgerEntry);

        CheckLedgerEntry.Init();
        CheckLedgerEntry.CopyFromBankAccLedgEntry(BankAccountLedgerEntry);
        CheckLedgerEntry."Entry No." := NextCheckEntryNo;

        OnAfterInitCheckLedgEntry(CheckLedgerEntry, BankAccountLedgerEntry);
    end;

    local procedure InitCustLedgEntry(GenJournalLine: Record "Gen. Journal Line"; var pCustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        OnBeforeInitCustLedgEntry(pCustLedgerEntry, GenJournalLine);

        pCustLedgerEntry.Init();
        pCustLedgerEntry.CopyFromGenJnlLine(GenJournalLine);
        pCustLedgerEntry."Entry No." := NextEntryNo;
        pCustLedgerEntry."Transaction No." := NextTransactionNo;

        OnAfterInitCustLedgEntry(pCustLedgerEntry, GenJournalLine);
    end;

    local procedure InitVendLedgEntry(GenJournalLine: Record "Gen. Journal Line"; var pVendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        OnBeforeInitVendLedgEntry(pVendorLedgerEntry, GenJournalLine);

        pVendorLedgerEntry.Init();
        pVendorLedgerEntry.CopyFromGenJnlLine(GenJournalLine);
        pVendorLedgerEntry."Entry No." := NextEntryNo;
        pVendorLedgerEntry."Transaction No." := NextTransactionNo;

        OnAfterInitVendLedgEntry(pVendorLedgerEntry, GenJournalLine);
    end;

    local procedure InitEmployeeLedgerEntry(GenJournalLine: Record "Gen. Journal Line"; var EmployeeLedgerEntry: Record "Employee Ledger Entry")
    begin
        OnBeforeInitEmployeeLedgEntry(EmployeeLedgerEntry, GenJournalLine);

        EmployeeLedgerEntry.Init();
        EmployeeLedgerEntry.CopyFromGenJnlLine(GenJournalLine);
        EmployeeLedgerEntry."Entry No." := NextEntryNo;
        EmployeeLedgerEntry."Transaction No." := NextTransactionNo;

        OnAfterInitEmployeeLedgerEntry(EmployeeLedgerEntry, GenJournalLine);
    end;

    local procedure InsertDtldCustLedgEntry(GenJournalLine: Record "Gen. Journal Line"; DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; Offset: Integer)
    begin
        DetailedCustLedgEntry.Init();
        DetailedCustLedgEntry.TransferFields(DetailedCVLedgEntryBuffer);
        DetailedCustLedgEntry."Entry No." := Offset + DetailedCVLedgEntryBuffer."Entry No.";
        DetailedCustLedgEntry."Journal Batch Name" := GenJournalLine."Journal Batch Name";
        DetailedCustLedgEntry."Reason Code" := GenJournalLine."Reason Code";
        DetailedCustLedgEntry."Source Code" := GenJournalLine."Source Code";
        DetailedCustLedgEntry."Transaction No." := NextTransactionNo;
        DetailedCustLedgEntry.UpdateDebitCredit(GenJournalLine.Correction);
        OnBeforeInsertDtldCustLedgEntry(DetailedCustLedgEntry, GenJournalLine, DetailedCVLedgEntryBuffer);
        DetailedCustLedgEntry.Insert(true);
        OnAfterInsertDtldCustLedgEntry(DetailedCustLedgEntry, GenJournalLine, DetailedCVLedgEntryBuffer, Offset);
    end;

    local procedure InsertDtldVendLedgEntry(GenJournalLine: Record "Gen. Journal Line"; DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry"; Offset: Integer)
    begin
        DetailedVendorLedgEntry.Init();
        DetailedVendorLedgEntry.TransferFields(DetailedCVLedgEntryBuffer);
        DetailedVendorLedgEntry."Entry No." := Offset + DetailedCVLedgEntryBuffer."Entry No.";
        DetailedVendorLedgEntry."Journal Batch Name" := GenJournalLine."Journal Batch Name";
        DetailedVendorLedgEntry."Reason Code" := GenJournalLine."Reason Code";
        DetailedVendorLedgEntry."Source Code" := GenJournalLine."Source Code";
        DetailedVendorLedgEntry."Transaction No." := NextTransactionNo;
        DetailedVendorLedgEntry.UpdateDebitCredit(GenJournalLine.Correction);
        OnBeforeInsertDtldVendLedgEntry(DetailedVendorLedgEntry, GenJournalLine, DetailedCVLedgEntryBuffer);
        DetailedVendorLedgEntry.Insert(true);
        OnAfterInsertDtldVendLedgEntry(DetailedVendorLedgEntry, GenJournalLine, DetailedCVLedgEntryBuffer, Offset);
    end;

    local procedure InsertDtldEmplLedgEntry(GenJournalLine: Record "Gen. Journal Line"; DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var DetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry"; Offset: Integer)
    begin
        DetailedEmployeeLedgerEntry.Init();
        DetailedEmployeeLedgerEntry.TransferFields(DetailedCVLedgEntryBuffer);
        DetailedEmployeeLedgerEntry."Entry No." := Offset + DetailedCVLedgEntryBuffer."Entry No.";
        DetailedEmployeeLedgerEntry."Journal Batch Name" := GenJournalLine."Journal Batch Name";
        DetailedEmployeeLedgerEntry."Reason Code" := GenJournalLine."Reason Code";
        DetailedEmployeeLedgerEntry."Source Code" := GenJournalLine."Source Code";
        DetailedEmployeeLedgerEntry."Transaction No." := NextTransactionNo;
        DetailedEmployeeLedgerEntry.UpdateDebitCredit(GenJournalLine.Correction);
        OnBeforeInsertDtldEmplLedgEntry(DetailedEmployeeLedgerEntry, GenJournalLine, DetailedCVLedgEntryBuffer);
        DetailedEmployeeLedgerEntry.Insert(true);
    end;

    local procedure ApplyCustLedgEntry(var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GenJournalLine: Record "Gen. Journal Line"; Customer: Record Customer)
    var
        OldCustLedgerEntry: Record "Cust. Ledger Entry";
        OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer";
        NewCustLedgerEntry: Record "Cust. Ledger Entry";
        NewCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer";
        TempOldCustLedgerEntry: Record "Cust. Ledger Entry" temporary;
        Completed: Boolean;
        AppliedAmount: Decimal;
        NewRemainingAmtBeforeAppln: Decimal;
        ApplyingDate: Date;
        PmtTolAmtToBeApplied: Decimal;
        AllApplied: Boolean;
        IsAmountToApplyCheckHandled: Boolean;
    begin
        OnBeforeApplyCustLedgEntry(NewCVLedgerEntryBuffer, DetailedCVLedgEntryBuffer, GenJournalLine, Customer, IsAmountToApplyCheckHandled);
        if not IsAmountToApplyCheckHandled then
            if NewCVLedgerEntryBuffer."Amount to Apply" = 0 then
                exit;

        AllApplied := true;
        if (GenJournalLine."Applies-to Doc. No." = '') and (GenJournalLine."Applies-to ID" = '') and
           not
           ((Customer."Application Method" = Customer."Application Method"::"Apply to Oldest") and
            GenJournalLine."Allow Application")
        then
            exit;

        PmtTolAmtToBeApplied := 0;
        NewRemainingAmtBeforeAppln := NewCVLedgerEntryBuffer."Remaining Amount";
        NewCVLedgerEntryBuffer2 := NewCVLedgerEntryBuffer;

        ApplyingDate := GenJournalLine."Posting Date";

        OnApplyCustLedgEntryOnBeforePrepareTempCustLedgEntry(GenJournalLine, NewCVLedgerEntryBuffer, DetailedCVLedgEntryBuffer, NextEntryNo);
        if not PrepareTempCustLedgEntry(GenJournalLine, NewCVLedgerEntryBuffer, TempOldCustLedgerEntry, Customer, ApplyingDate) then
            exit;

        GenJournalLine."Posting Date" := ApplyingDate;
        // Apply the new entry (Payment) to the old entries (Invoices) one at a time
        repeat
            TempOldCustLedgerEntry.CalcFields(
              Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)",
              "Original Amount", "Original Amt. (LCY)");
            TempOldCustLedgerEntry.CopyFilter(Positive, OldCVLedgerEntryBuffer.Positive);
            OldCVLedgerEntryBuffer.CopyFromCustLedgEntry(TempOldCustLedgerEntry);

            PostApply(
              GenJournalLine, DetailedCVLedgEntryBuffer, OldCVLedgerEntryBuffer, NewCVLedgerEntryBuffer, NewCVLedgerEntryBuffer2,
              Customer."Block Payment Tolerance", AllApplied, AppliedAmount, PmtTolAmtToBeApplied);

            if not OldCVLedgerEntryBuffer.Open then begin
                UpdateCalcInterest(OldCVLedgerEntryBuffer);
                UpdateCalcInterest(OldCVLedgerEntryBuffer, NewCVLedgerEntryBuffer);
            end;

            TempOldCustLedgerEntry.CopyFromCVLedgEntryBuffer(OldCVLedgerEntryBuffer);
            OldCustLedgerEntry := TempOldCustLedgerEntry;
            if GenJournalLine."Delayed Unrealized VAT" then begin
                UnrealCVLedgEntryBuffer.Init();
                UnrealCVLedgEntryBuffer."Account Type" := UnrealCVLedgEntryBuffer."Account Type"::Customer;
                UnrealCVLedgEntryBuffer."Account No." := OldCustLedgerEntry."Customer No.";
                UnrealCVLedgEntryBuffer."Payment Slip No." := GenJournalLine."Document No.";
                UnrealCVLedgEntryBuffer."Applies-to ID" := OldCustLedgerEntry."Applies-to ID";
                UnrealCVLedgEntryBuffer."Entry No." := OldCustLedgerEntry."Entry No.";
                UnrealCVLedgEntryBuffer."Applied Amount" := AppliedAmount;
                UnrealCVLedgEntryBuffer.Insert();
            end;
            OldCustLedgerEntry."Applies-to ID" := '';
            OldCustLedgerEntry."Amount to Apply" := 0;
            OldCustLedgerEntry.Modify();

            OnAfterOldCustLedgEntryModify(OldCustLedgerEntry);

            if GeneralLedgerSetup."Unrealized VAT" or
               (GeneralLedgerSetup."Prepayment Unrealized VAT" and TempOldCustLedgerEntry.Prepayment)
            then
                if IsNotPayment(TempOldCustLedgerEntry."Document Type") and not GenJournalLine."Delayed Unrealized VAT" then begin
                    TempOldCustLedgerEntry.RecalculateAmounts(
                      NewCVLedgerEntryBuffer."Currency Code", TempOldCustLedgerEntry."Currency Code", NewCVLedgerEntryBuffer."Posting Date");
                    OnApplyCustLedgEntryOnAfterRecalculateAmounts(TempOldCustLedgerEntry, OldCustLedgerEntry, NewCVLedgerEntryBuffer, GenJournalLine);
                    CustUnrealizedVAT(
                      GenJournalLine,
                      TempOldCustLedgerEntry,
                      CurrencyExchangeRate.ExchangeAmount(
                        AppliedAmount, NewCVLedgerEntryBuffer."Currency Code",
                        TempOldCustLedgerEntry."Currency Code", NewCVLedgerEntryBuffer."Posting Date"));
                end;

            TempOldCustLedgerEntry.Delete();

            Completed := FindNextOldCustLedgEntryToApply(GenJournalLine, TempOldCustLedgerEntry, NewCVLedgerEntryBuffer);
        until Completed;

        DetailedCVLedgEntryBuffer.SetCurrentKey("CV Ledger Entry No.", "Entry Type");
        DetailedCVLedgEntryBuffer.SetRange("CV Ledger Entry No.", NewCVLedgerEntryBuffer."Entry No.");
        DetailedCVLedgEntryBuffer.SetRange(
          "Entry Type",
          DetailedCVLedgEntryBuffer."Entry Type"::Application);
        DetailedCVLedgEntryBuffer.CalcSums("Amount (LCY)", Amount);

        CalcCurrencyUnrealizedGainLoss(
          NewCVLedgerEntryBuffer, DetailedCVLedgEntryBuffer, GenJournalLine, DetailedCVLedgEntryBuffer.Amount, NewRemainingAmtBeforeAppln);

        CalcAmtLCYAdjustment(NewCVLedgerEntryBuffer, DetailedCVLedgEntryBuffer, GenJournalLine);

        NewCVLedgerEntryBuffer."Applies-to ID" := '';
        NewCVLedgerEntryBuffer."Amount to Apply" := 0;

        if not NewCVLedgerEntryBuffer.Open then
            UpdateCalcInterest(NewCVLedgerEntryBuffer);

        if GeneralLedgerSetup."Unrealized VAT" or
           (GeneralLedgerSetup."Prepayment Unrealized VAT" and NewCVLedgerEntryBuffer.Prepayment)
        then
            if IsNotPayment(NewCVLedgerEntryBuffer."Document Type") and
               (NewRemainingAmtBeforeAppln - NewCVLedgerEntryBuffer."Remaining Amount" <> 0)
               and not GenJournalLine."Delayed Unrealized VAT"
            then begin
                NewCustLedgerEntry.CopyFromCVLedgEntryBuffer(NewCVLedgerEntryBuffer);
                CheckUnrealizedCust := true;
                CustLedgerEntry := NewCustLedgerEntry;
                CustLedgerEntry.CalcFields("Amount (LCY)", "Original Amt. (LCY)");
                UnrealizedRemainingAmountCust := NewCustLedgerEntry."Remaining Amount" - NewRemainingAmtBeforeAppln;
            end;
    end;

    local procedure FindNextOldCustLedgEntryToApply(GenJournalLine: Record "Gen. Journal Line"; var TempOldCustLedgerEntry: Record "Cust. Ledger Entry" temporary; NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer") Completed: Boolean
    var
        IsHandled: Boolean;
    begin
        OnBeforeFindNextOldCustLedgEntryToApply(GenJournalLine, TempOldCustLedgerEntry, NewCVLedgerEntryBuffer, Completed, IsHandled);
        if IsHandled then
            exit(Completed);

        if GenJournalLine."Applies-to Doc. No." <> '' then
            Completed := true
        else
            if TempOldCustLedgerEntry.GetFilter(Positive) <> '' then
                if TempOldCustLedgerEntry.Next() = 1 then
                    Completed := false
                else begin
                    TempOldCustLedgerEntry.SetRange(Positive);
                    TempOldCustLedgerEntry.Find('-');
                    TempOldCustLedgerEntry.CalcFields("Remaining Amount");
                    Completed := TempOldCustLedgerEntry."Remaining Amount" * NewCVLedgerEntryBuffer."Remaining Amount" >= 0;
                end
            else
                if NewCVLedgerEntryBuffer.Open then
                    Completed := TempOldCustLedgerEntry.Next() = 0
                else
                    Completed := true;
    end;

    procedure CustPostApplyCustLedgEntry(var GenJournalLinePostApply: Record "Gen. Journal Line"; var CustLedgerEntryPostApply: Record "Cust. Ledger Entry")
    var
        Customer: Record Customer;
        CustomerPostingGroup: Record "Customer Posting Group";
        lCustLedgerEntry: Record "Cust. Ledger Entry";
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        TempDetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer" temporary;
        CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer";
        GenJournalLine: Record "Gen. Journal Line";
        DtldLedgEntryInserted: Boolean;
    begin
        GenJournalLine := GenJournalLinePostApply;
        lCustLedgerEntry.TransferFields(CustLedgerEntryPostApply);
        GenJournalLine."Source Currency Code" := CustLedgerEntryPostApply."Currency Code";
        GenJournalLine."Applies-to ID" := CustLedgerEntryPostApply."Applies-to ID";

        GenJnlCheckLine.RunCheck(GenJournalLine);

        if NextEntryNo = 0 then
            StartPosting(GenJournalLine)
        else
            ContinuePosting(GenJournalLine);

        Customer.Get(lCustLedgerEntry."Customer No.");
        Customer.CheckBlockedCustOnJnls(Customer, GenJournalLine."Document Type", true);

        OnCustPostApplyCustLedgEntryOnBeforeCheckPostingGroup(GenJournalLine, Customer);

        if GenJournalLine."Posting Group" = '' then begin
            Customer.TestField("Customer Posting Group");
            GenJournalLine."Posting Group" := Customer."Customer Posting Group";
        end;
        CustomerPostingGroup.Get(GenJournalLine."Posting Group");
        CustomerPostingGroup.GetReceivablesAccount();

        DetailedCustLedgEntry.LockTable();
        lCustLedgerEntry.LockTable();

        // Post the application
        lCustLedgerEntry.CalcFields(
          Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)",
          "Original Amount", "Original Amt. (LCY)");
        CVLedgerEntryBuffer.CopyFromCustLedgEntry(lCustLedgerEntry);
        ApplyCustLedgEntry(CVLedgerEntryBuffer, TempDetailedCVLedgEntryBuffer, GenJournalLine, Customer);
        lCustLedgerEntry.CopyFromCVLedgEntryBuffer(CVLedgerEntryBuffer);
        lCustLedgerEntry.Modify();

        // Post the Dtld customer entry
        DtldLedgEntryInserted := PostDtldCustLedgEntries(GenJournalLine, TempDetailedCVLedgEntryBuffer, CustomerPostingGroup, false);

        CheckPostUnrealizedVAT(GenJournalLine, true);

        if DtldLedgEntryInserted then
            if IsTempGLEntryBufEmpty() then
                DetailedCustLedgEntry.SetZeroTransNo(NextTransactionNo);

        OnCustPostApplyCustLedgEntryOnBeforeFinishPosting(GenJournalLine, lCustLedgerEntry);

        FinishPosting(GenJournalLine);
    end;

    local procedure PrepareTempCustLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var TempOldCustLedgerEntry: Record "Cust. Ledger Entry" temporary; Customer: Record Customer; var ApplyingDate: Date): Boolean
    var
        OldCustLedgerEntry: Record "Cust. Ledger Entry";
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        RemainingAmount: Decimal;
        IsHandled: Boolean;
    begin
        OnBeforePrepareTempCustledgEntry(GenJournalLine, NewCVLedgerEntryBuffer);

        if GenJournalLine."Applies-to Doc. No." <> '' then begin
            // Find the entry to be applied to
            OldCustLedgerEntry.Reset();
            OldCustLedgerEntry.SetCurrentKey("Document No.");
            OldCustLedgerEntry.SetRange("Document No.", GenJournalLine."Applies-to Doc. No.");
            OldCustLedgerEntry.SetRange("Document Type", GenJournalLine."Applies-to Doc. Type");
            OldCustLedgerEntry.SetRange("Customer No.", NewCVLedgerEntryBuffer."CV No.");
            OldCustLedgerEntry.SetRange(Open, true);
            OnPrepareTempCustLedgEntryOnAfterSetFilters(OldCustLedgerEntry, GenJournalLine, NewCVLedgerEntryBuffer);
            OldCustLedgerEntry.FindFirst();
            OnPrepareTempCustLedgEntryOnBeforeTestPositive(GenJournalLine, IsHandled);
            if not IsHandled then
                OldCustLedgerEntry.TestField(Positive, not NewCVLedgerEntryBuffer.Positive);
            if OldCustLedgerEntry."Posting Date" > ApplyingDate then
                ApplyingDate := OldCustLedgerEntry."Posting Date";
            GenJnlApply.CheckAgainstApplnCurrency(
              NewCVLedgerEntryBuffer."Currency Code", OldCustLedgerEntry."Currency Code", GenJournalLine."Account Type"::Customer, true);
            TempOldCustLedgerEntry := OldCustLedgerEntry;
            OnPrepareTempCustLedgEntryOnBeforeTempOldCustLedgEntryInsert(TempOldCustLedgerEntry, GenJournalLine);
            TempOldCustLedgerEntry.Insert();
        end else begin
            // Find the first old entry (Invoice) which the new entry (Payment) should apply to
            OldCustLedgerEntry.Reset();
            OldCustLedgerEntry.SetCurrentKey("Customer No.", "Applies-to ID", Open, Positive, "Due Date");
            TempOldCustLedgerEntry.SetCurrentKey("Customer No.", "Applies-to ID", Open, Positive, "Due Date");
            OldCustLedgerEntry.SetRange("Customer No.", NewCVLedgerEntryBuffer."CV No.");
            OldCustLedgerEntry.SetRange("Applies-to ID", GenJournalLine."Applies-to ID");
            OldCustLedgerEntry.SetRange(Open, true);
            OldCustLedgerEntry.SetFilter("Entry No.", '<>%1', NewCVLedgerEntryBuffer."Entry No.");
            if not (Customer."Application Method" = Customer."Application Method"::"Apply to Oldest") then
                OldCustLedgerEntry.SetFilter("Amount to Apply", '<>%1', 0);

            if Customer."Application Method" = Customer."Application Method"::"Apply to Oldest" then
                OldCustLedgerEntry.SetFilter("Posting Date", '..%1', GenJournalLine."Posting Date");

            // Check Customer Ledger Entry and add to Temp.
            SalesReceivablesSetup.Get();
            if SalesReceivablesSetup."Appln. between Currencies" = SalesReceivablesSetup."Appln. between Currencies"::None then
                OldCustLedgerEntry.SetRange("Currency Code", NewCVLedgerEntryBuffer."Currency Code");
            if OldCustLedgerEntry.FindSet() then
                repeat
                    if GenJnlApply.CheckAgainstApplnCurrency(
                         NewCVLedgerEntryBuffer."Currency Code", OldCustLedgerEntry."Currency Code", GenJournalLine."Account Type"::Customer, false)
                    then begin
                        if (OldCustLedgerEntry."Posting Date" > ApplyingDate) and (OldCustLedgerEntry."Applies-to ID" <> '') then
                            ApplyingDate := OldCustLedgerEntry."Posting Date";
                        TempOldCustLedgerEntry := OldCustLedgerEntry;
                        OnPrepareTempCustLedgEntryOnBeforeTempOldCustLedgEntryInsert(TempOldCustLedgerEntry, GenJournalLine);
                        TempOldCustLedgerEntry.Insert();
                    end;
                until OldCustLedgerEntry.Next() = 0;

            TempOldCustLedgerEntry.SetRange(Positive, NewCVLedgerEntryBuffer."Remaining Amount" > 0);

            if TempOldCustLedgerEntry.Find('-') then begin
                RemainingAmount := NewCVLedgerEntryBuffer."Remaining Amount";
                TempOldCustLedgerEntry.SetRange(Positive);
                TempOldCustLedgerEntry.Find('-');
                repeat
                    TempOldCustLedgerEntry.CalcFields("Remaining Amount");
                    TempOldCustLedgerEntry.RecalculateAmounts(
                      TempOldCustLedgerEntry."Currency Code", NewCVLedgerEntryBuffer."Currency Code", NewCVLedgerEntryBuffer."Posting Date");
                    if PaymentToleranceManagement.CheckCalcPmtDiscCVCust(NewCVLedgerEntryBuffer, TempOldCustLedgerEntry, 0, false, false) then
                        TempOldCustLedgerEntry."Remaining Amount" -= TempOldCustLedgerEntry."Remaining Pmt. Disc. Possible";
                    RemainingAmount += TempOldCustLedgerEntry."Remaining Amount";
                until TempOldCustLedgerEntry.Next() = 0;
                TempOldCustLedgerEntry.SetRange(Positive, RemainingAmount < 0);
            end else
                TempOldCustLedgerEntry.SetRange(Positive);

            OnPrepareTempCustLedgEntryOnBeforeExit(GenJournalLine, NewCVLedgerEntryBuffer, TempOldCustLedgerEntry);
            exit(TempOldCustLedgerEntry.Find('-'));
        end;
        exit(true);
    end;

    local procedure PostDtldCustLedgEntries(GenJournalLine: Record "Gen. Journal Line"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; CustomerPostingGroup: Record "Customer Posting Group"; LedgEntryInserted: Boolean) DtldLedgEntryInserted: Boolean
    var
#pragma warning disable AL0432
        TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary;
#pragma warning restore AL0432
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        AdjAmount: array[4] of Decimal;
        DtldCustLedgEntryNoOffset: Integer;
        SaveEntryNo: Integer;
    begin
        if GenJournalLine."Account Type" <> GenJournalLine."Account Type"::Customer then
            exit;

        if DetailedCustLedgEntry.FindLast() then
            DtldCustLedgEntryNoOffset := DetailedCustLedgEntry."Entry No."
        else
            DtldCustLedgEntryNoOffset := 0;

        DetailedCVLedgEntryBuffer.Reset();
        if DetailedCVLedgEntryBuffer.FindSet() then begin
            if LedgEntryInserted then begin
                SaveEntryNo := NextEntryNo;
                NextEntryNo := NextEntryNo + 1;
            end;
            repeat
                InsertDtldCustLedgEntry(GenJournalLine, DetailedCVLedgEntryBuffer, DetailedCustLedgEntry, DtldCustLedgEntryNoOffset);
                UpdateTotalAmounts(TempInvoicePostBuffer, GenJournalLine."Dimension Set ID", DetailedCVLedgEntryBuffer);
                if ((DetailedCVLedgEntryBuffer."Amount (LCY)" <> 0) or
                    (DetailedCVLedgEntryBuffer."VAT Amount (LCY)" <> 0)) or
                   ((AddCurrencyCode <> '') and (DetailedCVLedgEntryBuffer."Additional-Currency Amount" <> 0))
                then
                    PostDtldCustLedgEntry(GenJournalLine, DetailedCVLedgEntryBuffer, CustomerPostingGroup, AdjAmount);
            until DetailedCVLedgEntryBuffer.Next() = 0;
        end;

        CreateGLEntriesForTotalAmounts(
          GenJournalLine, TempInvoicePostBuffer, AdjAmount, SaveEntryNo, CustomerPostingGroup.GetReceivablesAccount(), LedgEntryInserted);

        DtldLedgEntryInserted := not DetailedCVLedgEntryBuffer.IsEmpty();
        DetailedCVLedgEntryBuffer.DeleteAll();
    end;

    local procedure PostDtldCustLedgEntry(GenJournalLine: Record "Gen. Journal Line"; DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; CustomerPostingGroup: Record "Customer Posting Group"; var AdjAmount: array[4] of Decimal)
    var
        AccNo: Code[20];
    begin
        AccNo := GetDtldCustLedgEntryAccNo(GenJournalLine, DetailedCVLedgEntryBuffer, CustomerPostingGroup, 0, false);
        PostDtldCVLedgEntry(GenJournalLine, DetailedCVLedgEntryBuffer, AccNo, AdjAmount, false);
    end;

    local procedure PostDtldCustLedgEntryUnapply(GenJournalLine: Record "Gen. Journal Line"; DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; CustomerPostingGroup: Record "Customer Posting Group"; OriginalTransactionNo: Integer)
    var
        AdjAmount: array[4] of Decimal;
        AccNo: Code[20];
    begin
        if (DetailedCVLedgEntryBuffer."Amount (LCY)" = 0) and
           (DetailedCVLedgEntryBuffer."VAT Amount (LCY)" = 0) and
           ((AddCurrencyCode = '') or (DetailedCVLedgEntryBuffer."Additional-Currency Amount" = 0))
        then
            exit;

        AccNo := GetDtldCustLedgEntryAccNo(GenJournalLine, DetailedCVLedgEntryBuffer, CustomerPostingGroup, OriginalTransactionNo, true);
        DetailedCVLedgEntryBuffer."Gen. Posting Type" := DetailedCVLedgEntryBuffer."Gen. Posting Type"::Sale;
        PostDtldCVLedgEntry(GenJournalLine, DetailedCVLedgEntryBuffer, AccNo, AdjAmount, true);
    end;

    local procedure GetDtldCustLedgEntryAccNo(GenJournalLine: Record "Gen. Journal Line"; DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; CustomerPostingGroup: Record "Customer Posting Group"; OriginalTransactionNo: Integer; Unapply: Boolean): Code[20]
    var
        GeneralPostingSetup: Record "General Posting Setup";
        Currency: Record Currency;
        AmountCondition: Boolean;
    begin
        OnBeforeGetDtldCustLedgEntryAccNo(GenJournalLine, DetailedCVLedgEntryBuffer, CustomerPostingGroup, OriginalTransactionNo, Unapply);

        AmountCondition := IsDebitAmount(DetailedCVLedgEntryBuffer, Unapply);
        case DetailedCVLedgEntryBuffer."Entry Type" of
            DetailedCVLedgEntryBuffer."Entry Type"::"Initial Entry":
                ;
            DetailedCVLedgEntryBuffer."Entry Type"::Application:
                ;
            DetailedCVLedgEntryBuffer."Entry Type"::"Unrealized Loss",
            DetailedCVLedgEntryBuffer."Entry Type"::"Unrealized Gain",
            DetailedCVLedgEntryBuffer."Entry Type"::"Realized Loss",
            DetailedCVLedgEntryBuffer."Entry Type"::"Realized Gain":
                begin
                    GetCurrency(Currency, DetailedCVLedgEntryBuffer."Currency Code");
                    CheckNonAddCurrCodeOccurred(Currency.Code);
                    exit(Currency.GetGainLossAccount(DetailedCVLedgEntryBuffer));
                end;
            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount":
                exit(CustomerPostingGroup.GetPmtDiscountAccount(AmountCondition));
            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount (VAT Excl.)":
                begin
                    DetailedCVLedgEntryBuffer.TestField("Gen. Prod. Posting Group");
                    GeneralPostingSetup.Get(DetailedCVLedgEntryBuffer."Gen. Bus. Posting Group", DetailedCVLedgEntryBuffer."Gen. Prod. Posting Group");
                    exit(GeneralPostingSetup.GetSalesPmtDiscountAccount(AmountCondition));
                end;
            DetailedCVLedgEntryBuffer."Entry Type"::"Appln. Rounding":
                exit(CustomerPostingGroup.GetApplRoundingAccount(AmountCondition));
            DetailedCVLedgEntryBuffer."Entry Type"::"Correction of Remaining Amount":
                exit(CustomerPostingGroup.GetRoundingAccount(AmountCondition));
            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount Tolerance":
                case GeneralLedgerSetup."Pmt. Disc. Tolerance Posting" of
                    GeneralLedgerSetup."Pmt. Disc. Tolerance Posting"::"Payment Tolerance Accounts":
                        exit(CustomerPostingGroup.GetPmtToleranceAccount(AmountCondition));
                    GeneralLedgerSetup."Pmt. Disc. Tolerance Posting"::"Payment Discount Accounts":
                        exit(CustomerPostingGroup.GetPmtDiscountAccount(AmountCondition));
                end;
            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Tolerance":
                case GeneralLedgerSetup."Payment Tolerance Posting" of
                    GeneralLedgerSetup."Payment Tolerance Posting"::"Payment Tolerance Accounts":
                        exit(CustomerPostingGroup.GetPmtToleranceAccount(AmountCondition));
                    GeneralLedgerSetup."Payment Tolerance Posting"::"Payment Discount Accounts":
                        exit(CustomerPostingGroup.GetPmtDiscountAccount(AmountCondition));
                end;
            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Tolerance (VAT Excl.)":
                begin
                    DetailedCVLedgEntryBuffer.TestField("Gen. Prod. Posting Group");
                    GeneralPostingSetup.Get(DetailedCVLedgEntryBuffer."Gen. Bus. Posting Group", DetailedCVLedgEntryBuffer."Gen. Prod. Posting Group");
                    case GeneralLedgerSetup."Payment Tolerance Posting" of
                        GeneralLedgerSetup."Payment Tolerance Posting"::"Payment Tolerance Accounts":
                            exit(GeneralPostingSetup.GetSalesPmtToleranceAccount(AmountCondition));
                        GeneralLedgerSetup."Payment Tolerance Posting"::"Payment Discount Accounts":
                            exit(GeneralPostingSetup.GetSalesPmtDiscountAccount(AmountCondition));
                    end;
                end;
            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
                begin
                    GeneralPostingSetup.Get(DetailedCVLedgEntryBuffer."Gen. Bus. Posting Group", DetailedCVLedgEntryBuffer."Gen. Prod. Posting Group");
                    case GeneralLedgerSetup."Pmt. Disc. Tolerance Posting" of
                        GeneralLedgerSetup."Pmt. Disc. Tolerance Posting"::"Payment Tolerance Accounts":
                            exit(GeneralPostingSetup.GetSalesPmtToleranceAccount(AmountCondition));
                        GeneralLedgerSetup."Pmt. Disc. Tolerance Posting"::"Payment Discount Accounts":
                            exit(GeneralPostingSetup.GetSalesPmtDiscountAccount(AmountCondition));
                    end;
                end;
            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount (VAT Adjustment)",
          DetailedCVLedgEntryBuffer."Entry Type"::"Payment Tolerance (VAT Adjustment)",
          DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)":
                if Unapply then
                    PostDtldCustVATAdjustment(GenJournalLine, DetailedCVLedgEntryBuffer, OriginalTransactionNo);
            else
                DetailedCVLedgEntryBuffer.FieldError("Entry Type");
        end;
    end;

    local procedure CustUnrealizedVAT(GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry2: Record "Cust. Ledger Entry"; SettledAmount: Decimal)
    var
        VATEntry2: Record "VAT Entry";
        TaxJurisdiction: Record "Tax Jurisdiction";
        VATPostingSetup: Record "VAT Posting Setup";
        VATPart: Decimal;
        VATAmount: Decimal;
        VATBase: Decimal;
        VATAmountAddCurr: Decimal;
        VATBaseAddCurr: Decimal;
        PaidAmount: Decimal;
        TotalUnrealVATAmountLast: Decimal;
        TotalUnrealVATAmountFirst: Decimal;
        SalesVATAccount: Code[20];
        SalesVATUnrealAccount: Code[20];
        LastConnectionNo: Integer;
        lGLEntryNo: Integer;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCustUnrealizedVAT(GenJournalLine, CustLedgerEntry2, SettledAmount, IsHandled);
        if IsHandled then
            exit;

        PaidAmount := CustLedgerEntry2."Amount (LCY)" - CustLedgerEntry2."Remaining Amt. (LCY)";
        if GenJournalLine."Delayed Unrealized VAT" and GenJournalLine."Realize VAT" then
            PaidAmount := CalcPaidAmount(GenJournalLine) - SettledAmount;
        VATEntry2.Reset();
        VATEntry2.SetCurrentKey("Transaction No.");
        VATEntry2.SetRange("Transaction No.", CustLedgerEntry2."Transaction No.");
        if VATEntry2.FindSet() then
            repeat
                VATPostingSetup.Get(VATEntry2."VAT Bus. Posting Group", VATEntry2."VAT Prod. Posting Group");
                if VATPostingSetup."Unrealized VAT Type" in
                   [VATPostingSetup."Unrealized VAT Type"::Last, VATPostingSetup."Unrealized VAT Type"::"Last (Fully Paid)"]
                then
                    TotalUnrealVATAmountLast := TotalUnrealVATAmountLast - VATEntry2."Remaining Unrealized Amount";
                if VATPostingSetup."Unrealized VAT Type" in
                   [VATPostingSetup."Unrealized VAT Type"::First, VATPostingSetup."Unrealized VAT Type"::"First (Fully Paid)"]
                then
                    TotalUnrealVATAmountFirst := TotalUnrealVATAmountFirst - VATEntry2."Remaining Unrealized Amount";
            until VATEntry2.Next() = 0;
        if VATEntry2.FindSet() then begin
            LastConnectionNo := 0;
            repeat
                VATPostingSetup.Get(VATEntry2."VAT Bus. Posting Group", VATEntry2."VAT Prod. Posting Group");
                if LastConnectionNo <> VATEntry2."Sales Tax Connection No." then begin
                    InsertSummarizedVAT(GenJournalLine);
                    LastConnectionNo := VATEntry2."Sales Tax Connection No.";
                end;

                VATPart :=
                  VATEntry2.GetUnrealizedVATPart(
                    Round(SettledAmount / CustLedgerEntry2.GetAdjustedCurrencyFactor()),
                    PaidAmount,
                    CustLedgerEntry2."Amount (LCY)",
                    TotalUnrealVATAmountFirst,
                    TotalUnrealVATAmountLast,
                    GenJournalLine."Delayed Unrealized VAT",
                    GenJournalLine."Realize VAT");

                OnCustUnrealizedVATOnAfterVATPartCalculation(
                  GenJournalLine, CustLedgerEntry2, PaidAmount, TotalUnrealVATAmountFirst, TotalUnrealVATAmountLast, SettledAmount, VATEntry2);

                if VATPart > 0 then begin
                    case VATEntry2."VAT Calculation Type" of
                        VATEntry2."VAT Calculation Type"::"Normal VAT",
                        VATEntry2."VAT Calculation Type"::"Reverse Charge VAT",
                        VATEntry2."VAT Calculation Type"::"Full VAT":
                            begin
                                SalesVATAccount := VATPostingSetup.GetSalesAccount(false);
                                SalesVATUnrealAccount := VATPostingSetup.GetSalesAccount(true);
                            end;
                        VATEntry2."VAT Calculation Type"::"Sales Tax":
                            begin
                                TaxJurisdiction.Get(VATEntry2."Tax Jurisdiction Code");
                                SalesVATAccount := TaxJurisdiction.GetSalesAccount(false);
                                SalesVATUnrealAccount := TaxJurisdiction.GetSalesAccount(true);
                            end;
                    end;

                    if VATPart = 1 then begin
                        VATAmount := VATEntry2."Remaining Unrealized Amount";
                        VATBase := VATEntry2."Remaining Unrealized Base";
                        VATAmountAddCurr := VATEntry2."Add.-Curr. Rem. Unreal. Amount";
                        VATBaseAddCurr := VATEntry2."Add.-Curr. Rem. Unreal. Base";
                    end else begin
                        VATAmount := Round(VATEntry2."Remaining Unrealized Amount" * VATPart, GeneralLedgerSetup."Amount Rounding Precision");
                        VATBase := Round(VATEntry2."Remaining Unrealized Base" * VATPart, GeneralLedgerSetup."Amount Rounding Precision");
                        VATAmountAddCurr :=
                          Round(
                            VATEntry2."Add.-Curr. Rem. Unreal. Amount" * VATPart,
                            AddCurrency."Amount Rounding Precision");
                        VATBaseAddCurr :=
                          Round(
                            VATEntry2."Add.-Curr. Rem. Unreal. Base" * VATPart,
                            AddCurrency."Amount Rounding Precision");
                    end;

                    IsHandled := false;
                    OnCustUnrealizedVATOnBeforeInitGLEntryVAT(
                      GenJournalLine, VATEntry2, VATAmount, VATBase, VATAmountAddCurr, VATBaseAddCurr, IsHandled);
                    if not IsHandled then
                        InitGLEntryVAT(
                            GenJournalLine, SalesVATUnrealAccount, SalesVATAccount, -VATAmount, -VATAmountAddCurr, false);

                    lGLEntryNo :=
                      InitGLEntryVATCopy(GenJournalLine, SalesVATAccount, SalesVATUnrealAccount, VATAmount, VATAmountAddCurr, VATEntry2);

                    PostUnrealVATEntry(GenJournalLine, VATEntry2, VATAmount, VATBase, VATAmountAddCurr, VATBaseAddCurr, lGLEntryNo);
                end;
            until VATEntry2.Next() = 0;

            InsertSummarizedVAT(GenJournalLine);
        end;
    end;

    local procedure ApplyVendLedgEntry(var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GenJournalLine: Record "Gen. Journal Line"; Vendor: Record Vendor)
    var
        OldVendorLedgerEntry: Record "Vendor Ledger Entry";
        OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer";
        NewVendorLedgerEntry: Record "Vendor Ledger Entry";
        NewCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer";
        TempOldVendorLedgerEntry: Record "Vendor Ledger Entry" temporary;
        Completed: Boolean;
        AppliedAmount: Decimal;
        NewRemainingAmtBeforeAppln: Decimal;
        ApplyingDate: Date;
        PmtTolAmtToBeApplied: Decimal;
        AllApplied: Boolean;
        IsAmountToApplyCheckHandled: Boolean;
    begin
        OnBeforeApplyVendLedgEntry(NewCVLedgerEntryBuffer, DetailedCVLedgEntryBuffer, GenJournalLine, Vendor, IsAmountToApplyCheckHandled);
        if not IsAmountToApplyCheckHandled then
            if NewCVLedgerEntryBuffer."Amount to Apply" = 0 then
                exit;

        AllApplied := true;
        if (GenJournalLine."Applies-to Doc. No." = '') and (GenJournalLine."Applies-to ID" = '') and
           not
           ((Vendor."Application Method" = Vendor."Application Method"::"Apply to Oldest") and
            GenJournalLine."Allow Application")
        then
            exit;

        PmtTolAmtToBeApplied := 0;
        NewRemainingAmtBeforeAppln := NewCVLedgerEntryBuffer."Remaining Amount";
        NewCVLedgerEntryBuffer2 := NewCVLedgerEntryBuffer;

        ApplyingDate := GenJournalLine."Posting Date";

        if not PrepareTempVendLedgEntry(GenJournalLine, NewCVLedgerEntryBuffer, TempOldVendorLedgerEntry, Vendor, ApplyingDate) then
            exit;

        GenJournalLine."Posting Date" := ApplyingDate;
        // Apply the new entry (Payment) to the old entries (Invoices) one at a time
        repeat
            TempOldVendorLedgerEntry.CalcFields(
              Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)",
              "Original Amount", "Original Amt. (LCY)");
            OldCVLedgerEntryBuffer.CopyFromVendLedgEntry(TempOldVendorLedgerEntry);
            TempOldVendorLedgerEntry.CopyFilter(Positive, OldCVLedgerEntryBuffer.Positive);

            PostApply(
              GenJournalLine, DetailedCVLedgEntryBuffer, OldCVLedgerEntryBuffer, NewCVLedgerEntryBuffer, NewCVLedgerEntryBuffer2,
              Vendor."Block Payment Tolerance", AllApplied, AppliedAmount, PmtTolAmtToBeApplied);

            // Update the Old Entry
            TempOldVendorLedgerEntry.CopyFromCVLedgEntryBuffer(OldCVLedgerEntryBuffer);
            OldVendorLedgerEntry := TempOldVendorLedgerEntry;
            if GenJournalLine."Delayed Unrealized VAT" then begin
                UnrealCVLedgEntryBuffer.Init();
                UnrealCVLedgEntryBuffer."Account Type" := UnrealCVLedgEntryBuffer."Account Type"::Vendor;
                UnrealCVLedgEntryBuffer."Account No." := OldVendorLedgerEntry."Vendor No.";
                UnrealCVLedgEntryBuffer."Payment Slip No." := GenJournalLine."Document No.";
                UnrealCVLedgEntryBuffer."Applies-to ID" := OldVendorLedgerEntry."Applies-to ID";
                UnrealCVLedgEntryBuffer."Entry No." := OldVendorLedgerEntry."Entry No.";
                UnrealCVLedgEntryBuffer."Applied Amount" := AppliedAmount;
                UnrealCVLedgEntryBuffer.Insert();
            end;
            OldVendorLedgerEntry."Applies-to ID" := '';
            OldVendorLedgerEntry."Amount to Apply" := 0;
            OldVendorLedgerEntry.Modify();

            OnAfterOldVendLedgEntryModify(OldVendorLedgerEntry);

            if GeneralLedgerSetup."Unrealized VAT" or
               (GeneralLedgerSetup."Prepayment Unrealized VAT" and TempOldVendorLedgerEntry.Prepayment)
            then
                if IsNotPayment(TempOldVendorLedgerEntry."Document Type") and not GenJournalLine."Delayed Unrealized VAT" then begin
                    TempOldVendorLedgerEntry.RecalculateAmounts(
                      NewCVLedgerEntryBuffer."Currency Code", TempOldVendorLedgerEntry."Currency Code", NewCVLedgerEntryBuffer."Posting Date");
                    OnApplyVendLedgEntryOnAfterRecalculateAmounts(TempOldVendorLedgerEntry, OldVendorLedgerEntry, NewCVLedgerEntryBuffer, GenJournalLine);
                    VendUnrealizedVAT(
                      GenJournalLine,
                      TempOldVendorLedgerEntry,
                      CurrencyExchangeRate.ExchangeAmount(
                        AppliedAmount, NewCVLedgerEntryBuffer."Currency Code",
                        TempOldVendorLedgerEntry."Currency Code", NewCVLedgerEntryBuffer."Posting Date"));
                end;

            TempOldVendorLedgerEntry.Delete();

            Completed := FindNextOldVendLedgEntryToApply(GenJournalLine, TempOldVendorLedgerEntry, NewCVLedgerEntryBuffer);
        until Completed;

        DetailedCVLedgEntryBuffer.SetCurrentKey("CV Ledger Entry No.", "Entry Type");
        DetailedCVLedgEntryBuffer.SetRange("CV Ledger Entry No.", NewCVLedgerEntryBuffer."Entry No.");
        DetailedCVLedgEntryBuffer.SetRange(
          "Entry Type",
          DetailedCVLedgEntryBuffer."Entry Type"::Application);
        DetailedCVLedgEntryBuffer.CalcSums("Amount (LCY)", Amount);

        CalcCurrencyUnrealizedGainLoss(
          NewCVLedgerEntryBuffer, DetailedCVLedgEntryBuffer, GenJournalLine, DetailedCVLedgEntryBuffer.Amount, NewRemainingAmtBeforeAppln);

        CalcAmtLCYAdjustment(NewCVLedgerEntryBuffer, DetailedCVLedgEntryBuffer, GenJournalLine);

        NewCVLedgerEntryBuffer."Applies-to ID" := '';
        NewCVLedgerEntryBuffer."Amount to Apply" := 0;

        if GeneralLedgerSetup."Unrealized VAT" or
           (GeneralLedgerSetup."Prepayment Unrealized VAT" and NewCVLedgerEntryBuffer.Prepayment)
        then
            if IsNotPayment(NewCVLedgerEntryBuffer."Document Type") and
               (NewRemainingAmtBeforeAppln - NewCVLedgerEntryBuffer."Remaining Amount" <> 0) and
               not GenJournalLine."Delayed Unrealized VAT"
            then begin
                NewVendorLedgerEntry.CopyFromCVLedgEntryBuffer(NewCVLedgerEntryBuffer);
                CheckUnrealizedVend := true;
                VendorLedgerEntry := NewVendorLedgerEntry;
                VendorLedgerEntry.CalcFields("Amount (LCY)", "Original Amt. (LCY)");
                UnrealizedRemainingAmountVend := -(NewRemainingAmtBeforeAppln - NewVendorLedgerEntry."Remaining Amount");
            end;
    end;

    local procedure FindNextOldVendLedgEntryToApply(GenJournalLine: Record "Gen. Journal Line"; var TempOldVendorLedgerEntry: Record "Vendor Ledger Entry" temporary; NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer") Completed: Boolean
    var
        IsHandled: Boolean;
    begin
        OnBeforeFindNextOldVendLedgEntryToApply(GenJournalLine, TempOldVendorLedgerEntry, NewCVLedgerEntryBuffer, Completed, IsHandled);
        if IsHandled then
            exit(Completed);

        if GenJournalLine."Applies-to Doc. No." <> '' then
            Completed := true
        else
            if TempOldVendorLedgerEntry.GetFilter(Positive) <> '' then
                if TempOldVendorLedgerEntry.Next() = 1 then
                    Completed := false
                else begin
                    TempOldVendorLedgerEntry.SetRange(Positive);
                    TempOldVendorLedgerEntry.Find('-');
                    TempOldVendorLedgerEntry.CalcFields("Remaining Amount");
                    Completed := TempOldVendorLedgerEntry."Remaining Amount" * NewCVLedgerEntryBuffer."Remaining Amount" >= 0;
                end
            else
                if NewCVLedgerEntryBuffer.Open then
                    Completed := TempOldVendorLedgerEntry.Next() = 0
                else
                    Completed := true;
    end;

    local procedure ApplyEmplLedgEntry(var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GenJournalLine: Record "Gen. Journal Line"; Employee: Record Employee)
    var
        OldEmployeeLedgerEntry: Record "Employee Ledger Entry";
        OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer";
        NewCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer";
        TempOldEmployeeLedgerEntry: Record "Employee Ledger Entry" temporary;
        Completed: Boolean;
        AppliedAmount: Decimal;
        ApplyingDate: Date;
        PmtTolAmtToBeApplied: Decimal;
        AllApplied: Boolean;
    begin
        if NewCVLedgerEntryBuffer."Amount to Apply" = 0 then
            exit;

        AllApplied := true;
        if (GenJournalLine."Applies-to Doc. No." = '') and (GenJournalLine."Applies-to ID" = '') and
           not
           ((Employee."Application Method" = Employee."Application Method"::"Apply to Oldest") and
            GenJournalLine."Allow Application")
        then
            exit;

        PmtTolAmtToBeApplied := 0;
        NewCVLedgerEntryBuffer2 := NewCVLedgerEntryBuffer;

        ApplyingDate := GenJournalLine."Posting Date";

        if not PrepareTempEmplLedgEntry(GenJournalLine, NewCVLedgerEntryBuffer, TempOldEmployeeLedgerEntry, Employee, ApplyingDate) then
            exit;

        GenJournalLine."Posting Date" := ApplyingDate;

        // Apply the new entry (Payment) to the old entries one at a time
        repeat
            TempOldEmployeeLedgerEntry.CalcFields(
              Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)",
              "Original Amount", "Original Amt. (LCY)");
            OldCVLedgerEntryBuffer.CopyFromEmplLedgEntry(TempOldEmployeeLedgerEntry);
            TempOldEmployeeLedgerEntry.CopyFilter(Positive, OldCVLedgerEntryBuffer.Positive);

            PostApply(
              GenJournalLine, DetailedCVLedgEntryBuffer, OldCVLedgerEntryBuffer, NewCVLedgerEntryBuffer, NewCVLedgerEntryBuffer2,
              true, AllApplied, AppliedAmount, PmtTolAmtToBeApplied);

            // Update the Old Entry
            TempOldEmployeeLedgerEntry.CopyFromCVLedgEntryBuffer(OldCVLedgerEntryBuffer);
            OldEmployeeLedgerEntry := TempOldEmployeeLedgerEntry;
            OldEmployeeLedgerEntry."Applies-to ID" := '';
            OldEmployeeLedgerEntry."Amount to Apply" := 0;
            OldEmployeeLedgerEntry.Modify();

            TempOldEmployeeLedgerEntry.Delete();

            Completed := FindNextOldEmplLedgEntryToApply(GenJournalLine, TempOldEmployeeLedgerEntry, NewCVLedgerEntryBuffer);
        until Completed;

        DetailedCVLedgEntryBuffer.SetCurrentKey("CV Ledger Entry No.", "Entry Type");
        DetailedCVLedgEntryBuffer.SetRange("CV Ledger Entry No.", NewCVLedgerEntryBuffer."Entry No.");
        DetailedCVLedgEntryBuffer.SetRange(
          "Entry Type",
          DetailedCVLedgEntryBuffer."Entry Type"::Application);
        DetailedCVLedgEntryBuffer.CalcSums("Amount (LCY)", Amount);

        NewCVLedgerEntryBuffer."Applies-to ID" := '';
        NewCVLedgerEntryBuffer."Amount to Apply" := 0;
    end;

    local procedure FindNextOldEmplLedgEntryToApply(GenJournalLine: Record "Gen. Journal Line"; var TempOldEmployeeLedgerEntry: Record "Employee Ledger Entry" temporary; NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer") Completed: Boolean
    var
        IsHandled: Boolean;
    begin
        OnBeforeFindNextOldEmplLedgEntryToApply(GenJournalLine, TempOldEmployeeLedgerEntry, NewCVLedgerEntryBuffer, Completed, IsHandled);
        if IsHandled then
            exit(Completed);

        if GenJournalLine."Applies-to Doc. No." <> '' then
            Completed := true
        else
            if TempOldEmployeeLedgerEntry.GetFilter(Positive) <> '' then
                if TempOldEmployeeLedgerEntry.Next() = 1 then
                    Completed := false
                else begin
                    TempOldEmployeeLedgerEntry.SetRange(Positive);
                    TempOldEmployeeLedgerEntry.Find('-');
                    TempOldEmployeeLedgerEntry.CalcFields("Remaining Amount");
                    Completed := TempOldEmployeeLedgerEntry."Remaining Amount" * NewCVLedgerEntryBuffer."Remaining Amount" >= 0;
                end
            else
                if NewCVLedgerEntryBuffer.Open then
                    Completed := TempOldEmployeeLedgerEntry.Next() = 0
                else
                    Completed := true;
    end;

    procedure VendPostApplyVendLedgEntry(var GenJournalLinePostApply: Record "Gen. Journal Line"; var VendorLedgerEntryPostApply: Record "Vendor Ledger Entry")
    var
        Vendor: Record Vendor;
        VendorPostingGroup: Record "Vendor Posting Group";
        lVendorLedgerEntry: Record "Vendor Ledger Entry";
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        TempDetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer" temporary;
        CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer";
        GenJournalLine: Record "Gen. Journal Line";
        DtldLedgEntryInserted: Boolean;
    begin
        GenJournalLine := GenJournalLinePostApply;
        lVendorLedgerEntry.TransferFields(VendorLedgerEntryPostApply);
        GenJournalLine."Source Currency Code" := VendorLedgerEntryPostApply."Currency Code";
        GenJournalLine."Applies-to ID" := VendorLedgerEntryPostApply."Applies-to ID";

        GenJnlCheckLine.RunCheck(GenJournalLine);

        if NextEntryNo = 0 then
            StartPosting(GenJournalLine)
        else
            ContinuePosting(GenJournalLine);

        Vendor.Get(lVendorLedgerEntry."Vendor No.");
        Vendor.CheckBlockedVendOnJnls(Vendor, GenJournalLine."Document Type", true);

        OnVendPostApplyVendLedgEntryOnBeforeCheckPostingGroup(GenJournalLine, Vendor);
        if GenJournalLine."Posting Group" = '' then begin
            Vendor.TestField("Vendor Posting Group");
            GenJournalLine."Posting Group" := Vendor."Vendor Posting Group";
        end;
        VendorPostingGroup.Get(GenJournalLine."Posting Group");
        VendorPostingGroup.GetPayablesAccount();

        DetailedVendorLedgEntry.LockTable();
        lVendorLedgerEntry.LockTable();

        // Post the application
        lVendorLedgerEntry.CalcFields(
          Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)",
          "Original Amount", "Original Amt. (LCY)");
        CVLedgerEntryBuffer.CopyFromVendLedgEntry(lVendorLedgerEntry);
        ApplyVendLedgEntry(
          CVLedgerEntryBuffer, TempDetailedCVLedgEntryBuffer, GenJournalLine, Vendor);
        lVendorLedgerEntry.CopyFromCVLedgEntryBuffer(CVLedgerEntryBuffer);
        lVendorLedgerEntry.Modify(true);

        // Post Dtld vendor entry
        DtldLedgEntryInserted := PostDtldVendLedgEntries(GenJournalLine, TempDetailedCVLedgEntryBuffer, VendorPostingGroup, false);

        CheckPostUnrealizedVAT(GenJournalLine, true);

        if DtldLedgEntryInserted then
            if IsTempGLEntryBufEmpty() then
                DetailedVendorLedgEntry.SetZeroTransNo(NextTransactionNo);

        OnVendPostApplyVendLedgEntryOnBeforeFinishPosting(GenJournalLine, lVendorLedgerEntry);

        FinishPosting(GenJournalLine);
    end;

    procedure EmplPostApplyEmplLedgEntry(var GenJournalLinePostApply: Record "Gen. Journal Line"; var EmployeeLedgerEntryPostApply: Record "Employee Ledger Entry")
    var
        Employee: Record Employee;
        EmployeePostingGroup: Record "Employee Posting Group";
        EmployeeLedgerEntry: Record "Employee Ledger Entry";
        DetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry";
        TempDetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer" temporary;
        CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer";
        GenJournalLine: Record "Gen. Journal Line";
        DtldLedgEntryInserted: Boolean;
    begin
        GenJournalLine := GenJournalLinePostApply;
        EmployeeLedgerEntry.TransferFields(EmployeeLedgerEntryPostApply);
        GenJournalLine."Source Currency Code" := EmployeeLedgerEntryPostApply."Currency Code";
        GenJournalLine."Applies-to ID" := EmployeeLedgerEntryPostApply."Applies-to ID";

        GenJnlCheckLine.RunCheck(GenJournalLine);

        if NextEntryNo = 0 then
            StartPosting(GenJournalLine)
        else
            ContinuePosting(GenJournalLine);

        Employee.Get(EmployeeLedgerEntry."Employee No.");

        if GenJournalLine."Posting Group" = '' then begin
            Employee.TestField("Employee Posting Group");
            GenJournalLine."Posting Group" := Employee."Employee Posting Group";
        end;
        EmployeePostingGroup.Get(GenJournalLine."Posting Group");
        EmployeePostingGroup.GetPayablesAccount();

        DetailedEmployeeLedgerEntry.LockTable();
        EmployeeLedgerEntry.LockTable();

        // Post the application
        EmployeeLedgerEntry.CalcFields(
          Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)",
          "Original Amount", "Original Amt. (LCY)");
        CVLedgerEntryBuffer.CopyFromEmplLedgEntry(EmployeeLedgerEntry);
        ApplyEmplLedgEntry(
          CVLedgerEntryBuffer, TempDetailedCVLedgEntryBuffer, GenJournalLine, Employee);
        EmployeeLedgerEntry.CopyFromCVLedgEntryBuffer(CVLedgerEntryBuffer);
        EmployeeLedgerEntry.Modify(true);

        // Post Dtld vendor entry
        DtldLedgEntryInserted := PostDtldEmplLedgEntries(GenJournalLine, TempDetailedCVLedgEntryBuffer, EmployeePostingGroup, false);

        CheckPostUnrealizedVAT(GenJournalLine, true);

        if DtldLedgEntryInserted then
            if IsTempGLEntryBufEmpty() then
                DetailedEmployeeLedgerEntry.SetZeroTransNo(NextTransactionNo);

        FinishPosting(GenJournalLine);
    end;

    local procedure PrepareTempVendLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var TempOldVendorLedgerEntry: Record "Vendor Ledger Entry" temporary; Vendor: Record Vendor; var ApplyingDate: Date): Boolean
    var
        OldVendorLedgerEntry: Record "Vendor Ledger Entry";
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        RemainingAmount: Decimal;
    begin
        OnBeforePrepareTempVendLedgEntry(GenJournalLine, NewCVLedgerEntryBuffer);

        if GenJournalLine."Applies-to Doc. No." <> '' then begin
            // Find the entry to be applied to
            OldVendorLedgerEntry.Reset();
            OldVendorLedgerEntry.SetCurrentKey("Document No.");
            OldVendorLedgerEntry.SetRange("Document No.", GenJournalLine."Applies-to Doc. No.");
            OldVendorLedgerEntry.SetRange("Document Type", GenJournalLine."Applies-to Doc. Type");
            OldVendorLedgerEntry.SetRange("Vendor No.", NewCVLedgerEntryBuffer."CV No.");
            OldVendorLedgerEntry.SetRange(Open, true);
            OnPrepareTempVendLedgEntryOnAfterSetFilters(OldVendorLedgerEntry, GenJournalLine, NewCVLedgerEntryBuffer);
            OldVendorLedgerEntry.FindFirst();
            OldVendorLedgerEntry.TestField(Positive, not NewCVLedgerEntryBuffer.Positive);
            if OldVendorLedgerEntry."Posting Date" > ApplyingDate then
                ApplyingDate := OldVendorLedgerEntry."Posting Date";
            GenJnlApply.CheckAgainstApplnCurrency(
              NewCVLedgerEntryBuffer."Currency Code", OldVendorLedgerEntry."Currency Code", GenJournalLine."Account Type"::Vendor, true);
            TempOldVendorLedgerEntry := OldVendorLedgerEntry;
            OnPrepareTempVendLedgEntryOnBeforeTempOldVendLedgEntryInsert(TempOldVendorLedgerEntry, GenJournalLine);
            TempOldVendorLedgerEntry.Insert();
        end else begin
            // Find the first old entry (Invoice) which the new entry (Payment) should apply to
            OldVendorLedgerEntry.Reset();
            OldVendorLedgerEntry.SetCurrentKey("Vendor No.", "Applies-to ID", Open, Positive, "Due Date");
            TempOldVendorLedgerEntry.SetCurrentKey("Vendor No.", "Applies-to ID", Open, Positive, "Due Date");
            OldVendorLedgerEntry.SetRange("Vendor No.", NewCVLedgerEntryBuffer."CV No.");
            OldVendorLedgerEntry.SetRange("Applies-to ID", GenJournalLine."Applies-to ID");
            OldVendorLedgerEntry.SetRange(Open, true);
            OldVendorLedgerEntry.SetFilter("Entry No.", '<>%1', NewCVLedgerEntryBuffer."Entry No.");
            if not (Vendor."Application Method" = Vendor."Application Method"::"Apply to Oldest") then
                OldVendorLedgerEntry.SetFilter("Amount to Apply", '<>%1', 0);

            if Vendor."Application Method" = Vendor."Application Method"::"Apply to Oldest" then
                OldVendorLedgerEntry.SetFilter("Posting Date", '..%1', GenJournalLine."Posting Date");

            // Check and Move Ledger Entries to Temp
            PurchasesPayablesSetup.Get();
            if PurchasesPayablesSetup."Appln. between Currencies" = PurchasesPayablesSetup."Appln. between Currencies"::None then
                OldVendorLedgerEntry.SetRange("Currency Code", NewCVLedgerEntryBuffer."Currency Code");
            if OldVendorLedgerEntry.FindSet() then
                repeat
                    if GenJnlApply.CheckAgainstApplnCurrency(
                         NewCVLedgerEntryBuffer."Currency Code", OldVendorLedgerEntry."Currency Code", GenJournalLine."Account Type"::Vendor, false)
                    then begin
                        if (OldVendorLedgerEntry."Posting Date" > ApplyingDate) and (OldVendorLedgerEntry."Applies-to ID" <> '') then
                            ApplyingDate := OldVendorLedgerEntry."Posting Date";
                        TempOldVendorLedgerEntry := OldVendorLedgerEntry;
                        OnPrepareTempVendLedgEntryOnBeforeTempOldVendLedgEntryInsert(TempOldVendorLedgerEntry, GenJournalLine);
                        TempOldVendorLedgerEntry.Insert();
                    end;
                until OldVendorLedgerEntry.Next() = 0;

            TempOldVendorLedgerEntry.SetRange(Positive, NewCVLedgerEntryBuffer."Remaining Amount" > 0);

            if TempOldVendorLedgerEntry.Find('-') then begin
                RemainingAmount := NewCVLedgerEntryBuffer."Remaining Amount";
                TempOldVendorLedgerEntry.SetRange(Positive);
                TempOldVendorLedgerEntry.Find('-');
                repeat
                    TempOldVendorLedgerEntry.CalcFields("Remaining Amount");
                    TempOldVendorLedgerEntry.RecalculateAmounts(
                      TempOldVendorLedgerEntry."Currency Code", NewCVLedgerEntryBuffer."Currency Code", NewCVLedgerEntryBuffer."Posting Date");
                    if PaymentToleranceManagement.CheckCalcPmtDiscCVVend(NewCVLedgerEntryBuffer, TempOldVendorLedgerEntry, 0, false, false) then
                        TempOldVendorLedgerEntry."Remaining Amount" -= TempOldVendorLedgerEntry."Remaining Pmt. Disc. Possible";
                    RemainingAmount += TempOldVendorLedgerEntry."Remaining Amount";
                until TempOldVendorLedgerEntry.Next() = 0;
                TempOldVendorLedgerEntry.SetRange(Positive, RemainingAmount < 0);
            end else
                TempOldVendorLedgerEntry.SetRange(Positive);

            OnPrepareTempVendLedgEntryOnBeforeExit(GenJournalLine, NewCVLedgerEntryBuffer, TempOldVendorLedgerEntry);
            exit(TempOldVendorLedgerEntry.Find('-'));
        end;
        exit(true);
    end;

    local procedure PrepareTempEmplLedgEntry(GenJournalLine: Record "Gen. Journal Line"; var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var TempOldEmployeeLedgerEntry: Record "Employee Ledger Entry" temporary; Employee: Record Employee; var ApplyingDate: Date): Boolean
    var
        OldEmployeeLedgerEntry: Record "Employee Ledger Entry";
        RemainingAmount: Decimal;
    begin
        if GenJournalLine."Applies-to Doc. No." <> '' then begin
            // Find the entry to be applied to
            OldEmployeeLedgerEntry.Reset();
            OldEmployeeLedgerEntry.SetCurrentKey("Document No.");
            OldEmployeeLedgerEntry.SetRange("Document Type", GenJournalLine."Applies-to Doc. Type");
            OldEmployeeLedgerEntry.SetRange("Document No.", GenJournalLine."Applies-to Doc. No.");
            OldEmployeeLedgerEntry.SetRange("Employee No.", NewCVLedgerEntryBuffer."CV No.");
            OldEmployeeLedgerEntry.SetRange(Open, true);
            OldEmployeeLedgerEntry.FindFirst();
            OldEmployeeLedgerEntry.TestField(Positive, not NewCVLedgerEntryBuffer.Positive);
            if OldEmployeeLedgerEntry."Posting Date" > ApplyingDate then
                ApplyingDate := OldEmployeeLedgerEntry."Posting Date";
            TempOldEmployeeLedgerEntry := OldEmployeeLedgerEntry;
            TempOldEmployeeLedgerEntry.Insert();
        end else begin
            // Find the first old entry which the new entry (Payment) should apply to
            OldEmployeeLedgerEntry.Reset();
            OldEmployeeLedgerEntry.SetCurrentKey("Employee No.", "Applies-to ID", Open, Positive);
            TempOldEmployeeLedgerEntry.SetCurrentKey("Employee No.", "Applies-to ID", Open, Positive);
            OldEmployeeLedgerEntry.SetRange("Employee No.", NewCVLedgerEntryBuffer."CV No.");
            OldEmployeeLedgerEntry.SetRange("Applies-to ID", GenJournalLine."Applies-to ID");
            OldEmployeeLedgerEntry.SetRange(Open, true);
            OldEmployeeLedgerEntry.SetFilter("Entry No.", '<>%1', NewCVLedgerEntryBuffer."Entry No.");
            if not (Employee."Application Method" = Employee."Application Method"::"Apply to Oldest") then
                OldEmployeeLedgerEntry.SetFilter("Amount to Apply", '<>%1', 0);

            if Employee."Application Method" = Employee."Application Method"::"Apply to Oldest" then
                OldEmployeeLedgerEntry.SetFilter("Posting Date", '..%1', GenJournalLine."Posting Date");

            OldEmployeeLedgerEntry.SetRange("Currency Code", NewCVLedgerEntryBuffer."Currency Code");
            if OldEmployeeLedgerEntry.FindSet() then
                repeat
                    if (OldEmployeeLedgerEntry."Posting Date" > ApplyingDate) and (OldEmployeeLedgerEntry."Applies-to ID" <> '') then
                        ApplyingDate := OldEmployeeLedgerEntry."Posting Date";
                    TempOldEmployeeLedgerEntry := OldEmployeeLedgerEntry;
                    TempOldEmployeeLedgerEntry.Insert();
                until OldEmployeeLedgerEntry.Next() = 0;

            TempOldEmployeeLedgerEntry.SetRange(Positive, NewCVLedgerEntryBuffer."Remaining Amount" > 0);

            if TempOldEmployeeLedgerEntry.Find('-') then begin
                RemainingAmount := NewCVLedgerEntryBuffer."Remaining Amount";
                TempOldEmployeeLedgerEntry.SetRange(Positive);
                TempOldEmployeeLedgerEntry.Find('-');
                repeat
                    TempOldEmployeeLedgerEntry.CalcFields("Remaining Amount");
                    RemainingAmount += TempOldEmployeeLedgerEntry."Remaining Amount";
                until TempOldEmployeeLedgerEntry.Next() = 0;
                TempOldEmployeeLedgerEntry.SetRange(Positive, RemainingAmount < 0);
            end else
                TempOldEmployeeLedgerEntry.SetRange(Positive);
            exit(TempOldEmployeeLedgerEntry.Find('-'));
        end;
        exit(true);
    end;

    local procedure PostDtldVendLedgEntries(GenJournalLine: Record "Gen. Journal Line"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; VendorPostingGroup: Record "Vendor Posting Group"; LedgEntryInserted: Boolean) DtldLedgEntryInserted: Boolean
    var
#pragma warning disable AL0432
        TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary;
#pragma warning restore AL0432
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        AdjAmount: array[4] of Decimal;
        DtldVendLedgEntryNoOffset: Integer;
        SaveEntryNo: Integer;
    begin
        if GenJournalLine."Account Type" <> GenJournalLine."Account Type"::Vendor then
            exit;

        if DetailedVendorLedgEntry.FindLast() then
            DtldVendLedgEntryNoOffset := DetailedVendorLedgEntry."Entry No."
        else
            DtldVendLedgEntryNoOffset := 0;

        DetailedCVLedgEntryBuffer.Reset();
        if DetailedCVLedgEntryBuffer.FindSet() then begin
            if LedgEntryInserted then begin
                SaveEntryNo := NextEntryNo;
                NextEntryNo := NextEntryNo + 1;
            end;
            repeat
                InsertDtldVendLedgEntry(GenJournalLine, DetailedCVLedgEntryBuffer, DetailedVendorLedgEntry, DtldVendLedgEntryNoOffset);
                UpdateTotalAmounts(TempInvoicePostBuffer, GenJournalLine."Dimension Set ID", DetailedCVLedgEntryBuffer);
                if ((DetailedCVLedgEntryBuffer."Amount (LCY)" <> 0) or
                    (DetailedCVLedgEntryBuffer."VAT Amount (LCY)" <> 0)) or
                   ((AddCurrencyCode <> '') and (DetailedCVLedgEntryBuffer."Additional-Currency Amount" <> 0))
                then
                    PostDtldVendLedgEntry(GenJournalLine, DetailedCVLedgEntryBuffer, VendorPostingGroup, AdjAmount);
            until DetailedCVLedgEntryBuffer.Next() = 0;
        end;

        CreateGLEntriesForTotalAmounts(
          GenJournalLine, TempInvoicePostBuffer, AdjAmount, SaveEntryNo, VendorPostingGroup.GetPayablesAccount(), LedgEntryInserted);

        DtldLedgEntryInserted := not DetailedCVLedgEntryBuffer.IsEmpty();
        DetailedCVLedgEntryBuffer.DeleteAll();
    end;

    local procedure PostDtldVendLedgEntry(GenJournalLine: Record "Gen. Journal Line"; DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; VendorPostingGroup: Record "Vendor Posting Group"; var AdjAmount: array[4] of Decimal)
    var
        AccNo: Code[20];
    begin
        AccNo := GetDtldVendLedgEntryAccNo(GenJournalLine, DetailedCVLedgEntryBuffer, VendorPostingGroup, 0, false);
        PostDtldCVLedgEntry(GenJournalLine, DetailedCVLedgEntryBuffer, AccNo, AdjAmount, false);
    end;

    local procedure PostDtldVendLedgEntryUnapply(GenJournalLine: Record "Gen. Journal Line"; DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; VendorPostingGroup: Record "Vendor Posting Group"; OriginalTransactionNo: Integer)
    var
        AccNo: Code[20];
        AdjAmount: array[4] of Decimal;
    begin
        if (DetailedCVLedgEntryBuffer."Amount (LCY)" = 0) and
           (DetailedCVLedgEntryBuffer."VAT Amount (LCY)" = 0) and
           ((AddCurrencyCode = '') or (DetailedCVLedgEntryBuffer."Additional-Currency Amount" = 0))
        then
            exit;

        AccNo := GetDtldVendLedgEntryAccNo(GenJournalLine, DetailedCVLedgEntryBuffer, VendorPostingGroup, OriginalTransactionNo, true);
        DetailedCVLedgEntryBuffer."Gen. Posting Type" := DetailedCVLedgEntryBuffer."Gen. Posting Type"::Purchase;
        PostDtldCVLedgEntry(GenJournalLine, DetailedCVLedgEntryBuffer, AccNo, AdjAmount, true);
    end;

    local procedure GetDtldVendLedgEntryAccNo(GenJournalLine: Record "Gen. Journal Line"; DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; VendorPostingGroup: Record "Vendor Posting Group"; OriginalTransactionNo: Integer; Unapply: Boolean): Code[20]
    var
        Currency: Record Currency;
        GeneralPostingSetup: Record "General Posting Setup";
        AmountCondition: Boolean;
    begin
        OnBeforeGetDtldVendLedgEntryAccNo(GenJournalLine, DetailedCVLedgEntryBuffer, VendorPostingGroup, OriginalTransactionNo, Unapply);

        AmountCondition := IsDebitAmount(DetailedCVLedgEntryBuffer, Unapply);
        case DetailedCVLedgEntryBuffer."Entry Type" of
            DetailedCVLedgEntryBuffer."Entry Type"::"Initial Entry":
                ;
            DetailedCVLedgEntryBuffer."Entry Type"::Application:
                ;
            DetailedCVLedgEntryBuffer."Entry Type"::"Unrealized Loss",
            DetailedCVLedgEntryBuffer."Entry Type"::"Unrealized Gain",
            DetailedCVLedgEntryBuffer."Entry Type"::"Realized Loss",
            DetailedCVLedgEntryBuffer."Entry Type"::"Realized Gain":
                begin
                    GetCurrency(Currency, DetailedCVLedgEntryBuffer."Currency Code");
                    CheckNonAddCurrCodeOccurred(Currency.Code);
                    exit(Currency.GetGainLossAccount(DetailedCVLedgEntryBuffer));
                end;
            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount":
                exit(VendorPostingGroup.GetPmtDiscountAccount(AmountCondition));
            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount (VAT Excl.)":
                begin
                    GeneralPostingSetup.Get(DetailedCVLedgEntryBuffer."Gen. Bus. Posting Group", DetailedCVLedgEntryBuffer."Gen. Prod. Posting Group");
                    exit(GeneralPostingSetup.GetPurchPmtDiscountAccount(AmountCondition));
                end;
            DetailedCVLedgEntryBuffer."Entry Type"::"Appln. Rounding":
                exit(VendorPostingGroup.GetApplRoundingAccount(AmountCondition));
            DetailedCVLedgEntryBuffer."Entry Type"::"Correction of Remaining Amount":
                exit(VendorPostingGroup.GetRoundingAccount(AmountCondition));
            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount Tolerance":
                case GeneralLedgerSetup."Pmt. Disc. Tolerance Posting" of
                    GeneralLedgerSetup."Pmt. Disc. Tolerance Posting"::"Payment Tolerance Accounts":
                        exit(VendorPostingGroup.GetPmtToleranceAccount(AmountCondition));
                    GeneralLedgerSetup."Pmt. Disc. Tolerance Posting"::"Payment Discount Accounts":
                        exit(VendorPostingGroup.GetPmtDiscountAccount(AmountCondition));
                end;
            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Tolerance":
                case GeneralLedgerSetup."Payment Tolerance Posting" of
                    GeneralLedgerSetup."Payment Tolerance Posting"::"Payment Tolerance Accounts":
                        exit(VendorPostingGroup.GetPmtToleranceAccount(AmountCondition));
                    GeneralLedgerSetup."Payment Tolerance Posting"::"Payment Discount Accounts":
                        exit(VendorPostingGroup.GetPmtDiscountAccount(AmountCondition));
                end;
            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Tolerance (VAT Excl.)":
                begin
                    GeneralPostingSetup.Get(DetailedCVLedgEntryBuffer."Gen. Bus. Posting Group", DetailedCVLedgEntryBuffer."Gen. Prod. Posting Group");
                    case GeneralLedgerSetup."Payment Tolerance Posting" of
                        GeneralLedgerSetup."Payment Tolerance Posting"::"Payment Tolerance Accounts":
                            exit(GeneralPostingSetup.GetPurchPmtToleranceAccount(AmountCondition));
                        GeneralLedgerSetup."Payment Tolerance Posting"::"Payment Discount Accounts":
                            exit(GeneralPostingSetup.GetPurchPmtDiscountAccount(AmountCondition));
                    end;
                end;
            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
                begin
                    GeneralPostingSetup.Get(DetailedCVLedgEntryBuffer."Gen. Bus. Posting Group", DetailedCVLedgEntryBuffer."Gen. Prod. Posting Group");
                    case GeneralLedgerSetup."Pmt. Disc. Tolerance Posting" of
                        GeneralLedgerSetup."Pmt. Disc. Tolerance Posting"::"Payment Tolerance Accounts":
                            exit(GeneralPostingSetup.GetPurchPmtToleranceAccount(AmountCondition));
                        GeneralLedgerSetup."Pmt. Disc. Tolerance Posting"::"Payment Discount Accounts":
                            exit(GeneralPostingSetup.GetPurchPmtDiscountAccount(AmountCondition));
                    end;
                end;
            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount (VAT Adjustment)",
          DetailedCVLedgEntryBuffer."Entry Type"::"Payment Tolerance (VAT Adjustment)",
          DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)":
                if Unapply then
                    PostDtldVendVATAdjustment(GenJournalLine, DetailedCVLedgEntryBuffer, OriginalTransactionNo);
            else
                DetailedCVLedgEntryBuffer.FieldError("Entry Type");
        end;
    end;

    local procedure PostDtldEmplLedgEntries(GenJournalLine: Record "Gen. Journal Line"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; EmployeePostingGroup: Record "Employee Posting Group"; LedgEntryInserted: Boolean) DtldLedgEntryInserted: Boolean
    var
#pragma warning disable AL0432
        TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary;
#pragma warning restore AL0432
        DetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry";
        DummyAdjAmount: array[4] of Decimal;
        DtldEmplLedgEntryNoOffset: Integer;
        SaveEntryNo: Integer;
    begin
        if GenJournalLine."Account Type" <> GenJournalLine."Account Type"::Employee then
            exit;

        if DetailedEmployeeLedgerEntry.FindLast() then
            DtldEmplLedgEntryNoOffset := DetailedEmployeeLedgerEntry."Entry No."
        else
            DtldEmplLedgEntryNoOffset := 0;

        DetailedCVLedgEntryBuffer.Reset();
        if DetailedCVLedgEntryBuffer.FindSet() then begin
            if LedgEntryInserted then begin
                SaveEntryNo := NextEntryNo;
                NextEntryNo := NextEntryNo + 1;
            end;
            repeat
                InsertDtldEmplLedgEntry(GenJournalLine, DetailedCVLedgEntryBuffer, DetailedEmployeeLedgerEntry, DtldEmplLedgEntryNoOffset);
                UpdateTotalAmounts(TempInvoicePostBuffer, GenJournalLine."Dimension Set ID", DetailedCVLedgEntryBuffer);
            until DetailedCVLedgEntryBuffer.Next() = 0;
        end;

        CreateGLEntriesForTotalAmounts(
          GenJournalLine, TempInvoicePostBuffer, DummyAdjAmount, SaveEntryNo, EmployeePostingGroup.GetPayablesAccount(), LedgEntryInserted);

        DtldLedgEntryInserted := not DetailedCVLedgEntryBuffer.IsEmpty();
        DetailedCVLedgEntryBuffer.DeleteAll();
    end;

    local procedure PostDtldCVLedgEntry(GenJournalLine: Record "Gen. Journal Line"; DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; AccNo: Code[20]; var AdjAmount: array[4] of Decimal; Unapply: Boolean)
    begin
        OnBeforePostDtldCVLedgEntry(GenJournalLine, DetailedCVLedgEntryBuffer, AccNo, Unapply, AdjAmount);

        case DetailedCVLedgEntryBuffer."Entry Type" of
            DetailedCVLedgEntryBuffer."Entry Type"::"Initial Entry":
                ;
            DetailedCVLedgEntryBuffer."Entry Type"::Application:
                ;
            DetailedCVLedgEntryBuffer."Entry Type"::"Unrealized Loss",
            DetailedCVLedgEntryBuffer."Entry Type"::"Unrealized Gain",
            DetailedCVLedgEntryBuffer."Entry Type"::"Realized Loss",
            DetailedCVLedgEntryBuffer."Entry Type"::"Realized Gain":
                begin
                    OnPostDtldCVLedgEntryOnBeforeCreateGLEntryGainLoss(GenJournalLine, DetailedCVLedgEntryBuffer, Unapply, AccNo);
                    CreateGLEntryGainLoss(GenJournalLine, AccNo, -DetailedCVLedgEntryBuffer."Amount (LCY)", DetailedCVLedgEntryBuffer."Currency Code" = AddCurrencyCode);
                    if not Unapply then
                        CollectAdjustment(AdjAmount, -DetailedCVLedgEntryBuffer."Amount (LCY)", 0);
                end;
            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount",
            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Tolerance",
            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount Tolerance":
                begin
                    CreateGLEntry(GenJournalLine, AccNo, -DetailedCVLedgEntryBuffer."Amount (LCY)", -DetailedCVLedgEntryBuffer."Additional-Currency Amount", false);
                    if not Unapply then
                        CollectAdjustment(AdjAmount, -DetailedCVLedgEntryBuffer."Amount (LCY)", -DetailedCVLedgEntryBuffer."Additional-Currency Amount");
                end;
            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount (VAT Excl.)",
    DetailedCVLedgEntryBuffer."Entry Type"::"Payment Tolerance (VAT Excl.)",
    DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
                if not Unapply then
                    CreateGLEntryVATCollectAdj(
                      GenJournalLine, AccNo, -DetailedCVLedgEntryBuffer."Amount (LCY)", -DetailedCVLedgEntryBuffer."Additional-Currency Amount", -DetailedCVLedgEntryBuffer."VAT Amount (LCY)", DetailedCVLedgEntryBuffer,
                      AdjAmount)
                else
                    CreateGLEntryVAT(
                      GenJournalLine, AccNo, -DetailedCVLedgEntryBuffer."Amount (LCY)", -DetailedCVLedgEntryBuffer."Additional-Currency Amount", -DetailedCVLedgEntryBuffer."VAT Amount (LCY)", DetailedCVLedgEntryBuffer);
            DetailedCVLedgEntryBuffer."Entry Type"::"Appln. Rounding":
                if DetailedCVLedgEntryBuffer."Amount (LCY)" <> 0 then begin
                    CreateGLEntry(GenJournalLine, AccNo, -DetailedCVLedgEntryBuffer."Amount (LCY)", -DetailedCVLedgEntryBuffer."Additional-Currency Amount", true);
                    if not Unapply then
                        CollectAdjustment(AdjAmount, -DetailedCVLedgEntryBuffer."Amount (LCY)", -DetailedCVLedgEntryBuffer."Additional-Currency Amount");
                end;
            DetailedCVLedgEntryBuffer."Entry Type"::"Correction of Remaining Amount":
                if DetailedCVLedgEntryBuffer."Amount (LCY)" <> 0 then begin
                    CreateGLEntry(GenJournalLine, AccNo, -DetailedCVLedgEntryBuffer."Amount (LCY)", 0, false);
                    if not Unapply then
                        CollectAdjustment(AdjAmount, -DetailedCVLedgEntryBuffer."Amount (LCY)", 0);
                end;
            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount (VAT Adjustment)",
  DetailedCVLedgEntryBuffer."Entry Type"::"Payment Tolerance (VAT Adjustment)",
  DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)":
                ;
            else
                DetailedCVLedgEntryBuffer.FieldError("Entry Type");
        end;

        OnAfterPostDtldCVLedgEntry(GenJournalLine, DetailedCVLedgEntryBuffer, Unapply, AccNo, AdjAmount, NextEntryNo);
    end;

    local procedure PostDtldCustVATAdjustment(GenJournalLine: Record "Gen. Journal Line"; DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; OriginalTransactionNo: Integer)
    var
        VATPostingSetup: Record "VAT Posting Setup";
        TaxJurisdiction: Record "Tax Jurisdiction";
    begin
        DetailedCVLedgEntryBuffer.FindVATEntry(VATEntry, OriginalTransactionNo);

        case VATPostingSetup."VAT Calculation Type" of
            VATPostingSetup."VAT Calculation Type"::"Normal VAT",
            VATPostingSetup."VAT Calculation Type"::"Full VAT":
                begin
                    VATPostingSetup.Get(DetailedCVLedgEntryBuffer."VAT Bus. Posting Group", DetailedCVLedgEntryBuffer."VAT Prod. Posting Group");
                    VATPostingSetup.TestField("VAT Calculation Type", VATEntry."VAT Calculation Type");
                    CreateGLEntry(
                      GenJournalLine, VATPostingSetup.GetSalesAccount(false), -DetailedCVLedgEntryBuffer."Amount (LCY)", -DetailedCVLedgEntryBuffer."Additional-Currency Amount", false);
                end;
            VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                ;
            VATPostingSetup."VAT Calculation Type"::"Sales Tax":
                begin
                    DetailedCVLedgEntryBuffer.TestField("Tax Jurisdiction Code");
                    TaxJurisdiction.Get(DetailedCVLedgEntryBuffer."Tax Jurisdiction Code");
                    CreateGLEntry(
                      GenJournalLine, TaxJurisdiction.GetPurchAccount(false), -DetailedCVLedgEntryBuffer."Amount (LCY)", -DetailedCVLedgEntryBuffer."Additional-Currency Amount", false);
                end;
        end;
    end;

    local procedure PostDtldVendVATAdjustment(GenJournalLine: Record "Gen. Journal Line"; DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; OriginalTransactionNo: Integer)
    var
        VATPostingSetup: Record "VAT Posting Setup";
        TaxJurisdiction: Record "Tax Jurisdiction";
    begin
        DetailedCVLedgEntryBuffer.FindVATEntry(VATEntry, OriginalTransactionNo);

        case VATPostingSetup."VAT Calculation Type" of
            VATPostingSetup."VAT Calculation Type"::"Normal VAT",
            VATPostingSetup."VAT Calculation Type"::"Full VAT":
                begin
                    VATPostingSetup.Get(DetailedCVLedgEntryBuffer."VAT Bus. Posting Group", DetailedCVLedgEntryBuffer."VAT Prod. Posting Group");
                    VATPostingSetup.TestField("VAT Calculation Type", VATEntry."VAT Calculation Type");
                    CreateGLEntry(
                      GenJournalLine, VATPostingSetup.GetPurchAccount(false), -DetailedCVLedgEntryBuffer."Amount (LCY)", -DetailedCVLedgEntryBuffer."Additional-Currency Amount", false);
                end;
            VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                begin
                    VATPostingSetup.Get(DetailedCVLedgEntryBuffer."VAT Bus. Posting Group", DetailedCVLedgEntryBuffer."VAT Prod. Posting Group");
                    VATPostingSetup.TestField("VAT Calculation Type", VATEntry."VAT Calculation Type");
                    CreateGLEntry(
                      GenJournalLine, VATPostingSetup.GetPurchAccount(false), -DetailedCVLedgEntryBuffer."Amount (LCY)", -DetailedCVLedgEntryBuffer."Additional-Currency Amount", false);
                    CreateGLEntry(
                      GenJournalLine, VATPostingSetup.GetRevChargeAccount(false), DetailedCVLedgEntryBuffer."Amount (LCY)", DetailedCVLedgEntryBuffer."Additional-Currency Amount", false);
                end;
            VATPostingSetup."VAT Calculation Type"::"Sales Tax":
                begin
                    TaxJurisdiction.Get(DetailedCVLedgEntryBuffer."Tax Jurisdiction Code");
                    if DetailedCVLedgEntryBuffer."Use Tax" then begin
                        CreateGLEntry(
                          GenJournalLine, TaxJurisdiction.GetPurchAccount(false), -DetailedCVLedgEntryBuffer."Amount (LCY)", -DetailedCVLedgEntryBuffer."Additional-Currency Amount", false);
                        CreateGLEntry(
                          GenJournalLine, TaxJurisdiction.GetRevChargeAccount(false), DetailedCVLedgEntryBuffer."Amount (LCY)", DetailedCVLedgEntryBuffer."Additional-Currency Amount", false);
                    end else
                        CreateGLEntry(
                          GenJournalLine, TaxJurisdiction.GetPurchAccount(false), -DetailedCVLedgEntryBuffer."Amount (LCY)", -DetailedCVLedgEntryBuffer."Additional-Currency Amount", false);
                end;
        end;
    end;

    local procedure VendUnrealizedVAT(GenJournalLine: Record "Gen. Journal Line"; var VendorLedgerEntry2: Record "Vendor Ledger Entry"; SettledAmount: Decimal)
    var
        VATEntry2: Record "VAT Entry";
        TaxJurisdiction: Record "Tax Jurisdiction";
        VATPostingSetup: Record "VAT Posting Setup";
        VATPart: Decimal;
        VATAmount: Decimal;
        VATBase: Decimal;
        VATAmountAddCurr: Decimal;
        VATBaseAddCurr: Decimal;
        PaidAmount: Decimal;
        TotalUnrealVATAmountFirst: Decimal;
        TotalUnrealVATAmountLast: Decimal;
        PurchVATAccount: Code[20];
        PurchVATUnrealAccount: Code[20];
        PurchReverseAccount: Code[20];
        PurchReverseUnrealAccount: Code[20];
        LastConnectionNo: Integer;
        lGLEntryNo: Integer;
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeVendUnrealizedVAT(GenJournalLine, VendorLedgerEntry2, SettledAmount, IsHandled);
        if IsHandled then
            exit;

        VATEntry2.Reset();
        VATEntry2.SetCurrentKey("Transaction No.");
        VATEntry2.SetRange("Transaction No.", VendorLedgerEntry2."Transaction No.");
        PaidAmount := -VendorLedgerEntry2."Amount (LCY)" + VendorLedgerEntry2."Remaining Amt. (LCY)";
        if GenJournalLine."Delayed Unrealized VAT" and GenJournalLine."Realize VAT" then
            PaidAmount := CalcPaidAmount(GenJournalLine) + SettledAmount;
        if VATEntry2.FindSet() then
            repeat
                VATPostingSetup.Get(VATEntry2."VAT Bus. Posting Group", VATEntry2."VAT Prod. Posting Group");
                if VATPostingSetup."Unrealized VAT Type" in
                   [VATPostingSetup."Unrealized VAT Type"::Last, VATPostingSetup."Unrealized VAT Type"::"Last (Fully Paid)"]
                then
                    TotalUnrealVATAmountLast := TotalUnrealVATAmountLast - VATEntry2."Remaining Unrealized Amount";
                if VATPostingSetup."Unrealized VAT Type" in
                   [VATPostingSetup."Unrealized VAT Type"::First, VATPostingSetup."Unrealized VAT Type"::"First (Fully Paid)"]
                then
                    TotalUnrealVATAmountFirst := TotalUnrealVATAmountFirst - VATEntry2."Remaining Unrealized Amount";
            until VATEntry2.Next() = 0;
        if VATEntry2.FindSet() then begin
            LastConnectionNo := 0;
            repeat
                VATPostingSetup.Get(VATEntry2."VAT Bus. Posting Group", VATEntry2."VAT Prod. Posting Group");
                if LastConnectionNo <> VATEntry2."Sales Tax Connection No." then begin
                    InsertSummarizedVAT(GenJournalLine);
                    LastConnectionNo := VATEntry2."Sales Tax Connection No.";
                end;

                VATPart :=
                  VATEntry2.GetUnrealizedVATPart(
                    Round(SettledAmount / VendorLedgerEntry2.GetAdjustedCurrencyFactor()),
                    PaidAmount,
                    VendorLedgerEntry2."Amount (LCY)",
                    TotalUnrealVATAmountFirst,
                    TotalUnrealVATAmountLast,
                    GenJournalLine."Delayed Unrealized VAT",
                    GenJournalLine."Realize VAT");

                OnVendUnrealizedVATOnAfterVATPartCalculation(
                  GenJournalLine, VendorLedgerEntry2, PaidAmount, TotalUnrealVATAmountFirst, TotalUnrealVATAmountLast, SettledAmount, VATEntry2);

                if VATPart > 0 then begin
                    case VATEntry2."VAT Calculation Type" of
                        VATEntry2."VAT Calculation Type"::"Normal VAT",
                        VATEntry2."VAT Calculation Type"::"Full VAT":
                            begin
                                PurchVATAccount := VATPostingSetup.GetPurchAccount(false);
                                PurchVATUnrealAccount := VATPostingSetup.GetPurchAccount(true);
                            end;
                        VATEntry2."VAT Calculation Type"::"Reverse Charge VAT":
                            begin
                                PurchVATAccount := VATPostingSetup.GetPurchAccount(false);
                                PurchVATUnrealAccount := VATPostingSetup.GetPurchAccount(true);
                                PurchReverseAccount := VATPostingSetup.GetRevChargeAccount(false);
                                PurchReverseUnrealAccount := VATPostingSetup.GetRevChargeAccount(true);
                            end;
                        VATEntry2."VAT Calculation Type"::"Sales Tax":
                            if (VATEntry2.Type = VATEntry2.Type::Purchase) and VATEntry2."Use Tax" then begin
                                TaxJurisdiction.Get(VATEntry2."Tax Jurisdiction Code");
                                PurchVATAccount := TaxJurisdiction.GetPurchAccount(false);
                                PurchVATUnrealAccount := TaxJurisdiction.GetPurchAccount(true);
                                PurchReverseAccount := TaxJurisdiction.GetRevChargeAccount(false);
                                PurchReverseUnrealAccount := TaxJurisdiction.GetRevChargeAccount(true);
                            end else begin
                                TaxJurisdiction.Get(VATEntry2."Tax Jurisdiction Code");
                                PurchVATAccount := TaxJurisdiction.GetPurchAccount(false);
                                PurchVATUnrealAccount := TaxJurisdiction.GetPurchAccount(true);
                            end;
                    end;

                    if VATPart = 1 then begin
                        VATAmount := VATEntry2."Remaining Unrealized Amount";
                        VATBase := VATEntry2."Remaining Unrealized Base";
                        VATAmountAddCurr := VATEntry2."Add.-Curr. Rem. Unreal. Amount";
                        VATBaseAddCurr := VATEntry2."Add.-Curr. Rem. Unreal. Base";
                    end else begin
                        VATAmount := Round(VATEntry2."Remaining Unrealized Amount" * VATPart, GeneralLedgerSetup."Amount Rounding Precision");
                        VATBase := Round(VATEntry2."Remaining Unrealized Base" * VATPart, GeneralLedgerSetup."Amount Rounding Precision");
                        VATAmountAddCurr :=
                          Round(
                            VATEntry2."Add.-Curr. Rem. Unreal. Amount" * VATPart,
                            AddCurrency."Amount Rounding Precision");
                        VATBaseAddCurr :=
                          Round(
                            VATEntry2."Add.-Curr. Rem. Unreal. Base" * VATPart,
                            AddCurrency."Amount Rounding Precision");
                    end;

                    OnVendUnrealizedVATOnBeforeInitGLEntryVAT(GenJournalLine, VATEntry2, VATAmount, VATBase, VATAmountAddCurr, VATBaseAddCurr);

                    if (VATEntry2."VAT Calculation Type" = VATEntry2."VAT Calculation Type"::"Sales Tax") and
                       (VATEntry2.Type = VATEntry2.Type::Purchase) and VATEntry2."Use Tax"
                    then begin
                        InitGLEntryVAT(
                          GenJournalLine, PurchReverseUnrealAccount, PurchReverseAccount, -VATAmount, -VATAmountAddCurr, false);
                        lGLEntryNo :=
                          InitGLEntryVATCopy(
                            GenJournalLine, PurchReverseAccount, PurchReverseUnrealAccount, VATAmount, VATAmountAddCurr, VATEntry2);
                    end else begin
                        InitGLEntryVAT(
                          GenJournalLine, PurchVATUnrealAccount, PurchVATAccount, -VATAmount, -VATAmountAddCurr, false);
                        lGLEntryNo :=
                          InitGLEntryVATCopy(GenJournalLine, PurchVATAccount, PurchVATUnrealAccount, VATAmount, VATAmountAddCurr, VATEntry2);
                    end;

                    if VATEntry2."VAT Calculation Type" = VATEntry2."VAT Calculation Type"::"Reverse Charge VAT" then begin
                        InitGLEntryVAT(
                          GenJournalLine, PurchReverseUnrealAccount, PurchReverseAccount, VATAmount, VATAmountAddCurr, false);
                        lGLEntryNo :=
                          InitGLEntryVATCopy(GenJournalLine, PurchReverseAccount, PurchReverseUnrealAccount, -VATAmount, -VATAmountAddCurr, VATEntry2);
                    end;

                    PostUnrealVATEntry(GenJournalLine, VATEntry2, VATAmount, VATBase, VATAmountAddCurr, VATBaseAddCurr, lGLEntryNo);
                end;
            until VATEntry2.Next() = 0;

            InsertSummarizedVAT(GenJournalLine);
        end;
    end;

    local procedure PostUnrealVATEntry(GenJournalLine: Record "Gen. Journal Line"; var VATEntry2: Record "VAT Entry"; VATAmount: Decimal; VATBase: Decimal; VATAmountAddCurr: Decimal; VATBaseAddCurr: Decimal; pGLEntryNo: Integer)
    begin
        OnBeforePostUnrealVATEntry(GenJournalLine, VATEntry);
        VATEntry.LockTable();
        VATEntry := VATEntry2;
        VATEntry."Entry No." := NextVATEntryNo;
        VATEntry."Posting Date" := GenJournalLine."Posting Date";
        VATEntry."Document No." := GenJournalLine."Document No.";
        VATEntry."External Document No." := GenJournalLine."External Document No.";
        VATEntry."Document Type" := GenJournalLine."Document Type";
        VATEntry.Amount := VATAmount;
        VATEntry.Base := VATBase;
        VATEntry."Additional-Currency Amount" := VATAmountAddCurr;
        VATEntry."Additional-Currency Base" := VATBaseAddCurr;
        VATEntry.SetUnrealAmountsToZero();
        VATEntry."User ID" := CopyStr(UserId(), 1, 50);
        VATEntry."Source Code" := GenJournalLine."Source Code";
        VATEntry."Reason Code" := GenJournalLine."Reason Code";
        VATEntry."Closed by Entry No." := 0;
        VATEntry.Closed := false;
        VATEntry."Transaction No." := NextTransactionNo;
        VATEntry."Sales Tax Connection No." := NextConnectionNo;
        VATEntry."Unrealized VAT Entry No." := VATEntry2."Entry No.";
        VATEntry."Base Before Pmt. Disc." := VATEntry.Base;
        OnBeforeInsertPostUnrealVATEntry(VATEntry, GenJournalLine, VATEntry2);
        VATEntry.Insert(true);
        GLEntryVATEntryLink.InsertLink(pGLEntryNo + 1, NextVATEntryNo);
        NextVATEntryNo := NextVATEntryNo + 1;

        VATEntry2."Remaining Unrealized Amount" :=
          VATEntry2."Remaining Unrealized Amount" - VATEntry.Amount;
        VATEntry2."Remaining Unrealized Base" :=
          VATEntry2."Remaining Unrealized Base" - VATEntry.Base;
        VATEntry2."Add.-Curr. Rem. Unreal. Amount" :=
          VATEntry2."Add.-Curr. Rem. Unreal. Amount" - VATEntry."Additional-Currency Amount";
        VATEntry2."Add.-Curr. Rem. Unreal. Base" :=
          VATEntry2."Add.-Curr. Rem. Unreal. Base" - VATEntry."Additional-Currency Base";
        VATEntry2.Modify();
        OnAfterPostUnrealVATEntry(GenJournalLine, VATEntry2);
    end;

    local procedure PostApply(var GenJournalLine: Record "Gen. Journal Line"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var NewCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer"; BlockPaymentTolerance: Boolean; AllApplied: Boolean; var AppliedAmount: Decimal; var PmtTolAmtToBeApplied: Decimal)
    var
        OldCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer";
        OldCVLedgerEntryBuffer3: Record "CV Ledger Entry Buffer";
        OldRemainingAmtBeforeAppln: Decimal;
        ApplnRoundingPrecision: Decimal;
        AppliedAmountLCY: Decimal;
        OldAppliedAmount: Decimal;
        IsHandled: Boolean;
    begin
        OnBeforePostApply(GenJournalLine, DetailedCVLedgEntryBuffer, OldCVLedgerEntryBuffer, NewCVLedgerEntryBuffer, NewCVLedgerEntryBuffer2);

        OldRemainingAmtBeforeAppln := OldCVLedgerEntryBuffer."Remaining Amount";
        OldCVLedgerEntryBuffer3 := OldCVLedgerEntryBuffer;

        // Management of posting in multiple currencies
        OldCVLedgerEntryBuffer2 := OldCVLedgerEntryBuffer;
        OldCVLedgerEntryBuffer.CopyFilter(Positive, OldCVLedgerEntryBuffer2.Positive);
        ApplnRoundingPrecision := GetApplnRoundPrecision(NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer);

        OldCVLedgerEntryBuffer2.RecalculateAmounts(
          OldCVLedgerEntryBuffer2."Currency Code", NewCVLedgerEntryBuffer."Currency Code", NewCVLedgerEntryBuffer."Posting Date");

        OnPostApplyOnAfterRecalculateAmounts(OldCVLedgerEntryBuffer2, OldCVLedgerEntryBuffer, NewCVLedgerEntryBuffer, GenJournalLine);

        if not BlockPaymentTolerance then
            CalcPmtTolerance(
              NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2, DetailedCVLedgEntryBuffer, GenJournalLine,
              PmtTolAmtToBeApplied, NextTransactionNo, FirstNewVATEntryNo);

        CalcPmtDisc(
          NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2, DetailedCVLedgEntryBuffer, GenJournalLine,
          PmtTolAmtToBeApplied, ApplnRoundingPrecision, NextTransactionNo, FirstNewVATEntryNo);

        if not BlockPaymentTolerance then
            CalcPmtDiscTolerance(
              NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2, DetailedCVLedgEntryBuffer, GenJournalLine,
              NextTransactionNo, FirstNewVATEntryNo);

        IsHandled := false;
        OnBeforeCalcCurrencyApplnRounding(
          GenJournalLine, DetailedCVLedgEntryBuffer, OldCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2, OldCVLedgerEntryBuffer3,
          NewCVLedgerEntryBuffer, NewCVLedgerEntryBuffer2, IsHandled);
        if not IsHandled then
            CalcCurrencyApplnRounding(
              NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2, DetailedCVLedgEntryBuffer, GenJournalLine, ApplnRoundingPrecision);

        FindAmtForAppln(
          NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2,
          AppliedAmount, AppliedAmountLCY, OldAppliedAmount, ApplnRoundingPrecision);

        CalcCurrencyUnrealizedGainLoss(
          OldCVLedgerEntryBuffer, DetailedCVLedgEntryBuffer, GenJournalLine, -OldAppliedAmount, OldRemainingAmtBeforeAppln);

        CalcCurrencyRealizedGainLoss(
          NewCVLedgerEntryBuffer, DetailedCVLedgEntryBuffer, GenJournalLine, AppliedAmount, AppliedAmountLCY);

        CalcCurrencyRealizedGainLoss(
          OldCVLedgerEntryBuffer, DetailedCVLedgEntryBuffer, GenJournalLine, -OldAppliedAmount, -AppliedAmountLCY);

        CalcApplication(
          NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer, DetailedCVLedgEntryBuffer,
          GenJournalLine, AppliedAmount, AppliedAmountLCY, OldAppliedAmount,
          NewCVLedgerEntryBuffer2, OldCVLedgerEntryBuffer3, AllApplied);

        PaymentToleranceManagement.CalcRemainingPmtDisc(NewCVLedgerEntryBuffer, OldCVLedgerEntryBuffer, OldCVLedgerEntryBuffer2, GeneralLedgerSetup);

        CalcAmtLCYAdjustment(OldCVLedgerEntryBuffer, DetailedCVLedgEntryBuffer, GenJournalLine);

        OnAfterPostApply(GenJournalLine, DetailedCVLedgEntryBuffer, OldCVLedgerEntryBuffer, NewCVLedgerEntryBuffer, NewCVLedgerEntryBuffer2);
    end;

    procedure UnapplyCustLedgEntry(GenJournalLine2: Record "Gen. Journal Line"; DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    var
        Customer: Record Customer;
        CustomerPostingGroup: Record "Customer Posting Group";
        GenJournalLine: Record "Gen. Journal Line";
        DetailedCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
        NewDetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        lCustLedgerEntry: Record "Cust. Ledger Entry";
        DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer";
        lVATEntry: Record "VAT Entry";
        TempVATEntry2: Record "VAT Entry" temporary;
        CurrencyLCY: Record Currency;
#pragma warning disable AL0432
        TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary;
#pragma warning restore AL0432
        AdjAmount: array[4] of Decimal;
        NextDtldLedgEntryNo: Integer;
        UnapplyVATEntries: Boolean;
        PmtDiscTolExists: Boolean;
    begin
        GenJournalLine.TransferFields(GenJournalLine2);
        if GenJournalLine."Document Date" = 0D then
            GenJournalLine."Document Date" := GenJournalLine."Posting Date";

        if NextEntryNo = 0 then
            StartPosting(GenJournalLine)
        else
            ContinuePosting(GenJournalLine);

        ReadGLSetup(GeneralLedgerSetup);

        Customer.Get(DetailedCustLedgEntry2."Customer No.");
        Customer.CheckBlockedCustOnJnls(Customer, GenJournalLine2."Document Type"::Payment, true);

        OnUnapplyCustLedgEntryOnBeforeCheckPostingGroup(GenJournalLine, Customer);
        CustomerPostingGroup.Get(GenJournalLine."Posting Group");
        CustomerPostingGroup.GetReceivablesAccount();

        lVATEntry.LockTable();
        DetailedCustLedgEntry2.LockTable();
        lCustLedgerEntry.LockTable();

        DetailedCustLedgEntry2.TestField("Entry Type", DetailedCustLedgEntry2."Entry Type"::Application);

        DetailedCustLedgEntry2.Reset();
        DetailedCustLedgEntry2.FindLast();
        NextDtldLedgEntryNo := DetailedCustLedgEntry2."Entry No." + 1;
        if DetailedCustLedgEntry2."Transaction No." = 0 then begin
            DetailedCustLedgEntry2.SetCurrentKey("Application No.", "Customer No.", "Entry Type");
            DetailedCustLedgEntry2.SetRange("Application No.", DetailedCustLedgEntry2."Application No.");
        end else begin
            DetailedCustLedgEntry2.SetCurrentKey("Transaction No.", "Customer No.", "Entry Type");
            DetailedCustLedgEntry2.SetRange("Transaction No.", DetailedCustLedgEntry2."Transaction No.");
        end;
        DetailedCustLedgEntry2.SetRange("Customer No.", DetailedCustLedgEntry2."Customer No.");
        DetailedCustLedgEntry2.SetFilter("Entry Type", '>%1', DetailedCustLedgEntry2."Entry Type"::"Initial Entry");
        OnUnapplyCustLedgEntryOnAfterDtldCustLedgEntrySetFilters(DetailedCustLedgEntry2, DetailedCustLedgEntry2);
        if DetailedCustLedgEntry2."Transaction No." <> 0 then begin
            UnapplyVATEntries := false;
            DetailedCustLedgEntry2.FindSet();
            repeat
                DetailedCustLedgEntry2.TestField(Unapplied, false);
                if IsVATAdjustment(DetailedCustLedgEntry2."Entry Type") then
                    UnapplyVATEntries := true;
                if not GeneralLedgerSetup."Pmt. Disc. Excl. VAT" and GeneralLedgerSetup."Adjust for Payment Disc." then
                    if IsVATExcluded(DetailedCustLedgEntry2."Entry Type") then
                        UnapplyVATEntries := true;
                if DetailedCustLedgEntry2."Entry Type" = DetailedCustLedgEntry2."Entry Type"::"Payment Discount Tolerance (VAT Excl.)" then
                    PmtDiscTolExists := true;
            until DetailedCustLedgEntry2.Next() = 0;

            OnUnapplyCustLedgEntryOnBeforePostUnapply(DetailedCustLedgEntry2, DetailedCustLedgEntry2);

            PostUnapply(
              GenJournalLine, lVATEntry, lVATEntry.Type::Sale,
              DetailedCustLedgEntry2."Customer No.", DetailedCustLedgEntry2."Transaction No.", UnapplyVATEntries, TempVATEntry);

            if PmtDiscTolExists then
                ProcessTempVATEntryCust(DetailedCustLedgEntry2, TempVATEntry)
            else begin
                DetailedCustLedgEntry2.SetRange("Entry Type", DetailedCustLedgEntry2."Entry Type"::"Payment Tolerance (VAT Excl.)");
                ProcessTempVATEntryCust(DetailedCustLedgEntry2, TempVATEntry);
                DetailedCustLedgEntry2.SetRange("Entry Type", DetailedCustLedgEntry2."Entry Type"::"Payment Discount (VAT Excl.)");
                ProcessTempVATEntryCust(DetailedCustLedgEntry2, TempVATEntry);
                DetailedCustLedgEntry2.SetFilter("Entry Type", '>%1', DetailedCustLedgEntry2."Entry Type"::"Initial Entry");
            end;
        end;

        // Look one more time
        DetailedCustLedgEntry2.FindSet();
        TempInvoicePostBuffer.DeleteAll();
        repeat
            DetailedCustLedgEntry2.TestField(Unapplied, false);
            InsertDtldCustLedgEntryUnapply(GenJournalLine, NewDetailedCustLedgEntry, DetailedCustLedgEntry2, NextDtldLedgEntryNo);

            DetailedCVLedgEntryBuffer.Init();
            DetailedCVLedgEntryBuffer.TransferFields(NewDetailedCustLedgEntry);
            SetAddCurrForUnapplication(DetailedCVLedgEntryBuffer);
            CurrencyLCY.InitRoundingPrecision();

            if (DetailedCustLedgEntry2."Transaction No." <> 0) and IsVATExcluded(DetailedCustLedgEntry2."Entry Type") then begin
                UnapplyExcludedVAT(
                  TempVATEntry2, DetailedCustLedgEntry2."Transaction No.", DetailedCustLedgEntry2."VAT Bus. Posting Group",
                  DetailedCustLedgEntry2."VAT Prod. Posting Group", DetailedCustLedgEntry2."Gen. Prod. Posting Group");
                DetailedCVLedgEntryBuffer."VAT Amount (LCY)" :=
                  CalcVATAmountFromVATEntry(DetailedCVLedgEntryBuffer."Amount (LCY)", TempVATEntry2, CurrencyLCY);
            end;
            UpdateTotalAmounts(TempInvoicePostBuffer, GenJournalLine."Dimension Set ID", DetailedCVLedgEntryBuffer);

            if not (DetailedCVLedgEntryBuffer."Entry Type" in [
                                                        DetailedCVLedgEntryBuffer."Entry Type"::"Initial Entry",
                                                        DetailedCVLedgEntryBuffer."Entry Type"::Application])
            then
                CollectAdjustment(AdjAmount,
                  -DetailedCVLedgEntryBuffer."Amount (LCY)", -DetailedCVLedgEntryBuffer."Additional-Currency Amount");

            PostDtldCustLedgEntryUnapply(
              GenJournalLine, DetailedCVLedgEntryBuffer, CustomerPostingGroup, DetailedCustLedgEntry2."Transaction No.");

            DetailedCustLedgEntry2.Unapplied := true;
            DetailedCustLedgEntry2."Unapplied by Entry No." := NewDetailedCustLedgEntry."Entry No.";
            DetailedCustLedgEntry2.Modify();

            UpdateCustLedgEntry(DetailedCustLedgEntry2);
        until DetailedCustLedgEntry2.Next() = 0;

        OnBeforeCreateGLEntriesForTotalAmountsUnapply(DetailedCustLedgEntry2, CustomerPostingGroup, GenJournalLine, TempInvoicePostBuffer);
        CreateGLEntriesForTotalAmountsUnapply(GenJournalLine, TempInvoicePostBuffer, CustomerPostingGroup.GetReceivablesAccount());

        OnUnapplyCustLedgEntryOnAfterCreateGLEntriesForTotalAmounts(GenJournalLine2, DetailedCustLedgEntry2);

        if IsTempGLEntryBufEmpty() then
            DetailedCustLedgEntry2.SetZeroTransNo(NextTransactionNo);
        CheckPostUnrealizedVAT(GenJournalLine, true);

        FinishPosting(GenJournalLine);
    end;

    procedure UnapplyVendLedgEntry(GenJournalLine2: Record "Gen. Journal Line"; DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry")
    var
        Vendor: Record Vendor;
        VendorPostingGroup: Record "Vendor Posting Group";
        GenJournalLine: Record "Gen. Journal Line";
        DetailedVendorLedgEntry2: Record "Detailed Vendor Ledg. Entry";
        NewDetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        lVendorLedgerEntry: Record "Vendor Ledger Entry";
        DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer";
        lVATEntry: Record "VAT Entry";
        TempVATEntry2: Record "VAT Entry" temporary;
        CurrencyLCY: Record Currency;
#pragma warning disable AL0432
        TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary;
#pragma warning restore AL0432
        AdjAmount: array[4] of Decimal;
        NextDtldLedgEntryNo: Integer;
        UnapplyVATEntries: Boolean;
        PmtDiscTolExists: Boolean;
    begin
        GenJournalLine.TransferFields(GenJournalLine2);
        if GenJournalLine."Document Date" = 0D then
            GenJournalLine."Document Date" := GenJournalLine."Posting Date";

        if NextEntryNo = 0 then
            StartPosting(GenJournalLine)
        else
            ContinuePosting(GenJournalLine);

        ReadGLSetup(GeneralLedgerSetup);

        Vendor.Get(DetailedVendorLedgEntry."Vendor No.");
        Vendor.CheckBlockedVendOnJnls(Vendor, GenJournalLine2."Document Type"::Payment, true);

        OnUnapplyVendLedgEntryOnBeforeCheckPostingGroup(GenJournalLine, Vendor);
        VendorPostingGroup.Get(GenJournalLine."Posting Group");
        VendorPostingGroup.GetPayablesAccount();

        lVATEntry.LockTable();
        DetailedVendorLedgEntry.LockTable();
        lVendorLedgerEntry.LockTable();

        DetailedVendorLedgEntry.TestField("Entry Type", DetailedVendorLedgEntry."Entry Type"::Application);

        DetailedVendorLedgEntry2.Reset();
        DetailedVendorLedgEntry2.FindLast();
        NextDtldLedgEntryNo := DetailedVendorLedgEntry2."Entry No." + 1;
        if DetailedVendorLedgEntry."Transaction No." = 0 then begin
            DetailedVendorLedgEntry2.SetCurrentKey("Application No.", "Vendor No.", "Entry Type");
            DetailedVendorLedgEntry2.SetRange("Application No.", DetailedVendorLedgEntry."Application No.");
        end else begin
            DetailedVendorLedgEntry2.SetCurrentKey("Transaction No.", "Vendor No.", "Entry Type");
            DetailedVendorLedgEntry2.SetRange("Transaction No.", DetailedVendorLedgEntry."Transaction No.");
        end;
        DetailedVendorLedgEntry2.SetRange("Vendor No.", DetailedVendorLedgEntry."Vendor No.");
        DetailedVendorLedgEntry2.SetFilter("Entry Type", '>%1', DetailedVendorLedgEntry."Entry Type"::"Initial Entry");
        OnUnapplyVendLedgEntryOnAfterFilterSourceEntries(DetailedVendorLedgEntry, DetailedVendorLedgEntry2);
        if DetailedVendorLedgEntry."Transaction No." <> 0 then begin
            UnapplyVATEntries := false;
            DetailedVendorLedgEntry2.FindSet();
            repeat
                DetailedVendorLedgEntry2.TestField(Unapplied, false);
                if IsVATAdjustment(DetailedVendorLedgEntry2."Entry Type") then
                    UnapplyVATEntries := true;
                if not GeneralLedgerSetup."Pmt. Disc. Excl. VAT" and GeneralLedgerSetup."Adjust for Payment Disc." then
                    if IsVATExcluded(DetailedVendorLedgEntry2."Entry Type") then
                        UnapplyVATEntries := true;
                if DetailedVendorLedgEntry2."Entry Type" = DetailedVendorLedgEntry2."Entry Type"::"Payment Discount Tolerance (VAT Excl.)" then
                    PmtDiscTolExists := true;
            until DetailedVendorLedgEntry2.Next() = 0;

            OnUnapplyVendLedgEntryOnBeforePostUnapply(DetailedVendorLedgEntry, DetailedVendorLedgEntry2);

            PostUnapply(
              GenJournalLine, lVATEntry, lVATEntry.Type::Purchase,
              DetailedVendorLedgEntry."Vendor No.", DetailedVendorLedgEntry."Transaction No.", UnapplyVATEntries, TempVATEntry);

            if PmtDiscTolExists then
                ProcessTempVATEntryVend(DetailedVendorLedgEntry2, TempVATEntry)
            else begin
                DetailedVendorLedgEntry2.SetRange("Entry Type", DetailedVendorLedgEntry2."Entry Type"::"Payment Tolerance (VAT Excl.)");
                ProcessTempVATEntryVend(DetailedVendorLedgEntry2, TempVATEntry);
                DetailedVendorLedgEntry2.SetRange("Entry Type", DetailedVendorLedgEntry2."Entry Type"::"Payment Discount (VAT Excl.)");
                ProcessTempVATEntryVend(DetailedVendorLedgEntry2, TempVATEntry);
                DetailedVendorLedgEntry2.SetFilter("Entry Type", '>%1', DetailedVendorLedgEntry2."Entry Type"::"Initial Entry");
            end;
        end;

        // Look one more time
        DetailedVendorLedgEntry2.FindSet();
        TempInvoicePostBuffer.DeleteAll();
        repeat
            DetailedVendorLedgEntry2.TestField(Unapplied, false);
            InsertDtldVendLedgEntryUnapply(GenJournalLine, NewDetailedVendorLedgEntry, DetailedVendorLedgEntry2, NextDtldLedgEntryNo);

            DetailedCVLedgEntryBuffer.Init();
            DetailedCVLedgEntryBuffer.TransferFields(NewDetailedVendorLedgEntry);
            SetAddCurrForUnapplication(DetailedCVLedgEntryBuffer);
            CurrencyLCY.InitRoundingPrecision();

            if (DetailedVendorLedgEntry2."Transaction No." <> 0) and IsVATExcluded(DetailedVendorLedgEntry2."Entry Type") then begin
                UnapplyExcludedVAT(
                  TempVATEntry2, DetailedVendorLedgEntry2."Transaction No.", DetailedVendorLedgEntry2."VAT Bus. Posting Group",
                  DetailedVendorLedgEntry2."VAT Prod. Posting Group", DetailedVendorLedgEntry2."Gen. Prod. Posting Group");
                DetailedCVLedgEntryBuffer."VAT Amount (LCY)" :=
                  CalcVATAmountFromVATEntry(DetailedCVLedgEntryBuffer."Amount (LCY)", TempVATEntry2, CurrencyLCY);
            end;
            UpdateTotalAmounts(TempInvoicePostBuffer, GenJournalLine."Dimension Set ID", DetailedCVLedgEntryBuffer);

            if not (DetailedCVLedgEntryBuffer."Entry Type" in [
                                                        DetailedCVLedgEntryBuffer."Entry Type"::"Initial Entry",
                                                        DetailedCVLedgEntryBuffer."Entry Type"::Application])
            then
                CollectAdjustment(AdjAmount,
                  -DetailedCVLedgEntryBuffer."Amount (LCY)", -DetailedCVLedgEntryBuffer."Additional-Currency Amount");

            PostDtldVendLedgEntryUnapply(
              GenJournalLine, DetailedCVLedgEntryBuffer, VendorPostingGroup, DetailedVendorLedgEntry2."Transaction No.");

            DetailedVendorLedgEntry2.Unapplied := true;
            DetailedVendorLedgEntry2."Unapplied by Entry No." := NewDetailedVendorLedgEntry."Entry No.";
            DetailedVendorLedgEntry2.Modify();

            UpdateVendLedgEntry(DetailedVendorLedgEntry2);
        until DetailedVendorLedgEntry2.Next() = 0;

        OnBeforeCreateGLEntriesForTotalAmountsUnapplyVendor(DetailedVendorLedgEntry, VendorPostingGroup, GenJournalLine, TempInvoicePostBuffer);
        CreateGLEntriesForTotalAmountsUnapply(GenJournalLine, TempInvoicePostBuffer, VendorPostingGroup.GetPayablesAccount());

        OnUnapplyVendLedgEntryOnAfterCreateGLEntriesForTotalAmounts(GenJournalLine2, DetailedVendorLedgEntry);

        if IsTempGLEntryBufEmpty() then
            DetailedVendorLedgEntry.SetZeroTransNo(NextTransactionNo);
        CheckPostUnrealizedVAT(GenJournalLine, true);

        FinishPosting(GenJournalLine);
    end;

    procedure UnapplyEmplLedgEntry(GenJournalLine2: Record "Gen. Journal Line"; DetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry")
    var
        Employee: Record Employee;
        EmployeePostingGroup: Record "Employee Posting Group";
        GenJournalLine: Record "Gen. Journal Line";
        DetailedEmployeeLedgerEntry2: Record "Detailed Employee Ledger Entry";
        NewDetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry";
        EmployeeLedgerEntry: Record "Employee Ledger Entry";
        DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer";
        CurrencyLCY: Record Currency;
#pragma warning disable AL0432
        TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary;
#pragma warning restore AL0432
        NextDtldLedgEntryNo: Integer;
    begin
        GenJournalLine.TransferFields(GenJournalLine2);
        if GenJournalLine."Document Date" = 0D then
            GenJournalLine."Document Date" := GenJournalLine."Posting Date";

        if NextEntryNo = 0 then
            StartPosting(GenJournalLine)
        else
            ContinuePosting(GenJournalLine);

        ReadGLSetup(GeneralLedgerSetup);

        Employee.Get(DetailedEmployeeLedgerEntry."Employee No.");
        Employee.CheckBlockedEmployeeOnJnls(true);
        EmployeePostingGroup.Get(GenJournalLine."Posting Group");
        EmployeePostingGroup.GetPayablesAccount();

        DetailedEmployeeLedgerEntry.LockTable();
        EmployeeLedgerEntry.LockTable();

        DetailedEmployeeLedgerEntry.TestField("Entry Type", DetailedEmployeeLedgerEntry."Entry Type"::Application);

        DetailedEmployeeLedgerEntry2.Reset();
        DetailedEmployeeLedgerEntry2.FindLast();
        NextDtldLedgEntryNo := DetailedEmployeeLedgerEntry2."Entry No." + 1;
        if DetailedEmployeeLedgerEntry."Transaction No." = 0 then begin
            DetailedEmployeeLedgerEntry2.SetCurrentKey("Application No.", "Employee No.", "Entry Type");
            DetailedEmployeeLedgerEntry2.SetRange("Application No.", DetailedEmployeeLedgerEntry."Application No.");
        end else begin
            DetailedEmployeeLedgerEntry2.SetCurrentKey("Transaction No.", "Employee No.", "Entry Type");
            DetailedEmployeeLedgerEntry2.SetRange("Transaction No.", DetailedEmployeeLedgerEntry."Transaction No.");
        end;
        DetailedEmployeeLedgerEntry2.SetRange("Employee No.", DetailedEmployeeLedgerEntry."Employee No.");
        DetailedEmployeeLedgerEntry2.SetFilter("Entry Type", '>%1', DetailedEmployeeLedgerEntry."Entry Type"::"Initial Entry");

        // Look one more time
        DetailedEmployeeLedgerEntry2.FindSet();
        TempInvoicePostBuffer.DeleteAll();
        repeat
            DetailedEmployeeLedgerEntry2.TestField(Unapplied, false);
            InsertDtldEmplLedgEntryUnapply(GenJournalLine, NewDetailedEmployeeLedgerEntry, DetailedEmployeeLedgerEntry2, NextDtldLedgEntryNo);

            DetailedCVLedgEntryBuffer.Init();
            DetailedCVLedgEntryBuffer.TransferFields(NewDetailedEmployeeLedgerEntry);
            SetAddCurrForUnapplication(DetailedCVLedgEntryBuffer);
            CurrencyLCY.InitRoundingPrecision();
            UpdateTotalAmounts(TempInvoicePostBuffer, GenJournalLine."Dimension Set ID", DetailedCVLedgEntryBuffer);
            DetailedEmployeeLedgerEntry2.Unapplied := true;
            DetailedEmployeeLedgerEntry2."Unapplied by Entry No." := NewDetailedEmployeeLedgerEntry."Entry No.";
            DetailedEmployeeLedgerEntry2.Modify();

            UpdateEmplLedgEntry(DetailedEmployeeLedgerEntry2);
        until DetailedEmployeeLedgerEntry2.Next() = 0;

        CreateGLEntriesForTotalAmountsUnapply(GenJournalLine, TempInvoicePostBuffer, EmployeePostingGroup.GetPayablesAccount());

        if IsTempGLEntryBufEmpty() then
            DetailedEmployeeLedgerEntry.SetZeroTransNo(NextTransactionNo);

        FinishPosting(GenJournalLine);
    end;

    local procedure UnapplyExcludedVAT(var pTempVATEntry: Record "VAT Entry" temporary; TransactionNo: Integer; VATBusPostingGroup: Code[20]; VATProdPostingGroup: Code[20]; GenProdPostingGroup: Code[20])
    begin
        pTempVATEntry.SetRange("VAT Bus. Posting Group", VATBusPostingGroup);
        pTempVATEntry.SetRange("VAT Prod. Posting Group", VATProdPostingGroup);
        pTempVATEntry.SetRange("Gen. Prod. Posting Group", GenProdPostingGroup);
        if not pTempVATEntry.FindFirst() then begin
            pTempVATEntry.Reset();
            if pTempVATEntry.FindLast() then
                pTempVATEntry."Entry No." := pTempVATEntry."Entry No." + 1
            else
                pTempVATEntry."Entry No." := 1;
            pTempVATEntry.Init();
            pTempVATEntry."VAT Bus. Posting Group" := VATBusPostingGroup;
            pTempVATEntry."VAT Prod. Posting Group" := VATProdPostingGroup;
            pTempVATEntry."Gen. Prod. Posting Group" := GenProdPostingGroup;
            VATEntry.SetCurrentKey("Transaction No.");
            VATEntry.SetRange("Transaction No.", TransactionNo);
            VATEntry.SetRange("VAT Bus. Posting Group", VATBusPostingGroup);
            VATEntry.SetRange("VAT Prod. Posting Group", VATProdPostingGroup);
            VATEntry.SetRange("Gen. Prod. Posting Group", GenProdPostingGroup);
            if VATEntry.FindSet() then
                repeat
                    if VATEntry."Unrealized VAT Entry No." = 0 then begin
                        pTempVATEntry.Base := pTempVATEntry.Base + VATEntry.Base;
                        pTempVATEntry.Amount := pTempVATEntry.Amount + VATEntry.Amount;
                    end;
                until VATEntry.Next() = 0;
            Clear(VATEntry);
            pTempVATEntry.Insert();
        end;
    end;

    local procedure PostUnrealVATByUnapply(GenJournalLine: Record "Gen. Journal Line"; VATPostingSetup: Record "VAT Posting Setup"; pVATEntry: Record "VAT Entry"; NewVATEntry: Record "VAT Entry"): Integer
    var
        VATEntry2: Record "VAT Entry";
        AmountAddCurr: Decimal;
        GLEntryNoFromVAT: Integer;
    begin
        AmountAddCurr := CalcAddCurrForUnapplication(pVATEntry."Posting Date", pVATEntry.Amount);
        CreateGLEntry(
          GenJournalLine, GetPostingAccountNo(VATPostingSetup, pVATEntry, true), pVATEntry.Amount, AmountAddCurr, false);
        GLEntryNoFromVAT :=
          CreateGLEntryFromVATEntry(
            GenJournalLine, GetPostingAccountNo(VATPostingSetup, pVATEntry, false), -pVATEntry.Amount, -AmountAddCurr, pVATEntry);

        VATEntry2.Get(pVATEntry."Unrealized VAT Entry No.");
        VATEntry2."Remaining Unrealized Amount" := VATEntry2."Remaining Unrealized Amount" - NewVATEntry.Amount;
        VATEntry2."Remaining Unrealized Base" := VATEntry2."Remaining Unrealized Base" - NewVATEntry.Base;
        VATEntry2."Add.-Curr. Rem. Unreal. Amount" :=
          VATEntry2."Add.-Curr. Rem. Unreal. Amount" - NewVATEntry."Additional-Currency Amount";
        VATEntry2."Add.-Curr. Rem. Unreal. Base" :=
          VATEntry2."Add.-Curr. Rem. Unreal. Base" - NewVATEntry."Additional-Currency Base";
        VATEntry2.Modify();

        exit(GLEntryNoFromVAT);
    end;

    local procedure PostPmtDiscountVATByUnapply(GenJournalLine: Record "Gen. Journal Line"; ReverseChargeVATAccNo: Code[20]; VATAccNo: Code[20]; pVATEntry: Record "VAT Entry")
    var
        AmountAddCurr: Decimal;
    begin
        OnBeforePostPmtDiscountVATByUnapply(GenJournalLine, pVATEntry);

        AmountAddCurr := CalcAddCurrForUnapplication(pVATEntry."Posting Date", pVATEntry.Amount);
        CreateGLEntry(GenJournalLine, ReverseChargeVATAccNo, pVATEntry.Amount, AmountAddCurr, false);
        CreateGLEntry(GenJournalLine, VATAccNo, -pVATEntry.Amount, -AmountAddCurr, false);

        OnAfterPostPmtDiscountVATByUnapply(GenJournalLine, pVATEntry);
    end;

    local procedure PostUnapply(GenJournalLine: Record "Gen. Journal Line"; var pVATEntry: Record "VAT Entry"; VATEntryType: Enum "General Posting Type"; BilltoPaytoNo: Code[20]; TransactionNo: Integer; UnapplyVATEntries: Boolean; var pTempVATEntry: Record "VAT Entry" temporary)
    var
        VATPostingSetup: Record "VAT Posting Setup";
        VATEntry2: Record "VAT Entry";
        lGLEntryVATEntryLink: Record "G/L Entry - VAT Entry Link";
        AccNo: Code[20];
        TempVATEntryNo: Integer;
        GLEntryNoFromVAT: Integer;
    begin
        TempVATEntryNo := 1;
        pVATEntry.SetCurrentKey(Type, "Bill-to/Pay-to No.", "Transaction No.");
        pVATEntry.SetRange(Type, VATEntryType);
        pVATEntry.SetRange("Bill-to/Pay-to No.", BilltoPaytoNo);
        pVATEntry.SetRange("Transaction No.", TransactionNo);
        OnPostUnapplyOnAfterVATEntrySetFilters(pVATEntry, GenJournalLine);
        if pVATEntry.FindSet() then
            repeat
                VATPostingSetup.Get(pVATEntry."VAT Bus. Posting Group", pVATEntry."VAT Prod. Posting Group");
                OnPostUnapplyOnBeforeUnapplyVATEntry(pVATEntry, UnapplyVATEntries);
                if UnapplyVATEntries or (pVATEntry."Unrealized VAT Entry No." <> 0) then begin
                    InsertTempVATEntry(GenJournalLine, pVATEntry, TempVATEntryNo, pTempVATEntry);
                    if pVATEntry."Unrealized VAT Entry No." <> 0 then begin
                        VATPostingSetup.Get(pVATEntry."VAT Bus. Posting Group", pVATEntry."VAT Prod. Posting Group");
                        if VATPostingSetup."VAT Calculation Type" in
                           [VATPostingSetup."VAT Calculation Type"::"Normal VAT",
                            VATPostingSetup."VAT Calculation Type"::"Full VAT"]
                        then
                            GLEntryNoFromVAT := PostUnrealVATByUnapply(GenJournalLine, VATPostingSetup, pVATEntry, pTempVATEntry)
                        else
                            if VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT" then begin
                                GLEntryNoFromVAT := PostUnrealVATByUnapply(GenJournalLine, VATPostingSetup, pVATEntry, pTempVATEntry);
                                CreateGLEntry(
                                  GenJournalLine, VATPostingSetup.GetRevChargeAccount(true),
                                  -pVATEntry.Amount, CalcAddCurrForUnapplication(pVATEntry."Posting Date", -pVATEntry.Amount), false);
                                CreateGLEntry(
                                  GenJournalLine, VATPostingSetup.GetRevChargeAccount(false),
                                  pVATEntry.Amount, CalcAddCurrForUnapplication(pVATEntry."Posting Date", pVATEntry.Amount), false);
                            end else
                                GLEntryNoFromVAT := PostUnrealVATByUnapply(GenJournalLine, VATPostingSetup, pVATEntry, pTempVATEntry);
                        VATEntry2 := pTempVATEntry;
                        VATEntry2."Entry No." := NextVATEntryNo;
                        OnPostUnapplyOnBeforeVATEntryInsert(VATEntry2, GenJournalLine, pVATEntry);
                        VATEntry2.Insert();
                        if GLEntryNoFromVAT <> 0 then
                            lGLEntryVATEntryLink.InsertLink(GLEntryNoFromVAT, VATEntry2."Entry No.");
                        GLEntryNoFromVAT := 0;
                        pTempVATEntry.Delete();
                        IncrNextVATEntryNo();
                    end;

                    if VATPostingSetup."Adjust for Payment Discount" and not IsNotPayment(pVATEntry."Document Type") and
                       (VATPostingSetup."VAT Calculation Type" =
                        VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT") and
                       (pVATEntry."Unrealized VAT Entry No." = 0) and UnapplyVATEntries and (pVATEntry.Amount <> 0)
                    then begin
                        case VATEntryType of
                            pVATEntry.Type::Sale:
                                AccNo := VATPostingSetup.GetSalesAccount(false);
                            pVATEntry.Type::Purchase:
                                AccNo := VATPostingSetup.GetPurchAccount(false);
                        end;
                        PostPmtDiscountVATByUnapply(GenJournalLine, VATPostingSetup.GetRevChargeAccount(false), AccNo, pVATEntry);
                    end;
                end;
            until pVATEntry.Next() = 0;
    end;

    local procedure CalcAddCurrForUnapplication(Date: Date; Amt: Decimal): Decimal
    var
        lAddCurrency: Record Currency;
        lCurrencyExchangeRate: Record "Currency Exchange Rate";
    begin
        if AddCurrencyCode = '' then
            exit;

        lAddCurrency.Get(AddCurrencyCode);
        lAddCurrency.TestField("Amount Rounding Precision");

        exit(
          Round(
            lCurrencyExchangeRate.ExchangeAmtLCYToFCY(
              Date, AddCurrencyCode, Amt, lCurrencyExchangeRate.ExchangeRate(Date, AddCurrencyCode)),
            lAddCurrency."Amount Rounding Precision"));
    end;

    local procedure CalcVATAmountFromVATEntry(AmountLCY: Decimal; var pVATEntry: Record "VAT Entry"; CurrencyLCY: Record Currency) VATAmountLCY: Decimal
    begin
        if (AmountLCY = pVATEntry.Base) or (pVATEntry.Base = 0) then begin
            VATAmountLCY := pVATEntry.Amount;
            pVATEntry.Delete();
        end else begin
            VATAmountLCY :=
              Round(
                pVATEntry.Amount * AmountLCY / pVATEntry.Base,
                CurrencyLCY."Amount Rounding Precision",
                CurrencyLCY.VATRoundingDirection());
            pVATEntry.Base := pVATEntry.Base - AmountLCY;
            pVATEntry.Amount := pVATEntry.Amount - VATAmountLCY;
            pVATEntry.Modify();
        end;
    end;

    local procedure InsertDtldCustLedgEntryUnapply(GenJournalLine: Record "Gen. Journal Line"; var NewDetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; OldDetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; var NextDtldLedgEntryNo: Integer)
    begin
        NewDetailedCustLedgEntry := OldDetailedCustLedgEntry;
        NewDetailedCustLedgEntry."Entry No." := NextDtldLedgEntryNo;
        NewDetailedCustLedgEntry."Posting Date" := GenJournalLine."Posting Date";
        NewDetailedCustLedgEntry."Transaction No." := NextTransactionNo;
        NewDetailedCustLedgEntry."Application No." := 0;
        NewDetailedCustLedgEntry.Amount := -OldDetailedCustLedgEntry.Amount;
        NewDetailedCustLedgEntry."Amount (LCY)" := -OldDetailedCustLedgEntry."Amount (LCY)";
        NewDetailedCustLedgEntry."Debit Amount" := -OldDetailedCustLedgEntry."Debit Amount";
        NewDetailedCustLedgEntry."Credit Amount" := -OldDetailedCustLedgEntry."Credit Amount";
        NewDetailedCustLedgEntry."Debit Amount (LCY)" := -OldDetailedCustLedgEntry."Debit Amount (LCY)";
        NewDetailedCustLedgEntry."Credit Amount (LCY)" := -OldDetailedCustLedgEntry."Credit Amount (LCY)";
        NewDetailedCustLedgEntry.Unapplied := true;
        NewDetailedCustLedgEntry."Unapplied by Entry No." := OldDetailedCustLedgEntry."Entry No.";
        NewDetailedCustLedgEntry."Document No." := GenJournalLine."Document No.";
        NewDetailedCustLedgEntry."Source Code" := GenJournalLine."Source Code";
        NewDetailedCustLedgEntry."User ID" := CopyStr(UserId(), 1, 50);
        OnBeforeInsertDtldCustLedgEntryUnapply(NewDetailedCustLedgEntry, GenJournalLine, OldDetailedCustLedgEntry);
        NewDetailedCustLedgEntry.Insert(true);
        NextDtldLedgEntryNo := NextDtldLedgEntryNo + 1;
    end;

    local procedure InsertDtldVendLedgEntryUnapply(GenJournalLine: Record "Gen. Journal Line"; var NewDetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry"; OldDetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry"; var NextDtldLedgEntryNo: Integer)
    begin
        NewDetailedVendorLedgEntry := OldDetailedVendorLedgEntry;
        NewDetailedVendorLedgEntry."Entry No." := NextDtldLedgEntryNo;
        NewDetailedVendorLedgEntry."Posting Date" := GenJournalLine."Posting Date";
        NewDetailedVendorLedgEntry."Transaction No." := NextTransactionNo;
        NewDetailedVendorLedgEntry."Application No." := 0;
        NewDetailedVendorLedgEntry.Amount := -OldDetailedVendorLedgEntry.Amount;
        NewDetailedVendorLedgEntry."Amount (LCY)" := -OldDetailedVendorLedgEntry."Amount (LCY)";
        NewDetailedVendorLedgEntry."Debit Amount" := -OldDetailedVendorLedgEntry."Debit Amount";
        NewDetailedVendorLedgEntry."Credit Amount" := -OldDetailedVendorLedgEntry."Credit Amount";
        NewDetailedVendorLedgEntry."Debit Amount (LCY)" := -OldDetailedVendorLedgEntry."Debit Amount (LCY)";
        NewDetailedVendorLedgEntry."Credit Amount (LCY)" := -OldDetailedVendorLedgEntry."Credit Amount (LCY)";
        NewDetailedVendorLedgEntry.Unapplied := true;
        NewDetailedVendorLedgEntry."Unapplied by Entry No." := OldDetailedVendorLedgEntry."Entry No.";
        NewDetailedVendorLedgEntry."Document No." := GenJournalLine."Document No.";
        NewDetailedVendorLedgEntry."Source Code" := GenJournalLine."Source Code";
        NewDetailedVendorLedgEntry."User ID" := CopyStr(UserId(), 1, 50);
        OnBeforeInsertDtldVendLedgEntryUnapply(NewDetailedVendorLedgEntry, GenJournalLine, OldDetailedVendorLedgEntry);
        NewDetailedVendorLedgEntry.Insert(true);
        NextDtldLedgEntryNo := NextDtldLedgEntryNo + 1;
    end;

    local procedure InsertDtldEmplLedgEntryUnapply(GenJournalLine: Record "Gen. Journal Line"; var NewDetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry"; OldDetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry"; var NextDtldLedgEntryNo: Integer)
    begin
        NewDetailedEmployeeLedgerEntry := OldDetailedEmployeeLedgerEntry;
        NewDetailedEmployeeLedgerEntry."Entry No." := NextDtldLedgEntryNo;
        NewDetailedEmployeeLedgerEntry."Posting Date" := GenJournalLine."Posting Date";
        NewDetailedEmployeeLedgerEntry."Transaction No." := NextTransactionNo;
        NewDetailedEmployeeLedgerEntry."Application No." := 0;
        NewDetailedEmployeeLedgerEntry.Amount := -OldDetailedEmployeeLedgerEntry.Amount;
        NewDetailedEmployeeLedgerEntry."Amount (LCY)" := -OldDetailedEmployeeLedgerEntry."Amount (LCY)";
        NewDetailedEmployeeLedgerEntry."Debit Amount" := -OldDetailedEmployeeLedgerEntry."Debit Amount";
        NewDetailedEmployeeLedgerEntry."Credit Amount" := -OldDetailedEmployeeLedgerEntry."Credit Amount";
        NewDetailedEmployeeLedgerEntry."Debit Amount (LCY)" := -OldDetailedEmployeeLedgerEntry."Debit Amount (LCY)";
        NewDetailedEmployeeLedgerEntry."Credit Amount (LCY)" := -OldDetailedEmployeeLedgerEntry."Credit Amount (LCY)";
        NewDetailedEmployeeLedgerEntry.Unapplied := true;
        NewDetailedEmployeeLedgerEntry."Unapplied by Entry No." := OldDetailedEmployeeLedgerEntry."Entry No.";
        NewDetailedEmployeeLedgerEntry."Document No." := GenJournalLine."Document No.";
        NewDetailedEmployeeLedgerEntry."Source Code" := GenJournalLine."Source Code";
        NewDetailedEmployeeLedgerEntry."User ID" := CopyStr(UserId(), 1, 50);
        OnBeforeInsertDtldEmplLedgEntryUnapply(NewDetailedEmployeeLedgerEntry, GenJournalLine, OldDetailedEmployeeLedgerEntry);
        NewDetailedEmployeeLedgerEntry.Insert(true);
        NextDtldLedgEntryNo := NextDtldLedgEntryNo + 1;
    end;

    local procedure InsertTempVATEntry(GenJournalLine: Record "Gen. Journal Line"; pVATEntry: Record "VAT Entry"; var TempVATEntryNo: Integer; var pTempVATEntry: Record "VAT Entry" temporary)
    begin
        pTempVATEntry := pVATEntry;
        pTempVATEntry."Entry No." := TempVATEntryNo;
        TempVATEntryNo := TempVATEntryNo + 1;
        pTempVATEntry."Closed by Entry No." := 0;
        pTempVATEntry.Closed := false;
        pTempVATEntry.CopyAmountsFromVATEntry(pVATEntry, true);
        pTempVATEntry."Posting Date" := GenJournalLine."Posting Date";
        pTempVATEntry."Document No." := GenJournalLine."Document No.";
        pTempVATEntry."User ID" := CopyStr(UserId(), 1, 50);
        pTempVATEntry."Transaction No." := NextTransactionNo;
        OnInsertTempVATEntryOnBeforeInsert(pTempVATEntry, GenJournalLine);
        pTempVATEntry.Insert();
    end;

    local procedure ProcessTempVATEntry(DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var pTempVATEntry: Record "VAT Entry" temporary)
    var
        VATEntrySaved: Record "VAT Entry";
        VATBaseSum: array[3] of Decimal;
        DeductedVATBase: Decimal;
        EntryNoBegin: array[3] of Integer;
        i: Integer;
        SummarizedVAT: Boolean;
    begin
        if not (DetailedCVLedgEntryBuffer."Entry Type" in
                [DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount (VAT Excl.)",
                 DetailedCVLedgEntryBuffer."Entry Type"::"Payment Tolerance (VAT Excl.)",
                 DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount Tolerance (VAT Excl.)"])
        then
            exit;

        DeductedVATBase := 0;
        pTempVATEntry.Reset();
        pTempVATEntry.SetRange("Entry No.", 0, 999999);
        pTempVATEntry.SetRange("Gen. Bus. Posting Group", DetailedCVLedgEntryBuffer."Gen. Bus. Posting Group");
        pTempVATEntry.SetRange("Gen. Prod. Posting Group", DetailedCVLedgEntryBuffer."Gen. Prod. Posting Group");
        pTempVATEntry.SetRange("VAT Bus. Posting Group", DetailedCVLedgEntryBuffer."VAT Bus. Posting Group");
        pTempVATEntry.SetRange("VAT Prod. Posting Group", DetailedCVLedgEntryBuffer."VAT Prod. Posting Group");
        if pTempVATEntry.FindSet() then
            repeat
                case true of
                    SummarizedVAT and (VATBaseSum[3] + pTempVATEntry.Base = DetailedCVLedgEntryBuffer."Amount (LCY)" - DeductedVATBase):
                        i := 4;
                    SummarizedVAT and (VATBaseSum[2] + pTempVATEntry.Base = DetailedCVLedgEntryBuffer."Amount (LCY)" - DeductedVATBase):
                        i := 3;
                    SummarizedVAT and (VATBaseSum[1] + pTempVATEntry.Base = DetailedCVLedgEntryBuffer."Amount (LCY)" - DeductedVATBase):
                        i := 2;
                    pTempVATEntry.Base = DetailedCVLedgEntryBuffer."Amount (LCY)" - DeductedVATBase:
                        i := 1;
                    else
                        i := 0;
                end;
                if i > 0 then begin
                    pTempVATEntry.Reset();
                    if i > 1 then begin
                        if EntryNoBegin[i - 1] < pTempVATEntry."Entry No." then
                            pTempVATEntry.SetRange("Entry No.", EntryNoBegin[i - 1], pTempVATEntry."Entry No.")
                        else
                            pTempVATEntry.SetRange("Entry No.", pTempVATEntry."Entry No.", EntryNoBegin[i - 1]);
                    end else
                        pTempVATEntry.SetRange("Entry No.", pTempVATEntry."Entry No.");
                    pTempVATEntry.FindSet();
                    repeat
                        VATEntrySaved := pTempVATEntry;
                        case DetailedCVLedgEntryBuffer."Entry Type" of
                            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount (VAT Excl.)":
                                pTempVATEntry.Rename(pTempVATEntry."Entry No." + 3000000);
                            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Tolerance (VAT Excl.)":
                                pTempVATEntry.Rename(pTempVATEntry."Entry No." + 2000000);
                            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
                                pTempVATEntry.Rename(pTempVATEntry."Entry No." + 1000000);
                        end;
                        pTempVATEntry := VATEntrySaved;
                        DeductedVATBase += pTempVATEntry.Base;
                    until pTempVATEntry.Next() = 0;
                    for i := 1 to 3 do begin
                        VATBaseSum[i] := 0;
                        EntryNoBegin[i] := 0;
                        SummarizedVAT := false;
                    end;
                    pTempVATEntry.SetRange("Entry No.", 0, 999999);
                end else begin
                    VATBaseSum[3] += pTempVATEntry.Base;
                    VATBaseSum[2] := VATBaseSum[1] + pTempVATEntry.Base;
                    VATBaseSum[1] := pTempVATEntry.Base;
                    if EntryNoBegin[3] > 0 then
                        EntryNoBegin[3] := pTempVATEntry."Entry No.";
                    EntryNoBegin[2] := EntryNoBegin[1];
                    EntryNoBegin[1] := pTempVATEntry."Entry No.";
                    SummarizedVAT := true;
                end;
            until pTempVATEntry.Next() = 0;
    end;

    local procedure ProcessTempVATEntryCust(var DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; var pTempVATEntry: Record "VAT Entry" temporary)
    var
        DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer";
    begin
        if not DetailedCustLedgEntry.FindSet() then
            exit;
        repeat
            DetailedCVLedgEntryBuffer.Init();
            DetailedCVLedgEntryBuffer.TransferFields(DetailedCustLedgEntry);
            ProcessTempVATEntry(DetailedCVLedgEntryBuffer, pTempVATEntry);
        until DetailedCustLedgEntry.Next() = 0;
    end;

    local procedure ProcessTempVATEntryVend(var DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry"; var pTempVATEntry: Record "VAT Entry" temporary)
    var
        DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer";
    begin
        if not DetailedVendorLedgEntry.FindSet() then
            exit;
        repeat
            DetailedCVLedgEntryBuffer.Init();
            DetailedCVLedgEntryBuffer.TransferFields(DetailedVendorLedgEntry);
            ProcessTempVATEntry(DetailedCVLedgEntryBuffer, pTempVATEntry);
        until DetailedVendorLedgEntry.Next() = 0;
    end;

    local procedure UpdateCustLedgEntry(DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    var
        lCustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        if DetailedCustLedgEntry."Entry Type" <> DetailedCustLedgEntry."Entry Type"::Application then
            exit;

        lCustLedgerEntry.Get(DetailedCustLedgEntry."Cust. Ledger Entry No.");
        lCustLedgerEntry."Remaining Pmt. Disc. Possible" := DetailedCustLedgEntry."Remaining Pmt. Disc. Possible";
        lCustLedgerEntry."Max. Payment Tolerance" := DetailedCustLedgEntry."Max. Payment Tolerance";
        lCustLedgerEntry."Accepted Payment Tolerance" := 0;
        if not lCustLedgerEntry.Open then begin
            lCustLedgerEntry.Open := true;
            lCustLedgerEntry."Closed by Entry No." := 0;
            lCustLedgerEntry."Closed at Date" := 0D;
            lCustLedgerEntry."Closed by Amount" := 0;
            lCustLedgerEntry."Closed by Amount (LCY)" := 0;
            lCustLedgerEntry."Closed by Currency Code" := '';
            lCustLedgerEntry."Closed by Currency Amount" := 0;
            lCustLedgerEntry."Pmt. Disc. Given (LCY)" := 0;
            lCustLedgerEntry."Pmt. Tolerance (LCY)" := 0;
            lCustLedgerEntry."Calculate Interest" := false;
        end;

        OnBeforeCustLedgEntryModify(lCustLedgerEntry, DetailedCustLedgEntry);
        lCustLedgerEntry.Modify();
    end;

    local procedure UpdateVendLedgEntry(DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry")
    var
        lVendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        if DetailedVendorLedgEntry."Entry Type" <> DetailedVendorLedgEntry."Entry Type"::Application then
            exit;

        lVendorLedgerEntry.Get(DetailedVendorLedgEntry."Vendor Ledger Entry No.");
        lVendorLedgerEntry."Remaining Pmt. Disc. Possible" := DetailedVendorLedgEntry."Remaining Pmt. Disc. Possible";
        lVendorLedgerEntry."Max. Payment Tolerance" := DetailedVendorLedgEntry."Max. Payment Tolerance";
        lVendorLedgerEntry."Accepted Payment Tolerance" := 0;
        if not lVendorLedgerEntry.Open then begin
            lVendorLedgerEntry.Open := true;
            lVendorLedgerEntry."Closed by Entry No." := 0;
            lVendorLedgerEntry."Closed at Date" := 0D;
            lVendorLedgerEntry."Closed by Amount" := 0;
            lVendorLedgerEntry."Closed by Amount (LCY)" := 0;
            lVendorLedgerEntry."Closed by Currency Code" := '';
            lVendorLedgerEntry."Closed by Currency Amount" := 0;
            lVendorLedgerEntry."Pmt. Disc. Rcd.(LCY)" := 0;
            lVendorLedgerEntry."Pmt. Tolerance (LCY)" := 0;
        end;

        OnBeforeVendLedgEntryModify(lVendorLedgerEntry, DetailedVendorLedgEntry);
        lVendorLedgerEntry.Modify();
    end;

    local procedure UpdateEmplLedgEntry(DetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry")
    var
        EmployeeLedgerEntry: Record "Employee Ledger Entry";
    begin
        if DetailedEmployeeLedgerEntry."Entry Type" <> DetailedEmployeeLedgerEntry."Entry Type"::Application then
            exit;

        EmployeeLedgerEntry.Get(DetailedEmployeeLedgerEntry."Employee Ledger Entry No.");
        if not EmployeeLedgerEntry.Open then begin
            EmployeeLedgerEntry.Open := true;
            EmployeeLedgerEntry."Closed by Entry No." := 0;
            EmployeeLedgerEntry."Closed at Date" := 0D;
            EmployeeLedgerEntry."Closed by Amount" := 0;
            EmployeeLedgerEntry."Closed by Amount (LCY)" := 0;
        end;

        OnBeforeEmplLedgEntryModify(EmployeeLedgerEntry, DetailedEmployeeLedgerEntry);
        EmployeeLedgerEntry.Modify();
    end;

    local procedure UpdateCalcInterest(var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer")
    var
        lCustLedgerEntry: Record "Cust. Ledger Entry";
        CVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer";
    begin
        if lCustLedgerEntry.Get(CVLedgerEntryBuffer."Closed by Entry No.") then begin
            CVLedgerEntryBuffer2.TransferFields(lCustLedgerEntry);
            UpdateCalcInterest(CVLedgerEntryBuffer, CVLedgerEntryBuffer2);
        end;
        lCustLedgerEntry.SetCurrentKey("Closed by Entry No.");
        lCustLedgerEntry.SetRange("Closed by Entry No.", CVLedgerEntryBuffer."Entry No.");
        if lCustLedgerEntry.FindSet() then
            repeat
                CVLedgerEntryBuffer2.TransferFields(lCustLedgerEntry);
                UpdateCalcInterest(CVLedgerEntryBuffer, CVLedgerEntryBuffer2);
            until lCustLedgerEntry.Next() = 0;
    end;

    local procedure UpdateCalcInterest(var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var CVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer")
    begin
        if CVLedgerEntryBuffer."Due Date" < CVLedgerEntryBuffer2."Document Date" then
            CVLedgerEntryBuffer."Calculate Interest" := true;
    end;

    local procedure GLCalcAddCurrency(Amount: Decimal; AddCurrAmount: Decimal; OldAddCurrAmount: Decimal; UseAddCurrAmount: Boolean; GenJournalLine: Record "Gen. Journal Line"): Decimal
    begin
        if (AddCurrencyCode <> '') and
           (GenJournalLine."Additional-Currency Posting" = GenJournalLine."Additional-Currency Posting"::None)
        then begin
            if (GenJournalLine."Source Currency Code" = AddCurrencyCode) and UseAddCurrAmount then
                exit(AddCurrAmount);

            exit(ExchangeAmtLCYToFCY2(Amount));
        end;
        exit(OldAddCurrAmount);
    end;

    local procedure HandleAddCurrResidualGLEntry(GenJournalLine: Record "Gen. Journal Line"; GLEntry2: Record "G/L Entry")
    var
        GLAccount: Record "G/L Account";
        GLEntry: Record "G/L Entry";
    begin
        if AddCurrencyCode = '' then
            exit;

        TotalAddCurrAmount := TotalAddCurrAmount + GLEntry2."Additional-Currency Amount";
        TotalAmount := TotalAmount + GLEntry2.Amount;

        if (GenJournalLine."Additional-Currency Posting" = GenJournalLine."Additional-Currency Posting"::None) and
           (TotalAmount = 0) and (TotalAddCurrAmount <> 0) and
           CheckNonAddCurrCodeOccurred(GenJournalLine."Source Currency Code")
        then begin
            GLEntry.Init();
            GLEntry.CopyFromGenJnlLine(GenJournalLine);
            GLEntry."External Document No." := '';
            GLEntry.Description :=
              CopyStr(
                StrSubstNo(
                  ResidualRoundingErr,
                  GLEntry.FieldCaption("Additional-Currency Amount")),
                1, MaxStrLen(GLEntry.Description));
            GLEntry."Source Type" := GLEntry."Source Type"::" ";
            GLEntry."Source No." := '';
            GLEntry."Job No." := '';
            GLEntry.Quantity := 0;
            GLEntry."Entry No." := NextEntryNo;
            GLEntry."Transaction No." := NextTransactionNo;
            if TotalAddCurrAmount < 0 then
                GLEntry."G/L Account No." := AddCurrency."Residual Losses Account"
            else
                GLEntry."G/L Account No." := AddCurrency."Residual Gains Account";
            GLEntry.Amount := 0;
            GLEntry."System-Created Entry" := true;
            GLEntry."Additional-Currency Amount" := -TotalAddCurrAmount;
            GLAccount.Get(GLEntry."G/L Account No.");
            GLAccount.TestField(Blocked, false);
            GLAccount.TestField("Account Type", GLAccount."Account Type"::Posting);
            OnHandleAddCurrResidualGLEntryOnBeforeInsertGLEntry(GenJournalLine, GLEntry);
            InsertGLEntry(GenJournalLine, GLEntry, false);

            CheckGLAccDimError(GenJournalLine, GLEntry."G/L Account No.");

            TotalAddCurrAmount := 0;
        end;

        OnAfterHandleAddCurrResidualGLEntry(GenJournalLine, GLEntry2);
    end;

    local procedure CalcLCYToAddCurr(AmountLCY: Decimal): Decimal
    begin
        if AddCurrencyCode = '' then
            exit;

        exit(ExchangeAmtLCYToFCY2(AmountLCY));
    end;

    local procedure GetCurrencyExchRate(GenJournalLine: Record "Gen. Journal Line")
    var
        NewCurrencyDate: Date;
    begin
        if AddCurrencyCode = '' then
            exit;

        AddCurrency.Get(AddCurrencyCode);
        AddCurrency.TestField("Amount Rounding Precision");
        AddCurrency.TestField("Residual Gains Account");
        AddCurrency.TestField("Residual Losses Account");

        NewCurrencyDate := GenJournalLine."Posting Date";
        if GenJournalLine."Reversing Entry" then
            NewCurrencyDate := NewCurrencyDate - 1;
        if (NewCurrencyDate <> CurrencyDate) or
           UseCurrFactorOnly
        then begin
            UseCurrFactorOnly := false;
            CurrencyDate := NewCurrencyDate;
            CurrencyFactor :=
              CurrencyExchangeRate.ExchangeRate(CurrencyDate, AddCurrencyCode);
        end;
        if (GenJournalLine."FA Add.-Currency Factor" <> 0) and
           (GenJournalLine."FA Add.-Currency Factor" <> CurrencyFactor)
        then begin
            UseCurrFactorOnly := true;
            CurrencyDate := 0D;
            CurrencyFactor := GenJournalLine."FA Add.-Currency Factor";
        end;
    end;

    local procedure ExchangeAmtLCYToFCY2(Amount: Decimal): Decimal
    begin
        if UseCurrFactorOnly then
            exit(
              Round(
                CurrencyExchangeRate.ExchangeAmtLCYToFCYOnlyFactor(Amount, CurrencyFactor),
                AddCurrency."Amount Rounding Precision"));
        exit(
          Round(
            CurrencyExchangeRate.ExchangeAmtLCYToFCY(
              CurrencyDate, AddCurrencyCode, Amount, CurrencyFactor),
            AddCurrency."Amount Rounding Precision"));
    end;

    local procedure CheckNonAddCurrCodeOccurred(CurrencyCode: Code[10]): Boolean
    begin
        NonAddCurrCodeOccured :=
          NonAddCurrCodeOccured or (AddCurrencyCode <> CurrencyCode);
        exit(NonAddCurrCodeOccured);
    end;

    local procedure TotalVATAmountOnJnlLines(GenJournalLine: Record "Gen. Journal Line") TotalVATAmount: Decimal
    var
        GenJournalLine2: Record "Gen. Journal Line";
    begin
        GenJournalLine2.SetRange("Source Code", GenJournalLine."Source Code");
        GenJournalLine2.SetRange("Document No.", GenJournalLine."Document No.");
        GenJournalLine2.SetRange("Posting Date", GenJournalLine."Posting Date");
        GenJournalLine2.CalcSums("VAT Amount (LCY)", "Bal. VAT Amount (LCY)");
        TotalVATAmount := GenJournalLine2."VAT Amount (LCY)" - GenJournalLine2."Bal. VAT Amount (LCY)";
        exit(TotalVATAmount);
    end;

    procedure SetGLRegReverse(var ReverseGLRegister: Record "G/L Register")
    begin
        GLRegister.Reversed := true;
        ReverseGLRegister := GLRegister;
    end;

    local procedure InsertVATEntriesFromTemp(var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GLEntry: Record "G/L Entry")
    var
        Complete: Boolean;
        LinkedAmount: Decimal;
        lFirstEntryNo: Integer;
        LastEntryNo: Integer;
    begin
        TempVATEntry.Reset();
        TempVATEntry.SetRange("Gen. Bus. Posting Group", GLEntry."Gen. Bus. Posting Group");
        TempVATEntry.SetRange("Gen. Prod. Posting Group", GLEntry."Gen. Prod. Posting Group");
        TempVATEntry.SetRange("VAT Bus. Posting Group", GLEntry."VAT Bus. Posting Group");
        TempVATEntry.SetRange("VAT Prod. Posting Group", GLEntry."VAT Prod. Posting Group");
        case DetailedCVLedgEntryBuffer."Entry Type" of
            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount Tolerance (VAT Excl.)":
                begin
                    lFirstEntryNo := 1000000;
                    LastEntryNo := 1999999;
                end;
            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Tolerance (VAT Excl.)":
                begin
                    lFirstEntryNo := 2000000;
                    LastEntryNo := 2999999;
                end;
            DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount (VAT Excl.)":
                begin
                    lFirstEntryNo := 3000000;
                    LastEntryNo := 3999999;
                end;
        end;
        TempVATEntry.SetRange("Entry No.", lFirstEntryNo, LastEntryNo);
        if TempVATEntry.FindSet() then
            repeat
                VATEntry := TempVATEntry;
                VATEntry."Entry No." := NextVATEntryNo;
                OnInsertVATEntriesFromTempOnBeforeVATEntryInsert(VATEntry, TempVATEntry);
                VATEntry.Insert(true);
                NextVATEntryNo := NextVATEntryNo + 1;
                if VATEntry."Unrealized VAT Entry No." = 0 then
                    GLEntryVATEntryLink.InsertLink(GLEntry."Entry No.", VATEntry."Entry No.");
                LinkedAmount += VATEntry.Amount + VATEntry.Base;
                Complete := LinkedAmount = -(DetailedCVLedgEntryBuffer."Amount (LCY)" + DetailedCVLedgEntryBuffer."VAT Amount (LCY)");
                LastEntryNo := TempVATEntry."Entry No.";
            until Complete or (TempVATEntry.Next() = 0);

        TempVATEntry.SetRange("Entry No.", lFirstEntryNo, LastEntryNo);
        TempVATEntry.DeleteAll();
    end;

    procedure ABSMin(Decimal1: Decimal; Decimal2: Decimal): Decimal
    begin
        if Abs(Decimal1) < Abs(Decimal2) then
            exit(Decimal1);
        exit(Decimal2);
    end;

    local procedure GetApplnRoundPrecision(NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"): Decimal
    var
        ApplnCurrency: Record Currency;
        CurrencyCode: Code[10];
    begin
        if NewCVLedgerEntryBuffer."Currency Code" <> '' then
            CurrencyCode := NewCVLedgerEntryBuffer."Currency Code"
        else
            CurrencyCode := OldCVLedgerEntryBuffer."Currency Code";
        if CurrencyCode = '' then
            exit(0);
        ApplnCurrency.Get(CurrencyCode);
        if ApplnCurrency."Appln. Rounding Precision" <> 0 then
            exit(ApplnCurrency."Appln. Rounding Precision");
        exit(GeneralLedgerSetup."Appln. Rounding Precision");
    end;

    local procedure GetGLSetup()
    begin
        if GLSetupRead then
            exit;

        GeneralLedgerSetup.Get();
        GLSetupRead := true;

        AddCurrencyCode := GeneralLedgerSetup."Additional Reporting Currency";
    end;

    local procedure ReadGLSetup(var NewGeneralLedgerSetup: Record "General Ledger Setup")
    begin
        NewGeneralLedgerSetup := GeneralLedgerSetup;
    end;

    local procedure CheckSalesExtDocNo(GenJournalLine: Record "Gen. Journal Line")
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get();
        if not SalesReceivablesSetup."Ext. Doc. No. Mandatory" then
            exit;

        if GenJournalLine."Document Type" in
           [GenJournalLine."Document Type"::Invoice,
            GenJournalLine."Document Type"::"Credit Memo",
            GenJournalLine."Document Type"::Payment,
            GenJournalLine."Document Type"::Refund,
            GenJournalLine."Document Type"::" "]
        then
            GenJournalLine.TestField("External Document No.");
    end;

    local procedure CheckPurchExtDocNo(GenJournalLine: Record "Gen. Journal Line")
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        OldVendorLedgerEntry: Record "Vendor Ledger Entry";
        VendorMgt: Codeunit "Vendor Mgt.";
    begin
        PurchasesPayablesSetup.Get();
        if not (PurchasesPayablesSetup."Ext. Doc. No. Mandatory" or (GenJournalLine."External Document No." <> '')) then
            exit;

        GenJournalLine.TestField("External Document No.");
        OldVendorLedgerEntry.Reset();
        VendorMgt.SetFilterForExternalDocNo(
          OldVendorLedgerEntry, GenJournalLine."Document Type", GenJournalLine."External Document No.",
          GenJournalLine."Account No.", GenJournalLine."Document Date");
        if not OldVendorLedgerEntry.IsEmpty() then
            Error(
              PurchaseAlreadyExistsErr,
              GenJournalLine."Document Type", GenJournalLine."External Document No.");
    end;

    local procedure CheckDimValueForDisposal(GenJournalLine: Record "Gen. Journal Line"; AccountNo: Code[20])
    var
        DimensionManagement: Codeunit DimensionManagement;
        TableID: array[10] of Integer;
        AccNo: array[10] of Code[20];
    begin
        if ((GenJournalLine.Amount = 0) or (GenJournalLine."Amount (LCY)" = 0)) and
           (GenJournalLine."FA Posting Type" = GenJournalLine."FA Posting Type"::Disposal)
        then begin
            TableID[1] := DimensionManagement.TypeToTableID1(GenJournalLine."Account Type"::"G/L Account".AsInteger());
            AccNo[1] := AccountNo;
            if not DimensionManagement.CheckDimValuePosting(TableID, AccNo, GenJournalLine."Dimension Set ID") then
                Error(DimensionManagement.GetDimValuePostingErr());
        end;
    end;

    procedure SetOverDimErr()
    begin
        OverrideDimErr := true;
    end;

    local procedure CheckGLAccDimError(GenJournalLine: Record "Gen. Journal Line"; GLAccNo: Code[20])
    var
        DimensionManagement: Codeunit DimensionManagement;
        TableID: array[10] of Integer;
        AccNo: array[10] of Code[20];
    begin
        OnBeforeCheckGLAccDimError(GenJournalLine, GLAccNo);

        if (GenJournalLine.Amount = 0) and (GenJournalLine."Amount (LCY)" = 0) then
            exit;

        TableID[1] := DATABASE::"G/L Account";
        AccNo[1] := GLAccNo;
        if DimensionManagement.CheckDimValuePosting(TableID, AccNo, GenJournalLine."Dimension Set ID") then
            exit;

        if GenJournalLine."Line No." <> 0 then
            Error(
              DimensionUsedErr,
              GenJournalLine.TableCaption(), GenJournalLine."Journal Template Name",
              GenJournalLine."Journal Batch Name", GenJournalLine."Line No.",
              DimensionManagement.GetDimValuePostingErr());

        Error(DimensionManagement.GetDimValuePostingErr());
    end;

    local procedure CalculateCurrentBalance(AccountNo: Code[20]; BalAccountNo: Code[20]; InclVATAmount: Boolean; AmountLCY: Decimal; VATAmount: Decimal)
    begin
        if (AccountNo <> '') and (BalAccountNo <> '') then
            exit;

        if AccountNo = BalAccountNo then
            exit;

        if not InclVATAmount then
            VATAmount := 0;

        if BalAccountNo <> '' then
            CurrentBalance -= AmountLCY + VATAmount
        else
            CurrentBalance += AmountLCY + VATAmount;
    end;

    local procedure GetCurrency(var Currency: Record Currency; CurrencyCode: Code[10])
    begin
        if Currency.Code <> CurrencyCode then
            if CurrencyCode = '' then
                Clear(Currency)
            else
                Currency.Get(CurrencyCode);
    end;

    local procedure CollectAdjustment(var AdjAmount: array[4] of Decimal; Amount: Decimal; AmountAddCurr: Decimal)
    var
        Offset: Integer;
    begin
        Offset := GetAdjAmountOffset(Amount, AmountAddCurr);
        AdjAmount[Offset] += Amount;
        AdjAmount[Offset + 1] += AmountAddCurr;
    end;

    local procedure HandleDtldAdjustment(GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; AdjAmount: array[4] of Decimal; TotalAmountLCY: Decimal; TotalAmountAddCurr: Decimal; GLAccNo: Code[20])
    var
        IsHandled: Boolean;
    begin
        if not PostDtldAdjustment(
             GenJournalLine, GLEntry, AdjAmount,
             TotalAmountLCY, TotalAmountAddCurr, GLAccNo,
             GetAdjAmountOffset(TotalAmountLCY, TotalAmountAddCurr))
        then begin
            IsHandled := false;
            OnHandleDtldAdjustmentOnBeforeInitGLEntry(GenJournalLine, GLEntry, TotalAmountLCY, TotalAmountAddCurr, GLAccNo, IsHandled);
            if not IsHandled then
                InitGLEntry(GenJournalLine, GLEntry, GLAccNo, TotalAmountLCY, TotalAmountAddCurr, true, true);
        end;
    end;

    local procedure PostDtldAdjustment(GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; AdjAmount: array[4] of Decimal; TotalAmountLCY: Decimal; TotalAmountAddCurr: Decimal; GLAccount: Code[20]; ArrayIndex: Integer): Boolean
    begin
        if (GenJournalLine."Bal. Account No." <> '') and
           ((AdjAmount[ArrayIndex] <> 0) or (AdjAmount[ArrayIndex + 1] <> 0)) and
           ((TotalAmountLCY + AdjAmount[ArrayIndex] <> 0) or (TotalAmountAddCurr + AdjAmount[ArrayIndex + 1] <> 0))
        then begin
            CreateGLEntryBalAcc(
              GenJournalLine, GLAccount, -AdjAmount[ArrayIndex], -AdjAmount[ArrayIndex + 1],
              GenJournalLine."Bal. Account Type", GenJournalLine."Bal. Account No.");
            InitGLEntry(GenJournalLine, GLEntry,
              GLAccount, TotalAmountLCY + AdjAmount[ArrayIndex],
              TotalAmountAddCurr + AdjAmount[ArrayIndex + 1], true, true);
            AdjAmount[ArrayIndex] := 0;
            AdjAmount[ArrayIndex + 1] := 0;
            exit(true);
        end;

        exit(false);
    end;

    local procedure GetAdjAmountOffset(Amount: Decimal; AmountACY: Decimal): Integer
    begin
        if (Amount > 0) or (Amount = 0) and (AmountACY > 0) then
            exit(1);
        exit(3);
    end;

    procedure GetNextEntryNo(): Integer
    begin
        exit(NextEntryNo);
    end;

    procedure GetNextTransactionNo(): Integer
    begin
        exit(NextTransactionNo);
    end;

    procedure GetNextVATEntryNo(): Integer
    begin
        exit(NextVATEntryNo);
    end;

    procedure IncrNextVATEntryNo()
    begin
        NextVATEntryNo := NextVATEntryNo + 1;
    end;

    local procedure IsNotPayment(DocumentType: Enum "Gen. Journal Document Type"): Boolean
    begin
        exit(DocumentType in [DocumentType::Invoice,
                              DocumentType::"Credit Memo",
                              DocumentType::"Finance Charge Memo",
                              DocumentType::Reminder]);
    end;

    local procedure IsTempGLEntryBufEmpty(): Boolean
    begin
        exit(TempGLEntryBuf.IsEmpty());
    end;

    local procedure IsVATAdjustment(pEntryType: Enum "Detailed CV Ledger Entry Type"): Boolean
    var
        DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer";
    begin
        exit(pEntryType in [DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount (VAT Adjustment)",
                           DetailedCVLedgEntryBuffer."Entry Type"::"Payment Tolerance (VAT Adjustment)",
                           DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount Tolerance (VAT Adjustment)"]);
    end;

    local procedure IsVATExcluded(pEntryType: Enum "Detailed CV Ledger Entry Type"): Boolean
    var
        DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer";
    begin
        exit(pEntryType in [DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount (VAT Excl.)",
                           DetailedCVLedgEntryBuffer."Entry Type"::"Payment Tolerance (VAT Excl.)",
                           DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount Tolerance (VAT Excl.)"]);
    end;

    local procedure RealizeDelayedUnrealizedVAT(GenJournalLine: Record "Gen. Journal Line")
    begin
        if GenJournalLine."Delayed Unrealized VAT" and GenJournalLine."Realize VAT" then
            if (GenJournalLine."Applies-to Doc. No." <> '') or (GenJournalLine."Applies-to ID" <> '') then
                PostDelayedUnrealizedVAT(GenJournalLine);
    end;

    local procedure MakeDerogFAJnlLine(var FAJournalLine: Record "FA Journal Line"; GenJournalLine: Record "Gen. Journal Line")
    var
        DepreciationBook: Record "Depreciation Book";
        FAJournalSetup: Record "FA Journal Setup";
    begin
        DepreciationBook.SetRange("Derogatory Calculation", GenJournalLine."Depreciation Book Code");
        if not DepreciationBook.FindFirst() then
            Error(Text10800Lbl);
        FAJournalLine.Validate("Depreciation Book Code", DepreciationBook.Code);
        if not FAJournalSetup.Get(FAJournalLine."Depreciation Book Code", UserId()) then
            FAJournalSetup.Get(FAJournalLine."Depreciation Book Code", '');
        FAJournalLine."Journal Template Name" := FAJournalSetup."FA Jnl. Template Name";
        FAJournalLine."Journal Batch Name" := FAJournalSetup."FA Jnl. Batch Name";
        FAJournalLine."FA Posting Type" := "FA Journal Line FA Posting Type".FromInteger(GenJournalLine."FA Posting Type".AsInteger() - 1);
        FAJournalLine."FA No." := GenJournalLine."Account No.";
        if GenJournalLine."FA Posting Date" <> 0D then
            FAJournalLine."FA Posting Date" := GenJournalLine."FA Posting Date"
        else
            FAJournalLine."FA Posting Date" := GenJournalLine."Posting Date";
        FAJournalLine."Posting Date" := GenJournalLine."Posting Date";
        if FAJournalLine."Posting Date" = FAJournalLine."FA Posting Date" then
            FAJournalLine."Posting Date" := 0D;
        FAJournalLine."Document Type" := GenJournalLine."Document Type";
        FAJournalLine."Document Date" := GenJournalLine."Document Date";
        FAJournalLine."Document No." := GenJournalLine."Document No.";
        FAJournalLine."External Document No." := GenJournalLine."External Document No.";
        FAJournalLine.Description := GenJournalLine.Description;
        FAJournalLine.Validate(Amount, GenJournalLine."VAT Base Amount");
        FAJournalLine.Quantity := GenJournalLine.Quantity;
        FAJournalLine.Validate(Correction, GenJournalLine.Correction);
        FAJournalLine."No. of Depreciation Days" := GenJournalLine."No. of Depreciation Days";
        FAJournalLine."Depr. until FA Posting Date" := GenJournalLine."Depr. until FA Posting Date";
        FAJournalLine."Depr. Acquisition Cost" := GenJournalLine."Depr. Acquisition Cost";
        FAJournalLine."FA Posting Group" := GenJournalLine."Posting Group";
        FAJournalLine."Maintenance Code" := GenJournalLine."Maintenance Code";
        FAJournalLine."Shortcut Dimension 1 Code" := GenJournalLine."Shortcut Dimension 1 Code";
        FAJournalLine."Shortcut Dimension 2 Code" := GenJournalLine."Shortcut Dimension 2 Code";
        FAJournalLine."Dimension Set ID" := GenJournalLine."Dimension Set ID";
        FAJournalLine."Budgeted FA No." := GenJournalLine."Budgeted FA No.";
        FAJournalLine."FA Reclassification Entry" := GenJournalLine."FA Reclassification Entry";
        FAJournalLine."Index Entry" := GenJournalLine."Index Entry";
    end;

    procedure PostDelayedUnrealizedVAT(GenJournalLine: Record "Gen. Journal Line")
    var
        OldCustLedgerEntry: Record "Cust. Ledger Entry";
        OldVendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        case GenJournalLine."Source Type" of
            GenJournalLine."Source Type"::Customer:
                if GenJournalLine."Applies-to Doc. No." <> '' then begin
                    // Find original entry based on Applies-to Doc. No.
                    OldCustLedgerEntry.Reset();
                    OldCustLedgerEntry.SetCurrentKey("Document No.");
                    OldCustLedgerEntry.SetRange("Document No.", GenJournalLine."Applies-to Doc. No.");
                    OldCustLedgerEntry.SetRange("Document Type", GenJournalLine."Applies-to Doc. Type");
                    OldCustLedgerEntry.SetRange("Customer No.", GenJournalLine."Source No.");
                    OldCustLedgerEntry.FindFirst();
                    OldCustLedgerEntry.CalcFields(
                      Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)",
                      "Original Amount", "Original Amt. (LCY)");
                    SetTransactionNo(GenJournalLine);
                    UnrealCVLedgEntryBuffer.Reset();
                    UnrealCVLedgEntryBuffer.SetRange("Account Type", UnrealCVLedgEntryBuffer."Account Type"::Customer);
                    UnrealCVLedgEntryBuffer.SetRange("Account No.", GenJournalLine."Source No.");
                    if CheckHeaderNo(GenJournalLine."Document No.") then
                        UnrealCVLedgEntryBuffer.SetRange("Payment Slip No.", GenJournalLine."Created from No.")
                    else
                        UnrealCVLedgEntryBuffer.SetRange("Payment Slip No.", GenJournalLine."Document No.");
                    UnrealCVLedgEntryBuffer.FindFirst();
                    CustUnrealizedVAT(GenJournalLine, OldCustLedgerEntry, GenJournalLine.Amount);
                    UnrealCVLedgEntryBuffer.Realized := true;
                    UnrealCVLedgEntryBuffer.Modify();
                    UpdateUnrealCVLedgEntryBuffer(GenJournalLine, OldCustLedgerEntry."Transaction No.");
                end else begin
                    // Find original entry from buffer table
                    UnrealCVLedgEntryBuffer.Reset();
                    UnrealCVLedgEntryBuffer.SetRange("Account Type", UnrealCVLedgEntryBuffer."Account Type"::Customer);
                    UnrealCVLedgEntryBuffer.SetRange("Account No.", GenJournalLine."Source No.");
                    if CheckHeaderNo(GenJournalLine."Document No.") then
                        UnrealCVLedgEntryBuffer.SetRange("Payment Slip No.", GenJournalLine."Created from No.")
                    else
                        UnrealCVLedgEntryBuffer.SetRange("Payment Slip No.", GenJournalLine."Document No.");
                    UnrealCVLedgEntryBuffer.SetRange("Applies-to ID", GenJournalLine."Applies-to ID");
                    if UnrealCVLedgEntryBuffer.FindSet() then
                        repeat
                            OldCustLedgerEntry.Get(UnrealCVLedgEntryBuffer."Entry No.");
                            OldCustLedgerEntry.CalcFields(
                              Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)",
                              "Original Amount", "Original Amt. (LCY)");
                            SetTransactionNo(GenJournalLine);
                            CustUnrealizedVAT(GenJournalLine, OldCustLedgerEntry, UnrealCVLedgEntryBuffer."Applied Amount");
                            UnrealCVLedgEntryBuffer.Realized := true;
                            UnrealCVLedgEntryBuffer.Modify();
                            UpdateUnrealCVLedgEntryBuffer(GenJournalLine, OldCustLedgerEntry."Transaction No.");
                        until UnrealCVLedgEntryBuffer.Next() = 0;
                end;
            GenJournalLine."Source Type"::Vendor:
                if GenJournalLine."Applies-to Doc. No." <> '' then begin
                    // Find original entry based on Applies-to Doc. No.
                    OldVendorLedgerEntry.Reset();
                    OldVendorLedgerEntry.SetCurrentKey("Document No.");
                    OldVendorLedgerEntry.SetRange("Document No.", GenJournalLine."Applies-to Doc. No.");
                    OldVendorLedgerEntry.SetRange("Document Type", GenJournalLine."Applies-to Doc. Type");
                    OldVendorLedgerEntry.SetRange("Vendor No.", GenJournalLine."Source No.");
                    OldVendorLedgerEntry.FindFirst();
                    OldVendorLedgerEntry.CalcFields(
                      Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)",
                      "Original Amount", "Original Amt. (LCY)");
                    SetTransactionNo(GenJournalLine);
                    UnrealCVLedgEntryBuffer.Reset();
                    UnrealCVLedgEntryBuffer.SetRange("Account Type", UnrealCVLedgEntryBuffer."Account Type"::Vendor);
                    UnrealCVLedgEntryBuffer.SetRange("Account No.", GenJournalLine."Source No.");
                    if CheckHeaderNo(GenJournalLine."Document No.") then
                        UnrealCVLedgEntryBuffer.SetRange("Payment Slip No.", GenJournalLine."Created from No.")
                    else
                        UnrealCVLedgEntryBuffer.SetRange("Payment Slip No.", GenJournalLine."Document No.");
                    UnrealCVLedgEntryBuffer.FindFirst();
                    VendUnrealizedVAT(GenJournalLine, OldVendorLedgerEntry, GenJournalLine.Amount);
                    UnrealCVLedgEntryBuffer.Realized := true;
                    UnrealCVLedgEntryBuffer.Modify();
                    UpdateUnrealCVLedgEntryBuffer(GenJournalLine, OldVendorLedgerEntry."Transaction No.");
                end else begin
                    // Find original entry from buffer table
                    UnrealCVLedgEntryBuffer.Reset();
                    UnrealCVLedgEntryBuffer.SetRange("Account Type", UnrealCVLedgEntryBuffer."Account Type"::Vendor);
                    UnrealCVLedgEntryBuffer.SetRange("Account No.", GenJournalLine."Source No.");
                    if CheckHeaderNo(GenJournalLine."Document No.") then
                        UnrealCVLedgEntryBuffer.SetRange("Payment Slip No.", GenJournalLine."Created from No.")
                    else
                        UnrealCVLedgEntryBuffer.SetRange("Payment Slip No.", GenJournalLine."Document No.");
                    UnrealCVLedgEntryBuffer.SetRange("Applies-to ID", GenJournalLine."Applies-to ID");
                    if UnrealCVLedgEntryBuffer.FindSet() then
                        repeat
                            OldVendorLedgerEntry.Get(UnrealCVLedgEntryBuffer."Entry No.");
                            OldVendorLedgerEntry.CalcFields(
                              Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)",
                              "Original Amount", "Original Amt. (LCY)");
                            SetTransactionNo(GenJournalLine);
                            VendUnrealizedVAT(GenJournalLine, OldVendorLedgerEntry, UnrealCVLedgEntryBuffer."Applied Amount");
                            UnrealCVLedgEntryBuffer.Realized := true;
                            UnrealCVLedgEntryBuffer.Modify();
                            UpdateUnrealCVLedgEntryBuffer(GenJournalLine, OldVendorLedgerEntry."Transaction No.");
                        until UnrealCVLedgEntryBuffer.Next() = 0;
                end;
        end;
    end;


    procedure SetTransactionNo(GenJournalLine: Record "Gen. Journal Line")
    var
        AppliedCustLedgerEntry: Record "Cust. Ledger Entry";
        AppliedVendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        case GenJournalLine."Source Type" of
            GenJournalLine."Source Type"::Customer:
                begin
                    AppliedCustLedgerEntry.Reset();
                    AppliedCustLedgerEntry.SetCurrentKey("Document No.");
                    if CheckHeaderNo(GenJournalLine."Document No.") then
                        AppliedCustLedgerEntry.SetRange("Document No.", GenJournalLine."Created from No.")
                    else
                        AppliedCustLedgerEntry.SetRange("Document No.", GenJournalLine."Document No.");
                    AppliedCustLedgerEntry.SetRange("Document Type", AppliedCustLedgerEntry."Document Type"::" ");
                    AppliedCustLedgerEntry.SetRange("Customer No.", GenJournalLine."Source No.");
                    AppliedCustLedgerEntry.FindFirst();
#pragma warning disable AA0206
                    OldTransactionNo := AppliedCustLedgerEntry."Transaction No.";
#pragma warning restore AA0206
                end;
            GenJournalLine."Source Type"::Vendor:
                begin
                    AppliedVendorLedgerEntry.Reset();
                    AppliedVendorLedgerEntry.SetCurrentKey("Document No.");
                    if CheckHeaderNo(GenJournalLine."Document No.") then
                        AppliedVendorLedgerEntry.SetRange("Document No.", GenJournalLine."Created from No.")
                    else
                        AppliedVendorLedgerEntry.SetRange("Document No.", GenJournalLine."Document No.");
                    AppliedVendorLedgerEntry.SetRange("Document Type", AppliedVendorLedgerEntry."Document Type"::" ");
                    AppliedVendorLedgerEntry.SetRange("Vendor No.", GenJournalLine."Source No.");
                    AppliedVendorLedgerEntry.FindFirst();
                    OldTransactionNo := AppliedVendorLedgerEntry."Transaction No.";
                end;
        end;
    end;


    procedure UpdateUnrealCVLedgEntryBuffer(GenJournalLine: Record "Gen. Journal Line"; TransactionNo: Integer)
    var
        VATEntry2: Record "VAT Entry";
        UnrealCVLedgEntryBuffer2: Record "Unreal. CV Ledg. Entry Buffer";
        TotalUnrealVATAmount: Decimal;
    begin
        VATEntry2.Reset();
        VATEntry2.SetCurrentKey("Transaction No.");
        VATEntry2.SetRange("Transaction No.", TransactionNo);
        if VATEntry2.FindSet() then
            repeat
                TotalUnrealVATAmount := TotalUnrealVATAmount - VATEntry2."Remaining Unrealized Amount";
            until VATEntry2.Next() = 0;
        if TotalUnrealVATAmount = 0 then begin
            UnrealCVLedgEntryBuffer2.Reset();
            if GenJournalLine."Source Type" = GenJournalLine."Source Type"::Customer then
                UnrealCVLedgEntryBuffer2.SetRange("Account Type", UnrealCVLedgEntryBuffer2."Account Type"::Customer)
            else
                UnrealCVLedgEntryBuffer2.SetRange("Account Type", UnrealCVLedgEntryBuffer2."Account Type"::Vendor);
            UnrealCVLedgEntryBuffer2.SetRange("Entry No.", UnrealCVLedgEntryBuffer."Entry No.");
            UnrealCVLedgEntryBuffer2.SetRange(Realized, true);
            UnrealCVLedgEntryBuffer2.DeleteAll();
        end;
    end;

    procedure CalcPaidAmount(GenJournalLine: Record "Gen. Journal Line"): Decimal
    var
        UnrealCVLedgEntryBuffer2: Record "Unreal. CV Ledg. Entry Buffer";
        PaidAmount: Decimal;
    begin
        UnrealCVLedgEntryBuffer2.Reset();
        if GenJournalLine."Source Type" = GenJournalLine."Source Type"::Customer then
            UnrealCVLedgEntryBuffer2.SetRange("Account Type", UnrealCVLedgEntryBuffer2."Account Type"::Customer)
        else
            UnrealCVLedgEntryBuffer2.SetRange("Account Type", UnrealCVLedgEntryBuffer2."Account Type"::Vendor);
        UnrealCVLedgEntryBuffer2.SetRange("Entry No.", UnrealCVLedgEntryBuffer."Entry No.");
        UnrealCVLedgEntryBuffer2.SetRange(Realized, true);
        if UnrealCVLedgEntryBuffer2.FindSet() then
            repeat
                PaidAmount := PaidAmount - UnrealCVLedgEntryBuffer2."Applied Amount";
            until UnrealCVLedgEntryBuffer2.Next() = 0;
        exit(Abs(PaidAmount));
    end;


    procedure CheckHeaderNo(DocNo: Code[20]): Boolean
    var
        PaymentLine: Record "Payment Line";
    begin
        PaymentLine.SetRange("No.", DocNo);
        if not PaymentLine.ISEMPTY then
            exit(true);

        exit(false);
    end;

    local procedure UpdateVATEntryTaxDetails(GenJournalLine: Record "Gen. Journal Line"; var pVATEntry: Record "VAT Entry"; pTaxDetail: Record "Tax Detail"; var TaxJurisdiction: Record "Tax Jurisdiction")
    begin
        if pTaxDetail."Tax Jurisdiction Code" <> '' then
            TaxJurisdiction.Get(pTaxDetail."Tax Jurisdiction Code");
        if GenJournalLine."Gen. Posting Type" <> GenJournalLine."Gen. Posting Type"::Settlement then begin
            pVATEntry."Tax Group Used" := pTaxDetail."Tax Group Code";
            pVATEntry."Tax Type" := pTaxDetail."Tax Type";
            pVATEntry."Tax on Tax" := pTaxDetail."Calculate Tax on Tax";
        end;
        pVATEntry."Tax Jurisdiction Code" := pTaxDetail."Tax Jurisdiction Code";

        OnAfterUpdateVATEntryTaxDetails(pVATEntry, pTaxDetail);
    end;

    local procedure UpdateGLEntryNo(var pGLEntryNo: Integer; var SavedEntryNo: Integer)
    begin
        if SavedEntryNo <> 0 then begin
            pGLEntryNo := SavedEntryNo;
            NextEntryNo := NextEntryNo - 1;
            SavedEntryNo := 0;
        end;
    end;

#pragma warning disable AL0432
    local procedure UpdateTotalAmounts(var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary; DimSetID: Integer; DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer")
#pragma warning restore AL0432
    var
        IsHandled: Boolean;
    begin
        OnBeforeUpdateTotalAmounts(
          TempInvoicePostBuffer, DimSetID, DetailedCVLedgEntryBuffer."Amount (LCY)", DetailedCVLedgEntryBuffer."Additional-Currency Amount", IsHandled,
          DetailedCVLedgEntryBuffer);
        if IsHandled then
            exit;

        TempInvoicePostBuffer.SetRange("Dimension Set ID", DimSetID);
        if TempInvoicePostBuffer.FindFirst() then begin
            TempInvoicePostBuffer.Amount += DetailedCVLedgEntryBuffer."Amount (LCY)";
            TempInvoicePostBuffer."Amount (ACY)" += DetailedCVLedgEntryBuffer."Additional-Currency Amount";
            TempInvoicePostBuffer.Modify();
        end else begin
            TempInvoicePostBuffer.Init();
            TempInvoicePostBuffer."Dimension Set ID" := DimSetID;
            TempInvoicePostBuffer.Amount := DetailedCVLedgEntryBuffer."Amount (LCY)";
            TempInvoicePostBuffer."Amount (ACY)" := DetailedCVLedgEntryBuffer."Additional-Currency Amount";
            TempInvoicePostBuffer.Insert();
        end;
    end;

#pragma warning disable AL0432
    local procedure CreateGLEntriesForTotalAmountsUnapply(GenJournalLine: Record "Gen. Journal Line"; var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary; Account: Code[20])
#pragma warning restore AL0432
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        TempInvoicePostBuffer.SetRange("Dimension Set ID");
        if TempInvoicePostBuffer.FindSet() then
            repeat
                if (TempInvoicePostBuffer.Amount <> 0) or
                   (TempInvoicePostBuffer."Amount (ACY)" <> 0) and (GeneralLedgerSetup."Additional Reporting Currency" <> '')
                then begin
                    DimensionManagement.UpdateGenJnlLineDim(GenJournalLine, TempInvoicePostBuffer."Dimension Set ID");
                    CreateGLEntry(GenJournalLine, Account, TempInvoicePostBuffer.Amount, TempInvoicePostBuffer."Amount (ACY)", true);
                end;
            until TempInvoicePostBuffer.Next() = 0;
    end;

#pragma warning disable AL0432 // TODO - Tag V18
    local procedure CreateGLEntriesForTotalAmounts(GenJournalLine: Record "Gen. Journal Line"; var InvoicePostBuffer: Record "Invoice Post. Buffer"; AdjAmountBuf: array[4] of Decimal; SavedEntryNo: Integer; GLAccNo: Code[20]; LedgEntryInserted: Boolean)
#pragma warning restore AL0432 // TODO - Tag V18
    var
        DimensionManagement: Codeunit DimensionManagement;
        GLEntryInserted: Boolean;
    begin
        OnBeforeCreateGLEntriesForTotalAmounts(InvoicePostBuffer, GenJournalLine, GLAccNo);

        GLEntryInserted := false;

        InvoicePostBuffer.Reset();
        if InvoicePostBuffer.FindSet() then
            repeat
                if (InvoicePostBuffer.Amount <> 0) or (InvoicePostBuffer."Amount (ACY)" <> 0) and (AddCurrencyCode <> '') then begin
                    DimensionManagement.UpdateGenJnlLineDim(GenJournalLine, InvoicePostBuffer."Dimension Set ID");
                    CreateGLEntryForTotalAmounts(GenJournalLine, InvoicePostBuffer.Amount, InvoicePostBuffer."Amount (ACY)", AdjAmountBuf, SavedEntryNo, GLAccNo);
                    GLEntryInserted := true;
                end;
            until InvoicePostBuffer.Next() = 0;

        if not GLEntryInserted and LedgEntryInserted then
            CreateGLEntryForTotalAmounts(GenJournalLine, 0, 0, AdjAmountBuf, SavedEntryNo, GLAccNo);
    end;

    local procedure CreateGLEntryForTotalAmounts(GenJournalLine: Record "Gen. Journal Line"; Amount: Decimal; AmountACY: Decimal; AdjAmountBuf: array[4] of Decimal; var SavedEntryNo: Integer; GLAccNo: Code[20])
    var
        GLEntry: Record "G/L Entry";
    begin
        HandleDtldAdjustment(GenJournalLine, GLEntry, AdjAmountBuf, Amount, AmountACY, GLAccNo);
        GLEntry."Bal. Account Type" := GenJournalLine."Bal. Account Type";
        GLEntry."Bal. Account No." := GenJournalLine."Bal. Account No.";
        UpdateGLEntryNo(GLEntry."Entry No.", SavedEntryNo);
        InsertGLEntry(GenJournalLine, GLEntry, true);
    end;

    local procedure CreateAndPostDerogatoryEntry(SourceGenJournalLine: Record "Gen. Journal Line")
    var
        DepreciationBook: Record "Depreciation Book";
        DerogDepreciationBook: Record "Depreciation Book";
        GenJournalLine: Record "Gen. Journal Line";
        FAJournalLine: Record "FA Journal Line";
        DerogFALedgerEntry: Record "FA Ledger Entry";
        // CalculateAcqCostDepr: Codeunit "Calculate Acq. Cost Depr.";
        DerogatoryAmount: Decimal;
    begin
        if (SourceGenJournalLine."FA Posting Type" <> SourceGenJournalLine."FA Posting Type"::"Acquisition Cost") or
           (not SourceGenJournalLine."Depr. Acquisition Cost")
        then
            exit;

        DepreciationBook.Get(SourceGenJournalLine."Depreciation Book Code");
        DerogDepreciationBook.SetRange("Derogatory Calculation", DepreciationBook.Code);
        if not DerogDepreciationBook.FindFirst() then
            exit;

        DerogatoryCalc(
          DerogatoryAmount, SourceGenJournalLine."Account No.", DerogDepreciationBook.Code, SourceGenJournalLine.Amount);

        if DerogatoryAmount = 0 then
            exit;

        MakeGenJnlLineOfTypeDerogatory(GenJournalLine, SourceGenJournalLine, DerogatoryAmount);
        MakeDerogFAJnlLine(FAJournalLine, GenJournalLine);

        if DepreciationBook."G/L Integration - Derogatory" then begin
            // Insert/post G/L + FA entries for primary depreciation book
            CIRFAJnlPostLine.GenJnlPostLineContinue(
              GenJournalLine, GenJournalLine.Amount, GenJournalLine."VAT Amount", NextTransactionNo, NextEntryNo, GLRegister."No.");

            // Insert balance entry for primary depreciation book
            DerogFALedgerEntry.SetCurrentKey("Entry No.");
            DerogFALedgerEntry.FindLast();
            DerogFALedgerEntry."Automatic Entry" := true;
            CIRFAJnlPostLine.InsertBalAcc(DerogFALedgerEntry);
        end else begin
            // Post FA ledger entry for primary book
            FAJournalLine.Validate("Depreciation Book Code", SourceGenJournalLine."Depreciation Book Code");
            CIRFAJnlPostLine.FAJnlPostLine(FAJournalLine, true);
        end;

        // Post FA ledger entry for secondary book
        FAJournalLine.Validate("Depreciation Book Code", DerogDepreciationBook.Code);
        CIRFAJnlPostLine.FAJnlPostLine(FAJournalLine, true);
    end;

    local procedure MakeGenJnlLineOfTypeDerogatory(var DerogGenJournalLine: Record "Gen. Journal Line"; GenJournalLine: Record "Gen. Journal Line"; DerogAmount: Decimal)
    begin
        DerogGenJournalLine.TransferFields(GenJournalLine);
        DerogGenJournalLine.Validate("FA Posting Type", DerogGenJournalLine."FA Posting Type"::Derogatory);
        DerogGenJournalLine.Validate(Amount, DerogAmount);
        DerogGenJournalLine.Validate("Depr. until FA Posting Date", false);
        DerogGenJournalLine.Validate("Depr. Acquisition Cost", false);
        DerogGenJournalLine.Validate("System-Created Entry", true);
    end;

    local procedure SetAddCurrForUnapplication(var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer")
    begin
        if not (DetailedCVLedgEntryBuffer."Entry Type" in [DetailedCVLedgEntryBuffer."Entry Type"::Application, DetailedCVLedgEntryBuffer."Entry Type"::"Unrealized Loss",
                         DetailedCVLedgEntryBuffer."Entry Type"::"Unrealized Gain", DetailedCVLedgEntryBuffer."Entry Type"::"Realized Loss",
                         DetailedCVLedgEntryBuffer."Entry Type"::"Realized Gain", DetailedCVLedgEntryBuffer."Entry Type"::"Correction of Remaining Amount"])
then
            if (DetailedCVLedgEntryBuffer."Entry Type" = DetailedCVLedgEntryBuffer."Entry Type"::"Appln. Rounding") or
               ((AddCurrencyCode <> '') and (AddCurrencyCode = DetailedCVLedgEntryBuffer."Currency Code"))
            then
                DetailedCVLedgEntryBuffer."Additional-Currency Amount" := DetailedCVLedgEntryBuffer.Amount
            else
                DetailedCVLedgEntryBuffer."Additional-Currency Amount" := CalcAddCurrForUnapplication(DetailedCVLedgEntryBuffer."Posting Date", DetailedCVLedgEntryBuffer."Amount (LCY)");
    end;

    local procedure PostDeferral(var GenJournalLine: Record "Gen. Journal Line"; AccountNo: Code[20])
    var
        DeferralTemplate: Record "Deferral Template";
        DeferralHeader: Record "Deferral Header";
        DeferralLine: Record "Deferral Line";
        GLEntry: Record "G/L Entry";
        lCurrencyExchangeRate: Record "Currency Exchange Rate";
        lDeferralUtilities: Codeunit "Deferral Utilities";
        PerPostDate: Date;
        PeriodicCount: Integer;
        AmtToDefer: Decimal;
        AmtToDeferACY: Decimal;
        EmptyDeferralLine: Boolean;
    begin
        OnBeforePostDeferral(GenJournalLine, AccountNo);

        if GenJournalLine."Source Type" in [GenJournalLine."Source Type"::Vendor, GenJournalLine."Source Type"::Customer] then
            // Purchasing and Sales, respectively
            // We can create these types directly from the GL window, need to make sure we don't already have a deferral schedule
            // created for this GL Trx before handing it off to sales/purchasing subsystem
            if GenJournalLine."Source Code" <> GLSourceCode then begin
                PostDeferralPostBuffer(GenJournalLine);
                exit;
            end;

        if DeferralHeader.Get(DeferralDocType::"G/L", GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name", 0, '', GenJournalLine."Line No.") then begin
            EmptyDeferralLine := false;
            // Get the range of detail records for this schedule
            lDeferralUtilities.FilterDeferralLines(
              DeferralLine, DeferralDocType::"G/L", GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name", 0, '', GenJournalLine."Line No.");
            if DeferralLine.FindSet() then
                repeat
                    if DeferralLine.Amount = 0.0 then
                        EmptyDeferralLine := true;
                until (DeferralLine.Next() = 0) or EmptyDeferralLine;
            if EmptyDeferralLine then
                Error(ZeroDeferralAmtErr, GenJournalLine."Line No.", GenJournalLine."Deferral Code");
            DeferralHeader."Amount to Defer (LCY)" :=
              Round(lCurrencyExchangeRate.ExchangeAmtFCYToLCY(GenJournalLine."Posting Date", GenJournalLine."Currency Code",
                  DeferralHeader."Amount to Defer", GenJournalLine."Currency Factor"));
            DeferralHeader.Modify();
        end;

        lDeferralUtilities.RoundDeferralAmount(
          DeferralHeader,
          GenJournalLine."Currency Code", GenJournalLine."Currency Factor", GenJournalLine."Posting Date", AmtToDefer, AmtToDeferACY);

        DeferralTemplate.Get(GenJournalLine."Deferral Code");
        DeferralTemplate.TestField("Deferral Account");
        DeferralTemplate.TestField("Deferral %");

        // Get the Deferral Header table so we know the amount to defer...
        // Assume straight GL posting
        if DeferralHeader.Get(DeferralDocType::"G/L", GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name", 0, '', GenJournalLine."Line No.") then
            // Get the range of detail records for this schedule
            lDeferralUtilities.FilterDeferralLines(
              DeferralLine, DeferralDocType::"G/L", GenJournalLine."Journal Template Name", GenJournalLine."Journal Batch Name", 0, '', GenJournalLine."Line No.")
        else
            Error(NoDeferralScheduleErr, GenJournalLine."Line No.", GenJournalLine."Deferral Code");

        InitGLEntry(
          GenJournalLine, GLEntry, AccountNo,
          -DeferralHeader."Amount to Defer (LCY)", -DeferralHeader."Amount to Defer", true, true);
        GLEntry.Description := SetDeferralDescription(GenJournalLine, DeferralLine);
        InsertGLEntry(GenJournalLine, GLEntry, true);

        InitGLEntry(
          GenJournalLine, GLEntry, DeferralTemplate."Deferral Account",
          DeferralHeader."Amount to Defer (LCY)", DeferralHeader."Amount to Defer", true, true);
        GLEntry.Description := SetDeferralDescription(GenJournalLine, DeferralLine);
        InsertGLEntry(GenJournalLine, GLEntry, true);

        // Here we want to get the Deferral Details table range and loop through them...
        if DeferralLine.FindSet() then begin
            PeriodicCount := 1;
            repeat
                PerPostDate := DeferralLine."Posting Date";
                if GenJnlCheckLine.DateNotAllowed(PerPostDate) then
                    Error(InvalidPostingDateErr, PerPostDate);

                InitGLEntry(
                  GenJournalLine, GLEntry, AccountNo,
                  DeferralLine."Amount (LCY)", DeferralLine.Amount, true, true);
                GLEntry."Posting Date" := PerPostDate;
                GLEntry.Description := DeferralLine.Description;
                InsertGLEntry(GenJournalLine, GLEntry, true);

                InitGLEntry(
                  GenJournalLine, GLEntry, DeferralTemplate."Deferral Account",
                  -DeferralLine."Amount (LCY)", -DeferralLine.Amount, true, true);
                GLEntry."Posting Date" := PerPostDate;
                GLEntry.Description := DeferralLine.Description;
                InsertGLEntry(GenJournalLine, GLEntry, true);
                PeriodicCount := PeriodicCount + 1;
            until DeferralLine.Next() = 0;
        end else
            Error(NoDeferralScheduleErr, GenJournalLine."Line No.", GenJournalLine."Deferral Code");

        OnAfterPostDeferral(GenJournalLine, TempGLEntryBuf, AccountNo);
    end;

    local procedure PostDeferralPostBuffer(GenJournalLine: Record "Gen. Journal Line")
    var
        DeferralPostingBuffer: Record "Deferral Posting Buffer";
        GLEntry: Record "G/L Entry";
        PostDate: Date;
    begin
        if GenJournalLine."Source Type" = GenJournalLine."Source Type"::Customer then
            DeferralDocType := DeferralDocType::Sales
        else
            DeferralDocType := DeferralDocType::Purchase;

        DeferralPostingBuffer.SetRange("Deferral Doc. Type", DeferralDocType);
        DeferralPostingBuffer.SetRange("Document No.", GenJournalLine."Document No.");
        DeferralPostingBuffer.SetRange("Deferral Line No.", GenJournalLine."Deferral Line No.");

        if DeferralPostingBuffer.FindSet() then begin
            repeat
                PostDate := DeferralPostingBuffer."Posting Date";
                if GenJnlCheckLine.DateNotAllowed(PostDate) then
                    Error(InvalidPostingDateErr, PostDate);

                // When no sales/purch amount is entered, the offset was already posted
                if (DeferralPostingBuffer."Sales/Purch Amount" <> 0) or (DeferralPostingBuffer."Sales/Purch Amount (LCY)" <> 0) then begin
                    InitGLEntry(GenJournalLine, GLEntry, DeferralPostingBuffer."G/L Account",
                      DeferralPostingBuffer."Sales/Purch Amount (LCY)",
                      DeferralPostingBuffer."Sales/Purch Amount",
                      true, true);
                    GLEntry."Posting Date" := PostDate;
                    GLEntry.Description := DeferralPostingBuffer.Description;
                    GLEntry.CopyFromDeferralPostBuffer(DeferralPostingBuffer);
                    InsertGLEntry(GenJournalLine, GLEntry, true);
                end;

                if DeferralPostingBuffer.Amount <> 0 then begin
                    InitGLEntry(GenJournalLine, GLEntry,
                      DeferralPostingBuffer."Deferral Account",
                      -DeferralPostingBuffer."Amount (LCY)",
                      -DeferralPostingBuffer.Amount,
                      true, true);
                    GLEntry."Posting Date" := PostDate;
                    GLEntry.Description := DeferralPostingBuffer.Description;
                    InsertGLEntry(GenJournalLine, GLEntry, true);
                end;
            until DeferralPostingBuffer.Next() = 0;
            DeferralPostingBuffer.DeleteAll();
        end;
    end;

    procedure RemoveDeferralSchedule(GenJournalLine: Record "Gen. Journal Line")
    var
        lDeferralUtilities: Codeunit "Deferral Utilities";
        lDeferralDocType: Option Purchase,Sales,"G/L";
    begin
        // Removing deferral schedule after all deferrals for this line have been posted successfully
        lDeferralUtilities.DeferralCodeOnDelete(
  lDeferralDocType::"G/L",
  GenJournalLine."Journal Template Name",
  GenJournalLine."Journal Batch Name", 0, '', GenJournalLine."Line No.");
    end;

    local procedure GetGLSourceCode()
    var
        SourceCodeSetup: Record "Source Code Setup";
    begin
        SourceCodeSetup.Get();
        GLSourceCode := SourceCodeSetup."General Journal";
    end;

    local procedure DeferralPosting(DeferralCode: Code[10]; pSourceCode: Code[10]; AccountNo: Code[20]; var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean)
    begin
        if DeferralCode <> '' then
            // Sales and purchasing could have negative amounts, so check for them first...
            if (pSourceCode <> GLSourceCode) and
             (GenJournalLine."Account Type" in [GenJournalLine."Account Type"::Customer, GenJournalLine."Account Type"::Vendor])
          then
                PostDeferralPostBuffer(GenJournalLine)
            else
                // Pure GL trx, only post deferrals if it is not a balancing entry
                if not Balancing then
                    PostDeferral(GenJournalLine, AccountNo);
    end;

    local procedure SetDeferralDescription(GenJournalLine: Record "Gen. Journal Line"; DeferralLine: Record "Deferral Line"): Text[100]
    var
        DeferralDescription: Text[100];
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSetDeferralDescription(GenJournalLine, DeferralLine, DeferralDescription, IsHandled);
        if IsHandled then
            exit(DeferralDescription);

        exit(GenJournalLine.Description);
    end;

    local procedure GetPostingAccountNo(VATPostingSetup: Record "VAT Posting Setup"; pVATEntry: Record "VAT Entry"; UnrealizedVAT: Boolean): Code[20]
    var
        TaxJurisdiction: Record "Tax Jurisdiction";
    begin
        if VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Sales Tax" then begin
            pVATEntry.TestField("Tax Jurisdiction Code");
            TaxJurisdiction.Get(pVATEntry."Tax Jurisdiction Code");
            case pVATEntry.Type of
                pVATEntry.Type::Sale:
                    exit(TaxJurisdiction.GetSalesAccount(UnrealizedVAT));
                pVATEntry.Type::Purchase:
                    begin
                        if pVATEntry."Use Tax" then
                            exit(TaxJurisdiction.GetRevChargeAccount(UnrealizedVAT));
                        exit(TaxJurisdiction.GetPurchAccount(UnrealizedVAT));
                    end;
            end;
        end;

        case pVATEntry.Type of
            pVATEntry.Type::Sale:
                exit(VATPostingSetup.GetSalesAccount(UnrealizedVAT));
            pVATEntry.Type::Purchase:
                exit(VATPostingSetup.GetPurchAccount(UnrealizedVAT));
        end;
    end;

    local procedure IsDebitAmount(DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; Unapply: Boolean): Boolean
    var
        VATPostingSetup: Record "VAT Posting Setup";
        VATAmountCondition: Boolean;
        EntryAmount: Decimal;
    begin
        VATAmountCondition :=
  DetailedCVLedgEntryBuffer."Entry Type" in [DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount (VAT Excl.)", DetailedCVLedgEntryBuffer."Entry Type"::"Payment Tolerance (VAT Excl.)",
                   DetailedCVLedgEntryBuffer."Entry Type"::"Payment Discount Tolerance (VAT Excl.)"];
        if VATAmountCondition then begin
            VATPostingSetup.Get(DetailedCVLedgEntryBuffer."VAT Bus. Posting Group", DetailedCVLedgEntryBuffer."VAT Prod. Posting Group");
            VATAmountCondition := VATPostingSetup."VAT Calculation Type" = VATPostingSetup."VAT Calculation Type"::"Full VAT";
        end;
        if VATAmountCondition then
            EntryAmount := DetailedCVLedgEntryBuffer."VAT Amount (LCY)"
        else
            EntryAmount := DetailedCVLedgEntryBuffer."Amount (LCY)";
        if Unapply then
            exit(EntryAmount > 0);
        exit(EntryAmount <= 0);
    end;

    local procedure GetNextMatchingFALedgEntry(SourceFAJournalLine: Record "FA Journal Line"; FromEntryNo: Integer; DeprBookCode: Code[10]): Integer
    var
        FALedgerEntry: Record "FA Ledger Entry";
    begin
        FALedgerEntry.SetCurrentKey("Entry No.");
        FALedgerEntry.SetFilter("Entry No.", '>%1', FromEntryNo);
        FALedgerEntry.SetRange("Depreciation Book Code", DeprBookCode);
#pragma warning disable AA0210
        FALedgerEntry.SetRange(Amount, -SourceFAJournalLine.Amount);
#pragma warning restore AA0210
        FALedgerEntry.SetRange("FA Posting Type", SourceFAJournalLine.ConvertToLedgEntry(SourceFAJournalLine));
        FALedgerEntry.SetRange("FA No.", SourceFAJournalLine."FA No.");
        FALedgerEntry.SetRange("FA Posting Date", SourceFAJournalLine."FA Posting Date");
        FALedgerEntry.FindFirst();
        exit(FALedgerEntry."Entry No.");
    end;

    procedure DerogatoryCalc(var DeprAmount: Decimal; FANo: Code[20]; DeprBookCode: Code[10]; LocalDerogatoryBasis: Decimal)
    var
        DepreciationBook: Record "Depreciation Book";
        FADepreciationBook: Record "FA Depreciation Book";
        DepreciationCalculation: Codeunit "Depreciation Calculation";
        DerogBasis: Decimal;
    begin
        DeprAmount := 0;
        DepreciationBook.Get(DeprBookCode);
        if not FADepreciationBook.Get(FANo, DeprBookCode) then
            exit;
        FADepreciationBook.CalcFields(Derogatory, "Acquisition Cost", "Depreciable Basis");
        DerogBasis := FADepreciationBook."Depreciable Basis" - LocalDerogatoryBasis;
        if DerogBasis <= 0 then
            CreateError(FANo, DeprBookCode);
        if DerogBasis > 0 then
            DeprAmount :=
              DepreciationCalculation.CalcRounding(
                DeprBookCode, (FADepreciationBook.Derogatory * LocalDerogatoryBasis) / DerogBasis);
    end;

    local procedure CreateError(FANo: Code[20]; DeprBookCode: Code[20])
    var
        GenJournalLine: Record "Gen. Journal Line";
        FixedAsset: Record "Fixed Asset";
        FADepreciationBook: Record "FA Depreciation Book";
        DepreciationCalculation: Codeunit "Depreciation Calculation";
        Text000Txt: Label '%1 field must not have a check mark because %2 is zero or negative for %3.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Le champ %1 ne doit pas être coché car %2 est nul ou négatif pour %3." }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
    begin
        FixedAsset."No." := FANo;
        Error(
          Text000Txt,
          GenJournalLine.FieldCaption("Depr. Acquisition Cost"),
          FADepreciationBook.FieldCaption("Depreciable Basis"), DepreciationCalculation.FAName(FixedAsset, CopyStr(DeprBookCode, 1, 10)));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCode(var GenJournalLine: Record "Gen. Journal Line"; CheckLine: Boolean; var IsPosted: Boolean; var GLRegister: Record "G/L Register")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckGLAccDimError(var GenJournalLine: Record "Gen. Journal Line"; GLAccNo: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckPurchExtDocNo(GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Vendor Ledger Entry"; CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var Handled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeStartPosting(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeStartOrContinuePosting(var GenJournalLine: Record "Gen. Journal Line"; LastDocType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder; LastDocNo: Code[20]; LastDate: Date; var NextEntryNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeContinuePosting(var GenJournalLine: Record "Gen. Journal Line"; var GLRegister: Record "G/L Register"; var NextEntryNo: Integer; var NextTransactionNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCustUnrealizedVAT(var GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry"; SettledAmount: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnBeforePostGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostGLAcc(GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostVAT(GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; VATPostingSetup: Record "VAT Posting Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostPmtDiscountVATByUnapply(var GenJournalLine: Record "Gen. Journal Line"; var VATEntry: Record "VAT Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindAmtForAppln(var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer"; var AppliedAmount: Decimal; var AppliedAmountLCY: Decimal; var OldAppliedAmount: Decimal; var Handled: Boolean; var ApplnRoundingPrecision: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeVendUnrealizedVAT(var GenJournalLine: Record "Gen. Journal Line"; var VendorLedgerEntry: Record "Vendor Ledger Entry"; SettledAmount: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCustLedgEntryInsert(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterVendLedgEntryInsert(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFindAmtForAppln(var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer"; var AppliedAmount: Decimal; var AppliedAmountLCY: Decimal; var OldAppliedAmount: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitGLEntry(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitGLRegister(var GLRegister: Record "G/L Register"; var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitBankAccLedgEntry(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitCheckLedgEntry(var CheckLedgerEntry: Record "Check Ledger Entry"; BankAccountLedgerEntry: Record "Bank Account Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitCustLedgEntry(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitVendLedgEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitEmployeeLedgerEntry(var EmployeeLedgerEntry: Record "Employee Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertDtldCustLedgEntry(var DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; GenJournalLine: Record "Gen. Journal Line"; DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; Offset: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertDtldVendLedgEntry(var DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry"; GenJournalLine: Record "Gen. Journal Line"; DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; Offset: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertGlobalGLEntry(var GLEntry: Record "G/L Entry"; var TempGLEntryBuf: Record "G/L Entry"; var NextEntryNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitVAT(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; var VATPostingSetup: Record "VAT Posting Setup"; var AddCurrGLEntryVATAmt: Decimal)
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnAfterInsertVAT(var GenJournalLine: Record "Gen. Journal Line"; var VATEntry: Record "VAT Entry"; var UnrealizedVAT: Boolean; var AddCurrencyCode: Code[10]; var VATPostingSetup: Record "VAT Posting Setup"; var GLEntryAmount: Decimal; var GLEntryVATAmount: Decimal; var GLEntryBaseAmount: Decimal; var SrcCurrCode: Code[10]; var SrcCurrGLEntryAmt: Decimal; var SrcCurrGLEntryVATAmt: Decimal; var SrcCurrGLEntryBaseAmt: Decimal; AddCurrGLEntryVATAmt: Decimal; var NextConnectionNo: Integer; var NextVATEntryNo: Integer; var NextTransactionNo: Integer; TempGLEntryBufEntryNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertVATEntry(GenJournalLine: Record "Gen. Journal Line"; VATEntry: Record "VAT Entry"; GLEntryNo: Integer; var NextEntryNo: Integer)
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnAfterRunWithCheck(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnAfterRunWithoutCheck(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostPmtDiscountVATByUnapply(var GenJournalLine: Record "Gen. Journal Line"; var VATEntry: Record "VAT Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOldCustLedgEntryModify(var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeApplyCustLedgEntry(var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var GenJournalLine: Record "Gen. Journal Line"; Customer: Record Customer; var IsAmountToApplyCheckHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterOldVendLedgEntryModify(var VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeApplyVendLedgEntry(var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var GenJournalLine: Record "Gen. Journal Line"; Vendor: Record Vendor; var IsAmountToApplyCheckHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCustLedgEntryInsert(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeVendLedgEntryInsert(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertDtldCustLedgEntry(var DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; GenJournalLine: Record "Gen. Journal Line"; DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertDtldCustLedgEntryUnapply(var NewDetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; GenJournalLine: Record "Gen. Journal Line"; OldDetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertDtldEmplLedgEntry(var DetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry"; GenJournalLine: Record "Gen. Journal Line"; DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertDtldEmplLedgEntryUnapply(var NewDetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry"; GenJournalLine: Record "Gen. Journal Line"; OldDetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertDtldVendLedgEntry(var DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry"; GenJournalLine: Record "Gen. Journal Line"; DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertDtldVendLedgEntryUnapply(var NewDetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry"; GenJournalLine: Record "Gen. Journal Line"; OldDetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertGLEntryBuffer(var TempGLEntryBuf: Record "G/L Entry" temporary; var GenJournalLine: Record "Gen. Journal Line"; var BalanceCheckAmount: Decimal; var BalanceCheckAmount2: Decimal; var BalanceCheckAddCurrAmount: Decimal; var BalanceCheckAddCurrAmount2: Decimal; var NextEntryNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertGlobalGLEntry(var GlobalGLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertTempVATEntry(var TempVATEntry: Record "VAT Entry" temporary; GenJournalLine: Record "Gen. Journal Line"; VATEntry: Record "VAT Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInitBankAccLedgEntry(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInitCheckEntry(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var CheckLedgerEntry: Record "Check Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInitCustLedgEntry(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInitEmployeeLedgEntry(var EmployeeLedgerEntry: Record "Employee Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInitVendLedgEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInitGLEntry(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInitVAT(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; var VATPostingSetup: Record "VAT Posting Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertGLEntryFromVATEntry(var GLEntry: Record "G/L Entry"; VATEntry: Record "VAT Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertVAT(var GenJournalLine: Record "Gen. Journal Line"; var VATEntry: Record "VAT Entry"; var UnrealizedVAT: Boolean; var AddCurrencyCode: Code[10]; var VATPostingSetup: Record "VAT Posting Setup"; var GLEntryAmount: Decimal; var GLEntryVATAmount: Decimal; var GLEntryBaseAmount: Decimal; var SrcCurrCode: Code[10]; var SrcCurrGLEntryAmt: Decimal; var SrcCurrGLEntryVATAmt: Decimal; var SrcCurrGLEntryBaseAmt: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertVATEntry(var VATEntry: Record "VAT Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertPostUnrealVATEntry(var VATEntry: Record "VAT Entry"; GenJournalLine: Record "Gen. Journal Line"; var VATEntry2: Record "VAT Entry")
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnBeforeFinishPosting(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFinishPosting(var GlobalGLEntry: Record "G/L Entry"; var GLRegister: Record "G/L Register"; var IsTransactionConsistent: Boolean; var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGLFinishPosting(GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line"; IsTransactionConsistent: Boolean; FirstTransactionNo: Integer; var GLRegister: Record "G/L Register"; var TempGLEntryBuf: Record "G/L Entry" temporary; var NextEntryNo: Integer; var NextTransactionNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnNextTransactionNoNeeded(GenJournalLine: Record "Gen. Journal Line"; LastDocType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder; LastDocNo: Code[20]; LastDate: Date; CurrentBalance: Decimal; CurrentBalanceACY: Decimal; var NewTransaction: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostGLAcc(var GenJournalLine: Record "Gen. Journal Line"; var TempGLEntryBuf: Record "G/L Entry" temporary; var NextEntryNo: Integer; var NextTransactionNo: Integer; Balancing: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCalcPmtDiscOnAfterAssignPmtDisc(var PmtDisc: Decimal; var PmtDiscLCY: Decimal; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCalcPmtToleranceOnAfterAssignPmtDisc(var PmtTol: Decimal; var PmtTolLCY: Decimal; var PmtTolAmtToBeApplied: Decimal; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer"; var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var NextTransactionNo: Integer; var FirstNewVATEntryNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCalcPmtDiscIfAdjVATCopyFields(var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostDeferral(var GenJournalLine: Record "Gen. Journal Line"; var TempGLEntryBuf: Record "G/L Entry" temporary; AccountNo: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostDeferral(var GenJournalLine: Record "Gen. Journal Line"; var AccountNo: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
#pragma warning disable AL0432 // TODO - tag V18
    local procedure OnBeforeCreateGLEntriesForTotalAmounts(var InvoicePostBuffer: Record "Invoice Post. Buffer"; GenJournalLine: Record "Gen. Journal Line"; GLAccNo: Code[20])
#pragma warning restore AL0432 // TODO - tag V18
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostDtldCVLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; Unapply: Boolean; AccNo: Code[20]; AdjAmount: array[4] of Decimal; var NextEntryNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostDtldCVLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var AccNo: Code[20]; Unapply: Boolean; var AdjAmount: array[4] of Decimal)
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnAfterPostGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostCust(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean; var TempGLEntryBuf: Record "G/L Entry" temporary; var NextEntryNo: Integer; var NextTransactionNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostVend(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean; var TempGLEntryBuf: Record "G/L Entry" temporary; var NextEntryNo: Integer; var NextTransactionNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostVAT(GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; VATPostingSetup: Record "VAT Posting Setup")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcAmtLCYAdjustment(var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcAplication(var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var GenJournalLine: Record "Gen. Journal Line"; var AppliedAmount: Decimal; var AppliedAmountLCY: Decimal; var OldAppliedAmount: Decimal; var PrevNewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var PrevOldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var AllApplied: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcPmtTolerance(var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var GenJournalLine: Record "Gen. Journal Line"; var PmtTolAmtToBeApplied: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcPmtDisc(var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var GenJournalLine: Record "Gen. Journal Line"; var PmtTolAmtToBeApplied: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcPmtDiscTolerance(var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindNextOldCustLedgEntryToApply(var GenJournalLine: Record "Gen. Journal Line"; var TempOldCustLedgerEntry: Record "Cust. Ledger Entry" temporary; var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var Completed: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindNextOldEmplLedgEntryToApply(var GenJournalLine: Record "Gen. Journal Line"; var TempOldEmployeeLedgerEntry: Record "Employee Ledger Entry" temporary; var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var Completed: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindNextOldVendLedgEntryToApply(var GenJournalLine: Record "Gen. Journal Line"; var TempOldVendorLedgerEntry: Record "Vendor Ledger Entry" temporary; var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var Completed: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetDtldCustLedgEntryAccNo(var GenJournalLine: Record "Gen. Journal Line"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var CustomerPostingGroup: Record "Customer Posting Group"; OriginalTransactionNo: Integer; Unapply: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetDtldVendLedgEntryAccNo(var GenJournalLine: Record "Gen. Journal Line"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var VendorPostingGroup: Record "Vendor Posting Group"; OriginalTransactionNo: Integer; Unapply: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalcMinimalPossibleLiability(var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer"; var MinimalPossibleLiability: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalcPaymentExceedsLiability(var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer"; var MinimalPossibleLiability: Decimal; var PaymentExceedsLiability: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalcToleratedPaymentExceedsLiability(var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer"; var MinimalPossibleLiability: Decimal; var ToleratedPaymentExceedsLiability: Boolean; var PmtTolAmtToBeApplied: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalcPmtDiscount(var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var GenJournalLine: Record "Gen. Journal Line"; var PmtTolAmtToBeApplied: Decimal; var PmtDisc: Decimal; var PmtDiscLCY: Decimal; var PmtDiscAddCurr: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalcPmtDiscTolerance(var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var GenJournalLine: Record "Gen. Journal Line"; var PmtDiscTol: Decimal; var PmtDiscTolLCY: Decimal; var PmtDiscTolAddCurr: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitOldDtldCVLedgEntryBuf(var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var DePrevNewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var PrevOldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitNewDtldCVLedgEntryBuf(var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var DePrevNewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var PrevOldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnAfterSettingIsTransactionConsistent(GenJournalLine: Record "Gen. Journal Line"; var IsTransactionConsistent: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcCurrencyApplnRounding(GenJournalLine: Record "Gen. Journal Line"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer"; var OldCVLedgerEntryBuffer3: Record "CV Ledger Entry Buffer"; var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var NewCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcCurrencyRealizedGainLoss(var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var TempDetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer" temporary; var GenJournalLine: Record "Gen. Journal Line"; var AppliedAmount: Decimal; var AppliedAmountLCY: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcCurrencyUnrealizedGainLoss(var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var TempDetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer" temporary; var GenJournalLine: Record "Gen. Journal Line"; var AppliedAmount: Decimal; var RemainingAmountBeforeAppln: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostApply(GenJournalLine: Record "Gen. Journal Line"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var NewCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostApply(GenJournalLine: Record "Gen. Journal Line"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var NewCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer")
    begin
    end;

    [IntegrationEvent(false, false)]
#pragma warning disable AL0432
    local procedure OnBeforeUpdateTotalAmounts(var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary; var DimSetID: Integer; var AmountToCollect: Decimal; var AmountACYToCollect: Decimal; var IsHandled: Boolean; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer")
#pragma warning restore AL0432
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertPmtDiscVATForGLEntry(var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GenJournalLine: Record "Gen. Journal Line"; VATEntry: Record "VAT Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateGLEntryGainLossInsertGLEntry(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
#pragma warning disable AL0432
    local procedure OnBeforeCreateGLEntriesForTotalAmountsUnapply(DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; var CustomerPostingGroup: Record "Customer Posting Group"; GenJournalLine: Record "Gen. Journal Line"; var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary)
#pragma warning restore AL0432
    begin
    end;

    [IntegrationEvent(false, false)]
#pragma warning disable AL0432
    local procedure OnBeforeCreateGLEntriesForTotalAmountsUnapplyVendor(DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry"; var VendorPostingGroup: Record "Vendor Posting Group"; GenJournalLine: Record "Gen. Journal Line"; var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary)
#pragma warning restore AL0432
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInitGLEntryVAT(GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitGLEntryVAT(GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInitGLEntryVATCopy(GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; var VATEntry: Record "VAT Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitGLEntryVATCopy(GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostUnrealVATEntry(GenJournalLine: Record "Gen. Journal Line"; var VATEntry: Record "VAT Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostUnrealVATEntry(GenJournalLine: Record "Gen. Journal Line"; var VATEntry2: Record "VAT Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterHandleAddCurrResidualGLEntry(GenJournalLine: Record "Gen. Journal Line"; GLEntry2: Record "G/L Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalcCurrencyRealizedGainLoss(var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; AppliedAmount: Decimal; AppliedAmountLCY: Decimal; var RealizedGainLossLCY: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSalesTaxCalculateCalculateTax(var GenJournalLine: Record "Gen. Journal Line"; GLEntry: Record "G/L Entry"; Currency: Record Currency)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSalesTaxCalculateInitSalesTaxLines(var GenJournalLine: Record "Gen. Journal Line"; GLEntry: Record "G/L Entry"; SalesTaxBaseAmount: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSalesTaxCalculateReverseCalculateTax(var GenJournalLine: Record "Gen. Journal Line"; GLEntry: Record "G/L Entry"; Currency: Record Currency)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateVATEntryTaxDetails(var VATEntry: Record "VAT Entry"; TaxDetail: Record "Tax Detail")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnApplyCustLedgEntryOnAfterRecalculateAmounts(var TempOldCustLedgerEntry: Record "Cust. Ledger Entry" temporary; OldCustLedgerEntry: Record "Cust. Ledger Entry"; CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnApplyCustLedgEntryOnBeforePrepareTempCustLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; var NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var NextEntryNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnApplyVendLedgEntryOnAfterRecalculateAmounts(var TempOldVendorLedgerEntry: Record "Vendor Ledger Entry" temporary; OldVendorLedgerEntry: Record "Vendor Ledger Entry"; CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCustLedgEntryModify(var CustLedgerEntry: Record "Cust. Ledger Entry"; DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeVendLedgEntryModify(var VendorLedgerEntry: Record "Vendor Ledger Entry"; DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeEmplLedgEntryModify(var EmployeeLedgerEntry: Record "Employee Ledger Entry"; DetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePrepareTempCustledgEntry(var GenJournalLine: Record "Gen. Journal Line"; var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePrepareTempVendLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetDeferralDescription(GenJournalLine: Record "Gen. Journal Line"; DeferralLine: Record "Deferral Line"; var DeferralDescription: Text[100]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnCodeOnBeforeFinishPosting(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnContinuePostingOnBeforeCalculateCurrentBalance(var GenJournalLine: Record "Gen. Journal Line"; var NextTransactionNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCustPostApplyCustLedgEntryOnBeforeCheckPostingGroup(var GenJournalLine: Record "Gen. Journal Line"; var Customer: Record Customer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCustPostApplyCustLedgEntryOnBeforeFinishPosting(var GenJournalLine: Record "Gen. Journal Line"; CustLedgerEntry: Record "Cust. Ledger Entry");
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnHandleAddCurrResidualGLEntryOnBeforeInsertGLEntry(GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnHandleDtldAdjustmentOnBeforeInitGLEntry(GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; TotalAmountLCY: Decimal; TotalAmountAddCurr: Decimal; GLAccNo: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInitVATOnBeforeVATPostingSetupCheck(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; var VATPostingSetup: Record "VAT Posting Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInitVATOnBeforeTestFullVATAccount(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; var VATPostingSetup: Record "VAT Posting Setup"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertPmtDiscVATForGLEntryOnAfterCopyFromGenJnlLine(var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertTempVATEntryOnBeforeInsert(var VATEntry: Record "VAT Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertVATEntriesFromTempOnBeforeVATEntryInsert(var VATEntry: Record "VAT Entry"; TempVATEntry: Record "VAT Entry" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertVATOnBeforeCreateGLEntryForReverseChargeVATToPurchAcc(var GenJournalLine: Record "Gen. Journal Line"; VATPostingSetup: Record "VAT Posting Setup"; UnrealizedVAT: Boolean; VATAmount: Decimal; VATAmountAddCurr: Decimal; UseAmountAddCurr: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertVATOnBeforeCreateGLEntryForReverseChargeVATToRevChargeAcc(var GenJournalLine: Record "Gen. Journal Line"; VATPostingSetup: Record "VAT Posting Setup"; UnrealizedVAT: Boolean; VATAmount: Decimal; VATAmountAddCurr: Decimal; UseAmountAddCurr: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostApplyOnAfterRecalculateAmounts(var OldCVLedgerEntryBuffer2: Record "CV Ledger Entry Buffer"; OldCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; NewCVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostBankAccOnAfterBankAccLedgEntryInsert(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; BankAccount: Record "Bank Account")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostBankAccOnBeforeBankAccLedgEntryInsert(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; BankAccount: Record "Bank Account")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostBankAccOnAfterCheckLedgEntryInsert(var CheckLedgerEntry: Record "Check Ledger Entry"; var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; BankAccount: Record "Bank Account")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostBankAccOnBeforeCheckLedgEntryInsert(var CheckLedgerEntry: Record "Check Ledger Entry"; var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line"; BankAccount: Record "Bank Account")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostBankAccOnBeforeInitBankAccLedgEntry(var GenJournalLine: Record "Gen. Journal Line"; CurrencyFactor: Decimal; var NextEntryNo: Integer; var NextTransactionNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostCustOnAfterCopyCVLedgEntryBuf(var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostVendOnAfterCopyCVLedgEntryBuf(var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostDtldCVLedgEntryOnBeforeCreateGLEntryGainLoss(var GenJournalLine: Record "Gen. Journal Line"; DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; var Unapply: Boolean; var AccNo: Code[20])
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnPostGLAccOnBeforeInsertGLEntry(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnPostFixedAssetOnBeforeInsertGLEntry(var GenJournalLine: Record "Gen. Journal Line"; var GLEntry: Record "G/L Entry"; var IsHandled: Boolean; var TempFAGLPostingBuffer: Record "FA G/L Posting Buffer" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostUnapplyOnAfterVATEntrySetFilters(var VATEntry: Record "VAT Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostUnapplyOnBeforeUnapplyVATEntry(var VATEntry: Record "VAT Entry"; var UnapplyVATEntry: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostUnapplyOnBeforeVATEntryInsert(var VATEntry: Record "VAT Entry"; GenJournalLine: Record "Gen. Journal Line"; OrigVATEntry: Record "VAT Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPrepareTempCustLedgEntryOnAfterSetFilters(var OldCustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line"; CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPrepareTempCustLedgEntryOnBeforeExit(var GenJournalLine: Record "Gen. Journal Line"; var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var TempOldCustLedgerEntry: Record "Cust. Ledger Entry" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPrepareTempCustLedgEntryOnBeforeTestPositive(var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPrepareTempCustLedgEntryOnBeforeTempOldCustLedgEntryInsert(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPrepareTempVendLedgEntryOnAfterSetFilters(var OldVendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line"; CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPrepareTempVendLedgEntryOnBeforeExit(var GenJournalLine: Record "Gen. Journal Line"; var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; var TempOldVendorLedgerEntry: Record "Vendor Ledger Entry" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPrepareTempVendLedgEntryOnBeforeTempOldVendLedgEntryInsert(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUnapplyCustLedgEntryOnAfterCreateGLEntriesForTotalAmounts(var GenJournalLine: Record "Gen. Journal Line"; DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUnapplyCustLedgEntryOnAfterDtldCustLedgEntrySetFilters(var DetailedCustLedgEntry2: Record "Detailed Cust. Ledg. Entry"; DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUnapplyCustLedgEntryOnBeforeCheckPostingGroup(var GenJournalLine: Record "Gen. Journal Line"; Customer: Record Customer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUnapplyCustLedgEntryOnBeforePostUnapply(var DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; var DetailedCustLedgEntry2: Record "Detailed Cust. Ledg. Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUnapplyVendLedgEntryOnAfterCreateGLEntriesForTotalAmounts(var GenJournalLine: Record "Gen. Journal Line"; DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUnapplyVendLedgEntryOnAfterFilterSourceEntries(var DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry"; var DetailedVendorLedgEntry2: Record "Detailed Vendor Ledg. Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUnapplyVendLedgEntryOnBeforeCheckPostingGroup(var GenJournalLine: Record "Gen. Journal Line"; Vendor: Record Vendor)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUnapplyVendLedgEntryOnBeforePostUnapply(var DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry"; var DetailedVendorLedgEntry2: Record "Detailed Vendor Ledg. Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCustUnrealizedVATOnAfterVATPartCalculation(GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry"; PaidAmount: Decimal; TotalUnrealVATAmountFirst: Decimal; TotalUnrealVATAmountLast: Decimal; SettledAmount: Decimal; VATEntry2: Record "VAT Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCustUnrealizedVATOnBeforeInitGLEntryVAT(var GenJournalLine: Record "Gen. Journal Line"; var VATEntry: Record "VAT Entry"; var VATAmount: Decimal; var VATBase: Decimal; var VATAmountAddCurr: Decimal; var VATBaseAddCurr: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnVendPostApplyVendLedgEntryOnBeforeCheckPostingGroup(var GenJournalLine: Record "Gen. Journal Line"; Vendor: Record Vendor)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnVendPostApplyVendLedgEntryOnBeforeFinishPosting(var GenJournalLine: Record "Gen. Journal Line"; VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnVendUnrealizedVATOnAfterVATPartCalculation(GenJournalLine: Record "Gen. Journal Line"; var VendorLedgerEntry: Record "Vendor Ledger Entry"; PaidAmount: Decimal; TotalUnrealVATAmountFirst: Decimal; TotalUnrealVATAmountLast: Decimal; SettledAmount: Decimal; VATEntry2: Record "VAT Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnVendUnrealizedVATOnBeforeInitGLEntryVAT(var GenJournalLine: Record "Gen. Journal Line"; var VATEntry: Record "VAT Entry"; var VATAmount: Decimal; var VATBase: Decimal; var VATAmountAddCurr: Decimal; var VATBaseAddCurr: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnMoveGenJournalLine(var GenJournalLine: Record "Gen. Journal Line"; ToRecordID: RecordId)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitLastDocDate(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;
}
