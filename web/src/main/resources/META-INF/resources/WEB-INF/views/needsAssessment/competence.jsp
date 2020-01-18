<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    let competenceMethod_competence;

    // ------------------------------------------- Menu -------------------------------------------
    isc.Menu.create({
        ID: "CompetenceMenu_competence",
        data: [
            {title: "<spring:message code="refresh"/>", click: function () { refreshLG(CompetenceLG_competence); }},
            {title: "<spring:message code="create"/>", click: function () { createCompetence_competence(); }},
            {title: "<spring:message code="edit"/>", click: function () { editCompetence_competence(); }},
            {title: "<spring:message code="remove"/>", click: function () { removeCompetence_competence(); }},
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    isc.ToolStrip.create({
        ID: "CompetenceTS_competence",
        members: [
            isc.ToolStripButtonRefresh.create({click: function () { refreshLG(CompetenceLG_competence); }}),
            isc.ToolStripButtonCreate.create({click: function () { createCompetence_competence(); }}),
            isc.ToolStripButtonEdit.create({click: function () { editCompetence_competence(); }}),
            isc.ToolStripButtonRemove.create({click: function () { removeCompetence_competence(); }}),
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "CompetenceLGCountLabel_competence"}),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    CompetenceDS_competence = isc.TrDS.create({
        ID: "CompetenceDS_competence",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceTypeId", hidden: true},
            {name: "competenceType.title", title: "<spring:message code="type"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: competenceUrl + "/iscList",
    });

    CompetenceLG_competence = isc.TrLG.create({
        ID: "CompetenceLG_competence",
        dataSource: CompetenceDS_competence,
        autoFetchData: true,
        fields: [{name: "title"}, {name: "competenceType.title"}, {name: "description"},],
        gridComponents: [
            CompetenceTS_competence, "filterEditor", "header", "body"
        ],
        contextMenu: CompetenceMenu_competence,
        dataChanged: function () { updateCountLabel(this, CompetenceLGCountLabel_competence)},
        recordDoubleClick: function () { editCompetence_competence(); },
        selectionUpdated: function (record) { refreshCompetenceValueLG_competence(); }
    });

    CompetenceTypeDS_competence = isc.TrDS.create({
        ID: "CompetenceTypeDS_competence",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: parameterValueUrl + "/iscList/100",
    });

    // ------------------------------------------- DynamicForm & Window -------------------------------------------
    CompetenceDF_competence = isc.DynamicForm.create({
        ID: "CompetenceDF_competence",
        fields: [
            {name: "id", hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, validators: [TrValidators.NotEmpty],},
            {
                name: "competenceTypeId", title: "<spring:message code='type'/>", required: true, type: "select", optionDataSource: CompetenceTypeDS_competence,
                valueField: "id", displayField: "title", filterFields: ["title"], pickListProperties: {showFilterEditor: true,},
            },
            {name: "description", title: "<spring:message code="description"/>", type: "TextAreaItem",},
        ]
    });

    CompetenceWin_competence = isc.Window.create({
        ID: "CompetenceWin_competence",
        width: 800,
        items: [CompetenceDF_competence, isc.TrHLayoutButtons.create({
            members: [
                isc.IButtonSave.create({click: function () { saveCompetence_competence(); }}),
                isc.IButtonCancel.create({click: function () { CompetenceWin_competence.close(); }}),
            ],
        }),]
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrHLayout.create({
        members: [CompetenceLG_competence]
    });

    // ------------------------------------------- Functions -------------------------------------------
    function createCompetence_competence() {
        competenceMethod_competence = "POST";
        CompetenceDF_competence.clearValues();
        CompetenceWin_competence.setTitle("<spring:message code="create"/>&nbsp;" + "<spring:message code="competence"/>");
        CompetenceWin_competence.show();
    }

    function editCompetence_competence() {
        let record = CompetenceLG_competence.getSelectedRecord();
        if (checkRecordAsSelected(record, true, "<spring:message code="competence"/>")) {
            competenceMethod_competence = "PUT";
            CompetenceDF_competence.clearValues();
            CompetenceDF_competence.editRecord(record);
            CompetenceWin_competence.setTitle("<spring:message code="edit"/>&nbsp;" + "<spring:message code="competence"/>");
            CompetenceWin_competence.show();
        }
    }

    function saveCompetence_competence() {
        if (!CompetenceDF_competence.validate()) {
            return;
        }
        let competenceSaveUrl = competenceUrl;
        action = '<spring:message code="create"/>';
        if (competenceMethod_competence.localeCompare("PUT") == 0) {
            let record = CompetenceLG_competence.getSelectedRecord();
            competenceSaveUrl += "/" + record.id;
            action = '<spring:message code="edit"/>';
        }
        let data = CompetenceDF_competence.getValues();
        isc.RPCManager.sendRequest(
            TrDSRequest(competenceSaveUrl, competenceMethod_competence, JSON.stringify(data), "callback: studyResponse(rpcResponse, '" + action + "','<spring:message code="competence"/>', CompetenceWin_competence, CompetenceLG_competence)")
        );
    }

    function removeCompetence_competence() {
        let record = CompetenceLG_competence.getSelectedRecord();
        var entityType = '<spring:message code="competence"/>';
        if (checkRecordAsSelected(record, true, entityType)) {
            removeRecord(competenceUrl + "/" + record.id, entityType, record.title, 'CompetenceLG_competence');
        }
    }