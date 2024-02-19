page 50004 "Add Attachment For PSI"
{
    Caption = 'Add Attachment Posted Sales Invoice', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Add PJ doc vente enrregistré" } ] }';
    PageType = ConfirmationDialog;
    DataCaptionExpression = gPageCaption;
    UsageCategory = None;
    SourceTable = Integer;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            field("Document Type"; AttchmPostedSalesInvoice."Document Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Document Type ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Document Type" } ] }';

            }
            field(Description; AttchmPostedSalesInvoice.Description)
            {
                ApplicationArea = all;
                ToolTip = 'Specifies the value of the Description ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Désignation" } ] }';
            }
            field(File; gFile)
            {
                ApplicationArea = all;
                Visible = SelectFileVisible;
                Caption = 'File', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Fichier" } ] }';
                ToolTip = 'Specifies the value of the file ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Fichier" } ] }';

                trigger OnAssistEdit()
                var
                    FileManagement: Codeunit "File Management";
                    SelectionDocument_Lbl: Label 'Document selection', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Sélection document" } ] }';
                begin
                    gFile := CopyStr(FileManagement.UploadFileWithFilter(SelectionDocument_Lbl, '', 'PDF (*.pdf)|*.pdf|Tous les fichiers (*.*)|*.*', '(*.*)|*.*'), 1, MaxStrLen(gFile));
                end;
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        NoFileSelectErr: Label 'You have not selected a file.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous n''avez pas sélectionné de fichier."}]}';
    begin
        if CloseAction = Action::Yes then
            IF SelectFileVisible and (gFile = '') THEN
                ERROR(NoFileSelectErr)
            ELSE
                FctOkAction();
    end;

    var
        AttchmPostedSalesInvoice: Record "Attchm. Posted Sales Invoice";
        gFile: Text[300];
        gPageCaption: Text[100];

        AddMode: Boolean;
        SelectFileVisible: Boolean;

    local procedure FctOkAction()
    var
        lAttchmPostedSalesInvoice: Record "Attchm. Posted Sales Invoice";
        fileSystObj: Codeunit "File Management";
        NoDocType_Err: Label 'Please specify a document type.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Veuillez spécifier un type de document." } ] }';
        ReceiptSlipAlreadyExist_Err: Label 'You can''t associate more than receipt slip with a registered sales document.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Vous ne pouvez pas associer plus d''un PV à un document vente enregistré." } ] }';
        FileDoesntExist_Err: Label 'The selected file ''%1'' does not exist.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Le fichier sélectionné ''%1'' n''existe pas." } ] }';
    begin
        // Reset du N° de fichier en mode Add. Cette action est indispensable dans le cas ou la dernière
        // tentative de sauvegarde a échoué lors de l'évaluation du nom et du chemin du fichier de la PJ.
        IF AddMode THEN
            AttchmPostedSalesInvoice."File No." := 0;

        // Vérification spécification d'un type de fichier
        IF AttchmPostedSalesInvoice."Document Type" = AttchmPostedSalesInvoice."Document Type"::" " THEN
            ERROR(NoDocType_Err);

        // Test association d'une seule pièce jointe de type PV au document vente
        IF AttchmPostedSalesInvoice."Document Type" = AttchmPostedSalesInvoice."Document Type"::PV THEN BEGIN
            lAttchmPostedSalesInvoice.RESET();
            lAttchmPostedSalesInvoice.SETCURRENTKEY("Document Type");
            lAttchmPostedSalesInvoice.SETRANGE("Sales Document Type", AttchmPostedSalesInvoice."Sales Document Type");
            lAttchmPostedSalesInvoice.SETRANGE("Sales Document No.", AttchmPostedSalesInvoice."Sales Document No.");
            lAttchmPostedSalesInvoice.SETFILTER("File No.", '<>%1', AttchmPostedSalesInvoice."File No.");
            lAttchmPostedSalesInvoice.SETRANGE("Document Type", lAttchmPostedSalesInvoice."Document Type"::PV);
            IF not lAttchmPostedSalesInvoice.IsEmpty() THEN
                ERROR(ReceiptSlipAlreadyExist_Err);
        END;

        IF AttchmPostedSalesInvoice."File No." <> 0 THEN
            // Traitement de la modification de la pièce jointe
            AttchmPostedSalesInvoice.MODIFY(TRUE)
        ELSE BEGIN
            // Test existence de la pièce jointe sélectionnée
            IF NOT fileSystObj.ServerFileExists(gFile) THEN
                ERROR(FileDoesntExist_Err, gFile);
            AttchmPostedSalesInvoice.AssociateFile(gFile);
        end;
        CurrPage.CLOSE();
    end;

    procedure SelectedMode(p_AttchmPostedSalesInvoice: Record "Attchm. Posted Sales Invoice"; Mode: Option "Add","Modification")
    var
        SelectDocumentToBeModified_Err: Label 'Please select the document to be modified.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Veuillez sélectionner le document à modifier." } ] }';
    begin
        // Sauvegarde des caractéristiques de la pièce jointe à créer ou à modifier
        AttchmPostedSalesInvoice := p_AttchmPostedSalesInvoice;

        // Test sélection d'une pièce jointe dans le cadre d'une modification
        IF (mode = mode::Modification) AND (AttchmPostedSalesInvoice."File No." = 0) THEN
            ERROR(SelectDocumentToBeModified_Err);

        // Reset des caractéristiques de la pièce jointe dans le cadre d'un Add
        IF mode = mode::Add THEN BEGIN
            AttchmPostedSalesInvoice."File No." := 0;
            AttchmPostedSalesInvoice."Document Type" := AttchmPostedSalesInvoice."Document Type"::" ";
            AttchmPostedSalesInvoice.Description := '';
            AttchmPostedSalesInvoice."Added on" := 0D;
            AttchmPostedSalesInvoice."Added By" := '';
        END;

        // Masquage du sélecteur de fichier dans le cadre d'une modification
        SelectFileVisible := (mode = mode::Add);

        // Initialisation du titre de la fenêtre
        IF mode = mode::Add THEN
            CurrPage.CAPTION := 'Add document'
        ELSE
            CurrPage.CAPTION := 'Modification document';
        gPageCaption := FORMAT(AttchmPostedSalesInvoice."Sales Document Type") + ' ' + AttchmPostedSalesInvoice."Sales Document No.";

        // Sauvegarde du mode d'ouverture de la fenêtre
        AddMode := (mode = mode::Add);
    end;
}