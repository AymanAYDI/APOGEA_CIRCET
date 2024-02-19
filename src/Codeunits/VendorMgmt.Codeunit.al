codeunit 50010 "Vendor Mgmt"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Vendor Mgt.", 'OnAfterSetFilterForExternalDocNo', '', false, false)]
    local procedure OnAfterSetFilterForExternalDocNo(var VendorLedgerEntry: Record "Vendor Ledger Entry"; DocumentDate: Date);
    begin
        FilterPeriodOnDocumentDate(VendorLedgerEntry, DocumentDate);
    end;

    internal procedure CheckBlockedVendOnOrders(Vendor: Record Vendor; Transaction: Boolean)
    begin
        IF Vendor.Blocked = Vendor.Blocked::Order THEN
            VendBlockedErrorMessage(Vendor, Transaction);
    end;

    local procedure VendBlockedErrorMessage(Vendor: Record Vendor; Transaction: Boolean)
    var
        Action: Text[30];
        Post_Lbl: Label 'Post', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Valider"}]}';
        Create_Lbl: Label 'Create', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Créer"}]}';
        VendorBlockedOnOrder_Err: Label 'You cannot %1 this type of document when Vendor %2 is blocked with type %3', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous ne pouvez pas %1 ce type de document lorsque le fournisseur %2 est bloqué avec le type %3"}]}';
    begin
        IF Transaction THEN
            Action := Post_Lbl
        ELSE
            Action := Create_Lbl;
        ERROR(VendorBlockedOnOrder_Err, Action, Vendor."No.", Vendor.Blocked);
    end;

    /// <summary>
    /// ManagEditableFieldsHiveoOnPageVendor
    /// </summary>
    /// <param name="VAR editableActive">Boolean.</param>
    /// <param name="VAR editableInvitation">Boolean.</param>
    internal procedure ManagEditableFieldsHiveoOnPageVendor(Vendor: Record Vendor; VAR editableActive: Boolean; VAR editableInvitation: Boolean);
    BEGIN
        editableActive := (Vendor."Invitation Hiveo" = Vendor."Invitation Hiveo"::Treated);

        // Evaluation de l'état d'édition du statut d'invitation Hiveo
        editableInvitation := (Vendor."Invitation Hiveo" <> Vendor."Invitation Hiveo"::Treated);
    END;

    internal procedure NotSelectInvitTreated(Vendor: Record Vendor);
    VAR
        ERR_SELECT_INVIT_TREATED_Err: Label 'Status %1 for invitation does not selected manually', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le statut %1 de l''invitation ne peut pas être sélectionné manuellement."}]}';
    BEGIN
        IF (Vendor."Invitation Hiveo" = Vendor."Invitation Hiveo"::Treated) THEN
            ERROR(ERR_SELECT_INVIT_TREATED_Err, Vendor."Invitation Hiveo"::Treated);
    END;

    //Fonction pour filtrer sur les documents par numéro de doc externe par année.
    local procedure FilterPeriodOnDocumentDate(var VendLedgEntry: Record "Vendor Ledger Entry"; DocumentDate: Date)
    var
        DatGBegin, DatGEnd : Date;
        TxtGDate: Text;
    begin
        TxtGDate := '0101' + FORMAT(DATE2DMY(DocumentDate, 3));
        EVALUATE(DatGBegin, TxtGDate);
        TxtGDate := '3112' + FORMAT(DATE2DMY(DocumentDate, 3));
        EVALUATE(DatGEnd, TxtGDate);
        VendLedgEntry.SETRANGE("Document Date", DatGBegin, DatGEnd);
    end;
}