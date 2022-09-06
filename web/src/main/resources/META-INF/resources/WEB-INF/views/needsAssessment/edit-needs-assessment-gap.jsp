<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>

    <%--// var view_ENA = null;--%>
    const yellow ="#d6d216";
    const red = "#ff8abc";
    const green = "#5dd851";
    const blue = "#0380fc";
    let competenceAttitudeGapData = [];
    let competenceKnowledgeGapData = [];
    let competenceAbilityGapData = [];

    <%--var apiHeader = {--%>
    <%--    "Authorization": "Bearer <%= (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN) %>",--%>
    <%--    'Content-Type': 'application/json'--%>
    <%--};--%>
    <%--var selectedRecord = {};--%>
    <%--var editing = false;--%>
    <%--let isGap;--%>
    <%--let isFromEdit=false;--%>
    <%--let canInsert;--%>
    // let limit=0;
    let gapObjectId=null;
    let gapObjectType=null;
    <%--let selectedRecordForGap;--%>
    <%--var hasChanged = false;--%>
    <%--var canSendToWorkFlowNA = false;--%>

    <%--var skillData = [];--%>
    <%--var competenceData = [];--%>
    <%--var peopleTypeMap ={--%>
    <%--    "Personal" : "شرکتی",--%>
    <%--    "ContractorPersonal" : "پیمان کار"--%>
    <%--};--%>

    <%--//----------------------------------------- DataSources --------------------------------------------------------------%>
    <%--let NeedsAssessmentTargetDS_needsAssessment = isc.TrDS.create({--%>
    <%--    ID: "NeedsAssessmentTargetDS_needsAssessment",--%>
    <%--    fields: [--%>
    <%--        {name: "id", primaryKey: true, hidden: true},--%>
    <%--        {name: "title", title: "<spring:message code="title"/>", required: true, filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "code", title: "<spring:message code="code"/>", required: true, filterOperator: "iContains", autoFitWidth: true},--%>
    <%--    ],--%>
    <%--    fetchDataURL: parameterValueUrl + "/iscList/103",--%>

    <%--});--%>
    <%--let JobDs_needsAssessment = isc.TrDS.create({--%>
    <%--    fields: [--%>
    <%--        {name: "id", primaryKey: true, hidden: true},--%>
    <%--        {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},--%>
    <%--    ],--%>
    <%--    fetchDataURL: jobUrl + "/spec-list"--%>
    <%--});--%>
    <%--let JobGroupDs_needsAssessment = isc.TrDS.create({--%>
    <%--    fields: [--%>
    <%--        {name: "id", primaryKey: true, hidden: true},--%>
    <%--        {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},--%>
    <%--        {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"},--%>
    <%--    ],--%>
    <%--    fetchDataURL: jobGroupUrl + "iscList"--%>
    <%--});--%>
    <%--let PostDs_needsAssessment = isc.TrDS.create({--%>
    <%--    fields: [--%>
    <%--        {name: "id", primaryKey: true, hidden: true},--%>
    <%--        {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "job.titleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "postGrade.titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--    ],--%>
    <%--    fetchDataURL: postUrl + "/spec-list"--%>
    <%--});--%>
    <%--let PostDS_TrainingPost = isc.TrDS.create({--%>
    <%--    fields: [--%>
    <%--        {name: "id", primaryKey: true, hidden: true},--%>
    <%--        {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap:peopleTypeMap},--%>
    <%--        {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "jobTitleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "postGradeTitleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "competenceCount", title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},--%>
    <%--        {name: "personnelCount", title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},--%>
    <%--    ],--%>
    <%--    fetchDataURL: viewTrainingPostUrl + "/spec-list"--%>
    <%--});--%>

    <%--let PostGroupDs_needsAssessment = isc.TrDS.create({--%>
    <%--    fields: [--%>
    <%--        {name: "id", primaryKey: true, hidden: true},--%>
    <%--        {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},--%>
    <%--        {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"},--%>
    <%--    ],--%>
    <%--    fetchDataURL: postGroupUrl + "/spec-list"--%>
    <%--});--%>
    <%--let PostGradeDs_needsAssessment = isc.TrDS.create({--%>
    <%--    fields: [--%>
    <%--        {name: "id", primaryKey: true, hidden: true},--%>
    <%--        {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},--%>
    <%--    ],--%>
    <%--    fetchDataURL: postGradeUrl + "/spec-list"--%>
    <%--});--%>
    <%--let PostGradeGroupDs_needsAssessment = isc.TrDS.create({--%>
    <%--    fields: [--%>
    <%--        {name: "id", primaryKey: true, hidden: true},--%>
    <%--        {name: "titleFa", title: "<spring:message code='title'/>", filterOperator: "iContains"},--%>
    <%--        {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"},--%>
    <%--    ],--%>
    <%--    fetchDataURL: postGradeGroupUrl + "spec-list"--%>
    <%--});--%>
    let RestDataSource_Skill_JspNeedsAssessmentGap = isc.TrDS.create({
        ID: "RestDataSource_Skill_JspNeedsAssessmentGap",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "priority", title: "حیطه شایستگی", filterOperator: "iContains"},
            {name: "limitSufficiency", title: "حد بسندگی", filterOperator: "iContains"},
            {name: "competence", title: "شایستگی", filterOperator: "iContains"},
            {name: "skillLevel.titleFa", title: "<spring:message code="skill.level"/>", filterOperator: "iContains"},
            {name: "course.titleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains"},
            {name: "course.code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true}
        ],
        fetchDataURL: skillUrl + "/spec-list"
    });
    <%--var RestDataSource_NeedsAssessmentPriority_JspNeedsAssessment = isc.TrDS.create({--%>
    <%--    fields:[--%>
    <%--        {name: "id", primaryKey:true},--%>
    <%--        {name:"code"},--%>
    <%--        {name:"title"}--%>
    <%--    ],--%>
    <%--    fetchDataURL: parameterValueUrl + "/iscList?operator=and&_constructor=AdvancedCriteria&criteria={\"fieldName\":\"parameter.code\",\"operator\":\"equals\",\"value\":\"NeedsAssessmentPriority\"}"--%>
    <%--});--%>
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
                    111: "عملکردی توسعه",
                    112: "عملکردی بهبود",
                    113: "ضروری ضمن خدمت",
                    574: "ضروری انتصاب سمت"
                },title: "اولویت"}
        ],
        fetchDataURL: competenceUrl + "/spec-list",
    });
    <%--var RestDataSource_Course_JspENA = isc.TrDS.create({--%>
    <%--    fields: [--%>
    <%--        {name: "id", primaryKey: true},--%>
    <%--        {name: "code", title: "<spring:message code="skill.code"/>", filterOperator: "iContains"},--%>
    <%--        {name: "titleFa", title: "<spring:message code="skill"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true},--%>
    <%--        {name: "course.titleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains"},--%>
    <%--        {name: "course.code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true},--%>
    <%--        {name: "course.theoryDuration", title: "<spring:message code="duration"/>", filterOperator: "iContains"}--%>

    <%--    ],--%>
    <%--    fetchDataURL: skillUrl + "/WFC/spec-list"--%>

    <%--});--%>
    <%--var RestDataSource_AddCourse_JspENA = isc.TrDS.create({--%>
    <%--    fields: [--%>
    <%--        {name: "id", primaryKey: true},--%>
    <%--        {name: "scoringMethod"},--%>
    <%--        {name: "acceptancelimit"},--%>
    <%--        {name: "startEvaluation"},--%>
    <%--        {--%>
    <%--            name: "code",--%>
    <%--            title: "<spring:message code="course.code"/>",--%>
    <%--            filterOperator: "iContains",--%>
    <%--            autoFitWidth: true--%>
    <%--        },--%>
    <%--        {name: "titleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains"},--%>
    <%--        {name: "createdBy", title: "<spring:message code="created.by.user"/>", filterOperator: "iContains"},--%>
    <%--        {name: "theoryDuration"},--%>
    <%--        {name: "categoryId"},--%>
    <%--        {name: "subCategoryId"},--%>
    <%--    ],--%>
    <%--    fetchDataURL: courseUrl + "spec-list"--%>
    <%--});--%>
    <%--var RestDataSource_category_JspENA = isc.TrDS.create({--%>
    <%--    fields: [--%>
    <%--        {name: "id", primaryKey: true},--%>
    <%--        {name: "titleFa", type: "text"}--%>
    <%--    ],--%>
    <%--    fetchDataURL: categoryUrl + "spec-list",--%>
    <%--});--%>
    <%--var RestDataSource_category_JspENA1 = isc.TrDS.create({--%>
    <%--    fields: [--%>
    <%--        {name: "id", primaryKey: true},--%>
    <%--        {name: "titleFa", type: "text"}--%>
    <%--    ],--%>
    <%--    fetchDataURL: categoryUrl + "spec-list",--%>
    <%--});--%>
    <%--var RestDataSource_subCategory_JspENA = isc.TrDS.create({--%>
    <%--    fields: [--%>
    <%--        {name: "id", primaryKey: true},--%>
    <%--        {name: "titleFa", type: "text"}--%>
    <%--    ],--%>
    <%--    fetchDataURL: subCategoryUrl + "spec-list",--%>
    <%--});--%>
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
            {name: "competencePriorityId", hidden:true}
        ],
        testData: competenceAbilityGapData,
        clientOnly: true

    });

    <%--var RestDataSource_TrainingPost_By_Skill_Jsp = isc.TrDS.create({--%>
    <%--    fields: [--%>
    <%--        {name: "id", primaryKey: true, hidden: true},--%>
    <%--        {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap:peopleTypeMap},--%>
    <%--        {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "job.titleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "job.code", title: "<spring:message code="job.code"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "postGrade.titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both",}--%>

    <%--    ],--%>
    <%--    // fetchDataURL: needsAssessmentReportsUrl + "/postsWithSameSkill" +--%>
    <%--});--%>


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
        title: " ذخیره و ارسال به گردش کار",
        click: async function () {
            wait.show();
            saveAndSendToWorkFlow()
        }
    });
    // let buttonSave = isc.ToolStripButtonCreate.create({
    //     title: " ذخیره ",
    //     click: async function () {
    //         save()
    //     }
    // });
    let buttonChangeCancel = isc.ToolStripButtonRemove.create({
        ID: "CancelChange_JspENAGap",
        title: "بازخوانی / لغو تغییرات",
        click: function () {
            // let id = DynamicForm_JspEditNeedsAssessment.getValue("objectId");
            // let type = DynamicForm_JspEditNeedsAssessment.getValue("objectType");
            // wait.show();
            //
            // isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/rollBack/" + type + "/" + id, "PUT", null, (resp)=>{
            //     wait.close();
            //     if(resp.httpResponseCode === 200){
            //         hasChanged = false;
            //         canSendToWorkFlowNA = false;
            //         editNeedsAssessmentRecord(id, type);
            //     }
            // }));
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

    <%--let DynamicForm_total_courses_times = isc.DynamicForm.create({--%>
    <%--    width: 600,--%>
    <%--    height: 120,--%>
    <%--    padding: 6,--%>
    <%--    titleAlign: "right",--%>
    <%--    fields: [--%>
    <%--        {--%>
    <%--            name: "servingPriority",--%>
    <%--            width: "100%",--%>
    <%--            canEdit: false,--%>
    <%--            title: "مجموع ساعات دوره های ضروری ضمن خدمت    ",--%>
    <%--            editorType: 'text'--%>
    <%--        } , {--%>
    <%--            name: "improvementPriority",--%>
    <%--            width: "100%",--%>
    <%--            canEdit: false,--%>
    <%--            title: "مجموع ساعات دوره های عملکردی بهبود   ",--%>
    <%--            editorType: 'text'--%>
    <%--        } , {--%>
    <%--            name: "developmentPriority",--%>
    <%--            width: "100%",--%>
    <%--            canEdit: false,--%>
    <%--            title: "مجموع ساعات دوره های توسعه ای    ",--%>
    <%--            editorType: 'text'--%>
    <%--        } , {--%>
    <%--            name: "positionPriority",--%>
    <%--            width: "100%",--%>
    <%--            canEdit: false,--%>
    <%--            title: "مجموع ساعات دوره های ضروری انتصاب سمت    ",--%>
    <%--            editorType: 'text'--%>
    <%--        }--%>
    <%--    ]--%>
    <%--});--%>


    <%--let Window_total_courses_times = isc.Window.create({--%>
    <%--    width: 600,--%>
    <%--    height: 120,--%>
    <%--    numCols: 2,--%>
    <%--    title: "محاسبه مجموع ساعات",--%>
    <%--    items: [--%>
    <%--        DynamicForm_total_courses_times,--%>
    <%--        isc.MyHLayoutButtons.create({--%>
    <%--            members: [--%>
    <%--                isc.IButtonCancel.create({--%>
    <%--                    title: "<spring:message code="close"/>",--%>
    <%--                    click: function () {--%>
    <%--                        DynamicForm_total_courses_times.items[0].setValue("");--%>
    <%--                        DynamicForm_total_courses_times.items[1].setValue("");--%>
    <%--                        DynamicForm_total_courses_times.items[2].setValue("");--%>
    <%--                        DynamicForm_total_courses_times.items[3].setValue("");--%>

    <%--                        Window_total_courses_times.close();--%>
    <%--                    }--%>
    <%--                })]--%>
    <%--        })]--%>
    <%--});--%>

    <%--var Window_CourseDetail_JspENA = isc.Window.create({--%>
    <%--    title: "<spring:message code="course.plural.list"/>",--%>
    <%--    // placement: "fillScreen",--%>
    <%--    width: "80%",--%>
    <%--    height: "50%",--%>
    <%--    minWidth: 1024,--%>
    <%--    keepInParentRect: true,--%>
    <%--    isModal: true,--%>
    <%--    // autoSize: false,--%>
    <%--    autoSize: false,--%>
    <%--    show(criteria){--%>
    <%--        ListGrid_CourseDetail_JspENA.invalidateCache();--%>
    <%--        ListGrid_CourseDetail_JspENA.fetchData(criteria);--%>
    <%--        this.Super("show", arguments);--%>
    <%--    },--%>
    <%--    items: [--%>
    <%--        isc.TrHLayout.create({--%>
    <%--            members: [--%>
    <%--                isc.TrLG.create({--%>
    <%--                    ID: "ListGrid_CourseDetail_JspENA",--%>
    <%--                    dataSource: RestDataSource_Course_JspENA,--%>
    <%--                    // selectionType: "none",--%>
    <%--                    filterOnKeypress: true,--%>
    <%--                    // autoFetchData:true,--%>
    <%--                    fields: [--%>
    <%--                        // {name: "scoringMethod"},--%>
    <%--                        // {name: "acceptancelimit"},--%>
    <%--                        // {name: "startEvaluation"},--%>
    <%--                        {--%>
    <%--                            name: "code",--%>
    <%--                            title: "<spring:message code="skill.code"/>",--%>
    <%--                            filterOperator: "iContains",--%>
    <%--                            autoFitWidth: true--%>
    <%--                        },--%>
    <%--                        {--%>
    <%--                            name: "titleFa",--%>
    <%--                            title: "<spring:message code="skill"/>",--%>
    <%--                            filterOperator: "iContains",--%>
    <%--                            autoFitWidth: true--%>
    <%--                        },--%>
    <%--                        {--%>
    <%--                            name: "course.code",--%>
    <%--                            title: "<spring:message code="course.code"/>",--%>
    <%--                            filterOperator: "iContains",--%>
    <%--                            autoFitWidth: true--%>
    <%--                        },--%>
    <%--                        {--%>
    <%--                            name: "course.titleFa",--%>
    <%--                            title: "<spring:message code="course.title"/>",--%>
    <%--                            filterOperator: "iContains",--%>
    <%--                            autoFitWidth: true--%>
    <%--                        },--%>
    <%--                        &lt;%&ndash;{name: "createdBy", title: "<spring:message code="created.by.user"/>", filterOperator: "iContains"},&ndash;%&gt;--%>

    <%--                        {--%>
    <%--                            name: "course.categoryId",--%>
    <%--                            title: "<spring:message code="category"/> <spring:message code="course"/>",--%>
    <%--                            optionDataSource: RestDataSource_category_JspENA,--%>
    <%--                            filterOnKeypress: true,--%>
    <%--                            valueField: "id",--%>
    <%--                            displayField: "titleFa",--%>
    <%--                            filterOperator: "equals",--%>
    <%--                        },--%>
    <%--                        {--%>
    <%--                            name: "course.subCategoryId",--%>
    <%--                            title: "<spring:message code="subcategory"/> <spring:message code="course"/>",--%>
    <%--                            optionDataSource: RestDataSource_subCategory_JspENA,--%>
    <%--                            filterOnKeypress: true,--%>
    <%--                            valueField: "id",--%>
    <%--                            displayField: "titleFa",--%>
    <%--                            filterOperator: "equals",--%>
    <%--                        },--%>
    <%--                        {--%>
    <%--                            name: "course.theoryDuration",--%>
    <%--                            title: "<spring:message code="course_Running_time"/>",--%>
    <%--                            filterOperator: "equals",--%>
    <%--                        },--%>
    <%--                    ],--%>
    <%--                    gridComponents: ["filterEditor", "header", "body"],--%>
    <%--                }),--%>
    <%--            ]--%>
    <%--        })]--%>
    <%--});--%>

    <%--var Label_PlusData_JspNeedsAssessment = isc.LgLabel.create({--%>
    <%--    align:"left",--%>
    <%--    contents:"",--%>
    <%--    margin:8,--%>
    <%--    customEdges: []});--%>
    let Label_Help_JspNeedsAssessmentGap = isc.LgLabel.create({
        align:"left",
        width: "50%",
        contents: getFormulaMessage("اولویت : ", "2", "#020404", "b") + getFormulaMessage("ضروری ضمن خدمت", "2", red, "b") +" *** " +
            getFormulaMessage("عملکردی بهبود", "2", yellow, "b") + " *** " + getFormulaMessage("توسعه ای", "2", green, "b") + " *** " +
            getFormulaMessage("ضروری انتصاب سمت", "2", blue, "b")

        ,customEdges: []});
    <%--var Button_CourseDetail_JspEditNeedsAssessment = isc.Button.create({--%>
    <%--    title:"جزئیات دوره",--%>
    <%--    margin: 1,--%>
    <%--    baseStyle: "toolStripButton",--%>
    <%--    // borderRadius: 5,--%>
    <%--    click(){--%>
    <%--        if(ListGrid_Knowledge_JspNeedsAssessment.getSelectedRecord()||ListGrid_Ability_JspNeedsAssessment.getSelectedRecord()||ListGrid_Attitude_JspNeedsAssessment.getSelectedRecord()||ListGrid_SkillAll_JspNeedsAssessment.getSelectedRecord()){--%>
    <%--            let skillIds = [];--%>
    <%--            if(ListGrid_Knowledge_JspNeedsAssessment.getSelectedRecord()!= undefined && ListGrid_Knowledge_JspNeedsAssessment.getSelectedRecord().course != undefined) {--%>
    <%--                skillIds.push(ListGrid_Knowledge_JspNeedsAssessment.getSelectedRecord().skillId);--%>
    <%--            }--%>
    <%--            if(ListGrid_Ability_JspNeedsAssessment.getSelectedRecord()!= undefined && ListGrid_Ability_JspNeedsAssessment.getSelectedRecord().course!= undefined) {--%>
    <%--                skillIds.push(ListGrid_Ability_JspNeedsAssessment.getSelectedRecord().skillId);--%>
    <%--            }--%>
    <%--            if(ListGrid_Attitude_JspNeedsAssessment.getSelectedRecord()!= undefined && ListGrid_Attitude_JspNeedsAssessment.getSelectedRecord().course!= undefined) {--%>
    <%--                skillIds.push(ListGrid_Attitude_JspNeedsAssessment.getSelectedRecord().skillId);--%>
    <%--            }--%>
    <%--            if(ListGrid_SkillAll_JspNeedsAssessment.getSelectedRecord()!= undefined && ListGrid_SkillAll_JspNeedsAssessment.getSelectedRecord().course!= undefined) {--%>
    <%--                skillIds.push(ListGrid_SkillAll_JspNeedsAssessment.getSelectedRecord().id);--%>
    <%--            }--%>
    <%--            if(skillIds.length == 0){--%>
    <%--                createDialog("info", "مهارت های انتخاب شده بدون دوره هستند.");--%>
    <%--                return;--%>
    <%--            }--%>
    <%--            let criteria = {--%>
    <%--                _constructor: "AdvancedCriteria",--%>
    <%--                operator: "and",--%>
    <%--                criteria: [{fieldName: "id", operator: "inSet", value: skillIds}]--%>
    <%--            };--%>
    <%--            Window_CourseDetail_JspENA.show(criteria);--%>
    <%--        }--%>
    <%--        else{--%>
    <%--            createDialog("info", "مهارتی انتخاب نشده است")--%>
    <%--        }--%>
    <%--    }--%>
    <%--});--%>

    <%--var Button_changeShow_JspEditNeedsAssessment = isc.Button.create({--%>
    <%--    title:"مشاهده تغییرات",--%>
    <%--    margin: 1,--%>
    <%--    click: function () {--%>
    <%--        wait.show();--%>
    <%--        showWindowDiffNeedsAssessment(DynamicForm_JspEditNeedsAssessment.getValue("objectId"), DynamicForm_JspEditNeedsAssessment.getValue("objectType"), null,true)--%>
    <%--    }--%>
    <%--});--%>

    <%--let oldCourseRecord = {};--%>
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
                    if   (record !== undefined && record !== null ){
                        // ListGrid_NeedsAssessment_JspENAGap.setData([]);
                        Window_AddCourseGap.show();
                    }
                    else {
                        createDialog("info","<spring:message code='msg.no.records.selected'/>");
                    }
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
                        // ListGrid_NeedsAssessment_JspENAGap.setData([]);
                        Window_AddCourseGap.show();
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
                        Window_AddCourseGap.show();
                    }
                    else {
                        createDialog("info","<spring:message code='msg.no.records.selected'/>");
                    }
                }
            }
        ]
    });
    <%--let Menu_LG_Competence_JspENA = isc.Menu.create({--%>
    <%--    data: [--%>
    <%--        {--%>
    <%--            title: "جزییات شایستگی",--%>
    <%--            click: function () {--%>
    <%--                if(checkSelectedRecord(ListGrid_Competence_JspNeedsAssessment)) {--%>
    <%--                    ListGrid_Competence_JspNeedsAssessment.rowDoubleClick(ListGrid_Competence_JspNeedsAssessment.getSelectedRecord())--%>
    <%--                }--%>
    <%--            }--%>
    <%--        }, {--%>
    <%--            title: "ویرایش حد بسندگی ",--%>
    <%--            click: function () {--%>
    <%--                if(checkSelectedRecord(ListGrid_Competence_JspNeedsAssessment)) {--%>
    <%--                    if (isGap){--%>
    <%--                        isFromEdit=true;--%>
    <%--                        selectedRecordForGap=ListGrid_Competence_JspNeedsAssessment.getSelectedRecord()--%>
    <%--                        DynamicForm_limit_sufficiency.clearValues();--%>
    <%--                        DynamicForm_limit_sufficiency.clearErrors();--%>
    <%--                        Window_get_limit_sufficiency.show();--%>
    <%--                        DynamicForm_limit_sufficiency.getItem("limitSufficiency").setValue(selectedRecordForGap.limitSufficiency)--%>
    <%--                    }--%>

    <%--                }--%>

    <%--            }--%>
    <%--        },--%>
    <%--    ]--%>
    <%--});--%>
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
    <%--let Menu_LG_History_JspENA = isc.Menu.create({--%>
    <%--    data: [--%>
    <%--        {--%>
    <%--            title: "کپی شایستگی",--%>
    <%--            click: function () {--%>
    <%--                let record = ListGrid_NeedsAssessment_JspENA.getSelectedRecord()--%>
    <%--                let url = needsAssessmentUrl + "/getValuesForCopyNA/" + record.objectType--%>
    <%--                    + "/" + record.objectId + "/" + DynamicForm_JspEditNeedsAssessment.getValue("objectType")--%>
    <%--                    + "/" + DynamicForm_JspEditNeedsAssessment.getValue("objectId")--%>
    <%--                    + "?competenceId=" + record.competenceId;--%>
    <%--                wait.show();--%>
    <%--                isc.RPCManager.sendRequest(TrDSRequest(url, "GET", null, (resp) => {--%>
    <%--                    wait.close();--%>
    <%--                    if (resp.httpResponseCode !== 200) {--%>
    <%--                        createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");--%>
    <%--                        return;--%>
    <%--                    }--%>
    <%--                    editNeedsAssessmentRecord(DynamicForm_JspEditNeedsAssessment.getValue("objectId"),DynamicForm_JspEditNeedsAssessment.getValue("objectType"), JSON.parse(resp.data));--%>
    <%--                    hasChanged = true;--%>
    <%--                    canSendToWorkFlowNA = true;--%>
    <%--                }));--%>
    <%--            }--%>
    <%--        },--%>
    <%--    ]--%>
    <%--});--%>


    <%--var ListGrid_TrainingPost_By_Skill = isc.TrLG.create({--%>
    <%--    dataSource: RestDataSource_TrainingPost_By_Skill_Jsp,--%>
    <%--    autoFetchData: false,--%>
    <%--    sortField: 1,--%>
    <%--    fields: [--%>
    <%--        {--%>
    <%--            name: "peopleType",--%>
    <%--            filterOnKeypress: true,--%>
    <%--        },--%>
    <%--        {--%>
    <%--            name: "code",--%>
    <%--            filterEditorProperties: {--%>
    <%--                keyPressFilter: "[0-9/]"--%>
    <%--            }--%>
    <%--        },--%>
    <%--        {name: "titleFa"},--%>
    <%--        {name: "job.titleFa"},--%>
    <%--        {name: "postGrade.titleFa"},--%>
    <%--        {name: "area"},--%>
    <%--        {name: "assistance"},--%>
    <%--        {name: "affairs"},--%>
    <%--        {name: "section"},--%>
    <%--        {name: "unit"},--%>
    <%--        {--%>
    <%--            name: "costCenterCode",--%>
    <%--            filterEditorProperties: {--%>
    <%--                keyPressFilter: "[0-9]"--%>
    <%--            }--%>
    <%--        },--%>
    <%--        {name: "costCenterTitleFa"},--%>
    <%--        {--%>
    <%--            name: "enabled",--%>
    <%--            valueMap: {--%>
    <%--                // undefined : "فعال",--%>
    <%--                74: "غیر فعال"--%>
    <%--            }, filterOnKeypress: true--%>
    <%--        }--%>
    <%--    ]--%>
    <%--});--%>


    <%--var Window_Show_Post_Used_This_Skill = isc.Window.create({--%>
    <%--    title: "لیست پست های که در نیازسنجی شامل این مهارت هستند",--%>
    <%--    align: "center",--%>
    <%--    placement: "fillScreen",--%>
    <%--    minWidth: 1024,--%>
    <%--    items: [--%>
    <%--        isc.VLayout.create({--%>
    <%--            width: "100%",--%>
    <%--            height: "100%",--%>
    <%--            members: [ListGrid_TrainingPost_By_Skill]--%>
    <%--        })--%>
    <%--    ]--%>
    <%--});--%>

    <%--var Menu_ListGrid_Skils_RightClick_Jsp = isc.Menu.create({--%>
    <%--    width: 150,--%>
    <%--    data: [--%>
    <%--        {--%>
    <%--            title: "لیست پست های شامل این مهارت", icon: "<spring:url value="post.png"/>", click: function () {--%>
    <%--                let record = ListGrid_SkillAll_JspNeedsAssessment.getSelectedRecord();--%>
    <%--                if (record == null || record.id == null) {--%>

    <%--                    isc.Dialog.create({--%>

    <%--                        message: "<spring:message code="msg.no.records.selected"/>",--%>
    <%--                        icon: "[SKIN]ask.png",--%>
    <%--                        title: "پیام",--%>
    <%--                        buttons: [isc.IButtonSave.create({title: "تائید"})],--%>
    <%--                        buttonClick: function (button, index) {--%>
    <%--                            this.close();--%>
    <%--                        }--%>
    <%--                    });--%>
    <%--                } else {--%>
    <%--                    RestDataSource_TrainingPost_By_Skill_Jsp.fetchDataURL = skillUrl + "/postsWithSameSkill" + "/" + record.id;--%>
    <%--                    ListGrid_TrainingPost_By_Skill.invalidateCache();--%>
    <%--                    ListGrid_TrainingPost_By_Skill.fetchData();--%>
    <%--                    Window_Show_Post_Used_This_Skill.show();--%>
    <%--                }--%>
    <%--            }--%>
    <%--        }--%>
    <%--    ]--%>
    <%--});--%>

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
            {name: "categoryId", title: "گروه", optionDataSource: RestDataSource_category_JspENA, displayField: "titleFa", valueField:"id"},
            {name: "subCategoryId", title: "زیر گروه" , optionDataSource: RestDataSource_subCategory_JspENA, displayField: "titleFa", valueField:"id"},
            {name: "competenceLevelId", title: "حیطه" , },
            {name: "competencePriorityId", title: "اولویت" , }
        ],
        gridComponents: ["filterEditor", "header", "body"],
        rowDoubleClick(record){
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
    <%--let ListGrid_NeedsAssessment_JspENAGap = isc.TrLG.create({--%>
    <%--    dataSource: RestDataSource_NeedsAssessment_JspENAGap,--%>
    <%--    showHeaderContextMenu: false,--%>
    <%--    selectionType: "single",--%>
    <%--    // contextMenu: Menu_LG_History_JspENA,--%>
    <%--    filterOnKeypress: true,--%>
    <%--    canDragRecordsOut: true,--%>
    <%--    autoFetchData: false,--%>
    <%--    dragDataAction: "none",--%>
    <%--    canAcceptDroppedRecords: true,--%>
    <%--    fields: [--%>
    <%--        {name: "objectName", title: "نام عنوان", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "objectCode", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "objectType", title: "<spring:message code="title"/>", width:90, valueMap: priorityList},--%>
    <%--        {name: "competence.title", title: "نام شایستگی", filterOperator: "iContains"},--%>
    <%--        {name: "competence.competenceType.title", title: "نوع شایستگی", filterOperator: "iContains"},--%>
    <%--        {name: "skill.titleFa", title: "نام مهارت", filterOperator: "iContains"},--%>
    <%--        {name: "needsAssessmentDomain.title", title: "حیطه", filterOperator: "iContains"},--%>
    <%--        {name: "needsAssessmentPriority.title", title: "اولویت", filterOperator: "iContains"},--%>
    <%--    ],--%>
    <%--    gridComponents: [--%>
    <%--        isc.Label.create({--%>
    <%--            contents: "<style>b{color: white}</style><b>تاریخچه شایستگی</b>",--%>
    <%--            backgroundColor: "#fe9d2a",--%>
    <%--            align: "left",--%>
    <%--            padding: 4,--%>
    <%--            borderRadius: 2,--%>
    <%--            height: 28,--%>
    <%--            // showEdges: true--%>
    <%--        }),--%>
    <%--        "filterEditor", "header", "body"],--%>
    <%--});--%>

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

        <%--removeRecordClick(rowNum){--%>
        <%--    wait.show();--%>
        <%--    let id = DynamicForm_JspEditNeedsAssessment.getValue("objectId");--%>
        <%--    let type = DynamicForm_JspEditNeedsAssessment.getValue("objectType");--%>
        <%--    isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/isReadOnly/" + type + "/" + id, "GET", null, (resp) => {--%>
        <%--        wait.close();--%>
        <%--        if (resp.httpResponseCode !== 200) {--%>
        <%--            createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");--%>
        <%--            return;--%>
        <%--        }--%>
        <%--        if(resp.data === "true"){--%>
        <%--            createDialog("info", "<spring:message code='read.only.na.message'/>");--%>
        <%--        }--%>
        <%--        else {--%>
        <%--            let Dialog_Competence_remove = createDialog("ask", "هشدار: در صورت حذف شایستگی تمام مهارت های با مرجع "  + getFormulaMessage(priorityList[type],"2","red","b") +  " آن حذف خواهند شد.",--%>
        <%--                "<spring:message code="verify.delete"/>");--%>
        <%--            Dialog_Competence_remove.addProperties({--%>
        <%--                buttonClick: function (button, index) {--%>
        <%--                    this.close();--%>
        <%--                    if (index === 0) {--%>
        <%--                        let data = ListGrid_Knowledge_JspNeedsAssessment.data.localData.toArray();--%>
        <%--                        data.addAll(ListGrid_Attitude_JspNeedsAssessment.data.localData.toArray());--%>
        <%--                        data.addAll(ListGrid_Ability_JspNeedsAssessment.data.localData.toArray());--%>
        <%--                        let hasFather = false;--%>
        <%--                        for (let i = 0; i < data.length; i++) {--%>
        <%--                            let state = removeRecord_JspNeedsAssessment(data[i], 1);--%>
        <%--                            if(state===0){--%>
        <%--                                return;--%>
        <%--                            }--%>
        <%--                            else if(state===2){--%>
        <%--                                hasFather = true;--%>
        <%--                            }--%>
        <%--                        }--%>
        <%--                        if(hasFather===false) {--%>
        <%--                            ListGrid_Competence_JspNeedsAssessment.removeData(ListGrid_Competence_JspNeedsAssessment.getRecord(rowNum));--%>
        <%--                        }--%>
        <%--                    }--%>
        <%--                }--%>
        <%--            });--%>
        <%--        }--%>
        <%--    }))--%>
        <%--},--%>
        dataChanged(){
            editing = true;
            this.Super("dataChanged",arguments);
        },
        selectionUpdated(record){
            // fetchDataDomainsGrid();
            // ListGrid_SkillAll_JspNeedsAssessment_Refresh();
        },
        <%--rowDoubleClick (record) {--%>
        <%--    wait.show()--%>
        <%--    isc.RPCManager.sendRequest(TrDSRequest(competenceUrl + "/spec-list?id=" + record.id, "GET", null, (resp) => {--%>
        <%--        wait.close()--%>
        <%--        RestDataSource_category_JspENA.fetchData()--%>
        <%--        if (resp.httpResponseCode !== 200) {--%>
        <%--            createDialog("info", "<spring:message code='error'/>");--%>
        <%--        }--%>
        <%--        let fields = [--%>
        <%--            {--%>
        <%--                name: "code", title: "<spring:message code="corse_code"/>",--%>
        <%--                align: "center",--%>
        <%--                autoFitWidth: true,--%>
        <%--                filterOperator: "iContains"--%>
        <%--            },--%>
        <%--            {--%>
        <%--                name: "title",--%>
        <%--                title: "عنوان",--%>
        <%--                align: "center",--%>
        <%--                autoFitWidth: true,--%>
        <%--                filterOperator: "iContains",--%>
        <%--            },--%>
        <%--            {--%>
        <%--                name: "category.titleFa",--%>
        <%--                title: "<spring:message code="category"/>",--%>
        <%--                align: "center"--%>
        <%--            },--%>
        <%--            {--%>
        <%--                name: "subCategory.titleFa",--%>
        <%--                title: "<spring:message code="subcategory"/>",--%>
        <%--                align: "center"--%>
        <%--            },--%>
        <%--            {--%>
        <%--                name: "competenceType.title",--%>
        <%--                title: "نوع",--%>
        <%--                align: "center",--%>
        <%--            },--%>
        <%--        ];--%>
        <%--        showDetailViewer("جزئیات شایستگی", fields, JSON.parse(resp.data).response.data[0]);--%>
        <%--    }));--%>
        <%--}--%>
    });

    let ListGrid_SkillAll_JspNeedsAssessmentGap = isc.TrLG.create({
        ID: "ListGrid_SkillAll_JspNeedsAssessmentGap",
        dataSource: RestDataSource_Skill_JspNeedsAssessmentGap,
         autoFetchData: false,

        selectionType:"single",
        fields: [
             {name: "priority"},
             {name: "competence"},
             {name: "skillLevel.titleFa"},
            {name: "course.titleFa"},
            {name: "course.code"},
            {name: "limitSufficiency"}
        ],
        gridComponents: [
            isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="courses.list"/>" + "</b></span>", customEdges: ["T"]}),
            "filterEditor", "header", "body"
        ],

        canDragRecordsOut: true,
        // dataArrived:function(){
        //     setTimeout(function(){ $("tbody tr td:nth-child(1)").css({direction:'ltr'});},300);
        // },
        // rowHover: function(){
        //     changeDirection(1);
        // },
        // rowOver:function(){
        //     changeDirection(1);
        // },
        // rowClick:function(){
        //     changeDirection(1);
        // },
        // doubleClick: function () {
        //     changeDirection(1);
        // },
        // getCellCSSText: function (record) {
        //     if(record.course === undefined){
        //         return "color : red";
        //     }
        // },
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
                ListGrid_Attitude_JspNeedsAssessmentGap.deselectAllRecords();
                ListGrid_Ability_JspNeedsAssessmentGap.deselectAllRecords();
            }
        },
        <%--removeRecordClick(rowNum){--%>
        <%--    removeRecord_JspNeedsAssessment(this.getRecord(rowNum));--%>
        <%--},--%>
        <%--recordDrop(dropRecords, targetRecord, index, sourceWidget) {--%>
        <%--    let record = ListGrid_Competence_JspNeedsAssessment.getSelectedRecord();--%>
        <%--    if (checkRecordAsSelected(record, true, "<spring:message code="competence"/>")) {--%>
        <%--        if (sourceWidget.ID === 'ListGrid_SkillAll_JspNeedsAssessment') {--%>
        <%--            for (let i = 0; i < dropRecords.length; i++) {--%>
        <%--                createNeedsAssessmentRecords(createData_JspNeedsAssessment(dropRecords[i], 108));--%>
        <%--                fetchDataDomainsGrid();--%>
        <%--            }--%>
        <%--        }--%>
        <%--    }--%>
        <%--},--%>
        <%--dataChanged(){--%>
        <%--    editing = true;--%>
        <%--    this.Super("dataChanged",arguments);--%>
        <%--},--%>
        getCellCSSText(record) {
            return priorityColor(record);
        },
        <%--recordDoubleClick(viewer, record){--%>
        <%--    updatePriority_JspEditNeedsAssessment(viewer, record);--%>
        <%--},--%>
        <%--selectionChanged(record, state){--%>
        <%--    if(state){--%>
        <%--        selectedRecord = record;--%>
        <%--    }--%>
        <%--}--%>
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
                ListGrid_Knowledge_JspNeedsAssessmentGap.deselectAllRecords();
                ListGrid_Attitude_JspNeedsAssessmentGap.deselectAllRecords();
            }
        },
        <%--removeRecordClick(rowNum){--%>
        <%--    removeRecord_JspNeedsAssessment(this.getRecord(rowNum));--%>
        <%--},--%>
        <%--recordDrop(dropRecords, targetRecord, index, sourceWidget) {--%>
        <%--    let record = ListGrid_Competence_JspNeedsAssessment.getSelectedRecord();--%>
        <%--    if (checkRecordAsSelected(record, true, "<spring:message code="competence"/>")) {--%>
        <%--        if (sourceWidget.ID === 'ListGrid_SkillAll_JspNeedsAssessment') {--%>
        <%--            for (let i = 0; i < dropRecords.length; i++) {--%>
        <%--                createNeedsAssessmentRecords(createData_JspNeedsAssessment(dropRecords[i], 109));--%>
        <%--            }--%>
        <%--        }--%>
        <%--    }--%>
        <%--},--%>
        <%--dataChanged(){--%>
        <%--    editing = true;--%>
        <%--    this.Super("dataChanged",arguments);--%>
        <%--},--%>
        getCellCSSText: function (record) {
            return priorityColor(record);
        },
        <%--recordDoubleClick(viewer, record){--%>
        <%--    updatePriority_JspEditNeedsAssessment(viewer, record);--%>
        <%--},--%>
        <%--selectionChanged(record, state){--%>
        <%--    if(state){--%>
        <%--        selectedRecord = record;--%>
        <%--    }--%>
        <%--}--%>
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
                ListGrid_Knowledge_JspNeedsAssessmentGap.deselectAllRecords();
                ListGrid_Ability_JspNeedsAssessmentGap.deselectAllRecords();
            }
        },
        <%--removeRecordClick(rowNum){--%>
        <%--    removeRecord_JspNeedsAssessment(this.getRecord(rowNum));--%>
        <%--},--%>
        <%--recordDrop(dropRecords, targetRecord, index, sourceWidget) {--%>
        <%--    let record = ListGrid_Competence_JspNeedsAssessment.getSelectedRecord();--%>
        <%--    if (checkRecordAsSelected(record, true, "<spring:message code="competence"/>")) {--%>
        <%--        if (sourceWidget.ID === 'ListGrid_SkillAll_JspNeedsAssessment') {--%>
        <%--            for (let i = 0; i < dropRecords.length; i++) {--%>
        <%--                createNeedsAssessmentRecords(createData_JspNeedsAssessment(dropRecords[i], 110));--%>
        <%--                // DataSource_Skill_JspNeedsAssessment.addData(data);--%>
        <%--                // createNeedsAssessmentRecords(data);--%>
        <%--                // this.fetchData();--%>
        <%--                // fetchDataDomainsGrid()--%>
        <%--            }--%>
        <%--        }--%>
        <%--    }--%>
        <%--},--%>
        // dataChanged(){
        //     editing = true;
        //     this.Super("dataChanged",arguments);
        // },
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
        // recordDoubleClick(viewer, record){
        //     updatePriority_JspEditNeedsAssessment(viewer, record);
        // },
        // selectionChanged(record, state){
        //     if(state){
        //         selectedRecord = record;
        //     }
        // }

    });
    let Window_AddCourseGap = isc.Window.create({
        title: "لیست دوره ها",
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


    <%--let DynamicForm_JspEditNeedsAssessment = isc.DynamicForm.create({--%>
    <%--    ID: "DynamicForm_JspEditNeedsAssessment",--%>
    <%--    numCols: 2,--%>
    <%--    // readOnlyDisplay: "readOnly",--%>
    <%--    fields: [--%>
    <%--        {--%>
    <%--            name: "objectType",--%>
    <%--            showTitle: false,--%>
    <%--            optionDataSource: NeedsAssessmentTargetDS_needsAssessment,--%>
    <%--            valueField: "code",--%>
    <%--            displayField: "title",--%>
    <%--            defaultValue: "Job",--%>
    <%--            autoFetchData: false,--%>
    <%--            pickListFields: [{name: "title"}],--%>
    <%--            defaultToFirstOption: true,--%>
    <%--            pickListProperties: {--%>
    <%--                showFilterEditor: false,--%>
    <%--                autoFitWidthApproach: "both",--%>
    <%--            },--%>
    <%--            changed: function (form, item, value, oldValue) {--%>
    <%--                if(value !== oldValue) {--%>
    <%--                    updateObjectIdLG(form, value);--%>
    <%--                    clearAllGrid();--%>
    <%--                    form.getItem("objectId").clearValue();--%>
    <%--                    Label_PlusData_JspNeedsAssessment.setContents("");--%>
    <%--                    // refreshPersonnelLG();--%>
    <%--                }--%>
    <%--            },--%>
    <%--        },--%>
    <%--        {--%>
    <%--            name: "objectId",--%>
    <%--            showTitle: false,--%>
    <%--            optionDataSource: JobDs_needsAssessment,--%>
    <%--            editorType: "ComboBoxItem",--%>
    <%--            valueField: "id",--%>
    <%--            displayField: "titleFa",--%>
    <%--            filterFields: ["code","titleFa"],--%>
    <%--            autoFetchData: false,--%>
    <%--            textMatchStyle: "substring",--%>
    <%--            pickListProperties: {--%>
    <%--                showFilterEditor: false,--%>
    <%--                autoFitWidthApproach: "both",--%>
    <%--            },--%>
    <%--            pickListFields: [--%>
    <%--                {name: "code"},--%>
    <%--                {name: "titleFa"}--%>
    <%--            ],--%>
    <%--            click: function(form, item){--%>
    <%--                item.fetchData();--%>
    <%--                // updateObjectIdLG(form, form.getValue("objectType"));--%>
    <%--                // if(form.getValue("objectType") === "Post"){--%>
    <%--                // PostDs_needsAssessment.fetchDataURL = postUrl + "/spec-list";--%>
    <%--                // Window_AddPost_JspNeedsAssessment.show();--%>
    <%--                // }--%>
    <%--            },--%>
    <%--            changed: function (form, item, value, oldValue) {--%>
    <%--                if(value !== oldValue){--%>
    <%--                    editNeedsAssessmentRecord(DynamicForm_JspEditNeedsAssessment.getValue("objectId"), DynamicForm_JspEditNeedsAssessment.getValue("objectType"));--%>
    <%--                    // refreshPersonnelLG();--%>
    <%--                    updateLabelEditNeedsAssessment(item.getSelectedRecord());--%>
    <%--                }--%>
    <%--            },--%>
    <%--        },--%>
    <%--        // {name: "btnCourseDetail", type:"Button", title:"جزئیات دوره", startRow: false},--%>
    <%--    ]--%>
    <%--});--%>
    <%--let DynamicForm_CopyOf_JspEditNeedsAssessment = isc.DynamicForm.create({--%>
    <%--    ID: "DynamicForm_CopyOf_JspEditNeedsAssessment",--%>
    <%--    margin: 10,--%>
    <%--    numCols: 2,--%>
    <%--    fields: [--%>
    <%--        {--%>
    <%--            name: "objectType",--%>
    <%--            showTitle: false,--%>
    <%--            optionDataSource: NeedsAssessmentTargetDS_needsAssessment,--%>
    <%--            valueField: "code",--%>
    <%--            displayField: "title",--%>
    <%--            defaultValue: "Job",--%>
    <%--            autoFetchData: false,--%>
    <%--            required: true,--%>
    <%--            pickListProperties: {--%>
    <%--                showFilterEditor: false,--%>
    <%--                autoFitWidthApproach: "both",--%>
    <%--            },--%>
    <%--            pickListFields: [{name: "title"}],--%>
    <%--            defaultToFirstOption: true,--%>
    <%--            changed: function (form, item, value, oldValue) {--%>
    <%--                if(value !== oldValue) {--%>
    <%--                    updateObjectIdLG(form, value);--%>
    <%--                    form.getItem("objectId").clearValue();--%>
    <%--                }--%>
    <%--            },--%>
    <%--        },--%>
    <%--        {--%>
    <%--            name: "objectId",--%>
    <%--            showTitle: false,--%>
    <%--            optionDataSource: JobDs_needsAssessment,--%>
    <%--            editorType: "ComboBoxItem",--%>
    <%--            valueField: "id",--%>
    <%--            width: 500,--%>
    <%--            displayField: "titleFa",--%>
    <%--            filterFields: ["code","titleFa"],--%>
    <%--            textMatchStyle: "substring",--%>
    <%--            generateExactMatchCriteria: true,--%>
    <%--            required: true,--%>
    <%--            pickListProperties: {--%>
    <%--                showFilterEditor: false,--%>
    <%--                autoFitWidthApproach: "both",--%>
    <%--            },--%>
    <%--            pickListFields: [--%>
    <%--                {name: "titleFa", title: "<spring:message code="title"/>"},--%>
    <%--                {name: "code", title: "<spring:message code="code"/>"}--%>
    <%--            ],--%>
    <%--            click: function(form, item){--%>
    <%--                item.fetchData();--%>
    <%--            },--%>
    <%--            changed: function (form, item, value, oldValue) {--%>
    <%--                if(value !== oldValue){--%>
    <%--                }--%>
    <%--            },--%>
    <%--        },--%>
    <%--        {--%>
    <%--            title: "تایید",--%>
    <%--            colSpan: 2,--%>
    <%--            width:100,--%>
    <%--            type:"Button",--%>
    <%--            align: "center",--%>
    <%--            click: function(form, item) {--%>
    <%--                if (form.validate()) {--%>
    <%--                    Menu_JspEditNeedsAssessment.hideContextMenu();--%>
    <%--                    let url = needsAssessmentUrl + "/getValuesForCopyNA/" + DynamicForm_CopyOf_JspEditNeedsAssessment.getValue("objectType")--%>
    <%--                        + "/" + DynamicForm_CopyOf_JspEditNeedsAssessment.getValue("objectId") + "/" + DynamicForm_JspEditNeedsAssessment.getValue("objectType")--%>
    <%--                        + "/" + DynamicForm_JspEditNeedsAssessment.getValue("objectId");--%>
    <%--                    wait.show();--%>
    <%--                    isc.RPCManager.sendRequest(TrDSRequest(url, "GET", null,(resp)=>{--%>
    <%--                        wait.close();--%>
    <%--                        if (resp.httpResponseCode !== 200) {--%>
    <%--                            createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");--%>
    <%--                            return;--%>
    <%--                        }--%>
    <%--                        editNeedsAssessmentRecord(DynamicForm_JspEditNeedsAssessment.getValue("objectId"),DynamicForm_JspEditNeedsAssessment.getValue("objectType"), JSON.parse(resp.data));--%>
    <%--                        hasChanged = true;--%>
    <%--                        canSendToWorkFlowNA = true;--%>
    <%--                    }));--%>
    <%--                }--%>
    <%--            }--%>
    <%--        }--%>
    <%--    ]--%>
    <%--});--%>

    <%--let Menu_JspEditNeedsAssessment = isc.Menu.create({--%>
    <%--    // ID: "menu",--%>
    <%--    // title:"کپی از",--%>
    <%--    // autoDraw: false,--%>
    <%--    // showShadow: true,--%>
    <%--    // width: 505,--%>
    <%--    // height: 440,--%>
    <%--    // borderRadius: 5,--%>
    <%--    margin: 1,--%>
    <%--    data:[--%>
    <%--        {--%>
    <%--            // title: "Edit",--%>
    <%--            // showRollOver: false,--%>
    <%--            embeddedComponent: isc.TrVLayout.create({--%>
    <%--                // autoDraw: false,--%>
    <%--                // height: "100%",--%>
    <%--                // snapTo: "TR",--%>
    <%--                // membersMargin: 3,--%>
    <%--                // layoutRightMargin: 3,--%>
    <%--                // defaultLayoutAlign: "center",--%>
    <%--                members: [--%>
    <%--                    DynamicForm_CopyOf_JspEditNeedsAssessment--%>
    <%--                ]--%>
    <%--            }),--%>
    <%--            // embeddedComponentFields: ["key"]--%>
    <%--        },--%>
    <%--    ]--%>
    <%--});--%>
    <%--let Button_CopyOf_JspEditNeedsAssessment = isc.MenuButton.create({--%>
    <%--    // ID: "menuButton",--%>
    <%--    // autoDraw: false,--%>
    <%--    // height:20,--%>
    <%--    baseStyle: "toolStripButton",--%>
    <%--    borderRadius: 5,--%>
    <%--    title: "کپی نیازسنجی از",--%>
    <%--    titleAlign: "center",--%>
    <%--    width: 120,--%>
    <%--    menu: Menu_JspEditNeedsAssessment--%>
    <%--});--%>
    <%--let HLayout_Label_PlusData_JspNeedsAssessment = isc.TrHLayout.create({--%>
    <%--    height: "1%",--%>
    <%--    padding:2,--%>
    <%--    members: [--%>
    <%--        Button_CourseDetail_JspEditNeedsAssessment,--%>
    <%--        Button_CopyOf_JspEditNeedsAssessment,--%>
    <%--        Button_changeShow_JspEditNeedsAssessment,--%>
    <%--        Label_PlusData_JspNeedsAssessment,--%>
    <%--    ],--%>
    <%--});--%>

    <%--let Window_show_sort_grids = isc.Window.create({--%>
    <%--    width: "80%",--%>
    <%--    height: "50%",--%>
    <%--    minWidth: 1024,--%>
    <%--    keepInParentRect: true,--%>
    <%--    isModal: true,--%>
    <%--    title:"نمایش لیست مهارت ها بر اساس رنگ اولویت",--%>
    <%--    // autoSize: false,--%>
    <%--    autoSize: false,--%>
    <%--    show(){--%>
    <%--        ListGrid_Knowledge_sort.invalidateCache();--%>
    <%--        ListGrid_Knowledge_sort.fetchData();--%>
    <%--        ListGrid_Ability_sort.invalidateCache();--%>
    <%--        ListGrid_Ability_sort.fetchData();--%>
    <%--        ListGrid_Attitude_sort.invalidateCache();--%>
    <%--        ListGrid_Attitude_sort.fetchData();--%>
    <%--        ListGrid_Knowledge_sort.sort("needsAssessmentPriorityId", "ascending");--%>
    <%--        ListGrid_Ability_sort.sort("needsAssessmentPriorityId", "ascending");--%>
    <%--        ListGrid_Attitude_sort.sort("needsAssessmentPriorityId", "ascending");--%>
    <%--        this.Super("show", arguments);--%>
    <%--    },--%>
    <%--    items: [--%>
    <%--        isc.TrHLayout.create({--%>
    <%--            members: [--%>
    <%--                isc.TrLG.create({--%>
    <%--                    ID: "ListGrid_Knowledge_sort",--%>
    <%--                    autoFetchData:false,--%>
    <%--                    dataSource: DataSource_Skill_JspNeedsAssessment,--%>
    <%--                    showRowNumbers: false,--%>
    <%--                    selectionType:"single",--%>
    <%--                    autoSaveEdits:false,--%>
    <%--                    sortField: 0,--%>
    <%--                    sortDirection: "descending",--%>
    <%--                    implicitCriteria:{"needsAssessmentDomainId":108},--%>
    <%--                    fields: [--%>
    <%--                        {name: "id", hidden: true},--%>
    <%--                        {name: "course.code", align: "center"},--%>
    <%--                        {name: "course.titleFa", align: "center"},--%>
    <%--                        {name: "titleFa", align: "center"},--%>
    <%--                        {name: "skill.code", align: "center",--%>
    <%--                            sortNormalizer: function (record) {--%>
    <%--                                return record.skill.code;--%>
    <%--                            }--%>
    <%--                        },--%>
    <%--                        {name: "objectType"},--%>
    <%--                        {name: "hasWarning", title: "", type: "image", imageURLPrefix: "", imageURLSuffix: ".gif", showTitle:false, canFilter: false},--%>
    <%--                        {name: "needsAssessmentPriorityId", hidden: true}--%>
    <%--                    ],--%>
    <%--                    headerSpans: [--%>
    <%--                        {--%>
    <%--                            fields: ["course.code","course.titleFa","titleFa", "objectType", "skill.code"],--%>
    <%--                            title: "<spring:message code="knowledge"/>"--%>
    <%--                        }],--%>
    <%--                    headerHeight: 50,--%>
    <%--                    gridComponents: [--%>
    <%--                        "filterEditor", "header", "body"--%>
    <%--                    ],--%>
    <%--                    canAcceptDroppedRecords: true,--%>
    <%--                    showHoverComponents: true,--%>
    <%--                    canRemoveRecords:false,--%>
    <%--                    showHeaderContextMenu: false,--%>
    <%--                    showFilterEditor:true,--%>
    <%--                    getCellCSSText(record) {--%>
    <%--                        return priorityColor(record);--%>
    <%--                    }--%>
    <%--                }),--%>
    <%--                isc.TrLG.create({--%>
    <%--                    ID: "ListGrid_Ability_sort",--%>
    <%--                    autoFetchData:false,--%>
    <%--                    dataSource: DataSource_Skill_JspNeedsAssessment,--%>
    <%--                    showRowNumbers: false,--%>
    <%--                    selectionType:"single",--%>
    <%--                    autoSaveEdits:false,--%>
    <%--                    sortField: 0,--%>
    <%--                    sortDirection: "descending",--%>
    <%--                    implicitCriteria:{"needsAssessmentDomainId":109},--%>
    <%--                    contextMenu: Menu_ListGrid_JspENA,--%>
    <%--                    fields: [--%>
    <%--                        {name: "id", hidden: true},--%>
    <%--                        {name: "course.code", align: "center"},--%>
    <%--                        {name: "course.titleFa", align: "center"},--%>
    <%--                        {name: "titleFa", align: "center"},--%>
    <%--                        {name: "skill.code", align: "center",--%>
    <%--                            sortNormalizer: function (record) {--%>
    <%--                                return record.skill.code;--%>
    <%--                            }--%>
    <%--                        },--%>
    <%--                        {name: "objectType"},--%>
    <%--                        {name: "hasWarning", title: "", type: "image", imageURLPrefix: "", imageURLSuffix: ".gif", showTitle:false, canFilter: false},--%>
    <%--                        {name: "needsAssessmentPriorityId", hidden: true}--%>
    <%--                    ],--%>
    <%--                    headerSpans: [--%>
    <%--                        {--%>
    <%--                            fields: ["course.code","course.titleFa","titleFa", "objectType", "skill.code"],--%>
    <%--                            title: "<spring:message code="knowledge"/>"--%>
    <%--                        }],--%>
    <%--                    headerHeight: 50,--%>
    <%--                    gridComponents: [--%>
    <%--                        "filterEditor", "header", "body"--%>
    <%--                    ],--%>
    <%--                    canAcceptDroppedRecords: true,--%>
    <%--                    showHoverComponents: true,--%>
    <%--                    canRemoveRecords:false,--%>
    <%--                    showHeaderContextMenu: false,--%>
    <%--                    showFilterEditor:true,--%>
    <%--                    getCellCSSText(record) {--%>
    <%--                        return priorityColor(record);--%>
    <%--                    }--%>
    <%--                }),--%>
    <%--                isc.TrLG.create({--%>
    <%--                    ID: "ListGrid_Attitude_sort",--%>
    <%--                    autoFetchData:false,--%>
    <%--                    dataSource: DataSource_Skill_JspNeedsAssessment,--%>
    <%--                    showRowNumbers: false,--%>
    <%--                    selectionType:"single",--%>
    <%--                    autoSaveEdits:false,--%>
    <%--                    sortField: 0,--%>
    <%--                    sortDirection: "descending",--%>
    <%--                    implicitCriteria:{"needsAssessmentDomainId":110},--%>
    <%--                    contextMenu: Menu_ListGrid_JspENA,--%>
    <%--                    fields: [--%>
    <%--                        {name: "id", hidden: true},--%>
    <%--                        {name: "course.code", align: "center"},--%>
    <%--                        {name: "course.titleFa", align: "center"},--%>
    <%--                        {name: "titleFa", align: "center"},--%>
    <%--                        {name: "skill.code", align: "center",--%>
    <%--                            sortNormalizer: function (record) {--%>
    <%--                                return record.skill.code;--%>
    <%--                            }--%>
    <%--                        },--%>
    <%--                        {name: "objectType"},--%>
    <%--                        {name: "hasWarning", title: "", type: "image", imageURLPrefix: "", imageURLSuffix: ".gif", showTitle:false, canFilter: false},--%>
    <%--                        {name: "needsAssessmentPriorityId", hidden: true}--%>
    <%--                    ],--%>
    <%--                    headerSpans: [--%>
    <%--                        {--%>
    <%--                            fields: ["course.code","course.titleFa","titleFa", "objectType", "skill.code"],--%>
    <%--                            title: "<spring:message code="knowledge"/>"--%>
    <%--                        }],--%>
    <%--                    headerHeight: 50,--%>
    <%--                    gridComponents: [--%>
    <%--                        "filterEditor", "header", "body"--%>
    <%--                    ],--%>
    <%--                    canAcceptDroppedRecords: true,--%>
    <%--                    showHoverComponents: true,--%>
    <%--                    canRemoveRecords:false,--%>
    <%--                    showHeaderContextMenu: false,--%>
    <%--                    showFilterEditor:true,--%>
    <%--                    getCellCSSText(record) {--%>
    <%--                        return priorityColor(record);--%>
    <%--                    }--%>
    <%--                }),--%>
    <%--            ]--%>
    <%--        })]--%>
    <%--});--%>

    <%--DynamicForm_limit_sufficiency = isc.DynamicForm.create({--%>
    <%--    width: 400,--%>
    <%--    height: "100%",--%>
    <%--    numCols: 2,--%>
    <%--    fields: [--%>
    <%--        {--%>
    <%--            name: "limitSufficiency",--%>
    <%--            title: "حد بسندگی",--%>
    <%--            defaultValue: 0, min: 0,--%>
    <%--            validators: [{--%>
    <%--                type: "integerRange", min: 0, max: 100,--%>
    <%--                errorMessage: "لطفا یک عدد بین 0 تا 100 وارد کنید",--%>
    <%--            }],--%>
    <%--            max:100,--%>
    <%--            length: 3,--%>
    <%--            type: "Integer",--%>
    <%--            keyPressFilter: "[0-9]",--%>
    <%--            required: true},--%>
    <%--    ]--%>
    <%--});--%>



    <%--HLayout_IButtons_limit_sufficiency = isc.HLayout.create({--%>
    <%--    layoutMargin: 5,--%>
    <%--    membersMargin: 15,--%>
    <%--    width: "100%",--%>
    <%--    height: "100%",--%>
    <%--    align: "center",--%>
    <%--    members: [--%>
    <%--        isc.IButtonSave.create({--%>
    <%--            top: 260,--%>
    <%--            layoutMargin: 5,--%>
    <%--            membersMargin: 5,--%>
    <%--            click: async function () {--%>
    <%--                if (!DynamicForm_limit_sufficiency.validate()) {--%>
    <%--                    return;--%>
    <%--                } else {--%>
    <%--                    if (!isFromEdit) {--%>
    <%--                        canInsert = false;--%>
    <%--                        limit = DynamicForm_limit_sufficiency.getItem('limitSufficiency').getValue()--%>
    <%--                        selectedRecordForGap.limitSufficiency = limit--%>
    <%--                        RestDataSource_Competence_JspNeedsAssessment.addData(selectedRecordForGap);--%>
    <%--                        Window_get_limit_sufficiency.close();--%>
    <%--                        ListGrid_AllCompetence_JspNeedsAssessment.rowDoubleClick(selectedRecordForGap)--%>

    <%--                    } else {--%>
    <%--                        canInsert = true;--%>
    <%--                        limit = DynamicForm_limit_sufficiency.getItem('limitSufficiency').getValue()--%>
    <%--                        // selectedRecordForGap.limitSufficiency=limit--%>
    <%--                        // DataSource_Competence_JspNeedsAssessment.addData(selectedRecordForGap);--%>

    <%--                        updateRecord(selectedRecordForGap, limit);--%>


    <%--                        Window_get_limit_sufficiency.close();--%>

    <%--                        // updateListGridsLimit(limit)--%>
    <%--                    }--%>


    <%--                }--%>
    <%--            }--%>
    <%--        }),--%>
    <%--        isc.IButtonCancel.create({--%>
    <%--            layoutMargin: 5,--%>
    <%--            membersMargin: 5,--%>
    <%--            width: 120,--%>
    <%--            click: function () {--%>
    <%--                Window_get_limit_sufficiency.close();--%>
    <%--            }--%>
    <%--        })--%>
    <%--    ]--%>
    <%--});--%>



    <%--let  Window_get_limit_sufficiency = isc.Window.create({--%>
    <%--    title: "افزودن حد بسندگی",--%>
    <%--    width: 450,--%>
    <%--    autoSize: true,--%>
    <%--    autoCenter: true,--%>
    <%--    isModal: true,--%>
    <%--    showModalMask: true,--%>
    <%--    align: "center",--%>
    <%--    autoDraw: false,--%>
    <%--    dismissOnEscape: true,--%>
    <%--    items: [--%>
    <%--        DynamicForm_limit_sufficiency,--%>
    <%--        HLayout_IButtons_limit_sufficiency--%>
    <%--    ]--%>
    <%--});--%>

    <%--var ViewLoader_Eval_Person  = isc.ViewLoader.create({--%>
    <%--    autoDraw:false,--%>
    <%--    width: "1810",--%>
    <%--    height: 900,--%>
    <%--    loadingMessage: " loading! ..."--%>
    <%--});--%>

    <%--var personWindow = isc.Window.create({--%>
    <%--    title: "نمایش نیازسنجی",--%>
    <%--    border: "1px solid gray",--%>
    <%--    // placement:"fillScreen",--%>
    <%--    width: "1820",--%>
    <%--    height: 900,--%>
    <%--    autoSize:true,--%>
    <%--    autoCenter: true,--%>
    <%--    isModal: false,--%>
    <%--    showModalMask: true,--%>
    <%--    autoDraw: false,--%>
    <%--    dismissOnEscape: true,--%>
    <%--    closeClick : function () { this.Super("closeClick", arguments)},--%>
    <%--    items: [--%>
    <%--        ViewLoader_Eval_Person--%>
    <%--    ]--%>
    <%--});--%>

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

    <%--function updateObjectIdLG(form, value) {--%>
    <%--    // form.getItem("objectId").canEdit = true;--%>
    <%--    switch (value) {--%>
    <%--        case 'Job':--%>
    <%--            form.getItem("objectId").optionDataSource = JobDs_needsAssessment;--%>
    <%--            form.getItem("objectId").pickListFields = [--%>
    <%--                {name: "code", title: "<spring:message code="code"/>", autoFitWidth: false},--%>
    <%--                {name: "titleFa", title: "<spring:message code="title"/>", autoFitWidth: false }--%>
    <%--            ];--%>
    <%--            break;--%>
    <%--        case 'JobGroup':--%>
    <%--            form.getItem("objectId").optionDataSource = JobGroupDs_needsAssessment;--%>
    <%--            form.getItem("objectId").pickListFields = [{name: "titleFa", title: "<spring:message code="title"/>", autoFitWidth: false}, {name: "code", title: "<spring:message code="code"/>", autoFitWidth: false}];--%>
    <%--            break;--%>
    <%--        case 'Post':--%>
    <%--            form.getItem("objectId").optionDataSource = PostDs_needsAssessment;--%>
    <%--            form.getItem("objectId").pickListFields = [--%>
    <%--                {name: "code", keyPressFilter: false}, {name: "titleFa"}, {name: "job.titleFa"}, {name: "postGrade.titleFa"}, {name: "area"}, {name: "assistance"}, {name: "affairs"},--%>
    <%--                {name: "section"}, {name: "unit"}, {name: "costCenterCode"}, {name: "costCenterTitleFa"}--%>
    <%--            ];--%>
    <%--            // form.getItem("objectId").canEdit = false;--%>
    <%--            // PostDs_needsAssessment.fetchDataURL = postUrl + "/spec-list";--%>
    <%--            break;--%>
    <%--        case 'PostGroup':--%>
    <%--            form.getItem("objectId").optionDataSource = PostGroupDs_needsAssessment;--%>
    <%--            form.getItem("objectId").pickListFields = [{name: "titleFa", title: "<spring:message code="title"/>", autoFitWidth: false}, {name: "code", title: "<spring:message code="code"/>", autoFitWidth: false}];--%>
    <%--            break;--%>
    <%--        case 'TrainingPost':--%>
    <%--            form.getItem("objectId").optionDataSource = PostDS_TrainingPost;--%>
    <%--            form.getItem("objectId").pickListFields = [--%>
    <%--                {name: "code", keyPressFilter: false}, {name: "titleFa"}, {name: "job.titleFa"}, {name: "postGrade.titleFa"}, {name: "area"}, {name: "assistance"}, {name: "affairs"},--%>
    <%--                {name: "section"}, {name: "unit"}, {name: "costCenterCode"}, {name: "costCenterTitleFa"}--%>
    <%--            ];--%>
    <%--            break;--%>
    <%--        case 'PostGrade':--%>
    <%--            form.getItem("objectId").optionDataSource = PostGradeDs_needsAssessment;--%>
    <%--            form.getItem("objectId").pickListFields = [--%>
    <%--                {name: "code", title: "<spring:message code="code"/>", autoFitWidth: false},--%>
    <%--                {name: "titleFa", title: "<spring:message code="title"/>", autoFitWidth: false}--%>
    <%--            ];--%>
    <%--            break;--%>
    <%--        case 'PostGradeGroup':--%>
    <%--            form.getItem("objectId").optionDataSource = PostGradeGroupDs_needsAssessment;--%>
    <%--            form.getItem("objectId").pickListFields = [--%>
    <%--                {name: "titleFa", title: "<spring:message code="title"/>", autoFitWidth: false},--%>
    <%--                {name: "code", title: "<spring:message code="code"/>", autoFitWidth: false}--%>
    <%--            ];--%>
    <%--            break;--%>
    <%--    }--%>
    <%--}--%>
    <%--function clearAllGrid() {--%>
    <%--    competenceData.length = 0;--%>
    <%--    skillData.length = 0;--%>
    <%--    ListGrid_Competence_JspNeedsAssessment.setData([]);--%>
    <%--    ListGrid_Knowledge_JspNeedsAssessment.setData([]);--%>
    <%--    ListGrid_Attitude_JspNeedsAssessment.setData([]);--%>
    <%--    ListGrid_Ability_JspNeedsAssessment.setData([]);--%>
    <%--}--%>

    <%--function checkSaveData(data, dataSource, field = "skillId", objectType = null) {--%>
    <%--    if(!objectType) {--%>
    <%--        if(dataSource.testData.find(f => f[field] === data[field]) != null) {--%>
    <%--            return false;--%>
    <%--        }--%>
    <%--        return true;--%>
    <%--    }--%>
    <%--    else{--%>
    <%--        if(dataSource.testData.find(f => f[field] === data[field] && f["objectType"] === data["objectType"]) != null){--%>
    <%--            return false;--%>
    <%--        }--%>
    <%--        return true;--%>
    <%--    }--%>
    <%--}--%>
    <%--function fetchDataDomainsGrid(){--%>
    <%--    let record = ListGrid_Competence_JspNeedsAssessment.getSelectedRecord();--%>
    <%--    if(record != null) {--%>
    <%--        ListGrid_Knowledge_JspNeedsAssessment.fetchData({"competenceId":record.id});--%>
    <%--        ListGrid_Knowledge_JspNeedsAssessment.invalidateCache();--%>

    <%--        ListGrid_Ability_JspNeedsAssessment.fetchData({"competenceId":record.id});--%>
    <%--        ListGrid_Ability_JspNeedsAssessment.invalidateCache();--%>

    <%--        ListGrid_Attitude_JspNeedsAssessment.fetchData({"competenceId":record.id});--%>
    <%--        ListGrid_Attitude_JspNeedsAssessment.invalidateCache();--%>
    <%--    }--%>
    <%--}--%>
    <%--function removeRecord_JspNeedsAssessment(record, state=0) {--%>
    <%--    if(record.objectType === DynamicForm_JspEditNeedsAssessment.getValue("objectType")){--%>
    <%--        wait.show();--%>
    <%--        DataSource_Skill_JspNeedsAssessment.removeData(record);--%>
    <%--        hasChanged = true;--%>
    <%--        canSendToWorkFlowNA = true;--%>
    <%--        wait.close();--%>
    <%--        return 1;--%>
    <%--    }--%>
    <%--    else{--%>
    <%--        if(state === 0) {--%>
    <%--            createDialog("info", "فقط نیازسنجی های با مرجع " +'<u><b>'+ priorityList[DynamicForm_JspEditNeedsAssessment.getValue("objectType")] +'</u></b>'+ " قابل حذف است.")--%>
    <%--        }--%>
    <%--        return 2;--%>
    <%--    }--%>
    <%--}--%>

    <%--function editNeedsAssessmentRecord(objectId, objectType, data) {--%>
    <%--    updateObjectIdLG(DynamicForm_JspEditNeedsAssessment, objectType);--%>
    <%--    clearAllGrid();--%>
    <%--    if(!data)--%>
    <%--        isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/editList/" + objectType + "/" + objectId,--%>
    <%--            "GET", null, r => responseToListGrid_All_JspNeedsAssessment(objectId, objectType,--%>
    <%--                JSON.parse(r.data).list)));--%>
    <%--    else {--%>
    <%--        if (data.length === 0)--%>
    <%--            createDialog("info", "مهارتی غیر از مهارت های موجود در این نیازسنجی، در نیازسنجی انتخابی برای کپی وجود ندارد");--%>
    <%--        responseToListGrid_All_JspNeedsAssessment(objectId, objectType, data);--%>
    <%--    }--%>
    <%--}--%>

    <%--function responseToListGrid_All_JspNeedsAssessment(objectId, objectType, data) {--%>
    <%--    let flags  = [];--%>
    <%--    for (let i = 0; i < data.length; i++) {--%>
    <%--        let skill = {};--%>
    <%--        let competence = {};--%>
    <%--        skill.id = data[i].id;--%>
    <%--        skill.titleFa = data[i].skill.titleFa;--%>
    <%--        skill.needsAssessmentPriorityId = data[i].needsAssessmentPriorityId;--%>
    <%--        skill.needsAssessmentDomainId = data[i].needsAssessmentDomainId;--%>
    <%--        skill.skillId = data[i].skillId;--%>
    <%--        skill.competenceId = data[i].competenceId;--%>
    <%--        skill.limitSufficiency = data[i].limitSufficiency;--%>
    <%--        skill.objectId = data[i].objectId;--%>
    <%--        skill.objectType = data[i].objectType;--%>
    <%--        skill.objectName = data[i].objectName;--%>
    <%--        skill.objectCode = data[i].objectCode;--%>
    <%--        skill.skill = data[i].skill;--%>
    <%--        skill.mainWorkflowStatus = data[i].mainWorkflowStatus;--%>
    <%--        if(data[i].skill.course === undefined){--%>
    <%--            skill.hasWarning = "alarm";--%>
    <%--        }--%>
    <%--        else {--%>
    <%--            skill.course = data[i].skill.course;--%>
    <%--        }--%>
    <%--        DataSource_Skill_JspNeedsAssessment.addData(skill);--%>
    <%--        if( flags[data[i].competenceId]) continue;--%>
    <%--        flags[data[i].competenceId] = true;--%>
    <%--        // outPut.push(data[i].competenceId);--%>
    <%--        competence.id = data[i].competenceId;--%>
    <%--        competence.limitSufficiency = data[i].limitSufficiency;--%>
    <%--        competence.title = data[i].competence.title;--%>
    <%--        competence.competenceType = data[i].competence.competenceType;--%>
    <%--        competence.categoryId = data[i].competence.categoryId;--%>
    <%--        competence.subCategoryId = data[i].competence.subCategoryId;--%>
    <%--        competence.code = data[i].competence.code;--%>
    <%--        DataSource_Competence_JspNeedsAssessment.addData(competence, ()=>{ListGrid_Competence_JspNeedsAssessment.selectRecord(0)});--%>
    <%--    }--%>
    <%--    ListGrid_Competence_JspNeedsAssessment.fetchData();--%>
    <%--    ListGrid_Competence_JspNeedsAssessment.emptyMessage = "<spring:message code="msg.no.records.for.show"/>";--%>
    <%--    DynamicForm_JspEditNeedsAssessment.setValue("objectId", objectId);--%>
    <%--    DynamicForm_JspEditNeedsAssessment.setValue("objectType", objectType);--%>
    <%--    fetchDataDomainsGrid();--%>
    <%--}--%>

    <%--function createNeedsAssessmentRecords(data) {--%>
    <%--    if(data === null){--%>
    <%--        return;--%>
    <%--    }--%>
    <%--    if(!checkSaveData(data, DataSource_Skill_JspNeedsAssessment)){--%>
    <%--        createDialog("info", "<spring:message code="exception.duplicate.information"/>", "<spring:message code="error"/>");--%>
    <%--        return;--%>
    <%--    }--%>
    <%--    DataSource_Skill_JspNeedsAssessment.cacheData.unshift(data);--%>
    <%--    fetchDataDomainsGrid();--%>
    <%--    hasChanged = true;--%>
    <%--    canSendToWorkFlowNA = true;--%>
    <%--}--%>
    <%--function createData_JspNeedsAssessment(record, DomainId, PriorityId = 111) {--%>
    <%--    if(record.skillLevelId === 1 && DomainId !== 108){--%>
    <%--        createDialog("info", "مهارت با سطح مهارت آشنایی فقط در حیطه دانشی قرار میگیرد.");--%>
    <%--        return null;--%>
    <%--    }--%>
    <%--    if(record.skillLevelId === 2 && DomainId !== 109){--%>
    <%--        createDialog("info", "مهارت با سطح مهارت توانایی فقط در حیطه توانشی قرار میگیرد.");--%>
    <%--        return null;--%>
    <%--    }--%>
    <%--    let data = {--%>
    <%--        objectType: DynamicForm_JspEditNeedsAssessment.getValue("objectType"),--%>
    <%--        objectId: DynamicForm_JspEditNeedsAssessment.getValue("objectId"),--%>
    <%--        objectName: DynamicForm_JspEditNeedsAssessment.getItem("objectId").getSelectedRecord().titleFa,--%>
    <%--        objectCode: DynamicForm_JspEditNeedsAssessment.getItem("objectId").getSelectedRecord().code,--%>
    <%--        competenceId: ListGrid_Competence_JspNeedsAssessment.getSelectedRecord().id,--%>
    <%--        limitSufficiency: ListGrid_Competence_JspNeedsAssessment.getSelectedRecord().limitSufficiency,--%>
    <%--        skillId: record.id,--%>
    <%--        titleFa: record.titleFa,--%>
    <%--        needsAssessmentPriorityId: PriorityId,--%>
    <%--        needsAssessmentDomainId: DomainId,--%>
    <%--        hasWarning: record.course ? "" : "alarm",--%>
    <%--        course: record.course,--%>
    <%--        skill: record--%>
    <%--    };--%>
    <%--    return data;--%>
    <%--}--%>

    <%--const changeDirection=(status)=>{--%>
    <%--    let classes=".cellAltCol,.cellDarkAltCol, .cellOverAltCol, .cellOverDarkAltCol, .cellSelectedAltCol, .cellSelectedDarkAltCol," +--%>
    <%--        " .cellSelectedOverAltCol, .cellSelectedOverDarkAltCol, .cellPendingSelectedAltCol, .cellPendingSelectedDarkAltCol," +--%>
    <%--        " .cellPendingSelectedOverAltCol, .cellPendingSelectedOverDarkAltCol, .cellDeselectedAltCol, .cellDeselectedDarkAltCol," +--%>
    <%--        " .cellDeselectedOverAltCol, .cellDeselectedOverDarkAltCol, .cellDisabledAltCol, .cellDisabledDarkAltCol";--%>
    <%--    setTimeout(function() {--%>
    <%--        $(classes).css({'direction': 'ltr!important'});--%>
    <%--        if (status==0)--%>
    <%--            $("tbody tr td:nth-child(7)").css({'direction':'ltr'});--%>
    <%--        else--%>
    <%--            $("tbody tr td:nth-child(1)").css({'direction':'ltr'});--%>
    <%--    },10);--%>
    <%--};--%>

    <%--function updateLabelEditNeedsAssessment(objectId) {--%>
    <%--    Label_PlusData_JspNeedsAssessment.setContents("");--%>
    <%--    if(DynamicForm_JspEditNeedsAssessment.getValue("objectType") === "Post" || DynamicForm_JspEditNeedsAssessment.getValue("objectType") === "TrainingPost") {--%>
    <%--        Label_PlusData_JspNeedsAssessment.setContents(--%>
    <%--            (objectId.titleFa !== undefined ? '<b>عنوان پست: </b>' +  objectId.titleFa : "")--%>
    <%--            + "&nbsp;&nbsp;&nbsp;&nbsp;" +--%>
    <%--            (objectId.area !== undefined ? "<b>حوزه: </b>" + objectId.area : "")--%>
    <%--            + "&nbsp;&nbsp;&nbsp;&nbsp;" +--%>
    <%--            (objectId.assistance !== undefined ? "<b>معاونت: </b>" + objectId.assistance : "")--%>
    <%--            + "&nbsp;&nbsp;&nbsp;&nbsp;" +--%>
    <%--            (objectId.affairs !== undefined ? "<b>واحد: </b>" + objectId.affairs : "")--%>
    <%--        );--%>
    <%--    }--%>
    <%--}--%>
    <%--async function updatePriority_JspEditNeedsAssessment(viewer, record) {--%>
    <%--    if (record.objectType === DynamicForm_JspEditNeedsAssessment.getValue("objectType")) {--%>
    <%--        let priority = null;--%>
    <%--        if(record.needsAssessmentPriorityId === 113)--%>
    <%--            priority = 574;--%>
    <%--        else if (record.needsAssessmentPriorityId === 574)--%>
    <%--            priority = 111;--%>
    <%--        else--%>
    <%--            priority = record.needsAssessmentPriorityId + 1;--%>
    <%--        let updating = {--%>
    <%--            objectType: record.objectType,--%>
    <%--            objectId: record.objectId,--%>
    <%--            needsAssessmentPriorityId: priority--%>
    <%--        };--%>
    <%--        wait.show();--%>
    <%--        // let id = record.id--%>
    <%--        // if (id === undefined) {--%>
    <%--        let dataForNewSkill= {};--%>
    <%--        dataForNewSkill.list=DataSource_Skill_JspNeedsAssessment.cacheData;--%>
    <%--        dataForNewSkill.skillId=record.skillId;--%>
    <%--        if (dataForNewSkill.list.length !== 0) {--%>

    <%--            isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl+"/createOrUpdateListForNewSkill" , "POST", JSON.stringify(dataForNewSkill),--%>
    <%--                function (resp) {--%>

    <%--                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {--%>
    <%--                        changePriority(resp.httpResponseText, updating, record, viewer);--%>
    <%--                    }--%>
    <%--                }--%>

    <%--            ));--%>

    <%--        }--%>

    <%--        // } else {--%>
    <%--        //     changePriority(id, updating, record, viewer);--%>

    <%--        // }--%>
    <%--    } else {--%>
    <%--        createDialog("info", "فقط نیازسنجی های مرتبط با " + priorityList[DynamicForm_JspEditNeedsAssessment.getValue("objectType")] + " قابل تغییر است.")--%>
    <%--    }--%>
    <%--}--%>
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

    <%--let ListGrid_SkillAll_JspNeedsAssessment_Refresh = ()=>{--%>
    <%--    let record = ListGrid_Competence_JspNeedsAssessment.getSelectedRecord();--%>
    <%--    if(record == null){--%>
    <%--        ListGrid_SkillAll_JspNeedsAssessment.setData([]);--%>
    <%--    }else{--%>
    <%--        let cr = {};--%>
    <%--        if(record.subCategoryId != null) {--%>
    <%--            cr = {--%>
    <%--                _constructor: "AdvancedCriteria",--%>
    <%--                operator: "and",--%>
    <%--                criteria: [--%>
    <%--                    {fieldName: "subCategoryId", operator: "equals", value: record.subCategoryId},--%>
    <%--                ]--%>
    <%--            }--%>
    <%--        }--%>
    <%--        ListGrid_SkillAll_JspNeedsAssessment.setImplicitCriteria(cr);--%>
    <%--        ListGrid_SkillAll_JspNeedsAssessment.invalidateCache();--%>
    <%--        ListGrid_SkillAll_JspNeedsAssessment.fetchData();--%>
    <%--    }--%>
    <%--}--%>


    function loadEditNeedsAssessmentGap(record, type, state = "R&W",isFromGap) {
        gapObjectId=record.id
            gapObjectType=type

        // DataSource_Skill_JspNeedsAssessmentGap.fetchDataURL = needAssessmentWithGap + "iscList/"+gapObjectType+"/"+gapObjectId;
        ListGrid_Knowledge_JspNeedsAssessmentGap.fetchData();
        ListGrid_Knowledge_JspNeedsAssessmentGap.invalidateCache();
        ListGrid_Ability_JspNeedsAssessmentGap.fetchData();
        ListGrid_Ability_JspNeedsAssessmentGap.invalidateCache();
        ListGrid_Attitude_JspNeedsAssessmentGap.fetchData();
        ListGrid_Attitude_JspNeedsAssessmentGap.invalidateCache();
        <%--isGap=isFromGap--%>
        <%--canInsert=isFromGap--%>
        <%--ListGrid_Knowledge_JspNeedsAssessment.unsort();--%>
        <%--ListGrid_Ability_JspNeedsAssessment.unsort();--%>
        <%--ListGrid_Attitude_JspNeedsAssessment.unsort();--%>


        <%--if (ListGrid_SkillAll_JspNeedsAssessment) {--%>
        <%--    ListGrid_SkillAll_JspNeedsAssessment.clearFilterValues();--%>
        <%--}--%>

        <%--if(state === "read"){--%>
        <%--    DynamicForm_JspEditNeedsAssessment.disable()--%>
        <%--}--%>
        <%--else {--%>
        <%--    wait.show();--%>
        <%--    isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/isReadOnly/" + type + "/" + objectId.id, "GET", null, (resp) => {--%>
        <%--        wait.close();--%>
        <%--        if(resp.httpResponseCode !== 200){--%>
        <%--            if (JSON.parse(resp.httpResponseText).errors && JSON.parse(resp.httpResponseText).errors.size() > 0) {--%>
        <%--                createDialog("info", JSON.parse(resp.httpResponseText).errors[0].field);--%>
        <%--                buttonSave.disable();--%>
        <%--                buttonSendToWorkFlow.disable();--%>
        <%--                buttonChangeCancel.disable();--%>
        <%--                return;--%>
        <%--            }--%>
        <%--            createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");--%>
        <%--            return;--%>
        <%--        }--%>
        <%--        updateObjectIdLG(DynamicForm_JspEditNeedsAssessment, type);--%>
        <%--        DynamicForm_JspEditNeedsAssessment.setValue("objectType", type);--%>
        <%--        DynamicForm_JspEditNeedsAssessment.setValue("objectId", objectId.id);--%>
        <%--        clearAllGrid();--%>
        <%--        editNeedsAssessmentRecord(objectId.id, type);--%>
        <%--        // refreshPersonnelLG(objectId);--%>
        <%--        updateLabelEditNeedsAssessment(objectId);--%>
        <%--        if (resp.data === "true") {--%>
        <%--            readOnly(true);--%>
        <%--            fetch(needsAssessmentUrl + "/isCreatedByCurrentUser/" + type + "/" + objectId.id,{headers: apiHeader}).then(r => r.json()).then(d => {--%>
        <%--                if(d == false)--%>
        <%--                    createDialog("info", "<spring:message code='na.message.doesnot.access.to.others.assessment'/>");--%>
        <%--                else--%>
        <%--                    readOnly(false);--%>
        <%--            });--%>
        <%--        }--%>
        <%--        else{--%>
        <%--            readOnly(false);--%>
        <%--        }--%>
        <%--    }))--%>
        <%--}--%>
    }
