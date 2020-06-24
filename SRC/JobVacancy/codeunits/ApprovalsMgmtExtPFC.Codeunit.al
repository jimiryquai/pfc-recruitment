codeunit 50102 ApprovalsMgmtExt_PFC

{

    trigger OnRun()
    begin
    end;

    var
    WorkflowEventHandling: Codeunit WorkflowEventHandlingExt_PFC;
    WorkflowManagement: Codeunit "Workflow Management";
    NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';

    [IntegrationEvent(false, false)]
    procedure OnSendVacancyForApproval(var Vacancy: Record JobVacancies_PFC)
    begin
    end;


    [IntegrationEvent(false, false)]
    procedure OnCancelVacancyForApproval(var Vacancy: Record JobVacancies_PFC)
    begin
    end;

    procedure CheckVacancyApprovalsWorkflowEnabled(var Vacancy: Record JobVacancies_PFC): Boolean
    begin
        if not IsVacancyApprovalsWorkflowEnabled(Vacancy) then
            Error(NoWorkflowEnabledErr);
        exit(true);
    end;

    procedure IsVacancyApprovalsWorkflowEnabled(var Vacancy: Record JobVacancies_PFC): Boolean
    begin
        if Vacancy.Status <> Vacancy.Status::Open then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(Vacancy, WorkflowEventHandling.RunWorkflowOnSendVacancyForApprovalCode()));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        Vacancy: Record JobVacancies_PFC;
    begin
        case RecRef.Number of
            Database::JobVacancies_PFC:
                begin
                    RecRef.SetTable(Vacancy);
                    ApprovalEntryArgument."Document No." := Vacancy."No."
                end;
        end;
    end;
  
    // [IntegrationEvent(false, false)]
    // local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    // begin
    // end;


    // procedure IsVacancyApprovalsWorkflowEnabled(var Vacancy: Record JobVacancies_PFC): Boolean
    // begin
    //     exit(WorkflowManagement.CanExecuteWorkflow(Vacancy, WorkflowEventHandling.RunWorkflowOnSendVacancyForApprovalCode()));
    // end;

    // procedure IsVacancyPendingApproval(var Vacancy: Record JobVacancies_PFC): Boolean
    // begin
    //     if Vacancy.Status <> Vacancy.Status::Open then
    //         exit(false);

    //     exit(IsVacancyApprovalsWorkflowEnabled(Vacancy));
    // end;

    // procedure CheckVacancyApprovalPossible(var Vacancy: Record JobVacancies_PFC): Boolean
    // begin
    //     if not IsVacancyApprovalsWorkflowEnabled(Vacancy) then
    //         Error(NoWorkflowEnabledErr);

    //     OnAfterCheckVacancyApprovalPossible(Vacancy);

    //     exit(true);
    // end;

    // local procedure PopulateApprovalEntryArgument(RecRef: RecordRef; WorkflowStepInstance: Record "Workflow Step Instance"; var ApprovalEntryArgument: Record "Approval Entry")
    // var
    //     Vacancy: Record JobVacancies_PFC;
        
    // begin
    //     ApprovalEntryArgument.Init();
    //     ApprovalEntryArgument."Table ID" := RecRef.Number;
    //     ApprovalEntryArgument."Record ID to Approve" := RecRef.RecordId;
    //     ApprovalEntryArgument."Document Type" := ApprovalEntryArgument."Document Type"::" ";
    //     ApprovalEntryArgument."Approval Code" := WorkflowStepInstance."Workflow Code";
    //     ApprovalEntryArgument."Workflow Step Instance ID" := WorkflowStepInstance.ID;

    //     case RecRef.Number of
    //         DATABASE::JobVacancies_PFC:
    //             begin
    //                 RecRef.SetTable(Vacancy);
    //                 ApprovalEntryArgument."Document No." := Vacancy."No.";
    //             end;
    // end;
    //     OnPopulateApprovalEntryArgument(RecRef, ApprovalEntryArgument, WorkflowStepInstance);
    // end;

    // [IntegrationEvent(false, false)]
    // local procedure OnAfterCheckVacancyApprovalPossible(var Vacancy: Record JobVacancies_PFC)
    // begin
    // end;
}