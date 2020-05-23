<%--
  Created by IntelliJ IDEA.
  User: p-dodangeh
  Date: 1/12/2019
  Time: 4:34 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

// <script>

    <spring:eval var="restApiUrl" expression="@environment.getProperty('nicico.rest-api.url')"/>

    var Menu_ListGrid_WorkflowProcessInstance_List = isc.Menu.create({
        width: 150,
        data: [

            {
                icon: "contact.png",
                title: "<spring:message code="process.image"/>",
                click: function () {
                    ListGrid_WorkflowProcessList_showProcessImage();
                }
            },
            {
                title: "<spring:message code="process.status"/>", icon: "upload.png",
                click: function () {
                    ListGrid_WorkflowProcessInstance_showImage();
                }
            }
        ]
    });

    var workflowProcessInstanceViewLoader = isc.ViewLoader.create({
        width: "100%",
        height: "100%",
        autoDraw: false,
        <%--border: "10px solid black",--%>
        viewURL: "",
        loadingMessage: "<spring:message code="there.is.no.process.form.to.display"/>"
    });

    function ListGrid_WorkflowProcessList_showProcessImage() {

        var record = ListGrid_ProcessInstanceList.getSelectedRecord();

        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "<spring:message code="msg.no.records.selected"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="global.message"/>",
                buttons: [isc.Button.create({title: "<spring:message code="global.ok"/>"})],
                buttonClick: function (button, index) {
                    this.hide();
                }
            });
        } else {
            var processId = record.id;
            var procDefId = record.processDefinitionId;
            <spring:url value="/web/workflow/processInstance/diagram/" var="diagramUrl"/>
            workflowProcessInstanceViewLoader.setViewURL("${diagramUrl}" + processId + "?procDefId="
                + procDefId + "&Authorization=Bearer " + '${cookie['access_token'].getValue()}');
            workflowProcessInstanceViewLoader.show();
        }

    }


    var ToolStripButton_showProcessInstanceForm = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/column_preferences.png",
        title: "<spring:message code="display.process.form"/>",
        click: function () {
            ListGrid_WorkflowProcessList_showProcessInstanceForm();
        }
    });

    var ToolStripButton_showProcessImage = isc.ToolStripButton.create({
        icon: "contact.png",
        title: "<spring:message code="process.image"/>",
        click: function () {
            ListGrid_WorkflowProcessList_showProcessImage();
        }
    });


    var ToolStrip_ProcessInstanceActions = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStripButton_showProcessInstanceForm,
            ToolStripButton_showProcessImage
        ]
    });

    var HLayout_ProcessInstanceActions = isc.HLayout.create({
        width: "100%",
        members: [
            ToolStrip_ProcessInstanceActions
        ]
    });

    var RestDataSource_ProcessInstanceList = isc.TrDS.create({
        fields: [
            {name: "startDateEn", title: "<spring:message code="start.date"/>"},
            {name: "endDate", title: "<spring:message code="end.date"/>"},
            {name: "variableInstances.cId.textValue", title: "<spring:message code="competency.number"/>"},
            {name: "processDefinitionKey", title: "<spring:message code="key"/>"},
            {name: "processDefinitionVersion", title: "<spring:message code="version"/>"},
            {name: "id", title: "id", type: "text"}
        ],
        fetchDataURL: workflowUrl + "/allProcessInstance/list"
    });


    var ListGrid_ProcessInstanceList = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_ProcessInstanceList,
        sortDirection: "descending",
        contextMenu: Menu_ListGrid_WorkflowProcessInstance_List,
        fields: [
            {name: "variableInstances.userFullName.textValue", title: "<spring:message code="created.by.user"/>", width: "30%"},
            {name: "startDateFa", title: "<spring:message code="start.date"/>", width: "30%",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {name: "endDateFa", title: "<spring:message code="end.date"/>", width: "30%",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {name: "variableInstances.cId.textValue", title: "<spring:message code="competency.number"/>", width: "30%",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "processDefinitionKey", title: "<spring:message code="process.key.uploaded"/>", width: "30%"},
            {name: "variableInstances.cTitle.textValue", title: "<spring:message code="description"/>", width: "30%"},
            {name: "processDefinitionVersion", title: "<spring:message code="version"/>", width: "30%",
                filterEditorProperties: {
                    keyPressFilter: "[0-9|.]"
                }
            },
            {name: "id", title: "id", type: "text", width: "30%",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
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
        startsWithTitle: "tt"
    });


    var HLayout_ProcessInstanceGrid = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "10px solid green",--%>

        members: [
            ListGrid_ProcessInstanceList
        ]
    });


    var VLayout_ProcessInstanceBody = isc.VLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "10px solid red",--%>
        members: [
            HLayout_ProcessInstanceActions, HLayout_ProcessInstanceGrid, workflowProcessInstanceViewLoader
        ]
    });