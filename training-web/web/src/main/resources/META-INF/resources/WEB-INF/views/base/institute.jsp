<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--<script>--%>

	<spring:eval var="restApiUrl" expression="@environment.getProperty('nicico.rest-api.url')"/>

	var method = "POST";
	var url = "${restApiUrl}/api/institute";

	//--------------------------------------------------------------------------------------------------------------------//
	/*Rest Data Sources*/
	//--------------------------------------------------------------------------------------------------------------------//

	var RestDataSource_Institute_JspInstitute = isc.RestDataSource.create({
		fields: [
			{name: "id", primaryKey: true},
			{name: "code"},
			{name: "titleFa"},
			{name: "titleEn"},
			{name: "telephone"},
			{name: "address"},
			{name: "email"},
			{name: "postalCode"},
			{name: "branch"},
			{name: "einstituteType.titleFa"},
			{name: "elicenseType.titleFa"},
			{name: "version"}
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
		fetchDataURL: "${restApiUrl}/api/institute/spec-list"
	});


	var RestDataSource_EinstituteType_JspInstitute = isc.RestDataSource.create({
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
		fetchDataURL: enumUrl + "eInstituteType/spec-list"
	});

	var RestDataSource_ElicenseType_JspInstitute = isc.RestDataSource.create({
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
		fetchDataURL: enumUrl + "eLicenseType/spec-list"
	});
	//--------------------------------------------------------------------------------------------------------------------//
	/*Menu*/
	//--------------------------------------------------------------------------------------------------------------------//

	var Menu_ListGrid_Institute_JspInstitute = isc.Menu.create({
		width: 150,
		data: [{
			title: "<spring:message code='refresh'/>", icon: "pieces/16/refresh.png", click: function () {
				ListGrid_institute_refresh();
			}
		}, {
			title: "<spring:message code='create'/>", icon: "pieces/16/icon_add.png", click: function () {
				ListGrid_institute_add();
			}
		}, {
			title: "<spring:message code='edit'/>", icon: "pieces/16/icon_edit.png", click: function () {
				ListGrid_institute_edit();
			}
		}, {
			title: "<spring:message code='remove'/>", icon: "pieces/16/icon_delete.png", click: function () {
				ListGrid_institute_remove();
			}
		}, {isSeparator: true}, {
			title: "<spring:message code='print.pdf'/>", icon: "icon/pdf.png", click: function () {
				"<spring:url value="/institute/print/pdf" var="printUrl"/>"
				window.open('${printUrl}');
			}
		}, {
			title: "<spring:message code='print.excel'/>", icon: "icon/excel.png", click: function () {
				"<spring:url value="/institute/print/excel" var="printUrl"/>"
				window.open('${printUrl}');
			}
		}, {
			title: "<spring:message code='print.html'/>", icon: "icon/html.jpg", click: function () {
				"<spring:url value="/institute/print/html" var="printUrl"/>"
				window.open('${printUrl}');
			}
		}]
	});

	//--------------------------------------------------------------------------------------------------------------------//
	/*Listgrid*/
	//--------------------------------------------------------------------------------------------------------------------//

	var ListGrid_Institute_JspInstitute = isc.ListGrid.create({
		width: "100%",
		height: "100%",
		dataSource: RestDataSource_Institute_JspInstitute,
		contextMenu: Menu_ListGrid_Institute_JspInstitute,
		doubleClick: function () {
			ListGrid_institute_edit();
		},

		fields: [
			{name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
			{name: "code", title: "<spring:message code='code'/>", align: "center"},
			{name: "titleFa", title: "<spring:message code='title'/>", align: "center"},
			{name: "telephone", title: "<spring:message code='telephone'/>", align: "center"},
			{name: "branch", title: "<spring:message code='branch'/>", align: "center"},
			{name: "einstituteType.titleFa", title: "", hidden: true},
			{name: "elicenseType.titleFa", title: "", hidden: true},
			{name: "titleEn", title: "", hidden: true},
			{name: "address", title: "", hidden: true},
			{name: "email", title: "", hidden: true},
			{name: "postalCode", title: "", hidden: true},
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

	//--------------------------------------------------------------------------------------------------------------------//
	/*DynamicForm Add Or Edit*/
	//--------------------------------------------------------------------------------------------------------------------//

	var DynamicForm_Institute_JspInstitute = isc.DynamicForm.create({
		width: "800",
		titleWidth: "120",
		height: "190",
		align: "center",
		canSubmit: true,
		showInlineErrors: true,
		showErrorText: false,
		showErrorStyle: false,
		errorOrientation: "right",
		titleAlign: "right",
		requiredMessage: "<spring:message code='msg.field.is.required'/>",
		numCols: 4,
		margin: 50,
		padding: 5,
		fields: [
			{name: "id", hidden: true},

			{
				name: "code", title: "<spring:message code='code'/>",
				type: 'text',
				required: true,
				keyPressFilter: "[/|0-9]",
				length: "15",
			},
			{
				name: "titleFa",
				title: "<spring:message code='title'/>",
				required: true
			},
			{
				name: "titleEn",
				title: "<spring:message code='titleEn'/>",
				required: true
			},
			{
				name: "telephone",
				title: "<spring:message code='telephone'/>",
				required: true
			},
			{
				name: "address",
				title: "<spring:message code='address'/>",
				required: true
			},
			{
				name: "email",
				title: "<spring:message code='email'/>",
				required: true
			},
			{
				name: "postalCode",
				title: "<spring:message code='postal.code'/>",
				required: true
			},
			{
				name: "branch",
				title: "<spring:message code='branch'/>",
				required: true
			},
			{
				name: "einstituteType.id",
				type: "IntegerItem",
				title: "<spring:message code='institute.type'/>",
				required: true,
				textAlign: "center",
				editorType: "ComboBoxItem",
				changeOnKeypress: true,
				displayField: "titleFa",
				valueField: "id",
				optionDataSource: RestDataSource_EinstituteType_JspInstitute,
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
				name: "elicenseType.id",
				type: "IntegerItem",
				title: "<spring:message code='license.type'/>",
				required: true,
				textAlign: "center",
				editorType: "ComboBoxItem",
				changeOnKeypress: true,
				displayField: "titleFa",
				valueField: "id",
				optionDataSource: RestDataSource_ElicenseType_JspInstitute,
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
		]

	});

	var IButton_Institute_Exit_JspInstitute = isc.IButton.create({
		top: 260, title: "<spring:message code='cancel'/>", align: "center",
		click: function () {
			Window_Institute_JspInstitute.close();
		}
	});

	var IButton_Institute_Save_JspInstitute = isc.IButton.create({
		top: 260, title: "<spring:message code='save'/>", align: "center", click: function () {

			DynamicForm_Institute_JspInstitute.validate();
			if (DynamicForm_Institute_JspInstitute.hasErrors()) {
				return;
			}
			var data = DynamicForm_Institute_JspInstitute.getValues();

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
							ListGrid_Institute_JspInstitute.setSelectedState(gridState);
						}, 1000);
						ListGrid_institute_refresh();
						Window_Institute_JspInstitute.close();
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

	var HLayOut_InstituteSaveOrExit_JspInstitute = isc.HLayout.create({
		layoutMargin: 5,
		showEdges: false,
		edgeImage: "",
		width: "800",
		height: "10",
		alignLayout: "center",
		align: "center",
		padding: 10,
		membersMargin: 10,
		members: [IButton_Institute_Save_JspInstitute, IButton_Institute_Exit_JspInstitute]
	});

	var Window_Institute_JspInstitute = isc.Window.create({
		title: "<spring:message code='training.institute'/>",
		width: 800,
		height: 200,
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
			members: [DynamicForm_Institute_JspInstitute, HLayOut_InstituteSaveOrExit_JspInstitute]
		})]
	});

	//--------------------------------------------------------------------------------------------------------------------//
	/*ToolStrips and Layout*/
	//--------------------------------------------------------------------------------------------------------------------//

	var ToolStripButton_Refresh_JspInstitute = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/refresh.png",
		title: "<spring:message code='refresh'/>",
		click: function () {
			ListGrid_institute_refresh();
		}
	});

	var ToolStripButton_Edit_JspInstitute = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/edit.png",
		title: "<spring:message code='edit'/>",
		click: function () {
			ListGrid_institute_edit();
		}
	});

	var ToolStripButton_Add_JspInstitute = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/add.png",
		title: "<spring:message code='create'/>",
		click: function () {
			ListGrid_institute_add();
		}
	});

	var ToolStripButton_Remove_JspInstitute = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/remove.png",
		title: "<spring:message code='remove'/>",
		click: function () {
			ListGrid_institute_remove();
		}
	});

	var ToolStripButton_Print_JspInstitute = isc.ToolStripButton.create({
		icon: "[SKIN]/RichTextEditor/print.png",
		title: "<spring:message code='print'/>",
		click: function () {
			"<spring:url value="/institute/print/pdf" var="printUrl"/>"
			window.open('${printUrl}');
		}
	});

	var ToolStrip_Actions_JspInstitute = isc.ToolStrip.create({
		width: "100%",
		members: [
			ToolStripButton_Refresh_JspInstitute,
			ToolStripButton_Add_JspInstitute,
			ToolStripButton_Edit_JspInstitute,
			ToolStripButton_Remove_JspInstitute,
			ToolStripButton_Print_JspInstitute]
	});

	var HLayout_Actions_Institute_JspInstitute = isc.HLayout.create({
		width: "100%",
		members: [ToolStrip_Actions_JspInstitute]
	});

	var HLayout_Grid_Institute_JspInstitute = isc.HLayout.create({
		width: "100%",
		height: "100%",
		members: [ListGrid_Institute_JspInstitute]
	});

	var VLayout_Body_Institute_JspInstitute = isc.VLayout.create({
		width: "100%",
		height: "100%",
		members: [
			HLayout_Actions_Institute_JspInstitute
			, HLayout_Grid_Institute_JspInstitute
		]
	});

	//--------------------------------------------------------------------------------------------------------------------//
	/*Functions*/
	//--------------------------------------------------------------------------------------------------------------------//

	function ListGrid_institute_remove() {
		var record = ListGrid_Institute_JspInstitute.getSelectedRecord();
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
							actionURL: "${restApiUrl}/api/institute/" + record.id,
							httpMethod: "DELETE",
							useSimpleHttp: true,
							contentType: "application/json; charset=utf-8",
							httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
							showPrompt: true,
							serverOutputAsString: false,
							callback: function (resp) {
								wait.close();
								if (resp.httpResponseCode == 200) {
									ListGrid_Institute_JspInstitute.invalidateCache();
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

	function ListGrid_institute_edit() {
		var record = ListGrid_Institute_JspInstitute.getSelectedRecord();
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
			DynamicForm_Institute_JspInstitute.clearValues();
			url = "${restApiUrl}/api/institute/" + record.id;
			DynamicForm_Institute_JspInstitute.editRecord(record);
			Window_Institute_JspInstitute.show();
		}
	};

	function ListGrid_institute_refresh() {
		ListGrid_Institute_JspInstitute.invalidateCache();
	};

	function ListGrid_institute_add() {
		method = "POST";
		url = "${restApiUrl}/api/institute";
		DynamicForm_Institute_JspInstitute.clearValues();
		Window_Institute_JspInstitute.show();
	};