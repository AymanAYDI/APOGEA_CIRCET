report 50007 "CIR Suggest Vendor Payments FR"
{
    Caption = 'Suggest Vendor Payments', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Proposer paiements fournisseur"}]}';
    Permissions = TableData "Vendor Ledger Entry" = rm;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING("No.") WHERE(Blocked = FILTER(' ' | Order));
            RequestFilterFields = "No.", "Payment Method Code";

            trigger OnAfterGetRecord()
            begin
                if StopPayments then
                    CurrReport.Break();
                Window.Update(1, "No.");
                GetVendLedgEntries(true, false);
                GetVendLedgEntries(false, false);
                CheckAmounts(false);
            end;

            trigger OnPostDataItem()
            begin
                if bUsePriority and not StopPayments then begin
                    Reset();
                    CopyFilters(Vend2);
                    SetCurrentKey(Priority);
                    SetRange(Priority, 0);
                    if Find('-') then
                        repeat
                            Window.Update(1, "No.");
                            GetVendLedgEntries(true, false);
                            GetVendLedgEntries(false, false);
                            CheckAmounts(false);
                        until (Next() = 0) or StopPayments;
                end;

                if bUsePaymentDisc and not StopPayments then begin
                    Reset();
                    CopyFilters(Vend2);
                    Window.Open(Text007_Txt);
                    if Find('-') then
                        repeat
                            Window.Update(1, "No.");
                            TempPayableVendLedgEntry.SetRange("Vendor No.", "No.");
                            GetVendLedgEntries(true, true);
                            GetVendLedgEntries(false, true);
                            CheckAmounts(true);
                        until (Next() = 0) or StopPayments;
                end;

                GenPayLine.LockTable();
                GenPayLine.SetRange("No.", GenPayLine."No.");
                if GenPayLine.FindLast() then begin
                    LastLineNo := GenPayLine."Line No.";
                    GenPayLine.Init();
                end;

                Window.Open(Text008_Txt);

                TempPayableVendLedgEntry.Reset();
                TempPayableVendLedgEntry.SetRange(Priority, 1, 2147483647);
                MakeGenPayLines();
                TempPayableVendLedgEntry.Reset();
                TempPayableVendLedgEntry.SetRange(Priority, 0);
                MakeGenPayLines();
                TempPayableVendLedgEntry.Reset();
                TempPayableVendLedgEntry.DeleteAll();

                Window.Close();
                ShowMessage(MessageText);
            end;

            trigger OnPreDataItem()
            begin
                if LastDueDateToPayReq = 0D then
                    Error(Text000_Err);
                if PostingDate = 0D then
                    Error(Text001_Err);

                GenPayLineInserted := false;
                MessageText := '';

                if bUsePaymentDisc and (LastDueDateToPayReq < WorkDate()) then
                    if not
                       Confirm(
                         Text003_Qst +
                         Text004_Qst, false,
                         WorkDate())
                    then
                        Error(Text005_Err);

                Vend2.CopyFilters(Vendor);

                OriginalAmtAvailable := AmountAvailable;
                if bUsePriority then begin
                    SetCurrentKey(Priority);
                    SetRange(Priority, 1, 2147483647);
                    bUsePriority := true;
                end;
                Window.Open(Text006_Txt);

                NextEntryNo := 1;
            end;
        }
    }

    requestpage
    {
        SaveValues = false;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Options"}]}';
                    field(LastPaymentDate; LastDueDateToPayReq)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Last Payment Date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Dernière date échéance"}]}';
                        ToolTip = 'Specifies the latest payment date that can appear on the vendor ledger entries to include in the batch job. ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la dernière date d''échéance qui peut apparaître sur les écritures comptables fournisseur à inclure dans le traitement par lots."}]}';
                    }
                    field(UsePaymentDisc; bUsePaymentDisc)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Find Payment Discounts', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Rechercher les escomptes"}]}';
                        MultiLine = true;
                        ToolTip = 'Specifies whether to include vendor ledger entries for which you can receive a payment discount.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie si vous souhaitez inclure les écritures comptables fournisseur pour lesquelles vous pouvez obtenir un escompte."}]}';
                    }
                    field(SummarizePer; OptSummarizePer)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Summarize per', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Totaliser par"}]}';
                        OptionCaption = ' ,Vendor,Due date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":" ,Fournisseur,Date d''échéance"}]}';
                        ToolTip = 'Specifies how to summarize. Choose the Vendor option for one summarized line per vendor for open ledger entries. Choose the Due Date option for one summarized line per due date per vendor for open ledger entries. Choose the empty option if you want each open vendor ledger entry to result in an individual payment line.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie comment totaliser. Sélectionnez l''option Fournisseur pour une ligne totalisée par fournisseur pour les écritures comptables ouvertes. Sélectionnez l''option Date d''échéance pour une ligne totalisée par délai par fournisseur pour les écritures comptables ouvertes. Sélectionnez l''option vide si vous souhaitez que chaque écriture comptable fournisseur ouverte apparaisse sur une ligne de paiement individuelle."}]}';
                    }
                    field(UsePriority; bUsePriority)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Use Vendor Priority', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Utiliser priorité fournisseur"}]}';
                        ToolTip = 'Specifies whether to order suggested payments based on the priority that is specified for the vendor on the Vendor card.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie s''il faut trier les paiements proposés en fonction de la priorité indiquée pour le fournisseur sur la fiche fournisseur."}]}';

                        trigger OnValidate()
                        begin
                            if not bUsePriority and (AmountAvailable <> 0) then
                                Error(Text011_Err);
                        end;
                    }
                    field(AvailableAmountLCY; AmountAvailable)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Available Amount (LCY)', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Montant disponible DS"}]}';
                        ToolTip = 'Specifies a maximum amount available in local currency for payments. ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie un montant maximal disponible dans la devise locale pour les paiements."}]}';

                        trigger OnValidate()
                        begin
                            AmountAvailableOnAfterValidate();
                        end;
                    }
                    field(CurrencyFilter; gCurrencyFilter)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Currency Filter', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Filtre devise"}]}';
                        Editable = false;
                        TableRelation = Currency;
                        ToolTip = 'Specifies the currencies to include in the transfer. To see the available currencies, choose the Filter field.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie les devises à inclure dans le transfert. Pour visualiser les devises disponibles, cliquez sur le champ filtre."}]}';
                    }
                }
            }
        }
    }

    var
        Vend2: Record Vendor;
        GenPayHead: Record "Payment Header";
        GenPayLine: Record "Payment Line";
        VendLedgEntry: Record "Vendor Ledger Entry";
        TempPayableVendLedgEntry: Record "Payable Vendor Ledger Entry" temporary;
        TempPaymentPostBuffer: Record "Payment Post. Buffer" temporary;
        TempOldTempPaymentPostBuffer: Record "Payment Post. Buffer" temporary;
        PaymentClass: Record "Payment Class";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text000_Err: Label 'Please enter the last payment date.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Veuillez entrer la dernière date d''échéance."}]}';
        Text001_Err: Label 'Please enter the posting date.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Veuillez entrer une date de comptabilisation."}]}';
        Text003_Qst: Label 'The selected last due date is earlier than %1.\\', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"La date de dernière échéance sélectionnée est antérieure au %1.\\"}]}';
        Text004_Qst: Label 'Do you still want to run the batch job?', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Souhaitez-vous tout de même exécuter ce traitement par lots ?"}]}';
        Text005_Err: Label 'The batch job was interrupted.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le traitement par lots a été interrompu."}]}';
        Text006_Txt: Label 'Processing vendors     #1##########', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Traitement des fournisseurs     #1##########"}]}';
        Text007_Txt: Label 'Processing vendors for payment discounts #1##########', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":" Traitement des escomptes fournisseur #1##########"}]}';
        Text008_Txt: Label 'Inserting payment journal lines #1##########', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Insertion des lignes f. paiement #1##########"}]}';
        Text011_Err: Label 'Use Vendor Priority must be activated when the value in the Amount Available field is not 0.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le champ Utiliser priorité fournisseur doit être activé lorsque la valeur du champ Montant disponible est différente de 0."}]}';
        Text016_Err: Label ' is already applied to %1 %2 for vendor %3.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"est déjà lettré(e) avec %1 %2 pour le fournisseur %3."}]}';
        Window: Dialog;
        bUsePaymentDisc: Boolean;
        PostingDate: Date;
        LastDueDateToPayReq: Date;
        NextDocNo: Code[20];
        AmountAvailable: Decimal;
        OriginalAmtAvailable: Decimal;
        bUsePriority: Boolean;
        OptSummarizePer: Option " ",Vendor,"Due date";
        LastLineNo: Integer;
        NextEntryNo: Integer;
        StopPayments: Boolean;
        MessageText: Text;
        GenPayLineInserted: Boolean;
        gCurrencyFilter: Code[10];


    procedure SetGenPayLine(NewGenPayLine: Record "Payment Header")
    begin
        GenPayHead := NewGenPayLine;
        GenPayLine."No." := NewGenPayLine."No.";
        PaymentClass.Get(GenPayHead."Payment Class");
        PostingDate := GenPayHead."Posting Date";
        gCurrencyFilter := GenPayHead."Currency Code";
    end;


    procedure GetVendLedgEntries(Positive: Boolean; Future: Boolean)
    begin
        VendLedgEntry.Reset();
        VendLedgEntry.SetCurrentKey("Vendor No.", Open, Positive, "Due Date");
        VendLedgEntry.SetRange("Vendor No.", Vendor."No.");
        VendLedgEntry.SetRange(Open, true);
        VendLedgEntry.SetRange(Positive, Positive);
        VendLedgEntry.SetRange("Currency Code", gCurrencyFilter);
        VendLedgEntry.SetRange("Applies-to ID", '');
        if Future then begin
            VendLedgEntry.SetRange("Due Date", LastDueDateToPayReq + 1, 99991231D);
            VendLedgEntry.SetRange("Pmt. Discount Date", PostingDate, LastDueDateToPayReq);
            VendLedgEntry.SetFilter("Original Pmt. Disc. Possible", '<0');
        end else
            VendLedgEntry.SetRange("Due Date", 0D, LastDueDateToPayReq);
        VendLedgEntry.SetRange("On Hold", '');
        if VendLedgEntry.Find('-') then
            repeat
                SaveAmount();
            until VendLedgEntry.Next() = 0;
    end;

    local procedure SaveAmount()
    begin
        GenPayLine."Account Type" := GenPayLine."Account Type"::Vendor;
        GenPayLine.Validate("Account No.", VendLedgEntry."Vendor No.");
        GenPayLine."Posting Date" := VendLedgEntry."Posting Date";
        GenPayLine."Currency Factor" := VendLedgEntry."Adjusted Currency Factor";
        if GenPayLine."Currency Factor" = 0 then
            GenPayLine."Currency Factor" := 1;
        GenPayLine.Validate("Currency Code", VendLedgEntry."Currency Code");
        VendLedgEntry.CalcFields("Remaining Amount");
        if ((VendLedgEntry."Document Type" = VendLedgEntry."Document Type"::"Credit Memo") and
            (VendLedgEntry."Remaining Pmt. Disc. Possible" <> 0) or
            (VendLedgEntry."Document Type" = VendLedgEntry."Document Type"::Invoice)) and
           (PostingDate <= VendLedgEntry."Pmt. Discount Date")
        then
            GenPayLine.Amount := -(VendLedgEntry."Remaining Amount" - VendLedgEntry."Original Pmt. Disc. Possible")
        else
            GenPayLine.Amount := -VendLedgEntry."Remaining Amount";
        GenPayLine.Validate(Amount);

        if bUsePriority then
            TempPayableVendLedgEntry.Priority := Vendor.Priority
        else
            TempPayableVendLedgEntry.Priority := 0;
        TempPayableVendLedgEntry."Vendor No." := VendLedgEntry."Vendor No.";
        TempPayableVendLedgEntry."Entry No." := NextEntryNo;
        TempPayableVendLedgEntry."Vendor Ledg. Entry No." := VendLedgEntry."Entry No.";
        TempPayableVendLedgEntry.Amount := GenPayLine.Amount;
        TempPayableVendLedgEntry."Amount (LCY)" := GenPayLine."Amount (LCY)";
        TempPayableVendLedgEntry.Positive := (TempPayableVendLedgEntry.Amount > 0);
        TempPayableVendLedgEntry.Future := (VendLedgEntry."Due Date" > LastDueDateToPayReq);
        TempPayableVendLedgEntry."Currency Code" := VendLedgEntry."Currency Code";
        TempPayableVendLedgEntry."Due Date" := VendLedgEntry."Due Date";
        TempPayableVendLedgEntry.Insert();
        NextEntryNo := NextEntryNo + 1;
    end;


    procedure CheckAmounts(Future: Boolean)
    var
        CurrencyBalance: Decimal;
        PrevCurrency: Code[10];
    begin
        TempPayableVendLedgEntry.SetRange("Vendor No.", Vendor."No.");
        TempPayableVendLedgEntry.SetRange(Future, Future);
        if TempPayableVendLedgEntry.Find('-') then begin
            PrevCurrency := TempPayableVendLedgEntry."Currency Code";
            repeat
                if TempPayableVendLedgEntry."Currency Code" <> PrevCurrency then begin
