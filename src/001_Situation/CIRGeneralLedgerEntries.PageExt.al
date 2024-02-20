pageextension 50500 "CIR General Ledger Entries" extends "General Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field("CIR Entry Type"; Rec."CIR Entry Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the entry type.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Spécifie le type d''entrée." }, { "lang": "FRB", "txt": "<ToComplete>" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
            }
            field("Document Date"; Rec."Document Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Document Date';
            }
        }
        addafter(Control1)
        {
            group("Total Amount")
            {
                Caption = 'Total Amount', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Total sélection"}]}';
                field("CIR Total Amount"; SelectedTotal)
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    Caption = 'Total selected amounts', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Total des montants sélectionnés"}]}';
                    ToolTip = 'Specifies the total amount in the general ledger entries.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Spécifie le montant total dans les écritures comptables"}]}';
                    Editable = false;
                    Visible = true;
                }
            }
        }
        modify("Debit Amount")
        {
            Visible = true;
        }
        modify("Credit Amount")
        {
            Visible = true;
        }
    }

    actions
    {
        addlast(processing)
        {
            action("Calculate Selection")
            {
                Caption = 'Calculate Selection', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Calculer la sélection"}]}';
                ToolTip = 'Calculate the amount of the selected lines', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Calculer le montant des lignes sélectionnées"}]}';
                Image = Account;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    SelectedGLEntry: Record "G/L Entry";
                begin
                    SelectedGLEntry.Reset();
                    SelectedTotal := 0;
                    CurrPage.SetSelectionFilter(SelectedGLEntry);
                    SelectedGLEntry.SetLoadFields(Amount);
                    if SelectedGLEntry.FindSet() then
                        repeat
                            SelectedTotal += SelectedGLEntry.Amount;
                        until SelectedGLEntry.Next() = 0;
                end;
            }
        }
        addafter("Ent&ry")
        {
            group("Apply")
            {
                Caption = 'Apply', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Lettrage"}]}';
                Image = LotInfo;

                action("Apply Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Apply Entries', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ecritures lettrées"}]}';
                    Image = ApplyEntries;
                    ShortCutKey = 'Shift+F11';
                    ToolTip = 'Apply entries to general ledger accounts.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Lettrage sur écritures comptable"}]}';

                    trigger OnAction()
                    var
                        lGLEntry: Record "G/L Entry";
                        lApplyGLEntries: Page "Apply G/L Entries";
                    begin
                        CLEAR(lApplyGLEntries);
                        lGLEntry.SetRange("G/L Account No.", rec."G/L Account No.");
                        lGLEntry.SetFilter(Letter, '<>%1', '');
                        lApplyGLEntries.SetTableView(lGLEntry);
                        lApplyGLEntries.Run();
                    end;
                }

                action("Open Entries")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Open Entries', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ecritures ouvertes"}]}';
                    Image = Open;
                    ToolTip = 'Open entries to general ledger accounts.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Ecritures ouvertes"}]}';

                    trigger OnAction()
                    var
                        lGLEntry: Record "G/L Entry";
                        lApplyGLEntries: Page "Apply G/L Entries";
                    begin
                        CLEAR(lApplyGLEntries);
                        lGLEntry.SetRange("G/L Account No.", rec."G/L Account No.");
                        lGLEntry.SetRange(Letter, '');
                        lApplyGLEntries.SetTableView(lGLEntry);
                        lApplyGLEntries.Run();
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        UserGroup: Record "User Group";
        CIRUserManagement: Codeunit "CIR User Management";
    begin
        if not (CIRUserManagement.CheckRightUserByGroup(UserGroup.FIELDNO("Allow employees entries"))) then begin
            Rec.FILTERGROUP(2);
            rec.SetFilter("Source Type", '<>%1', Rec."Source Type"::Employee);
            Rec.FILTERGROUP(0);
        end;
        ClearTotalAmount();
    end;

    local procedure ClearTotalAmount()
    begin
        SelectedTotal := 0;
    end;

    var
        SelectedTotal: Decimal;
}