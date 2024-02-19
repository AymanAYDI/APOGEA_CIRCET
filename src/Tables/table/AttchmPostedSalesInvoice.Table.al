table 50003 "Attchm. Posted Sales Invoice"
{
    Caption = 'Attachment Posted Sales Invoices', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "PJ doc vente enregistré" } ] }';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Sales Document Type"; Enum "CIR Attach Sales Document Type")
        {
            Caption = 'Sales Document Type', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Type doc. vente" } ] }';
            DataClassification = CustomerContent;
        }
        field(2; "Sales Document No."; Code[20])
        {
            Caption = 'Sales Document No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° doc. vente" } ] }';
            DataClassification = CustomerContent;
            TableRelation = IF ("Sales Document Type" = CONST(Invoice)) "Sales Invoice Header"."No." ELSE
            IF ("Sales Document Type" = CONST("Credit Memo")) "Sales Cr.Memo Header"."No.";
        }
        field(3; "File No."; Integer)
        {
            Caption = 'File No.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "N° File" } ] }';
            DataClassification = CustomerContent;
        }
        field(4; "Extension"; Code[5])
        {
            Caption = 'Extension', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Extension" } ] }';
            DataClassification = CustomerContent;
        }
        field(5; "Document Type"; Enum "CIR Attachment Document Type")
        {
            Caption = 'Document Type', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Type document" } ] }';
            DataClassification = CustomerContent;
        }
        field(6; "Description"; Text[50])
        {
            Caption = 'Description', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Désignation" } ] }';
            DataClassification = CustomerContent;
        }
        field(7; "Added on"; Date)
        {
            Caption = 'Added on', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ajouté le" } ] }';
            DataClassification = CustomerContent;
        }
        field(8; "Added By"; Code[50])
        {
            Caption = 'Added By', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ajouté par" } ] }';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Sales Document Type", "Sales Document No.", "File No.")
        {
            Clustered = true;
        }
        key(AddedOn; "Added on") { }
        key(DocType; "Document Type") { }
    }
    trigger OnDelete()
    var
        fileSystObj: Codeunit "File Management";
    begin
        // Traitement de la suppression de la pièce jointe
        IF fileSystObj.ServerFileExists(GetFullFileName()) THEN
            fileSystObj.DeleteServerFile(GetFullFileName());
    end;

    /// <summary>
    /// Evaluation du chemin d'accès et du nom de File de la pièce jointe.
    /// </summary>
    /// <returns></returns>
    procedure GetFullFileName() FileName: Text[300]
    var
        GeneralApplicationSetup: Record "General Application Setup";
        fileSystObj: Codeunit "File Management";
        FolderNotExistErr: Label 'The storage directory for attachments ''%1'' does not exist.\\ Please contact your administrator.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Le répertoire de stockage des pièces jointes ''%1'' n''existe pas.\\ Veuillez vous rapprocher de votre administrateur."}]}';
    begin
        GeneralApplicationSetup.GET();
        GeneralApplicationSetup.TESTFIELD("Attach. Posted Sales Inv. Save");

        /// Test existence du répertoire de stockage de la pièce jointe
        IF NOT fileSystObj.ServerDirectoryExists(GeneralApplicationSetup."Attach. Posted Sales Inv. Save") THEN
            ERROR(FolderNotExistErr, GeneralApplicationSetup."Attach. Posted Sales Inv. Save");

        /// Construction du nom et du chemin de localisation de la pièce jointe
        fileName := GeneralApplicationSetup."Attach. Posted Sales Inv. Save";
        IF (COPYSTR(fileName, STRLEN(fileName), 1) <> '\') THEN
            fileName += '\';
        CreateCompanyFolderIfNeed(fileName);
        GetFileName(fileName);
        EXIT(fileName);
    end;


    /// <summary>
    /// Evaluation du chemin d'accès et du nom de File de la pièce jointe.
    /// </summary>
    /// <returns></returns>
    procedure GetFileName(var FileName: Text[300])
    var
        Arg1_Lbl: Label '_%1', Locked = true;
    begin
        FileName += CompanyName() + '\';
        FileName += FORMAT("Sales Document Type");
        FileName += ' - ';
        FileName += "Sales Document No.";
        FileName += STRSUBSTNO("Arg1_Lbl", "File No.");
        IF Extension <> '' THEN BEGIN
            FileName += '.';
            FileName += Extension;
        END;
    end;

    /// <summary>
    /// Gestion de l'association d'un File à un document vente validé.
    /// </summary>
    /// <param name="File"></param>
    procedure AssociateFile(File: Text[500]): Boolean
    var
        recPJSearch: Record "Attchm. Posted Sales Invoice";
        fileSystObj: Codeunit "File Management";
        indexStr: Integer;
        tailleExt: Integer;
        fin: Boolean;
    begin
        Extension := '';
        indexStr := STRLEN(File);
        tailleExt := 0;
        fin := FALSE;
        WHILE ((indexStr > 0) AND (NOT fin) AND (tailleExt <= MAXSTRLEN(Extension))) DO
            IF COPYSTR(File, indexStr, 1) = '.' THEN BEGIN
                fin := TRUE;
                indexStr += 1;
            END ELSE BEGIN
                indexStr -= 1;
                tailleExt += 1;
            END;
        IF (fin = TRUE) AND (tailleExt > 0) THEN
            Extension := CopyStr(COPYSTR(File, indexStr, tailleExt), 1, MaxStrLen(Extension));

        /// Recherche du N° de la pièce jointe
        recPJSearch.RESET();
        recPJSearch.LOCKTABLE();
        recPJSearch.SETRANGE("Sales Document Type", "Sales Document Type");
        recPJSearch.SETRANGE("Sales Document No.", "Sales Document No.");
        IF recPJSearch.FindLast() THEN
            "File No." := recPJSearch."File No." + 1
        ELSE
            "File No." := 1;

        /// Copie de la pièce jointe dans le répertoire destination
        fileSystObj.CopyServerFile(File, GetFullFileName(), false);

        /// Sauvegarde de la pièce jointe
        "Added on" := TODAY();
        "Added By" := CopyStr(USERID, 1, MaxStrLen("Added By"));
        if INSERT(TRUE) then
            exit(true);
    end;

    local procedure CreateCompanyFolderIfNeed(FolderPath: Text)
    var
        DirectoryHelper: DotNet Directory;
    begin
        FolderPath += CompanyName() + '\';

        if not DirectoryHelper.Exists(FolderPath) then
            DirectoryHelper.CreateDirectory(FolderPath);
    end;
}