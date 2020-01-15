<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    let needsAssessmentMethod_needsAssessment;

    // ------------------------------------------- Menu -------------------------------------------
    isc.Menu.create({
        ID: "NeedsAssessmentMenu_needsAssessment",
        data: [
            {title: "<spring:message code="refresh"/>", click: function () { refreshLG(NeedsAssessmentLG_needsAssessment); }},
            {title: "<spring:message code="create"/>", click: function () { createNeedsAssessment_needsAssessment(); }},
            {title: "<spring:message code="edit"/>", click: function () { editNeedsAssessment_needsAssessment(); }},
            {title: "<spring:message code="remove"/>", click: function () { removeNeedsAssessment_needsAssessment(); }},
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    isc.ToolStrip.create({
        ID: "NeedsAssessmentTS_needsAssessment",
        members: [
            isc.ToolStripButtonRefresh.create({click: function () { refreshLG(NeedsAssessmentLG_needsAssessment); }}),
            isc.ToolStripButtonCreate.create({click: function () { createNeedsAssessment_needsAssessment(); }}),
            isc.ToolStripButtonEdit.create({click: function () { editNeedsAssessment_needsAssessment(); }}),
            isc.ToolStripButtonRemove.create({click: function () { removeNeedsAssessment_needsAssessment(); }}),
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "NeedsAssessmentLGCountLabel_needsAssessment"}),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    NeedsAssessmentDS_needsAssessment = isc.TrDS.create({
        ID: "NeedsAssessmentDS_needsAssessment",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "objectId", hidden: true},
            {name: "competenceId", hidden: true},
            {name: "competence.title", title: "<spring:message code="competence"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
            {name: "skillId", hidden: true},
            {name: "skill.title", title: "<spring:message code="skill"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
            {name: "needsAssessmentDomainId", hidden: true},
            {name: "needsAssessmentDomain.title", title: "<spring:message code="domain"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
            {name: "needsAssessmentPriorityId", hidden: true},
            {name: "needsAssessmentPriority.title", title: "<spring:message code="priority"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: needsAssessmentUrl + "/iscList",
    });

    NeedsAssessmentLG_needsAssessment = isc.TrLG.create({
        ID: "NeedsAssessmentLG_needsAssessment",
        dataSource: NeedsAssessmentDS_needsAssessment,
        autoFetchData: true,
        fields: [{name: "competence.title"}, {name: "skill.title"}, {name: "needsAssessmentDomain.title"}, {name: "needsAssessmentPriority.title"},],
        gridComponents: [
            NeedsAssessmentTS_needsAssessment, "filterEditor", "header", "body"
        ],
        contextMenu: NeedsAssessmentMenu_needsAssessment,
        dataChanged: function () { updateCountLabel(this, NeedsAssessmentLGCountLabel_needsAssessment)},
        recordDoubleClick: function () { editNeedsAssessment_needsAssessment(); },
        selectionUpdated: function (record) { refreshNeedsAssessmentValueLG_needsAssessment(); }
    });

    NeedsAssessmentTypeDS_needsAssessment = isc.TrDS.create({
        ID: "NeedsAssessmentTypeDS_needsAssessment",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: parameterValueUrl + "/iscList/100",
    });

    // ------------------------------------------- DynamicForm & Window -------------------------------------------
    NeedsAssessmentDF_needsAssessment = isc.DynamicForm.create({
        ID: "NeedsAssessmentDF_needsAssessment",
        fields: [
            {name: "id", hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, validators: [TrValidators.NotEmpty],},
            {
                name: "needsAssessmentTypeId", title: "<spring:message code='type'/>", required: true, type: "select", optionDataSource: NeedsAssessmentTypeDS_needsAssessment,
                valueField: "id", displayField: "title", filterFields: ["title"], pickListProperties: {showFilterEditor: true,},
            },
            {name: "description", title: "<spring:message code="description"/>", type: "TextAreaItem",},
        ]
    });

    NeedsAssessmentWin_needsAssessment = isc.Window.create({
        ID: "NeedsAssessmentWin_needsAssessment",
        width: 800,
        items: [NeedsAssessmentDF_needsAssessment, isc.TrHLayoutButtons.create({
            members: [
                isc.IButtonSave.create({click: function () { saveNeedsAssessment_needsAssessment(); }}),
                isc.IButtonCancel.create({click: function () { NeedsAssessmentWin_needsAssessment.close(); }}),
            ],
        }),]
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrHLayout.create({
        members: [NeedsAssessmentLG_needsAssessment]
    });

    // ------------------------------------------- Functions -------------------------------------------
    function createNeedsAssessment_needsAssessment() {
        needsAssessmentMethod_needsAssessment = "POST";
        NeedsAssessmentDF_needsAssessment.clearValues();
        NeedsAssessmentWin_needsAssessment.setTitle("<spring:message code="create"/>&nbsp;" + "<spring:message code="needsAssessment"/>");
        NeedsAssessmentWin_needsAssessment.show();
    }

    function editNeedsAssessment_needsAssessment() {
        let record = NeedsAssessmentLG_needsAssessment.getSelectedRecord();
        if (checkRecordAsSelected(record, true, "<spring:message code="needsAssessment"/>")) {
            needsAssessmentMethod_needsAssessment = "PUT";
            NeedsAssessmentDF_needsAssessment.clearValues();
            NeedsAssessmentDF_needsAssessment.editRecord(record);
            NeedsAssessmentWin_needsAssessment.setTitle("<spring:message code="edit"/>&nbsp;" + "<spring:message code="needsAssessment"/>");
            NeedsAssessmentWin_needsAssessment.show();
        }
    }

    function saveNeedsAssessment_needsAssessment() {
        if (!NeedsAssessmentDF_needsAssessment.validate()) {
            return;
        }
        let needsAssessmentSaveUrl = needsAssessmentUrl;
        action = '<spring:message code="create"/>';
        if (needsAssessmentMethod_needsAssessment.localeCompare("PUT") == 0) {
            let record = NeedsAssessmentLG_needsAssessment.getSelectedRecord();
            needsAssessmentSaveUrl += "/" + record.id;
            action = '<spring:message code="edit"/>';
        }
        let data = NeedsAssessmentDF_needsAssessment.getValues();
        isc.RPCManager.sendRequest(
            TrDSRequest(needsAssessmentSaveUrl, needsAssessmentMethod_needsAssessment, JSON.stringify(data), "callback: studyResponse(rpcResponse, '" + action + "','<spring:message code="needsAssessment"/>', NeedsAssessmentWin_needsAssessment, NeedsAssessmentLG_needsAssessment)")
        );
    }

    function removeNeedsAssessment_needsAssessment() {
        let record = NeedsAssessmentLG_needsAssessment.getSelectedRecord();
        var entityType = '<spring:message code="needsAssessment"/>';
        if (checkRecordAsSelected(record, true, entityType)) {
            removeRecord(needsAssessmentUrl + "/" + record.id, entityType, record.title, 'NeedsAssessmentLG_needsAssessment');
        }
    }