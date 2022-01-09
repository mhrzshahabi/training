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
                }
            },
            {
                title: "<spring:message code="workflow.history"/>", icon: "pieces/512/showProcForm.png",
                click: function () {
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

    isc.Window.create({
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
        }
    });

    var ToolStripButton_showUserTaskHistoryForm = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/column_preferences.png",
        title: "<spring:message code="workflow.history"/>",
        click: function () {
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
        },
        fields: [

            {name: "name", title: "<spring:message code="work.name"/>", width: "30%"},
            {name: "description", title: "<spring:message code="description"/>", width: "70%"},
            {name: "id", title: "id", type: "text", width: "1%", hidden: true},
        ],
        sortField: 0,
        dataPageSize: 50,
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
        }
    });

    var HLayout_UserTaskGrid = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [
            ListGrid_UserTaskList
        ]
    });

    VLayout_Processes_UserPortfolio = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [HLayout_UserTask_Actions, HLayout_UserTaskGrid]

    });

    VLayout_Processes_History_UserPortfolio = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [userTaskViewLoader]

    });

    HLayout_Main_UserPortfolio = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [
            VLayout_Processes_UserPortfolio, VLayout_Processes_History_UserPortfolio
        ]
    });

// </script>