<%--    function readOnly(status){--%>
<%--        if(status === true){--%>
<%--            buttonSave.disable();--%>
<%--            buttonSendToWorkFlow.disable();--%>
<%--            buttonChangeCancel.disable();--%>
<%--            DynamicForm_JspEditNeedsAssessment.disable();--%>
<%--            CompetenceTS_needsAssessment.disable();--%>
<%--            ListGrid_Knowledge_JspNeedsAssessment.disable();--%>
<%--            ListGrid_Ability_JspNeedsAssessment.disable();--%>
<%--            ListGrid_Attitude_JspNeedsAssessment.disable();--%>
<%--            Button_changeShow_JspEditNeedsAssessment.show();--%>
<%--            Button_CopyOf_JspEditNeedsAssessment.hide();--%>
<%--            ToolStrip_JspNeedsAssessment.disable();--%>
<%--        }--%>
<%--        else {--%>
<%--            buttonSave.enable();--%>
<%--            buttonSendToWorkFlow.enable();--%>
<%--            buttonChangeCancel.enable();--%>
<%--            DynamicForm_JspEditNeedsAssessment.enable();--%>
<%--            CompetenceTS_needsAssessment.enable();--%>
<%--            ListGrid_Knowledge_JspNeedsAssessment.enable();--%>
<%--            ListGrid_Ability_JspNeedsAssessment.enable();--%>
<%--            ListGrid_Attitude_JspNeedsAssessment.enable();--%>
<%--            Button_CopyOf_JspEditNeedsAssessment.show();--%>
<%--            ToolStrip_JspNeedsAssessment.enable();--%>
<%--            Button_changeShow_JspEditNeedsAssessment.hide();--%>
<%--        }--%>

<%--    }--%>

