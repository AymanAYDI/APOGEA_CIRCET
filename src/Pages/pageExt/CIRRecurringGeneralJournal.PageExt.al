pageextension 50076 "CIR Recurring General Journal" extends "Recurring General Journal"
{
    actions
    {
        modify(Post)
        {
            Visible = NOT gVisiblePostSimu;
        }
        modify("Post and &Print")
        {
            Visible = NOT gVisiblePostSimu;
        }
        addafter(Post)
        {
            action("CIR Post")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Post situation registers', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Valider écritures situation" }, { "lang": "FRB", "txt": "Valider écritures situation" }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';
                Image = PostOrder;
                Visible = gVisiblePostSimu;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.', Comment = '{ "instructions": "", "translations": [ { "lang": "FRA", "txt": "Finalisez le document ou la feuille en validant les montants et les quantités sur les comptes concernés dans la comptabilité de la société." }, { "lang": "FRB", "txt": "Finalisez le document ou la feuille en validant les montants et les quantités sur les comptes concernés dans la comptabilité de la société." }, { "lang": "DEU", "txt": "<ToComplete>" }, { "lang": "ESP", "txt": "<ToComplete>" }, { "lang": "ITA", "txt": "<ToComplete>" }, { "lang": "NLB", "txt": "<ToComplete>" }, { "lang": "NLD", "txt": "<ToComplete>" }, { "lang": "PTG", "txt": "<ToComplete>" } ] }';

                trigger OnAction()
                begin
                    CODEUNIT.Run(CODEUNIT::"CIR Gen. Jnl.-Post", Rec);
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        GenJournalTemplate: Record "Gen. Journal Template";
    begin
        IF GenJournalTemplate.Get(Rec."Journal Template Name") THEN
            if SourceCode.Get(GenJournalTemplate."Source Code") then
                gVisiblePostSimu := SourceCode."CIR Situation";
    end;

    trigger OnAfterGetRecord()
    var
        GenJournalTemplate: Record "Gen. Journal Template";
    begin
        IF GenJournalTemplate.Get(Rec."Journal Template Name") THEN
            if SourceCode.Get(GenJournalTemplate."Source Code") then
                gVisiblePostSimu := SourceCode."CIR Situation";
    end;

    var
        SourceCode: Record "Source Code";
        gVisiblePostSimu: Boolean;
}