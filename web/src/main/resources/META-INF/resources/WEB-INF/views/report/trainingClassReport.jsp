<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
// <script>
    //----------------------------------------------------Variables-----------------------------------------------------
    var nationalCodeCheck_JspTeacherReport = true;
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
        fetchDataURL: educationLevelUrl + "iscList"
    });

    var RestDataSource_Education_Major_JspTeacherReport = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa", filterOperator: "equals"}],
        fetchDataURL: educationMajorUrl + "spec-list"
    });

    var RestDataSource_City_JspTeacherReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "name"}]
    });

    var RestDataSource_State_JspTeacherReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "name"}],
        fetchDataURL: stateUrl + "spec-list?_startRow=0&_endRow=100"
    });

    var RestDataSource_Category_Major_JspTeacherReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "iscList"
    });

    var RestDataSource_SubCategory_Major_JspTeacherReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: subCategoryUrl + "iscList"
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
            {name: "lastCourseEvaluationGrade"}],
        fetchDataURL: teacherUrl + "spec-list-report"
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

    var Window_Result_JspTeacherReport = isc.Window.create({
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
                    ListGrid_Result_JspTeacherReport
                    ]
            }),
        ]
    });
    //----------------------------------------------------Criteria Form-------------------------------------------------
    var Window_AddCourse_JspClass = isc.Window.create({
        title: "<spring:message code="course.plural.list"/>",
        placement: "fillScreen",
        // width: "80%",
        // height: "50%",
        minWidth: 1024,
        keepInParentRect: true,
        autoSize: false,
        show(){
            ListGrid_Course_JspClass.invalidateCache();
            ListGrid_Course_JspClass.fetchData();
            this.Super("show", arguments);
        },
        items: [
            isc.TrHLayout.create({
                members: [
                    isc.TrLG.create({
                        ID: "ListGrid_Course_JspClass",
                        dataSource: RestDataSource_Course_JspClass,
                        selectionType: "single",
                        filterOnKeypress: false,
                        // autoFetchData:true,
                        fields: [
                            // {name: "scoringMethod"},
                            // {name: "acceptancelimit"},
                            // {name: "startEvaluation"},
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
                            {name: "createdBy", title: "<spring:message code="created.by.user"/>", filterOperator: "iContains"},
                            {
                                name: "theoryDuration",
                                title: "<spring:message code="course_Running_time"/>",
                                filterOperator: "equals",
                            },
                            {
                                name: "categoryId",
                                title: "<spring:message code="category"/> ",
                                optionDataSource: RestDataSource_category_JspCourse,
                                filterOnKeypress: true,
                                valueField: "id",
                                displayField: "titleFa",
                                filterOperator: "equals",
                            },
                        ],
                        gridComponents: ["filterEditor", "header", "body"],
                        recordDoubleClick(viewer, record, recordNum, field, fieldNum, value, rawValue){
                            DynamicForm_Class_JspClass.setValue("course.id", record.id);
                            setTimeout(function () {
                                DynamicForm_Class_JspClass.getItem("course.id").changed(DynamicForm_Class_JspClass, DynamicForm_Class_JspClass.getItem("course.id"));
                                Window_AddCourse_JspClass.close();
                            },1000)
                        }
                    }),
                ]
            })]
    })


    var DynamicForm_CriteriaForm_JspTeacherReport = isc.DynamicForm.create({
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
            },
            {
                name: "selectedCourses",
                title: "انتخاب دوره از لیست دوره ها",
                canEdit: false,
                click(form){
                    Window_AddCourse_JspClass.show();
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
                type: "selectItem",
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
                type: "selectItem",
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
                    filterOperator: "iContains",
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
                name: "majorCategoryId",
                title: "گروه مرتبط",
                textAlign: "center",
                editorType: "ComboBoxItem",
                width: "*",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Category_Major_JspTeacherReport,
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
                    var subCategoryField = DynamicForm_CriteriaForm_JspTeacherReport.getField("majorSubCategoryId");
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
                optionDataSource: RestDataSource_SubCategory_Major_JspTeacherReport,
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
                        var id = DynamicForm_CriteriaForm_JspTeacherReport.getField("majorCategoryId").getValue();
                        if (id == null || id == undefined) {
                            RestDataSource_SubCategory_Major_JspTeacherReport.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_Major_JspTeacherReport.implicitCriteria = {
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
                optionDataSource: RestDataSource_Education_Major_JspTeacherReport,
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
                optionDataSource: RestDataSource_Education_Level_JspTeacherReport,
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
                optionDataSource: RestDataSource_State_JspTeacherReport,
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
                changed: function () {
                    isEvaluationCategoriesChanged = true;
                    var subCategoryField = DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationSubCategory");
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
                title: "استاد در حوزه های",
                type: "selectItem",
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
                type: "selectItem",
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
                    filterOperator: "iContains",
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
                canEdit: false,
            },
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
            if(item.name == "evaluationSubCategory" || item.name=="evaluationGrade"){
                if(newValue != undefined)
                    item.clearErrors();
            }
            if(item.name == "evaluationCategory"){
                DynamicForm_CriteriaForm_JspTeacherReport.getItem("evaluationSubCategory").clearValue();
                if(newValue == undefined){
                    DynamicForm_CriteriaForm_JspTeacherReport.getItem("evaluationSubCategory").clearErrors();
                    DynamicForm_CriteriaForm_JspTeacherReport.getItem("evaluationGrade").clearErrors();
                    DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationGrade").disable();
                }
                if(newValue != undefined)
                    DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationGrade").enable();
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
            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("evaluationCategory") != undefined){
                if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("evaluationSubCategory")==undefined ||
                    DynamicForm_CriteriaForm_JspTeacherReport.getValue("evaluationGrade")==undefined){
                    if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("evaluationSubCategory")==undefined)
                        DynamicForm_CriteriaForm_JspTeacherReport.addFieldErrors("evaluationSubCategory", "فیلد اجباری است", true);
                    if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("evaluationGrade")==undefined)
                        DynamicForm_CriteriaForm_JspTeacherReport.addFieldErrors("evaluationGrade", "فیلد اجباری است", true);
                    return;
                }
            }

            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("personality.nationalCode") != undefined){
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "کد ملی: " +"</span>" ;
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTeacherReport.getValue("personality.nationalCode") + "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("personality.firstNameFa") != undefined){
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "نام:  " +"</span>" ;
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                                        DynamicForm_CriteriaForm_JspTeacherReport.getValue("personality.firstNameFa")+ "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("personality.lastNameFa") != undefined){
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "نام خانوادگی: " +"</span>" ;
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                                        DynamicForm_CriteriaForm_JspTeacherReport.getValue("personality.lastNameFa")+ "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("personality.educationMajorId") != undefined){
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "رشته تحصیلی: " +"</span>" ;
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("personality.educationMajorId").getDisplayValue()+ "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("personality.educationLevelId") != undefined){
                personalInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "مدرک تحصیلی: " +"</span>";
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("personality.educationLevelId").getDisplayValue()+ "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("personality.contactInfo.homeAddress.stateId") != undefined){
                personalInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "استان: " +"</span>" ;
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("personality.contactInfo.homeAddress.stateId").getDisplayValue()+ "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("personality.contactInfo.homeAddress.cityId") != undefined){
                personalInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "شهر: " +"</span>";
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("personality.contactInfo.homeAddress.cityId").getDisplayValue()+ "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }

            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("enableStatus") == "true"){
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "وضعیت استاد: " +"</span>";
                teacherInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+ "فعال" + "</span>";
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            else  if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("enableStatus") == "false"){
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "وضعیت استاد: " +"</span>";
                teacherInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+ "غیرفعال" + "</span>";
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("personnelStatus") == "true"){
                teacherInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "نوع استاد: " +"</span>";
                teacherInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+ "داخلی شرکت مس" + "</span>";
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            else  if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("personnelStatus") == "false"){
                teacherInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "نوع استاد: " +"</span>";
                teacherInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +"بیرونی" + "</span>";
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("categories") != undefined){
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "زمینه های آموزشی: " +"</span>";
                teacherInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("categories").getDisplayValue() + "</span>";
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("subCategories") != undefined){
                teacherInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "زیر زمینه های آموزشی: " +"</span>";
                teacherInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("subCategories").getDisplayValue()+ "</span>";
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("majorCategoryId") != undefined){
                teacherInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "گروه مرتبط با رشته ی تحصیلی: " +"</span>";
                teacherInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("majorCategoryId").getDisplayValue()+ "</span>";
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("majorSubCategoryId") != undefined){
                teacherInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "زیرگروه مرتبط با رشته ی تحصیلی: " +"</span>";
                teacherInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("majorSubCategoryId").getDisplayValue()+ "</span>";
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("evaluationCategory") != undefined){
                evalInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "حداقل نمره ی ارزیابی استاد در گروه: " +"</span>";
                evalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationCategory").getDisplayValue()+ "</span>";
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("evaluationSubCategory") != undefined){
                evalInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "و زیرگروه: " +"</span>";
                evalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationSubCategory").getDisplayValue()+ "</span>";
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("evaluationGrade") != undefined){
                evalInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "مساوی: " +"</span>";
                evalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                    DynamicForm_CriteriaForm_JspTeacherReport.getValue("evaluationGrade")+ "</span>";
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("teachingCategories") != undefined){
                teachingInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "زمینه های تدریس استاد: " +"</span>";
                teachingInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                            DynamicForm_CriteriaForm_JspTeacherReport.getField("teachingCategories").getDisplayValue()+ "</span>";
                teachingInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("teachingSubCategories") != undefined){
                teachingInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "زیر زمینه های تدریس استاد: " +"</span>";
                teachingInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                            DynamicForm_CriteriaForm_JspTeacherReport.getField("teachingSubCategories").getDisplayValue()+ "</span>";
            }

            titr.contents = "<span style='color:#050505; font-size:13px;'>" + "گزارش اساتید با توجه به محدودیت های اعمال شده" +"</span>";

            var data_values = DynamicForm_CriteriaForm_JspTeacherReport.getValuesAsAdvancedCriteria();
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