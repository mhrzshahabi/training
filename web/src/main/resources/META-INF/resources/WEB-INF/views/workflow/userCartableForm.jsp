<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %><%--
  Created by IntelliJ IDEA.
  User: p-dodangeh
  Date: 1/12/2019
  Time: 4:34 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
<%--<script>--%>

	<spring:eval var="restApiUrl" expression="@environment.getProperty('nicico.rest-api.url')"/>

	var Menu_ListGrid_UserTaskList = isc.Menu.create({
		width: 150,
		data: [
			{
				title: "نمایش کار مرتبط", icon: "pieces/512/showProcForm.png",
				click: function () {
					ListGrid_WorkflowUserTaskList_showTaskForm();
				}
			},
			{
				title: "لیست تاریخچه ی کار", icon: "pieces/512/showProcForm.png",
				click: function () {
					ListGrid_WorkflowUserTaskList_showTaskHistory();
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
		title: "تکمیل فرآیند",
		autoSize: false,
		width: "80%",
		height: "90%",
		canDragReposition: true,
		canDragResize: true,
		autoDraw: false,
		autoCenter: true,
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
		loadingMessage: "فرم کاری انتخاب نشده است"
	});

	<%--Get Process Form Details--%>

	function ListGrid_WorkflowUserTaskList_showTaskForm() {

		var record = ListGrid_UserTaskList.getSelectedRecord();
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
			<spring:url value="/web/workflow/getUserCartableDetailForm/" var="getUserCartableDetailForm"/>
			taskConfirmViewLoader.setViewURL("${getUserCartableDetailForm}" + taskID + "/" + record.assignee + "?Authorization=Bearer " + "${cookie['access_token'].getValue()}");
			taskConfirmationWindow.show();

		}
	}

	function ListGrid_WorkflowUserTaskList_showTaskHistory() {

		var record = ListGrid_UserTaskList.getSelectedRecord();
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
			userTaskViewLoader.setViewURL("${getUserTaskHistoryForm}" + pId);
			userTaskViewLoader.show();

		}
	}

	var ToolStripButton_showUserTaskForm = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/column_preferences.png",
		title: " نمایش فرم کار",
		click: function () {
			ListGrid_WorkflowUserTaskList_showTaskForm();
		}
	});

	var ToolStripButton_showUserTaskHistoryForm = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/column_preferences.png",
		title: "لیست تاریخچه ی کار",
		click: function () {
			ListGrid_WorkflowUserTaskList_showTaskHistory();
		}
	});


	var ToolStrip_UserTask_Actions = isc.ToolStrip.create({
		width: "100%",
		members: [
			ToolStripButton_showUserTaskForm, ToolStripButton_showUserTaskHistoryForm
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

			{name: "name", title: "عنوان کار"},
			{name: "startDateFa", title: "تاریخ ایجاد"},
			{name: "cTime", title: "زمان"},
			{name: "endTimeFa", title: "تاریخ خاتمه", width: "30%"},
			{name: "description", title: "توصیف"},
			{name: "taskDef", title: "تعریف کار"},
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

		fetchDataURL: workflowUrl + "userTask/list?usr=${username}"
	});


	var ListGrid_UserTaskList = isc.ListGrid.create({
		width: "100%",
		height: "100%",
		dataSource: RestDataSource_UserTaskList,
		sortDirection: "descending",
		contextMenu: Menu_ListGrid_UserTaskList,
		doubleClick: function () {
			ListGrid_WorkflowUserTaskList_showTaskForm();
		},
		fields: [

			{name: "name", title: "نام کار", width: "30%"},
			{name: "description", title: "توصیف", width: "70%"},
			{name: "id", title: "id", type: "text", width: "1%"},
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


	var HLayout_UserTaskGrid = isc.HLayout.create({
		width: "100%",
		height: "100%",
		<%--border: "10px solid green",--%>

		members: [
			ListGrid_UserTaskList
		]
	});

	var VLayout_Menu_Grid = isc.VLayout.create({
		width: "100%",
		height: "100%",
		members: [HLayout_UserTask_Actions, HLayout_UserTaskGrid]

	});

	var VLayout_Task_ViewLoader = isc.VLayout.create({
		width: "100%",
		height: "100%",
		members: [userTaskViewLoader]

	});

	var HLayout_UserTaskBody = isc.HLayout.create({
		width: "100%",
		height: "100%",
		<%--border: "10px solid red",--%>
		members: [
			VLayout_Menu_Grid, VLayout_Task_ViewLoader
		]
	});