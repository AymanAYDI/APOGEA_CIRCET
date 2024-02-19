codeunit 50036 "Upgrade Historic"
{
    Permissions = tabledata "G/L Entry" = rm,
                  tabledata "Job Ledger Entry" = rm,
                  tabledata "Cust. Ledger Entry" = rm,
                  tabledata "Detailed Cust. Ledg. Entry" = rm,
                  tabledata "Vendor Ledger Entry" = rm,
                  tabledata "Detailed Vendor Ledg. Entry" = rm,
                  tabledata "Item Ledger Entry" = rm,
                  tabledata "Res. Ledger Entry" = rm,
                  tabledata "FA Ledger Entry" = rm,
                  tabledata "Value Entry" = rm,
                  tabledata "Sales Invoice Header" = rm,
                  tabledata "Sales Invoice Line" = rm,
                  tabledata "Sales Cr.Memo Header" = rm,
                  tabledata "Sales Cr.Memo Line" = rm,
                  tabledata "Purch. Rcpt. Header" = rm,
                  tabledata "Purch. Rcpt. Line" = rm,
                  tabledata "Purch. Inv. Header" = rm,
                  tabledata "Purch. Inv. Line" = rm,
                  tabledata "Purch. Cr. Memo Hdr." = rm,
                  tabledata "Purch. Cr. Memo Line" = rm,
                  tabledata ARBVRNPostedWorkCertifHeader = rm,
                  tabledata ARBVRNPostedWorkCertifLines = rm,
                  tabledata ARBVRNPostedProductionHeader = rm,
                  tabledata ARBVRNPostedProductionLines = rm,
                  tabledata ARBVRNPostVeronaTimeSheetHeade = rm,
                  tabledata ARBVRNPostVeronaTimeSheetLines = rm,
                  tabledata ARBVRNPostedTravelExpensesHdr = rm,
                  tabledata ARBVRNPostedTravelExpensesLine = rm,
                  tabledata ARBVRNPostedOutDispatchNoteHDR = rm,
                  tabledata ARBVRNPostOutputDispNoteLin = rm,
                  tabledata ARBVRNPostTransferExpIncomeHdr = rm,
                  tabledata ARBVRNPostTransferExpIncomeLin = rm,
                  tabledata "Dimension Set Entry" = r;

    var
        GeneralApplicationSetup: Record "General Application Setup";

    [EventSubscriber(ObjectType::Table, Database::Job, 'OnAfterValidateShortcutDimCode', '', false, false)]
    local procedure OnAfterValidateShortcutDimCode_Job_CIRCETFR(var Job: Record Job; var xJob: Record Job; FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        VeronaFunctions: Codeunit ARBVRNVeronaFunctions;
    begin
        GeneralLedgerSetup.Get();
        case FieldNumber of
            1:
                if GeneralLedgerSetup."Global Dimension 1 Code" = VeronaFunctions.DevolverDimDpto() then begin
                    if xJob."Global Dimension 1 Code" = Job."Global Dimension 1 Code" then
                        exit;
                    UpgradeHistoricDimension(Job, FieldNumber);
                end;
            2:
                if GeneralLedgerSetup."Global Dimension 2 Code" = VeronaFunctions.DevolverDimDpto() then begin
                    if xJob."Global Dimension 2 Code" = Job."Global Dimension 2 Code" then
                        exit;
                    UpgradeHistoricDimension(Job, FieldNumber);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Default Dimension", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnAfterModifyEvent_DefaultDimension(var Rec: Record "Default Dimension"; var xRec: Record "Default Dimension"; RunTrigger: Boolean)
    var
        Job: Record Job;
        lRecJobHijos: Record Job;
        VeronaFunctions: Codeunit ARBVRNVeronaFunctions;
    begin
        if not RunTrigger then
            exit;
        if Rec."Table ID" <> Database::Job then
            exit;
        if Rec."Dimension Code" <> VeronaFunctions.DevolverDimDpto() then
            exit;
        if Job.Get(Rec."No.") then begin
            UpgradeHistoricDimension(Job, VeronaFunctions.FunGetPosDim(VeronaFunctions.DevolverDimDpto()));
            if Job.ARBVRNJobMatrixWork = Job.ARBVRNJobMatrixWork::"Matrix Job" then begin
                lRecJobHijos.SetRange(ARBVRNJobMatrixWork, lRecJobHijos.ARBVRNJobMatrixWork::"Work Job");
                lRecJobHijos.SetRange(ARBVRNJobMatrixItBelongs, Job."No.");
                if lRecJobHijos.FindSet() then
                    repeat
                        lRecJobHijos.Validate(lRecJobHijos."Global Dimension 1 Code", Rec."Dimension Value Code");
                    until lRecJobHijos.Next() = 0;
            end;
        end;
    end;

    local procedure UpgradeHistoricDimension(var Job: Record Job; FieldNumber: Integer)
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        JobLedgerEntries: Record "Job Ledger Entry";
        GLEntry: Record "G/L Entry";
        ResourceLedgerEntry: Record "Res. Ledger Entry";
        FAEntries: Record "FA Ledger Entry";
        FADepreciationBook: Record "FA Depreciation Book";
        ItemLedgerEntries: Record "Item Ledger Entry";
        ItemValueEntries: Record "Value Entry";
        CustomerLedgerEntries: Record "Cust. Ledger Entry";
        DetailCustomerLedgerEntries: Record "Detailed Cust. Ledg. Entry";
        VendorLedgerEntries: Record "Vendor Ledger Entry";
        DetailVendorLedgerEntries: Record "Detailed Vendor Ledg. Entry";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        PurchaseReceiptHeader: Record "Purch. Rcpt. Header";
        PurchaseReceiptLine: Record "Purch. Rcpt. Line";
        PurchInvHeader: Record "Sales Invoice Header";
        PurchInvLine: Record "Sales Invoice Line";
        PurchCrMemoHeader: Record "Sales Cr.Memo Header";
        PurchCrMemoLine: Record "Sales Cr.Memo Line";
        PostedCertificationHeader: Record ARBVRNPostedWorkCertifHeader;
        PostedCertificationLine: Record ARBVRNPostedWorkCertifLines;
        PostedProductionHeader: Record ARBVRNPostedProductionHeader;
        PostedProductionLine: Record ARBVRNPostedProductionLines;
        PostedTimeSheetHeader: Record ARBVRNPostVeronaTimeSheetHeade;
        PostedTimeSheetLine: Record ARBVRNPostVeronaTimeSheetLines;
        PostedTravelExpensesHeader: Record ARBVRNPostedTravelExpensesHdr;
        PostedTravelExpensesLine: Record ARBVRNPostedTravelExpensesLine;
        PostedOutputHeader: Record ARBVRNPostedOutDispatchNoteHDR;
        PostedOutputLine: Record ARBVRNPostOutputDispNoteLin;
        PostedTransferHeader: Record ARBVRNPostTransferExpIncomeHdr;
        PostedTransferLine: Record ARBVRNPostTransferExpIncomeLin;
        DimensionSet: Record "Dimension Set Entry";
        VeronaFunctions: Codeunit ARBVRNVeronaFunctions;
        DimensionMgt: Codeunit DimensionManagement;
        FromDate: Date;
        ToDate: Date;
        StartDate, StartDateN1, EndDateN1, EndDateTrimester : Date;
        FinishMsg: Label 'Entries of the current year have been updated with the new department code', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Les écritures de l''année en cours ont été mise à jour avec le nouveau code département"}]}';
    begin
        FromDate := DMY2Date(1, 1, Date2DMY(WorkDate(), 3));
        Todate := DMY2Date(31, 12, 9999);

        GeneralApplicationSetup.Get();
        StartDate := CALCDATE('<-CY>', WorkDate());
        EndDateTrimester := CALCDATE('<+4M>', CALCDATE('<-CY>', WorkDate()));
        StartDateN1 := CALCDATE('<-1Y>', CALCDATE('<-CY>', WorkDate()));
        EndDateN1 := CALCDATE('<-1Y>', CALCDATE('<CY>', WorkDate()));

        GeneralLedgerSetup.Get();
        JobLedgerEntries.Reset();
        JobLedgerEntries.SetCurrentKey("Job No.", "Posting Date");
        JobLedgerEntries.SetRange("Job No.", Job."No.");
        JobLedgerEntries.SetRange("Posting Date", FromDate, ToDate);
        if JobLedgerEntries.FindSet() then
            repeat
                if FieldNumber = 1 then
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", JobLedgerEntries."Dimension Set ID")
                else
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", JobLedgerEntries."Dimension Set ID");
                DimensionMgt.UpdateGlobalDimFromDimSetID(JobLedgerEntries."Dimension Set ID", JobLedgerEntries."Global Dimension 1 Code", JobLedgerEntries."Global Dimension 2 Code");
                JobLedgerEntries.Modify();
            until JobLedgerEntries.next() = 0;

        //Mise à jour des écritures projets sur l'année N-1 si période de situation et premier trimestre
        if GeneralApplicationSetup."Evaluation Period Situation" then
            if ((WorkDate() >= StartDate) and (WorkDate() < EndDateTrimester)) then begin
                JobLedgerEntries.SetCurrentKey("Job No.", "Posting Date");
                JobLedgerEntries.SetRange("Job No.", Job."No.");
                JobLedgerEntries.SetRange("Posting Date", StartDateN1, EndDateN1);
                if JobLedgerEntries.FindSet() then
                    repeat
                        if FieldNumber = 1 then
                            VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", JobLedgerEntries."Dimension Set ID")
                        else
                            VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", JobLedgerEntries."Dimension Set ID");
                        DimensionMgt.UpdateGlobalDimFromDimSetID(JobLedgerEntries."Dimension Set ID", JobLedgerEntries."Global Dimension 1 Code", JobLedgerEntries."Global Dimension 2 Code");
                        JobLedgerEntries.Modify();
                    until JobLedgerEntries.next() = 0;
            end;

        GLEntry.Reset();
        GLEntry.SetCurrentKey("Posting Date");
        GLEntry.SetRange("Posting Date", FromDate, ToDate);
        GLEntry.SetRange("Job No.", Job."No.");
        if GLEntry.FindSet() then
            repeat
                if FieldNumber = 1 then
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", GLEntry."Dimension Set ID")
                else
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", GLEntry."Dimension Set ID");
                DimensionMgt.UpdateGlobalDimFromDimSetID(GLEntry."Dimension Set ID", GLEntry."Global Dimension 1 Code", GLEntry."Global Dimension 2 Code");
                GLEntry.Modify();
            until GLEntry.Next() = 0;

        ResourceLedgerEntry.Reset();
        ResourceLedgerEntry.SetCurrentKey("Resource No.", "Posting Date");
        ResourceLedgerEntry.SetRange("Posting Date", FromDate, ToDate);
        ResourceLedgerEntry.SetRange("Job No.", Job."No.");
        if ResourceLedgerEntry.FindSet() then
            repeat
                if FieldNumber = 1 then
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", ResourceLedgerEntry."Dimension Set ID")
                else
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", ResourceLedgerEntry."Dimension Set ID");
                DimensionMgt.UpdateGlobalDimFromDimSetID(ResourceLedgerEntry."Dimension Set ID", ResourceLedgerEntry."Global Dimension 1 Code", ResourceLedgerEntry."Global Dimension 2 Code");
                ResourceLedgerEntry.Modify();
            until ResourceLedgerEntry.Next() = 0;

        FADepreciationBook.Reset();
        FADepreciationBook.SetRange(ARBVRNJobNo, Job."No.");
        if FADepreciationBook.FindSet() then
            repeat
                FAEntries.Reset();
                FAEntries.SetRange("FA No.", FADepreciationBook."FA No.");
                FAEntries.SetRange("Depreciation Book Code", FADepreciationBook."Depreciation Book Code");
                FAEntries.SetRange("Posting Date", FromDate, ToDate);
                if FAEntries.FindSet() then
                    repeat
                        DimensionSet.Reset();
                        DimensionSet.SetRange("Dimension Set ID", FAEntries."Dimension Set ID");
                        DimensionSet.SetRange("Dimension Code", VeronaFunctions.DevolverDimProyecto());
                        DimensionSet.SetRange("Dimension Value Code", Job."No.");
                        if not DimensionSet.IsEmpty() then begin
                            if FieldNumber = 1 then
                                VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", FAEntries."Dimension Set ID")
                            else
                                VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", FAEntries."Dimension Set ID");
                            DimensionMgt.UpdateGlobalDimFromDimSetID(FAEntries."Dimension Set ID", FAEntries."Global Dimension 1 Code", FAEntries."Global Dimension 2 Code");
                            FAEntries.Modify();
                        end;
                    until FAEntries.Next() = 0;
            until FADepreciationBook.Next() = 0;

        ItemLedgerEntries.Reset();
        ItemLedgerEntries.SetCurrentKey("Item No.", "Posting Date");
        ItemLedgerEntries.SetRange("Posting Date", FromDate, ToDate);
        ItemLedgerEntries.SetRange("Job No.", Job."No.");
        if ItemLedgerEntries.FindSet() then
            repeat
                if FieldNumber = 1 then
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", ItemLedgerEntries."Dimension Set ID")
                else
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", ItemLedgerEntries."Dimension Set ID");
                DimensionMgt.UpdateGlobalDimFromDimSetID(ItemLedgerEntries."Dimension Set ID", ItemLedgerEntries."Global Dimension 1 Code", ItemLedgerEntries."Global Dimension 2 Code");
                ItemLedgerEntries.Modify();
                ItemValueEntries.Reset();
                ItemValueEntries.SetCurrentKey("Item Ledger Entry No.");
                ItemValueEntries.SetRange("Item Ledger Entry No.", ItemLedgerEntries."Entry No.");
                if ItemValueEntries.FindSet() then
                    repeat
                        if FieldNumber = 1 then
                            VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", ItemValueEntries."Dimension Set ID")
                        else
                            VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", ItemValueEntries."Dimension Set ID");
                        DimensionMgt.UpdateGlobalDimFromDimSetID(ItemValueEntries."Dimension Set ID", ItemValueEntries."Global Dimension 1 Code", ItemValueEntries."Global Dimension 2 Code");
                    until ItemValueEntries.Next() = 0;
            until ItemLedgerEntries.Next() = 0;

        CustomerLedgerEntries.Reset();
        CustomerLedgerEntries.SetCurrentKey("Salesperson Code", "Posting Date");
        CustomerLedgerEntries.SetRange("Posting Date", FromDate, ToDate);
        CustomerLedgerEntries.setrange(ARBVRNJobNo, Job."No.");
        if CustomerLedgerEntries.FindSet() then
            repeat
                if FieldNumber = 1 then
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", CustomerLedgerEntries."Dimension Set ID")
                else
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", CustomerLedgerEntries."Dimension Set ID");
                DimensionMgt.UpdateGlobalDimFromDimSetID(CustomerLedgerEntries."Dimension Set ID", CustomerLedgerEntries."Global Dimension 1 Code", CustomerLedgerEntries."Global Dimension 2 Code");
                CustomerLedgerEntries.Modify();

                DetailCustomerLedgerEntries.Reset();
                DetailCustomerLedgerEntries.SetCurrentKey("Cust. Ledger Entry No.");
                DetailCustomerLedgerEntries.SetRange("Cust. Ledger Entry No.", CustomerLedgerEntries."Entry No.");
                if DetailCustomerLedgerEntries.FindSet() then
                    repeat
                        if FieldNumber = 1 then
                            DetailCustomerLedgerEntries."Initial Entry Global Dim. 1" := Job."Global Dimension 1 Code"
                        else
                            DetailCustomerLedgerEntries."Initial Entry Global Dim. 2" := Job."Global Dimension 2 Code";
                        DetailCustomerLedgerEntries.Modify();

                    until DetailCustomerLedgerEntries.Next() = 0;
            until CustomerLedgerEntries.Next() = 0;

        VendorLedgerEntries.Reset();
        VendorLedgerEntries.SetCurrentKey("Purchaser Code", "Posting Date");
        VendorLedgerEntries.SetRange("Posting Date", FromDate, ToDate);
        VendorLedgerEntries.setrange(ARBVRNJobNo, Job."No.");
        if VendorLedgerEntries.FindSet() then
            repeat
                if FieldNumber = 1 then
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", VendorLedgerEntries."Dimension Set ID")
                else
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", VendorLedgerEntries."Dimension Set ID");
                DimensionMgt.UpdateGlobalDimFromDimSetID(VendorLedgerEntries."Dimension Set ID", VendorLedgerEntries."Global Dimension 1 Code", VendorLedgerEntries."Global Dimension 2 Code");
                VendorLedgerEntries.Modify();

                DetailVendorLedgerEntries.Reset();
                DetailVendorLedgerEntries.SetCurrentKey("Vendor Ledger Entry No.");
                DetailVendorLedgerEntries.SetRange("Vendor Ledger Entry No.", VendorLedgerEntries."Entry No.");
                if DetailVendorLedgerEntries.FindSet() then
                    repeat
                        if FieldNumber = 1 then
                            DetailVendorLedgerEntries."Initial Entry Global Dim. 1" := Job."Global Dimension 1 Code"
                        else
                            DetailVendorLedgerEntries."Initial Entry Global Dim. 2" := Job."Global Dimension 2 Code";
                        DetailVendorLedgerEntries.Modify();
                    until DetailVendorLedgerEntries.Next() = 0;
            until VendorLedgerEntries.Next() = 0;
        SalesInvHeader.Reset();
        SalesInvHeader.SetRange("Posting Date", FromDate, ToDate);
        SalesInvHeader.SetRange(ARBVRNJobNo, Job."No.");
        if SalesInvHeader.FindSet() then
            repeat
                if FieldNumber = 1 then
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", SalesInvHeader."Dimension Set ID")
                else
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", SalesInvHeader."Dimension Set ID");
                DimensionMgt.UpdateGlobalDimFromDimSetID(SalesInvHeader."Dimension Set ID", SalesInvHeader."Shortcut Dimension 1 Code", SalesInvHeader."Shortcut Dimension 2 Code");
                SalesInvHeader.Modify();
            until SalesInvHeader.Next() = 0;
        SalesInvLine.Reset();
        SalesInvLine.SetRange("Posting Date", FromDate, ToDate);
        SalesInvLine.SetRange("Job No.", Job."No.");
        if SalesInvLine.FindSet() then
            repeat
                if FieldNumber = 1 then
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", SalesInvLine."Dimension Set ID")
                else
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", SalesInvLine."Dimension Set ID");
                DimensionMgt.UpdateGlobalDimFromDimSetID(SalesInvLine."Dimension Set ID", SalesInvLine."Shortcut Dimension 1 Code", SalesInvLine."Shortcut Dimension 2 Code");
                SalesInvLine.Modify();
            until SalesInvLine.Next() = 0;
        SalesCrmemoHeader.Reset();
        SalesCrmemoHeader.SetRange("Posting Date", FromDate, ToDate);
        SalesCrmemoHeader.SetRange(ARBVRNJobNo, Job."No.");
        if SalesCrmemoHeader.FindSet() then
            repeat
                if FieldNumber = 1 then
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", SalesCrmemoHeader."Dimension Set ID")
                else
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", SalesCrmemoHeader."Dimension Set ID");
                DimensionMgt.UpdateGlobalDimFromDimSetID(SalesCrmemoHeader."Dimension Set ID", SalesCrmemoHeader."Shortcut Dimension 1 Code", SalesCrmemoHeader."Shortcut Dimension 2 Code");
                SalesCrmemoHeader.Modify();
            until SalesCrmemoHeader.Next() = 0;
        SalesCrMemoLine.Reset();
        SalesCrMemoLine.SetRange("Posting Date", FromDate, ToDate);
        SalesCrMemoLine.SetRange("Job No.", Job."No.");
        if SalesCrMemoLine.FindSet() then
            repeat
                if FieldNumber = 1 then
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", SalesCrMemoLine."Dimension Set ID")
                else
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", SalesCrMemoLine."Dimension Set ID");
                DimensionMgt.UpdateGlobalDimFromDimSetID(SalesCrMemoLine."Dimension Set ID", SalesCrMemoLine."Shortcut Dimension 1 Code", SalesCrMemoLine."Shortcut Dimension 2 Code");
                SalesCrMemoLine.Modify();
            until SalesCrMemoLine.Next() = 0;
        PurchaseReceiptHeader.Reset();
        PurchaseReceiptHeader.SetRange("Posting Date", FromDate, ToDate);
        PurchaseReceiptHeader.SetRange(ARBVRNJobNo, Job."No.");
        if PurchaseReceiptHeader.FindSet() then
            repeat
                if FieldNumber = 1 then
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", PurchaseReceiptHeader."Dimension Set ID")
                else
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", PurchaseReceiptHeader."Dimension Set ID");
                DimensionMgt.UpdateGlobalDimFromDimSetID(PurchaseReceiptHeader."Dimension Set ID", PurchaseReceiptHeader."Shortcut Dimension 1 Code", PurchaseReceiptHeader."Shortcut Dimension 2 Code");
                PurchaseReceiptHeader.Modify();
            until PurchaseReceiptHeader.Next() = 0;
        PurchaseReceiptLine.Reset();
        PurchaseReceiptLine.SetRange("Posting Date", FromDate, ToDate);
        PurchaseReceiptLine.SetRange("Job No.", Job."No.");
        if PurchaseReceiptLine.FindSet() then
            repeat
                if FieldNumber = 1 then
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", PurchaseReceiptLine."Dimension Set ID")
                else
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", PurchaseReceiptLine."Dimension Set ID");
                DimensionMgt.UpdateGlobalDimFromDimSetID(PurchaseReceiptLine."Dimension Set ID", PurchaseReceiptLine."Shortcut Dimension 1 Code", PurchaseReceiptLine."Shortcut Dimension 2 Code");
                PurchaseReceiptLine.Modify();
            until PurchaseReceiptLine.Next() = 0;
        PurchInvHeader.Reset();
        PurchInvHeader.SetRange("Posting Date", FromDate, ToDate);
        PurchInvHeader.SetRange(ARBVRNJobNo, Job."No.");
        if PurchInvHeader.FindSet() then
            repeat
                if FieldNumber = 1 then
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", PurchInvHeader."Dimension Set ID")
                else
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", PurchInvHeader."Dimension Set ID");
                DimensionMgt.UpdateGlobalDimFromDimSetID(PurchInvHeader."Dimension Set ID", PurchInvHeader."Shortcut Dimension 1 Code", PurchInvHeader."Shortcut Dimension 2 Code");
                PurchInvHeader.Modify();
            until PurchInvHeader.Next() = 0;
        PurchInvLine.Reset();
        PurchInvLine.SetRange("Posting Date", FromDate, ToDate);
        PurchInvLine.SetRange("Job No.", Job."No.");
        if PurchInvLine.FindSet() then
            repeat
                if FieldNumber = 1 then
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", PurchInvLine."Dimension Set ID")
                else
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", PurchInvLine."Dimension Set ID");
                DimensionMgt.UpdateGlobalDimFromDimSetID(PurchInvLine."Dimension Set ID", PurchInvLine."Shortcut Dimension 1 Code", PurchInvLine."Shortcut Dimension 2 Code");
                PurchInvLine.Modify();
            until PurchInvLine.Next() = 0;
        PurchCrMemoHeader.Reset();
        PurchCrMemoHeader.SetRange("Posting Date", FromDate, ToDate);
        PurchCrMemoHeader.SetRange(ARBVRNJobNo, Job."No.");
        if PurchCrMemoHeader.FindSet() then
            repeat
                if FieldNumber = 1 then
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", PurchCrMemoHeader."Dimension Set ID")
                else
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", PurchCrMemoHeader."Dimension Set ID");
                DimensionMgt.UpdateGlobalDimFromDimSetID(PurchCrMemoHeader."Dimension Set ID", PurchCrMemoHeader."Shortcut Dimension 1 Code", PurchCrMemoHeader."Shortcut Dimension 2 Code");
                PurchCrMemoHeader.Modify();
            until PurchCrMemoHeader.Next() = 0;
        PurchCrMemoLine.Reset();
        PurchCrMemoLine.SetRange("Posting Date", FromDate, ToDate);
        PurchCrMemoLine.SetRange("Job No.", Job."No.");
        if PurchCrMemoLine.FindSet() then
            repeat
                if FieldNumber = 1 then
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", PurchCrMemoLine."Dimension Set ID")
                else
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", PurchCrMemoLine."Dimension Set ID");
                DimensionMgt.UpdateGlobalDimFromDimSetID(PurchCrMemoLine."Dimension Set ID", PurchCrMemoLine."Shortcut Dimension 1 Code", PurchCrMemoLine."Shortcut Dimension 2 Code");
                PurchCrMemoLine.Modify();
            until PurchCrMemoLine.Next() = 0;

        PostedCertificationHeader.Reset();
        PostedCertificationHeader.SetRange(ARBVRNPostingDate, FromDate, ToDate);
        PostedCertificationHeader.SetRange(ARBVRNJobNo, Job."No.");
        if PostedCertificationHeader.FindSet() then
            repeat
                if FieldNumber = 1 then
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", PostedCertificationHeader.ARBVRNDimensionSetID)
                else
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", PostedCertificationHeader.ARBVRNDimensionSetID);
                DimensionMgt.UpdateGlobalDimFromDimSetID(PostedCertificationHeader.ARBVRNDimensionSetID, PostedCertificationHeader.ARBVRNShortcutDimension1Code, PostedCertificationHeader.ARBVRNShortcutDimension2Code);
                PostedCertificationHeader.Modify();
            until PostedCertificationHeader.Next() = 0;
        PostedCertificationLine.Reset();
        PostedCertificationHeader.Reset();
        PostedCertificationLine.SetRange(ARBVRNJobNo, Job."No.");
        if PostedCertificationLine.FindSet() then
            repeat
                PostedCertificationHeader.Get(PostedCertificationLine.ARBVRNDocumentNo);
                if (PostedCertificationHeader.ARBVRNPostingDAte >= FromDate) and (PostedCertificationHeader.ARBVRNPostingDAte <= ToDate) then begin
                    if FieldNumber = 1 then
                        VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", PostedCertificationLine.ARBVRNDimensionSetID)
                    else
                        VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", PostedCertificationLine.ARBVRNDimensionSetID);
                    DimensionMgt.UpdateGlobalDimFromDimSetID(PostedCertificationLine.ARBVRNDimensionSetID, PostedCertificationLine.ARBVRNShortcutDimension1Code, PostedCertificationLine.ARBVRNShortcutDimension2Code);
                    PostedCertificationLine.Modify();
                end;
            until PostedCertificationLine.Next() = 0;

        PostedProductionHeader.Reset();
        PostedProductionHeader.SetRange(ARBVRNPostingDate, FromDate, ToDate);
        PostedProductionHeader.SetRange(ARBVRNJobNo, Job."No.");
        if PostedProductionHeader.FindSet() then
            repeat
                if FieldNumber = 1 then
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", PostedProductionHeader.ARBVRNDimensionSetID)
                else
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", PostedProductionHeader.ARBVRNDimensionSetID);
                DimensionMgt.UpdateGlobalDimFromDimSetID(PostedProductionHeader.ARBVRNDimensionSetID, PostedProductionHeader.ARBVRNShortcutDimension1Code, PostedProductionHeader.ARBVRNShortcutDimension2Code);
                PostedProductionHeader.Modify();
            until PostedProductionHeader.Next() = 0;
        PostedProductionLine.Reset();
        PostedProductionHeader.Reset();
        PostedProductionLine.SetRange(ARBVRNJobNo, Job."No.");
        if PostedProductionLine.FindSet() then
            repeat
                PostedProductionHeader.Get(PostedProductionLine.ARBVRNDocumentNo);
                if (PostedProductionHeader.ARBVRNPostingDAte >= FromDate) and (PostedProductionHeader.ARBVRNPostingDAte <= ToDate) then begin
                    if FieldNumber = 1 then
                        VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", PostedProductionLine.ARBVRNDimensionSetID)
                    else
                        VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", PostedProductionLine.ARBVRNDimensionSetID);
                    DimensionMgt.UpdateGlobalDimFromDimSetID(PostedProductionLine.ARBVRNDimensionSetID, PostedProductionLine.ARBVRNShortcutDimension1Code, PostedProductionLine.ARBVRNShortcutDimension2Code);
                    PostedProductionLine.Modify();
                end;
            until PostedProductionLine.Next() = 0;

        PostedTimeSheetHeader.Reset();
        PostedTimeSheetHeader.SetRange(ARBVRNTimeSheetType, PostedTimeSheetHeader.ARBVRNTimeSheetType::"By job");
        PostedTimeSheetHeader.SetRange(ARBVRNPostingDate, FromDate, ToDate);
        PostedTimeSheetHeader.SetRange(ARBVRNResourceNoJobNo, Job."No.");
        if PostedTimeSheetHeader.FindSet() then
            repeat
                if FieldNumber = 1 then
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", PostedTimeSheetHeader.ARBVRNDimensionSetID)
                else
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", PostedTimeSheetHeader.ARBVRNDimensionSetID);
                DimensionMgt.UpdateGlobalDimFromDimSetID(PostedTimeSheetHeader.ARBVRNDimensionSetID, PostedTimeSheetHeader.ARBVRNShortcutDimension1Code, PostedTimeSheetHeader.ARBVRNShortcutDimension2Code);
                PostedTimeSheetHeader.Modify();
            until PostedTimeSheetHeader.Next() = 0;
        PostedTimeSheetLine.Reset();
        PostedTimeSheetHeader.Reset();
        PostedTimeSheetLine.SetRange(ARBVRNJobNo, Job."No.");
        if PostedTimeSheetLine.FindSet() then
            repeat
                PostedTimeSheetHeader.Get(PostedTimeSheetLine.ARBVRNDocumentNo);
                if (PostedTimeSheetHeader.ARBVRNPostingDAte >= FromDate) and (PostedTimeSheetHeader.ARBVRNPostingDAte <= ToDate) then begin
                    if FieldNumber = 1 then
                        VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", PostedTimeSheetLine.ARBVRNDimensionSetID)
                    else
                        VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", PostedTimeSheetLine.ARBVRNDimensionSetID);
                    DimensionMgt.UpdateGlobalDimFromDimSetID(PostedTimeSheetLine.ARBVRNDimensionSetID, PostedTimeSheetLine.ARBVRNShortcutDimension1Code, PostedTimeSheetLine.ARBVRNShortcutDimension2Code);
                    PostedTimeSheetLine.Modify();
                end;
            until PostedTimeSheetLine.Next() = 0;
        PostedTransferLine.Reset();
        PostedTransferHeader.Reset();
        PostedTransferLine.SetRange(ARBVRNOriginalJobNo, Job."No.");
        if PostedTransferLine.FindSet() then
            repeat
                PostedTransferHeader.Get(PostedTransferLine.ARBVRNDocumentType, PostedTransferLine.ARBVRNDocumentNo);
                if (PostedTransferHeader.ARBVRNPostingDAte >= FromDate) and (PostedTransferHeader.ARBVRNPostingDAte <= ToDate) then begin
                    if FieldNumber = 1 then begin
                        VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", PostedTransferLine.ARBVRNDimensionSetID);
                        PostedTransferLine.ARBVRNOriginalDepartament := Job."Global Dimension 1 Code";
                    end else begin
                        VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", PostedTransferLine.ARBVRNDimensionSetID);
                        PostedTransferLine.ARBVRNOriginalDepartament := Job."Global Dimension 2 Code";
                    end;
                    PostedTransferLine.Modify();
                end;
            until PostedTransferLine.Next() = 0;

        PostedTransferLine.Reset();
        PostedTransferHeader.Reset();
        PostedTransferLine.SetRange(ARBVRNDestinationJobNo, Job."No.");
        if PostedTransferLine.FindSet() then
            repeat
                PostedTransferHeader.Get(PostedTransferLine.ARBVRNDocumentType, PostedTransferLine.ARBVRNDocumentNo);
                if (PostedTransferHeader.ARBVRNPostingDAte >= FromDate) and (PostedTransferHeader.ARBVRNPostingDAte <= ToDate) then begin
                    if FieldNumber = 1 then begin
                        VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", PostedTransferLine.ARBVRNDimensionSetID2);
                        PostedTransferLine.ARBVRNDestinationJobNo := Job."Global Dimension 1 Code";
                    end else begin
                        VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", PostedTransferLine.ARBVRNDimensionSetID2);
                        PostedTransferLine.ARBVRNDestinationJobNo := Job."Global Dimension 2 Code";
                    end;
                    PostedTransferLine.Modify();
                end;
            until PostedTransferLine.Next() = 0;

        PostedOutputHeader.Reset();
        PostedOutputHeader.SetRange(ARBVRNPostingDate, FromDate, ToDate);
        PostedOutputHeader.SetRange(ARBVRNJobNo, Job."No.");
        if PostedOutputHeader.FindSet() then
            repeat
                if FieldNumber = 1 then
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", PostedOutputHeader.ARBVRNDimensionSetID)
                else
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", PostedOutputHeader.ARBVRNDimensionSetID);
                DimensionMgt.UpdateGlobalDimFromDimSetID(PostedOutputHeader.ARBVRNDimensionSetID, PostedOutputHeader.ARBVRNShortcutDimension1Code, PostedOutputHeader.ARBVRNShortcutDimension2Code);
                PostedOutputHeader.Modify();
            until PostedOutputHeader.Next() = 0;
        PostedOutputLine.Reset();
        PostedOutputHeader.Reset();
        PostedOutputLine.SetRange(ARBVRNJobNo, Job."No.");
        if PostedOutputLine.FindSet() then
            repeat
                PostedOutputHeader.Get(PostedOutputLine.ARBVRNDocumentNo);
                if (PostedOutputHeader.ARBVRNPostingDAte >= FromDate) and (PostedOutputHeader.ARBVRNPostingDAte <= ToDate) then begin
                    if FieldNumber = 1 then
                        VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", PostedOutputLine.ARBVRNDimensionSetID)
                    else
                        VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", PostedOutputLine.ARBVRNDimensionSetID);
                    DimensionMgt.UpdateGlobalDimFromDimSetID(PostedOutputLine.ARBVRNDimensionSetID, PostedOutputLine.ARBVRNShortcutDimension1Code, PostedOutputLine.ARBVRNShortcutDimension2Code);
                    PostedOutputLine.Modify();
                end;
            until PostedOutputLine.Next() = 0;

        PostedTravelExpensesHeader.Reset();
        PostedTravelExpensesHeader.SetRange(ARBVRNPostingDate, FromDate, ToDate);
        PostedTravelExpensesHeader.SetRange(ARBVRNJobNo, Job."No.");
        if PostedTravelExpensesHeader.FindSet() then
            repeat
                if FieldNumber = 1 then
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", PostedTravelExpensesHeader.ARBVRNDimensionSetID)
                else
                    VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", PostedTravelExpensesHeader.ARBVRNDimensionSetID);
                DimensionMgt.UpdateGlobalDimFromDimSetID(PostedTravelExpensesHeader.ARBVRNDimensionSetID, PostedTravelExpensesHeader.ARBVRNShortcutDimension1Code, PostedTravelExpensesHeader.ARBVRNShortcutDimension2Code);
                PostedTravelExpensesHeader.Modify();
            until PostedTravelExpensesHeader.Next() = 0;
        PostedTravelExpensesLine.Reset();
        PostedTravelExpensesHeader.Reset();
        PostedTravelExpensesLine.SetRange(ARBVRNJobNo, Job."No.");
        if PostedTravelExpensesLine.FindSet() then
            repeat
                PostedTravelExpensesHeader.Get(PostedTravelExpensesLine.ARBVRNDocumentNo);
                if (PostedTravelExpensesHeader.ARBVRNPostingDAte >= FromDate) and (PostedTravelExpensesHeader.ARBVRNPostingDAte <= ToDate) then begin
                    if FieldNumber = 1 then
                        VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 1 Code", PostedTravelExpensesLine.ARBVRNDimensionSetID)
                    else
                        VeronaFunctions.UpdateDimSet(VeronaFunctions.DevolverDimDpto(), Job."Global Dimension 2 Code", PostedTravelExpensesLine.ARBVRNDimensionSetID);
                    DimensionMgt.UpdateGlobalDimFromDimSetID(PostedTravelExpensesLine.ARBVRNDimensionSetID, PostedTravelExpensesLine.ARBVRNShortcutDimension1Code, PostedTravelExpensesLine.ARBVRNShortcutDimension2Code);
                    PostedTravelExpensesLine.Modify();
                end;
            until PostedTravelExpensesLine.Next() = 0;

        if job.ARBVRNJobMatrixItBelongs = '' then
            Message(FinishMsg);
    end;
}