<%--    function isReadOnly(id, type){--%>
<%--        wait.show();--%>
<%--        isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/isReadOnly/" + type + "/" + id, "GET", null, (resp) => {--%>
<%--            wait.close();--%>
<%--            if (resp.httpResponseCode !== 200) {--%>
<%--                createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");--%>
<%--                return true;--%>
<%--            }--%>
<%--            return resp.data === "true";--%>
<%--        }))--%>
<%--    }--%>

<%--    // <<---------------------------------------- Send To Workflow ------------------------------------------%>
<%--    function sendNeedsAssessmentToWorkflow(mustSend) {--%>
<%--        wait.close();--%>
<%--        isc.MyYesNoDialog.create({--%>
<%--            message: "<spring:message code="needs.assessment.sent.to.workflow.ask"/>",--%>
<%--            title: "<spring:message code="message"/>",--%>
<%--            buttonClick: function (button, index) {--%>
<%--                this.close();--%>
<%--                if (index === 0) {--%>
<%--                    if (mustSend) {--%>
<%--                        let param={}--%>
<%--                        param.data={--%>
<%--                            "processDefinitionKey": "نیازسنجی",--%>
<%--                            "title": "تغییر نیازسنجی " + priorityList[DynamicForm_JspEditNeedsAssessment.getValue("objectType")] + " : " + DynamicForm_JspEditNeedsAssessment.getItem("objectId").getSelectedRecord().titleFa + (DynamicForm_JspEditNeedsAssessment.getItem("objectId").getSelectedRecord().code !== undefined ? " با کد : " + DynamicForm_JspEditNeedsAssessment.getItem("objectId").getSelectedRecord().code : "")--%>
<%--                        }--%>
<%--                        param.rq= {--%>
<%--                            "id": DynamicForm_JspEditNeedsAssessment.getValue("objectId"),--%>
<%--                            "type": DynamicForm_JspEditNeedsAssessment.getValue("objectType"),--%>
<%--                            "title": "تغییر نیازسنجی " + priorityList[DynamicForm_JspEditNeedsAssessment.getValue("objectType")] + " : " + DynamicForm_JspEditNeedsAssessment.getItem("objectId").getSelectedRecord().titleFa + (DynamicForm_JspEditNeedsAssessment.getItem("objectId").getSelectedRecord().code !== undefined ? " با کد : " + DynamicForm_JspEditNeedsAssessment.getItem("objectId").getSelectedRecord().code : "")--%>
<%--                            // "competenceTypeId": record.competenceTypeId,--%>
<%--                            // "code": record.code,--%>
<%--                            // "categoryId": record.categoryId,--%>
<%--                            // "subCategoryId": record.subCategoryId,--%>
<%--                            // "description": record.description,--%>
<%--                            // "workFlowStatusCode": method !== "POST" ? 4 : 0,--%>
<%--                        };--%>

<%--                        let varParams = [{--%>
<%--                            "processKey": "needAssessment_MainWorkflow",--%>
<%--                            "cId": DynamicForm_JspEditNeedsAssessment.getValue("objectId"),--%>
<%--                            "objectName": "تغییر نیازسنجی " + priorityList[DynamicForm_JspEditNeedsAssessment.getValue("objectType")] + " : " + DynamicForm_JspEditNeedsAssessment.getItem("objectId").getSelectedRecord().titleFa + (DynamicForm_JspEditNeedsAssessment.getItem("objectId").getSelectedRecord().code !== undefined ? " با کد : " + DynamicForm_JspEditNeedsAssessment.getItem("objectId").getSelectedRecord().code : ""),--%>
<%--                            "objectType": priorityList[DynamicForm_JspEditNeedsAssessment.getValue("objectType")],--%>
<%--                            "needAssessmentCreatorId": "${username}",--%>
<%--                            "needAssessmentCreator": userFullName,--%>
<%--                            "REJECTVAL": "",--%>
<%--                            "REJECT": "",--%>
<%--                            "target": "/course/show-form",--%>
<%--                            "targetTitleFa": "نیازسنجی",--%>
<%--                            "workflowStatus": "ثبت اولیه",--%>
<%--                            "workflowStatusCode": "0",--%>
<%--                            "workFlowName": "NeedAssessment",--%>
<%--                            "cType": DynamicForm_JspEditNeedsAssessment.getValue("objectType")--%>
<%--                        }];--%>
<%--                        wait.show();--%>
<%--                        isc.RPCManager.sendRequest(TrDSRequest(bpmsUrl + "/processes/need-assessment/start-data-validation", "POST", JSON.stringify(param), startProcess_callback));--%>
<%--                        // isc.RPCManager.sendRequest(TrDSRequest(workflowUrl + "/startProcess", "POST", JSON.stringify(varParams), startProcess_callback));--%>
<%--                    } else {--%>
<%--                        let url = needsAssessmentUrl.concat("/updateWorkFlowStatesToSent?objectId=")--%>
<%--                            .concat(DynamicForm_JspEditNeedsAssessment.getValue("objectId"))--%>
<%--                            .concat("&objectType=")--%>
<%--                            .concat(DynamicForm_JspEditNeedsAssessment.getValue("objectType"));--%>
<%--                        fetch(url, {headers: apiHeader, method: "POST"})--%>
<%--                            .then(resp => {--%>
<%--                                if(resp.status === 500) {--%>
<%--                                    createDialog("info", resp.errors[0].field);--%>
<%--                                    canSendToWorkFlowNA = true;--%>
<%--                                    return;--%>
<%--                                }--%>
<%--                                if(resp.status === 200) {--%>
<%--                                    simpleDialog("<spring:message code="message"/>", "<spring:message code='course.changes.set.on.workflow.engine'/>", 3000, "say");--%>
<%--                                    Window_NeedsAssessment_Edit.close(0);--%>
<%--                                    canSendToWorkFlowNA = false;--%>
<%--                                    return ;--%>
<%--                                }--%>
<%--                                else {--%>
<%--                                    canSendToWorkFlowNA = true;--%>
<%--                                    createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");--%>
<%--                                }--%>
<%--                            });--%>
<%--                    }--%>
<%--                }--%>
<%--            }--%>
<%--        });--%>
<%--    }--%>

