<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.training.controller.util.AppUtils" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%
    final String tenantId = AppUtils.getTenantId();
%>
// <script>

    <spring:eval var="restApiUrl" expression="@environment.getProperty('nicico.rest-api.url')"/>
    <% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN); %>

    //-------------------------------------------------- Rest DataSources --------------------------------------------------

    let RestDataSource_Processes_UserPortfolio = isc.TrDS.create({
        fields: [
            {name: "name", title: "عنوان تسک"},
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
                "tenantId": "<%= tenantId %>",
                "page": 0,
                "size": 100
            };
            dsRequest.httpMethod = "POST";
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: bpmsUrl + "/tasks/searchAll"
    });

//----------------------------------------------------- Main Layout ----------------------------------------------------
    let Menu_BPMSProcesses = isc.Menu.create({
        width: 150,
        data: [
            {
                icon: "contact.png",
                title: "<spring:message code="process.image"/>",
                click: function () {
                    showBPMSProcessImage(ListGrid_BPMSProcesses.getSelectedRecord().taskId, ListGrid_BPMSProcesses.getSelectedRecord().deploymentId);
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
            showBPMSProcessImage(ListGrid_BPMSProcesses.getSelectedRecord().taskId, ListGrid_BPMSProcesses.getSelectedRecord().deploymentId);
        }
    });

    let ToolStrip_Actions_BPMSProcesses = isc.ToolStrip.create({
        width: "100%",
        members: [
            // ToolStripButton_showForm_BPMSProcesses,
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
        dataSource: RestDataSource_Processes_UserPortfolio,
        sortDirection: "descending",
        contextMenu: Menu_BPMSProcesses,
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
            'src="'+ origin +'/workflow/iframe/task/detail?type=ext&taskId='+ taskId +'&deploymentId='+ deploymentId +'&token' +
            '=Bearer <%= accessToken %>" frameborder="0" id="iframe_bpms"></iframe></div>');
        Window_ShowImage_BPMSProcesses.addItem(imageFlow);
        Window_ShowImage_BPMSProcesses.show();
    }

// </script>