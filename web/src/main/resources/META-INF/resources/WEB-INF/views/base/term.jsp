<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    var term_method = "POST";
    var startDateCheckTerm = true;
    var endDateCheckTerm = true;
    var checkConflict = false;
    var  termCode="0";

    //******************************
    //Menu
    //******************************
    Menu_ListGrid_term = isc.Menu.create({
        data: [
            {
                title: "بازخوانی اطلاعات", icon: "<spring:url value="refresh.png"/>", click: function () {
                ListGrid_Term.invalidateCache();
                                   }
            }, {
                title: "ایجاد", icon: "<spring:url value="create.png"/>", click: function () {
                 show_TermNewForm();
                                  }
            }, {
                title: "ویرایش", icon: "<spring:url value="edit.png"/>", click: function () {
                             show_TermEditForm();      }
            }, {
                title: "حذف", icon: "<spring:url value="remove.png"/>", click: function () {
                           show_TermRemoveForm();       }
            }, {isSeparator: true}, {
                 title: "ارسال به Pdf", icon: "<spring:url value="pdf.png"/>", click: function () {
                          print_TermListGrid("pdf") ;        }
             }, {
                 title: "ارسال به Excel", icon: "<spring:url value="excel.png"/>", click: function () {
                                 print_TermListGrid("excel")  }
             }, {
                 title: "ارسال به Html", icon: "<spring:url value="html.png"/>", click: function () {
                       print_TermListGrid("html");           }
            }]
    });

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
        canAddFormulaFields: true,
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
        doubleClick: function () {
            DynamicForm_Term.clearValues();
            show_TermEditForm();
        },
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
                //  hidden: true,
                type: 'text',
                required: true,
                canEdit:false,
                requiredMessage: "کد می تواند شامل عدد , حروف فارسی و انگلیسی باشد",
                //  titleOrientation: "top",
                //keyPressFilter: "[/|0-9]",
                // length: "15",
                width: "*",
                height: 35
            }, {
                name: "titleFa",
                title: "نام فارسی",
                required: true,
                type: 'text',
                readonly: true,
                required: true,
                height: 35,
                requiredMessage: "در نام فارسی می توانید از عدد و حروف انگلیسی هم استفاده کنید",
                // keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]", length: "250",
                width: "*", hint: "Persian/فارسی", showHintInField: true,
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber]
            },

            {
                name: "startDate",
                height: 35,
                title: "تاریخ شروع",
                ID: "startDate_jspTerm",
                type: 'text',
                enabled:false,
                 required: true,
                hint: "YYYY/MM/DD",
                keyPressFilter: "[0-9/]",
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

                    var endDate = DynamicForm_Term.getValue("endDate");
                    var startDate = DynamicForm_Term.getValue("startDate");
                    if (endDate != undefined && startDate > endDate) {
                        //  DynamicForm_Term.clearFieldErrors("endDate", true);
                        DynamicForm_Term.addFieldErrors("endDate", "<spring:message code='msg.date.order'/>", true);
                        DynamicForm_Term.getItem("endDate").setValue();

                        endDateCheckTerm = false;
                    }
                }
            },
            {
                name: "endDate",
                height: 35,
                title: "تاریخ پایان",
                ID: "endDate_jspTerm",
                type: 'text',
                enabled:false,
                required: true,
                hint: "YYYY/MM/DD",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                focus: function () {
                    displayDatePicker('endDate_jspTerm', this, 'ymd', '/');
                },
                icons: [{
                    src: "pieces/pcal.png",
                    click: function () {
                        var startdate = DynamicForm_Term.getItem("startDate").getValue();
                        closeCalendarWindow();
                        displayDatePicker('endDate_jspTerm', this, 'ymd', '/');
                        if (startdate != null) {
                            if (term_method == "POST")
                                getTermCodeRequest(startdate.substr(0, 4));
                        } else
                            simpleDialog("پیام","تاریخ شروع وارد نشده است.",3000,"say");
                    }
                }],
                blur: function () {
                    var dateCheck = false;
                    dateCheck = checkDate(DynamicForm_Term.getValue("endDate"));
                    var endDate = DynamicForm_Term.getValue("endDate");
                    var startDate = DynamicForm_Term.getValue("startDate");
                    if (dateCheck == false) {
                        DynamicForm_Term.clearFieldErrors("endDate", true);
                        DynamicForm_Term.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                        endDateCheckTerm = false;
                    }
                    if (dateCheck == true) {
                        if (startDate == undefined)
                            DynamicForm_Term.clearFieldErrors("endDate", true);
                        if (startDate != undefined && startDate > endDate) {
                            DynamicForm_Term.clearFieldErrors("endDate", true);
                            DynamicForm_Term.addFieldErrors("endDate", "<spring:message code='msg.date.order'/>", true);
                            endDateCheckTerm = false;
                        }
                        if (startDate != undefined && startDate < endDate) {
                            DynamicForm_Term.clearFieldErrors("endDate", true);
                            endDateCheckTerm = true;
                        }
                    }
                }

            },
            {
                name: "description",
                title: "توضیحات",
                type: "textArea",
                colSpan: 3,
                height: "50",
                length: "250", width: "*",

            }

        ]
    });
    var Window_term = isc.TrWindow.create({
        title: "دوره",
        width: 500,
        items: [DynamicForm_Term, isc.MyHLayoutButtons.create({
            members: [isc.MyButton.create({
                title: "ذخیره",
                icon: "pieces/16/save.png",
                click: function () {


                    if (term_method == "PUT") {
                        edit_Term();
                    } else {




                        save_Term();
                    }

                }
                ,
                focus:function f() {

                 //  DynamicForm_Term.setValue("code",termCode);//salam

                }
            }), isc.MyButton.create({
                title: "لغو",
                icon: "<spring:url value="remove.png"/>",
                click: function () {
                    Window_term.close();
                }
            })],
        }),]
    });

