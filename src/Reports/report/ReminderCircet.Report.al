report 50013 "Reminder Circet"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RDL/ReminderCircet.rdl';
    Caption = 'Reminder ACC', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Courrier relance"}]}';

    dataset
    {
        dataitem("Issued Reminder Header"; "Issued Reminder Header")
        {
            DataItemTableView = SORTING("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Reminder', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Relance"}]}';
            column(Issued_Reminder_Header__No__of_Reminders_Caption; CstGIssued_Reminder_Header__No__of_Reminders_Caption_Lbl)
            {
            }
            column(Issued_Reminder_Header__Remaining_Amount__Control40Caption; CstGIssued_Reminder_Header__Remaining_Amount__Control40Caption_Lbl)
            {
            }
            column(Issued_Reminder_Header__Original_Amount_Caption; CstGIssued_Reminder_Header__Original_Amount_Caption_Lbl)
            {
            }
            column(Issued_Reminder_Header__Document_No__Caption; CstGIssued_Reminder_Header__Document_No__Caption_Lbl)
            {
            }
            column(Issued_Reminder_Header__Due_Date_Caption; CstGIssued_Reminder_Header__Due_Date_Caption_Lbl)
            {
            }
            column(Issued_Reminder_Header__Document_Type_Caption; CstGIssued_Reminder_Header__Document_Type_Caption_Lbl)
            {
            }
            column(Issued_Reminder_Header__Document_Date_Caption; CstGIssued_Reminder_Header__Document_Date_Caption_Lbl)
            {
            }
            column(Issued_Reminder_Header_No_; "No.")
            {
            }
            dataitem(Integer; Integer)
            {
                DataItemTableView = SORTING(Number)
                                    WHERE(Number = CONST(1));
                column(CustAddr_7_; TxtGCustAddr[7])
                {
                }
                column(CustAddr_5_; TxtGCustAddr[5])
                {
                }
                column(CustAddr_6_; TxtGCustAddr[6])
                {
                }
                column(CustAddr_4_; TxtGCustAddr[4])
                {
                }
                column(TxtFax; TxtFax)
                {
                }
                column(CustAddr_3_; TxtGCustAddr[3])
                {
                }
                column(TxtGPhone; TxtGPhone)
                {
                }
                column(CustAddr_2_; TxtGCustAddr[2])
                {
                }
                column(TxtGSalesperson; TxtGSalesperson)
                {
                }
                column(CustAddr_1_; TxtGCustAddr[1])
                {
                }
                column(Customer_VAT_Registration_No; GRecCustomer."VAT Registration No.")
                {
                }
                column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
                {
                }
                column(CompanyInfo_Picture; RecGCompanyInfo.Picture)
                {
                }
                column(Issued_Reminder_Header___Customer_No__; "Issued Reminder Header"."Customer No.")
                {
                }
                column(FORMAT__Issued_Reminder_Header___Document_Date__0_4_; FORMAT("Issued Reminder Header"."Document Date", 0, 4))
                {
                }
                column(Issued_Reminder_Header___No__; "Issued Reminder Header"."No.")
                {
                }
                column(STRSUBSTNO_TextEASY008_CompanyInfo_Name_; STRSUBSTNO(NewManager_Lbl, RecGCompanyInfo.Name))
                {
                }
                column(STRSUBSTNO_TextEASY009_CompanyInfo_Name_; STRSUBSTNO(PaymentThx_Lbl, RecGCompanyInfo.Name))
                {
                }
                column(TextEASY010; BankingDetails_Lbl)
                {
                }
                column(RIB_____FORMAT_GRecBankAccount__Bank_Branch_No___________FORMAT_GRecBankAccount__Bank_Account_No____; 'RIB :' + FORMAT(RecGCompanyInfo."Bank Branch No.") + ' ' + FORMAT(RecGCompanyInfo."Bank Account No."))
                {
                }
                column(GRecBankAccount_Name; RecGCompanyInfo."Bank Name")
                {
                }
                column(TextEASY011______FORMAT__Issued_Reminder_Header___Posting_Date__; Revival_Lbl + ' ' + FORMAT("Issued Reminder Header"."Posting Date"))
                {
                }
                column(SIRET____CompanyInfo__Registration_No__; 'SIRET  ' + RecGCompanyInfo."Registration No.")
                {
                }
                column(CompanyInfo__VAT_Registration_No__; RecGCompanyInfo."VAT Registration No.")
                {
                }
                column(CompanyInfo__Post_Code________CompanyInfo_City_______RecGCountryRegion_Name; RecGCompanyInfo."Post Code" + ' - ' + RecGCompanyInfo.City + ' - ' + RecGCountryRegion.Name)
                {
                }
                column(CompanyInfo_Address_______CompanyInfo__Address_2_; RecGCompanyInfo.Address + ' - ' + RecGCompanyInfo."Address 2")
                {
                }
                column(CompanyInfo__Fax_No__; RecGCompanyInfo."Fax No.")
                {
                }
                column(CompanyInfo__Phone_No__; RecGCompanyInfo."Phone No.")
                {
                }
                column(TxtGHeader; TxtGHeader)
                {
                }
                column(Your_contactCaption; CstGYour_contactCaption_Lbl)
                {
                }
                column(Delivery_AddressCaption; CstGDelivery_AddressCaption_Lbl)
                {
                }
                column(Phone_NoCaption; CstGPhone_NoCaption_Lbl)
                {
                }
                column(FaxCaption; CstGFaxCaption_Lbl)
                {
                }
                column(Date__Caption; CstGDate__Caption_Lbl)
                {
                }
                column(Customer_CodeCaption; CstGCustomer_CodeCaption_Lbl)
                {
                }
                column(DateCaption; CstGDateCaption_Lbl)
                {
                }
                column(REMIND_N__Caption; CstGREMIND_N__Caption_Lbl)
                {
                }
                column(REMINDCaption; CstGREMINDCaption_Lbl)
                {
                }
                column(VAT_Intracom__Number__Caption; CstGVAT_Intracom__Number__Caption_Lbl)
                {
                }
                column(Fax__Caption; CstGFax__Caption_Lbl)
                {
                }
                column(Phone__Caption; CstGPhone__Caption_Lbl)
                {
                }
                column(CompinfoAdress; RecGCompanyInfo.Address)
                {
                }
                column(CompinfoAdress2; RecGCompanyInfo."Address 2")
                {
                }
                column(CompanyInfo__Email; RecGCompanyInfo."E-Mail")
                {
                }
                column(CompanyInfo__EmailCaption; RecGCompanyInfo.FIELDCAPTION("E-Mail"))
                {
                }
                column(CompanyInfo__HomePage; RecGCompanyInfo."Home Page")
                {
                }
                column(CompanyInfo__HomePageCaption; RecGCompanyInfo.FIELDCAPTION("Home Page"))
                {
                }
                column(CompanyInfo__CompanyInfo__Csttxt0001; CstGStockCapital_Lbl)
                {
                }
                column(Csttxt0002LB; CstGTradeRegister_Lbl)
                {
                }
                column(Integer_Number; Number)
                {
                }
                column(CompanyInfo_Footer; RecGCompanyInfo.FooterInformationCompany())
                {
                }
                column(TotalText2; TxtGTotalText)
                {
                }
                dataitem("Text Header"; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = FILTER(1 ..));
                    column(TxtGHeader2; TxtGHeader2)
                    {
                    }
                    column(Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        TxtGHeader2 := RecGIssuedReminderLine.Description;

                        RecGIssuedReminderLine.NEXT();
                        TxtGHeader := CopyStr(TxtGHeader + ' ' + TxtGHeader2, 1, MaxStrLen(TxtGHeader));
                    end;

                    trigger OnPreDataItem()
                    begin
                        TxtGHeader2 := '';
                        RecGIssuedReminderLine.SETFILTER(RecGIssuedReminderLine."Reminder No.", "Issued Reminder Header"."No.");

                        RecGIssuedReminderLine.SETFILTER(RecGIssuedReminderLine."Line No.", '<%1', 10000);
                        IF NOT RecGIssuedReminderLine.ISEMPTY() THEN;
                        "Text Header".SETRANGE("Text Header".Number, 1, RecGIssuedReminderLine.COUNT());

                        TxtGHeader := '';
                    end;
                }
                dataitem(DimensionLoop; Integer)
                {
                    DataItemLinkReference = "Issued Reminder Header";
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = FILTER(1 ..));
                    column(DimText; TxtGDimText)
                    {
                    }
                    column(DimText_Control93; TxtGDimText)
                    {
                    }
                    column(Header_DimensionsCaption; CstGHeader_DimensionsCaption_Lbl)
                    {
                    }
                    column(DimensionLoop_Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    var
                        "%1%2_Lbl": Label '%1 %2', Locked = true;
                        "%1%2%3_Lbl": Label '%1, %2 %3', Locked = true;
                    begin
                        IF Number = 1 THEN BEGIN
                            IF NOT RecGDimSetEntry1.FINDSET() THEN
                                CurrReport.BREAK();
                        END
                        ELSE
                            IF NOT BooGContinue THEN
                                CurrReport.BREAK();

                        CLEAR(TxtGDimText);
                        BooGContinue := FALSE;
                        REPEAT
                            TxtGOldDimText := TxtGDimText;
                            IF TxtGDimText = '' THEN
                                TxtGDimText := STRSUBSTNO("%1%2_Lbl", RecGDimSetEntry1."Dimension Code", RecGDimSetEntry1."Dimension Value Code")
                            ELSE
                                TxtGDimText := STRSUBSTNO("%1%2%3_Lbl", TxtGDimText, RecGDimSetEntry1."Dimension Code", RecGDimSetEntry1."Dimension Value Code");
                            IF STRLEN(TxtGDimText) > MAXSTRLEN(TxtGOldDimText) THEN BEGIN
                                TxtGDimText := TxtGOldDimText;
                                BooGContinue := TRUE;
                                EXIT;
                            END;
                        UNTIL RecGDimSetEntry1.NEXT() = 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF NOT BooGShowInternalInfo THEN
                            CurrReport.BREAK();
                    end;
                }
                dataitem("Issued Reminder Line"; "Issued Reminder Line")
                {
                    DataItemLink = "Reminder No." = FIELD("No.");
                    DataItemLinkReference = "Issued Reminder Header";
                    DataItemTableView = SORTING("Reminder No.", "Line No.");
                    column(Issued_Reminder_Line__Remaining_Amount_; "Remaining Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader();
                        AutoFormatType = 1;
                    }
                    column(Issued_Reminder_Line__Document_Date_; "Document Date")
                    {
                    }
                    column(Issued_Reminder_Line__Document_No__; "Document No.")
                    {
                    }
                    column(Issued_Reminder_Line__Due_Date_; "Due Date")
                    {
                    }
                    column(Issued_Reminder_Line__Remaining_Amount__Control40; "Remaining Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader();
                        AutoFormatType = 1;
                    }
                    column(Issued_Reminder_Line__Original_Amount_; "Original Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader();
                        AutoFormatType = 1;
                    }
                    column(Issued_Reminder_Line__Document_Type_; "Document Type")
                    {
                    }
                    column(Issued_Reminder_Line__No__of_Reminders_; "No. of Reminders")
                    {
                    }
                    column(Issued_Reminder_Line_Type; Type)
                    {
                    }
                    column(IntGOptionType; IntGOptionType)
                    {
                    }
                    column(BooGCustLedgEntry; BooGCustLedgEntry)
                    {
                    }
                    column(BooGGlAccount; BooGGlAccount)
                    {
                    }
                    column(Issued_Reminder_Line_Description; Description)
                    {
                    }
                    column(Issued_Reminder_Line__Remaining_Amount__Control38; "Remaining Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader();
                        AutoFormatType = 1;
                    }
                    column(Issued_Reminder_Line__No__; "No.")
                    {
                    }
                    column(ShowInternalInfo; BooGShowInternalInfo)
                    {
                    }
                    column(Issued_Reminder_Line__Remaining_Amount__Control95; "Remaining Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader();
                        AutoFormatType = 1;
                    }
                    column(Issued_Reminder_Line_Description_Control96; Description)
                    {
                    }
                    column(IssuedReminderLine_Description; Description)
                    {
                    }
                    column(BooGShowDescription; BooGShowDescription)
                    {
                    }
                    column(BooGShowAmount; BooGShowAmount)
                    {
                    }
                    column(Issued_Reminder_Line__Remaining_Amount__Control42; "Remaining Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader();
                        AutoFormatType = 1;
                    }
                    column(ReminderInterestAmount; DecGReminderInterestAmount)
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader();
                        AutoFormatType = 1;
                    }
                    column(Remaining_Amount____ReminderInterestAmount; "Remaining Amount" + DecGReminderInterestAmount)
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader();
                        AutoFormatType = 1;
                    }
                    column(TotalText; TxtGTotalText)
                    {
                    }
                    column(Remaining_Amount____ReminderInterestAmount____VAT_Amount_; "Remaining Amount" + DecGReminderInterestAmount + "VAT Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader();
                        AutoFormatType = 1;
                    }
                    column(TotalInclVATText; TxtGTotalInclVATText)
                    {
                    }
                    column(Issued_Reminder_Line__VAT_Amount_; "VAT Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader();
                        AutoFormatType = 1;
                    }
                    column(Issued_Reminder_Line__Document_Date_Caption; FIELDCAPTION("Document Date"))
                    {
                    }
                    column(Issued_Reminder_Line__Document_No__Caption; FIELDCAPTION("Document No."))
                    {
                    }
                    column(Issued_Reminder_Line__Due_Date_Caption; CstGIssued_Reminder_Line__Due_Date_Caption_Lbl)
                    {
                    }
                    column(Issued_Reminder_Line__Remaining_Amount__Control40Caption; FIELDCAPTION("Remaining Amount"))
                    {
                    }
                    column(Issued_Reminder_Line__Original_Amount_Caption; FIELDCAPTION("Original Amount"))
                    {
                    }
                    column(Issued_Reminder_Line__Document_Type_Caption; FIELDCAPTION("Document Type"))
                    {
                    }
                    column(Issued_Reminder_Line__No__of_Reminders_Caption; FIELDCAPTION("No. of Reminders"))
                    {
                    }
                    column(Issued_Reminder_Line__Remaining_Amount_Caption; CstGIssued_Reminder_Line__Remaining_Amount_Caption_Lbl)
                    {
                    }
                    column(Issued_Reminder_Line__Remaining_Amount__Control42Caption; CstGIssued_Reminder_Line__Remaining_Amount__Control42Caption_Lbl)
                    {
                    }
                    column(ReminderInterestAmountCaption; CstGReminderInterestAmountCaption_Lbl)
                    {
                    }
                    column(Issued_Reminder_Line__VAT_Amount_Caption; FIELDCAPTION("VAT Amount"))
                    {
                    }
                    column(Issued_Reminder_Line_Reminder_No_; "Reminder No.")
                    {
                    }
                    column(Issued_Reminder_Line_Line_No_; "Line No.")
                    {
                    }
                    column(TxtGExternalDocNo; TxtGExternalDocNo)
                    {
                    }
                    dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
                    {
                        DataItemLink = "Document No." = FIELD("Document No."),
                                       "Document Type" = FIELD("Document Type"),
                                       "Customer No." = FIELD("No.");
                        PrintOnlyIfDetail = true;
                        column(Cust__Ledger_Entry_Entry_No_; "Entry No.")
                        {
                        }
                        column(Cust__Ledger_Entry_Document_Type; "Document Type")
                        {
                        }
                        column(Cust__Ledger_Entry_Document_No_; "Document No.")
                        {
                        }
                        column(External_Doc_No; "External Document No.")
                        {
                        }
                        dataitem("Cust. Ledger Entry2"; "Cust. Ledger Entry")
                        {
                            DataItemLink = "Closed by Entry No." = FIELD("Entry No.");
                            DataItemTableView = SORTING("Entry No.");
                            column(TextEASY012; AppliedBy_Lbl)
                            {
                            }
                            column(Cust__Ledger_Entry2__Document_Type_; "Document Type")
                            {
                            }
                            column(Cust__Ledger_Entry2__Document_No__; "Document No.")
                            {
                            }
                            column(Cust__Ledger_Entry2__Closed_by_Amount_; "Closed by Amount")
                            {
                            }
                            column(IntGCountCustLedger2; IntGCountCustLedger2)
                            {
                            }
                            column(Cust__Ledger_Entry2_Entry_No_; "Entry No.")
                            {
                            }
                            column(Cust__Ledger_Entry2_Closed_by_Entry_No_; "Closed by Entry No.")
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                IntGCountCustLedger2 += 1;
                            end;

                            trigger OnPreDataItem()
                            begin
                                IntGCountCustLedger2 := 0;
                            end;
                        }
                    }

                    trigger OnAfterGetRecord()
                    var
                        RecLCustLegerEntry: Record "Cust. Ledger Entry";
                    begin
                        TempVATAmountLine.INIT();
                        TempVATAmountLine."VAT Identifier" := "VAT Identifier";
                        TempVATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                        TempVATAmountLine."Tax Group Code" := "Tax Group Code";
                        TempVATAmountLine."VAT %" := "VAT %";
                        TempVATAmountLine."VAT Base" := Amount;
                        TempVATAmountLine."VAT Amount" := "VAT Amount";
                        TempVATAmountLine."Amount Including VAT" := Amount + "VAT Amount";
                        TempVATAmountLine.InsertLine();

                        CASE Type OF
                            Type::"G/L Account":
                                "Remaining Amount" := Amount;
                            Type::"Customer Ledger Entry":
                                DecGReminderInterestAmount := Amount;
                        END;

                        IntGOptionType := Type.AsInteger();

                        IF (Type = Type::"Customer Ledger Entry") THEN
                            BooGCustLedgEntry := TRUE
                        ELSE
                            BooGCustLedgEntry := FALSE;

                        IF (Type = Type::"G/L Account") THEN
                            BooGGlAccount := TRUE
                        ELSE
                            BooGGlAccount := FALSE;

                        IF ((Type = Type::" ") AND ("Line Type" <> "Line Type"::"Ending Text") AND ("Line No." >= 10000)) THEN
                            BooGShowDescription := TRUE
                        ELSE
                            BooGShowDescription := FALSE;

                        IF "Original Amount" <> "Remaining Amount" THEN
                            BooGShowAmount := TRUE
                        ELSE
                            BooGShowAmount := FALSE;
                        DecGRemAmount += "Remaining Amount";
                        DecGRemAmount += DecGReminderInterestAmount;

                        TxtGExternalDocNo := '';
                        RecLCustLegerEntry.SETCURRENTKEY("Document No.");
                        RecLCustLegerEntry.SETRANGE("Document Type", "Document Type");
                        RecLCustLegerEntry.SETRANGE("Document No.", "Document No.");
                        IF RecLCustLegerEntry.FindFirst() THEN
                            TxtGExternalDocNo := RecLCustLegerEntry."External Document No.";
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF FINDLAST() THEN BEGIN
                            IntGEndLineNo := "Line No." + 1;
                            REPEAT
                                BooGContinue := Type = Type::" ";
                                IF BooGContinue AND (Description = '') THEN
                                    IntGEndLineNo := "Line No.";
                            UNTIL (NEXT(-1) = 0) OR NOT BooGContinue;
                        END;

                        TempVATAmountLine.DELETEALL();
                        SETFILTER("Line No.", '<%1', IntGEndLineNo);
                        DecGRemAmount := 0;
                    end;
                }
                dataitem(total; Integer)
                {
                    DataItemLinkReference = "Issued Reminder Header";
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = FILTER(1));
                    column(DecGRemAmount; DecGRemAmount)
                    {
                    }
                    column(total_Number; Number)
                    {
                    }
                }
                dataitem(IssuedReminderLine2; "Issued Reminder Line")
                {
                    DataItemLink = "Reminder No." = FIELD("No.");
                    DataItemLinkReference = "Issued Reminder Header";
                    DataItemTableView = SORTING("Reminder No.", "Line No.");
                    column(IssuedReminderLine2_Description; Description)
                    {
                    }
                    column(BooGEndingText2; BooGEndingText2)
                    {
                    }
                    column(IssuedReminderLine2_Reminder_No_; "Reminder No.")
                    {
                    }
                    column(IssuedReminderLine2_Line_No_; "Line No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        BooGEndingText2 := FALSE;
                        IF ("Line Type" <> "Line Type"::"Ending Text") THEN
                            BooGEndingText2 := TRUE;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SETFILTER("Line No.", '>=%1', IntGEndLineNo);
                    end;
                }
                dataitem(IssuedReminderLine3; "Issued Reminder Line")
                {
                    DataItemLink = "Reminder No." = FIELD("No.");
                    DataItemLinkReference = "Issued Reminder Header";
                    DataItemTableView = SORTING("Reminder No.", "Line No.")
                                        WHERE("Line Type" = FILTER("Ending Text"));
                    column(IssuedReminderLine3_Description; Description)
                    {
                    }
                    column(BooGEndingText; BooGEndingText)
                    {
                    }
                    column(IssuedReminderLine3_Reminder_No_; "Reminder No.")
                    {
                    }
                    column(IssuedReminderLine3_Line_No_; "Line No.")
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        BooGEndingText := FALSE;
                        IF ("Line Type" = "Line Type"::"Ending Text") THEN
                            BooGEndingText := TRUE;
                    end;
                }
            }

            trigger OnAfterGetRecord()
            var
                lCustomer: Record Customer;
            begin
                if "Language Code" <> '' then
                    CurrReport.LANGUAGE := gLanguage.GetLanguageID("Language Code")
                else
                    if lCustomer.get("Customer No.") then
                        if lCustomer."Language Code" <> '' then
                            CurrReport.LANGUAGE := gLanguage.GetLanguageID(lCustomer."Language Code");


                RecGDimSetEntry1.SETRANGE("Dimension Set ID", "Issued Reminder Header"."Dimension Set ID");

                CduGFormatAddrCodeunit.IssuedReminder(TxtGCustAddr, "Issued Reminder Header");
                IF "Your Reference" = '' THEN
                    TxtGReferenceText := ''
                ELSE
                    TxtGReferenceText := CopyStr(FIELDCAPTION("Your Reference"), 1, MaxStrLen(TxtGReferenceText));
                IF "VAT Registration No." = '' THEN
                    TxtGVATNoText := ''
                ELSE
                    TxtGVATNoText := CopyStr(FIELDCAPTION("VAT Registration No."), 1, MaxStrLen(TxtGVATNoText));
                IF "Currency Code" = '' THEN BEGIN
                    RecGGLSetup.TESTFIELD("LCY Code");
                    TxtGTotalText := STRSUBSTNO(Total_Lbl, RecGGLSetup."LCY Code");
                    TxtGTotalInclVATText := STRSUBSTNO(TotalInclVAT_Lbl, RecGGLSetup."LCY Code");
                END
                ELSE BEGIN
                    TxtGTotalText := STRSUBSTNO(Total_Lbl, "Currency Code");
                    TxtGTotalInclVATText := STRSUBSTNO(TotalInclVAT_Lbl, "Currency Code");
                END;

                IF NOT CurrReport.PREVIEW THEN BEGIN
                    IF BooGLogInteraction THEN
                        CduGSegManagement.LogDocument(8, "No.", 0, 0, DATABASE::Customer, "Customer No.", '', '', "Posting Description", '');
                    IncrNoPrinted();
                END;
                TxtGSalesperson := '';
                TxtGPhone := '';
                TxtFax := '';

                IF GRecCustomer.GET("Issued Reminder Header"."Customer No.") THEN BEGIN
                    TxtFax := GRecCustomer."Fax No.";
                    IF GRecCustomer."Salesperson Code" <> '' THEN BEGIN
                        IF GRecSalesperson.GET(GRecCustomer."Salesperson Code") THEN BEGIN
                            TxtGSalesperson := GRecSalesperson.Name;
                            TxtGPhone := GRecSalesperson."Phone No.";
                        END;
                    END
                    ELSE BEGIN
                        TxtGSalesperson := GRecCustomer.Contact;
                        TxtGPhone := GRecCustomer."Phone No.";
                    END;
                END;
            end;

            trigger OnPreDataItem()
            begin
                RecGCompanyInfo.GET();
                RecGCompanyInfo.CALCFIELDS(Picture);
                IF RecGCompanyInfo."Country/Region Code" <> '' THEN
                    RecGCountryRegion.GET(RecGCompanyInfo."Country/Region Code");
                CduGFormatAddrCodeunit.Company(TxtGCompanyAddr, RecGCompanyInfo);
