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
            {name: "objectType", title: "<spring:message code="type"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceId", hidden: true},
            {name: "competence.title", title: "<spring:message code="competence"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
            {name: "skillId", hidden: true},
            {name: "skill.titleFa", title: "<spring:message code="skill"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
            {name: "needsAssessmentDomainId", hidden: true},
            {name: "needsAssessmentDomain.title", title: "<spring:message code="domain"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
            {name: "needsAssessmentPriorityId", hidden: true},
            {name: "needsAssessmentPriority.title", title: "<spring:message code="priority"/>", required: true, filterOperator: "iContains"},
        ],
        fetchDataURL: needsAssessmentUrl + "/iscList",
    });

    NeedsAssessmentLG_needsAssessment = isc.TrLG.create({
        ID: "NeedsAssessmentLG_needsAssessment",
        dataSource: NeedsAssessmentDS_needsAssessment,
        autoFetchData: true,
        fields: [{name: "objectType"}, {name: "competence.title"}, {name: "skill.titleFa"}, {name: "needsAssessmentDomain.title"}, {name: "needsAssessmentPriority.title"},],
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

    NeedsAssessmentDomainDS_needsAssessment = isc.TrDS.create({
        ID: "NeedsAssessmentDomainDS_needsAssessment",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: parameterValueUrl + "/iscList/101",
    });

    NeedsAssessmentPriorityDS_needsAssessment = isc.TrDS.create({
        ID: "NeedsAssessmentPriorityDS_needsAssessment",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: parameterValueUrl + "/iscList/102",
    });

    JobDS_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: jobUrl + "/iscList"
    });

    JobGroupDS_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: jobGroupUrl + "spec-list"
    });

    PostDS_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "job.titleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postGrade.titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: postUrl + "/iscList"
    });

    // ------------------------------------------- DynamicForm & Window -------------------------------------------
    NeedsAssessmentDF_needsAssessment = isc.DynamicForm.create({
        ID: "NeedsAssessmentDF_needsAssessment",
        fields: [
            {name: "id", hidden: true},
            {
                name: "objectType",
                title: "<spring:message code='type'/>",
                required: true,
                valueMap: {
                    Job: "<spring:message code="job"/>",
                    JobGroup: "<spring:message code="job.group"/>",
                    Post: "<spring:message code="post"/>",
                    PostGroup: "<spring:message code="post.group"/>",
                    PostGrade: "<spring:message code="post.grade"/>",
                    PostGradeGroup: "<spring:message code="post.grade.group"/>"
                },
                changed: function (form, item, value) {
                    form.getItem("objectId").clearValue();
                    switch (value) {
                        case 'Job':
                            form.getItem("objectId").optionDataSource = JobDS_needsAssessment;
                            break;
                        case 'JobGroup':
                            form.getItem("objectId").optionDataSource = JobGroupDS_needsAssessment;
                            break;
                        case 'Post':
                            form.getItem("objectId").optionDataSource = PostDS_needsAssessment;
                            break;
                    }
                    form.getItem("objectId").valueField = "id";
                    form.getItem("objectId").displayField = "titleFa";
                }
            },
            {
                name: "objectId",
                title: "",
                required: true,
                editorType: "SelectItem",
                pickListFields: [{name: "titleFa"},]
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
                optionDataSource: NeedsAssessmentDomainDS_needsAssessment,
                valueField: "id", displayField: "title",
                pickListFields: [{name: "title"},],
            },
            {
                name: "needsAssessmentPriorityId",
                title: "<spring:message code='priority'/>",
                required: true,
                optionDataSource: NeedsAssessmentPriorityDS_needsAssessment,
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