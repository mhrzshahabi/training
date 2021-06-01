<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    var temp;
    var editing = false;
    var RestDataSource_NeedsAssessmentPriority_JspNeedsAssessment = isc.TrDS.create({
        fields:[
            {name: "id", primaryKey:true},
            {name:"code"},
            {name:"title"}
        ],
        fetchDataURL: parameterValueUrl + "/iscList?operator=and&_constructor=AdvancedCriteria&criteria={\"fieldName\":\"parameter.code\",\"operator\":\"equals\",\"value\":\"NeedsAssessmentPriority\"}"
    })
    var RestDataSource_Competence_JspNeedsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceType.title", title: "<spring:message code="type"/>", filterOperator: "iContains",},
        ],
        fetchDataURL: competenceUrl + "/iscList",
    });
    var ListGrid_AllCompetence_JspNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_AllCompetence_JspNeedsAssessment",
        dataSource: RestDataSource_Competence_JspNeedsAssessment,
        selectionType: "single",
        selectionAppearance: "checkbox",
        filterOnKeypress: true,
        canDragRecordsOut: true,
        dragDataAction: "none",
        canAcceptDroppedRecords: true,
        fields: [
            {name: "title", title: "<spring:message code="title"/>"}, {name: "competenceType.title", title: "<spring:message code="type"/>"}
        ],
        gridComponents: ["filterEditor", "header", "body"],
        // selectionUpdated: "ListGrid_Competence_JspNeedsAssessment.setData(this.getSelection())"
        selectionChanged(record, state) {
            if (state == true) {
                if (checkSaveData(record, DataSource_Competence_JspNeedsAssessment, "id")) {
                    ListGrid_Competence_JspNeedsAssessment.transferSelectedData(this);
                    return;
                }
                createDialog("info", "<spring:message code="exception.duplicate.information"/>", "<spring:message code="error"/>");
            }
        }
    });
    var DataSource_Competence_JspNeedsAssessment = isc.DataSource.create({
        clientOnly: true,
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceType.title", title: "<spring:message code="type"/>", filterOperator: "iContains",},
        ],
        // fetchDataURL: competenceUrl + "/iscList",
    });
    var Window_AddCompetence = isc.Window.create({
        title: "<spring:message code="skill.plural.list"/>",
        width: "40%",
        height: "50%",
        keepInParentRect: true,
        isModal: false,
        autoSize: false,
        items: [
            isc.TrHLayout.create({
                members: [
                    ListGrid_AllCompetence_JspNeedsAssessment
                ]
            })]
    })

    // ------------------------------------------- ToolStrip -------------------------------------------
    CompetenceTS_needsAssessment = isc.ToolStrip.create({
        ID: "CompetenceTS_needsAssessment",
        members: [
            isc.ToolStripButtonRefresh.create({
                click: function () { refreshLG(ListGrid_Competence_JspNeedsAssessment); }
            }),
            isc.ToolStripButtonAdd.create({
                title:"افزودن",
                click: function () {
                    if(NeedsAssessmentTargetDF_needsAssessment.getValue("objectId")!=null) {
                        ListGrid_AllCompetence_JspNeedsAssessment.fetchData();
                        ListGrid_AllCompetence_JspNeedsAssessment.invalidateCache();
                        Window_AddCompetence.show();
                    }
                    else {
                        createDialog("info","<spring:message code='msg.no.records.selected'/>");
                    }
                }
            }),
            // isc.ToolStripButtonCreate.create({click: function () { createCompetence_competence(); }}),
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


    var ListGrid_Competence_JspNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_Competence_JspNeedsAssessment",
        dataSource: DataSource_Competence_JspNeedsAssessment,
        autoFetchData: true,
        selectionType:"single",

        // selectionAppearance: "checkbox",
        showRowNumbers: false,
        border: "1px solid",
        fields: [{name: "title", title: "<spring:message code="title"/>"}, {name: "competenceType.title", title: "<spring:message code="type"/>"},],
        gridComponents: [
            isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="competence.list"/>" + "</b></span>", customEdges: ["B"]}),
            CompetenceTS_needsAssessment, "header", "body"
        ],
        canRemoveRecords:true,
        canDragRecordsOut: true,
        dragDataAction: "none",
        removeRecordClick(rowNum){
            this.Super("removeRecordClick", arguments);
        },
        dataChanged(){
            editing = true;
            this.Super("dataChanged",arguments);
        },
        selectionUpdated(record){
            fetchDataDomainsGrid();
        }
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
        // selectionAppearance: "checkbox",
        showRowNumbers: false,
        selectionType:"single",
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
    // SelectedListGrid_Competence_JspNeedsAssessment = isc.TrLG.create({
    //     ID: "SelectedListGrid_Competence_JspNeedsAssessment",
    //     showRowNumbers: false,
    //     fields: [{name: "id", hidden: true, primaryKey: true}, {name: "title"},],
    //     showHeader: false,
    //     selectionType:"single",
    //     preventDuplicates: true,
    //     canAcceptDroppedRecords: true,
    //     recordDrop(dropRecords, targetRecord, index, sourceWidget) {
    //         if (sourceWidget.ID === 'ListGrid_Competence_JspNeedsAssessment') {
    //             for (i = 0; i < dropRecords.length; i++)
    //                 this.addData({'id': dropRecords[i].id, 'title': dropRecords[i].title});
    //         }
    //     },
    //     selectionUpdated(record, recordList){
    //
    //     },
    // });

    // Selected  Skill - Knowledge
    var KnowledgeSkillDS_needsAssessment = isc.DataSource.create({
        ID: "KnowledgeSkillDS_needsAssessment",
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "needsAssessmentPriorityId", title: "<spring:message code="priority"/>", filterOperator: "iContains"},
            {name: "needsAssessmentDomainId", title: "<spring:message code="priority"/>", filterOperator: "iContains"},
            {name: "skillId", primaryKey: true, title: "<spring:message code="priority"/>", filterOperator: "iContains"},
            {name: "competenceId", title: "<spring:message code="priority"/>", filterOperator: "iContains"},
            {name: "objectId", title: "<spring:message code="priority"/>", filterOperator: "iContains"},
            {name: "objectType", title: "<spring:message code="priority"/>", filterOperator: "iContains"},
        ],
        clientOnly: true,
    });
    <%--var AbilitySkillDS_needsAssessment = isc.DataSource.create({--%>
        <%--ID: "AbilitySkillDS_needsAssessment",--%>
        <%--fields: [--%>
            <%--{name: "id", primaryKey: true, hidden: true},--%>
            <%--{name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},--%>
            <%--{name: "needsAssessmentPriority", title: "<spring:message code="priority"/>", filterOperator: "iContains"},--%>
        <%--],--%>
        <%--clientOnly: true,--%>
    <%--});--%>
    <%--var AttitudeSkillDS_needsAssessment = isc.DataSource.create({--%>
        <%--ID: "AttitudeSkillDS_needsAssessment",--%>
        <%--fields: [--%>
            <%--{name: "id", primaryKey: true, hidden: true},--%>
            <%--{name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},--%>
            <%--{name: "needsAssessmentPriority", title: "<spring:message code="priority"/>", filterOperator: "iContains"},--%>
        <%--],--%>
        <%--clientOnly: true,--%>
    <%--});--%>

    var ListGrid_Knowledge_JspNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_Knowledge_JspNeedsAssessment",
        autoFetchData:false,
        dataSource: KnowledgeSkillDS_needsAssessment,
        showRowNumbers: false,
        selectionType:"single",
        implicitCriteria:{"needsAssessmentDomainId":108},
        fields: [
            {name: "titleFa"},
            {
                name: "needsAssessmentPriorityId",
                canEdit:true,
                valueField: "id",
                displayField: "title",
                optionDataSource: RestDataSource_NeedsAssessmentPriority_JspNeedsAssessment,
                // modalEditing: true,
            }
        ],
        gridComponents: [
            "filterEditor", "header", "body"
        ],
        width: "25%",
        canAcceptDroppedRecords: true,
        canHover: true,
        showHoverComponents: true,
        hoverMode: "details",
        canRemoveRecords:true,
        showFilterEditor:false,
        recordDrop(dropRecords, targetRecord, index, sourceWidget) {
            let record = ListGrid_Competence_JspNeedsAssessment.getSelectedRecord();
            if (checkRecordAsSelected(record, true, "<spring:message code="competence"/>")) {
                if (sourceWidget.ID === 'SkillLG_needsAssessment') {
                    for (let i = 0; i < dropRecords.length; i++) {
                        let data = {
                            objectType: NeedsAssessmentTargetDF_needsAssessment.getValue("objectType"),
                            objectId: NeedsAssessmentTargetDF_needsAssessment.getValue("objectId"),
                            competenceId: ListGrid_Competence_JspNeedsAssessment.getSelectedRecord().id,
                            skillId: dropRecords[i].id,
                            titleFa: dropRecords[i].titleFa,
                            needsAssessmentPriorityId: 111,
                            needsAssessmentDomainId:108
                        };
                        createNeedsAssessmentRecords(data);
                        // fetchDataDomainsGrid();
                        // this.fetchData();
                    }
                }
            }
        },
        dataChanged(){
            editing = true;
            this.Super("dataChanged",arguments);
        }
    });

    // Selected  Skill - Ability


    var ListGrid_Ability_JspNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_Ability_JspNeedsAssessment",
        dataSource: KnowledgeSkillDS_needsAssessment,
        autoFetchData:false,
        showRowNumbers: false,
        selectionType:"single",
        fields: [
            {name: "titleFa"},
            {
                name: "needsAssessmentPriorityId",
                canEdit:true,
                valueField: "id",
                displayField: "title",
                optionDataSource: RestDataSource_NeedsAssessmentPriority_JspNeedsAssessment,
            }
        ],
        gridComponents: [
            "filterEditor", "header", "body"
        ],
        width: "25%",
        canAcceptDroppedRecords: true,
        canHover: true,
        showHoverComponents: true,
        hoverMode: "details",
        canRemoveRecords:true,
        showFilterEditor:false,
        implicitCriteria:{"needsAssessmentDomainId":109},
        recordDrop(dropRecords, targetRecord, index, sourceWidget) {
            let record = ListGrid_Competence_JspNeedsAssessment.getSelectedRecord();
            if (checkRecordAsSelected(record, true, "<spring:message code="competence"/>")) {
                if (sourceWidget.ID === 'SkillLG_needsAssessment') {
                    for (let i = 0; i < dropRecords.length; i++) {
                        let data = {
                            objectType: NeedsAssessmentTargetDF_needsAssessment.getValue("objectType"),
                            objectId: NeedsAssessmentTargetDF_needsAssessment.getValue("objectId"),
                            competenceId: ListGrid_Competence_JspNeedsAssessment.getSelectedRecord().id,
                            skillId: dropRecords[i].id,
                            titleFa: dropRecords[i].titleFa,
                            needsAssessmentPriorityId: 111,
                            needsAssessmentDomainId:109
                        };
                        // KnowledgeSkillDS_needsAssessment.addData(data);
                        createNeedsAssessmentRecords(data);
                        // this.fetchData();
                        // fetchDataDomainsGrid();
                    }
                }
            }
        },
        dataChanged(){
            editing = true;
            this.Super("dataChanged",arguments);
        }
    });

    // Selected  Skill - Attitude


    var ListGrid_Attitude_JspNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_Attitude_JspNeedsAssessment",
        dataSource: KnowledgeSkillDS_needsAssessment,
        showRowNumbers: false,
        autoFetchData:false,
        selectionType:"single",
        fields: [
            {name: "titleFa"},
            {
                name: "needsAssessmentPriorityId",
                canEdit:true,
                valueField: "id",
                displayField: "title",
                optionDataSource: RestDataSource_NeedsAssessmentPriority_JspNeedsAssessment,
            }
        ],
        gridComponents: [
            "filterEditor", "header", "body"
        ],
        width: "25%",
        canAcceptDroppedRecords: true,
        canHover: true,
        showHoverComponents: true,
        hoverMode: "details",
        canRemoveRecords:true,
        showFilterEditor:false,
        implicitCriteria:{"needsAssessmentDomainId":110},
        recordDrop(dropRecords, targetRecord, index, sourceWidget) {
            let record = ListGrid_Competence_JspNeedsAssessment.getSelectedRecord();
            if (checkRecordAsSelected(record, true, "<spring:message code="competence"/>")) {
                if (sourceWidget.ID === 'SkillLG_needsAssessment') {
                    for (let i = 0; i < dropRecords.length; i++) {
                        let data = {
                            objectType: NeedsAssessmentTargetDF_needsAssessment.getValue("objectType"),
                            objectId: NeedsAssessmentTargetDF_needsAssessment.getValue("objectId"),
                            competenceId: ListGrid_Competence_JspNeedsAssessment.getSelectedRecord().id,
                            skillId: dropRecords[i].id,
                            titleFa: dropRecords[i].titleFa,
                            needsAssessmentPriorityId: 111,
                            needsAssessmentDomainId:110
                        };
                        // KnowledgeSkillDS_needsAssessment.addData(data);
                        createNeedsAssessmentRecords(data);
                        // this.fetchData();
                        // fetchDataDomainsGrid()
                    }
                }
            }
        },
        dataChanged(){
            editing = true;
            this.Super("dataChanged",arguments);
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
                        pickListFields: [{name: "title"}],
                        defaultToFirstOption: true,
                        changed: function (form, item, value) {
                            ListGrid_Competence_JspNeedsAssessment.setData([]);
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
                        width: "25%",
                        members: [ListGrid_Competence_JspNeedsAssessment, SkillLG_needsAssessment]
                    }),
                    <%--isc.TrVLayout.create({--%>
                        <%--width: "10%",--%>
                        <%--members: [--%>
                            <%--isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="competence"/>" + "</b></span>"}),--%>
                            <%--SelectedListGrid_Competence_JspNeedsAssessment--%>
                        <%--]--%>
                    <%--}),--%>
                    ListGrid_Knowledge_JspNeedsAssessment,
                    ListGrid_Ability_JspNeedsAssessment,
                    ListGrid_Attitude_JspNeedsAssessment

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

    function createNeedsAssessmentRecords(data) {
        // fetchDataDomainsGrid();
        if(!checkSaveData(data, KnowledgeSkillDS_needsAssessment)){
            createDialog("info", "<spring:message code="exception.duplicate.information"/>", "<spring:message code="error"/>");
            return;
        }
        isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl, "POST", JSON.stringify(data),function(resp){
            if (resp.httpResponseCode != 200){
                createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                return;
            }
            KnowledgeSkillDS_needsAssessment.addData(data);
            fetchDataDomainsGrid();
        }))
    }

    function fetchDataDomainsGrid(){
        let record = ListGrid_Competence_JspNeedsAssessment.getSelectedRecord();
        if(record != null) {
            ListGrid_Knowledge_JspNeedsAssessment.fetchData({"competenceId":record.id});
            ListGrid_Knowledge_JspNeedsAssessment.invalidateCache();

            ListGrid_Ability_JspNeedsAssessment.fetchData({"competenceId":record.id});
            ListGrid_Ability_JspNeedsAssessment.invalidateCache();

            ListGrid_Attitude_JspNeedsAssessment.fetchData({"competenceId":record.id});
            ListGrid_Attitude_JspNeedsAssessment.invalidateCache();

        }
    }

    function checkSaveData(data, dataSource, field = "skillId", objectType = null) {
        if(!objectType) {
            if(dataSource.testData.find(f => f[field] === data[field]) != null) {
                return false;
            }
            return true;
        }
        else{
            if(dataSource.testData.find(f => f[field] === data[field] && f["objectType"] === data["objectType"]) != null){
                return false;
            }
            return true;
        }
    }