<%--    async function sendNeedsAssessmentForSaving() {--%>
<%--        let data = DataSource_Skill_JspNeedsAssessment.cacheData;--%>
<%--        if (data.length == 0) {--%>
<%--            createDialog("info", "<spring:message code="msg.error.list.cant.be.empty"/>")--%>
<%--            return [false ,false];--%>
<%--        }--%>
<%--        let f = await fetch(needsAssessmentUrl+"/createOrUpdateList", {headers: apiHeader, method: "POST", body: JSON.stringify(data)});--%>
<%--        let hasAlreadySentToWorkFlow = await f.json();--%>
<%--        if(f.status === 500) {--%>
<%--            createDialog("info", hasAlreadySentToWorkFlow.errors[0].field);--%>
<%--            return [false ,false];--%>
<%--        }--%>
<%--        if(f.status === 200) {--%>
<%--            return [true ,(hasAlreadySentToWorkFlow == false)];--%>
<%--        }--%>
<%--        else {--%>
<%--            createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");--%>
<%--            return [false ,false];--%>
<%--        }--%>
<%--    }--%>

<%--    function startProcess_callback(resp) {--%>
<%--        wait.close()--%>
<%--        if (resp.httpResponseCode === 200) {--%>
<%--            simpleDialog("<spring:message code="message"/>", "<spring:message code='course.set.on.workflow.engine'/>", 3000, "say");--%>
<%--            Window_NeedsAssessment_Edit.close(0);--%>
<%--        } else if (resp.httpResponseCode === 404) {--%>
<%--            simpleDialog("<spring:message code="message"/>", "<spring:message code='workflow.bpmn.not.uploaded'/>", 3000, "stop");--%>
<%--        } else {--%>
<%--            simpleDialog("<spring:message code="message"/>", "<spring:message code='msg.send.to.workflow.problem'/>", 3000, "stop");--%>
<%--        }--%>
<%--    }--%>


