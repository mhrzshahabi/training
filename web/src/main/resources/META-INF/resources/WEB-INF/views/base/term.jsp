<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

//<script>


 	var term_method = "POST";
	var startDateCheckTerm = true;
    var endDateCheckTerm = true;
 //************************************************************************************
    // RestDataSource & ListGrid
 //************************************************************************************
	var RestDataSource_course = isc.RestDataSource.create({
		fields: [
			{name: "id"},
			{name: "titleFa"},
			{name: "titleEn"},
			{name: "code"},
			{name: "version"},
			{name: "duration"},

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
		fetchDataURL: "${restApiUrl}/api/course/spec-list"
	});
	var ListGrid_Term = isc.MyListGrid.create({

		//dataSource: RestDataSource_course,
	//	contextMenu: Menu_ListGrid_course,
    //    autoFetchData: true,

		doubleClick: function () {
	    },
		fields: [
			{name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
			{name: "code", title: "کد", align: "center"},
			{name: "titleFa", title: "نام ", align: "center"},
			{name: "startDate", title: "شروع", align: "center"},
			{name: "endDate", title: "پایان", align: "center"},
			{name: "description", title: "توضیحات", align: "center"},
			{name: "version", title: "version",hidden: true}
		],
		sortField: 0,
	});
//*************************************************************************************
			//DynamicForm & Window
//*************************************************************************************
	var DynamicForm_Term = isc.MyDynamicForm.create({
		 ID: "DF_TERM",
		// numCols: 2,
		// margin: 10,
		// newPadding: 5,
		fields: [{name: "id", hidden: true},
		 {
			name: "code",
			title: "کد",
			type: 'text',
			required: true,
			 required: true, keyPressFilter: "[/|0-9]", length: "15",
              width: "*",
              height: 27
		}, {
			name: "titleFa",
			title: "نام فارسی",
			required: true,
			type: 'text',
			readonly: true,
		   required: true, keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]", length: "250",
                width: "*", height: 27, hint: "Persian/فارسی", showHintInField: true,
                validators: [MyValidators.NotEmpty]
					},

			  {
                name: "startDate",
                title: "تاریخ شروع",
                ID: "startDate_jspTerm",
                type: 'text', required: true,
                hint: "YYYY/MM/DD",
                keyPressFilter:"[0-9/]",
                showHintInField: true,
                focus: function () {
                    displayDatePicker('startDate_jspTerm', this, 'ymd', '/');
                },
                icons: [{
                    src: "pieces/pcal.png",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate_jspTerm', this, 'ymd', '/');
                    }
                }],
                blur: function () {
                    var dateCheck = false;
                    dateCheck = checkDate(DynamicForm_Term.getValue("startDate"));
                    startDateCheckTerm = dateCheck;
                    if (dateCheck == false)
                        DynamicForm_Term.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                    if (dateCheck == true)
                       DynamicForm_Term.clearFieldErrors("startDate", true);
                }
            },
		 {
                name: "endDate",
                title: "تاریخ پایان",
                ID: "endDate_jspTerm",
                type: 'text', required: true,
                hint: "YYYY/MM/DD",
                keyPressFilter:"[0-9/]",
                showHintInField: true,
                focus: function () {
                    displayDatePicker('endDate_jspTerm', this, 'ymd', '/');
                },
                icons: [{
                    src: "pieces/pcal.png",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('endDate_jspTerm', this, 'ymd', '/');
                    }
                }],
                blur: function () {
                    var dateCheck = false;
                    dateCheck = checkDate(DynamicForm_Term.getValue("endDate"));
                    var endDate = DynamicForm_Term.getValue("endDate");
                    var startDate = DynamicForm_Term.getValue("startDate");
                    if (dateCheck == false){
                            DynamicForm_Term.clearFieldErrors("endDate", true);
                            DynamicForm_Term.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                            endDateCheckTerm = false;
                        }
                    if (dateCheck == true){
                        if(startDate == undefined)
                            DynamicForm_Term.clearFieldErrors("endDate", true);
                        if(startDate != undefined && startDate > endDate){
                            DynamicForm_Term.clearFieldErrors("endDate", true);
                            DynamicForm_Term.addFieldErrors("endDate", "<spring:message code='msg.date.order'/>", true);
                            endDateCheckTerm = false;
                        }
                        if(startDate != undefined && startDate < endDate){
                            DynamicForm_Term.clearFieldErrors("endDate", true);
                            endDateCheckTerm = true;
                        }
                       }
                }

            },
		 {
			name: "description",
			title: "توضیحات",
			type: "text",
			  length: "250", width: "*", height: 27
		}

		]
	});

	var IButton_course_Save = isc.IButton.create({
		top: 260, title: "ذخیره", icon: "pieces/16/save.png", click: function () {

			DynamicForm_Term.validate();
			if (DynamicForm_Term.hasErrors()) {
				return;
			}
			var data = DynamicForm_Term.getValues();

			isc.RPCManager.sendRequest({
				actionURL: termUrl,
				httpMethod: term_method,
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
						ListGrid_course_refresh();
						Windows_Term.close();
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

	var courseSaveOrExitHlayout = isc.HLayout.create({
		layoutMargin: 5,
		showEdges: false,
		edgeImage: "",
		width: "100%",
		alignLayout: "center",
		padding: 10,
		membersMargin: 10,
		members: [IButton_course_Save, isc.IButton.create({
			ID: "courseEditExitIButton",
			title: "لغو",
			prompt: "",
			width: 100,
			icon: "pieces/16/icon_delete.png",
			orientation: "vertical",
			click: function () {
				Windows_Term.close();
			}
		})]
	});

	var Windows_Term = isc.MyWindow.create({
		title: "ترم",
		width: 500,
	    closeClick: function () {
			this.Super("closeClick", arguments);
		},
		items: [DynamicForm_Term, isc.MyHLayoutButtons.create({
			 members: [isc.MyButton.create({
                title: "ذخیره",
                icon: "pieces/16/save.png",
                click: function () {

                }
            }), isc.MyButton.create({
                title: "لغو",
                icon: "pieces/16/icon_delete.png",
                click: function () {
                    Windows_Term.close();
                }
            })],
        }),]
    });

//****************************************************************************************
	var ToolStripButton_Refresh = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/refresh.png",
		title: "بازخوانی اطلاعات",
		click: function () {
			ListGrid_Term_refresh();
		}
	});
	var ToolStripButton_Edit = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/edit.png",
		title: "ویرایش",
		click: function () {

			ListGrid_Term_edit();
		}
	});
	var ToolStripButton_Add = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/add.png",
		title: "ایجاد",
		click: function () {
			term_method = "POST";
			//termUrl = "${restApiUrl}/api/course";
			DynamicForm_Term.clearValues();
			Windows_Term.show();

		}
	});
	var ToolStripButton_Remove = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/remove.png",
		title: "حذف",
		click: function () {
			ListGrid_Term_remove()
		}
	});
	var ToolStripButton_Print = isc.ToolStripButton.create({
		icon: "[SKIN]/RichTextEditor/print.png",
		title: "چاپ",

	});
	var ToolStrip_Actions = isc.ToolStrip.create({
		width: "100%",
		members: [ToolStripButton_Add, ToolStripButton_Edit, ToolStripButton_Remove, ToolStripButton_Refresh, ToolStripButton_Print]
	});
	var Menu_ListGrid_course = isc.Menu.create({
		width: 150,
		data: [{
			title: "بازخوانی اطلاعات", icon: "pieces/16/refresh.png", click: function () {
				ListGrid_Term_refresh();
			}
		}, {
			title: "ایجاد", icon: "pieces/16/icon_add.png", click: function () {
				DynamicForm_Term.clearValues();
				Windows_Term.show();

			}
		}, {
			title: "ویرایش", icon: "pieces/16/icon_edit.png", click: function () {
			 ListGrid_Term_edit()
			}
		}, {
			title: "حذف", icon: "pieces/16/icon_delete.png", click: function () {
				ListGrid_Term_remove()
			}
		}, {isSeparator: true}, {
			title: "ارسال به Pdf", icon: "icon/pdf.png", click: function () {

			}
		}, {
			title: "ارسال به Excel", icon: "icon/excel.png", click: function () {

			}
		}, {
			title: "ارسال به Html", icon: "icon/html.jpg", click: function () {

			}
		}]
	});


    var HLayout_Actions_Group = isc.HLayout.create({
		width: "100%",
		members: [ToolStrip_Actions]
	});

	var HLayout_Grid_Term = isc.HLayout.create({
		width: "100%",
		height: "100%",
		members: [ListGrid_Term]
	});

	var VLayout_Body_Group = isc.VLayout.create({
		width: "100%",
		height: "100%",
		members: [
			HLayout_Actions_Group
			, HLayout_Grid_Term
		]
	});

	function ListGrid_Term_edit() {
		var record = ListGrid_Course.getSelectedRecord();
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
			term_method = "PUT";
			//termUrl = "${restApiUrl}/api/course/" + record.id;
			DynamicForm_Term.editRecord(record);
			Windows_Term.show();
		}
	};

	function ListGrid_Term_remove() {


		var record = ListGrid_Course.getSelectedRecord();

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
							actionURL: "${restApiUrl}/api/course/" + record.id,
							httpMethod: "DELETE",
							useSimpleHttp: true,
							contentType: "application/json; charset=utf-8",
							httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
							showPrompt: true,
							serverOutputAsString: false,
							callback: function (resp) {
								wait.close();
								if (resp.httpResponseCode == 200) {
									ListGrid_Course.invalidateCache();
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

	function ListGrid_Term_refresh() {
		var record = ListGrid_Course.getSelectedRecord();
		if (record == null || record.id == null) {
		} else {
			ListGrid_Course.selectRecord(record);
		}
		ListGrid_Course.invalidateCache();
	};

	function ListGrid_Term_save() {
        if (!DynamicForm_Term.validate()) {
            return;
        }
        var termData = DynamicForm_Term.getValues();
        var termSaveUrl = termUrl;
        if (term_method .localeCompare("PUT") == 0) {
            var termRecord = ListGrid_Term.getSelectedRecord();
            termSaveUrl += termRecord.id;
        }
        isc.RPCManager.sendRequest(MyDsRequest(termSaveUrl, term_method, JSON.stringify(termData), "callback: show_JobActionResult(rpcResponse)"));
    };
