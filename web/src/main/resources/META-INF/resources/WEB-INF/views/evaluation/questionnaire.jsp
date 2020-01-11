<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    let questionnaireMethod_questionnaire;
    let questionnaireQuestionMethod_questionnaire;

    // ------------------------------------------- Menu -------------------------------------------
    isc.Menu.create({
        ID: "QuestionnaireMenu_questionnaire",
        data: [
            {title: "<spring:message code="refresh"/>", click: function () { refreshLG(QuestionnaireLG_questionnaire, cleanLG(QuestionnaireQuestionLG_questionnaire)); }},
            {title: "<spring:message code="create"/>", click: function () { createQuestionnaire_questionnaire(); }},
            {title: "<spring:message code="edit"/>", click: function () { editQuestionnaire_questionnaire(); }},
            {title: "<spring:message code="remove"/>", click: function () { removeQuestionnaire_questionnaire(); }},
        ]
    });

    isc.Menu.create({
        ID: "QuestionnaireQuestionMenu_questionnaire",
        data: [
            {title: "<spring:message code="refresh"/>", click: function () { refreshQuestionnaireQuestionLG_questionnaire(); }},
            {title: "<spring:message code="create"/>", click: function () { createQuestionnaireQuestion_questionnaire(); }},
            {title: "<spring:message code="edit"/>", click: function () { editQuestionnaireQuestion_questionnaire(); }},
            {title: "<spring:message code="remove"/>", click: function () { removeQuestionnaireQuestion_questionnaire(); }},
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    isc.ToolStrip.create({
        ID: "QuestionnaireTS_questionnaire",
        members: [
            isc.ToolStripButtonRefresh.create({click: function () { refreshLG(QuestionnaireLG_questionnaire, cleanLG(QuestionnaireQuestionLG_questionnaire)); }}),
            isc.ToolStripButtonCreate.create({click: function () { createQuestionnaire_questionnaire(); }}),
            isc.ToolStripButtonEdit.create({click: function () { editQuestionnaire_questionnaire(); }}),
            isc.ToolStripButtonRemove.create({click: function () { removeQuestionnaire_questionnaire(); }}),
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "QuestionnaireLGCountLabel_questionnaire"}),
        ]
    });

    isc.ToolStrip.create({
        ID: "QuestionnaireQuestionTS_questionnaire",
        members: [
            isc.ToolStripButtonRefresh.create({click: function () { refreshQuestionnaireQuestionLG_questionnaire(); }}),
            isc.ToolStripButtonAdd.create({click: function () { createQuestionnaireQuestion_questionnaire(); }}),
            isc.ToolStripButtonEdit.create({click: function () { editQuestionnaireQuestion_questionnaire(); }}),
            isc.ToolStripButtonRemove.create({click: function () { removeQuestionnaireQuestion_questionnaire(); }}),
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "QuestionnaireQuestionLGCount_questionnaire"}),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    QuestionnaireDS_questionnaire = isc.TrDS.create({
        ID: "QuestionnaireDS_questionnaire",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: questionnaireUrl + "/iscList",
    });

    QuestionnaireLG_questionnaire = isc.TrLG.create({
        ID: "QuestionnaireLG_questionnaire",
        dataSource: QuestionnaireDS_questionnaire,
        autoFetchData: true,
        fields: [{name: "title"}, {name: "description"},],
        gridComponents: [
            isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="questionnaire"/>" + "</b></span>",}),
            QuestionnaireTS_questionnaire, "filterEditor", "header", "body"
        ],
        contextMenu: QuestionnaireMenu_questionnaire,
        dataChanged: function () { updateCountLabel(this, QuestionnaireLGCountLabel_questionnaire)},
        recordDoubleClick: function () { editQuestionnaire_questionnaire(); },
        selectionUpdated: function (record) { refreshQuestionnaireQuestionLG_questionnaire(); }
    });

    QuestionnaireQuestionDS_questionnaire = isc.TrDS.create({
        ID: "QuestionnaireQuestionDS_questionnaire",
        fields: [
            {name: "weight", title: "<spring:message code="weight"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "order", title: "<spring:message code="order"/>", filterOperator: "iContains"},
        ],
    });

    QuestionnaireQuestionLG_questionnaire = isc.TrLG.create({
        ID: "QuestionnaireQuestionLG_questionnaire",
        dataSource: QuestionnaireQuestionDS_questionnaire,
        fields: [{name: "weight"}, {name: "order"}],
        gridComponents: [
            isc.LgLabel.create({
                contents: "<span><b>" + "<spring:message code="questions"/>" + "</b></span>"
            }),
            QuestionnaireQuestionTS_questionnaire, "filterEditor", "header", "body"
        ],
        contextMenu: QuestionnaireQuestionMenu_questionnaire,
        dataChanged: function () { updateCountLabel(this, QuestionnaireQuestionLGCount_questionnaire)},
        recordDoubleClick: function () { editQuestionnaireQuestion_questionnaire(); }
    });

    EvaluationQuestionDS_questionnaire = isc.TrDS.create({
        ID: "EvaluationQuestionDS_questionnaire",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "question", title: "<spring:message code="question"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: configQuestionnaireUrl + "/iscList",
    });

    // ------------------------------------------- DynamicForm & Window -------------------------------------------
    QuestionnaireDF_questionnaire = isc.DynamicForm.create({
        ID: "QuestionnaireDF_questionnaire",
        fields: [
            {name: "id", hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, validators: [TrValidators.NotEmpty],},
            {name: "description", title: "<spring:message code="description"/>", type: "TextAreaItem",},
        ]
    });

    QuestionnaireWin_questionnaire = isc.Window.create({
        ID: "QuestionnaireWin_questionnaire",
        width: 800,
        items: [QuestionnaireDF_questionnaire, isc.TrHLayoutButtons.create({
            members: [
                isc.IButtonSave.create({click: function () { saveQuestionnaire_questionnaire(); }}),
                isc.IButtonCancel.create({click: function () { QuestionnaireWin_questionnaire.close(); }}),
            ],
        }),]
    });

    QuestionnaireQuestionDF_questionnaire = isc.DynamicForm.create({
        ID: "QuestionnaireQuestionDF_questionnaire",
        fields: [
            {name: "id", hidden: true},
            {name: "questionnaire.id", dataPath: "questionnaireId", hidden: true,},
            {name: "questionnaire.title", title: "<spring:message code="questionnaire"/>", canEdit: false},
            {
                name: "evaluationQuestionId",
                title: "<spring:message code='question'/>",
                required: true,
                type: "select",
                optionDataSource: EvaluationQuestionDS_questionnaire,
                multiple: true,
                valueField: "id",
                displayField: "question",
                filterFields: ["question"],
                pickListProperties: {
                    showFilterEditor: true,
                },
            },
            {name: "weight", title: "<spring:message code="weight"/>", required: true, editorType: "SpinnerItem", defaultValue: 1, min: 1},
            {name: "order", title: "<spring:message code="order"/>"},
        ]
    });

    QuestionnaireQuestionWin_questionnaire = isc.Window.create({
        ID: "QuestionnaireQuestionWin_questionnaire",
        width: 800,
        items: [QuestionnaireQuestionDF_questionnaire, isc.TrHLayoutButtons.create({
            members: [
                isc.IButtonSave.create({click: function () { saveQuestionnaireQuestion_questionnaire(); }}),
                isc.IButtonCancel.create({click: function () { QuestionnaireQuestionWin_questionnaire.close(); }}),
            ],
        }),]
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrHLayout.create({
        members: [QuestionnaireLG_questionnaire, QuestionnaireQuestionLG_questionnaire]
    });

    // ------------------------------------------- Functions -------------------------------------------
    function createQuestionnaire_questionnaire() {
        questionnaireMethod_questionnaire = "POST";
        QuestionnaireDF_questionnaire.clearValues();
        QuestionnaireWin_questionnaire.setTitle("<spring:message code="create"/>&nbsp;" + "<spring:message code="questionnaire"/>");
        QuestionnaireWin_questionnaire.show();
    }

    function editQuestionnaire_questionnaire() {
        let record = QuestionnaireLG_questionnaire.getSelectedRecord();
        if (checkRecordAsSelected(record, true, "<spring:message code="questionnaire"/>")) {
            questionnaireMethod_questionnaire = "PUT";
            QuestionnaireDF_questionnaire.clearValues();
            QuestionnaireDF_questionnaire.editRecord(record);
            QuestionnaireWin_questionnaire.setTitle("<spring:message code="edit"/>&nbsp;" + "<spring:message code="questionnaire"/>");
            QuestionnaireWin_questionnaire.show();
        }
    }

    function saveQuestionnaire_questionnaire() {
        if (!QuestionnaireDF_questionnaire.validate()) {
            return;
        }
        let questionnaireSaveUrl = questionnaireUrl;
        action = '<spring:message code="create"/>';
        if (questionnaireMethod_questionnaire.localeCompare("PUT") == 0) {
            let record = QuestionnaireLG_questionnaire.getSelectedRecord();
            questionnaireSaveUrl += "/" + record.id;
            action = '<spring:message code="edit"/>';
        }
        let data = QuestionnaireDF_questionnaire.getValues();
        isc.RPCManager.sendRequest(
            TrDSRequest(questionnaireSaveUrl, questionnaireMethod_questionnaire, JSON.stringify(data), "callback: studyResponse(rpcResponse, '" + action + "','<spring:message code="questionnaire"/>', QuestionnaireWin_questionnaire, QuestionnaireLG_questionnaire)")
        );
    }

    function removeQuestionnaire_questionnaire() {
        let record = QuestionnaireLG_questionnaire.getSelectedRecord();
        var entityType = '<spring:message code="questionnaire"/>';
        if (checkRecordAsSelected(record, true, entityType)) {
            removeRecord(questionnaireUrl + "/" + record.id, entityType, record.title, 'QuestionnaireLG_questionnaire');
        }
    }

    // ---------------------------------------------------------------------------------------------------

    function refreshQuestionnaireQuestionLG_questionnaire() {
        var record = QuestionnaireLG_questionnaire.getSelectedRecord();
        if (checkRecordAsSelected(record, false)) {
            // refreshLgDs(QuestionnaireQuestionLG_questionnaire, QuestionnaireQuestionDS_questionnaire, questionnaireQuestionUrl + "/iscList/" + record.id)
        }
    }

    function createQuestionnaireQuestion_questionnaire() {
        let record = QuestionnaireLG_questionnaire.getSelectedRecord();
        if (checkRecordAsSelected(record, true, "<spring:message code="questionnaire"/>")) {
            questionnaireQuestionMethod_questionnaire = "POST";
            QuestionnaireQuestionDF_questionnaire.clearValues();
            QuestionnaireQuestionDF_questionnaire.getItem("questionnaire.id").setValue(record.id);
            QuestionnaireQuestionDF_questionnaire.getItem("questionnaire.title").setValue(record.title);
            QuestionnaireQuestionWin_questionnaire.setTitle("<spring:message code="add"/>&nbsp;" + "<spring:message code="question"/>");
            QuestionnaireQuestionWin_questionnaire.show();
        }
    }

    function editQuestionnaireQuestion_questionnaire() {
        let questionnaireRecord = QuestionnaireLG_questionnaire.getSelectedRecord();
        let record = QuestionnaireQuestionLG_questionnaire.getSelectedRecord();
        if (checkRecordAsSelected(record, true, "<spring:message code="questionnaire.value"/>")) {
            questionnaireQuestionMethod_questionnaire = "PUT";
            QuestionnaireQuestionDF_questionnaire.clearValues();
            QuestionnaireQuestionDF_questionnaire.editRecord(record);
            QuestionnaireQuestionDF_questionnaire.getItem("questionnaire.id").setValue(questionnaireRecord.id);
            QuestionnaireQuestionDF_questionnaire.getItem("questionnaire.title").setValue(questionnaireRecord.title);
            QuestionnaireQuestionWin_questionnaire.setTitle("<spring:message code="edit"/>&nbsp;" + "<spring:message code="questionnaire.value"/>");
            QuestionnaireQuestionWin_questionnaire.show();
        }
    }

    function saveQuestionnaireQuestion_questionnaire() {
        if (!QuestionnaireQuestionDF_questionnaire.validate()) {
            return;
        }
        let questionnaireQuestionSaveUrl = questionnaireQuestionUrl;
        let action = '<spring:message code="create"/>';
        if (questionnaireQuestionMethod_questionnaire.localeCompare("PUT") == 0) {
            let record = QuestionnaireQuestionLG_questionnaire.getSelectedRecord();
            questionnaireQuestionSaveUrl += "/" + record.id;
            action = '<spring:message code="edit"/>';
        }
        let data = QuestionnaireQuestionDF_questionnaire.getValues();
        isc.RPCManager.sendRequest(
            TrDSRequest(questionnaireQuestionSaveUrl, questionnaireQuestionMethod_questionnaire, JSON.stringify(data), "callback: studyResponse(rpcResponse, '" + action + "','" + "<spring:message code="questionnaire.value"/>" +
                "', QuestionnaireQuestionWin_questionnaire, QuestionnaireQuestionLG_questionnaire)")
        );
    }


    function removeQuestionnaireQuestion_questionnaire() {
        let record = QuestionnaireQuestionLG_questionnaire.getSelectedRecord();
        var entityType = '<spring:message code="questionnaire.value"/>';
        if (checkRecordAsSelected(record, true, entityType)) {
            removeRecord(questionnaireQuestionUrl + "/" + record.id, entityType, record.title, 'QuestionnaireQuestionLG_questionnaire');
        }
    }
