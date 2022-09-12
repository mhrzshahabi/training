<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
// <script>
    var userNationalCode_JspWeeklyTrainingSchedule = "<%= SecurityUtil.getNationalCode()%>";
    var isCategoryChanged_JspWeeklyTrainingSchedule = false;
    //----------------------------------------------------Variables-----------------------------------------------------
    RestDataSource_Class_JspWeeklyTrainingSchedule = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "sessionDate"},
            {name: "dayName"},
            {name: "sessionHour"},
            {name: "sessionStartHour"},
            {name: "sessionStateFa"},
            {name: "tclass.code"},
            {name: "tclass.course.code"},
            {name: "tclass.course.titleFa"},
            {name: "tclass.course.categoryId"},
            {name: "tclass.course.subCategoryId"},
            {name: "studentStatus",canSort:false},
            {name: "studentPresentStatus",canSort: false}
        ],
        fetchDataURL: studentPortalUrl + "/sessionService/specListWeeklyTrainingSchedule/" + userNationalCode_JspWeeklyTrainingSchedule
    });

    var RestDataSource_Category_JspWeeklyTrainingSchedule = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "iscList"
    });

    var RestDataSource_SubCategory_JspWeeklyTrainingSchedule = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });

    //----------------------------------------------------Criteria Form-------------------------------------------------
    var DynamicForm_CriteriaForm_JspWeeklyTrainingSchedule = isc.DynamicForm.create({
        numCols: 5,
        colWidths: ["10%", "30%", "10%", "30%","20%"],
        width: "700",
        fields: [
            {
                name: "tclass.course.categoryId",
                title: "انتخاب گروه",
                type: "ComboBoxItem",
                editorType: "SelectItem",
                textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true
                },
                optionDataSource: RestDataSource_Category_JspWeeklyTrainingSchedule,
                autoFetchData: false,
                displayField: "titleFa",
                valueField: "id",
                specialValues: { "**emptyValue**": ""},
                separateSpecialValues: true,
                textAlign: "center",
                pickListWidth: "280",
                `pickListFields`: [
                    {name: "titleFa", width: "100%", filterOperator: "iContains"}],
                changed: function (form, item, value) {
                    isCategoryChanged_JspWeeklyTrainingSchedule = true;
                    DynamicForm_CriteriaForm_JspWeeklyTrainingSchedule.getField("tclass.course.subCategoryId").clearValue();
                    if (value == null || value == undefined) {
                        DynamicForm_CriteriaForm_JspWeeklyTrainingSchedule.getField("tclass.course.subCategoryId").disable();
                    } else {
                        DynamicForm_CriteriaForm_JspWeeklyTrainingSchedule.getField("tclass.course.subCategoryId").enable();
                    }
                }
            },
            {
                name: "tclass.course.subCategoryId",
                title: "انتخاب  زیر گروه",
                type: "ComboBoxItem",
                editorType: "SelectItem",
                textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true
                },
                optionDataSource: RestDataSource_SubCategory_JspWeeklyTrainingSchedule,
                autoFetchData: false,
                displayField: "titleFa",
                valueField: "id",
                specialValues: { "**emptyValue**": ""},
                separateSpecialValues: true,
                textAlign: "center",
                pickListWidth: "280",
                pickListFields: [
                    {name: "titleFa", width: "100%", filterOperator: "iContains"}],
                focus: function () {
                    if (isCategoryChanged_JspWeeklyTrainingSchedule) {
                        isCategoryChanged_JspWeeklyTrainingSchedule = false;
                        var id = DynamicForm_CriteriaForm_JspWeeklyTrainingSchedule.getField("tclass.course.categoryId").getValue();
                        if (id == null || id == undefined) {
                            RestDataSource_SubCategory_JspWeeklyTrainingSchedule.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_JspWeeklyTrainingSchedule.implicitCriteria = {
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
                name: "reportBottom",
                title: "گزارش گیری",
                type: "ButtonItem",
                align: "right",
                width: "100",
                startRow: false,
                click: function () {
                    ListGrid_Result_JspWeeklyTrainingSchedule.implicitCriteria = DynamicForm_CriteriaForm_JspWeeklyTrainingSchedule.getValuesAsAdvancedCriteria();
                    ListGrid_Result_JspWeeklyTrainingSchedule.invalidateCache();
                    ListGrid_Result_JspWeeklyTrainingSchedule.fetchData();

                    /*ListGrid_Result_JspWeeklyTrainingSchedule.implicitCriteria = DynamicForm_CriteriaForm_JspWeeklyTrainingSchedule.getValuesAsAdvancedCriteria();
                    ListGrid_Result_JspWeeklyTrainingSchedule.invalidateCache();
                    ListGrid_Result_JspWeeklyTrainingSchedule.fetchData();*/

                }
            }
        ]
    });
    //----------------------------------------------------ListGrid Result-----------------------------------------------
    ListGrid_Result_JspWeeklyTrainingSchedule = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Class_JspWeeklyTrainingSchedule,
        initialSort: [
            // {property: "studentStatus", direction: "ascending"},
            // {property: "sessionDate", direction: "ascending"},
            // {property: "sessionStartHour", direction: "ascending"}
        ],
        canAddFormulaFields: false,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
        selectionType: "single",
        canMultiSort: true,
        autoFetchData: true,
        fields: [
            {name: "id", title: "id", canEdit: false, hidden: true},
            {name: "tclass.course.categoryId", hidden: true},
            {name: "tclass.course.subCategoryId", hidden: true},
            {
                name: "tclass.code",
                title: "کد کلاس"
            },
            {
                name: "tclass.course.code",
                title: "کد دوره"
            },
            {
                name: "tclass.course.titleFa",
                title: "نام دوره"
            },
            {
                name: "sessionDate",
                title: "تاریخ",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {
                name: "sessionStartHour",
                title: "ساعت شروع",
                filterOperator: "iContains",
                hidden: true
            },
            {
                name: "dayName",
                title: "روز",
                filterOperator: "equals"
            },
            {
                name: "sessionHour",
                title: "ساعت",
                filterOperator: "iContains",
                displayField:"sessionStartHour",
                displayValueFromRecord: false,
                type: "TextItem",
                filterEditorProperties: {
                    keyPressFilter: "[0-9|:]"
                }
            },
            {
                name: "sessionStateFa",
                title: "وضعیت برگزاری",
                align: "center",
                valueMap: {
                    "شروع نشده": "شروع نشده",
                    "در حال اجرا": "در حال اجرا",
                    "پایان": "پایان"
                },
                filterEditorProperties: {
                    pickListProperties: {
                        showFilterEditor: false
                    }
                }
            },
            {
                name: "studentStatus",
                title: "وضعیت شما",
                align: "center",
                valueMap: {
                    "ثبت نام شده": "ثبت نام شده",
                    "ثبت نام نشده": "ثبت نام نشده"
                },
                filterEditorProperties: {
                    pickListProperties: {
                        showFilterEditor: false
                    }
                },
                sortNormalizer: function (record) {
                    return record.studentStatus;
                },
                canFilter: false
            },
            {
                name: "studentPresentStatus",
                title: "وضعیت حضور و غیاب شما",
                align: "center",
                canFilter: false,
                valueMap: {
                    "0": "نامشخص",
                    "1": "حاضر",
                    "2": "حاضر و اضافه کار",
                    "3": "غیبت غیر موجه",
                    "4": "غیبت موجه"
                },
                filterEditorProperties: {
                    pickListProperties: {
                        showFilterEditor: false
                    }
                }
            }
        ]
    });

    HLayout_CriteriaForm_JspWeeklyTrainingSchedule = isc.TrHLayout.create({
        align: "center",
        height: "5%",
        members: [
            DynamicForm_CriteriaForm_JspWeeklyTrainingSchedule
        ]
    });

    HLayout_ListGrid_JspWeeklyTrainingSchedule = isc.TrHLayout.create({
        align: "center",
        height: "90%",
        members: [
            ListGrid_Result_JspWeeklyTrainingSchedule
        ]
    });

    VLayout_Body_JspWeeklyTrainingSchedule = isc.TrVLayout.create({
        members: [
            HLayout_CriteriaForm_JspWeeklyTrainingSchedule,
            isc.ToolStripButtonExcel.create({
                margin:5,
                click: function() {

                    // let criteria=DynamicForm_CriteriaForm_JspWeeklyTrainingSchedule.getValuesAsAdvancedCriteria();
                    //
                    // if(criteria==null){
                    //     criteria = {
                    //         _constructor: "AdvancedCriteria",
                    //         operator: "and",
                    //         criteria: [
                    //             {fieldName: "nationalCode", operator: "equals", value: userNationalCode_JspWeeklyTrainingSchedule}
                    //         ]
                    //     };
                    // }else{
                    //     criteria.criteria.splice(0,0,{fieldName: "nationalCode", operator: "equals", value: userNationalCode_JspWeeklyTrainingSchedule});
                    // }

                    let criteria = ListGrid_Result_JspWeeklyTrainingSchedule.getCriteria();

                    if (typeof (criteria.operator) == 'undefined') {
                        criteria._constructor = "AdvancedCriteria";
                        criteria.operator = "and";
                    }

                    if (typeof (criteria.criteria) == 'undefined') {
                        criteria.criteria = [];
                    }

                    criteria.criteria.push({fieldName: "nationalCode", operator: "equals", value: userNationalCode_JspWeeklyTrainingSchedule});

                    ExportToFile.downloadExcel(null, ListGrid_Result_JspWeeklyTrainingSchedule, 'weeklyTrainingSchedule', 0, null, '',  "برنامه ريزي آموزشي هفته", criteria, null);
                }
            }),
            HLayout_ListGrid_JspWeeklyTrainingSchedule
        ]
    });


    //