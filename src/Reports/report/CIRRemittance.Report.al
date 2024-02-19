report 50022 "CIR Remittance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RDL/CIRRemittance.rdl';
    Caption = 'Remittance', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Remise"}]}';

    dataset
    {
        dataitem("Payment Lines1"; "Payment Line")
        {
            DataItemTableView = SORTING("No.", "Line No.") WHERE("Account Type" = CONST(Customer));
            MaxIteration = 1;
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Payment lines', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Lignes paiement"}]}';
            column(Payment_Lines1_No_; "No.")
            {
            }
            column(Payment_Lines1_Line_No_; "Line No.")
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
                    column(Operation; Operation)
                    {
                    }
                    column(PaymtHeader__No__; PaymtHeader."No.")
                    {
                    }
                    column(STRSUBSTNO_Text003____1__CopyText_; StrSubstNo(Text003Lbl + Arg1Lbl, CopyText))
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
                    column(CompanyInfo__Phone_No__; CompanyInfo."Phone No.")
                    {
                    }
                    column(CompanyInfo__Fax_No__; CompanyInfo."Fax No.")
                    {
                    }
                    column(CompanyInfo__VAT_Registration_No__; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(FORMAT_PostingDate_0_4_; Format(PostingDate, 0, 4))
                    {
                    }
                    column(BankAccAddr_4_; BankAccAddr[4])
                    {
                    }
                    column(BankAccAddr_5_; BankAccAddr[5])
                    {
                    }
                    column(BankAccAddr_6_; BankAccAddr[6])
                    {
                    }
                    column(BankAccAddr_7_; BankAccAddr[7])
                    {
                    }
                    column(BankAccAddr_3_; BankAccAddr[3])
                    {
                    }
                    column(BankAccAddr_2_; BankAccAddr[2])
                    {
                    }
                    column(BankAccAddr_1_; BankAccAddr[1])
                    {
                    }
                    column(PrintCurrencyCode; PrintCurrencyCode())
                    {
                    }
                    column(PaymtHeader__Bank_Branch_No__; PaymtHeader."Bank Branch No.")
                    {
                    }
                    column(PaymtHeader__Agency_Code_; PaymtHeader."Agency Code")
                    {
                    }
                    column(PaymtHeader__Bank_Account_No__; PaymtHeader."Bank Account No.")
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(Text003; Text003Lbl)
                    {
                    }
                    column(Text000; Text000Lbl)
                    {
                    }
                    column(PaymtHeader_IBAN; PaymtHeader.IBAN)
                    {
                    }
                    column(PaymtHeader__SWIFT_Code_; PaymtHeader."SWIFT Code")
                    {
                    }
                    column(PageLoop_Number; Number)
                    {
                    }
                    column(PaymtHeader__No__Caption; PaymtHeader__No__CaptionLbl)
                    {
                    }
                    column(CompanyInfo__Phone_No__Caption; CompanyInfo__Phone_No__CaptionLbl)
                    {
                    }
                    column(CompanyInfo__Fax_No__Caption; CompanyInfo__Fax_No__CaptionLbl)
                    {
                    }
                    column(CompanyInfo__VAT_Registration_No__Caption; CompanyInfo__VAT_Registration_No__CaptionLbl)
                    {
                    }
                    column(PrintCurrencyCodeCaption; PrintCurrencyCodeCaptionLbl)
                    {
                    }
                    column(PaymtHeader__Bank_Branch_No__Caption; PaymtHeader__Bank_Branch_No__CaptionLbl)
                    {
                    }
                    column(PaymtHeader__Agency_Code_Caption; PaymtHeader__Agency_Code_CaptionLbl)
                    {
                    }
                    column(PaymtHeader__Bank_Account_No__Caption; PaymtHeader__Bank_Account_No__CaptionLbl)
                    {
                    }
                    column(PaymtHeader_IBANCaption; PaymtHeader_IBANCaptionLbl)
                    {
                    }
                    column(PaymtHeader__SWIFT_Code_Caption; PaymtHeader__SWIFT_Code_CaptionLbl)
                    {
                    }
                    dataitem("Payment Line"; "Payment Line")
                    {
                        DataItemLink = "No." = FIELD("No.");
                        DataItemLinkReference = "Payment Lines1";
                        DataItemTableView = SORTING("No.", "Line No.");
                        column(PrintAmountInLCYCode; vPrintAmountInLCYCode)
                        {
                        }
                        column(StatementAmount; StatementAmount)
                        {
                            AutoFormatExpression = ExtrCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(PrintCurrencyCode_Control1120060; PrintCurrencyCode())
                        {
                        }
                        column(Cust_Name; Cust.Name)
                        {
                        }
                        column(StatementAmount_Control1120031; StatementAmount)
                        {
                            AutoFormatExpression = ExtrCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(PrintCurrencyCode_Control1120061; PrintCurrencyCode())
                        {
                        }
                        column(Payment_Line__Due_Date_; Format("Due Date"))
                        {
                        }
                        column(Payment_Line__No__; "No.")
                        {
                        }
                        column(Payment_Line__Account_No__; "Account No.")
                        {
                        }
                        column(Payment_Line__Drawee_Reference_; "Drawee Reference")
                        {
                        }
                        column(Reference_PaymentLine; Reference)
                        {
                        }
                        column(Payment_Line__Bank_Branch_No__; "Bank Branch No.")
                        {
                        }
                        column(Payment_Line__Agency_Code_; "Agency Code")
                        {
                        }
                        column(Payment_Line__Bank_Account_No__; "Bank Account No.")
                        {
                        }
                        column(Payment_Line__SWIFT_Code_; "SWIFT Code")
                        {
                        }
                        column(Payment_Line_IBAN; IBAN)
                        {
                        }
                        column(StatementAmount_Control1120036; StatementAmount)
                        {
                            AutoFormatExpression = ExtrCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(PrintCurrencyCode_Control1120063; PrintCurrencyCode())
                        {
                        }
                        column(StatementAmount_Control1120039; StatementAmount)
                        {
                            AutoFormatExpression = ExtrCurrencyCode();
                            AutoFormatType = 1;
                        }
                        column(PrintCountingDelivery; PrintCountingDelivery())
                        {
                        }
                        column(PrintCurrencyCode_Control1120064; PrintCurrencyCode())
                        {
                        }
                        column(Payment_Line_Line_No_; "Line No.")
                        {
                        }
                        column(All_amounts_are_in_company_currencyCaption; All_amounts_are_in_company_currencyCaptionLbl)
                        {
                        }
                        column(Cust_NameCaption; Cust_NameCaptionLbl)
                        {
                        }
                        column(StatementAmount_Control1120031Caption; StatementAmount_Control1120031CaptionLbl)
                        {
                        }
                        column(Payment_Line__Drawee_Reference_Caption; FieldCaption("Drawee Reference"))
                        {
                        }
                        column(Reference_PaymentLine_Caption; FieldCaption(Reference))
                        {
                        }
                        column(Payment_Line__No__Caption; Payment_Line__No__CaptionLbl)
                        {
                        }
                        column(Payment_Line__Due_Date_Caption; Payment_Line__Due_Date_CaptionLbl)
                        {
                        }
                        column(Payment_Line__Account_No__Caption; FieldCaption("Account No."))
                        {
                        }
                        column(Payment_Line__Bank_Branch_No__Caption; FieldCaption("Bank Branch No."))
                        {
                        }
                        column(Payment_Line__Agency_Code_Caption; FieldCaption("Agency Code"))
                        {
                        }
                        column(Payment_Line__Bank_Account_No__Caption; FieldCaption("Bank Account No."))
                        {
                        }
                        column(Payment_Line__SWIFT_Code_Caption; FieldCaption("SWIFT Code"))
                        {
                        }
                        column(Payment_Line_IBANCaption; Payment_Line_IBANCaptionLbl)
                        {
                        }
                        column(ReportCaption; ReportCaptionLbl)
                        {
                        }
                        column(EmptyStringCaption; EmptyStringCaptionLbl)
                        {
                        }
                        column(ReportCaption_Control1120015; ReportCaption_Control1120015Lbl)
                        {
                        }
                        column(TotalCaption; TotalCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            Cust.Get("Account No.");

                            if vPrintAmountInLCYCode then
                                StatementAmount := Amount
                            else
                                StatementAmount := Amount;
                            StatementAmount := Abs(Amount);
                        end;

                        trigger OnPreDataItem()
                        begin
                            Clear(StatementAmount);
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                        OutputNo := OutputNo + 1;
                        CopyText := Text000Lbl;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    LoopsNumber := Abs(vCopiesNumber) + 1;
                    CopyText := '';
                    SetRange(Number, 1, LoopsNumber);

                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                PaymtHeader.Get("No.");
                PostingDate := PaymtHeader."Posting Date";

                PaymtHeader.CalcFields("No. of Lines");
                CountStatement := PaymtHeader."No. of Lines";

                PaymtHeader.TestField("Account Type", PaymtHeader."Account Type"::"Bank Account");

                FormatAddress.FormatAddr(
                  BankAccAddr, PaymtHeader."Bank Name", PaymtHeader."Bank Name 2", '', PaymtHeader."Bank Address", PaymtHeader."Bank Address 2",
                  PaymtHeader."Bank City", PaymtHeader."Bank Post Code", '', '');
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get();
                FormatAddress.Company(CompanyAddr, CompanyInfo);
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
                    field(CopiesNumber; vCopiesNumber)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Number of Copies', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nombre de copies"}]}';
                        ToolTip = 'Specifies the number of copies to print.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie le nombre de copies à imprimer."}]}';
                    }
                    field(PrintAmountInLCYCode; vPrintAmountInLCYCode)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Print Amounts in LCY', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Imprimer montants DS"}]}';
                        ToolTip = 'Specifies whether to print amounts in the local currency.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie s''il faut imprimer les montants dans la devise locale."}]}';
                    }
                }
            }
        }
    }

    var
        CompanyInfo: Record "Company Information";
        Cust: Record Customer;
        GLSetup: Record "General Ledger Setup";
        PaymtHeader: Record "Payment Header";
        FormatAddress: Codeunit "Format Address";
        BankAccAddr: array[8] of Text[100];
        CompanyAddr: array[8] of Text[100];
        Operation: Text[80];
        LoopsNumber: Integer;
        vCopiesNumber: Integer;
        CopyText: Text[30];
        vPrintAmountInLCYCode: Boolean;
        StatementAmount: Decimal;
        CountStatement: Integer;
        PostingDate: Date;
        OutputNo: Integer;
        Arg1Lbl: label ' %1', locked = true;
        Text001Msg: Label ' BILL', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"EFFET"}]}';
        Text002Msg: Label ' BILLS', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"EFFETS"}]}';
        Text003Lbl: Label 'Remittance', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Remise"}]}';
        Text000Lbl: Label 'COPY', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"COPIE"}]}';
        PaymtHeader__No__CaptionLbl: Label 'Remittance No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° remise"}]}';
        CompanyInfo__Phone_No__CaptionLbl: Label 'Phone No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° téléphone"}]}';
        CompanyInfo__Fax_No__CaptionLbl: Label 'FAX No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° TÉLÉCOPIE"}]}';
        CompanyInfo__VAT_Registration_No__CaptionLbl: Label 'VAT Registration No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° identif. intracomm."}]}';
        PrintCurrencyCodeCaptionLbl: Label 'Currency Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code devise"}]}';
        PaymtHeader__Bank_Branch_No__CaptionLbl: Label 'Bank Branch No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code établissement"}]}';
        PaymtHeader__Agency_Code_CaptionLbl: Label 'Agency Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code agence"}]}';
        PaymtHeader__Bank_Account_No__CaptionLbl: Label 'Bank Account No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° compte bancaire"}]}';
        PaymtHeader_IBANCaptionLbl: Label 'IBAN', Locked = true;
        PaymtHeader__SWIFT_Code_CaptionLbl: Label 'SWIFT Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code SWIFT"}]}';
        All_amounts_are_in_company_currencyCaptionLbl: Label 'All amounts are in company currency', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Tous les montants sont en devise société"}]}';
        Cust_NameCaptionLbl: Label 'Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom"}]}';
        StatementAmount_Control1120031CaptionLbl: Label 'Remaining Amount', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montant ouvert"}]}';
        Payment_Line__No__CaptionLbl: Label 'Document No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° document"}]}';
        Payment_Line__Due_Date_CaptionLbl: Label 'Due Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date d''échéance"}]}';
        Payment_Line_IBANCaptionLbl: Label 'IBAN', Locked = true;
        ReportCaptionLbl: Label 'Report', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"État"}]}';
        EmptyStringCaptionLbl: Label '/', Locked = true;
        ReportCaption_Control1120015Lbl: Label 'Report', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"État"}]}';
        TotalCaptionLbl: Label 'Total', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Total"}]}';


    procedure ExtrCurrencyCode(): Code[10]
    begin
        if vPrintAmountInLCYCode then
            exit('');

        exit("Payment Lines1"."Currency Code");
    end;


    procedure PrintCurrencyCode(): Code[10]
    begin
        if ("Payment Lines1"."Currency Code" = '') or vPrintAmountInLCYCode then begin
            GLSetup.Get();
            exit(GLSetup."LCY Code");
        end;
        exit("Payment Lines1"."Currency Code");
    end;


    procedure PrintCountingDelivery(): Text[30]
    begin
        if CountStatement > 1 then
            exit(Format(CountStatement) + Text002Msg);

        exit(Format(CountStatement) + Text001Msg);
    end;


    procedure InitRequest(InitCopies: Integer; InitAmountInLCYCode: Boolean)
    begin
        vCopiesNumber := InitCopies;
        vPrintAmountInLCYCode := InitAmountInLCYCode;
    end;
}

