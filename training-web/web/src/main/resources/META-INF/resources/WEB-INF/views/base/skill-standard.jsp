<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--<script>--%>

	<spring:eval var="restApiUrl" expression="@environment.getProperty('nicico.rest-api.url')"/>

	var method = "POST";
	var url = "${restApiUrl}/api/skill-standard";

	var RestDataSource_skill_level = isc.RestDataSource.create({
		fields: [{name: "id"}, {name: "titleFa"},
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
		fetchDataURL: "${restApiUrl}/api/skill-level/spec-list"
	});

	var RestDataSource_Skill_Standard_Category = isc.RestDataSource.create({
		fields: [
			{name: "id"}, {name: "titleFa"},
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
		fetchDataURL: "${restApiUrl}/api/skill-standard-category/spec-list"
	});

	var RestDataSource_skill_standard = isc.RestDataSource.create({
		fields: [
			{name: "id"}, {name: "titleFa"}, {name: "titleEn"},
			{name: "code"}, {name: "version"}, {name: "skillLevel.titleFa"},
			{name: "skillStandardCategory.titleFa"}
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
		fetchDataURL: "${restApiUrl}/api/skill-standard/spec-list"
	});

	var DynamicForm_skill_standard = isc.DynamicForm.create({
		width: "100%",
		height: "100%",
		setMethod: 'POST',
		align: "center",
		canSubmit: true,
		showInlineErrors: true,
		showErrorText: true,
		showErrorStyle: true,
		errorOrientation: "right",
		colWidths: ["30%", "*"],
		titleAlign: "right",
		requiredMessage: "فیلد اجباری است.",
		numCols: 2,
		margin: 10,
		newPadding: 5,
		fields: [{name: "id", hidden: true}, {
			name: "code",
			title: "کد",
			type: 'text',
			required: true,
			length: "7"

		}, {
			name: "titleFa",
			title: "نام فارسی",
			required: true,
			type: 'text',
			readonly: true,
			hint: "Persian/فارسی",
			keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9 ]",
			length: "200",
			validators: [{
				type: "isString",
				validateOnExit: true,
				stopOnError: true,
				errorMessage: "نام مجاز بین چهار تا دویست کاراکتر است"
			}]
		}, {
			name: "titleEn",
			title: "نام لاتین ",
			type: 'text',
			keyPressFilter: "[a-z|A-Z|0-9 ]",
			length: "20",
			hint: "Latin",
			validators: [{
				type: "isString",
				validateOnExit: true,
				type: "lengthRange",
				min: 0,
				max: 200,
				stopOnError: true,
				errorMessage: "نام مجاز بین چهار تا دویست کاراکتر است"
			}]
		},
			{
				name: "skillLevelId",
				title: "سطح استاندارد مهارت",
				type: "integerItem",
				textAlign: "center",
				editorType: "ComboBoxItem",
				pickListWidth: 400,
				changeOnKeypress: true,
				displayField: "titleFa",
				valueField: "id",
				optionDataSource: RestDataSource_skill_level,
				autoFetchData: true,
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
					{name: "titleFa", width: "70%", filterOperator: "iContains"}],
				changed: function (form, item, value) {
				},
			},

			{
				name: "skillStandardCategoryId",
				title: "دسته بندي",
				type: "integerItem",
				textAlign: "center",
				editorType: "ComboBoxItem",
				pickListWidth: 400,
				changeOnKeypress: true,
				displayField: "code",
				valueField: "id",
				optionDataSource: RestDataSource_Skill_Standard_Category,
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
					{name: "titleFa", width: "70%", filterOperator: "iContains"}],
				changed: function (form, item, value) {
				},
			},
		]
	});

	var IButton_skill_standard_Save = isc.IButton.create({
		top: 260, title: "ذخیره", icon: "pieces/16/save.png", click: function () {

			DynamicForm_skill_standard.validate();
			if (DynamicForm_skill_standard.hasErrors()) {
				return;
			}
			var data = DynamicForm_skill_standard.getValues();

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
						var OK = isc.Dialog.create({
							message: "عملیات با موفقیت انجام شد.",
							icon: "[SKIN]say.png",
							title: "انجام فرمان"
						});
						setTimeout(function () {
							OK.close();
						}, 3000);
						ListGrid_Skill_Standard_refresh();
						Window_skill_standard.close();
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

	function ListGrid_skill_standard_remove() {

		var record = ListGrid_Skill_Standard.getSelectedRecord();
		//console.log(record);
		if (record == null) {
			isc.Dialog.create({
				message: "<spring:message code='global.grid.record.not.selected'/> !",
				icon: "[SKIN]ask.png",
				title: "<spring:message code='global.message'/>",
				buttons: [isc.Button.create({title: "<spring:message code='global.ok'/>"})],
				buttonClick: function (button, index) {
					this.close();
				}
			});
		} else {
			var Dialog_Delete = isc.Dialog.create({
				message: "<spring:message code='global.grid.record.remove.ask'/>",
				icon: "[SKIN]ask.png",
				title: "<spring:message code='global.grid.record.remove.ask.title'/>",
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
							actionURL: "${restApiUrl}/api/skill-standard/" + record.id,
							httpMethod: "DELETE",
							useSimpleHttp: true,
							contentType: "application/json; charset=utf-8",
							httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
							showPrompt: true,
							serverOutputAsString: false,
							callback: function (resp) {
								wait.close();
								if (resp.httpResponseCode == 200) {
									ListGrid_Skill_Standard.invalidateCache();
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

	function ListGrid_skill_standard_edit() {
		var record = ListGrid_Skill_Standard.getSelectedRecord();
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
			method = "PUT";
			url = "${restApiUrl}/api/skill-standard/" + record.id;
			DynamicForm_skill_standard.editRecord(record);
			Window_skill_standard.show();
		}
	};

	function ListGrid_Skill_Standard_refresh() {
		var record = ListGrid_Skill_Standard.getSelectedRecord();
		if (record == null || record.id == null) {
		} else {
			ListGrid_Skill_Standard.selectRecord(record);
		}
		ListGrid_Skill_Standard.invalidateCache();
	};

	var skill_standardSaveOrExitHlayout = isc.HLayout.create({
		layoutMargin: 5,
		showEdges: false,
		edgeImage: "",
		width: "100%",
		alignLayout: "center",
		padding: 10,
		membersMargin: 10,
		members: [IButton_skill_standard_Save, isc.IButton.create({
			ID: "EditExitIButton",
			title: "لغو",
			prompt: "",
			width: 100,
			icon: "pieces/16/icon_delete.png",
			orientation: "vertical",
			click: function () {
				Window_skill_standard.close();
			}
		})]
	});

	var Window_skill_standard = isc.Window.create({
		title: "استاندارد مهارت",
		width: 500,
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
			members: [DynamicForm_skill_standard, skill_standardSaveOrExitHlayout]
		})]
	});

	var Menu_ListGrid_skill_standard = isc.Menu.create({
		width: 150,
		data: [{
			title: "بازخوانی اطلاعات", icon: "pieces/16/refresh.png", click: function () {
				ListGrid_Skill_Standard_refresh();
			}
		}, {
			title: "ایجاد", icon: "pieces/16/icon_add.png", click: function () {
				method = "POST";
				url = "${restApiUrl}/api/skill-standard";
				DynamicForm_skill_standard.clearValues();
				Window_skill_standard.show();
			}
		}, {
			title: "ویرایش", icon: "pieces/16/icon_edit.png", click: function () {

				ListGrid_skill_standard_edit();

			}
		}, {
			title: "حذف", icon: "pieces/16/icon_delete.png", click: function () {
				ListGrid_skill_standard_remove();
			}
		}, {isSeparator: true}, {
			title: "ارسال به Pdf", icon: "icon/pdf.png", click: function () {

				"<spring:url value="/skill-standard/print/pdf" var="printUrl"/>"
				window.open('${printUrl}');
			}
		}, {
			title: "ارسال به Excel", icon: "icon/excel.png", click: function () {
				"<spring:url value="/skill-standard/print/excel" var="printUrl"/>"
				window.open('${printUrl}');
			}
		}, {
			title: "ارسال به Html", icon: "icon/html.jpg", click: function () {
				"<spring:url value="/skill-standard/print/html" var="printUrl"/>"
				window.open('${printUrl}');
			}
		}]
	});


	var ListGrid_Skill_Standard = isc.ListGrid.create({
		width: "100%",
		height: "100%",
		dataSource: RestDataSource_skill_standard,
		contextMenu: Menu_ListGrid_skill_standard,
		doubleClick: function () {
			ListGrid_skill_standard_edit();
		},
		fields: [
			{name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
			{name: "code", title: "کد", align: "center"},
			{name: "titleFa", title: "نام فارسی", align: "center"},
			{name: "titleEn", title: "نام لاتین ", align: "center"},
			{name: "skillLevel.titleFa", title: "سطح", align: "center"},
			{name: "skillStandardCategory.titleFa", title: "دسته", align: "center"},
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


	var ToolStripButton_Refresh = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/refresh.png",
		title: "بازخوانی اطلاعات",
		click: function () {
			ListGrid_Skill_Standard_refresh();
		}
	});
	var ToolStripButton_Edit = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/edit.png",
		title: "ویرایش",
		click: function () {
			ListGrid_Skill_Standard_edit();
		}
	});
	var ToolStripButton_Add = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/add.png",
		title: "ایجاد",
		click: function () {
			method = "POST";
			url = "${restApiUrl}/api/skill-standard";
			DynamicForm_skill_standard.clearValues();
			Window_skill_standard.show();
		}
	});
	var ToolStripButton_Remove = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/remove.png",
		title: "حذف",
		click: function () {
			ListGrid_skill_standard_remove();
		}
	});
	var ToolStripButton_Print = isc.ToolStripButton.create({
		icon: "[SKIN]/RichTextEditor/print.png",
		title: "چاپ",

		click: function () {
			"<spring:url value="/skill-standard/print/pdf" var="printUrl"/>"
			window.open('${printUrl}');
		}
	});

	var ToolStrip_Actions = isc.ToolStrip.create({
		width: "100%",
		members: [ToolStripButton_Add, ToolStripButton_Edit, ToolStripButton_Remove, ToolStripButton_Refresh, ToolStripButton_Print]
	});


	var HLayout_Actions_Skill_Standard = isc.HLayout.create({
		width: "100%",
		members: [ToolStrip_Actions]
	});

	var HLayout_Grid_Skill_Standard = isc.HLayout.create({
		width: "100%",
		height: "100%",
		members: [ListGrid_Skill_Standard]
	});
	var VLayout_Body_Skill_Standard = isc.VLayout.create({
		width: "100%",
		height: "100%",
		members: [
			HLayout_Actions_Skill_Standard
			, HLayout_Grid_Skill_Standard
		]
	});