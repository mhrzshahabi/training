<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.training.controller.util.AppUtils" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
    final String tenantId = AppUtils.getTenantId();
    final String userNationalCode = SecurityUtil.getNationalCode();
    final String userUserName = SecurityUtil.getUsername();
%>

// <script>

    let interalBaseUrl="";
    let interalUrl="";
    let interalRecord=null;
    let interalMap_data = {};
 //-------------------------------------------------- Rest DataSources --------------------------------------------------

    let RestDataSource_Processes_UserPortfolio = isc.TrDS.create({
        fields: [
            {name: "name", title: "فرایند"},
            {name: "deploymentId"},
            {name: "objectId"},
            {name: "objectType"},
            {name: "approved"},
            {name: "tenantId", title: "زیرسیستم"},
            {name: "createBy", title: "ایجاد کننده"},
            {name: "assignFrom", title: "کد ملی ایجاد کننده ایجاد کننده"},
            {name: "title", title: "عنوان"},
            {name: "processInstanceId", title: "شناسه فرایند"},
            {name: "processDefinitionId"},
            {name: "taskId"},
            {name: "tenantTitle"},
            {name: "date", title: "تاریخ"},
            {name: "processStartTime", title: "تاریخ شروع فرایند"},
            {name: "taskDefinitionKey"},
            {name: "processDefinitionKey"},
            {name: "returnReason",title: "توضیحات",
                showHover:true,
                hoverWidth: 250,
                hoverHTML(record) {
                    return "دلیل عودت: " + record.returnReason + "<br>";
                },
            }
        ],
        transformRequest: function (dsRequest) {

            dsRequest.params = {
                "userId": "<%= userNationalCode %>",
                "tenantId": "<%= tenantId %>",
                "page": 0,
                "size": 100
            };
            dsRequest.httpMethod = "POST";
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: bpmsUrl + "/tasks/searchByUserId"
    });
    let RestDataSource_Processes_History_UserPortfolio = isc.TrDS.create({
        fields: [
            {name: "timeComing"},
            {name: "waitingTime"},
            {name: "taskDefinitionKey"},
            {name: "assignee"},
            {name: "taskId"},
            {name: "name"},
            {name: "post"},
            {name: "approved"}
        ]
    });
    let RestDataSource_Processes_Detail_Competence_UserPortfolio = isc.TrDS.create({
        fields: [
            {name: "code", title: "کد", type: "staticText"},
            {name: "competenceType.title", title: "نوع", type: "staticText"},
            {name: "category.titleFa", title: "گروه", type: "staticText"},
            {name: "subCategory.titleFa", title: "زیرگروه", type: "staticText"},
            {name: "workFlowStatusCode", title: "وضعیت گردش کار", type: "staticText",
                valueMap: {
                    0: "ارسال به گردش کار",
                    1: "عدم تایید",
                    2: "تایید نهایی",
                    3: "حذف گردش کار",
                    4: "اصلاح شایستگی و ارسال به گردش کار"
                }
            },
            {name: "description", title: "توضیحات", type: "staticText"},
            {name: "complex", title: "مجتمع", type: "staticText"},
            {name: "competencePriority", title: "اولویت شایستگی", type: "staticText"},
            {name: "competenceLevel", title: "سطح شایستگی", type: "staticText"},
            {name: "processInstanceId", hidden: true}
        ]
    });
    let RestDataSource_Processes_Detail_Certification_UserPortfolio = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "processInstanceId", hidden: true},
            {name: "nationalCode", title: "کدملی", type: "staticText"},
            {name: "personnelNo2", title: "شماره پرسنلی قدیم", type: "staticText"},
            {name: "personnelNumber", title: "شماره پرسنلی جدید", type: "staticText"},
            {name: "name", title: "نام", type: "staticText"},
            {name: "lastName", title: "نام خانوادگی", type: "staticText"},
            {name: "educationLevel", title: "مدرک تحصیلی", type: "staticText"},
            {name: "educationMajor", title: "رشته", type: "staticText"},
            {name: "currentPostTitle", title: "پست فعلی", type: "staticText"},
            {name: "postTitle", title: "پست پیشنهادی", type: "staticText"},
            {name: "affairs", title: "امور", type: "staticText"},
            {name: "post", title: "کدپست پیشنهادی", type: "staticText"},
            {name: "operationalRoleTitles", title: "گروه های کاری", type: "staticText"},
            {name: "competenceReqId", hidden: true}
        ]
    });
    let RestDataSource_Request_Item_Experts_Opinion = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>"},
            {name: "code", title: "<spring:message code="code"/>"}
        ],
        fetchDataURL: parameterValueUrl + "/listByCode/requestItemExpertsOpinion"
    });
    let RestDataSource_Parallel_RequestItem_Courses = isc.TrDS.create({
        fields: [
            {name: "courseCode", title: "<spring:message code="course.code"/>"},
            {name: "courseTitle", title: "<spring:message code="course.title"/>"},
            {name: "categoryTitle", title: "<spring:message code="category"/>"},
            {name: "subCategoryTitle", title: "<spring:message code="subcategory"/>"},
            {name: "priority", title: "<spring:message code="priority"/>"},
            {name: "requestItemProcessDetailId", hidden: true},
            {name: "isPassed", hidden: true}
        ]
    });
    let RestDataSource_Expert_Opinion_Courses = isc.TrDS.create({
        fields: [
            {name: "courseCode", title: "<spring:message code="course.code"/>", width: "10%"},
            {name: "courseTitle", title: "<spring:message code="course.title"/>", width: "10%"},
            {name: "categoryTitle", title: "<spring:message code="category"/>", width: "10%"},
            {name: "subCategoryTitle", title: "<spring:message code="subcategory"/>", width: "10%"},
            {name: "priority", title: "<spring:message code="priority"/>", width: "10%"},
            {name: "requestItemProcessDetailId", hidden: true}
        ]
    });
    let RestDataSource_Experts = isc.TrDS.create({
        fields: [
            {name: "nationalCode", title: "<spring:message code="national.code"/>", width: "10%"},
            {name: "firstName", title: "<spring:message code="firstName"/>", width: "10%"},
            {name: "lastName", title: "<spring:message code="lastName"/>", width: "10%"},
            {name: "generalOpinion", title: "نظر کلی کارشناس", width: "10%"}
        ]
    });

//--------------------------------------------------- Process Layout ---------------------------------------------------

    let ToolStripButton_Refresh_Processes_UserPortfolio = isc.ToolStripButtonRefresh.create({
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_Processes_UserPortfolio.invalidateCache();
            ListGrid_Processes_UserPortfolio.clearFilterValues();
            ListGrid_Processes_History_UserPortfolio.setData([]);
        }
    });
    let ToolStripButton_Show_Processes_UserPortfolio = isc.ToolStripButton.create({
        title: "نمایش جزییات و تکمیل فرایند",
        click: function () {
            let record = ListGrid_Processes_UserPortfolio.getSelectedRecord();
            if (record == null) {
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            } else {

                if (record.title.includes("صلاحیت علمی و فنی") && record.name.includes("بررسی کارشناس ارشد برنامه ریزی"))
                    showParallelRequestItemProcess(record);
                else if (record.title.includes("صلاحیت علمی و فنی") && record.name.includes("بررسی رئیس برنامه ریزی جهت تعیین وضعیت"))
                    showRequestItemProcessToDetermineStatus(record);
                else if (record.title.includes("صلاحیت علمی و فنی") && record.name.includes("بررسی رئیس اجرا"))
                    showRequestItemProcessStatusToRunChief(record);

                else if (record.title.includes("صلاحیت علمی و فنی") && record.name.includes("بررسی سرپرست اجرا"))
                    showRequestItemProcessStatusToRunSupervisor(record);
                else if (record.title.includes("صلاحیت علمی و فنی") && record.name.includes("بررسی کارشناس اجرا"))
                    showRequestItemProcessStatusToRunExperts(record);
                // else if (record.title.includes("صلاحیت علمی و فنی") && record.name.includes("تایید سرپرست اجرا"))
                //     showRequestItemProcessStatusToRunSupervisorForApproval(record);
                // else if (record.title.includes("صلاحیت علمی و فنی") && record.name.includes("تایید رئیس اجرا"))
                //     showRequestItemProcessStatusToRunChiefForApproval(record);
                // else if (record.title.includes("صلاحیت علمی و فنی") && record.name.includes("بررسی / تایید رئیس برنامه ریزی"))
                //     showRequestItemProcessStatusToPlanningChiefForApproval(record);

                // else if (record.title.includes("صلاحیت علمی و فنی") && record.name === "بررسی کارشناس انتصاب سمت - دوره های غیر انتصاب")
                //     showRequestItemProcessToAppointmentExpertNoLetter(record);
                else if (record.title.includes("صلاحیت علمی و فنی") && record.name.includes("بررسی کارشناس انتصاب سمت"))
                    showRequestItemProcessToAppointmentExpert(record);

                else if (record.title.includes("درخواست صدور گواهی نامه آموزشی") && record.name.includes("بررسی مسئول صدور گواهی نامه"))
                    showTrainingCertificationProcessToCertificationResponsible(record);
                else if (record.title.includes("درخواست صدور گواهی نامه آموزشی") && record.name.includes("بررسی مسئول مالی"))
                    showTrainingCertificationProcessToFinancialResponsible(record);
                else if (record.title.includes("درخواست صدور گواهی نامه آموزشی") && record.name.includes("بررسی نهایی مسئول صدور گواهی نامه"))
                    showTrainingCertificationProcessToCertificationResponsibleForApproval(record);
                else if (record.title.includes("درخواست صدور گواهی نامه آموزشی") && record.name.includes("تایید مدیر آموزش مجتمع"))
                    showTrainingCertificationProcessToTrainingManager(record);
                else if (record.title.includes("درخواست صدور گواهی نامه آموزشی") && record.name.includes("در انتظار صدور گواهی نامه"))
                    showTrainingCertificationProcessToCertificationResponsibleForIssuing(record);
                else
                    showProcessAndCompletion(record);
            }
        }
    });
    let ToolStripButton_InProgress_Workflow_UserPortfolio = isc.ToolStripButton.create({
        title: "به جریان انداختن فرآیند",
        click: function () {
            let record = ListGrid_Processes_UserPortfolio.getSelectedRecord();
            if (record == null) {
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            } else {
                if (record.title.includes("درخواست صدور گواهی نامه آموزشی") && record.name.includes("بررسی مسئول صدور گواهی نامه"))
                    reAssignTrainingCertificationTask(record);
                else if (record.title.includes("صلاحیت علمی و فنی") && record.name.includes("بررسی رئیس برنامه ریزی"))
                    reAssignToPlanningChiefFromExpert(record);
                else
                    reAssignTask(record);
            }
        }
    });
    let ToolStripButton_Group_Confirm_UserPortfolio = isc.ToolStripButton.create({
        title: "تایید گروهی",
        click: function () {
            let records = ListGrid_Processes_UserPortfolio.getSelectedRecords();
            if (records[0].title.includes("صلاحیت علمی و فنی") && records[0].name === "بررسی رئیس برنامه ریزی") {
                confirmGroupProcess(records);
            } else if (records[0].title.includes("صلاحیت علمی و فنی") && records[0].name === "بررسی کارشناس ارشد برنامه ریزی") {
                confirmGroupParallelRequestItemProcess(records);
            } else if (records[0].title.includes("صلاحیت علمی و فنی") && records[0].name === "بررسی رئیس برنامه ریزی جهت تعیین وضعیت") {
                confirmGroupRequestItemProcessToDetermineStatus(records);
            } else if (records[0].title.includes("صلاحیت علمی و فنی") && records[0].name.includes("بررسی / تایید رئیس برنامه ریزی")) {
                confirmGroupRequestItemProcessByPlanningChiefForApproval(records);
            } else if (records[0].title.includes("صلاحیت علمی و فنی") && records[0].name === "بررسی کارشناس انتصاب سمت") {
                showGroupRequestItemProcessToAppointmentExpert(records);
            } else {
                createDialog("info", "امکان تایید گروهی برای رکوردهای انتخابی وجود ندارد");
            }
        }
    });
    let ToolStripButton_Excel_Processes_UserPortfolio = isc.ToolStripButton.create({
        title: "ارسال به اکسل",
        click: function () {
            let records = ListGrid_Processes_UserPortfolio.getSelectedRecords();
            showGroupExcelParallelRequestItemProcess(records);
        }
    });
    let ToolStrip_Actions_Processes_UserPortfolio = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStripButton_Show_Processes_UserPortfolio,
            ToolStripButton_InProgress_Workflow_UserPortfolio,
            ToolStripButton_Group_Confirm_UserPortfolio,
            ToolStripButton_Excel_Processes_UserPortfolio,
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: "0px",
                members: [
                    ToolStripButton_Refresh_Processes_UserPortfolio
                ]
            })
        ]
    });

    let ListGrid_Processes_UserPortfolio = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        autoFetchData: true,
        dataSource: RestDataSource_Processes_UserPortfolio,
        sortDirection: "descending",
        fields: [
            {name: "name", showHover: true},
            {name: "deploymentId", hidden: true},
            {name: "objectId", hidden: true},
            {name: "objectType", hidden: true},
            {name: "tenantId", hidden: true},
            {name: "approved", hidden: true},
            {name: "createBy"},
            {name: "assignFrom", hidden: true},
            {name: "title", showHover: true},
            {name: "processInstanceId", hidden: true},
            {name: "processDefinitionId", hidden: true},
            {name: "taskId", hidden: true},
            {name: "tenantTitle", hidden: true},
            {name: "date"},
            {name: "processStartTime"},
            {name: "taskDefinitionKey", hidden: true},
            {name: "processDefinitionKey", hidden: true},
            {name: "returnReason"}
        ],
        showHoverComponents: true,
        sortField: ["date"],
        dataPageSize: 50,
        showFilterEditor: true,
        filterOnKeypress: true,
        selectionUpdated: function (record) {

            let records = ListGrid_Processes_UserPortfolio.getSelectedRecords();
            let recordsName = records.map(item => item.name);

            if (records.size() > 1 && new Set(recordsName).size === 1) {
                ToolStripButton_Group_Confirm_UserPortfolio.setDisabled(false);
                if (recordsName.contains("بررسی کارشناس ارشد برنامه ریزی")) {
                    ToolStripButton_Excel_Processes_UserPortfolio.show();
                } else
                    ToolStripButton_Excel_Processes_UserPortfolio.hide();
            } else {
                if (new Set(recordsName).size === 2 && recordsName.includes("بررسی / تایید رئیس برنامه ریزی") && recordsName.includes("بررسی / تایید رئیس برنامه ریزی - ضمن خدمت") )
                    ToolStripButton_Group_Confirm_UserPortfolio.setDisabled(false);
                else
                    ToolStripButton_Group_Confirm_UserPortfolio.setDisabled(true);
                ToolStripButton_Excel_Processes_UserPortfolio.hide();
            }

            if (records.size() > 1)
                ToolStripButton_Show_Processes_UserPortfolio.setDisabled(true);
            else {
                if (record.approved === false) {
                    ToolStripButton_Show_Processes_UserPortfolio.setDisabled(true);
                    ToolStripButton_InProgress_Workflow_UserPortfolio.setDisabled(false);
                } else {
                    ToolStripButton_Show_Processes_UserPortfolio.setDisabled(false);
                    ToolStripButton_InProgress_Workflow_UserPortfolio.setDisabled(true);
                }
            }
        },
        recordClick: function(viewer, record) {
            showProcessHistory(record.processInstanceId);
        }
    });
    let VLayout_Processes_UserPortfolio = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            ToolStrip_Actions_Processes_UserPortfolio,
            ListGrid_Processes_UserPortfolio
        ]
    });

//------------------------------------------------ Process History Layout ----------------------------------------------

    let ToolStripButton_Refresh_Processes_History_UserPortfolio = isc.ToolStripButtonRefresh.create({
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_Processes_History_UserPortfolio.clearFilterValues();
            ListGrid_Processes_History_UserPortfolio.invalidateCache();
        }
    });
    let ToolStrip_Actions_Processes_History_UserPortfolio = isc.ToolStrip.create({
        width: "100%",
        members: [
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: "0px",
                members: [
                    // ToolStripButton_Refresh_Processes_History_UserPortfolio
                ]
            })
        ]
    });

    let ListGrid_Processes_History_UserPortfolio = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        autoFetchData: false,
        dataSource: RestDataSource_Processes_History_UserPortfolio,
        sortDirection: "descending",
        fields: [
            {name: "timeComing", title: "زمان ورود به کارتابل"},
            {name: "waitingTime", title: "زمان انتظار"},
            {name: "taskDefinitionKey", hidden: true},
            {name: "assignee", title: "منتسب شده به"},
            {name: "taskId", hidden: true},
            {name: "name", title: "فرایند"},
            {name: "post", title: "", hidden: true},
            {name: "approved", title: "تایید شده"}
        ],
        sortField: 0,
        dataPageSize: 50,
        showFilterEditor: true,
        filterOnKeypress: true
    });
    let VLayout_Processes_History_UserPortfolio = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            ToolStrip_Actions_Processes_History_UserPortfolio,
            ListGrid_Processes_History_UserPortfolio
        ]
    });

//----------------------------------------------------- Main Layout ----------------------------------------------------

    let HLayout_Main_UserPortfolio = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [
            VLayout_Processes_UserPortfolio,
            VLayout_Processes_History_UserPortfolio
        ]
    });

