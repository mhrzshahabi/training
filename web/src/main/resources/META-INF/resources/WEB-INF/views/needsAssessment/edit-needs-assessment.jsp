<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>

    // var view_ENA = null;
    const yellow ="#d6d216";
    const red = "#ff8abc";
    const green = "#5dd851";
    var selectedRecord = {};
    var editing = false;
    var hasChanged = false;

    var skillData = [];
    var competenceData = [];
    var peopleTypeMap ={
        "Personal" : "شرکتی",
        "ContractorPersonal" : "پیمان کار"
    };

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
    let PostDS_TrainingPost = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap:peopleTypeMap},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "jobTitleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postGradeTitleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceCount", title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCount", title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
        ],
        fetchDataURL: viewTrainingPostUrl + "/spec-list"
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
        fetchDataURL: postGradeUrl + "/spec-list"
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
            {name: "code", title: "<spring:message code="skill.code"/>", filterOperator: "iContains"},
            {name: "titleFa", title: "<spring:message code="skill"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true},
            {name: "category.titleFa", title: "<spring:message code="category"/>", filterOperator: "iContains"},
            {name: "subCategory.titleFa", title: "<spring:message code="subcategory"/>", filterOperator: "iContains"},
            {name: "skillLevel.titleFa", title: "<spring:message code="skill.level"/>", filterOperator: "iContains"},
            {name: "course.titleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains"},
            {name: "course.code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true}
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
    var RestDataSource_NeedsAssessment_JspENA = isc.TrDS.create({
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
    var RestDataSource_Competence_JspNeedsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name : "code"},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceType.title", title: "<spring:message code="type"/>", filterOperator: "iContains",},
            {name: "categoryId", title: "گروه"},
            {name: "subCategoryId", title: "زیر گروه"}
        ],
        fetchDataURL: competenceUrl + "/spec-list",
    });
    var RestDataSource_Course_JspENA = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code", title: "<spring:message code="skill.code"/>", filterOperator: "iContains"},
            {name: "titleFa", title: "<spring:message code="skill"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true},
            {name: "course.titleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains"},
            {name: "course.code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true},
            {name: "course.theoryDuration", title: "<spring:message code="duration"/>", filterOperator: "iContains"}

        ],
        fetchDataURL: skillUrl + "/WFC/spec-list"

    });
    var RestDataSource_AddCourse_JspENA = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "scoringMethod"},
            {name: "acceptancelimit"},
            {name: "startEvaluation"},
            {
                name: "code",
                title: "<spring:message code="course.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "titleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains"},
            {name: "createdBy", title: "<spring:message code="created.by.user"/>", filterOperator: "iContains"},
            {name: "theoryDuration"},
            {name: "categoryId"},
            {name: "subCategoryId"},
        ],
        fetchDataURL: courseUrl + "spec-list"
    });
    var RestDataSource_category_JspENA = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: categoryUrl + "spec-list",
    });
    var RestDataSource_category_JspENA1 = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: categoryUrl + "spec-list",
    });
    var RestDataSource_subCategory_JspENA = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: subCategoryUrl + "spec-list",
    });
    var DataSource_Competence_JspNeedsAssessment = isc.DataSource.create({
        clientOnly: true,
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceType.title", title: "<spring:message code="type"/>", filterOperator: "iContains"},
            {name: "categoryId", title: "گروه"},
            {name: "subCategoryId", title: "زیرگروه"},
            {name: "code", title:"کد"}
        ],
        testData: competenceData,
        // fetchDataURL: competenceUrl + "/iscList",
    });
    var DataSource_Skill_JspNeedsAssessment = isc.DataSource.create({
        ID: "DataSource_Skill_JspNeedsAssessment",
        fields: [
            {name: "id", hidden:true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains",
                showHover:true,
                canEdit: false,
                hoverWidth: 250,
                hoverHTML(record) {
                    return (record.mainWorkflowStatus !== undefined ? record.mainWorkflowStatus : getFormulaMessage("به گردش کار ارسال نشده است", "2", "orange", "b")) + "<br>" +
                        (record.course ?
                        "نام مهارت: " + record.titleFa + "<br>" + "نام دوره: " + record.course.titleFa + "<br>" + "کد دوره: " + record.course.code :
                        "نام مهارت: " + record.titleFa);
                },
            },
            {name: "needsAssessmentPriorityId", title: "<spring:message code="priority"/>", filterOperator: "iContains", autoFitWidth:true},
            {name: "needsAssessmentDomainId", filterOperator: "iContains", hidden:true},
            {name: "skillId", primaryKey: true, filterOperator: "iContains", hidden:true},
            {name: "competenceId", filterOperator: "iContains", hidden:true},
            {name: "objectId", filterOperator: "iContains", hidden:true},
            {name: "objectType", title: "<spring:message code="reference"/>", primaryKey: true, filterOperator: "iContains", valueMap: priorityList, autoFitWidth:true,
                showHover:true,
                canEdit: false,
                hoverWidth: 150,
                hoverHTML(record) {
                    return "نام: " + record.objectName + "<br>" + "کد:" + record.objectCode;
                },
                sortNormalizer(record){
                    if(record.objectType === DynamicForm_JspEditNeedsAssessment.getValue("objectType")){
                        return 0;
                    }
                    return 1;
                }
            },
            {name: "objectName"},
            {name: "objectCode"},
            {name: "course"},
            {name: "skill"},
            {name: "mainWorkflowStatus"},
            {name: "hasWarning", title: "", type: "image", imageURLPrefix: "", imageURLSuffix: ".gif", showTitle:false, autoFitWidth:true,
                showHover:true,
                hoverWidth: 200,
                hoverHTML(record) {
                    if(record.hasWarning == "alarm"){
                        return "دوره ای به مهارت اختصاص نیافته است";
                    }
                },
            },
        ],
        testData: skillData,
        clientOnly: true,
    });

    let CompetenceTS_needsAssessment = isc.ToolStrip.create({
        ID: "CompetenceTS_needsAssessment",
        members: [
            isc.ToolStripButtonAdd.create({
                title:"افزودن",
                click: function () {
                    if(DynamicForm_JspEditNeedsAssessment.getValue("objectId")!=null) {
                        ListGrid_AllCompetence_JspNeedsAssessment.fetchData();
                        ListGrid_AllCompetence_JspNeedsAssessment.invalidateCache();
                        Window_AddCompetence.show();
                    }
                    else {
                        createDialog("info","<spring:message code='msg.no.records.selected'/>");
                    }
                }
            }),
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "CompetenceLGCount_needsAssessment"}),
        ]
    });
    let buttonSendToWorkFlow = isc.ToolStripButtonCreate.create({
        title: "ارسال به گردش کار",
        click: function () {
            sendNeedsAssessmentToWorkflow();
        }
    });
    let buttonChangeCancel = isc.ToolStripButtonRemove.create({
        ID: "CancelChange_JspENA",
        title: "بازخوانی / لغو تغییرات",
        click: function () {
            let id = DynamicForm_JspEditNeedsAssessment.getValue("objectId");
            let type = DynamicForm_JspEditNeedsAssessment.getValue("objectType");
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/rollBack/" + type + "/" + id, "PUT", null, (resp)=>{
                wait.close();
                if(resp.httpResponseCode === 200){
                    hasChanged = false;
                    editNeedsAssessmentRecord(id, type);
                }
            }));
        }
    });
    let ToolStrip_JspNeedsAssessment = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        align: "center",
        border: "1px solid gray",
        members: [
            buttonSendToWorkFlow,
            buttonChangeCancel
        ]
    });

    var Window_CourseDetail_JspENA = isc.Window.create({
        title: "<spring:message code="course.plural.list"/>",
        // placement: "fillScreen",
        width: "80%",
        height: "50%",
        minWidth: 1024,
        keepInParentRect: true,
        isModal: true,
        // autoSize: false,
        autoSize: false,
        show(criteria){
            ListGrid_CourseDetail_JspENA.invalidateCache();
            ListGrid_CourseDetail_JspENA.fetchData(criteria);
            this.Super("show", arguments);
        },
        items: [
            isc.TrHLayout.create({
                members: [
                    isc.TrLG.create({
                        ID: "ListGrid_CourseDetail_JspENA",
                        dataSource: RestDataSource_Course_JspENA,
                        // selectionType: "none",
                        filterOnKeypress: true,
                        // autoFetchData:true,
                        fields: [
                            // {name: "scoringMethod"},
                            // {name: "acceptancelimit"},
                            // {name: "startEvaluation"},
                            {
                                name: "code",
                                title: "<spring:message code="skill.code"/>",
                                filterOperator: "iContains",
                                autoFitWidth: true
                            },
                            {
                                name: "titleFa",
                                title: "<spring:message code="skill"/>",
                                filterOperator: "iContains",
                                autoFitWidth: true
                            },
                            {
                                name: "course.code",
                                title: "<spring:message code="course.code"/>",
                                filterOperator: "iContains",
                                autoFitWidth: true
                            },
                            {
                                name: "course.titleFa",
                                title: "<spring:message code="course.title"/>",
                                filterOperator: "iContains",
                                autoFitWidth: true
                            },
                            <%--{name: "createdBy", title: "<spring:message code="created.by.user"/>", filterOperator: "iContains"},--%>

                            {
                                name: "course.categoryId",
                                title: "<spring:message code="category"/> <spring:message code="course"/>",
                                optionDataSource: RestDataSource_category_JspENA,
                                filterOnKeypress: true,
                                valueField: "id",
                                displayField: "titleFa",
                                filterOperator: "equals",
                            },
                            {
                                name: "course.subCategoryId",
                                title: "<spring:message code="subcategory"/> <spring:message code="course"/>",
                                optionDataSource: RestDataSource_subCategory_JspENA,
                                filterOnKeypress: true,
                                valueField: "id",
                                displayField: "titleFa",
                                filterOperator: "equals",
                            },
                            {
                                name: "course.theoryDuration",
                                title: "<spring:message code="course_Running_time"/>",
                                filterOperator: "equals",
                            },
                        ],
                        gridComponents: ["filterEditor", "header", "body"],
                    }),
                ]
            })]
    });

    var Label_PlusData_JspNeedsAssessment = isc.LgLabel.create({
        align:"left",
        contents:"",
        margin:8,
        customEdges: []});
    var Label_Help_JspNeedsAssessment = isc.LgLabel.create({
        align:"left",
        // contents:"<span>.اولویت ضروری با رنگ قرمز، اولویت بهبود با رنگ زرد و اولویت توسعه با رنگ سبز مشخص شده اند<span/>",
        contents:getFormulaMessage("اولویت : ", "2", "#020404", "b")+getFormulaMessage("عملکردی ضروری", "2", red, "b")+" *** "+getFormulaMessage("عملکردی بهبود", "2", yellow, "b")+" *** "+getFormulaMessage("توسعه ای", "2", green, "b"),
        customEdges: []});
    var Button_CourseDetail_JspEditNeedsAssessment = isc.Button.create({
        title:"جزئیات دوره",
        margin: 1,
        baseStyle: "toolStripButton",
        // borderRadius: 5,
        click(){
            if(ListGrid_Knowledge_JspNeedsAssessment.getSelectedRecord()||ListGrid_Ability_JspNeedsAssessment.getSelectedRecord()||ListGrid_Attitude_JspNeedsAssessment.getSelectedRecord()||ListGrid_SkillAll_JspNeedsAssessment.getSelectedRecord()){
                let skillIds = [];
                if(ListGrid_Knowledge_JspNeedsAssessment.getSelectedRecord()!= undefined && ListGrid_Knowledge_JspNeedsAssessment.getSelectedRecord().course != undefined) {
                    skillIds.push(ListGrid_Knowledge_JspNeedsAssessment.getSelectedRecord().skillId);
                }
                if(ListGrid_Ability_JspNeedsAssessment.getSelectedRecord()!= undefined && ListGrid_Ability_JspNeedsAssessment.getSelectedRecord().course!= undefined) {
                    skillIds.push(ListGrid_Ability_JspNeedsAssessment.getSelectedRecord().skillId);
                }
                if(ListGrid_Attitude_JspNeedsAssessment.getSelectedRecord()!= undefined && ListGrid_Attitude_JspNeedsAssessment.getSelectedRecord().course!= undefined) {
                    skillIds.push(ListGrid_Attitude_JspNeedsAssessment.getSelectedRecord().skillId);
                }
                if(ListGrid_SkillAll_JspNeedsAssessment.getSelectedRecord()!= undefined && ListGrid_SkillAll_JspNeedsAssessment.getSelectedRecord().course!= undefined) {
                    skillIds.push(ListGrid_SkillAll_JspNeedsAssessment.getSelectedRecord().id);
                }
                if(skillIds.length == 0){
                    createDialog("info", "مهارت های انتخاب شده بدون دوره هستند.");
                    return;
                }
                let criteria = {
                    _constructor: "AdvancedCriteria",
                    operator: "and",
                    criteria: [{fieldName: "id", operator: "inSet", value: skillIds}]
                };
                Window_CourseDetail_JspENA.show(criteria);
            }
            else{
                createDialog("info", "مهارتی انتخاب نشده است")
            }
        }
    });

    var Button_changeShow_JspEditNeedsAssessment = isc.Button.create({
        title:"مشاهده تغییرات",
        margin: 1,
        click: function () {
            wait.show();
            showWindowDiffNeedsAssessment(DynamicForm_JspEditNeedsAssessment.getValue("objectId"), DynamicForm_JspEditNeedsAssessment.getValue("objectType"), true)
        }
    });

    let oldCourseRecord = {};
    let Menu_ListGrid_JspENA = isc.Menu.create({
        data: [
            {
                title: "جزییات دوره",
                click: function () {
                    if(selectedRecord.course !== undefined) {
                        let id = selectedRecord.course.id;
                        wait.show()
                        isc.RPCManager.sendRequest(TrDSRequest(courseUrl + "spec-list?id=" + id, "GET", null, (resp) => {
                            wait.close()
                            if (resp.httpResponseCode !== 200) {
                                createDialog("info", "<spring:message code='error'/>");
                            }
                            let fields = [
                                {
                                    name: "code", title: "<spring:message code="corse_code"/>",
                                    align: "center",
                                    autoFitWidth: true,
                                    filterOperator: "iContains"
                                },
                                {
                                    name: "titleFa",
                                    title: "<spring:message code="course_fa_name"/>",
                                    align: "center",
                                    autoFitWidth: true,
                                    filterOperator: "iContains",
                                },
                                {
                                    name: "titleEn",
                                    title: "<spring:message code="course_en_name"/>",
                                    align: "center",
                                    filterOperator: "iContains",
                                    hidden: true
                                },
                                {
                                    name: "category.titleFa",
                                    title: "<spring:message code="course_category"/>",
                                    align: "center",
                                    filterOperator: "equals"
                                },
                                {
                                    name: "subCategory.titleFa",
                                    title: "<spring:message code="course_subcategory"/>",
                                    align: "center",
                                    filterOperator: "iContains",
                                    sortNormalizer: function (record) {
                                        return record.subCategory.titleFa;
                                    }
                                },
                                {
                                    name: "erunType.titleFa",
                                    title: "<spring:message code="course_eruntype"/>",
                                    align: "center",
                                    filterOperator: "iContains",
                                    // allowFilterOperators: false,
                                    canFilter: false,
                                    canSort: false,
                                },
                                {
                                    name: "elevelType.titleFa", title: "<spring:message
        code="cousre_elevelType"/>", align: "center", filterOperator: "iContains",
                                    canFilter: false,
                                    canSort: false
                                },
                                {
                                    name: "etheoType.titleFa", title: "<spring:message
        code="course_etheoType"/>", align: "center", filterOperator: "iContains",
                                    canFilter: false,
                                    canSort: false
                                },
                                {
                                    name: "theoryDuration", title: "<spring:message
                code="course_theoryDuration"/>", align: "center", filterOperator: "equals",
                                    filterEditorProperties: {
                                        keyPressFilter: "[0-9]"
                                    }
                                },
                                {
                                    name: "etechnicalType.titleFa", title: "<spring:message
                 code="course_etechnicalType"/>", align: "center", filterOperator: "iContains",
                                    canSort: false,
                                    canFilter: false
                                },
                                {
                                    name: "minTeacherDegree", title: "<spring:message
        code="course_minTeacherDegree"/>", align: "center", filterOperator: "iContains", hidden: true
                                },
                                {
                                    name: "minTeacherExpYears", title: "<spring:message
        code="course_minTeacherExpYears"/>", align: "center", filterOperator: "iContains", hidden: true
                                },
                                {
                                    name: "minTeacherEvalScore", title: "<spring:message
        code="course_minTeacherEvalScore"/>", align: "center", filterOperator: "iContains", hidden: true
                                },
                                // {
                                //     name: "knowledge",
                                //     title: "دانشی",
                                //     align: "center",
                                //     filterOperator: "greaterThan",
                                //     format: "%",
                                //     width: "50"
                                //     // formatCellValue: function (value, record) {
                                //     //     // if (!isc.isA.Number(record.gdp) || !isc.isA.Number(record.population)) return "N/A";
                                //     //     var gdpPerCapita = Math.round(record.theoryDuration/10);
                                //     //     return isc.NumberUtil.format(gdpPerCapita, "%");
                                //     // }
                                // },
                                // {name: "skill", title: "مهارتی", align: "center", filterOperator: "greaterThan", format: "%", width: "50"},
                                // {
                                //     name: "attitude",
                                //     title: "نگرشی",
                                //     align: "center",
                                //     filterOperator: "greaterThan",
                                //     format: "%",
                                //     width: "50"
                                // },
                                {name: "needText", title: "شرح", hidden: true},
                                {name: "description", title: "توضیحات", hidden: true},
                                {
                                    name: "workflowStatus",
                                    title: "<spring:message code="status"/>",
                                    align: "center",
                                    autoFitWidth: true,
                                    filterOperator: "iContains"
                                },
                                {
                                    name: "behavioralLevel", title: "سطح رفتاری",
                                    // hidden:true,
                                    valueMap: {
                                        "1": "مشاهده",
                                        "2": "مصاحبه",
                                        "3": "کار پروژه ای"
                                    }
                                },
                                {
                                    name: "evaluation", title: "<spring:message code="evaluation.level"/>",
                                    valueMap: {
                                        "1": "واکنشی",
                                        "2": "یادگیری",
                                        "3": "رفتاری",
                                        "4": "نتایج"
                                    }
                                },
                                <%--{--%>
                                <%--name: "workflowStatusCode",--%>
                                <%--title: "<spring:message code="status"/>",--%>
                                <%--align: "center",--%>
                                <%--autoFitWidth: true,--%>
                                <%--filterOperator: "iContains",--%>
                                <%--hidden: true--%>
                                <%--},--%>
                                // {name: "hasGoal", type: "boolean", title: "بدون هدف", hidden: true, canFilter: false},
                                // {name: "hasSkill", type: "boolean", title: "بدون مهارت", hidden: true, canFilter: false}
                            ];
                            showDetailViewer("جزئیات دوره", fields, JSON.parse(resp.data).response.data);
                        }));
                    }
                    else{

                    }
                }
            },
            {isSeparator: true},
            {
                title: "ویرایش دوره",
                click: function () {
                    if(selectedRecord.objectType === DynamicForm_JspEditNeedsAssessment.getValue("objectType")) {
                        let Window_AddCourse_JspENA = isc.Window.create({
                            title: "<spring:message code="course.plural.list"/>",
                            // placement: "fillScreen",
                            width: "40%",
                            height: "50%",
                            minWidth: 1024,
                            keepInParentRect: true,
                            autoSize: false,
                            show() {
                                let cr = {
                                    _constructor: "AdvancedCriteria",
                                    operator: "and",
                                    criteria: [
                                        {fieldName: "categoryId", operator: "equals", value: selectedRecord.skill.categoryId},
                                        {fieldName: "subCategoryId", operator: "equals", value: selectedRecord.skill.subCategoryId},
                                    ]
                                }

                                ListGrid_AddCourse_JspENA.setImplicitCriteria(cr);
                                ListGrid_AddCourse_JspENA.invalidateCache();
                                ListGrid_AddCourse_JspENA.fetchData(null, ()=>{
                                    if(selectedRecord.skill.courseId !== undefined){
                                        oldCourseRecord = ListGrid_AddCourse_JspENA.getData().localData.toArray().find(a=>a.id===selectedRecord.skill.courseId);
                                        if(oldCourseRecord != null) {
                                            ListGrid_AddCourse_JspENA.selectRecord(oldCourseRecord);
                                        }
                                    }
                                });
                                this.Super("show", arguments);
                            },
                            items: [
                                isc.TrHLayout.create({
                                    members: [
                                        isc.TrLG.create({
                                            ID: "ListGrid_AddCourse_JspENA",
                                            dataSource: RestDataSource_AddCourse_JspENA,
                                            selectionType: "single",
                                            selectionAppearance:"checkbox",
                                            filterOnKeypress: false,
                                            dataPageSize: 1000,
                                            fields: [
                                                {
                                                    name: "code",
                                                    title: "<spring:message code="course.code"/>",
                                                    filterOperator: "iContains",
                                                    autoFitWidth: true
                                                },
                                                {
                                                    name: "titleFa",
                                                    title: "<spring:message code="course.title"/>",
                                                    filterOperator: "iContains",
                                                    autoFitWidth: true
                                                },
                                                {
                                                    name: "createdBy",
                                                    title: "<spring:message code="created.by.user"/>",
                                                    filterOperator: "iContains"
                                                },
                                                {
                                                    name: "theoryDuration",
                                                    title: "<spring:message code="course_Running_time"/>",
                                                    filterOperator: "equals",
                                                },
                                                {
                                                    name: "categoryId",
                                                    title: "<spring:message code="category"/> ",
                                                    optionDataSource: RestDataSource_category_JspENA,
                                                    filterOnKeypress: true,
                                                    valueField: "id",
                                                    displayField: "titleFa",
                                                    filterOperator: "equals",
                                                },
                                                {
                                                    name: "subCategoryId",
                                                    title: "<spring:message code="subcategory"/> ",
                                                    optionDataSource: RestDataSource_subCategory_JspENA,
                                                    filterOnKeypress: true,
                                                    valueField: "id",
                                                    displayField: "titleFa",
                                                    filterOperator: "equals",
                                                },
                                            ],
                                            gridComponents: ["filterEditor", "header", "body"],
                                            selectionChanged(record, state){
                                                if(state){
                                                    if((selectedRecord.skill.courseId == null)||(record.id !== selectedRecord.skill.courseId)){
                                                        let dialog = createDialog("ask", "از تغییر دوره مهارت " + selectedRecord.skill.titleFa + " به دوره انتخاب شده مطمئن هستید.");
                                                        dialog.addProperties({
                                                            buttonClick: function (button, index) {
                                                                this.close();
                                                                if (index === 0) {
                                                                    let url = skillUrl + "/add-course/" + record.id + "/" + selectedRecord.skillId;
                                                                    wait.show();
                                                                    isc.RPCManager.sendRequest(TrDSRequest(url, "POST", null, (resp) => {
                                                                        wait.close()
                                                                        if (resp.httpResponseCode !== 200) {
                                                                            createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                                                                        }
                                                                        editNeedsAssessmentRecord(DynamicForm_JspEditNeedsAssessment.getValue("objectId"), DynamicForm_JspEditNeedsAssessment.getValue("objectType"));
                                                                        ListGrid_SkillAll_JspNeedsAssessment_Refresh();
                                                                        Window_AddCourse_JspENA.close()
                                                                    }));
                                                                }else {
                                                                    ListGrid_AddCourse_JspENA.selectSingleRecord (oldCourseRecord);
                                                                    // ListGrid_AddCourse_JspENA.deselectRecord(record);
                                                                }
                                                            }
                                                        });
                                                    }
                                                }
                                            },
                                        }),
                                    ]
                                })]
                        });
                        Window_AddCourse_JspENA.show()
                    }
                    else{
                        createDialog("info","فقط نیازسنجی های مرتبط با "+priorityList[DynamicForm_JspEditNeedsAssessment.getValue("objectType")]+" قابل تغییر است.")
                    }
                }
            },
        ]
    });
    let Menu_LG_Competence_JspENA = isc.Menu.create({
        data: [
            {
                title: "جزییات شایستگی",
                click: function () {
                    if(checkSelectedRecord(ListGrid_Competence_JspNeedsAssessment)) {
                        ListGrid_Competence_JspNeedsAssessment.rowDoubleClick(ListGrid_Competence_JspNeedsAssessment.getSelectedRecord())
                    }
                }
            },
        ]
    });
    let Menu_LG_AllCompetence_JspENA = isc.Menu.create({
        data: [
            {
                title: "افزودن شایستگی",
                click: function () {
                    ListGrid_AllCompetence_JspNeedsAssessment.rowDoubleClick(ListGrid_AllCompetence_JspNeedsAssessment.getSelectedRecord())
                }
            },
        ]
    });
    let Menu_LG_History_JspENA = isc.Menu.create({
        data: [
            {
                title: "کپی شایستگی",
                click: function () {
                    let record = ListGrid_NeedsAssessment_JspENA.getSelectedRecord()
                    let url = needsAssessmentUrl + "/copy/" + record.objectType
                        + "/" + record.objectId + "/" + DynamicForm_JspEditNeedsAssessment.getValue("objectType")
                        + "/" + DynamicForm_JspEditNeedsAssessment.getValue("objectId")
                        + "?competenceId=" + record.competenceId;
                    wait.show();
                    isc.RPCManager.sendRequest(TrDSRequest(url, "GET", null,(resp)=>{
                        wait.close();
                        if(resp.data === "true"){
                            editNeedsAssessmentRecord(DynamicForm_JspEditNeedsAssessment.getValue("objectId"), DynamicForm_JspEditNeedsAssessment.getValue("objectType"))
                            hasChanged = true;
                        }
                        else if(resp.data === "false"){
                            readOnly(true);
                        }
                    }));
                }
            },
        ]
    });

    let ListGrid_AllCompetence_JspNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_AllCompetence_JspNeedsAssessment",
        dataSource: RestDataSource_Competence_JspNeedsAssessment,
        showHeaderContextMenu: false,
        selectionType: "single",
        contextMenu: Menu_LG_AllCompetence_JspENA,
        filterOnKeypress: true,
        canDragRecordsOut: true,
        dragDataAction: "none",
        canAcceptDroppedRecords: true,
        fields: [
            {name: "code", title: "کد شایستگی", autoFitData: true, autoFitWidthApproach: true},
            {name: "title", title: "نام شایستگی"},
            {name: "competenceType.title", title: "نوع شایستگی"},
            {name: "categoryId", title: "گروه", optionDataSource: RestDataSource_category_JspENA, displayField: "titleFa", valueField:"id"},
            {name: "subCategoryId", title: "زیر گروه" , optionDataSource: RestDataSource_subCategory_JspENA, displayField: "titleFa", valueField:"id"}
        ],
        gridComponents: ["filterEditor", "header", "body"],
        rowDoubleClick(record){
            if (checkSaveData(record, DataSource_Competence_JspNeedsAssessment, "id")) {
                ListGrid_Competence_JspNeedsAssessment.transferSelectedData(this);
                return;
            }
            createDialog("info", "<spring:message code="exception.duplicate.information"/>", "<spring:message code="error"/>");
        },
        selectionChanged(record, state) {
            if (state === true) {
                let criteria = {
                    _constructor: "AdvancedCriteria",
                    operator: "and",
                    criteria: [{fieldName: "competenceId", operator: "equals", value: record.id}]
                };
                ListGrid_NeedsAssessment_JspENA.invalidateCache();
                ListGrid_NeedsAssessment_JspENA.setImplicitCriteria(criteria);
                ListGrid_NeedsAssessment_JspENA.fetchData(criteria);
            }
        }
    });
    let ListGrid_NeedsAssessment_JspENA = isc.TrLG.create({
        dataSource: RestDataSource_NeedsAssessment_JspENA,
        showHeaderContextMenu: false,
        selectionType: "single",
        contextMenu: Menu_LG_History_JspENA,
        filterOnKeypress: true,
        canDragRecordsOut: true,
        autoFetchData: false,
        dragDataAction: "none",
        canAcceptDroppedRecords: true,
        fields: [
            {name: "objectName", title: "نام عنوان", filterOperator: "iContains", autoFitWidth: true},
            {name: "objectCode", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "objectType", title: "<spring:message code="title"/>", width:90, valueMap: priorityList},
            {name: "competence.title", title: "نام شایستگی", filterOperator: "iContains"},
            {name: "competence.competenceType.title", title: "نوع شایستگی", filterOperator: "iContains"},
            {name: "skill.titleFa", title: "نام مهارت", filterOperator: "iContains"},
            {name: "needsAssessmentDomain.title", title: "حیطه", filterOperator: "iContains"},
            {name: "needsAssessmentPriority.title", title: "اولویت", filterOperator: "iContains"},
        ],
        gridComponents: [
            isc.Label.create({
                contents: "<style>b{color: white}</style><b>تاریخچه شایستگی</b>",
                backgroundColor: "#fe9d2a",
                align: "left",
                padding: 4,
                borderRadius: 2,
                height: 28,
                // showEdges: true
            }),
            "filterEditor", "header", "body"],
    });
    let ListGrid_Competence_JspNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_Competence_JspNeedsAssessment",
        dataSource: DataSource_Competence_JspNeedsAssessment,
        autoFetchData: true,
        contextMenu: Menu_LG_Competence_JspENA,
        selectionType:"single",
        showHeaderContextMenu: false,
        showRowNumbers: false,
        fields: [{name: "title", title: "<spring:message code="title"/>"}, {name: "competenceType.title", title: "<spring:message code="type"/>"},],
        gridComponents: [
            isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="competence.list"/>" + "</b></span>", customEdges: ["B"]}),
            CompetenceTS_needsAssessment, "header", "body"
        ],
        canRemoveRecords:true,
        canDragRecordsOut: true,
        dragDataAction: "none",
        canHover: true,
        showHoverComponents: true,
        hoverMode: "details",

        removeRecordClick(rowNum){
            wait.show();
            let id = DynamicForm_JspEditNeedsAssessment.getValue("objectId");
            let type = DynamicForm_JspEditNeedsAssessment.getValue("objectType");
            isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/isReadOnly/" + type + "/" + id, "GET", null, (resp) => {
                wait.close();
                if (resp.httpResponseCode !== 200) {
                    createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                    return;
                }
                if(resp.data === "true"){
                    createDialog("info", "<spring:message code='read.only.na.message'/>");
                }
                else {
                    let Dialog_Competence_remove = createDialog("ask", "هشدار: در صورت حذف شایستگی تمام مهارت های با مرجع "  + getFormulaMessage(priorityList[type],"2","red","b") +  " آن حذف خواهند شد.",
                        "<spring:message code="verify.delete"/>");
                    Dialog_Competence_remove.addProperties({
                        buttonClick: function (button, index) {
                            this.close();
                            if (index === 0) {
                                let data = ListGrid_Knowledge_JspNeedsAssessment.data.localData.toArray();
                                data.addAll(ListGrid_Attitude_JspNeedsAssessment.data.localData.toArray());
                                data.addAll(ListGrid_Ability_JspNeedsAssessment.data.localData.toArray());
                                let hasFather = false;
                                for (let i = 0; i < data.length; i++) {
                                    let state = removeRecord_JspNeedsAssessment(data[i], 1);
                                    if(state===0){
                                        return;
                                    }
                                    else if(state===2){
                                        hasFather = true;
                                    }
                                }
                                if(hasFather===false) {
                                    ListGrid_Competence_JspNeedsAssessment.removeData(ListGrid_Competence_JspNeedsAssessment.getRecord(rowNum));
                                }
                            }
                        }
                    });
                }
            }))
        },
        dataChanged(){
            editing = true;
            this.Super("dataChanged",arguments);
        },
        selectionUpdated(record){
            fetchDataDomainsGrid();
            ListGrid_SkillAll_JspNeedsAssessment_Refresh();
        },
        rowDoubleClick (record) {
            wait.show()
            isc.RPCManager.sendRequest(TrDSRequest(competenceUrl + "/spec-list?id=" + record.id, "GET", null, (resp) => {
                wait.close()
                RestDataSource_category_JspENA.fetchData()
                if (resp.httpResponseCode !== 200) {
                    createDialog("info", "<spring:message code='error'/>");
                }
                let fields = [
                    {
                        name: "code", title: "<spring:message code="corse_code"/>",
                        align: "center",
                        autoFitWidth: true,
                        filterOperator: "iContains"
                    },
                    {
                        name: "title",
                        title: "عنوان",
                        align: "center",
                        autoFitWidth: true,
                        filterOperator: "iContains",
                    },
                    {
                        name: "category.titleFa",
                        title: "<spring:message code="category"/>",
                        align: "center"
                    },
                    {
                        name: "subCategory.titleFa",
                        title: "<spring:message code="subcategory"/>",
                        align: "center"
                    },
                    {
                        name: "competenceType.title",
                        title: "نوع",
                        align: "center",
                    },
                ];
                showDetailViewer("جزئیات شایستگی", fields, JSON.parse(resp.data).response.data[0]);
            }));
        }
    });
    let ListGrid_SkillAll_JspNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_SkillAll_JspNeedsAssessment",
        dataSource: RestDataSource_Skill_JspNeedsAssessment,
        autoFetchData: false,
        // selectionAppearance: "checkbox",
        // showRowNumbers: false,
        // showHeaderContextMenu: false,
        selectionType:"single",
        fields: [
            {name: "code"},
            {name: "titleFa"},
            {name: "category.titleFa"},
            {name: "subCategory.titleFa"},
            {name: "skillLevel.titleFa"},
            {name: "course.titleFa"},
            {name: "course.code"}
        ],
        gridComponents: [
            isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="skills.list"/>" + "</b></span>", customEdges: ["T"]}),
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
        },
        getCellCSSText: function (record) {
            if(record.course === undefined){
                return "color : red";
            }
        },
    });
    let ListGrid_Knowledge_JspNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_Knowledge_JspNeedsAssessment",
        autoFetchData:false,
        dataSource: DataSource_Skill_JspNeedsAssessment,
        showRowNumbers: false,
        selectionType:"single",
        autoSaveEdits:false,
        sortField: 0,
        sortDirection: "descending",
        implicitCriteria:{"needsAssessmentDomainId":108},
        contextMenu: Menu_ListGrid_JspENA,
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa"},
            {name: "objectType"},
            {name: "hasWarning", title: "", type: "image", imageURLPrefix: "", imageURLSuffix: ".gif", showTitle:false},

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
        canAcceptDroppedRecords: true,
        showHoverComponents: true,
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
                        fetchDataDomainsGrid();
                    }
                }
            }
        },
        dataChanged(){
            editing = true;
            this.Super("dataChanged",arguments);
        },
        getCellCSSText(record) {
            return priorityColor(record);
        },
        recordDoubleClick(viewer, record){
            updatePriority_JspEditNeedsAssessment(viewer, record);
        },
        selectionChanged(record, state){
            if(state){
                selectedRecord = record;
            }
        }
    });
    let ListGrid_Ability_JspNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_Ability_JspNeedsAssessment",
        dataSource: DataSource_Skill_JspNeedsAssessment,
        autoFetchData:false,
        showRowNumbers: false,
        contextMenu: Menu_ListGrid_JspENA,
        selectionType:"single",
        sortField: 0,
        sortDirection: "descending",
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa"},
            {name: "objectType"},
            {name: "hasWarning", title: "", type: "image", imageURLPrefix: "", imageURLSuffix: ".gif", showTitle:false},
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
        showHeaderContextMenu: false,
        canAcceptDroppedRecords: true,
        showHoverComponents: true,
        autoSaveEdits:false,
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
                    }
                }
            }
        },
        dataChanged(){
            editing = true;
            this.Super("dataChanged",arguments);
        },
        getCellCSSText: function (record) {
            return priorityColor(record);
        },
        recordDoubleClick(viewer, record){
            updatePriority_JspEditNeedsAssessment(viewer, record);
        },
        selectionChanged(record, state){
            if(state){
                selectedRecord = record;
            }
        }});
    let ListGrid_Attitude_JspNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_Attitude_JspNeedsAssessment",
        dataSource: DataSource_Skill_JspNeedsAssessment,
        showHeaderContextMenu: false,
        showRowNumbers: false,
        autoFetchData:false,
        contextMenu: Menu_ListGrid_JspENA,
        selectionType:"single",
        sortField: 0,
        sortDirection: "descending",
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa"},
            {name: "objectType"},
            {name: "hasWarning", type: "image", imageURLPrefix: "", imageURLSuffix: ".gif", showTitle:false},
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
        //         if (record.objectType == DynamicForm_JspEditNeedsAssessment.getValue("objectType")) {
        //             return true;
        //         }
        //     }
        //     return false;
        // },
        getCellCSSText: function (record) {
            return priorityColor(record);
        },
        recordDoubleClick(viewer, record){
            updatePriority_JspEditNeedsAssessment(viewer, record);
        },
        selectionChanged(record, state){
            if(state){
                selectedRecord = record;
            }
        }});
    let Window_AddCompetence = isc.Window.create({
        title: "<spring:message code="competence.list"/>",
        width: "80%",
        height: "70%",
        keepInParentRect: true,
        isModal: false,
        autoSize: false,
        items: [
            isc.TrVLayout.create({
                members: [
                    ListGrid_AllCompetence_JspNeedsAssessment,
                    ListGrid_NeedsAssessment_JspENA
                ]
            })],
        show(){
            this.Super("show", arguments);
            let criteria = {
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [{fieldName: "workFlowStatusCode", operator: "equals", value: 2}]
            }
            ListGrid_AllCompetence_JspNeedsAssessment.setImplicitCriteria(criteria);
            ListGrid_AllCompetence_JspNeedsAssessment.fetchData();
        }
    });

    let DynamicForm_JspEditNeedsAssessment = isc.DynamicForm.create({
        ID: "DynamicForm_JspEditNeedsAssessment",
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
                pickListProperties: {
                    showFilterEditor: false,
                    autoFitWidthApproach: "both",
                },
                changed: function (form, item, value, oldValue) {
                    if(value !== oldValue) {
                        updateObjectIdLG(form, value);
                        clearAllGrid();
                        form.getItem("objectId").clearValue();
                        Label_PlusData_JspNeedsAssessment.setContents("");
                        // refreshPersonnelLG();
                    }
                },
            },
            {
                name: "objectId",
                showTitle: false,
                optionDataSource: JobDs_needsAssessment,
                editorType: "ComboBoxItem",
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["code","titleFa"],
                autoFetchData: false,
                textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    autoFitWidthApproach: "both",
                },
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
                        editNeedsAssessmentRecord(DynamicForm_JspEditNeedsAssessment.getValue("objectId"), DynamicForm_JspEditNeedsAssessment.getValue("objectType"));
                        // refreshPersonnelLG();
                        updateLabelEditNeedsAssessment(item.getSelectedRecord());
                    }
                },
            },
            // {name: "btnCourseDetail", type:"Button", title:"جزئیات دوره", startRow: false},
        ]
    });
    let DynamicForm_CopyOf_JspEditNeedsAssessment = isc.DynamicForm.create({
        ID: "DynamicForm_CopyOf_JspEditNeedsAssessment",
        margin: 10,
        numCols: 2,
        fields: [
            {
                name: "objectType",
                showTitle: false,
                optionDataSource: NeedsAssessmentTargetDS_needsAssessment,
                valueField: "code",
                displayField: "title",
                defaultValue: "Job",
                autoFetchData: false,
                pickListProperties: {
                    showFilterEditor: false,
                    autoFitWidthApproach: "both",
                },
                pickListFields: [{name: "title"}],
                defaultToFirstOption: true,
                changed: function (form, item, value, oldValue) {
                    if(value !== oldValue) {
                        updateObjectIdLG(form, value);
                        form.getItem("objectId").clearValue();
                    }
                },
            },
            {
                name: "objectId",
                showTitle: false,
                optionDataSource: JobDs_needsAssessment,
                editorType: "ComboBoxItem",
                valueField: "id",
                width: 500,
                displayField: "titleFa",
                filterFields: ["code","titleFa"],
                textMatchStyle: "substring",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: false,
                    autoFitWidthApproach: "both",
                },
                pickListFields: [
                    {name: "titleFa", title: "<spring:message code="title"/>"},
                    {name: "code", title: "<spring:message code="code"/>"}
                ],
                click: function(form, item){
                    item.fetchData();
                },
                changed: function (form, item, value, oldValue) {
                    if(value !== oldValue){
                    }
                },
            },
            {
                title: "تایید",
                colSpan: 2,
                width:100,
                type:"Button",
                align: "center",
                click(){
                    Menu_JspEditNeedsAssessment.hideContextMenu();
                    let url = needsAssessmentUrl + "/copy/" + DynamicForm_CopyOf_JspEditNeedsAssessment.getValue("objectType")
                        + "/" + DynamicForm_CopyOf_JspEditNeedsAssessment.getValue("objectId") + "/" + DynamicForm_JspEditNeedsAssessment.getValue("objectType")
                        + "/" + DynamicForm_JspEditNeedsAssessment.getValue("objectId");
                    wait.show();
                    isc.RPCManager.sendRequest(TrDSRequest(url, "GET", null,(resp)=>{
                        wait.close();
                        if(resp.data === "true"){
                            editNeedsAssessmentRecord(DynamicForm_JspEditNeedsAssessment.getValue("objectId"), DynamicForm_JspEditNeedsAssessment.getValue("objectType"))
                            hasChanged = true;
                        }
                        else if(resp.data === "false"){
                            readOnly(true);
                        }
                    }));
                }
            }
        ]
    });

    let Menu_JspEditNeedsAssessment = isc.Menu.create({
        // ID: "menu",
        // title:"کپی از",
        // autoDraw: false,
        // showShadow: true,
        // width: 505,
        // height: 440,
        // borderRadius: 5,
        margin: 1,
        data:[
            {
                // title: "Edit",
                // showRollOver: false,
                embeddedComponent: isc.TrVLayout.create({
                    // autoDraw: false,
                    // height: "100%",
                    // snapTo: "TR",
                    // membersMargin: 3,
                    // layoutRightMargin: 3,
                    // defaultLayoutAlign: "center",
                    members: [
                        DynamicForm_CopyOf_JspEditNeedsAssessment
                    ]
                }),
                // embeddedComponentFields: ["key"]
            },
        ]
    });
    let Button_CopyOf_JspEditNeedsAssessment = isc.MenuButton.create({
        // ID: "menuButton",
        // autoDraw: false,
        // height:20,
        baseStyle: "toolStripButton",
        borderRadius: 5,
        title: "کپی نیازسنجی از",
        titleAlign: "center",
        width: 120,
        menu: Menu_JspEditNeedsAssessment
    });
    let HLayout_Label_PlusData_JspNeedsAssessment = isc.TrHLayout.create({
        height: "1%",
        padding:2,
        members: [
            Button_CourseDetail_JspEditNeedsAssessment,
            Button_CopyOf_JspEditNeedsAssessment,
            Button_changeShow_JspEditNeedsAssessment,
            Label_PlusData_JspNeedsAssessment,
        ],
    });
    let HLayout_Bottom = isc.TrHLayout.create({
        members: [
            isc.TrVLayout.create({
                width: "25%",
                showResizeBar: true,
                members: [ListGrid_Competence_JspNeedsAssessment]
            }),
            isc.TrVLayout.create({
                ID: "VLayoutLeft_JspEditNeedsAssessment",
                // width: "75%",
                members: [
                    isc.TrHLayout.create({
                        ID: "HLayoutCenter_JspEditNeedsAssessment",
                        height: "70%",
                        showResizeBar: true,
                        members: [
                            ListGrid_Knowledge_JspNeedsAssessment,
                            ListGrid_Ability_JspNeedsAssessment,
                            ListGrid_Attitude_JspNeedsAssessment
                        ]
                    }),
                    Label_Help_JspNeedsAssessment,
                    ListGrid_SkillAll_JspNeedsAssessment
                ]
            }),
        ]
    });

    isc.TrVLayout.create({
        members: [
            DynamicForm_JspEditNeedsAssessment,
            HLayout_Label_PlusData_JspNeedsAssessment,
            HLayout_Bottom,
            ToolStrip_JspNeedsAssessment],
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
            case 'TrainingPost':
                form.getItem("objectId").optionDataSource = PostDS_TrainingPost;
                form.getItem("objectId").pickListFields = [
                    {name: "code", keyPressFilter: false}, {name: "titleFa"}, {name: "job.titleFa"}, {name: "postGrade.titleFa"}, {name: "area"}, {name: "assistance"}, {name: "affairs"},
                    {name: "section"}, {name: "unit"}, {name: "costCenterCode"}, {name: "costCenterTitleFa"}
                ];
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
    function removeRecord_JspNeedsAssessment(record, state=0) {
        if(record.objectType === DynamicForm_JspEditNeedsAssessment.getValue("objectType")){
            // isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/" + record.id + "?isFirstChange=" + isFirstChange, "DELETE", null, function (resp) {
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/" + record.id + "/" + record.objectType + "/" + record.objectId , "DELETE", null, function (resp) {
                wait.close();
                if (resp.httpResponseCode === 409) {
                    createDialog("info", resp.httpResponseText);
                    return 0;
                } else if (resp.httpResponseCode !== 200) {
                    createDialog("info","خطا در حذف مهارت");
                    return 0;
                }
                DataSource_Skill_JspNeedsAssessment.removeData(record);
                hasChanged = true;
                return 1;
            }));
        }
        else{
            if(state === 0) {
                createDialog("info", "فقط نیازسنجی های با مرجع " +'<u><b>'+ priorityList[DynamicForm_JspEditNeedsAssessment.getValue("objectType")] +'</u></b>'+ " قابل حذف است.")
            }
            return 2;
        }
    }

    function editNeedsAssessmentRecord(objectId, objectType) {
        updateObjectIdLG(DynamicForm_JspEditNeedsAssessment, objectType);
        clearAllGrid();
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/editList/" + objectType + "/" + objectId, "GET", null, function(resp){
            wait.close();
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
                skill.skill = data[i].skill;
                skill.mainWorkflowStatus = data[i].mainWorkflowStatus;
                if(data[i].skill.course === undefined){
                    skill.hasWarning = "alarm";
                }
                else {
                    skill.course = data[i].skill.course;
                }
                DataSource_Skill_JspNeedsAssessment.addData(skill);
                if( flags[data[i].competenceId]) continue;
                flags[data[i].competenceId] = true;
                // outPut.push(data[i].competenceId);
                competence.id = data[i].competenceId;
                competence.title = data[i].competence.title;
                competence.competenceType = data[i].competence.competenceType;
                competence.categoryId = data[i].competence.categoryId;
                competence.subCategoryId = data[i].competence.subCategoryId;
                competence.code = data[i].competence.code;
                DataSource_Competence_JspNeedsAssessment.addData(competence, ()=>{ListGrid_Competence_JspNeedsAssessment.selectRecord(0)});
            }
            ListGrid_Competence_JspNeedsAssessment.fetchData();
            ListGrid_Competence_JspNeedsAssessment.emptyMessage = "<spring:message code="msg.no.records.for.show"/>";
            DynamicForm_JspEditNeedsAssessment.setValue("objectId", objectId);
            DynamicForm_JspEditNeedsAssessment.setValue("objectType", objectType);
            fetchDataDomainsGrid();
        }))
    }

    function createNeedsAssessmentRecords(data) {
        if(data === null){
            return;
        }
        if(!checkSaveData(data, DataSource_Skill_JspNeedsAssessment)){
            createDialog("info", "<spring:message code="exception.duplicate.information"/>", "<spring:message code="error"/>");
            return;
        }
        // isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "?isFirstChange=" + isFirstChange, "POST", JSON.stringify(data),function(resp){
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl, "POST", JSON.stringify(data),function(resp){
            wait.close()
            if (resp.httpResponseCode === 409) {
                createDialog("info", resp.httpResponseText);
                return 0;
            }
            else if(resp.httpResponseCode === 408){
                createDialog("warning", JSON.parse(resp.httpResponseText).message)
                return;
            }
            else if (resp.httpResponseCode !== 200){
                createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                return;
            }
            data.id = JSON.parse(resp.data).id;
            DataSource_Skill_JspNeedsAssessment.addData(data);
            hasChanged = true;
            fetchDataDomainsGrid();
        }))
    }
    function createData_JspNeedsAssessment(record, DomainId, PriorityId = 111) {
        if(record.skillLevelId === 1 && DomainId !== 108){
            createDialog("info", "مهارت با سطح مهارت آشنایی فقط در حیطه دانشی قرار میگیرد.");
            return null;
        }
        if(record.skillLevelId === 2 && DomainId !== 109){
            createDialog("info", "مهارت با سطح مهارت توانایی فقط در حیطه توانشی قرار میگیرد.");
            return null;
        }
        let data = {
            objectType: DynamicForm_JspEditNeedsAssessment.getValue("objectType"),
            objectId: DynamicForm_JspEditNeedsAssessment.getValue("objectId"),
            objectName: DynamicForm_JspEditNeedsAssessment.getItem("objectId").getSelectedRecord().titleFa,
            objectCode: DynamicForm_JspEditNeedsAssessment.getItem("objectId").getSelectedRecord().code,
            competenceId: ListGrid_Competence_JspNeedsAssessment.getSelectedRecord().id,
            skillId: record.id,
            titleFa: record.titleFa,
            needsAssessmentPriorityId: PriorityId,
            needsAssessmentDomainId: DomainId,
            hasWarning: record.course ? "" : "alarm",
            course: record.course,
            skill: record
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
        if(DynamicForm_JspEditNeedsAssessment.getValue("objectType") === "Post" || DynamicForm_JspEditNeedsAssessment.getValue("objectType") === "TrainingPost") {
            Label_PlusData_JspNeedsAssessment.setContents(
                (objectId.titleFa !== undefined ? '<b>عنوان پست: </b>' +  objectId.titleFa : "")
                + "&nbsp;&nbsp;&nbsp;&nbsp;" +
                (objectId.area !== undefined ? "<b>حوزه: </b>" + objectId.area : "")
                + "&nbsp;&nbsp;&nbsp;&nbsp;" +
                (objectId.assistance !== undefined ? "<b>معاونت: </b>" + objectId.assistance : "")
                + "&nbsp;&nbsp;&nbsp;&nbsp;" +
                (objectId.affairs !== undefined ? "<b>واحد: </b>" + objectId.affairs : "")
            );
        }
    }
    function updatePriority_JspEditNeedsAssessment(viewer, record) {
        if(record.objectType === DynamicForm_JspEditNeedsAssessment.getValue("objectType")) {
            let updating = {objectType: record.objectType, objectId: record.objectId, needsAssessmentPriorityId: record.needsAssessmentPriorityId + 1 > 113 ? 111 : record.needsAssessmentPriorityId + 1};
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/" + record.id, "PUT", JSON.stringify(updating), function (resp) {
                wait.close()
                if (resp.httpResponseCode === 409) {
                    createDialog("info", resp.httpResponseText);
                    return 0;
                } else if (resp.httpResponseCode !== 200) {
                    createDialog("info", "<spring:message code='error'/>");
                    return;
                }
                record.needsAssessmentPriorityId = record.needsAssessmentPriorityId + 1 > 113 ? 111 : record.needsAssessmentPriorityId + 1;
                DataSource_Skill_JspNeedsAssessment.updateData(record);
                hasChanged = true;
                viewer.endEditing();
            }));
        }
        else{
            createDialog("info","فقط نیازسنجی های مرتبط با "+priorityList[DynamicForm_JspEditNeedsAssessment.getValue("objectType")]+" قابل تغییر است.")
        }
    }
    function priorityColor(record){
        switch (record.needsAssessmentPriorityId) {
            case 111:
                return "background-color : " + red;
            case 112:
                return "background-color : " + yellow;
            case 113:
                return "background-color : " + green;
        }
    }

    let ListGrid_SkillAll_JspNeedsAssessment_Refresh = ()=>{
            let record = ListGrid_Competence_JspNeedsAssessment.getSelectedRecord();
            if(record == null){
                ListGrid_SkillAll_JspNeedsAssessment.setData([]);
            }else{
                let cr = {};
                if(record.subCategoryId != null) {
                    cr = {
                        _constructor: "AdvancedCriteria",
                        operator: "and",
                        criteria: [
                            {fieldName: "subCategoryId", operator: "equals", value: record.subCategoryId},
                        ]
                    }
                }
                ListGrid_SkillAll_JspNeedsAssessment.setImplicitCriteria(cr);
                ListGrid_SkillAll_JspNeedsAssessment.invalidateCache();
                ListGrid_SkillAll_JspNeedsAssessment.fetchData();
            }
    }


    function loadEditNeedsAssessment(objectId, type, state = "R&W") {
        if (ListGrid_SkillAll_JspNeedsAssessment) {
            ListGrid_SkillAll_JspNeedsAssessment.clearFilterValues();
        }

        if(state === "read"){
            DynamicForm_JspEditNeedsAssessment.disable()
        }
        else {
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/isReadOnly/" + type + "/" + objectId.id, "GET", null, (resp) => {
                wait.close();
                if(resp.httpResponseCode !== 200){
                    if (JSON.parse(resp.httpResponseText).errors && JSON.parse(resp.httpResponseText).errors.size() > 0) {
                        createDialog("info", JSON.parse(resp.httpResponseText).errors[0].field);
                        buttonSendToWorkFlow.disable();
                        buttonChangeCancel.disable();
                        return;
                    }
                    createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                    return;
                }
                updateObjectIdLG(DynamicForm_JspEditNeedsAssessment, type);
                DynamicForm_JspEditNeedsAssessment.setValue("objectType", type);
                DynamicForm_JspEditNeedsAssessment.setValue("objectId", objectId.id);
                clearAllGrid();
                editNeedsAssessmentRecord(objectId.id, type);
                // refreshPersonnelLG(objectId);
                updateLabelEditNeedsAssessment(objectId);
                if(resp.data === "true"){
                    readOnly(true);
                }
                else{
                    readOnly(false);
                }
            }))
        }
    }
    function readOnly(status){
        if(status === true){
            buttonSendToWorkFlow.disable();
            buttonChangeCancel.disable();
            DynamicForm_JspEditNeedsAssessment.disable();
            CompetenceTS_needsAssessment.disable();
            ListGrid_Knowledge_JspNeedsAssessment.disable();
            ListGrid_Ability_JspNeedsAssessment.disable();
            ListGrid_Attitude_JspNeedsAssessment.disable();
            Button_changeShow_JspEditNeedsAssessment.show();
            Button_CopyOf_JspEditNeedsAssessment.hide();
            ToolStrip_JspNeedsAssessment.disable();
            createDialog("info", "<spring:message code='read.only.na.message'/>");
        }
        else{
            buttonSendToWorkFlow.enable();
            buttonChangeCancel.enable();
            DynamicForm_JspEditNeedsAssessment.enable();
            CompetenceTS_needsAssessment.enable();
            ListGrid_Knowledge_JspNeedsAssessment.enable();
            ListGrid_Ability_JspNeedsAssessment.enable();
            ListGrid_Attitude_JspNeedsAssessment.enable();
            Button_CopyOf_JspEditNeedsAssessment.show();
            ToolStrip_JspNeedsAssessment.enable();
            Button_changeShow_JspEditNeedsAssessment.hide();
        }

    }

    function isReadOnly(id, type){
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/isReadOnly/" + type + "/" + id, "GET", null, (resp) => {
            wait.close();
            if (resp.httpResponseCode !== 200) {
                createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                return true;
            }
            return resp.data === "true";
        }))
    }

    // <<---------------------------------------- Send To Workflow ----------------------------------------
    function sendNeedsAssessmentToWorkflow() {
        if(hasChanged){
            isc.MyYesNoDialog.create({
                message: "<spring:message code="needs.assessment.sent.to.workflow.ask"/>",
                title: "<spring:message code="message"/>",
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        let varParams = [{
                            "processKey": "needAssessment_MainWorkflow",
                            "cId": DynamicForm_JspEditNeedsAssessment.getValue("objectId"),
                            "objectName": "تغییر نیازسنجی " + priorityList[DynamicForm_JspEditNeedsAssessment.getValue("objectType")] + " : " + DynamicForm_JspEditNeedsAssessment.getItem("objectId").getSelectedRecord().titleFa + ( DynamicForm_JspEditNeedsAssessment.getItem("objectId").getSelectedRecord().code !== undefined ? " با کد : " + DynamicForm_JspEditNeedsAssessment.getItem("objectId").getSelectedRecord().code: ""),
                            "objectType": priorityList[DynamicForm_JspEditNeedsAssessment.getValue("objectType")],
                            "needAssessmentCreatorId": "${username}",
                            "needAssessmentCreator": userFullName,
                            "REJECTVAL": "",
                            "REJECT": "",
                            "target": "/course/show-form",
                            "targetTitleFa": "نیازسنجی",
                            "workflowStatus": "ثبت اولیه",
                            "workflowStatusCode": "0",
                            "workFlowName": "NeedAssessment",
                            "cType": DynamicForm_JspEditNeedsAssessment.getValue("objectType")
                        }];
                        wait.show();
                        isc.RPCManager.sendRequest(TrDSRequest(workflowUrl + "/startProcess", "POST", JSON.stringify(varParams), startProcess_callback));

                    }
                }
            });
        }
        else{
            createDialog("info","تغییری صورت نگرفته است")
        }
    }

    function startProcess_callback(resp) {
        wait.close()
        if (resp.httpResponseCode === 200) {
            simpleDialog("<spring:message code="message"/>", "<spring:message code='course.set.on.workflow.engine'/>", 3000, "say");
            Window_NeedsAssessment_Edit.close(0);
        } else if (resp.httpResponseCode === 404) {
            simpleDialog("<spring:message code="message"/>", "<spring:message code='workflow.bpmn.not.uploaded'/>", 3000, "stop");
        } else {
            simpleDialog("<spring:message code="message"/>", "<spring:message code='msg.send.to.workflow.problem'/>", 3000, "stop");
        }
    }

    // ---------------------------------------- Send To Workflow ---------------------------------------->>

    // </script>