//**********************************************************************************
                                //ToolStripButton
//**********************************************************************************
	var ToolStripButton_Refresh = isc.ToolStripButton.create({
		icon: "<spring:url value="refresh.png"/>",
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
        members: [ToolStripButton_Refresh, ToolStripButton_Add, ToolStripButton_Edit, ToolStripButton_Remove, ToolStripButton_Print]
    });
    //***********************************************************************************
    //HLayout
    //***********************************************************************************
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

    //************************************************************************************
    //function
    //************************************************************************************

    function show_TermNewForm() {
        term_method = "POST";
        DynamicForm_Term.clearValues();
        Window_term.setTitle("<spring:message code="create"/>");
        Window_term.show();
    };

    function show_TermEditForm() {

        var record = ListGrid_Term.getSelectedRecord();

        if (record == null || record.id == null) {


            isc.Dialog.create({
                message: "<spring:message code="msg.not.selected.record"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="course_Warning"/>",
                buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {

            term_method = "PUT";
            DynamicForm_Term.clearValues();
            DynamicForm_Term.editRecord(record);
            Window_term.setTitle("<spring:message code="edit"/>");
            Window_term.show();

        }
    };

    function save_Term() {
        if (endDateCheckTerm == false)
            return;

        var startDate1 = DynamicForm_Term.getValue("startDate");
        var endDate1 = DynamicForm_Term.getValue("endDate");

        if (!DynamicForm_Term.validate()) {
            return;
        }


        var strsData = startDate1.replace(/(\/)/g, "");
        var streData = endDate1.replace(/\//g, "");


        isc.RPCManager.sendRequest({
            actionURL: termUrl + "checkForConflict/" + strsData + "/" + streData,
            httpMethod: "GET",
            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
            useSimpleHttp: true,
            contentType: "application/json; charset=utf-8",
            showPrompt: false,
            serverOutputAsString: false,
            callback: function (resp) {
                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                    if (resp.data.length > 0) {
                        var OK = isc.Dialog.create({
                            message: getFormulaMessage(resp.data, 3, "red", "I") + " با ترم وارد شده تداخل دارد",
                            icon: "[SKIN]say.png",
                            title: "انجام فرمان"
                        });
                        setTimeout(function () {
                            OK.close();
                        }, 3000);

                    } else {
                        var termData = DynamicForm_Term.getValues();
                        var termSaveUrl = termUrl;
                        if (term_method.localeCompare("PUT") == 0) {
                            var jobRecord = ListGrid_Term.getSelectedRecord();
                            termSaveUrl += jobRecord.id;
                        }
                        isc.RPCManager.sendRequest(MyDsRequest(termSaveUrl, term_method, JSON.stringify(termData), "callback:show_TermActionResult(rpcResponse)"));
                    }
                }
            }
        });
    };

    function getTermCodeRequest(termYear) {


        isc.RPCManager.sendRequest({
            actionURL: " http://localhost:8080/training/api/term/getCode/"+termYear,//termUrl + "checkForConflict/" + strsData + "/" + streData,
            httpMethod: "GET",
            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
            useSimpleHttp: true,
            contentType: "application/json; charset=utf-8",
            showPrompt: false,
            serverOutputAsString: false,
            callback: function f(resp){

        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

                if (resp.data != null) {
                    termCode = resp.data;
                } else {
                    termCode = "0";
                }

                 DynamicForm_Term.setValue("code",termYear +"-"+(parseInt(termCode)+1));

            } else {
                simpleDialog("خطا","پاسخی از سرور دریافت نشد.",3000,"error");
            }

            },
        });
    };



    function edit_Term() {
        var selectTerm = ListGrid_Term.getSelectedRecord();
        if (endDateCheckTerm == false)
            return;
         var startDate1 = DynamicForm_Term.getValue("startDate");
         var endDate1 = DynamicForm_Term.getValue("endDate");
         var termCode1 = DynamicForm_Term.getValue("code");

            if(startDate1.substr(0,4)!=termCode1.substr(0,4))
            {
            simpleDialog("پیام","کد با تاریخ شروع همخوانی ندارد.",3000,"say");
            return;
            }


        if (!DynamicForm_Term.validate()) {

            return;
        }


        var strsData = startDate1.replace(/(\/)/g, "");
        var streData = endDate1.replace(/\//g, "");


        isc.RPCManager.sendRequest({
            actionURL: termUrl + "checkForConflict/" + strsData + "/" + streData + "/" + selectTerm.id,
            httpMethod: "GET",
            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
            useSimpleHttp: true,
            contentType: "application/json; charset=utf-8",
            showPrompt: false,
            serverOutputAsString: false,
            callback: function (resp) {
                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                    if (resp.data.length > 0) {
                        var OK = isc.Dialog.create({
                            message: getFormulaMessage(resp.data, 3, "red", "I") + " با ترم وارد شده تداخل دارد",
                            icon: "[SKIN]say.png",
                            title: "انجام فرمان"
                        });
                        setTimeout(function () {
                            OK.close();
                        }, 3000);

                    } else {
                        var termData = DynamicForm_Term.getValues();
                        var termSaveUrl = termUrl;
                        if (term_method.localeCompare("PUT") == 0) {
                            var jobRecord = ListGrid_Term.getSelectedRecord();
                            termSaveUrl += jobRecord.id;
                        }
                        isc.RPCManager.sendRequest(MyDsRequest(termSaveUrl, term_method, JSON.stringify(termData), "callback:show_TermActionResult(rpcResponse)"));

                    }

                }

            }
        });
    };

    function show_TermRemoveForm() {
        var record = ListGrid_Term.getSelectedRecord();
        if (record == null || record.id == null) {

            <%--// simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.record.not.selected"/>", 2000, "say");--%>
            isc.Dialog.create({
                message: "<spring:message code="msg.not.selected.record"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="course_Warning"/>",
                buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
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
                MyOkDialog_term.close();

            }, 3000);

            Window_term.close();

        } else {
            var MyOkDialog_term = isc.MyOkDialog.create({
                message: "خطا در اجراي عمليات! کد خطا: " + resp.httpResponseCode,
            });

            setTimeout(function () {
                MyOkDialog_term.close();
            }, 3000);
        }
    };

    function print_TermListGrid(type) {
        var advancedCriteria = ListGrid_Term.getCriteria();
        var criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/term/printWithCriteria/"/>" + type,
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

