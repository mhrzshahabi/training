<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>
    changed: function (form, item, value) {

    }
    {
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

        JobLG_needsAssessment = isc.TrLG.create({
            ID: "JobLG_needsAssessment",
            dataSource: JobDs_needsAssessment,
            fields: [{name: "code"}, {name: "titleFa"}],
        });

        // JobGroup
        JobGroupDs_needsAssessment = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            ],
            fetchDataURL: jobGroupUrl + "spec-list"
        });

        JobGroupLG_needsAssessment = isc.TrLG.create({
            ID: "JobGroupLG_needsAssessment",
            dataSource: JobGroupDs_needsAssessment,
            fields: [{name: "titleFa"}],
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

        PostLG_needsAssessment = isc.TrLG.create({
            ID: "PostLG_needsAssessment",
            dataSource: PostDs_needsAssessment,
            fields: [
                {name: "code"}, {name: "titleFa"}, {name: "job.titleFa"}, {name: "postGrade.titleFa"}, {name: "area"}, {name: "assistance"},
                {name: "affairs"}, {name: "section"}, {name: "unit"}, {name: "costCenterCode"}, {name: "costCenterTitleFa"},
            ],
        });

        // PostGroup
        PostGroupDs_needsAssessment = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            ],
            fetchDataURL: postGroupUrl + "/spec-list"
        });

        PostGroupLG_needsAssessment = isc.TrLG.create({
            ID: "PostGroupLG_needsAssessment",
            dataSource: PostGroupDs_needsAssessment,
            fields: [{name: "titleFa"}],
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

        PostGradeLG_needsAssessment = isc.TrLG.create({
            ID: "PostGradeLG_needsAssessment",
            dataSource: PostGradeDs_needsAssessment,
            fields: [{name: "code"}, {name: "titleFa"}],
        });

        // PostGradeGroup
        PostGradeGroupDs_needsAssessment = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {name: "titleFa", title: "<spring:message code='title'/>", filterOperator: "iContains"},
            ],
            fetchDataURL: postGradeGroupUrl + "spec-list"
        });

        PostGradeGroupLG_needsAssessment = isc.TrLG.create({
            ID: "PostGradeGroupLG_needsAssessment",
            dataSource: PostGradeGroupDs_needsAssessment,
            fields: [{name: "titleFa"}],
        });
    }

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
    SelectedCompetenceDS_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
        ],
    });

    SelectedCompetenceLG_needsAssessment = isc.TrLG.create({
        ID: "SelectedCompetenceLG_needsAssessment",
        dataSource: SelectedCompetenceDS_needsAssessment,
        showRowNumbers: false,
        fields: [{name: "title"},],
        gridComponents: [
            "filterEditor", "header", "body"
        ],
        width: "16%",
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
        dataSource: KnowledgeSkillDS_needsAssessment,
        showRowNumbers: false,
        fields: [{name: "titleFa"}, {name: "needsAssessmentPriority.title"}],
        gridComponents: [
            "filterEditor", "header", "body"
        ],
        width: "28%",
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
        width: "28%",
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
        width: "28%",
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [
            isc.Label.create({ID: "ObjectTypeLabel_needsAssessment", width: "20%", customEdges: []}),
            isc.Label.create({ID: "ObjectLabel_needsAssessment", width: "80%", customEdges: []}),
            ]
    });
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
                    },
                    {
                        name: "objectId",
                        showTitle: false,
                        optionDataSource: JobDs_needsAssessment,
                        valueField: "id", displayField: "titleFa",
                        pickListFields: [{name: "code"}, {name: "titleFa"}],
                    },
                ]
            }),

            isc.TrHLayout.create({
                members: [

                    isc.TrVLayout.create({
                        width: "20%",
                        members: [
                            isc.LgLabel.create({width: "100%", customEdges: []}),
                            CompetenceLG_needsAssessment,
                            SkillLG_needsAssessment
                        ],
                    }),
                    isc.TrVLayout.create({
                        members: [
                            isc.TrHLayout.create({
                                members: [
                                    isc.LgLabel.create({width: "16%", customEdges: []}),
                                    isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="domain"/>" + "</b></span>", width: "84%", customEdges: ["T", "R", "L"]}),
                                ],
                                height: "1%",
                            }),
                            isc.TrHLayout.create({
                                members: [
                                    isc.LgLabel.create({width: "16%", customEdges: []}),
                                    isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="domain"/>" + "</b></span>", width: "84%", customEdges: ["T", "R", "L"]}),
                                ],
                                height: "1%",
                            }),
                            isc.TrHLayout.create({
                                members: [
                                    isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="competence"/>" + "</b></span>", width: "16%", customEdges: ["T", "B"]}),
                                    isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="knowledge"/>" + "</b></span>", width: "28%",}),
                                    isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="ability"/>" + "</b></span>", width: "28%", customEdges: ["T", "B"]}),
                                    isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="attitude"/>" + "</b></span>", width: "28%",}),
                                ],
                                height: "1%",
                            }),
                            isc.TrHLayout.create({
                                members: [
                                    SelectedCompetenceLG_needsAssessment,
                                    KnowledgeSkillLG_needsAssessment,
                                    AbilitySkillLG_needsAssessment,
                                    AttitudeSkillLG_needsAssessment
                                ],
                            }),
                        ]
                    }),
                ]
            })
        ]
    });

    ParameterLG_parameter = isc.TrLG.create({
        ID: "ParameterLG_parameter",
        dataSource: ParameterDS_parameter,
        autoFetchData: true,
        fields: [{name: "title"}, {name: "code"}, {name: "type"}, {name: "description"},],
        gridComponents: [
            ParameterTS_parameter, "filterEditor", "header", "body"
        ],
        contextMenu: ParameterMenu_parameter,
        dataChanged: function () { updateCountLabel(this, ParameterLGCountLabel_parameter)},
        recordDoubleClick: function () { editParameter_parameter(); },
        selectionUpdated: function (record) { refreshParameterValueLG_parameter(); }
    });

    // ------------------------------------------- DynamicForm & Window -------------------------------------------
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
            },
            {
                name: "objectId",
                showTitle: false,
                optionDataSource: JobDs_needsAssessment,
                valueField: "id", displayField: "titleFa",
                pickListFields: [{name: "code"}, {name: "titleFa"}],
            },
            // {
            //     name: "objectType",
            //     showTitle: false,
            //     colWidths: "20%",
            //     required: true,
            //     defaultToFirstOption: true,
            //     changed: function (form, item, value) {
            //         alert('1');
            //         // form.getItem("objectId").clearValue();
            //         // switch (value) {
            //         //     case 'Job':
            //         //         form.getItem("objectId").optionDataSource = JobDS_needsAssessment;
            //         //         break;
            //         //     case 'JobGroup':
            //         //         form.getItem("objectId").optionDataSource = JobGroupDS_needsAssessment;
            //         //         break;
            //         //     case 'Post':
            //         //         form.getItem("objectId").optionDataSource = PostDS_needsAssessment;
            //         //         break;
            //         // }
            //         // form.getItem("objectId").valueField = "id";
            //         // form.getItem("objectId").displayField = "titleFa";
            //     }
            // },
            // {
            //     name: "objectId",
            //     showTitle: false,
            //     colWidths: "60%",
            //     required: true,
            //     editorType: "SelectItem",
            //     pickListFields: [{name: "titleFa"},]
            // },
        ]
    });

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




    CompetenceDS_needsAssessment = isc.TrDS.create({
        ID: "CompetenceDS_needsAssessment",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceType.title", title: "<spring:message code="type"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: competenceUrl + "/iscList",
    });

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

    //
    // let needsAssessmentMethod_needsAssessment;


    NeedsAssessmentLG_needsAssessment = isc.TrLG.create({
        ID: "NeedsAssessmentLG_needsAssessment",
        border: "1px solid",
        fields: [{name: "competence.title"}, {name: "kn_skill.titleFa"}, {name: "kn_needsAssessmentPriority.title"},
            {name: "ab_skill.titleFa"}, {name: "ab_needsAssessmentPriority.title"}, {name: "at_skill.titleFa"}, {name: "at_needsAssessmentPriority.title"},],
        showRowNumbers: false,
        canRemoveRecords: true,
        showHeader: false,
        gridComponents: [
            isc.TrHLayout.create({
                members: [
                    isc.LgLabel.create({width: "16%", customEdges: []}),
                    isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="domain"/>" + "</b></span>", width: "84%", customEdges: ["R"]}),
                ],
                height: "1%",
            }),
            isc.TrHLayout.create({
                members: [
                    isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="competence"/>" + "</b></span>", width: "16%", customEdges: ["T", "B"]}),
                    isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="knowledge"/>" + "</b></span>", width: "28%",}),
                    isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="ability"/>" + "</b></span>", width: "28%", customEdges: ["T", "B"]}),
                    isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="attitude"/>" + "</b></span>", width: "28%",}),
                ],
                height: "1%",
            }),
            isc.TrHLayout.create({
                members: [
                    SelectedCompetenceLG_needsAssessment,
                    SelectedSkillLG_needsAssessment,
                ],
            }),
            "filterEditor", "header", "body",
        ],

        canAcceptDroppedRecords: true,
        recordDrop(dropRecords, targetRecord, index, sourceWidget) {
            // console.log(dropRecords);
            // console.log(targetRecord);
            // console.log(index);
            // console.log(sourceWidget);
            // console.log(this.getData());

            switch (sourceWidget.ID) {
                case 'CompetenceLG_needsAssessment':
                    for (i = 0; i < dropRecords.length; i++)
                        this.addData({'competence.title': dropRecords[i].title});
                    break;
                case 'SkillLG_needsAssessment':
                    var record = this.getSelectedRecord();
                    if (checkRecordAsSelected(record, true, "<spring:message code="competence"/>")) {
                        var competenceTitle = record["competence.title"];
                        this.removeData(record);
                        for (i = 0; i < dropRecords.length; i++)
                            this.addData({'competence.title': competenceTitle, 'skill.titleFa': dropRecords[i].titleFa});
                        // record["skill.titleFa"] = dropRecords[0].titleFa
                        // this.updateData()
                        // console.log(record);
                        // record.set('skill.titleFa': dropRecords[0].titleFa)
                        // this.addData({'competence.title': record["competence.title"], 'skill.titleFa': dropRecords[0].titleFa});
                    }
                    break;
            }

            // var postGradeGroupId = ListGrid_Post_Grade_Group_Jsp.getSelectedRecord().id;
            // var postGradeIds = [];
            // for (var i = 0; i < dropRecords.getLength(); i++) {
            //     postGradeIds.add(dropRecords[i].id);
            // }
            // isc.RPCManager.sendRequest(TrDSRequest(postGradeGroupUrl + "removePostGrades/" + postGradeGroupId + "/" + postGradeIds,
            //     "DELETE", null, "callback: allPostGrade_remove_result(rpcResponse)"));
        }
    });


    // ------------------------------------------- TabSet -------------------------------------------

    NeedsAssessmentTargetTabs_needsAssessment = isc.TabSet.create({
        ID: "NeedsAssessmentTargetTabs_needsAssessment",
        height: "30%",
        tabs: [
            {title: "<spring:message code="job"/>", pane: JobLG_needsAssessment,},
            {title: "<spring:message code="job.group"/>", pane: JobGroupLG_needsAssessment,},
            {title: "<spring:message code="post"/>", pane: PostLG_needsAssessment,},
            {title: "<spring:message code="post.group"/>", pane: PostGroupLG_needsAssessment,},
            {title: "<spring:message code="post.grade"/>", pane: PostGradeLG_needsAssessment,},
            {title: "<spring:message code="post.grade.group"/>", pane: PostGradeGroupLG_needsAssessment,},
        ],
        tabSelected: function (tabNum, tabPane, ID, tab, name) {
            tabPane.fetchData();
        },
        showResizeBar: true,
    });

    NeedsAssessmentDS_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "competence.title", dataPath: "competence", title: "<spring:message code="competence"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "kn_skill.titleFa", title: "<spring:message code="skill"/>", filterOperator: "iContains",},
            {name: "kn_needsAssessmentPriority.title", title: "<spring:message code="priority"/>", filterOperator: "iContains",},
            {name: "ab_skill.titleFa", title: "<spring:message code="skill"/>", filterOperator: "iContains",},
            {name: "ab_needsAssessmentPriority.title", title: "<spring:message code="priority"/>", filterOperator: "iContains",},
            {name: "at_skill.titleFa", title: "<spring:message code="skill"/>", filterOperator: "iContains",},
            {name: "at_needsAssessmentPriority.title", title: "<spring:message code="priority"/>", filterOperator: "iContains",},
        ],
    });



    console.log('dropRecords:');
    console.log(dropRecords);
    console.log('targetRecord:');
    console.log(targetRecord);
    console.log('index:');
    console.log(index);
    console.log('sourceWidget:');
    console.log(sourceWidget);
    console.log('thid.data:');
    console.log(this.getData());




    switch (sourceWidget.ID) {
        case 'SkillLG_needsAssessment':

            if (checkRecordAsSelected(record, true, "<spring:message code="competence"/>")) {
                for (i = 0; i < dropRecords.length; i++)
                    this.addData({'id': dropRecords[i].id, 'titleFa': dropRecords[i].titleFa});
                // var competenceTitle = record["competence.title"];
                // this.removeData(record);
                // for (i = 0; i < dropRecords.length; i++)
                //     this.addData({'competence.title': competenceTitle, 'skill.titleFa': dropRecords[i].titleFa});
                // record["skill.titleFa"] = dropRecords[0].titleFa
                // this.updateData()
                // console.log(record);
                // record.set('skill.titleFa': dropRecords[0].titleFa)
                // this.addData({'competence.title': record["competence.title"], 'skill.titleFa': dropRecords[0].titleFa});
            }

            // for (i = 0; i < dropRecords.length; i++)
            //     this.addData({'id': dropRecords[i].id, 'title': dropRecords[i].title});
            break;
    }
    console.log(this.getData());