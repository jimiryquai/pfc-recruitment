codeunit 50107 PageManagementExt_PFC
{
    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Page Management", 'OnAfterGetPageID', '', true, true)]
    local procedure OnAfterGetPageID(RecordRef: RecordRef; var PageID: Integer)
    begin
        if PageID = 0 then
            PageID := GetConditionalCardPageID(RecordRef);
    end;

    local procedure GetConditionalCardPageID(RecordRef: RecordRef): Integer
    begin
        case RecordRef.Number of
            Database::JobVacancies_PFC:
                exit(Page::JobVacancyCard_PFC)
        end;
    end;
}
