page 50500 "CIR Situation Registers"
{
    AdditionalSearchTerms = 'general ledger situation registers', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "registres de situation du grand livre général" }, { "lang": "FRB", "txt": "registres de situation du grand livre général" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
    ApplicationArea = Basic, Suite;
    Caption = 'Situation Registers', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Registres de situation" }, { "lang": "FRB", "txt": "Registres de situation" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
    Editable = false;
    PageType = List;
    SourceTable = "G/L Register";
    SourceTableView = SORTING("No.")
                      ORDER(Descending) where("No." = filter(< 0));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the general ledger register.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie le numéro du registre du grand livre." }, { "lang": "FRB", "txt": "Spécifie le numéro du registre du grand livre." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the date when the entries in the register were posted.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie la date à laquelle les écritures de l''historique ont été validées." }, { "lang": "FRB", "txt": "Spécifie la date à laquelle les écritures de l''historique ont été validées." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                }
                field("Creation Time"; Rec."Creation Time")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the time when the entries in the register were posted.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Indique l''heure à laquelle les entrées dans le registre ont été enregistrées." }, { "lang": "FRB", "txt": "Indique l''heure à laquelle les entrées dans le registre ont été enregistrées." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the ID of the user who posted the entry, to be used, for example, in the change log.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie l''ID de l''utilisateur qui a publié l''entrée, à utiliser, par exemple, dans le journal des modifications." }, { "lang": "FRB", "txt": "Spécifie l''ID de l''utilisateur qui a publié l''entrée, à utiliser, par exemple, dans le journal des modifications." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';

                    trigger OnDrillDown()
                    var
                        UserMgt: Codeunit "User Management";
                    begin
                        UserMgt.DisplayUserInformation(Rec."User ID");
                    end;
                }
                field("Source Code"; Rec."Source Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the source code for the entries in the register.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie le code source des écritures de l''historique." }, { "lang": "FRB", "txt": "Spécifie le code source des écritures de l''historique." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the batch name of the general journal that the entries were posted from.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie le nom du lot du journal général à partir duquel les entrées ont été enregistrées." }, { "lang": "FRB", "txt": "Spécifie le nom du lot du journal général à partir duquel les entrées ont été enregistrées." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies if the register has been reversed (undone) from the Reverse Entries window.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie si le registre a été contrepassé (annulé) à partir de la fenêtre Contrepasser les écritures." }, { "lang": "FRB", "txt": "Spécifie si le registre a été contrepassé (annulé) à partir de la fenêtre Contrepasser les écritures." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    Visible = false;
                }
                field("From Entry No."; Rec."From Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the first general ledger entry number in the register.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Indique le numéro de la première écriture comptable dans le registre." }, { "lang": "FRB", "txt": "Indique le numéro de la première écriture comptable dans le registre." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                }
                field("To Entry No."; Rec."To Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the last general ledger entry number in the register.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Indique le numéro de la dernière écriture comptable dans le registre." }, { "lang": "FRB", "txt": "Indique le numéro de la dernière écriture comptable dans le registre." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                }
                field("From VAT Entry No."; Rec."From VAT Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the first VAT entry number in the register.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Indique le numéro de la première écriture TVA dans le registre." }, { "lang": "FRB", "txt": "Indique le numéro de la première écriture TVA dans le registre." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                }
                field("To VAT Entry No."; Rec."To VAT Entry No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the last entry number in the register.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Indique le numéro de la dernière écriture TVA dans le registre." }, { "lang": "FRB", "txt": "Indique le numéro de la dernière écriture TVA dans le registre." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Register")
            {
                Caption = '&Register', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Transaction" }, { "lang": "FRB", "txt": "Transaction" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                Image = Register;
                action("General Ledger")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'General Ledger', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Écritures comptables" }, { "lang": "FRB", "txt": "Écritures comptables" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                    Image = GLRegisters;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'View the general ledger entries that resulted in the current register entry.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Affichez les écritures comptables issues de l''écriture de la transaction actuelle." }, { "lang": "FRB", "txt": "Affichez les écritures comptables issues de l''écriture de la transaction actuelle." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';

                    trigger OnAction()
                    var
                        GLEntry: Record "G/L Entry";
                    begin
                        if Rec."From Entry No." > 0 then
                            GLEntry.SetRange("Entry No.", Rec."From Entry No.", Rec."To Entry No.")
                        else
                            GLEntry.SetRange("Entry No.", Rec."To Entry No.", Rec."From Entry No.");
                        Page.Run(Page::"General Ledger Entries", GLEntry);
                    end;
                }
            }
        }

        area(reporting)
        {
            action("Detail Trial Balance")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Detail Trial Balance', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Grand livre" }, { "lang": "FRB", "txt": "Grand livre" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                RunObject = Report "Detail Trial Balance";
                ToolTip = 'Print or save a detail trial balance for the general ledger accounts that you specify.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Imprimez ou enregistrez un grand livre pour les comptes généraux que vous spécifiez." }, { "lang": "FRB", "txt": "Imprimez ou enregistrez un grand livre pour les comptes généraux que vous spécifiez." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            }
            action("Trial Balance by Period")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Trial Balance by Period', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Balance par période" }, { "lang": "FRB", "txt": "Balance par période" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                RunObject = Report "Trial Balance by Period";
                ToolTip = 'Print or save the opening balance by general ledger account, the movements in the selected period of month, quarter, or year, and the resulting closing balance.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Imprimez ou enregistrez le solde d''ouverture par compte général, les mouvements pour la période sélectionnée de mois, de trimestre ou d''année et le solde de clôture qui en résulte." }, { "lang": "FRB", "txt": "Imprimez ou enregistrez le solde d''ouverture par compte général, les mouvements pour la période sélectionnée de mois, de trimestre ou d''année et le solde de clôture qui en résulte." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            }
            action("G/L Register")
            {
                ApplicationArea = Suite;
                Caption = 'G/L Register', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Historique des transactions comptabilité" }, { "lang": "FRB", "txt": "Historique des transactions comptabilité" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedOnly = true;
                RunObject = Report "G/L Register";
                ToolTip = 'View posted G/L entries.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Affichez les écritures comptables validées." }, { "lang": "FRB", "txt": "Affichez les écritures comptables validées." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            }
        }
        area(Processing)
        {
            action("CIR Delete")
            {
                Caption = 'Delete', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Supprimer" }, { "lang": "FRB", "txt": "Supprimer" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = all;
                Image = Delete;
                ToolTip = 'Delete simation register', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Supprime l''écriture de situation sélectionnée" }, { "lang": "FRB", "txt": "Supprime l''écriture de situation sélectionnée" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                trigger OnAction()
                var
                    CIRSituationManagement: Codeunit "CIR Situation Management";
                begin
                    CIRSituationManagement.delete(Rec);
                end;
            }
            action("CIR Transfer")
            {
                Caption = 'Transfer', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Transfert" }, { "lang": "FRB", "txt": "Transfert" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                ApplicationArea = All;
                Image = Change;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ToolTip = 'Transfer situation register', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Supprime et transfert l''écriture de situation sélectionnée" }, { "lang": "FRB", "txt": "Supprime et transfert l''écriture de situation sélectionnée" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                trigger OnAction()
                var
                    CIRSituationManagement: Codeunit "CIR Situation Management";
                begin
                    CIRSituationManagement.DeleteCreate(Rec);
                end;
            }

            action(CopyRegister)
            {
                Caption = 'Copy G/L Register to Journal', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Copier hist. trans. dans feuille"}]}';
                ApplicationArea = Basic, Suite;
                Ellipsis = true;
                Image = CopyToGL;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Copies selected g/l register posted journal lines to general journal.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Copie les lignes feuille validées de l''historique des transactions comptabilité sélectionné dans la feuille comptabilité."}]}';

                trigger OnAction()
                var
                    PostedGenJournalLine: Record "Posted Gen. Journal Line";
                    CopyGenJournalMgt: Codeunit "Copy Gen. Journal Mgt.";
                    Text001Lbl: Label 'WARNING this history has duplicate lines, you will have to delete some lines in the sheet if necessary ?', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "ATTENTION cette historique présente des lignes en doublons, vous devrez le cas échéant supprimer certaines lignes dans la feuille ?" }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                begin
                    PostedGenJournalLine.SetCurrentKey("G/L Register No.");
                    PostedGenJournalLine.SETFILTER("G/L Register No.", FORMAT(Rec."No."));
                    if checkDoublonData(PostedGenJournalLine) then
                        message(Text001Lbl);
                    CopyGenJournalMgt.CopyGLRegister(PostedGenJournalLine);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Rec.FindSet() then;
    end;

    local procedure checkDoublonData(var PostedGenJournalLine: Record "Posted Gen. Journal Line") Return: Boolean
    var
        TempArray: Record "Anomaly" temporary;
        i: Integer;
    begin
        Return := false;
        if PostedGenJournalLine.FINDSET() then
            repeat
                TempArray.SETRANGE(Designation, PostedGenJournalLine."Journal Template Name" + PostedGenJournalLine."Account No." + FORMAT(PostedGenJournalLine."Posting Date") + FORMAT(PostedGenJournalLine.Amount));
                if (TempArray.count = 0) then begin
                    i := i + 1;
                    TempArray.Code := FORMAT(i);
                    TempArray.Designation := PostedGenJournalLine."Journal Template Name" + PostedGenJournalLine."Account No." + FORMAT(PostedGenJournalLine."Posting Date") + FORMAT(PostedGenJournalLine.Amount);
                    TempArray.INSERT();
                end else
                    exit(true);
            until PostedGenJournalLine.NEXT() = 0;
    end;
}