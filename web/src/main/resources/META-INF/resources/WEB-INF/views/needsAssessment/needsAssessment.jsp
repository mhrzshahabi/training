<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    var temp;

    // ------------------------------------------- ToolStrip -------------------------------------------
    CompetenceTS_needsAssessment = isc.ToolStrip.create({
        ID: "CompetenceTS_needsAssessment",
        members: [
            isc.ToolStripButtonRefresh.create({click: function () { refreshLG(CompetenceLG_needsAssessment); }}),
            isc.ToolStripButtonCreate.create({click: function () { createCompetence_competence(); }}),
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "CompetenceLGCount_needsAssessment"}),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------

    // NeedsAssessmentTarget
    NeedsAssessmentTargetDS_needsAssessment = isc.TrDS.create({
        ID: "NeedsAssessmentTargetDS_needsAssessment",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
            {name: "code", title: "<spring:message code="code"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: parameterValueUrl + "/iscList/103",
    });

    // Job
    JobDs_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: jobUrl + "/iscList"
    });

    // JobGroup
    JobGroupDs_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: jobGroupUrl + "spec-list"
    });

    // Post
    PostDs_needsAssessment = isc.TrDS.create({
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

    // PostGroup
    PostGroupDs_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: postGroupUrl + "/spec-list"
    });

    // PostGrade
    PostGradeDs_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: postGradeUrl + "/iscList"
    });

    // PostGradeGroup
    PostGradeGroupDs_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code='title'/>", filterOperator: "iContains"},
        ],
        fetchDataURL: postGradeGroupUrl + "spec-list"
    });

    // Competence
    CompetenceDS_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceType.title", title: "<spring:message code="type"/>", filterOperator: "iContains",},
        ],
        fetchDataURL: competenceUrl + "/iscList",
    });

    CompetenceLG_needsAssessment = isc.TrLG.create({
        ID: "CompetenceLG_needsAssessment",
        dataSource: CompetenceDS_needsAssessment,
        autoFetchData: true,
        selectionAppearance: "checkbox",
        showRowNumbers: false,
        border: "1px solid",
        fields: [{name: "title"}, {name: "competenceType.title"},],
        gridComponents: [
            isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="competence.list"/>" + "</b></span>", customEdges: ["B"]}),
            CompetenceTS_needsAssessment, "filterEditor", "header", "body"
        ],
        canDragRecordsOut: true,
        dragDataAction: "none",
    });

    // Skill
    SkillDS_needsAssessment = isc.TrDS.create({
        ID: "SkillDS_needsAssessment",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "category.titleFa", title: "<spring:message code="category"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "subCategory.titleFa", title: "<spring:message code="subcategory"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "skillLevel.titleFa", title: "<spring:message code="skill.level"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: skillUrl + "/spec-list"
    });

    SkillLG_needsAssessment = isc.TrLG.create({
        ID: "SkillLG_needsAssessment",
        dataSource: SkillDS_needsAssessment,
        autoFetchData: true,
        selectionAppearance: "checkbox",
        showRowNumbers: false,
        border: "1px solid",
        fields: [{name: "titleFa"}, {name: "category.titleFa"}, {name: "subCategory.titleFa"},],
        gridComponents: [
            isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="skills.list"/>" + "</b></span>", customEdges: ["B"]}),
            "filterEditor", "header", "body"
        ],
        canHover: true,
        showHoverComponents: true,
        hoverMode: "details",
        canDragRecordsOut: true,
    });

    // Selected Competence
    SelectedCompetenceLG_needsAssessment = isc.TrLG.create({
        ID: "SelectedCompetenceLG_needsAssessment",
        showRowNumbers: false,
        fields: [{name: "id", hidden: true}, {name: "title"},],
        showHeader: false,
        preventDuplicates: true,
        canAcceptDroppedRecords: true,
        recordDrop(dropRecords, targetRecord, index, sourceWidget) {
            if (sourceWidget.ID === 'CompetenceLG_needsAssessment') {
                for (i = 0; i < dropRecords.length; i++)
                    this.addData({'id': dropRecords[i].id, 'title': dropRecords[i].title});
            }
        }
    });

    // Selected  Skill - Knowledge
    KnowledgeSkillDS_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "needsAssessmentPriority.title", title: "<spring:message code="priority"/>", filterOperator: "iContains"},
        ],
    });

    KnowledgeSkillLG_needsAssessment = isc.TrLG.create({
        ID: "KnowledgeSkillLG_needsAssessment",
        // dataSource: KnowledgeSkillDS_needsAssessment,
        showRowNumbers: false,
        fields: [{name: "titleFa"}, {name: "needsAssessmentPriority.title"}],
        gridComponents: [
            "filterEditor", "header", "body"
        ],
        width: "25%",
        canAcceptDroppedRecords: true,
        recordDrop(dropRecords, targetRecord, index, sourceWidget) {
            var record = SelectedCompetenceLG_needsAssessment.getSelectedRecord();
            if (checkRecordAsSelected(record, true, "<spring:message code="competence"/>")) {
                if (sourceWidget.ID === 'SkillLG_needsAssessment') {
                    for (i = 0; i < dropRecords.length; i++)
                        this.addData({'id': dropRecords[i].id, 'titleFa': dropRecords[i].titleFa, 'needsAssessmentPriority.title': 'عملکردی ضروری'});
                }
            }
        }
    });

    // Selected  Skill - Ability
    AbilitySkillDS_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "needsAssessmentPriority.title", title: "<spring:message code="priority"/>", filterOperator: "iContains"},
        ],
    });

    AbilitySkillLG_needsAssessment = isc.TrLG.create({
        ID: "AbilitySkillDS_needsAssessment",
        dataSource: AbilitySkillDS_needsAssessment,
        showRowNumbers: false,
        fields: [{name: "titleFa"}, {name: "needsAssessmentPriority.title"}],
        gridComponents: [
            "filterEditor", "header", "body"
        ],
        width: "25%",
    });

    // Selected  Skill - Attitude
    AttitudeSkillDS_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "needsAssessmentPriority.title", title: "<spring:message code="priority"/>", filterOperator: "iContains"},
        ],
    });

    AttitudeSkillLG_needsAssessment = isc.TrLG.create({
        ID: "AttitudeSkillDS_needsAssessment",
        dataSource: AttitudeSkillDS_needsAssessment,
        showRowNumbers: false,
        fields: [{name: "titleFa"}, {name: "needsAssessmentPriority.title"}],
        gridComponents: [
            "filterEditor", "header", "body"
        ],
        width: "25%",
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [
            isc.DynamicForm.create({
                ID: "NeedsAssessmentTargetDF_needsAssessment",
                numCols: 2,
                fields: [
                    {
                        name: "objectType",
                        showTitle: false,
                        optionDataSource: NeedsAssessmentTargetDS_needsAssessment,
                        valueField: "code", displayField: "title",
                        pickListFields: [{name: "title"}],
                        defaultToFirstOption: true,
                        changed: function (form, item, value) {
                            form.getItem("objectId").clearValue();
                            updateObjectIdLG(form, value);
                        },
                    },
                    {
                        name: "objectId",
                        showTitle: false,
                        optionDataSource: JobDs_needsAssessment,
                        valueField: "id", displayField: "titleFa",
                        pickListFields: [{name: "code"}, {name: "titleFa"}],
                        changed: function (form, item, value) {
                        },
                    },
                ]
            }),
            isc.TrHLayout.create({
                height: "1%",
                members: [
                    isc.LgLabel.create({width: "25%", customEdges: []}),
                    isc.LgLabel.create({width: "75%", contents: "<span><b>" + "<spring:message code="domain"/>" + "</b></span>", customEdges: ["T", "R", "L"]}),
                ]
            }),
            isc.TrHLayout.create({
                height: "1%",
                members: [
                    isc.LgLabel.create({width: "25%", customEdges: []}),
                    isc.LgLabel.create({width: "25%", contents: "<span><b>" + "<spring:message code="knowledge"/>" + "</b></span>"}),
                    isc.LgLabel.create({width: "25%", contents: "<span><b>" + "<spring:message code="ability"/>" + "</b></span>", customEdges: ["T", "B"]}),
                    isc.LgLabel.create({width: "25%", contents: "<span><b>" + "<spring:message code="attitude"/>" + "</b></span>"}),
                ]
            }),
            isc.TrHLayout.create({
                members: [
                    isc.TrVLayout.create({
                        width: "15%",
                        members: [CompetenceLG_needsAssessment, SkillLG_needsAssessment]
                    }),
                    isc.TrVLayout.create({
                        width: "10%",
                        members: [
                            isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="competence"/>" + "</b></span>"}),
                            SelectedCompetenceLG_needsAssessment
                        ]
                    }),
                    KnowledgeSkillLG_needsAssessment,
                    AbilitySkillLG_needsAssessment,
                    AttitudeSkillLG_needsAssessment

                ]
            }),
        ]
    });

    // ------------------------------------------- Functions -------------------------------------------
    function updateObjectIdLG(form, value) {
        switch (value) {
            case 'Job':
                form.getItem("objectId").optionDataSource = JobDs_needsAssessment;
                form.getItem("objectId").pickListFields = [{name: "code"}, {name: "titleFa"}];
                break;
            case 'JobGroup':
                form.getItem("objectId").optionDataSource = JobGroupDs_needsAssessment;
                form.getItem("objectId").pickListFields = [{name: "titleFa"}];
                break;
            case 'Post':
                form.getItem("objectId").optionDataSource = PostDs_needsAssessment;
                form.getItem("objectId").pickListFields = [
                    {name: "code"}, {name: "titleFa"}, {name: "job.titleFa"}, {name: "postGrade.titleFa"}, {name: "area"}, {name: "assistance"}, {name: "affairs"},
                    {name: "section"}, {name: "unit"}, {name: "costCenterCode"}, {name: "costCenterTitleFa"}
                ];
                break;
            case 'PostGroup':
                form.getItem("objectId").optionDataSource = PostGroupDs_needsAssessment;
                form.getItem("objectId").pickListFields = [{name: "titleFa"}];
                break;
            case 'PostGrade':
                form.getItem("objectId").optionDataSource = PostGradeDs_needsAssessment;
                form.getItem("objectId").pickListFields = [{name: "code"}, {name: "titleFa"}];
                break;
            case 'PostGradeGroup':
                form.getItem("objectId").optionDataSource = PostGradeGroupDs_needsAssessment;
                form.getItem("objectId").pickListFields = [{name: "titleFa"}];
                break;
        }
    }