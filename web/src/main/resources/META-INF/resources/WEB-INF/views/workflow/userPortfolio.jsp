<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.training.controller.util.AppUtils" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
    final String tenantId = AppUtils.getTenantId();
    final String userNationalCode = SecurityUtil.getNationalCode();
    final String userUserName = SecurityUtil.getUsername();
%>

<%--<spring:eval var="restApiUrl" expression="@environment.getProperty('nicico.rest-api.url')"/>--%>

// <script>

//-------------------------------------------------- Rest DataSources --------------------------------------------------

    let RestDataSource_Processes_UserPortfolio = isc.TrDS.create({
        fields: [
            {name: "name", title: "فرایند"},
            {name: "deploymentId"},
            {name: "tenantId", title: "زیرسیستم"},
            {name: "createBy", title: "ایجاد کننده"},
            {name: "title", title: "عنوان"},
            {name: "processInstanceId", title: "شناسه فرایند"},
            {name: "processDefinitionId"},
            {name: "taskId"},
            {name: "tenantTitle"},
            {name: "date", title: "تاریخ"},
            {name: "processStartTime", title: "تاریخ شروع فرایند"},
            {name: "taskDefinitionKey"},
            {name: "processDefinitionKey"}
            // {name: "owner", title: "درخواست دهنده"},
            // {name: "description"},
            // {name: "processDocumentation"},
            // {name: "postTitle"},
            // {name: "senderUserName"},
            // {name: "instanceDetails"},
            // {name: "formListDTOS"}
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
            {name: "approved"},
            {name: "owner"}
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
            {name: "processInstanceId", hidden: true}
        ]
    });

