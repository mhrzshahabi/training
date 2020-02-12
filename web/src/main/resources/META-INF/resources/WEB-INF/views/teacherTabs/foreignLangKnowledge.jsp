<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    var methodForeignLangKnowledge = "GET";
    var saveActionUrlForeignLangKnowledge;
    var waitForeignLangKnowledge;
    var teacherIdForeignLangKnowledge = null;


    //--------------------------------------------------------------------------------------------------------------------//
    /*RestDataSource*/
    //--------------------------------------------------------------------------------------------------------------------//

    RestDataSource_JspForeignLangKnowledge = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "langName", filterOperator: "iContains"},
            {name: "langLevelId", filterOperator: "equals"},
            {name: "langLevel.titleFa"},
            {name: "instituteName"},
            {name: "duration"},
            {name: "startDate"},
            {name: "endDate"}
        ]
    });

    var RestDataSource_ElangLevel_JspTeacher = isc.TrDS.create({
        fields:[{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "iContains"}],
        fetchDataURL: enumUrl + "eLangLevel/spec-list"
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*window*/
    //--------------------------------------------------------------------------------------------------------------------//

    DynamicForm_JspForeignLangKnowledge = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        titleAlign: "left",
        showInlineErrors: true,
        showErrorText: false,
        fields: [
            {name: "id", hidden: true},
            {
                name: "langName",
                title: "<spring:message code="foreign.language"/>",
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"
            },
            {
                name: "langLevelId",
                type: "IntegerItem",
                title: "<spring:message code="knowledge.level"/>",
                textAlign: "center",
                width: "*",
                required: true,
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                defaultToFirstOption: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_ElangLevel_JspTeacher,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {name: "titleFa", width: "30%", filterOperator: "iContains"}]
            },
            {
                name: "instituteName",
                title: "<spring:message code="institute.place"/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"
            },
            {
                name: "duration",
                title: "<spring:message code="duration"/>",
                type: "IntegerItem",
                keyPressFilter: "[0-9]",
                hint: "<spring:message code='hour'/>",
                showHintInField: true,
                length: 5
            },
            {
                name: "startDate",
                ID: "foreignLangKnowledge_startDate_JspForeignLangKnowledge",
                title: "<spring:message code='start.date'/>",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('foreignLangKnowledge_startDate_JspForeignLangKnowledge', this, 'ymd', '/');
                    }
                }],
                validators: [{
                    type: "custom",
                    errorMessage: "<spring:message code='msg.correct.date'/>",
                    condition: function (item, validator, value) {
                        if (value === undefined)
                            return  DynamicForm_JspForeignLangKnowledge.getValue("endDate") === undefined;
                        return checkBirthDate(value);
                    }
                }]
            },
            {
                name: "endDate",
                ID: "foreignLangKnowledge_endDate_JspForeignLangKnowledge",
                title: "<spring:message code='end.date'/>",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('foreignLangKnowledge_endDate_JspForeignLangKnowledge', this, 'ymd', '/');
                    }
                }],
                validators: [{
                    type: "custom",
                    errorMessage: "<spring:message code='msg.correct.date'/>",
                    condition: function (item, validator, value) {
                        if (value === undefined)
                            return  DynamicForm_JspForeignLangKnowledge.getValue("startDate") === undefined;
                        if (!checkDate(value))
                            return false;
                        if ( DynamicForm_JspForeignLangKnowledge.hasFieldErrors("startDate"))
                            return true;
                        var startDate = JalaliDate.jalaliToGregori( DynamicForm_JspForeignLangKnowledge.getValue("startDate"));
                        var endDate = JalaliDate.jalaliToGregori( DynamicForm_JspForeignLangKnowledge.getValue("endDate"));
                        return Date.compareDates(startDate, endDate) === 1;
                    }
                }]
            }
        ]
    });

    IButton_Save_JspForeignLangKnowledge = isc.TrSaveBtn.create({
        top: 260,
        click: function () {
            DynamicForm_JspForeignLangKnowledge.validate();
            if (!DynamicForm_JspForeignLangKnowledge.valuesHaveChanged() || !DynamicForm_JspForeignLangKnowledge.validate())
                return;
            waitForeignLangKnowledge = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlForeignLangKnowledge,
                methodForeignLangKnowledge,
                JSON.stringify(DynamicForm_JspForeignLangKnowledge.getValues()),
                "callback: ForeignLangKnowledge_save_result(rpcResponse)"));
        }
    });

    IButton_Cancel_JspForeignLangKnowledge = isc.TrCancelBtn.create({
        click: function () {
            DynamicForm_JspForeignLangKnowledge.clearValues();
            Window_JspForeignLangKnowledge.close();
        }
    });

    HLayout_SaveOrExit_JspForeignLangKnowledge = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Save_JspForeignLangKnowledge, IButton_Cancel_JspForeignLangKnowledge]
    });

    Window_JspForeignLangKnowledge = isc.Window.create({
        width: "500",
        align: "center",
        border: "1px solid gray",
        title: "<spring:message code="foreign.languages.knowledge"/>",
        items: [isc.TrVLayout.create({
            members: [DynamicForm_JspForeignLangKnowledge, HLayout_SaveOrExit_JspForeignLangKnowledge]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Grid*/
    //--------------------------------------------------------------------------------------------------------------------//

    Menu_JspForeignLangKnowledge = isc.Menu.create({
        data: [{
            title: "<spring:message code='refresh'/>", click: function () {
                ListGrid_ForeignLangKnowledge_refresh();
            }
        }, {
            title: "<spring:message code='create'/>", click: function () {
                ListGrid_ForeignLangKnowledge_Add();
            }
        }, {
            title: "<spring:message code='edit'/>", click: function () {
                ListGrid_ForeignLangKnowledge_Edit();
            }
        }, {
            title: "<spring:message code='remove'/>", click: function () {
                ListGrid_ForeignLangKnowledge_Remove();
            }
        }
        ]
    });

    ListGrid_JspForeignLangKnowledge = isc.TrLG.create({
        dataSource: RestDataSource_JspForeignLangKnowledge,
        contextMenu: Menu_JspForeignLangKnowledge,
        fields: [
            {
                name: "langName",
                title: "<spring:message code='foreign.language'/>",
            },
            {
                name: "langLevelId",
                title:"<spring:message code='knowledge.level'/>",
                type: "IntegerItem",
                editorType: "SelectItem",
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_ElangLevel_JspTeacher,
                filterOnKeypress: true
            },
            {
                name: "instituteName",
                title: "<spring:message code="institute.place"/>"
            },
            {
                name: "duration",
                title: "<spring:message code="duration"/>"
            },
            {
                name: "startDate",
                title: "<spring:message code='start.date'/>",
                canSort: false
            },
            {
                name: "endDate",
                title: "<spring:message code='end.date'/>",
                canSort: false
            }
        ],
        rowDoubleClick: function () {
            ListGrid_ForeignLangKnowledge_Edit();
        },
        align: "center",
        filterOperator: "iContains",
        filterOnKeypress: false,
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>"
    });

    ToolStripButton_Refresh_JspForeignLangKnowledge = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_ForeignLangKnowledge_refresh();
        }
    });

    ToolStripButton_Edit_JspForeignLangKnowledge = isc.ToolStripButtonEdit.create({
        click: function () {
            ListGrid_ForeignLangKnowledge_Edit();
        }
    });
    ToolStripButton_Add_JspForeignLangKnowledge = isc.ToolStripButtonCreate.create({
        click: function () {
            ListGrid_ForeignLangKnowledge_Add();
        }
    });
    ToolStripButton_Remove_JspForeignLangKnowledge = isc.ToolStripButtonRemove.create({
        click: function () {
            ListGrid_ForeignLangKnowledge_Remove();
        }
    });

    ToolStrip_Actions_JspForeignLangKnowledge = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_Add_JspForeignLangKnowledge,
                ToolStripButton_Edit_JspForeignLangKnowledge,
                ToolStripButton_Remove_JspForeignLangKnowledge,
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_JspForeignLangKnowledge
                    ]
                })
            ]
    });

    VLayout_Body_JspForeignLangKnowledge = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_JspForeignLangKnowledge,
            ListGrid_JspForeignLangKnowledge
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function ListGrid_ForeignLangKnowledge_refresh() {
        ListGrid_JspForeignLangKnowledge.invalidateCache();
        ListGrid_JspForeignLangKnowledge.filterByEditor();
    }

    function ListGrid_ForeignLangKnowledge_Add() {
        methodForeignLangKnowledge = "POST";
        saveActionUrlForeignLangKnowledge = foreignLangKnowledgeUrl + "/" + teacherIdForeignLangKnowledge;
        DynamicForm_JspForeignLangKnowledge.clearValues();
        DynamicForm_JspForeignLangKnowledge.getField("langName").enable();
        Window_JspForeignLangKnowledge.show();
    }

    function ListGrid_ForeignLangKnowledge_Edit() {
        var record = ListGrid_JspForeignLangKnowledge.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            methodForeignLangKnowledge = "PUT";
            saveActionUrlForeignLangKnowledge = foreignLangKnowledgeUrl + "/" + record.id;
            DynamicForm_JspForeignLangKnowledge.clearValues();
            DynamicForm_JspForeignLangKnowledge.editRecord(record);
            DynamicForm_JspForeignLangKnowledge.getField("langName").disable();
            Window_JspForeignLangKnowledge.show();
        }
    }

    function ListGrid_ForeignLangKnowledge_Remove() {
        var record = ListGrid_JspForeignLangKnowledge.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            var Dialog_Delete = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code='verify.delete'/>");
            Dialog_Delete.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        waitForeignLangKnowledge = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(foreignLangKnowledgeUrl +
                            "/" +
                            teacherIdForeignLangKnowledge +
                            "," +
                            ListGrid_JspForeignLangKnowledge.getSelectedRecord().id,
                            "DELETE",
                            null,
                            "callback: ForeignLangKnowledge_remove_result(rpcResponse)"));
                    }
                }
            });
        }
    }

    function ForeignLangKnowledge_save_result(resp) {
        waitForeignLangKnowledge.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            ListGrid_JspForeignLangKnowledge.invalidateCache();
            Window_JspForeignLangKnowledge.close();
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            if (resp.httpResponseCode === 406 && resp.httpResponseText === "DuplicateRecord") {
                createDialog("info", "<spring:message code="msg.record.duplicate"/>",
                    "<spring:message code="message"/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>",
                    "<spring:message code="message"/>");
            }
        }
    }

    function ForeignLangKnowledge_remove_result(resp) {
        waitForeignLangKnowledge.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_ForeignLangKnowledge_refresh();
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            var respText = resp.httpResponseText;
            if (resp.httpResponseCode === 406 && respText === "NotDeletable") {
                createDialog("info", "<spring:message code='msg.record.cannot.deleted'/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>");
            }
        }
    }

    function loadPage_ForeignLangKnowledge(id) {
        if (teacherIdForeignLangKnowledge !== id) {
            teacherIdForeignLangKnowledge = id;
            RestDataSource_JspForeignLangKnowledge.fetchDataURL = foreignLangKnowledgeUrl + "/iscList/" + teacherIdForeignLangKnowledge;
            ListGrid_JspForeignLangKnowledge.fetchData();
            ListGrid_ForeignLangKnowledge_refresh();
        }
    }

    function clear_ForeignLangKnowledge() {
        ListGrid_JspForeignLangKnowledge.clear();
    }

    //</script>