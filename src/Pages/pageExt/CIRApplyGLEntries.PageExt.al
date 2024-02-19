pageextension 50097 "CIR Apply G/L Entries" extends "Apply G/L Entries"
{
    layout
    {
        addafter(Description)
        {
            field("Document Date"; Rec."Document Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Document Date';
            }
            field("Debit Amount"; Rec."Debit Amount")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the total of the ledger entries that represent debits.';
            }
            field("Credit Amount"; Rec."Credit Amount")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the total of the ledger entries that represent credits.';
            }
        }
        addlast(Control1120000)
        {
            field(SelectionDebit; SelectedDebit)
            {
                ApplicationArea = Basic, Suite;
                AutoFormatType = 1;
                Caption = 'Debit (LCY) Selected', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Débit (DS) lettrage"}]}';
                Editable = false;
                ToolTip = 'Specifies the accumulated debit amount of all the lines applied to this line.';
            }
            field(SelectionCredit; SelectedCredit)
            {
                ApplicationArea = Basic, Suite;
                AutoFormatType = 1;
                Caption = 'Credit (LCY) Selected', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Crédit (DS) lettrage"}]}';
                Editable = false;
                ToolTip = 'Specifies the accumulated credit amount of all the lines applied to this line.';
            }
            field("SelectedDebit - SelectedCredit"; SelectedDebit - SelectedCredit)
            {
                ApplicationArea = Basic, Suite;
                AutoFormatType = 1;
                Caption = 'Balance Selected', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Solde lettrage"}]}';
                Editable = false;
                ToolTip = 'Specifies the accumulated balance of all the lines applied to this line.';
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(SetAppliesToIDPlus)
            {
                Caption = 'Set Applies-to ID+', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Lettrer +"}]}';
                ApplicationArea = all;
                ToolTip = 'Set Applies-to ID and calculate the sum of selected lines, the lettering balance is then calculated', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Renseignez le champ ID Lettrage de l''écriture sélectionnée non lettrée par le numéro de document de l''écriture de paiement, le solde lettrage est ensuite calculé. Remarque: cela fonctionne uniquement pour les écritures non lettrées."}]}';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Image = CalculateLines;
                trigger OnAction()
                begin
                    SetApplyAndCalculAmount(True);
                end;
            }
        }

        addlast(Processing)
        {
            action(SetAppliesToIDAllPlus)
            {
                Caption = 'Set Applies-to ID All +', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Lettrer Tout +"}]}';
                ApplicationArea = all;
                ToolTip = 'Fill in the Applies-to ID field on the selected non-applied entry with the document number of the entry on the payment, the lettering balance is then calculated. NOTE: This only works for non-applied entries.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Renseignez le champ ID Lettrage de l''écriture sélectionnée non lettrée par le numéro de document de l''écriture de paiement, puis calcul du solde de lettrage. Remarque : cela fonctionne à la fois pour les écritures lettrées et non lettrées."}]}';
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Image = CalculateLines;
                trigger OnAction()
                begin
                    SetApplyAndCalculAmount(False);
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        UserGroup: Record "User Group";
        CIRUserManagement: Codeunit "CIR User Management";
    begin
        if not (CIRUserManagement.CheckRightUserByGroup(UserGroup.FIELDNO("Allow employees entries"))) then begin
            FILTERGROUP(2);
            rec.SetFilter("Source Type", '<>%1', Rec."Source Type"::Employee);
            FILTERGROUP(0);
        end;
    end;

    local procedure SetApplyAndCalculAmount(OnlyNotApplied: Boolean)
    var
        GLEntry: Record "G/L Entry";
        GLEntriesApplication: Codeunit "G/L Entry Application";
    begin
        SelectedCredit := 0;
        SelectedDebit := 0;
        Clear(GLEntry);
        GLEntry.Copy(Rec);
        CurrPage.SetSelectionFilter(GLEntry);
        OnlyNotApplied := true;
        GLEntriesApplication.SetAppliesToID(GLEntry, OnlyNotApplied);
        clear(GLEntry);
        GLEntry.SetRange("G/L Account No.", Rec."G/L Account No.");
        GLEntry.SetFilter("Applies-to ID", '<>''''');
        if GLEntry.FindSet() then
            repeat
                SelectedCredit := SelectedCredit + GLEntry."Credit Amount";
                SelectedDebit := SelectedDebit + GLEntry."Debit Amount";
            until GLEntry.Next() = 0;
    end;

    var
        SelectedDebit, SelectedCredit : Decimal;
}