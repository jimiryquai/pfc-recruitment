codeunit 50103 WorkflowEventHandlingExt_PFC
{
    
    trigger OnRun()
    begin
    end;

    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        ApprReqApprovedEventDescTxt: Label 'An approval request is approved.';
        ApprReqRejectedEventDescTxt: Label 'An approval request is rejected.';
        ApprReqDelegatedEventDescTxt: Label 'An approval request is delegated.';
        EventAlreadyExistErr: Label 'An event with description %1 already exists.';
        VacancySendForApprovalEventDescTxt: Label 'Approval of a job vacancy is requested.';
        VacancyApprReqCancelledEventDescTxt: Label 'An approval request for a job vacancy is canceled.';


        [EventSubscriber(ObjectType::Codeunit, CodeUnit:: "Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', true, true)]
        local procedure OnAddWorkflowEventsToLibrary()
        begin
            WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendVacancyForApprovalCode(), Database::JobVacancies_PFC, VacancySendForApprovalEventDescTxt, 0, false);
            WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelVacancyApprovalCode(), Database::JobVacancies_PFC, VacancyApprReqCancelledEventDescTxt, 0, false);
            WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnApproveApprovalRequestCode(), DATABASE::"Approval Entry", ApprReqApprovedEventDescTxt, 0, false);
            WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnRejectApprovalRequestCode(), DATABASE::"Approval Entry", ApprReqRejectedEventDescTxt, 0, false);
            WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnDelegateApprovalRequestCode(), DATABASE::"Approval Entry", ApprReqDelegatedEventDescTxt, 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure AddEventPredecessorsToLibrary(EventFunctionName: Code[128])
    begin
        case EventFunctionName of
            RunWorkflowOnCancelVacancyApprovalCode():
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelVacancyApprovalCode(), RunWorkflowOnSendVacancyForApprovalCode());
            RunWorkflowOnApproveApprovalRequestCode():
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnApproveApprovalRequestCode(), RunWorkflowOnSendVacancyForApprovalCode());
            RunWorkflowOnRejectApprovalRequestCode():
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnRejectApprovalRequestCode(), RunWorkflowOnSendVacancyForApprovalCode());
            RunWorkflowOnDelegateApprovalRequestCode():
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnDelegateApprovalRequestCode(), RunWorkflowOnSendVacancyForApprovalCode());
        end;
    end;

    // procedure CreateEventsLibrary()
    // begin
    //     AddEventToLibrary(
    //         RunWorkflowOnSendVacancyForApprovalCode(), DATABASE::JobVacancies_PFC, VacancySendForApprovalEventDescTxt, 0, false);
    //     AddEventToLibrary(
    //         RunWorkflowOnCancelVacancyApprovalRequestCode(), DATABASE::JobVacancies_PFC, VacancyApprReqCancelledEventDescTxt, 0, false);
    //     AddEventToLibrary(RunWorkflowOnApproveApprovalRequestCode(), DATABASE::"Approval Entry", ApprReqApprovedEventDescTxt, 0, false);
    //     AddEventToLibrary(RunWorkflowOnRejectApprovalRequestCode(), DATABASE::"Approval Entry", ApprReqRejectedEventDescTxt, 0, false);
    //     AddEventToLibrary(RunWorkflowOnDelegateApprovalRequestCode(), DATABASE::"Approval Entry", ApprReqDelegatedEventDescTxt, 0, false);

    //     OnAddWorkflowEventsToLibrary();
    //     OnAddWorkflowTableRelationsToLibrary();
    // end;

    // local procedure AddEventPredecessors(EventFunctionName: Code[128])
    // begin
    //     case EventFunctionName of
    //         RunWorkflowOnCancelVacancyApprovalRequestCode():
    //             AddEventPredecessor(RunWorkflowOnCancelVacancyApprovalRequestCode(), RunWorkflowOnSendVacancyForApprovalCode());
    //         RunWorkflowOnApproveApprovalRequestCode():
    //             AddEventPredecessor(RunWorkflowOnApproveApprovalRequestCode(), RunWorkflowOnSendVacancyForApprovalCode());
    //         RunWorkflowOnRejectApprovalRequestCode():
    //             AddEventPredecessor(RunWorkflowOnRejectApprovalRequestCode(), RunWorkflowOnSendVacancyForApprovalCode());
    //         RunWorkflowOnDelegateApprovalRequestCode():
    //             AddEventPredecessor(RunWorkflowOnDelegateApprovalRequestCode(), RunWorkflowOnSendVacancyForApprovalCode());
    //     end;

    //     OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName);
    // end;

    // procedure AddEventToLibrary(FunctionName: Code[128]; TableID: Integer; Description: Text[250]; RequestPageID: Integer; UsedForRecordChange: Boolean)
    // var
    //     WorkflowEvent: Record "Workflow Event";
    //     SystemInitialization: Codeunit "System Initialization";
    // begin
    //     if WorkflowEvent.Get(FunctionName) then
    //         exit;

    //     WorkflowEvent.SetRange(Description, Description);
    //     if not WorkflowEvent.IsEmpty then begin
    //         if SystemInitialization.IsInProgress() or (GetExecutionContext() <> ExecutionContext::Normal) then
    //             exit;
    //         Error(EventAlreadyExistErr, Description);
    //     end;

    //     WorkflowEvent.Init();
    //     WorkflowEvent."Function Name" := FunctionName;
    //     WorkflowEvent."Table ID" := TableID;
    //     WorkflowEvent.Description := Description;
    //     WorkflowEvent."Request Page ID" := RequestPageID;
    //     WorkflowEvent."Used for Record Change" := UsedForRecordChange;
    //     WorkflowEvent.Insert();

    //     AddEventPredecessors(WorkflowEvent."Function Name");
    // end;

    // procedure AddEventPredecessor(FunctionName: Code[128]; PredecessorFunctionName: Code[128])
    // var
    //     WFEventResponseCombination: Record "WF Event/Response Combination";
    // begin
    //     WFEventResponseCombination.Init();
    //     WFEventResponseCombination.Type := WFEventResponseCombination.Type::"Event";
    //     WFEventResponseCombination."Function Name" := FunctionName;
    //     WFEventResponseCombination."Predecessor Type" := WFEventResponseCombination."Predecessor Type"::"Event";
    //     WFEventResponseCombination."Predecessor Function Name" := PredecessorFunctionName;
    //     if WFEventResponseCombination.Insert() then;
    // end;


    // [IntegrationEvent(false, false)]
    // local procedure OnAddWorkflowEventsToLibrary()
    // begin
    // end;

    // [IntegrationEvent(false, false)]
    // local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    // begin
    // end;

    // [IntegrationEvent(false, false)]
    // local procedure OnAddWorkflowTableRelationsToLibrary()
    // begin
    // end;

    procedure RunWorkflowOnSendVacancyForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendVacancyForApproval'));
    end;

    procedure RunWorkflowOnCancelVacancyApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelVacancyApproval'));
    end;

    procedure RunWorkflowOnApproveApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnApproveApprovalRequest'));
    end;

    procedure RunWorkflowOnRejectApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnRejectApprovalRequest'));
    end;

    procedure RunWorkflowOnDelegateApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnDelegateApprovalRequest'));
    end;


    [EventSubscriber(ObjectType::Codeunit, 50102, 'OnSendVacancyForApproval', '', false, false)]
    local procedure RunWorkflowOnSendVacancyForApproval(var Vacancy: Record JobVacancies_PFC)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendVacancyForApprovalCode(), Vacancy);
    end;


    [EventSubscriber(ObjectType::Codeunit, 50102, 'OnCancelVacancyForApproval', '', false, false)]
    local procedure RunWorkflowOnCancelSalesApprovalRequest(var Vacancy: Record JobVacancies_PFC)
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelVacancyApprovalCode(), Vacancy);
    end;

    [EventSubscriber(ObjectType::Codeunit, 1535, 'OnApproveApprovalRequest', '', false, false)]
    local procedure RunWorkflowOnApproveApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    begin
        WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowOnApproveApprovalRequestCode(),
          ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;

    [EventSubscriber(ObjectType::Codeunit, 1535, 'OnRejectApprovalRequest', '', false, false)]
    local procedure RunWorkflowOnRejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    begin
        WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowOnRejectApprovalRequestCode(),
          ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;

    [EventSubscriber(ObjectType::Codeunit, 1535, 'OnDelegateApprovalRequest', '', false, false)]
    local procedure RunWorkflowOnDelegateApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    begin
        WorkflowManagement.HandleEventOnKnownWorkflowInstance(RunWorkflowOnDelegateApprovalRequestCode(),
          ApprovalEntry, ApprovalEntry."Workflow Step Instance ID");
    end;

}