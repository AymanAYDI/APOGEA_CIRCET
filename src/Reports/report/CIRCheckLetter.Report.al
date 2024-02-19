report 50025 "CIR Check Letter"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RDL/CIRCheckLetter.rdl';
    Caption = 'Check Letter', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Lettre chèque"}]}';
    UsageCategory = None;

    dataset
    {
        dataitem("Payment Lines1"; "Payment Line")
        {
            DataItemTableView = SORTING("No.", "Line No.")
                                WHERE(Marked = CONST(True));
            RequestFilterFields = "No.";
            column(Payment_Lines1_No_; "No.")
            {
            }
            column(Payment_Lines1_Line_No_; "Line No.")
            {
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                column(Number_CopyLoop; Number)
                {
                }
                column(LoopsNumber; LoopsNumber)
                {
                }
                dataitem(PageLoop; Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number = CONST(1));
                    dataitem("Payment Line"; "Payment Line")
                    {
                        DataItemLink = "No." = FIELD("No."),
                                       "Line No." = FIELD("Line No.");
                        DataItemLinkReference = "Payment Lines1";
                        DataItemTableView = SORTING("No.", "Line No.");
                        column(CompanyInformation_City______le_____FORMAT_PostingDate_0_4_; CompanyInformation.City + '  le ' + FORMAT(PostingDate, 0, 4))
                        {
                        }
                        column(VendAddr_7_; VendAddr[7])
                        {
                        }
                        column(VendAddr_6_; VendAddr[6])
                        {
                        }
                        column(VendAddr_5_; VendAddr[5])
                        {
                        }
                        column(VendAddr_4_; VendAddr[4])
                        {
                        }
                        column(VendAddr_3_; VendAddr[3])
                        {
                        }
                        column(VendAddr_2_; VendAddr[2])
                        {
                        }
                        column(VendAddr_1_; VendAddr[1])
                        {
                        }
                        column("Payment_Line_Référence"; Reference)
                        {
                        }
                        column("Veuillez_trouver_sous_ce_pli__un_chèque_de_____FORMAT_Amount________tiré_sur_la_banque_____PaymtHeader__Account_No__"; 'Veuillez trouver sous ce pli, un chèque de ' + FORMAT(Amount) + ' € tiré sur la banque ' + PaymtHeader."Account No.")
                        {
                        }
                        column("Recevez__Messieurs__l__expression_de_nos_salutations_distinguées__"; 'Recevez, Messieurs, l''expression de nos salutations distinguées.')
                        {
                        }
                        column(CheckAmountText; CheckAmountText)
                        {
                        }
                        column(CheckDateText; CheckDateText)
                        {
                        }
                        column(DescriptionLine_2_; DescriptionLine[2])
                        {
                        }
                        column(DescriptionLine_1_; DescriptionLine[1])
                        {
                        }
                        column(OrdreChq; OrdreChq)
                        {
                        }
                        column(CompanyInformation_City; CompanyInformation.City)
                        {
                        }
                        column("RéférenceCaption"; ReferenceCaptionLbl)
                        {
                        }
                        column(Payment_Line_No_; "No.")
                        {
                        }
                        column(Payment_Line_Line_No_; "Line No.")
                        {
                        }
                        column(Payment_Line_Account_No_; "Account No.")
                        {
                        }
                        column(Payment_Line_Applies_to_ID; "Applies-to ID")
                        {
                        }
                        column(RecBankAccountType; recBankAccount."Print Check Format")
                        {
                        }
                        dataitem(DataItem4114; "Vendor Ledger Entry")
                        {
                            CalcFields = "Remaining Amount";
                            DataItemLink = "Vendor No." = FIELD("Account No."),
                                           "Applies-to ID" = FIELD("Applies-to ID");
                            DataItemLinkReference = "Payment Line";
                            DataItemTableView = SORTING("Document No.", "Document Type", "Vendor No.");
                            column(HeaderText2; HeaderText2Lbl)
                            {
                            }
                            column(ABS__Remaining_Amount__; ABS("Remaining Amount"))
                            {
                                AutoFormatExpression = "Currency Code";
                                AutoFormatType = 1;
                            }
                            column(PrintCurrencyCode; PrintCurrencyCode())
                            {
                            }
                            column(Vendor_Ledger_Entry__Currency_Code_; "Currency Code")
                            {
                            }
                            column(Vendor_Ledger_Entry__Document_No__; "Document No.")
                            {
                            }
                            column(Vendor_Ledger_Entry__External_Document_No__; "External Document No.")
                            {
                            }
                            column(Vendor_Ledger_Entry__Posting_Date_; "Posting Date")
                            {
                            }
                            column(Vendor_Ledger_Entry__Document_No__Caption; FIELDCAPTION("Document No."))
                            {
                            }
                            column(Vendor_Ledger_Entry__External_Document_No__Caption; FIELDCAPTION("External Document No."))
                            {
                            }
                            column(DateCaption; DateCaptionLbl)
                            {
                            }
                            column(ReportCaption; ReportCaptionLbl)
                            {
                            }
                            column(Vendor_Ledger_Entry_Entry_No_; "Entry No.")
                            {
                            }
                            column(Vendor_Ledger_Entry_Vendor_No_; "Vendor No.")
                            {
                            }
                            column(Vendor_Ledger_Entry_Applies_to_ID; "Applies-to ID")
                            {
                            }
                            column(ABS__Remaining_Amount__Caption; AmountCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                IF "Payment Line"."Applies-to ID" = '' THEN
                                    CurrReport.SKIP()
                                ELSE
                                    IF "Currency Code" = '' THEN
                                        "Currency Code" := GLSetup."LCY Code";

                                NbreEcrLettrees += 1;
                                IF NbreEcrLettrees > 12 THEN
                                    ERROR(PbOnCheckCantCoverMore12DocumentsErr, "Payment Lines1"."Document No.");

                                DraftCounting := DraftCounting + 1;
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            IF NOT Vendor.GET("Account No.") THEN
                                Vendor.INIT();

                            FormatAddressMgt.FillAdresseAccortingToPaymentLineAccountType(VendAddr, "Payment Line");

                            DraftAmount := ABS(Amount);

                            CheckReport.InitTextVariable();
                            CheckReport.FormatNoText(DescriptionLine, DraftAmount, "Currency Code");

                            CheckAmountText := FORMAT(DraftAmount, 0, '<Sign><Integer Thousand><Decimals,3>');
                            CheckDateText := FORMAT(TODAY);

                            IF NOT CurrReport.PREVIEW THEN BEGIN
                                "External Document No." := "Document No.";
                                MODIFY();
                            END;

                            IF "Currency Code" = '' THEN
                                "Currency Code" := '€';

                            IF Vendor."Check Order" <> '' THEN
                                OrdreChq := Vendor."Check Order"
                            ELSE
                                OrdreChq := VendAddr[1];

                            HeaderText1 := STRSUBSTNO(TransfertDoneLbl, "Payment Line"."Bank Account Name", "Payment Line"."Bank Branch No.",
                              "Payment Line"."Agency Code", "Payment Line"."Bank Account No.", PostingDate);
                            DraftCounting := 0;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    IF Number > 1 THEN
                        CopyText := CopyLbl;
                end;

                trigger OnPreDataItem()
                begin
                    LoopsNumber := ABS(CopiesNumber) + 1;
                    CopyText := '';
                    SETRANGE(Number, 1, LoopsNumber);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                PaymtHeader.GET("No.");
                PaymtHeader.CALCFIELDS("Payment Class Name");
                PostingDate := PaymtHeader."Posting Date";
                BankAccountBuffer.Init();
                BankAccountBuffer."Customer No." := "Account No.";
                BankAccountBuffer."Bank Branch No." := "Bank Branch No.";
                BankAccountBuffer."Agency Code" := "Agency Code";
                BankAccountBuffer."Bank Account No." := "Bank Account No.";
                IF NOT BankAccountBuffer.INSERT() THEN;

                recBankAccount.INIT();
                IF PaymtHeader."Account Type" = PaymtHeader."Account Type"::"Bank Account" THEN
                    IF recBankAccount.GET(PaymtHeader."Account No.") THEN;
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("No.", TransfertNo);
            end;
        }
    }

    trigger OnInitReport()
    begin
        CopiesNumber := 0;
    end;

    trigger OnPostReport()
    begin
        BankAccountBuffer.DELETEALL();
    end;

    trigger OnPreReport()
    begin
        TransfertNo := CopyStr("Payment Lines1".GETFILTER("No."), 1, MaxStrLen(TransfertNo));
        IF TransfertNo = '' THEN
            ERROR(MustSpecifyTransfertNoErr);

        CompanyInformation.GET();
        FormatAddress.Company(CompanyAddr, CompanyInformation);
        GLSetup.GET();
    end;

    var
        CompanyInformation: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        PaymtHeader: Record "Payment Header";
        BankAccountBuffer: Record "Bank Account Buffer";
        Vendor: Record Vendor;
        recBankAccount: Record "Bank Account";
        CheckReport: Report "CIR Check";
        FormatAddress: Codeunit "Format Address";
        FormatAddressMgt: Codeunit "Format Address Mgt.";
        MustSpecifyTransfertNoErr: Label 'You must specify a transfert''s no.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous devez spécifier un N° de transfert"}]}';
        CopyLbl: Label 'COPY', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Copie"}]}';
        TransfertDoneLbl: Label 'A transfert to your bank account %1 (RIB : %2 %3 %4) has been done on %5.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Un transfert vers votre compte bancaire %1 (RIB : %2 %3 %4) a été fait le %5."}]}';
        HeaderText2Lbl: Label 'This transfert is relied to these invoices :', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ce virement est lié à ces factures :"}]}';
        ReferenceCaptionLbl: Label 'Reference', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Référence"}]}';
        AmountCaptionLbl: Label 'Amount', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montant"}]}';
        DateCaptionLbl: Label 'Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date"}]}';
        ReportCaptionLbl: Label 'Report', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Rapport"}]}';
        PbOnCheckCantCoverMore12DocumentsErr: Label 'Problem with check %1 : you cannot cover more than 12 documents per check', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Problème sur le chèque %1 : vous ne pouvez pas lettrer plus de 12 documents par chèque."}]}';
        VendAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        LoopsNumber: Integer;
        CopiesNumber: Integer;
        CopyText: Text[30];
        DraftAmount: Decimal;
        TransfertNo: Code[20];
        HeaderText1: Text[250];
        PostingDate: Date;
        CheckAmountText: Text[15];
        CheckDateText: Text[30];
        DescriptionLine: array[3] of Text[132];
        OrdreChq: Text[80];
        NbreEcrLettrees: Integer;
        DraftCounting: Decimal;


    procedure PrintCurrencyCode(): Code[10]
    begin
        IF "Payment Lines1"."Currency Code" = '' THEN
            EXIT(GLSetup."LCY Code")
        ELSE
            EXIT("Payment Lines1"."Currency Code");
    end;
}

