<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
// <script>
    //----------------------------------------------------Variables-----------------------------------------------------
    var nationalCodeCheck_JspTClassReport = true;
    var isCriteriaCategoriesChanged = false;
    var isTeachingCategoriesChanged = false;
    var isMajorCategoriesChanged = false;
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
    var RestDataSource_Category_JspTClassReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "spec-list"
    });

    var RestDataSource_SubCategory_JspTClassReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });

    var RestDataSource_Education_Level_JspTClassReport = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "equals"}],
        fetchDataURL: educationLevelUrl + "iscList"
    });

    var RestDataSource_Education_Major_JspTClassReport = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "equals"}],
        fetchDataURL: educationMajorUrl + "spec-list"
    });

    var RestDataSource_City_JspTClassReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "name"}]
    });

    var RestDataSource_State_JspTClassReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "name"}],
        fetchDataURL: stateUrl + "spec-list?_startRow=0&_endRow=100"
    });

    var RestDataSource_Category_Major_JspTClassReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "iscList"
    });

    var RestDataSource_SubCategory_Major_JspTClassReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });

    var RestDataSource_Category_Evaluation_JspTClassReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "iscList"
    });

    var RestDataSource_SubCategory_Evaluation_JspTClassReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });

    var RestDataSource_Teaching_Category_JspTClassReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "iscList"
    });

    var RestDataSource_Teaching_SubCategory_JspTClassReport = isc.TrDS.create({
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
            {name: "lastCourseEvaluationGrade"}],
        fetchDataURL: teacherUrl + "spec-list-report"
    });

    var RestDataSource_Course_JspTClassReport = isc.TrDS.create({
        ID: "courseDS",
        fields: [
            {name: "id", type: "Integer", primaryKey: true},
            {name: "code"},
            {name: "titleFa"},
        ],
        fetchDataURL: courseUrl + "spec-list",
    });
    //----------------------------------------------------ListGrid Result-----------------------------------------------
    var ListGrid_Result_JspTClassReport = isc.TrLG.create({
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
                title: "نوع استاد",
                align: "center",
                valueMap: {
                    true: "<spring:message code='company.staff'/>",
                    false: "<spring:message code='external.teacher'/>"
                },

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

    var Window_Result_JspTClassReport = isc.Window.create({
        placement: "fillScreen",
        title: "گزارش اساتید",
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
                    ListGrid_Result_JspTClassReport
                    ]
            }),
        ]
    });
    //----------------------------------------------------Criteria Form-------------------------------------------------
    var DynamicForm_CriteriaForm_JspTClassReport = isc.DynamicForm.create({
        align: "right",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 6,
        fields: [
            {
                name: "course.code",
                title: "کد دوره",
                hint: "کدهای دوره را با ; از یکدیگر جدا کنید",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click:function(){Window_SelectCourses_JspTClassReport.show();}
                }],
                keyPressFilter: "[A-Z|0-9|;-]"
            },
            {
                name: "course.titleFa",
                title: "نام دوره",

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
                type: "selectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_Category_JspTClassReport,
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
                    var subCategoryField = DynamicForm_CriteriaForm_JspTClassReport.getField("subCategories");
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
                type: "selectItem",
                textAlign: "center",
                autoFetchData: false,
                disabled: true,
                optionDataSource: RestDataSource_SubCategory_JspTClassReport,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains",
                },
                focus: function () {
                    if (isCriteriaCategoriesChanged) {
                        isCriteriaCategoriesChanged = false;
                        var ids = DynamicForm_CriteriaForm_JspTClassReport.getField("categories").getValue();
                        if (ids === []) {
                            RestDataSource_SubCategory_JspTClassReport.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_JspTClassReport.implicitCriteria = {
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
                name: "majorCategoryId",
                title: "گروه مرتبط",
                textAlign: "center",
                editorType: "ComboBoxItem",
                width: "*",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Category_Major_JspTClassReport,
                autoFetchData: true,
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
                    {
                        name: "titleFa",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ],
                changed: function () {
                    isMajorCategoriesChanged = true;
                    var subCategoryField = DynamicForm_CriteriaForm_JspTClassReport.getField("majorSubCategoryId");
                    subCategoryField.clearValue();
                    if (this.getValue() == null || this.getValue() == undefined) {
                        subCategoryField.clearValue();
                        subCategoryField.disable();
                        return;
                    }
                    subCategoryField.enable();
                }
            },
            {
                name: "majorSubCategoryId",
                title: "و زیرگروه مرتبط با رشته ی تحصیلی",
                textAlign: "center",
                editorType: "ComboBoxItem",
                width: "*",
                disabled: true,
                autoFetchData: false,
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_SubCategory_Major_JspTClassReport,
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
                    {
                        name: "titleFa",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ],
                focus: function () {
                    if (isMajorCategoriesChanged) {
                        isMajorCategoriesChanged = false;
                        var id = DynamicForm_CriteriaForm_JspTClassReport.getField("majorCategoryId").getValue();
                        if (id == null || id == undefined) {
                            RestDataSource_SubCategory_Major_JspTClassReport.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_Major_JspTClassReport.implicitCriteria = {
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
                name: "temp3",
                title: "",
                canEdit: false,
            },
            {
                name: "personality.educationMajorId",
                title: "<spring:message code='education.major'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                width: "*",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Education_Major_JspTClassReport,
                autoFetchData: true,
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
                    {
                        name: "titleFa",
                        width: "70%",
                        filterOperator: "iContains"
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
                optionDataSource: RestDataSource_Education_Level_JspTClassReport,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["titleFa"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListFields: [
                    {
                        name: "titleFa",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ]
            },
            {
                name: "temp4",
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
                optionDataSource: RestDataSource_State_JspTClassReport,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["name"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {
                        name: "name",
                        width: "70%",
                        filterOperator: "iContains"
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
                addUnknownValues: false,
                cachePickListResults: false,
                useClientFiltering: true,
                filterFields: ["name"],
                sortField: ["id"],
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {
                        name: "name",
                        width: "70%",
                        filterOperator: "iContains"
                    }
                ]
            },
            {
                name: "temp5",
                title: "",
                canEdit: false
            },
            {
                name: "evaluationCategory",
                title: " حداقل نمره ی ارزیابی استاد در گروه",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                defaultValue: null,
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Category_Evaluation_JspTClassReport,
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
                changed: function () {
                    isEvaluationCategoriesChanged = true;
                    var subCategoryField = DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationSubCategory");
                    if (this.getValue() == null || this.getValue() == undefined) {
                        subCategoryField.clearValue();
                        subCategoryField.disable();
                        return;
                    }
                    subCategoryField.enable();
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
                optionDataSource: RestDataSource_SubCategory_Evaluation_JspTClassReport,
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
                        var id = DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationCategory").getValue();
                        if (id == null || id == undefined) {
                            RestDataSource_SubCategory_Evaluation_JspTClassReport.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_Evaluation_JspTClassReport.implicitCriteria = {
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
                title: "استاد در حوزه های",
                type: "selectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_Teaching_Category_JspTClassReport,
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
                    var subCategoryField = DynamicForm_CriteriaForm_JspTClassReport.getField("teachingSubCategories");
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
                type: "selectItem",
                textAlign: "center",
                autoFetchData: false,
                disabled: true,
                optionDataSource: RestDataSource_Teaching_SubCategory_JspTClassReport,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains",
                },
                focus: function () {
                    if (isTeachingCategoriesChanged) {
                        isTeachingCategoriesChanged = false;
                        var ids = DynamicForm_CriteriaForm_JspTClassReport.getField("teachingCategories").getValue();
                        if (ids === []) {
                            RestDataSource_Teaching_SubCategory_JspTClassReport.implicitCriteria = null;
                        } else {
                            RestDataSource_Teaching_SubCategory_JspTClassReport.implicitCriteria = {
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
                canEdit: false,
            },
        ],
        itemChanged: function (item, newValue) {
            if (item.name === "personality.contactInfo.homeAddress.stateId") {
                if (newValue === undefined) {
                    DynamicForm_CriteriaForm_JspTClassReport.clearValue("personality.contactInfo.homeAddress.cityId");
                } else {
                    DynamicForm_CriteriaForm_JspTClassReport.clearValue("personality.contactInfo.homeAddress.cityId");
                    RestDataSource_City_JspTClassReport.fetchDataURL = stateUrl + "spec-list-by-stateId/" + newValue;
                    DynamicForm_CriteriaForm_JspTClassReport.getField("personality.contactInfo.homeAddress.cityId").optionDataSource = RestDataSource_City_JspTClassReport;
                    DynamicForm_CriteriaForm_JspTClassReport.getField("personality.contactInfo.homeAddress.cityId").fetchData();
                }
            }
            if(item.name == "evaluationSubCategory" || item.name=="evaluationGrade"){
                if(newValue != undefined)
                    item.clearErrors();
            }
            if(item.name == "evaluationCategory"){
                DynamicForm_CriteriaForm_JspTClassReport.getItem("evaluationSubCategory").clearValue();
                if(newValue == undefined){
                    DynamicForm_CriteriaForm_JspTClassReport.getItem("evaluationSubCategory").clearErrors();
                    DynamicForm_CriteriaForm_JspTClassReport.getItem("evaluationGrade").clearErrors();
                    DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationGrade").disable();
                }
                if(newValue != undefined)
                    DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationGrade").enable();
            }
        }
    });
    var initialLayoutStyle = "verticalReverse";
    var DynamicForm_SelectCourses_JspTClassReport = isc.DynamicForm.create({
        align: "center",
        titleWidth: 0,
        titleAlign: "center",
        width: 500,
        height: 300,
        fields: [
            {
                name: "course.code",
                align: "center",
                title: "",
                editorType: "MultiComboBoxItem",
                multiple: true,
                defaultValue: null,
                changeOnKeypress: true,
                showHintInField: true,
                displayField: "code",
                comboBoxWidth: 500,
                valueField: "code",
                layoutStyle: initialLayoutStyle,
                optionDataSource:  RestDataSource_Course_JspTClassReport
            }
        ]
    });
    DynamicForm_SelectCourses_JspTClassReport.getField("course.code").comboBox.setHint("دوره های مورد نظر را انتخاب کنید");
    DynamicForm_SelectCourses_JspTClassReport.getField("course.code").comboBox.pickListFields =
        [{name: "titleFa", width: "30%", filterOperator: "iContains"},{name: "code", width: "30%", filterOperator: "iContains"}];
    DynamicForm_SelectCourses_JspTClassReport.getField("course.code").comboBox.filterFields = ["titleFa","code"];

    IButton_ConfirmCourseSelections_JspTClassReport = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            var criteriaDisplayValues = "";
            var selectorDisplayValues = DynamicForm_SelectCourses_JspTClassReport.getItem("course.code").getValue();
            if(DynamicForm_CriteriaForm_JspTClassReport.getField("course.code").getValue() != undefined
                && DynamicForm_CriteriaForm_JspTClassReport.getField("course.code").getValue() != "") {
                criteriaDisplayValues = DynamicForm_CriteriaForm_JspTClassReport.getField("course.code").getValue();
                var ALength = criteriaDisplayValues.length;
                var lastChar = criteriaDisplayValues.charAt(ALength -1);
                if(lastChar != ";")
                    criteriaDisplayValues += ";";
            }
            if(selectorDisplayValues != undefined) {
                for (var i = 0; i < selectorDisplayValues.size() - 1; i++) {
                    criteriaDisplayValues += selectorDisplayValues [i] + ";";
                }
                criteriaDisplayValues += selectorDisplayValues [selectorDisplayValues.size() - 1];
            }
            DynamicForm_CriteriaForm_JspTClassReport.getField("course.code").setValue(criteriaDisplayValues);
            DynamicForm_SelectCourses_JspTClassReport.clearValues();
            Window_SelectCourses_JspTClassReport.close();
        }
    });

    var Window_SelectCourses_JspTClassReport = isc.Window.create({
        placement: "center",
        title: "انتخاب دوره ها",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "2px solid gray",
        width: 500,
        height: 300,
        items: [
            isc.TrVLayout.create({
                members: [
                    DynamicForm_SelectCourses_JspTClassReport,
                    IButton_ConfirmCourseSelections_JspTClassReport
                ]
            }),
        ]
    });

    IButton_Confirm_JspTClassReport = isc.IButtonSave.create({
        top: 260,
        title: "گزارش گیری",
        width: 300,
        click: function () {
            if (DynamicForm_CriteriaForm_JspTClassReport.hasErrors())
                return;
            if(DynamicForm_CriteriaForm_JspTClassReport.getValue("evaluationCategory") != undefined){
                if(DynamicForm_CriteriaForm_JspTClassReport.getValue("evaluationSubCategory")==undefined ||
                    DynamicForm_CriteriaForm_JspTClassReport.getValue("evaluationGrade")==undefined){
                    if(DynamicForm_CriteriaForm_JspTClassReport.getValue("evaluationSubCategory")==undefined)
                        DynamicForm_CriteriaForm_JspTClassReport.addFieldErrors("evaluationSubCategory", "فیلد اجباری است", true);
                    if(DynamicForm_CriteriaForm_JspTClassReport.getValue("evaluationGrade")==undefined)
                        DynamicForm_CriteriaForm_JspTClassReport.addFieldErrors("evaluationGrade", "فیلد اجباری است", true);
                    return;
                }
            }

            if(DynamicForm_CriteriaForm_JspTClassReport.getValue("personality.nationalCode") != undefined){
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "کد ملی: " +"</span>" ;
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTClassReport.getValue("personality.nationalCode") + "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }
            if(DynamicForm_CriteriaForm_JspTClassReport.getValue("personality.firstNameFa") != undefined){
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "نام:  " +"</span>" ;
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                                        DynamicForm_CriteriaForm_JspTClassReport.getValue("personality.firstNameFa")+ "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }
            if(DynamicForm_CriteriaForm_JspTClassReport.getValue("personality.lastNameFa") != undefined){
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "نام خانوادگی: " +"</span>" ;
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                                        DynamicForm_CriteriaForm_JspTClassReport.getValue("personality.lastNameFa")+ "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }
            if(DynamicForm_CriteriaForm_JspTClassReport.getValue("personality.educationMajorId") != undefined){
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "رشته تحصیلی: " +"</span>" ;
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                                        DynamicForm_CriteriaForm_JspTClassReport.getField("personality.educationMajorId").getDisplayValue()+ "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }
            if(DynamicForm_CriteriaForm_JspTClassReport.getValue("personality.educationLevelId") != undefined){
                personalInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "مدرک تحصیلی: " +"</span>";
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTClassReport.getField("personality.educationLevelId").getDisplayValue()+ "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }
            if(DynamicForm_CriteriaForm_JspTClassReport.getValue("personality.contactInfo.homeAddress.stateId") != undefined){
                personalInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "استان: " +"</span>" ;
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTClassReport.getField("personality.contactInfo.homeAddress.stateId").getDisplayValue()+ "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }
            if(DynamicForm_CriteriaForm_JspTClassReport.getValue("personality.contactInfo.homeAddress.cityId") != undefined){
                personalInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "شهر: " +"</span>";
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTClassReport.getField("personality.contactInfo.homeAddress.cityId").getDisplayValue()+ "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }

            if(DynamicForm_CriteriaForm_JspTClassReport.getValue("enableStatus") == "true"){
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "وضعیت استاد: " +"</span>";
                teacherInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+ "فعال" + "</span>";
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            else  if(DynamicForm_CriteriaForm_JspTClassReport.getValue("enableStatus") == "false"){
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "وضعیت استاد: " +"</span>";
                teacherInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+ "غیرفعال" + "</span>";
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            if(DynamicForm_CriteriaForm_JspTClassReport.getValue("personnelStatus") == "true"){
                teacherInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "نوع استاد: " +"</span>";
                teacherInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+ "داخلی شرکت مس" + "</span>";
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            else  if(DynamicForm_CriteriaForm_JspTClassReport.getValue("personnelStatus") == "false"){
                teacherInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "نوع استاد: " +"</span>";
                teacherInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +"بیرونی" + "</span>";
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            if(DynamicForm_CriteriaForm_JspTClassReport.getValue("categories") != undefined){
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "زمینه های آموزشی: " +"</span>";
                teacherInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTClassReport.getField("categories").getDisplayValue() + "</span>";
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            if(DynamicForm_CriteriaForm_JspTClassReport.getValue("subCategories") != undefined){
                teacherInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "زیر زمینه های آموزشی: " +"</span>";
                teacherInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTClassReport.getField("subCategories").getDisplayValue()+ "</span>";
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            if(DynamicForm_CriteriaForm_JspTClassReport.getValue("majorCategoryId") != undefined){
                teacherInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "گروه مرتبط با رشته ی تحصیلی: " +"</span>";
                teacherInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTClassReport.getField("majorCategoryId").getDisplayValue()+ "</span>";
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            if(DynamicForm_CriteriaForm_JspTClassReport.getValue("majorSubCategoryId") != undefined){
                teacherInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "زیرگروه مرتبط با رشته ی تحصیلی: " +"</span>";
                teacherInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTClassReport.getField("majorSubCategoryId").getDisplayValue()+ "</span>";
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            if(DynamicForm_CriteriaForm_JspTClassReport.getValue("evaluationCategory") != undefined){
                evalInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "حداقل نمره ی ارزیابی استاد در گروه: " +"</span>";
                evalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationCategory").getDisplayValue()+ "</span>";
            }
            if(DynamicForm_CriteriaForm_JspTClassReport.getValue("evaluationSubCategory") != undefined){
                evalInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "و زیرگروه: " +"</span>";
                evalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationSubCategory").getDisplayValue()+ "</span>";
            }
            if(DynamicForm_CriteriaForm_JspTClassReport.getValue("evaluationGrade") != undefined){
                evalInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "مساوی: " +"</span>";
                evalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                    DynamicForm_CriteriaForm_JspTClassReport.getValue("evaluationGrade")+ "</span>";
            }
            if(DynamicForm_CriteriaForm_JspTClassReport.getValue("teachingCategories") != undefined){
                teachingInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "زمینه های تدریس استاد: " +"</span>";
                teachingInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                            DynamicForm_CriteriaForm_JspTClassReport.getField("teachingCategories").getDisplayValue()+ "</span>";
                teachingInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            if(DynamicForm_CriteriaForm_JspTClassReport.getValue("teachingSubCategories") != undefined){
                teachingInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "زیر زمینه های تدریس استاد: " +"</span>";
                teachingInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                            DynamicForm_CriteriaForm_JspTClassReport.getField("teachingSubCategories").getDisplayValue()+ "</span>";
            }

            titr.contents = "<span style='color:#050505; font-size:13px;'>" + "گزارش اساتید با توجه به محدودیت های اعمال شده" +"</span>";

            var data_values = DynamicForm_CriteriaForm_JspTClassReport.getValuesAsAdvancedCriteria();
            for(var i=0;i<data_values.criteria.size();i++){
                if(data_values.criteria[i].fieldName == "enableStatus" || data_values.criteria[i].fieldName == "personnelStatus"){
                    if(data_values.criteria[i].value == "true")
                        data_values.criteria[i].value = true;
                    else if(data_values.criteria[i].value == "false")
                        data_values.criteria[i].value = false;
                    }
                if(data_values.criteria[i].fieldName == "majorCategoryId" || data_values.criteria[i].fieldName == "majorSubCategoryId")
                    data_values.criteria[i].operator = "equals";
                }

            ListGrid_Result_JspTClassReport.fetchData(data_values);
            Window_Result_JspTClassReport.show();
        }
    });

    var HLayOut_CriteriaForm_JspTClassReport = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "80%",
        alignLayout: "center",
        padding: 10,
        members: [
            DynamicForm_CriteriaForm_JspTClassReport
        ]
    });
    var HLayOut_Confirm_JspTClassReport = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Confirm_JspTClassReport
        ]
    });



    var VLayout_Body_Teacher_JspTeacher = isc.TrVLayout.create({
        members: [
            HLayOut_CriteriaForm_JspTClassReport,
            HLayOut_Confirm_JspTClassReport
        ]
    });
    //----------------------------------------------------End-----------------------------------------------------------
    Window_Result_JspTClassReport.hide();