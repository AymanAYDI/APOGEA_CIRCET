pageextension 50052 "CIR Bank Acc. Rec. List" extends "Bank Acc. Reconciliation List"
{
    PromotedActionCategories = 'New,Process,Report,Navigate', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nouveau,Traitement,Edition,Naviguer"}]}';
    layout
    {
        addafter(StatementDate)
        {
            field("Number of Lines"; Rec."Number of Lines")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Number of Bank Acc Reconciliation Line ', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nombres lignes relevé"}]}';
            }
        }
    }
    actions
    {
        addBefore("P&osting")
        {
            group("Ba&nk")
            {
                Caption = 'Ba&nk', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Banque"}]}';
                action("Import Bank Statement")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Import Bank Statement', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Importer le relevé bancaire"}]}';
                    Image = Import;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Import electronic bank statements from your bank to populate with data about actual bank transactions.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Importez des relevés bancaires électroniques depuis votre banque pour insérer des données concernant des transactions bancaires réelles."}]}';
                    trigger OnAction()
                    var
                        ImportBankMgt: Codeunit "Import Bank Mgt.";
                        ConfirmImportBankMsg: Label 'Do you confirm the import of the bank files ?', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Confirmez-vous l''import des fichiers bancaires ?"}]}';
                    begin
                        IF CONFIRM(ConfirmImportBankMsg, false) THEN BEGIN
                            ImportBankMgt.RUN();
                            CurrPage.Update();
                        END;
                    end;
                }
                action("Log Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Log Entries', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ecritures interface"}]}';
                    Image = Log;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Executes the Log Entries for ALLMYBANKS', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ecritures interface pour ALLMYBANKS"}]}';
                    trigger OnAction()
                    var
                        InterfaceLogEntry: Record "Interface Log Entry";
                        InterfaceLogEntries: page "Interface Log Entries";
                    begin
                        InterfaceLogEntry.FilterGroup(2);
                        InterfaceLogEntry.SetRange("Interface Name", 5);
                        InterfaceLogEntry.FilterGroup(0);
                        InterfaceLogEntries.SetTableView(InterfaceLogEntry);
                        InterfaceLogEntries.RUN();
                    end;
                }
            }
        }
    }
}