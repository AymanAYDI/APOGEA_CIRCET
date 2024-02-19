/// <summary>
/// Codeunit ACY Gen. Journal Line ESI (ID 50035).
/// </summary>
codeunit 50035 "ACY Gen. Journal Line ESI"
{
    EventSubscriberInstance = Manual;
    SingleInstance = true;                  // Activé obligatoirement pour que cela soit pris en compte dans la prise en compte de l'event

    [EventSubscriber(ObjectType::Table, Database::Job, 'OnBeforeTestBlocked', '', false, false)]
    local procedure OnBeforeTestBlockedJob(var Job: Record Job; var IsHandled: Boolean);
    begin
        IsHandled := true;
    end;
}