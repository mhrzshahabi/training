<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    var editing = false;
    var skillData = [];
    var competenceData = [];
    var RestDataSourceNeedsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "objectType", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competence.title", title: "<spring:message code="type"/>", filterOperator: "iContains"},
            {name: "competence.competenceType.title", title: "<spring:message code="type"/>", filterOperator: "iContains"},
            {name: "skill.titleFa", title: "<spring:message code="type"/>", filterOperator: "iContains"},
            {name: "needsAssessmentDomain.title", title: "<spring:message code="type"/>", filterOperator: "iContains"},
            {name: "needsAssessmentPriority.title", title: "<spring:message code="type"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: needsAssessmentUrl + "/iscList",
    });
    var ToolStrip_NeedsAssessment_JspNeedAssessment = isc.ToolStrip.create({
        members: [
            isc.ToolStripButtonAdd.create({
                click(){
                    NeedsAssessmentTargetDF_needsAssessment.clearValues()
                    Window_NeedsAssessment_JspNeedsAssessment.show()
                }
            }),
            isc.ToolStripButtonEdit.create({
                click() {
                    editNeedsAssessmentRecord(ListGrid_NeedsAssessment_JspNeedAssessment.getSelectedRecord().objectId,ListGrid_NeedsAssessment_JspNeedAssessment.getSelectedRecord().objectType);
                    Window_NeedsAssessment_JspNeedsAssessment.show()
                }
            })
        ]
    });
    var ListGrid_NeedsAssessment_JspNeedAssessment = isc.TrLG.create({
        autoFetchData: true,
        fields:[
            {name: "objectType", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competence.title", title: "<spring:message code="type"/>", filterOperator: "iContains"},
            {name: "competence.competenceType.title", title: "<spring:message code="type"/>", filterOperator: "iContains"},
            {name: "skill.titleFa", title: "<spring:message code="type"/>", filterOperator: "iContains"},
            {name: "needsAssessmentDomain.title", title: "<spring:message code="type"/>", filterOperator: "iContains"},
            {name: "needsAssessmentPriority.title", title: "<spring:message code="type"/>", filterOperator: "iContains"},
        ],
        dataSource: RestDataSourceNeedsAssessment,
        gridComponents: [ToolStrip_NeedsAssessment_JspNeedAssessment, "filterEditor", "header", "body"]
    });


    //----------------------components of window--------------------------

    NeedsAssessmentTargetDS_needsAssessment = isc.TrDS.create({
        ID: "NeedsAssessmentTargetDS_needsAssessment",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
            {name: "code", title: "<spring:message code="code"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: parameterValueUrl + "/iscList/103",
    });
    JobDs_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: jobUrl + "/iscList"
    });
    JobGroupDs_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: jobGroupUrl + "spec-list"
    });
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
    PostGroupDs_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: postGroupUrl + "/spec-list"
    });
    PostGradeDs_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: postGradeUrl + "/iscList"
    });
    PostGradeGroupDs_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code='title'/>", filterOperator: "iContains"},
        ],
        fetchDataURL: postGradeGroupUrl + "spec-list"
    });
    var RestDataSource_Skill_JspNeedsAssessment = isc.TrDS.create({
        ID: "RestDataSource_Skill_JspNeedsAssessment",
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

    var DataSource_Competence_JspNeedsAssessment = isc.DataSource.create({
        clientOnly: true,
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceType.title", title: "<spring:message code="type"/>", filterOperator: "iContains",},
        ],
        testData: competenceData,
        // fetchDataURL: competenceUrl + "/iscList",
    });
    var DataSource_Skill_JspNeedsAssessment = isc.DataSource.create({
        ID: "DataSource_Skill_JspNeedsAssessment",
        fields: [
            {name: "id"},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "needsAssessmentPriorityId", title: "<spring:message code="priority"/>", filterOperator: "iContains"},
            {name: "needsAssessmentDomainId", title: "<spring:message code="priority"/>", filterOperator: "iContains"},
            {name: "skillId", primaryKey: true, title: "<spring:message code="priority"/>", filterOperator: "iContains"},
            {name: "competenceId", title: "<spring:message code="priority"/>", filterOperator: "iContains"},
            {name: "objectId", title: "<spring:message code="priority"/>", filterOperator: "iContains"},
            {name: "objectType", title: "<spring:message code="priority"/>", filterOperator: "iContains"},
        ],
        testData: skillData,
        clientOnly: true,
    });

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
            let data = ListGrid_Knowledge_JspNeedsAssessment.data.localData.toArray();
            data.addAll(ListGrid_Attitude_JspNeedsAssessment.data.localData.toArray());
            data.addAll(ListGrid_Ability_JspNeedsAssessment.data.localData.toArray());
            for (let i = 0; i < data.length; i++) {
                if(removeRecord_JspNeedsAssessment(data[i])){
                    return;
                }
                DataSource_Competence_JspNeedsAssessment.removeData(this.getRecord(rowNum));
            }
        },
        dataChanged(){
            editing = true;
            this.Super("dataChanged",arguments);
        },
        selectionUpdated(record){
            fetchDataDomainsGrid();
        }
    });
    var ListGrid_SkillAll_JspNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_SkillAll_JspNeedsAssessment",
        dataSource: RestDataSource_Skill_JspNeedsAssessment,
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
    var ListGrid_Knowledge_JspNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_Knowledge_JspNeedsAssessment",
        autoFetchData:false,
        dataSource: DataSource_Skill_JspNeedsAssessment,
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
                // valueMap:["عملکرد ضروری","عملکرد توسعه ای","عملکرد بهبود"]
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
        removeRecordClick(rowNum){
            removeRecord_JspNeedsAssessment(this.getRecord(rowNum));
        },
        recordDrop(dropRecords, targetRecord, index, sourceWidget) {
            let record = ListGrid_Competence_JspNeedsAssessment.getSelectedRecord();
            if (checkRecordAsSelected(record, true, "<spring:message code="competence"/>")) {
                if (sourceWidget.ID === 'ListGrid_SkillAll_JspNeedsAssessment') {
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
    var ListGrid_Ability_JspNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_Ability_JspNeedsAssessment",
        dataSource: DataSource_Skill_JspNeedsAssessment,
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
        removeRecordClick(rowNum){
            removeRecord_JspNeedsAssessment(this.getRecord(rowNum));
        },
        recordDrop(dropRecords, targetRecord, index, sourceWidget) {
            let record = ListGrid_Competence_JspNeedsAssessment.getSelectedRecord();
            if (checkRecordAsSelected(record, true, "<spring:message code="competence"/>")) {
                if (sourceWidget.ID === 'ListGrid_SkillAll_JspNeedsAssessment') {
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
                        // DataSource_Skill_JspNeedsAssessment.addData(data);
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
    var ListGrid_Attitude_JspNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_Attitude_JspNeedsAssessment",
        dataSource: DataSource_Skill_JspNeedsAssessment,
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
        removeRecordClick(rowNum){
            removeRecord_JspNeedsAssessment(this.getRecord(rowNum));
        },
        recordDrop(dropRecords, targetRecord, index, sourceWidget) {
            let record = ListGrid_Competence_JspNeedsAssessment.getSelectedRecord();
            if (checkRecordAsSelected(record, true, "<spring:message code="competence"/>")) {
                if (sourceWidget.ID === 'ListGrid_SkillAll_JspNeedsAssessment') {
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
                        // DataSource_Skill_JspNeedsAssessment.addData(data);
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

    //--------------------------------------------------------------------

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
    var Window_NeedsAssessment_JspNeedsAssessment = isc.Window.create({
        title: "<spring:message code="needs.assessment"/>",
        minWidth: 1024,
        keepInParentRect: true,
        placement:"fillPanel",
        close(){
          clearAllGrid();
          this.Super("close",arguments)
        },
        items:[
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
                        changed: function (form, item, value, oldValue) {
                            if(value != oldValue) {
                                clearAllGrid()
                                form.getItem("objectId").clearValue();
                                updateObjectIdLG(form, value);
                            }
                        },
                    },
                    {
                        name: "objectId",
                        showTitle: false,
                        optionDataSource: JobDs_needsAssessment,
                        valueField: "id", displayField: "titleFa",
                        pickListFields: [{name: "code"}, {name: "titleFa"}],
                        changed: function (form, item, value, oldValue) {
                            if(value != oldValue){
                                editNeedsAssessmentRecord(NeedsAssessmentTargetDF_needsAssessment.getValue("objectId"), NeedsAssessmentTargetDF_needsAssessment.getValue("objectType"))
                            }
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
                        members: [ListGrid_Competence_JspNeedsAssessment, ListGrid_SkillAll_JspNeedsAssessment]
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

    isc.TrVLayout.create({
        members: [ListGrid_NeedsAssessment_JspNeedAssessment],
    });

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
        if(!checkSaveData(data, DataSource_Skill_JspNeedsAssessment)){
            createDialog("info", "<spring:message code="exception.duplicate.information"/>", "<spring:message code="error"/>");
            return;
        }
        isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl, "POST", JSON.stringify(data),function(resp){
            if (resp.httpResponseCode != 200){
                createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                return;
            }
            data.id = JSON.parse(resp.data).id
            DataSource_Skill_JspNeedsAssessment.addData(data);
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

    function editNeedsAssessmentRecord(objectId, objectType) {
        // let criteria = [
        //     '{"fieldName":"objectType","operator":"equals","value":"'+objectType+'"}',
        //     '{"fieldName":"objectId","operator":"equals","value":'+objectId+'}'
        // ];
        updateObjectIdLG(NeedsAssessmentTargetDF_needsAssessment, objectType)
        clearAllGrid();
        isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/editList/" + objectType + "/" + objectId, "GET", null, function(resp){
            if (resp.httpResponseCode != 200){
                createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                return;
            }
            let data = JSON.parse(resp.data).list;
            let flags  = [];
            for (let i = 0; i < data.length; i++) {
                let skill = {};
                let competence = {};
                skill.id = data[i].id;
                skill.titleFa = data[i].skill.titleFa;
                skill.needsAssessmentPriorityId = data[i].needsAssessmentPriorityId;
                skill.needsAssessmentDomainId = data[i].needsAssessmentDomainId;
                skill.skillId = data[i].skillId;
                skill.competenceId = data[i].competenceId;
                skill.objectId = data[i].objectId;
                skill.objectType = data[i].objectType;
                DataSource_Skill_JspNeedsAssessment.addData(skill);
                if( flags[data[i].competenceId]) continue;
                flags[data[i].competenceId] = true;
                // outPut.push(data[i].competenceId);
                competence.id = data[i].competenceId;
                competence.title = data[i].competence.title;
                competence.competenceType = data[i].competence.competenceType;
                DataSource_Competence_JspNeedsAssessment.addData(competence);
            }
            ListGrid_Competence_JspNeedsAssessment.fetchData();
            NeedsAssessmentTargetDF_needsAssessment.setValue("objectId", objectId);
            NeedsAssessmentTargetDF_needsAssessment.setValue("objectType", objectType);
            fetchDataDomainsGrid();
        }))
    }

    function clearAllGrid() {
        competenceData.length = 0;
        skillData.length = 0;
        ListGrid_Competence_JspNeedsAssessment.setData([]);
        ListGrid_Knowledge_JspNeedsAssessment.setData([]);
        ListGrid_Attitude_JspNeedsAssessment.setData([]);
        ListGrid_Ability_JspNeedsAssessment.setData([]);
    }

    function removeRecord_JspNeedsAssessment(record) {
        isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/" + record.id, "DELETE", null,function(resp){
            if(resp.httpResponseCode != 200){
                return true;
            }
            DataSource_Skill_JspNeedsAssessment.removeData(record);
            // return false;
        }));
    }
