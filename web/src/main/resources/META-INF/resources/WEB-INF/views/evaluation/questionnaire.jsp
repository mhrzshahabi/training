<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    let questionnaireMethod_questionnaire;

    // ------------------------------------------- Menu -------------------------------------------
    isc.Menu.create({
        ID: "QuestionnaireMenu_questionnaire",
        data: [
            {title: "<spring:message code="refresh"/>", click: function () { refreshLG(QuestionnaireLG_questionnaire, cleanLG(QuestionnaireValueLG_questionnaire)); }},
            {title: "<spring:message code="create"/>", click: function () { createQuestionnaire_questionnaire(); }},
            {title: "<spring:message code="edit"/>", click: function () { editQuestionnaire_questionnaire(); }},
            {title: "<spring:message code="remove"/>", click: function () { removeQuestionnaire_questionnaire(); }},
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    isc.ToolStrip.create({
        ID: "QuestionnaireTS_questionnaire",
        members: [
            isc.ToolStripButtonRefresh.create({click: function () { refreshLG(QuestionnaireLG_questionnaire, cleanLG(QuestionnaireValueLG_questionnaire)); }}),
            isc.ToolStripButtonCreate.create({click: function () { createQuestionnaire_questionnaire(); }}),
            isc.ToolStripButtonEdit.create({click: function () { editQuestionnaire_questionnaire(); }}),
            isc.ToolStripButtonRemove.create({click: function () { removeQuestionnaire_questionnaire(); }}),
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "QuestionnaireLGCountLabel_questionnaire"}),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    QuestionnaireDS_questionnaire = isc.TrDS.create({
        ID: "QuestionnaireDS_questionnaire",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "type", title: "<spring:message code="type"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: questionnaireUrl + "/iscList",
    });

    QuestionnaireLG_questionnaire = isc.TrLG.create({
        ID: "QuestionnaireLG_questionnaire",
        dataSource: QuestionnaireDS_questionnaire,
        autoFetchData: true,
        fields: [{name: "title"}, {name: "code"}, {name: "type"}, {name: "description"},],
        gridComponents: [
            isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="type"/>" + "</b></span>",}),
            QuestionnaireTS_questionnaire, "filterEditor", "header", "body"
        ],
        contextMenu: QuestionnaireMenu_questionnaire,
        dataChanged: function () { updateCountLabel(this, QuestionnaireLGCountLabel_questionnaire)},
        recordDoubleClick: function () { editQuestionnaire_questionnaire(); },
        selectionUpdated: function (record) { refreshQuestionnaireValueLG_questionnaire(); }
    });

    QuestionnaireValueDS_questionnaire = isc.TrDS.create({
        ID: "QuestionnaireValueDS_questionnaire",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "type", title: "<spring:message code="type"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "value", title: "<spring:message code="value"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
        ],
    });

    QuestionnaireValueLG_questionnaire = isc.TrLG.create({
        ID: "QuestionnaireValueLG_questionnaire",
        dataSource: QuestionnaireValueDS_questionnaire,
        fields: [{name: "title"}, {name: "code"}, {name: "type"}, {name: "value"}, {name: "description"},],
        gridComponents: [
            isc.LgLabel.create({
                contents: "<span><b>" + "<spring:message code="values"/>" + "</b></span>"
            }),
            QuestionnaireValueTS_questionnaire, "filterEditor", "header", "body"
        ],
        contextMenu: QuestionnaireValueMenu_questionnaire,
        dataChanged: function () { updateCountLabel(this, QuestionnaireValueLGCount_questionnaire)},
        recordDoubleClick: function () { editQuestionnaireValue_questionnaire(); }
    });

    // ------------------------------------------- DynamicForm & Window -------------------------------------------
    QuestionnaireDF_questionnaire = isc.DynamicForm.create({
        ID: "QuestionnaireDF_questionnaire",
        fields: [
            {name: "id", hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, validators: [TrValidators.NotEmpty],},
            {name: "code", title: "<spring:message code="code"/>", required: true, validators: [TrValidators.NotEmpty],},
            {name: "type", title: "<spring:message code="type"/>"},
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

    QuestionnaireValueDF_questionnaire = isc.DynamicForm.create({
        ID: "QuestionnaireValueDF_questionnaire",
        fields: [
            {name: "id", hidden: true},
            {name: "questionnaire.id", dataPath: "questionnaireId", hidden: true,},
            {name: "questionnaire.title", title: "<spring:message code="questionnaire.type"/>", canEdit: false},
            {name: "title", title: "<spring:message code="title"/>", required: true, validators: [TrValidators.NotEmpty],},
            {name: "code", title: "<spring:message code="code"/>",},
            {name: "value", title: "<spring:message code="value"/>",},
            {name: "type", title: "<spring:message code="type"/>",},
            {name: "description", title: "<spring:message code="description"/>", type: "TextAreaItem",},
        ]
    });

    QuestionnaireValueWin_questionnaire = isc.Window.create({
        ID: "QuestionnaireValueWin_questionnaire",
        width: 800,
        items: [QuestionnaireValueDF_questionnaire, isc.TrHLayoutButtons.create({
            members: [
                isc.IButtonSave.create({click: function () { saveQuestionnaireValue_questionnaire(); }}),
                isc.IButtonCancel.create({click: function () { QuestionnaireValueWin_questionnaire.close(); }}),
            ],
        }),]
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrHLayout.create({
        members: [QuestionnaireLG_questionnaire, QuestionnaireValueLG_questionnaire]
    });

    // ------------------------------------------- Functions -------------------------------------------
    function createQuestionnaire_questionnaire() {
        questionnaireMethod_questionnaire = "POST";
        QuestionnaireDF_questionnaire.clearValues();
        QuestionnaireWin_questionnaire.setTitle("<spring:message code="create"/>&nbsp;" + "<spring:message code="questionnaire.type"/>");
        QuestionnaireWin_questionnaire.show();
    }

    function editQuestionnaire_questionnaire() {
        let record = QuestionnaireLG_questionnaire.getSelectedRecord();
        if (checkRecordAsSelected(record, true, "<spring:message code="questionnaire.type"/>")) {
            questionnaireMethod_questionnaire = "PUT";
            QuestionnaireDF_questionnaire.clearValues();
            QuestionnaireDF_questionnaire.editRecord(record);
            QuestionnaireWin_questionnaire.setTitle("<spring:message code="edit"/>&nbsp;" + "<spring:message code="questionnaire.type"/>");
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
            TrDSRequest(questionnaireSaveUrl, questionnaireMethod_questionnaire, JSON.stringify(data), "callback: studyResponse(rpcResponse, '" + action + "','<spring:message code="questionnaire.type"/>', QuestionnaireWin_questionnaire, QuestionnaireLG_questionnaire)")
        );
    }

    function removeQuestionnaire_questionnaire() {
        let record = QuestionnaireLG_questionnaire.getSelectedRecord();
        var entityType = '<spring:message code="questionnaire.type"/>';
        if (checkRecordAsSelected(record, true, entityType)) {
            removeRecord(questionnaireUrl + "/" + record.id, entityType, record.title, 'QuestionnaireLG_questionnaire');
        }
    }

    // ---------------------------------------------------------------------------------------------------

    function refreshQuestionnaireValueLG_questionnaire() {
        var record = QuestionnaireLG_questionnaire.getSelectedRecord();
        if (checkRecordAsSelected(record, false)) {
            refreshLgDs(QuestionnaireValueLG_questionnaire, QuestionnaireValueDS_questionnaire, questionnaireValueUrl + "/iscList/" + record.id)
        }
    }

    function createQuestionnaireValue_questionnaire() {
        let record = QuestionnaireLG_questionnaire.getSelectedRecord();
        if (checkRecordAsSelected(record, true, "<spring:message code="questionnaire.type"/>")) {
            questionnaireValueMethod_questionnaire = "POST";
            QuestionnaireValueDF_questionnaire.clearValues();
            QuestionnaireValueDF_questionnaire.getItem("questionnaire.id").setValue(record.id);
            QuestionnaireValueDF_questionnaire.getItem("questionnaire.title").setValue(record.title);
            QuestionnaireValueWin_questionnaire.setTitle("<spring:message code="create"/>&nbsp;" + "<spring:message code="questionnaire.value"/>");
            QuestionnaireValueWin_questionnaire.show();
        }
    }

    function editQuestionnaireValue_questionnaire() {
        let questionnaireRecord = QuestionnaireLG_questionnaire.getSelectedRecord();
        let record = QuestionnaireValueLG_questionnaire.getSelectedRecord();
        if (checkRecordAsSelected(record, true, "<spring:message code="questionnaire.value"/>")) {
            questionnaireValueMethod_questionnaire = "PUT";
            QuestionnaireValueDF_questionnaire.clearValues();
            QuestionnaireValueDF_questionnaire.editRecord(record);
            QuestionnaireValueDF_questionnaire.getItem("questionnaire.id").setValue(questionnaireRecord.id);
            QuestionnaireValueDF_questionnaire.getItem("questionnaire.title").setValue(questionnaireRecord.title);
            QuestionnaireValueWin_questionnaire.setTitle("<spring:message code="edit"/>&nbsp;" + "<spring:message code="questionnaire.value"/>");
            QuestionnaireValueWin_questionnaire.show();
        }
    }

    function saveQuestionnaireValue_questionnaire() {
        if (!QuestionnaireValueDF_questionnaire.validate()) {
            return;
        }
        let questionnaireValueSaveUrl = questionnaireValueUrl;
        let action = '<spring:message code="create"/>';
        if (questionnaireValueMethod_questionnaire.localeCompare("PUT") == 0) {
            let record = QuestionnaireValueLG_questionnaire.getSelectedRecord();
            questionnaireValueSaveUrl += "/" + record.id;
            action = '<spring:message code="edit"/>';
        }
        let data = QuestionnaireValueDF_questionnaire.getValues();
        isc.RPCManager.sendRequest(
            TrDSRequest(questionnaireValueSaveUrl, questionnaireValueMethod_questionnaire, JSON.stringify(data), "callback: studyResponse(rpcResponse, '" + action + "','" + "<spring:message code="questionnaire.value"/>" +
                "', QuestionnaireValueWin_questionnaire, QuestionnaireValueLG_questionnaire)")
        );
    }


    function removeQuestionnaireValue_questionnaire() {
        let record = QuestionnaireValueLG_questionnaire.getSelectedRecord();
        var entityType = '<spring:message code="questionnaire.value"/>';
        if (checkRecordAsSelected(record, true, entityType)) {
            removeRecord(questionnaireValueUrl + "/" + record.id, entityType, record.title, 'QuestionnaireValueLG_questionnaire');
        }
    }
