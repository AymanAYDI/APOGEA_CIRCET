codeunit 50006 "SalesPost Single Instance Mgmt"
{
    EventSubscriberInstance = StaticAutomatic;
    SingleInstance = true;
    Subtype = Normal;

    var
        ValidateSalesDocument: Page "Validate Sales Document";
        BooGRunAfterPost: boolean;
        TxtGfichierPVRecette: Text[300];
        TxtGdescPVRecette: Text[50];

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostSalesDoc', '', false, false)]
    local procedure OnBeforePostSalesDoc(var Sender: Codeunit "Sales-Post"; var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; var HideProgressWindow: Boolean);
    var
        Bool: Boolean;
    begin
        if NOT DoNotRunFunctionOnBeforePostSalesDoc(Bool) then begin
            Commit();
            CheckBeforePostSalesDoc(SalesHeader, PreviewMode);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnRunOnBeforeFinalizePosting', '', false, false)]
    local procedure OnRunOnBeforeFinalizePosting(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; CommitIsSuppressed: Boolean; GenJnlLineExtDocNo: Code[35]; var EverythingInvoiced: Boolean; GenJnlLineDocNo: Code[20]; SrcCode: Code[10]);
    var
        ImportFileErr: Label 'A problem occurred during the integration of the file. Please try again or contact an administrator', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Un problème est survenu lors de l''intégration du fichier. Veuillez réessayer ou contacter un administrateur"}]}';
    begin
        IF BooGRunAfterPost and (TxtGfichierPVRecette <> '') THEN
            if NOT ValidateSalesDocument.FctOnAfterPostOrder(SalesHeader, TxtGfichierPVRecette, TxtGdescPVRecette) then
                ERROR(ImportFileErr);
    end;

    procedure DoNotRunFunctionOnBeforePostSalesDoc(pRun: Boolean): Boolean
    begin
        exit(pRun);
    end;

    local procedure CheckBeforePostSalesDoc(var SalesHeader: Record "Sales Header"; PreviewMode: Boolean)
    begin
        IF PreviewMode THEN
            EXIT;

        CLEAR(ValidateSalesDocument);
        BooGRunAfterPost := FALSE;
        ValidateSalesDocument.FctSetSalesHeader(SalesHeader);
        IF ValidateSalesDocument.RUNMODAL() = ACTION::OK THEN BEGIN
            ValidateSalesDocument.FctProcessSalesHeader(SalesHeader);
            ValidateSalesDocument.FctGetPageFields(TxtGfichierPVRecette, TxtGdescPVRecette);
            BooGRunAfterPost := TRUE;
        END ELSE
            ERROR('');
    end;
}