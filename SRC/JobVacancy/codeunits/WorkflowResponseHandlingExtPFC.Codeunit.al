codeunit 50105 WorkflowResponseHandlingExtPFC
{
    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, CodeUnit:: "Workflow Response Handling", 'OnOpenDocument', '', true, true)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        Vacancy: Record JobVacancies_PFC;
    begin
        case RecRef.Number of
            DATABASE:: JobVacancies_PFC:
                begin
                    RecRef.SetTable(Vacancy);
                    Vacancy.Status := Vacancy.Status::Open;
                    Vacancy.Modify();
                    Handled := true;
                end;
    end;
end;

    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Workflow Response Handling", 'OnReleaseDocument', '', true, true)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        Vacancy: Record JobVacancies_PFC;
    begin
        case RecRef.Number of
            DATABASE::JobVacancies_PFC:
                begin
                    RecRef.SetTable(Vacancy);
                    Vacancy.Status := Vacancy.Status::"Released";
                    Vacancy.Modify();
                    Handled := true
                end;
    end;
end;

    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', true, true)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var isHandled: Boolean)
    var
        Vacancy: Record JobVacancies_PFC;
    begin
        case RecRef.Number of
            DATABASE::JobVacancies_PFC:
                begin
                    RecRef.SetTable(Vacancy);
                    Vacancy.Status := Vacancy.Status::"Released";
                    Vacancy.Modify();
                    isHandled := true
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', true, true)]
    local procedure OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowEventHandlingExt: Codeunit WorkflowEventHandlingExt_PFC;
    begin
        case ResponseFunctionName of
        WorkflowResponseHandling.SetStatusToPendingApprovalCode():
            WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(),
              WorkflowEventHandlingExt.RunWorkflowOnSendVacancyForApprovalCode());
        WorkflowResponseHandling.SendApprovalRequestForApprovalCode():
            WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode(),
                WorkflowEventHandlingExt.RunWorkflowOnSendVacancyForApprovalCode()); 
        WorkflowResponseHandling.CancelAllApprovalRequestsCode():
            WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode(),
            WorkflowEventHandlingExt.RunWorkflowOnCancelVacancyApprovalCode());
        WorkflowResponseHandling.OpenDocumentCode():
            WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode(),
                WorkflowEventHandlingExt.RunWorkflowOnCancelVacancyApprovalCode());   
        end;
    end;
}
