<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--<script>--%>

	<spring:eval var="restApiUrl" expression="@environment.getProperty('nicico.rest-api.url')"/>

	var methodGoal = "GET";
	var urlGoal = "${restApiUrl}/api/goal";
	var methodSyllabus = "GET";
	var urlSyllabus = "${restApiUrl}/api/syllabus";

	var RestDataSourceGoalEDomainType = isc.RestDataSource.create({
		fields: [{name: "id"}, {name: "titleFa"}
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
		fetchDataURL: "${restApiUrl}/api/enum/eDomainType"
	});
	<%--var RestDataSource_Syllabus = isc.RestDataSource.create({--%>
	<%--fields: [--%>
	<%--{name: "id"},--%>
	<%--{name: "titleFa"},--%>
	<%--{name: "titleEn"},--%>
	<%--{name: "edomainType.titleFa"},--%>
	<%--{name: "code"}--%>
	<%--], dataFormat: "json",--%>
	<%--jsonPrefix: "",--%>
	<%--jsonSuffix: "",--%>
	<%--transformRequest: function (dsRequest) {--%>
	<%--dsRequest.httpHeaders = {--%>
	<%--"Authorization": "Bearer " + "${cookie['access_token'].getValue()}",--%>
	<%--"Access-Control-Allow-Origin": "${restApiUrl}"--%>
	<%--};--%>
	<%--return this.Super("transformRequest", arguments);--%>
	<%--},--%>
	<%--fetchDataURL: "${restApiUrl}/api/syllabus/spec-list"--%>
	<%--});--%>

	var DynamicForm_Goal = isc.DynamicForm.create({
		width: "70%",
		height: "10%",
		setMethod: methodGoal,
		align: "center",
		canSubmit: true,
		showInlineErrors: true,
		showErrorText: true,
		showErrorStyle: true,
		errorOrientation: "right",
		titleAlign: "right",
		requiredMessage: "فیلد اجباری است.",
		numCols: 4,
		margin: 10,
		newPadding: 5,
		fields: [
			{name: "id", hidden: true},
			{
				name: "titleFa",
				title: "نام فارسی",
				required: true,
				type: 'text',
				readonly: true,
				keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|a-z|A-Z|0-9 ]",
				validators: [MyValidators.NotEmpty]
			},
			{
				name: "titleEn",
				title: "نام لاتین ",
				type: 'text',
				keyPressFilter: "[a-z|A-Z|0-9 ]"
			}
		]
	});
	var DynamicForm_Syllabus = isc.DynamicForm.create({
		width: "70%",
		height: "10%",
		setMethod: methodSyllabus,
		align: "center",
		canSubmit: true,
		showInlineErrors: true,
		showErrorText: true,
		showErrorStyle: true,
		errorOrientation: "right",
		titleAlign: "right",
		requiredMessage: "فیلد اجباری است.",
		numCols: 2,
		margin: 10,
		newPadding: 5,
		fields: [
			{name: "id", hidden: true},
			{
				name: "goalId",
				title: "شماره هدف",
				required: true,
				type: 'text',
				readonly: true,
				keyPressFilter: "[0-9]",
				length: "200",
				width: "150",
				hidden: true,
				validators: [{
					type: "isString",
					validateOnExit: true,
					stopOnError: true,
					errorMessage: "نام مجاز بین چهار تا دویست کاراکتر است"
				}]
			},
			{
				name: "code",
				title: "کد",
				type: 'text',
				required: true,
				length: "7"
			},
			{
				name: "titleFa",
				title: "نام فارسی",
				required: true,
				type: 'text',
				readonly: true,
				hint: "Persian/فارسی",
				keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|a-z|A-Z|0-9 ]",
				length: "200",
				validators: [{
					type: "isString",
					validateOnExit: true,
					stopOnError: true,
					errorMessage: "نام مجاز بین چهار تا دویست کاراکتر است"
				}]
			},
			{
				name: "edomainType.id",
				value: "",
				type: "IntegerItem",
				title: "حیطه",
				width: "95%",
				required: true,
				textAlign: "center",
				editorType: "ComboBoxItem",
				pickListWidth: 100,
				changeOnKeypress: true,
				displayField: "titleFa",
				valueField: "id",
				optionDataSource: RestDataSourceGoalEDomainType,
				autoFetchData: false,
				addUnknownValues: false,
				cachePickListResults: false,
				useClientFiltering: false,
				filterFields: ["titleFa"],
				sortField: ["id"],
				textMatchStyle: "startsWith",
				generateExactMatchCriteria: true,
				pickListProperties: {
					showFilterEditor: true,
				},
				pickListFields: [
					{name: "titleFa", width: "30%", filterOperator: "iContains"}],
			},
			{
				name: "titleEn",
				title: "نام لاتین ",
				type: 'text',
				keyPressFilter: "[a-z|A-Z|0-9 ]",
				length: "200",
				hint: "Latin",
				validators: [{
					type: "isString",
					validateOnExit: true,
					type: "lengthRange",
					min: 3,
					max: 200,
					stopOnError: true,
					errorMessage: "نام مجاز بين سه تا دویست کاراکتر است"
				}]
			},
			{name: "practicalDuration", title: "ساعت عملي", type: "text"},
			{name: "theoreticalDuration", title: "ساعت نظري", type: "text"}]
	});

	var IButton_Goal_Save = isc.IButton.create({
		top: 260, title: "ذخیره",
		icon: "pieces/16/save.png",
		click: function () {
			DynamicForm_Goal.validate();
			if (DynamicForm_Goal.hasErrors()) {
				return;
			}
			var data = DynamicForm_Goal.getValues();
			isc.RPCManager.sendRequest({
				actionURL: urlGoal,
				httpMethod: methodGoal,
				httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
				useSimpleHttp: true,
				contentType: "application/json; charset=utf-8",
				showPrompt: false,
				data: JSON.stringify(data),
				serverOutputAsString: false,
				callback: function (resp) {
					if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
						var OK = isc.Dialog.create({
							message: "عملیات با موفقیت انجام شد.",
							icon: "[SKIN]say.png",
							title: "انجام فرمان"
						});
						setTimeout(function () {
							OK.close();
						}, 3000);
						ListGrid_Goal_refresh();
						Window_Goal.close();
					} else {
						var ERROR = isc.Dialog.create({
							message: ("اجرای عملیات با مشکل مواجه شده است!"),
							icon: "[SKIN]stop.png",
							title: "پیغام"
						});
						setTimeout(function () {
							ERROR.close();
						}, 3000);
					}

				}
			});

		}
	});

	var Hlayout_Goal_SaveOrExit = isc.HLayout.create({
		layoutMargin: 5,
		showEdges: false,
		edgeImage: "",
		width: "100%",
		alignLayout: "center",
		padding: 10,
		membersMargin: 10,
		members: [IButton_Goal_Save, isc.IButton.create({
			ID: "IButton_Goal_Exit",
			title: "لغو",
			prompt: "",
			width: 100,
			icon: "pieces/16/icon_delete.png",
			orientation: "vertical",
			click: function () {
				Window_Goal.close();
			}
		})]
	});

	var Window_Goal = isc.Window.create({
		title: "هدف",
		width: "500",
		autoSize: true,
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
			width: "900",
			height: "200",
			members: [DynamicForm_Goal, Hlayout_Goal_SaveOrExit]
		})]
	});

	var IButton_Syllabus_Save = isc.IButton.create({
		top: 260, title: "ذخیره",
		icon: "pieces/16/save.png",
		click: function () {
			DynamicForm_Syllabus.validate();
			if (DynamicForm_Syllabus.hasErrors()) {
				return;
			}
			var data = DynamicForm_Syllabus.getValues();
			isc.RPCManager.sendRequest({
				actionURL: urlSyllabus,
				httpMethod: methodSyllabus,
				httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
				useSimpleHttp: true,
				contentType: "application/json; charset=utf-8",
				showPrompt: false,
				data: JSON.stringify(data),
				serverOutputAsString: false,
				callback: function (resp) {
					if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
						var OK = isc.Dialog.create({
							message: "عملیات با موفقیت انجام شد.",
							icon: "[SKIN]say.png",
							title: "انجام فرمان"
						});
						setTimeout(function () {
							OK.close();
						}, 3000);
						ListGrid_Syllabus.invalidateCache();
						Window_Syllabus.close();
					} else {
						var ERROR = isc.Dialog.create({
							message: ("اجرای عملیات با مشکل مواجه شده است!"),
							icon: "[SKIN]stop.png",
							title: "پیغام"
						});
						setTimeout(function () {
							ERROR.close();
						}, 3000);
					}

				}
			});

		}
	});

	var Hlayout_Syllabus_SaveOrExit = isc.HLayout.create({
		layoutMargin: 5,
		showEdges: false,
		edgeImage: "",
		width: "100%",
		alignLayout: "center",
		padding: 10,
		membersMargin: 10,
		members: [IButton_Syllabus_Save, isc.IButton.create({
			ID: "IButton_Syllabus_Exit",
			title: "لغو",
			prompt: "",
			width: 100,
			icon: "pieces/16/icon_delete.png",
			orientation: "vertical",
			click: function () {
				Window_Syllabus.close();
			}
		})]
	});

	var Window_Syllabus = isc.Window.create({
		title: "سرفصل",
		width: "600",
		autoSize: true,
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
			members: [DynamicForm_Syllabus, Hlayout_Syllabus_SaveOrExit]
		})]
	});

	var Menu_ListGrid_Syllabus = isc.Menu.create({
		width: 150,
		data: [{
			title: "بازخوانی اطلاعات", icon: "pieces/16/refresh.png", click: function () {
				ListGrid_Syllabus_refresh();
			}
		}, {
			title: "ایجاد", icon: "pieces/16/icon_add.png", click: function () {
				ListGrid_Syllabus_Add()
			}
		}, {
			title: "ویرایش", icon: "pieces/16/icon_edit.png", click: function () {

				ListGrid_Syllabus_Edit();

			}
		}, {
			title: "حذف", icon: "pieces/16/icon_delete.png", click: function () {
				ListGrid_Syllabus_Remove();
			}
		}, {isSeparator: true}, {
			title: "ارسال به Pdf", icon: "icon/pdf.png", click: function () {
				window.open("<spring:url value="/syllabus/print/pdf"/>");
			}
		}, {
			title: "ارسال به Excel", icon: "icon/excel.png", click: function () {
				window.open("<spring:url value="/syllabus/print/exel"/>");
			}
		}, {
			title: "ارسال به Html", icon: "icon/html.jpg", click: function () {
				window.open("<spring:url value="/syllabus/print/html"/>");
			}
		}]
	});
	var Menu_ListGrid_Goal = isc.Menu.create({
		width: 150,
		data: [{
			title: "بازخوانی اطلاعات", icon: "pieces/16/refresh.png", click: function () {
				ListGrid_Goal_refresh();
			}
		}, {
			title: "ایجاد", icon: "pieces/16/icon_add.png", click: function () {
				methodGoal = "POST";
				urlGoal = "${restApiUrl}/api/goal";
				DynamicForm_Goal.clearValues();
				Window_Goal.show();
			}
		}, {
			title: "ویرایش", icon: "pieces/16/icon_edit.png", click: function () {

				ListGrid_Goal_Edit();

			}
		}, {
			title: "حذف", icon: "pieces/16/icon_delete.png", click: function () {
				ListGrid_Goal_Remove();
			}
		}, {isSeparator: true}, {
			title: "ارسال به Pdf", icon: "icon/pdf.png", click: function () {
				window.open("<spring:url value="/goal/print/pdf"/>");
			}
		}, {
			title: "ارسال به Excel", icon: "icon/excel.png", click: function () {
				window.open("<spring:url value="/goal/print/exel"/>");
			}
		}, {
			title: "ارسال به Html", icon: "icon/html.jpg", click: function () {
				window.open("<spring:url value="/goal/print/html"/>");
			}
		}]
	});

	var ListGrid_Goal = isc.ListGrid.create({
		width: "100%",
		height: "100%",
		dataSource: RestDataSource_CourseGoal,
		contextMenu: Menu_ListGrid_Goal,
		doubleClick: function () {
			ListGrid_Goal_Edit();
		},
		fields: [
			{name: "id", title: "شماره", primaryKey: true, canEdit: false, hidden: true},
			{name: "titleFa", title: "نام فارسی هدف", align: "center"},
			{name: "titleEn", title: "نام لاتین هدف ", align: "center"},
			{name: "version", title: "version", canEdit: false, hidden: true}
		],
		selectionType: "multiple",
		selectionChanged: function (record, state) {
			RestDataSource_Syllabus.fetchDataURL = "${restApiUrl}/api/goal/" + record.id + "/syllabus";
			// selectedGoalId=record.id;
			ListGrid_Syllabus.fetchData();
			ListGrid_Syllabus.invalidateCache();
		},
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
	var ListGrid_Syllabus = isc.ListGrid.create({
		width: "100%",
		height: "100%",
		dataSource: RestDataSource_Syllabus,
		contextMenu: Menu_ListGrid_Syllabus,
		doubleClick: function () {
			ListGrid_Syllabus_Edit();
		},
		fields: [
			{name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
			{name: "code", title: "کد سرفصل", align: "center"},
			{name: "titleFa", title: "نام فارسی سرفصل", align: "center"},
			{name: "titleEn", title: "نام لاتین سرفصل", align: "center"},
			{name: "edomainType.titleFa", title: "حیطه", align: "center"},
			{name: "theoreticalDuration", title: "ساعت نظري سرفصل", align: "center"},
			{name: "practicalDuration", title: "ساعت عملي سرفصل", align: "center"},
			{name: "version", title: "version", canEdit: false, hidden: true}
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

	// var ToolStripButton_Syllabus_Refresh = isc.ToolStripButton.create({
	//     icon: "[SKIN]/actions/refresh.png",
	//     title: "بازخوانی اطلاعات",
	//     click: function () {
	//         ListGrid_Syllabus_refresh();
	//     }
	// });
	var ToolStripButton_Syllabus_Edit = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/edit.png",
		title: "ویرایش سرفصل",
		click: function () {
			ListGrid_Syllabus_Edit();
		}
	});
	var ToolStripButton_Syllabus_Add = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/add.png",
		title: "ایجاد سرفصل",
		click: function () {
			ListGrid_Syllabus_Add();
		}
	});
	var ToolStripButton_Syllabus_Remove = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/remove.png",
		title: "حذف سرفصل",
		click: function () {
			ListGrid_Syllabus_Remove();
		}
	});
	var ToolStripButton_Syllabus_Print = isc.ToolStripButton.create({
		icon: "[SKIN]/RichTextEditor/print.png",
		title: "چاپ",
		click: function () {
			window.open("<spring:url value="/goal/print/pdf"/>");
		}
	});
	var ToolStrip_Actions_Syllabus = isc.ToolStrip.create({
		width: "100%",
		members: [ToolStripButton_Syllabus_Add, ToolStripButton_Syllabus_Edit, ToolStripButton_Syllabus_Remove, ToolStripButton_Syllabus_Print]
	});

	var ToolStripButton_Goal_Refresh = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/refresh.png",
		title: "بازخوانی اطلاعات",
		click: function () {
			ListGrid_Goal_refresh();
			RestDataSource_Syllabus.fetchDataURL = "${restApiUrl}/api/syllabus/course/" + courseId.id;
			ListGrid_Syllabus.invalidateCache();
		}
	});
	var ToolStripButton_Goal_Edit = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/edit.png",
		title: "ویرایش هدف",
		prompt: "اخطار<br/>ویرایش هدف در تمامی دوره های ارضا کننده هدف نیز اعمال خواهد شد.",
		hoverWidth: 320,
		click: function () {
			ListGrid_Goal_Edit();
		}
	});
	var ToolStripButton_Goal_Add = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/add.png",
		title: "ایجاد هدف",
		prompt: "به منظور تعریف هدف جدید کلیک نمایید.",
		hoverWidth: 180,
		click: function () {
			ListGrid_Goal_Add();
		}
	});
	var ToolStripButton_Goal_Remove = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/remove.png",
		title: "حذف هدف",
		prompt: "اخطار<br/>هدف انتخاب شده از تمامی دوره های موجود حذف خواهد شد.",
		hoverWidth: 280,
		click: function () {
			ListGrid_Goal_Remove();
		}
	});
	var ToolStripButton_Goal_Print = isc.ToolStripButton.create({
		icon: "[SKIN]/RichTextEditor/print.png",
		title: "چاپ",
		click: function () {
			window.open("<spring:url value="/goal/print/pdf"/>");
		}
	});
	var ToolStrip_Actions_Goal = isc.ToolStrip.create({
		width: "100%",
		members: [ToolStripButton_Goal_Add, ToolStripButton_Goal_Edit, ToolStripButton_Goal_Remove, ToolStripButton_Goal_Refresh, ToolStripButton_Goal_Print]
	});

	var HLayout_Action_Goal = isc.HLayout.create({
		width: "100%",
		<%--border: "2px solid blue",--%>
		members: [ToolStrip_Actions_Goal]
	});
	var HLayout_Grid_Goal = isc.HLayout.create({
		width: "100%",
		height: "100%",
		members: [ListGrid_Goal]
	});
	var VLayout_Body_Goal = isc.VLayout.create({
		width: "30%",
		height: "100%",
		members: [HLayout_Action_Goal, HLayout_Grid_Goal]
	});
	var HLayout_Action_Syllabus = isc.HLayout.create({
		width: "100%",
		<%--border: "2px solid blue",--%>
		members: [ToolStrip_Actions_Syllabus]
	});
	var HLayout_Grid_Syllabus = isc.HLayout.create({
		width: "100%",
		height: "100%",
		<%--border: "2px solid blue",--%>
		members: [ListGrid_Syllabus]
	});
	var VLayout_Body_Syllabus = isc.VLayout.create({
		width: "70%",
		height: "100%",
		<%--border: "2px solid blue",--%>
		members: [HLayout_Action_Syllabus, HLayout_Grid_Syllabus]
	});
	var HLayout_Body_All_Goal = isc.HLayout.create({
		width: "100%",
		height: "100%",
		<%--border: "2px solid blue",--%>
		members: [VLayout_Body_Goal, VLayout_Body_Syllabus]
	});

	function ListGrid_Goal_Remove() {

		var record = ListGrid_Goal.getSelectedRecord();
		console.log(record);
		if (record == null) {
			isc.Dialog.create({
				message: "<spring:message code='msg.record.not.selected'/> !",
				icon: "[SKIN]ask.png",
				title: "<spring:message code='message'/>",
				buttons: [isc.Button.create({title: "<spring:message code='ok'/>"})],
				buttonClick: function (button, index) {
					this.close();
				}
			});
		} else {
			var Dialog_Delete = isc.Dialog.create({
				message: "با حذف هدف مذکور، این هدف از کلیه دوره ها حذف خواهد شد.",
				icon: "[SKIN]ask.png",
				title: "اخطار",
				buttons: [isc.Button.create({title: "موافقم"}), isc.Button.create({
					title: "مخالفم"
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
							actionURL: "${restApiUrl}/api/goal/delete/" + record.id,
							httpMethod: "DELETE",
							useSimpleHttp: true,
							contentType: "application/json; charset=utf-8",
							httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
							showPrompt: true,
							serverOutputAsString: false,
							callback: function (resp) {
								wait.close();
								if (resp.httpResponseCode == 200) {
									ListGrid_Goal.invalidateCache();
									var OK = isc.Dialog.create({
										message: "<spring:message code='msg.operation.successful'/>",
										icon: "[SKIN]say.png",
										title: "<spring:message code='msg.command.done'/>"
									});
									setTimeout(function () {
										OK.close();
									}, 3000);
								} else {
									var ERROR = isc.Dialog.create({
										message: "<spring:message code='msg.record.cannot.deleted'/>",
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
			ListGrid_Syllabus_refresh();
		}
	};

	function ListGrid_Goal_Edit() {
		var record = ListGrid_Goal.getSelectedRecord();
		if (record == null || record.id == null) {
			isc.Dialog.create({
				message: "رکوردی انتخاب نشده است.",
				icon: "[SKIN]ask.png",
				title: "پیغام",
				buttons: [isc.Button.create({title: "تائید"})],
				buttonClick: function (button, index) {
					this.close();
				}
			});
		} else {
			methodGoal = "PUT";
			urlGoal = "${restApiUrl}/api/goal/" + record.id;
			DynamicForm_Goal.editRecord(record);
			Window_Goal.show();
		}
	};

	function ListGrid_Goal_refresh() {
		var record = ListGrid_Goal.getSelectedRecord();
		if (record == null || record.id == null) {
		} else {
			ListGrid_Goal.selectRecord(record);
		}
		ListGrid_Goal.invalidateCache();
	};

	function ListGrid_Goal_Add() {
		if (courseId == null || courseId.id == null) {
			isc.Dialog.create({
				message: "دوره اي انتخاب نشده است.",
				icon: "[SKIN]ask.png",
				title: "پیغام",
				buttons: [isc.Button.create({title: "تائید"})],
				buttonClick: function (button, index) {
					this.close();
				}
			});
		} else {
			methodGoal = "POST";
			urlGoal = "${restApiUrl}/api/goal/create/" + courseId.id;
			DynamicForm_Goal.clearValues();
			Window_Goal.show();
		}
	};

	function ListGrid_Syllabus_Remove() {

		var record = ListGrid_Syllabus.getSelectedRecord();
		console.log(record);
		if (record == null) {
			isc.Dialog.create({
				message: "<spring:message code='msg.record.not.selected'/> !",
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
				title: "<spring:message code='msg.record.remove.ask'/>",
				buttons: [isc.Button.create({title: "<spring:message code='global.yes'/>"}), isc.Button.create({
					title: "<spring:message
		code='global.no'/>"
				})],
				buttonClick: function (button, index) {
					this.close();

					if (index == 0) {
						var wait = isc.Dialog.create({
							message: "<spring:message code='global.form.do.operation'/>",
							icon: "[SKIN]say.png",
							title: "<spring:message code='global.message'/>"
						});
						isc.RPCManager.sendRequest({
							actionURL: "${restApiUrl}/api/syllabus/" + record.id,
							httpMethod: "DELETE",
							useSimpleHttp: true,
							contentType: "application/json; charset=utf-8",
							httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
							showPrompt: true,
							serverOutputAsString: false,
							callback: function (resp) {
								wait.close();
								if (resp.httpResponseCode == 200) {
									ListGrid_Syllabus.invalidateCache();
									var OK = isc.Dialog.create({
										message: "<spring:message code='global.form.request.successful'/>",
										icon: "[SKIN]say.png",
										title: "<spring:message code='global.form.command.done'/>"
									});
									setTimeout(function () {
										OK.close();
									}, 3000);
								} else {
									var ERROR = isc.Dialog.create({
										message: "<spring:message code='global.grid.record.cannot.deleted'/>",
										icon: "[SKIN]stop.png",
										title: "<spring:message code='global.message'/>"
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

	function ListGrid_Syllabus_Add() {
		var gRecord = ListGrid_Goal.getSelectedRecord();
		if (gRecord == null || gRecord.id == null) {
			isc.Dialog.create({
				message: "هدف مرتبط انتخاب نشده است.",
				icon: "[SKIN]ask.png",
				title: "پیغام",
				buttons: [isc.Button.create({title: "تائید"})],
				buttonClick: function (button, index) {
					this.close();
				}
			});
		} else {
			selectedGoalId = gRecord.id;
			methodSyllabus = "POST";
			urlSyllabus = "${restApiUrl}/api/syllabus";
			DynamicForm_Syllabus.clearValues();
			DynamicForm_Syllabus.getItem("goalId").setValue(gRecord.id);
			Window_Syllabus.show();
		}
	};

	function ListGrid_Syllabus_Edit() {
		var sRecord = ListGrid_Syllabus.getSelectedRecord();
		if (sRecord == null || sRecord.id == null) {
			isc.Dialog.create({
				message: "سرفصلی انتخاب نشده است.",
				icon: "[SKIN]ask.png",
				title: "پیغام",
				buttons: [isc.Button.create({title: "تائید"})],
				buttonClick: function (button, index) {
					this.close();
				}
			});
		} else {
			methodSyllabus = "PUT";
			urlSyllabus = "${restApiUrl}/api/syllabus/" + sRecord.id;
			DynamicForm_Syllabus.editRecord(sRecord);
			Window_Syllabus.show();
		}
	};

	function ListGrid_Syllabus_refresh() {
		var record = ListGrid_Syllabus.getSelectedRecord();
		if (record == null || record.id == null) {
		} else {
			ListGrid_Syllabus.selectRecord(record);
		}
		ListGrid_Syllabus.invalidateCache();
	};