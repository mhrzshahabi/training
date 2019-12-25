<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

<%--
  Created by IntelliJ IDEA.
  User: p-dodangeh
  Date: 3/17/2019
  Time: 2:11 PM
  To change this template use File | Settings | File Templates.
--%>


// <script>

    var activitiRefreshButton = isc.ToolStripButtonRefresh.create({
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_DocumentActivity.invalidateCache();
            ListGrid_DocumentActivity.fetchData();
        }
    });
    var activitiGridControls = isc.ToolStrip.create({

        width: "100%", height: 20,
        members: [
            activitiRefreshButton
        ]
    });
    var ListGrid_DocumentActivity = isc.ListGrid.create({
        width: "100%",
        height: "60%",
        dataSource: activeDocumentDS,
        gridComponents: [activitiGridControls, "filterEditor", "header", "body"],
        showRowNumbers: true,
        showFilterEditor: true,
        autoFetchData: true,
        canMultiSort: false,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        fields: [

            {name: "id", type: "integer", title: "<spring:message code="identity"/>"},
            {name: "name", title: "<spring:message code="activity.name"/>"},
            {name: "assignee", title: "<spring:message code="attributable.to"/>"},
            {name: "startDateFa", title: "<spring:message code="start.date"/>"},
            {name: "startTime", title: "<spring:message code="start.time"/>"},
            {name: "endDateFa", title: "<spring:message code="end.date"/>"},
            {name: "endTime", title: "<spring:message code="end.time"/>"},
            {name: "duration", title: "<spring:message code="period.of.time"/>"},
            {name: "durationHours", title: "<spring:message code="hour"/>"},
            {name: "durationDay", title: "<spring:message code="day"/>"}

        ]
    });
    var activeDocumentDS = isc.RestDataSource.create({
        fields: [
            {name: "id", primaryKey: true, type: "integer", title: " ID"},
            {name: "name", title: "<spring:message code="activity.name"/>"},
            {name: "startDate", title: "<spring:message code="start.date"/>"},
            {name: "startTime", title: "<spring:message code="start.time"/>"},
            {name: "endTime", title: "workflow.endTime"},
            {name: "endDateFa", title: "<spring:message code="end.date"/>"},
            {name: "durationInMillis", title: "<spring:message code="period.of.time"/>"},
            {name: "assignee", title: "<spring:message code="attributable.to"/>"}
        ],
        dataFormat: "json",
        jsonPrefix: "",
        jsonSuffix: "",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer <%= accessToken %>"
                <%--"Access-Control-Allow-Origin": "${restApiUrl}"--%>
            };
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: workflowUrl + "/userTaskHistory/list/${pId}"


    });

    isc.VLayout.create({
        ID: "historyProcessConfirmVLayout",
        layoutMargin: 5,
        membersMargin: 10,
        showEdges: false,
        overflow: "auto",
        edgeImage: "",
        width: "100%",
        height: "100%",
//backgroundColor: "#FFAAAA",
        alignLayout: "center",
        members: [

            ListGrid_DocumentActivity


        ]
    });