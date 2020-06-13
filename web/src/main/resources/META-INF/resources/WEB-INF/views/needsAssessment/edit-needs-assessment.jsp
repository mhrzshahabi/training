<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>

    // var view_ENA = null;
    var editing = false;
    var priorityList = {
        "Post": "پست",
        "PostGroup": "گروه پستی",
        "Job": "شغل",
        "JobGroup": "گروه شغلی",
        "PostGrade": "رده پستی",
        "PostGradeGroup": "گروه رده پستی",
    };
    var skillData = [];
    var competenceData = [];

    let NeedsAssessmentTargetDS_needsAssessment = isc.TrDS.create({
        ID: "NeedsAssessmentTargetDS_needsAssessment",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
            {name: "code", title: "<spring:message code="code"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: parameterValueUrl + "/iscList/103",

    });
    let JobDs_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: jobUrl + "/spec-list"
    });
    let JobGroupDs_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: jobGroupUrl + "iscList"
    });
    let PostDs_needsAssessment = isc.TrDS.create({
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
        fetchDataURL: postUrl + "/spec-list"
    });
    let PostGroupDs_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: postGroupUrl + "/spec-list"
    });
    let PostGradeDs_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: postGradeUrl + "/iscList"
    });
    let PostGradeGroupDs_needsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code='title'/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: postGradeGroupUrl + "spec-list"
    });
    var RestDataSource_Skill_JspNeedsAssessment = isc.TrDS.create({
        ID: "RestDataSource_Skill_JspNeedsAssessment",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true},
            {name: "category.titleFa", title: "<spring:message code="category"/>", filterOperator: "iContains"},
            {name: "subCategory.titleFa", title: "<spring:message code="subcategory"/>", filterOperator: "iContains"},
            {name: "skillLevel.titleFa", title: "<spring:message code="skill.level"/>", filterOperator: "iContains"},
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
    });
    var RestDataSource_Competence_JspNeedsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceType.title", title: "<spring:message code="type"/>", filterOperator: "iContains",},
        ],
        fetchDataURL: competenceUrl + "/iscList",
    });
    let RestDataSource_Personnel_JspNeedsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true, width: "*"},
            {name: "employmentStatus", title: "<spring:message code="employment.status"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "complexTitle", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "workPlaceTitle", title: "<spring:message code="work.place"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "workTurnTitle", title: "<spring:message code="work.turn"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpAffairs", title: "<spring:message code="reward.cost.center.affairs"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: personnelUrl + "/iscList"
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
            {name: "id", hidden:true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "needsAssessmentPriorityId", title: "<spring:message code="priority"/>", filterOperator: "iContains", autoFitWidth:true},
            {name: "needsAssessmentDomainId", filterOperator: "iContains", hidden:true},
            {name: "skillId", primaryKey: true, filterOperator: "iContains", hidden:true},
            {name: "competenceId", filterOperator: "iContains", hidden:true},
            {name: "objectId", filterOperator: "iContains", hidden:true},
            {name: "objectType", title: "<spring:message code="reference"/>", primaryKey: true, filterOperator: "iContains", valueMap: priorityList, autoFitWidth:true,
                showHover:true,
                canEdit: false,
                hoverHTML(record) {
                    return "نام: " + record.objectName + "<br>" + "کد:" + record.objectCode;
                },
            },
            {name: "objectName"},
            {name: "objectCode"}
        ],
        testData: skillData,
        clientOnly: true,
    });

    let CompetenceTS_needsAssessment = isc.ToolStrip.create({
        ID: "CompetenceTS_needsAssessment",
        members: [
            // isc.ToolStripButtonRefresh.create({
            //     click: function () { refreshLG(ListGrid_Competence_JspNeedsAssessment); }
            // }),
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

    var Label_PlusData_JspNeedsAssessment = isc.LgLabel.create({
        align:"left",
        contents:"",
        customEdges: []});
    var Label_Help_JspNeedsAssessment = isc.LgLabel.create({
        align:"left",
        contents:"<span>.اولویت ضروری با رنگ قرمز، اولویت بهبود با رنگ زرد و اولویت توسعه با رنگ سبز مشخص شده اند<span/>",
        contents:"اولویت ضروری با رنگ " + getFormulaMessage("قرمز", "2", "#ff8abc")+"، اواویت بهبود با رنگ "+getFormulaMessage("زرد", "2", "#fff669")+" و اولویت توسعه با رنگ "+getFormulaMessage("سبز", "2", "#61ff55")+" مشخص شده است.",
        customEdges: []});

    var ListGrid_AllCompetence_JspNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_AllCompetence_JspNeedsAssessment",
        dataSource: RestDataSource_Competence_JspNeedsAssessment,
        showHeaderContextMenu: false,
        selectionType: "single",
        selectionAppearance: "checkbox",
        filterOnKeypress: true,
        canDragRecordsOut: true,
        dragDataAction: "none",
        canAcceptDroppedRecords: true,
        fields: [
            {name: "title", title: "<spring:message code="title"/>"},
            {name: "competenceType.title", title: "<spring:message code="type"/>"}
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
        showHeaderContextMenu: false,
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
            }
            DataSource_Competence_JspNeedsAssessment.removeData(this.getRecord(rowNum));
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
        // showRowNumbers: false,
        // showHeaderContextMenu: false,
        selectionType:"single",
        fields: [
            {name: "code"},
            {name: "titleFa"},
            {name: "category.titleFa"},
            {name: "subCategory.titleFa"},
            {name: "skillLevel.titleFa"}
        ],
        gridComponents: [
            isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="skills.list"/>" + "</b></span>", customEdges: ["B"]}),
            "filterEditor", "header", "body"
        ],
        // canHover: true,
        // showHoverComponents: true,
        // hoverMode: "details",
        canDragRecordsOut: true,
        dataArrived:function(){
            setTimeout(function(){ $("tbody tr td:nth-child(1)").css({direction:'ltr'});},300);
        },
        rowHover: function(){
            changeDirection(1);
        },
        rowOver:function(){
            changeDirection(1);
        },
        rowClick:function(){
            changeDirection(1);
        },
        doubleClick: function () {
            changeDirection(1);
        }
    });
    var ListGrid_Knowledge_JspNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_Knowledge_JspNeedsAssessment",
        autoFetchData:false,
        dataSource: DataSource_Skill_JspNeedsAssessment,
        showRowNumbers: false,
        selectionType:"single",
        autoSaveEdits:false,
        implicitCriteria:{"needsAssessmentDomainId":108},
        fields: [
            {name: "titleFa"},
            {name: "objectType"},

            // {
            //     name: "needsAssessmentPriorityId",
            //     canEdit:true,
            //     valueField: "id",
            //     displayField: "title",
            //     optionDataSource: RestDataSource_NeedsAssessmentPriority_JspNeedsAssessment,
            //     change(form, item){
            //         updateSkillRecord(form, item)
            //     }
            //     // modalEditing: true,
            //     // valueMap:["عملکرد ضروری","عملکرد توسعه ای","عملکرد بهبود"]
            // }
        ],
        headerSpans: [
            {
                fields: ["titleFa", "objectType"],
                title: "<spring:message code="knowledge"/>"
            }],
        headerHeight: 50,
        gridComponents: [
            "filterEditor", "header", "body"
        ],
        // width: "25%",
        canAcceptDroppedRecords: true,
        // canHover: true,
        showHoverComponents: true,
        // hoverMode: "detailField",
        canRemoveRecords:true,
        showHeaderContextMenu: false,
        showFilterEditor:false,
        removeRecordClick(rowNum){
            removeRecord_JspNeedsAssessment(this.getRecord(rowNum));
        },
        recordDrop(dropRecords, targetRecord, index, sourceWidget) {
            let record = ListGrid_Competence_JspNeedsAssessment.getSelectedRecord();
            if (checkRecordAsSelected(record, true, "<spring:message code="competence"/>")) {
                if (sourceWidget.ID === 'ListGrid_SkillAll_JspNeedsAssessment') {
                    for (let i = 0; i < dropRecords.length; i++) {
                        createNeedsAssessmentRecords(createData_JspNeedsAssessment(dropRecords[i], 108));
                        // fetchDataDomainsGrid();
                        // this.fetchData();
                    }
                }
            }
        },
        dataChanged(){
            editing = true;
            this.Super("dataChanged",arguments);
        },
        // canEditCell(rowNum, colNum){
        //     if(colNum === 1) {
        //         let record = this.getRecord(rowNum);
        //         if (record.objectType === NeedsAssessmentTargetDF_needsAssessment.getValue("objectType")) {
        //             return true;
        //         }
        //     }
        //     return false;
        // },
        getCellCSSText(record) {
                switch (record.needsAssessmentPriorityId) {
                    case 111:
                        return "background-color : " + "#ff8abc";
                    case 112:
                        return "background-color : " + "#fff7bf";
                    case 113:
                        return "background-color : " + "#afffbe";
                }
        },
        recordDoubleClick(viewer, record){
            updatePriority_JspEditNeedsAssessment(viewer, record);
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
            {name: "objectType"},
            // {
            //     name: "needsAssessmentPriorityId",
            //     canEdit:true,
            //     valueField: "id",
            //     displayField: "title",
            //     optionDataSource: RestDataSource_NeedsAssessmentPriority_JspNeedsAssessment,
            //     change(form, item){
            //         updateSkillRecord(form, item)
            //     }
            // }
        ],
        headerSpans: [
            {
                fields: ["titleFa", "objectType"],
                title: "<spring:message code="ability"/>"
            }],
        headerHeight: 50,
        gridComponents: [
            "filterEditor", "header", "body"
        ],
        // width: "25%",
        showHeaderContextMenu: false,
        canAcceptDroppedRecords: true,
        // canHover: true,
        showHoverComponents: true,
        autoSaveEdits:false,
        // hoverMode: "details",
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
                        createNeedsAssessmentRecords(createData_JspNeedsAssessment(dropRecords[i], 109));
                        // DataSource_Skill_JspNeedsAssessment.addData(data);
                        // createNeedsAssessmentRecords(data);
                        // this.fetchData();
                        // fetchDataDomainsGrid();
                    }
                }
            }
        },
        dataChanged(){
            editing = true;
            this.Super("dataChanged",arguments);
        },
        // canEditCell(rowNum, colNum){
        //     if(colNum == 1) {
        //         let record = this.getRecord(rowNum);
        //         if (record.objectType == NeedsAssessmentTargetDF_needsAssessment.getValue("objectType")) {
        //             return true;
        //         }
        //     }
        //     return false;
        // },
        getCellCSSText: function (record) {
            switch (record.needsAssessmentPriorityId) {
                case 111:
                    return "background-color : " + "#ff8abc";
                case 112:
                    return "background-color : " + "#fff7bf";
                case 113:
                    return "background-color : " + "#afffbe";
            }
        },
        recordDoubleClick(viewer, record){
            updatePriority_JspEditNeedsAssessment(viewer, record);
        }
    });
    var ListGrid_Attitude_JspNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_Attitude_JspNeedsAssessment",
        dataSource: DataSource_Skill_JspNeedsAssessment,
        showHeaderContextMenu: false,
        showRowNumbers: false,
        autoFetchData:false,
        selectionType:"single",
        fields: [
            {name: "titleFa"},
            {name: "objectType"},
            // {
            //     name: "needsAssessmentPriorityId",
            //     canEdit:true,
            //     valueField: "id",
            //     displayField: "title",
            //     optionDataSource: RestDataSource_NeedsAssessmentPriority_JspNeedsAssessment,
            //     change(form, item){
            //         updateSkillRecord(form, item)
            //     }
            // }
        ],
        headerSpans: [
            {
                fields: ["titleFa", "objectType"],
                title: "<spring:message code="attitude"/>"
            }],
        headerHeight: 50,
        gridComponents: [
            "filterEditor", "header", "body"
        ],
        // width: "25%",
        canAcceptDroppedRecords: true,
        // canHover: true,
        autoSaveEdits:false,
        showHoverComponents: true,
        // hoverMode: "details",
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
                        createNeedsAssessmentRecords(createData_JspNeedsAssessment(dropRecords[i], 110));
                        // DataSource_Skill_JspNeedsAssessment.addData(data);
                        // createNeedsAssessmentRecords(data);
                        // this.fetchData();
                        // fetchDataDomainsGrid()
                    }
                }
            }
        },
        dataChanged(){
            editing = true;
            this.Super("dataChanged",arguments);
        },
        // canEditCell(rowNum, colNum){
        //     if(colNum == 1) {
        //         let record = this.getRecord(rowNum);
        //         if (record.objectType == NeedsAssessmentTargetDF_needsAssessment.getValue("objectType")) {
        //             return true;
        //         }
        //     }
        //     return false;
        // },
        getCellCSSText: function (record) {
            switch (record.needsAssessmentPriorityId) {
                case 111:
                    return "background-color : " + "#ff8abc";
                case 112:
                    return "background-color : " + "#fff7bf";
                case 113:
                    return "background-color : " + "#afffbe";
            }
        },
        recordDoubleClick(viewer, record){
            updatePriority_JspEditNeedsAssessment(viewer, record);
        }
    });
    let ListGrid_Personnel_JspNeedsAssessment = isc.TrLG.create({
        width: "100%",
        dataSource: RestDataSource_Personnel_JspNeedsAssessment,
        fields: [
            {name: "firstName"},
            {name: "lastName"},
            {name: "nationalCode"},
            {name: "personnelNo"},
            {name: "personnelNo2"},
            {name: "companyName"},
            {name: "ccpAffairs"},
            {name: "employmentStatus"},
            {name: "complexTitle"},
            {name: "workPlaceTitle"},
            {name: "workTurnTitle"},
        ],
        autoFetchData: false,
        gridComponents: [
            isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="personnel.for"/>" + "</b></span>", customEdges: ["T","L","R","B"]}),
            "header", "body"],
        // canExpandRecords: true,
        // expansionMode: "details",
        // showDetailFields: true
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
    });

    var NeedsAssessmentTargetDF_needsAssessment = isc.DynamicForm.create({
        ID: "NeedsAssessmentTargetDF_needsAssessment",
        numCols: 2,
        // readOnlyDisplay: "readOnly",
        fields: [
            {
                name: "objectType",
                showTitle: false,
                optionDataSource: NeedsAssessmentTargetDS_needsAssessment,
                valueField: "code",
                displayField: "title",
                defaultValue: "Job",
                autoFetchData: false,
                pickListFields: [{name: "title"}],
                defaultToFirstOption: true,
                changed: function (form, item, value, oldValue) {
                    if(value !== oldValue) {
                        updateObjectIdLG(form, value);
                        clearAllGrid();
                        form.getItem("objectId").clearValue();
                        Label_PlusData_JspNeedsAssessment.setContents("");
                        refreshPersonnelLG();
                    }
                },
            },
            {
                name: "objectId",
                showTitle: false,
                optionDataSource: JobDs_needsAssessment,
                editorType: "SelectItem",
                valueField: "id",
                displayField: "titleFa",
                autoFetchData: false,
                pickListFields: [
                    {name: "code"},
                    {name: "titleFa"}
                ],
                click: function(form, item){
                    item.fetchData();
                    // updateObjectIdLG(form, form.getValue("objectType"));
                    // if(form.getValue("objectType") === "Post"){
                        // PostDs_needsAssessment.fetchDataURL = postUrl + "/spec-list";
                        // Window_AddPost_JspNeedsAssessment.show();
                    // }
                },
                changed: function (form, item, value, oldValue) {
                    if(value !== oldValue){
                        editNeedsAssessmentRecord(NeedsAssessmentTargetDF_needsAssessment.getValue("objectId"), NeedsAssessmentTargetDF_needsAssessment.getValue("objectType"));
                        refreshPersonnelLG();
                        updateLabelEditNeedsAssessment(item.getSelectedRecord());
                    }
                },
            },
        ]
    });
    var HLayout_Label_PlusData_JspNeedsAssessment = isc.TrVLayout.create({
        height: "1%",
        members: [
            Label_Help_JspNeedsAssessment,
            Label_PlusData_JspNeedsAssessment,
        ]
    });
    var HLayout_Bottom = isc.TrHLayout.create({
            members: [
                isc.TrVLayout.create({
                    width: "25%",
                    showResizeBar: true,
                    members: [ListGrid_Competence_JspNeedsAssessment]
                }),
                isc.TrVLayout.create({
                    // width: "75%",
                    members: [
                        isc.TrHLayout.create({
                            height: "70%",
                            showResizeBar: true,
                            members: [
                                ListGrid_Knowledge_JspNeedsAssessment,
                                ListGrid_Ability_JspNeedsAssessment,
                                ListGrid_Attitude_JspNeedsAssessment
                            ]
                        }),
                        ListGrid_SkillAll_JspNeedsAssessment
                    ]
                }),
            ]
        });

    isc.TrVLayout.create({
        members: [NeedsAssessmentTargetDF_needsAssessment, HLayout_Label_PlusData_JspNeedsAssessment, HLayout_Bottom],
    });

    function updateObjectIdLG(form, value) {
        // form.getItem("objectId").canEdit = true;
        switch (value) {
            case 'Job':
                form.getItem("objectId").optionDataSource = JobDs_needsAssessment;
                form.getItem("objectId").pickListFields = [
                    {name: "code", title: "<spring:message code="code"/>", autoFitWidth: false},
                    {name: "titleFa", title: "<spring:message code="title"/>", autoFitWidth: false }
                ];
                break;
            case 'JobGroup':
                form.getItem("objectId").optionDataSource = JobGroupDs_needsAssessment;
                form.getItem("objectId").pickListFields = [{name: "titleFa", title: "<spring:message code="title"/>", autoFitWidth: false}, {name: "code", title: "<spring:message code="code"/>", autoFitWidth: false}];
                break;
            case 'Post':
                form.getItem("objectId").optionDataSource = PostDs_needsAssessment;
                form.getItem("objectId").pickListFields = [
                    {name: "code", keyPressFilter: false}, {name: "titleFa"}, {name: "job.titleFa"}, {name: "postGrade.titleFa"}, {name: "area"}, {name: "assistance"}, {name: "affairs"},
                    {name: "section"}, {name: "unit"}, {name: "costCenterCode"}, {name: "costCenterTitleFa"}
                ];
                // form.getItem("objectId").canEdit = false;
                // PostDs_needsAssessment.fetchDataURL = postUrl + "/spec-list";
                break;
            case 'PostGroup':
                form.getItem("objectId").optionDataSource = PostGroupDs_needsAssessment;
                form.getItem("objectId").pickListFields = [{name: "titleFa", title: "<spring:message code="title"/>", autoFitWidth: false}, {name: "code", title: "<spring:message code="code"/>", autoFitWidth: false}];
                break;
            case 'PostGrade':
                form.getItem("objectId").optionDataSource = PostGradeDs_needsAssessment;
                form.getItem("objectId").pickListFields = [
                    {name: "code", title: "<spring:message code="code"/>", autoFitWidth: false},
                    {name: "titleFa", title: "<spring:message code="title"/>", autoFitWidth: false}
                ];
                break;
            case 'PostGradeGroup':
                form.getItem("objectId").optionDataSource = PostGradeGroupDs_needsAssessment;
                form.getItem("objectId").pickListFields = [
                    {name: "titleFa", title: "<spring:message code="title"/>", autoFitWidth: false},
                    {name: "code", title: "<spring:message code="code"/>", autoFitWidth: false}
                ];
                break;
        }
    }
    function clearAllGrid() {
        competenceData.length = 0;
        skillData.length = 0;
        ListGrid_Competence_JspNeedsAssessment.setData([]);
        ListGrid_Knowledge_JspNeedsAssessment.setData([]);
        ListGrid_Attitude_JspNeedsAssessment.setData([]);
        ListGrid_Ability_JspNeedsAssessment.setData([]);
    }
    function refreshPersonnelLG(pickListRecord) {
        if (pickListRecord == null)
            pickListRecord = NeedsAssessmentTargetDF_needsAssessment.getItem("objectId").getSelectedRecord();
        if (pickListRecord == null){
            ListGrid_Personnel_JspNeedsAssessment.setData([]);
            return;
        }
        let crt = {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: []
        };
        switch (NeedsAssessmentTargetDF_needsAssessment.getItem("objectType").getValue()) {
            case 'Job':
                crt.criteria.add({fieldName: "jobNo", operator: "equals", value: pickListRecord.code});
                break;
            case 'JobGroup':
                crt.criteria.add({fieldName: "jobNo", operator: "inSet", value: pickListRecord.jobSet.map(PG => PG.code)});
                break;
            case 'Post':
                crt.criteria.add({fieldName: "postCode", operator: "equals", value: pickListRecord.code});
                break;
            case 'PostGroup':
                // crt.criteria.add({fieldName: "postCode", operator: "inSet", value: pickListRecord.postSet.map(PG => PG.code)});
                crt.criteria.add({fieldName: "postCode", operator: "inSet", value: pickListRecord.code});
                break;
            case 'PostGrade':
                crt.criteria.add({fieldName: "postGradeCode", operator: "equals", value: pickListRecord.code});
                break;
            case 'PostGradeGroup':
                crt.criteria.add({fieldName: "postGradeCode", operator: "inSet", value: pickListRecord.postGradeSet.map(PG => PG.code)});
                break;
        }
        ListGrid_Personnel_JspNeedsAssessment.implicitCriteria = crt;
        // refreshLG(ListGrid_Personnel_JspNeedsAssessment);
        ListGrid_Personnel_JspNeedsAssessment.invalidateCache();
        ListGrid_Personnel_JspNeedsAssessment.fetchData();
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
    function removeRecord_JspNeedsAssessment(record) {
        if(record.objectType === NeedsAssessmentTargetDF_needsAssessment.getValue("objectType")){
            isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/" + record.id, "DELETE", null, function (resp) {
                if (resp.httpResponseCode != 200) {
                    return true;
                }
                DataSource_Skill_JspNeedsAssessment.removeData(record);
                // return false;
            }));
        }
        else{
            createDialog("info","فقط نیازسنجی های مرتبط با "+priorityList[NeedsAssessmentTargetDF_needsAssessment.getValue("objectType")]+" قابل حذف است.")
        }
    }

    function editNeedsAssessmentRecord(objectId, objectType) {
        // let criteria = [
        //     '{"fieldName":"objectType","operator":"equals","value":"'+objectType+'"}',
        //     '{"fieldName":"objectId","operator":"equals","value":'+objectId+'}'
        // ];
        updateObjectIdLG(NeedsAssessmentTargetDF_needsAssessment, objectType);
        clearAllGrid();
        isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/editList/" + objectType + "/" + objectId, "GET", null, function(resp){
            if (resp.httpResponseCode !== 200){
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
                skill.objectName = data[i].objectName;
                skill.objectCode = data[i].objectCode;
                DataSource_Skill_JspNeedsAssessment.addData(skill);
                if( flags[data[i].competenceId]) continue;
                flags[data[i].competenceId] = true;
                // outPut.push(data[i].competenceId);
                competence.id = data[i].competenceId;
                competence.title = data[i].competence.title;
                competence.competenceType = data[i].competence.competenceType;
                DataSource_Competence_JspNeedsAssessment.addData(competence, ()=>{ListGrid_Competence_JspNeedsAssessment.selectRecord(0)});
            }
            ListGrid_Competence_JspNeedsAssessment.fetchData();
            ListGrid_Competence_JspNeedsAssessment.emptyMessage = "<spring:message code="msg.no.records.for.show"/>";
            NeedsAssessmentTargetDF_needsAssessment.setValue("objectId", objectId);
            NeedsAssessmentTargetDF_needsAssessment.setValue("objectType", objectType);
            fetchDataDomainsGrid();
        }))
    }
    function updateSkillRecord(form, item) {
        let record = form.getData();
        record.needsAssessmentPriorityId = item.getSelectedRecord().id;
        isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/" + record.id, "PUT", JSON.stringify(record), function(resp) {
            if(resp.httpResponseCode !== 200){
                createDialog("info", "<spring:message code='error'/>");
            }
            DataSource_Skill_JspNeedsAssessment.updateData(record);
            item.grid.endEditing();
        }));
    }
    function createNeedsAssessmentRecords(data) {
        if(!checkSaveData(data, DataSource_Skill_JspNeedsAssessment)){
            createDialog("info", "<spring:message code="exception.duplicate.information"/>", "<spring:message code="error"/>");
            return;
        }
        isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl, "POST", JSON.stringify(data),function(resp){
            if (resp.httpResponseCode != 200){
                createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                return;
            }
            data.id = JSON.parse(resp.data).id;
            DataSource_Skill_JspNeedsAssessment.addData(data);
            fetchDataDomainsGrid();
        }))
    }
    function createData_JspNeedsAssessment(record, DomainId, PriorityId = 111) {
        let data = {
            objectType: NeedsAssessmentTargetDF_needsAssessment.getValue("objectType"),
            objectId: NeedsAssessmentTargetDF_needsAssessment.getValue("objectId"),
            objectName: NeedsAssessmentTargetDF_needsAssessment.getItem("objectId").getSelectedRecord().titleFa,
            objectCode: NeedsAssessmentTargetDF_needsAssessment.getItem("objectId").getSelectedRecord().code,
            competenceId: ListGrid_Competence_JspNeedsAssessment.getSelectedRecord().id,
            skillId: record.id,
            titleFa: record.titleFa,
            needsAssessmentPriorityId: PriorityId,
            needsAssessmentDomainId: DomainId
        };
        return data;
    }

    const changeDirection=(status)=>{
        let classes=".cellAltCol,.cellDarkAltCol, .cellOverAltCol, .cellOverDarkAltCol, .cellSelectedAltCol, .cellSelectedDarkAltCol," +
            " .cellSelectedOverAltCol, .cellSelectedOverDarkAltCol, .cellPendingSelectedAltCol, .cellPendingSelectedDarkAltCol," +
            " .cellPendingSelectedOverAltCol, .cellPendingSelectedOverDarkAltCol, .cellDeselectedAltCol, .cellDeselectedDarkAltCol," +
            " .cellDeselectedOverAltCol, .cellDeselectedOverDarkAltCol, .cellDisabledAltCol, .cellDisabledDarkAltCol";
        setTimeout(function() {
            $(classes).css({'direction': 'ltr!important'});
            if (status==0)
                $("tbody tr td:nth-child(7)").css({'direction':'ltr'});
            else
                $("tbody tr td:nth-child(1)").css({'direction':'ltr'});
        },10);
    };

    function updateLabelEditNeedsAssessment(objectId) {
        Label_PlusData_JspNeedsAssessment.setContents("");
        if(NeedsAssessmentTargetDF_needsAssessment.getValue("objectType") === "Post") {
            Label_PlusData_JspNeedsAssessment.setContents(
                "عنوان پست: " + objectId.titleFa
                // + "&nbsp;&nbsp;***&nbsp;&nbsp;" + "عنوان رده پستی: " + objectId.postGrade.titleFa
                + "&nbsp;&nbsp;***&nbsp;&nbsp;" + "حوزه: " + objectId.area
                + "&nbsp;&nbsp;***&nbsp;&nbsp;" + "معاونت: " + objectId.assistance
                + "&nbsp;&nbsp;***&nbsp;&nbsp;" + "امور: " + objectId.affairs
            );
        }
    }
    function updatePriority_JspEditNeedsAssessment(viewer, record) {
        if(record.objectType === NeedsAssessmentTargetDF_needsAssessment.getValue("objectType")) {
            switch (record.needsAssessmentPriorityId) {
                case 111:
                    record.needsAssessmentPriorityId++;
                    break;
                case 112:
                    record.needsAssessmentPriorityId++;
                    break;
                default:
                    record.needsAssessmentPriorityId = 111;
                    break;
            }
            isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/" + record.id, "PUT", JSON.stringify(record), function (resp) {
                if (resp.httpResponseCode !== 200) {
                    createDialog("info", "<spring:message code='error'/>");
                    return;
                }
                DataSource_Skill_JspNeedsAssessment.updateData(record);
                viewer.endEditing();
            }));
        }
        else{
            createDialog("info","فقط نیازسنجی های مرتبط با "+priorityList[NeedsAssessmentTargetDF_needsAssessment.getValue("objectType")]+" قابل تغییر است.")
        }
    }


    function loadEditNeedsAssessment(objectId, type) {
        updateObjectIdLG(NeedsAssessmentTargetDF_needsAssessment, type);
        NeedsAssessmentTargetDF_needsAssessment.setValue("objectType", type);
        NeedsAssessmentTargetDF_needsAssessment.setValue("objectId", objectId.id);
        clearAllGrid();
        editNeedsAssessmentRecord(objectId.id, type);
        refreshPersonnelLG(objectId);
        updateLabelEditNeedsAssessment(objectId);
    }

    // </script>