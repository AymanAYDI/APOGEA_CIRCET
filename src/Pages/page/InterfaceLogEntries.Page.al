page 50011 "Interface Log Entries"
{
    ApplicationArea = All;
    Caption = 'Interface Log Entries', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Liste écritures interface"}]}';
    PageType = List;
    SourceTable = "Interface Log Entry";
    ShowFilter = true;
    UsageCategory = History;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    PromotedActionCategories = 'New,Process,Report,Navigate', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nouveau,Traitement,Edition,Navigation"}]}';

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° écriture"}]}';
                    ApplicationArea = All;
                    StyleExpr = TxtStyleExpr;
                }
                field("Date and Time"; Rec."Date and Time")
                {
                    ToolTip = 'Specifies the value of the Date and Time', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Date & heure"}]}';
                    ApplicationArea = All;
                    StyleExpr = TxtStyleExpr;
                }
                field("Interface Name"; Rec."Interface Name")
                {
                    ToolTip = 'Specifies the value of the Interface Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom de l''interface"}]}';
                    ApplicationArea = All;
                    StyleExpr = TxtStyleExpr;
                }
                field("Purch. Document Type"; Rec."Purch. Document Type")
                {
                    ToolTip = 'Specifies the value of the Purch. Document Type', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Type de document achat"}]}';
                    ApplicationArea = All;
                    StyleExpr = TxtStyleExpr;
                }
                field("Purch. Document No."; Rec."Purch. Document No.")
                {
                    ToolTip = 'Specifies the value of the Purch. Document No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° document achat"}]}';
                    ApplicationArea = All;
                    StyleExpr = TxtStyleExpr;
                }
                field("Statement Type"; Rec."Statement Type")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtStyleExpr;
                    Visible = false;
                    ToolTip = 'Specifies the value of the Statement Type', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Type de déclaration"}]}';
                }
                field("Bank Account No."; "Bank Account No.")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtStyleExpr;
                    ToolTip = 'Specifies the value of the Bank Account No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° compte bancaire"}]}';
                }
                field("Statement No."; Rec."Statement No.")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtStyleExpr;
                    ToolTip = 'Specifies the value of the Statement No.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"N° de déclaration"}]}';
                }
                field("Number of Lines Recon."; Rec."Number of Lines Recon.")
                {
                    ApplicationArea = All;
                    StyleExpr = TxtStyleExpr;
                    ToolTip = 'Specifies the value of the Number of Bank Acc Reconciliation Line', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nombres lignes relevé"}]}';
                }
                field("Invoice Type"; Rec."Invoice Type")
                {
                    ToolTip = 'Specifies the value of the Invoice Type', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Type facture"}]}';
                    ApplicationArea = All;
                    StyleExpr = TxtStyleExpr;
                }
                field("Invoice ID"; Rec."Invoice ID")
                {
                    ToolTip = 'Specifies the value of the Invoice ID', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"ID facture"}]}';
                    ApplicationArea = All;
                    StyleExpr = TxtStyleExpr;
                    Visible = false;
                }
                field("Invoice Filename"; Rec."Filename")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Invoice Filename', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom du fichier de facture"}]}';
                    StyleExpr = TxtStyleExpr;
                }
                field("Ack Filename"; Rec."Ack Filename")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Ack Filename', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom du fichier d''acquittement"}]}';
                    StyleExpr = TxtStyleExpr;
                }
                field("User Name"; Rec."User Name")
                {
                    ToolTip = 'Specifies the value of the User Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom utilisateur"}]}';
                    ApplicationArea = All;
                    StyleExpr = TxtStyleExpr;
                    Visible = false;
                }
                field("Error Message"; Rec."Error Message")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Error Message', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Message d''erreur"}]}';
                    StyleExpr = TxtStyleExpr;
                }
                field("Company Name"; "Company Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                    StyleExpr = TxtStyleExpr;
                    ToolTip = 'Specifies the value of the Company Name', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Nom de société"}]}';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Delete)
            {
                Caption = 'Delete', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Supprimer historique"}]}';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Image = Delete;
                ToolTip = 'Executes the Delete', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Executer la suppression de l''historique"}]}';

                trigger OnAction()
                var
                    ConfirmManagement: codeunit "Confirm Management";
                    ConfirmDeleteQst: Label 'Please confirm the deletion of the history.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Veuillez confirmer la suppression de l''historique."}]}';
                begin
                    IF ConfirmManagement.GetResponseOrDefault(ConfirmDeleteQst, false) THEN
                        Rec.DELETEALL();
                    CurrPage.Update(true);
                end;
            }

            action(OpenDocument)
            {
                Caption = 'Open Document', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ouvrir document"}]}';
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Category4;
                Image = Open;
                ToolTip = 'Executes the Open Document', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ouvrir le document lié"}]}';

                trigger OnAction()
                var
                    PurchInvHeader: Record "Purch. Inv. Header";
                    PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
                    BankAccReconciliation: Record "Bank Acc. Reconciliation";
                begin
                    case rec."Interface Name" of
                        rec."Interface Name"::ITESOFT:
                            case rec."Purch. Document Type" of
                                rec."Purch. Document Type"::Invoice:
                                    IF PurchInvHeader.GET(rec."Purch. Document No.") THEN
                                        PAGE.RUN(PAGE::"Posted Purchase Invoice", PurchInvHeader);
                                rec."Purch. Document Type"::"Credit Memo":
                                    IF PurchCrMemoHdr.GET(rec."Purch. Document No.") THEN
                                        PAGE.RUN(PAGE::"Posted Purchase Credit Memo", PurchCrMemoHdr);
                            end;

                        rec."Interface Name"::ALLMYBANKS:
                            IF BankAccReconciliation.GET(rec."Statement Type", rec."Bank Account No.", rec."Statement No.") THEN
                                PAGE.RUN(PAGE::"Bank Acc. Reconciliation", BankAccReconciliation);
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Ascending(false);
    end;

    trigger OnAfterGetRecord()
    begin
        SetStyleExpr();
    end;

    local procedure SetStyleExpr()
    begin
        TxtStyleExpr := 'Standard';

        IF (rec.Error) THEN
            TxtStyleExpr := 'Attention';
    end;

    var
        TxtStyleExpr: Text;
}