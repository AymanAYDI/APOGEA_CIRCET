codeunit 50002 "CIR User Management"
{
    /// <summary>
    /// CheckRightUserByGroup : retourne la valeur d'un champ sur les groupes utilisateurs pour un utilisateur et un champ
    /// </summary>
    /// <param name="FieldNo">Numéro de champs à vérifier de type booléen</param>
    /// <returns>La valeur du paramètre</returns>
    internal procedure CheckRightUserByGroup(FieldNo: Integer) BoolValue: Boolean
    var
        User: Record User;
        UserGroupMember: Record "User Group Member";
        lfieldRef: FieldRef;
    begin
        User.SetRange("User Name", USERID);
        User.FindFirst();
        UserGroupMember.SetRange("User Security ID", User."User Security ID");
        UserGroupMember.SetFilter("Company Name", '%1|%2', CompanyName(), '');
        if UserGroupMember.FindSet() then
            repeat
                GetRightByPermission(User."User Security ID", UserGroupMember."User Group Code", FieldNo, lfieldRef);
                IF lfieldRef.Number <> 0 THEN
                    BoolValue := lfieldRef.Value;
            until (UserGroupMember.Next() = 0) or (BoolValue);
        exit(BoolValue)
    end;

    /// <summary>
    /// GetRightByPermission : retourne la valeur d'un champ sur les groupes utilisateurs
    /// </summary>
    /// <param name="UserSecurityID">GUID.</param>
    /// <param name="UserGroupCode">Code[20].</param>
    /// <param name="FieldNo">Integer.</param>
    /// <param name="FieldRef">VAR FieldRef.</param>
    local procedure GetRightByPermission(UserSecurityID: GUID; UserGroupCode: Code[20]; FieldNo: Integer; var FieldRef: FieldRef)
    var
        UserGroupMember: Record "User Group Member";
    begin
        IF UserGroupMember.GET(UserGroupCode, UserSecurityID, COMPANYNAME()) THEN
            GetValueByPermission(UserGroupCode, FieldNo, fieldRef)
        else
            IF UserGroupMember.GET(UserGroupCode, UserSecurityID, '') THEN
                GetValueByPermission(UserGroupCode, FieldNo, fieldRef);
    end;

    local procedure GetValueByPermission(UserGroupCode: Code[20]; FieldNo: Integer; var FieldRef: FieldRef)
    var
        UserGroup: Record "User Group";
        lRecordRef: RecordRef;
    begin
        UserGroup.GET(UserGroupCode);
        lRecordRef.OPEN(DATABASE::"User Group");
        lRecordRef.GET(UserGroup.RecordId);
        FieldRef := lRecordRef.FIELD(FieldNo);
    end;
}