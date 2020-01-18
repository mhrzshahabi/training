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
        // autoFetchData: true,
        fields: [{name: "competence.title"}, {name: "skill.title"}, {name: "needsAssessmentDomain.title"}, {name: "needsAssessmentPriority.title"},],
        gridComponents: [
            NeedsAssessmentTS_needsAssessment, "filterEditor", "header", "body"
        ],
        contextMenu: NeedsAssessmentMenu_needsAssessment,
        dataChanged: function () { updateCountLabel(this, NeedsAssessmentLGCountLabel_needsAssessment)},
        recordDoubleClick: function () { editNeedsAssessment_needsAssessment(); },
        selectionUpdated: function (record) { refreshNeedsAssessmentValueLG_needsAssessment(); }
    });

    CompetenceDS_needsAssessment = isc.TrDS.create({
        ID: "CompetenceDS_needsAssessment",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceType.title", title: "<spring:message code="type"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: competenceUrl + "/iscList",
    });

    SkillDS_needsAssessment = isc.TrDS.create({
        ID: "SkillDS_needsAssessment",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: skillUrl + "/spec-list"
    });

    NeedsAssessmentDomainDS_competence = isc.TrDS.create({
        ID: "NeedsAssessmentDomainDS_competence",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: parameterValueUrl + "/iscList/101",
    });

    NeedsAssessmentPriorityDS_competence = isc.TrDS.create({
        ID: "NeedsAssessmentPriorityDS_competence",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: parameterValueUrl + "/iscList/102",
    });

    // ------------------------------------------- DynamicForm & Window -------------------------------------------
    NeedsAssessmentDF_needsAssessment = isc.DynamicForm.create({
        ID: "NeedsAssessmentDF_needsAssessment",
        fields: [
            {name: "id", hidden: true},
            {
                name: "object",
                title: "<spring:message code='type'/>",
                required: true,
                valueMap: {
                    job: "<spring:message code="job"/>",
                    jobGroup: "<spring:message code="job.group"/>",
                    post: "<spring:message code="post"/>",
                    postGroup: "<spring:message code="post.group"/>",
                    postGrade: "<spring:message code="post.grade"/>",
                    postGradeGroup: "<spring:message code="post.grade.group"/>"
                },
                changed: function (form, item, value) {

                }
            },
            {
                name: "objectId",
                title: "",
                required: true,
            },
            {
                name: "competenceId",
                title: "<spring:message code='competence'/>",
                required: true,
                optionDataSource: CompetenceDS_needsAssessment,
                valueField: "id", displayField: "title",
                pickListFields: [{name: "title"}, {name: "competenceType.title"},],
            },
            {
                name: "skillId",
                title: "<spring:message code='skill'/>",
                required: true,
                optionDataSource: SkillDS_needsAssessment,
                valueField: "id", displayField: "titleFa",
                pickListFields: [{name: "titleFa"},],
            },
            {
                name: "needsAssessmentDomainId",
                title: "<spring:message code='domain'/>",
                required: true,
                optionDataSource: NeedsAssessmentDomainDS_competence,
                valueField: "id", displayField: "title",
                pickListFields: [{name: "title"},],
            },
            {
                name: "needsAssessmentPriorityId",
                title: "<spring:message code='priority'/>",
                required: true,
                optionDataSource: NeedsAssessmentPriorityDS_competence,
                valueField: "id", displayField: "title",
                pickListFields: [{name: "title"},],
            },
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
        NeedsAssessmentWin_needsAssessment.setTitle("<spring:message code="create"/>&nbsp;" + "<spring:message code="needs.assessment"/>");
        NeedsAssessmentWin_needsAssessment.show();
    }

    function editNeedsAssessment_needsAssessment() {
        let record = NeedsAssessmentLG_needsAssessment.getSelectedRecord();
        if (checkRecordAsSelected(record, true, "<spring:message code="needs.assessment"/>")) {
            needsAssessmentMethod_needsAssessment = "PUT";
            NeedsAssessmentDF_needsAssessment.clearValues();
            NeedsAssessmentDF_needsAssessment.editRecord(record);
            NeedsAssessmentWin_needsAssessment.setTitle("<spring:message code="edit"/>&nbsp;" + "<spring:message code="needs.assessment"/>");
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
            TrDSRequest(needsAssessmentSaveUrl, needsAssessmentMethod_needsAssessment, JSON.stringify(data), "callback: studyResponse(rpcResponse, '" + action + "','<spring:message code="needs.assessment"/>', NeedsAssessmentWin_needsAssessment, NeedsAssessmentLG_needsAssessment)")
        );
    }

    function removeNeedsAssessment_needsAssessment() {
        let record = NeedsAssessmentLG_needsAssessment.getSelectedRecord();
        var entityType = '<spring:message code="needs.assessment"/>';
        if (checkRecordAsSelected(record, true, entityType)) {
            removeRecord(needsAssessmentUrl + "/" + record.id, entityType, record.title, 'NeedsAssessmentLG_needsAssessment');
        }
    }