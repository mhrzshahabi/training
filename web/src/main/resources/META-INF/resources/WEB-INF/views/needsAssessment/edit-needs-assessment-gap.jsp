<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>

    const yellow ="#d6d216";
    const red = "#ff8abc";
    const green = "#5dd851";
    const blue = "#0380fc";
    let competenceAttitudeGapData = [];
    let competenceKnowledgeGapData = [];
    let belowCourses = [];
    let belowCoursesForMainPage = [];
    let competenceAbilityGapData = [];


    let gapObjectId=null;
    let canChange=true;
    let selectedListGridKnowledge=false;
    let selectedListGridAbility=false;
    let selectedListGridAttitude=false;
    let gapObjectType=null;
    let selectedRecord=null;

    let RestDataSource_Skill_JspNeedsAssessmentGap = isc.TrDS.create({
        ID: "RestDataSource_Skill_JspNeedsAssessmentGap",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
             {name: "code", title: "کد مهارت", filterOperator: "iContains"},
             {name: "category.titleFa", title: "گروه", filterOperator: "iContains"},
             {name: "subCategory.titleFa", title: "زیر گروه", filterOperator: "iContains"},
            {name: "skillLevel.titleFa", title: "<spring:message code="skill.level"/>", filterOperator: "iContains"},
            {name: "course.titleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains"},
            {name: "course.code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true}
        ],
        fetchDataURL: skillUrl + "/spec-list"
    });

    let RestDataSource_Skill_JspNeedsAssessmentGapTop = isc.TrDS.create({
        ID: "RestDataSource_Skill_JspNeedsAssessmentGapTop",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "کد مهارت", filterOperator: "iContains"},
            {name: "category.titleFa", title: "گروه", filterOperator: "iContains"},
            {name: "subCategory.titleFa", title: "زیر گروه", filterOperator: "iContains"},
            {name: "skillLevel.titleFa", title: "<spring:message code="skill.level"/>", filterOperator: "iContains"},
            {name: "course.titleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains"},
            {name: "course.code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true}
        ],
        fetchDataURL: skillUrl + "/spec-list"
    });


    let RestDataSource_Skill_JspNeedsAssessmentGapBelow = isc.TrDS.create({
        ID: "RestDataSource_Skill_JspNeedsAssessmentGapBelow",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "کد مهارت", filterOperator: "iContains"},
            {name: "category.titleFa", title: "گروه", filterOperator: "iContains"},
            {name: "subCategory.titleFa", title: "زیر گروه", filterOperator: "iContains"},
            {name: "skillLevel.titleFa", title: "<spring:message code="skill.level"/>", filterOperator: "iContains"},
            {name: "course.titleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains"},
            {name: "course.code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true},
            {name: "limitSufficiency", title:"حد بسندگی", length: 3,
                keyPressFilter: "[0-9.]"}

        ],
        testData: belowCourses,
        clientOnly: true
     });


    let RestDataSource_Skill_JspNeedsAssessmentGapBelowForMainPage = isc.TrDS.create({
        ID: "RestDataSource_Skill_JspNeedsAssessmentGapBelowForMainPage",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "کد مهارت", filterOperator: "iContains"},
            {name: "category.titleFa", title: "گروه", filterOperator: "iContains"},
            {name: "subCategory.titleFa", title: "زیر گروه", filterOperator: "iContains"},
            {name: "skillLevel.titleFa", title: "<spring:message code="skill.level"/>", filterOperator: "iContains"},
            {name: "course.titleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains"},
            {name: "course.code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true},
            {name: "limitSufficiency", title:"حد بسندگی", length: 3,
                keyPressFilter: "[0-9.]"}

        ],
        testData: belowCoursesForMainPage,
        clientOnly: true
    });




    let RestDataSource_NeedsAssessment_JspENAGap = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "objectName", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "objectCode", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "objectType", title: "<spring:message code="title"/>", width:90, valueMap: priorityList},
            {name: "competence.title", title: "<spring:message code="type"/>", filterOperator: "iContains"},
            {name: "competence.competenceType.title", title: "<spring:message code="type"/>", filterOperator: "iContains"},
            {name: "skill.titleFa", title: "<spring:message code="type"/>", filterOperator: "iContains"},
            {name: "needsAssessmentDomain.title", title: "<spring:message code="type"/>", filterOperator: "iContains"},
            {name: "needsAssessmentPriority.title", title: "<spring:message code="type"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: needsAssessmentUrl + "/iscList"
    });
    let RestDataSource_Competence_JspNeedsAssessmentGap = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name : "code"},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceType.title", title: "<spring:message code="type"/>", filterOperator: "iContains",},
            {name: "categoryId", title: "گروه"},
            {name: "subCategoryId", title: "زیر گروه"},
            {name: "competenceLevelId",valueMap: {
                    108: "دانشی",
                    109: "توانشی",
                    110: "نگرشی"
                }, title: "حیطه", filterOperator: "equals"},
            {name: "competencePriorityId", filterOperator: "equals", valueMap: {
                    113: "عملکردی توسعه",
                    112: "عملکردی بهبود",
                    111: "ضروری ضمن خدمت",
                    574: "ضروری انتصاب سمت"
                },title: "اولویت"}
        ],
        fetchDataURL: competenceUrl + "/spec-list",
    });

    let DataSource_Competence_JspNeedsAssessmentGap = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "عنوان"},
        ],
        fetchDataURL: parameterValueUrl + "/listByCode/v2/gapCompetenceType/iscList",
    });


    let DataSource_competence_Attitude_JspNeedsAssessmentGap = isc.TrDS.create({
        ID: "DataSource_competence_Attitude_JspNeedsAssessmentGap",
        fields: [
            {name: "id", hidden:true},
            {name: "code", title: "کد شایستگی", align: "center"},
            {name: "title", title: "نام شایستگی", align: "center"},
            {name: "categoryId", hidden:true},
            {name: "subCategoryId", hidden:true},
            {name: "competencePriorityId", hidden:true}
        ],
        testData: competenceAttitudeGapData,
        clientOnly: true

    });

    let DataSource_competence_Knowledge_JspNeedsAssessmentGap = isc.TrDS.create({
        ID: "DataSource_competence_Knowledge_JspNeedsAssessmentGap",
        fields: [
            {name: "id", hidden:true},
            {name: "code", title: "کد شایستگی", align: "center"},
            {name: "title", title: "نام شایستگی", align: "center"},
            {name: "categoryId", hidden:true},
            {name: "subCategoryId", hidden:true},
            {name: "competencePriorityId", hidden:true}
        ],
        testData: competenceKnowledgeGapData,
        clientOnly: true

    });

    let DataSource_competence_Ability_JspNeedsAssessmentGap = isc.TrDS.create({
        ID: "DataSource_competence_Ability_JspNeedsAssessmentGap",
        fields: [
            {name: "id", hidden:true},
            {name: "code", title: "کد شایستگی", align: "center"},
            {name: "title", title: "نام شایستگی", align: "center"},
            {name: "categoryId", hidden:true},
            {name: "subCategoryId", hidden:true},
            {name: "competencePriorityId", hidden:true}
        ],
        testData: competenceAbilityGapData,
        clientOnly: true

    });


    <%--//----------------------------------------- ToolStrips --------------------------------------------------------------%>

    let CompetenceTS_needsAssessmentGap = isc.ToolStrip.create({
        ID: "CompetenceTS_needsAssessmentGap",
        members: [
            isc.ToolStripButtonAdd.create({
                title:"افزودن شایستگی",
                click: function () {
                    let record = ListGrid_Competence_JspNeedsAssessmentGap.getSelectedRecord();
                    if   (record !== undefined && record !== null ){
                        // ListGrid_NeedsAssessment_JspENAGap.setData([]);
                        Window_AddCompetenceGap.show();
                    }
                    else {
                        createDialog("info","<spring:message code='msg.no.records.selected'/>");
                    }
                }
            }),
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "CompetenceLGCount_needsAssessmentGap"}),
        ]
    });
    let buttonSendToWorkFlow = isc.ToolStripButtonCreate.create({
        title: "ارسال به گردش کار",
        click: async function () {
            saveAndSendToWorkFlowGap()
        }
    });

    let buttonChangeCancel = isc.ToolStripButtonRemove.create({
        ID: "CancelChange_JspENAGap",
        title: "بازخوانی / لغو تغییرات",
        click: function () {
            deleteUnCompleteData()
        }
    });
    let ToolStrip_JspNeedsAssessment = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        align: "center",
        border: "1px solid gray",
        members: [
            // buttonSave,
            buttonSendToWorkFlow,
            buttonChangeCancel
        ]
    });


    let Label_Help_JspNeedsAssessmentGap = isc.LgLabel.create({
        align:"left",
        width: "50%",
        contents: getFormulaMessage("اولویت : ", "2", "#020404", "b") + getFormulaMessage("ضروری ضمن خدمت", "2", red, "b") +" *** " +
            getFormulaMessage("عملکردی بهبود", "2", yellow, "b") + " *** " + getFormulaMessage("توسعه ای", "2", green, "b") + " *** " +
            getFormulaMessage("ضروری انتصاب سمت", "2", blue, "b")

        ,customEdges: []});

    let Menu_ListGrid_Competence_JspNeedsAssessmentGap = isc.Menu.create({
        data: [
            {
                title: "افزودن شایستگی",
                click: function () {
                    let record = ListGrid_Competence_JspNeedsAssessmentGap.getSelectedRecord();
                    if   (record !== undefined && record !== null ){
                        // ListGrid_NeedsAssessment_JspENAGap.setData([]);
                        Window_AddCompetenceGap.show();
                    }
                    else {
                        createDialog("info","<spring:message code='msg.no.records.selected'/>");
                    }
                }
            }
        ]
    });
    let Menu_ListGrid_Knowledge_JspNeedsAssessmentGap = isc.Menu.create({
        data: [
            {
                title: "افزودن دوره",
                click: function () {
                    let record = ListGrid_Knowledge_JspNeedsAssessmentGap.getSelectedRecord();
                openCourseWindow(record)
                }
            }
        ]
    });
    let Menu_ListGrid_Ability_JspNeedsAssessmentGap = isc.Menu.create({
        data: [
            {
                title: "افزودن دوره",
                click: function () {
                    let record = ListGrid_Ability_JspNeedsAssessmentGap.getSelectedRecord();
                    if   (record !== undefined && record !== null ){
                         openCourseWindow(record)
                    }
                    else {
                        createDialog("info","<spring:message code='msg.no.records.selected'/>");
                    }
                }
            }
        ]
    });
    let Menu_ListGrid_Attitude_JspNeedsAssessmentGap = isc.Menu.create({
        data: [
            {
                title: "افزودن دوره",
                click: function () {
                    let record = ListGrid_Attitude_JspNeedsAssessmentGap.getSelectedRecord();
                    if   (record !== undefined && record !== null ){
                        // ListGrid_NeedsAssessment_JspENAGap.setData([]);
                        openCourseWindow(record)
                    }
                    else {
                        createDialog("info","<spring:message code='msg.no.records.selected'/>");
                    }
                }
            }
        ]
    });

    let Menu_LG_AllCompetence_JspENAGap = isc.Menu.create({
        data: [
            {
                title: "افزودن شایستگی",
                click: function () {
                    ListGrid_AllCompetence_JspNeedsAssessmentGap.rowDoubleClick(ListGrid_AllCompetence_JspNeedsAssessmentGap.getSelectedRecord())
                }
            },
        ]
    });

    let ListGrid_SkillAll_JspNeedsAssessmentGap = isc.TrLG.create({
        ID: "ListGrid_SkillAll_JspNeedsAssessmentGap",
        dataSource: RestDataSource_Skill_JspNeedsAssessmentGapBelowForMainPage,
        autoFetchData: true,

        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "skillLevel.titleFa", title: "<spring:message code="skill.level"/>",  canFilter: false},
            {name: "code", title: "کد مهارت",  canFilter: false},
            {name: "category.titleFa", title: "گروه",  canFilter: false},
            {name: "subCategory.titleFa", title: "زیرگروه",  canFilter: false},
            {name: "course.titleFa", title: "<spring:message code="course.title"/>",  canFilter: false},
            {name: "course.code", title: "<spring:message code="course.code"/>",  canFilter: false, autoFitWidth: true, autoFitWidthApproach: true},
            {name: "limitSufficiency",  title:"حد بسندگی",canEdit:false, canFilter: false}
        ],
        gridComponents: [
            isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="course.plural.list"/>" + "</b></span>", customEdges: ["T"]}),
            "filterEditor", "header", "body"
        ],

    });
    let RestDataSource_category_JspENAGap = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: categoryUrl + "spec-list",
    });
    let RestDataSource_subCategory_JspENAGap = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: subCategoryUrl + "spec-list",
    });

    let ListGrid_AllCompetence_JspNeedsAssessmentGap = isc.TrLG.create({
        ID: "ListGrid_AllCompetence_JspNeedsAssessmentGap",
        dataSource: RestDataSource_Competence_JspNeedsAssessmentGap,
        showHeaderContextMenu: false,
        selectionType: "single",
        contextMenu: Menu_LG_AllCompetence_JspENAGap,
        filterOnKeypress: true,
        canDragRecordsOut: true,
        dragDataAction: "none",
        canAcceptDroppedRecords: true,
        fields: [
            {name: "code", title: "کد شایستگی", autoFitData: true, autoFitWidthApproach: true},
            {name: "title", title: "نام شایستگی"},
            {name: "competenceType.title", title: "نوع شایستگی"},
            {name: "categoryId", title: "گروه", optionDataSource: RestDataSource_category_JspENAGap, displayField: "titleFa", valueField:"id"},
            {name: "subCategoryId", title: "زیر گروه" , optionDataSource: RestDataSource_subCategory_JspENAGap, displayField: "titleFa", valueField:"id"},
            {name: "competenceLevelId", title: "حیطه" , },
            {name: "competencePriorityId", title: "اولویت" , }
        ],
        gridComponents: ["filterEditor", "header", "body"],
        rowDoubleClick(record){
            addGridCompetenceRecords(record);
        },
        selectionChanged(record, state) {
            if (state === true) {
                let criteria = {
                    _constructor: "AdvancedCriteria",
                    operator: "and",
                    criteria: [{fieldName: "competenceId", operator: "equals", value: record.id}]
                };
                // ListGrid_NeedsAssessment_JspENAGap.invalidateCache();
                // ListGrid_NeedsAssessment_JspENAGap.setImplicitCriteria(criteria);
                // ListGrid_NeedsAssessment_JspENAGap.fetchData(criteria);
            }
        }
    });

    let ListGrid_Competence_JspNeedsAssessmentGap = isc.TrLG.create({
        ID: "ListGrid_Competence_JspNeedsAssessmentGap",
        dataSource: DataSource_Competence_JspNeedsAssessmentGap,
        contextMenu: Menu_ListGrid_Competence_JspNeedsAssessmentGap,
        gridComponents: [
            isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="competence.list"/>" + "</b></span>", customEdges: ["B"]}),
            CompetenceTS_needsAssessmentGap, "header", "body"
        ],
        fields: [
            {name: "id", title: "شماره", primaryKey: true, canEdit: false, hidden: true},
            {name: "title", title: "عنوان", align: "center"},
        ],
        autoFetchData: true,
        showFilterEditor: false,
        allowAdvancedCriteria: false,
        allowFilterExpressions: false,
        filterOnKeypress: false,
        selectionType: "single",
        autoFithWidth: true,
        showResizeBar: false,


        dataChanged(){
            editing = true;
            this.Super("dataChanged",arguments);
        },
        selectionUpdated(record){
            // fetchDataDomainsGrid();
            // ListGrid_SkillAll_JspNeedsAssessment_Refresh();
        },

    });



    let ListGrid_Knowledge_JspNeedsAssessmentGap = isc.ListGrid.create({
        ID: "ListGrid_Knowledge_JspNeedsAssessmentGap",
        autoFetchData:false,
        dataSource: DataSource_competence_Knowledge_JspNeedsAssessmentGap,
        showRowNumbers: false,
        selectionType:"multiple",
        autoSaveEdits:false,
        sortField: 0,
        sortDirection: "descending",
        implicitCriteria:{"needsAssessmentDomainId":108},
        contextMenu: Menu_ListGrid_Knowledge_JspNeedsAssessmentGap,
         headerSpans: [
            {
                fields: ["code","title"],
                title: "<spring:message code="knowledge"/>"
            }],

        headerHeight: 50,
        gridComponents: [
             "header", "body"
        ],
        canAcceptDroppedRecords: true,
        showHoverComponents: true,
        canRemoveRecords:true,
        showHeaderContextMenu: false,
        showFilterEditor:true,
        selectionChanged(record, state) {
            if (state === true) {
                ListGrid_SkillAll_JspNeedsAssessmentGap.fetchData();
                ListGrid_SkillAll_JspNeedsAssessmentGap.invalidateCache();
                belowCoursesForMainPage.length = 0;
                ListGrid_Attitude_JspNeedsAssessmentGap.deselectAllRecords();
                ListGrid_Ability_JspNeedsAssessmentGap.deselectAllRecords();
                getLastRecordsForBelow(ListGrid_SkillAll_JspNeedsAssessmentGap,RestDataSource_Skill_JspNeedsAssessmentGapBelowForMainPage,null,record.id,false)
            }
        },

        getCellCSSText(record) {
            return priorityColor(record);
        },

    });
    let ListGrid_Ability_JspNeedsAssessmentGap = isc.ListGrid.create({
        ID: "ListGrid_Ability_JspNeedsAssessmentGap",
        dataSource: DataSource_competence_Ability_JspNeedsAssessmentGap,
        autoFetchData:false,
        showRowNumbers: false,
        contextMenu: Menu_ListGrid_Ability_JspNeedsAssessmentGap,
        selectionType:"multiple",
        sortField: 0,
        sortDirection: "descending",
        headerSpans: [
            {
                fields: ["code","title"],
                title: "<spring:message code="ability"/>"
            }],

        headerHeight: 50,
        gridComponents: [
            "header", "body"
        ],
        showHeaderContextMenu: false,
        canAcceptDroppedRecords: true,
        showHoverComponents: true,
        autoSaveEdits:false,
        canRemoveRecords:true,
        showFilterEditor:true,
        implicitCriteria:{"needsAssessmentDomainId":109},
        selectionChanged(record, state) {
            if (state === true) {
                ListGrid_SkillAll_JspNeedsAssessmentGap.fetchData();
                ListGrid_SkillAll_JspNeedsAssessmentGap.invalidateCache();
                belowCoursesForMainPage.length = 0;
                ListGrid_Knowledge_JspNeedsAssessmentGap.deselectAllRecords();
                ListGrid_Attitude_JspNeedsAssessmentGap.deselectAllRecords();
                getLastRecordsForBelow(ListGrid_SkillAll_JspNeedsAssessmentGap,RestDataSource_Skill_JspNeedsAssessmentGapBelowForMainPage,null,record.id,false)
            }
        },

        getCellCSSText: function (record) {
            return priorityColor(record);
        },

    });
    let ListGrid_Attitude_JspNeedsAssessmentGap = isc.ListGrid.create({
        ID: "ListGrid_Attitude_JspNeedsAssessmentGap",
        dataSource: DataSource_competence_Attitude_JspNeedsAssessmentGap,
        showHeaderContextMenu: false,
        showRowNumbers: false,
        autoFetchData:false,
        contextMenu: Menu_ListGrid_Attitude_JspNeedsAssessmentGap,
        selectionType:"multiple",
        sortField: 0,
        sortDirection: "descending",
         headerSpans: [
            {
                fields: ["code","title"],
                title: "<spring:message code="attitude"/>"
            }],

        headerHeight: 50,
        gridComponents: [
            "header", "body"
        ],
        // width: "25%",
        canAcceptDroppedRecords: true,
        // canHover: true,
        autoSaveEdits:false,
        showHoverComponents: true,
        // hoverMode: "details",
        canRemoveRecords:true,
        showFilterEditor:true,
        implicitCriteria:{"needsAssessmentDomainId":110},
        selectionChanged(record, state) {
            if (state === true) {
                ListGrid_SkillAll_JspNeedsAssessmentGap.fetchData();
                ListGrid_SkillAll_JspNeedsAssessmentGap.invalidateCache();
                belowCoursesForMainPage.length = 0;
                ListGrid_Knowledge_JspNeedsAssessmentGap.deselectAllRecords();
                ListGrid_Ability_JspNeedsAssessmentGap.deselectAllRecords();
                getLastRecordsForBelow(ListGrid_SkillAll_JspNeedsAssessmentGap,RestDataSource_Skill_JspNeedsAssessmentGapBelowForMainPage,null,record.id,false)

            }
        },

        getCellCSSText: function (record) {
            return priorityColor(record);
        },


    });
    let Spacer_TopGap = isc.LayoutSpacer.create({height: 5});
    let Spacer_BottomGap = isc.LayoutSpacer.create({height: 35});

    // دوره های انتخاب شده
    let ListGrid_Used_course = isc.TrLG.create({
        width: "100%",
        height: "100%",
        canAutoFitWidth: true,
        selectionType: "simple",
        selectionAppearance: "checkbox",
        dataSource: RestDataSource_Skill_JspNeedsAssessmentGapBelow,
        autoFetchData: true,

        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "skillLevel.titleFa", title: "<spring:message code="skill.level"/>",  canFilter: false},
            {name: "code", title: "کد مهارت",  canFilter: false},
            {name: "category.titleFa", title: "گروه",  canFilter: false},
            {name: "subCategory.titleFa", title: "زیرگروه",  canFilter: false},
            {name: "course.titleFa", title: "<spring:message code="course.title"/>",  canFilter: false},
            {name: "course.code", title: "<spring:message code="course.code"/>",  canFilter: false, autoFitWidth: true, autoFitWidthApproach: true},
            {name: "limitSufficiency", length: 3,title:"حد بسندگی",canEdit:true, canFilter: false,keyPressFilter: "[0-9.]",editEvent: "click", change: function(form, item, value, oldValue) {
                    setLimitSufficiencyValue(value, form)
                },}
        ],
    });

    let Section_Stack_Used_Courses = isc.SectionStack.create({
        width: "100%",
        height: "100%",
        border: "1px solid red",
        sections: [{
            title: "دوره های انتخاب شده",
            expanded: true,
            canCollapse: false,
            align: "center",
            items: [ ListGrid_Used_course]
        }]
    });

    // دوره های انتخاب نشده
    let ListGrid_Non_Used_course = isc.TrLG.create({
        width: "100%",
        height: "100%",
        canAutoFitWidth: true,
        selectionType: "simple",
        selectionAppearance: "checkbox",
        dataSource: RestDataSource_Skill_JspNeedsAssessmentGapTop,
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "skillLevel.titleFa", title: "<spring:message code="skill.level"/>", filterOperator: "iContains"},
            {name: "code", title: "کد مهارت", filterOperator: "iContains"},
            {name: "category.titleFa", title: "گروه", filterOperator: "iContains"},
            {name: "subCategory.titleFa", title: "زیرگروه", filterOperator: "iContains"},
            {name: "course.titleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains"},
            {name: "course.code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true}
         ],
        autoFetchData: true
    });

    let Section_Stack_Non_Used_coursesGap = isc.SectionStack.create({
        width: "100%",
        height: "100%",
        border: "1px solid green",
        sections: [{
            title: "لیست دوره ها",
            expanded: true,
            canCollapse: false,
            align: "center",
            items: [ListGrid_Non_Used_course]
        }]
    });
    let IButton_Add_Course = isc.ToolStripButtonAdd.create({
        width:"10%",
        height:30,
        title:"افزودن",
        click: function () {
            // addPostToOperationalRole();
            addCoursesToNeedAssessmentWithGap();
            // refreshLG(ListGrid_Post_OperationalRole);
        }
    })

    let IButton_del_Course = isc.ToolStripButtonRemove.create({
        width:"10%",
        height:30,
        title:"حذف",
        click: function () {
            deleteCoursesFromNeedAssessmentWithGap(ListGrid_Used_course.getSelectedRecords(),RestDataSource_Skill_JspNeedsAssessmentGapBelow);
        }
    })
     let IButton_save_Course = isc.ToolStripButtonAdd.create({
        width:"10%",
        height:30,
         title:"ذخیره تغییرات",
        click: function () {
            saveSkilsInNeedassessment();
            // refreshLG(ListGrid_Post_OperationalRole);
        }
    })

    let Window_AddCourseGap = isc.Window.create({
        title: "لیست دوره ها",
        align: "center",
        placement: "fillScreen",
        border: "1px solid gray",
        closeClick: function () {
            // refreshLG(ListGrid_Non_Used_Post_OperationalRole);
            // refreshLG(ListGrid_Post_OperationalRole);
            this.close();
        },
        items: [isc.TrVLayout.create({
            members: [
                Section_Stack_Non_Used_coursesGap, Spacer_TopGap,IButton_Add_Course,Spacer_BottomGap,Section_Stack_Used_Courses,Spacer_TopGap,IButton_del_Course,Spacer_TopGap,IButton_save_Course,Spacer_BottomGap
            ]
        })]
    });

    let Window_AddCompetenceGap = isc.Window.create({
        title: "<spring:message code="competence.list"/>",
        width: "80%",
        height: "70%",
        keepInParentRect: true,
        isModal: false,
        autoSize: false,
        items: [
            isc.TrVLayout.create({
                members: [
                    ListGrid_AllCompetence_JspNeedsAssessmentGap,
                    // ListGrid_NeedsAssessment_JspENAGap
                ]
            })],
        show(){
            let record = ListGrid_Competence_JspNeedsAssessmentGap.getSelectedRecord();
            let competenceTitle= record.title

            this.Super("show", arguments);
            let criteria = {
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [{fieldName: "workFlowStatusCode", operator: "equals", value: 2},
                    {fieldName: "competenceType.title", operator: "equals", value:competenceTitle},
                    {fieldName: "active", operator: "equals", value:true},
                ]
            }
            ListGrid_AllCompetence_JspNeedsAssessmentGap.setImplicitCriteria(criteria);
            ListGrid_AllCompetence_JspNeedsAssessmentGap.fetchData();
        }
    });




    let HLayout_Bottom = isc.TrHLayout.create({
        members: [
            isc.TrVLayout.create({
                width: "25%",
                showResizeBar: true,
                members: [ListGrid_Competence_JspNeedsAssessmentGap]
            }),
            isc.TrVLayout.create({
                ID: "VLayoutLeft_JspEditNeedsAssessmentGap",
                // width: "75%",
                members: [
                    isc.TrHLayout.create({
                        ID: "HLayoutCenter_JspEditNeedsAssessmentGap",
                        height: "70%",
                        showResizeBar: true,
                        members: [
                            ListGrid_Knowledge_JspNeedsAssessmentGap,
                            ListGrid_Ability_JspNeedsAssessmentGap,
                            ListGrid_Attitude_JspNeedsAssessmentGap
                        ]
                    }),
                    isc.HLayout.create({
                        height: "5%",
                        showResizeBar: true,
                        members: [
                            Label_Help_JspNeedsAssessmentGap
                        ]
                    }),
                    ListGrid_SkillAll_JspNeedsAssessmentGap
                ]
            })
        ]
    });

    isc.TrVLayout.create({
        members: [
            HLayout_Bottom,
            ToolStrip_JspNeedsAssessment
        ],
    });


    function priorityColor(record){
        switch (record.competencePriorityId) {
            case 113:
                return "background-color : " + red;
            case 112:
                return "background-color : " + yellow;
            case 111:
                return "background-color : " + green;
            case 574:
                return "background-color : " + blue;
        }
    }



    function loadEditNeedsAssessmentGap(record, type, state = "R&W",isFromGap) {
        gapObjectId = record.id
        gapObjectType = type
        clearAllGrid()
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(canChangeData+gapObjectId+"/"+gapObjectType , "Get",null, function (resp) {
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                wait.close();
                canChange = resp.data === "true";
                changeEnableBtn(IButton_save_Course,canChange);
                changeEnableBtn(IButton_del_Course,canChange);
                changeEnableBtn(buttonSendToWorkFlow,canChange);
                changeEnableBtn(buttonChangeCancel,canChange);
                changeEnableBtn(IButton_Add_Course,canChange);
                callApiForLoadLastData()
            } else {
                wait.close();
                createDialog("info", "<spring:message code="msg.operation.error"/>");
                canChange=false
                changeEnableBtn(IButton_save_Course,canChange);
                changeEnableBtn(IButton_del_Course,canChange);
                changeEnableBtn(buttonSendToWorkFlow,canChange);
                changeEnableBtn(buttonChangeCancel,canChange);
                changeEnableBtn(IButton_Add_Course,canChange);
            }
        }));
    }
    function checkSaveDataGap(data, dataSource, field) {
            return dataSource.testData.find(f => f[field] === data[field]) == null;
    }
    function addCoursesToNeedAssessmentWithGap() {
        let selectedRecords=[]
         selectedRecords = ListGrid_Non_Used_course.getSelectedRecords();
        for (let i = 0; i < selectedRecords.length; i++) {
            RestDataSource_Skill_JspNeedsAssessmentGapBelow.addData(selectedRecords[i]);
        }
    }
    function saveSkilsInNeedassessment() {

         let data = {}
         let errorForLimitSufficiency = 0
         let errorForCourse = 0
         let message = ""
        let skillData = []

        for (let i = 0; i < belowCourses.length; i++) {
            let skill = {}
            if (belowCourses[i].limitSufficiency===undefined ||
                belowCourses[i].limitSufficiency===null ||
                Number( belowCourses[i].limitSufficiency)===0 ||
                Number( belowCourses[i].limitSufficiency)>100){
                errorForLimitSufficiency++;
                if (belowCourses[i].limitSufficiency===undefined ||
                    belowCourses[i].limitSufficiency===null )
                message="حد بسندگی را تعیین کنید";
                else {
                    message="حد بسندگی  باید بین ۰ تا 100 باشد";

                }
                break;
            }else {
                if (belowCourses[i].course=== undefined ||
                    belowCourses[i].course===null ||
                    belowCourses[i].course.id===undefined ||
                    belowCourses[i].course.id === null){
                    errorForCourse++;
                    message="مهارت مورد نظر به هیچ دوره ای وصل نشده است";
                    break;
                }else {
                    skill.id=belowCourses[i].id
                    skill.courseId=belowCourses[i].course.id
                    skill.limitSufficiency=belowCourses[i].limitSufficiency
                    skillData.push(skill)
                }
            }

        }

        if (errorForCourse > 0 || errorForLimitSufficiency > 0) {
            createDialog("info", message, "<spring:message code="error"/>");
            return;
        }else {
            wait.show();
            data.objectId=gapObjectId
            data.objectType=gapObjectType
            data.competenceId=selectedRecord.id
            data.createNeedAssessmentSkills=skillData

            isc.RPCManager.sendRequest(TrDSRequest(addNeedAssmentForGaps , "POST",JSON.stringify(data), function (resp) {

                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    wait.close();

                    ListGrid_SkillAll_JspNeedsAssessmentGap.fetchData();
                    ListGrid_SkillAll_JspNeedsAssessmentGap.invalidateCache();
                    belowCoursesForMainPage.length = 0;
                    ListGrid_Attitude_JspNeedsAssessmentGap.deselectAllRecords();
                    ListGrid_Ability_JspNeedsAssessmentGap.deselectAllRecords();
                    ListGrid_Knowledge_JspNeedsAssessmentGap.deselectAllRecords();
                    Window_AddCourseGap.close();
                    createDialog("info", "<spring:message code="global.form.request.successful"/>");
                    // refreshLG(ListGrid_Post_OperationalRole);
                } else {
                    wait.close();
                    createDialog("info", "<spring:message code="msg.operation.error"/>");
                }
            }));
        }

    }

    function deleteCoursesFromNeedAssessmentWithGap(selectedRecords,dataSource) {
        if (selectedRecords!==undefined && selectedRecords!==null ){
            for (let i = 0; i < selectedRecords.length; i++) {
                dataSource.removeData(selectedRecords[i]);
            }
        }

    }

    function openCourseWindow(record) {

        if   (record !== undefined && record !== null ){
            selectedRecord=null;
            selectedRecord=record;
            let criteria = {
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [
                    {fieldName: "subCategoryId", operator: "equals", value: record.subCategoryId},
                    {fieldName: "categoryId", operator: "equals", value: record.categoryId}
                ]
            };
            ListGrid_Non_Used_course.invalidateCache();
            ListGrid_Non_Used_course.setImplicitCriteria(criteria);
            ListGrid_Non_Used_course.fetchData();
            getLastRecordsForBelow(ListGrid_Used_course,RestDataSource_Skill_JspNeedsAssessmentGapBelow,Window_AddCourseGap,selectedRecord.id,true)
        }
        else {
            selectedRecord=null;
            createDialog("info","<spring:message code='msg.no.records.selected'/>");
        }
    }

    function setLimitSufficiencyValue(value, form) {
        let index = belowCourses.findIndex(f => f.id === form.values.id)
        belowCourses[index].limitSufficiency = value;

    }
    function saveAndSendToWorkFlowGap() {
if (canChange){
    wait.show();
    isc.RPCManager.sendRequest(TrDSRequest(sendToWorkFlow+gapObjectId+"/"+gapObjectType , "Get",null, function (resp) {


        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            wait.close();
            isc.say("عملیات با موفقیت انجام شد.");
            Window_NeedsAssessment_Edit_Gap.close(0);
        } else {
            wait.close();
            createDialog("info", "<spring:message code="msg.operation.error"/>");
        }
    }));
}

    }
    function deleteUnCompleteData() {
if (canChange){
    wait.show();
    isc.RPCManager.sendRequest(TrDSRequest(deleteTempDataFromWorkFlow+gapObjectId+"/"+gapObjectType , "Get",null, function (resp) {


        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            wait.close();
            isc.say("عملیات با موفقیت انجام شد.");
            Window_NeedsAssessment_Edit_Gap.close(0);
        } else {
            wait.close();
            createDialog("info", "<spring:message code="msg.operation.error"/>");
        }
    }));
}

    }
    function changeEnableBtn(btn,en) {
        if (en){
            btn.enable();
        }else
            btn.disable();
    }

    function getLastRecordsForBelow(gridForRemoveData,dataSourceForRemoveData,windowForClose,competenceId,addData) {
        deleteCoursesFromNeedAssessmentWithGap(gridForRemoveData.data.localData,dataSourceForRemoveData);
        isc.RPCManager.sendRequest(TrDSRequest(getSkills+competenceId+"/"+gapObjectId+"/"+gapObjectType , "Get",null, function (resp) {
            wait.show();

            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                wait.close();
                let data = JSON.parse(resp.data).list;
                if (addData){
                    for (let i = 0; i < data.size(); i++) {
                        dataSourceForRemoveData.addData(data[i]);
                    }
                }else{
                    gridForRemoveData.setData(data);
                }
                if (windowForClose!==null)
                windowForClose.show();
            } else {
                wait.close();
                createDialog("info", "<spring:message code="msg.operation.error"/>");
            }
        }));





    }
    function clearAllGrid() {
        ListGrid_Knowledge_JspNeedsAssessmentGap.fetchData();
        ListGrid_Knowledge_JspNeedsAssessmentGap.invalidateCache();
        competenceKnowledgeGapData.length = 0;


        ListGrid_Ability_JspNeedsAssessmentGap.fetchData();
        ListGrid_Ability_JspNeedsAssessmentGap.invalidateCache();
        competenceAbilityGapData.length = 0;


        ListGrid_Attitude_JspNeedsAssessmentGap.fetchData();
        ListGrid_Attitude_JspNeedsAssessmentGap.invalidateCache();
        competenceAttitudeGapData.length = 0;

        ListGrid_Used_course.fetchData();
        ListGrid_Used_course.invalidateCache();
        belowCourses.length = 0;

        ListGrid_SkillAll_JspNeedsAssessmentGap.fetchData();
        ListGrid_SkillAll_JspNeedsAssessmentGap.invalidateCache();
        belowCoursesForMainPage.length = 0;

    }
    function addGridCompetenceRecords(record) {
        switch (record.competenceLevelId) {
            case 108:
            {
                if (checkSaveDataGap(record, DataSource_competence_Knowledge_JspNeedsAssessmentGap, "id")) {
                    DataSource_competence_Knowledge_JspNeedsAssessmentGap.addData(record);
                    return;
                }
                createDialog("info", "<spring:message code="exception.duplicate.information"/>", "<spring:message code="error"/>");
            }
                break;
            case 109:
            {
                if (checkSaveDataGap(record, DataSource_competence_Ability_JspNeedsAssessmentGap, "id")) {
                    DataSource_competence_Ability_JspNeedsAssessmentGap.addData(record);
                    return;
                }
                createDialog("info", "<spring:message code="exception.duplicate.information"/>", "<spring:message code="error"/>");

            }
                break;
            case 110:
            {
                if (checkSaveDataGap(record, DataSource_competence_Attitude_JspNeedsAssessmentGap, "id")) {
                    DataSource_competence_Attitude_JspNeedsAssessmentGap.addData(record);
                    return;
                }
                createDialog("info", "<spring:message code="exception.duplicate.information"/>", "<spring:message code="error"/>");

            }
                break;
        }
    }
    function callApiForLoadLastData() {
        isc.RPCManager.sendRequest(TrDSRequest(CompetencesIscList+"/"+gapObjectId+"/"+gapObjectType , "Get",null, function (resp) {
            wait.show();

            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                wait.close();
                let data = JSON.parse(resp.data).list;

                // if (addData){
                    for (let i = 0; i < data.size(); i++) {
                        addGridCompetenceRecords(data[i])
                        // dataSourceForRemoveData.addData(data[i]);
                    }
                // }else{
                //     gridForRemoveData.setData(data);
                // }

            } else {
                wait.close();
            }
        }));
    }


    // ---------------------------------------- Send To Workflow ---------------------------------------->>

    // </script>
