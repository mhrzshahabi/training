<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>

// <script>
    var DynamicForm_CriteriaForm_JspTeacherReport = isc.DynamicForm.create({
        width: "100%",
        height: "80%",
        align: "right",
        titleWidth: 0,
        showInlineErrors: true,
        showErrorText: false,
        numCols: 4,
        fields: [
            {
                name: "personality.nationalCode",
                title: "<spring:message code='national.code'/>",
                required: true,
                wrapTitle: false,
                keyPressFilter: "[0-9]",
                length: "10",
                hint: "<spring:message code='msg.national.code.hint'/>",
                showHintInField: true,
                blur: function () {
                    var codeCheck;
                    codeCheck = checkNationalCode(DynamicForm_BasicInfo_JspTeacher.getValue("personality.nationalCode"));
                    nationalCodeCheck = codeCheck;
                    if (codeCheck === false)
                        DynamicForm_BasicInfo_JspTeacher.addFieldErrors("personality.nationalCode", "<spring:message
        code='msg.national.code.validation'/>", true);
                    if (codeCheck === true) {
                        DynamicForm_BasicInfo_JspTeacher.clearFieldErrors("personality.nationalCode", true);
                        var nationalCodeTemp = DynamicForm_BasicInfo_JspTeacher.getValue("personality.nationalCode");
                        fillPersonalInfoFields(nationalCodeTemp);
                    }
                }
            },
            {
                name: "personality.firstNameFa",
                title: "<spring:message code='firstName'/>",
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"
            },

            {
                name: "personality.lastNameFa",
                title: "<spring:message code='lastName'/>",
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"
            },
            {
                name: "enableStatus",
                title: "<spring:message code='status'/>",
                type: "radioGroup",
                width: "*",
                colSpan: 2,
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
                    "true": "<spring:message code='company.staff'/>",
                    "false": "<spring:message code='external.teacher'/>"
                },
                vertical: false,
                defaultValue: "false",
                changed: function () {
                    var personnelStatusTemp = DynamicForm_BasicInfo_JspTeacher.getValue("personnelStatus");
                    vm.clearValues();
                    DynamicForm_BasicInfo_JspTeacher.getField("evaluation").setValue("<spring:message code='select.related.category.and.subcategory.for.evaluation'/>");
                    if (personnelStatusTemp == "true") {
                        DynamicForm_BasicInfo_JspTeacher.getField("personnelCode").enable();
                        DynamicForm_BasicInfo_JspTeacher.getField("personnelStatus").setValue("true");
                    } else if (personnelStatusTemp == "false") {
                        DynamicForm_BasicInfo_JspTeacher.getField("personality.nationalCode").enable();
                        DynamicForm_BasicInfo_JspTeacher.getField("personnelCode").disable();
                        DynamicForm_BasicInfo_JspTeacher.getField("personnelStatus").setValue("false");
                    }

                }
            },
            {
                name: "categories",
                title: "<spring:message code='education.categories'/>",
                type: "selectItem",
                textAlign: "center",
                required: true,
                optionDataSource: RestDataSource_Category_JspTeacher,
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
                    isTeacherCategoriesChanged = true;
                    var subCategoryField = DynamicForm_BasicInfo_JspTeacher.getField("subCategories");
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
                title: "<spring:message code='sub.education.categories'/>",
                type: "selectItem",
                textAlign: "center",
                autoFetchData: false,
                disabled: true,
                optionDataSource: RestDataSource_SubCategory_JspTeacher,
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
                    if (isTeacherCategoriesChanged) {
                        isTeacherCategoriesChanged = false;
                        var ids = DynamicForm_BasicInfo_JspTeacher.getField("categories").getValue();
                        if (ids === []) {
                            RestDataSource_SubCategory_JspTeacher.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_JspTeacher.implicitCriteria = {
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
                name: "personality.educationMajorId",
                title: "<spring:message code='education.major'/>",
                textAlign: "center",
                editorType: "ComboBoxItem",
                width: "*",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Education_Major_JspTeacher,
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
                title: "<spring:message code='education.level'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                required: true,
                optionDataSource: RestDataSource_Education_Level_JspTeacher,
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
                name: "personality.contactInfo.homeAddress.stateId",
                title: "<spring:message code='state'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                displayField: "name",
                valueField: "id",
                optionDataSource: RestDataSource_Home_State_JspTeacher,
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
                name: "evaluation",
                title: "",
                canEdit: false,
                baseStyle: "eval-code"
            },
            {
                name: "category",
                title: "<spring:message code='category'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                defaultValue: null,
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                required: true,
                optionDataSource: RestDataSource_Category_JspTeacher,
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
                    isCategoriesChanged = true;
                    var subCategoryField = DynamicForm_Evaluation_JspTeacher.getField("subCategory");
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
                name: "subCategory",
                title: "<spring:message code='subcategory'/>",
                textAlign: "center",
                width: "*",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                defaultValue: null,
                displayField: "titleFa",
                valueField: "id",
                required: true,
                optionDataSource: RestDataSource_SubCategory_JspTeacher,
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
                    if (isCategoriesChanged) {
                        isCategoriesChanged = false;
                        var ids = DynamicForm_Evaluation_JspTeacher.getField("category").getValue();
                        if (ids === []) {
                            RestDataSource_SubCategory_JspTeacher.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_JspTeacher.implicitCriteria = {
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
                name: "evaluation",
                title: "",
                canEdit: false,
                baseStyle: "eval-code"
            },
            {
                name: "grade",
                colSpan: 2,
                formatOnBlur: true,
                title: "<spring:message code='duration'/>:",
                hint: "<spring:message code='hour'/>",
                textAlign: "center",
                required: true,
                showHintInField: true,
                keyPressFilter: "[0-9.]",
                mapValueToDisplay: function (value) {
                    if (isNaN(value)) {
                        return "";
                    }
                    return value + " ساعت ";
                }
            },

        ]
    });

    IButton_Confirm_JspTeacherReport = isc.IButtonSave.create({
        top: 260,
        click: function () {
            Window_Result_JspTeacherReport.show();
        }
    });

    var HLayOut_Confirm_JspTeacherReport = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Confirm_JspTeacherReport
        ]
    });

    var VLayout_Body_Teacher_JspTeacher = isc.TrVLayout.create({
        members: [
            DynamicForm_CriteriaForm_JspTeacherReport
            HLayOut_Confirm_JspTeacherReport
        ]
    });
///////////////////////result set///////////////////////////////////////////////////////////////////////////////////////
    var DynamicForm_Titr_JspTeacherReport = isc.DynamicForm.create({
        height: "100%",
        align: "right",
        canSubmit: true,
        titleWidth: 120,
        titleAlign: "left",
        showInlineErrors: true,
        showErrorText: false,
        valuesManager: "vm",
        styleName: "teacher-form",
        numCols: 6,
        margin: 10,
        newPadding: 5,
        canTabToIcons: false,
        fields: [
            {name: "personality.id", hidden: true},
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
                title: "<spring:message code='code'/>"
            },
            {
                name: "personality.nationalCode",
                title: "<spring:message code='firstName'/>"
            },
            {
                name: "personnelCode",
                title: "<spring:message code='lastName'/>"
            },
            {
                name: "name",
                title: "<spring:message code='category'/>"
            },
            {
                name: "personality.educationMajor.titleFa",
                title: "<spring:message code='education.major'/>",
                align: "center",
                sortNormalizer: function (record) {
                    return record.personality.educationLevel.titleFa;
                },
                editorType: "SelectItem",
                displayField: "titleFa",
                valueField: "titleFa",
                filterOperator: "equals",
                optionDataSource: RestDataSource_Education_Major_JspTeacher
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
        filterEditorSubmit: function () {
            ListGrid_Teacher_JspTeacher.invalidateCache();
        },
        cellHeight: 43,
        filterOperator: "iContains",
        filterOnKeypress: true,
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        allowAdvancedCriteria: true,
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

    Window_Result_JspTeacherReport.hide();
