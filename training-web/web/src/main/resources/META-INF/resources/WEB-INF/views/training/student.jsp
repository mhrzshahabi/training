<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    <spring:eval var="restApiUrl" expression="@environment.getProperty('nicico.rest-api.url')"/>

    var method = "POST";
    var url = "${restApiUrl}/api/student";

    //--------------------------------------------------------------------------------------------------------------------//
    /*Rest Data Sources*/
    //--------------------------------------------------------------------------------------------------------------------//

    var RestDataSource_Student_JspStudent = isc.RestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "studentID"},
            {name: "fullNameFa"},
            {name: "fullNameEn"},
            {name: "personalID"},
            {name: "department"},
            {name: "license"},
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
        fetchDataURL: "${restApiUrl}/api/student/spec-list"
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Menu*/
    //--------------------------------------------------------------------------------------------------------------------//

    var Menu_ListGrid_Student_JspStudent = isc.Menu.create({
        width: 150,
        data: [{
            title: "<spring:message code='refresh'/>", icon: "pieces/16/refresh.png", click: function () {
                ListGrid_student_refresh();
            }
        }, {
            title: "<spring:message code='create'/>", icon: "pieces/16/icon_add.png", click: function () {
                ListGrid_student_add();
            }
        }, {
            title: "<spring:message code='edit'/>", icon: "pieces/16/icon_edit.png", click: function () {
                ListGrid_student_edit();
            }
        }, {
            title: "<spring:message code='remove'/>", icon: "pieces/16/icon_delete.png", click: function () {
                ListGrid_student_remove();
            }
        }, {isSeparator: true}, {
            title: "<spring:message code='print.pdf'/>", icon: "icon/pdf.png", click: function () {
                var advancedCriteria = ListGrid_Student_JspStudent.getCriteria();
                var criteriaForm = isc.DynamicForm.create({
                    method: "POST",
                    action: "/student/printWithCriteria/pdf",
                    target: "_Blank",
                    canSubmit: true,
                    fields:
                        [
                            {name: "CriteriaStr", type: "hidden"}
                        ]
                });
                criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
                criteriaForm.submitForm();
            }
        }, {
            title: "<spring:message code='print.excel'/>", icon: "icon/excel.png", click: function () {
                var advancedCriteria = ListGrid_Student_JspStudent.getCriteria();
                var criteriaForm = isc.DynamicForm.create({
                    method: "POST",
                    action: "/student/printWithCriteria/excel",
                    target: "_Blank",
                    canSubmit: true,
                    fields:
                        [
                            {name: "CriteriaStr", type: "hidden"}
                        ]
                });
                criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
                criteriaForm.submitForm();
            }
        }, {
            title: "<spring:message code='print.html'/>", icon: "icon/html.jpg", click: function () {
                var advancedCriteria = ListGrid_Student_JspStudent.getCriteria();
                var criteriaForm = isc.DynamicForm.create({
                    method: "POST",
                    action: "/student/printWithCriteria/html",
                    target: "_Blank",
                    canSubmit: true,
                    fields:
                        [
                            {name: "CriteriaStr", type: "hidden"}
                        ]
                });
                criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
                criteriaForm.submitForm();
            }
        }]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Listgrid*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ListGrid_Student_JspStudent = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Student_JspStudent,
        contextMenu: Menu_ListGrid_Student_JspStudent,
        doubleClick: function () {
            ListGrid_student_edit();
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {
                name: "studentID",
                title: "<spring:message code='student.ID'/>",
                align: "center",
                filterOperator: "equals"
            },
            {
                name: "fullNameFa",
                title: "<spring:message code='student.persian.name'/>",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "fullNameEn",
                title: "<spring:message code='student.english.name'/>",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "personalID",
                title: "<spring:message code='personal.ID'/>",
                align: "center",
                filterOperator: "contains"
            },
            {
                name: "department",
                title: "<spring:message code='department'/>",
                align: "center",
                filterOperator: "contains"
            },
            {name: "license", title: "<spring:message code='degree'/>", align: "center", filterOperator: "contains"},
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        sortFieldAscendingText: "<spring:message code='sort.ascending'/>",
        sortFieldDescendingText: "<spring:message code='sort.descending'/>",
        configureSortText: "<spring:message code='configureSortText'/>",
        autoFitAllText: "<spring:message code='autoFitAllText'/>",
        autoFitFieldText: "<spring:message code='autoFitFieldText'/>",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>"
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*DynamicForm Add Or Edit*/
    //--------------------------------------------------------------------------------------------------------------------//

    var DynamicForm_Student_JspStudent = isc.DynamicForm.create({
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
                name: "studentID",
                title: "<spring:message code='student.ID'/>",
                required: true,
                keyPressFilter: "[0-9]",
                length: "15"
            },
            {
                name: "personalID",
                title: "<spring:message code='personal.ID'/>",
                keyPressFilter: "[0-9]",
                length: "15"
            },
            {
                name: "fullNameFa",
                title: "<spring:message code='firstName'/>",
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                hint: "Persian/فارسی",
                showHintInField: true
            },
            {
                name: "department",
                title: "<spring:message code='department'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"
            },
            {
                name: "fullNameEn",
                title: "<spring:message code='firstName.latin'/>",
                required: true,
                keyPressFilter: "[a-z|A-Z |]",
                hint: "English/انگليسي",
                showHintInField: true
            },
            {
                name: "license",
                title: "<spring:message code='degree'/>"
            },

        ]

    });

    var IButton_Student_Exit_JspStudent = isc.IButton.create({
        top: 260,
        title: "<spring:message code='cancel'/>",
        align: "center",
        icon: "pieces/16/icon_delete.png",
        click: function () {
            Window_Student_JspStudent.close();
        }
    });

    var IButton_Student_Save_JspStudent = isc.IButton.create({
        top: 260,
        title: "<spring:message code='save'/>",
        align: "center",
        icon: "pieces/16/save.png",
        click: function () {

            DynamicForm_Student_JspStudent.validate();
            if (DynamicForm_Student_JspStudent.hasErrors()) {
                return;
            }
            var data = DynamicForm_Student_JspStudent.getValues();

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
                            ListGrid_Student_JspStudent.setSelectedState(gridState);
                        }, 1000);
                        ListGrid_student_refresh();
                        Window_Student_JspStudent.close();
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

    var HLayOut_StudentSaveOrExit_JspStudent = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "800",
        height: "10",
        alignLayout: "center",
        align: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_Student_Save_JspStudent, IButton_Student_Exit_JspStudent]
    });

    var Window_Student_JspStudent = isc.Window.create({
        title: "<spring:message code='student'/>",
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
            members: [DynamicForm_Student_JspStudent, HLayOut_StudentSaveOrExit_JspStudent]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*ToolStrips and Layout*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ToolStripButton_Refresh_JspStudent = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/refresh.png",
        title: "<spring:message code='refresh'/>",
        click: function () {
            ListGrid_student_refresh();
        }
    });

    var ToolStripButton_Edit_JspStudent = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "<spring:message code='edit'/>",
        click: function () {
            ListGrid_student_edit();
        }
    });

    var ToolStripButton_Add_JspStudent = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "<spring:message code='create'/>",
        click: function () {
            ListGrid_student_add();
        }
    });

    var ToolStripButton_Remove_JspStudent = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "<spring:message code='remove'/>",
        click: function () {
            ListGrid_student_remove();
        }
    });

    var ToolStripButton_Print_JspStudent = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "<spring:message code='print'/>",
        click: function () {
            var advancedCriteria = ListGrid_Student_JspStudent.getCriteria();
            var criteriaForm = isc.DynamicForm.create({
                method: "POST",
                action: "/student/printWithCriteria/pdf",
                target: "_Blank",
                canSubmit: true,
                fields:
                    [
                        {name: "CriteriaStr", type: "hidden"}
                    ]
            });
            criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
            criteriaForm.submitForm();
        }
    });

    var ToolStrip_Actions_JspStudent = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStripButton_Refresh_JspStudent,
            ToolStripButton_Add_JspStudent,
            ToolStripButton_Edit_JspStudent,
            ToolStripButton_Remove_JspStudent,
            ToolStripButton_Print_JspStudent]
    });

    var HLayout_Actions_Student_JspStudent = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_JspStudent]
    });

    var HLayout_Grid_Student_JspStudent = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_Student_JspStudent]
    });

    var VLayout_Body_Student_JspStudent = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            HLayout_Actions_Student_JspStudent
            , HLayout_Grid_Student_JspStudent
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function ListGrid_student_remove() {
        var record = ListGrid_Student_JspStudent.getSelectedRecord();
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
                            actionURL: "${restApiUrl}/api/student/" + record.id,
                            httpMethod: "DELETE",
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            httpHeaders: {"Authorization": "Bearer " + "${cookie['access_token'].getValue()}"},
                            showPrompt: true,
                            serverOutputAsString: false,
                            callback: function (resp) {
                                wait.close();
                                if (resp.httpResponseCode == 200) {
                                    ListGrid_Student_JspStudent.invalidateCache();
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

    function ListGrid_student_edit() {
        DynamicForm_Student_JspStudent.clearValues();
        var record = ListGrid_Student_JspStudent.getSelectedRecord();
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
            url = "${restApiUrl}/api/student/" + record.id;
            DynamicForm_Student_JspStudent.editRecord(record);
            Window_Student_JspStudent.show();
        }
    };

    function ListGrid_student_refresh() {
        ListGrid_Student_JspStudent.invalidateCache();
    };

    function ListGrid_student_add() {
        method = "POST";
        url = "${restApiUrl}/api/student";
        DynamicForm_Student_JspStudent.clearValues();
        Window_Student_JspStudent.show();
    };