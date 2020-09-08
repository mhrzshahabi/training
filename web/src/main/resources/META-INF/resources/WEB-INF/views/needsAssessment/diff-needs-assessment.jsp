<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>

    // var view_ENA = null;
    isc.defineClass("NaLG", TrLG);
    isc.NaLG.addProperties({
        sortField: 1,
    });
    const yellow ="#d6d216";
    const red = "#ff8abc";
    const green = "#5dd851";
    var editing = false;

    var skillTopData = [];
    var skillBottomData = [];
    var competenceTopData = [];
    var competenceBottomData = [];
    let oLoadAttachments_Job = null;

    let NeedsAssessmentTargetDS_DiffNeedsAssessment = isc.TrDS.create({
        ID: "NeedsAssessmentTargetDS_DiffNeedsAssessment",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
            {name: "code", title: "<spring:message code="code"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: parameterValueUrl + "/iscList/103",

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
    let JobDs_diffNeedsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: jobUrl + "/spec-list"
    });
    let JobGroupDs_diffNeedsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: jobGroupUrl + "iscList"
    });
    let PostDs_diffNeedsAssessment = isc.TrDS.create({
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
    let PostGroupDs_diffNeedsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: postGroupUrl + "/spec-list"
    });
    let PostGradeDs_diffNeedsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: postGradeUrl + "/spec-list"
    });
    let PostGradeGroupDs_diffNeedsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code='title'/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: postGradeGroupUrl + "spec-list"
    });
    var RestDataSource_Skill_Top_JspDiffNeedsAssessment = isc.TrDS.create({
        ID: "RestDataSource_Skill_Top_JspDiffNeedsAssessment",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="skill.code"/>", filterOperator: "iContains"},
            {name: "titleFa", title: "<spring:message code="skill"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true},
            {name: "category.titleFa", title: "<spring:message code="category"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true},
            {name: "subCategory.titleFa", title: "<spring:message code="subcategory"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true},
            {name: "skillLevel.titleFa", title: "<spring:message code="skill.level"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true},
            {name: "course.titleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true},
            {name: "course.code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true}
        ],
        fetchDataURL: skillUrl + "/spec-list"
    });
    var RestDataSource_NeedsAssessmentPriority_JspDiffNeedsAssessment = isc.TrDS.create({
        fields:[
            {name: "id", primaryKey:true},
            {name:"code"},
            {name:"title"}
        ],
        fetchDataURL: parameterValueUrl + "/iscList?operator=and&_constructor=AdvancedCriteria&criteria={\"fieldName\":\"parameter.code\",\"operator\":\"equals\",\"value\":\"NeedsAssessmentPriority\"}"
    });
    var RestDataSource_Competence_JspDiffNeedsAssessment = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceType.title", title: "<spring:message code="type"/>", filterOperator: "iContains",},
        ],
        fetchDataURL: competenceUrl + "/iscList",
    });
    var RestDataSource_Course_JspENA = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code", title: "<spring:message code="skill.code"/>", filterOperator: "iContains"},
            {name: "titleFa", title: "<spring:message code="skill"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true},
            <%--{name: "category.titleFa", title: "<spring:message code="category"/>", filterOperator: "iContains"},--%>
            <%--{name: "subCategory.titleFa", title: "<spring:message code="subcategory"/>", filterOperator: "iContains"},--%>
            <%--{name: "skillLevel.titleFa", title: "<spring:message code="skill.level"/>", filterOperator: "iContains"},--%>
            {name: "course.titleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains"},
            {name: "course.code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true},
            {name: "course.theoryDuration", title: "<spring:message code="duration"/>", filterOperator: "iContains"}
            <%--{name: "scoringMethod"},--%>
            <%--{name: "acceptancelimit"},--%>
            <%--{name: "startEvaluation"},--%>
            <%--{--%>
                <%--name: "code",--%>
                <%--title: "<spring:message code="course.code"/>",--%>
                <%--filterOperator: "iContains",--%>
                <%--autoFitWidth: true--%>
            <%--},--%>
            <%--{name: "titleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains"},--%>
            <%--{name: "createdBy", title: "<spring:message code="created.by.user"/>", filterOperator: "iContains"},--%>
            <%--{name: "theoryDuration"},--%>
            <%--{name: "categoryId"},--%>
            // {name: "subCategoryId"},
        ],
        fetchDataURL: skillUrl + "/WFC/spec-list"

    });
    var RestDataSource_category_JspDiff = isc.TrDS.create({
        ID: "categoryDS_Diff",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: categoryUrl + "spec-list",
    });
    var RestDataSource_subCategory_JspDiff = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: subCategoryUrl + "spec-list",
    });
    var DataSource_Competence_Top_JspDiffNeedsAssessment = isc.DataSource.create({
        clientOnly: true,
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceType.title", title: "<spring:message code="type"/>", filterOperator: "iContains",},
        ],
        testData: competenceTopData,
        // fetchDataURL: competenceUrl + "/iscList",
    });
    var DataSource_Competence_Bottom_JspDiffNeedsAssessment = isc.DataSource.create({
        clientOnly: true,
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceType.title", title: "<spring:message code="type"/>", filterOperator: "iContains",},
        ],
        testData: competenceBottomData,
        // fetchDataURL: competenceUrl + "/iscList",
    });
    var DataSource_Skill_Top_JspDiffNeedsAssessment = isc.DataSource.create({
        ID: "DataSource_Skill_Top_JspDiffNeedsAssessment",
        fields: [
            {name: "id", hidden:true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains",
                showHover:true,
                canEdit: false,
                hoverWidth: 250,
                    hoverHTML(record) {
                    return record.course ? "نام مهارت: " + record.titleFa + "<br>" + "نام دوره: " + record.course.titleFa + "<br>" + "کد دوره: " + record.course.code : "نام مهارت: " + record.titleFa;
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
                // sortNormalizer(record){
                //     if(record.objectType === type){
                //         return 0;
                //     }
                //     return 1;
                // }
            },
            {name: "objectName"},
            {name: "objectCode"},
            {name: "course"},
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
        testData: skillTopData,
        clientOnly: true,
    });
    var DataSource_Skill_Bottom_JspDiffNeedsAssessment = isc.DataSource.create({
        ID: "DataSource_Skill_Bottom_JspDiffNeedsAssessment",
        fields: [
            {name: "id", hidden:true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains",
                showHover:true,
                canEdit: false,
                hoverWidth: 250,
                    hoverHTML(record) {
                    return record.course ? "نام مهارت: " + record.titleFa + "<br>" + "نام دوره: " + record.course.titleFa + "<br>" + "کد دوره: " + record.course.code : "نام مهارت: " + record.titleFa;
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
                // sortNormalizer(record){
                //     if(record.objectType === DynamicForm_JspEditNeedsAssessment.getValue("objectType")){
                //         return 0;
                //     }
                //     return 1;
                // }
            },
            {name: "objectName"},
            {name: "objectCode"},
            {name: "course"},
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
        testData: skillBottomData,
        clientOnly: true,
    });

    let CompetenceTS_diffNeedsAssessment = isc.ToolStrip.create({
        ID: "CompetenceTS_diffNeedsAssessment",
        members: [
            // isc.ToolStripButtonRefresh.create({
            //     click: function () { refreshLG(ListGridTop_Competence_JspDiffNeedsAssessment); }
            // }),
            isc.ToolStripButtonAdd.create({
                title:"افزودن",
                click: function () {
                    if(NeedsAssessmentTargetDF_diffNeedsAssessment.getValue("objectId")!=null) {
                        ListGrid_AllCompetence_JspDiffNeedsAssessment.fetchData();
                        ListGrid_AllCompetence_JspDiffNeedsAssessment.invalidateCache();
                        Window_AddCompetence.show();
                    }
                    else {
                        createDialog("info","<spring:message code='msg.no.records.selected'/>");
                    }
                }
            }),
            // isc.ToolStripButtonCreate.create({click: function () { createCompetence_competence(); }}),
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "CompetenceLGCount_diffNeedsAssessment"}),
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
            ListGrid_Course_JspENA.invalidateCache();
            ListGrid_Course_JspENA.fetchData(criteria);
            this.Super("show", arguments);
        },
        items: [
            isc.TrHLayout.create({
                members: [
                    isc.TrLG.create({
                        ID: "ListGrid_Course_JspENA",
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
                                optionDataSource: RestDataSource_category_JspDiff,
                                filterOnKeypress: true,
                                valueField: "id",
                                displayField: "titleFa",
                                filterOperator: "equals",
                            },
                            {
                                name: "course.subCategoryId",
                                title: "<spring:message code="subcategory"/> <spring:message code="course"/>",
                                optionDataSource: RestDataSource_subCategory_JspDiff,
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

    var Label_PlusData_JspDiffNeedsAssessment = isc.LgLabel.create({
        align:"left",
        contents:"",
        margin:8,
        customEdges: []});
    var Label_Help_JspDiffNeedsAssessment = isc.LgLabel.create({
        align:"left",
        // contents:"<span>.اولویت ضروری با رنگ قرمز، اولویت بهبود با رنگ زرد و اولویت توسعه با رنگ سبز مشخص شده اند<span/>",
        contents:getFormulaMessage("اولویت : ", "2", "#020404", "b")+getFormulaMessage("عملکردی ضروری", "2", red, "b")+" *** "+getFormulaMessage("عملکردی بهبود", "2", yellow, "b")+" *** "+getFormulaMessage("توسعه ای", "2", green, "b"),
        customEdges: []});
    var Button_CourseDetail_JspDiffNeedsAssessment = isc.Button.create({
        title:"جزئیات دوره",
        margin: 1,
        click(){
           if(ListGridTop_Knowledge_JspDiffNeedsAssessment.getSelectedRecord()||ListGridTop_Ability_JspDiffNeedsAssessment.getSelectedRecord()
               ||ListGridTop_Attitude_JspDiffNeedsAssessment.getSelectedRecord()||ListGrid_SkillAll_JspDiffNeedsAssessment.getSelectedRecord()
               ||ListGridBottom_Knowledge_JspDiffNeedsAssessment.getSelectedRecord()||ListGridBottom_Ability_JspDiffNeedsAssessment.getSelectedRecord()
               ||ListGridBottom_Attitude_JspDiffNeedsAssessment.getSelectedRecord()||ListGrid_SkillAll_JspDiffNeedsAssessment.getSelectedRecord()
           ){
               let skillIds = [];
               if(ListGridTop_Knowledge_JspDiffNeedsAssessment.getSelectedRecord()!= undefined && ListGridTop_Knowledge_JspDiffNeedsAssessment.getSelectedRecord().course != undefined) {
                   skillIds.push(ListGridTop_Knowledge_JspDiffNeedsAssessment.getSelectedRecord().skillId);
               }
               if(ListGridTop_Ability_JspDiffNeedsAssessment.getSelectedRecord()!= undefined && ListGridTop_Ability_JspDiffNeedsAssessment.getSelectedRecord().course!= undefined) {
                   skillIds.push(ListGridTop_Ability_JspDiffNeedsAssessment.getSelectedRecord().skillId);
               }
               if(ListGridTop_Attitude_JspDiffNeedsAssessment.getSelectedRecord()!= undefined && ListGridTop_Attitude_JspDiffNeedsAssessment.getSelectedRecord().course!= undefined) {
                   skillIds.push(ListGridTop_Attitude_JspDiffNeedsAssessment.getSelectedRecord().skillId);
               }

               if(ListGridBottom_Knowledge_JspDiffNeedsAssessment.getSelectedRecord()!= undefined && ListGridBottom_Knowledge_JspDiffNeedsAssessment.getSelectedRecord().course != undefined) {
                   skillIds.push(ListGridBottom_Knowledge_JspDiffNeedsAssessment.getSelectedRecord().skillId);
               }
               if(ListGridBottom_Ability_JspDiffNeedsAssessment.getSelectedRecord()!= undefined && ListGridBottom_Ability_JspDiffNeedsAssessment.getSelectedRecord().course!= undefined) {
                   skillIds.push(ListGridBottom_Ability_JspDiffNeedsAssessment.getSelectedRecord().skillId);
               }
               if(ListGridBottom_Attitude_JspDiffNeedsAssessment.getSelectedRecord()!= undefined && ListGridBottom_Attitude_JspDiffNeedsAssessment.getSelectedRecord().course!= undefined) {
                   skillIds.push(ListGridBottom_Attitude_JspDiffNeedsAssessment.getSelectedRecord().skillId);
               }
               if(ListGrid_SkillAll_JspDiffNeedsAssessment.getSelectedRecord()!= undefined && ListGrid_SkillAll_JspDiffNeedsAssessment.getSelectedRecord().course!= undefined) {
                   skillIds.push(ListGrid_SkillAll_JspDiffNeedsAssessment.getSelectedRecord().id);
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
    // var Button_CancelChange_JspDiffNeedsAssessment = isc.Button.create({
    //     title:"لغو تغییرات",
    //     margin: 1,
    //     click(){
    //
    //     }
    // });
    var Button_AddSkill_JspDiffNeedsAssessment = isc.Button.create({
        title:"مهارت ها",
        margin: 1,
        click(){
            Window_AddSkill_Diff.show();
        }
    });
    var Button_ShowAttachment_JspDiffNeedsAssessment = isc.Button.create({
        title:"ضمیمه",
        margin: 1,
        click(){
            if (!loadjs.isDefined('load_Attachments_Job')) {
                loadjs('<spring:url value='tclass/attachments-tab' />', 'load_Attachments_Job');
            }

            loadjs.ready('load_Attachments_Job', function () {
                setTimeout(()=>{
                    oLoadAttachments_Job = new loadAttachments();
                    // DetailTab_Job.updateTab(JobAttachmentsTab, oLoadAttachments_Job.VLayout_Body_JspAttachment)
                    if (typeof oLoadAttachments_Job.loadPage_attachment_Job!== "undefined")
                        oLoadAttachments_Job.loadPage_attachment_Job(NeedsAssessmentTargetDF_diffNeedsAssessment.getValue("objectType"), NeedsAssessmentTargetDF_diffNeedsAssessment.getValue("objectId"), "<spring:message code="attachment"/>", {
                            1: "جزوه",
                            2: "لیست نمرات",
                            3: "لیست حضور و غیاب",
                            4: "نامه غیبت موجه"
                        }, false);
                    let Window_Attach = isc.Window.create({
                        title: "ضمیمه",
                        autoSize: false,
                        width: "70%",
                        height:"60%",
                        items:[
                            oLoadAttachments_Job.VLayout_Body_JspAttachment,
                            // isc.TrHLayoutButtons.create({
                            //     members:[
                            //         isc.IButton.create({
                            //             title:"ارسال شماره نامه",
                            //             click:function () {
                            //                 if(ListGrid_JspAttachment.getSelectedRecord() == undefined){
                            //                     createDialog("info", "لطفاً رکوردی را انتخاب نمایید.", "پیغام");
                            //                 }
                            //                 if(trTrim(ListGrid_JspAttachment.getSelectedRecord().description) != null) {
                            //                     return;
                            //                 }
                            //                 createDialog("info", "لطفاً شماره نامه را مشخص نمایید.", "پیغام");
                            //             }
                            //         })
                            //     ]
                            // })
                        ]});
                    Window_Attach.show();
                },0)
            });
            // Window_AddSkill_Diff.show();
        }
    });

    var ListGrid_AllCompetence_JspDiffNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_AllCompetence_JspDiffNeedsAssessment",
        dataSource: RestDataSource_Competence_JspDiffNeedsAssessment,
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
        // selectionUpdated: "ListGridTop_Competence_JspDiffNeedsAssessment.setData(this.getSelection())"
        selectionChanged(record, state) {
            if (state == true) {
                if (checkSaveData_Diff(record, DataSource_Competence_Top_JspDiffNeedsAssessment, "id")) {
                    ListGridTop_Competence_JspDiffNeedsAssessment.transferSelectedData(this);
                    return;
                }
                createDialog("info", "<spring:message code="exception.duplicate.information"/>", "<spring:message code="error"/>");
            }
        }
    });
    var ListGrid_SkillAll_JspDiffNeedsAssessment = isc.TrLG.create({
        ID: "ListGrid_SkillAll_JspDiffNeedsAssessment",
        dataSource: RestDataSource_Skill_Top_JspDiffNeedsAssessment,
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
            {name: "skillLevel.titleFa"},
            {name: "course.titleFa"},
            {name: "course.code"}
        ],
        gridComponents: [
            <%--isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="skills.list"/>" + "</b></span>", customEdges: ["T"]}),--%>
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
    var ListGridTop_Competence_JspDiffNeedsAssessment = isc.TrLG.create({
        ID: "ListGridTop_Competence_JspDiffNeedsAssessment",
        dataSource: DataSource_Competence_Top_JspDiffNeedsAssessment,
        autoFetchData: true,
        selectionType:"single",
        // selectionAppearance: "checkbox",
        showHeaderContextMenu: false,
        showRowNumbers: false,
        border: "1px solid",
        fields: [{name: "title", title: "<spring:message code="title"/>"}, {name: "competenceType.title", title: "<spring:message code="type"/>"}],
        headerHeight: 50,
        headerSpans: [
            {
                fields: ["title", "competenceType.title"],
                title: "<spring:message code="competence.list"/>"
            }],
        gridComponents: [
            isc.LgLabel.create({contents: "<span><h3><b>" + "نیازسنجی تایید نشده" + "</b></h3></span>", customEdges: ["B"]}),
            CompetenceTS_diffNeedsAssessment, "header", "body"
        ],
        canRemoveRecords:true,
        canDragRecordsOut: true,
        dragDataAction: "none",
        removeRecordClick(rowNum){
            let Dialog_Competence_remove = createDialog("ask",  "هشدار: در صورت حذف شایستگی تمام مهارت های با مرجع " + '<b><u>'+priorityList[type]+'</b></u>' + " آن حذف خواهند شد.",
                "<spring:message code="verify.delete"/>");
            Dialog_Competence_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        let data = ListGridTop_Knowledge_JspDiffNeedsAssessment.data.localData.toArray();
                        data.addAll(ListGridTop_Attitude_JspDiffNeedsAssessment.data.localData.toArray());
                        data.addAll(ListGridTop_Ability_JspDiffNeedsAssessment.data.localData.toArray());
                        let hasFather = false;
                        for (let i = 0; i < data.length; i++) {
                            let state = removeRecord_JspDiffNeedsAssessment(data[i], 1);
                            if(state===0){
                                return;
                            }
                            else if(state===2){
                                hasFather = true;
                            }
                        }
                        if(hasFather===false) {
                            DataSource_Competence_Top_JspDiffNeedsAssessment.removeData(this.getRecord(rowNum));
                            ListGridTop_Competence_JspDiffNeedsAssessment.invalidateCache();
                        }
                    }
                }
            });
        },
        dataChanged(){
            editing = true;
            this.Super("dataChanged",arguments);
        },
        selectionUpdated(record){
            fetchDataDomainsTopGrid_diff();
        }
    });
    var ListGridTop_Knowledge_JspDiffNeedsAssessment = isc.NaLG.create({
        ID: "ListGridTop_Knowledge_JspDiffNeedsAssessment",
        autoFetchData:false,
        dataSource: DataSource_Skill_Top_JspDiffNeedsAssessment,
        showRowNumbers: false,
        selectionType:"single",
        autoSaveEdits:false,
        implicitCriteria:{"needsAssessmentDomainId":108},
        fields: [
            {name: "titleFa"},
            {name: "objectType"},
            {name: "hasWarning", title: "", type: "image", imageURLPrefix: "", imageURLSuffix: ".gif", showTitle:false},

            // {
            //     name: "needsAssessmentPriorityId",
            //     canEdit:true,
            //     valueField: "id",
            //     displayField: "title",
            //     optionDataSource: RestDataSource_NeedsAssessmentPriority_JspDiffNeedsAssessment,
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
            removeRecord_JspDiffNeedsAssessment(this.getRecord(rowNum));
        },
        recordDrop(dropRecords, targetRecord, index, sourceWidget) {
            let record = ListGridTop_Competence_JspDiffNeedsAssessment.getSelectedRecord();
            if (checkRecordAsSelected(record, true, "<spring:message code="competence"/>")) {
                if (sourceWidget.ID === 'ListGrid_SkillAll_JspDiffNeedsAssessment') {
                    for (let i = 0; i < dropRecords.length; i++) {
                        createNeedsAssessmentRecords_Diff(createData_JspDiffNeedsAssessment(dropRecords[i], 108));
                        // fetchDataDomainsTopGrid_diff();
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
        //         if (record.objectType === NeedsAssessmentTargetDF_diffNeedsAssessment.getValue("objectType")) {
        //             return true;
        //         }
        //     }
        //     return false;
        // },
        getCellCSSText(record) {
            return priorityColor(record);
        },
        recordDoubleClick(viewer, record){
            updatePriority_JspDiffNeedsAssessment(viewer, record);
        }
    });
    var ListGridTop_Ability_JspDiffNeedsAssessment = isc.NaLG.create({
        ID: "ListGridTop_Ability_JspDiffNeedsAssessment",
        dataSource: DataSource_Skill_Top_JspDiffNeedsAssessment,
        autoFetchData:false,
        showRowNumbers: false,
        selectionType:"single",
        fields: [
            {name: "titleFa"},
            {name: "objectType"},
            {name: "hasWarning", title: "", type: "image", imageURLPrefix: "", imageURLSuffix: ".gif", showTitle:false},
            // {
            //     name: "needsAssessmentPriorityId",
            //     canEdit:true,
            //     valueField: "id",
            //     displayField: "title",
            //     optionDataSource: RestDataSource_NeedsAssessmentPriority_JspDiffNeedsAssessment,
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
            removeRecord_JspDiffNeedsAssessment(this.getRecord(rowNum));
        },
        recordDrop(dropRecords, targetRecord, index, sourceWidget) {
            let record = ListGridTop_Competence_JspDiffNeedsAssessment.getSelectedRecord();
            if (checkRecordAsSelected(record, true, "<spring:message code="competence"/>")) {
                if (sourceWidget.ID === 'ListGrid_SkillAll_JspDiffNeedsAssessment') {
                    for (let i = 0; i < dropRecords.length; i++) {
                        createNeedsAssessmentRecords_Diff(createData_JspDiffNeedsAssessment(dropRecords[i], 109));
                        // DataSource_Skill_Top_JspDiffNeedsAssessment.addData(data);
                        // createNeedsAssessmentRecords_Diff(data);
                        // this.fetchData();
                        // fetchDataDomainsTopGrid_diff();
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
        //         if (record.objectType == NeedsAssessmentTargetDF_diffNeedsAssessment.getValue("objectType")) {
        //             return true;
        //         }
        //     }
        //     return false;
        // },
        getCellCSSText: function (record) {
            return priorityColor(record);
        },
        recordDoubleClick(viewer, record){
            updatePriority_JspDiffNeedsAssessment(viewer, record);
        }
    });
    var ListGridTop_Attitude_JspDiffNeedsAssessment = isc.NaLG.create({
        ID: "ListGridTop_Attitude_JspDiffNeedsAssessment",
        dataSource: DataSource_Skill_Top_JspDiffNeedsAssessment,
        showHeaderContextMenu: false,
        showRowNumbers: false,
        autoFetchData:false,
        selectionType:"single",
        fields: [
            {name: "titleFa"},
            {name: "objectType"},
            {name: "hasWarning", type: "image", imageURLPrefix: "", imageURLSuffix: ".gif", showTitle:false},
            // {
            //     name: "needsAssessmentPriorityId",
            //     canEdit:true,
            //     valueField: "id",
            //     displayField: "title",
            //     optionDataSource: RestDataSource_NeedsAssessmentPriority_JspDiffNeedsAssessment,
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
            removeRecord_JspDiffNeedsAssessment(this.getRecord(rowNum));
        },
        recordDrop(dropRecords, targetRecord, index, sourceWidget) {
            let record = ListGridTop_Competence_JspDiffNeedsAssessment.getSelectedRecord();
            if (checkRecordAsSelected(record, true, "<spring:message code="competence"/>")) {
                if (sourceWidget.ID === 'ListGrid_SkillAll_JspDiffNeedsAssessment') {
                    for (let i = 0; i < dropRecords.length; i++) {
                        createNeedsAssessmentRecords_Diff(createData_JspDiffNeedsAssessment(dropRecords[i], 110));
                        // DataSource_Skill_Top_JspDiffNeedsAssessment.addData(data);
                        // createNeedsAssessmentRecords_Diff(data);
                        // this.fetchData();
                        // fetchDataDomainsTopGrid_diff()
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
        //         if (record.objectType == NeedsAssessmentTargetDF_diffNeedsAssessment.getValue("objectType")) {
        //             return true;
        //         }
        //     }
        //     return false;
        // },
        getCellCSSText: function (record) {
            return priorityColor(record);
        },
        recordDoubleClick(viewer, record){
            updatePriority_JspDiffNeedsAssessment(viewer, record);
        }
    });
    var ListGridBottom_Competence_JspDiffNeedsAssessment = isc.TrLG.create({
        ID: "ListGridBottom_Competence_JspDiffNeedsAssessment",
        dataSource: DataSource_Competence_Bottom_JspDiffNeedsAssessment,
        autoFetchData: true,
        selectionType:"single",
        // selectionAppearance: "checkbox",
        showHeaderContextMenu: false,
        showRowNumbers: false,
        border: "1px solid",
        headerHeight: 50,
        headerSpans: [
            {
                fields: ["title", "competenceType.title"],
                title: "<spring:message code="competence.list"/>"
            }],
        fields: [{name: "title", title: "<spring:message code="title"/>"}, {name: "competenceType.title", title: "<spring:message code="type"/>"}],
        gridComponents: [
            isc.LgLabel.create({contents: "<span><h3><b>" + "نیازسنجی موجود سیستم" + "</b></h3></span>", customEdges: ["B"]}),
            "header", "body"
        ],
        // canRemoveRecords:true,
        // canDragRecordsOut: true,
        // dragDataAction: "none",
        removeRecordClick(rowNum){
            let Dialog_Competence_remove = createDialog("ask", "هشدار: در صورت حذف شایستگی تمام مهارت های مربوط به آن حذف خواهند شد.",
                "<spring:message code="verify.delete"/>");
            Dialog_Competence_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        let data = ListGridTop_Knowledge_JspDiffNeedsAssessment.data.localData.toArray();
                        data.addAll(ListGridTop_Attitude_JspDiffNeedsAssessment.data.localData.toArray());
                        data.addAll(ListGridTop_Ability_JspDiffNeedsAssessment.data.localData.toArray());
                        let hasFather = false;
                        for (let i = 0; i < data.length; i++) {
                            let state = removeRecord_JspDiffNeedsAssessment(data[i], 1);
                            if(state===0){
                                return;
                            }
                            else if(state===2){
                                hasFather = true;
                            }
                        }
                        if(hasFather===false) {
                            DataSource_Competence_Top_JspDiffNeedsAssessment.removeData(this.getRecord(rowNum));
                        }
                    }
                }
            });
        },
        dataChanged(){
            editing = true;
            this.Super("dataChanged",arguments);
        },
        selectionUpdated(record){
            fetchDataDomainsBottomGrid();
        }
    });
    var ListGridBottom_Knowledge_JspDiffNeedsAssessment = isc.NaLG.create({
        ID: "ListGridBottom_Knowledge_JspDiffNeedsAssessment",
        autoFetchData:false,
        dataSource: DataSource_Skill_Bottom_JspDiffNeedsAssessment,
        showRowNumbers: false,
        selectionType:"single",
        autoSaveEdits:false,
        implicitCriteria:{"needsAssessmentDomainId":108},
        fields: [
            {name: "titleFa"},
            {name: "objectType"},
            {name: "hasWarning", title: "", type: "image", imageURLPrefix: "", imageURLSuffix: ".gif", showTitle:false},

            // {
            //     name: "needsAssessmentPriorityId",
            //     canEdit:true,
            //     valueField: "id",
            //     displayField: "title",
            //     optionDataSource: RestDataSource_NeedsAssessmentPriority_JspDiffNeedsAssessment,
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
        // canAcceptDroppedRecords: true,
        // canHover: true,
        showHoverComponents: true,
        // hoverMode: "detailField",
        // canRemoveRecords:true,
        showHeaderContextMenu: false,
        showFilterEditor:false,

        getCellCSSText(record) {
            return priorityColor(record);
        },
    });
    var ListGridBottom_Ability_JspDiffNeedsAssessment = isc.NaLG.create({
        ID: "ListGridBottom_Ability_JspDiffNeedsAssessment",
        dataSource: DataSource_Skill_Bottom_JspDiffNeedsAssessment,
        autoFetchData:false,
        showRowNumbers: false,
        selectionType:"single",
        fields: [
            {name: "titleFa"},
            {name: "objectType"},
            {name: "hasWarning", title: "", type: "image", imageURLPrefix: "", imageURLSuffix: ".gif", showTitle:false},
            // {
            //     name: "needsAssessmentPriorityId",
            //     canEdit:true,
            //     valueField: "id",
            //     displayField: "title",
            //     optionDataSource: RestDataSource_NeedsAssessmentPriority_JspDiffNeedsAssessment,
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
        // canAcceptDroppedRecords: true,
        // canHover: true,
        showHoverComponents: true,
        autoSaveEdits:false,
        // hoverMode: "details",
        // canRemoveRecords:true,
        showFilterEditor:false,
        implicitCriteria:{"needsAssessmentDomainId":109},

        getCellCSSText: function (record) {
            return priorityColor(record);
        },
    });
    var ListGridBottom_Attitude_JspDiffNeedsAssessment = isc.NaLG.create({
        ID: "ListGridBottom_Attitude_JspDiffNeedsAssessment",
        dataSource: DataSource_Skill_Bottom_JspDiffNeedsAssessment,
        showHeaderContextMenu: false,
        showRowNumbers: false,
        autoFetchData:false,
        selectionType:"single",
        fields: [
            {name: "titleFa"},
            {name: "objectType"},
            {name: "hasWarning", type: "image", imageURLPrefix: "", imageURLSuffix: ".gif", showTitle:false},
            // {
            //     name: "needsAssessmentPriorityId",
            //     canEdit:true,
            //     valueField: "id",
            //     displayField: "title",
            //     optionDataSource: RestDataSource_NeedsAssessmentPriority_JspDiffNeedsAssessment,
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
        showFilterEditor:false,
        implicitCriteria:{"needsAssessmentDomainId":110},
        getCellCSSText: function (record) {
            return priorityColor(record);
        },
    });
    let Window_AddCompetence = isc.Window.create({
        title: "لیست شایستگی ها",
        width: "40%",
        height: "50%",
        keepInParentRect: true,
        isModal: false,
        autoSize: false,
        items: [
            isc.TrHLayout.create({
                members: [
                    ListGrid_AllCompetence_JspDiffNeedsAssessment
                ]
            })],
        show(){
            this.Super("show", arguments);
            let criteria = {
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [{fieldName: "workFlowStatusCode", operator: "equals", value: 2}]
            }
            ListGrid_AllCompetence_JspDiffNeedsAssessment.setImplicitCriteria(criteria);
            ListGrid_AllCompetence_JspDiffNeedsAssessment.fetchData();
        }
    });
    var Window_AddSkill_Diff = isc.Window.create({
        title: "<spring:message code="skill.plural.list"/>",
        width: "60%",
        height: "40%",
        autoCenter: false,
        keepInParentRect: true,
        // isModal: true,
        left:"1%", top:"60%",
        autoSize: false,
        modalMask: Window_AddSkill_Diff,
        topElement: Window_NeedsAssessment_Diff,
        showModalMask: true,
        opacity: 90,
        items: [
            isc.TrHLayout.create({
                members: [
                    ListGrid_SkillAll_JspDiffNeedsAssessment
                ]
            })]
    });

    var NeedsAssessmentTargetDF_diffNeedsAssessment = isc.DynamicForm.create({
        ID: "NeedsAssessmentTargetDF_diffNeedsAssessment",
        numCols: 2,
        visible: false,
        // readOnlyDisplay: "readOnly",
        fields: [
            {
                name: "objectType",
                showTitle: false,
                optionDataSource: NeedsAssessmentTargetDS_DiffNeedsAssessment,
                valueField: "code",
                displayField: "title",
                defaultValue: "Job",
                autoFetchData: false,
                pickListFields: [{name: "title"}],
                defaultToFirstOption: true,
                changed: function (form, item, value, oldValue) {
                    if(value !== oldValue) {
                        updateObjectIdLG_Diff(form, value);
                        clearAllGrid_Diff();
                        form.getItem("objectId").clearValue();
                        Label_PlusData_JspDiffNeedsAssessment.setContents("");
                        // refreshPersonnelLG();
                    }
                },
            },
            {
                name: "objectId",
                showTitle: false,
                optionDataSource: JobDs_diffNeedsAssessment,
                // editorType: "SelectItem",
                valueField: "id",
                displayField: "titleFa",
                autoFetchData: false,
                pickListFields: [
                    {name: "code"},
                    {name: "titleFa"}
                ],
                click: function(form, item){
                    item.fetchData();
                    // updateObjectIdLG_Diff(form, form.getValue("objectType"));
                    // if(form.getValue("objectType") === "Post"){
                        // PostDs_needsAssessment.fetchDataURL = postUrl + "/spec-list";
                        // Window_AddPost_JspDiffNeedsAssessment.show();
                    // }
                },
                changed: function (form, item, value, oldValue) {
                    if(value !== oldValue){
                        editNeedsAssessmentRecord_Diff(NeedsAssessmentTargetDF_diffNeedsAssessment.getValue("objectId"), NeedsAssessmentTargetDF_diffNeedsAssessment.getValue("objectType"));
                        // refreshPersonnelLG();
                        updateLabelDiffNeedsAssessment(item.getSelectedRecord());
                    }
                },
            },
            // {name: "btnCourseDetail", type:"Button", title:"جزئیات دوره", startRow: false},
        ]
    });
    var HLayout_Label_PlusData_JspDiffNeedsAssessment = isc.TrHLayout.create({
        height: "1%",
        padding:2,
        members: [
            Button_CourseDetail_JspDiffNeedsAssessment,
            // Button_CancelChange_JspDiffNeedsAssessment,
            Button_AddSkill_JspDiffNeedsAssessment,
            Button_ShowAttachment_JspDiffNeedsAssessment,
            Label_PlusData_JspDiffNeedsAssessment,
        ],
    });
    var HLayout_Bottom = isc.TrHLayout.create({
            members: [
                // isc.TrVLayout.create({
                //     width: "25%",
                //     showResizeBar: true,
                //     members: [ListGridTop_Competence_JspDiffNeedsAssessment]
                // }),
                isc.TrVLayout.create({
                    // width: "75%",
                    members: [
                        isc.TrHLayout.create({
                            height: "55%",
                            showResizeBar: true,
                            members: [
                                ListGridTop_Competence_JspDiffNeedsAssessment,
                                ListGridTop_Knowledge_JspDiffNeedsAssessment,
                                ListGridTop_Ability_JspDiffNeedsAssessment,
                                ListGridTop_Attitude_JspDiffNeedsAssessment
                            ]
                        }),
                        Label_Help_JspDiffNeedsAssessment,
                        isc.TrHLayout.create({
                            height: "45%",
                            showResizeBar: true,
                            members: [
                                ListGridBottom_Competence_JspDiffNeedsAssessment,
                                ListGridBottom_Knowledge_JspDiffNeedsAssessment,
                                ListGridBottom_Ability_JspDiffNeedsAssessment,
                                ListGridBottom_Attitude_JspDiffNeedsAssessment
                            ]
                        }),
                        // ListGrid_SkillAll_JspDiffNeedsAssessment
                    ]
                }),
            ]
        });

    isc.TrVLayout.create({
        members: [HLayout_Label_PlusData_JspDiffNeedsAssessment, HLayout_Bottom],
    });

    function updateObjectIdLG_Diff(form, value) {
        // form.getItem("objectId").canEdit = true;
        switch (value) {
            case 'Job':
                form.getItem("objectId").optionDataSource = JobDs_diffNeedsAssessment;
                form.getItem("objectId").pickListFields = [
                    {name: "code", title: "<spring:message code="code"/>", autoFitWidth: false},
                    {name: "titleFa", title: "<spring:message code="title"/>", autoFitWidth: false }
                ];
                break;
            case 'JobGroup':
                form.getItem("objectId").optionDataSource = JobGroupDs_diffNeedsAssessment;
                form.getItem("objectId").pickListFields = [{name: "titleFa", title: "<spring:message code="title"/>", autoFitWidth: false}, {name: "code", title: "<spring:message code="code"/>", autoFitWidth: false}];
                break;
            case 'Post':
                form.getItem("objectId").optionDataSource = PostDs_diffNeedsAssessment;
                form.getItem("objectId").pickListFields = [
                    {name: "code", keyPressFilter: false}, {name: "titleFa"}, {name: "job.titleFa"}, {name: "postGrade.titleFa"}, {name: "area"}, {name: "assistance"}, {name: "affairs"},
                    {name: "section"}, {name: "unit"}, {name: "costCenterCode"}, {name: "costCenterTitleFa"}
                ];
                // form.getItem("objectId").canEdit = false;
                // PostDs_diffNeedsAssessment.fetchDataURL = postUrl + "/spec-list";
                break;
            case 'TrainingPost':
                form.getItem("objectId").optionDataSource = PostDS_TrainingPost;
                form.getItem("objectId").pickListFields = [
                    {name: "code", keyPressFilter: false}, {name: "titleFa"}, {name: "job.titleFa"}, {name: "postGrade.titleFa"}, {name: "area"}, {name: "assistance"}, {name: "affairs"},
                    {name: "section"}, {name: "unit"}, {name: "costCenterCode"}, {name: "costCenterTitleFa"}
                ];
                break;
            case 'PostGroup':
                form.getItem("objectId").optionDataSource = PostGroupDs_diffNeedsAssessment;
                form.getItem("objectId").pickListFields = [{name: "titleFa", title: "<spring:message code="title"/>", autoFitWidth: false}, {name: "code", title: "<spring:message code="code"/>", autoFitWidth: false}];
                break;
            case 'PostGrade':
                form.getItem("objectId").optionDataSource = PostGradeDs_diffNeedsAssessment;
                form.getItem("objectId").pickListFields = [
                    {name: "code", title: "<spring:message code="code"/>", autoFitWidth: false},
                    {name: "titleFa", title: "<spring:message code="title"/>", autoFitWidth: false}
                ];
                break;
            case 'PostGradeGroup':
                form.getItem("objectId").optionDataSource = PostGradeGroupDs_diffNeedsAssessment;
                form.getItem("objectId").pickListFields = [
                    {name: "titleFa", title: "<spring:message code="title"/>", autoFitWidth: false},
                    {name: "code", title: "<spring:message code="code"/>", autoFitWidth: false}
                ];
                break;
        }
    }
    function clearAllGrid_Diff() {
        competenceTopData.length = 0;
        competenceBottomData.length = 0;
        skillTopData.length = 0;
        skillBottomData.length = 0;
        ListGridTop_Competence_JspDiffNeedsAssessment.setData([]);
        ListGridTop_Knowledge_JspDiffNeedsAssessment.setData([]);
        ListGridTop_Attitude_JspDiffNeedsAssessment.setData([]);
        ListGridTop_Ability_JspDiffNeedsAssessment.setData([]);
        ListGridBottom_Competence_JspDiffNeedsAssessment.setData([]);
        ListGridBottom_Knowledge_JspDiffNeedsAssessment.setData([]);
        ListGridBottom_Attitude_JspDiffNeedsAssessment.setData([]);
        ListGridBottom_Ability_JspDiffNeedsAssessment.setData([]);
    }
    function checkSaveData_Diff(data, dataSource, field = "skillId", objectType = null) {
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
    function fetchDataDomainsTopGrid_diff(){
        let record = ListGridTop_Competence_JspDiffNeedsAssessment.getSelectedRecord();
        if(record != null) {
            ListGridTop_Knowledge_JspDiffNeedsAssessment.fetchData({"competenceId":record.id});
            ListGridTop_Knowledge_JspDiffNeedsAssessment.invalidateCache();

            ListGridTop_Ability_JspDiffNeedsAssessment.fetchData({"competenceId":record.id});
            ListGridTop_Ability_JspDiffNeedsAssessment.invalidateCache();

            ListGridTop_Attitude_JspDiffNeedsAssessment.fetchData({"competenceId":record.id});
            ListGridTop_Attitude_JspDiffNeedsAssessment.invalidateCache();
        }
    }
    function fetchDataDomainsBottomGrid(){
        let record = ListGridBottom_Competence_JspDiffNeedsAssessment.getSelectedRecord();
        if(record != null) {
            ListGridBottom_Knowledge_JspDiffNeedsAssessment.fetchData({"competenceId":record.id});
            ListGridBottom_Knowledge_JspDiffNeedsAssessment.invalidateCache();

            ListGridBottom_Ability_JspDiffNeedsAssessment.fetchData({"competenceId":record.id});
            ListGridBottom_Ability_JspDiffNeedsAssessment.invalidateCache();

            ListGridBottom_Attitude_JspDiffNeedsAssessment.fetchData({"competenceId":record.id});
            ListGridBottom_Attitude_JspDiffNeedsAssessment.invalidateCache();
        }
    }
    function removeRecord_JspDiffNeedsAssessment(record, state=0) {
        if(record.objectType === NeedsAssessmentTargetDF_diffNeedsAssessment.getValue("objectType")){
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/workflow/" + record.id, "DELETE", null, function (resp) {
                wait.close()
                if (resp.httpResponseCode !== 200) {
                    createDialog("info","خطا در حذف مهارت");
                    return 0;
                }
                DataSource_Skill_Top_JspDiffNeedsAssessment.removeData(record);
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

    function editNeedsAssessmentRecord_Diff(objectId, objectType) {
        // let criteria = [
        //     '{"fieldName":"objectType","operator":"equals","value":"'+objectType+'"}',
        //     '{"fieldName":"objectId","operator":"equals","value":'+objectId+'}'
        // ];
        updateObjectIdLG_Diff(NeedsAssessmentTargetDF_diffNeedsAssessment, objectType);
        clearAllGrid_Diff();
        wait.show();
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
                if(data[i].skill.course === undefined){
                    skill.hasWarning = "alarm";
                }
                else {
                    skill.course = data[i].skill.course;
                }
                DataSource_Skill_Bottom_JspDiffNeedsAssessment.addData(skill);
                if(flags[data[i].competenceId]) continue;
                flags[data[i].competenceId] = true;
                // outPut.push(data[i].competenceId);
                competence.id = data[i].competenceId;
                competence.title = data[i].competence.title;
                competence.competenceType = data[i].competence.competenceType;
                DataSource_Competence_Bottom_JspDiffNeedsAssessment.addData(competence, ()=>{ListGridBottom_Competence_JspDiffNeedsAssessment.selectRecord(0)});
            }
            ListGridBottom_Competence_JspDiffNeedsAssessment.fetchData();
            ListGridBottom_Competence_JspDiffNeedsAssessment.emptyMessage = "<spring:message code="msg.no.records.for.show"/>";
            NeedsAssessmentTargetDF_diffNeedsAssessment.setValue("objectId", objectId);
            NeedsAssessmentTargetDF_diffNeedsAssessment.setValue("objectType", objectType);
            fetchDataDomainsBottomGrid();
            isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/workflowList/" + objectType + "/" + objectId, "GET", null, (resp)=>{
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
                    if(data[i].skill.course === undefined){
                        skill.hasWarning = "alarm";
                    }
                    else {
                        skill.course = data[i].skill.course;
                    }
                    DataSource_Skill_Top_JspDiffNeedsAssessment.addData(skill);
                    if(flags[data[i].competenceId]) continue;
                    flags[data[i].competenceId] = true;
                    // outPut.push(data[i].competenceId);
                    competence.id = data[i].competenceId;
                    competence.title = data[i].competence.title;
                    competence.competenceType = data[i].competence.competenceType;
                    DataSource_Competence_Top_JspDiffNeedsAssessment.addData(competence, ()=>{ListGridBottom_Competence_JspDiffNeedsAssessment.selectRecord(0)});
                }
                ListGridTop_Competence_JspDiffNeedsAssessment.fetchData();
                ListGridTop_Competence_JspDiffNeedsAssessment.emptyMessage = "<spring:message code="msg.no.records.for.show"/>";
                // NeedsAssessmentTargetDF_diffNeedsAssessment.setValue("objectId", objectId);
                // NeedsAssessmentTargetDF_diffNeedsAssessment.setValue("objectType", objectType);
                fetchDataDomainsTopGrid_diff();
            }))
        }))
    }
    function createNeedsAssessmentRecords_Diff(data) {
        if(data === null){
            return;
        }
        if(!checkSaveData_Diff(data, DataSource_Skill_Top_JspDiffNeedsAssessment)){
            createDialog("info", "<spring:message code="exception.duplicate.information"/>", "<spring:message code="error"/>");
            return;
        }
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/workflow", "POST", JSON.stringify(data),function(resp){
            wait.close()
            if (resp.httpResponseCode != 200){
                createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                return;
            }
            data.id = JSON.parse(resp.data).id;
            DataSource_Skill_Top_JspDiffNeedsAssessment.addData(data);
            // DataSource_Skill_Bottom_JspDiffNeedsAssessment.addData(data);
            fetchDataDomainsTopGrid_diff();
            // fetchDataDomainsBottomGrid();
        }))
    }
    function createData_JspDiffNeedsAssessment(record, DomainId, PriorityId = 111) {
        if(record.skillLevelId === 1 && DomainId !== 108){
            createDialog("info", "مهارت با سطح مهارت آشنایی فقط در حیطه دانشی قرار میگیرد.");
            return null;
        }
        if(record.skillLevelId === 2 && DomainId !== 109){
            createDialog("info", "مهارت با سطح مهارت توانایی فقط در حیطه توانشی قرار میگیرد.");
            return null;
        }
        let data = {
            objectType: NeedsAssessmentTargetDF_diffNeedsAssessment.getValue("objectType"),
            objectId: NeedsAssessmentTargetDF_diffNeedsAssessment.getValue("objectId"),
            objectName: NeedsAssessmentTargetDF_diffNeedsAssessment.getItem("objectId").getSelectedRecord().titleFa,
            objectCode: NeedsAssessmentTargetDF_diffNeedsAssessment.getItem("objectId").getSelectedRecord().code,
            competenceId: ListGridTop_Competence_JspDiffNeedsAssessment.getSelectedRecord().id,
            skillId: record.id,
            titleFa: record.titleFa,
            needsAssessmentPriorityId: PriorityId,
            needsAssessmentDomainId: DomainId,
            hasWarning: record.course ? "" : "alarm",
            course: record.course,
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

    function updateLabelDiffNeedsAssessment(objectId) {
        Label_PlusData_JspDiffNeedsAssessment.setContents("");
        if(NeedsAssessmentTargetDF_diffNeedsAssessment.getValue("objectType") === "Post") {
            isc.RPCManager.sendRequest(TrDSRequest(postUrl + "/spec-list?id=" + objectId , "GET", null, (resp)=> {
                if(resp.httpResponseCode === 200){
                    let record = JSON.parse(resp.data).response.data[0];
                    Label_PlusData_JspDiffNeedsAssessment.setContents(
                        (record.titleFa !== undefined ? "<b>عنوان پست: </b>" +  record.titleFa : "")
                        // + "&nbsp;&nbsp;***&nbsp;&nbsp;" + "عنوان رده پستی: " + objectId.postGrade.titleFa
                        + "&nbsp;&nbsp;&nbsp;&nbsp;" +
                        (record.area !== undefined ? "<b>حوزه: </b>" + record.area : "")
                        + "&nbsp;&nbsp;&nbsp;&nbsp;" +
                        (record.assistance !== undefined ? "<b>معاونت: </b>" + record.assistance : "")
                        + "&nbsp;&nbsp;&nbsp;&nbsp;" +
                        (record.affairs !== undefined ? "<b>واحد: </b>" + record.affairs : "")
                    );
                }

            }));

        }
    }
    function updatePriority_JspDiffNeedsAssessment(viewer, record) {
        if(record.objectType === NeedsAssessmentTargetDF_diffNeedsAssessment.getValue("objectType")) {
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
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/workflow/" + record.id, "PUT", JSON.stringify(record), function (resp) {
                wait.close()
                if (resp.httpResponseCode !== 200) {
                    createDialog("info", "<spring:message code='error'/>");
                    return;
                }
                DataSource_Skill_Top_JspDiffNeedsAssessment.updateData(record);
                viewer.endEditing();
            }));
        }
        else{
            createDialog("info","فقط نیازسنجی های مرتبط با "+priorityList[NeedsAssessmentTargetDF_diffNeedsAssessment.getValue("objectType")]+" قابل تغییر است.")
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


    function loadDiffNeedsAssessment(objectId, type, state = "R&W") {
        if(state === "read"){
            NeedsAssessmentTargetDF_diffNeedsAssessment.disable()
        }
        updateObjectIdLG_Diff(NeedsAssessmentTargetDF_diffNeedsAssessment, type);
        NeedsAssessmentTargetDF_diffNeedsAssessment.setValue("objectType", type);
        NeedsAssessmentTargetDF_diffNeedsAssessment.setValue("objectId", objectId);
        clearAllGrid_Diff();
        editNeedsAssessmentRecord_Diff(objectId, type);
        // refreshPersonnelLG(objectId);
        updateLabelDiffNeedsAssessment(objectId);
    }
    Window_NeedsAssessment_Diff.addProperties({
        hide(){
            Window_AddSkill_Diff.close()
            this.Super("hide", arguments);
        }
    })

    // </script>