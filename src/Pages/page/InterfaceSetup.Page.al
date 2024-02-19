page 50006 "Interface Setup"
{
    AdditionalSearchTerms = 'Interface setup,Paramètres interface,Interface CIRCET';
    Caption = 'Interface Setup', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Paramètres interface" } ] }';
    PageType = Card;
    SourceTable = "Interface Setup";
    UsageCategory = Administration;
    ApplicationArea = All;
    DeleteAllowed = false;
    InsertAllowed = false;
    DataCaptionExpression = '';
    PromotedActionCategories = 'New,Process,Report,Tracking', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nouveau,Traitement,Edition,Suivi"}]}';

    layout
    {
        area(content)
        {
            group(Itesoft)
            {
                Caption = 'ITESOFT', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"ITESOFT"}]}';
                field(Path; Rec.Path)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Path', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Chemin"}]}';
                }
                field("Archive Message"; Rec."Archive Message")
                {
                    ToolTip = 'Specifies the value of the Archive the file ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Archiver le fichier"}]}';
                    ApplicationArea = All;
                }
                field("Archive Path"; Rec."Archive Path")
                {
                    ToolTip = 'Specifies the value of the Archive Path ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Répertoire d''archive"}]}';
                    ApplicationArea = All;
                }
                field("Response Path"; Rec."Response Path")
                {
                    ToolTip = 'Specifies the value of the Response Path ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Répertoire de réponse"}]}';
                    ApplicationArea = All;
                }
                field("Error Code Invoice Status"; Rec."Error Code Invoice Status")
                {
                    ToolTip = 'Specifies the value of the Error Code Invoice Status ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code d''erreur BAP"}]}';
                    ApplicationArea = All;
                }
                field("Success Code"; Rec."Success Code")
                {
                    ToolTip = 'Specifies the value of the Success Code ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code de succès"}]}';
                    ApplicationArea = All;
                }
                field("On Hold Code"; Rec."On Hold Code")
                {
                    ToolTip = 'Specifies the value of the On Hold Code ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code en attente"}]}';
                    ApplicationArea = All;
                }
                field("Gen. Posting Code"; Rec."Gen. Posting Code")
                {
                    ToolTip = 'Specifies the value of the Gen. Posting Code ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code validation comptable"}]}';
                    ApplicationArea = All;
                }
                field("Final Posting Code"; Rec."Final Posting Code")
                {
                    ToolTip = 'Specifies the value of the Final Posting Code ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code validation finale"}]}';
                    ApplicationArea = All;
                }
                field("Error Code Inv."; Rec."Error Code Inv.")
                {
                    ToolTip = 'Specifies the value of the Error Code Inv. ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Code d''erreur Facture/Avoir"}]}';
                    ApplicationArea = All;
                }
            }
            group(Concur)
            {
                Caption = 'SAP Concur', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"SAP Concur"}]}';
                field("Expense Job Journal Template"; Rec."Expense Job Journal Template")
                {
                    ToolTip = 'Specifies the value of the expense job journal template', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie la valeur pour la modèle feuille projet frais" } ] }';
                    ApplicationArea = All;
                }
                field("Work Type Expense"; Rec."Work Type Expense")
                {
                    ToolTip = 'Specifies the value of the work type expense', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie la valeur pour la type travail frais" } ] }';
                    ApplicationArea = All;
                }
                field("Expense Journal Template"; Rec."Expense Journal Template")
                {
                    ToolTip = 'Specifies the value of the expense journal template', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie la valeur pour la modèle feuille de frais" } ] }';
                    ApplicationArea = All;
                }
            }
            group(Quarksup)
            {
                Caption = 'Quarksup', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Quarksup"}]}';
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ToolTip = 'Specifies the value of the Base Unit of Measure', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Unité de base"}]}';
                    ApplicationArea = All;
                }
                field("Employee Posting Group"; Rec."Employee Posting Group")
                {
                    ToolTip = 'Specifies the value of the Employee Posting Group', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Groupe compta. salarié"}]}';
                    ApplicationArea = All;
                }

                field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = All;
                    ToolTip = 'Initialisation of the Gen. Prod. Posting Group of the resource', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Initialisation du groupe compta. produit de la fiche ressource"}]}';
                }
            }
            group(Horoquartz)
            {
                Caption = 'Horoquartz', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Horoquartz"}]}';
                field("HQ Job Journal Template"; Rec."HQ Job Journal Template")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Job Journal Template', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Modèle feuille Horoquartz"}]}';
                }
                field("HQ Root Name Journal Batch"; Rec."HQ Root Name Journal Batch")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Root Name Journal Batch', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Racine nom feuille Horoquartz"}]}';
                }
            }
            group("Sage Paie")
            {
                Caption = 'Sage Paie', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Sage Paie"}]}';
                field("SAGE PAIE Gen. Jnl. Template"; Rec."SAGE PAIE Gen. Jnl. Template")
                {
                    ToolTip = 'Specifies the value of the Sage Paie General Journal Template', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur pour le nom modèle feuille Sage Paie"}]}';
                    ApplicationArea = All;
                }
                field("SAGE PAIE Gen. Journal Batch"; Rec."SAGE PAIE Gen. Journal Batch")
                {
                    ToolTip = 'Specifies the value of the Sage Paie General Journal Batch', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie la valeur pour le nom feuille Sage Paie"}]}';
                    ApplicationArea = All;
                }
            }

            group(AllMyBanks)
            {
                Caption = 'ALLMYBANKS', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"ALLMYBANKS"}]}';
                field("Bank File Path"; Rec."Bank File Path")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Path', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Chemin fichier bancaire"}]}';
                }
                field("Archive Bank File"; Rec."Archive Bank File")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Archive Bank File', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Archiver fichier bancaire"}]}';
                }
                field("Archive Bank File Path"; Rec."Archive Bank File Path")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Archive Bank File Path', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Répertoire d''archive fichier bancaire"}]}';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Import Sage Paie")
            {
                Caption = 'Import Sage Paie', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Import Sage paie"}]}';
                ToolTip = 'Allows you to launch the import of Sage Paie', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Permet de lancer l''import Sage paie"}]}';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = xmlport "Import Sage paie";
                Image = Import;
            }
            action("Import ITESOFT")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import invoices ITESOFT', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Import factures ITESOFT"}]}';
                Image = PurchaseInvoice;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the import invoices ITESOFT', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Import factures ITESOFT"}]}';

                trigger OnAction()
                var
                    ImportInvoicesITESOFT: Codeunit "Import Invoices ITESOFT";
                begin
                    ImportInvoicesITESOFT.RUN();
                end;
            }
            action("Import ALLMYBNAKS")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import ALLMYBNAKS', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Import ALLMYBANKS"}]}';
                Image = Bank;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Executes the import ALLMYBANKS', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Import ALLMYBANKS"}]}';

                trigger OnAction()
                var
                    ImportBankMgt: Codeunit "Import Bank Mgt.";
                begin
                    ImportBankMgt.RUN();
                end;
            }
        }
        area(navigation)
        {
            group("Tracking")
            {
                Caption = 'Export Tracking', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Suivi export"}]}';
                Image = Track;
                action("Log Entries ITESOFT")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Log Entries ITESOFT', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ecritures interface ITESOFT"}]}';
                    Image = Log;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Interface Log Entries";
                    RunPageLink = "Interface Name" = filter(0);
                    ToolTip = 'Executes the Log Entries for ITESOFT', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ecritures interface pour ITESOFT"}]}';
                }

                action("Log Entries ALLMYBANKS")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Log Entries ALLMYBANKS', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ecritures interface ALLMYBANKS"}]}';
                    Image = Log;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Interface Log Entries";
                    RunPageLink = "Interface Name" = filter(5);
                    ToolTip = 'Executes the Log Entries for ALLMYBANKS', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ecritures interface pour ALLMYBANKS"}]}';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}