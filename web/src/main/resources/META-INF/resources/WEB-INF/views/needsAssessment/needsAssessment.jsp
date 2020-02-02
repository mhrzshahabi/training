<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    var localIdSequence = 1;

    // ------------------------------------------- ToolStrip -------------------------------------------
    CompetenceTS_needsAssessment = isc.ToolStrip.create({
        members: [
            isc.ToolStripButtonRefresh.create({title: "", click: function () { refreshLG(CompetenceLG_needsAssessment); }}),
            isc.ToolStripButtonCreate.create({title: "", click: function () { }}),
        ]
    });

    SkillTS_needsAssessment = isc.ToolStrip.create({
        members: [
            isc.ToolStripButtonRefresh.create({title: "", click: function () { refreshLG(SkillLG_needsAssessment); }}),
            isc.ToolStripButtonCreate.create({title: "", click: function () { }}),
        ]
    });

    NeedsAssessmentTS_needsAssessment = isc.ToolStrip.create({
        members: [
            isc.ToolStripButtonRefresh.create({title: "", click: function () { }}),
            isc.ToolStripButtonCreate.create({title: "", click: function () { }}),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------

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

    // NeedsAssessmentTarget
    NeedsAssessmentTargetDS_needsAssessment = isc.TrDS.create({
        ID: "NeedsAssessmentTargetDS_needsAssessment",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
            {name: "code", title: "<spring:message code="code"/>", required: true, filterOperator: "iContains"},
        ],
        fetchDataURL: parameterValueUrl + "/iscList/103",
    });

    // Competence
    CompetenceDS_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceType.title", title: "<spring:message code="type"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: competenceUrl + "/iscList"
    });

    CompetenceLG_needsAssessment = isc.TrLG.create({
        ID: "CompetenceLG_needsAssessment",
        dataSource: CompetenceDS_needsAssessment,
        fields: [{name: "title"}, {name: "competenceType.title"},],
        autoFetchData: true,
        showRowNumbers: false,
        border: "1px solid",
        gridComponents: [
            isc.TrHLayout.create({
                height: "1%",
                members: [
                    CompetenceTS_needsAssessment,
                    isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="competence.list"/>" + "</b></span>", showEdges: false, width: "100%"}),
                ]
            }),
            , "filterEditor", "header", "body"
        ],
        canDragRecordsOut: true,
    });

    // Skill
    SkillDS_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains",},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "category.titleFa", title: "<spring:message code="category"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "subCategory.titleFa", title: "<spring:message code="subcategory"/>", filterOperator: "iContains"},
            {name: "skillLevel.titleFa", title: "<spring:message code="skill.level"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: skillUrl + "/spec-list"
    });

    SkillLG_needsAssessment = isc.TrLG.create({
        ID: "SkillLG_needsAssessment",
        dataSource: SkillDS_needsAssessment,
        fields: [{name: "titleFa"}, {name: "category.titleFa"}, {name: "subCategory.titleFa"}],
        autoFetchData: true,
        showRowNumbers: false,
        border: "1px solid",
        gridComponents: [
            isc.TrHLayout.create({
                height: "1%",
                members: [
                    SkillTS_needsAssessment,
                    isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="skills.list"/>" + "</b></span>", showEdges: false, width: "100%"}),
                ]
            }),
            , "filterEditor", "header", "body"
        ],
        canDragRecordsOut: true,
        canHover: true,
        showHoverComponents: true,
        hoverMode: "details",
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

    // NeedsAssessment
    NeedsAssesmentDS_needsAssessment = isc.TrDS.create({
        ID: "NeedsAssesmentDS_needsAssessment",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "competence.id", hidden: true},
            {name: "competence.title", title: "<spring:message code="competence"/>", filterOperator: "iContains", hidden: true},
            {name: "skill.id", hidden: true},
            {name: "skill.titleFa", title: "<spring:message code="skill"/>", filterOperator: "iContains"},
            {name: "needsAssessmentDomain.id", title: "<spring:message code="domain"/>", filterOperator: "iContains"},
            {name: "needsAssessmentDomain.title", title: "<spring:message code="domain"/>", filterOperator: "iContains"},
            {name: "needsAssessmentPriority.id", title: "<spring:message code="domain"/>", filterOperator: "iContains"},
            {name: "needsAssessmentPriority.title", title: "<spring:message code="priority"/>", filterOperator: "iContains"},
        ],
        clientOnly: true,
    });

    NeedsAssesmentLG_needsAssessment = isc.TrLG.create({
        ID: "NeedsAssesmentLG_needsAssessment",
        dataSource: NeedsAssesmentDS_needsAssessment,
        fields: [
            {name: "competence.title"}, ,
            {name: "skill.titleFa"},
            {name: "needsAssessmentDomain.title", optionDataSource: NeedsAssessmentDomainDS_needsAssessment, valueField: "id", displayField: "title", canEdit: true,},
            {name: "needsAssessmentPriority.title", optionDataSource: NeedsAssessmentPriorityDS_needsAssessment, valueField: "id", displayField: "title", canEdit: true,}
        ],
        gridComponents: [
            isc.TrHLayout.create({
                height: "1%",
                members: [
                    NeedsAssessmentTS_needsAssessment,
                    isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="needs.assessment"/>" + "</b></span>", showEdges: false, width: "100%"}),
                ]
            }),
            , "filterEditor", "header", "body",
            isc.TrHLayoutButtons.create({
                members: [
                    isc.IButtonSave.create({click: function () { NeedsAssesmentLG_needsAssessment.saveAllEdits(); }}),
                    isc.IButtonCancel.create({click: function () { NeedsAssessmentWin_needsAssessment.close(); }}),
                ]
            }),
        ],
        showRowNumbers: false,
        canAcceptDroppedRecords: true,
        sortField: 1,
        groupByField: "competence.title",
        groupStartOpen: "all",
        recordDrop(dropRecords, targetRecord, index, sourceWidget) {
            if (sourceWidget.ID === 'CompetenceLG_needsAssessment') {
                for (i = 0; i < dropRecords.length; i++) {
                    this.addData({'id': localIdSequence++, competence: {'id': dropRecords[i].id, 'title': dropRecords[i].title},});
                }
            } else if (sourceWidget.ID === 'SkillLG_needsAssessment') {
                targetRecord = this.getSelectedRecord();
                if (checkRecordAsSelected(targetRecord, true, "<spring:message code="competence"/>")) {
                    for (i = 0; i < dropRecords.length; i++) {
                        if (targetRecord.skill == undefined) {
                            targetRecord.skill = {'id': dropRecords[i].id, 'titleFa': dropRecords[i].titleFa};
                            this.updateData(targetRecord);
                        } else {
                            var record = targetRecord;
                            record.id = localIdSequence++;
                            record.skill = {"id": dropRecords[i].id, "titleFa": dropRecords[i].titleFa};
                            this.addData(record);
                        }
                    }
                }
            }
            refreshLG(NeedsAssesmentLG_needsAssessment);
        },
        modalEditing: true,
        autoSaveEdits: false,
        saveAllEdits: function(rows) {
            console.log(this.getAllEditRows());
            alert('save changes');
            var objectId = NeedsAssessmentTargetDF_needsAssessment.getItem('objectId').getValue();
            console.log('objectId');
            console.log(objectId);
            if (objectId !== undefined) {
                var objectType = NeedsAssessmentTargetDF_needsAssessment.getItem('objectType').getValue();
                this.Super("saveAllEdits",arguments);
            }
        }
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
                        textAlign: "center",
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
                            if (value !== null && value !== undefined) {
                                refreshNeedsAssesmentLG_needsAssessment();
                            }
                        },
                    },
                ]
            }),
            isc.TrHLayout.create({
                border: "1px solid",
                members: [
                    isc.TrVLayout.create({
                        width: "20%",
                        showResizeBar: true,
                        members: [CompetenceLG_needsAssessment, SkillLG_needsAssessment],
                    }),
                    isc.TrVLayout.create({
                        width: "80%",
                        showResizeBar: true,
                        members: [NeedsAssesmentLG_needsAssessment],
                    }),
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

    function refreshNeedsAssesmentLG_needsAssessment() {
        var objectId = NeedsAssessmentTargetDF_needsAssessment.getItem('objectId').getValue();
        console.log('objectId');
        console.log(objectId);

        if (objectId !== undefined) {
            var objectType = NeedsAssessmentTargetDF_needsAssessment.getItem('objectType').getValue();
            console.log('objectType');
            console.log(objectType);
            NeedsAssesmentDS_needsAssessment.addData(isc.RPCManager.sendRequest(
                TrDSRequest(needsAssessmentUrl + "/iscList/" + objectType + "/" + objectId, "GET", null)
            ));

            // NeedsAssesmentDS_needsAssessment.dataURL = needsAssessmentUrl + "/iscList/" + objectType + "/" + objectId;
            NeedsAssesmentDS_needsAssessment.fetchData(null);

        }
    }

