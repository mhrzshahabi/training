<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

<%--<spring:eval var="restApiUrl" expression="@environment.getProperty('nicico.rest-api.url')"/>--%>

// <script>

//-------------------------------------------------- Rest DataSources --------------------------------------------------

    let RestDataSource_Processes_UserPortfolio = isc.TrDS.create({
        fields: [
            {name: "processInstanceId"},
            {name: "processDefinitionId"},
            {name: "taskId"},
            {name: "name"},
            {name: "tenantId"},
            {name: "tenantTitle"},
            {name: "owner"},
            {name: "description"},
            {name: "processDocumentation"},
            {name: "postTitle"},
            {name: "senderUserName"},
            {name: "processStartTime"},
            {name: "instanceDetails"},
            {name: "taskDefinitionKey"},
            {name: "processDefinitionKey"},
            {name: "formListDTOS"}
        ]
        <%--transformRequest: function (dsRequest) {--%>

        <%--    dsRequest.httpHeaders = {--%>
        <%--        "Authorization": "Bearer <%= accessToken %>"--%>
        <%--    };--%>
        <%--    return this.Super("transformRequest", arguments);--%>
        <%--},--%>
        <%--fetchDataURL: workflowUrl + "/userTask/list?usr=${username}"--%>
    });
    let RestDataSource_Processes_History_UserPortfolio = isc.TrDS.create({
        fields: [
            {name: "processDefinitionKey"},
            {name: "processDescription"},
            {name: "processInstanceId"},
            {name: "deploymentId"},
            {name: "processVersion"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "duration"},
            {name: "result"},
            {name: "deleteReason"},
            {name: "status"},
            {name: "taskHistoryDetailList"},
            {name: "comments"},
            {name: "waitingStateInfos"},
        ]
    });

//--------------------------------------------------- Process Layout ---------------------------------------------------

    let ToolStripButton_Refresh_Processes_UserPortfolio = isc.ToolStripButtonRefresh.create({
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_Processes_UserPortfolio.clearFilterValues();
            ListGrid_Processes_UserPortfolio.invalidateCache();
            // activitiRefreshButton.click();
        }
    });
    let ToolStripButton_Show_Processes_UserPortfolio = isc.ToolStripButton.create({
            icon: "[SKIN]/actions/column_preferences.png",
            title: "<spring:message code="show.workflow.job.form"/>",
            click: function () {
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
                ToolStripButton_Show_Processes_History_UserPortfolio,
                isc.ToolStrip.create(
                    {
                        width: "100%",
                        align: "left",
                        border: "0px",
                        members: [
                            ToolStripButton_Refresh_Processes_UserPortfolio
                        ]
                    }
                )
            ]
        });
    let Menu_Processes_UserPortfolio = isc.Menu.create({
        width: 150,
        data: [
            {
                title: "<spring:message code="show.workflow.relation.job"/>",
                icon: "pieces/512/showProcForm.png",
                click: function () {
                }
            },
            {
                title: "<spring:message code="workflow.history"/>",
                icon: "pieces/512/showProcForm.png",
                click: function () {
                }
            }
        ]
    });
    let ListGrid_Processes_UserPortfolio = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        autoFetchData: true,
        dataSource: RestDataSource_Processes_UserPortfolio,
        sortDirection: "descending",
        contextMenu: Menu_Processes_UserPortfolio,
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
            isc.ToolStrip.create(
                {
                    width: "100%",
                    align: "left",
                    border: "0px",
                    members: [
                        ToolStripButton_Refresh_Processes_History_UserPortfolio
                    ]
                }
            )
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
            {name: "name", title: "<spring:message code="work.name"/>", width: "30%"},
        ],
        sortField: 0,
        dataPageSize: 50,
        showFilterEditor: true,
        filterOnKeypress: true,
        selectionUpdated: function(record, recordList) {
        }
    });
    let VLayout_Processes_History_UserPortfolio = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [ToolStrip_Actions_Processes_History_UserPortfolio, ListGrid_Processes_History_UserPortfolio]
    });

//----------------------------------------------------- Main Layout ----------------------------------------------------
    let HLayout_Main_UserPortfolio = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [
            VLayout_Processes_UserPortfolio, VLayout_Processes_History_UserPortfolio
        ]
    });

// </script>