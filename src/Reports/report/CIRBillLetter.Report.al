report 50017 "CIR Bill Letter"
{
    DefaultLayout = RDLC;
    RDLCLayout = './RDL/CIRBillLetter.rdl';
    Caption = 'Bill Letter', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Lettre Traite"}]}';

    dataset
    {
        dataitem("Payment Line"; "Payment Line")
        {
            DataItemTableView = WHERE("Account Type" = CONST(Vendor));
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Payment lines';
            column(BuyFromAddr_1_; BuyFromAddr[1])
            {
            }
            column(BuyFromAddr_2_; BuyFromAddr[2])
            {
            }
            column(BuyFromAddr_3_; BuyFromAddr[3])
            {
            }
            column(BuyFromAddr_4_; BuyFromAddr[4])
            {
            }
            column(BuyFromAddr_5_; BuyFromAddr[5])
            {
            }
            column(BuyFromAddr_6_; BuyFromAddr[6])
            {
            }
            column(BuyFromAddr_7_; BuyFromAddr[7])
            {
            }
            column(BuyFromAddr_8_; BuyFromAddr[8])
            {
            }
            column(CompanyInfo_City; CompanyInfo.City)
            {
            }
            column(CompanyInfo__Post_Code_; CompanyInfo."Post Code")
            {
            }
            column(CompanyInfo_Address; CompanyInfo.Address)
            {
            }
            column(PaymtHeader__Account_No__; PaymtHeader."Account No.")
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(CompanyInfo_City______le_____FORMAT_PaymtHeader__Document_Date__0_; CompanyInfo.City + OnCaptionLbl + FORMAT(PaymtHeader."Document Date", 0))
            {
            }
            column(E_mail________CompanyInfo__E_Mail_; EmailLbl + CompanyInfo."E-Mail")
            {
            }
            column(Fax________CompanyInfo__Fax_No__; FaxLbl + CompanyInfo."Fax No.")
            {
            }
            column(Tel________CompanyInfo__Phone_No__; TelLbl + CompanyInfo."Phone No.")
            {
            }
            column(Payment_Line__Document_No_; "Document No.")
            {
            }
            column(Banck_Transmiting__Caption; Bank_Transmiting__CaptionLbl)
            {
            }
            column(Yours_Ref___Caption; Yours_Ref___CaptionLbl)
            {
            }
            column(Payment_Line_No_; "No.")
            {
            }
            column(Payment_Line_Line_No_; "Line No.")
            {
            }
            dataitem(CopyLoop; Integer)
            {
                DataItemTableView = SORTING(Number);
                column(NoLines; BooGNoLines)
                {
                }
                column(DataItem1000000018; STRSUBSTNO(PleaseFindeBillLetterLbl, FORMAT(ABS("Payment Line".Amount), 0, PrecisionStandardFormatLbl), CurrencyCode, BankAccount.Name))
                {
                }
                column(Text50003; MadamSirLbl)
                {
                }
                column(Text50006; YoursSincerelyLbl)
                {
                }
                column(Text50007; AccountingDeptLbl)
                {
                }
                column(TiersLedgerEntry__External_Document_No__; TiersLedgerEntry."External Document No.")
                {
                }
                column(TiersLedgerEntry__Document_Date_; TiersLedgerEntry."Document Date")
                {
                }
                column(TiersLedgerEntry__Amount_to_Apply_; -TiersLedgerEntry."Amount to Apply")
                {
                }
                column(TiersLedgerEntry__Due_Date_; TiersLedgerEntry."Due Date")
                {
                }
                column(Vendor_Name; Vendor.Name)
                {
                }
                column(Vendor_Address; Vendor.Address)
                {
                }
                column(Vendor__Address_2_; Vendor."Address 2")
                {
                }
                column(FORMAT__Payment_Line__Amount_0___Precision_2___Standard_Format_0___; FORMAT("Payment Line".Amount, 0, PrecisionStandardFormatLbl))
                {
                }
                column(Vendor__Post_Code__________Vendor_City; Vendor."Post Code" + ' ' + Vendor.City)
                {
                }
                column(PaymtHeader__Agency_Code_; PaymtHeader."Agency Code")
                {
                }
                column(PaymtHeader__Bank_Branch_No__; PaymtHeader."Bank Branch No.")
                {
                }
                column(PaymtHeader__Bank_Account_No__; PaymtHeader."Bank Account No.")
                {
                }
                column(PaymtHeader__Posting_Date_; PaymtHeader."Posting Date")
                {
                }
                column(CONVERTSTR_FORMAT_PaymtHeader__RIB_Key__2_______0__; CONVERTSTR(FORMAT(PaymtHeader."RIB Key", 2), ' ', '0'))
                {
                }
                column(Payment_Line___Due_Date_; "Payment Line"."Due Date")
                {
                }
                column(CompanyAddr_1_; CompanyAddr[1])
                {
                }
                column(BankAccount_Name; BankAccount.Name)
                {
                }
                column(BankAccount_City; BankAccount.City)
                {
                }
                column("Acceptée_au_______FORMAT__Payment_Line___Due_Date__0_"; AcceptedAtLbl + FORMAT("Payment Line"."Due Date", 0))
                {
                }
                column(COPYSTR_CompanyInfo__VAT_Registration_No___7_20_; COPYSTR(CompanyInfo."VAT Registration No.", 7, 20))
                {
                }
                column(TiersLedgerEntry__External_Document_No__Caption; ExternalDocumentNoLbl)
                {
                }
                column(Invoice_DateCaption; Invoice_DateCaptionLbl)
                {
                }
                column(Amount_to_ApplyCaption; Amount_to_ApplyCaptionLbl)
                {
                }
                column(Due_DateCaption; Due_DateCaptionLbl)
                {
                }
                column(ACaption; InLbl)
                {
                }
                column("MONTANT_POUR_CONTRÔLECaption"; AmountForControlLbl)
                {
                }
                column(R_I_B_du_TIRECaption; RIBLbl)
                {
                }
                column("code_établ_Caption"; BankBranchNoLbl)
                {
                }
                column(code_guichetCaption; AgencyCodeLbl)
                {
                }
                column(n__de_compteCaption; AccountNoLbl)
                {
                }
                column(DATE_DE_CREATIONCaption; CreationDateLbl)
                {
                }
                column(Valeur_en__Caption; ValueInLbl)
                {
                }
                column(LECaption; OnLbl)
                {
                }
                column(NOMCaption; NameLbl)
                {
                }
                column(et_ADRESSECaption; AndAddressLbl)
                {
                }
                column(du_TIRECaption; OfDraweeLbl)
                {
                }
                column("clé_R_I_BCaption"; RIBKeyLbl)
                {
                }
                column(ECHEANCECaption; DueDateLbl)
                {
                }
                column(Contre_cette_LETTRE_DE_CHANGECaption; AgainstBILLLbl)
                {
                }
                column("stipulée_SANS_FRAISCaption"; NoChargesLbl)
                {
                }
                column("ci_dessous_à_l_ordre_de__Caption"; BelowToOrderLbl)
                {
                }
                column("veuillez_payer_la_somme_indiquéeCaption"; PleasePaySumLbl)
                {
                }
                column(REF_TIRECaption; DraweeRefLbl)
                {
                }
                column(L_C_R_seulementCaption; LCROnlyLbl)
                {
                }
                column(Droit_de_Timbre_et_de_SignatureCaption; StampAndSignatureLbl)
                {
                }
                column(DOMICILIATIONCaption; DOMICILIATIONCaptionLbl)
                {
                }
                column(MONTANTCaption; AmountLbl)
                {
                }
                column(ACCEPTATION_OU_AVALCaption; AcceptanceOrEndorsmentLbl)
                {
                }
                column(ne_rien_inscrire_au_dessous_de_cette_ligneCaption; DoNotWriteAnythingBelowLbl)
                {
                }
                column(Integer_Number; Number)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    cpt := cpt + 1;

                    IF cpt > 1 THEN TiersLedgerEntry.NEXT(1);

                    TiersLedgerEntry.CALCFIELDS(Amount, "Remaining Amount");

                    TiersLedgerEntry.Amount := -TiersLedgerEntry.Amount;
                end;

                trigger OnPreDataItem()
                begin
                    TiersLedgerEntry.RESET();
                    TiersLedgerEntry.SETRANGE("Vendor No.", "Payment Line"."Account No.");
                    TiersLedgerEntry.SETRANGE("Applies-to ID", "Payment Line"."Applies-to ID");
                    IF "Payment Line"."Applies-to ID" = '' THEN
                        TiersLedgerEntry.SETRANGE("Applies-to ID", '-_-');
                    BooGNoLines := TiersLedgerEntry.ISEMPTY;
                    IF TiersLedgerEntry.FindFirst() THEN
                        CopyLoop.SETRANGE(CopyLoop.Number, 1, TiersLedgerEntry.COUNT)
                    ELSE
                        CopyLoop.SETRANGE(CopyLoop.Number, 1, 1);
                    cpt := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                GLSetup.GET();
                PaymtHeader.GET("No.");
                FormatAddress.BankAcc(BankAddr, BankAccount);

                CompanyInfo.GET();
                FormatAddress.Company(CompanyAddr, CompanyInfo);
                CompanyInfo.CALCFIELDS(Picture);

                IF BankAccount.GET(PaymtHeader."Account No.") THEN;

                GLSetup.GET();
                IF Vendor.GET("Payment Line"."Account No.") THEN;

                PayAdress.RESET();
                PayAdress.SETRANGE("Account Type", PayAdress."Account Type"::Vendor);
                PayAdress.SETRANGE("Account No.", "Payment Line"."Account No.");
                PayAdress.SETRANGE(Code, "Payment Line"."Payment Address Code");
                IF PayAdress.FindFirst() THEN
                    FormatAddressMgt.PaymentAddress(BuyFromAddr, PayAdress)
                ELSE
                    FormatAddress.Vendor(BuyFromAddr, Vendor);

                COMPRESSARRAY(BuyFromAddr);
                IF "Payment Line"."Currency Code" = '' THEN
                    CurrencyCode := 'EUR'
                ELSE
                    CurrencyCode := "Payment Line"."Currency Code";
                j := 0;

                IF IssueDateVar = 0D THEN
                    IssueDateVar := WORKDATE();

                VendLedgEntry.RESET();
                VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive);
                VendLedgEntry.SETRANGE("Vendor No.", "Payment Line"."Account No.");
                VendLedgEntry.SETRANGE(Open, TRUE);
                VendLedgEntry.SETRANGE("Applies-to ID", "Applies-to ID");
                IF VendLedgEntry.FIND('-') THEN;

                j := j + 1;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.GET();
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
                    field(IssueDate; IssueDateVar)
                    {
                        ApplicationArea = All;
                        Caption = 'Issue date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date d''émission"}]}';
                        ToolTip = 'Specifies the issue date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date d''émission"}]}';
                    }
                }
            }
        }


        trigger OnOpenPage()
        begin
            CompanyInfo.GET();
            IssueDateVar := WORKDATE();
        end;
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET();
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        PaymtHeader: Record "Payment Header";
        Vendor: Record Vendor;
        BankAccount: Record "Bank Account";
        TiersLedgerEntry: Record "Vendor Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        PayAdress: Record "Payment Address";
        FormatAddressMgt: Codeunit "Format Address Mgt.";
        FormatAddress: Codeunit "Format Address";
        CompanyAddr: array[8] of Text[50];
        BuyFromAddr: array[8] of Text[50];
        CurrencyCode: Code[10];
        cpt: Integer;
        j: Integer;
        IssueDateVar: Date;
        BankAddr: array[8] of Text[50];
        FaxLbl: Label 'Fax :  ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Fax :  "}]}';
        EmailLbl: Label 'E-mail :  ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"E-mail :  "}]}';
        TelLbl: Label 'Tel :  ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Tél :  "}]}';
        AcceptedAtLbl: Label 'Accepted at', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Acceptée au "}]}';
        PrecisionStandardFormatLbl: Label '<Precision,2:><Standard Format,0>', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"<Precision,2:><Standard Format,0>"}]}';
        PleaseFindeBillLetterLbl: Label 'Please find herewith our bill letter payment for the sum of : %1 %2 %3 ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Veuillez trouver ci-joint la lettre de paiement de notre facture pour la somme de: %1 %2 %3 "}]}';
        MadamSirLbl: Label 'Madam, Sir,', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Madame, Monsieur,"}]}';
        YoursSincerelyLbl: Label 'Yours sincerely', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Cordialement"}]}';
        AccountingDeptLbl: Label 'Accounting dept.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Service comptabilité"}]}';
        Bank_Transmiting__CaptionLbl: Label 'Bank Transmiting :', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Transmission bancaire"}]}';
        Yours_Ref___CaptionLbl: Label 'Yours Ref : ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Votre Réf."}]}';
        ExternalDocumentNoLbl: Label 'External Document No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° de document externe"}]}';
        Invoice_DateCaptionLbl: Label 'Invoice Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date de facture"}]}';
        Amount_to_ApplyCaptionLbl: Label 'Amount to Apply', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montant à lettrer"}]}';
        Due_DateCaptionLbl: Label 'Due Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date d''échéance"}]}';
        InLbl: Label 'In', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"À"}]}';
        AmountForControlLbl: Label 'AMOUNT FOR CONTROL', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"MONTANT POUR CONTRÔLE"}]}';
        RIBLbl: Label 'R.I.B.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"R.I.B du TIRE"}]}';
        BankBranchNoLbl: Label 'bank branch no.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"code établ."}]}';
        AgencyCodeLbl: Label 'agency code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"code guichet"}]}';
        AccountNoLbl: Label 'account no.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"n° de compte"}]}';
        CreationDateLbl: Label 'CREATION DATE', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"DATE DE CREATION"}]}';
        ValueInLbl: Label 'Value in :', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Valeur en :"}]}';
        OnCaptionLbl: Label ', on ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":", le "}]}';
        OnLbl: Label 'On', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"LE"}]}';
        NameLbl: Label 'NAME', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"NOM"}]}';
        AndAddressLbl: Label 'and ADDRESS', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"et ADRESSE"}]}';
        OfDraweeLbl: Label 'of DRAWEE', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"du TIRE"}]}';
        RIBKeyLbl: Label 'RIB Key', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"clé R.I.B"}]}';
        DueDateLbl: Label 'DUE DATE', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"ECHEANCE"}]}';
        AgainstBILLLbl: Label 'Against this BILL', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Contre cette LETTRE DE CHANGE"}]}';
        NoChargesLbl: Label 'noted as NO CHARGES', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"stipulée SANS FRAIS"}]}';
        BelowToOrderLbl: Label 'below to the order of :', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"ci-dessous à l''ordre de"}]}';
        PleasePaySumLbl: Label 'please pay the indicated sum', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"veuillez payer la somme indiquée"}]}';
        DraweeRefLbl: Label 'DRAWEE REF.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"REF. TIRE"}]}';
        LCROnlyLbl: Label 'L.C.R only', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"L.C.R seulement"}]}';
        StampAndSignatureLbl: Label 'Stamp and Signature', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Droit de Timbre et de Signature"}]}';
        DOMICILIATIONCaptionLbl: Label 'DOMICILIATION', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"DOMICILIATION"}]}';
        AmountLbl: Label 'AMOUNT', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"MONTANT"}]}';
        AcceptanceOrEndorsmentLbl: Label 'ACCEPTANCE or ENDORSMENT', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"ACCEPTATION OU AVAL"}]}';
        DoNotWriteAnythingBelowLbl: Label 'do not write anything below this line', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"ne rien inscrire au-dessous de cette ligne"}]}';
        BooGNoLines: Boolean;
}