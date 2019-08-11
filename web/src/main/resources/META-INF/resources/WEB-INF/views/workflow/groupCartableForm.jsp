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

	var Menu_ListGrid_GroupTaskList = isc.Menu.create({
		width: 150,
		data: [
			{
				title: "نمایش کار مرتبط", icon: "pieces/512/showProcForm.png",
				click: function () {
					ListGrid_WorkflowGroupTaskList_showTaskForm();
				}
			},
			{
				title: "لیست تاریخچه ی کار", icon: "pieces/512/showProcForm.png",
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
		loadingMessage: "فرم کاری انتخاب نشده است"
	});

	<%--Get Process Form Details--%>

	function ListGrid_WorkflowGroupTaskList_showTaskForm() {

		var record = ListGrid_GroupTaskList.getSelectedRecord();
		if (record == null || record.id == null) {
			isc.Dialog.create({
				message: "رکوردی انتخاب نشده است !",
				icon: "[SKIN]ask.png",
				title: "پیغام",
				buttons: [isc.Button.create({title: "تائید"})],
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
				message: "رکوردی انتخاب نشده است !",
				icon: "[SKIN]ask.png",
				title: "پیغام",
				buttons: [isc.Button.create({title: "تائید"})],
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
		title: " نمایش فرم کار",
		click: function () {
			ListGrid_WorkflowGroupTaskList_showTaskForm();
		}
	});

	var ToolStripButton_showGroupTaskHistoryForm = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/column_preferences.png",
		title: "لیست تاریخچه ی کار",
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

			{name: "name", title: "نام کار"},
			{name: "startDate", title: "تاریخ ایجاد"},
			{name: "startDateFa", title: "تاریخ ایجاد شمسی"},
			{name: "cTime", title: "زمان"},
			{name: "processVariables.documentId.textValue", title: "شماره سند"},
			{name: "description", title: "توصیف"},
			{name: "taskDef", title: "تعریف کار"},
			{name: "id", title: "id", type: "text"}
		],
		dataFormat: "json",
		jsonPrefix: "",
		jsonSuffix: "",
		fetchDataURL: "<spring:url value="/rest/workflow/groupTask/list?roles=${userRoles}"/>"
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

			{name: "name", title: "نام کار", width: "30%"},
			{name: "processVariables.documentId.textValue", title: "شماره سند", width: "30%"},
			{name: "id", title: "id", type: "text", width: "30%"}
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
		freezeFieldText: "ثابت نگه داشتن"

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