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
            {name:"nationalCode"},
            {name:"firstName"},
            {name:"lastName"},
            {name:"personnelStatus"},
            {name:"educationMajor"},
            {name:"teacherCode"},
            {name:"personnelCode"},
            {name:"mobile"},
            {name:"classCounts"},
            {name:"lastClass"},
            {name:"lastClassGrade"},
            {name:"teacherTermTitles"},
            {name: "educationMajorTitle"},
            {name: "teacherId"}
        ],
        fetchDataURL: viewTeacherReportUrl + "iscList"
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
            {name:"nationalCode", title: "کد ملی" , filterOperator: "iContains"},
            {name:"firstName", title: "نام",  filterOperator: "iContains"},
            {name:"lastName", title: "نام خانوادگی",  filterOperator: "iContains"},
            {name:"personnelStatus",title: "نوع استاد",  filterOperator: "equals",
                valueMap: {
                    "true": "<spring:message code='company.staff'/>",
                    "false": "<spring:message code='external.teacher'/>"
                },
                filterEditorProperties:{
                    pickListProperties: {
                        showFilterEditor: false
                    }
                }},
            {name:"educationMajorTitle", title:  "رشته تحصیلی" ,  filterOperator: "iContains"},
            {name:"teacherCode", title: "کد مدرس" , filterOperator: "iContains"},
            {name:"personnelCode", title: "کد پرسنلی" ,  filterOperator: "iContains"},
            {name:"mobile",title: "موبایل" ,  filterOperator: "iContains"},
            {name:"classCounts", title: "تعداد دوره های تدریسی در شرکت" ,  filterOperator: "equals"},
            {name:"lastClass", title: "نام آخرین دوره ی تدریسی در شرکت" ,  filterOperator: "iContains"},
            {name:"lastClassGrade", title: "نمره ارزیابی کلاسی آخرین دوره ی تدریسی در شرکت" ,  filterOperator: "equals"},
            {name:"teacherTermTitles",title: "ترم های تدریسی در شرکت" ,  filterOperator: "iContains"},
            {name: "teacherId", hidden: true}
        ],
        cellHeight: 43,
        filterOnKeypress: false,
        sortField: 1,
        sortDirection: "descending",
        autoFetchData: true,
        allowAdvancedCriteria: true,
        showFilterEditor: true,
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
                    isc.ToolStripButtonExcel.create({
                        margin:5,
                        click: function() {
                            ExportToFile.downloadExcel(null, ListGrid_Result_JspTeacherReport, 'teacherReport', 0, null, '',  "گزارش اساتيد", ListGrid_Result_JspTeacherReport.data.criteria, null);
                        }
                    }),
                    isc.ToolStripButton.create({
                        margin:5,
                        title: "نمایش جزئیات مدرس",
                        baseStyle: "buttonDetail",
                        click: function() {
                            let record = ListGrid_Result_JspTeacherReport.getSelectedRecord();
                            if (record == null) {
                                createDialog("info", "<spring:message code='msg.not.selected.record'/>");
                            }
                            else{
                                let RestDataSource_TrainingClasses_JspTeacherReport = isc.TrDS.create({
                                    fields: [
                                        {name: "id", primaryKey: true, hidden: true},
                                        {name: "course.code"},
                                        {name: "course.titleFa"},
                                        {name: "startDate"},
                                        {name: "endDate"},
                                        {name: "evaluationGrade"},
                                        {name: "code"}
                                    ]
                                });
                                let ListGrid_TrainingClasses_JspTeacherReport = isc.TrLG.create({
                                    height: 500,
                                    dataSource: RestDataSource_TrainingClasses_JspTeacherReport,
                                    fields: [
                                        {name: "id",hidden: true},
                                        {
                                            name: "course.code",
                                            title: "کد دوره",
                                            filterOperator: "iContains"
                                        },
                                        {
                                            name: "course.titleFa",
                                            title: "نام دوره",
                                            filterOperator: "iContains"
                                        },
                                        {
                                            name: "code",
                                            title: "کد کلاس",
                                            filterOperator: "iContains"
                                        },
                                        {
                                            name: "startDate",
                                            title: "تاریخ شروع",
                                            filterOperator: "iContains",
                                            filterEditorProperties: {
                                                keyPressFilter: "[0-9/]"
                                            }
                                        },
                                        {
                                            name: "endDate",
                                            title: "تاریخ خاتمه",
                                            filterOperator: "iContains",
                                            filterEditorProperties: {
                                                keyPressFilter: "[0-9/]"
                                            }
                                        },
                                        {
                                            name: "evaluationGrade",
                                            title: "نمره ارزیابی فراگیران به مدرس",
                                            canFilter: false
                                        }
                                    ],
                                    align: "center",
                                    filterOnKeypress: true,
                                    sortField: 3,
                                    sortDirection: "descending",
                                });
                                let Window_TrainingClasses_JspTeacherReport = isc.Window.create({
                                    ID: "Window_TrainingClasses_JspTeacherReport",
                                    title: "لیست کلاسهای مدرس " + record.firstName + " " + record.lastName,
                                    width: 1200,
                                    height: 520,
                                    border: "1px solid gray",
                                    closeClick: function () {
                                        this.Super("closeClick", arguments);
                                    },
                                    items: [ isc.TrVLayout.create({
                                        members: [
                                            isc.ToolStripButtonExcel.create({
                                                margin:5,
                                                click: function() {
                                                    let criteria = new Object();
                                                    criteria.operator = "and";
                                                    criteria._constructor = "AdvancedCriteria";
                                                    criteria.criteria = [];
                                                    let LGObj = ListGrid_TrainingClasses_JspTeacherReport.getCriteria();
                                                    if(isEmpty(LGObj) == false)
                                                        criteria.criteria.push(ListGrid_TrainingClasses_JspTeacherReport.getCriteria());
                                                    criteria.criteria.push({fieldName: "teacherId", operator: "equals", value: record.teacherId});

                                                    ExportToFile.downloadExcel(null, ListGrid_TrainingClasses_JspTeacherReport, 'teacherTrainingClasses', 0, null, '',  "لیست کلاسهای مدرس " + record.firstName + " " + record.lastName, criteria, null);
                                                }
                                            }),
                                            ListGrid_TrainingClasses_JspTeacherReport
                                        ]
                                    })]
                                });
                                RestDataSource_TrainingClasses_JspTeacherReport.fetchDataURL = classUrl + "listByteacherID/" + record.teacherId;
                                ListGrid_TrainingClasses_JspTeacherReport.fetchData();
                                ListGrid_TrainingClasses_JspTeacherReport.invalidateCache();
                                Window_TrainingClasses_JspTeacherReport.show()
                            }
                        }
                    }),
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
                name: "nationalCode",
                title: "<spring:message code='national.code'/>",
                wrapTitle: false,
                keyPressFilter: "[0-9]",
                length: "10",
                hint: "<spring:message code='msg.national.code.hint'/>",
                showHintInField: true,
                blur: function () {
                    var codeCheck;
                    codeCheck = checkNationalCode(DynamicForm_CriteriaForm_JspTeacherReport.getValue("nationalCode"));
                    nationalCodeCheck_JspTeacherReport = codeCheck;
                    if (codeCheck === false)
                        DynamicForm_CriteriaForm_JspTeacherReport.addFieldErrors("nationalCode", "<spring:message
        code='msg.national.code.validation'/>", true);
                    if (codeCheck === true) {
                        DynamicForm_CriteriaForm_JspTeacherReport.clearFieldErrors("nationalCode", true);
                    }
                }
            },
            {
                name: "firstName",
                title: "<spring:message code='firstName'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"
            },
            {
                name: "lastName",
                title: "<spring:message code='lastName'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]"
            },
            {
                name: "teacherEnableStatus",
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
                defaultValue: "true"
            },
            {
                name: "temp1",
                title: "",
                canEdit: false
            },
            {
                name: "teacherCategories",
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
                    var subCategoryField = DynamicForm_CriteriaForm_JspTeacherReport.getField("teacherSubCategories");
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
                name: "teacherSubCategories",
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
                        var ids = DynamicForm_CriteriaForm_JspTeacherReport.getField("teacherCategories").getValue();
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
                name: "educationMajor",
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
                name: "educationLevel",
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
                name: "state",
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
                name: "city",
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
            // {
            //     name: "evaluationCategory",
            //     title: " حداقل نمره ی ارزیابی مدرس در گروه",
            //     textAlign: "center",
            //     width: "*",
            //     editorType: "ComboBoxItem",
            //     defaultValue: null,
            //     changeOnKeypress: true,
            //     prompt: "در صورت انتخاب گروه زیرگروه هم باید انتخاب شود",
            //     displayField: "titleFa",
            //     valueField: "id",
            //     optionDataSource: RestDataSource_Category_Evaluation_JspTeacherReport,
            //     autoFetchData: false,
            //     addUnknownValues: false,
            //     cachePickListResults: false,
            //     useClientFiltering: true,
            //     filterFields: ["titleFa"],
            //     sortField: ["id"],
            //     textMatchStyle: "startsWith",
            //     generateExactMatchCriteria: true,
            //     pickListProperties: {
            //         showFilterEditor: true
            //     },
            //     pickListFields: [
            //         {name: "titleFa", width: "30%", filterOperator: "iContains"}],
            //     changed: function (form,item,value) {
            //         isEvaluationCategoriesChanged = true;
            //         DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationSubCategory").clearValue();
            //         if (value == null || value == undefined) {
            //             DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationSubCategory").disable();
            //             DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationGrade").clearValue();
            //             DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationGrade").disable();
            //         } else{
            //             DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationSubCategory").enable();
            //             DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationGrade").enable();
            //         }
            //     }
            // },
            // {
            //     name: "evaluationSubCategory",
            //     title: "و زیرگروه",
            //     textAlign: "center",
            //     width: "*",
            //     titleAlign: "center",
            //     editorType: "ComboBoxItem",
            //     changeOnKeypress: true,
            //     defaultValue: null,
            //     displayField: "titleFa",
            //     valueField: "id",
            //     disabled: true,
            //     optionDataSource: RestDataSource_SubCategory_Evaluation_JspTeacherReport,
            //     autoFetchData: false,
            //     addUnknownValues: false,
            //     cachePickListResults: false,
            //     useClientFiltering: true,
            //     filterFields: ["titleFa"],
            //     sortField: ["id"],
            //     textMatchStyle: "startsWith",
            //     generateExactMatchCriteria: true,
            //     pickListProperties: {
            //         showFilterEditor: true
            //     },
            //     pickListFields: [
            //         {name: "titleFa", width: "30%", filterOperator: "iContains"}],
            //     focus: function () {
            //         if (isEvaluationCategoriesChanged) {
            //             isEvaluationCategoriesChanged = false;
            //             var id = DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationCategory").getValue();
            //             if (id == null || id == undefined) {
            //                 RestDataSource_SubCategory_Evaluation_JspTeacherReport.implicitCriteria = null;
            //             } else {
            //                 RestDataSource_SubCategory_Evaluation_JspTeacherReport.implicitCriteria = {
            //                     _constructor: "AdvancedCriteria",
            //                     operator: "and",
            //                     criteria: [{fieldName: "categoryId", operator: "inSet", value: id}]
            //                 };
            //             }
            //             this.fetchData();
            //         }
            //     }
            // },
            // {
            //     name: "evaluationGrade",
            //     title: "=",
            //     hint: "100",
            //     length: 3,
            //     disabled: true,
            //     titleAlign: "center",
            //     formatOnBlur: true,
            //     textAlign: "center",
            //     showHintInField: true,
            //     keyPressFilter: "[0-9]"
            // },
            {
                name: "teachingHistoryCats",
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
                    var subCategoryField = DynamicForm_CriteriaForm_JspTeacherReport.getField("teachingHistorySubCats");
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
                name: "teachingHistorySubCats",
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
                        var ids = DynamicForm_CriteriaForm_JspTeacherReport.getField("teachingHistoryCats").getValue();
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
                name: "teacherTermIds",
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
            if (item.name === "state") {
                if (newValue === undefined) {
                    DynamicForm_CriteriaForm_JspTeacherReport.clearValue("city");
                } else {
                    DynamicForm_CriteriaForm_JspTeacherReport.clearValue("city");
                    RestDataSource_City_JspTeacherReport.fetchDataURL = stateUrl + "spec-list-by-stateId/" + newValue;
                    DynamicForm_CriteriaForm_JspTeacherReport.getField("city").optionDataSource = RestDataSource_City_JspTeacherReport;
                    DynamicForm_CriteriaForm_JspTeacherReport.getField("city").fetchData();
                }
            }
        }
    });
    //----------------------------------------------------LayOut--------------------------------------------------------
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

            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("nationalCode").getValue() != undefined){
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "کد ملی: " +"</span>" ;
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("nationalCode").getValue() + "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("firstName").getValue() != undefined){
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "نام:  " +"</span>" ;
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("firstName").getValue()+ "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("lastName").getValue() != undefined){
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "نام خانوادگی: " +"</span>" ;
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("lastName").getValue()+ "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("educationMajor").getValue() != undefined){
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "رشته تحصیلی: " +"</span>" ;
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("educationMajor").getDisplayValue()+ "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("educationLevel").getValue() != undefined){
                personalInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "مدرک تحصیلی: " +"</span>";
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("educationLevel").getDisplayValue()+ "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("state").getValue() != undefined){
                personalInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "استان: " +"</span>" ;
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("state").getDisplayValue()+ "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("city").getValue() != undefined){
                personalInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "شهر: " +"</span>";
                personalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("city").getDisplayValue()+ "</span>";
                personalInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>" ;
            }

            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("teacherEnableStatus").getValue() == "true"){
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "وضعیت مدرس: " +"</span>";
                teacherInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+ "فعال" + "</span>";
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            else  if(DynamicForm_CriteriaForm_JspTeacherReport.getField("teacherEnableStatus").getValue() == "false"){
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
            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("teacherCategories").getValue() != undefined){
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + "زمینه های آموزشی: " +"</span>";
                teacherInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("teacherCategories").getDisplayValue() + "</span>";
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("teacherSubCategories").getValue() != undefined){
                teacherInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "زیر زمینه های آموزشی: " +"</span>";
                teacherInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                        DynamicForm_CriteriaForm_JspTeacherReport.getField("teacherSubCategories").getDisplayValue()+ "</span>";
                teacherInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            // if(DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationCategory").getValue() != undefined &&
            //     DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationGrade").getValue() != undefined &&
            //     DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationSubCategory").getValue() != undefined){
            //
            //     evalInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "حداقل نمره ی ارزیابی مدرس در گروه: " +"</span>";
            //     evalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
            //                             DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationCategory").getDisplayValue()+ "</span>";
            //
            //     evalInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "و زیرگروه: " +"</span>";
            //     evalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
            //                             DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationSubCategory").getDisplayValue()+ "</span>";
            //
            //     evalInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "مساوی: " +"</span>";
            //     evalInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
            //                         DynamicForm_CriteriaForm_JspTeacherReport.getField("evaluationGrade").getValue()+ "</span>";
            // }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("teachingHistoryCats").getValue() != undefined){
                teachingInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "زمینه های تدریس مدرس: " +"</span>";
                teachingInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                            DynamicForm_CriteriaForm_JspTeacherReport.getField("teachingHistoryCats").getDisplayValue()+ "</span>";
                teachingInfo.contents +=  "<span style='color:#050505; font-size:12px;'>" + ", " +"</span>";
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("teachingHistorySubCats").getValue() != undefined){
                teachingInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "زیر زمینه های تدریس مدرس: " +"</span>";
                teachingInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                                            DynamicForm_CriteriaForm_JspTeacherReport.getField("teachingHistorySubCats").getDisplayValue()+ "</span>";
            }
            if(DynamicForm_CriteriaForm_JspTeacherReport.getField("teacherTermIds").getValue() != undefined){
                teachingInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "ترم های تدریسی مدرس: " +"</span>";
                teachingInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>"+
                    DynamicForm_CriteriaForm_JspTeacherReport.getField("teacherTermIds").getDisplayValue()+ "</span>";
            }
            titr.contents = "<span style='color:#050505; font-size:13px;'>" + "گزارش مدرسان با توجه به محدودیت های اعمال شده" +"</span>";

            titr.redraw();
            personalInfo.redraw();
            teacherInfo.redraw();
            evalInfo.redraw();
            teachingInfo.redraw();

            let removedObjects = [];
            let addedObjects = [];
            let data_values = DynamicForm_CriteriaForm_JspTeacherReport.getValuesAsAdvancedCriteria();
            for(let i=0;i<data_values.criteria.size();i++){
                if(data_values.criteria[i].fieldName == "teacherEnableStatus" || data_values.criteria[i].fieldName == "personnelStatus"){
                    if(data_values.criteria[i].value == "true")
                        data_values.criteria[i].value = true;
                    else if(data_values.criteria[i].value == "false")
                        data_values.criteria[i].value = false;
                    }
                else if(data_values.criteria[i].fieldName == "teacherTermIds"
                    || data_values.criteria[i].fieldName == "teachingHistorySubCats"
                    || data_values.criteria[i].fieldName == "teachingHistoryCats"
                    || data_values.criteria[i].fieldName == "teacherSubCategories"
                    || data_values.criteria[i].fieldName == "teacherCategories"){
                        let trecord = data_values.criteria[i];
                        let tsize = trecord.value.size();
                        let mainCriteria = new Object();
                        mainCriteria.operator = "or";
                        mainCriteria.criteria = [];
                        for(let j=0;j<tsize;j++){
                            let tvalue = ',' + trecord.value[j] + ',';
                            let tname = data_values.criteria[i].fieldName;
                            let toperator = "iContains";
                            let crecord = new Object();
                            crecord.fieldName = tname;
                            crecord.value = tvalue;
                            crecord.operator = toperator;
                            mainCriteria.criteria[j] = crecord;
                        }
                    addedObjects.add(mainCriteria);
                    removedObjects.add(trecord);
                }
                }
            data_values.criteria.removeList(removedObjects);
            data_values.criteria.addList(addedObjects);
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

    function isEmpty(obj) {
        for(var prop in obj) {
            if(obj.hasOwnProperty(prop))
                return false;
        }

        return true;
    }