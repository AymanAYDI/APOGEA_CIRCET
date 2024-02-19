report 50010 "CIR Draft Recapitulation"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RDL/CIRDraftreCapitulation.rdl';
    Caption = 'Draft recapitulation', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Récapitulatif de virement"}]}';

    dataset
    {
        dataitem("Payment Lines1"; "Payment Line")
        {
            DataItemTableView = SORTING("No.", "Line No.");
            MaxIteration = 1;
            PrintOnlyIfDetail = true;
            column(Payment_Lines1_No_; "No.")
            {
            }
            column(Payment_Lines1_Line_No_; "Line No.")
            {
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    column(PaymtHeader__No__; PaymtHeader."No.")
                    {
                    }
                    column(STRSUBSTNO_Text001_CopyText_; STRSUBSTNO(DRaftRecapLbl, PaymtHeader."Payment Class", CopyText))
                    {
                    }
                    column(STRSUBSTNO__Page__1__FORMAT_CurrReport_PAGENO__; PageLbl)
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
                    column(CompanyInformation__Phone_No__; CompanyInformation."Phone No.")
                    {
                    }
                    column(CompanyInformation__Fax_No__; CompanyInformation."Fax No.")
                    {
                    }
                    column(CompanyInformation__VAT_Registration_No__; CompanyInformation."VAT Registration No.")
                    {
                    }
                    column(FORMAT_PostingDate_0_4_; FORMAT(PostingDate, 0, 4))
                    {
                    }
                    column(BankAccountAddr_4_; BankAccountAddr[4])
                    {
                    }
                    column(BankAccountAddr_5_; BankAccountAddr[5])
                    {
                    }
                    column(BankAccountAddr_6_; BankAccountAddr[6])
                    {
                    }
                    column(BankAccountAddr_7_; BankAccountAddr[7])
                    {
                    }
                    column(BankAccountAddr_3_; BankAccountAddr[3])
                    {
                    }
                    column(BankAccountAddr_2_; BankAccountAddr[2])
                    {
                    }
                    column(BankAccountAddr_1_; BankAccountAddr[1])
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
                    column(PaymtHeader__RIB_Key_; PaymtHeader."RIB Key")
                    {
                    }
                    column(PaymtHeader__National_Issuer_No__; PaymtHeader."National Issuer No.")
                    {
                    }
                    column(OutputNo; OutputNo)
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
                    column(PaymtHeader__No__Caption; PaymtHeaderNoCaptionLbl)
                    {
                    }
                    column(CompanyInformation__Phone_No__Caption; CompanyInformation__Phone_No__CaptionLbl)
                    {
                    }
                    column(CompanyInformation__Fax_No__Caption; CompanyInformation__Fax_No__CaptionLbl)
                    {
                    }
                    column(CompanyInformation__VAT_Registration_No__Caption; CompanyInformation__VAT_Registration_No__CaptionLbl)
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
                    column(PaymtHeader__RIB_Key_Caption; PaymtHeader__RIB_Key_CaptionLbl)
                    {
                    }
                    column(PaymtHeader__National_Issuer_No__Caption; PaymtHeader__National_Issuer_No__CaptionLbl)
                    {
                    }
                    column(PaymtHeader_IBANCaption; IBANCaptionLbl)
                    {
                    }
                    column(PaymtHeader__SWIFT_Code_Caption; SWIFTCodeCaptionLbl)
                    {
                    }
                    dataitem("Payment Lines"; "Payment Line")
                    {
                        DataItemLink = "No." = FIELD("No.");
                        DataItemLinkReference = "Payment Lines1";
                        DataItemTableView = SORTING("No.", "Line No.");
                        column(ABS_Amount_; ABS(Amount))
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrintCurrencyCode_Control1120060; PrintCurrencyCode())
                        {
                        }
                        column(Vendor_Name; Vendor.Name)
                        {
                        }
                        column(Payment_Lines__Bank_Branch_No__; "Bank Branch No.")
                        {
                        }
                        column(ABS_Amount__Control1120031; ABS(Amount))
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(Payment_Lines__Bank_Account_Name_; "Bank Account Name")
                        {
                        }
                        column(Payment_Lines__Account_No__; "Account No.")
                        {
                        }
                        column(PrintCurrencyCode_Control1120061; PrintCurrencyCode())
                        {
                        }
                        column(Payment_Lines__Agency_Code_; "Agency Code")
                        {
                        }
                        column(Payment_Lines__Bank_Account_No__; "Bank Account No.")
                        {
                        }
                        column(Payment_Lines__SWIFT_Code_; "SWIFT Code")
                        {
                        }
                        column(Payment_Lines_IBAN; IBAN)
                        {
                        }
                        column(ABS_Amount__Control1120036; ABS(Amount))
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrintCurrencyCode_Control1120063; PrintCurrencyCode())
                        {
                        }
                        column(DraftAmount; DraftAmount)
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrintDraftCounting; PrintDraftCounting())
                        {
                        }
                        column(PrintCurrencyCode_Control1120064; PrintCurrencyCode())
                        {
                        }
                        column(FORMAT_PostingDate_0_4__Control1120034; FORMAT(PostingDate, 0, 4))
                        {
                        }
                        column(CompanyInformation_City; CompanyInformation.City)
                        {
                        }
                        column(Text004; DraftLbl)
                        {
                        }
                        column(Text005; DraftsLbl)
                        {
                        }
                        column(Payment_Lines_No_; "No.")
                        {
                        }
                        column(Payment_Lines_Line_No_; "Line No.")
                        {
                        }
                        column(Payment_Lines__Account_No__Caption; FIELDCAPTION("Account No."))
                        {
                        }
                        column(Vendor_NameCaption; Vendor_NameCaptionLbl)
                        {
                        }
                        column(Payment_Lines__Bank_Account_Name_Caption; Payment_Lines__Bank_Account_Name_CaptionLbl)
                        {
                        }
                        column(ABS_Amount__Control1120031Caption; ABS_Amount__Control1120031CaptionLbl)
                        {
                        }
                        column(Bank_AccountCaption; Bank_AccountCaptionLbl)
                        {
                        }
                        column(Payment_Lines__SWIFT_Code_Caption; SWIFTCodeCaptionLbl)
                        {
                        }
                        column(Payment_Lines_IBANCaption; IBANCaptionLbl)
                        {
                        }
                        column(ReportCaption; ReportCaptionLbl)
                        {
                        }
                        column(ReportCaption_Control1120015; ReportCaptionLbl)
                        {
                        }
                        column(TotalCaption; TotalCaptionLbl)
                        {
                        }
                        column(Done_at__Caption; DoneAtCaptionLbl)
                        {
                        }
                        column(On__Caption; OnCaptionLbl)
                        {
                        }
                        column(Signature__Caption; Signature__CaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            Vendor.SETRANGE("No.", "Account No.");
                            IF NOT Vendor.FindFirst() THEN
                                ERROR(VendorErr, "Account No.");

                            DraftAmount := ABS(Amount);
                            DraftCounting := 1;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SETRANGE("Account Type", "Account Type"::Vendor);
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
                    LoopsNumber := ABS(CopiesNbr) + 1;
                    CopyText := '';
                    SETRANGE(Number, 1, LoopsNumber);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                PaymtHeader.GET("No.");
                PostingDate := PaymtHeader."Posting Date";

                PaymtManagt.PaymentBankAcc(BankAccountAddr, PaymtHeader);
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("No.", TransfertNo);
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

                    field(CopiesNumber; CopiesNbr)
                    {
                        Caption = 'Number of copies', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nombre de copies"}]}';
                        ToolTip = 'Number of copies', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nombre de copies"}]}';
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        TransfertNo := FORMAT("Payment Lines1".GETFILTER("No."));
        IF TransfertNo = '' THEN
            ERROR(TransfertNoErr);

        CompanyInformation.GET();
        FormatAddress.Company(CompanyAddr, CompanyInformation);
    end;

    var
        CompanyInformation: Record "Company Information";
        Vendor: Record Vendor;
        GLSetup: Record "General Ledger Setup";
        PaymtHeader: Record "Payment Header";
        PaymtManagt: Codeunit "Payment Management";
        FormatAddress: Codeunit "Format Address";
        BankAccountAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        LoopsNumber: Integer;
        CopiesNbr: Integer;
        OutputNo: Integer;
        CopyText: Text;
        DraftAmount: Decimal;
        DraftCounting: Decimal;
        TransfertNo: Code[20];
        PostingDate: Date;
        TransfertNoErr: Label 'You must specify a transfer number.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous devez spécifier un numéro de transfert."}]}';
        VendorErr: Label 'Vendor %1 does not exist.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le fournisseur %1 n''existe pas"}]}';
        CopyLbl: Label 'COPY', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"COPIE"}]}';
        DRaftRecapLbl: Label 'Draft Recapitulation %1 %2', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Récapitulatif de virement %1 %2"}]}';
        PageLbl: Label 'Page', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Page"}]}';
        PaymtHeaderNoCaptionLbl: Label 'Draft No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° virement"}]}';
        CompanyInformation__Phone_No__CaptionLbl: Label 'Phone No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° de téléphone"}]}';
        CompanyInformation__Fax_No__CaptionLbl: Label 'Fax No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Numéro de fax."}]}';
        CompanyInformation__VAT_Registration_No__CaptionLbl: Label 'VAT Registration No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Enregistrement de la TVA"}]}';
        PrintCurrencyCodeCaptionLbl: Label 'Currency Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code devise"}]}';
        PaymtHeader__Bank_Branch_No__CaptionLbl: Label 'Bank Branch No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code établissement"}]}';
        PaymtHeader__Agency_Code_CaptionLbl: Label 'Agency Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code guichet"}]}';
        PaymtHeader__Bank_Account_No__CaptionLbl: Label 'Bank Account No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Numéro de compte bancaire"}]}';
        PaymtHeader__RIB_Key_CaptionLbl: Label 'RIB Key', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Clé RIB"}]}';
        PaymtHeader__National_Issuer_No__CaptionLbl: Label 'National Issuer No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° émetteur national"}]}';
        IBANCaptionLbl: Label 'IBAN', Locked = true, Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"IBAN"}]}';
        SWIFTCodeCaptionLbl: Label 'SWIFT Code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code SWIFT"}]}';
        DraftLbl: Label ' DRAFT', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"VIREMENT"}]}';
        DraftsLbl: Label ' DRAFTS', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"VIREMENTS"}]}';
        Vendor_NameCaptionLbl: Label 'Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom"}]}';
        Payment_Lines__Bank_Account_Name_CaptionLbl: Label 'Bank Account Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom du compte bancaire"}]}';
        ABS_Amount__Control1120031CaptionLbl: Label 'Amount', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montant"}]}';
        Bank_AccountCaptionLbl: Label 'Bank Account', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Compte bancaire"}]}';
        ReportCaptionLbl: Label 'Report', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Edition"}]}';
        TotalCaptionLbl: Label 'Total', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Total"}]}';
        DoneAtCaptionLbl: Label 'Done at :', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Fait à"}]}';
        OnCaptionLbl: Label 'On :', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Au :"}]}';
        Signature__CaptionLbl: Label 'Signature :', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Signature"}]}';


    procedure PrintDraftCounting(): Text[30]
    begin
        EXIT(CopyStr((FORMAT(DraftCounting) + ' ' + "Payment Lines1"."Payment Class"), 1, 30));
    end;


    procedure InitRequest(InitDraftNo: Code[20]; InitCopies: Integer)
    begin
        TransfertNo := InitDraftNo;
        CopiesNbr := InitCopies;
    end;


    procedure PrintCurrencyCode(): Code[10]
    begin
        IF "Payment Lines1"."Currency Code" = '' THEN BEGIN
            GLSetup.GET();
            EXIT(GLSetup."LCY Code");
        END;
        EXIT("Payment Lines1"."Currency Code");
    end;
}