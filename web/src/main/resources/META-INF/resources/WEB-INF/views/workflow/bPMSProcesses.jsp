<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

// <script>

    <spring:eval var="restApiUrl" expression="@environment.getProperty('nicico.rest-api.url')"/>
    <% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN); %>

    let taskId = "e4188b49-72ba-11ec-a9d9-0242ac1f0007";
    let deploymentId = "0a8ab1c8-71df-11ec-a985-0242ac1f0007";

    //-------------------------------------------------- Rest DataSources --------------------------------------------------
    let RestDataSource_BPMSProcesses = isc.TrDS.create({
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

//----------------------------------------------------- Main Layout ----------------------------------------------------
    let Menu_BPMSProcesses = isc.Menu.create({
        width: 150,
        data: [
            {
                icon: "contact.png",
                title: "<spring:message code="process.image"/>",
                click: function () {
                    showBPMSProcessImage(taskId, deploymentId);
                }
            }
        ]
    });

    let ToolStripButton_showForm_BPMSProcesses = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/column_preferences.png",
        title: "<spring:message code="display.process.form"/>",
        click: function () {

        }
    });

    let ToolStripButton_showImage_BPMSProcesses = isc.ToolStripButton.create({
        icon: "contact.png",
        title: "<spring:message code="process.image"/>",
        click: function () {
            showBPMSProcessImage(taskId, deploymentId);
        }
    });

    let ToolStrip_Actions_BPMSProcesses = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStripButton_showForm_BPMSProcesses,
            ToolStripButton_showImage_BPMSProcesses
        ]
    });

    let HLayout_Actions_BPMSProcesses = isc.HLayout.create({
        width: "100%",
        members: [
            ToolStrip_Actions_BPMSProcesses
        ]
    });

    let ListGrid_BPMSProcesses = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_BPMSProcesses,
        sortDirection: "descending",
        contextMenu: Menu_BPMSProcesses,
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

    let HLayout_Grid_BPMSProcesses = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [
            ListGrid_BPMSProcesses
        ]
    });

    let VLayout_BPMSProcesses = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            HLayout_Actions_BPMSProcesses,
            HLayout_Grid_BPMSProcesses
        ]
    });

//------------------------------------------------------ Functions -----------------------------------------------------
    function showBPMSProcessImage(taskId, deploymentId) {

        // TODO add origin to URL
        let origin = window.location.origin;
        let imageFlow = isc.HTMLFlow.create({
            width: "70%",
            height: "60%",
            align: "center",
            contents: ""
        });
        let Window_ShowImage_BPMSProcesses = isc.Window.create({
            title: "تصویر فرایند",
            width: "60%",
            height: "60%",
            align: "center",
            items: []
        });
        imageFlow.setContents('');
        imageFlow.setContents('<div style="width: 100%;height: 59vh"><iframe width="100%" height="100%" ' +
            'src="http://devapp01.icico.net.ir/workflow/iframe/task/detail?type=ext&taskId='+ taskId +'&deploymentId='+ deploymentId +'&token' +
            '=Bearer <%= accessToken %>" frameborder="0" id="iframe_bpms"></iframe></div>');
        Window_ShowImage_BPMSProcesses.addItem(imageFlow);
        Window_ShowImage_BPMSProcesses.show();
    }

// </script>