<%--    async    function addNewSkillForChangePriority(data) {--%>


<%--    }--%>

<%--    function changePriority(id,updating,record,viewer ) {--%>
<%--        isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/" +id, "PUT", JSON.stringify(updating), function (resp) {--%>
<%--            wait.close()--%>
<%--            if (resp.httpResponseCode === 409) {--%>
<%--                createDialog("info", resp.httpResponseText);--%>
<%--                return 0;--%>
<%--            } else if (resp.httpResponseCode !== 200) {--%>
<%--                createDialog("info", "<spring:message code='error'/>");--%>
<%--                return;--%>
<%--            }--%>
<%--            let priority = null;--%>
<%--            if(record.needsAssessmentPriorityId === 113)--%>
<%--                priority = 574;--%>
<%--            else if (record.needsAssessmentPriorityId === 574)--%>
<%--                priority = 111;--%>
<%--            else--%>
<%--                priority = record.needsAssessmentPriorityId + 1;--%>
<%--            record.needsAssessmentPriorityId = priority;--%>
<%--            DataSource_Skill_JspNeedsAssessment.updateData(record);--%>
<%--            hasChanged = true;--%>
<%--            canSendToWorkFlowNA = true;--%>
<%--            viewer.endEditing();--%>
<%--        }));--%>