//--------------------------------------------------- Process Layout ---------------------------------------------------

    let ToolStripButton_Refresh_Processes_UserPortfolio = isc.ToolStripButtonRefresh.create({
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_Processes_UserPortfolio.clearFilterValues();
            ListGrid_Processes_UserPortfolio.invalidateCache();
        }
    });
    let ToolStripButton_Show_Processes_UserPortfolio = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/column_preferences.png",
        title: "نمایش جزییات و تکمیل فرایند",
        click: function () {
            let record = ListGrid_Processes_UserPortfolio.getSelectedRecord();
            showProcessAndCompletion(record);
        }
    });
    let ToolStripButton_Show_Processes_History_UserPortfolio = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/column_preferences.png",
        title: "<spring:message code="workflow.history"/>",
        click: function () {
        }
    });
    let ToolStrip_Actions_Processes_UserPortfolio = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStripButton_Show_Processes_UserPortfolio,
            // ToolStripButton_Show_Processes_History_UserPortfolio,
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
            {name: "name"},
            {name: "deploymentId", hidden: true},
            {name: "tenantId", hidden: true},
            {name: "createBy"},
            {name: "title"},
            {name: "processInstanceId", hidden: true},
            {name: "processDefinitionId", hidden: true},
            {name: "taskId", hidden: true},
            {name: "tenantTitle", hidden: true},
            {name: "date"},
            {name: "processStartTime"},
            {name: "taskDefinitionKey", hidden: true},
            {name: "processDefinitionKey", hidden: true}
        ],
        sortField: 0,
        dataPageSize: 50,
        showFilterEditor: true,
        filterOnKeypress: true,
        rowDoubleClick: function (record) {
            showProcessAndCompletion(record);
        },
        recordClick: function(viewer, record) {
            showProcessHistory(record.processInstanceId);
        }
    });
    let VLayout_Processes_UserPortfolio = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [ToolStrip_Actions_Processes_UserPortfolio, ListGrid_Processes_UserPortfolio]
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
        doubleClick: function () {
        },
        fields: [
            {name: "timeComing", title: "زمان ورود به کارتابل"},
            {name: "waitingTime", title: "زمان انتظار"},
            {name: "taskDefinitionKey", hidden: true},
            {name: "assignee", title: "منتسب شده به"},
            {name: "taskId", hidden: true},
            {name: "name", title: "فرایند"},
            {name: "post", title: "", hidden: true},
            {name: "approved", title: "تایید شده"},
            {name: "owner", title: "مالک"}
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
            VLayout_Processes_UserPortfolio, VLayout_Processes_History_UserPortfolio
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
                        height: "100%",
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
                        align: "center",
                        membersMargin: 10,
                        members: [
                            isc.Button.create({
                                title: "<spring:message code='global.ok'/>",
                                click: function () {
                                    if (!reasonForm.validate()) {
                                        return;
                                    }
                                    // TODO call return process API
                                    let reason = reasonForm.getField("returnReason").getValue();
                                    isc.RPCManager.sendRequest(TrDSRequest(bpmsUrl + "/processes/cancel-process/" + record.processInstanceId , "POST", reason, function (resp) {
                                        wait.close();
                                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                            window.close();
                                            createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                            ListGrid_Processes_UserPortfolio.invalidateCache();
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
                height: "100%",
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
                    }
                ]
            });
            let Button_Completion_Detail = isc.IButton.create({
                title: "مشاهده جزییات",
                align: "center",
                width: "120",
                click: function () {
                    showProcessDetail(record.name, record.processInstanceId);
                }
            });
            let Button_Completion_Confirm = isc.IButton.create({
                title: "تایید فرایند",
                align: "center",
                width: "120",
                click: function () {
                    confirmProcess(record.taskId, record.processInstanceId, Window_Completion_UserPortfolio);
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
            Window_Completion_UserPortfolio.show();
        }
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

        let processName = "";
        let DynamicForm_Processes_Detail = isc.DynamicForm.create({
            // dataSource: RestDataSource_Processes_Detail_Competence_UserPortfolio,
            colWidths: ["40%", "60%"],
            width: "100%",
            height: "100%",
            numCols: 2,
            autoFocus: "true",
            cellPadding: 5,
            fields: [
                {
                    name: "code",
                    // title: "کد",
                    // type: "staticText"
                },
                {
                    name: "competenceType.title",
                    // title: "نوع",
                    // type: "staticText"
                },
                {
                    name: "category.titleFa",
                    // title: "گروه",
                    // type: "staticText"
                },
                {
                    name: "subCategory.titleFa",
                    // title: "زیرگروه",
                    // type: "staticText"
                },
                {
                    name: "workFlowStatusCode",
                    // title: "وضعیت گردش کار",
                    // type: "staticText",
                    // valueMap: {
                    //     0: "ارسال به گردش کار",
                    //     1: "عدم تایید",
                    //     2: "تایید نهایی",
                    //     3: "حذف گردش کار",
                    //     4: "اصلاح شایستگی و ارسال به گردش کار"
                    // }
                },
                {
                    name: "description",
                    // title: "توضیحات",
                    // type: "staticText"
                }
            ]
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
            processName = "competence";
        }
        isc.RPCManager.sendRequest(TrDSRequest(bpmsUrl + "/processes/details/" + processInstanceId + "/" + processName, "GET", null, function (resp) {
            wait.close();
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                let detail = JSON.parse(resp.httpResponseText);
                if (processName === "competence")
                    DynamicForm_Processes_Detail.setDataSource(RestDataSource_Processes_Detail_Competence_UserPortfolio);
                DynamicForm_Processes_Detail.setValues(detail);
                Window_Processes_Detail.show();
            } else {
                createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
            }
        }));
    }
    function confirmProcess(taskId, processInstanceId, window) {

        let reviewTaskRequest = {
          taskId: taskId,
          approve: false,
          userName: userUserName,
          processInstanceId: processInstanceId
        };
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(bpmsUrl + "/tasks/review", "POST", JSON.stringify(reviewTaskRequest), function (resp) {
            wait.close();
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                window.close();
                createDialog("info", "<spring:message code="global.form.request.successful"/>");
                ListGrid_Processes_UserPortfolio.invalidateCache();
            } else {
                window.close();
                createDialog("info", "عملیات انجام نشد");
            }
        }));
    }

// </script>