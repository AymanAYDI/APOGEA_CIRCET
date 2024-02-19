report 50011 "CIR Draft Notice"
{
    Caption = 'Draft notice', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Avis de virement"}]}';
    DefaultLayout = RDLC;
    RDLCLayout = './RDL/CIRDraftNotice.rdl';

    dataset
    {
        dataitem("Payment Lines1"; "Payment Line")
        {
            DataItemTableView = SORTING("No.", "Line No.");
            column(Payment_Lines1_Line_No_; "Line No.")
            {
            }
            column(Payment_Lines1_No_; "No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                PaymtHeader.GET("No.");
                PaymtHeader.CALCFIELDS("Payment Class Name");
                PostingDate := PaymtHeader."Posting Date";

                BankAccountBuffer.INIT();
                BankAccountBuffer."Customer No." := "Account No.";
                BankAccountBuffer."Bank Branch No." := "Bank Branch No.";
                BankAccountBuffer."Agency Code" := "Agency Code";
                BankAccountBuffer."Bank Account No." := "Bank Account No.";
                IF NOT PaymtHeader.Print then
                    BankAccountBuffer."Line No." := "Line No.";
                IF NOT BankAccountBuffer.INSERT() THEN;
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("No.", TransfertNo);
            end;
        }
        dataitem(CopyLoop; Integer)
        {
            DataItemTableView = SORTING(Number);
            dataitem(BankAccntBuffer; "Bank Account Buffer")
            {
                DataItemTableView = SORTING("Customer No.", "Bank Branch No.", "Agency Code", "Bank Account No.");
                column(Bank_Account_Buffer_Agency_Code; "Agency Code")
                {
                }
                column(Bank_Account_Buffer_Bank_Account_No_; "Bank Account No.")
                {
                }
                column(Bank_Account_Buffer_Bank_Branch_No_; "Bank Branch No.")
                {
                }
                column(Bank_Account_Buffer_Customer_No_; "Customer No.")
                {
                }
                dataitem(PaymentLine; "Payment Line")
                {
                    DataItemLink = "Account No." = FIELD("Customer No."),
                                    "Bank Branch No." = FIELD("Bank Branch No."),
                                    "Agency Code" = FIELD("Agency Code"),
                                    "Bank Account No." = FIELD("Bank Account No.");
                    DataItemLinkReference = BankAccntBuffer;
                    DataItemTableView = SORTING("No.", "Account No.", "Bank Branch No.", "Agency Code", "Bank Account No.", "Payment Address Code");
                    column(ABS_Amount_; ABS(Amount))
                    {
                        AutoFormatExpression = "Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Bank_Account_Buffer___Agency_Code_; BankAccntBuffer."Agency Code")
                    {
                    }
                    column(Bank_Account_Buffer___Bank_Account_No__; BankAccntBuffer."Bank Account No.")
                    {
                    }
                    column(Bank_Account_Buffer___Bank_Branch_No__; BankAccntBuffer."Bank Branch No.")
                    {
                    }
                    column(Bank_Account_Buffer___Customer_No__; BankAccntBuffer."Customer No.")
                    {
                    }
                    column(CompanyAddr_1_; CompanyAddr[1])
                    {
                    }
                    column(CompanyAddr_2_; CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr_3_; CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr_4_; CompanyAddr[4])
                    {
                    }
                    column(CompanyAddr_5_; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr_6_; CompanyAddr[6])
                    {
                    }
                    column(CompanyInformation__Fax_No__; CompanyInformation."Fax No.")
                    {
                    }
                    column(CompanyInformation__Fax_No__Caption; CompanyInformation__Fax_No__CaptionLbl)
                    {
                    }
                    column(CompanyInformation__Phone_No__; CompanyInformation."Phone No.")
                    {
                    }
                    column(CompanyInformation__Phone_No__Caption; CompanyInformation__Phone_No__CaptionLbl)
                    {
                    }
                    column(CompanyInformation__VAT_Registration_No__; CompanyInformation."VAT Registration No.")
                    {
                    }
                    column(CompanyInformation__VAT_Registration_No__Caption; CompanyInformation__VAT_Registration_No__CaptionLbl)
                    {
                    }
                    column(CopyLoop_Number; CopyLoop.Number)
                    {
                    }
                    column(Draft_Notice_AmountCaption; Draft_Notice_AmountCaptionLbl)
                    {
                    }
                    column(DraftAmount; DraftAmount)
                    {
                        AutoFormatExpression = "Currency Code";
                        AutoFormatType = 1;
                    }
                    column(FORMAT_PostingDate_0_4_; FORMAT(PostingDate, 0, 4))
                    {
                    }
                    column(HeaderText1; HeaderText1)
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(Payment_Line__Document_No__; "Document No.")
                    {
                    }
                    column(Payment_Line__Due_Date_; FORMAT("Due Date"))
                    {
                    }
                    column(Payment_Line__External_Document_No__; "External Document No.")
                    {
                    }
                    column(Payment_Line_Account_No_; "Account No.")
                    {
                    }
                    column(Payment_Line_Agency_Code; "Agency Code")
                    {
                    }
                    column(Payment_Line_Applies_to_ID; "Applies-to ID")
                    {
                    }
                    column(Payment_Line_Bank_Account_No_; "Bank Account No.")
                    {
                    }
                    column(Payment_Line_Bank_Branch_No_; "Bank Branch No.")
                    {
                    }
                    column(Payment_Line_Line_No_; "Line No.")
                    {
                    }
                    column(Payment_Line_No_; "No.")
                    {
                    }
                    column(Payment_Line_Payment_Address_Code; "Payment Address Code")
                    {
                    }
                    column(Payment_Line_Reference; Reference)
                    {
                    }
                    column(Payment_Lines1___No__; "Payment Lines1"."No.")
                    {
                    }
                    column(Payment_Lines1___No__Caption; Payment_Lines1___No__CaptionLbl)
                    {
                    }
                    column(PaymtHeader__IBAN__Caption; PaymtHeader__IBAN__CaptionLbl)
                    {
                    }
                    column(PaymtHeader__Payment_Class_Name_; PaymtHeader."Payment Class Name")
                    {
                    }
                    column(PaymtHeader__SWIFT_Code__Caption; PaymtHeader__SWIFT_Code__CaptionLbl)
                    {
                    }
                    column(PaymtHeader_IBAN; PaymtHeader.IBAN)
                    {
                    }
                    column(PaymtHeader_SWIFT_Code; PaymtHeader."SWIFT Code")
                    {
                    }
                    column(PaymtLine_Amount__CaptionLbl; PaymtLine_Amount__CaptionLbl)
                    {
                    }
                    column(PaymtLine_DocNo__CaptionLbl; PaymtLine_DocNo__CaptionLbl)
                    {
                    }
                    column(PaymtLine_Reference__CaptionLbl; PaymtLine_Reference__CaptionLbl)
                    {
                    }
                    column(PostingDate; FORMAT(PostingDate))
                    {
                    }
                    column(PrintCurrencyCode; PrintCurrencyCode())
                    {
                    }
                    column(PrintCurrencyCode_Control1120064; PrintCurrencyCode())
                    {
                    }
                    column(PrintCurrencyCode_Control1120069; PrintCurrencyCode())
                    {
                    }
                    column(PrintCurrencyCodeCaption; PrintCurrencyCodeCaptionLbl)
                    {
                    }
                    column(STRSUBSTNO__Page__1__FORMAT_CurrReport_PAGENO__; PageLbl)
                    {
                    }
                    column(STRSUBSTNO_Text002_CopyText_; STRSUBSTNO(DraftNoticeLbl, CopyText))
                    {
                    }
                    column(TotalDraftAmount; TotalDraftAmount)
                    {
                    }
                    column(VendAddr_1_; VendAddr[1])
                    {
                    }
                    column(VendAddr_2_; VendAddr[2])
                    {
                    }
                    column(VendAddr_3_; VendAddr[3])
                    {
                    }
                    column(VendAddr_4_; VendAddr[4])
                    {
                    }
                    column(VendAddr_5_; VendAddr[5])
                    {
                    }
                    column(VendAddr_6_; VendAddr[6])
                    {
                    }
                    column(VendAddr_7_; VendAddr[7])
                    {
                    }
                    column(Vendor__No__; Vendor."No.")
                    {
                    }
                    dataitem(DataItem4114; "Vendor Ledger Entry")
                    {
                        CalcFields = "Remaining Amount";
                        DataItemLink = "Vendor No." = FIELD("Account No."), "Applies-to ID" = FIELD("Applies-to ID");
                        DataItemLinkReference = PaymentLine;
                        DataItemTableView = SORTING("Document No.");
                        column(ABS__Remaining_Amount__; ABS("Remaining Amount"))
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(ABS__Remaining_Amount___Control1120036; AmountRemaining)
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(ABS__Remaining_Amount___Control1120059; ABS("Remaining Amount"))
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(ABS__Remaining_Amount___Control1120059Caption; ABS__Remaining_Amount___Control1120059CaptionLbl)
                        {
                        }
                        column(HeaderText2; HeaderText2Lbl)
                        {
                        }
                        column(PrintCurrencyCode_Control1120060; PrintCurrencyCode())
                        {
                        }
                        column(PrintCurrencyCode_Control1120063; PrintCurrencyCode())
                        {
                        }
                        column(ReportCaption; ReportCaptionLbl)
                        {
                        }
                        column(ReportCaption_Control1120015; ReportCaptionLbl)
                        {
                        }
                        column(Vendor_Ledger_Entry__Currency_Code_; "Currency Code")
                        {
                        }
                        column(Vendor_Ledger_Entry__Document_Date_; "Document Date")
                        {
                        }
                        column(Vendor_Ledger_Entry__Document_Date__Caption; FIELDCAPTION("Document Date"))
                        {
                        }
                        column(Vendor_Ledger_Entry__Document_No__; "Document No.")
                        {
                        }
                        column(Vendor_Ledger_Entry__Document_No__Caption; FIELDCAPTION("Document No."))
                        {
                        }
                        column(Vendor_Ledger_Entry__Due_Date_; FORMAT("Due Date"))
                        {
                        }
                        column(Vendor_Ledger_Entry__Due_Date_Caption; Vendor_Ledger_Entry__Due_Date_CaptionLbl)
                        {
                        }
                        column(Vendor_Ledger_Entry__External_Document_No__; "External Document No.")
                        {
                        }
                        column(Vendor_Ledger_Entry__External_Document_No__Caption; FIELDCAPTION("External Document No."))
                        {
                        }
                        column(Vendor_Ledger_Entry__Posting_Date_; FORMAT("Posting Date"))
                        {
                        }
                        column(Vendor_Ledger_Entry__Posting_Date_Caption; Vendor_Ledger_Entry__Posting_Date_CaptionLbl)
                        {
                        }
                        column(Vendor_Ledger_Entry_Applies_to_ID; "Applies-to ID")
                        {
                        }
                        column(Vendor_Ledger_Entry_Description; Description)
                        {
                        }
                        column(Vendor_Ledger_Entry_DescriptionCaption; FIELDCAPTION(Description))
                        {
                        }
                        column(Vendor_Ledger_Entry_Entry_No_; "Entry No.")
                        {
                        }
                        column(Vendor_Ledger_Entry_Vendor_No_; "Vendor No.")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            AmountRemaining := 0;
                            IF PaymentLine."Applies-to ID" = '' THEN
                                CurrReport.Skip();
                            IF "Currency Code" = '' THEN
                                "Currency Code" := GLSetup."LCY Code";

                            DraftCounting := DraftCounting + 1;

                            if DataItem4114."Document Type" = DataItem4114."Document Type"::"Credit Memo" then
                                AmountRemaining := -"Remaining Amount"
                            else
                                AmountRemaining := Abs("Remaining Amount");
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var
                        PaymtAddr: Record "Payment Address";
                        PaymtManagt: Codeunit "Payment Management";
                    begin
                        HeaderText1 := STRSUBSTNO(TransferDoneLbl, "Bank Account Name", "SWIFT Code", "Agency Code", IBAN, PostingDate);
                        DraftCounting := 0;

                        TotalDraftAmount := TotalDraftAmount + ABS(Amount);

                        Vendor.GET("Account No.");
                        IF "Payment Address Code" = '' THEN
                            FormatAddress.Vendor(VendAddr, Vendor)
                        ELSE
                            IF PaymtAddr.GET("Account Type"::Vendor, "Account No.", "Payment Address Code") THEN
                                PaymtManagt.PaymentAddr(VendAddr, PaymtAddr);

                        DraftAmount := ABS(Amount);
                    end;

                    trigger OnPreDataItem()
                    begin
                        SETRANGE("No.", TransfertNo);
                        SETRANGE("Selected", true);

                        TotalDraftAmount := 0;

                        IF NOT PaymtHeader.Print then
                            SETRANGE("Line No.", BankAccntBuffer."Line No.");
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                IF Number > 1 THEN BEGIN
                    CopyText := CopyLbl;
                    OutputNo := OutputNo + 1;
                END;
            end;

            trigger OnPreDataItem()
            begin
                OutputNo := 1;
                LoopsNumber := ABS(CopiesNumber) + 1;
                CopyText := '';
                SETRANGE(Number, 1, LoopsNumber);
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
                    field(NumberOfCopies; CopiesNumber)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Number of copies', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nombre de copies"}]}';
                        ToolTip = 'Number of copies', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nombre de copies"}]}';
                    }
                }
            }
        }
    }

    trigger OnPostReport()
    begin
        BankAccountBuffer.DELETEALL();
    end;

    trigger OnPreReport()
    begin
        TransfertNo := COPYSTR("Payment Lines1".GETFILTER("No."), 1, MAXSTRLEN(TransfertNo));

        IF TransfertNo = '' THEN
            ERROR(TransfertNoErr);

        CompanyInformation.GET();
        FormatAddress.Company(CompanyAddr, CompanyInformation);
        GLSetup.GET();
    end;

    var
        BankAccountBuffer: Record "Bank Account Buffer";
        CompanyInformation: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        PaymtHeader: Record "Payment Header";
        Vendor: Record Vendor;
        FormatAddress: Codeunit "Format Address";
        TransfertNo: Code[20];
        PostingDate: Date;
        AmountRemaining: Decimal;
        DraftAmount: Decimal;
        DraftCounting: Decimal;
        TotalDraftAmount: Decimal;
        CopiesNumber: Integer;
        LoopsNumber: Integer;
        OutputNo: Integer;
        ABS__Remaining_Amount___Control1120059CaptionLbl: Label 'Amount', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montant"}]}';
        CompanyInformation__Fax_No__CaptionLbl: Label 'FAX No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Numéro de fax."}]}';
        CompanyInformation__Phone_No__CaptionLbl: Label 'Phone No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° de téléphone"}]}';
        CompanyInformation__VAT_Registration_No__CaptionLbl: Label 'VAT Registration No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° d''enregistrement TVA"}]}';
        CopyLbl: Label 'COPY', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"COPIE"}]}';
        Draft_Notice_AmountCaptionLbl: Label 'Draft Notice Amount', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montant du virement"}]}';
        DraftNoticeLbl: Label 'Draft notice %1', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Avis de virement %1"}]}';
        HeaderText2Lbl: Label 'This transfer is related to these invoices :', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ce virement est lié aux factures suivantes:"}]}';
        PageLbl: Label 'Page', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Page "}]}';
        Payment_Lines1___No__CaptionLbl: Label 'Draft No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° virement"}]}';
        PaymtHeader__IBAN__CaptionLbl: Label 'IBAN', Locked = true, Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"IBAN"}]}';
        PaymtHeader__SWIFT_Code__CaptionLbl: Label 'SWIFT Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code SWIFT"}]}';
        PaymtLine_Amount__CaptionLbl: Label 'Amount', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montant"}]}';
        PaymtLine_DocNo__CaptionLbl: Label 'N° document', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Document N°"}]}';
        PaymtLine_Reference__CaptionLbl: Label 'Your reference', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Votre référence"}]}';
        PrintCurrencyCodeCaptionLbl: Label 'Currency Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code devise"}]}';
        ReportCaptionLbl: Label 'Report', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Edition"}]}';
        TransferDoneLbl: Label 'A transfer to your bank account %1 (RIB : %2 %3 %4) has been done on %5.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Un virement sur votre compte bancaire %1 (RIB : %2 %3 %4) a été effectué le %5."}]}';
        TransfertNoErr: Label 'You must specify a transfer number.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous devez spécifier un numéro de transfert."}]}';
        Vendor_Ledger_Entry__Due_Date_CaptionLbl: Label 'Due Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date d''échéance"}]}';
        Vendor_Ledger_Entry__Posting_Date_CaptionLbl: Label 'Posting Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date de publication"}]}';
        CopyText: Text;
        HeaderText1: Text;
        CompanyAddr: array[8] of Text[50];
        VendAddr: array[8] of Text[50];


    procedure PrintCurrencyCode(): Code[10]
    begin
        IF "Payment Lines1"."Currency Code" = '' THEN
            EXIT(GLSetup."LCY Code");

        EXIT("Payment Lines1"."Currency Code");
    end;
}