#pragma warning disable AA0206
                BooGFirstPage := TRUE;
#pragma warning restore AA0206
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Options"}]}';
                    field(BooGShowInternalInfo; BooGShowInternalInfo)
                    {
                        Caption = 'Show Internal Information', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Afficher info. internes"}]}';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Show Internal Information ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie si on doit afficher les informations internes"}]}';
                    }
                    field(BooGLogInteraction; BooGLogInteraction)
                    {
                        Caption = 'Log Interaction', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Journal interaction"}]}';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Log Interaction ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur du journal interaction"}]}';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        RecGGLSetup.GET();
    end;

    var
        RecGGLSetup: Record "General Ledger Setup";
        RecGCompanyInfo: Record "Company Information";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        GRecSalesperson: Record "Salesperson/Purchaser";
        GRecCustomer: Record "Customer";
        RecGIssuedReminderLine: Record "Issued Reminder Line";
        RecGDimSetEntry1: Record "Dimension Set Entry";
        RecGCountryRegion: Record "Country/Region";
        gLanguage: Codeunit Language;
        CduGFormatAddrCodeunit: Codeunit "Format Address";

        CduGSegManagement: Codeunit "SegManagement";
        TxtGCustAddr: array[8] of Text[50];
        TxtGCompanyAddr: array[8] of Text[50];
        TxtGVATNoText: Text[25];
        TxtGReferenceText: Text[35];
        TxtGTotalText: Text[50];
        TxtGTotalInclVATText: Text[50];
        DecGReminderInterestAmount: Decimal;
        IntGEndLineNo: Integer;
        BooGContinue: Boolean;
        TxtGDimText: Text[120];
        TxtGOldDimText: Text[120];