<%--    }--%>
    async function saveAndSendToWorkFlow() {
        // if (hasChanged) {
        //     let [isSaved, mustSent] = await sendNeedsAssessmentForSaving();
        //     if (!isSaved)
        //         return;
        //     sendNeedsAssessmentToWorkflow(mustSent);
        // } else {
        //     canSendToWorkFlowNA = false;
        //     let [isSaved, mustSent] = await sendNeedsAssessmentForSaving();
        //     if (!isSaved)
        //         return;
        //     sendNeedsAssessmentToWorkflow(mustSent);
        //  }
    }
    async function save() {
        // if (hasChanged || isGap) {
        //     wait.show();
        //     let [isSaved] = await sendNeedsAssessmentForSaving();
        //     wait.close();
        //     if (isSaved) createDialog("info","تغییرات ذخیره شد.");
        //     if (!isSaved)
        //         return;
        // } else
        //     return;
        //
    }


<%--    function updateRecord(record,limitSufficiency) {--%>
<%--// zaza--%>
<%--        record.limitSufficiency = limitSufficiency;--%>
<%--        DataSource_Competence_JspNeedsAssessment.updateData(record);--%>


<%--        let data = ListGrid_Knowledge_JspNeedsAssessment.data.localData.toArray();--%>
<%--        data.addAll(ListGrid_Attitude_JspNeedsAssessment.data.localData.toArray());--%>
<%--        data.addAll(ListGrid_Ability_JspNeedsAssessment.data.localData.toArray());--%>
<%--        if (data.length !== 0) {--%>
<%--            let rec = data[0]--%>
<%--            let changedData = {}--%>
<%--            changedData.objectId=rec.objectId--%>
<%--            changedData.objectType=rec.objectType--%>
<%--            rec.limitSufficiency = limitSufficiency;--%>
<%--            isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/update-limitSufficiency/" + record.id+"/"+limitSufficiency, "PUT",JSON.stringify(changedData), function (resp) {--%>
<%--                if (resp.httpResponseCode !== 200) {--%>
<%--                    createDialog("info", "<spring:message code='error'/>");--%>
<%--                    return false--%>
<%--                }--%>

<%--            }));--%>