#pragma warning disable AA0205
                    if CurrencyBalance < 0 then begin
#pragma warning restore AA0205
                        TempPayableVendLedgEntry.SetRange("Currency Code", PrevCurrency);
                        TempPayableVendLedgEntry.DeleteAll();
                        TempPayableVendLedgEntry.SetRange("Currency Code");
                    end else
                        AmountAvailable := AmountAvailable - CurrencyBalance;
                    CurrencyBalance := 0;
                    PrevCurrency := TempPayableVendLedgEntry."Currency Code";
                end;
                if (OriginalAmtAvailable = 0) or
                   (AmountAvailable >= CurrencyBalance + TempPayableVendLedgEntry."Amount (LCY)")
                then
                    CurrencyBalance := CurrencyBalance + TempPayableVendLedgEntry."Amount (LCY)"
                else
                    TempPayableVendLedgEntry.Delete();
            until TempPayableVendLedgEntry.Next() = 0;
            if CurrencyBalance < 0 then begin
                TempPayableVendLedgEntry.SetRange("Currency Code", PrevCurrency);
                TempPayableVendLedgEntry.DeleteAll();
                TempPayableVendLedgEntry.SetRange("Currency Code");
            end else
                if OriginalAmtAvailable > 0 then
                    AmountAvailable := AmountAvailable - CurrencyBalance;
            if (OriginalAmtAvailable > 0) and (AmountAvailable <= 0) then
                StopPayments := true;
        end;
        TempPayableVendLedgEntry.Reset();
    end;

    local procedure InsertTempPaymentPostBuffer(var pTempPaymentPostBuffer: Record "Payment Post. Buffer" temporary; var pVendLedgEntry: Record "Vendor Ledger Entry")
    begin
        pTempPaymentPostBuffer."Applies-to Doc. Type" := pVendLedgEntry."Document Type";
        pTempPaymentPostBuffer."Applies-to Doc. No." := pVendLedgEntry."Document No.";
        pTempPaymentPostBuffer."Currency Factor" := pVendLedgEntry."Adjusted Currency Factor";
        pTempPaymentPostBuffer.Amount := TempPayableVendLedgEntry.Amount;
        pTempPaymentPostBuffer."Amount (LCY)" := TempPayableVendLedgEntry."Amount (LCY)";
        pTempPaymentPostBuffer."Global Dimension 1 Code" := pVendLedgEntry."Global Dimension 1 Code";
        pTempPaymentPostBuffer."Global Dimension 2 Code" := pVendLedgEntry."Global Dimension 2 Code";
        pTempPaymentPostBuffer."Auxiliary Entry No." := pVendLedgEntry."Entry No.";
        pTempPaymentPostBuffer.Insert();
    end;

    local procedure MakeGenPayLines()
    var
        GenPayLine3: Record "Gen. Journal Line";
    begin
        TempPaymentPostBuffer.DeleteAll();

        if TempPayableVendLedgEntry.Find('-') then
            repeat
                TempPayableVendLedgEntry.SetRange("Vendor No.", TempPayableVendLedgEntry."Vendor No.");
                TempPayableVendLedgEntry.Find('-');
                repeat
                    VendLedgEntry.Get(TempPayableVendLedgEntry."Vendor Ledg. Entry No.");
                    TempPaymentPostBuffer."Account No." := VendLedgEntry."Vendor No.";
                    TempPaymentPostBuffer."Currency Code" := VendLedgEntry."Currency Code";
                    if OptSummarizePer = OptSummarizePer::"Due date" then
                        TempPaymentPostBuffer."Due Date" := VendLedgEntry."Due Date";

                    TempPaymentPostBuffer."Dimension Entry No." := 0;
                    TempPaymentPostBuffer."Global Dimension 1 Code" := '';
                    TempPaymentPostBuffer."Global Dimension 2 Code" := '';

                    if OptSummarizePer in [OptSummarizePer::Vendor, OptSummarizePer::"Due date"] then begin
                        TempPaymentPostBuffer."Auxiliary Entry No." := 0;
                        if TempPaymentPostBuffer.Find() then begin
                            TempPaymentPostBuffer.Amount := TempPaymentPostBuffer.Amount + TempPayableVendLedgEntry.Amount;
                            TempPaymentPostBuffer."Amount (LCY)" := TempPaymentPostBuffer."Amount (LCY)" + TempPayableVendLedgEntry."Amount (LCY)";
                            TempPaymentPostBuffer.Modify();
                        end else begin
                            LastLineNo := LastLineNo + 10000;
                            TempPaymentPostBuffer."Payment Line No." := LastLineNo;
                            if PaymentClass."Line No. Series" = '' then begin
                                NextDocNo := CopyStr(GenPayHead."No." + '/' + Format(LastLineNo), 1, MaxStrLen(NextDocNo));
                                TempPaymentPostBuffer."Applies-to ID" := NextDocNo;
                            end else begin
                                NextDocNo := NoSeriesMgt.GetNextNo(PaymentClass."Line No. Series", PostingDate, false);
                                TempPaymentPostBuffer."Applies-to ID" := GenPayHead."No." + '/' + NextDocNo;
                            end;
                            TempPaymentPostBuffer."Document No." := NextDocNo;
                            NextDocNo := IncStr(NextDocNo);
                            TempPaymentPostBuffer.Amount := TempPayableVendLedgEntry.Amount;
                            TempPaymentPostBuffer."Amount (LCY)" := TempPayableVendLedgEntry."Amount (LCY)";
                            Window.Update(1, VendLedgEntry."Vendor No.");
                            TempPaymentPostBuffer.Insert();
                        end;
                        VendLedgEntry."Applies-to ID" := TempPaymentPostBuffer."Applies-to ID";
                        CODEUNIT.Run(CODEUNIT::"Vend. Entry-Edit", VendLedgEntry);
                    end else begin
                        GenPayLine3.Reset();
                        GenPayLine3.SetCurrentKey(
                          "Account Type", "Account No.", "Applies-to Doc. Type", "Applies-to Doc. No.");
                        GenPayLine3.SetRange("Account Type", GenPayLine3."Account Type"::Vendor);
                        GenPayLine3.SetRange("Account No.", VendLedgEntry."Vendor No.");
                        GenPayLine3.SetRange("Applies-to Doc. Type", VendLedgEntry."Document Type");
                        GenPayLine3.SetRange("Applies-to Doc. No.", VendLedgEntry."Document No.");
                        if GenPayLine3.FindFirst() then
                            GenPayLine3.FieldError(
                              "Applies-to Doc. No.",
                              StrSubstNo(
                                Text016_Err,
                                VendLedgEntry."Document Type", VendLedgEntry."Document No.",
                                VendLedgEntry."Vendor No."));
                        InsertTempPaymentPostBuffer(TempPaymentPostBuffer, VendLedgEntry);
                        Window.Update(1, VendLedgEntry."Vendor No.");
                    end;
                    VendLedgEntry.CalcFields("Remaining Amount");
                    VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
                    CODEUNIT.Run(CODEUNIT::"Vend. Entry-Edit", VendLedgEntry);
                until TempPayableVendLedgEntry.Next() = 0;
                TempPayableVendLedgEntry.SetFilter("Vendor No.", '>%1', TempPayableVendLedgEntry."Vendor No.");
            until not TempPayableVendLedgEntry.FindFirst();

        Clear(TempOldTempPaymentPostBuffer);
        TempPaymentPostBuffer.SetCurrentKey("Document No.");
        if TempPaymentPostBuffer.Find('-') then
            repeat
                GenPayLine.Init();
                Window.Update(1, TempPaymentPostBuffer."Account No.");
                if OptSummarizePer = OptSummarizePer::" " then begin
                    LastLineNo := LastLineNo + 10000;
                    GenPayLine."Line No." := LastLineNo;
                    if PaymentClass."Line No. Series" = '' then begin
                        NextDocNo := CopyStr(GenPayHead."No." + '/' + Format(GenPayLine."Line No."), 1, MaxStrLen(NextDocNo));
                        GenPayLine."Applies-to ID" := NextDocNo;
                    end else begin
                        NextDocNo := NoSeriesMgt.GetNextNo(PaymentClass."Line No. Series", PostingDate, false);
                        GenPayLine."Applies-to ID" := GenPayHead."No." + '/' + NextDocNo;
                    end;
                end else begin
                    GenPayLine."Line No." := TempPaymentPostBuffer."Payment Line No.";
                    NextDocNo := TempPaymentPostBuffer."Document No.";
                    GenPayLine."Applies-to ID" := TempPaymentPostBuffer."Applies-to ID";
                end;
                GenPayLine."Document No." := NextDocNo;
                TempOldTempPaymentPostBuffer := TempPaymentPostBuffer;
                TempOldTempPaymentPostBuffer."Document No." := GenPayLine."Document No.";
                if OptSummarizePer = OptSummarizePer::" " then begin
                    VendLedgEntry.Get(TempPaymentPostBuffer."Auxiliary Entry No.");
                    VendLedgEntry."Applies-to ID" := GenPayLine."Applies-to ID";
                    VendLedgEntry.Modify();
                end;
                GenPayLine."Account Type" := GenPayLine."Account Type"::Vendor;
                GenPayLine.Validate("Account No.", TempPaymentPostBuffer."Account No.");
                GenPayLine."Currency Code" := TempPaymentPostBuffer."Currency Code";
                GenPayLine."Currency Factor" := GenPayHead."Currency Factor";
                if GenPayLine."Currency Factor" = 0 then
                    GenPayLine."Currency Factor" := 1;
                GenPayLine.Validate(Amount, TempPaymentPostBuffer.Amount);
                Vend2.Get(GenPayLine."Account No.");
                GenPayLine.Validate("Bank Account Code", Vend2."Preferred Bank Account Code");
                GenPayLine."Payment Class" := GenPayHead."Payment Class";
                GenPayLine.Validate("Status No.");
                GenPayLine."Posting Date" := PostingDate;
                if OptSummarizePer = OptSummarizePer::" " then begin
                    GenPayLine."Applies-to Doc. Type" := VendLedgEntry."Document Type";
                    GenPayLine."Applies-to Doc. No." := VendLedgEntry."Document No.";
                    GenPayLine."Dimension Set ID" := VendLedgEntry."Dimension Set ID";
                end;
                case OptSummarizePer of
                    OptSummarizePer::" ":
                        GenPayLine."Due Date" := VendLedgEntry."Due Date";
                    OptSummarizePer::Vendor:
                        begin
                            TempPayableVendLedgEntry.SetCurrentKey("Vendor No.", "Due Date");
                            TempPayableVendLedgEntry.SetRange("Vendor No.", TempPaymentPostBuffer."Account No.");
                            TempPayableVendLedgEntry.Find('-');
                            GenPayLine."Due Date" := TempPayableVendLedgEntry."Due Date";
                            TempPayableVendLedgEntry.DeleteAll();
                        end;
                    OptSummarizePer::"Due date":
                        GenPayLine."Due Date" := TempPaymentPostBuffer."Due Date";
                end;
                if GenPayLine.Amount <> 0 then begin
                    if GenPayLine."Dimension Set ID" = 0 then // per "Customer", per "Due Date"
                        GenPayLine.DimensionSetup();
                    GenPayLine.Insert();
                end;
                GenPayLineInserted := true;
            until TempPaymentPostBuffer.Next() = 0;
    end;

    local procedure ShowMessage(Text: Text)
    begin
        if (Text <> '') and GenPayLineInserted then
            Message(Text);
    end;

    local procedure AmountAvailableOnAfterValidate()
    begin
        if AmountAvailable <> 0 then
            bUsePriority := true;
    end;
}