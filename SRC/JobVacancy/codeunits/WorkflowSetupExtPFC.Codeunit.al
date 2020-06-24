codeunit 50104 WorkflowSetupExt_PFC
{

    trigger OnRun()
    begin
    end;

    var
        WorkflowSetup: Codeunit "Workflow Setup";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowEventHandling: Codeunit WorkflowEventHandlingExt_PFC;
        BlankDateFormula: DateFormula;
        InvalidEventCondErr: Label 'No event conditions are specified.';
        ApprovalRequestCanceledMsg: Label 'The approval request for the record has been canceled.';
        MsTemplateTok: Label 'MS-', Locked = true;
        PendingApprovalsCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Approval Entry">%1</DataItem></DataItems></ReportParameters>', Locked = true;
        VacancyCategoryDescTxt: Label 'Job Vacancies';
        VacancyApprWorkflowCodeTxt: Label 'VACAPW', Locked = true;
        VacancyApprWorkflowDescTxt: Label 'Vacancy Approval Workflow';
        VacancyCategoryTxt: Label 'HR', Locked = true;
        VacancyTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Customer">%1</DataItem></DataItems></ReportParameters>', Locked = true;
        CustomTemplateToken: Code[3];

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddWorkflowCategoriesToLibrary', '', true, true)]
    local procedure OnAddWorkflowCategoriesToLibrary()
    begin
        WorkflowSetup.InsertWorkflowCategory(VacancyCategoryDescTxt, VacancyApprWorkflowDescTxt);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAfterInsertApprovalsTableRelations', '', true, true)]
    local procedure OnAfterInsertApprovalsTableRelations()
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        WorkflowSetup.InsertTableRelation(Database:: JobVacancies_PFC, 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnInsertWorkflowTemplates', '', true, true)]
    local procedure OnInsertWorkflowTemplates()
    begin
        InsertVacancyApprovalWorkflowTemplate();
    end;

    local procedure InsertVacancyApprovalWorkflowTemplate()
    var
        Workflow: Record Workflow;
    begin
        InsertWorkflowTemplate(Workflow, VacancyApprWorkflowCodeTxt, VacancyApprWorkflowDescTxt, VacancyCategoryTxt);
        InsertVacancyApprovalWorkflowDetails(Workflow);
        MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertVacancyApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        Vacancy: Record JobVacancies_PFC;
    begin
        PopulateWorkflowStepArgument(WorkflowStepArgument,
          WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
          0, '', BlankDateFormula, true);

        InsertRecApprovalWorkflowSteps(Workflow, BuildVacancyTypeConditions(Vacancy.Status::Open),
          WorkflowEventHandling.RunWorkflowOnSendVacancyForApprovalCode(),
          WorkflowResponseHandling.CreateApprovalRequestsCode(),
          WorkflowResponseHandling.SendApprovalRequestForApprovalCode(),
          WorkflowEventHandling.RunWorkflowOnCancelVacancyApprovalCode(),
          WorkflowStepArgument,
          true, true);
    end;

    // local procedure InsertWorkflowTemplates()
    // begin
    //     InsertApprovalsTableRelations();
    //     InsertVacancyApprovalWorkflowTemplate();
    //     OnInsertWorkflowTemplates();
    // end;

    // procedure InsertWorkflowCategories()
    // begin
    //     InsertWorkflowCategory(VacancyCategoryDescTxt, VacancyCategoryDescTxt);
    //     OnAddWorkflowCategoriesToLibrary();
    // end;

    // local procedure InsertVacancyApprovalWorkflowTemplate()
    // var
    //     Workflow: Record Workflow;
    // begin
    //     InsertWorkflowTemplate(Workflow, VacancyApprWorkflowCodeTxt, VacancyApprWorkflowDescTxt, VacancyCategoryTxt);
    //     InsertVacancyApprovalWorkflowDetails(Workflow);
    //     MarkWorkflowAsTemplate(Workflow);
    // end;

    // procedure InsertVacancyApprovalWorkflow()
    // var
    //     Workflow: Record Workflow;
    // begin
    //     InsertWorkflow(Workflow, GetWorkflowCode(VacancyApprWorkflowCodeTxt), VacancyApprWorkflowDescTxt, VacancyCategoryTxt);
    //     InsertVacancyApprovalWorkflowDetails(Workflow);
    // end;

    // local procedure InsertVacancyApprovalWorkflowDetails(var Workflow: Record Workflow)
    // var
    //     WorkflowStepArgument: Record "Workflow Step Argument";
    // begin
    //     PopulateWorkflowStepArgument(WorkflowStepArgument,
    //       WorkflowStepArgument."Approver Type"::Approver, WorkflowStepArgument."Approver Limit Type"::"Direct Approver",
    //       0, '', BlankDateFormula, true);

    //     InsertRecApprovalWorkflowSteps(Workflow, BuildVacancyTypeConditions(),
    //       WorkflowEventHandling.RunWorkflowOnSendVacancyForApprovalCode(),
    //       WorkflowResponseHandling.CreateApprovalRequestsCode(),
    //       WorkflowResponseHandling.SendApprovalRequestForApprovalCode(),
    //       WorkflowEventHandling.RunWorkflowOnCancelVacancyApprovalCode(),
    //       WorkflowStepArgument,
    //       true, true);
    // end;

    procedure InsertRecApprovalWorkflowSteps(Workflow: Record Workflow; ConditionString: Text; RecSendForApprovalEventCode: Code[128]; RecCreateApprovalRequestsCode: Code[128]; RecSendApprovalRequestForApprovalCode: Code[128]; RecCanceledEventCode: Code[128]; WorkflowStepArgument: Record "Workflow Step Argument"; ShowConfirmationMessage: Boolean; RemoveRestrictionOnCancel: Boolean)
    var
        SentForApprovalEventID: Integer;
        CreateApprovalRequestResponseID: Integer;
        SendApprovalRequestResponseID: Integer;
        OnAllRequestsApprovedEventID: Integer;
        OnRequestApprovedEventID: Integer;
        SendApprovalRequestResponseID2: Integer;
        OnRequestRejectedEventID: Integer;
        RejectAllApprovalsResponseID: Integer;
        OnRequestCanceledEventID: Integer;
        CancelAllApprovalsResponseID: Integer;
        OnRequestDelegatedEventID: Integer;
        SentApprovalRequestResponseID3: Integer;
        RestrictUsageResponseID: Integer;
        AllowRecordUsageResponseID: Integer;
        ShowMessageResponseID: Integer;
        TempResponseResponseID: Integer;
    begin
        SentForApprovalEventID := InsertEntryPointEventStep(Workflow, RecSendForApprovalEventCode);
        InsertEventArgument(SentForApprovalEventID, ConditionString);

        RestrictUsageResponseID := InsertResponseStep(Workflow, WorkflowResponseHandling.RestrictRecordUsageCode(),
            SentForApprovalEventID);
        CreateApprovalRequestResponseID := InsertResponseStep(Workflow, RecCreateApprovalRequestsCode,
            RestrictUsageResponseID);
        InsertApprovalArgument(CreateApprovalRequestResponseID,
          WorkflowStepArgument."Approver Type", WorkflowStepArgument."Approver Limit Type",
          WorkflowStepArgument."Workflow User Group Code", WorkflowStepArgument."Approver User ID",
          WorkflowStepArgument."Due Date Formula", ShowConfirmationMessage);
        SendApprovalRequestResponseID := InsertResponseStep(Workflow, RecSendApprovalRequestForApprovalCode,
            CreateApprovalRequestResponseID);
        InsertNotificationArgument(SendApprovalRequestResponseID, false, '', 0, '');

        OnAllRequestsApprovedEventID := InsertEventStep(Workflow, WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode(),
            SendApprovalRequestResponseID);
        InsertEventArgument(OnAllRequestsApprovedEventID, BuildNoPendingApprovalsConditions());
        InsertResponseStep(Workflow, WorkflowResponseHandling.AllowRecordUsageCode(), OnAllRequestsApprovedEventID);

        OnRequestApprovedEventID := InsertEventStep(Workflow, WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode(),
            SendApprovalRequestResponseID);
        InsertEventArgument(OnRequestApprovedEventID, BuildPendingApprovalsConditions());
        SendApprovalRequestResponseID2 := InsertResponseStep(Workflow, WorkflowResponseHandling.SendApprovalRequestForApprovalCode(),
            OnRequestApprovedEventID);

        SetNextStep(Workflow, SendApprovalRequestResponseID2, SendApprovalRequestResponseID);

        OnRequestRejectedEventID := InsertEventStep(Workflow, WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode(),
            SendApprovalRequestResponseID);
        RejectAllApprovalsResponseID := InsertResponseStep(Workflow, WorkflowResponseHandling.RejectAllApprovalRequestsCode(),
            OnRequestRejectedEventID);
        InsertNotificationArgument(RejectAllApprovalsResponseID, true, '', WorkflowStepArgument."Link Target Page", '');

        OnRequestCanceledEventID := InsertEventStep(Workflow, RecCanceledEventCode, SendApprovalRequestResponseID);
        CancelAllApprovalsResponseID := InsertResponseStep(Workflow, WorkflowResponseHandling.CancelAllApprovalRequestsCode(),
            OnRequestCanceledEventID);
        InsertNotificationArgument(CancelAllApprovalsResponseID, false, '', WorkflowStepArgument."Link Target Page", '');

        TempResponseResponseID := CancelAllApprovalsResponseID;
        if RemoveRestrictionOnCancel then begin
            AllowRecordUsageResponseID :=
              InsertResponseStep(Workflow, WorkflowResponseHandling.AllowRecordUsageCode(), CancelAllApprovalsResponseID);
            TempResponseResponseID := AllowRecordUsageResponseID;
        end;
        if ShowConfirmationMessage then begin
            ShowMessageResponseID := InsertResponseStep(Workflow, WorkflowResponseHandling.ShowMessageCode(), TempResponseResponseID);
            InsertMessageArgument(ShowMessageResponseID, ApprovalRequestCanceledMsg);
        end;

        OnRequestDelegatedEventID := InsertEventStep(Workflow, WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode(),
            SendApprovalRequestResponseID);
        SentApprovalRequestResponseID3 := InsertResponseStep(Workflow, WorkflowResponseHandling.SendApprovalRequestForApprovalCode(),
            OnRequestDelegatedEventID);

        SetNextStep(Workflow, SentApprovalRequestResponseID3, SendApprovalRequestResponseID);
    end;

    local procedure InsertWorkflow(var Workflow: Record Workflow; WorkflowCode: Code[20]; WorkflowDescription: Text[100]; CategoryCode: Code[20])
    begin
        Workflow.Init();
        Workflow.Code := WorkflowCode;
        Workflow.Description := WorkflowDescription;
        Workflow.Category := CategoryCode;
        Workflow.Enabled := false;
        Workflow.Insert();
    end;

    procedure InsertEventStep(Workflow: Record Workflow; FunctionName: Code[128]; PreviousStepID: Integer): Integer
    var
        WorkflowStep: Record "Workflow Step";
    begin
        InsertStep(WorkflowStep, Workflow.Code, WorkflowStep.Type::"Event", FunctionName);
        WorkflowStep."Sequence No." := GetSequenceNumber(Workflow, PreviousStepID);
        WorkflowStep.Validate("Previous Workflow Step ID", PreviousStepID);
        WorkflowStep.Modify(true);
        exit(WorkflowStep.ID);
    end;

    procedure InsertEntryPointEventStep(Workflow: Record Workflow; FunctionName: Code[128]): Integer
    var
        WorkflowStep: Record "Workflow Step";
    begin
        InsertStep(WorkflowStep, Workflow.Code, WorkflowStep.Type::"Event", FunctionName);
        WorkflowStep.Validate("Entry Point", true);
        WorkflowStep.Modify(true);
        exit(WorkflowStep.ID);
    end;


    procedure InsertEventArgument(WorkflowStepID: Integer; EventConditions: Text)
    var
        WorkflowStep: Record "Workflow Step";
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        if EventConditions = '' then
            Error(InvalidEventCondErr);

        WorkflowStepArgument.Type := WorkflowStepArgument.Type::"Event";
        WorkflowStepArgument.Insert(true);
        WorkflowStepArgument.SetEventFilters(EventConditions);

        WorkflowStep.SetRange(ID, WorkflowStepID);
        WorkflowStep.FindFirst();
        WorkflowStep.Argument := WorkflowStepArgument.ID;
        WorkflowStep.Modify(true);
    end;

    procedure InsertResponseStep(Workflow: Record Workflow; FunctionName: Code[128]; PreviousStepID: Integer): Integer
    var
        WorkflowStep: Record "Workflow Step";
    begin
        InsertStep(WorkflowStep, Workflow.Code, WorkflowStep.Type::Response, FunctionName);
        WorkflowStep."Sequence No." := GetSequenceNumber(Workflow, PreviousStepID);
        WorkflowStep.Validate("Previous Workflow Step ID", PreviousStepID);
        WorkflowStep.Modify(true);
        exit(WorkflowStep.ID);
    end;

    procedure InsertStep(var WorkflowStep: Record "Workflow Step"; WorkflowCode: Code[20]; StepType: Option; FunctionName: Code[128])
    begin
        with WorkflowStep do begin
            Validate("Workflow Code", WorkflowCode);
            Validate(Type, StepType);
            Validate("Function Name", FunctionName);
            Insert(true);
        end;
    end;

    local procedure InsertApprovalArgument(WorkflowStepID: Integer; ApproverType: Option; ApproverLimitType: Option; WorkflowUserGroupCode: Code[20]; ApproverId: Code[50]; DueDateFormula: DateFormula; ShowConfirmationMessage: Boolean)
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        InsertStepArgument(WorkflowStepArgument, WorkflowStepID);

        WorkflowStepArgument."Approver Type" := ApproverType;
        WorkflowStepArgument."Approver Limit Type" := ApproverLimitType;
        WorkflowStepArgument."Workflow User Group Code" := WorkflowUserGroupCode;
        WorkflowStepArgument."Approver User ID" := ApproverId;
        WorkflowStepArgument."Due Date Formula" := DueDateFormula;
        WorkflowStepArgument."Show Confirmation Message" := ShowConfirmationMessage;
        WorkflowStepArgument.Modify(true);
    end;


    // [IntegrationEvent(TRUE, false)]
    // local procedure OnInsertWorkflowTemplates()
    // begin
    // end;

    // [IntegrationEvent(false, false)]
    // local procedure OnAddWorkflowCategoriesToLibrary()
    // begin
    // end;

    procedure GetSequenceNumber(Workflow: Record Workflow; PreviousStepID: Integer): Integer
    var
        WorkflowStep: Record "Workflow Step";
    begin
        WorkflowStep.SetRange("Workflow Code", Workflow.Code);
        WorkflowStep.SetRange("Previous Workflow Step ID", PreviousStepID);
        if WorkflowStep.FindLast() then
            exit(WorkflowStep."Sequence No." + 1);
    end;

    local procedure SetNextStep(Workflow: Record Workflow; WorkflowStepID: Integer; NextStepID: Integer)
    var
        WorkflowStep: Record "Workflow Step";
    begin
        WorkflowStep.Get(Workflow.Code, WorkflowStepID);
        WorkflowStep.Validate("Next Workflow Step ID", NextStepID);
        WorkflowStep.Modify(true);
    end;


    procedure InsertTableRelation(TableId: Integer; FieldId: Integer; RelatedTableId: Integer; RelatedFieldId: Integer)
    var
        WorkflowTableRelation: Record "Workflow - Table Relation";
    begin
        if WorkflowTableRelation.Get(TableId, FieldId, RelatedTableId, RelatedFieldId) then
            exit;
        WorkflowTableRelation.Init();
        WorkflowTableRelation."Table ID" := TableId;
        WorkflowTableRelation."Field ID" := FieldId;
        WorkflowTableRelation."Related Table ID" := RelatedTableId;
        WorkflowTableRelation."Related Field ID" := RelatedFieldId;
        WorkflowTableRelation.Insert();
    end;

    procedure InsertWorkflowTemplate(var Workflow: Record Workflow; WorkflowCode: Code[17]; WorkflowDescription: Text[100]; CategoryCode: Code[20])
    begin
        Workflow.Init();
        Workflow.Code := GetWorkflowTemplateCode(WorkflowCode);
        Workflow.Description := WorkflowDescription;
        Workflow.Category := CategoryCode;
        Workflow.Enabled := false;
        if Workflow.Insert() then;
    end;

    procedure InsertWorkflowCategory("Code": Code[20]; Description: Text[100])
    var
        WorkflowCategory: Record "Workflow Category";
    begin
        if WorkflowCategory.Get(Code) then
            exit;
        WorkflowCategory.Init();
        WorkflowCategory.Code := Code;
        WorkflowCategory.Description := Description;
        WorkflowCategory.Insert();
    end;

    procedure InsertApprovalsTableRelations()
    var
        IncomingDocument: Record "Incoming Document";
        ApprovalEntry: Record "Approval Entry";
    begin
        InsertTableRelation(DATABASE::JobVacancies_PFC, 0,
          DATABASE::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));

        InsertTableRelation(
          DATABASE::"Incoming Document", IncomingDocument.FieldNo("Entry No."),
          DATABASE::"Approval Entry", ApprovalEntry.FieldNo("Document No."));
        InsertTableRelation(
          DATABASE::"Approval Entry", ApprovalEntry.FieldNo("Document No."),
          DATABASE::"Incoming Document", IncomingDocument.FieldNo("Entry No."));

        OnAfterInsertApprovalsTableRelations();
    end;

    procedure MarkWorkflowAsTemplate(var Workflow: Record Workflow)
    begin
        Workflow.Validate(Template, true);
        Workflow.Modify(true);
    end;

    procedure GetWorkflowTemplateCode(WorkflowCode: Code[17]): Code[20]
    begin
        exit(GetWorkflowTemplateToken() + WorkflowCode);
    end;

    procedure GetWorkflowTemplateToken(): Code[3]
    begin
        if CustomTemplateToken <> '' then
            exit(CustomTemplateToken);

        exit(MsTemplateTok);
    end;

    local procedure GetWorkflowCode(WorkflowCode: Text): Code[20]
    var
        Workflow: Record Workflow;
    begin
        exit(CopyStr(Format(Workflow.Count + 1) + '-' + WorkflowCode, 1, MaxStrLen(Workflow.Code)));
    end;

    procedure PopulateWorkflowStepArgument(var WorkflowStepArgument: Record "Workflow Step Argument"; ApproverType: Option; ApproverLimitType: Option; ApprovalEntriesPage: Integer; WorkflowUserGroupCode: Code[20]; DueDateFormula: DateFormula; ShowConfirmationMessage: Boolean)
    begin
        WorkflowStepArgument.Init();
        WorkflowStepArgument.Type := WorkflowStepArgument.Type::Response;
        WorkflowStepArgument."Approver Type" := ApproverType;
        WorkflowStepArgument."Approver Limit Type" := ApproverLimitType;
        WorkflowStepArgument."Workflow User Group Code" := WorkflowUserGroupCode;
        WorkflowStepArgument."Due Date Formula" := DueDateFormula;
        WorkflowStepArgument."Link Target Page" := ApprovalEntriesPage;
        WorkflowStepArgument."Show Confirmation Message" := ShowConfirmationMessage;
    end;

    local procedure InsertNotificationArgument(WorkflowStepID: Integer; NotifySender: Boolean; NotifUserID: Code[50]; LinkTargetPage: Integer; CustomLink: Text[250])
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        InsertStepArgument(WorkflowStepArgument, WorkflowStepID);

        WorkflowStepArgument."Notification User ID" := NotifUserID;
        WorkflowStepArgument.Validate("Notify Sender", NotifySender);
        WorkflowStepArgument."Link Target Page" := LinkTargetPage;
        WorkflowStepArgument."Custom Link" := CustomLink;
        WorkflowStepArgument.Modify(true);
    end;

    local procedure InsertStepArgument(var WorkflowStepArgument: Record "Workflow Step Argument"; WorkflowStepID: Integer)
    var
        WorkflowStep: Record "Workflow Step";
    begin
        WorkflowStep.SetRange(ID, WorkflowStepID);
        WorkflowStep.FindFirst();

        if WorkflowStepArgument.Get(WorkflowStep.Argument) then
            exit;

        WorkflowStepArgument.Type := WorkflowStepArgument.Type::Response;
        WorkflowStepArgument.Validate("Response Function Name", WorkflowStep."Function Name");
        WorkflowStepArgument.Insert(true);

        WorkflowStep.Argument := WorkflowStepArgument.ID;
        WorkflowStep.Modify(true);
    end;

    local procedure InsertMessageArgument(WorkflowStepID: Integer; Message: Text[250])
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
    begin
        InsertStepArgument(WorkflowStepArgument, WorkflowStepID);

        WorkflowStepArgument.Message := Message;
        WorkflowStepArgument.Modify(true);
    end;

    local procedure BuildNoPendingApprovalsConditions(): Text
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.SetRange("Pending Approvals", 0);
        exit(StrSubstNo(PendingApprovalsCondnTxt, Encode(ApprovalEntry.GetView(false))));
    end;

    local procedure BuildPendingApprovalsConditions(): Text
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.SetFilter("Pending Approvals", '>%1', 0);
        exit(StrSubstNo(PendingApprovalsCondnTxt, Encode(ApprovalEntry.GetView(false))));
    end;

    procedure Encode(Text: Text): Text
    var
        XMLDOMManagement: Codeunit XMLDOMManagementExt_PFC;
    begin
        exit(XMLDOMManagement.XMLEscape(Text));
    end;

    procedure BuildVacancyTypeConditions(Status: Enum VacancyStatus_PFC): Text
    var
        Vacancy: Record JobVacancies_PFC;
    begin
        exit(StrSubstNo(VacancyTypeCondnTxt, Encode(Vacancy.GetView(false))));
    end;



//     [IntegrationEvent(false, false)]
//     local procedure OnAfterInsertApprovalsTableRelations()
//     begin
//     end;
// 
}