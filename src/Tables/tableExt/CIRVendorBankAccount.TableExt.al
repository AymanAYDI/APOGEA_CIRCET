tableextension 50044 "CIR Vendor Bank Account" extends "Vendor Bank Account"
{
    trigger onDelete()
    var
        UserGroup: Record "User Group";
        CIRUserManagement: Codeunit "CIR User Management";
        NotRightsToDeletevendorBankAccount_Err: Label 'You do not have the rights to delete a vendor bank account.', Comment = '{"instructions":"","translations":[{"lang":"FRA","txt":"Vous n''avez pas les droits pour supprimer un compte bancaire fournisseur"}]}';
    begin
        If not CirUserManagement.CheckRightUserByGroup(UserGroup.FieldNo("Deletion Vendor RIB")) then
            Error(NotRightsToDeletevendorBankAccount_Err);
    end;
}