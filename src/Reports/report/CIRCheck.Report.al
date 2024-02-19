report 50018 "CIR Check"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RDL/Check.rdl';

    Caption = 'Check', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Chèque"}]}';
    Permissions = TableData "Bank Account" = m;

    dataset
    {
        dataitem(VoidGenJnlLine; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
            RequestFilterFields = "Journal Template Name", "Journal Batch Name", "Posting Date";

            trigger OnAfterGetRecord()
            begin
                CheckManagement.VoidCheck(VoidGenJnlLine);
            end;

            trigger OnPreDataItem()
            begin
                IF CurrReport.PREVIEW THEN
                    ERROR(PreviewIsNotAllowed_Txt);

                IF UseCheckNo = '' THEN
                    ERROR(LastCheckNoMustBeFilledIn_Txt);

                IF TestPrint THEN
                    CurrReport.BREAK();

                IF NOT ReprintChecks THEN
                    CurrReport.BREAK();

                IF (GETFILTER("Line No.") <> '') OR (GETFILTER("Document No.") <> '') THEN
                    ERROR(
                      FiltersOnP1AndP2AreNotAllowed_Txt, FIELDCAPTION("Line No."), FIELDCAPTION("Document No."));
                SETRANGE("Bank Payment Type", "Bank Payment Type"::"Computer Check");
                SETRANGE("Check Printed", TRUE);
            end;
        }
        dataitem(GenJnlLine; "Gen. Journal Line")
        {
            DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");

            column(JnlTemplName_GenJnlLine; "Journal Template Name")
            {
            }
            column(JnlBatchName_GenJnlLine; "Journal Batch Name")
            {
            }
            column(LineNo_GenJnlLine; "Line No.")
            {
            }
            dataitem(CheckPages; Integer)
            {
                DataItemTableView = SORTING(Number);
                column(CheckToAddr1; CheckToAddr[1])
                {
                }
                column(CheckDateText; CheckDateText)
                {
                }
                column(CheckNoText; CheckNoText)
                {
                }
                column(FirstPage; FirstPage)
                {
                }
                column(PreprintedStub; PreprintedStub)
                {
                }
                column(CheckNoTextCaption; CheckNoTextCaption_Lbl)
                {
                }
                dataitem(PrintSettledLoop; Integer)
                {
                    DataItemTableView = SORTING(Number);
                    MaxIteration = 30;
                    column(NetAmount; NetAmount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(TotalLineDiscountLineDisc; TotalLineDiscount - LineDiscount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(TotalLineAmountLineAmount; TotalLineAmount - LineAmount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(TotalLineAmountLineAmount2; TotalLineAmount - LineAmount2)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(LineAmount; LineAmount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(LineDiscount; LineDiscount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(LineAmountLineDiscount; LineAmount + LineDiscount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(DocNo; DocNo)
                    {
                    }
                    column(DocDate; DocDate)
                    {
                    }
                    column(CurrencyCode2; CurrencyCode2)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(CurrentLineAmount; CurrentLineAmount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(ExtDocNo; ExtDocNo)
                    {
                    }
                    column(LineAmountCaption; LineAmountCaption_Lbl)
                    {
                    }
                    column(LineDiscountCaption; LineDiscountCaption_Lbl)
                    {
                    }
                    column(AmountCaption; AmountCaption_Lbl)
                    {
                    }
                    column(DocNoCaption; DocNoCaption_Lbl)
                    {
                    }
                    column(DocDateCaption; DocDateCaption_Lbl)
                    {
                    }
                    column(CurrencyCodeCaption; CurrencyCodeCaption_Lbl)
                    {
                    }
                    column(YourDocNoCaption; YourDocNoCaption_Lbl)
                    {
                    }
                    column(TransportCaption; TransportCaption_Lbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF NOT TestPrint THEN BEGIN
                            IF FoundLast THEN BEGIN
                                IF RemainingAmount <> 0 THEN BEGIN
                                    DocNo := '';
                                    ExtDocNo := '';
                                    DocDate := 0D;
                                    LineAmount := RemainingAmount;
                                    LineAmount2 := RemainingAmount;
                                    CurrentLineAmount := LineAmount2;
                                    LineDiscount := 0;
                                    RemainingAmount := 0;
                                END ELSE
                                    CurrReport.BREAK();
                            END ELSE
                                CASE ApplyMethod OF
                                    ApplyMethod::OneLineOneEntry:
                                        BEGIN
                                            CASE BalancingType OF
                                                BalancingType::Customer:
                                                    BEGIN
                                                        CustLedgEntry.RESET();
                                                        CustLedgEntry.SETCURRENTKEY("Document No.");
                                                        CustLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
                                                        CustLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
                                                        CustLedgEntry.SETRANGE("Customer No.", BalancingNo);
                                                        CustLedgEntry.FindFirst();
                                                        CustUpdateAmounts(CustLedgEntry, RemainingAmount);
                                                    END;
                                                BalancingType::Vendor:
                                                    BEGIN
                                                        VendLedgEntry.RESET();
                                                        VendLedgEntry.SETCURRENTKEY("Document No.");
                                                        VendLedgEntry.SETRANGE("Document Type", GenJnlLine."Applies-to Doc. Type");
                                                        VendLedgEntry.SETRANGE("Document No.", GenJnlLine."Applies-to Doc. No.");
                                                        VendLedgEntry.SETRANGE("Vendor No.", BalancingNo);
                                                        VendLedgEntry.FindFirst();
                                                        VendUpdateAmounts(VendLedgEntry, RemainingAmount);
                                                    END;
                                            END;
                                            RemainingAmount := RemainingAmount - LineAmount2;
                                            CurrentLineAmount := LineAmount2;
                                            FoundLast := TRUE;
                                        END;
                                    ApplyMethod::OneLineID:
                                        BEGIN
                                            CASE BalancingType OF
                                                BalancingType::Customer:
                                                    BEGIN
                                                        CustUpdateAmounts(CustLedgEntry, RemainingAmount);
                                                        FoundLast := (CustLedgEntry.NEXT() = 0) OR (RemainingAmount <= 0);
                                                        IF FoundLast AND NOT FoundNegative THEN BEGIN
                                                            CustLedgEntry.SETRANGE(Positive, FALSE);
                                                            FoundLast := NOT CustLedgEntry.FindFirst();
                                                            FoundNegative := TRUE;
                                                        END;
                                                    END;
                                                BalancingType::Vendor:
                                                    BEGIN
                                                        VendUpdateAmounts(VendLedgEntry, RemainingAmount);
                                                        FoundLast := (VendLedgEntry.NEXT() = 0) OR (RemainingAmount <= 0);
                                                        IF FoundLast AND NOT FoundNegative THEN BEGIN
                                                            VendLedgEntry.SETRANGE(Positive, FALSE);
                                                            FoundLast := NOT VendLedgEntry.FindFirst();
                                                            FoundNegative := TRUE;
                                                        END;
                                                    END;
                                            END;
                                            RemainingAmount := RemainingAmount - LineAmount2;
                                            CurrentLineAmount := LineAmount2;
                                        END;
                                    ApplyMethod::MoreLinesOneEntry:
                                        BEGIN
                                            CurrentLineAmount := GenJnlLine2.Amount;
                                            LineAmount2 := CurrentLineAmount;

                                            IF GenJnlLine2."Applies-to ID" <> '' THEN
                                                ERROR(InTheCheckReportOneCheckPerVendor_Txt);
                                            GenJnlLine2.TESTFIELD("Check Printed", FALSE);
                                            GenJnlLine2.TESTFIELD("Bank Payment Type", GenJnlLine2."Bank Payment Type"::"Computer Check");
                                            IF BankAcc2."Currency Code" <> GenJnlLine2."Currency Code" THEN
                                                ERROR(TheBankAccountAndTheGeneralJournalLineMustHaveTheSameCurrency_Txt);
                                            IF GenJnlLine2."Applies-to Doc. No." = '' THEN BEGIN
                                                DocNo := '';
                                                ExtDocNo := '';
                                                DocDate := 0D;
                                                LineAmount := CurrentLineAmount;
                                                LineDiscount := 0;
                                            END ELSE
                                                CASE BalancingType OF
                                                    BalancingType::"G/L Account":
                                                        BEGIN
                                                            DocNo := GenJnlLine2."Document No.";
                                                            ExtDocNo := GenJnlLine2."External Document No.";
                                                            LineAmount := CurrentLineAmount;
                                                            LineDiscount := 0;
                                                        END;
                                                    BalancingType::Customer:
                                                        BEGIN
                                                            CustLedgEntry.RESET();
                                                            CustLedgEntry.SETCURRENTKEY("Document No.");
                                                            CustLedgEntry.SETRANGE("Document Type", GenJnlLine2."Applies-to Doc. Type");
                                                            CustLedgEntry.SETRANGE("Document No.", GenJnlLine2."Applies-to Doc. No.");
                                                            CustLedgEntry.SETRANGE("Customer No.", BalancingNo);
                                                            CustLedgEntry.FindFirst();
                                                            CustUpdateAmounts(CustLedgEntry, CurrentLineAmount);
                                                            LineAmount := CurrentLineAmount;
                                                        END;
                                                    BalancingType::Vendor:
                                                        BEGIN
                                                            VendLedgEntry.RESET();
                                                            IF GenJnlLine2."Source Line No." <> 0 THEN
                                                                VendLedgEntry.SETRANGE("Entry No.", GenJnlLine2."Source Line No.")
                                                            ELSE BEGIN
                                                                VendLedgEntry.SETCURRENTKEY("Document No.");
                                                                VendLedgEntry.SETRANGE("Document Type", GenJnlLine2."Applies-to Doc. Type");
                                                                VendLedgEntry.SETRANGE("Document No.", GenJnlLine2."Applies-to Doc. No.");
                                                                VendLedgEntry.SETRANGE("Vendor No.", BalancingNo);
                                                            END;
                                                            VendLedgEntry.FindFirst();
                                                            VendUpdateAmounts(VendLedgEntry, CurrentLineAmount);
                                                            LineAmount := CurrentLineAmount;
                                                        END;
                                                    BalancingType::"Bank Account":
                                                        BEGIN
                                                            DocNo := GenJnlLine2."Document No.";
                                                            ExtDocNo := GenJnlLine2."External Document No.";
                                                            LineAmount := CurrentLineAmount;
                                                            LineDiscount := 0;
                                                        END;
                                                END;

                                            FoundLast := GenJnlLine2.NEXT() = 0;
                                        END;

                                END;

                            TotalLineAmount := TotalLineAmount + LineAmount2;
                            TotalLineDiscount := TotalLineDiscount + LineDiscount;
                        END ELSE BEGIN
                            IF FoundLast THEN
                                CurrReport.BREAK();
                            FoundLast := TRUE;
                            DocNo := XXXXXXXXXX_Txt;
                            ExtDocNo := XXXXXXXXXX_Txt;
                            LineAmount := 0;
                            LineDiscount := 0;
                        END;
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF NOT TestPrint THEN
                            IF FirstPage THEN BEGIN
                                FoundLast := TRUE;
                                CASE ApplyMethod OF
                                    ApplyMethod::OneLineOneEntry:
                                        FoundLast := FALSE;
                                    ApplyMethod::OneLineID:
                                        CASE BalancingType OF
                                            BalancingType::Customer:
                                                BEGIN
                                                    CustLedgEntry.RESET();
                                                    CustLedgEntry.SETCURRENTKEY("Customer No.", Open, Positive);
                                                    CustLedgEntry.SETRANGE("Customer No.", BalancingNo);
                                                    CustLedgEntry.SETRANGE(Open, TRUE);
                                                    CustLedgEntry.SETRANGE(Positive, TRUE);
                                                    CustLedgEntry.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
                                                    FoundLast := NOT CustLedgEntry.FindFirst();
                                                    IF FoundLast THEN BEGIN
                                                        CustLedgEntry.SETRANGE(Positive, FALSE);
                                                        FoundLast := NOT CustLedgEntry.FindFirst();
                                                        FoundNegative := TRUE;
                                                    END ELSE
                                                        FoundNegative := FALSE;
                                                END;
                                            BalancingType::Vendor:
                                                BEGIN
                                                    VendLedgEntry.RESET();
                                                    VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive);
                                                    VendLedgEntry.SETRANGE("Vendor No.", BalancingNo);
                                                    VendLedgEntry.SETRANGE(Open, TRUE);
                                                    VendLedgEntry.SETRANGE(Positive, TRUE);
                                                    VendLedgEntry.SETRANGE("Applies-to ID", GenJnlLine."Applies-to ID");
                                                    FoundLast := NOT VendLedgEntry.FindFirst();
                                                    IF FoundLast THEN BEGIN
                                                        VendLedgEntry.SETRANGE(Positive, FALSE);
                                                        FoundLast := NOT VendLedgEntry.FindFirst();
                                                        FoundNegative := TRUE;
                                                    END ELSE
                                                        FoundNegative := FALSE;
                                                END;
                                        END;
                                    ApplyMethod::MoreLinesOneEntry:
                                        FoundLast := FALSE;
                                END;
                            END
                            ELSE
                                FoundLast := FALSE;

                        IF DocNo = '' THEN
                            CurrencyCode2 := GenJnlLine."Currency Code";

                        IF PreprintedStub THEN
                            TotalText := ''
                        ELSE
                            TotalText := Total_Txt;

                        IF GenJnlLine."Currency Code" <> '' THEN
                            NetAmount := STRSUBSTNO(NetAmountP1_Txt, GenJnlLine."Currency Code")
                        ELSE BEGIN
                            GLSetup.GET();
                            NetAmount := STRSUBSTNO(NetAmountP1_Txt, GLSetup."LCY Code");
                        END;
                    end;
                }
                dataitem(PrintCheck; Integer)
                {
                    DataItemTableView = SORTING(Number);
                    MaxIteration = 1;
                    column(CheckAmountText; CheckAmountText)
                    {
                    }
                    column(CheckDateText2; CheckDateText)
                    {
                    }
                    column(DescriptionLine2; DescriptionLine[2])
                    {
                    }
                    column(DescriptionLine1; DescriptionLine[1])
                    {
                    }
                    column(CheckToAddr17; CheckToAddr[1])
                    {
                    }
                    column(CheckToAddr2; CheckToAddr[2])
                    {
                    }
                    column(CheckToAddr4; CheckToAddr[4])
                    {
                    }
                    column(CheckToAddr3; CheckToAddr[3])
                    {
                    }
                    column(CheckToAddr5; CheckToAddr[5])
                    {
                    }
                    column(CheckToAddr6; CheckToAddr[6])
                    {
                    }
                    column(CheckToAddr7; CheckToAddr[7])
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(CompanyAddr8; CompanyAddr[8])
                    {
                    }
                    column(CompanyAddr7; CompanyAddr[7])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(CheckNoText2; CheckNoText)
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(TotalLineAmount; TotalLineAmount)
                    {
                        AutoFormatExpression = GenJnlLine."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(TotalText; TotalText)
                    {
                    }
                    column(VoidText; VoidText)
                    {
                    }
                    column(CompanyInfo_City______le_____FORMAT_PostingDate_0_4_; CompanyInfo.City + On_Lbl + FORMAT(GenJnlLine."Posting Date", 0, 4))
                    {
                    }
                    column("Veuillez_trouver_sous_ce_pli__un_chèque_de_____FORMAT_Amount________tiré_sur_la_banque_____Bal__Account_No__"; TxtGLine1_Txt)
                    {
                    }
                    column("Recevez__Messieurs__l__expression_de_nos_salutations_distinguées__"; Greeting_Lbl)
                    {
                    }
                    column("RéférenceCaption"; ReferenceCaption_Lbl)
                    {
                    }
                    column(GenJnlLine_PaymentReference; GenJnlLine."Payment Reference")
                    {
                    }
                    column(HeaderText2; HeaderText2_Lbl)
                    {
                    }
                    column(CompanyInfo_City; CompanyInfo.City)
                    {
                    }
                    column(RecGBankAccountType; RecGBankAccount."Print Check Format")
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        Decimals: Decimal;
                        CheckLedgEntryAmount: Decimal;
                    begin

                        IF NOT TestPrint THEN BEGIN
                            CheckLedgEntry.INIT();
                            CheckLedgEntry."Bank Account No." := BankAcc2."No.";
                            CheckLedgEntry."Posting Date" := GenJnlLine."Posting Date";
                            CheckLedgEntry."Document Type" := GenJnlLine."Document Type";
                            CheckLedgEntry."Document No." := UseCheckNo;
                            CheckLedgEntry.Description := GenJnlLine.Description;
                            CheckLedgEntry."Bank Payment Type" := GenJnlLine."Bank Payment Type";
                            CheckLedgEntry."Bal. Account Type" := BalancingType;
                            CheckLedgEntry."Bal. Account No." := BalancingNo;
                            IF FoundLast THEN BEGIN
                                IF TotalLineAmount <= 0 THEN
                                    ERROR(
                                      TheAmountMustBePositive_Txt,
                                      UseCheckNo, TotalLineAmount);
                                CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::Printed;
                                CheckLedgEntry.Amount := TotalLineAmount;
                            END ELSE BEGIN
                                CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::Voided;
                                CheckLedgEntry.Amount := 0;
                            END;
                            CheckLedgEntry."Check Date" := GenJnlLine."Posting Date";
                            CheckLedgEntry."Check No." := UseCheckNo;
                            CheckManagement.InsertCheck(CheckLedgEntry, RECORDID);

                            IF FoundLast THEN BEGIN
                                IF BankAcc2."Currency Code" <> '' THEN
                                    Currency.GET(BankAcc2."Currency Code")
                                ELSE
                                    Currency.InitRoundingPrecision();
                                CheckLedgEntryAmount := CheckLedgEntry.Amount;
                                Decimals := CheckLedgEntry.Amount - ROUND(CheckLedgEntry.Amount, 1, '<');
                                IF STRLEN(FORMAT(Decimals)) < STRLEN(FORMAT(Currency."Amount Rounding Precision")) THEN
                                    IF Decimals = 0 THEN
                                        CheckAmountText := FORMAT(CheckLedgEntryAmount, 0, 0) +
                                          COPYSTR(FORMAT(0.01), 2, 1) +
                                          PADSTR('', STRLEN(FORMAT(Currency."Amount Rounding Precision")) - 2, '0')
                                    ELSE
                                        CheckAmountText := CopyStr(FORMAT(CheckLedgEntryAmount, 0, 0) +
                                          PADSTR('', STRLEN(FORMAT(Currency."Amount Rounding Precision")) - STRLEN(FORMAT(Decimals)), '0'), 1, MaxStrLen(CheckAmountText))
                                ELSE
                                    CheckAmountText := FORMAT(CheckLedgEntryAmount, 0, 0);
                                FormatNoText(DescriptionLine, CheckLedgEntry.Amount, BankAcc2."Currency Code");
                                VoidText := '';
                            END ELSE BEGIN
                                CLEAR(CheckAmountText);
                                CLEAR(DescriptionLine);
                                TotalText := Subtotal_Txt;
                                DescriptionLine[1] := VOIDVOIDVOID_Txt;
                                DescriptionLine[2] := DescriptionLine[1];
                                VoidText := NONNEGOTIABLE_Txt;
                            END;

                        END ELSE BEGIN
                            CheckLedgEntry.INIT();
                            CheckLedgEntry."Bank Account No." := BankAcc2."No.";
                            CheckLedgEntry."Posting Date" := GenJnlLine."Posting Date";
                            CheckLedgEntry."Document No." := UseCheckNo;
                            CheckLedgEntry.Description := TestPrint_Txt;
                            CheckLedgEntry."Bank Payment Type" := "Bank Payment Type"::"Computer Check";
                            CheckLedgEntry."Entry Status" := CheckLedgEntry."Entry Status"::"Test Print";
                            CheckLedgEntry."Check Date" := GenJnlLine."Posting Date";
                            CheckLedgEntry."Check No." := UseCheckNo;
                            CheckManagement.InsertCheck(CheckLedgEntry, RECORDID);

                            CheckAmountText := XXXX_XX_Txt;
                            DescriptionLine[1] := XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX_Txt;
                            DescriptionLine[2] := DescriptionLine[1];
                            VoidText := NONNEGOTIABLE_Txt;
                        END;

                        ChecksPrinted := ChecksPrinted + 1;
                        FirstPage := FALSE;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    IF FoundLast THEN
                        CurrReport.BREAK();

                    UseCheckNo := INCSTR(UseCheckNo);
                    IF NOT TestPrint THEN
                        CheckNoText := UseCheckNo
                    ELSE
                        CheckNoText := XXXX_Txt;
                end;

                trigger OnPostDataItem()
                begin
                    IF NOT TestPrint THEN BEGIN
                        IF UseCheckNo <> GenJnlLine."Document No." THEN BEGIN
                            GenJnlLine3.RESET();
                            GenJnlLine3.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                            GenJnlLine3.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                            GenJnlLine3.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
                            GenJnlLine3.SETRANGE("Posting Date", GenJnlLine."Posting Date");
                            GenJnlLine3.SETRANGE("Document No.", UseCheckNo);
                            IF GenJnlLine3.FindFirst() THEN
                                GenJnlLine3.FIELDERROR("Document No.", STRSUBSTNO(P1AlreadyExists_Txt, UseCheckNo));
                        END;

                        IF ApplyMethod <> ApplyMethod::MoreLinesOneEntry THEN BEGIN
                            GenJnlLine3 := GenJnlLine;
                            GenJnlLine3.TESTFIELD("Posting No. Series", '');
                            GenJnlLine3."Document No." := UseCheckNo;
                            GenJnlLine3."Check Printed" := TRUE;
                            GenJnlLine3.MODIFY();
                        END ELSE BEGIN
                            IF GenJnlLine2.FindFirst() THEN BEGIN
                                HighestLineNo := GenJnlLine2."Line No.";
                                REPEAT
                                    IF GenJnlLine2."Line No." > HighestLineNo THEN
                                        HighestLineNo := GenJnlLine2."Line No.";
                                    GenJnlLine3 := GenJnlLine2;
                                    GenJnlLine3.TESTFIELD("Posting No. Series", '');
                                    GenJnlLine3."Bal. Account No." := '';
                                    GenJnlLine3."Bank Payment Type" := GenJnlLine3."Bank Payment Type"::" ";
                                    GenJnlLine3."Document No." := UseCheckNo;
                                    GenJnlLine3."Check Printed" := TRUE;
                                    GenJnlLine3.VALIDATE(Amount);
                                    GenJnlLine3.MODIFY();
                                UNTIL GenJnlLine2.NEXT() = 0;
                            END;

                            GenJnlLine3.RESET();
                            GenJnlLine3 := GenJnlLine;
                            GenJnlLine3.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                            GenJnlLine3.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
                            GenJnlLine3."Line No." := HighestLineNo;
                            IF GenJnlLine3.NEXT() = 0 THEN
                                GenJnlLine3."Line No." := HighestLineNo + 10000
                            ELSE BEGIN
                                WHILE GenJnlLine3."Line No." = HighestLineNo + 1 DO BEGIN
                                    HighestLineNo := GenJnlLine3."Line No.";
                                    IF GenJnlLine3.NEXT() = 0 THEN
                                        GenJnlLine3."Line No." := HighestLineNo + 20000;
                                END;
                                GenJnlLine3."Line No." := (GenJnlLine3."Line No." + HighestLineNo) DIV 2;
                            END;
                            GenJnlLine3.INIT();
                            GenJnlLine3.VALIDATE("Posting Date", GenJnlLine."Posting Date");
                            GenJnlLine3."Document Type" := GenJnlLine."Document Type";
                            GenJnlLine3."Document No." := UseCheckNo;
                            GenJnlLine3."Account Type" := GenJnlLine3."Account Type"::"Bank Account";
                            GenJnlLine3.VALIDATE("Account No.", BankAcc2."No.");
                            IF BalancingType <> BalancingType::"G/L Account" THEN
                                GenJnlLine3.Description := STRSUBSTNO(CheckForP1P2_Txt, BalancingType, BalancingNo);
                            GenJnlLine3.VALIDATE(Amount, -TotalLineAmount);
                            GenJnlLine3."Bank Payment Type" := GenJnlLine3."Bank Payment Type"::"Computer Check";
                            GenJnlLine3."Check Printed" := TRUE;
                            GenJnlLine3."Source Code" := GenJnlLine."Source Code";
                            GenJnlLine3."Reason Code" := GenJnlLine."Reason Code";
                            GenJnlLine3."Allow Zero-Amount Posting" := TRUE;
                            GenJnlLine3.INSERT();
                        END;
                    END;

                    BankAcc2."Last Check No." := UseCheckNo;
                    BankAcc2.MODIFY();

                    CLEAR(CheckManagement);
                end;

                trigger OnPreDataItem()
                begin
                    FirstPage := TRUE;
                    FoundLast := FALSE;
                    TotalLineAmount := 0;
                    TotalLineDiscount := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                IF OneCheckPrVendor AND (GenJnlLine."Currency Code" <> '') AND
                   (GenJnlLine."Currency Code" <> Currency.Code)
                THEN BEGIN
                    Currency.GET(GenJnlLine."Currency Code");
                    Currency.TESTFIELD("Conv. LCY Rndg. Debit Acc.");
                    Currency.TESTFIELD("Conv. LCY Rndg. Credit Acc.");
                END;

                IF "Bank Payment Type" = "Bank Payment Type"::"Computer Check" THEN
                    TESTFIELD("Exported to Payment File", FALSE);

                IF NOT TestPrint THEN BEGIN
                    IF Amount = 0 THEN
                        CurrReport.SKIP();

                    TESTFIELD("Bal. Account Type", "Bal. Account Type"::"Bank Account");
                    IF "Bal. Account No." <> BankAcc2."No." THEN
                        CurrReport.SKIP();

                    IF ("Account No." <> '') AND ("Bal. Account No." <> '') THEN BEGIN
                        BalancingType := "Account Type";
                        BalancingNo := "Account No.";
                        RemainingAmount := Amount;
                        IF OneCheckPrVendor THEN BEGIN
                            ApplyMethod := ApplyMethod::MoreLinesOneEntry;
                            GenJnlLine2.RESET();
                            GenJnlLine2.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.");
                            GenJnlLine2.SETRANGE("Journal Template Name", "Journal Template Name");
                            GenJnlLine2.SETRANGE("Journal Batch Name", "Journal Batch Name");
                            GenJnlLine2.SETRANGE("Posting Date", "Posting Date");
                            GenJnlLine2.SETRANGE("Document No.", "Document No.");
                            GenJnlLine2.SETRANGE("Account Type", "Account Type");
                            GenJnlLine2.SETRANGE("Account No.", "Account No.");
                            GenJnlLine2.SETRANGE("Bal. Account Type", "Bal. Account Type");
                            GenJnlLine2.SETRANGE("Bal. Account No.", "Bal. Account No.");
                            GenJnlLine2.SETRANGE("Bank Payment Type", "Bank Payment Type");
                            GenJnlLine2.FindFirst();
                            RemainingAmount := 0;
                        END ELSE
                            IF "Applies-to Doc. No." <> '' THEN
                                ApplyMethod := ApplyMethod::OneLineOneEntry
                            ELSE
                                IF "Applies-to ID" <> '' THEN
                                    ApplyMethod := ApplyMethod::OneLineID
                                ELSE
                                    ApplyMethod := ApplyMethod::Payment;
                    END ELSE
                        IF "Account No." = '' THEN
                            FIELDERROR("Account No.", MustBeEntered_Txt)
                        ELSE
                            FIELDERROR("Bal. Account No.", MustBeEntered_Txt);

                    CLEAR(CheckToAddr);
                    CLEAR(SalesPurchPerson);
                    CASE BalancingType OF
                        BalancingType::"G/L Account":
                            CheckToAddr[1] := CopyStr(GenJnlLine.Description, 1, MaxStrLen(CheckToAddr[1]));
                        BalancingType::Customer:
                            BEGIN
                                Cust.GET(BalancingNo);
                                IF Cust.Blocked = Cust.Blocked::All THEN
                                    ERROR(P1MustNotBeP2ForP3P4_Txt, Cust.FIELDCAPTION(Blocked), Cust.Blocked, Cust.TABLECAPTION, Cust."No.");
                                Cust.Contact := '';
                                FormatAddr.Customer(CheckToAddr, Cust);
                                IF BankAcc2."Currency Code" <> "Currency Code" THEN
                                    ERROR(TheBankAccountAndTheGeneralJournalLineMustHaveTheSameCurrency_Txt);
                                IF Cust."Salesperson Code" <> '' THEN
                                    SalesPurchPerson.GET(Cust."Salesperson Code");
                            END;
                        BalancingType::Vendor:
                            BEGIN
                                Vend.GET(BalancingNo);
                                IF Vend.Blocked IN [Vend.Blocked::All, Vend.Blocked::Payment] THEN
                                    ERROR(P1MustNotBeP2ForP3P4_Txt, Vend.FIELDCAPTION(Blocked), Vend.Blocked, Vend.TABLECAPTION, Vend."No.");
                                Vend.Contact := '';
                                FormatAddr.Vendor(CheckToAddr, Vend);
                                IF BankAcc2."Currency Code" <> "Currency Code" THEN
                                    ERROR(TheBankAccountAndTheGeneralJournalLineMustHaveTheSameCurrency_Txt);
                                IF Vend."Purchaser Code" <> '' THEN
                                    SalesPurchPerson.GET(Vend."Purchaser Code");
                            END;
                        BalancingType::Employee:
                            begin
                                Employee.get(BalancingNo);
                                if Employee.Status IN [Employee.Status::Inactive, Employee.Status::Terminated] then
                                    Error(P1MustNotBeP2ForP3P4_Txt, Employee.FIELDCAPTION(Status), Employee.Status, Employee.TABLECAPTION, Employee."No.");
                                FormatAddr.Employee(CheckToAddr, Employee);
                                IF BankAcc2."Currency Code" <> "Currency Code" THEN
                                    ERROR(TheBankAccountAndTheGeneralJournalLineMustHaveTheSameCurrency_Txt);
                                if Employee."Salespers./Purch. Code" <> '' then
                                    SalesPurchPerson.get(Employee."Salespers./Purch. Code");
                            end;
                        BalancingType::"Bank Account":
                            BEGIN
                                BankAcc.GET(BalancingNo);
                                BankAcc.TESTFIELD(Blocked, FALSE);
                                BankAcc.Contact := '';
                                FormatAddr.BankAcc(CheckToAddr, BankAcc);
                                IF BankAcc2."Currency Code" <> BankAcc."Currency Code" THEN
                                    ERROR(BothBankAccountsMustHaveTheSameCurrency_Txt);
                                IF BankAcc."Our Contact Code" <> '' THEN
                                    SalesPurchPerson.GET(BankAcc."Our Contact Code");
                            END;
                    END;
                    CheckDateText := FORMAT("Posting Date");
                END ELSE BEGIN
                    IF ChecksPrinted > 0 THEN
                        CurrReport.BREAK();
                    BalancingType := BalancingType::Vendor;
                    BalancingNo := XXXXXXXXXX_Txt;
                    CLEAR(CheckToAddr);
                    FOR i := 1 TO 5 DO
                        CheckToAddr[i] := XXXXXXXXXXXXXXXX__Txt;
                    CLEAR(SalesPurchPerson);
                    CheckNoText := XXXX_Txt;
                    CheckDateText := XX_XXXXXXXXXX_XXXX_Txt;
                END;

                RecGBankAccount.INIT();
                IF GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"Bank Account" THEN
                    IF RecGBankAccount.GET(GenJnlLine."Bal. Account No.") THEN;

                IF TestPrint THEN
                    TxtGLine1_Txt := StrSubstNo(TxtGLine1_Lbl, XXXX_XX_Txt, XXXXXXXXXX_Txt)
                ELSE
                    TxtGLine1_Txt := StrSubstNo(TxtGLine1_Lbl, FORMAT(GenJnlLine.Amount), GenJnlLine."Bal. Account No.");
            end;

            trigger OnPreDataItem()
            begin
                GenJnlLine.COPY(VoidGenJnlLine);
                CompanyInfo.GET();
                IF NOT TestPrint THEN BEGIN
                    FormatAddr.Company(CompanyAddr, CompanyInfo);
                    BankAcc2.GET(BankAcc2."No.");
                    BankAcc2.TESTFIELD(Blocked, FALSE);
                    COPY(VoidGenJnlLine);
                    SETRANGE("Bank Payment Type", "Bank Payment Type"::"Computer Check");
                    SETRANGE("Check Printed", FALSE);
                END ELSE BEGIN
                    CLEAR(CompanyAddr);
                    FOR i := 1 TO 5 DO
                        CompanyAddr[i] := XXXXXXXXXXXXXXXX__Txt;
                END;
                ChecksPrinted := 0;

                SETRANGE("Account Type", GenJnlLine."Account Type"::"Fixed Asset");
                IF FindFirst() THEN
                    GenJnlLine.FIELDERROR("Account Type");
                SETRANGE("Account Type");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Options"}]}';
                    field(BankAccount; BankAcc2."No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Bank Account', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Compte bancaire"}]}';
                        TableRelation = "Bank Account";
                        ToolTip = 'Specifies the bank account that the printed checks will be drawn from.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie le compte bancaire à partir duquel les chèques imprimés sont tirés."}]}';

                        trigger OnValidate()
                        begin
                            InputBankAccount();
                        end;
                    }
                    field(LastCheckNo; UseCheckNo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Last Check No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° dern. chèque"}]}';
                        ToolTip = 'Specifies the value of the Last Check No. field on the bank account card.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du champ N° dern. chèque sur la fiche compte bancaire."}]}';
                    }
                    field(OneCheckPerVendorPerDocumentNo; OneCheckPrVendor)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'One Check per Vendor per Document No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Un chèque par fournisseur par n° document"}]}';
                        MultiLine = true;
                        ToolTip = 'Specifies if only one check is printed per vendor for each document number.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Indique si un seul chèque est imprimé par fournisseur et par numéro de document."}]}';
                    }
                    field(ReprintChecks; ReprintChecks)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Reprint Checks', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Réimprimer les chèques"}]}';
                        ToolTip = 'Specifies if checks are printed again if you canceled the printing due to a problem.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Indique si les chèques sont imprimés à nouveau si vous avez annulé l''impression suite à un problème."}]}';
                    }
                    field(TestPrinting; TestPrint)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Test Print', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Impression test"}]}';
                        ToolTip = 'Specifies if you want to print the checks on blank paper before you print them on check forms.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Indique si vous souhaitez imprimer les chèques sur papier blanc avant de les imprimer sous forme de chèque."}]}';
                    }
                    field(PreprintedStub; PreprintedStub)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Preprinted Stub', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Formulaire préimprimé"}]}';
                        ToolTip = 'Specifies if you use check forms with preprinted stubs.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Indique si vous utilisez les formulaires chèque avec souches pré-imprimées."}]}';
                        Visible = false;
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            IF BankAcc2."No." <> '' THEN
                IF BankAcc2.GET(BankAcc2."No.") THEN
                    UseCheckNo := BankAcc2."Last Check No."
                ELSE BEGIN
                    BankAcc2."No." := '';
                    UseCheckNo := '';
                END;
            PreprintedStub := FALSE;
        end;
    }

    trigger OnPreReport()
    begin
        InitTextVariable();
    end;

    var
        CompanyInfo: Record "Company Information";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        GenJnlLine2: Record "Gen. Journal Line";
        GenJnlLine3: Record "Gen. Journal Line";
        Cust: Record "Customer";
        CustLedgEntry: record "Cust. Ledger Entry";
        Vend: Record Vendor;
        Employee: Record Employee;
        VendLedgEntry: Record "Vendor Ledger Entry";
        BankAcc: Record "Bank Account";
        BankAcc2: Record "Bank Account";
        CheckLedgEntry: Record "Check Ledger Entry";
        Currency: Record Currency;
        GLSetup: Record "General Ledger Setup";
        RecGBankAccount: Record "Bank Account";
        FormatAddr: Codeunit "Format Address";
        CheckManagement: Codeunit CheckManagement;
        PreviewIsNotAllowed_Txt: Label 'Preview is not allowed.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"L''aperçu n''est pas autorisé."}]}';
        LastCheckNoMustBeFilledIn_Txt: Label 'Last Check No. must be filled in.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le numéro du dernier chèque doit être renseigné."}]}';
        FiltersOnP1AndP2AreNotAllowed_Txt: Label 'Filters on %1 and %2 are not allowed.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Les filtres sur %1 et %2 ne sont pas autorisés."}]}';
        XXXXXXXXXXXXXXXX__Txt: Label 'XXXXXXXXXXXXXXXX', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"XXXXXXXXXXXXXXXX"}]}';
        MustBeEntered_Txt: Label 'must be entered.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"doit être entré(e)."}]}';
        TheBankAccountAndTheGeneralJournalLineMustHaveTheSameCurrency_Txt: Label 'The Bank Account and the General Journal Line must have the same currency.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le compte bancaire et la ligne feuille doivent indiquer la même devise."}]}';
        BothBankAccountsMustHaveTheSameCurrency_Txt: Label 'Both Bank Accounts must have the same currency.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Les deux comptes bancaires doivent indiquer la même devise."}]}';
        XXXXXXXXXX_Txt: Label 'XXXXXXXXXX', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"XXXXXXXXXX"}]}';
        XXXX_Txt: Label 'XXXX', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"XXXX"}]}';
        XX_XXXXXXXXXX_XXXX_Txt: Label 'XX.XXXXXXXXXX.XXXX', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"XX.XXXXXXXXXX.XXXX"}]}';
        P1AlreadyExists_Txt: Label '%1 already exists.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"%1 existe déjà."}]}';
        CheckForP1P2_Txt: Label 'Check for %1 %2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Chèque pour %1 %2"}]}';
        InTheCheckReportOneCheckPerVendor_Txt: Label 'In the Check report, One Check per Vendor and Document No.\must not be activated when Applies-to ID is specified in the journal lines.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Dans l''état Chèque, les options Un chèque par fournisseur et par N° document\\ne doivent pas être activées si ID lettrage est spécifié dans les lignes feuille."}]}';
        Total_Txt: Label 'Total', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Total"}]}';
        TheAmountMustBePositive_Txt: Label 'The total amount of check %1 is %2. The amount must be positive.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le montant total du chèque %1 est de %2. Le montant doit être positif."}]}';
        VOIDVOIDVOID_Txt: Label 'VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID VOID', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"NUL NUL NUL NUL NUL NUL NUL NUL NUL NUL NUL NUL NUL NUL NUL NUL NUL NUL NUL NUL"}]}';
        NONNEGOTIABLE_Txt: Label 'NON-NEGOTIABLE', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"NON NEGOCIABLE"}]}';
        TestPrint_Txt: Label 'Test print', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Impression test"}]}';
        XXXX_XX_Txt: Label 'XXXX.XX', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"XXXX.XX"}]}';
        XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX_Txt: Label 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"}]}';
        Zero_Txt: Label 'ZERO', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"ZERO"}]}';
        Hundred_Txt: Label 'HUNDRED', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"CENT"}]}';
        And_Txt: Label 'AND', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"ET"}]}';
        P1ResultsInAWrittenNumberThatIsTooLong_Txt: Label '%1 results in a written number that is too long.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"%1 résultat(s) en toutes lettres trop long(s)."}]}';
        IsAlreadyAppliedToP1P2ForCustomerP3_Txt: Label ' is already applied to %1 %2 for customer %3.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":" est déjà lettré(e) avec %1 %2 pour le client %3."}]}';
        IsAlreadyAppliedToP1P2ForVendorP3_Txt: Label ' is already applied to %1 %2 for vendor %3.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":" est déjà lettré(e) avec %1 %2 pour le fournisseur %3."}]}';
        One_Txt: Label 'ONE', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"UN"}]}';
        Two_Txt: Label 'TWO', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"DEUX"}]}';
        Three_Txt: Label 'THREE', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"TROIS"}]}';
        Four_Txt: Label 'FOUR', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"QUATRE"}]}';
        Five_Txt: Label 'FIVE', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"CINQ"}]}';
        Six_Txt: Label 'SIX', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"SIX"}]}';
        Seven_Txt: Label 'SEVEN', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"SEPT"}]}';
        Eight_Txt: Label 'EIGHT', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"HUIT"}]}';
        Nine_Txt: Label 'NINE', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"NEUF"}]}';
        Ten_Txt: Label 'TEN', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"DIX"}]}';
        Eleven_Txt: Label 'ELEVEN', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"ONZE"}]}';
        Twelve_Txt: Label 'TWELVE', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"DOUZE"}]}';
        Thirteen_Txt: Label 'THIRTEEN', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"TREIZE"}]}';
        Fourteen_Txt: Label 'FOURTEEN', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"QUATORZE"}]}';
        Fifteen_Txt: Label 'FIFTEEN', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"QUINZE"}]}';
        Sixteen_Txt: Label 'SIXTEEN', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"SEIZE"}]}';
        Seventeen_Txt: Label 'SEVENTEEN', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"DIX-SEPT"}]}';
        Eighteen_Txt: Label 'EIGHTEEN', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"DIX-HUIT"}]}';
        Nineteen_Txt: Label 'NINETEEN', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"DIX-NEUF"}]}';
        Twenty_Txt: Label 'TWENTY', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"VINGT"}]}';
        Thirty_Txt: Label 'THIRTY', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"TRENTE"}]}';
        Forty_Txt: Label 'FORTY', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"QUARANTE"}]}';
        Fifty_Txt: Label 'FIFTY', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"CINQUANTE"}]}';
        Sixty_Txt: Label 'SIXTY', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"SOIXANTE"}]}';
        Seventy_Txt: Label 'SEVENTY', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"SOIXANTE-DIX"}]}';
        Eighty_Txt: Label 'EIGHTY', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"QUATRE-VINGT"}]}';
        Ninety_Txt: Label 'NINETY', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"QUATRE-DIX"}]}';
        Thousand_Txt: Label 'THOUSAND', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"MILLE"}]}';
        Million_Txt: Label 'MILLION', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"MILLION"}]}';
        Billion_Txt: Label 'BILLION', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"MILLIARD"}]}';
        CompanyAddr: array[8] of Text[50];
        CheckToAddr: array[8] of Text[50];
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        ExponentText: array[5] of Text[30];
        BalancingType: Enum "Gen. Journal Account Type";
        BalancingNo: Code[20];
        CheckNoText: Text[30];
        CheckDateText: Text[30];
        CheckAmountText: Text[30];
        DescriptionLine: array[2] of Text[80];
        DocNo: Text[30];
        ExtDocNo: Text[35];
        VoidText: Text[30];
        LineAmount: Decimal;
        LineDiscount: Decimal;
        TotalLineAmount: Decimal;
        TotalLineDiscount: Decimal;
        RemainingAmount: Decimal;
        CurrentLineAmount: Decimal;
        UseCheckNo: Code[20];
        FoundLast: Boolean;
