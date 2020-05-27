<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
// <script>
    //----------------------------------------------------Variables-----------------------------------------------------
    var nationalCodeCheck_JspTeacherReport = true;
    var isCriteriaCategoriesChanged = false;
    var isTeachingCategoriesChanged = false;
    var isEvaluationCategoriesChanged = false;

    var titr = isc.HTMLFlow.create({
        align: "center",
        border: "1px solid black",
        width: "20%"
    });
    var personalInfo = isc.HTMLFlow.create({
        align: "center"
    });
    var teacherInfo = isc.HTMLFlow.create({
        align: "center"
    });
    var evalInfo = isc.HTMLFlow.create({
        align: "center"
    });
    var teachingInfo = isc.HTMLFlow.create({
        align: "center"
    });
    //----------------------------------------------------Rest DataSource-----------------------------------------------
    var RestDataSource_Category_JspTeacherReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "spec-list"
    });

    var RestDataSource_SubCategory_JspTeacherReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });

    var RestDataSource_Education_Level_JspTeacherReport = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "equals"}],
        fetchDataURL: educationLevelUrl + "spec-list-by-id"
    });

    var RestDataSource_Education_Major_JspTeacherReport = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "equals"}],
        fetchDataURL: educationMajorUrl + "spec-list-by-id"
    });

    var RestDataSource_City_JspTeacherReport = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "name", filterOperator: "equals"}],
    });

    var RestDataSource_State_JspTeacherReport = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "name",  filterOperator: "equals"}],
        fetchDataURL: stateUrl + "spec-list-by-id"
    });

    var RestDataSource_Category_Evaluation_JspTeacherReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "iscList"
    });

    var RestDataSource_SubCategory_Evaluation_JspTeacherReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });

    var RestDataSource_Teaching_Category_JspTeacherReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "iscList"
    });

    var RestDataSource_Teaching_SubCategory_JspTeacherReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });

    var RestDataSource_Teacher_JspTeacherResult = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "teacherCode"},
            {name: "personality.nationalCode"},
            {name: "personnelCode"},
            {name: "personality.firstNameFa"},
            {name: "personality.educationMajor.titleFa"},
            {name: "personnelStatus"},
            {name: "mobile"},
            {name: "numberOfCourses"},
            {name: "evaluationGrade"},
            {name: "lastCourse"},
            {name: "codes"},
            {name: "lastCourseEvaluationGrade"}],
        fetchDataURL: teacherUrl + "spec-list-report"
    });
    var RestDataSource_Term_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
        ],
        fetchDataURL: termUrl + "spec-list?_startRow=0&_endRow=55"
    });
    //----------------------------------------------------ListGrid Result-----------------------------------------------
    var ListGrid_Result_JspTeacherReport = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Teacher_JspTeacherResult,
        fields: [
            {name: "id", title: "id", canEdit: false, hidden: true},
            {
                name: "teacherCode",
                title: "کد مدرس"
            },
            {
                name: "personality.nationalCode",
                title: "کد ملی"
            },
            {
                name: "personnelCode",
                title: "کد پرسنلی"
            },
            {
                name: "personality.name",
                title: "نام و نام خانوادگی"
            },
            {
                name: "personality.educationMajor.titleFa",
                title: "رشته ی تحصیلی",
                align: "center"
            },
            {
                name: "personnelStatus",
                title: "نوع مدرس",
                align: "center",
                valueMap: {
                    true: "<spring:message code='company.staff'/>",
                    false: "<spring:message code='external.teacher'/>"
                }
            },
            {
                name: "personality.contactInfo.mobile",
                title: "موبايل"
            },
            {
                name: "numberOfCourses",
                title: "تعداد دوره هاي تدريسي در شرکت"
            },
            {
                name: "evaluationGrade",
                title: "نمره ارزيابی در گروه و زيرگروه انتخابي"
            },
            {
                name: "lastCourse",
                title: "نام آخرين دوره ي تدريسي در شرکت"
            },
            {
                name: "lastCourseEvaluationGrade",
                title: "نمره ارزيابي کلاسي آخرين دوره تدريسي در شرکت"
            },
            {
                name: "codes",
                title:"ترم"
            }
        ],
        cellHeight: 43,
        filterOperator: "iContains",
        filterOnKeypress: true,
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        allowAdvancedCriteria: true,
        showFilterEditor: false,
        allowFilterExpressions: true,
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>"
    });

    var Window_Result_JspTeacherReport = isc.Window.create({
        placement: "fillScreen",
        title: "گزارش مدرسان",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [
            isc.TrVLayout.create({
                members: [
                    titr,
                    personalInfo,
                    teacherInfo,
                    evalInfo,
                    teachingInfo,
                    ListGrid_Result_JspTeacherReport
                    ]
            })
        ]
    });
    //----------------------------------------------------Criteria Form-------------------------------------------------
    var DynamicForm_CriteriaForm_JspTeacherReport = isc.DynamicForm.create({
        align: "right",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 6,
        fields: [
            {
                name: "personality.nationalCode",
                title: "<spring:message code='national.code'/>",
                wrapTitle: false,
                keyPressFilter: "[0-9]",
                length: "10",
                hint: "<spring:message code='msg.national.code.hint'/>",
                showHintInField: true,
                blur: function () {
                    var codeCheck;
                    codeCheck = checkNationalCode(DynamicForm_CriteriaForm_JspTeacherReport.getValue("personality.nationalCode"));
                    nationalCodeCheck_JspTeacherReport = codeCheck;
                    if (codeCheck === false)
                        DynamicForm_CriteriaForm_JspTeacherReport.addFieldErrors("personality.nationalCode", "<spring:message
        code='msg.national.code.validation'/>", true);
                    if (codeCheck === true) {
                        DynamicForm_CriteriaForm_JspTeacherReport.clearFieldErrors("personality.nationalCode", true);
                    }
                }
            },
            {
                name: "personality.firstNameFa",
                title: "<spring:message code='firstName'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"
            },
            {
                name: "personality.lastNameFa",
                title: "<spring:message code='lastName'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"
            },
            {
                name: "enableStatus",
                title: "<spring:message code='status'/>",
                type: "radioGroup",
                width: "*",
                valueMap: {"true": "<spring:message code='enabled'/>", "false": "<spring:message code='disabled'/>"},
                vertical: false,
                defaultValue: "true"
            },
            {
                name: "personnelStatus",
                title: "<spring:message code='teacher.type'/>",
                type: "radioGroup",
                width: "*",
                valueMap: {
                    "true" : "<spring:message code='company.staff'/>",
                    "false" : "<spring:message code='external.teacher'/>"
                },
                vertical: false,
                defaultValue: "false"
            },
            {
                name: "temp1",
                title: "",
                canEdit: false
            },
            {
                name: "categories",
                title: "زمینه های آموزشی",
                type: "SelectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_Category_JspTeacherReport,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                changed: function () {
                    isCriteriaCategoriesChanged = true;
                    var subCategoryField = DynamicForm_CriteriaForm_JspTeacherReport.getField("subCategories");
                    if (this.getSelectedRecords() == null) {
                        subCategoryField.clearValue();
                        subCategoryField.disable();
                        return;
                    }
                    subCategoryField.enable();
                    if (subCategoryField.getValue() === undefined)
                        return;
                    var subCategories = subCategoryField.getSelectedRecords();
                    var categoryIds = this.getValue();
                    var SubCats = [];
                    for (var i = 0; i < subCategories.length; i++) {
                        if (categoryIds.contains(subCategories[i].categoryId))
                            SubCats.add(subCategories[i].id);
                    }
                    subCategoryField.setValue(SubCats);
                    subCategoryField.focus(this.form, subCategoryField);
                }
            },
            {
                name: "subCategories",
                title: "زیر زمینه های آموزشی",
                type: "SelectItem",
                textAlign: "center",
                autoFetchData: false,
                disabled: true,
                optionDataSource: RestDataSource_SubCategory_JspTeacherReport,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                focus: function () {
                    if (isCriteriaCategoriesChanged) {
                        isCriteriaCategoriesChanged = false;
                        var ids = DynamicForm_CriteriaForm_JspTeacherReport.getField("categories").getValue();
                        if (ids === []) {
                            RestDataSource_SubCategory_JspTeacherReport.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_JspTeacherReport.implicitCriteria = {
                                _constructor: "AdvancedCriteria",
                                operator: "and",
                                criteria: [{fieldName: "categoryId", operator: "inSet", value: ids}]
                            };
                        }
                        this.fetchData();
                    }
                }
            },
            {
                name: "temp2",
                title: "",
                canEdit: false
            },
            {
                name: "personality.educationMajorId",
                title: "<spring:message code='education.major'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Education_Major_JspTeacherReport,
                autoFetchData: false,
                filterFields: ["titleFa","titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                operator: "equals",
                pickListProperties: {
                    showFilterEditor: false,
                    autoFitWidthApproach: "both"
                },
                pickListFields: [
                    {
                        name: "titleFa",
                        width: "70%"
                    }
                ]
            },
            {
                name: "personality.educationLevelId",
                title: "مدرک تحصیلی",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                operator: "equals",
                optionDataSource: RestDataSource_Education_Level_JspTeacherReport,
                autoFetchData: false,
                filterFields: ["titleFa","titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                pickListProperties: {
                    showFilterEditor: false,
                    autoFitWidthApproach: "both"
                },
                pickListFields: [
                    {
                        name: "titleFa",
                        width: "70%"
                    }
                ]
            },
            {
                name: "temp3",
                title: "",
                canEdit: false
            },
            {
                name: "personality.contactInfo.homeAddress.stateId",
                title: "<spring:message code='state'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "name",
                valueField: "id",
                optionDataSource: RestDataSource_State_JspTeacherReport,
                autoFetchData: false,
                filterFields: ["name", "name"],
                sortField: ["id"],
                operator: "equals",
                textMatchStyle: "startsWith",
                pickListProperties: {
                    showFilterEditor: false,
                    autoFitWidthApproach: "both"
                },
                pickListFields: [
                    {
                        name: "name",
                        width: "70%"
                    }
                ]
            },
            {
                name: "personality.contactInfo.homeAddress.cityId",
                title: "<spring:message code='city'/>",
                width: "*",
                textAlign: "center",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "name",
                valueField: "id",
                autoFetchData: false,
                filterFields: ["name","name"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                operator: "equals",
                pickListProperties: {
                    showFilterEditor: false,
                    autoFitWidthApproach: "both"
                },
                pickListFields: [
                    {
                        name: "name",
                        width: "70%"
                    }
                ]
            },
            {
                name: "temp4",
                title: "",
                canEdit: false
            },
            {
                name: "evaluationCategory",
                title: " حداقل نمره ی ارزیابی مدرس در گروه",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                defaultValue: null,
                changeOnKeypress: true,
                prompt: "در صورت انتخاب گروه زیرگروه هم باید انتخاب شود",
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Category_Evaluation_JspTeacherReport,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {name: "titleFa", width: "30%", filterOperator: "iContains"}],
                changed: function (form,item,value) {
                    isEvaluationCategoriesChanged = true;

                    if (value == null || value == undefined) {
                        DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationSubCategory").disable();
                        DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationSubCategory").clearValue();
                        DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationGrade").clearValue();
                        DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationGrade").disable();
                    } else{
                        DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationSubCategory").enable();
                        DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationGrade").enable();
                    }
                }
            },
            {
                name: "evaluationSubCategory",
                title: "و زیرگروه",
                textAlign: "center",
                width: "*",
                titleAlign: "center",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                defaultValue: null,
                displayField: "titleFa",
                valueField: "id",
                disabled: true,
                optionDataSource: RestDataSource_SubCategory_Evaluation_JspTeacherReport,
                autoFetchData: false,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {name: "titleFa", width: "30%", filterOperator: "iContains"}],
                focus: function () {
                    if (isEvaluationCategoriesChanged) {
                        isEvaluationCategoriesChanged = false;
                        var id = DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationCategory").getValue();
                        if (id == null || id == undefined) {
                            RestDataSource_SubCategory_Evaluation_JspTeacherReport.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_Evaluation_JspTeacherReport.implicitCriteria = {
                                _constructor: "AdvancedCriteria",
                                operator: "and",
                                criteria: [{fieldName: "categoryId", operator: "inSet", value: id}]
                            };
                        }
                        this.fetchData();
                    }
                }
            },
            {
                name: "evaluationGrade",
                title: "=",
                hint: "100",
                length: 3,
                disabled: true,
                titleAlign: "center",
                formatOnBlur: true,
                textAlign: "center",
                showHintInField: true,
                keyPressFilter: "[0-9]"
            },
            {
                name: "teachingCategories",
                title: "مدرس در حوزه های",
                type: "SelectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_Teaching_Category_JspTeacherReport,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                changed: function () {
                    isTeachingCategoriesChanged = true;
                    var subCategoryField = DynamicForm_CriteriaForm_JspTeacherReport.getField("teachingSubCategories");
                    if (this.getSelectedRecords() == null) {
                        subCategoryField.clearValue();
                        subCategoryField.disable();
                        return;
                    }
                    subCategoryField.enable();
                    if (subCategoryField.getValue() === undefined)
                        return;
                    var subCategories = subCategoryField.getSelectedRecords();
                    var categoryIds = this.getValue();
                    var SubCats = [];
                    for (var i = 0; i < subCategories.length; i++) {
                        if (categoryIds.contains(subCategories[i].categoryId))
                            SubCats.add(subCategories[i].id);
                    }
                    subCategoryField.setValue(SubCats);
                    subCategoryField.focus(this.form, subCategoryField);
                }
            },
            {
                name: "teachingSubCategories",
                title: "و زیر حوزه های",
                titleAlign: "center",
                type: "SelectItem",
                textAlign: "center",
                autoFetchData: false,
                disabled: true,
                optionDataSource: RestDataSource_Teaching_SubCategory_JspTeacherReport,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                focus: function () {
                    if (isTeachingCategoriesChanged) {
                        isTeachingCategoriesChanged = false;
                        var ids = DynamicForm_CriteriaForm_JspTeacherReport.getField("teachingCategories").getValue();
                        if (ids === []) {
                            RestDataSource_Teaching_SubCategory_JspTeacherReport.implicitCriteria = null;
                        } else {
                            RestDataSource_Teaching_SubCategory_JspTeacherReport.implicitCriteria = {
                                _constructor: "AdvancedCriteria",
                                operator: "and",
                                criteria: [{fieldName: "categoryId", operator: "inSet", value: ids}]
                            };
                        }
                        this.fetchData();
                    }
                }
            },
            {
                name: "temp6",
                title: "تدریس داشته است.",
                canEdit: false
            },
            {
                name: "termId",
                title: "<spring:message code='term'/>",
                textAlign: "center",
                type: "SelectItem",
                multiple: true,
                displayField: "code",
                valueField: "id",
                optionDataSource: RestDataSource_Term_JspClass,
                filterFields: ["code"],
                sortField: ["code"],
                sortDirection: "descending",
                pickListFields: [
                    {
                        name: "code",
                        title: "<spring:message code='term.code'/>",
                        filterOperator: "iContains",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9|\-]"
                        }
                    },
                    {
                        name: "startDate",
                        title: "<spring:message code='start.date'/>",
                        filterOperator: "iContains",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9/]"
                        }
                    },
                    {
                        name: "endDate",
                        title: "<spring:message code='end.date'/>",
                        filterOperator: "iContains",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9/]"
                        }
                    }
                ]
            }
        ],
        itemChanged: function (item, newValue) {
            if (item.name === "personality.contactInfo.homeAddress.stateId") {
                if (newValue === undefined) {
                    DynamicForm_CriteriaForm_JspTeacherReport.clearValue("personality.contactInfo.homeAddress.cityId");
                } else {
                    DynamicForm_CriteriaForm_JspTeacherReport.clearValue("personality.contactInfo.homeAddress.cityId");
                    RestDataSource_City_JspTeacherReport.fetchDataURL = stateUrl + "spec-list-by-stateId/" + newValue;
                    DynamicForm_CriteriaForm_JspTeacherReport.getField("personality.contactInfo.homeAddress.cityId").optionDataSource = RestDataSource_City_JspTeacherReport;
                    DynamicForm_CriteriaForm_JspTeacherReport.getField("personality.contactInfo.homeAddress.cityId").fetchData();
                }
            }
        }
    });

    IButton_Confirm_JspTeacherReport = isc.IButtonSave.create({
        top: 260,
        title: "گزارش گیری",
        width: 300,
        click: function () {
            if (DynamicForm_CriteriaForm_JspTeacherReport.hasErrors())
                return;

            titr.contents = "";
            personalInfo.contents = "";
            teacherInfo.contents = "";
            evalInfo.contents = "";
            teachingInfo.contents = "";

            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("personality.nationalCode").getValue() != undefined){
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "کد ملی: " +"</span>" ;
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("personality.nationalCode").getValue() + "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("personality.firstNameFa").getValue() != undefined){
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "نام:  " +"</span>" ;
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("personality.firstNameFa").getValue()+ "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("personality.lastNameFa").getValue() != undefined){
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "نام خانوادگی: " +"</span>" ;
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("personality.lastNameFa").getValue()+ "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("personality.educationMajorId").getValue() != undefined){
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "رشته تحصیلی: " +"</span>" ;
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("personality.educationMajorId").getDisplayValue()+ "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("personality.educationLevelId").getValue() != undefined){
                personalInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "مدرک تحصیلی: " +"</span>";
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("personality.educationLevelId").getDisplayValue()+ "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("personality.contactInfo.homeAddress.stateId").getValue() != undefined){
                personalInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "استان: " +"</span>" ;
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("personality.contactInfo.homeAddress.stateId").getDisplayValue()+ "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("personality.contactInfo.homeAddress.cityId").getValue() != undefined){
                personalInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "شهر: " +"</span>";
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("personality.contactInfo.homeAddress.cityId").getDisplayValue()+ "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }

            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("enableStatus").getValue() == "true"){
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "وضعیت مدرس: " +"</span>";
                teacherInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+ "فعال" + "</span>";
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            else  if(DynamicForm_CriteriaForm_JspTeacherReport.getField("enableStatus").getValue() == "false"){
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "وضعیت مدرس: " +"</span>";
                teacherInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+ "غیرفعال" + "</span>";
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("personnelStatus").getValue() == "true"){
                teacherInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "نوع مدرس: " +"</span>";
                teacherInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+ "داخلی شرکت مس" + "</span>";
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            else  if(DynamicForm_CriteriaForm_JspTeacherReport.getField("personnelStatus").getValue() == "false"){
                teacherInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "نوع مدرس: " +"</span>";
                teacherInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +"بیرونی" + "</span>";
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("categories").getValue() != undefined){
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "زمینه های آموزشی: " +"</span>";
                teacherInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("categories").getDisplayValue() + "</span>";
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("subCategories").getValue() != undefined){
                teacherInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "زیر زمینه های آموزشی: " +"</span>";
                teacherInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("subCategories").getDisplayValue()+ "</span>";
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationCategory").getValue() != undefined &&
                DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationGrade").getValue() != undefined &&
                DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationSubCategory").getValue() != undefined){

                evalInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "حداقل نمره ی ارزیابی مدرس در گروه: " +"</span>";
                evalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationCategory").getDisplayValue()+ "</span>";

                evalInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "و زیرگروه: " +"</span>";
                evalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationSubCategory").getDisplayValue()+ "</span>";

                evalInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "مساوی: " +"</span>";
                evalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                    DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationGrade").getValue()+ "</span>";
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("teachingCategories").getValue() != undefined){
                teachingInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "زمینه های تدریس مدرس: " +"</span>";
                teachingInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                            DynamicForm_CriteriaForm_JspTeacherReport.getField("teachingCategories").getDisplayValue()+ "</span>";
                teachingInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("teachingSubCategories").getValue() != undefined){
                teachingInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "زیر زمینه های تدریس مدرس: " +"</span>";
                teachingInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                            DynamicForm_CriteriaForm_JspTeacherReport.getField("teachingSubCategories").getDisplayValue()+ "</span>";
            }

            titr.contents = "<span style='color:#050505; font-size:13px;'>" + "گزارش مدرسان با توجه به محدودیت های اعمال شده" +"</span>";

            titr.redraw();
            personalInfo.redraw();
            teacherInfo.redraw();
            evalInfo.redraw();
            teachingInfo.redraw();

            var data_values = DynamicForm_CriteriaForm_JspTeacherReport.getValuesAsAdvancedCriteria();
            for(var i=0;i<data_values.criteria.size();i++){
                if(data_values.criteria[i].fieldName == "enableStatus" || data_values.criteria[i].fieldName == "personnelStatus"){
                    if(data_values.criteria[i].value == "true")
                        data_values.criteria[i].value = true;
                    else if(data_values.criteria[i].value == "false")
                        data_values.criteria[i].value = false;
                    }
                }
            ListGrid_Result_JspTeacherReport.invalidateCache();
            ListGrid_Result_JspTeacherReport.fetchData(data_values);
            Window_Result_JspTeacherReport.show();
        }
    });

    var HLayOut_CriteriaForm_JspTeacherReport = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "80%",
        alignLayout: "center",
        padding: 10,
        members: [
            DynamicForm_CriteriaForm_JspTeacherReport
        ]
    });
    var HLayOut_Confirm_JspTeacherReport = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Confirm_JspTeacherReport
        ]
    });

    var VLayout_Body_Teacher_JspTeacher = isc.TrVLayout.create({
        members: [
            HLayOut_CriteriaForm_JspTeacherReport,
            HLayOut_Confirm_JspTeacherReport
        ]
    });
    //----------------------------------------------------End-----------------------------------------------------------
    Window_Result_JspTeacherReport.hide();