#pragma warning disable AA0204
        BooGShowInternalInfo, BooGLogInteraction : Boolean;
#pragma warning restore AA0204
        TxtGHeader2: Text[100];
        Total_Lbl: Label 'Total %1', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Total %1"}]}';
        TotalInclVAT_Lbl: Label 'Total %1 Incl. VAT', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Total %1 TTC"}]}';
        NewManager_Lbl: Label 'From now on, %1 manages your account.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"A partir de maintenant, %1 gère votre compte"}]}';
        PaymentThx_Lbl: Label 'THANK YOU TO MAKE OUT YOUR PAYMENTS AT THE ORDER OF %1', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"MERCI D''EFFECTUER VOS PAIEMENTS À L''ORDRE DE %1"}]}';
        BankingDetails_Lbl: Label 'Banking Details : ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Coordonnées bancaires :"}]}';
        Revival_Lbl: Label 'This revival takes account of the expiries until', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Cette relance tient compte des échéances jusqu''à"}]}';
        BooGFirstPage: Boolean;
        AppliedBy_Lbl: Label 'Applied by : ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Appliqué par : "}]}';
        TxtGSalesperson: Text[100];
        TxtGPhone: Text[30];
        TxtFax: Text[30];
        IntGOptionType: Integer;
        BooGShowDescription: Boolean;
        BooGCustLedgEntry: Boolean;
        BooGGlAccount: Boolean;
        BooGEndingText: Boolean;
        BooGEndingText2: Boolean;
        BooGShowAmount: Boolean;
        DecGRemAmount: Decimal;
        IntGCountCustLedger2: Integer;
        TxtGHeader: Text[1024];
        CstGIssued_Reminder_Header__No__of_Reminders_Caption_Lbl: Label 'No. of Reminders', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nombre de relances"}]}';
        CstGIssued_Reminder_Header__Remaining_Amount__Control40Caption_Lbl: Label 'Remaining Amount', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montant ouvert"}]}';
        CstGIssued_Reminder_Header__Original_Amount_Caption_Lbl: Label 'Original Amount', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montant initial"}]}';
        CstGIssued_Reminder_Header__Document_No__Caption_Lbl: Label 'Document No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° document"}]}';
        CstGIssued_Reminder_Header__Due_Date_Caption_Lbl: Label 'Due Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date d''échéance"}]}';
        CstGIssued_Reminder_Header__Document_Type_Caption_Lbl: Label 'Document Type', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Type document"}]}';
        CstGIssued_Reminder_Header__Document_Date_Caption_Lbl: Label 'Document Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date document"}]}';
        CstGYour_contactCaption_Lbl: Label 'Your contact', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Votre contact"}]}';
        CstGDelivery_AddressCaption_Lbl: Label 'Billing Address', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Adresse de facturation"}]}';
        CstGPhone_NoCaption_Lbl: Label 'Phone No', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° téléphone"}]}';
        CstGFaxCaption_Lbl: Label 'Fax', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Fax"}]}';
        CstGDate__Caption_Lbl: Label 'Date  ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date  "}]}';
        CstGCustomer_CodeCaption_Lbl: Label 'Customer Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code client"}]}';
        CstGDateCaption_Lbl: Label 'Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date"}]}';
        CstGREMIND_N__Caption_Lbl: Label 'REMIND N° ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"RELANCE N° "}]}';
        CstGREMINDCaption_Lbl: Label 'REMIND', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"RELANCE"}]}';
        CstGVAT_Intracom__Number__Caption_Lbl: Label 'VAT Intracom. Number :', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° identif. intracomm."}]}';
        CstGFax__Caption_Lbl: Label 'Fax :', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Fax :"}]}';
        CstGPhone__Caption_Lbl: Label 'Phone :', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Tél :"}]}';
        CstGHeader_DimensionsCaption_Lbl: Label 'Header Dimensions', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Analytique en-tête"}]}';
        CstGIssued_Reminder_Line__Due_Date_Caption_Lbl: Label 'Due Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date d''échéance"}]}';
        CstGIssued_Reminder_Line__Remaining_Amount_Caption_Lbl: Label 'Continued', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Suite"}]}';
        CstGIssued_Reminder_Line__Remaining_Amount__Control42Caption_Lbl: Label 'Continued', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Suite"}]}';
        CstGReminderInterestAmountCaption_Lbl: Label 'Interest Amount', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montant intérêts"}]}';
        CstGStockCapital_Lbl: Label 'Stock Capital', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Capital social"}]}';
        CstGTradeRegister_Lbl: Label 'Trade Register', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Registre du commerce"}]}';
        TxtGExternalDocNo: Text;
}

