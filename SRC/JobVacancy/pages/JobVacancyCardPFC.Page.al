page 50105 "JobVacancyCard_PFC"
{
    Caption = 'Job Vacancy';
    PageType = ListPlus;
    PromotedActionCategories = 'New,Process,Report,Navigate';
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = JobVacancies_PFC;

    layout
    {
        area(Content)
        {
            group("Job Details")
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    Importance = Standard;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    // Visible = NoFieldVisible;

                    trigger OnAssistEdit()
                    begin
                        AssistEdit();
                    end;
                }
                field("Application Open Date"; "Application Open Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on which this vacancy will be open for applications.';
                    Caption = 'Application Open Date';
                }
                field("Application Close Date"; "Application Close Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on which this vacancy will close for applications.';
                    Caption = 'Application Open Date';
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the job title of the vacancy.';
                    Caption = 'Job Title';
                }
                field("Job Description"; "Job Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the job description of the vacancy.';
                    Caption = 'Job Description';
                }
                field("Travel Required"; "Travel Required")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether travel is a requirement of the vacancy.';
                    Caption = 'Travel Required';
                }
                field("Location"; "Location")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location of the vacancy.';
                    Caption = 'Location';
                }

            }
            group("Salary Details")
            {
                field("Salary From"; "Salary From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the minimum salary of the vacancy.';
                    Caption = 'Salary From';
                }
                field("Salary To"; "Salary To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the maximum salary of the vacancy.';
                    Caption = 'Salary To';
                }
                field("Salary Per"; "Salary Per")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the salary payment frequency of the vacancy.';
                    Caption = 'Salary Per';
                }
                field("OTE Amount"; "OTE Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the on-target earnings of the vacancy if applicable.';
                    Caption = 'OTE Amount';
                }
                field("Salary Description"; "Salary Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the salary of the vacancy as you would like an applicant to see it. e.g. "£12-£14 p/hr" or "£32,000 ProRata" or "Competitive"';
                    Caption = 'Salary Description';
                }
            }
            group("Contract Details")
            {
                field("Contract Type"; "Contract Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contract type of the vacancy';
                    Caption = 'Contract Type';
                }

                field("Contract Duration"; "Contract Duration")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contract d uration of the vacancy';
                    Caption = 'Contract Duration';
                }
                field("Period Units"; "Period Units")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contract duration of the vacancy in period units e.g. "Months"';
                    Caption = 'Period Units';
                }
                field("Min. Hours"; "Min. Hours")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the min. hours of the vacancy';
                    Caption = 'Min. Hours';
                }
                field("Max. Hours"; "Max. Hours")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the max. hours of the vacancy';
                    Caption = 'Max. Hours';
                }
                field("Hours Per"; "Hours Per")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the hours of the vacancy in period units e.g. "Per Week"';
                    Caption = 'Hours Per';
                }
                field("Contracted Hours"; "Contracted Hours")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contracted hours of the vacancy e.g. "Full-Time"';
                    Caption = 'Contracted Hours';
                }
                field("Hours Description"; "Hours Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the contracted hours of the vacancy';
                    Caption = 'Hours Description';
                }
                fixed(DefiningFixedControl)
                {
                    group("Working Week")
                    {
                        field("Monday"; "Monday")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies whether the vacancy requires the successful applicant to work on a Monday';
                            Caption = 'Monday';
                        }
                        field("Tuesday"; "Tuesday")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies whether the vacancy requires the successful applicant to work on a Tuesday';
                            Caption = 'Tuesday';
                        }
                        field("Wednesday"; "Wednesday")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies whether the vacancy requires the successful applicant to work on a Wenesday';
                            Caption = 'Wednesday';
                        }
                        field("Thursday"; "Thursday")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies whether the vacancy requires the successful applicant to work on a Thursday';
                            Caption = 'Thursday';
                        }
                        field("Friday"; "Friday")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies whether the vacancy requires the successful applicant to work on a Friday';
                            Caption = 'Friday';
                        }
                        field("Saturday"; "Saturday")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies whether the vacancy requires the successful applicant to work on a Saturday';
                            Caption = 'Saturday';
                        }
                        field("Sunday"; "Sunday")
                        {
                            ApplicationArea = All;
                            ToolTip = 'Specifies whether the vacancy requires the successful applicant to work on a Sunday';
                            Caption = 'Sunday';
                        }
                    }
                }
                field("Start ASAP"; "Start ASAP")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the vacancy needs to be filled unrgently.';
                }
                field("Start Date"; "Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the start date of vacancy.';
                }
                field("Finish Date"; "Finish Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Finish date of vacancy.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(RecordId);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(RecordId);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    ToolTip = 'View or add comments for the record.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ToolTip = 'Request approval of the document.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit ApprovalsMgmtExt_PFC;
                    begin
                        if ApprovalsMgmt.CheckVacancyApprovalsWorkflowEnabled(Rec) then
                            ApprovalsMgmt.OnSendVacancyForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit ApprovalsMgmtExt_PFC;
                        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                    begin
                        ApprovalsMgmt.OnCancelVacancyForApproval(Rec);
                        WorkflowWebhookMgt.FindAndCancel(RecordId);
                    end;
                }
                group(Flow)
                {
                    Caption = 'Flow';
                    Image = Flow;
                    action(CreateFlow)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Create a Flow';
                        Image = Flow;
                        Promoted = true;
                        PromotedOnly = true;
                        PromotedCategory = Process;
                        ToolTip = 'Create a new Flow from a list of relevant Flow templates.';

                        trigger OnAction()
                        var
                            FlowServiceManagement: Codeunit "Flow Service Management";
                            FlowTemplateSelector: Page "Flow Template Selector";
                        begin
                            // Opens page 6400 where the user can use filtered templates to create new flows.
                            FlowTemplateSelector.SetSearchText(FlowServiceManagement.GetSalesTemplateFilter());
                            FlowTemplateSelector.Run();
                        end;
                    }
                    action(SeeFlows)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'See my Flows';
                        Image = Flow;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Flow Selector";
                        ToolTip = 'View and configure Flows that you created.';
                    }
                }
            }
        }
    }
    
    trigger OnOpenPage()
    begin
        SetNoFieldVisible();
        SetControlVisibility();
    end;

    var
        NoFieldVisible: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;

    local procedure SetNoFieldVisible()
    var
        VacancyNoVisibility: Codeunit VacancyNoVisibility_PFC;
    begin
        NoFieldVisible := VacancyNoVisibility.VacancyNoIsVisible();
    end;

    local procedure SetControlVisibility()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RecordId);
        WorkflowWebhookMgt.GetCanRequestAndCanCancel(RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
    end;
}