<%--
  Created by IntelliJ IDEA.
  User: p-dodangeh
  Date: 1/12/2019
  Time: 4:34 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>


<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    var Menu_ListGrid_GroupTaskList = isc.Menu.create({
        width: 150,
        data: [
            {
                title: "<spring:message code="show.workflow.job.form"/>", icon: "pieces/512/showProcForm.png",
                click: function () {
                    ListGrid_WorkflowGroupTaskList_showTaskForm();
                }
            },
            {
                title: "<spring:message code="workflow.history"/>", icon: "pieces/512/showProcForm.png",
                click: function () {
                    ListGrid_WorkflowGroupTaskList_showTaskHistory();
                }
            }
        ]
    });

    var GroupTask_ViewLoader = isc.ViewLoader.create({
        width: "100%",
        height: "100%",
        autoDraw: false,
//border: "10px solid black",
        viewURL: "",
        loadingMessage: "<spring:message code="work.form.not.selected"/>"
    });

    <%--Get Process Form Details--%>

    function ListGrid_WorkflowGroupTaskList_showTaskForm() {

        var record = ListGrid_GroupTaskList.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "<spring:message code="msg.no.records.selected"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="global.message"/>",
                buttons: [isc.Button.create({title: "<spring:message code="global.ok"/>"})],
                buttonClick: function () {
                    this.hide();
                }
            });
        } else {


            var taskID = record.id;
            <spring:url value="/web/workflow/getGroupCartableDetailForm/" var="getGroupCartableDetailForm"/>
            GroupTask_ViewLoader.setViewURL("${getGroupCartableDetailForm}" + taskID)
            GroupTask_ViewLoader.show();

        }
    }

    function ListGrid_WorkflowGroupTaskList_showTaskHistory() {

        var record = ListGrid_GroupTaskList.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "<spring:message code="msg.no.records.selected"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="global.message"/>",
                buttons: [isc.Button.create({title: "<spring:message code="global.ok"/>"})],
                buttonClick: function () {
                    this.hide();
                }
            });
        } else {
            var pId = record.processInstanceId;
            <spring:url value="/web/workflow/getUserTaskHistoryForm/" var="getUserTaskHistoryForm"/>
            GroupTask_ViewLoader.setViewURL("${getUserTaskHistoryForm}" + pId);
            GroupTask_ViewLoader.show();
        }
    }

    var ToolStripButton_showGroupTaskForm = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/column_preferences.png",
        title: "<spring:message code="show.workflow.job.form"/>",
        click: function () {
            ListGrid_WorkflowGroupTaskList_showTaskForm();
        }
    });

    var ToolStripButton_showGroupTaskHistoryForm = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/column_preferences.png",
        title: "<spring:message code="workflow.history"/>",
        click: function () {
            ListGrid_WorkflowGroupTaskList_showTaskHistory();
        }
    });
    var ToolStrip_GroupTask_Actions = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStripButton_showGroupTaskForm, ToolStripButton_showGroupTaskHistoryForm
        ]
    });

    var HLayout_GroupTask_Actions = isc.HLayout.create({
        width: "100%",
        members: [
            ToolStrip_GroupTask_Actions
        ]
    });

    var RestDataSource_GroupTaskList = isc.RestDataSource.create({
        fields: [

            {name: "name", title: "<spring:message code="work.name"/>"},
            {name: "startDate", title: "تاریخ ایجاد"},
            {name: "startDateFa", title: "تاریخ ایجاد شمسی"},
            {name: "cTime", title: "زمان"},
            {name: "processVariables.documentId.textValue", title: "شماره سند"},
            {name: "description", title: "<spring:message code="description"/>"},
            {name: "taskDef", title: "<spring:message code="work.definition"/>"},
            {name: "id", title: "id", type: "text"}
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

        <%--		fetchDataURL: "<spring:url value="/rest/workflow/groupTask/list?roles=${userRoles}"/>"--%>
        fetchDataURL: workflowUrl + "/groupTask/list?roles=${userRoles}"
    });

    var ListGrid_GroupTaskList = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_GroupTaskList,
        sortDirection: "descending",
        contextMenu: Menu_ListGrid_GroupTaskList,
        doubleClick: function () {
            ListGrid_WorkflowGroupTaskList_showTaskForm();
        },
        fields: [

            {name: "name", title: "<spring:message code="work.name"/>", width: "30%"},
            {name: "processVariables.documentId.textValue", title: "شماره سند", width: "30%"},
            {name: "id", title: "id", type: "text", width: "30%"}
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
        freezeFieldText: "<spring:message code="freezeFieldText"/>"

    });


    var HLayout_GroupTaskGrid = isc.HLayout.create({
        width: "100%",
        height: "100%",
//border: "10px solid green",

        members: [
            ListGrid_GroupTaskList
        ]
    });
    var VLayout_Menu_Grid_Group_Cartable = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [HLayout_GroupTask_Actions, HLayout_GroupTaskGrid]

    });
    var VLayout_Task_ViewLoader = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [GroupTask_ViewLoader]

    });

    var HLayout_GroupTaskBody = isc.HLayout.create({
        width: "100%",
        height: "100%",
//border: "10px solid red",
        members: [
            VLayout_Menu_Grid_Group_Cartable, VLayout_Task_ViewLoader
        ]
    });