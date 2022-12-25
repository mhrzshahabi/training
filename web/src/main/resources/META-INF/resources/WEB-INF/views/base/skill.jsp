<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    let method_Skill = "POST";
    let url_Skill;
    let wait_Skill;
    let skillLevelSymbol_Skill = "";

    /////////////////////////////////////////////////TrDS/////////////////////////////////////////////////////////////////

    let SkillLevelDS_Skill = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code='title'/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
        ],
        fetchDataURL: rootUrl + "/skill-level/spec-list"
    });

    let CategoryDS_Skill = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code='code'/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "titleFa", title: "<spring:message code='category'/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"}
        ],
        fetchDataURL: categoryUrl + "spec-list"
    });

    let SubCategoryDS_Skill = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code='code'/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "titleFa", title: "<spring:message code='subcategory'/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
        ]
    });

    let PostDS_Skill = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap:peopleTypeMap, filterOnKeypress: true},
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "objectId", hidden: true, filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "objectCode", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "objectName", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "objectType", title: "نوع نیازسنجی", filterOperator: "equals", autoFitWidth: true, valueMap:{
                    "Post": "پست انفرادی",
                    "PostGroup": "گروه پستی",
                    "Job": "شغل",
                    "JobGroup": "گروه شغلی",
                    "PostGrade": "رده پستی",
                    "PostGradeGroup": "گروه رده پستی",
                    "TrainingPost": "پست"
                }},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"}
        ],
        fetchDataURL: skillNAUrl
    });

    let CourseDS_Skill = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "titleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "createdBy", title: "<spring:message code="created.by.user"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},

            {name: "category.titleFa", title: "<spring:message code="course_category"/>", align: "center", filterOperator: "iContains"},
            {name: "subCategory.titleFa", title: "<spring:message code="course_subcategory"/>", align: "center", filterOperator: "iContains"},
            {name: "erunType.titleFa", title: "<spring:message code="course_eruntype"/>", align: "center", filterOperator: "iContains"},
            {name: "elevelType.titleFa", title: "<spring:message code="cousre_elevelType"/>", align: "center", filterOperator: "iContains"},
            {name: "etheoType.titleFa", title: "<spring:message code="course_etheoType"/>", align: "center", filterOperator: "iContains"},
            {name: "theoryDuration", title: "<spring:message code="course_theoryDuration"/>", align: "center", filterOperator: "iContains"},
            {name: "etechnicalType.titleFa", title: "<spring:message code="course_etechnicalType"/>", align: "center", filterOperator: "iContains"},

            {name: "workflowStatus", title: "<spring:message code="status"/>", align: "center", autoFitWidth: true, filterOperator: "iContains"},
            {name: "behavioralLevel", title: "سطح رفتاری", valueMap: {"1": "مشاهده", "2": "مصاحبه", "3": "کار پروژه ای"}, autoFitWidth: true},
            {name: "evaluation", title: "<spring:message code="evaluation.level"/>", valueMap: {"1": "واکنش", "2": "یادگیری", "3": "رفتاری", "4": "نتایج"}, autoFitWidth: true},
        ],
        fetchDataURL: courseUrl + "spec-list"
    });

    let SkillDS_Skill = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code='skill.code'/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "titleFa", title: "<spring:message code='skill.title'/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "titleEn", title: "<spring:message code='title.en'/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "category.titleFa", title: "<spring:message code='category'/>", filterOperator: "iContains",autoFitWidthApproach: "both", autoFitWidth: true,},
            {name: "subCategory.titleFa", title: "<spring:message code='subcategory'/>", filterOperator: "iContains",autoFitWidthApproach: "both", autoFitWidth: true,},
            {name: "skillLevel.titleFa", title: "<spring:message code='skill.level'/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "description", title: "<spring:message code='description'/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "categoryId", hidden: true},

            {name: "courseId", hidden: true},
            {name: "course.titleFa", title: "<spring:message code='course.title'/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "course.code", title: "<spring:message code='course.code'/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
        ],
        fetchDataURL: skillUrl + "/spec-list"
    });

    //////////////////////////////////////////////////Course/////////////////////////////////////////////////////

    let CourseDV_Skill = isc.DetailViewer.create({
        width: 430,
        height: "90%",
        autoDraw: false,
        border: "2px solid black",
        layoutMargin: 5,
        autoFetchData: false,
        dataSource: CourseDS_Skill,
        emptyMessage:"دوره مرتبطی وجود ندارد",
        fields: [
            {name: "code"},
            {name: "titleFa"},
            {name: "category.titleFa"},
            {name: "subCategory.titleFa"},
            {name: "erunType.titleFa"},
            {name: "elevelType.titleFa"},
            {name: "etheoType.titleFa"},
            {name: "theoryDuration"},
            {name: "etechnicalType.titleFa"},
            {name: "workflowStatus"},
            {name: "behavioralLevel"},
            {name: "evaluation"},
        ]
    });

    let DVHLayout_Skill = isc.HLayout.create({
        width: "100%",
        height: "5%",
        autoDraw: false,
        border: "0px solid red",
        align: "center",
        vAlign: "center",
        layoutMargin: 5,
        membersMargin: 7,
        members: [
            CourseDV_Skill
        ]
    });

    let CloseHlayout_Skill = isc.HLayout.create({
        width: "100%",
        height: "6%",
        autoDraw: false,
        align: "center",
        members: [
            isc.IButton.create({
                title: "<spring:message code='close'/>",
                icon: "[SKIN]/actions/cancel.png",
                width: "70",
                align: "center",
                click: function () {
                    CourseWindow_Skill.close();
                }
            })
        ]
    });

    let CourseWindow_Skill = isc.Window.create({
        title: "<spring:message code='course'/>",
        width: 460,
        height: 400,
        autoSize: false,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        vAlign: "center",
        autoDraw: false,
        dismissOnEscape: true,
        layoutMargin: 5,
        membersMargin: 7,
        items: [
            DVHLayout_Skill,
            CloseHlayout_Skill
        ]
    });

    //////////////////////////////////////////////////Skill/////////////////////////////////////////////////////

    let SkillDF_Skill = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        numCols: "4",
        errorOrientation: "right",
        titleAlign: "left",

        fields: [
            {name: "id", hidden: true},
            {
                name: "code",
                colSpan: 2,
                title: "<spring:message code="skill.code"/>",
                length: 10,
                type: 'staticText',
                canEdit: false,
                required: false,
                keyPressFilter: "^[A-Z|0-9 ]",
                width: "300"

            },
            {
                name: "titleFa",
                title: "<spring:message code='skill.title'/>",
                required: true,
                default: "125",
                validateOnExit:true,
                readonly: true,
                width: "300",
            },
            {
                name: "titleEn",
                title: "<spring:message code='title.en'/>",
                type: 'text',
                keyPressFilter: "[a-z|A-Z|0-9| ]",
                showHintInField: true,
                width: "300"
            },
            {
                name: "categoryId",
                title: "<spring:message code="category"/>",
                width: "300",
                required: true,
                textAlign: "right",
                type: "ComboBoxItem",
                addUnknownValues: false,
                changeOnKeypress: false,
                filterOnKeypress: true,
                pickListWidth: 300,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: CategoryDS_Skill,
                autoFetchData: true,
                filterFields: ["code", "titleFa"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [{name: "titleFa"}, {name: "code"}],
                changed: function (form, item, value) {
                    if (value != null) {
                        SubCategoryDS_Skill.fetchDataURL = categoryUrl + value + "/sub-categories";
                        form.getItem("subCategoryId").fetchData();
                        form.getItem("subCategoryId").setValue(null);
                        form.getItem("subCategoryId").setDisabled(false);
                        form.clearValue('code');
                    }
                }
            },
            {
                name: "subCategoryId",
                title: "<spring:message code="subcategory"/>",
                width: "300",
                required: true,
                textAlign: "right",
                type: "ComboBoxItem",
                pickListWidth: 300,
                displayField: "titleFa",
                valueField: "id",
                addUnknownValues: false,
                changeOnKeypress: false,
                filterOnKeypress: true,
                optionDataSource: SubCategoryDS_Skill,
                autoFetchData: false,
                filterFields: ["code", "titleFa"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [{name: "code"}, {name: "titleFa"}],
                changed: function () {
                    setSkillCode_Skill();
                }
            },
            {
                name: "skillLevelId",
                title: "<spring:message code="skill.level"/>",
                width: "300",
                required: true,
                textAlign: "right",
                type: "ComboBoxItem",
                pickListWidth: 300,
                addUnknownValues: false,
                useClientFiltering: true,
                cachePickListResults: true,
                changeOnKeypress: false,
                filterOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: SkillLevelDS_Skill,
                autoFetchData: true,
                filterFields: ["titleFa"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [{name: "titleFa"}],
                changed: function (form, item, value) {
                    switch (value) {
                        case 1:
                            skillLevelSymbol_Skill = "A";
                            break;
                        case 2:
                            skillLevelSymbol_Skill = "B";
                            break;
                        case 3:
                            skillLevelSymbol_Skill = "C";
                            break;
                    }
                    setSkillCode_Skill();
                }
            },
            {
                name: "courseId",
                title: "<spring:message code='course'/>:",
                textAlign: "center",
                icons:[
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click : function (form, item) {
                            item.clearValue();
                            item.focusInItem();

                        }
                    }
                ],
                width: "300",
                type: "ComboBoxItem",
                pickListWidth: 500,
                optionDataSource: CourseDS_Skill,
                displayField: "titleFa",
                valueField: "id",
                addUnknownValues: false,
                changeOnKeypress: false,
                filterOnKeypress: true,
                autoFetchData: true,
                textMatchStyle: "startsWith",
                filterFields: ["titleFa", "code", "createdBy"],
                pickListFields: [
                    {name: "code"},
                    {name: "titleFa"},
                    {name: "createdBy"}
                ],
                pickListProperties: {
                    showFilterEditor: false,
                    alternateRecordStyles: true,
                    autoFitWidthApproach: "both",
                },
                click(form, item){
                    if(form.getValue("categoryId") === undefined || form.getValue("subCategoryId") === undefined){
                        CourseDS_Skill.fetchDataURL = courseUrl + "spec-list?id=-1";
                    }
                    else{
                        CourseDS_Skill.fetchDataURL = courseUrl + "spec-list";
                        item.pickListCriteria = {
                            _constructor: "AdvancedCriteria",
                            operator: "and",
                            criteria: [
                                {fieldName: "categoryId", operator: "equals", value: form.getValue("categoryId")},
                                {fieldName: "subCategoryId", operator: "equals", value: form.getValue("subCategoryId")}
                            ]
                        };
                    }
                    item.fetchData();
                }
            },
            {
                name: "description",
                colSpan: 4,
                title: "<spring:message code="description"/>",
                width: "700",
                type: 'areaText',
                validators: [ TrValidators.NotContainSpecialChar,TrValidators.NotContainSpecialWords,
                    {
                        type: "regexp",
                        errorMessage: "<spring:message code="msg.field.length"/>",
                        expression: /^.{2,150}$/
                    }]
            }
        ]
    });

    let SkillIBSave_Skill = isc.IButtonSave.create({

        click: function () {

            if (!SkillDF_Skill.validate()) {
                return;
            }
            if (!SkillDF_Skill.valuesHaveChanged()) {
                SkillWindow_Skill.close();
                return;
            }
            if (method_Skill === "POST") {
                let sub_cat_code;
                if (SkillDF_Skill.getItem('subCategoryId').getSelectedRecord() != null)
                    sub_cat_code = SkillDF_Skill.getItem('subCategoryId').getSelectedRecord().code;
                SkillDF_Skill.getItem('code').setValue(sub_cat_code + skillLevelSymbol_Skill);
            }
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(url_Skill, method_Skill, JSON.stringify(SkillDF_Skill.getValues()), Result_SaveSkill_Skill));


        }
    });

    let SkillHlayout_Skill = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        align: "center",
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        padding: 10,
        membersMargin: 10,
        members: [
            SkillIBSave_Skill,
            isc.IButtonCancel.create({
                click: function () {
                    SkillWindow_Skill.close();
                }
        })]
    });

    let SkillWindow_Skill = isc.Window.create({
        title: "<spring:message code="skill"/>",
        width: "830",
        autoSize: true,
        autoCenter: true,
        align: "center",
        dismissOnEscape: false,
        border: "1px solid gray",
        items: [isc.VLayout.create({
            width: "100%",
            height: "100%",
            align: "center",
            members: [SkillDF_Skill, SkillHlayout_Skill]
        })]
    });

    let MenuSkill_Skill = isc.Menu.create({
        data: [
            <sec:authorize access="hasAuthority('Skill_R')">
            {
                title: "<spring:message code="refresh"/>",
                click: function () {
                    refreshLG(SkillLG_Skill);
                    PostLG_Skill.setData([]);
                }
            },
            </sec:authorize>

            <sec:authorize access="hasAuthority('Skill_C')">
            {
                title: "<spring:message code="create"/>",
                click: function () {
                    CreateSkill_Skill();
                }
            },
            </sec:authorize>

            <sec:authorize access="hasAuthority('Skill_U')">
            {
                title: "<spring:message code="edit"/>",
                click: function () {
                    EditSkill_Skill();
                }
            },
            </sec:authorize>

            <sec:authorize access="hasAuthority('Skill_D')">
            {
                title: "<spring:message code="remove"/>",
                click: function () {
                    RemoveSkill_Skill();
                }
            },
            </sec:authorize>

            <sec:authorize access="hasAuthority('Skill_R')">
            {
                title: "دوره مرتبط با مهارت",
                click: function () {
                    setCourseDetailViewerData_Skill();
                }
            }
            </sec:authorize>
        ]
    });

    let SkillLG_Skill = isc.TrLG.create({
        <sec:authorize access="hasAuthority('Skill_R')">
        dataSource: SkillDS_Skill,
        </sec:authorize>
        contextMenu: MenuSkill_Skill,
        width:"100%",
        minWidth:"100%",
        autoFetchData: true,
        selectionType: "single",
        showResizeBar: true,
        fields: [
            {name: "code"},
            {name: "titleFa"},
            {name: "category.titleFa"},
            {name: "subCategory.titleFa"},
            {name: "skillLevel.titleFa"},
            {name: "course.code"},
            {name: "course.titleFa"},
            {name: "description"}
        ],
        dataArrived:function(){
            setTimeout(function(){
                $("tbody tr td:nth-child(8)").css({direction:'ltr'});
                $("tbody tr td:nth-child(2)").css({direction:'ltr'});
                $("td.toolStripButtonExcel").css({direction:'rtl'});
            },100);
        },
        rowHover: function(){
            changeDirection();
        },
        rowOver:function(){
            changeDirection();
        },
        rowClick:function(){
            changeDirection();
        },
        doubleClick: function () {
            changeDirection();
            EditSkill_Skill();
        },
        selectionUpdated: function () {
            PostLG_Skill.clearFilterValues();
            PostLG_Skill.setImplicitCriteria({
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [{fieldName: "skillId", operator: "equals", value: this.getSelectedRecord().id}]
            });
            PostLG_Skill.invalidateCache();
            PostLG_Skill.fetchData();
        }
    });

    /////////////////////////////////////////////////ToolStrip/////////////////////////////////////////////////////

    let RefreshTSB_Skill = isc.ToolStripButtonRefresh.create({
        title: "<spring:message code="refresh"/>",
        click: function () {
            refreshLG(SkillLG_Skill);
            PostLG_Skill.setData([]);
        }
    });
    let EditTSB_Skill = isc.ToolStripButtonEdit.create({
        click: function () {
            EditSkill_Skill();
        }
    });
    let CreateTSB_Skill = isc.ToolStripButtonCreate.create({
        click: function () {
            CreateSkill_Skill();
        }
    });
    let RemoveTSB_Skill = isc.ToolStripButtonRemove.create({
        click: function () {
            RemoveSkill_Skill();
        }
    });

    let ToolStrip_Skill_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    ExportToFile.downloadExcelRestUrl(null, SkillLG_Skill , skillUrl + "/spec-list", 0, null, '',"لیست مهارت ها"  , SkillLG_Skill.getCriteria(), null);
                }
            })
        ]
    });

    let CourseTSB_Skill = isc.ToolStripButton.create({
        top: 260,
        align: "center",
        title: "دوره مرتبط با مهارت",
        click: function () {
            setCourseDetailViewerData_Skill();
        }
    });

    let ActionsTS_Skill = isc.ToolStrip.create({
        width: "100%",
        members: [
            <sec:authorize access="hasAuthority('Skill_C')">
            CreateTSB_Skill,
            </sec:authorize>
            <sec:authorize access="hasAuthority('Skill_U')">
            EditTSB_Skill,
            </sec:authorize>
            <sec:authorize access="hasAuthority('Skill_D')">
            RemoveTSB_Skill,
            </sec:authorize>
            <sec:authorize access="hasAuthority('Skill_R')">
            CourseTSB_Skill,
            </sec:authorize>
            <sec:authorize access="hasAuthority('Skill_P')">
            ToolStrip_Skill_Export2EXcel,
            </sec:authorize>
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    <sec:authorize access="hasAuthority('Skill_R')">
                    RefreshTSB_Skill
                    </sec:authorize>
                ]
            })
        ]
    });

    //////////////////////////////////////////////////NA/////////////////////////////////////////////////////

    let ToolStrip_Skill_Post_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    if (SkillLG_Skill.getSelectedRecord() == null) {
                        createDialog("info", "مهارتی از جدول بالا انتخاب نشده است");
                        return;
                    }
                    ExportToFile.downloadExcelRestUrl(null, PostLG_Skill , skillNAUrl, 0, SkillLG_Skill, '',"لیست موارد نیازسنجی شده برای مهارت " + SkillLG_Skill.getSelectedRecord().titleFa + " با کد " + SkillLG_Skill.getSelectedRecord().code, null, null, 0, true );
                }
            })
        ]
    });

    let ActionsTS_Post_Skill = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStrip_Skill_Post_Export2EXcel
        ]
    });

    let PostLG_Skill = isc.TrLG.create({
        dataSource: PostDS_Skill,
        selectionType: "none",
        autoFetchData: false,
        gridComponents: [ActionsTS_Post_Skill, "filterEditor", "header", "body"],
        sortField: "objectType",
        // groupByField: "objectType",
        fields: [
            {name: "objectType", filterOnKeypress: true},
            {name: "peopleType", filterOnKeypress: true},
            {name: "objectCode"},
            {name: "objectName"},
            {name: "area"},
            {name: "assistance"},
            {name: "affairs"},
            {name: "section"},
            {name: "unit"},
            {
                name: "enabled",
                valueMap:{
                    // undefined : "فعال",
                    74 : "غیر فعال"
                },
                filterOnKeypress: true
            }
        ],
    });

    /////////////////////////////////////////////////DetailTabSet///////////////////////////////////////////////

    let DetailTS_Skill = isc.TabSet.create({
        tabBarPosition: "top",
        height: "40%",
        tabs: [{name: "Post", title: "<spring:message code='need.assessment'/>", pane: PostLG_Skill}]
    });

    /////////////////////////////////////////////////Layout/////////////////////////////////////////////////////

    isc.TrVLayout.create({
        members: [
            ActionsTS_Skill,
            SkillLG_Skill,
            <sec:authorize access="hasAuthority('Skill_R')">
            DetailTS_Skill
            </sec:authorize>
        ]
    });

    /////////////////////////////////////////////////Functions//////////////////////////////////////////////////

    function RemoveSkill_Skill() {
        let record = SkillLG_Skill.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.not.selected.record'/>");
        } else {
            let Dialog_Skill_remove = createDialog("ask", "<spring:message code="msg.record.remove.ask"/>",
                "<spring:message code="verify.delete"/>");
            Dialog_Skill_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        wait.show();
                        isc.RPCManager.sendRequest(TrDSRequest(skillUrl + "/" + record.id, "DELETE", null, Result_RemoveSkill_Skill));
                    }
                }
            });
        }
    }

    function Result_RemoveSkill_Skill(resp) {
        wait.close();
        if (resp.data === "true") {
            refreshLG(SkillLG_Skill);
            PostLG_Skill.setData([]);
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else if (resp.httpResponseCode === 401) {
            createDialog("info", "شما مجوز دسترسی برای حذف را ندارید");
        }
        else if(resp.httpResponseCode === 204) {
            createDialog("info", "به دلیل وجود وابستگی این رکورد قابل حذف نمی باشد");
        }
    }

    function EditSkill_Skill() {
        let record = SkillLG_Skill.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.not.selected.record'/>");
        } else {
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(skillUrl + "/editSkill/" +record.id, "GET", null, Result_EditSkill));

        }
    }

    function  Result_EditSkill(resp) {
            wait.close();
            let record = SkillLG_Skill.getSelectedRecord();
            if (resp.data === 'true')
            {

                let id = record.categoryId;
                SkillDF_Skill.clearValues();
                SubCategoryDS_Skill.fetchDataURL = categoryUrl + id + "/sub-categories";
                SkillDF_Skill.getItem("subCategoryId").fetchData();
                method_Skill = "PUT";
                url_Skill = skillUrl + "/" + record.id;
                SkillDF_Skill.editRecord(record);
                SkillDF_Skill.getItem("categoryId").setDisabled(true);
                SkillDF_Skill.getItem("subCategoryId").setDisabled(true);
                SkillDF_Skill.getItem("skillLevelId").setDisabled(true);
                SkillDF_Skill.getItem("code").visible = true;
                SkillWindow_Skill.show();
            }
            else {

                let id = record.categoryId;
                SkillDF_Skill.clearValues();
                SubCategoryDS_Skill.fetchDataURL = categoryUrl + id + "/sub-categories";
                SkillDF_Skill.getItem("subCategoryId").fetchData();
                method_Skill = "PUT";
                url_Skill = skillUrl + "/" + record.id;
                SkillDF_Skill.editRecord(record);
                SkillDF_Skill.getItem("categoryId").setDisabled(false);
                SkillDF_Skill.getItem("subCategoryId").setDisabled(false);
                SkillDF_Skill.getItem("skillLevelId").setDisabled(false);
                SkillDF_Skill.getItem("code").visible = true;
                SkillWindow_Skill.show();
            }
        }

    function CreateSkill_Skill() {
        method_Skill = "POST";
        url_Skill = skillUrl;
        SkillDF_Skill.clearValues();
        SkillDF_Skill.getItem("categoryId").setDisabled(false);
        SkillDF_Skill.getItem("subCategoryId").setDisabled(true);
        SkillDF_Skill.getItem("skillLevelId").setDisabled(false);
        SkillWindow_Skill.show();
    }

    function Result_SaveSkill_Skill(resp){
        wait.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
            refreshLG(SkillLG_Skill);
            PostLG_Skill.setData([]);
            SkillWindow_Skill.close();
        }else if(resp.httpResponseCode === 406){
            isc.Dialog.create({
                message: "اطلاعات این مهارت با اطلاعات مهارت"+"&nbsp;" +"&nbsp;"+getFormulaMessage(decodeURIComponent(resp.httpHeaders.skillname.replace(/\+/g,' ')), 2, "red", "I")+"&nbsp;"+"  با کد "+ "&nbsp;" +getFormulaMessage(resp.httpHeaders.skillcode, 2, "red", "I") + "&nbsp;"+ " برابر است",
                icon: "[SKIN]say.png",
                title: "<spring:message code="warning"/>",
            });
        }
        else {
            if (JSON.parse(resp.httpResponseText)!==undefined &&
                JSON.parse(resp.httpResponseText).errors !==undefined &&
                JSON.parse(resp.httpResponseText).errors.size()>0 &&
                JSON.parse(resp.httpResponseText).errors.get(0).field !== undefined &&
                JSON.parse(resp.httpResponseText).errors.get(0).field === 'skillHasCourse'){
                createDialog("info", "مهارت به دوره ای وصل است که کلاس دارد .به این دلیل امکان حذف یا ویرایش دوره وجود ندارد");

            }else {
                createDialog("info", "<spring:message code="msg.operation.error"/>");

            }
        }
    }

    function setSkillCode_Skill(){
        if (SkillDF_Skill.getValue("categoryId") != null && SkillDF_Skill.getValue("subCategoryId") != null && SkillDF_Skill.getValue("skillLevelId") != null) {
            let code = SkillDF_Skill.getItem('subCategoryId').getSelectedRecord().code;
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(skillUrl + "/getMaxSkillCode/" + (code + skillLevelSymbol_Skill), "GET", null, Result_SetSkillCode_Skill));
        }
    }

    function Result_SetSkillCode_Skill(resp) {
        wait.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            SkillDF_Skill.getItem('code').setValue(resp.data);
        }
    }

    function setCourseDetailViewerData_Skill() {
        let skill = SkillLG_Skill.getSelectedRecord();
        if (skill == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        }
        if (skill.courseId != null) {
            CourseDV_Skill.implicitCriteria = {
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [{fieldName: "id", operator: "equals", value: skill.courseId}]
            };
            CourseDV_Skill.invalidateCache();
            CourseDV_Skill.fetchData();
        } else
            CourseDV_Skill.setData(null);
        CourseDV_Skill.show();
        CourseWindow_Skill.show();
    }

    const changeDirection=()=>{
        let classes=".cellAltCol,.cellDarkAltCol, .cellOverAltCol, .cellOverDarkAltCol, .cellSelectedAltCol, .cellSelectedDarkAltCol," +
                    " .cellSelectedOverAltCol, .cellSelectedOverDarkAltCol, .cellPendingSelectedAltCol, .cellPendingSelectedDarkAltCol," +
                    " .cellPendingSelectedOverAltCol, .cellPendingSelectedOverDarkAltCol, .cellDeselectedAltCol, .cellDeselectedDarkAltCol," +
                    " .cellDeselectedOverAltCol, .cellDeselectedOverDarkAltCol, .cellDisabledAltCol, .cellDisabledDarkAltCol";
        setTimeout(function() {
            $(classes).css({'direction': 'ltr!important'});
            $("tbody tr td:nth-child(8)").css({direction:'ltr'});
            $("tbody tr td:nth-child(2)").css({direction:'ltr'});
            $("td.toolStripButtonExcel").css({direction:'rtl'});
        },10);
    };

    //</script>