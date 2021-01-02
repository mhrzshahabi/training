<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

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
            {name: "domainId", filterOperator: "equals", autoFitWidth: true},
            {name: "domain.id", filterOperator: "equals", autoFitWidth: true},
            {name: "evaluationIndices", filterOperator: "inSet", autoFitWidth: true}
        ],
        fetchDataURL: configQuestionnaireUrl + "/iscList"
    });

    RestDataSource_QuestionDomain_JspConfigQuestionnaire = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true}
        ],
        fetchDataURL: parameterUrl + "/iscList/test"
    });

    RestDataSource_QuestionIndicator_JspConfigQuestionnaire = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "nameFa", title: "<spring:message code="evaluation.index.nameFa"/>", filterOperator: "iContains"},
            {name: "evalStatus", title: "<spring:message code="evaluation.index.evalStatus"/>", filterOperator: "iContains", autoFitWidth: true}
        ],
        fetchDataURL: evaluationIndexUrl + "/iscList"
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*window*/
    //--------------------------------------------------------------------------------------------------------------------//

    DynamicForm_JspConfigQuestionnaire = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        titleAlign: "right",
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
                type: "SelectItem",
                required: true,
                textAlign: "center",
                optionDataSource: RestDataSource_QuestionDomain_JspConfigQuestionnaire,
                valueField: "id",
                displayField: "title",
                pickListFields: [
                    {name: "title"},
                    {name: "code"}
                ]
            },
            {
                name: "evaluationIndices",
                title: "<spring:message code='question.indicator'/>",
                type: "MultiComboBoxItem",
                layoutStyle: "vertical",
                optionDataSource: RestDataSource_QuestionIndicator_JspConfigQuestionnaire,
                valueField: "id",
                displayField: "nameFa",
                filterFields: ["nameFa"],
                comboBoxWidth: "100%",
                width: "585",
                multiple: true,
                filterOnKeypress: true,
                comboBoxProperties: {
                    hint: "",
                    filterFields: ["nameFa", "nameFa"],
                    textMatchStyle: "substring",
                    pickListWidth: 500,
                    pickListProperties: {
                        showFilterEditor: false,
                        autoFitWidthApproach: "both"
                    },
                    pickListFields: [
                        {name: "nameFa", title: "<spring:message code='question.indicator'/>", filterOperator: "iContains"},
                        {name: "evalStatus", title: "<spring:message code="evaluation.index.evalStatus"/>", autoFitWidth: true,
                            valueMap: {"0": "<spring:message code='deActive'/>", "1": "<spring:message code='active'/>"}
                        }
                    ],
                }
            }
        ]
    });

    IButton_Save_JspConfigQuestionnaire = isc.IButtonSave.create({
        top: 260,
        click: function () {
            if (!DynamicForm_JspConfigQuestionnaire.valuesHaveChanged() && methodConfigQuestionnaire === "PUT") {
                Window_JspConfigQuestionnaire.close();
                return;
            }
            if (!DynamicForm_JspConfigQuestionnaire.validate()) {
                return;
            }
            var questionText = DynamicForm_JspConfigQuestionnaire.getValue("question");
            if (questionText[questionText.length - 1] !== '؟' && questionText[questionText.length - 1] !== '?')
                DynamicForm_JspConfigQuestionnaire.setValue("question", questionText + '؟');
            waitConfigQuestionnaire = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlConfigQuestionnaire,
                methodConfigQuestionnaire,
                JSON.stringify(DynamicForm_JspConfigQuestionnaire.getValues()),
                ConfigQuestionnaire_save_result));
        }
    });

    IButton_Cancel_JspConfigQuestionnaire = isc.IButtonCancel.create({
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
        width: "700",
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
        data: [
            <sec:authorize access="hasAuthority('EvaluationQuestion_R')">
            {
            title: "<spring:message code='refresh'/>", click: function () {
                refreshLG(ListGrid_JspConfigQuestionnaire);
            }
        },
            </sec:authorize>

            <sec:authorize access="hasAuthority('EvaluationQuestion_C')">
            {
            title: "<spring:message code='create'/>", click: function () {
                ListGrid_ConfigQuestionnaire_Add();
            }
        },
            </sec:authorize>

            <sec:authorize access="hasAuthority('EvaluationQuestion_U')">
            {
            title: "<spring:message code='edit'/>", click: function () {
                ListGrid_ConfigQuestionnaire_Edit();
            }
        },
            </sec:authorize>

            <sec:authorize access="hasAuthority('EvaluationQuestion_D')">
            {
            title: "<spring:message code='remove'/>", click: function () {
                ListGrid_ConfigQuestionnaire_Remove();
            }
        }
            </sec:authorize>
        ]
    });

    ListGrid_JspConfigQuestionnaire = isc.TrLG.create({

        <sec:authorize access="hasAuthority('EvaluationQuestion_R')">
        dataSource: RestDataSource_JspConfigQuestionnaire,
        </sec:authorize>

        contextMenu: Menu_JspConfigQuestionnaire,
        autoFetchData: true,
        sortField: 1,
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
                canSort: false,
            }
        ],
        <sec:authorize access="hasAuthority('EvaluationQuestion_U')">
        rowDoubleClick: function () {
            ListGrid_ConfigQuestionnaire_Edit();
        },
        </sec:authorize>
        getCellCSSText: function (record) {
            if (record.domain.code === "SAT")
                return "color:red;font-size: 12px;";
            if (record.domain.code === "EQP")
                return "color:blue;font-size: 12px;";
            if (record.domain.code === "CLASS")
                return "color:black;font-size: 12px;";
            if (record.domain.code === "Content")
                return "color:green;font-size: 12px;";
            if (record.domain.code === "TRAINING")
                return "color:gray;font-size: 12px;";
        },
        filterEditorSubmit: function () {
            ListGrid_JspConfigQuestionnaire.invalidateCache();
        }
    });

    ToolStripButton_Refresh_JspConfigQuestionnaire = isc.ToolStripButtonRefresh.create({
        click: function () {
            refreshLG(ListGrid_JspConfigQuestionnaire);
        }
    });

    ToolStripButton_Edit_JspConfigQuestionnaire = isc.ToolStripButtonEdit.create({
        click: function () {
            ListGrid_ConfigQuestionnaire_Edit();
        }
    });
    ToolStripButton_Add_JspConfigQuestionnaire = isc.ToolStripButtonCreate.create({
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
                <sec:authorize access="hasAuthority('EvaluationQuestion_C')">
                ToolStripButton_Add_JspConfigQuestionnaire,
                </sec:authorize>
                <sec:authorize access="hasAuthority('EvaluationQuestion_U')">
                ToolStripButton_Edit_JspConfigQuestionnaire,
                </sec:authorize>

                <sec:authorize access="hasAuthority('EvaluationQuestion_D')">
                ToolStripButton_Remove_JspConfigQuestionnaire,
                </sec:authorize>

                isc.ToolStripButtonExcel.create({
                    click: function () {
                        if (ListGrid_JspConfigQuestionnaire.data.size() < 1)
                            return;

                        ExportToFile.downloadExcelRestUrl(null, ListGrid_JspConfigQuestionnaire, configQuestionnaireUrl + "/iscList", 0, null, '', "ارزیابی - پرسشنامه - بانک سوال", ListGrid_JspConfigQuestionnaire.getCriteria(), null);
                    }
                }),

                <sec:authorize access="hasAuthority('EvaluationQuestion_R')">
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_JspConfigQuestionnaire
                    ]
                })
                </sec:authorize>
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
            <sec:authorize access="hasAuthority('EvaluationQuestion_R')">
            {title: "<spring:message code="question.bank"/>", pane: VLayout_Body_JspConfigQuestionnaire},
            </sec:authorize>

            <sec:authorize access="hasAuthority('Questionnaire_R')">
            {
                title: "<spring:message code="questionnaire"/>",
                pane: isc.ViewLoader.create({viewURL: "web/questionnaire"})
            },
            </sec:authorize>
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*functions*/
    //--------------------------------------------------------------------------------------------------------------------//

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
            isc.RPCManager.sendRequest(TrDSRequest(configQuestionnaireUrl +
                "/usedCount/" +
                ListGrid_JspConfigQuestionnaire.getSelectedRecord().id,
                "GET",
                null,
                function(resp){
                    if(resp.data!=0){
                        createDialog("info", "سوال مورد نظر قابل ویرایش نمی باشد.");
                        return ;
                    }

                    methodConfigQuestionnaire = "PUT";
                    saveActionUrlConfigQuestionnaire = configQuestionnaireUrl + "/" + record.id;
                    DynamicForm_JspConfigQuestionnaire.clearValues();
                    DynamicForm_JspConfigQuestionnaire.editRecord(record);
                    Window_JspConfigQuestionnaire.show();
                }));

        }
    }

    function ListGrid_ConfigQuestionnaire_Remove() {
        let record = ListGrid_JspConfigQuestionnaire.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {

            isc.RPCManager.sendRequest(TrDSRequest(configQuestionnaireUrl +
                "/usedCount/" +
                ListGrid_JspConfigQuestionnaire.getSelectedRecord().id,
                "GET",
                null,
                function(resp){
                    if(resp.data!=0){
                        createDialog("info", "سوال مورد نظر قابل حذف نمی باشد.");
                        return ;
                    }

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
                }));


        }
    }

    function ConfigQuestionnaire_save_result(resp) {
        waitConfigQuestionnaire.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
            refreshLG(ListGrid_JspConfigQuestionnaire);
            Window_JspConfigQuestionnaire.close();
            setTimeout(function () {
                OK.close();
            }, 3000);
        }else if (resp.httpResponseCode === 403) {
            createDialog("info", "سوال مورد نظر قابل ویرایش نمی باشد.");
        }else
        {
            let errors = JSON.parse(resp.httpResponseText).errors;
            let message = "";
            for (let i = 0; i < errors.length; i++) {
                message += errors[i].message + "<br/>";
            }
            createDialog("info", message);
        }
    }

    function ConfigQuestionnaire_remove_result(resp) {
        waitConfigQuestionnaire.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            refreshLG(ListGrid_JspConfigQuestionnaire);
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
        }else if (resp.httpResponseCode === 403) {
            createDialog("info", "سوال مورد نظر قابل حذف نمی باشد.");
        } else {
            if (resp.httpResponseCode === 406) {
                createDialog("info", "<spring:message code='msg.record.cannot.deleted'/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>");
            }
        }
    }

    //</script>
