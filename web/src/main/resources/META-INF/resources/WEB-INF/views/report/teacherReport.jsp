<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
// <script>
    //----------------------------------------------------Variables-----------------------------------------------------
    var nationalCodeCheck_JspTeacherReport = true;
    var isCriteriaCategoriesChanged = false;
    var isEvaluationCategoriesChanged;
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
        fetchDataURL: categoryUrl + "spec-list"
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
        fetchDataURL: teacherUrl + "spec-list-grid"
    });
    //----------------------------------------------------ListGrid Result-----------------------------------------------
    var DynamicForm_Titr_JspTeacherReport = isc.DynamicForm.create({
        align: "center",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 2,
        fields: [
            {
                name: "titr",
                canEdit: false,
                title: "",
                align: "center",
            },
            {
                name: "personalInfo",
                canEdit: false,
                title: "",
                align: "center"
            },
            {
                name: "teacherInfo",
                canEdit: false,
                title: "",
                align: "center"
            },
            {
                name: "evalInfo",
                canEdit: false,
                title: "",
                align: "center"
            },
            {
                name: "teachingInfo",
                canEdit: false,
                title: "",
                align: "center"
            },
            ]

    });

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
                name: "personality.firstNameFa",
                title: "نام"
            },
            {
                name: "personality.lastNameFa",
                title: "نام خانوادگی"
            },
            {
                name: "personality.educationMajor.titleFa",
                title: "<spring:message code='education.major'/>",
                align: "center",
                // sortNormalizer: function (record) {
                //     return record.personality.educationLevel.titleFa;
                // },
                // editorType: "SelectItem",
                // displayField: "titleFa",
                // valueField: "titleFa",
                // filterOperator: "equals",
                // optionDataSource: RestDataSource_Education_Major_JspTeacher
            },
            {
                name: "personnelStatus",
                title: "<spring:message code='status'/>",
                align: "center",
                type: "boolean"
            },
            {
                name: "mobile",
                title: "موبايل"
            },
            {
                name: "numberOfCourses",
                title: "تعداد دوره هاي تدريسي در شرکت"
            },
            {
                name: "evaluationGrade",
                title: "نمره ارزيباي در گروه و زيرگروه انتخابي"
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
        // filterEditorSubmit: function () {
        //     ListGrid_Teacher_JspTeacher.invalidateCache();
        // },
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
        title: "<spring:message code='teacher'/>",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [isc.TrVLayout.create({
            members: [
                DynamicForm_Titr_JspTeacherReport,
                ListGrid_Result_JspTeacherReport
            ]
        })]
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
                canEdit: false,
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
                    filterOperator: "iContains",
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
                canEdit: false,
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
                optionDataSource: RestDataSource_Category_Evaluation_JspTeacherReport,
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
                name: "majorSubCategoryId",
                title: "و زیرگروه مرتبط با رشته ی تحصیلی",
                textAlign: "center",
                editorType: "ComboBoxItem",
                width: "*",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_SubCategory_Evaluation_JspTeacherReport,
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
                canEdit: false,
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
                canEdit: false,
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
                optionDataSource: RestDataSource_Category_JspTeacherReport,
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
                    var subCategoryField = DynamicForm_CriteriaForm_JspTeacherReport.getField("subCategory");
                    subCategoryField.clearValue();
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
                optionDataSource: RestDataSource_SubCategory_JspTeacherReport,
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
                        var ids = DynamicForm_CriteriaForm_JspTeacherReport.getField("category").getValue();
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
                name: "evaluationGrade",
                title: "=",
                hint: "100",
                titleAlign: "center",
                formatOnBlur: true,
                textAlign: "center",
                showHintInField: true,
                keyPressFilter: "[0-9.]"
            },
            {
                name: "teachingCategories",
                title: "استاد در حوزه های",
                titleAlign: "center",
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
                    filterOperator: "iContains",
                },
                // changed: function () {
                //     isCriteriaCategoriesChanged = true;
                //     var subCategoryField = DynamicForm_CriteriaForm_JspTeacherReport.getField("subCategories");
                //     if (this.getSelectedRecords() == null) {
                //         subCategoryField.clearValue();
                //         subCategoryField.disable();
                //         return;
                //     }
                //     subCategoryField.enable();
                //     if (subCategoryField.getValue() === undefined)
                //         return;
                //     var subCategories = subCategoryField.getSelectedRecords();
                //     var categoryIds = this.getValue();
                //     var SubCats = [];
                //     for (var i = 0; i < subCategories.length; i++) {
                //         if (categoryIds.contains(subCategories[i].categoryId))
                //             SubCats.add(subCategories[i].id);
                //     }
                //     subCategoryField.setValue(SubCats);
                //     subCategoryField.focus(this.form, subCategoryField);
                // }
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
                // focus: function () {
                //     if (isCriteriaCategoriesChanged) {
                //         isCriteriaCategoriesChanged = false;
                //         var ids = DynamicForm_CriteriaForm_JspTeacherReport.getField("categories").getValue();
                //         if (ids === []) {
                //             RestDataSource_SubCategory_JspTeacherReport.implicitCriteria = null;
                //         } else {
                //             RestDataSource_SubCategory_JspTeacherReport.implicitCriteria = {
                //                 _constructor: "AdvancedCriteria",
                //                 operator: "and",
                //                 criteria: [{fieldName: "categoryId", operator: "inSet", value: ids}]
                //             };
                //         }
                //         this.fetchData();
                //     }
                // }
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
        }
    });

    IButton_Confirm_JspTeacherReport = isc.IButtonSave.create({
        top: 260,
        title: "گزارش گیری",
        width: 300,
        click: function () {
            if (DynamicForm_CriteriaForm_JspTeacherReport.hasErrors())
                return;

            var personalInfo = "";
            var teacherInfo = "";
            var evalInfo = "";
            var teachingInfo = "";

            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("personality.nationalCode") != undefined){
                personalInfo += "کد ملی: ";
                personalInfo += DynamicForm_CriteriaForm_JspTeacherReport.getValue("personality.nationalCode") + ", ";
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("personality.firstNameFa") != undefined){
                personalInfo += "نام: ";
                personalInfo += DynamicForm_CriteriaForm_JspTeacherReport.getValue("personality.firstNameFa") + ", ";
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("personality.lastNameFa") != undefined){
                personalInfo += "نام خانوادگی: ";
                personalInfo += DynamicForm_CriteriaForm_JspTeacherReport.getValue("personality.lastNameFa") + ", ";
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("personality.educationMajorId") != undefined){
                personalInfo += "رشته تحصیلی: ";
                personalInfo += DynamicForm_CriteriaForm_JspTeacherReport.getField("personality.educationMajorId").getDisplayValue() + ", ";
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("personality.educationLevelId") != undefined){
                personalInfo += "مدرک تحصیلی: ";
                personalInfo += DynamicForm_CriteriaForm_JspTeacherReport.getField("personality.educationLevelId").getDisplayValue() + ", ";
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("personality.contactInfo.homeAddress.stateId") != undefined){
                personalInfo += "استان: ";
                personalInfo += DynamicForm_CriteriaForm_JspTeacherReport.getField("personality.contactInfo.homeAddress.stateId").getDisplayValue() + ", ";
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getValue("personality.contactInfo.homeAddress.cityId") != undefined){
                personalInfo += "شهر: ";
                personalInfo += DynamicForm_CriteriaForm_JspTeacherReport.getField("personality.contactInfo.homeAddress.cityId").getDisplayValue() + ", ";
            }
            ynamicForm_Titr_JspTeacherReport.getField("titr").setValue("گزارش اساتید بر اساس محدودیت های: ");
            DynamicForm_Titr_JspTeacherReport.getField("personalInfo").setValue(personalInfo);
            DynamicForm_Titr_JspTeacherReport.getField("teacherInfo").setValue(personalInfo);
            DynamicForm_Titr_JspTeacherReport.getField("evalInfo").setValue(personalInfo);
            DynamicForm_Titr_JspTeacherReport.getField("teachingInfo").setValue(personalInfo);

            var data_values = DynamicForm_CriteriaForm_JspTeacherReport.getValuesAsAdvancedCriteria();
            for(var i=0;i<data_values.criteria.size();i++)
                if(data_values.criteria[i].fieldName == "enableStatus" || data_values.criteria[i].fieldName == "personnelStatus"){
                    if(data_values.criteria[i].value == "true")
                        data_values.criteria[i].value = true;
                    else if(data_values.criteria[i].value == "false")
                        data_values.criteria[i].value = false;
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
