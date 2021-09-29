<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    var term_method = "POST";
    var startDateCheckTerm = true;
    var endDateCheckTerm = true;
    var checkConflict = false;
    var termCode = "0";

    //******************************
    //Menu
    //******************************
    Menu_ListGrid_term = isc.Menu.create({
        data: [
            <sec:authorize access="hasAuthority('Term_R')">
            {
                title: "<spring:message code="refresh"/>",
                <%--icon: "<spring:url value="refresh.png"/>",--%>
                click: function () {
                    ListGrid_Term.invalidateCache();
                }
            },
            </sec:authorize>
            <%--<sec:authorize access="hasAuthority('Term_C')">--%>
            <%--{--%>
                <%--title: "<spring:message code="create"/>", icon: "<spring:url value="create.png"/>", --%>
                <%--click: function () {--%>
                    <%--show_TermNewForm();--%>
                <%--}--%>
            <%--},--%>
            <%--</sec:authorize>--%>
            <%--<sec:authorize access="hasAuthority('Term_U')">--%>
            <%--{--%>
                <%--title: "<spring:message code="edit"/>", icon: "<spring:url value="edit.png"/>", --%>
                <%--click: function () {--%>
                    <%--show_TermEditForm();--%>
                <%--}--%>
            <%--},--%>
            <%--</sec:authorize>--%>
            <%--<sec:authorize access="hasAuthority('Term_D')">--%>
            <%--{--%>
                <%--title: "<spring:message code="remove"/>", icon: "<spring:url value="remove.png"/>", --%>
                <%--click: function () {--%>
                    <%--show_TermRemoveForm();--%>
                <%--}--%>
            <%--},--%>
            <%--</sec:authorize>--%>
            <%--<sec:authorize access="hasAnyAuthority('Term_R', 'Term_C', 'Term_U', 'Term_D')">--%>
            <%--{isSeparator: true},--%>
            <%--</sec:authorize>--%>
            <sec:authorize access="hasAuthority('Term_P')">
            {
                title: "<spring:message code="print.pdf"/>", icon: "<spring:url value="pdf.png"/>", click: function () {
                    print_TermListGrid("pdf");
                }
            }, {
                title: "<spring:message code="print.excel"/>",
                icon: "<spring:url value="excel.png"/>",
                click: function () {
                    print_TermListGrid("excel")
                }
            }, {
                title: "<spring:message code="print.html"/>",
                icon: "<spring:url value="html.png"/>",
                click: function () {
                    print_TermListGrid("html");
                }
            }
            </sec:authorize>
            ]
    });
    //************************************************************************************
    // RestDataSource & ListGrid
    //************************************************************************************
    var RestDataSource_term = isc.TrDS.create({
        ID: "termDS",
        transformRequest: function (dsRequest) {
            dsRequest.httpHeaders = {
                "Authorization": "Bearer <%= accessToken %>"
            };
            return this.Super("transformRequest", arguments);
        },
        fields: [{name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "description"}
        ], dataFormat: "json",
        fetchDataURL: termUrl + "spec-list",
        autoFetchData: true,
    });
    var ListGrid_Term = isc.TrLG.create({
        <sec:authorize access="hasAuthority('Term_R')">
        dataSource: RestDataSource_term,
        </sec:authorize>
        canAddFormulaFields: true,
        contextMenu: Menu_ListGrid_term,
        autoFetchData: true,

        fields: [
           // {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "<spring:message code="code"/>", align: "center", filterOperator: "iContains",
                filterEditorProperties: {
                keyPressFilter: "[0-9|\-]"
                }
            },
            {name: "titleFa", title: "<spring:message code="title"/>", align: "center", filterOperator: "iContains"},
            {
                name: "startDate",
                title: "<spring:message code="start.date"/>",
                align: "center",
                filterOperator: "iContains",
                filterEditorProperties: {
                keyPressFilter: "[0-9/]"
                }
            },

            {name: "endDate", title: "<spring:message code="end.date"/>", align: "center", filterOperator: "iContains",
                filterEditorProperties: {
                keyPressFilter: "[0-9/]"
                }
            },

            {name: "description",title: "<spring:message code="description"/>",align: "center",filterOperator: "iContains"},
        ],
        recordDoubleClick: function () {
            DynamicForm_Term.clearValues();
            // show_TermEditForm();
        },
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
        sortField: 2,
        sortDirection: "descending",

    });
    //*************************************************************************************
    //DynamicForm & Window
    //*************************************************************************************
    var DynamicForm_Term = isc.DynamicForm.create({
        ID: "DynamicForm_Term",
        fields: [{name: "id", hidden: true},
            {
                name: "code",
                title: "<spring:message code="code"/>",
                disabled: true,
                canEdit: false,
                hint: "<spring:message code="msg.generated.automatically.code"/>", showHintInField: true,
                width: "*",
                height: 35
            }
            , {
                name: "titleFa",
                title: "<spring:message code="title"/>",
                required: true,
                type: 'text',
                readonly: true,
                height: 35,
// requiredMessage: "در نام فارسی می توانید از عدد و حروف انگلیسی هم استفاده کنید",
// keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]", length: "250",
                width: "*",// hint: "Persian/فارسی", showHintInField: true,
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber]
            },

            {
                name: "startDate",
                height: 35,
                title: "<spring:message code="start.date"/>",
                ID: "startDate_jspTerm",
                type: 'text',

                required: true,
                hint: "YYYY/MM/DD",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                // focus: function () {
                //     displayDatePicker('startDate_jspTerm', this, 'ymd', '/');
                // },
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate_jspTerm', this, 'ymd', '/');
                    }
                }],

                changed: function (form, item, value) {
                    var startdate = DynamicForm_Term.getItem("startDate").getValue();
                    if (startdate != null) {
                        if (term_method == "POST")
                            getTermCodeRequest(startdate.substr(0, 4));
                    } else

                        simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.start.date.not.entered"/>", 3000, "say");
                },
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
// DynamicForm_Term.clearFieldErrors("endDate", true);
                        DynamicForm_Term.addFieldErrors("endDate", "<spring:message code='msg.date.order'/>", true);
                        DynamicForm_Term.getItem("endDate").setValue();
                        endDateCheckTerm = false;
                    }
                }
            },
            {
                name: "endDate",
                height: 35,
                title: "<spring:message code="end.date"/>",
                ID: "endDate_jspTerm",
                type: 'text',
                enabled: false,
                required: true,
                hint: "YYYY/MM/DD",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                // focus: function () {
                //     displayDatePicker('endDate_jspTerm', this, 'ymd', '/');
                // },
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
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
                title: "<spring:message code="description"/>",
                type: "textArea",
                colSpan: 3,
                height: "50",
                length: "250", width: "*",

            }

        ]
    });
    var Window_term = isc.Window.create({
        title: "دوره",
        width: 500,
        items: [DynamicForm_Term, isc.MyHLayoutButtons.create({
            members: [isc.IButtonSave.create({
                title: "ذخیره",
                click: function () {
                    if (term_method == "PUT") {
                        edit_Term();
                    } else {
                        save_Term();
                    }
                }

            }), isc.IButtonCancel.create({
                title: "لغو",
                click: function () {
                    Window_term.close();
                }
            })],
        }),]
    });

    //**********************************************************************************
    //ToolStripButton
    //**********************************************************************************
    var ToolStripButton_Refresh = isc.ToolStripButtonRefresh.create({
// icon: "<spring:url value="refresh.png"/>",
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_Term.invalidateCache();
        }
    });
    var ToolStripButton_Edit = isc.ToolStripButtonEdit.create({
//icon: "[SKIN]/actions/edit.png",
        title: "<spring:message code="edit"/>",
        disabled: true,
        click: function () {

            show_TermEditForm();
        }
    });
    var ToolStripButton_Add = isc.ToolStripButtonAdd.create({

        title: "<spring:message code="create"/>",
        disabled: true,
        click: function () {
            term_method = "POST";
            show_TermNewForm();

        }
    });
    var ToolStripButton_Remove = isc.ToolStripButtonRemove.create({
//icon: "[SKIN]/actions/remove.png",
        title: "<spring:message code="remove"/>",
        disabled: true,
        click: function () {
            show_TermRemoveForm()
        }
    });

    var ToolStripButton_Print = isc.ToolStripButtonPrint.create({
//icon: "[SKIN]/RichTextEditor/print.png",
        title: "<spring:message code="print"/>",
        click: function () {
            <%--"<spring:url value="/term/printWithCriteria/pdf" var="printUrl"/>"--%>
            <%--      window.open('${printUrl}');--%>
// window.open("/term/printWithCriteria/pdf");
            print_TermListGrid("pdf");

        }
    });
    var ToolStripButton_Export2EXcel = isc.ToolStripButtonExcel.create({
        click: function () {
            ExportToFile.downloadExcelRestUrl(null, ListGrid_Term,  termUrl + "spec-list", 0, null, '',"لیست ترم ها", ListGrid_Term.getCriteria(), null);
        }
    });


    var ToolStrip_Actions = isc.ToolStrip.create({
        width: "100%",
        members: [
            <sec:authorize access="hasAuthority('Term_C')">
            ToolStripButton_Add,
            </sec:authorize>
            <sec:authorize access="hasAuthority('Term_U')">
            ToolStripButton_Edit,
            </sec:authorize>
            <sec:authorize access="hasAuthority('Term_D')">
            ToolStripButton_Remove,
            </sec:authorize>
            <sec:authorize access="hasAuthority('Term_P')">
            ToolStripButton_Print,
            ToolStripButton_Export2EXcel,
            </sec:authorize>
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    <sec:authorize access="hasAuthority('Term_R')">
                    ToolStripButton_Refresh,
                    </sec:authorize>
                ]
            })
        ]
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
        Window_term.setTitle("<spring:message code="create.term"/>");
        Window_term.show();
        setTimeout(function() {
        $("input[name='startDate']").attr("readonly",true);
        $("input[name='endDate']").attr("readonly",true);
        },300);
    };

    function show_TermEditForm() {

        var record = ListGrid_Term.getSelectedRecord();

        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "<spring:message code="msg.no.records.selected"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="message"/>",
                buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            term_method = "PUT";
            DynamicForm_Term.clearValues();
            DynamicForm_Term.editRecord(record);
            Window_term.setTitle("<spring:message code="edit.term"/>");
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
        isc.RPCManager.sendRequest(TrDSRequest(termUrl + "checkForConflict/" + strsData + "/" + streData, "GET", null, "callback:conflictReq(rpcResponse)"));

    };


    function conflictReq(resp) {
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

            if (resp.data.length > 0) {
                var OK = isc.Dialog.create({
                    message: getFormulaMessage(resp.data, 2, "red", "I") + "<spring:message code="msg.conflict.term"/>",
                    icon: "[SKIN]say.png",
                    title: "<spring:message code="warning"/>",
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
                isc.RPCManager.sendRequest(TrDSRequest(termSaveUrl, term_method, JSON.stringify(termData), "callback:show_TermActionResult(rpcResponse)"));
            }
        } else {
            var OK = isc.Dialog.create({
                message: "<spring:message code="msg.error.connecting.to.server"/>",
                icon: "[SKIN]say.png",
                title: "<spring:message code="global.form.command.done"/>",
            });
            setTimeout(function () {
                OK.close();
            }, 3000);
        }

    };

    //===================================================================================


    function getTermCodeRequest(termYear) {
        isc.RPCManager.sendRequest({
            actionURL: termUrl+"getCode/" + termYear,
            httpMethod: "GET",
            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
            useSimpleHttp: true,
            contentType: "application/json; charset=utf-8",
            showPrompt: false,
            serverOutputAsString: false,
            callback: function f(resp) {

                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

                    if (resp.data != null) {
                        termCode = resp.data;
                    } else {
                        termCode = "0";
                    }

                    DynamicForm_Term.setValue("code", termYear + "-" + (parseInt(termCode) + 1));

                } else {
                    simpleDialog("<spring:message code="warning"/>", "<spring:message code="msg.error.connecting.to.server"/>", 3000, "error");
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

        if (startDate1.substr(0, 4) != termCode1.substr(0, 4)) {
            simpleDialog("<spring:message code="warning"/>", "<spring:message code="msg.cod.not.match"/>", 3000, "say");
            return;
        }
        if (!DynamicForm_Term.validate()) {
            return;
        }
        var strsData = startDate1.replace(/(\/)/g, "");
        var streData = endDate1.replace(/\//g, "");
//=================================================================
        isc.RPCManager.sendRequest(TrDSRequest(termUrl + "checkForConflict/" + strsData + "/" + streData + "/" + selectTerm.id, "GET", null, "callback:ConflictWhenEdit(rpcResponse)"));
    };

    function ConflictWhenEdit(resp) {
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            if (resp.data.length > 0) {
                var OK = isc.Dialog.create({
                    message: getFormulaMessage(resp.data, 2, "red", "I") + "<spring:message code="msg.conflict.term"/>",
                    icon: "[SKIN]say.png",
                    title: "<spring:message code="warning"/>",
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

                isc.RPCManager.sendRequest(TrDSRequest(termSaveUrl, term_method, JSON.stringify(termData), "callback:show_TermActionResult(rpcResponse)"));
            }
        }

    }

    function show_TermRemoveForm() {
        var record = ListGrid_Term.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.not.selected.record'/>");
        } else {
            var Dialog_Class_remove = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code="verify.delete"/>");
            Dialog_Class_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index == 0) {
                        isc.RPCManager.sendRequest(TrDSRequest(termUrl + record.id, "DELETE", null, "callback: term_delete_result(rpcResponse)"));
                    }
                }
            });
        }

    };

    function show_TermActionResult(resp) {
        var respCode = resp.httpResponseCode;
        if (respCode == 200 || respCode == 201) {
            ListGrid_Term.invalidateCache();
            var OK = isc.Dialog.create({
                message: "<spring:message code="global.form.request.successful"/>",
                icon: "[SKIN]say.png",
                title: "<spring:message code="global.form.command.done"/>"
            });

            setTimeout(function () {
                OK.close();

            }, 2000);

            Window_term.close();

        }
        else if(respCode==405){
            createDialog("info", "<spring:message code="term.usage"/>", "<spring:message code="message"/>");
        }

        else {
            if (respCode == 400) {
                var OK = isc.Dialog.create({
                    message: "<spring:message code="msg.delete.childRecord"/>",
                    icon: "[SKIN]say.png",
                    title: "<spring:message code="error"/>"
                });

                setTimeout(function () {
                    OK.close();
                }, 2000);
            }
        }
    };

    function term_delete_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_Term.invalidateCache();
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
        }

        else if(resp.httpResponseCode===405){
            createDialog("info", "<spring:message code="term.usage"/>", "<spring:message code="message"/>");
            }

        else {
            let respText = resp.httpResponseText;
            if (resp.httpResponseCode === 406 && respText === "NotDeletable") {
                createDialog("info", "<spring:message code='msg.record.fk-class-term-cannot.deleted'/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>");
            }
        }
    }

    function print_TermListGrid(type) {

        var advancedCriteria = ListGrid_Term.getCriteria();
        var criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/term/printWithCriteria/"/>" + type,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "CriteriaStr", type: "hidden"},
                    {name: "sortBy", type: "hidden"},
                    {name: "token", type: "hidden"}
                ]
        })
        criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
        criteriaForm.setValue("sortBy", JSON.stringify(ListGrid_Term.getSort()[0]));
        criteriaForm.setValue("token", "<%= accessToken %>");
        criteriaForm.show();
        criteriaForm.submitForm();
    };

