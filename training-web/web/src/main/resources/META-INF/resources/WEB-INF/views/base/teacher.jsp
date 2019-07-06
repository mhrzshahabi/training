<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--<script>--%>

	<spring:eval var="restApiUrl" expression="@environment.getProperty('nicico.rest-api.url')"/>

	var method = "POST";
	var url = "${restApiUrl}/api/teacher";

	//--------------------------------------------------------------------------------------------------------------------//
	/*Rest Data Sources*/
	//--------------------------------------------------------------------------------------------------------------------//

	var RestDataSource_Teacher_JspTeacher = isc.RestDataSource.create({
		fields: [
			{name: "id", primaryKey: true}, {name: "fullNameFa"}, {name: "fullNameEn"},
			{name: "homeAddress"}, {name: "workAddress"}, {name: "mobile"},
			{name: "phone"}, {name: "nationalCode"}
		], dataFormat: "json",
		jsonPrefix: "",
		jsonSuffix: "",
		transformRequest: function (dsRequest) {
			dsRequest.httpHeaders = {
				"Authorization": "Bearer " + "${cookie['access_token'].getValue()}",
				"Access-Control-Allow-Origin": "${restApiUrl}"
			};
			return this.Super("transformRequest", arguments);
		},
		fetchDataURL: "${restApiUrl}/api/teacher/spec-list"
	});

	//--------------------------------------------------------------------------------------------------------------------//
	/*Menu*/
	//--------------------------------------------------------------------------------------------------------------------//

	var Menu_ListGrid_Teacher_JspTeacher = isc.Menu.create({
		width: 150,
		data: [{
			title: "<spring:message code='refresh'/>", icon: "pieces/16/refresh.png", click: function () {
				ListGrid_teacher_refresh();
			}
		}, {
			title: "<spring:message code='create'/>", icon: "pieces/16/icon_add.png", click: function () {
				ListGrid_teacher_add();
			}
		}, {
			title: "<spring:message code='edit'/>", icon: "pieces/16/icon_edit.png", click: function () {
				ListGrid_teacher_edit();
			}
		}, {
			title: "<spring:message code='remove'/>", icon: "pieces/16/icon_delete.png", click: function () {
				ListGrid_teacher_remove();
			}
		}, {isSeparator: true}, {
			title: "<spring:message code='print.pdf'/>", icon: "icon/pdf.png", click: function () {
				"<spring:url value="/teacher/print/pdf" var="printUrl"/>"
				window.open('${printUrl}');
			}
		}, {
			title: "<spring:message code='print.excel'/>", icon: "icon/excel.png", click: function () {
				"<spring:url value="/teacher/print/excel" var="printUrl"/>"
				window.open('${printUrl}');
			}
		}, {
			title: "<spring:message code='print.html'/>", icon: "icon/html.jpg", click: function () {
				"<spring:url value="/teacher/print/html" var="printUrl"/>"
				window.open('${printUrl}');
			}
		}]
	});

	//--------------------------------------------------------------------------------------------------------------------//
	/*Listgrid*/
	//--------------------------------------------------------------------------------------------------------------------//

	var ListGrid_Teacher_JspTeacher = isc.ListGrid.create({
		width: "100%",
		height: "100%",
		dataSource: RestDataSource_Teacher_JspTeacher,
		contextMenu: Menu_ListGrid_Teacher_JspTeacher,
		doubleClick: function () {
			ListGrid_teacher_edit();
		},
		fields: [
			{name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
			{name: "fullNameFa", title: "<spring:message code='firstName'/>", align: "center"},
			{name: "fullNameEn", title: "<spring:message code='firstName.latin'/>", align: "center"},
			{name: "homeAddress", title: "<spring:message code='home.address'/>", align: "center"},
			{name: "workAddress", title: "<spring:message code='work.address'/>", align: "center"},
			{name: "mobile", title: "<spring:message code='mobile'/>", align: "center"},
			{name: "phone", title: "<spring:message code='telephone'/>", align: "center"},
			{name: "nationalCode", title: "<spring:message code='national.code'/>", align: "center"}
		],
		sortField: 1,
		sortDirection: "descending",
		dataPageSize: 50,
		autoFetchData: true,
		showFilterEditor: true,
		filterOnKeypress: true,
		sortFieldAscendingText: "مرتب سازی صعودی ",
		sortFieldDescendingText: "مرتب سازی نزولی",
		configureSortText: "تنظیم مرتب سازی",
		autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
		autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
		filterUsingText: "فیلتر کردن",
		groupByText: "گروه بندی",
		freezeFieldText: "ثابت نگه داشتن"

	});

	//--------------------------------------------------------------------------------------------------------------------//
	/*DynamicForm Add Or Edit*/
	//--------------------------------------------------------------------------------------------------------------------//

	var DynamicForm_Teacher_JspTeacher = isc.DynamicForm.create({
		width: "100%",
		height: "100%",
		align: "center",
		canSubmit: true,
		titleWidth: 250,
		showInlineErrors: true,
		showErrorText: false,
		showErrorStyle: false,
		errorOrientation: "right",
		numCols: 2,
		titleAlign: "right",
		requiredMessage: "<spring:message code='msg.field.is.required'/>",
		margin: 10,
		newPadding: 5,
		fields: [{name: "id", hidden: true}, {
			name: "fullNameFa",
			title: "<spring:message code='firstName.lastName'/>",
			type: 'text',
			required: true

		}, {
			name: "fullNameEn",
			title: "<spring:message code='firstName.lastName.latin'/>",
			type: 'text',
			keyPressFilter: "[a-z|A-Z|0-9 ]",
			validators: [{
				type: "isString",
				validateOnExit: true,
				type: "lengthRange",
				min: 0,
				max: 200,
				stopOnError: true,
				errorMessage: "<spring:message code='msg.limit.name.lenght'/>"
			}]
		}, {
			name: "homeAddress",
			title: "<spring:message code='home.address'/>",
			type: 'text',
			validators: [{
				type: "isString",
				validateOnExit: true,
				min: 0,
				max: 200,
				stopOnError: true,
				errorMessage: "<spring:message code='msg.limit.name.lenght'/>"
			}]
		}, {
			name: "workAddress",
			title: "<spring:message code='work.address'/>",
			type: 'text',
			validators: [{
				type: "isString",
				validateOnExit: true,
				min: 0,
				max: 200,
				stopOnError: true,
				errorMessage: "<spring:message code='msg.limit.name.lenght'/>"
			}]
		},
			{
				name: "mobile",
				title: "<spring:message code='mobile'/>",
				type: 'text',
				keyPressFilter: "[0-9+]",
				validators: [{
					type: "isString",
					validateOnExit: true,
					type: "lengthRange",
					min: 0,
					max: 200,
					stopOnError: true,
					errorMessage: "<spring:message code='msg.limit.name.lenght'/>"
				}]
			},
			{
				name: "phone",
				title: "<spring:message code='telephone'/>",
				type: 'text',
				keyPressFilter: "[0-9+]",
				validators: [{
					type: "isString",
					validateOnExit: true,
					type: "lengthRange",
					min: 0,
					max: 200,
					stopOnError: true,
					errorMessage: "<spring:message code='msg.limit.name.lenght'/>"
				}]
			},
			{
				name: "nationalCode",
				title: "<spring:message code='national.code'/>",
				type: 'text',
				keyPressFilter: "[0-9+]",
				validators: [{
					type: "isString",
					validateOnExit: true,
					min: 0,
					max: 200,
					stopOnError: true,
					errorMessage: "<spring:message code='msg.limit.name.lenght'/>"
				}]
			}]
	});

	var IButton_Teacher_Save_JspTeacher = isc.IButton.create({
		top: 260, title: "<spring:message code='save'/>", click: function () {

			DynamicForm_Teacher_JspTeacher.validate();
			if (DynamicForm_Teacher_JspTeacher.hasErrors()) {
				return;
			}
			var data = DynamicForm_Teacher_JspTeacher.getValues();

			isc.RPCManager.sendRequest({
				actionURL: url,
				httpMethod: method,
				httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
				useSimpleHttp: true,
				contentType: "application/json; charset=utf-8",
				showPrompt: false,
				data: JSON.stringify(data),
				serverOutputAsString: false,
				callback: function (resp) {
					if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
						var responseID = JSON.parse(resp.data).id;
						var gridState = "[{id:" + responseID + "}]";
						var OK = isc.Dialog.create({
							message: "<spring:message code='msg.operation.successful'/>",
							icon: "[SKIN]say.png",
							title: "<spring:message code='msg.command.done'/>"
						});
						setTimeout(function () {
							OK.close();
							ListGrid_Teacher_JspTeacher.setSelectedState(gridState);
						}, 1000);
						ListGrid_Teacher_JspTeacher.invalidateCache();
						Window_Teacher_JspTeacher.close();
					} else {
						var ERROR = isc.Dialog.create({
							message: ("<spring:message code='msg.operation.error'/>"),
							icon: "[SKIN]stop.png",
							title: "<spring:message code='message'/>"
						});
						setTimeout(function () {
							ERROR.close();
						}, 3000);
					}

				}
			});
		}
	});

	var IButton_Teacher_Exit_JspTeacher = isc.IButton.create({
		title: "<spring:message code='cancel'/>",
		prompt: "",
		width: 100,
		orientation: "vertical",
		click: function () {
			Window_Teacher_JspTeacher.close();
		}

	});

	var HLayOut_TeacherSaveOrExit_JspTeacher = isc.HLayout.create({
		layoutMargin: 5,
		showEdges: false,
		edgeImage: "",
		width: "100%",
		alignLayout: "center",
		align: "center",
		padding: 10,
		membersMargin: 10,
		members: [IButton_Teacher_Save_JspTeacher, IButton_Teacher_Exit_JspTeacher]
	});

	var Window_Teacher_JspTeacher = isc.Window.create({
		title: "<spring:message code='teacher'/>",
		width: 550,
		autoSize: true,
		align: "center",
		autoCenter: true,
		isModal: true,
		showModalMask: true,
		align: "center",
		autoDraw: false,
		dismissOnEscape: false,
		border: "1px solid gray",
		closeClick: function () {
			this.Super("closeClick", arguments);
		},
		items: [isc.VLayout.create({
			width: "100%",
			height: "100%",
			members: [DynamicForm_Teacher_JspTeacher, HLayOut_TeacherSaveOrExit_JspTeacher]
		})]
	});

	//--------------------------------------------------------------------------------------------------------------------//
	/*ToolStrips and Layout*/
	//--------------------------------------------------------------------------------------------------------------------//

	var ToolStripButton_Refresh_JspTeacher = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/refresh.png",
		title: "<spring:message code='refresh'/>",
		click: function () {
			ListGrid_teacher_refresh();
		}
	});

	var ToolStripButton_Edit_JspTeacher = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/edit.png",
		title: "<spring:message code='edit'/>",
		click: function () {
			ListGrid_teacher_edit();
		}
	});

	var ToolStripButton_Add_JspTeacher = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/add.png",
		title: "<spring:message code='create'/>",
		click: function () {
			ListGrid_teacher_add();
		}
	});

	var ToolStripButton_Remove_JspTeacher = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/remove.png",
		title: "<spring:message code='remove'/>",
		click: function () {
			ListGrid_teacher_remove();
		}
	});

	var ToolStripButton_Print_JspTeacher = isc.ToolStripButton.create({
		icon: "[SKIN]/RichTextEditor/print.png",
		title: "<spring:message code='print'/>",
		click: function () {
			"<spring:url value="/teacher/print/pdf" var="printUrl"/>"
			window.open('${printUrl}');
		}
	});

	var ToolStrip_Actions_JspTeacher = isc.ToolStrip.create({
		width: "100%",
		members: [
			ToolStripButton_Refresh_JspTeacher,
			ToolStripButton_Add_JspTeacher,
			ToolStripButton_Edit_JspTeacher,
			ToolStripButton_Remove_JspTeacher,
			ToolStripButton_Print_JspTeacher
		]
	});

	var HLayout_Grid_Teacher_JspTeacher = isc.HLayout.create({
		width: "100%",
		height: "100%",
		members: [ListGrid_Teacher_JspTeacher]
	});

	var HLayout_Actions_Teacher = isc.HLayout.create({
		width: "100%",
		members: [ToolStrip_Actions_JspTeacher]
	});

	var VLayout_Body_Teacher_JspTeacher = isc.VLayout.create({
		width: "100%",
		height: "100%",
		members: [
			HLayout_Actions_Teacher
			, HLayout_Grid_Teacher_JspTeacher
		]
	});

	//--------------------------------------------------------------------------------------------------------------------//
	/*Functions*/
	//--------------------------------------------------------------------------------------------------------------------//

	function ListGrid_teacher_refresh() {
		ListGrid_Teacher_JspTeacher.invalidateCache();
	};

	function ListGrid_teacher_edit() {
		DynamicForm_Teacher_JspTeacher.clearValues();
		var record = ListGrid_Teacher_JspTeacher.getSelectedRecord();
		if (record == null || record.id == null) {
			isc.Dialog.create({
				message: "<spring:message code='msg.record.not.selected'/>",
				icon: "[SKIN]ask.png",
				title: "<spring:message code='message'/>",
				buttons: [isc.Button.create({title: "<spring:message code='ok'/>"})],
				buttonClick: function (button, index) {
					this.close();
				}
			});
		} else {
			method = "PUT";
			url = "${restApiUrl}/api/teacher/" + record.id;
			DynamicForm_Teacher_JspTeacher.editRecord(record);
			Window_Teacher_JspTeacher.show();
		}
	};

	function ListGrid_teacher_add() {
		method = "POST";
		url = "${restApiUrl}/api/teacher";
		DynamicForm_Teacher_JspTeacher.clearValues();
		Window_Teacher_JspTeacher.show();
	};

	function ListGrid_teacher_remove() {
		var record = ListGrid_Teacher_JspTeacher.getSelectedRecord();
		if (record == null) {
			isc.Dialog.create({
				message: "<spring:message code='msg.record.not.selected'/>",
				icon: "[SKIN]ask.png",
				title: "<spring:message code='message'/>",
				buttons: [isc.Button.create({title: "<spring:message code='ok'/>"})],
				buttonClick: function (button, index) {
					this.close();
				}
			});
		} else {
			var Dialog_Delete = isc.Dialog.create({
				message: "<spring:message code='msg.record.remove.ask'/>",
				icon: "[SKIN]ask.png",
				title: "<spring:message code='msg.remove.title'/>",
				buttons: [isc.Button.create({title: "<spring:message code='yes'/>"}), isc.Button.create({
					title: "<spring:message code='no'/>"
				})],
				buttonClick: function (button, index) {
					this.close();

					if (index == 0) {
						var wait = isc.Dialog.create({
							message: "<spring:message code='msg.waiting'/>",
							icon: "[SKIN]say.png",
							title: "<spring:message code='message'/>"
						});
						isc.RPCManager.sendRequest({
							actionURL: "${restApiUrl}/api/teacher/" + record.id,
							httpMethod: "DELETE",
							useSimpleHttp: true,
							contentType: "application/json; charset=utf-8",
							httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
							showPrompt: true,
							serverOutputAsString: false,
							callback: function (resp) {
								wait.close();
								if (resp.httpResponseCode == 200) {
									ListGrid_Teacher_JspTeacher.invalidateCache();
									var OK = isc.Dialog.create({
										message: "<spring:message code='msg.record.remove.successful'/>",
										icon: "[SKIN]say.png",
										title: "<spring:message code='msg.command.done'/>"
									});
									setTimeout(function () {
										OK.close();
									}, 3000);
								} else {
									var ERROR = isc.Dialog.create({
										message: "<spring:message code='msg.record.remove.failed'/>",
										icon: "[SKIN]stop.png",
										title: "<spring:message code='message'/>"
									});
									setTimeout(function () {
										ERROR.close();
									}, 3000);
								}
							}
						});
					}
				}
			});
		}
	};