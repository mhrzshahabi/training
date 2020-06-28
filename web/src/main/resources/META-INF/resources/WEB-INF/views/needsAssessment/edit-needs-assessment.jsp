<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>

    // var view_ENA = null;
    const yellow ="#d6d216";
    const red = "#ff8abc";
    const green = "#5dd851";
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
    var RestDataSource_Competence_JspNeedsAssessment = isc.TrDS.create({
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
    var RestDataSource_category_JspCourse = isc.TrDS.create({
        ID: "categoryDS",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: categoryUrl + "spec-list",
    });
    var RestDataSource_subCategory_JspCourse = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: subCategoryUrl + "spec-list",
    });
    <%--let RestDataSource_Personnel_JspNeedsAssessment = isc.TrDS.create({--%>
        <%--fields: [--%>
            <%--{name: "id", hidden: true},--%>
            <%--{name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},--%>
            <%--{name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},--%>
            <%--{name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},--%>
            <%--{name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true},--%>
            <%--{name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains", autoFitWidth: true},--%>
            <%--{name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true, width: "*"},--%>
            <%--{name: "employmentStatus", title: "<spring:message code="employment.status"/>", filterOperator: "iContains", autoFitWidth: true},--%>
            <%--{name: "complexTitle", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true},--%>
            <%--{name: "workPlaceTitle", title: "<spring:message code="work.place"/>", filterOperator: "iContains", autoFitWidth: true},--%>
            <%--{name: "workTurnTitle", title: "<spring:message code="work.turn"/>", filterOperator: "iContains", autoFitWidth: true},--%>
            <%--{name: "ccpAffairs", title: "<spring:message code="reward.cost.center.affairs"/>", filterOperator: "iContains"},--%>
        <%--],--%>
        <%--fetchDataURL: personnelUrl + "/iscList"--%>
    <%--});--%>
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
            // isc.ToolStripButtonRefresh.create({
            //     click: function () { refreshLG(ListGrid_Competence_JspNeedsAssessment); }
            // }),
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
            // isc.ToolStripButtonCreate.create({click: function () { createCompetence_competence(); }}),
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "CompetenceLGCount_needsAssessment"}),
        ]
    });
    let ToolStrip_JspNeedsAssessment = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        align: "center",
        border: "1px solid gray",
        members: [
            isc.ToolStripButtonCreate.create({
                title: "ارسال به گردش کار",
                click: function () {

                }
            }),
            isc.ToolStripButtonRemove.create({
                title: "بازخوانی / لغو تغییرات",
                click: function () {
                    let id = DynamicForm_JspEditNeedsAssessment.getValue("objectId");
                    let type = DynamicForm_JspEditNeedsAssessment.getValue("objectType")
                    wait.show();
                    isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/rollBack/" + type + "/" + id, "PUT", null, (resp)=>{
                        wait.close()
                        if(resp.httpResponseCode === 200){
                            editNeedsAssessmentRecord(id, type);
                        }
                    }));
                }
            }),
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
                                optionDataSource: RestDataSource_category_JspCourse,
                                filterOnKeypress: true,
                                valueField: "id",
                                displayField: "titleFa",
                                filterOperator: "equals",
                            },
                            {
                                name: "course.subCategoryId",
                                title: "<spring:message code="subcategory"/> <spring:message code="course"/>",
                                optionDataSource: RestDataSource_subCategory_JspCourse,
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
        click(){
            if(Window_NeedsAssessment_Diff === undefined) {
                var Window_NeedsAssessment_Diff = isc.Window.create({
                    ID: "Window_NeedsAssessment_Diff",
                    title: "<spring:message code="needs.assessment"/>",
                    placement: "fillScreen",
                    minWidth: 1024,
                    items: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/diff-needs-assessment/"})],
                    showUs(record, objectType) {
                        loadDiffNeedsAssessment(record, objectType);
                        this.Super("show", arguments);
                    },
                });
                let interval = setInterval(()=>{
                    if(Window_NeedsAssessment_Diff !== undefined) {
                        Window_NeedsAssessment_Diff.showUs(DynamicForm_JspEditNeedsAssessment.getField("objectId").getSelectedRecord(), DynamicForm_JspEditNeedsAssessment.getValue("objectType"))
                        Window_NeedsAssessment_Edit.close();
                        clearInterval(interval);
                    }
                },50)
            }
        }
    });

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
        // border: "1px solid",
        fields: [{name: "title", title: "<spring:message code="title"/>"}, {name: "competenceType.title", title: "<spring:message code="type"/>"},],
        gridComponents: [
            isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="competence.list"/>" + "</b></span>", customEdges: ["B"]}),
            CompetenceTS_needsAssessment, "header", "body"
        ],
        canRemoveRecords:true,
        canDragRecordsOut: true,
        dragDataAction: "none",
        removeRecordClick(rowNum){
            if(isReadOnly(DynamicForm_JspEditNeedsAssessment.getValue("objectId"), DynamicForm_JspEditNeedsAssessment.getValue("objectType"))){
                createDialog("info", "بدلیل تایید نشدن تغییرات قبلی، امکان حذف وجود ندارد");
                return;
            }
            let Dialog_Competence_remove = createDialog("ask", "هشدار: در صورت حذف شایستگی تمام مهارت های مربوط به آن حذف خواهند شد.",
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
                            DataSource_Competence_JspNeedsAssessment.removeData(this.getRecord(rowNum));
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
            //     // modalEditing: true,
            //     // valueMap:["عملکرد ضروری","عملکرد توسعه ای","عملکرد بهبود"]
            // }
        ],
        headerSpans: [
            {
                fields: ["titleFa", "objectType"],
                title: "<spring:message code="knowledge"/>"
            }],
        sortField: 1,
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
                        fetchDataDomainsGrid();
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
        //         if (record.objectType === DynamicForm_JspEditNeedsAssessment.getValue("objectType")) {
        //             return true;
        //         }
        //     }
        //     return false;
        // },
        getCellCSSText(record) {
            return priorityColor(record);
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
        sortField: 1,
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
        sortField: 1,
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
        }
    });
    <%--let ListGrid_Personnel_JspNeedsAssessment = isc.TrLG.create({--%>
        <%--width: "100%",--%>
        <%--dataSource: RestDataSource_Personnel_JspNeedsAssessment,--%>
        <%--fields: [--%>
            <%--{name: "firstName"},--%>
            <%--{name: "lastName"},--%>
            <%--{name: "nationalCode"},--%>
            <%--{name: "personnelNo"},--%>
            <%--{name: "personnelNo2"},--%>
            <%--{name: "companyName"},--%>
            <%--{name: "ccpAffairs"},--%>
            <%--{name: "employmentStatus"},--%>
            <%--{name: "complexTitle"},--%>
            <%--{name: "workPlaceTitle"},--%>
            <%--{name: "workTurnTitle"},--%>
        <%--],--%>
        <%--autoFetchData: false,--%>
        <%--gridComponents: [--%>
            <%--isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="personnel.for"/>" + "</b></span>", customEdges: ["T","L","R","B"]}),--%>
            <%--"header", "body"],--%>
        <%--// canExpandRecords: true,--%>
        <%--// expansionMode: "details",--%>
        <%--// showDetailFields: true--%>
    <%--});--%>

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

    var DynamicForm_JspEditNeedsAssessment = isc.DynamicForm.create({
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
    var DynamicForm_CopyOf_JspEditNeedsAssessment = isc.DynamicForm.create({
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
                        console.log(resp.data);
                        if(resp.data === "true"){
                            editNeedsAssessmentRecord(DynamicForm_JspEditNeedsAssessment.getValue("objectId"), DynamicForm_JspEditNeedsAssessment.getValue("objectType"))
                        }
                        else if(resp.data === "false"){
                            readOnly(true);
                        }
                    }));
                }
            }
        ]
    });

    var Menu_JspEditNeedsAssessment = isc.Menu.create({
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
    var Button_CopyOf_JspEditNeedsAssessment = isc.MenuButton.create({
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
    var HLayout_Label_PlusData_JspNeedsAssessment = isc.TrHLayout.create({
        height: "1%",
        padding:2,
        members: [
            Button_CourseDetail_JspEditNeedsAssessment,
            Button_CopyOf_JspEditNeedsAssessment,
            Button_changeShow_JspEditNeedsAssessment,
            Label_PlusData_JspNeedsAssessment,
        ],
    });
    var HLayout_Bottom = isc.TrHLayout.create({
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
    // function refreshPersonnelLG(pickListRecord) {
    //     if (pickListRecord == null)
    //         pickListRecord = DynamicForm_JspEditNeedsAssessment.getItem("objectId").getSelectedRecord();
    //     if (pickListRecord == null){
    //         ListGrid_Personnel_JspNeedsAssessment.setData([]);
    //         return;
    //     }
    //     let crt = {
    //         _constructor: "AdvancedCriteria",
    //         operator: "and",
    //         criteria: []
    //     };
    //     switch (DynamicForm_JspEditNeedsAssessment.getItem("objectType").getValue()) {
    //         case 'Job':
    //             crt.criteria.add({fieldName: "jobNo", operator: "equals", value: pickListRecord.code});
    //             break;
    //         case 'JobGroup':
    //             crt.criteria.add({fieldName: "jobNo", operator: "inSet", value: pickListRecord.jobSet.map(PG => PG.code)});
    //             break;
    //         case 'Post':
    //             crt.criteria.add({fieldName: "postCode", operator: "equals", value: pickListRecord.code});
    //             break;
    //         case 'PostGroup':
    //             // crt.criteria.add({fieldName: "postCode", operator: "inSet", value: pickListRecord.postSet.map(PG => PG.code)});
    //             crt.criteria.add({fieldName: "postCode", operator: "inSet", value: pickListRecord.code});
    //             break;
    //         case 'PostGrade':
    //             crt.criteria.add({fieldName: "postGradeCode", operator: "equals", value: pickListRecord.code});
    //             break;
    //         case 'PostGradeGroup':
    //             crt.criteria.add({fieldName: "postGradeCode", operator: "inSet", value: pickListRecord.postGradeSet.map(PG => PG.code)});
    //             break;
    //     }
    //     ListGrid_Personnel_JspNeedsAssessment.implicitCriteria = crt;
    //     // refreshLG(ListGrid_Personnel_JspNeedsAssessment);
    //     ListGrid_Personnel_JspNeedsAssessment.invalidateCache();
    //     ListGrid_Personnel_JspNeedsAssessment.fetchData();
    // }
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
                return 1;
            }));
        }
        else{
            if(state === 0) {
                createDialog("info", "فقط نیازسنجی های مرتبط با " + priorityList[DynamicForm_JspEditNeedsAssessment.getValue("objectType")] + " قابل حذف است.")
            }
            return 2;
        }
    }

    function editNeedsAssessmentRecord(objectId, objectType) {
        // let criteria = [
        //     '{"fieldName":"objectType","operator":"equals","value":"'+objectType+'"}',
        //     '{"fieldName":"objectId","operator":"equals","value":'+objectId+'}'
        // ];
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
                DataSource_Competence_JspNeedsAssessment.addData(competence, ()=>{ListGrid_Competence_JspNeedsAssessment.selectRecord(0)});
            }
            ListGrid_Competence_JspNeedsAssessment.fetchData();
            ListGrid_Competence_JspNeedsAssessment.emptyMessage = "<spring:message code="msg.no.records.for.show"/>";
            DynamicForm_JspEditNeedsAssessment.setValue("objectId", objectId);
            DynamicForm_JspEditNeedsAssessment.setValue("objectType", objectType);
            fetchDataDomainsGrid();
        }))
    }
    <%--function updateSkillRecord(form, item) {--%>
        <%--let record = form.getData();--%>
        <%--record.needsAssessmentPriorityId = item.getSelectedRecord().id;--%>
        <%--isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/" + record.id, "PUT", JSON.stringify(record), function(resp) {--%>
            <%--if(resp.httpResponseCode !== 200){--%>
                <%--createDialog("info", "<spring:message code='error'/>");--%>
            <%--}--%>
            <%--DataSource_Skill_JspNeedsAssessment.updateData(record);--%>
            <%--item.grid.endEditing();--%>
        <%--}));--%>
    <%--}--%>
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
            } else if (resp.httpResponseCode != 200){
                createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                return;
            }
            data.id = JSON.parse(resp.data).id;
            DataSource_Skill_JspNeedsAssessment.addData(data);
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
        if(DynamicForm_JspEditNeedsAssessment.getValue("objectType") === "Post") {
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
        if(record.objectType === DynamicForm_JspEditNeedsAssessment.getValue("objectType")) {
            let updating = {objectType: record.objectType, objectId: record.objectId, needsAssessmentPriorityId: record.needsAssessmentPriorityId + 1 > 113 ? 111 : record.needsAssessmentPriorityId + 1};
            // isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/" + record.id + "?isFirstChange=" + isFirstChange, "PUT", JSON.stringify(record), function (resp) {
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


    function loadEditNeedsAssessment(objectId, type, state = "R&W") {
        if(state === "read"){
            DynamicForm_JspEditNeedsAssessment.disable()
        }
        else {
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(needsAssessmentUrl + "/isReadOnly/" + type + "/" + objectId.id, "GET", null, (resp) => {
                wait.close();
                if(resp.httpResponseCode !== 200){
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
            DynamicForm_JspEditNeedsAssessment.disable();
            ListGrid_Knowledge_JspNeedsAssessment.disable();
            ListGrid_Ability_JspNeedsAssessment.disable();
            ListGrid_Attitude_JspNeedsAssessment.disable();
            Button_changeShow_JspEditNeedsAssessment.show();
            Button_CopyOf_JspEditNeedsAssessment.hide();
            ToolStrip_JspNeedsAssessment.disable();
            createDialog("info", "بدلیل تایید نشدن تغییرات قبلی، امکان ویرایش وجود ندارد");
        }
        else{
            DynamicForm_JspEditNeedsAssessment.enable();
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
            if (resp.data === "true") {
                return true;
            } else {
                return false;
            }
        }))
    }

    // </script>