page 50005 "Attachm. Posted Sales Invoice"
{
    Caption = 'Attachment Posted Sales Invoice', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "PJ doc vente enregistré" } ] }';
    PageType = ListPart;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    UsageCategory = None;
    SourceTable = "Attchm. Posted Sales Invoice";

    layout
    {
        area(Content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Type document" } ] } ';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Désignation" } ] } ';
                    ApplicationArea = All;
                }
                field("Added on"; Rec."Added on")
                {
                    ToolTip = 'Specifies the value of the Added on', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ajouté le" } ] } ';
                    ApplicationArea = All;
                }
                field("Added By"; Rec."Added By")
                {
                    ToolTip = 'Specifies the value of the Added By', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ajouté par" } ] } ';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            group(Functions)
            {
                Caption = 'Functions', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Fonctions" } ] }';
                Enabled = MenuButtonFonctionEnable;

                action(Add)
                {
                    Caption = 'Add', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ajouter" } ] }';
                    ToolTip = 'Executes the Add ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Exécuter ajouter" } ] }';
                    ApplicationArea = All;
                    Image = Add;

                    trigger OnAction()
                    var
                        AddAttachmentForPSI: Page "Add Attachment For PSI";
                    begin
                        // Ouverture de la fenêtre d'ajout d'une pièce jointe
                        AddAttachmentForPSI.SelectedMode(Rec, 0);
                        AddAttachmentForPSI.RUNMODAL();
                    end;
                }
                action(Edit)
                {
                    Caption = 'Edit', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Modifier" } ] }';
                    ToolTip = 'Executes the Edit ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Exécuter modifier" } ] }';
                    ApplicationArea = all;
                    Image = UpdateDescription;

                    trigger OnAction()
                    var
                        AddAttachmentForPSI: Page "Add Attachment For PSI";
                    begin
                        // Ouverture de la fenêtre d'ajout d'une pièce jointe
                        AddAttachmentForPSI.SelectedMode(Rec, 1);
                        AddAttachmentForPSI.RUNMODAL();
                    end;
                }
                action(Delete)
                {
                    Caption = 'Delete', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Supprimer" } ] }';
                    ToolTip = 'Executes the Delete ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Exécuter supprimer" } ] }';
                    ApplicationArea = All;
                    Image = Delete;

                    trigger OnAction()
                    var
                        SelectDocToBeDeleted_Err: Label 'Please select the document to be deleted.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Veuillez sélectionner le document à supprimer." } ] }';
                        ConfirmDeletionDoc_Qst: Label 'Do you confirm the deletion of the selected document ?', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Confirmez vous la suppression du document sélectionné ?" } ] }';
                    begin
                        IF Rec."File No." = 0 THEN
                            ERROR(SelectDocToBeDeleted_Err)
                        ELSE
                            IF CONFIRM(ConfirmDeletionDoc_Qst) THEN
                                // Traitement de la suppression de la pièce jointe
                                Rec.DELETE(TRUE);
                    end;
                }
            }
            action(Open)
            {
                Caption = 'Open', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Ouvrir" } ] }';
                ToolTip = 'Executes the Open ', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Exécuter ouvrir" } ] }';
                ApplicationArea = All;
                Image = OpenJournal;

                trigger OnAction()
                var
                    SelectDocToBeOpened_Err: Label 'Please select the document to be opened.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Veuillez sélectionner le document à ouvrir." } ] }';
                    FileName: text[300];
                begin
                    GeneralApplicationSetup.GET();
                    GeneralApplicationSetup.TESTFIELD("Attach. Posted Sales Inv. Open");
                    // Ouverture de la pièce jointe
                    IF Rec."File No." = 0 THEN
                        ERROR(SelectDocToBeOpened_Err)
                    ELSE
                        Rec.GetFileName(FileName);
                    HYPERLINK(GeneralApplicationSetup."Attach. Posted Sales Inv. Open" + FileName);
                end;
            }
        }
    }

    trigger OnInit()
    begin
        MenuButtonFonctionEnable := true;
    end;

    trigger OnOpenPage()
    begin
        OnActivateForm();
    end;

    var
        MenuButtonFonctionEnable: Boolean;

    local procedure OnActivateForm()
    var
        UserGroup: Record "User Group";
        CIRUserManagement: Codeunit "CIR User Management";
    begin
        MenuButtonFonctionEnable := CIRUserManagement.CheckRightUserByGroup(UserGroup.FIELDNO("Leader Sales Invoice")) OR
                                     (CIRUserManagement.CheckRightUserByGroup(UserGroup.FIELDNO("Invoice Sales Rights")) AND (Rec."Sales Document Type" = Rec."Sales Document Type"::Invoice));
    end;

    var
        GeneralApplicationSetup: Record "General Application Setup";
}