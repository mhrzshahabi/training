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
            {name: "langLevelReading.titleFa"},
            {name: "langLevelWriting.titleFa"},
            {name: "langLevelSpeaking.titleFa"},
            {name: "langLevelTranslation.titleFa"}
        ]
    });

    var RestDataSource_ElangLevel_JspTeacher = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
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
        fields: [
            {name: "id", hidden: true},
            {
                name: "langName",
                title: "زبان خارجی",
                required: true,
                validators: [TrValidators.NotEmpty]
            },
            {
                name: "langLevelReadingId",
                type: "IntegerItem",
                title: "خواندن",
                textAlign: "center",
                width: "*",
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
                name: "langLevelWritingId",
                type: "IntegerItem",
                title: "نوشتن",
                textAlign: "center",
                width: "*",
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
                name: "langLevelSpeakingId",
                type: "IntegerItem",
                title: "مکالمه",
                textAlign: "center",
                width: "*",
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
                name: "langLevelTranslationId",
                type: "IntegerItem",
                title: "ترجمه",
                textAlign: "center",
                width: "*",
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
        ]
    });

    IButton_Save_JspForeignLangKnowledge = isc.TrSaveBtn.create({
        top: 260,
        click: function () {
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
        title: "آشنایی با زبانهای خارجی",
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
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        align: "center",
        fields: [
            {
                name: "langName",
                title: "نام زبان خارجی",
            },
            {
                name: "langLevelReading.titleFa",
                title:"خواندن"
            },
            {
                name: "langLevelWriting.titleFa",
                title: "نوشتن"
            },
            {
                name: "langLevelSpeaking.titleFa",
                title: "مکالمه"
            },
            {
                name: "langLevelTranslation.titleFa",
                title: "ترجمه"
            }
        ],
        rowDoubleClick: function () {
            ListGrid_ForeignLangKnowledge_Edit();
        }
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
    ToolStripButton_Add_JspForeignLangKnowledge = isc.ToolStripButtonAdd.create({
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
        // ListGrid_JspForeignLangKnowledge.invalidateCache();
        // ListGrid_JspForeignLangKnowledge.filterByEditor();
        RestDataSource_JspForeignLangKnowledge.fetchDataURL = foreignLangKnowledgeUrl + "/iscList/" + teacherIdForeignLangKnowledge;
        ListGrid_JspForeignLangKnowledge.fetchData();
        ListGrid_Teacher_JspTeacher.invalidateCache();
    }

    function ListGrid_ForeignLangKnowledge_Add() {
        methodForeignLangKnowledge = "POST";
        saveActionUrlForeignLangKnowledge = foreignLangKnowledgeUrl + "/" + teacherIdForeignLangKnowledge;
        DynamicForm_JspForeignLangKnowledge.clearValues();
        Window_JspForeignLangKnowledge.show();
    }

    function ListGrid_ForeignLangKnowledge_Edit() {
        var record = ListGrid_JspForeignLangKnowledge.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            methodForeignLangKnowledge = "PUT";
            saveActionUrlForeignLangKnowledge = ForeignLangKnowledgeUrl + "/" + record.id;
            DynamicForm_JspForeignLangKnowledge.clearValues();
            DynamicForm_JspForeignLangKnowledge.editRecord(record);
            
            if (subCategoryIds != null && subCategoryIds.length > 0) {
                var subCatIds = [];
                for (var i = 0; i < subCategoryIds.length; i++)
                    subCatIds.add(subCategoryIds[i].id);
                DynamicForm_JspForeignLangKnowledge.getField("subCategories").setValue(subCatIds);
            }
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
                        isc.RPCManager.sendRequest(TrDSRequest(ForeignLangKnowledgeUrl +
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
            ListGrid_Teacher_JspTeacher.invalidateCache();
        }
    }

    function clear_ForeignLangKnowledge() {
        ListGrid_JspForeignLangKnowledge.clear();
    }

    //</script>