//------------------------------------------------------ Functions -----------------------------------------------------

    function showProcessAndCompletion(record) {

        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {

            let Window_Completion_Return = isc.Window.create({
                title: "عودت",
                autoSize: false,
                width: "30%",
                height: "20%",
                canDragReposition: true,
                canDragResize: true,
                autoDraw: false,
                autoCenter: true,
                isModal: false,
                items: [
                    isc.DynamicForm.create({
                        ID: "reasonForm",
                        width: "100%",
                        height: "75%",
                        autoFocus: "true",
                        cellPadding: 5,
                        fields: [
                            {
                                name: "returnReason",
                                title: "دلیل عودت",
                                type: "text",
                                required: true,
                                validators: [{
                                    validateOnExit: true,
                                    type: "lengthRange",
                                    min: 1,
                                    max: 250,
                                    stopOnError: true,
                                    errorMessage: "حداکثر تعداد کاراکتر مجاز 250 می باشد. "
                                }]
                            }
                        ]
                    }),
                    isc.HLayout.create({
                        width: "100%",
                        height: "25%",
                        align: "center",
                        membersMargin: 10,
                        members: [
                            isc.Button.create({
                                title: "<spring:message code='global.ok'/>",
                                click: function () {
                                    if (!reasonForm.validate())
                                        return;

                                    let baseUrl = "";
                                    let url =""
                                    let reviewTaskRequest={}
                                    let data={}

                                    if (record.title.includes("نیازسنجی")) {
                                        baseUrl = bpmsUrl;
                                        url="/needAssessment/processes/cancel-process/";
                                        let map_data = {
                                            "objectId": ListGrid_Processes_UserPortfolio.getSelectedRecord().objectId,
                                            "returnReason": reasonForm.getField("returnReason").getValue(),
                                            "assignTo": record.assignFrom,
                                            "objectType": ListGrid_Processes_UserPortfolio.getSelectedRecord().objectType
                                        };
                                        reviewTaskRequest = {
                                            variables:map_data,
                                            processInstanceId:record.processInstanceId,
                                            taskId: record.taskId,
                                            approve: false,
                                            userName: userUserName,
                                        };
                                    } else if (record.title.includes("شایستگی")) {
                                        baseUrl = bpmsUrl;
                                        url="/processes/cancel-process/";
                                        reviewTaskRequest  = {
                                            taskId: record.taskId,
                                            userName: userUserName,
                                            approve: false,
                                            processInstanceId:record.processInstanceId
                                        };
                                    } else if (record.title.includes("صلاحیت علمی و فنی")) {
                                        baseUrl = requestItemBPMSUrl;
                                        url="/processes/request-item/cancel-process/";
                                        let var_data = {
                                            "returnReason": reasonForm.getField("returnReason").getValue(),
                                            "assignTo": record.assignFrom
                                        };
                                        reviewTaskRequest  = {
                                            variables: var_data,
                                            taskId: record.taskId,
                                            userName: userUserName,
                                            approve: false,
                                            processInstanceId: record.processInstanceId
                                        };
                                    }

                                    data = {
                                        reviewTaskRequest: reviewTaskRequest,
                                        reason: reasonForm.getField("returnReason").getValue()
                                    }

                                    // TODO call return process API
                                    wait.show();
                                    isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url  , "POST", JSON.stringify(data), function (resp) {
                                        wait.close();
                                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                            window.close();
                                            createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                            ToolStripButton_Refresh_Processes_UserPortfolio.click();
                                        } else {
                                            window.close();
                                            createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                                        }
                                    }));
                                    Window_Completion_UserPortfolio.close();
                                    Window_Completion_Return.close();
                                }
                            }),
                            isc.Button.create({
                                title: "<spring:message code='cancel'/>",
                                click: function () {
                                    Window_Completion_Return.close();
                                }
                            })
                        ]
                    })
                ]
            });
            let DynamicForm_Completion_UserPortfolio = isc.DynamicForm.create({
                colWidths: ["10%", "80%", "10%"],
                width: "100%",
                height: "75%",
                numCols: "3",
                autoFocus: "true",
                cellPadding: 5,
                fields: [
                    {
                        name: "title",
                        title: "عنوان",
                        type: "staticText"
                    },
                    {
                        name: "createBy",
                        title: "ایجاد کننده فرایند",
                        type: "staticText"
                    },
                    {
                        name: "objectType",
                        type: "staticText"
                    }
                ]
            });
            let Button_Completion_Detail = isc.IButton.create({
                title: "مشاهده جزییات",
                align: "center",
                width: "120",
                click: function () {

                    if (record.title.includes("نیازسنجی")) {
                        showWindowDiffNeedsAssessment(ListGrid_Processes_UserPortfolio.getSelectedRecord().objectId, ListGrid_Processes_UserPortfolio.getSelectedRecord().objectType, "", false);
                    } else if (record.title.includes("شایستگی") || record.title.includes("صلاحیت علمی و فنی")) {
                        showProcessDetail(record.name, record.processInstanceId);
                    }
                }
            });
            let Button_Completion_Confirm = isc.IButton.create({
                title: "تایید فرایند",
                align: "center",
                width: "120",
                click: function () {

                    isc.Dialog.create({
                        message: "آیا اطمینان دارید؟",
                        icon: "[SKIN]ask.png",
                        buttons: [
                            isc.Button.create({title: "<spring:message code="yes"/>"}),
                            isc.Button.create({title: "<spring:message code="global.no"/>"})
                        ],
                        buttonClick: function (button, index) {

                            if (index === 0) {
                                confirmProcess(record, Window_Completion_UserPortfolio);
                            }
                            this.hide();
                        }
                    });
                }
            });
            let Button_Completion_Return = isc.IButton.create({
                title: "عودت",
                align: "center",
                width: "120",
                click: function () {
                    Window_Completion_Return.show();
                }
            });
            let Button_Completion_Close = isc.IButton.create({
                title: "بستن",
                align: "center",
                width: "120",
                click: function () {
                    Window_Completion_UserPortfolio.close();
                }
            });
            let HLayout_Completion_UserPortfolio = isc.HLayout.create({
                width: "100%",
                height: "25%",
                align: "center",
                membersMargin: 10,
                members: [
                    Button_Completion_Detail,
                    Button_Completion_Confirm,
                    Button_Completion_Return,
                    Button_Completion_Close
                ]
            });
            let Window_Completion_UserPortfolio = isc.Window.create({
                title: "نمایش جزییات و تکمیل فرایند",
                autoSize: false,
                width: "40%",
                height: "20%",
                canDragReposition: true,
                canDragResize: true,
                autoDraw: false,
                autoCenter: true,
                isModal: false,
                items: [
                    DynamicForm_Completion_UserPortfolio,
                    HLayout_Completion_UserPortfolio
                ]
            });

            DynamicForm_Completion_UserPortfolio.setValue("title", record.title);
            DynamicForm_Completion_UserPortfolio.setValue("createBy", record.createBy);

            if (record.title.includes("نیازسنجی")) {

                DynamicForm_Completion_UserPortfolio.getItem("objectType").title = "نوع";
                DynamicForm_Completion_UserPortfolio.setValue("objectType", setTitle(record.objectType));
            } else if (record.title.includes("شایستگی")) {

                DynamicForm_Completion_UserPortfolio.getItem("objectType").title = "نوع";
                DynamicForm_Completion_UserPortfolio.setValue("objectType", "شایستگی");
            } else if (record.title.includes("صلاحیت علمی و فنی")) {

                DynamicForm_Completion_UserPortfolio.getItem("objectType").title = "توضیحات";
                DynamicForm_Completion_UserPortfolio.setValue("objectType", "درخواست با شماره " + record.requestNo);
            }
            Window_Completion_UserPortfolio.show();
        }
    }
    function showParallelRequestItemProcess(record) {

        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {

            let Window_Parallel_RequestItem_Return = isc.Window.create({
                title: "عودت",
                autoSize: false,
                width: "30%",
                height: "20%",
                canDragReposition: true,
                canDragResize: true,
                autoDraw: false,
                autoCenter: true,
                isModal: false,
                items: [
                    isc.DynamicForm.create({
                        ID: "reasonForm",
                        width: "100%",
                        height: "75%",
                        autoFocus: "true",
                        cellPadding: 5,
                        fields: [
                            {
                                name: "returnReason",
                                title: "دلیل عودت",
                                type: "text",
                                required: true,
                                validators: [{
                                    validateOnExit: true,
                                    type: "lengthRange",
                                    min: 1,
                                    max: 250,
                                    stopOnError: true,
                                    errorMessage: "حداکثر تعداد کاراکتر مجاز 250 می باشد. "
                                }]
                            }
                        ]
                    }),
                    isc.HLayout.create({
                        width: "100%",
                        height: "25%",
                        align: "center",
                        membersMargin: 10,
                        members: [
                            isc.Button.create({
                                title: "<spring:message code='global.ok'/>",
                                click: function () {
                                    if (!reasonForm.validate())
                                        return;

                                    let baseUrl = requestItemBPMSUrl;
                                    let url = "/processes/parallel/request-item/cancel-process";
                                    let var_data = {
                                        "returnReason": reasonForm.getField("returnReason").getValue(),
                                    };
                                    let reviewTaskRequest = {
                                        variables: var_data,
                                        taskId: record.taskId,
                                        userName: userUserName,
                                        approve: false,
                                        processInstanceId: record.processInstanceId
                                    };

                                    let data = {
                                        reviewTaskRequest: reviewTaskRequest,
                                        reason: reasonForm.getField("returnReason").getValue()
                                    }

                                    wait.show();
                                    isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url, "POST", JSON.stringify(data), function (resp) {
                                        wait.close();
                                        let response = JSON.parse(resp.httpResponseText);
                                        createDialog("info", response.message);
                                        ToolStripButton_Refresh_Processes_UserPortfolio.click();
                                    }));
                                    Window_Parallel_RequestItem_Completion.close();
                                    Window_Parallel_RequestItem_Return.close();
                                }
                            }),
                            isc.Button.create({
                                title: "<spring:message code='cancel'/>",
                                click: function () {
                                    Window_Parallel_RequestItem_Return.close();
                                }
                            })
                        ]
                    })
                ]
            });
            let DynamicForm_Parallel_RequestItem_Completion = isc.DynamicForm.create({
                colWidths: ["25%", "75%"],
                width: "100%",
                height: "15%",
                numCols: "2",
                autoFocus: "true",
                cellPadding: 5,
                fields: [
                    {
                        name: "title",
                        title: "عنوان",
                        type: "staticText"
                    },
                    {
                        name: "createBy",
                        title: "ایجاد کننده فرایند",
                        type: "staticText"
                    },
                    {
                        name: "description",
                        title: "توضیحات",
                        type: "staticText"
                    },
                    {
                        name: "postUpdateStatus",
                        title: "وضعیت نیازسنجی پست",
                        type: "staticText",
                        width: "100%"
                    },
                    {
                        name: "expertOpinion",
                        title: "نظر کارشناس ارشد",
                        width: "100%",
                        hidden: true,
                        optionDataSource: RestDataSource_Request_Item_Experts_Opinion,
                        displayField: "title",
                        autoFetchData: true,
                        valueField: "id",
                        textAlign: "center",
                        required: true,
                        textMatchStyle: "substring",
                        pickListFields: [
                            {name: "title", autoFitWidth: true}
                        ],
                        pickListProperties: {
                            sortField: 0,
                            showFilterEditor: false
                        }
                    },
                    {
                        name: "priorities",
                        title: "انتخاب اولویت ها",
                        type: "selectItem",
                        multiple: true,
                        valueMap: {
                            "ضروری ضمن خدمت": "ضروری ضمن خدمت",
                            "ضروری انتصاب سمت": "ضروری انتصاب سمت",
                            "عملکردی بهبود": "عملکردی بهبود",
                            "عملکردی توسعه": "عملکردی توسعه",
                        },
                        vertical: false,
                        changed: function (form, item, value) {
                            let allRecords = ListGrid_Parallel_RequestItem_Courses.getData().localData;
                            if (value) {
                                let selectRecords = ListGrid_Parallel_RequestItem_Courses.getData().localData.filter(item => value.includes(item.priority));
                                ListGrid_Parallel_RequestItem_Courses.deselectRecords(allRecords);
                                ListGrid_Parallel_RequestItem_Courses.selectRecords(selectRecords);
                            } else {
                                ListGrid_Parallel_RequestItem_Courses.deselectRecords(allRecords);
                            }
                        }
                    }
                ]
            });
            let ListGrid_Parallel_RequestItem_Courses = isc.ListGrid.create({
                width: "100%",
                height: "75%",
                autoFetchData: true,
                selectionType: "simple",
                selectCellTextOnClick: true,
                selectionAppearance: "checkbox",
                dataSource: RestDataSource_Parallel_RequestItem_Courses,
                sortDirection: "descending",
                fields: [
                    {name: "courseCode"},
                    {name: "courseTitle", showHover: true},
                    {name: "categoryTitle", showHover: true},
                    {name: "subCategoryTitle", showHover: true},
                    {name: "priority"},
                    {name: "requestItemProcessDetailId", hidden: true}
                ],
                showHoverComponents: true,
                showFilterEditor: true,
                filterOnKeypress: true,
                gridComponents: [
                    isc.Label.create({
                        contents: "<span style='color: #b30e0e; font-weight: bold'>دوره هایی که نیاز به گذراندن دارند از لیست زیر انتخاب کنید</span>",
                        align: "center",
                        height: 15,
                    }), "filterEditor", "header", "body"
                ]
            });
            let Button_Parallel_RequestItem_Completion_Detail = isc.IButton.create({
                title: "مشاهده جزییات",
                align: "center",
                width: "120",
                click: function () {
                    showProcessDetail(record.name, record.processInstanceId);
                }
            });
            let Button_Parallel_RequestItem_Completion_Confirm = isc.IButton.create({
                title: "تایید فرایند",
                align: "center",
                width: "120",
                click: function () {

                    if (!DynamicForm_Parallel_RequestItem_Completion.validate())
                        return;

                    isc.Dialog.create({
                        message: "آیا اطمینان دارید؟",
                        icon: "[SKIN]ask.png",
                        buttons: [
                            isc.Button.create({title: "<spring:message code="yes"/>"}),
                            isc.Button.create({title: "<spring:message code="global.no"/>"})
                        ],
                        buttonClick: function (button, index) {

                            if (index === 0) {
                                confirmParallelRequestItemProcess(record, ListGrid_Parallel_RequestItem_Courses, Window_Parallel_RequestItem_Completion);
                            }
                            this.hide();
                        }
                    });
                }
            });
            let Button_Parallel_RequestItem_Completion_Return = isc.IButton.create({
                title: "عودت",
                align: "center",
                width: "120",
                click: function () {
                    Window_Parallel_RequestItem_Return.show();
                }
            });
            let Button_Parallel_RequestItem_Completion_Close = isc.IButton.create({
                title: "بستن",
                align: "center",
                width: "120",
                click: function () {
                    Window_Parallel_RequestItem_Completion.close();
                }
            });
            let HLayout_Parallel_RequestItem_Completion = isc.HLayout.create({
                width: "100%",
                height: "5%",
                align: "center",
                membersMargin: 10,
                members: [
                    Button_Parallel_RequestItem_Completion_Detail,
                    Button_Parallel_RequestItem_Completion_Confirm,
                    Button_Parallel_RequestItem_Completion_Return,
                    Button_Parallel_RequestItem_Completion_Close
                ]
            });
            let Window_Parallel_RequestItem_Completion = isc.Window.create({
                title: "نمایش جزییات و تکمیل فرایند",
                autoSize: false,
                width: "50%",
                height: "70%",
                canDragReposition: true,
                canDragResize: true,
                autoDraw: false,
                autoCenter: true,
                isModal: false,
                items: [
                    DynamicForm_Parallel_RequestItem_Completion,
                    ListGrid_Parallel_RequestItem_Courses,
                    HLayout_Parallel_RequestItem_Completion
                ]
            });

            if (record.assigneeList.size() === 1)
                Button_Parallel_RequestItem_Completion_Return.show();
            else
                Button_Parallel_RequestItem_Completion_Return.hide();

            DynamicForm_Parallel_RequestItem_Completion.setValue("title", record.title);
            DynamicForm_Parallel_RequestItem_Completion.setValue("createBy", record.createBy);
            DynamicForm_Parallel_RequestItem_Completion.setValue("description", "درخواست با شماره " + record.requestNo);

            isc.RPCManager.sendRequest(TrDSRequest(trainingPostUrl + "/getNeedAssessmentInfo/byRequestItemId?requestItemId=" + record.requestItemId, "GET", null, function (resp) {
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    let data = JSON.parse(resp.httpResponseText);
                    let lastModifiedDate = data.lastModifiedDateNA !== undefined ? data.lastModifiedDateNA : "";
                    let modifiedBy = data.modifiedByNA !== undefined ? data.modifiedByNA : "";
                    DynamicForm_Parallel_RequestItem_Completion.setValue("postUpdateStatus", "تاریخ بروزرسانی: " + lastModifiedDate + " - بروزرسانی کننده: " + modifiedBy);
                } else {
                    DynamicForm_Parallel_RequestItem_Completion.setValue("postUpdateStatus", "پست وجود ندارد");
                }
                RestDataSource_Parallel_RequestItem_Courses.fetchDataURL = needsAssessmentUrl + "/by-training-post-code/spec-list/" + record.requestItemId;
                ListGrid_Parallel_RequestItem_Courses.invalidateCache();
                ListGrid_Parallel_RequestItem_Courses.fetchData();
                Window_Parallel_RequestItem_Completion.show();
            }));
        }
    }
    function showRequestItemProcessToDetermineStatus(record) {

        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {

            let DynamicForm_RequestItem_Determine_Status = isc.DynamicForm.create({
                colWidths: ["25%", "75%"],
                width: "100%",
                height: "85%",
                numCols: "2",
                autoFocus: "true",
                cellPadding: 5,
                fields: [
                    {
                        name: "title",
                        title: "عنوان",
                        type: "staticText"
                    },
                    {
                        name: "createBy",
                        title: "ایجاد کننده فرایند",
                        type: "staticText"
                    },
                    {
                        name: "description",
                        title: "توضیحات",
                        type: "staticText"
                    },
                    {
                        name: "chiefOpinion",
                        title: "نظر رئیس برنامه ریزی",
                        width: "100%",
                        optionDataSource: RestDataSource_Request_Item_Experts_Opinion,
                        displayField: "title",
                        autoFetchData: true,
                        valueField: "id",
                        textAlign: "center",
                        required: true,
                        textMatchStyle: "substring",
                        pickListFields: [
                            {name: "title", autoFitWidth: true}
                        ],
                        pickListProperties: {
                            sortField: 0,
                            showFilterEditor: false
                        }
                    }
                ]
            });
            let Button_RequestItem_Determine_Status_Experts_Opinion = isc.IButton.create({
                title: "مشاهده نظر کارشناسان",
                align: "center",
                width: "140",
                click: function () {
                    showExpertsOpinion(record);
                }
            });
            let Button_RequestItem_Determine_Status_Detail = isc.IButton.create({
                title: "مشاهده جزییات",
                align: "center",
                width: "140",
                click: function () {
                    showProcessDetail(record.name, record.processInstanceId);
                }
            });
            let Button_RequestItem_Determine_Status_Confirm = isc.IButton.create({
                title: "تایید فرایند",
                align: "center",
                width: "140",
                click: function () {

                    if (!DynamicForm_RequestItem_Determine_Status.validate())
                        return;

                    isc.Dialog.create({
                        message: "آیا اطمینان دارید؟",
                        icon: "[SKIN]ask.png",
                        buttons: [
                            isc.Button.create({title: "<spring:message code="yes"/>"}),
                            isc.Button.create({title: "<spring:message code="global.no"/>"})
                        ],
                        buttonClick: function (button, index) {

                            if (index === 0) {
                                let chiefOpinion = DynamicForm_RequestItem_Determine_Status.getValue("chiefOpinion");
                                confirmRequestItemProcessToDetermineStatus(record, chiefOpinion, Window_RequestItem_Determine_Status_Completion);
                            }
                            this.hide();
                        }
                    });
                }
            });
            let Button_RequestItem_Determine_Status_Close = isc.IButton.create({
                title: "بستن",
                align: "center",
                width: "140",
                click: function () {
                    Window_RequestItem_Determine_Status_Completion.close();
                }
            });
            let HLayout_RequestItem_Determine_Status_Completion = isc.HLayout.create({
                width: "100%",
                height: "15%",
                align: "center",
                membersMargin: 10,
                members: [
                    Button_RequestItem_Determine_Status_Experts_Opinion,
                    Button_RequestItem_Determine_Status_Detail,
                    Button_RequestItem_Determine_Status_Confirm,
                    Button_RequestItem_Determine_Status_Close
                ]
            });
            let Window_RequestItem_Determine_Status_Completion = isc.Window.create({
                title: "نمایش جزییات و تکمیل فرایند",
                autoSize: false,
                width: "50%",
                height: "25%",
                canDragReposition: true,
                canDragResize: true,
                autoDraw: false,
                autoCenter: true,
                isModal: false,
                items: [
                    DynamicForm_RequestItem_Determine_Status,
                    HLayout_RequestItem_Determine_Status_Completion
                ]
            });

            DynamicForm_RequestItem_Determine_Status.setValue("title", record.title);
            DynamicForm_RequestItem_Determine_Status.setValue("createBy", record.createBy);
            DynamicForm_RequestItem_Determine_Status.setValue("description", "درخواست با شماره " + record.requestNo);

            isc.RPCManager.sendRequest(TrDSRequest(requestItemUrl + "/planning-chief-opinion/" + record.requestItemId, "GET", null, function (resp) {
                if (resp.httpResponseCode === 200) {
                    let opinion = JSON.parse(resp.httpResponseText);
                    DynamicForm_RequestItem_Determine_Status.setValue("chiefOpinion", opinion.finalOpinionId);
                    Window_RequestItem_Determine_Status_Completion.show();
                }
            }));
        }
    }
    function showRequestItemProcessStatusToRunChief(record) {

        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {

            let DynamicForm_RequestItem_Show_Status = isc.DynamicForm.create({
                colWidths: ["25%", "75%"],
                width: "100%",
                height: "15%",
                numCols: "2",
                autoFocus: "true",
                cellPadding: 5,
                fields: [
                    {
                        name: "title",
                        title: "عنوان",
                        type: "staticText"
                    },
                    {
                        name: "createBy",
                        title: "ایجاد کننده فرایند",
                        type: "staticText"
                    },
                    {
                        name: "description",
                        title: "توضیحات",
                        type: "staticText"
                    },
                    {
                        name: "certificationStatus",
                        title: "وضعیت آموزشی",
                        width: "100%",
                        type: "staticText"
                    }
                ]
            });
            let ListGrid_RequestItem_Show_Courses = isc.ListGrid.create({
                width: "100%",
                height: "70%",
                sortDirection: "descending",
                selectCellTextOnClick: true,
                dataSource: RestDataSource_Parallel_RequestItem_Courses,
                fields: [
                    {name: "courseCode"},
                    {name: "courseTitle", showHover: true},
                    {name: "categoryTitle", showHover: true},
                    {name: "subCategoryTitle", showHover: true},
                    {name: "priority"},
                    {name: "requestItemProcessDetailId", hidden: true}
                ],
                showHoverComponents: true,
                showFilterEditor: true,
                filterOnKeypress: true,
                gridComponents: [
                    isc.Label.create({
                        contents: "<span style='color: #b30e0e; font-weight: bold'>دوره هایی که نیاز به گذراندن دارند</span>",
                        align: "center",
                        height: 15,
                    }), "filterEditor", "header", "body"
                ]
            });
            let Button_RequestItem_Show_Status_Detail = isc.IButton.create({
                title: "مشاهده جزییات",
                align: "center",
                width: "140",
                click: function () {
                    showProcessDetail(record.name, record.processInstanceId);
                }
            });
            let Button_RequestItem_Show_Status_Confirm = isc.IButton.create({
                title: "تایید فرایند",
                align: "center",
                width: "140",
                click: function () {

                    isc.Dialog.create({
                        message: "آیا اطمینان دارید؟",
                        icon: "[SKIN]ask.png",
                        buttons: [
                            isc.Button.create({title: "<spring:message code="yes"/>"}),
                            isc.Button.create({title: "<spring:message code="global.no"/>"})
                        ],
                        buttonClick: function (button, index) {

                            if (index === 0) {
                                confirmRequestItemProcessByRunChief(record, Window_RequestItem_Show_Status_Completion);
                            }
                            this.hide();
                        }
                    });
                }
            });
            let Button_RequestItem_Show_Status_Close = isc.IButton.create({
                title: "بستن",
                align: "center",
                width: "140",
                click: function () {
                    Window_RequestItem_Show_Status_Completion.close();
                }
            });
            let HLayout_RequestItem_Show_Status_Completion = isc.HLayout.create({
                width: "100%",
                height: "5%",
                align: "center",
                membersMargin: 10,
                members: [
                    Button_RequestItem_Show_Status_Detail,
                    Button_RequestItem_Show_Status_Confirm,
                    Button_RequestItem_Show_Status_Close
                ]
            });
            let Window_RequestItem_Show_Status_Completion = isc.Window.create({
                title: "نمایش جزییات و تکمیل فرایند",
                autoSize: false,
                width: "50%",
                height: "70%",
                canDragReposition: true,
                canDragResize: true,
                autoDraw: false,
                autoCenter: true,
                isModal: false,
                items: [
                    DynamicForm_RequestItem_Show_Status,
                    ListGrid_RequestItem_Show_Courses,
                    HLayout_RequestItem_Show_Status_Completion
                ]
            });

            DynamicForm_RequestItem_Show_Status.setValue("title", record.title);
            DynamicForm_RequestItem_Show_Status.setValue("createBy", record.createBy);
            DynamicForm_RequestItem_Show_Status.setValue("description", "درخواست با شماره " + record.requestNo);


            RestDataSource_Parallel_RequestItem_Courses.fetchDataURL = requestItemUrl + "/planning-chief-opinion/" + record.requestItemId;
            ListGrid_RequestItem_Show_Courses.fetchData(null, function (dsResponse, data, dsRequest) {

                if (dsResponse.httpResponseCode === 200) {
                    let resp = JSON.parse(dsResponse.httpResponseText);
                    DynamicForm_RequestItem_Show_Status.setValue("certificationStatus", resp.finalOpinion);
                    if (resp.courses !== undefined && resp.courses.length !== 0)
                        ListGrid_RequestItem_Show_Courses.setData(resp.courses);
                    else
                        ListGrid_RequestItem_Show_Courses.setData([]);
                    Window_RequestItem_Show_Status_Completion.show();
                }
            });
        }
    }
    function showRequestItemProcessStatusToRunSupervisor(record) {

        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {

            let DynamicForm_RequestItem_Show_Status = isc.DynamicForm.create({
                colWidths: ["25%", "75%"],
                width: "100%",
                height: "15%",
                numCols: "2",
                autoFocus: "true",
                cellPadding: 5,
                fields: [
                    {
                        name: "title",
                        title: "عنوان",
                        type: "staticText"
                    },
                    {
                        name: "createBy",
                        title: "ایجاد کننده فرایند",
                        type: "staticText"
                    },
                    {
                        name: "description",
                        title: "توضیحات",
                        type: "staticText"
                    },
                    {
                        name: "certificationStatus",
                        title: "وضعیت آموزشی",
                        width: "100%",
                        type: "staticText"
                    }
                ]
            });
            let ListGrid_RequestItem_Show_Courses = isc.ListGrid.create({
                width: "100%",
                height: "70%",
                sortDirection: "descending",
                selectCellTextOnClick: true,
                dataSource: RestDataSource_Parallel_RequestItem_Courses,
                fields: [
                    {name: "courseCode"},
                    {name: "courseTitle", showHover: true},
                    {name: "categoryTitle", showHover: true},
                    {name: "subCategoryTitle", showHover: true},
                    {name: "priority"},
                    {name: "requestItemProcessDetailId", hidden: true}
                ],
                showHoverComponents: true,
                showFilterEditor: true,
                filterOnKeypress: true,
                gridComponents: [
                    isc.Label.create({
                        contents: "<span style='color: #b30e0e; font-weight: bold'>دوره هایی که نیاز به گذراندن دارند</span>",
                        align: "center",
                        height: 15,
                    }), "filterEditor", "header", "body"
                ]
            });
            let Button_RequestItem_Show_Status_Detail = isc.IButton.create({
                title: "مشاهده جزییات",
                align: "center",
                width: "140",
                click: function () {
                    showProcessDetail(record.name, record.processInstanceId);
                }
            });
            let Button_RequestItem_Show_Status_Confirm = isc.IButton.create({
                title: "تایید فرایند",
                align: "center",
                width: "140",
                click: function () {

                    isc.Dialog.create({
                        message: "آیا اطمینان دارید؟",
                        icon: "[SKIN]ask.png",
                        buttons: [
                            isc.Button.create({title: "<spring:message code="yes"/>"}),
                            isc.Button.create({title: "<spring:message code="global.no"/>"})
                        ],
                        buttonClick: function (button, index) {

                            if (index === 0) {
                                confirmRequestItemProcessByRunSupervisor(record, Window_RequestItem_Show_Status_Completion);
                            }
                            this.hide();
                        }
                    });
                }
            });
            let Button_RequestItem_Show_Status_Close = isc.IButton.create({
                title: "بستن",
                align: "center",
                width: "140",
                click: function () {
                    Window_RequestItem_Show_Status_Completion.close();
                }
            });
            let HLayout_RequestItem_Show_Status_Completion = isc.HLayout.create({
                width: "100%",
                height: "5%",
                align: "center",
                membersMargin: 10,
                members: [
                    Button_RequestItem_Show_Status_Detail,
                    Button_RequestItem_Show_Status_Confirm,
                    Button_RequestItem_Show_Status_Close
                ]
            });
            let Window_RequestItem_Show_Status_Completion = isc.Window.create({
                title: "نمایش جزییات و تکمیل فرایند",
                autoSize: false,
                width: "50%",
                height: "70%",
                canDragReposition: true,
                canDragResize: true,
                autoDraw: false,
                autoCenter: true,
                isModal: false,
                items: [
                    DynamicForm_RequestItem_Show_Status,
                    ListGrid_RequestItem_Show_Courses,
                    HLayout_RequestItem_Show_Status_Completion
                ]
            });

            DynamicForm_RequestItem_Show_Status.setValue("title", record.title);
            DynamicForm_RequestItem_Show_Status.setValue("createBy", record.createBy);
            DynamicForm_RequestItem_Show_Status.setValue("description", "درخواست با شماره " + record.requestNo);


            RestDataSource_Parallel_RequestItem_Courses.fetchDataURL = requestItemUrl + "/related-courses-to-run/" + record.requestItemId + "/" + false;
            wait.show();
            ListGrid_RequestItem_Show_Courses.fetchData(null, function (dsResponse, data, dsRequest) {
                wait.close();
                if (dsResponse.httpResponseCode === 200) {
                    let resp = JSON.parse(dsResponse.httpResponseText);
                    DynamicForm_RequestItem_Show_Status.setValue("certificationStatus", resp.finalOpinion);
                    if (resp.courses !== undefined && resp.courses.length !== 0) {
                        // if (record.name.includes("انتصاب سمت"))
                        //     ListGrid_RequestItem_Show_Courses.setData(resp.courses.filter(item => item.priority.contains("انتصاب سمت")));
                        // else if (record.name.includes("ضمن خدمت"))
                        //     ListGrid_RequestItem_Show_Courses.setData(resp.courses);
                        // else
                        ListGrid_RequestItem_Show_Courses.setData(resp.courses.filter(item => item.courseCode === record.courseCode));
                    } else
                        ListGrid_RequestItem_Show_Courses.setData([]);
                    Window_RequestItem_Show_Status_Completion.show();
                }
            });
        }
    }
    function showRequestItemProcessStatusToRunExperts(record) {

        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {

            let DynamicForm_RequestItem_Show_Status = isc.DynamicForm.create({
                colWidths: ["25%", "75%"],
                width: "100%",
                height: "15%",
                numCols: "2",
                autoFocus: "true",
                cellPadding: 5,
                fields: [
                    {
                        name: "title",
                        title: "عنوان",
                        type: "staticText"
                    },
                    {
                        name: "createBy",
                        title: "ایجاد کننده فرایند",
                        type: "staticText"
                    },
                    {
                        name: "description",
                        title: "توضیحات",
                        type: "staticText"
                    },
                    {
                        name: "certificationStatus",
                        title: "وضعیت آموزشی",
                        width: "100%",
                        type: "staticText"
                    }
                ]
            });
            let ListGrid_RequestItem_Show_Courses = isc.ListGrid.create({
                width: "100%",
                height: "70%",
                sortDirection: "descending",
                selectCellTextOnClick: true,
                dataSource: RestDataSource_Parallel_RequestItem_Courses,
                fields: [
                    {name: "courseCode"},
                    {name: "courseTitle", showHover: true},
                    {name: "categoryTitle", showHover: true},
                    {name: "subCategoryTitle", showHover: true},
                    {name: "priority"},
                    {name: "requestItemProcessDetailId", hidden: true},
                    {name: "isPassed", hidden: true}
                ],
                showHoverComponents: true,
                showFilterEditor: true,
                filterOnKeypress: true,
                gridComponents: [
                    isc.Label.create({
                        contents: "<span style='color: #b30e0e; font-weight: bold'>دوره هایی که نیاز به گذراندن دارند</span>",
                        align: "center",
                        height: 15,
                    }), "filterEditor", "header", "body"
                ]
            });
            let Button_RequestItem_Show_Status_Detail = isc.IButton.create({
                title: "مشاهده جزییات",
                align: "center",
                width: "140",
                click: function () {
                    showProcessDetail(record.name, record.processInstanceId);
                }
            });
            let Button_RequestItem_Show_Status_Confirm = isc.IButton.create({
                title: "تایید فرایند",
                align: "center",
                width: "140",
                click: function () {

                    if (ListGrid_RequestItem_Show_Courses.getData().some(item => item.passed === false) === true) {
                        createDialog("info", "شخص دوره مورد نظر را نگذرانده است.");
                    } else {
                        isc.Dialog.create({
                            message: "آیا اطمینان دارید؟",
                            icon: "[SKIN]ask.png",
                            buttons: [
                                isc.Button.create({title: "<spring:message code="yes"/>"}),
                                isc.Button.create({title: "<spring:message code="global.no"/>"})
                            ],
                            buttonClick: function (button, index) {

                                if (index === 0) {
                                    confirmRequestItemProcessByRunExperts(record, Window_RequestItem_Show_Status_Completion);
                                }
                                this.hide();
                            }
                        });
                    }
                }
            });
            let Button_RequestItem_Show_Status_Close = isc.IButton.create({
                title: "بستن",
                align: "center",
                width: "140",
                click: function () {
                    Window_RequestItem_Show_Status_Completion.close();
                }
            });
            let HLayout_RequestItem_Show_Status_Completion = isc.HLayout.create({
                width: "100%",
                height: "5%",
                align: "center",
                membersMargin: 10,
                members: [
                    Button_RequestItem_Show_Status_Detail,
                    Button_RequestItem_Show_Status_Confirm,
                    Button_RequestItem_Show_Status_Close
                ]
            });
            let Window_RequestItem_Show_Status_Completion = isc.Window.create({
                title: "نمایش جزییات و تکمیل فرایند",
                autoSize: false,
                width: "50%",
                height: "70%",
                canDragReposition: true,
                canDragResize: true,
                autoDraw: false,
                autoCenter: true,
                isModal: false,
                items: [
                    DynamicForm_RequestItem_Show_Status,
                    ListGrid_RequestItem_Show_Courses,
                    HLayout_RequestItem_Show_Status_Completion
                ]
            });

            DynamicForm_RequestItem_Show_Status.setValue("title", record.title);
            DynamicForm_RequestItem_Show_Status.setValue("createBy", record.createBy);
            DynamicForm_RequestItem_Show_Status.setValue("description", "درخواست با شماره " + record.requestNo);


            RestDataSource_Parallel_RequestItem_Courses.fetchDataURL = requestItemUrl + "/related-courses-to-run/" + record.requestItemId + "/" + true;
            wait.show();
            ListGrid_RequestItem_Show_Courses.fetchData(null, function (dsResponse, data, dsRequest) {
                wait.close();
                if (dsResponse.httpResponseCode === 200) {
                    let resp = JSON.parse(dsResponse.httpResponseText);
                    DynamicForm_RequestItem_Show_Status.setValue("certificationStatus", resp.finalOpinion);
                    if (resp.courses !== undefined && resp.courses.length !== 0) {
                        // if (record.name.includes("انتصاب سمت"))
                        //     ListGrid_RequestItem_Show_Courses.setData(resp.courses.filter(item => item.priority.contains("انتصاب سمت")));
                        // else if (record.name.includes("ضمن خدمت"))
                        //     ListGrid_RequestItem_Show_Courses.setData(resp.courses);
                        // else
                        ListGrid_RequestItem_Show_Courses.setData(resp.courses.filter(item => item.courseCode === record.courseCode));
                    } else
                        ListGrid_RequestItem_Show_Courses.setData([]);
                    Window_RequestItem_Show_Status_Completion.show();
                }
            });
        }
    }
    <%--function showRequestItemProcessStatusToRunSupervisorForApproval(record) {--%>

    <%--    if (record == null) {--%>
    <%--        createDialog("info", "<spring:message code='msg.no.records.selected'/>");--%>
    <%--    } else {--%>

    <%--        let DynamicForm_RequestItem_Show_Status = isc.DynamicForm.create({--%>
    <%--            colWidths: ["25%", "75%"],--%>
    <%--            width: "100%",--%>
    <%--            height: "15%",--%>
    <%--            numCols: "2",--%>
    <%--            autoFocus: "true",--%>
    <%--            cellPadding: 5,--%>
    <%--            fields: [--%>
    <%--                {--%>
    <%--                    name: "title",--%>
    <%--                    title: "عنوان",--%>
    <%--                    type: "staticText"--%>
    <%--                },--%>
    <%--                {--%>
    <%--                    name: "createBy",--%>
    <%--                    title: "ایجاد کننده فرایند",--%>
    <%--                    type: "staticText"--%>
    <%--                },--%>
    <%--                {--%>
    <%--                    name: "description",--%>
    <%--                    title: "توضیحات",--%>
    <%--                    type: "staticText"--%>
    <%--                },--%>
    <%--                {--%>
    <%--                    name: "certificationStatus",--%>
    <%--                    title: "وضعیت آموزشی",--%>
    <%--                    width: "100%",--%>
    <%--                    type: "staticText"--%>
    <%--                }--%>
    <%--            ]--%>
    <%--        });--%>
    <%--        let ListGrid_RequestItem_Show_Courses = isc.ListGrid.create({--%>
    <%--            width: "100%",--%>
    <%--            height: "70%",--%>
    <%--            sortDirection: "descending",--%>
    <%--            selectCellTextOnClick: true,--%>
    <%--            dataSource: RestDataSource_Parallel_RequestItem_Courses,--%>
    <%--            fields: [--%>
    <%--                {name: "courseCode"},--%>
    <%--                {name: "courseTitle", showHover: true},--%>
    <%--                {name: "categoryTitle", showHover: true},--%>
    <%--                {name: "subCategoryTitle", showHover: true},--%>
    <%--                {name: "priority"},--%>
    <%--                {name: "requestItemProcessDetailId", hidden: true}--%>
    <%--            ],--%>
    <%--            showHoverComponents: true,--%>
    <%--            showFilterEditor: true,--%>
    <%--            filterOnKeypress: true,--%>
    <%--            gridComponents: [--%>
    <%--                isc.Label.create({--%>
    <%--                    contents: "<span style='color: #b30e0e; font-weight: bold'>دوره های گذرانده</span>",--%>
    <%--                    align: "center",--%>
    <%--                    height: 15,--%>
    <%--                }), "filterEditor", "header", "body"--%>
    <%--            ]--%>
    <%--        });--%>
    <%--        let Button_RequestItem_Show_Status_Detail = isc.IButton.create({--%>
    <%--            title: "مشاهده جزییات",--%>
    <%--            align: "center",--%>
    <%--            width: "140",--%>
    <%--            click: function () {--%>
    <%--                showProcessDetail(record.name, record.processInstanceId);--%>
    <%--            }--%>
    <%--        });--%>
    <%--        let Button_RequestItem_Show_Status_Confirm = isc.IButton.create({--%>
    <%--            title: "تایید فرایند",--%>
    <%--            align: "center",--%>
    <%--            width: "140",--%>
    <%--            click: function () {--%>

    <%--                isc.Dialog.create({--%>
    <%--                    message: "آیا اطمینان دارید؟",--%>
    <%--                    icon: "[SKIN]ask.png",--%>
    <%--                    buttons: [--%>
    <%--                        isc.Button.create({title: "<spring:message code="yes"/>"}),--%>
    <%--                        isc.Button.create({title: "<spring:message code="global.no"/>"})--%>
    <%--                    ],--%>
    <%--                    buttonClick: function (button, index) {--%>

    <%--                        if (index === 0) {--%>
    <%--                            confirmRequestItemProcessByRunSupervisorForApproval(record, Window_RequestItem_Show_Status_Completion);--%>
    <%--                        }--%>
    <%--                        this.hide();--%>
    <%--                    }--%>
    <%--                });--%>
    <%--            }--%>
    <%--        });--%>
    <%--        let Button_RequestItem_Show_Status_Close = isc.IButton.create({--%>
    <%--            title: "بستن",--%>
    <%--            align: "center",--%>
    <%--            width: "140",--%>
    <%--            click: function () {--%>
    <%--                Window_RequestItem_Show_Status_Completion.close();--%>
    <%--            }--%>
    <%--        });--%>
    <%--        let HLayout_RequestItem_Show_Status_Completion = isc.HLayout.create({--%>
    <%--            width: "100%",--%>
    <%--            height: "5%",--%>
    <%--            align: "center",--%>
    <%--            membersMargin: 10,--%>
    <%--            members: [--%>
    <%--                Button_RequestItem_Show_Status_Detail,--%>
    <%--                Button_RequestItem_Show_Status_Confirm,--%>
    <%--                Button_RequestItem_Show_Status_Close--%>
    <%--            ]--%>
    <%--        });--%>
    <%--        let Window_RequestItem_Show_Status_Completion = isc.Window.create({--%>
    <%--            title: "نمایش جزییات و تکمیل فرایند",--%>
    <%--            autoSize: false,--%>
    <%--            width: "50%",--%>
    <%--            height: "70%",--%>
    <%--            canDragReposition: true,--%>
    <%--            canDragResize: true,--%>
    <%--            autoDraw: false,--%>
    <%--            autoCenter: true,--%>
    <%--            isModal: false,--%>
    <%--            items: [--%>
    <%--                DynamicForm_RequestItem_Show_Status,--%>
    <%--                ListGrid_RequestItem_Show_Courses,--%>
    <%--                HLayout_RequestItem_Show_Status_Completion--%>
    <%--            ]--%>
    <%--        });--%>

    <%--        DynamicForm_RequestItem_Show_Status.setValue("title", record.title);--%>
    <%--        DynamicForm_RequestItem_Show_Status.setValue("createBy", record.createBy);--%>
    <%--        DynamicForm_RequestItem_Show_Status.setValue("description", "درخواست با شماره " + record.requestNo);--%>


    <%--        RestDataSource_Parallel_RequestItem_Courses.fetchDataURL = requestItemUrl + "/related-courses-to-run/" + record.requestItemId + "/" + false;--%>
    <%--        wait.show();--%>
    <%--        ListGrid_RequestItem_Show_Courses.fetchData(null, function (dsResponse, data, dsRequest) {--%>
    <%--            wait.close();--%>
    <%--            if (dsResponse.httpResponseCode === 200) {--%>
    <%--                let resp = JSON.parse(dsResponse.httpResponseText);--%>
    <%--                DynamicForm_RequestItem_Show_Status.setValue("certificationStatus", resp.finalOpinion);--%>
    <%--                if (resp.courses !== undefined && resp.courses.length !== 0) {--%>
    <%--                    if (record.name.includes("انتصاب سمت"))--%>
    <%--                        ListGrid_RequestItem_Show_Courses.setData(resp.courses.filter(item => item.priority.contains("انتصاب سمت")));--%>
    <%--                    else if (record.name.includes("ضمن خدمت"))--%>
    <%--                        ListGrid_RequestItem_Show_Courses.setData(resp.courses);--%>
    <%--                    else--%>
    <%--                        ListGrid_RequestItem_Show_Courses.setData(resp.courses.filter(item => item.courseCode === record.courseCode));--%>
    <%--                } else--%>
    <%--                    ListGrid_RequestItem_Show_Courses.setData([]);--%>
    <%--                Window_RequestItem_Show_Status_Completion.show();--%>
    <%--            }--%>
    <%--        });--%>
    <%--    }--%>
    <%--}--%>
    <%--function showRequestItemProcessStatusToRunChiefForApproval(record) {--%>

    <%--    if (record == null) {--%>
    <%--        createDialog("info", "<spring:message code='msg.no.records.selected'/>");--%>
    <%--    } else {--%>

    <%--        let DynamicForm_RequestItem_Show_Status = isc.DynamicForm.create({--%>
    <%--            colWidths: ["25%", "75%"],--%>
    <%--            width: "100%",--%>
    <%--            height: "15%",--%>
    <%--            numCols: "2",--%>
    <%--            autoFocus: "true",--%>
    <%--            cellPadding: 5,--%>
    <%--            fields: [--%>
    <%--                {--%>
    <%--                    name: "title",--%>
    <%--                    title: "عنوان",--%>
    <%--                    type: "staticText"--%>
    <%--                },--%>
    <%--                {--%>
    <%--                    name: "createBy",--%>
    <%--                    title: "ایجاد کننده فرایند",--%>
    <%--                    type: "staticText"--%>
    <%--                },--%>
    <%--                {--%>
    <%--                    name: "description",--%>
    <%--                    title: "توضیحات",--%>
    <%--                    type: "staticText"--%>
    <%--                },--%>
    <%--                {--%>
    <%--                    name: "certificationStatus",--%>
    <%--                    title: "وضعیت آموزشی",--%>
    <%--                    width: "100%",--%>
    <%--                    type: "staticText"--%>
    <%--                }--%>
    <%--            ]--%>
    <%--        });--%>
    <%--        let ListGrid_RequestItem_Show_Courses = isc.ListGrid.create({--%>
    <%--            width: "100%",--%>
    <%--            height: "70%",--%>
    <%--            sortDirection: "descending",--%>
    <%--            selectCellTextOnClick: true,--%>
    <%--            dataSource: RestDataSource_Parallel_RequestItem_Courses,--%>
    <%--            fields: [--%>
    <%--                {name: "courseCode"},--%>
    <%--                {name: "courseTitle", showHover: true},--%>
    <%--                {name: "categoryTitle", showHover: true},--%>
    <%--                {name: "subCategoryTitle", showHover: true},--%>
    <%--                {name: "priority"},--%>
    <%--                {name: "requestItemProcessDetailId", hidden: true}--%>
    <%--            ],--%>
    <%--            showHoverComponents: true,--%>
    <%--            showFilterEditor: true,--%>
    <%--            filterOnKeypress: true,--%>
    <%--            gridComponents: [--%>
    <%--                isc.Label.create({--%>
    <%--                    contents: "<span style='color: #b30e0e; font-weight: bold'>دوره های گذرانده</span>",--%>
    <%--                    align: "center",--%>
    <%--                    height: 15,--%>
    <%--                }), "filterEditor", "header", "body"--%>
    <%--            ]--%>
    <%--        });--%>
    <%--        let Button_RequestItem_Show_Status_Detail = isc.IButton.create({--%>
    <%--            title: "مشاهده جزییات",--%>
    <%--            align: "center",--%>
    <%--            width: "140",--%>
    <%--            click: function () {--%>
    <%--                showProcessDetail(record.name, record.processInstanceId);--%>
    <%--            }--%>
    <%--        });--%>
    <%--        let Button_RequestItem_Show_Status_Confirm = isc.IButton.create({--%>
    <%--            title: "تایید فرایند",--%>
    <%--            align: "center",--%>
    <%--            width: "140",--%>
    <%--            click: function () {--%>

    <%--                isc.Dialog.create({--%>
    <%--                    message: "آیا اطمینان دارید؟",--%>
    <%--                    icon: "[SKIN]ask.png",--%>
    <%--                    buttons: [--%>
    <%--                        isc.Button.create({title: "<spring:message code="yes"/>"}),--%>
    <%--                        isc.Button.create({title: "<spring:message code="global.no"/>"})--%>
    <%--                    ],--%>
    <%--                    buttonClick: function (button, index) {--%>

    <%--                        if (index === 0) {--%>
    <%--                            confirmRequestItemProcessByRunChiefForApproval(record, Window_RequestItem_Show_Status_Completion);--%>
    <%--                        }--%>
    <%--                        this.hide();--%>
    <%--                    }--%>
    <%--                });--%>
    <%--            }--%>
    <%--        });--%>
    <%--        let Button_RequestItem_Show_Status_Close = isc.IButton.create({--%>
    <%--            title: "بستن",--%>
    <%--            align: "center",--%>
    <%--            width: "140",--%>
    <%--            click: function () {--%>
    <%--                Window_RequestItem_Show_Status_Completion.close();--%>
    <%--            }--%>
    <%--        });--%>
    <%--        let HLayout_RequestItem_Show_Status_Completion = isc.HLayout.create({--%>
    <%--            width: "100%",--%>
    <%--            height: "5%",--%>
    <%--            align: "center",--%>
    <%--            membersMargin: 10,--%>
    <%--            members: [--%>
    <%--                Button_RequestItem_Show_Status_Detail,--%>
    <%--                Button_RequestItem_Show_Status_Confirm,--%>
    <%--                Button_RequestItem_Show_Status_Close--%>
    <%--            ]--%>
    <%--        });--%>
    <%--        let Window_RequestItem_Show_Status_Completion = isc.Window.create({--%>
    <%--            title: "نمایش جزییات و تکمیل فرایند",--%>
    <%--            autoSize: false,--%>
    <%--            width: "50%",--%>
    <%--            height: "70%",--%>
    <%--            canDragReposition: true,--%>
    <%--            canDragResize: true,--%>
    <%--            autoDraw: false,--%>
    <%--            autoCenter: true,--%>
    <%--            isModal: false,--%>
    <%--            items: [--%>
    <%--                DynamicForm_RequestItem_Show_Status,--%>
    <%--                ListGrid_RequestItem_Show_Courses,--%>
    <%--                HLayout_RequestItem_Show_Status_Completion--%>
    <%--            ]--%>
    <%--        });--%>

    <%--        DynamicForm_RequestItem_Show_Status.setValue("title", record.title);--%>
    <%--        DynamicForm_RequestItem_Show_Status.setValue("createBy", record.createBy);--%>
    <%--        DynamicForm_RequestItem_Show_Status.setValue("description", "درخواست با شماره " + record.requestNo);--%>


    <%--        RestDataSource_Parallel_RequestItem_Courses.fetchDataURL = requestItemUrl + "/planning-chief-opinion/" + record.requestItemId;--%>
    <%--        wait.show();--%>
    <%--        ListGrid_RequestItem_Show_Courses.fetchData(null, function (dsResponse, data, dsRequest) {--%>
    <%--            wait.close();--%>
    <%--            if (dsResponse.httpResponseCode === 200) {--%>
    <%--                let resp = JSON.parse(dsResponse.httpResponseText);--%>
    <%--                DynamicForm_RequestItem_Show_Status.setValue("certificationStatus", resp.finalOpinion);--%>
    <%--                if (resp.courses !== undefined && resp.courses.length !== 0) {--%>
    <%--                    if (record.name.includes("انتصاب سمت"))--%>
    <%--                        ListGrid_RequestItem_Show_Courses.setData(resp.courses.filter(item => item.priority.contains("انتصاب سمت")));--%>
    <%--                    else if (record.name.includes("ضمن خدمت"))--%>
    <%--                        ListGrid_RequestItem_Show_Courses.setData(resp.courses);--%>
    <%--                    else--%>
    <%--                        ListGrid_RequestItem_Show_Courses.setData(resp.courses.filter(item => item.courseCode === record.courseCode));--%>
    <%--                } else--%>
    <%--                    ListGrid_RequestItem_Show_Courses.setData([]);--%>
    <%--                Window_RequestItem_Show_Status_Completion.show();--%>
    <%--            }--%>
    <%--        });--%>
    <%--    }--%>
    <%--}--%>
    <%--function showRequestItemProcessStatusToPlanningChiefForApproval(record) {--%>

    <%--    if (record == null) {--%>
    <%--        createDialog("info", "<spring:message code='msg.no.records.selected'/>");--%>
    <%--    } else {--%>

    <%--        let DynamicForm_RequestItem_Show_Status = isc.DynamicForm.create({--%>
    <%--            colWidths: ["25%", "75%"],--%>
    <%--            width: "100%",--%>
    <%--            height: "15%",--%>
    <%--            numCols: "2",--%>
    <%--            autoFocus: "true",--%>
    <%--            cellPadding: 5,--%>
    <%--            fields: [--%>
    <%--                {--%>
    <%--                    name: "title",--%>
    <%--                    title: "عنوان",--%>
    <%--                    type: "staticText"--%>
    <%--                },--%>
    <%--                {--%>
    <%--                    name: "createBy",--%>
    <%--                    title: "ایجاد کننده فرایند",--%>
    <%--                    type: "staticText"--%>
    <%--                },--%>
    <%--                {--%>
    <%--                    name: "description",--%>
    <%--                    title: "توضیحات",--%>
    <%--                    type: "staticText"--%>
    <%--                },--%>
    <%--                {--%>
    <%--                    name: "certificationStatus",--%>
    <%--                    title: "وضعیت آموزشی",--%>
    <%--                    width: "100%",--%>
    <%--                    type: "staticText"--%>
    <%--                }--%>
    <%--            ]--%>
    <%--        });--%>
    <%--        let ListGrid_RequestItem_Show_Courses = isc.ListGrid.create({--%>
    <%--            width: "100%",--%>
    <%--            height: "70%",--%>
    <%--            sortDirection: "descending",--%>
    <%--            selectCellTextOnClick: true,--%>
    <%--            dataSource: RestDataSource_Parallel_RequestItem_Courses,--%>
    <%--            fields: [--%>
    <%--                {name: "courseCode"},--%>
    <%--                {name: "courseTitle", showHover: true},--%>
    <%--                {name: "categoryTitle", showHover: true},--%>
    <%--                {name: "subCategoryTitle", showHover: true},--%>
    <%--                {name: "priority"},--%>
    <%--                {name: "requestItemProcessDetailId", hidden: true}--%>
    <%--            ],--%>
    <%--            showHoverComponents: true,--%>
    <%--            showFilterEditor: true,--%>
    <%--            filterOnKeypress: true,--%>
    <%--            gridComponents: [--%>
    <%--                isc.Label.create({--%>
    <%--                    contents: "<span style='color: #b30e0e; font-weight: bold'>دوره های گذرانده</span>",--%>
    <%--                    align: "center",--%>
    <%--                    height: 15,--%>
    <%--                }), "filterEditor", "header", "body"--%>
    <%--            ]--%>
    <%--        });--%>
    <%--        let Button_RequestItem_Show_Status_Detail = isc.IButton.create({--%>
    <%--            title: "مشاهده جزییات",--%>
    <%--            align: "center",--%>
    <%--            width: "140",--%>
    <%--            click: function () {--%>
    <%--                showProcessDetail(record.name, record.processInstanceId);--%>
    <%--            }--%>
    <%--        });--%>
    <%--        let Button_RequestItem_Show_Status_Confirm = isc.IButton.create({--%>
    <%--            title: "تایید فرایند",--%>
    <%--            align: "center",--%>
    <%--            width: "140",--%>
    <%--            click: function () {--%>

    <%--                isc.Dialog.create({--%>
    <%--                    message: "آیا اطمینان دارید؟",--%>
    <%--                    icon: "[SKIN]ask.png",--%>
    <%--                    buttons: [--%>
    <%--                        isc.Button.create({title: "<spring:message code="yes"/>"}),--%>
    <%--                        isc.Button.create({title: "<spring:message code="global.no"/>"})--%>
    <%--                    ],--%>
    <%--                    buttonClick: function (button, index) {--%>

    <%--                        if (index === 0) {--%>
    <%--                            confirmRequestItemProcessByPlanningChiefForApproval(record, Window_RequestItem_Show_Status_Completion);--%>
    <%--                        }--%>
    <%--                        this.hide();--%>
    <%--                    }--%>
    <%--                });--%>
    <%--            }--%>
    <%--        });--%>
    <%--        let Button_RequestItem_Show_Status_Close = isc.IButton.create({--%>
    <%--            title: "بستن",--%>
    <%--            align: "center",--%>
    <%--            width: "140",--%>
    <%--            click: function () {--%>
    <%--                Window_RequestItem_Show_Status_Completion.close();--%>
    <%--            }--%>
    <%--        });--%>
    <%--        let HLayout_RequestItem_Show_Status_Completion = isc.HLayout.create({--%>
    <%--            width: "100%",--%>
    <%--            height: "5%",--%>
    <%--            align: "center",--%>
    <%--            membersMargin: 10,--%>
    <%--            members: [--%>
    <%--                Button_RequestItem_Show_Status_Detail,--%>
    <%--                Button_RequestItem_Show_Status_Confirm,--%>
    <%--                Button_RequestItem_Show_Status_Close--%>
    <%--            ]--%>
    <%--        });--%>
    <%--        let Window_RequestItem_Show_Status_Completion = isc.Window.create({--%>
    <%--            title: "نمایش جزییات و تکمیل فرایند",--%>
    <%--            autoSize: false,--%>
    <%--            width: "50%",--%>
    <%--            height: "70%",--%>
    <%--            canDragReposition: true,--%>
    <%--            canDragResize: true,--%>
    <%--            autoDraw: false,--%>
    <%--            autoCenter: true,--%>
    <%--            isModal: false,--%>
    <%--            items: [--%>
    <%--                DynamicForm_RequestItem_Show_Status,--%>
    <%--                ListGrid_RequestItem_Show_Courses,--%>
    <%--                HLayout_RequestItem_Show_Status_Completion--%>
    <%--            ]--%>
    <%--        });--%>

    <%--        DynamicForm_RequestItem_Show_Status.setValue("title", record.title);--%>
    <%--        DynamicForm_RequestItem_Show_Status.setValue("createBy", record.createBy);--%>
    <%--        DynamicForm_RequestItem_Show_Status.setValue("description", "درخواست با شماره " + record.requestNo);--%>


    <%--        RestDataSource_Parallel_RequestItem_Courses.fetchDataURL = requestItemUrl + "/planning-chief-opinion/" + record.requestItemId;--%>
    <%--        wait.show()--%>
    <%--        ListGrid_RequestItem_Show_Courses.fetchData(null, function (dsResponse, data, dsRequest) {--%>
    <%--            wait.close();--%>
    <%--            if (dsResponse.httpResponseCode === 200) {--%>
    <%--                let resp = JSON.parse(dsResponse.httpResponseText);--%>
    <%--                DynamicForm_RequestItem_Show_Status.setValue("certificationStatus", resp.finalOpinion);--%>
    <%--                if (resp.courses !== undefined && resp.courses.length !== 0) {--%>
    <%--                    if (record.name.includes("انتصاب سمت"))--%>
    <%--                        ListGrid_RequestItem_Show_Courses.setData(resp.courses.filter(item => item.priority.contains("انتصاب سمت")));--%>
    <%--                    else if (record.name.includes("ضمن خدمت"))--%>
    <%--                        ListGrid_RequestItem_Show_Courses.setData(resp.courses);--%>
    <%--                    else--%>
    <%--                        ListGrid_RequestItem_Show_Courses.setData(resp.courses.filter(item => item.courseCode === record.courseCode));--%>
    <%--                } else--%>
    <%--                    ListGrid_RequestItem_Show_Courses.setData([]);--%>
    <%--                Window_RequestItem_Show_Status_Completion.show();--%>
    <%--            }--%>
    <%--        });--%>
    <%--    }--%>
    <%--}--%>
    function showRequestItemProcessToAppointmentExpert(record) {

        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {

            let DynamicForm_RequestItem_Appointment_Expert = isc.DynamicForm.create({
                colWidths: ["25%", "75%"],
                width: "100%",
                height: "15%",
                numCols: "2",
                autoFocus: "true",
                cellPadding: 5,
                fields: [
                    {
                        name: "title",
                        title: "عنوان",
                        type: "staticText"
                    },
                    {
                        name: "createBy",
                        title: "ایجاد کننده فرایند",
                        type: "staticText"
                    },
                    {
                        name: "description",
                        title: "توضیحات",
                        type: "staticText"
                    },
                    {
                        name: "letterNumberSent",
                        title: "شماره نامه ارسالی به کارگزینی",
                        required: true
                    },
                    {
                        name: "dateSent",
                        title: "تاریخ ارسال به کارگزینی",
                        required: true,
                        ID: "dateSent_userPortfolio",
                        hint: "--/--/----",
                        keyPressFilter: "[0-9/]",
                        showHintInField: true,
                        textAlign: "center",
                        icons: [{
                            src: "<spring:url value="calendar.png"/>",
                            click: function (form) {
                                closeCalendarWindow();
                                displayDatePicker('dateSent_userPortfolio', this, 'ymd', '/');
                            }
                        }],
                        changed: function (form, item, value) {
                            if (value == null || value === "" || checkDate(value))
                                item.clearErrors();
                            else
                                item.setErrors("<spring:message code='msg.correct.date'/>");
                        }
                    }
                ]
            });
            let ListGrid_RequestItem_Show_Courses = isc.ListGrid.create({
                width: "100%",
                height: "70%",
                sortDirection: "descending",
                selectCellTextOnClick: true,
                dataSource: RestDataSource_Parallel_RequestItem_Courses,
                fields: [
                    {name: "courseCode"},
                    {name: "courseTitle", showHover: true},
                    {name: "categoryTitle", showHover: true},
                    {name: "subCategoryTitle", showHover: true},
                    {name: "priority"},
                    {name: "requestItemProcessDetailId", hidden: true}
                ],
                showHoverComponents: true,
                showFilterEditor: true,
                filterOnKeypress: true,
                gridComponents: [
                    isc.Label.create({
                        contents: "<span style='color: #b30e0e; font-weight: bold'>لیست دوره ها</span>",
                        align: "center",
                        height: 15,
                    }), "filterEditor", "header", "body"
                ]
            });
            let Button_RequestItem_Appointment_Expert_Detail = isc.IButton.create({
                title: "مشاهده جزییات",
                align: "center",
                width: "140",
                click: function () {
                    showProcessDetail(record.name, record.processInstanceId);
                }
            });
            let Button_RequestItem_Appointment_Expert_Confirm = isc.IButton.create({
                title: "تایید فرایند",
                align: "center",
                width: "140",
                click: function () {

                    if (!DynamicForm_RequestItem_Appointment_Expert.validate())
                        return;

                    isc.Dialog.create({
                        message: "آیا اطمینان دارید؟",
                        icon: "[SKIN]ask.png",
                        buttons: [
                            isc.Button.create({title: "<spring:message code="yes"/>"}),
                            isc.Button.create({title: "<spring:message code="global.no"/>"})
                        ],
                        buttonClick: function (button, index) {

                            if (index === 0) {
                                let letterNumberSent = DynamicForm_RequestItem_Appointment_Expert.getValue("letterNumberSent");
                                let dateSent = DynamicForm_RequestItem_Appointment_Expert.getValue("dateSent");
                                confirmRequestItemProcessByAppointmentExpert(record, letterNumberSent, dateSent, Window_RequestItem_Appointment_Expert_Completion);
                            }
                            this.hide();
                        }
                    });
                }
            });
            let Button_RequestItem_Appointment_Expert_Close = isc.IButton.create({
                title: "بستن",
                align: "center",
                width: "140",
                click: function () {
                    Window_RequestItem_Appointment_Expert_Completion.close();
                }
            });
            let HLayout_RequestItem_Appointment_Expert = isc.HLayout.create({
                width: "100%",
                height: "5%",
                align: "center",
                membersMargin: 10,
                members: [
                    Button_RequestItem_Appointment_Expert_Detail,
                    Button_RequestItem_Appointment_Expert_Confirm,
                    Button_RequestItem_Appointment_Expert_Close
                ]
            });
            let Window_RequestItem_Appointment_Expert_Completion = isc.Window.create({
                title: "نمایش جزییات و تکمیل فرایند",
                autoSize: false,
                width: "50%",
                height: "70%",
                canDragReposition: true,
                canDragResize: true,
                autoDraw: false,
                autoCenter: true,
                isModal: false,
                items: [
                    DynamicForm_RequestItem_Appointment_Expert,
                    ListGrid_RequestItem_Show_Courses,
                    HLayout_RequestItem_Appointment_Expert
                ]
            });

            DynamicForm_RequestItem_Appointment_Expert.setValue("title", record.title);
            DynamicForm_RequestItem_Appointment_Expert.setValue("createBy", record.createBy);
            DynamicForm_RequestItem_Appointment_Expert.setValue("description", "درخواست با شماره " + record.requestNo);

            RestDataSource_Parallel_RequestItem_Courses.fetchDataURL = requestItemUrl + "/planning-chief-opinion/" + record.requestItemId;
            wait.show()
            ListGrid_RequestItem_Show_Courses.fetchData(null, function (dsResponse, data, dsRequest) {
                wait.close();
                if (dsResponse.httpResponseCode === 200) {
                    let resp = JSON.parse(dsResponse.httpResponseText);
                    if (resp.courses !== undefined && resp.courses.length !== 0) {
                        if (record.name.includes("دوره های انتصاب"))
                            ListGrid_RequestItem_Show_Courses.setData(resp.courses.filter(item => item.priority.contains("انتصاب سمت")));
                        else
                            ListGrid_RequestItem_Show_Courses.setData(resp.courses);
                    } else
                        ListGrid_RequestItem_Show_Courses.setData([]);
                    Window_RequestItem_Appointment_Expert_Completion.show();
                }
            });
        }
    }
    <%--function showRequestItemProcessToAppointmentExpertNoLetter(record) {--%>

    <%--    if (record == null) {--%>
    <%--        createDialog("info", "<spring:message code='msg.no.records.selected'/>");--%>
    <%--    } else {--%>

    <%--        let DynamicForm_RequestItem_Appointment_Expert = isc.DynamicForm.create({--%>
    <%--            colWidths: ["25%", "75%"],--%>
    <%--            width: "100%",--%>
    <%--            height: "15%",--%>
    <%--            numCols: "2",--%>
    <%--            autoFocus: "true",--%>
    <%--            cellPadding: 5,--%>
    <%--            fields: [--%>
    <%--                {--%>
    <%--                    name: "title",--%>
    <%--                    title: "عنوان",--%>
    <%--                    type: "staticText"--%>
    <%--                },--%>
    <%--                {--%>
    <%--                    name: "createBy",--%>
    <%--                    title: "ایجاد کننده فرایند",--%>
    <%--                    type: "staticText"--%>
    <%--                },--%>
    <%--                {--%>
    <%--                    name: "description",--%>
    <%--                    title: "توضیحات",--%>
    <%--                    type: "staticText"--%>
    <%--                }--%>
    <%--            ]--%>
    <%--        });--%>
    <%--        let ListGrid_RequestItem_Show_Courses = isc.ListGrid.create({--%>
    <%--            width: "100%",--%>
    <%--            height: "70%",--%>
    <%--            sortDirection: "descending",--%>
    <%--            selectCellTextOnClick: true,--%>
    <%--            dataSource: RestDataSource_Parallel_RequestItem_Courses,--%>
    <%--            fields: [--%>
    <%--                {name: "courseCode"},--%>
    <%--                {name: "courseTitle", showHover: true},--%>
    <%--                {name: "categoryTitle", showHover: true},--%>
    <%--                {name: "subCategoryTitle", showHover: true},--%>
    <%--                {name: "priority"},--%>
    <%--                {name: "requestItemProcessDetailId", hidden: true}--%>
    <%--            ],--%>
    <%--            showHoverComponents: true,--%>
    <%--            showFilterEditor: true,--%>
    <%--            filterOnKeypress: true,--%>
    <%--            gridComponents: [--%>
    <%--                isc.Label.create({--%>
    <%--                    contents: "<span style='color: #b30e0e; font-weight: bold'>دوره های گذرانده</span>",--%>
    <%--                    align: "center",--%>
    <%--                    height: 15,--%>
    <%--                }), "filterEditor", "header", "body"--%>
    <%--            ]--%>
    <%--        });--%>
    <%--        let Button_RequestItem_Appointment_Expert_Detail = isc.IButton.create({--%>
    <%--            title: "مشاهده جزییات",--%>
    <%--            align: "center",--%>
    <%--            width: "140",--%>
    <%--            click: function () {--%>
    <%--                showProcessDetail(record.name, record.processInstanceId);--%>
    <%--            }--%>
    <%--        });--%>
    <%--        let Button_RequestItem_Appointment_Expert_Confirm = isc.IButton.create({--%>
    <%--            title: "تایید فرایند",--%>
    <%--            align: "center",--%>
    <%--            width: "140",--%>
    <%--            click: function () {--%>

    <%--                isc.Dialog.create({--%>
    <%--                    message: "آیا اطمینان دارید؟",--%>
    <%--                    icon: "[SKIN]ask.png",--%>
    <%--                    buttons: [--%>
    <%--                        isc.Button.create({title: "<spring:message code="yes"/>"}),--%>
    <%--                        isc.Button.create({title: "<spring:message code="global.no"/>"})--%>
    <%--                    ],--%>
    <%--                    buttonClick: function (button, index) {--%>

    <%--                        if (index === 0) {--%>
    <%--                            confirmRequestItemProcessByAppointmentExpertNoLetter(record, Window_RequestItem_Appointment_Expert_Completion);--%>
    <%--                        }--%>
    <%--                        this.hide();--%>
    <%--                    }--%>
    <%--                });--%>
    <%--            }--%>
    <%--        });--%>
    <%--        let Button_RequestItem_Appointment_Expert_Close = isc.IButton.create({--%>
    <%--            title: "بستن",--%>
    <%--            align: "center",--%>
    <%--            width: "140",--%>
    <%--            click: function () {--%>
    <%--                Window_RequestItem_Appointment_Expert_Completion.close();--%>
    <%--            }--%>
    <%--        });--%>
    <%--        let HLayout_RequestItem_Appointment_Expert = isc.HLayout.create({--%>
    <%--            width: "100%",--%>
    <%--            height: "5%",--%>
    <%--            align: "center",--%>
    <%--            membersMargin: 10,--%>
    <%--            members: [--%>
    <%--                Button_RequestItem_Appointment_Expert_Detail,--%>
    <%--                Button_RequestItem_Appointment_Expert_Confirm,--%>
    <%--                Button_RequestItem_Appointment_Expert_Close--%>
    <%--            ]--%>
    <%--        });--%>
    <%--        let Window_RequestItem_Appointment_Expert_Completion = isc.Window.create({--%>
    <%--            title: "نمایش جزییات و تکمیل فرایند",--%>
    <%--            autoSize: false,--%>
    <%--            width: "50%",--%>
    <%--            height: "70%",--%>
    <%--            canDragReposition: true,--%>
    <%--            canDragResize: true,--%>
    <%--            autoDraw: false,--%>
    <%--            autoCenter: true,--%>
    <%--            isModal: false,--%>
    <%--            items: [--%>
    <%--                DynamicForm_RequestItem_Appointment_Expert,--%>
    <%--                ListGrid_RequestItem_Show_Courses,--%>
    <%--                HLayout_RequestItem_Appointment_Expert--%>
    <%--            ]--%>
    <%--        });--%>

    <%--        DynamicForm_RequestItem_Appointment_Expert.setValue("title", record.title);--%>
    <%--        DynamicForm_RequestItem_Appointment_Expert.setValue("createBy", record.createBy);--%>
    <%--        DynamicForm_RequestItem_Appointment_Expert.setValue("description", "درخواست با شماره " + record.requestNo);--%>

    <%--        RestDataSource_Parallel_RequestItem_Courses.fetchDataURL = requestItemUrl + "/planning-chief-opinion/" + record.requestItemId;--%>
    <%--        wait.show()--%>
    <%--        ListGrid_RequestItem_Show_Courses.fetchData(null, function (dsResponse, data, dsRequest) {--%>
    <%--            wait.close();--%>
    <%--            if (dsResponse.httpResponseCode === 200) {--%>
    <%--                let resp = JSON.parse(dsResponse.httpResponseText);--%>
    <%--                if (resp.courses !== undefined && resp.courses.length !== 0) {--%>
    <%--                    ListGrid_RequestItem_Show_Courses.setData(resp.courses.filter(item => item.courseCode === record.courseCode));--%>
    <%--                } else--%>
    <%--                    ListGrid_RequestItem_Show_Courses.setData([]);--%>
    <%--                Window_RequestItem_Appointment_Expert_Completion.show();--%>
    <%--            }--%>
    <%--        });--%>
    <%--    }--%>
    <%--}--%>
    function showTrainingCertificationProcessToCertificationResponsible(record) {

        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {

            let DynamicForm_TrainingCertification_Certification_Responsible = isc.DynamicForm.create({
                colWidths: ["25%", "75%"],
                width: "100%",
                height: "85%",
                numCols: "2",
                autoFocus: "true",
                cellPadding: 5,
                fields: [
                    {
                        name: "title",
                        title: "عنوان",
                        type: "staticText"
                    },
                    {
                        name: "createBy",
                        title: "ایجاد کننده فرایند",
                        type: "staticText"
                    },
                    {
                        type: "RowSpacerItem"
                    },
                    {
                        name: "payment",
                        title: "",
                        showTitle: false,
                        value: "آیا نیاز به پرداخت هزینه دارد؟",
                        type: "staticText"
                    }
                ]
            });
            let Button_TrainingCertification_Certification_Responsible_Yes = isc.IButton.create({
                title: "بله",
                align: "center",
                width: "140",
                click: function () {

                    isc.Dialog.create({
                        message: "آیا اطمینان دارید؟",
                        icon: "[SKIN]ask.png",
                        buttons: [
                            isc.Button.create({title: "<spring:message code="yes"/>"}),
                            isc.Button.create({title: "<spring:message code="global.no"/>"})
                        ],
                        buttonClick: function (button, index) {

                            if (index === 0) {
                                confirmTrainingCertificationProcessByCertificationResponsibleToYes(record, Window_TrainingCertification_Certification_Responsible_Completion);
                            }
                            this.hide();
                        }
                    });
                }
            });
            let Button_TrainingCertification_Certification_Responsible_No = isc.IButton.create({
                title: "خیر",
                align: "center",
                width: "140",
                click: function () {

                    isc.Dialog.create({
                        message: "آیا اطمینان دارید؟",
                        icon: "[SKIN]ask.png",
                        buttons: [
                            isc.Button.create({title: "<spring:message code="yes"/>"}),
                            isc.Button.create({title: "<spring:message code="global.no"/>"})
                        ],
                        buttonClick: function (button, index) {

                            if (index === 0) {
                                confirmTrainingCertificationProcessByCertificationResponsibleToNo(record, Window_TrainingCertification_Certification_Responsible_Completion);
                            }
                            this.hide();
                        }
                    });
                }
            });
            let Button_TrainingCertification_Certification_Responsible_Close = isc.IButton.create({
                title: "بستن",
                align: "center",
                width: "140",
                click: function () {
                    Window_TrainingCertification_Certification_Responsible_Completion.close();
                }
            });
            let HLayout_TrainingCertification_Certification_Responsible = isc.HLayout.create({
                width: "100%",
                height: "15%",
                align: "center",
                membersMargin: 10,
                members: [
                    Button_TrainingCertification_Certification_Responsible_Yes,
                    Button_TrainingCertification_Certification_Responsible_No,
                    Button_TrainingCertification_Certification_Responsible_Close
                ]
            });
            let Window_TrainingCertification_Certification_Responsible_Completion = isc.Window.create({
                title: "نمایش جزییات و تکمیل فرایند",
                autoSize: false,
                width: "40%",
                height: "25%",
                canDragReposition: true,
                canDragResize: true,
                autoDraw: false,
                autoCenter: true,
                isModal: false,
                items: [
                    DynamicForm_TrainingCertification_Certification_Responsible,
                    HLayout_TrainingCertification_Certification_Responsible
                ]
            });

            DynamicForm_TrainingCertification_Certification_Responsible.setValue("title", record.title);
            DynamicForm_TrainingCertification_Certification_Responsible.setValue("createBy", record.createBy);

            Window_TrainingCertification_Certification_Responsible_Completion.show();
        }
    }
    function showTrainingCertificationProcessToFinancialResponsible(record) {

        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {

            let Window_TrainingCertification_Financial_Responsible_Return = isc.Window.create({
                title: "عودت",
                autoSize: false,
                width: "30%",
                height: "20%",
                canDragReposition: true,
                canDragResize: true,
                autoDraw: false,
                autoCenter: true,
                isModal: false,
                items: [
                    isc.DynamicForm.create({
                        ID: "reason",
                        width: "100%",
                        height: "75%",
                        autoFocus: "true",
                        cellPadding: 5,
                        fields: [
                            {
                                name: "returnReason",
                                title: "دلیل عودت",
                                type: "text",
                                required: true,
                                validators: [{
                                    validateOnExit: true,
                                    type: "lengthRange",
                                    min: 1,
                                    max: 250,
                                    stopOnError: true,
                                    errorMessage: "حداکثر تعداد کاراکتر مجاز 250 می باشد. "
                                }]
                            }
                        ]
                    }),
                    isc.HLayout.create({
                        width: "100%",
                        height: "25%",
                        align: "center",
                        membersMargin: 10,
                        members: [
                            isc.Button.create({
                                title: "<spring:message code='global.ok'/>",
                                click: function () {
                                    if (!reason.validate())
                                        return;

                                    let baseUrl = trainingCertificationBPMSUrl;
                                    let url = "/processes/financial-responsible/training-certification/cancel-process";
                                    let var_data = {
                                        "returnReason": reason.getField("returnReason").getValue(),
                                    };
                                    let reviewTaskRequest = {
                                        taskId: record.taskId,
                                        userName: userUserName,
                                        approve: false,
                                        processInstanceId: record.processInstanceId,
                                        variables: var_data
                                    };
                                    let data = {
                                        reviewTaskRequest: reviewTaskRequest,
                                        reason: reason.getField("returnReason").getValue()
                                    }

                                    wait.show();
                                    isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url  , "POST", JSON.stringify(data), function (resp) {
                                        wait.close();
                                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                            createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                            ToolStripButton_Refresh_Processes_UserPortfolio.click();
                                        } else {
                                            createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                                        }
                                    }));
                                    Window_TrainingCertification_Financial_Responsible_Completion.close();
                                    Window_TrainingCertification_Financial_Responsible_Return.close();
                                }
                            }),
                            isc.Button.create({
                                title: "<spring:message code='cancel'/>",
                                click: function () {
                                    Window_TrainingCertification_Financial_Responsible_Return.close();
                                }
                            })
                        ]
                    })
                ]
            });
            let DynamicForm_TrainingCertification_Financial_Responsible = isc.DynamicForm.create({
                colWidths: ["25%", "75%"],
                width: "100%",
                height: "85%",
                numCols: "2",
                autoFocus: "true",
                cellPadding: 5,
                fields: [
                    {
                        name: "title",
                        title: "عنوان",
                        type: "staticText"
                    },
                    {
                        name: "createBy",
                        title: "ایجاد کننده فرایند",
                        type: "staticText"
                    }
                ]
            });
            let Button_TrainingCertification_Financial_Responsible_Confirm = isc.IButton.create({
                title: "تایید فرایند",
                align: "center",
                width: "140",
                click: function () {

                    isc.Dialog.create({
                        message: "آیا اطمینان دارید؟",
                        icon: "[SKIN]ask.png",
                        buttons: [
                            isc.Button.create({title: "<spring:message code="yes"/>"}),
                            isc.Button.create({title: "<spring:message code="global.no"/>"})
                        ],
                        buttonClick: function (button, index) {

                            if (index === 0) {
                                confirmTrainingCertificationProcessByFinancialResponsible(record, Window_TrainingCertification_Financial_Responsible_Completion);
                            }
                            this.hide();
                        }
                    });
                }
            });
            let Button_TrainingCertification_Financial_Responsible_Return = isc.IButton.create({
                title: "عودت",
                align: "center",
                width: "120",
                click: function () {
                    Window_TrainingCertification_Financial_Responsible_Return.show();
                }
            });
            let Button_TrainingCertification_Financial_Responsible_Close = isc.IButton.create({
                title: "بستن",
                align: "center",
                width: "140",
                click: function () {
                    Window_TrainingCertification_Financial_Responsible_Completion.close();
                }
            });
            let HLayout_TrainingCertification_Financial_Responsible = isc.HLayout.create({
                width: "100%",
                height: "15%",
                align: "center",
                membersMargin: 10,
                members: [
                    Button_TrainingCertification_Financial_Responsible_Confirm,
                    Button_TrainingCertification_Financial_Responsible_Return,
                    Button_TrainingCertification_Financial_Responsible_Close
                ]
            });
            let Window_TrainingCertification_Financial_Responsible_Completion = isc.Window.create({
                title: "نمایش جزییات و تکمیل فرایند",
                autoSize: false,
                width: "40%",
                height: "20%",
                canDragReposition: true,
                canDragResize: true,
                autoDraw: false,
                autoCenter: true,
                isModal: false,
                items: [
                    DynamicForm_TrainingCertification_Financial_Responsible,
                    HLayout_TrainingCertification_Financial_Responsible
                ]
            });

            DynamicForm_TrainingCertification_Financial_Responsible.setValue("title", record.title);
            DynamicForm_TrainingCertification_Financial_Responsible.setValue("createBy", record.createBy);

            Window_TrainingCertification_Financial_Responsible_Completion.show();
        }
    }
    function showTrainingCertificationProcessToCertificationResponsibleForApproval(record) {

        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {

            let DynamicForm_TrainingCertification_Certification_Responsible_Approval = isc.DynamicForm.create({
                colWidths: ["25%", "75%"],
                width: "100%",
                height: "85%",
                numCols: "2",
                autoFocus: "true",
                cellPadding: 5,
                fields: [
                    {
                        name: "title",
                        title: "عنوان",
                        type: "staticText"
                    },
                    {
                        name: "createBy",
                        title: "ایجاد کننده فرایند",
                        type: "staticText"
                    }
                ]
            });
            let Button_TrainingCertification_Certification_Responsible_Approval_Confirm = isc.IButton.create({
                title: "تایید فرایند",
                align: "center",
                width: "140",
                click: function () {

                    isc.Dialog.create({
                        message: "آیا اطمینان دارید؟",
                        icon: "[SKIN]ask.png",
                        buttons: [
                            isc.Button.create({title: "<spring:message code="yes"/>"}),
                            isc.Button.create({title: "<spring:message code="global.no"/>"})
                        ],
                        buttonClick: function (button, index) {

                            if (index === 0) {
                                confirmTrainingCertificationProcessByCertificationResponsibleForApproval(record, Window_TrainingCertification_Certification_Responsible_Approval_Completion);
                            }
                            this.hide();
                        }
                    });
                }
            });
            let Button_TrainingCertification_Certification_Responsible_Approval_Close = isc.IButton.create({
                title: "بستن",
                align: "center",
                width: "140",
                click: function () {
                    Window_TrainingCertification_Certification_Responsible_Approval_Completion.close();
                }
            });
            let HLayout_TrainingCertification_Certification_Responsible_Approval = isc.HLayout.create({
                width: "100%",
                height: "15%",
                align: "center",
                membersMargin: 10,
                members: [
                    Button_TrainingCertification_Certification_Responsible_Approval_Confirm,
                    Button_TrainingCertification_Certification_Responsible_Approval_Close
                ]
            });
            let Window_TrainingCertification_Certification_Responsible_Approval_Completion = isc.Window.create({
                title: "نمایش جزییات و تکمیل فرایند",
                autoSize: false,
                width: "40%",
                height: "20%",
                canDragReposition: true,
                canDragResize: true,
                autoDraw: false,
                autoCenter: true,
                isModal: false,
                items: [
                    DynamicForm_TrainingCertification_Certification_Responsible_Approval,
                    HLayout_TrainingCertification_Certification_Responsible_Approval
                ]
            });

            DynamicForm_TrainingCertification_Certification_Responsible_Approval.setValue("title", record.title);
            DynamicForm_TrainingCertification_Certification_Responsible_Approval.setValue("createBy", record.createBy);

            Window_TrainingCertification_Certification_Responsible_Approval_Completion.show();
        }
    }
    function showTrainingCertificationProcessToTrainingManager(record) {

        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {

            let DynamicForm_TrainingCertification_Training_Manager = isc.DynamicForm.create({
                colWidths: ["25%", "75%"],
                width: "100%",
                height: "85%",
                numCols: "2",
                autoFocus: "true",
                cellPadding: 5,
                fields: [
                    {
                        name: "title",
                        title: "عنوان",
                        type: "staticText"
                    },
                    {
                        name: "createBy",
                        title: "ایجاد کننده فرایند",
                        type: "staticText"
                    }
                ]
            });
            let Button_TrainingCertification_Training_Manager_Confirm = isc.IButton.create({
                title: "تایید فرایند",
                align: "center",
                width: "140",
                click: function () {

                    isc.Dialog.create({
                        message: "آیا اطمینان دارید؟",
                        icon: "[SKIN]ask.png",
                        buttons: [
                            isc.Button.create({title: "<spring:message code="yes"/>"}),
                            isc.Button.create({title: "<spring:message code="global.no"/>"})
                        ],
                        buttonClick: function (button, index) {

                            if (index === 0) {
                                confirmTrainingCertificationProcessByTrainingManager(record, Window_TrainingCertification_Training_Manager_Completion);
                            }
                            this.hide();
                        }
                    });
                }
            });
            let Button_TrainingCertification_Training_Manager_Close = isc.IButton.create({
                title: "بستن",
                align: "center",
                width: "140",
                click: function () {
                    Window_TrainingCertification_Training_Manager_Completion.close();
                }
            });
            let HLayout_TrainingCertification_Training_Manager = isc.HLayout.create({
                width: "100%",
                height: "15%",
                align: "center",
                membersMargin: 10,
                members: [
                    Button_TrainingCertification_Training_Manager_Confirm,
                    Button_TrainingCertification_Training_Manager_Close
                ]
            });
            let Window_TrainingCertification_Training_Manager_Completion = isc.Window.create({
                title: "نمایش جزییات و تکمیل فرایند",
                autoSize: false,
                width: "40%",
                height: "20%",
                canDragReposition: true,
                canDragResize: true,
                autoDraw: false,
                autoCenter: true,
                isModal: false,
                items: [
                    DynamicForm_TrainingCertification_Training_Manager,
                    HLayout_TrainingCertification_Training_Manager
                ]
            });

            DynamicForm_TrainingCertification_Training_Manager.setValue("title", record.title);
            DynamicForm_TrainingCertification_Training_Manager.setValue("createBy", record.createBy);

            Window_TrainingCertification_Training_Manager_Completion.show();
        }
    }
    function showTrainingCertificationProcessToCertificationResponsibleForIssuing(record) {

        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {

            let DynamicForm_TrainingCertification_Certification_Responsible_Issuing = isc.DynamicForm.create({
                colWidths: ["25%", "75%"],
                width: "100%",
                height: "85%",
                numCols: "2",
                autoFocus: "true",
                cellPadding: 5,
                fields: [
                    {
                        name: "title",
                        title: "عنوان",
                        type: "staticText"
                    },
                    {
                        name: "createBy",
                        title: "ایجاد کننده فرایند",
                        type: "staticText"
                    }
                ]
            });
            let Button_TrainingCertification_Certification_Responsible_Issuing_Confirm = isc.IButton.create({
                title: "تایید فرایند",
                align: "center",
                width: "140",
                click: function () {

                    isc.Dialog.create({
                        message: "آیا اطمینان دارید؟",
                        icon: "[SKIN]ask.png",
                        buttons: [
                            isc.Button.create({title: "<spring:message code="yes"/>"}),
                            isc.Button.create({title: "<spring:message code="global.no"/>"})
                        ],
                        buttonClick: function (button, index) {

                            if (index === 0) {
                                confirmTrainingCertificationProcessByCertificationResponsibleForIssuing(record, Window_TrainingCertification_Certification_Responsible_Issuing_Completion);
                            }
                            this.hide();
                        }
                    });
                }
            });
            let Button_TrainingCertification_Certification_Responsible_Issuing_Download = isc.IButton.create({
                title: "دانلود گواهی نامه",
                align: "center",
                width: "140",
                click: function () {
                    downloadTrainingCertification(record, Window_TrainingCertification_Certification_Responsible_Issuing_Completion);
                }
            });
            let Button_TrainingCertification_Certification_Responsible_Issuing_Close = isc.IButton.create({
                title: "بستن",
                align: "center",
                width: "140",
                click: function () {
                    Window_TrainingCertification_Certification_Responsible_Issuing_Completion.close();
                }
            });
            let HLayout_TrainingCertification_Certification_Responsible_Issuing = isc.HLayout.create({
                width: "100%",
                height: "15%",
                align: "center",
                membersMargin: 10,
                members: [
                    Button_TrainingCertification_Certification_Responsible_Issuing_Confirm,
                    Button_TrainingCertification_Certification_Responsible_Issuing_Download,
                    Button_TrainingCertification_Certification_Responsible_Issuing_Close
                ]
            });
            let Window_TrainingCertification_Certification_Responsible_Issuing_Completion = isc.Window.create({
                title: "نمایش جزییات و تکمیل فرایند",
                autoSize: false,
                width: "40%",
                height: "20%",
                canDragReposition: true,
                canDragResize: true,
                autoDraw: false,
                autoCenter: true,
                isModal: false,
                items: [
                    DynamicForm_TrainingCertification_Certification_Responsible_Issuing,
                    HLayout_TrainingCertification_Certification_Responsible_Issuing
                ]
            });

            DynamicForm_TrainingCertification_Certification_Responsible_Issuing.setValue("title", record.title);
            DynamicForm_TrainingCertification_Certification_Responsible_Issuing.setValue("createBy", record.createBy);

            Window_TrainingCertification_Certification_Responsible_Issuing_Completion.show();
        }
    }

    function showGroupExcelParallelRequestItemProcess(records) {

        let itemFields = ["name", "lastName", "personnelNo2", "nationalCode", "affairs", "post", "postTitle", "modifiedDate", "courseCode", "courseTitle", "priority"];
        let itemHeaders = ["نام", "نام خانوادگی", "شماره پرسنلی", "کدملی", "امور", "کدپست پیشنهادی", "پست پیشنهادی", "تاریخ بروزرسانی پست", "کد دوره", "نام دوره", "اولویت"];
        let requestItemIds = records.map(item => item.requestItemId);

        let downloadForm = isc.DynamicForm.create({
            method: "POST",
            action: "/training/reportsToExcel/planningExperts",
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "fieldNames", type: "hidden"},
                    {name: "headers", type: "hidden"},
                    {name: "requestItemIds", type: "hidden"}
                ]
        });

        downloadForm.setValue("fieldNames", itemFields);
        downloadForm.setValue("headers", itemHeaders);
        downloadForm.setValue("requestItemIds", requestItemIds);
        downloadForm.show();
        downloadForm.submitForm();
    }
    function showGroupRequestItemProcessToAppointmentExpert(records) {

        let DynamicForm_Group_RequestItem_Appointment_Expert = isc.DynamicForm.create({
            colWidths: ["25%", "75%"],
            width: "100%",
            height: "85%",
            numCols: "2",
            autoFocus: "true",
            cellPadding: 5,
            fields: [
                {
                    name: "letterNumberSent",
                    title: "شماره نامه ارسالی به کارگزینی",
                    required: true
                },
                {
                    name: "dateSent",
                    title: "تاریخ ارسال به کارگزینی",
                    required: true,
                    ID: "dateSent_userPortfolio",
                    hint: "--/--/----",
                    keyPressFilter: "[0-9/]",
                    showHintInField: true,
                    textAlign: "center",
                    icons: [{
                        src: "<spring:url value="calendar.png"/>",
                        click: function (form) {
                            closeCalendarWindow();
                            displayDatePicker('dateSent_userPortfolio', this, 'ymd', '/');
                        }
                    }],
                    changed: function (form, item, value) {
                        if (value == null || value === "" || checkDate(value))
                            item.clearErrors();
                        else
                            item.setErrors("<spring:message code='msg.correct.date'/>");
                    }
                }
            ]
        });
        let Button_Group_RequestItem_Appointment_Expert_Confirm = isc.IButton.create({
            title: "تایید فرایند",
            align: "center",
            width: "140",
            click: function () {

                if (!DynamicForm_Group_RequestItem_Appointment_Expert.validate())
                    return;

                isc.Dialog.create({
                    message: "آیا اطمینان دارید؟",
                    icon: "[SKIN]ask.png",
                    buttons: [
                        isc.Button.create({title: "<spring:message code="yes"/>"}),
                        isc.Button.create({title: "<spring:message code="global.no"/>"})
                    ],
                    buttonClick: function (button, index) {

                        if (index === 0) {
                            let letterNumberSent = DynamicForm_Group_RequestItem_Appointment_Expert.getValue("letterNumberSent");
                            let dateSent = DynamicForm_Group_RequestItem_Appointment_Expert.getValue("dateSent");
                            confirmGroupRequestItemProcessByAppointmentExpert(records, letterNumberSent, dateSent, Window_Group_RequestItem_Appointment_Expert_Completion);
                        }
                        this.hide();
                    }
                });
            }
        });
        let Button_Group_RequestItem_Appointment_Expert_Close = isc.IButton.create({
            title: "بستن",
            align: "center",
            width: "140",
            click: function () {
                Window_Group_RequestItem_Appointment_Expert_Completion.close();
            }
        });
        let HLayout_Group_RequestItem_Appointment_Expert = isc.HLayout.create({
            width: "100%",
            height: "15%",
            align: "center",
            membersMargin: 10,
            members: [
                Button_Group_RequestItem_Appointment_Expert_Confirm,
                Button_Group_RequestItem_Appointment_Expert_Close
            ]
        });
        let Window_Group_RequestItem_Appointment_Expert_Completion = isc.Window.create({
            title: "تایید گروهی فرایند",
            autoSize: false,
            width: "50%",
            height: "20%",
            canDragReposition: true,
            canDragResize: true,
            autoDraw: false,
            autoCenter: true,
            isModal: false,
            items: [
                DynamicForm_Group_RequestItem_Appointment_Expert,
                HLayout_Group_RequestItem_Appointment_Expert
            ]
        });

        Window_Group_RequestItem_Appointment_Expert_Completion.show();
    }

    function confirmProcess(record, window) {

        let baseUrl = "";
        let url = "";
        let reviewTaskRequest = {}

        if (record.title.includes("نیازسنجی")) {
            let map_data = {
                "objectId": record.objectId,
                "objectType": record.objectType
            };
            baseUrl = bpmsUrl;
            url = "/needAssessment/tasks/review";
            reviewTaskRequest = {
                taskId: record.taskId,
                approve: true,
                userName: userUserName,
                processInstanceId: record.processInstanceId,
                variables: map_data
            };
        } else if (record.title.includes("شایستگی")) {
            baseUrl = bpmsUrl;
            url = "/tasks/review";
            reviewTaskRequest = {
                taskId: record.taskId,
                approve: true,
                userName: userUserName,
                processInstanceId: record.processInstanceId
            };
        } else if (record.title.includes("صلاحیت علمی و فنی")) {
            let ass_data = {};
            baseUrl = requestItemBPMSUrl;
            url = "/tasks/request-item/review";
            reviewTaskRequest = {
                taskId: record.taskId,
                approve: true,
                userName: userUserName,
                processInstanceId: record.processInstanceId,
                variables: ass_data
            };
        }

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url , "POST", JSON.stringify(reviewTaskRequest), function (resp) {
            wait.close();
            let response = JSON.parse(resp.httpResponseText);
            window.close();
            createDialog("info", response.message);
            ToolStripButton_Refresh_Processes_UserPortfolio.click();
        }));
    }
    function confirmParallelRequestItemProcess(record, coursesListGrid, window) {

        let coursesRecord = coursesListGrid.getSelectedRecords();

        let baseUrl = requestItemBPMSUrl;
        let url = "/tasks/parallel/request-item/review";
        let ass_data = {
            "assigneeList": record.assigneeList,
        };
        let reviewTaskRequest = {
            taskId: record.taskId,
            approve: true,
            userName: userUserName,
            processInstanceId: record.processInstanceId,
            variables: ass_data
        };
        let reqItemCourses = {
            courses: coursesRecord,
            reviewTaskRequest: reviewTaskRequest
        };

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url + "/" + "<%= userNationalCode %>", "POST", JSON.stringify(reqItemCourses), function (resp) {
            wait.close();
            let response = JSON.parse(resp.httpResponseText);
            if (response.status === 200) {
                window.close();
                createDialog("info", "<spring:message code="global.form.request.successful"/>");
                ToolStripButton_Refresh_Processes_UserPortfolio.click();
            } else {
                window.close();
                createDialog("info", response.message);
            }
        }));
    }
    function confirmRequestItemProcessToDetermineStatus(record, chiefOpinion, window) {

        let baseUrl = requestItemBPMSUrl;
        let url = "/tasks/determine-status/request-item/review";
        let ass_data = {
            "assignFrom": record.assignFrom,
        };
        let reviewTaskRequest = {
            taskId: record.taskId,
            approve: true,
            userName: userUserName,
            processInstanceId: record.processInstanceId,
            variables: ass_data
        };

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url + "/" + chiefOpinion + "/" + "<%= userNationalCode %>", "POST", JSON.stringify(reviewTaskRequest), function (resp) {
            wait.close();
            let response = JSON.parse(resp.httpResponseText);
            window.close();
            createDialog("info", response.message);
            ToolStripButton_Refresh_Processes_UserPortfolio.click();
        }));
    }
    function confirmRequestItemProcessByRunChief(record, window) {

        let baseUrl = requestItemBPMSUrl;
        let url;
        if (record.name.includes("ضمن خدمت")) {
            url = "/tasks/run-chief/request-item/review";
        } else {
            url = "/tasks/run-chief/need-to-pass/request-item/review";
        }
        let reviewTaskRequest = {
            taskId: record.taskId,
            approve: true,
            userName: userUserName,
            processInstanceId: record.processInstanceId,
            variables: {}
        };

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url, "POST", JSON.stringify(reviewTaskRequest), function (resp) {
            wait.close();
            let response = JSON.parse(resp.httpResponseText);
            window.close();
            createDialog("info", response.message);
            ToolStripButton_Refresh_Processes_UserPortfolio.click();
        }));
    }
    function confirmRequestItemProcessByRunSupervisor(record, window) {

        let baseUrl = requestItemBPMSUrl;
        let expertsAssignListUrl = "/experts-assign-List/request-item/" + record.processInstanceId + "/" + record.courseCode;

        let ListGrid_Experts_List = isc.ListGrid.create({
            width: "100%",
            height: "100%",
            selectionType: "simple",
            selectCellTextOnClick: true,
            selectionAppearance: "checkbox",
            fields: [
                {name: "expertNationalCode", title: "کدملی"},
                {name: "expertFullName", title: "نام و نام خانوادگی"}
            ]
        });
        let Button_Experts_List_Confirm = isc.IButton.create({
            title: "تایید کارشناس و ادامه",
            align: "center",
            width: "140",
            click: function () {

                let records = ListGrid_Experts_List.getSelectedRecords();
                if (records == null || records.size() !== 1) {
                    createDialog("info", "حتما و فقط یک کارشناس انتخاب شود");
                } else {

                    let url = "/tasks/run-supervisor/request-item/review/" + records[0].expertNationalCode;
                    let reviewTaskRequest = {
                        taskId: record.taskId,
                        approve: true,
                        userName: userUserName,
                        processInstanceId: record.processInstanceId,
                        variables: {}
                    };

                    wait.show();
                    isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url, "POST", JSON.stringify(reviewTaskRequest), function (resp) {
                        wait.close();
                        let response = JSON.parse(resp.httpResponseText);
                        Window_Experts_List.close();
                        window.close();
                        createDialog("info", response.message);
                        ToolStripButton_Refresh_Processes_UserPortfolio.click();
                    }));
                }
            }
        });
        let Button_Experts_List_Close = isc.IButton.create({
            title: "بستن",
            align: "center",
            width: "140",
            click: function () {
                Window_Experts_List.close();
            }
        });
        let HLayout_Experts_List = isc.HLayout.create({
            width: "100%",
            height: "5%",
            align: "center",
            membersMargin: 10,
            members: [
                Button_Experts_List_Confirm,
                Button_Experts_List_Close
            ]
        });
        let Window_Experts_List = isc.Window.create({
            title: "انتخاب کارشناس اجرا",
            autoSize: false,
            width: "40%",
            height: "50%",
            canDragReposition: true,
            canDragResize: true,
            autoDraw: false,
            autoCenter: true,
            isModal: false,
            items: [
                ListGrid_Experts_List,
                HLayout_Experts_List
            ]
        });

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(baseUrl + expertsAssignListUrl, "GET", null, function (resp) {
            wait.close();
            let expertsList = JSON.parse(resp.httpResponseText);
            ListGrid_Experts_List.setData(expertsList);
            Window_Experts_List.show();
        }));
    }
    function confirmRequestItemProcessByRunExperts(record, window) {

        let baseUrl = requestItemBPMSUrl;
        let url = "/tasks/run-experts/request-item/review/" + record.courseCode;

        let reviewTaskRequest = {
            taskId: record.taskId,
            approve: true,
            userName: userUserName,
            processInstanceId: record.processInstanceId,
            variables: {}
        };

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url, "POST", JSON.stringify(reviewTaskRequest), function (resp) {
            wait.close();
            let response = JSON.parse(resp.httpResponseText);
            window.close();
            createDialog("info", response.message);
            ToolStripButton_Refresh_Processes_UserPortfolio.click();
        }));
    }
    // function confirmRequestItemProcessByRunSupervisorForApproval(record, window) {
    //
    //     let baseUrl = requestItemBPMSUrl;
    //     let url = "/tasks/run-supervisor-for-approval/request-item/review";
    //
    //     let reviewTaskRequest = {
    //         taskId: record.taskId,
    //         approve: true,
    //         userName: userUserName,
    //         processInstanceId: record.processInstanceId,
    //         variables: {}
    //     };
    //
    //     wait.show();
    //     isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url, "POST", JSON.stringify(reviewTaskRequest), function (resp) {
    //         wait.close();
    //         let response = JSON.parse(resp.httpResponseText);
    //         window.close();
    //         createDialog("info", response.message);
    //         ToolStripButton_Refresh_Processes_UserPortfolio.click();
    //     }));
    // }
    // function confirmRequestItemProcessByRunChiefForApproval(record, window) {
    //
    //     let baseUrl = requestItemBPMSUrl;
    //     let url = "/tasks/run-chief-for-approval/request-item/review";
    //
    //     let reviewTaskRequest = {
    //         taskId: record.taskId,
    //         approve: true,
    //         userName: userUserName,
    //         processInstanceId: record.processInstanceId,
    //         variables: {}
    //     };
    //
    //     wait.show();
    //     isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url, "POST", JSON.stringify(reviewTaskRequest), function (resp) {
    //         wait.close();
    //         let response = JSON.parse(resp.httpResponseText);
    //         window.close();
    //         createDialog("info", response.message);
    //         ToolStripButton_Refresh_Processes_UserPortfolio.click();
    //     }));
    // }
    // function confirmRequestItemProcessByPlanningChiefForApproval(record, window) {
    //
    //     let baseUrl = requestItemBPMSUrl;
    //     let url = "/tasks/planning-chief-for-approval/request-item/review";
    //     let ass_data = {
    //         "assignFrom": record.assignFrom,
    //     };
    //     let reviewTaskRequest = {
    //         taskId: record.taskId,
    //         approve: true,
    //         userName: userUserName,
    //         processInstanceId: record.processInstanceId,
    //         variables: ass_data
    //     };
    //
    //     wait.show();
    //     isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url, "POST", JSON.stringify(reviewTaskRequest), function (resp) {
    //         wait.close();
    //         let response = JSON.parse(resp.httpResponseText);
    //         window.close();
    //         createDialog("info", response.message);
    //         ToolStripButton_Refresh_Processes_UserPortfolio.click();
    //     }));
    // }
    function confirmRequestItemProcessByAppointmentExpert(record, letterNumberSent, dateSent, window) {

        let baseUrl = requestItemBPMSUrl;
        let url = "/tasks/appointment-expert/request-item/review";

        let reviewTaskRequest = {
            taskId: record.taskId,
            approve: true,
            userName: userUserName,
            processInstanceId: record.processInstanceId,
        };

        let bPMSReqItemSentLetterDto = {
            letterNumberSent: letterNumberSent,
            dateSent: dateSent,
            reviewTaskRequest: reviewTaskRequest
        };

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url, "POST", JSON.stringify(bPMSReqItemSentLetterDto), function (resp) {
            wait.close();
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                window.close();
                createDialog("info", "<spring:message code="global.form.request.successful"/>");
                ToolStripButton_Refresh_Processes_UserPortfolio.click();
            } else {
                window.close();
                createDialog("info", "عملیات انجام نشد");
            }
        }));
    }
    <%--function confirmRequestItemProcessByAppointmentExpertNoLetter(record, window) {--%>

    <%--    let baseUrl = requestItemBPMSUrl;--%>
    <%--    let url = "/tasks/appointment-expert-no-letter/request-item/review";--%>

    <%--    let reviewTaskRequest = {--%>
    <%--        taskId: record.taskId,--%>
    <%--        approve: true,--%>
    <%--        userName: userUserName,--%>
    <%--        processInstanceId: record.processInstanceId,--%>
    <%--    };--%>

    <%--    let bPMSReqItemSentLetterDto = {--%>
    <%--        // letterNumberSent: letterNumberSent,--%>
    <%--        // dateSent: dateSent,--%>
    <%--        reviewTaskRequest: reviewTaskRequest--%>
    <%--    };--%>

    <%--    wait.show();--%>
    <%--    isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url, "POST", JSON.stringify(bPMSReqItemSentLetterDto), function (resp) {--%>
    <%--        wait.close();--%>
    <%--        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {--%>
    <%--            window.close();--%>
    <%--            createDialog("info", "<spring:message code="global.form.request.successful"/>");--%>
    <%--            ToolStripButton_Refresh_Processes_UserPortfolio.click();--%>
    <%--        } else {--%>
    <%--            window.close();--%>
    <%--            createDialog("info", "عملیات انجام نشد");--%>
    <%--        }--%>
    <%--    }));--%>
    <%--}--%>
    function confirmTrainingCertificationProcessByCertificationResponsibleToYes(record, window) {

        let baseUrl = trainingCertificationBPMSUrl;
        let url = "/tasks/certification-responsible-yes/training-certification/review";
        let reviewTaskRequest = {
            taskId: record.taskId,
            approve: true,
            userName: userUserName,
            processInstanceId: record.processInstanceId,
            variables: {}
        };

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url, "POST", JSON.stringify(reviewTaskRequest), function (resp) {
            wait.close();
            let response = JSON.parse(resp.httpResponseText);
            window.close();
            createDialog("info", response.message);
            ToolStripButton_Refresh_Processes_UserPortfolio.click();
        }));
    }
    function confirmTrainingCertificationProcessByCertificationResponsibleToNo(record, window) {

        let baseUrl = trainingCertificationBPMSUrl;
        let url = "/tasks/certification-responsible-no/training-certification/review";
        let reviewTaskRequest = {
            taskId: record.taskId,
            approve: true,
            userName: userUserName,
            processInstanceId: record.processInstanceId,
            variables: {}
        };

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url, "POST", JSON.stringify(reviewTaskRequest), function (resp) {
            wait.close();
            let response = JSON.parse(resp.httpResponseText);
            window.close();
            createDialog("info", response.message);
            ToolStripButton_Refresh_Processes_UserPortfolio.click();
        }));
    }
    function confirmTrainingCertificationProcessByFinancialResponsible(record, window) {

        let baseUrl = trainingCertificationBPMSUrl;
        let url = "/tasks/financial-responsible/training-certification/review";
        let reviewTaskRequest = {
            taskId: record.taskId,
            approve: true,
            userName: userUserName,
            processInstanceId: record.processInstanceId,
            variables: {}
        };

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url, "POST", JSON.stringify(reviewTaskRequest), function (resp) {
            wait.close();
            let response = JSON.parse(resp.httpResponseText);
            window.close();
            createDialog("info", response.message);
            ToolStripButton_Refresh_Processes_UserPortfolio.click();
        }));
    }
    function confirmTrainingCertificationProcessByCertificationResponsibleForApproval(record, window) {

        let baseUrl = trainingCertificationBPMSUrl;
        let url = "/tasks/certification-responsible-approval/training-certification/review";
        let reviewTaskRequest = {
            taskId: record.taskId,
            approve: true,
            userName: userUserName,
            processInstanceId: record.processInstanceId,
            variables: {}
        };

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url, "POST", JSON.stringify(reviewTaskRequest), function (resp) {
            wait.close();
            let response = JSON.parse(resp.httpResponseText);
            window.close();
            createDialog("info", response.message);
            ToolStripButton_Refresh_Processes_UserPortfolio.click();
        }));
    }
    function confirmTrainingCertificationProcessByTrainingManager(record, window) {

        let baseUrl = trainingCertificationBPMSUrl;
        let url = "/tasks/training-manager/training-certification/review";
        let reviewTaskRequest = {
            taskId: record.taskId,
            approve: true,
            userName: userUserName,
            processInstanceId: record.processInstanceId,
            variables: {}
        };

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url, "POST", JSON.stringify(reviewTaskRequest), function (resp) {
            wait.close();
            let response = JSON.parse(resp.httpResponseText);
            window.close();
            createDialog("info", response.message);
            ToolStripButton_Refresh_Processes_UserPortfolio.click();
        }));
    }
    function confirmTrainingCertificationProcessByCertificationResponsibleForIssuing(record, window) {

        let baseUrl = trainingCertificationBPMSUrl;
        let url = "/tasks/certification-responsible-issuing/training-certification/review";
        let reviewTaskRequest = {
            taskId: record.taskId,
            approve: true,
            userName: userUserName,
            processInstanceId: record.processInstanceId,
        };

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url, "POST", JSON.stringify(reviewTaskRequest), function (resp) {
            wait.close();
            let response = JSON.parse(resp.httpResponseText);
            window.close();
            createDialog("info", response.message);
            ToolStripButton_Refresh_Processes_UserPortfolio.click();
        }));
    }
    function downloadTrainingCertification(record, window) {

        let baseUrl = trainingCertificationBPMSUrl;
        let url = "/download/training-certification";

        // wait.show();
        // isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url, "POST", JSON.stringify(reviewTaskRequest), function (resp) {
        //     wait.close();
        //     let response = JSON.parse(resp.httpResponseText);
        //     window.close();
        //     createDialog("info", response.message);
        //     ToolStripButton_Refresh_Processes_UserPortfolio.click();
        // }));
    }

    function confirmGroupProcess(records) {

        let baseUrl = requestItemBPMSUrl;
        let url = "/tasks/request-item/review/group";

        let reviewTaskRequestList = [];
        for (let i = 0; i < records.length; i++) {
            let ass_data = {};
            let reviewTaskRequest = {
                taskId: records[i].taskId,
                approve: true,
                userName: userUserName,
                processInstanceId: records[i].processInstanceId,
                variables: ass_data
            };
            reviewTaskRequestList.add(reviewTaskRequest);
        }

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url, "POST", JSON.stringify(reviewTaskRequestList), function (resp) {
            wait.close();
            let hasException = JSON.parse(resp.httpResponseText);
            if (hasException === false) {
                createDialog("info", "<spring:message code='global.form.request.successful'/>");
            } else {
                createDialog("info", "ارسال بعضی از درخواست ها با مشکل مواجه شده است");
            }
            ToolStripButton_Refresh_Processes_UserPortfolio.click();
        }));
    }
    function confirmGroupParallelRequestItemProcess(records) {

        let baseUrl = requestItemBPMSUrl;
        let url = "/tasks/parallel/request-item/review/group";

        let reviewTaskRequestList = [];
        for (let i = 0; i < records.length; i++) {
            let ass_data = {
                "assigneeList": records[i].assigneeList,
            };
            let reviewTaskRequest = {
                taskId: records[i].taskId,
                approve: true,
                userName: userUserName,
                processInstanceId: records[i].processInstanceId,
                variables: ass_data
            };
            reviewTaskRequestList.add(reviewTaskRequest);
        }

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url + "/" + "<%= userNationalCode %>", "POST", JSON.stringify(reviewTaskRequestList), function (resp) {
            wait.close();
            let hasException = JSON.parse(resp.httpResponseText);
            if (hasException === false) {
                createDialog("info", "<spring:message code='global.form.request.successful'/>");
            } else {
                createDialog("info", "ارسال بعضی از درخواست ها با مشکل مواجه شده است");
            }
            ToolStripButton_Refresh_Processes_UserPortfolio.click();
        }));
    }
    function confirmGroupRequestItemProcessToDetermineStatus(records) {

        let baseUrl = requestItemBPMSUrl;
        let url = "/tasks/determine-status/request-item/review/group";

        let reviewTaskRequestList = [];
        for (let i = 0; i < records.length; i++) {
            let ass_data = {
                "assignFrom": records[i].assignFrom,
            };
            let reviewTaskRequest = {
                taskId: records[i].taskId,
                approve: true,
                userName: userUserName,
                processInstanceId: records[i].processInstanceId,
                variables: ass_data
            };
            reviewTaskRequestList.add(reviewTaskRequest);
        }

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url+ "/" + "<%= userNationalCode %>", "POST", JSON.stringify(reviewTaskRequestList), function (resp) {
            wait.close();
            let hasException = JSON.parse(resp.httpResponseText);
            if (hasException === false) {
                createDialog("info", "<spring:message code='global.form.request.successful'/>");
            } else {
                createDialog("info", "ارسال بعضی از درخواست ها با مشکل مواجه شده است");
            }
            ToolStripButton_Refresh_Processes_UserPortfolio.click();
        }));
    }
    function confirmGroupRequestItemProcessByAppointmentExpert(records, letterNumberSent, dateSent, window) {

        let baseUrl = requestItemBPMSUrl;
        let url = "/tasks/appointment-expert/request-item/review/group";

        let bPMSReqItemSentLetterDtoList = [];
        for (let i = 0; i < records.length; i++) {
            let reviewTaskRequest = {
                taskId: records[i].taskId,
                approve: true,
                userName: userUserName,
                processInstanceId: records[i].processInstanceId,
            };
            let bPMSReqItemSentLetterDto = {
                letterNumberSent: letterNumberSent,
                dateSent: dateSent,
                reviewTaskRequest: reviewTaskRequest
            };
            bPMSReqItemSentLetterDtoList.add(bPMSReqItemSentLetterDto);
        }

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url, "POST", JSON.stringify(bPMSReqItemSentLetterDtoList), function (resp) {
            wait.close();
            let hasException = JSON.parse(resp.httpResponseText);
            if (hasException === false) {
                createDialog("info", "<spring:message code='global.form.request.successful'/>");
            } else {
                createDialog("info", "ارسال بعضی از درخواست ها با مشکل مواجه شده است");
            }
            window.close();
            ToolStripButton_Refresh_Processes_UserPortfolio.click();
        }));
    }
    function confirmGroupRequestItemProcessByPlanningChiefForApproval(records) {

        let baseUrl = requestItemBPMSUrl;
        let url = "/tasks/planning-chief-for-approval/request-item/review/group";

        let reviewTaskRequestList = [];
        for (let i = 0; i < records.length; i++) {
            let ass_data = {
                "assignFrom": records[i].assignFrom,
            };
            let reviewTaskRequest = {
                taskId: records[i].taskId,
                approve: true,
                userName: userUserName,
                processInstanceId: records[i].processInstanceId,
                variables: ass_data
            };
            reviewTaskRequestList.add(reviewTaskRequest);
        }

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url, "POST", JSON.stringify(reviewTaskRequestList), function (resp) {
            wait.close();
            let hasException = JSON.parse(resp.httpResponseText);
            if (hasException === false) {
                createDialog("info", "<spring:message code='global.form.request.successful'/>");
            } else {
                createDialog("info", "ارسال بعضی از درخواست ها با مشکل مواجه شده است");
            }
            ToolStripButton_Refresh_Processes_UserPortfolio.click();
        }));
    }

    function setTitle(name) {
        switch (name) {

            case "Job":
                return "<spring:message code="job"/>";
            case "Post":
                return "پست انفرادی";
            case "PostGrade":
                return "<spring:message code="post.grade"/>";
            case "PostGroup":
                return "<spring:message code="post.group"/>";
            case "JobGroup":
                return "<spring:message code="job.group"/>";
            case "PostGradeGroup":
                return "<spring:message code="post.grade.group"/>";
            case "TrainingPost":
                return "پست";

            default:
                return name.split('_').last();
        }
    }



    let RestDataSource_AllHeadsPortfolio = isc.TrDS.create({
        ID: "RestDataSource_AllHeadsPortfolio",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "nationalCode", hidden: true},
            {name: "firstName", title: "نام"},
            {name: "lastName", title: "نام خانوادگی"},
        ],
        fetchDataURL: operationalRoleUrl + "/findAllByObjectType/"+"HEAD_OF_PLANNING"
    });





