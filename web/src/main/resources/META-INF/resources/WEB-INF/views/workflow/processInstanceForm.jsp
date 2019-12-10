<%--
  Created by IntelliJ IDEA.
  User: p-dodangeh
  Date: 1/12/2019
  Time: 4:34 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

<%--<script>--%>

<spring:eval var="restApiUrl" expression="@environment.getProperty('nicico.rest-api.url')"/>

var Menu_ListGrid_WorkflowProcessInstance_List = isc.Menu.create({
width: 150,
data: [

{
icon: "contact.png",
title: "تصویر فرایند",
click: function () {
ListGrid_WorkflowProcessList_showProcessImage();
}
},
{
title: "وضعیت نمونه فرایند", icon: "upload.png",
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
loadingMessage: "فرم نمونه فرایندی برای نمایش وجود ندارد"
});

function ListGrid_WorkflowProcessList_showProcessImage() {

var record = ListGrid_ProcessInstanceList.getSelectedRecord();

if (record == null || record.id == null) {
isc.Dialog.create({
message: "رکوردی انتخاب نشده است !",
icon: "[SKIN]ask.png",
title: "پیغام",
buttons: [isc.Button.create({title: "تائید"})],
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
title: " نمایش فرم فرایند",
click: function () {
ListGrid_WorkflowProcessList_showProcessInstanceForm();
}
});

var ToolStripButton_showProcessImage = isc.ToolStripButton.create({
icon: "contact.png",
title: "تصویر فرایند",
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
{name: "startDateEn", title: "تاریخ شروع"},
{name: "endDate", title: "تاریخ خاتمه"},
{name: "variableInstances.cId.textValue", title: "شماره شایستگی"},
{name: "processDefinitionKey", title: "کلید"},
{name: "processDefinitionVersion", title: "نسخه"},
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
{name: "variableInstances.userFullName.textValue", title: "ایجاد کننده فرایند", width: "30%"},
{name: "startDateFa", title: "تاریخ شروع", width: "30%"},
{name: "endDateFa", title: "تاریخ خاتمه", width: "30%"},
{name: "variableInstances.cId.textValue", title: "شماره شایستگی", width: "30%"},
{name: "processDefinitionKey", title: "کلید فرایند آپلود شده", width: "30%"},
{name: "variableInstances.cTitle.textValue", title: "توصیف", width: "30%"},
{name: "processDefinitionVersion", title: "نسخه", width: "30%"},
{name: "id", title: "id", type: "text", width: "30%"},
],
sortField: 0,
dataPageSize: 50,
autoFetchData: true,
showFilterEditor: true,
filterOnKeypress: true,
sortFieldAscendingText: "مرتب سازی صعودی",
sortFieldDescendingText: "مرتب سازی نزولی",
configureSortText: "تنظیم مرتب سازی",
autoFitAllText: "متناسب سازی ستون ها براساس محتوا",
autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
filterUsingText: "فیلتر کردن",
groupByText: "گروه بندی",
freezeFieldText: "ثابت نگه داشتن",
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