<%--
  Created by IntelliJ IDEA.
  User: p-dodangeh
  Date: 1/12/2019
  Time: 4:34 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>


// <script>

    <spring:eval var="restApiUrl" expression="@environment.getProperty('nicico.rest-api.url')"/>

    var Menu_ListGrid_UserTaskList = isc.Menu.create({
        width: 150,
        data: [
            {
                title: "<spring:message code="show.workflow.relation.job"/>", icon: "pieces/512/showProcForm.png",
                click: function () {
                    ListGrid_WorkflowUserTaskList_showTaskForm();
                }
            },
            {
                title: "<spring:message code="workflow.history"/>", icon: "pieces/512/showProcForm.png",
                click: function () {
                    ListGrid_WorkflowUserTaskList_showTaskHistory();
                }
            }
        ]
    });

    isc.ViewLoader.create({
        ID: "taskConfirmViewLoader",
        width: "100%",
        height: "100%",
        autoDraw: false,
        viewURL: "",
        loadingMessage: "Loading Grid.."
    });

    isc.Window.create(
        {
            ID: "taskConfirmationWindow",
            title: "<spring:message code="complete.the.process"/>",
            autoSize: false,
            width: "80%",
            height: "90%",
            canDragReposition: true,
            canDragResize: true,
            autoDraw: false,
            autoCenter: true,
            isModal: false,
            items: [
                taskConfirmViewLoader
            ]
        });

    var userTaskViewLoader = isc.ViewLoader.create({
        width: "100%",
        height: "100%",
        autoDraw: false,
        //border: "10px solid black",
        viewURL: "",
        loadingMessage: "<spring:message code="work.form.not.selected"/>"
    });

    <%--Get Process Form Details--%>

    function ListGrid_WorkflowUserTaskList_showTaskForm() {

        var record = ListGrid_UserTaskList.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "<spring:message code="msg.no.records.selected"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="global.message"/>",
                buttons: [isc.IButtonSave.create({title: "<spring:message code="global.ok"/>"})],
                buttonClick: function () {
                    this.hide();
                }
            });
        } else {


            var taskID = record.id;
            <spring:url value="/web/workflow/getUserCartableDetailForm/" var="getUserCartableDetailForm"/>
            taskConfirmViewLoader.setViewURL("${getUserCartableDetailForm}" + taskID + "/" + record.assignee + "?Authorization=Bearer " + "${cookie['access_token'].getValue()}");
            taskConfirmationWindow.show();
        }
    }

    function ListGrid_WorkflowUserTaskList_showTaskHistory() {

        var record = ListGrid_UserTaskList.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "<spring:message code="msg.no.records.selected"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="global.message"/>",
                buttons: [isc.IButtonSave.create({title: "<spring:message code="global.ok"/>"})],
                buttonClick: function () {
                    this.hide();
                }
            });
        } else {

            var pId = record.processInstanceId;
            <spring:url value="/web/workflow/getUserTaskHistoryForm/" var="getUserTaskHistoryForm"/>

            userTaskViewLoader.setViewURL("${getUserTaskHistoryForm}" + pId);

            activeDocumentDS.fetchDataURL = workflowUrl + "/userTaskHistory/list/" + pId;

            setTimeout(function () {
                ListGrid_DocumentActivity.invalidateCache();
                ListGrid_DocumentActivity.fetchData();
            }, 500);
        }
    }

    userTaskViewLoader.setViewURL("${getUserTaskHistoryForm}" + 0);
    userTaskViewLoader.show();

    var TSB_Refresh_userCartableForm = isc.ToolStripButtonRefresh.create({
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_UserTaskList.clearFilterValues();
            ListGrid_UserTaskList.invalidateCache();
            activitiRefreshButton.click();
        }
    });

    var ToolStripButton_showUserTaskForm = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/column_preferences.png",
        title: "<spring:message code="show.workflow.job.form"/>",
        click: function () {
            ListGrid_WorkflowUserTaskList_showTaskForm();
        }
    });

    var ToolStripButton_showUserTaskHistoryForm = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/column_preferences.png",
        title: "<spring:message code="workflow.history"/>",
        click: function () {
            ListGrid_WorkflowUserTaskList_showTaskHistory();
        }
    });


    var ToolStrip_UserTask_Actions = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStripButton_showUserTaskForm, ToolStripButton_showUserTaskHistoryForm,
            isc.ToolStrip.create(
                {
                    width: "100%",
                    align: "left",
                    border: "0px",
                    members: [TSB_Refresh_userCartableForm]
                }
            )
        ]
    });

    var HLayout_UserTask_Actions = isc.HLayout.create({
        width: "100%",
        members: [
            ToolStrip_UserTask_Actions
        ]
    });

    var RestDataSource_UserTaskList = isc.TrDS.create({
        fields: [

            {name: "name", title: "<spring:message code="title"/>"},
            {name: "startDateFa", title: "<spring:message code="creation.date"/>"},
            {name: "cTime", title: "<spring:message code="time"/>"},
            {name: "endTimeFa", title: "<spring:message code="end.date"/>", width: "30%"},
            {name: "description", title: "<spring:message code="description"/>"},
            {name: "taskDef", title: "<spring:message code="work.definition"/>"},
            {name: "id", title: "id", type: "text"},
            {name: "assignee", title: "assignee", type: "text"},
            {name: "processInstanceId", title: "PID", type: "text"}

        ],
        dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {

            dsRequest.httpHeaders = {
                "Authorization": "Bearer <%= accessToken %>"
            };
            return this.Super("transformRequest", arguments);
        },

        fetchDataURL: workflowUrl + "/userTask/list?usr=${username}"
    });

    var ListGrid_UserTaskList = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        autoFetchData: true,
        dataSource: RestDataSource_UserTaskList,
        sortDirection: "descending",
        contextMenu: Menu_ListGrid_UserTaskList,
        doubleClick: function () {
            ListGrid_WorkflowUserTaskList_showTaskForm();
        },
        fields: [

            {name: "name", title: "<spring:message code="work.name"/>", width: "30%"},
            {name: "description", title: "<spring:message code="description"/>", width: "70%"},
            {name: "id", title: "id", type: "text", width: "1%", hidden: true},
        ],
        sortField: 0,
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        filterOnKeypress: true,
        sortFieldAscendingText: "<spring:message code="sort.ascending"/>",
        sortFieldDescendingText: "<spring:message code="sort.descending"/>",
        configureSortText: "<spring:message code="configureSortText"/>",
        autoFitAllText: "<spring:message code="autoFitAllText"/>",
        autoFitFieldText: "<spring:message code="autoFitFieldText"/>",
        filterUsingText: "<spring:message code="filterUsingText"/>",
        groupByText: "<spring:message code="groupByText"/>",
        freezeFieldText: "<spring:message code="freezeFieldText"/>",
        selectionUpdated: function(record, recordList) {
            ListGrid_WorkflowUserTaskList_showTaskHistory();
        }


    });


    var HLayout_UserTaskGrid = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "10px solid green",--%>

        members: [
            ListGrid_UserTaskList
        ]
    });

    var VLayout_Menu_Grid = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [HLayout_UserTask_Actions, HLayout_UserTaskGrid]

    });

    var VLayout_Task_ViewLoader = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [userTaskViewLoader]

    });

    var HLayout_UserTaskBody = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "10px solid red",--%>
        members: [
            VLayout_Menu_Grid, VLayout_Task_ViewLoader
        ]
    });