#pragma warning disable AA0204
        ReprintChecks: Boolean;
        PreprintedStub: Boolean;
#pragma warning restore AA0204
        TestPrint: Boolean;
        FirstPage: Boolean;
        OneCheckPrVendor: Boolean;
        FoundNegative: Boolean;
        ApplyMethod: Option Payment,OneLineOneEntry,OneLineID,MoreLinesOneEntry;
        ChecksPrinted: Integer;
        HighestLineNo: Integer;
        TotalText: Text[10];
        DocDate: Date;
        i: Integer;
        CurrencyCode2: Code[10];
        NetAmount: Text[30];
        LineAmount2: Decimal;
        NetAmountP1_Txt: Label 'Net Amount %1', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montant net %1"}]}';
        P1MustNotBeP2ForP3P4_Txt: Label '%1 must not be %2 for %3 %4.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"%1 ne doit pas être %2 pour %3 %4."}]}';
        Subtotal_Txt: Label 'Subtotal', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Sous-total"}]}';
        Euros_Txt: Label 'EUROS', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"EUROS"}]}';
        Cent_Txt: Label 'CENT', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"CENT"}]}';
        CheckNoTextCaption_Lbl: Label 'Check No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° chèque"}]}';
        LineAmountCaption_Lbl: Label 'Amount', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montant"}]}';
        LineDiscountCaption_Lbl: Label 'Discount', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Remise"}]}';
        AmountCaption_Lbl: Label 'Amount', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montant"}]}';
        DocNoCaption_Lbl: Label 'Document No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° document"}]}';
        DocDateCaption_Lbl: Label 'Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date"}]}';
        CurrencyCodeCaption_Lbl: Label 'Currency Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code devise"}]}';
        YourDocNoCaption_Lbl: Label 'External Document No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° doc. externe"}]}';
        TransportCaption_Lbl: Label 'Transport', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Transport"}]}';
        ReferenceCaption_Lbl: Label 'Reference', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Référence"}]}';
        HeaderText2_Lbl: Label 'This transfert is relied to these invoices :', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ce chèque est lié aux factures suivantes :"}]}';
        TxtGLine1_Txt: Text;
        TxtGLine1_Lbl: Label 'Please find under this envelope, a check for %1 € drawn on the bank %2 ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Veuillez trouver sous ce pli, un chèque de %1 € tiré sur la banque %2"}]}';
        Greeting_Lbl: label 'Regards', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Recevez, Messieurs, l''expression de nos salutations distinguées."}]}';
        On_Lbl: label '  on ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"  le "}]}';



    procedure FormatNoText(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    begin
        IF (CurrencyCode = '') OR (CurrencyCode = 'FRF') THEN
            FormatNoTextFR(NoText, No, CurrencyCode)
        ELSE
            FormatNoTextINTL(NoText, No, CurrencyCode);
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30])
    begin
        PrintExponent := TRUE;

        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(P1ResultsInAWrittenNumberThatIsTooLong_Txt, AddText);
        END;

        NoText[NoTextIndex] := CopyStr(DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<'), 1, MaxStrLen(NoText[NoTextIndex]));
    end;

    local procedure CustUpdateAmounts(var CustLedgEntry2: record "Cust. Ledger Entry"; RemainingAmount2: Decimal)
    begin
        IF (ApplyMethod = ApplyMethod::OneLineOneEntry) OR
           (ApplyMethod = ApplyMethod::MoreLinesOneEntry)
        THEN BEGIN
            GenJnlLine3.RESET();
            GenJnlLine3.SETCURRENTKEY(
              "Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
            GenJnlLine3.SETRANGE("Account Type", GenJnlLine3."Account Type"::Customer);
            GenJnlLine3.SETRANGE("Account No.", CustLedgEntry2."Customer No.");
            GenJnlLine3.SETRANGE("Applies-to Doc. Type", CustLedgEntry2."Document Type");
            GenJnlLine3.SETRANGE("Applies-to Doc. No.", CustLedgEntry2."Document No.");
            IF ApplyMethod = ApplyMethod::OneLineOneEntry THEN
                GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine."Line No.")
            ELSE
                GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine2."Line No.");
            IF CustLedgEntry2."Document Type" <> CustLedgEntry2."Document Type"::" " THEN
                IF GenJnlLine3.FindFirst() THEN
                    GenJnlLine3.FIELDERROR(
                      "Applies-to Doc. No.",
                      STRSUBSTNO(
                        IsAlreadyAppliedToP1P2ForCustomerP3_Txt,
                        CustLedgEntry2."Document Type", CustLedgEntry2."Document No.",
                        CustLedgEntry2."Customer No."));
        END;

        DocNo := CustLedgEntry2."Document No.";
        ExtDocNo := CustLedgEntry2."External Document No.";
        DocDate := CustLedgEntry2."Posting Date";
        CurrencyCode2 := CustLedgEntry2."Currency Code";

        CustLedgEntry2.CALCFIELDS("Remaining Amount");

        LineAmount :=
          -ABSMin(
            CustLedgEntry2."Remaining Amount" -
            CustLedgEntry2."Remaining Pmt. Disc. Possible" -
            CustLedgEntry2."Accepted Payment Tolerance",
            CustLedgEntry2."Amount to Apply");
        LineAmount2 :=
          ROUND(
            ExchangeAmt(CustLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2, LineAmount),
            Currency."Amount Rounding Precision");

        IF ((CustLedgEntry2."Document Type" IN [CustLedgEntry2."Document Type"::Invoice,
                                                CustLedgEntry2."Document Type"::"Credit Memo"]) AND
            (CustLedgEntry2."Remaining Pmt. Disc. Possible" <> 0) AND
            (CustLedgEntry2."Posting Date" <= CustLedgEntry2."Pmt. Discount Date")) OR
           CustLedgEntry2."Accepted Pmt. Disc. Tolerance"
        THEN BEGIN
            LineDiscount := -CustLedgEntry2."Remaining Pmt. Disc. Possible";
            IF CustLedgEntry2."Accepted Payment Tolerance" <> 0 THEN
                LineDiscount := LineDiscount - CustLedgEntry2."Accepted Payment Tolerance";
        END ELSE BEGIN
            IF RemainingAmount2 >=
               ROUND(
                 -ExchangeAmt(CustLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2,
                   CustLedgEntry2."Amount to Apply"), Currency."Amount Rounding Precision")
            THEN
                LineAmount2 :=
                  ROUND(
                    -ExchangeAmt(CustLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2,
                      CustLedgEntry2."Amount to Apply"), Currency."Amount Rounding Precision")
            ELSE BEGIN
                LineAmount2 := RemainingAmount2;
                LineAmount :=
                  ROUND(
                    ExchangeAmt(CustLedgEntry2."Posting Date", CurrencyCode2, GenJnlLine."Currency Code",
                      LineAmount2), Currency."Amount Rounding Precision");
            END;
            LineDiscount := 0;
        END;
    end;

    local procedure VendUpdateAmounts(var VendLedgEntry2: Record "Vendor Ledger Entry"; RemainingAmount2: Decimal)
    begin
        IF (ApplyMethod = ApplyMethod::OneLineOneEntry) OR
           (ApplyMethod = ApplyMethod::MoreLinesOneEntry)
        THEN BEGIN
            GenJnlLine3.RESET();
            GenJnlLine3.SETCURRENTKEY(
              "Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
            GenJnlLine3.SETRANGE("Account Type", GenJnlLine3."Account Type"::Vendor);
            GenJnlLine3.SETRANGE("Account No.", VendLedgEntry2."Vendor No.");
            GenJnlLine3.SETRANGE("Applies-to Doc. Type", VendLedgEntry2."Document Type");
            GenJnlLine3.SETRANGE("Applies-to Doc. No.", VendLedgEntry2."Document No.");
            IF ApplyMethod = ApplyMethod::OneLineOneEntry THEN
                GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine."Line No.")
            ELSE
                GenJnlLine3.SETFILTER("Line No.", '<>%1', GenJnlLine2."Line No.");
            IF VendLedgEntry2."Document Type" <> VendLedgEntry2."Document Type"::" " THEN
                IF GenJnlLine3.FindFirst() THEN
                    GenJnlLine3.FIELDERROR(
                      "Applies-to Doc. No.",
                      STRSUBSTNO(
                        IsAlreadyAppliedToP1P2ForVendorP3_Txt,
                        VendLedgEntry2."Document Type", VendLedgEntry2."Document No.",
                        VendLedgEntry2."Vendor No."));
        END;

        DocNo := VendLedgEntry2."Document No.";
        ExtDocNo := VendLedgEntry2."External Document No.";
        DocDate := VendLedgEntry2."Posting Date";
        CurrencyCode2 := VendLedgEntry2."Currency Code";
        VendLedgEntry2.CALCFIELDS("Remaining Amount");

        LineAmount :=
          -ABSMin(
            VendLedgEntry2."Remaining Amount" -
            VendLedgEntry2."Remaining Pmt. Disc. Possible" -
            VendLedgEntry2."Accepted Payment Tolerance",
            VendLedgEntry2."Amount to Apply");

        LineAmount2 :=
          ROUND(
            ExchangeAmt(VendLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2, LineAmount),
            Currency."Amount Rounding Precision");

        IF ((VendLedgEntry2."Document Type" IN [VendLedgEntry2."Document Type"::Invoice,
                                                VendLedgEntry2."Document Type"::"Credit Memo"]) AND
            (VendLedgEntry2."Remaining Pmt. Disc. Possible" <> 0) AND
            (GenJnlLine."Posting Date" <= VendLedgEntry2."Pmt. Discount Date")) OR
           VendLedgEntry2."Accepted Pmt. Disc. Tolerance"
        THEN BEGIN
            LineDiscount := -VendLedgEntry2."Remaining Pmt. Disc. Possible";
            IF VendLedgEntry2."Accepted Payment Tolerance" <> 0 THEN
                LineDiscount := LineDiscount - VendLedgEntry2."Accepted Payment Tolerance";
        END ELSE BEGIN
            IF ABS(RemainingAmount2) >=
               ABS(ROUND(
                   ExchangeAmt(VendLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2,
                     VendLedgEntry2."Amount to Apply"), Currency."Amount Rounding Precision"))
            THEN BEGIN
                LineAmount2 :=
                  ROUND(
                    -ExchangeAmt(VendLedgEntry2."Posting Date", GenJnlLine."Currency Code", CurrencyCode2,
                      VendLedgEntry2."Amount to Apply"), Currency."Amount Rounding Precision");
                LineAmount :=
                  ROUND(
                    ExchangeAmt(VendLedgEntry2."Posting Date", CurrencyCode2, GenJnlLine."Currency Code",
                    LineAmount2), Currency."Amount Rounding Precision");
            END ELSE BEGIN
                LineAmount2 := RemainingAmount2;
                LineAmount :=
                  ROUND(
                    ExchangeAmt(VendLedgEntry2."Posting Date", CurrencyCode2, GenJnlLine."Currency Code",
                    LineAmount2), Currency."Amount Rounding Precision");
            END;
            LineDiscount := 0;
        END;
    end;


    procedure InitTextVariable()
    begin
        OnesText[1] := One_Txt;
        OnesText[2] := Two_Txt;
        OnesText[3] := Three_Txt;
        OnesText[4] := Four_Txt;
        OnesText[5] := Five_Txt;
        OnesText[6] := Six_Txt;
        OnesText[7] := Seven_Txt;
        OnesText[8] := Eight_Txt;
        OnesText[9] := Nine_Txt;
        OnesText[10] := Ten_Txt;
        OnesText[11] := Eleven_Txt;
        OnesText[12] := Twelve_Txt;
        OnesText[13] := Thirteen_Txt;
        OnesText[14] := Fourteen_Txt;
        OnesText[15] := Fifteen_Txt;
        OnesText[16] := Sixteen_Txt;
        OnesText[17] := Seventeen_Txt;
        OnesText[18] := Eighteen_Txt;
        OnesText[19] := Nineteen_Txt;

        TensText[1] := '';
        TensText[2] := Twenty_Txt;
        TensText[3] := Thirty_Txt;
        TensText[4] := Forty_Txt;
        TensText[5] := Fifty_Txt;
        TensText[6] := Sixty_Txt;
        TensText[7] := Seventy_Txt;
        TensText[8] := Eighty_Txt;
        TensText[9] := Ninety_Txt;

        ExponentText[1] := '';
        ExponentText[2] := Thousand_Txt;
        ExponentText[3] := Million_Txt;
        ExponentText[4] := Billion_Txt;
    end;


    procedure InitializeRequest(pBankAcc: Code[20]; pLastCheckNo: Code[20]; NewOneCheckPrVend: Boolean; NewReprintChecks: Boolean; NewTestPrint: Boolean; NewPreprintedStub: Boolean)
    begin
        IF pBankAcc <> '' THEN
            IF BankAcc2.GET(pBankAcc) THEN BEGIN
                UseCheckNo := pLastCheckNo;
                OneCheckPrVendor := NewOneCheckPrVend;
                ReprintChecks := NewReprintChecks;
                TestPrint := NewTestPrint;
                PreprintedStub := NewPreprintedStub;
            END;
    end;

    local procedure ExchangeAmt(PostingDate: Date; CurrencyCode: Code[10]; pCurrencyCode2: Code[10]; Amount: Decimal) Amount2: Decimal
    begin
        IF (CurrencyCode <> '') AND (pCurrencyCode2 = '') THEN
            Amount2 :=
              CurrencyExchangeRate.ExchangeAmtLCYToFCY(
                PostingDate, CurrencyCode, Amount, CurrencyExchangeRate.ExchangeRate(PostingDate, CurrencyCode))
        ELSE
            IF (CurrencyCode = '') AND (pCurrencyCode2 <> '') THEN
                Amount2 :=
                  CurrencyExchangeRate.ExchangeAmtFCYToLCY(
                    PostingDate, pCurrencyCode2, Amount, CurrencyExchangeRate.ExchangeRate(PostingDate, pCurrencyCode2))
            ELSE
                IF (CurrencyCode <> '') AND (pCurrencyCode2 <> '') AND (CurrencyCode <> pCurrencyCode2) THEN
                    Amount2 := CurrencyExchangeRate.ExchangeAmtFCYToFCY(PostingDate, pCurrencyCode2, CurrencyCode, Amount)
                ELSE
                    Amount2 := Amount;
    end;

    local procedure ABSMin(Decimal1: Decimal; Decimal2: Decimal): Decimal
    begin
        IF ABS(Decimal1) < ABS(Decimal2) THEN
            EXIT(Decimal1);
        EXIT(Decimal2);
    end;


    procedure InputBankAccount()
    begin
        IF BankAcc2."No." <> '' THEN BEGIN
            BankAcc2.GET(BankAcc2."No.");
            BankAcc2.TESTFIELD("Last Check No.");
            UseCheckNo := BankAcc2."Last Check No.";
        END;
    end;


    procedure FormatNoTextFR(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '****';

        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Zero_Txt)
        ELSE
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;

                IF Hundreds = 1 THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Hundred_Txt)
                ELSE
                    IF Hundreds > 1 THEN BEGIN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                        IF (Tens * 10 + Ones) = 0 THEN
                            AddToNoText(NoText, NoTextIndex, PrintExponent, Hundred_Txt + 'S')
                        ELSE
                            AddToNoText(NoText, NoTextIndex, PrintExponent, Hundred_Txt);
                    END;

                FormatTens(NoText, NoTextIndex, PrintExponent, Exponent, Hundreds, Tens, Ones);

                IF PrintExponent AND (Exponent > 1) THEN
                    IF ((Hundreds * 100 + Tens * 10 + Ones) > 1) AND (Exponent <> 2) THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent] + 'S')
                    ELSE
                        AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);

                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;

        IF CurrencyCode = '' THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Euros_Txt)
        ELSE BEGIN
            Currency.GET(CurrencyCode);
            AddToNoText(NoText, NoTextIndex, PrintExponent, UPPERCASE(Currency.Description));
        END;

        No := No * 100;
        Ones := No MOD 10;
        Tens := No DIV 10;
        FormatTens(NoText, NoTextIndex, PrintExponent, Exponent, Hundreds, Tens, Ones);

        IF (CurrencyCode = '') OR (CurrencyCode = 'FRF') THEN
            CASE TRUE OF
                No = 1:
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Cent_Txt);
                No > 1:
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Cent_Txt + 'S');
            END;
    end;


    procedure FormatTens(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; Exponent: Integer; Hundreds: Integer; Tens: Integer; Ones: Integer)
    begin
        CASE Tens OF
            9:
                BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Eighty_Txt);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones + 10]);
                END;

            8:
                IF Ones = 0 THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Eighty_Txt + 'S')
                ELSE BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Eighty_Txt);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END;
            7:
                BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Sixty_Txt);
                    IF Ones = 1 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, And_Txt);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones + 10]);
                END;
            2:
                BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Twenty_Txt);
                    IF Ones > 0 THEN BEGIN
                        IF Ones = 1 THEN
                            AddToNoText(NoText, NoTextIndex, PrintExponent, And_Txt);
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                    END;
                END;
            1:
                AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
            0:
                IF Ones > 0 THEN
                    IF (Ones = 1) AND (Hundreds < 1) AND (Exponent = 2) THEN
                        PrintExponent := TRUE
                    ELSE
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
            ELSE BEGIN
                AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                IF Ones > 0 THEN BEGIN
                    IF Ones = 1 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, 'ET');
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END;
            END;
        END;
    end;


    procedure FormatNoTextINTL(var NoText: array[2] of Text[80]; No: Decimal; CurrencyCode: Code[10])
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '****';

        IF No < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Zero_Txt)
        ELSE
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := No DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Hundred_Txt);
                END;
                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                No := No - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;
        AddToNoText(NoText, NoTextIndex, PrintExponent, And_Txt);
        AddToNoText(NoText, NoTextIndex, PrintExponent, FORMAT(No * 100) + '/100');

        IF CurrencyCode <> '' THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, CurrencyCode);
    end;
}