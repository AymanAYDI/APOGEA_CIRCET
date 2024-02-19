codeunit 50005 "Purchase Mgmt"
{
    [EventSubscriber(ObjectType::Table, Database::"Purch. Rcpt. Line", 'OnBeforeInsertInvLineFromRcptLine', '', false, false)]
    local procedure OnBeforeInsertInvLineFromRcptLine(var PurchRcptLine: Record "Purch. Rcpt. Line"; var PurchLine: Record "Purchase Line"; PurchOrderLine: Record "Purchase Line"; var IsHandled: Boolean);
    begin
        UpdateDimensionValueProject(PurchLine);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterUpdateDirectUnitCost', '', false, false)]
    local procedure OnAfterUpdateDirectUnitCost(var PurchLine: Record "Purchase Line"; xPurchLine: Record "Purchase Line"; CalledByFieldNo: Integer; CurrFieldNo: Integer);
    begin
        GeneralApplicationSetup.Get();
        if (NOT GeneralApplicationSetup."Init. Item Direct Unit Cost") then
            EXIT;

        if PurchLine."Document Type" <> PurchLine."Document Type"::Order then
            EXIT;

        // Si le champ est mis à jour via un import
        if (CurrFieldNo = 0) then
            EXIT;

        case PurchLine.Type of
            PurchLine.Type::Item:
                PurchLine.VALIDATE("Direct Unit Cost", 0);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure OnBeforePostPurchaseDoc(var Sender: Codeunit "Purch.-Post"; var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean; CommitIsSupressed: Boolean; var HideProgressWindow: Boolean);
    var
        PurchaseLine: Record "Purchase Line";
        NotRightsToReceive_Err: Label 'You are not allowed to receive lines with negative amounts. Please contact the staff in charge of purchase invoicing in the accounting department.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous n''êtes pas autorisé à réceptionner des lignes dont le montant est négatif. Veuillez vous rapprocher du personnel en charge de la facturation achat au service comptabilité."}]}';
    begin
        if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) and (PurchaseHeader.Receive) then begin
            PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
            PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
            PurchaseLine.SetFilter("Qty. to Receive (Base)", '<>0');
            if not CIRUserManagement.CheckRightUserByGroup(UserGroup.FieldNo("Invoice Purchase Rights")) then
                if PurchaseLine.FindSet(false, false) then
                    repeat
                        if PurchaseLine."Line Amount" < 0 then
                            Error(NotRightsToReceive_Err);
                    until PurchaseLine.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeConfirmPost', '', false, false)]
    local procedure OnBeforeConfirmPost(var PurchaseHeader: Record "Purchase Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer);
    begin
        CheckPostPurchaseHeader(PurchaseHeader, HideDialog, IsHandled);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post + Print", 'OnBeforeConfirmPost', '', false, false)]
    local procedure OnBeforeConfirmPostPrint(var PurchaseHeader: Record "Purchase Header"; var HideDialog: Boolean; var IsHandled: Boolean; var DefaultOption: Integer);
    begin
        CheckPostPurchaseHeader(PurchaseHeader, HideDialog, IsHandled);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeManualReleasePurchaseDoc', '', false, false)]
    local procedure OnBeforeManualReleasePurchaseDoc_CheckJobNo(var PurchaseHeader: Record "Purchase Header"; PreviewMode: Boolean)
    begin
        CheckJobOnPurchase(PurchaseHeader);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnValidateBuyFromVendorNoOnAfterUpdateBuyFromCont', '', false, false)]
    local procedure OnValidateBuyFromVendorNoOnAfterUpdateBuyFromCont(var PurchaseHeader: Record "Purchase Header"; xPurchaseHeader: Record "Purchase Header")
    begin
        OnValidateBuyFromVendorNoOnAfterUpdateBuyFromContMeth(PurchaseHeader, xPurchaseHeader);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterInitRecord', '', false, false)]
    local procedure OnAfterInitRecord(var PurchHeader: Record "Purchase Header")
    begin
        OnAfterInitRecordMeth(PurchHeader);
        updateAddressFromPurchaser(PurchHeader);
    end;

    //L'indicateur FNP devrait être décoché automatiquement lors de la réception partielle ou totale de la ligne (KO)
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnPostUpdateOrderLineOnPurchHeaderReceive', '', false, false)]
    local procedure OnPostUpdateOrderLineOnPurchHeaderReceive(var TempPurchLine: Record "Purchase Line"; PurchRcptHeader: Record "Purch. Rcpt. Header");
    begin
        IF TempPurchLine.Accrue THEN
            TempPurchLine.Accrue := TempPurchLine."Qty. to Receive (Base)" = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnValidateQuantityOnBeforeDropShptCheck', '', false, false)]
    local procedure OnValidateQuantityOnBeforeDropShptCheck(var PurchaseLine: Record "Purchase Line"; xPurchaseLine: Record "Purchase Line"; CallingFieldNo: Integer; var IsHandled: Boolean);
    begin
        CheckDimOnPurchaseLine(PurchaseLine);
    end;

    local procedure CheckDimOnPurchaseLine(pPurchaseLine: Record "Purchase Line")
    var
        ShortcutDimCode: array[8] of Code[20];
        lMessageErr: Label 'The current line must carry a dimension project and a dimension department. Please correct your line before entering the quantity. The correction must be made at the level of the item/fixed asset/general account sheet by adding the missing dimension or on the line by adding a project number.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"La ligne actuelle doit porter un axe projet et un axe département. Veuillez corriger votre ligne avant d''entrer la quantité. La correction doit être réalisée au niveau de la fiche article /immobilisation/compte général en ajoutant les axes manquants ou sur la ligne en ajoutant un N° projet."}]}';
    begin
        if pPurchaseLine.Type = pPurchaseLine.Type::" " then
            exit;

        if pPurchaseLine.Quantity = 0 then
            exit;

        if (pPurchaseLine."Shortcut Dimension 1 Code" = '') then
            Error(lMessageErr)
        else begin
            pPurchaseLine.ShowShortcutDimCode(ShortcutDimCode);
            if ShortcutDimCode[4] = '' then
                Error(lMessageErr);
        end;
    end;

    procedure Receipt(var pPurchaseHeader: Record "Purchase Header"; PostingDate: Date)
    var
        PurchaseHeader: Record "Purchase Header";
        PurchPost: Codeunit "Purch.-Post";
    begin
        //Ajout d'une fonctionnalité permettant la spécification d'une date de réception au niveau du formulaire de préparation des réceptions.

        // Initialisation de la date de comptabilisation de la réception
        pPurchaseHeader."Posting Date" := postingDate;
        pPurchaseHeader.MODIFY();
        PurchaseHeader.COPY(pPurchaseHeader);
        PurchaseHeader.Receive := TRUE;
        PurchaseHeader.Invoice := FALSE;
        PurchPost.RUN(PurchaseHeader);
        pPurchaseHeader := PurchaseHeader;
    end;

    procedure ReceiptAndPrint(var pPurchaseHeader: Record "Purchase Header"; PostingDate: Date)
    var
        PurchaseHeader: Record "Purchase Header";
        PurchPost: Codeunit "Purch.-Post";
        PurchPostPrint: Codeunit "Purch.-Post + Print";
    begin
        //Ajout d'une fonctionnalité permettant la spécification d'une date de réception au niveau du formulaire de préparation des réceptions.

        // Initialisation de la date de comptabilisation de la réception
        pPurchaseHeader."Posting Date" := postingDate;
        pPurchaseHeader.MODIFY();
        PurchaseHeader.COPY(pPurchaseHeader);
        PurchaseHeader.Receive := TRUE;
        PurchaseHeader.Invoice := FALSE;
        PurchPost.RUN(PurchaseHeader);
        PurchPostPrint.GetReport(PurchaseHeader);
        pPurchaseHeader := PurchaseHeader;
    end;

    procedure UpdateDirectCustPayment(PurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
        PurchaseLine.SETRANGE("Type", PurchaseLine.Type::"Item");
        IF NOT PurchaseLine.ISEMPTY() THEN
            PurchaseLine.ModifyAll("Accrue", PurchaseHeader."Direct Customer Payment");
    end;

    procedure ExistReceptLine(PurchaseHeader: Record "Purchase Header"): Boolean
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
        PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
        PurchaseLine.SETFILTER("Qty. Received (Base)", '<>0');
        EXIT(NOT PurchaseLine.ISEMPTY());
    end;

    local procedure CheckJobOnPurchase(PurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
        CannotReleasePurchOrder_Err: Label 'You can''t release the order if there is no Job No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous ne pouvez pas lancer la commande s''il n''y a pas de n° de projet"}]}';
    begin
        //Add control on "Job No." on Order
        GeneralApplicationSetup.Get();
        if GeneralApplicationSetup."Control Over Company" then
            IF (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Order) then begin
                PurchaseLine.SETRANGE("Document Type", PurchaseHeader."Document Type");
                PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
                PurchaseLine.SETRANGE(Type, PurchaseLine.Type::"Fixed Asset");
                PurchaseLine.SETFILTER(Quantity, '>0');
                if (PurchaseLine.IsEmpty() AND (PurchaseHeader.ARBVRNJobNo = '')) then
                    Error(CannotReleasePurchOrder_Err);
            end;
    end;

    local procedure ConfirmPost(var PurchaseHeader: Record "Purchase Header"; var IsHandled: Boolean): Boolean
    var
        ConfirmManagement: Codeunit "Confirm Management";
        Selection: Integer;
        ReceiveInvoiceQst: Label 'Receive &and Invoice', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Réceptionner et facturer"}]}';
        PostConfirmQst: Label 'Do you want to post the %1?', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Souhaitez vous valider le %1 ?"}]}';
    begin
        Selection := 1;
        case PurchaseHeader."Document Type" of
            PurchaseHeader."Document Type"::Order:
                begin
                    Selection := StrMenu(ReceiveInvoiceQst, Selection);
                    if Selection = 0 then begin
                        IsHandled := true;
                        exit(false);
                    end;
                    PurchaseHeader.Receive := Selection in [1];
                    PurchaseHeader.Invoice := Selection in [1];
                end;
            else
                if not ConfirmManagement.GetResponseOrDefault(StrSubstNo(PostConfirmQst, LowerCase(Format(PurchaseHeader."Document Type"))), true) then begin
                    IsHandled := true;
                    exit(false);
                end;
        end;
        PurchaseHeader."Print Posted Documents" := false;
        exit(true);
    end;

    local procedure UpdateDimensionValueProject(var pPurchaseLine: Record "Purchase Line")
    var
        lJob: Record Job;
    begin
        //On ré-affecte les axes du projet dans le cas où ils ont changé entre la réception et le projet
        if lJob.Get(pPurchaseLine."Job No.") then begin
            pPurchaseLine.Validate("Shortcut Dimension 1 Code", lJob."Global Dimension 1 Code");
            pPurchaseLine.Validate("Shortcut Dimension 2 Code", lJob."Global Dimension 2 Code");
        end;
    end;

    internal procedure CheckPostPurchaseHeader(var PurchaseHeader: Record "Purchase Header"; var HideDialog: Boolean; var IsHandled: Boolean)
    begin
        //Add control on "Job No." on Order
        CheckJobOnPurchase(PurchaseHeader);

        IF PurchaseHeader."Direct Customer Payment" THEN BEGIN
            //Vérification que l'utilisateur a les droits d'accès pour valider le paiement direct
            IF NOT CirUserManagement.CheckRightUserByGroup(UserGroup.FieldNo("Accounts receivable")) THEN
                ERROR(NotAuthorizedLbl);

            if NOT HideDialog THEN
                if not ConfirmPost(PurchaseHeader, IsHandled) then
                    exit;

            HideDialog := true; //On masque l'écran standard
        end;
    end;

    internal procedure updateAddressFromPurchaser(var PurchHeader: Record "Purchase Header")
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        UserSetup: Record "User Setup";
    begin
        if PurchHeader."Purchaser Code" <> '' then begin
            if UserSetup.Get(UserId()) then;
            if PurchHeader."Document Type" = PurchHeader."Document Type"::order then begin
                SalespersonPurchaser.SetRange(Code, PurchHeader."Purchaser Code");
                SalespersonPurchaser.SetRange(Purchaser, true);
                if SalespersonPurchaser.FindFirst() then begin
                    PurchHeader."Purchaser Code" := SalespersonPurchaser.Code;
                    PurchHeader."Tel. Buyer" := SalespersonPurchaser."Phone No.";
                    PurchHeader."Fax Buyer" := SalespersonPurchaser."Fax No.";
                    PurchHeader."E-mail Buyer" := SalespersonPurchaser."E-Mail";
                    PurchHeader."E-mail Service Buyer" := SalespersonPurchaser."E-Mail Service";

                    if SalespersonPurchaser."Ship-to Customer" = '' then begin
                        PurchHeader.Validate("Sell-to Customer No.", '');
                        PurchHeader."Ship-to Code" := '';
                        PurchHeader."Ship-to Name" := SalespersonPurchaser."Ship-to Name";
                        PurchHeader."Ship-to Address" := SalespersonPurchaser."Ship-to Address";
                        PurchHeader."Ship-to Address 2" := SalespersonPurchaser."Ship-to Address 2";
                        PurchHeader."Ship-to Post Code" := SalespersonPurchaser."Ship-to Post Code";
                        PurchHeader."Ship-to City" := SalespersonPurchaser."Ship-to City";
                        PurchHeader."Ship-to Contact" := SalespersonPurchaser."Ship-to Contact";

                        if PurchHeader."Ship-to Name" = '' then
                            PurchHeader.UpdateShipToAddress();
                    end else begin
                        PurchHeader."Sell-to Customer No." := SalespersonPurchaser."Ship-to Customer";
                        PurchHeader.Validate("Ship-to Code", SalespersonPurchaser."Ship-to Customer Adress");
                    end;
                end
                else begin
                    PurchHeader."Purchaser Code" := '';
                    PurchHeader."Tel. Buyer" := '';
                    PurchHeader."Fax Buyer" := '';
                    PurchHeader."E-mail Buyer" := '';
                    PurchHeader."E-mail Service Buyer" := '';
                end;
            end;
        end;
    end;

    procedure OnValidateBuyFromVendorNoOnAfterUpdateBuyFromContMeth(var PurchaseHeader: Record "Purchase Header"; xPurchaseHeader: Record "Purchase Header")
    begin
        PurchaseHeader."Posting Description" := PurchaseHeader."Buy-from Vendor Name";
    end;

    procedure OnAfterInitRecordMeth(var PurchHeader: Record "Purchase Header")
    begin
        PurchHeader."Posting Description" := PurchHeader."Buy-from Vendor Name";
    end;

    var
        GeneralApplicationSetup: Record "General Application Setup";
        UserGroup: Record "User Group";
        CirUserManagement: Codeunit "CIR User Management";
        NotAuthorizedLbl: Label 'You are not authorized to receive an order in direct customer payment, please contact the customer accounting department', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous n''êtes pas autorisé à réceptionner une commande en paiement direct client, merci de vous rapprocher de la comptabilité client"}]}';
}