<%--            for (let i = 0; i < data.length; i++) {--%>
<%--                let rec = data[i]--%>
<%--                rec.limitSufficiency = limitSufficiency;--%>
<%--                DataSource_Skill_JspNeedsAssessment.updateData(rec);--%>
<%--            }--%>

<%--        }--%>
<%--    }--%>
<%--    function updatePriority_AllSelectedRecords(records, priorityId) {--%>

<%--        wait.show();--%>
<%--        records.forEach(rec => {--%>

<%--            let dataForNewSkill= {};--%>
<%--            dataForNewSkill.list=DataSource_Skill_JspNeedsAssessment.cacheData;--%>
<%--            dataForNewSkill.skillId=rec.skillId;--%>
<%--            if (dataForNewSkill.list.length !== 0) {--%>
<%--                isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl+"/createOrUpdateListForNewSkill" , "POST", JSON.stringify(dataForNewSkill), function (resp) {--%>
<%--                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {--%>

<%--                        let updating = {--%>
<%--                            objectId: rec.objectId,--%>
<%--                            objectType: rec.objectType,--%>
<%--                            needsAssessmentPriorityId: priorityId--%>
<%--                        };--%>

<%--                        isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl+ "/"+ resp.httpResponseText, "PUT", JSON.stringify(updating), function (resp) {--%>
<%--                            if (resp.httpResponseCode === 409) {--%>
<%--                                createDialog("info", resp.httpResponseText);--%>
<%--                                return;--%>
<%--                            } else if (resp.httpResponseCode !== 200) {--%>
<%--                                createDialog("info", "<spring:message code='error'/>");--%>
<%--                                return;--%>
<%--                            }--%>
<%--                            rec.needsAssessmentPriorityId = priorityId;--%>
<%--                            DataSource_Skill_JspNeedsAssessment.updateData(rec);--%>
<%--                        }));--%>
<%--                    }--%>
<%--                }));--%>
<%--            }--%>

<%--        });--%>
<%--        wait.close();--%>
<%--    }--%>
    function checkSaveDataGap(data, dataSource, field) {
            return dataSource.testData.find(f => f[field] === data[field]) == null;
    }
    // ---------------------------------------- Send To Workflow ---------------------------------------->>

    // </script>
