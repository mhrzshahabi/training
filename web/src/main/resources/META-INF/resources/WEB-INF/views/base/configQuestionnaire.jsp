<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    let methodConfigQuestionnaire = "GET";
    let saveActionUrlConfigQuestionnaire;
    let waitConfigQuestionnaire;
    let teacherIdConfigQuestionnaire = null;
    let isCategoriesChanged = false;

    //--------------------------------------------------------------------------------------------------------------------//
    /*RestDataSource*/
    //--------------------------------------------------------------------------------------------------------------------//

    RestDataSource_JspConfigQuestionnaire = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "question", filterOperator: "iContains"},
            {name: "domainId", filterOperator: "equals"},
            {name: "domain.id", filterOperator: "equals"},
            {name: "evaluationIndices", filterOperator: "inSet"}
        ],
        fetchDataURL: configQuestionnaireUrl + "/iscList"
    });

    RestDataSource_QuestionDomain_JspConfigQuestionnaire = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        fetchDataURL: parameterValueUrl + "/iscList/49"
    });

    RestDataSource_QuestionIndicator_JspConfigQuestionnaire = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "nameFa", title: "<spring:message code="evaluation.index.nameFa"/>", filterOperator: "iContains"},
            {name: "evalStatus", title: "<spring:message code="evaluation.index.evalStatus"/>",type: "boolean"}
        ],
        fetchDataURL: evaluationIndexHomeUrl + "/iscList"
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*window*/
    //--------------------------------------------------------------------------------------------------------------------//

    DynamicForm_JspConfigQuestionnaire = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        titleAlign: "left",
        fields: [
            {name: "id", hidden: true},
            {
                name: "question",
                title: "<spring:message code='question'/>",
                required: true,
                length: 150
            },
            {
                name: "domainId",
                title: "<spring:message code='question.domain'/>",
                type: "selectItem",
                required: true,
                textAlign: "center",
                optionDataSource: RestDataSource_QuestionDomain_JspConfigQuestionnaire,
                valueField: "id",
                displayField: "title",
                filterFields: ["title"],
                multiple: false,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                pickListFields: [
                    {
                        name: "title",
                        title: "<spring:message code='question.domain'/>",
                        filterOperator: "iContains",
                        width: "30%"
                    },
                    {
                        name: "code",
                        title: "<spring:message code="code"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    }
                ]
            },
            {
                name: "evaluationIndices",
                title: "<spring:message code='question.indicator'/>",
                type: "selectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_QuestionIndicator_JspConfigQuestionnaire,
                valueField: "id",
                displayField: "nameFa",
                filterFields: ["nameFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                pickListFields: [
                    {
                        name: "nameFa",
                        title: "<spring:message code='question.indicator'/>",
                        filterOperator: "iContains",
                        width: "30%"
                    },
                    {
                        name: "evalStatus",
                        title: "<spring:message code="evaluation.index.evalStatus"/>",
                        filterOperator: "iContains"
                    }
                ]
            }
        ]
    });

    IButton_Save_JspConfigQuestionnaire = isc.TrSaveBtn.create({
        top: 260,
        click: function () {
            if (!DynamicForm_JspConfigQuestionnaire.valuesHaveChanged()) {
                Window_JspConfigQuestionnaire.close();
                return;
            }
            if (!DynamicForm_JspConfigQuestionnaire.validate()) {
                return;
            }
            var questionText = DynamicForm_JspConfigQuestionnaire.getValue("question");
            if (questionText[questionText.length - 1] !== '؟')
                DynamicForm_JspConfigQuestionnaire.setValue("question", questionText + '؟');
            waitConfigQuestionnaire = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlConfigQuestionnaire,
                methodConfigQuestionnaire,
                JSON.stringify(DynamicForm_JspConfigQuestionnaire.getValues()),
                ConfigQuestionnaire_save_result));
        }
    });

    IButton_Cancel_JspConfigQuestionnaire = isc.TrCancelBtn.create({
        click: function () {
            DynamicForm_JspConfigQuestionnaire.clearValues();
            Window_JspConfigQuestionnaire.close();
        }
    });

    HLayout_SaveOrExit_JspConfigQuestionnaire = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Save_JspConfigQuestionnaire, IButton_Cancel_JspConfigQuestionnaire]
    });

    Window_JspConfigQuestionnaire = isc.Window.create({
        width: "500",
        align: "center",
        border: "1px solid gray",
        title: "<spring:message code='question'/>",
        items: [isc.TrVLayout.create({
            members: [DynamicForm_JspConfigQuestionnaire, HLayout_SaveOrExit_JspConfigQuestionnaire]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Grid*/
    //--------------------------------------------------------------------------------------------------------------------//

    Menu_JspConfigQuestionnaire = isc.Menu.create({
        data: [{
            title: "<spring:message code='refresh'/>", click: function () {
                ListGrid_ConfigQuestionnaire_refresh();
            }
        }, {
            title: "<spring:message code='create'/>", click: function () {
                ListGrid_ConfigQuestionnaire_Add();
            }
        }, {
            title: "<spring:message code='edit'/>", click: function () {
                ListGrid_ConfigQuestionnaire_Edit();
            }
        }, {
            title: "<spring:message code='remove'/>", click: function () {
                ListGrid_ConfigQuestionnaire_Remove();
            }
        }
        ]
    });

    ListGrid_JspConfigQuestionnaire = isc.TrLG.create({
        dataSource: RestDataSource_JspConfigQuestionnaire,
        contextMenu: Menu_JspConfigQuestionnaire,
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        align: "center",
        fields: [
            {
                name: "question",
                title: "<spring:message code='question'/>"
            },
            {
                name: "domainId",
                title: "<spring:message code='question.domain'/>",
                type: "selectItem",
                optionDataSource: RestDataSource_QuestionDomain_JspConfigQuestionnaire,
                valueField: "id",
                displayField: "title",
                filterLocally: true,
                filterOnKeypress: true
            },
            {
                name: "evaluationIndices",
                title: "<spring:message code='question.indicator'/>",
                type: "selectItem",
                optionDataSource: RestDataSource_QuestionIndicator_JspConfigQuestionnaire,
                valueField: "id",
                displayField: "nameFa",
                filterOnKeypress: true,
                multiple: true,
                filterLocally: false
            }
        ],
        rowDoubleClick: function () {
            ListGrid_ConfigQuestionnaire_Edit();
        },
        getCellCSSText: function (record) {
            if (record.domain.code === "PRF")
                return "color:red;font-size: 12px;";
            if (record.domain.code === "EQP")
                return "color:blue;font-size: 12px;";
        },
        filterEditorSubmit: function () {
            ListGrid_JspConfigQuestionnaire.invalidateCache();
        }
    });

    ToolStripButton_Refresh_JspConfigQuestionnaire = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_ConfigQuestionnaire_refresh();
        }
    });

    ToolStripButton_Edit_JspConfigQuestionnaire = isc.ToolStripButtonEdit.create({
        click: function () {
            ListGrid_ConfigQuestionnaire_Edit();
        }
    });
    ToolStripButton_Add_JspConfigQuestionnaire = isc.ToolStripButtonAdd.create({
        click: function () {
            ListGrid_ConfigQuestionnaire_Add();
        }
    });
    ToolStripButton_Remove_JspConfigQuestionnaire = isc.ToolStripButtonRemove.create({
        click: function () {
            ListGrid_ConfigQuestionnaire_Remove();
        }
    });

    ToolStrip_Actions_JspConfigQuestionnaire = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_Add_JspConfigQuestionnaire,
                ToolStripButton_Edit_JspConfigQuestionnaire,
                ToolStripButton_Remove_JspConfigQuestionnaire,
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_JspConfigQuestionnaire
                    ]
                })
            ]
    });

    VLayout_Body_JspConfigQuestionnaire = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_JspConfigQuestionnaire,
            ListGrid_JspConfigQuestionnaire
        ]
    });

    Tabset_Body_JspConfigQuestionnaire = isc.TabSet.create({
        tabBarPosition: "right",
        tabBarThickness: 125,
        tabs: [
            {
                title: "<spring:message code="evaluation.question.repository"/>",
                pane: VLayout_Body_JspConfigQuestionnaire
            }
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function ListGrid_ConfigQuestionnaire_refresh() {
        ListGrid_JspConfigQuestionnaire.invalidateCache();
        ListGrid_JspConfigQuestionnaire.filterByEditor();
        RestDataSource_QuestionDomain_JspConfigQuestionnaire.fetchData();
        RestDataSource_QuestionIndicator_JspConfigQuestionnaire.fetchData();
    }

    function ListGrid_ConfigQuestionnaire_Add() {
        methodConfigQuestionnaire = "POST";
        saveActionUrlConfigQuestionnaire = configQuestionnaireUrl;
        DynamicForm_JspConfigQuestionnaire.clearValues();
        Window_JspConfigQuestionnaire.show();
    }

    function ListGrid_ConfigQuestionnaire_Edit() {
        var record = ListGrid_JspConfigQuestionnaire.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            methodConfigQuestionnaire = "PUT";
            saveActionUrlConfigQuestionnaire = configQuestionnaireUrl + "/" + record.id;
            DynamicForm_JspConfigQuestionnaire.clearValues();
            DynamicForm_JspConfigQuestionnaire.editRecord(record);
            Window_JspConfigQuestionnaire.show();
        }
    }

    function ListGrid_ConfigQuestionnaire_Remove() {
        let record = ListGrid_JspConfigQuestionnaire.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            let Dialog_Delete = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code='verify.delete'/>");
            Dialog_Delete.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        waitConfigQuestionnaire = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(configQuestionnaireUrl +
                            "/" +
                            ListGrid_JspConfigQuestionnaire.getSelectedRecord().id,
                            "DELETE",
                            null,
                            ConfigQuestionnaire_remove_result));
                    }
                }
            });
        }
    }

    function ConfigQuestionnaire_save_result(resp) {
        waitConfigQuestionnaire.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            ListGrid_ConfigQuestionnaire_refresh();
            Window_JspConfigQuestionnaire.close();
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

    function ConfigQuestionnaire_remove_result(resp) {
        waitConfigQuestionnaire.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_ConfigQuestionnaire_refresh();
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            let respText = resp.httpResponseText;
            if (resp.httpResponseCode === 406 && respText === "NotDeletable") {
                createDialog("info", "<spring:message code='msg.record.cannot.deleted'/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>");
            }
        }
    }

    //</script>