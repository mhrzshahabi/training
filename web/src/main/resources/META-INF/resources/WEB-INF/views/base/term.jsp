<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

//<script>


 	var term_method = "POST";
	var startDateCheckTerm = true;
    var endDateCheckTerm = true;
 //************************************************************************************
    // RestDataSource & ListGrid
 //************************************************************************************
 	var RestDataSource_term = isc.MyRestDataSource.create({
        ID: "termDS",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {"Authorization": "Bearer <%= accessToken %>"
            };
            return this.Super("transformRequest", arguments);
        },
        fields: [{name: "id", primaryKey: true},
         {name: "titleFa"},
         {name: "code"},
         {name: "titleFa"},
         {name: "startDate"},
          {name: "endDate"},
        ], dataFormat: "json",
        fetchDataURL: termUrl + "spec-list",
        autoFetchData: true,
    });
	var ListGrid_Term = isc.MyListGrid.create({

		 dataSource: RestDataSource_term,
		 contextMenu: Menu_ListGrid_term,
        autoFetchData: true,

		doubleClick: function () {
	    },
		fields: [
			{name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
			{name: "code", title: "کد", align: "center", filterOperator: "contains"},
			{name: "titleFa", title: "نام ", align: "center", filterOperator: "contains"},
			{name: "startDate", title: "شروع", align: "center", filterOperator: "contains"},
			{name: "endDate", title: "پایان", align: "center", filterOperator: "contains"},
			{name: "description", title: "توضیحات", align: "center", filterOperator: "contains"},
		],
		 showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
		sortField: 0,
	});
//*************************************************************************************
			//DynamicForm & Window
//*************************************************************************************
	var DynamicForm_Term = isc.MyDynamicForm.create({
		 ID: "DynamicForm_Term",
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
	var Window_term = isc.MyWindow.create({
		title: "دوره",
		 width: 500,
		items: [DynamicForm_Term,isc.MyHLayoutButtons.create({
            members: [isc.MyButton.create({
                title: "ذخیره",
                icon: "pieces/16/save.png",
                click: function () {
                    save_Term();

                }
            }), isc.MyButton.create({
                title: "لغو",
                icon: "pieces/16/icon_delete.png",
                click: function () {
                    Window_term.close();
                }
            })],
        }),]
    });

//****************************************************************************************
	var ToolStripButton_Refresh = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/refresh.png",
		title: "بازخوانی اطلاعات",
		click: function () {
			ListGrid_Term.invalidateCache();
		}
	});
	var ToolStripButton_Edit = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/edit.png",
		title: "ویرایش",
		click: function () {

				 show_TermEditForm();
		}
	});
	var ToolStripButton_Add = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/add.png",
		title: "ایجاد",
		click: function () {
			term_method = "POST";
		   show_TermNewForm();

		}
	});
	var ToolStripButton_Remove = isc.ToolStripButton.create({
		icon: "[SKIN]/actions/remove.png",
		title: "حذف",
		click: function () {
			show_TermRemoveForm()
		}
	});
	var ToolStripButton_Print = isc.ToolStripButton.create({
		icon: "[SKIN]/RichTextEditor/print.png",
		title: "چاپ",
		  click: function () {
          print_TermListGrid("pdf");
         }

	});
	var ToolStrip_Actions = isc.ToolStrip.create({
		width: "100%",
		members: [ToolStripButton_Refresh,ToolStripButton_Add, ToolStripButton_Edit, ToolStripButton_Remove,ToolStripButton_Print]
	});
	var Menu_ListGrid_term = isc.Menu.create({
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

 function  show_TermNewForm()
{
        term_method = "POST";
      	DynamicForm_Term.clearValues();
       	Window_term.show();
    };

function  show_TermEditForm() {
        var record = ListGrid_Term.getSelectedRecord();
       if (record == null || record.id == null)
      {

<%--// simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.record.not.selected"/>", 2000, "say");--%>
            isc.Dialog.create({
                message: "<spring:message code="msg.record.not.selected"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="course_Warning"/>",
                buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        }
            else
                {
                term_method = "PUT";
                DynamicForm_Term.clearValues();
                DynamicForm_Term.editRecord(record);
                Window_term.show();

                } };

    function  save_Term() {
      if (endDateCheckTerm == false)
                return;
        if (!DynamicForm_Term.validate()) {
            return;
        }
        var termData = DynamicForm_Term.getValues();
        var termSaveUrl = termUrl;
        if (term_method.localeCompare("PUT") == 0) {
            var jobRecord = ListGrid_Term.getSelectedRecord();
           termSaveUrl += jobRecord.id;
        }
        isc.RPCManager.sendRequest(MyDsRequest(termSaveUrl, term_method, JSON.stringify(termData), "callback: show_TermActionResult(rpcResponse)"));

    };

    function show_TermRemoveForm() {
        var record = ListGrid_Term.getSelectedRecord();
         if (record == null || record.id == null)
      {

<%--// simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.record.not.selected"/>", 2000, "say");--%>
            isc.Dialog.create({
                message: "<spring:message code="msg.record.not.selected"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="course_Warning"/>",
                buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        }
        else{
            isc.MyYesNoDialog.create({
                message: "آیا رکورد انتخاب شده حذف گردد؟",
                buttonClick: function (button, index) {
                    this.close();
                    if (index == 0) {
                        isc.RPCManager.sendRequest(MyDsRequest(termUrl + record.id, "DELETE", null, "callback: show_TermActionResult(rpcResponse)"));
                    }
                }
            });
        }

    };
    function  show_TermActionResult(resp) {
        var respCode = resp.httpResponseCode;
        if (respCode == 200 || respCode == 201) {
                ListGrid_Term.invalidateCache();
            var MyOkDialog_job = isc.MyOkDialog.create({
                message: "عمليات با موفقيت اجرا شد.",

            });

            setTimeout(function () {
                MyOkDialog_job.close();

            }, 3000);

          Window_term.close();

        } else {
            var MyOkDialog_job = isc.MyOkDialog.create({
                message: "خطا در اجراي عمليات! کد خطا: " + resp.httpResponseCode,
            });

            setTimeout(function () {
                MyOkDialog_job.close();
            }, 3000);
        }
    };

     function print_TermListGrid(type) {
        var advancedCriteria =ListGrid_Term.getCriteria();
        var criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/term/printWithCriteria/"/>" + type ,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "CriteriaStr", type: "hidden"}
                ]
        })
        criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
        criteriaForm.submitForm();


    };