function reAssignTask(record) {

        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            let baseUrl = "";
              interalBaseUrl = "";
            let url = ""
              interalUrl = ""
            let map_data = {};
            interalMap_data = {};
            interalRecord=record

            if (record.title.includes("نیازسنجی")) {
                baseUrl = bpmsUrl;
                interalBaseUrl = bpmsUrl;
                url = "/needAssessment/processes/reAssign-process";
                interalUrl = "/needAssessment/processes/reAssign-process";
                map_data = {
                    "objectId": ListGrid_Processes_UserPortfolio.getSelectedRecord().objectId,
                    "returnReason": null,
                    "objectType": ListGrid_Processes_UserPortfolio.getSelectedRecord().objectType
                };
                interalMap_data = {
                    "objectId": ListGrid_Processes_UserPortfolio.getSelectedRecord().objectId,
                    "returnReason": null,
                    "objectType": ListGrid_Processes_UserPortfolio.getSelectedRecord().objectType
                };
                wait.show();
                isc.RPCManager.sendRequest(TrDSRequest(bpmsUrl + "/checkHasHead/"+"HEAD_OF_PLANNING", "GET", null, (resp) => {
                    if (resp.httpResponseCode === 200 ) {
                        wait.close();
                        doReAssignFunction(map_data,record,baseUrl,url,null);
                    } else if (resp.httpResponseCode === 400 ) {
                        wait.close();

                        let Window_showHeadsPortfolio = isc.Window.create({
                            title: "انتخاب رییس برنامه ریزی",
                            width: "50%",
                            height: "50%",
                            keepInParentRect: true,
                            isModal: false,
                            autoSize: false,
                            items: [
                                isc.TrVLayout.create({
                                    members: [
                                        isc.TrLG.create({
                                            ID: "ListGrid_AllHeadsPortfolio",
                                            dataSource: RestDataSource_AllHeadsPortfolio,
                                            showHeaderContextMenu: false,
                                            selectionType: "single",
                                            filterOnKeypress: true,
                                            autoFetchData:true,
                                            canDragRecordsOut: true,
                                            dragDataAction: "none",
                                            canAcceptDroppedRecords: true,
                                            fields: [
                                                {name: "id", title: "کد", autoFitData: true, autoFitWidthApproach: true,hidden: true},
                                                {name: "firstName", title: "نام"},
                                                {name: "lastName", title: "نام خانوادگی"},
                                                {name: "nationalCode",hidden: true},
                                            ],
                                            gridComponents: ["filterEditor", "header", "body"],

                                        }),
                                        isc.HLayout.create({
                                            layoutMargin: 5,
                                            showEdges: false,
                                            edgeImage: "",
                                            width: "100%",
                                            height:"10%",
                                            align: "center",
                                            padding: 10,
                                            membersMargin: 10,
                                            members: [
                                                isc.IButton.create({
                                                    title: "تایید",
                                                    click: function () {
                                                        if (ListGrid_AllHeadsPortfolio.getSelectedRecord() !== undefined && ListGrid_AllHeadsPortfolio.getSelectedRecord() !== null) {
                                                            doReAssignFunction(interalMap_data,interalRecord,interalBaseUrl,interalUrl,ListGrid_AllHeadsPortfolio.getSelectedRecord().nationalCode);

                                                            Window_showHeadsPortfolio.close()

                                                        }else {
                                                            isc.Dialog.create({
                                                                message: "رکوردی انتخاب نشده است!",
                                                                icon: "[SKIN]ask.png",
                                                                title: "توجه",
                                                                buttons: [isc.IButtonSave.create({title: "<spring:message code='global.ok'/>"})],
                                                                buttonClick: function (button, index) {
                                                                    this.close();
                                                                }
                                                            });
                                                        }
                                                    }
                                                })
                                                , isc.IButtonCancel.create({
                                                    title: "<spring:message code='cancel'/>",
                                                    prompt: "",
                                                    width: 100,
//icon: "<spring:url value="remove.png"/>",
                                                    orientation: "vertical",
                                                    click: function () {
                                                        Window_showHeadsPortfolio.close()
                                                    }
                                                })]
                                        })
                                    ]
                                })]
                        });
                        Window_showHeadsPortfolio.show();

                    }
                    else if (resp.httpResponseCode === 402 ) {
                        wait.close();
                        createDialog("info", "کاربر محترم .. دپارتمان شما در سیستم منابع انسانی مس ثبت نشده است..برای به جریان انداختن فرایند ابتدا دپارتمان خود را بروز کنید");
                    }


                }));

            } else if (record.title.includes("صلاحیت علمی و فنی")) {
                baseUrl = requestItemBPMSUrl;
                url = "/processes/request-item/reAssign-process/";
                map_data = {
                    "returnReason": null,
                };

                doReAssignFunction(map_data,record,baseUrl,url,null)
            }


        }
    }
    function reAssignTrainingCertificationTask(record) {

        let baseUrl = trainingCertificationBPMSUrl;
        let url = "/processes/training-certification/reAssign-process";
        let map_data = {
            "returnReason": null,
        };
        let reviewTaskRequest = {
            variables: map_data,
            processInstanceId: record.processInstanceId,
            taskId: record.taskId,
            approve: true,
            userName: userUserName,
        };
        let data = {
            reviewTaskRequest: reviewTaskRequest,
            reason: null,
        }

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url, "POST", JSON.stringify(data), function (resp) {
            wait.close();
            let response = JSON.parse(resp.httpResponseText);
            createDialog("info", response.message);
            ToolStripButton_Refresh_Processes_UserPortfolio.click();
        }));
    }
    function doReAssignFunction( map_data,record,baseUrl,url,HeadNationalCode) {
        let reviewTaskRequest = {}
        let data = {}
        reviewTaskRequest = {
            variables: map_data,
            processInstanceId: record.processInstanceId,
            taskId: record.taskId,
            approve: false,
            userName: userUserName,
        };
        data = {
            reviewTaskRequest: reviewTaskRequest,
            reason: null,
            headNationalCode: HeadNationalCode
        }

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url, "POST", JSON.stringify(data), function (resp) {
            wait.close();
            let response = JSON.parse(resp.httpResponseText);
            createDialog("info", response.message);
            ToolStripButton_Refresh_Processes_UserPortfolio.click();
        }));
    }
    function showExpertsOpinion(processRecord) {

        let ListGrid_Experts = isc.ListGrid.create({
            width: "100%",
            height: "35%",
            dataSource: RestDataSource_Experts,
            sortDirection: "descending",
            fields: [
                {name: "nationalCode", title: "<spring:message code="national.code"/>"},
                {name: "firstName", title: "<spring:message code="firstName"/>"},
                {name: "lastName", title: "<spring:message code="lastName"/>"},
                {name: "generalOpinion", title: "نظر کلی کارشناس"}
            ],
            showHoverComponents: true,
            showFilterEditor: true,
            filterOnKeypress: true,
            recordClick: function (viewer, record) {
                RestDataSource_Expert_Opinion_Courses.fetchDataURL = requestItemUrl + "/expert-opinion/" + processRecord.requestItemId + "/" + record.nationalCode;
                ListGrid_Experts_Opinion.invalidateCache();
                ListGrid_Experts_Opinion.fetchData();
            }
        });
        let ListGrid_Experts_Opinion = isc.ListGrid.create({
            width: "100%",
            height: "60%",
            dataSource: RestDataSource_Expert_Opinion_Courses,
            sortDirection: "descending",
            fields: [
                {name: "courseCode"},
                {name: "courseTitle", showHover: true},
                {name: "categoryTitle", showHover: true},
                {name: "subCategoryTitle", showHover: true},
                {name: "priority"},
                {name: "requestItemProcessDetailId", hidden: true}
            ],
            showHoverComponents: true,
            showFilterEditor: true,
            filterOnKeypress: true
        });
        let Button_Experts_Opinion_Close = isc.IButton.create({
            title: "بستن",
            align: "center",
            width: "140",
            click: function () {
                Window_Experts_Opinion.close();
            }
        });
        let HLayout_Experts_Opinion = isc.HLayout.create({
            width: "100%",
            height: "5%",
            align: "center",
            membersMargin: 10,
            members: [
                Button_Experts_Opinion_Close
            ]
        });
        let Window_Experts_Opinion = isc.Window.create({
            title: "نظر کارشناسان",
            autoSize: false,
            width: "50%",
            height: "60%",
            canDragReposition: true,
            canDragResize: true,
            autoDraw: false,
            autoCenter: true,
            isModal: false,
            items: [
                ListGrid_Experts,
                ListGrid_Experts_Opinion,
                HLayout_Experts_Opinion
            ]
        });
        RestDataSource_Experts.fetchDataURL = requestItemUrl + "/get-experts/" + processRecord.requestItemId + "/" + processRecord.assigneeList;
        ListGrid_Experts.invalidateCache();
        ListGrid_Experts.fetchData();
        Window_Experts_Opinion.show();
    }
    function showProcessHistory(processInstanceId) {

        isc.RPCManager.sendRequest(TrDSRequest(bpmsUrl + "/processes/process-instance-history/details/" + processInstanceId , "GET", null, function (resp) {
            wait.close();
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                let taskHistory = JSON.parse(resp.httpResponseText);
                ListGrid_Processes_History_UserPortfolio.setData(taskHistory);
            } else {
                createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
            }
        }));
    }
    function showProcessDetail(bPMSProcessName, processInstanceId) {

        let DynamicForm_Processes_Detail = isc.DynamicForm.create({
            colWidths: ["40%", "60%"],
            width: "100%",
            height: "100%",
            numCols: 2,
            autoFocus: "true",
            cellPadding: 5
        });
        let Window_Processes_Detail = isc.Window.create({
            title: "نمایش جزییات",
            autoSize: false,
            width: "25%",
            height: "30%",
            canDragReposition: true,
            canDragResize: true,
            autoDraw: false,
            autoCenter: true,
            isModal: false,
            items: [
                DynamicForm_Processes_Detail
            ]
        });

        if (bPMSProcessName.contains('شایستگی')) {

            isc.RPCManager.sendRequest(TrDSRequest(bpmsUrl + "/processes/details/" + processInstanceId, "GET", null, function (resp) {
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    let detail = JSON.parse(resp.httpResponseText);
                    DynamicForm_Processes_Detail.setDataSource(RestDataSource_Processes_Detail_Competence_UserPortfolio);
                    DynamicForm_Processes_Detail.setValues(detail);
                    Window_Processes_Detail.show();
                } else {
                    createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                }
            }));
        } else {

            isc.RPCManager.sendRequest(TrDSRequest(requestItemBPMSUrl + "/processes/details/" + processInstanceId, "GET", null, function (resp) {
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    let detail = JSON.parse(resp.httpResponseText);
                    DynamicForm_Processes_Detail.setDataSource(RestDataSource_Processes_Detail_Certification_UserPortfolio);
                    DynamicForm_Processes_Detail.setValues(detail);
                    Window_Processes_Detail.show();
                } else {
                    createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                }
            }));
        }
    }
    function reAssignToPlanningChiefFromExpert(record) {

        let baseUrl = requestItemBPMSUrl;
        let url = "/processes/parallel/request-item/reAssign-process";
        let map_data = {
            "returnReason": null,
        };
        let reviewTaskRequest = {
            variables: map_data,
            processInstanceId: record.processInstanceId,
            taskId: record.taskId,
            approve: true,
            userName: userUserName,
        };
        let data = {
            reviewTaskRequest: reviewTaskRequest,
            reason: null,
        }

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(baseUrl + url, "POST", JSON.stringify(data), function (resp) {
            wait.close();
            let response = JSON.parse(resp.httpResponseText);
            createDialog("info", response.message);
            ToolStripButton_Refresh_Processes_UserPortfolio.click();
        }));
    }

// </script>