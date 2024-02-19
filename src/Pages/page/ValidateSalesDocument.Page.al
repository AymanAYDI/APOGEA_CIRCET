page 50014 "Validate Sales Document"
{
    Caption = 'Validate Sales Document', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Valider document vente" } ] }';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    MultipleNewLines = false;
    PageType = StandardDialog;
    PopulateAllFields = false;
    SaveValues = false;
    ShowFilter = false;
    SourceTable = "Sales Header";
    SourceTableTemporary = true;
    SourceTableView = SORTING("Document Type", "No.");

    layout
    {
        area(content)
        {
            group(Dates)
            {
                Caption = 'Dates';
                field(DateComptaSel; PostingDateSelected)
                {
                    Caption = 'Posting Date', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Date comptabilisation" } ] }';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Posting Date', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Date comptabilisation" } ] } ';
                }
                field(DateDocSel; DocumentDateSelected)
                {
                    Caption = 'Document date', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Date document" } ] }';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Date document', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Date document" } ] } ';
                }
            }
            group(GrpPVRecette)
            {
                Caption = 'Receipt Slip', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "PV recette" } ] }';
                Visible = BooGPvRecetteVisibility;
                field(TxtGdescPVRecette; TxtGdescPVRecette)
                {
                    Caption = 'Description', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Désignation" } ] }';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Désignation" } ] } ';
                }
                field(TxtGfichierPVRecette; TxtGfichierPVRecette)
                {
                    Caption = 'File', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Fichier" } ] }';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the File', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Fichier" } ] } ';

                    trigger OnAssistEdit()
                    var
                        CduLFileManagement: Codeunit "File Management";
                        SelectionDocument_Lbl: Label 'Document selection', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Sélection document" } ] }';
                        FilterFileExtension_Lbl: Label 'PDF (*.pdf)|*.pdf', Locked = true;
                    begin
                        TxtGfichierPVRecette := CopyStr(CduLFileManagement.UploadFileWithFilter(SelectionDocument_Lbl, '', FilterFileExtension_Lbl, '(*.*)|*.*'), 1, MaxStrLen(TxtGfichierPVRecette));
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        GestAffichageCtrlPV();
        CurrPage.UPDATE(FALSE);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        NoFileSelectErr: Label 'You have not selected a file.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous n''avez pas sélectionné de fichier."}]}';
    begin
        if CloseAction = Action::OK then
            IF BooGPvRecetteVisibility and (TxtGfichierPVRecette = '') THEN
                ERROR(NoFileSelectErr);
    end;

    var
        RecGSalesHeader: Record "Sales Header";
        TxtGfichierPVRecette: Text[300];
        TxtGdescPVRecette: Text[50];
        BooGPvRecetteVisibility: Boolean;
        PostingDateSelected: Date;
        DocumentDateSelected: Date;


    procedure FctSetSalesHeader(var RecPSalesHeader: Record "Sales Header")
    begin
        RecGSalesHeader.COPY(RecPSalesHeader);
        GestAffichageCtrlPV();
        PostingDateSelected := WORKDATE();
        DocumentDateSelected := WORKDATE();
    end;


    procedure FctGetPageFields(var TxtPfichierPVRecette: Text[300]; var TxtPdescPVRecette: Text[50])
    begin
        TxtPfichierPVRecette := TxtGfichierPVRecette;
        TxtPdescPVRecette := TxtGdescPVRecette;
    end;

    local procedure GestAffichageCtrlPV()
    var
        recSalesHeader: Record "Sales Header";
        recSalesLine: Record "Sales Line";
        recCustomer: Record Customer;
        montantFactu: Decimal;
    begin
        // Description :
        // Gestion de l'affichage du cadre permettant d'associer, depuis le formulaire de requête (RequestForm), un PV de recette à la facture à générer en fonction des lignes du document vente à valider.
        // Paramètre d'entrée : aucun
        // Paramètre de sortie : aucun

        BooGPvRecetteVisibility := TRUE;

        // Test si le document à valider nécessite la saisie d'un PV de recette :
        //    - le client à facturer impose la fourniture d'un PV de recette en accompagnement de la facture,
        //    - le document à valider est une commande ou une facture,
        //    - le montant à facturer présente un montant différent de 0.

        // Test si le client à facturer impose la fourniture d'un PV de recette
        IF BooGPvRecetteVisibility THEN BEGIN
            recSalesHeader.INIT();
            IF recSalesHeader.GET(RecGSalesHeader."Document Type", RecGSalesHeader."No.") THEN;
            recCustomer.INIT();
            IF recCustomer.GET(recSalesHeader."Bill-to Customer No.") THEN;
            BooGPvRecetteVisibility := recCustomer."Receipt Slip Mandatory";
        END;

        // Test si le document à valider est une facture ou une commande à facturer
        IF BooGPvRecetteVisibility THEN
            BooGPvRecetteVisibility := (RecGSalesHeader."Document Type" = recSalesHeader."Document Type"::Invoice) OR
                                  ((RecGSalesHeader."Document Type" = recSalesHeader."Document Type"::Order) AND RecGSalesHeader.Invoice);

        // Test si le montant à facturer est différent de 0
        IF BooGPvRecetteVisibility THEN BEGIN
            // Parcours des lignes du document vente à valider pour évaluer le montant à facturer
            recSalesLine.RESET();
            recSalesLine.SETRANGE("Document Type", RecGSalesHeader."Document Type");
            recSalesLine.SETRANGE("Document No.", RecGSalesHeader."No.");
            recSalesLine.SETFILTER("Qty. to Invoice", '<>0');
            montantFactu := 0;
            IF recSalesLine.FindSet() THEN
                REPEAT
                    montantFactu += (recSalesLine."Qty. to Invoice" * recSalesLine."Unit Price");
                UNTIL recSalesLine.NEXT() = 0;

            BooGPvRecetteVisibility := (montantFactu <> 0);
        END;
    end;


    procedure FctOnAfterPostOrder(var RecPSalesHeader: Record "Sales Header"; TxtPfichierPVRecette: Text[300]; TxtPdescPVRecette: Text[50]): Boolean
    var
        AttchPostedSalesInvoices: Record "Attchm. Posted Sales Invoice";
    begin
        // Association du PV de recette à la facture vente générée
        IF TxtPfichierPVRecette <> '' THEN BEGIN
            AttchPostedSalesInvoices.INIT();
            AttchPostedSalesInvoices."Sales Document Type" := AttchPostedSalesInvoices."Sales Document Type"::Invoice;
            AttchPostedSalesInvoices."Sales Document No." := RecPSalesHeader."Last Posting No.";
            AttchPostedSalesInvoices."Document Type" := AttchPostedSalesInvoices."Document Type"::PV;
            AttchPostedSalesInvoices.Description := TxtPdescPVRecette;
            if AttchPostedSalesInvoices.AssociateFile(TxtPfichierPVRecette) then
                exit(true);
        END;
    end;


    procedure FctProcessSalesHeader(var RecPSalesHeader: Record "Sales Header")
    begin
        FctCheckParams();

        RecPSalesHeader.VALIDATE("Posting Date", PostingDateSelected);
        RecPSalesHeader.VALIDATE("Document Date", DocumentDateSelected);
    end;

    local procedure FctCheckParams()
    var
        PostingDateErr: Label 'Please input a posting date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Veuillez saisir la date de comptabilisation"}]}';
        DocumentDateErr: Label 'Please input a document date', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Veuillez saisir la date de document"}]}';
    begin
        IF (PostingDateSelected = 0D) THEN
            ERROR(PostingDateErr);

        IF (DocumentDateSelected = 0D) THEN
            ERROR(DocumentDateErr);
    end;
}