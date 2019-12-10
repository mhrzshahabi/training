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


<%--<script>--%>

var activitiRefreshButton = isc.ToolStripButton.create({
icon: "<spring:url value="refresh.png"/>",
prompt: "بازخوانی اطلاعات",
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

{name: "id", type: "integer", title: " شناسه"},
{name: "name", title: "نام فعالیت"},
{name: "assignee", title: "منتسب به"},
{name: "startDateFa", title: "تاریخ شروع"},
{name: "startTime", title: "زمان شروع"},
{name: "endDateFa", title: "تاریخ پایان"},
{name: "endTime", title: "زمان پایان"},
{name: "duration", title: "مدت زمان>"},
{name: "durationHours", title: "ساعت"},
{name: "durationDay", title: "روز"}

]
});
var activeDocumentDS = isc.RestDataSource.create({
fields: [
{name: "id", primaryKey: true, type: "integer", title: " ID"},
{name: "name", title: "نام فعالیت"},
{name: "startDate", title: "تاریخ شروع"},
{name: "startTime", title: "زمان شروع"},
{name: "endTime", title: "workflow.endTime"},
{name: "endDateFa", title: "تاریخ پایان"},
{name: "durationInMillis", title: "مدت زمان"},
{name: "assignee", title: "منتسب به"}
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
fetchDataURL: workflowUrl + "userTaskHistory/list/${pId}"


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