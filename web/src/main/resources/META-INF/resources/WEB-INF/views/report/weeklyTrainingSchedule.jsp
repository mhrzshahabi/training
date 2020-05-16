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
            {name: "studentStatus"},
            {name: "studentPresentStatus"}
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
        align: "center",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 4,
        fields: [
            {
                name: "tclass.course.categoryId",
                title: "انتخاب گروه",
                textAlign: "center",
                width: "30%",
                editorType: "ComboBoxItem",
                defaultValue: null,
                changeOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_Category_JspWeeklyTrainingSchedule,
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
                    isCategoryChanged_JspWeeklyTrainingSchedule = true;
                    if (value == null || value == undefined) {
                        DynamicForm_CriteriaForm_JspWeeklyTrainingSchedule.getField("tclass.course.subCategoryId").disable();
                        DynamicForm_CriteriaForm_JspWeeklyTrainingSchedule.getField("tclass.course.subCategoryId").clearValue();
                    } else{
                        DynamicForm_CriteriaForm_JspWeeklyTrainingSchedule.getField("tclass.course.subCategoryId").enable();
                    }
                }
            },
            {
                name: "tclass.course.subCategoryId",
                title: "انتخاب زیرگروه",
                textAlign: "center",
                width: "30%",
                titleAlign: "center",
                editorType: "ComboBoxItem",
                changeOnKeypress: true,
                defaultValue: null,
                displayField: "titleFa",
                valueField: "id",
                disabled: true,
                optionDataSource: RestDataSource_SubCategory_JspWeeklyTrainingSchedule,
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
            }
        ],
        itemChanged: function(item,newValue){
            var newCriteria = isc.DataSource.combineCriteria(ListGrid_Result_JspWeeklyTrainingSchedule.getCriteria(),
                DynamicForm_CriteriaForm_JspWeeklyTrainingSchedule.getValuesAsAdvancedCriteria());
            ListGrid_Result_JspWeeklyTrainingSchedule.fetchData(newCriteria);
        }
    });
    //----------------------------------------------------ListGrid Result-----------------------------------------------
    ListGrid_Result_JspWeeklyTrainingSchedule = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Class_JspWeeklyTrainingSchedule,
        initialSort: [
            {property: "studentStatus", direction: "ascending"},
            {property: "sessionDate", direction: "ascending"},
            {property: "sessionStartHour", direction: "ascending"}
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
                title: "تاریخ"
            },
            {
                name: "sessionStartHour",
                title: "ساعت شروع",
                filterOperator: "iContains",
                hidden: true
            },
            {
                name: "dayName",
                title: "روز"
            },
            {
                name: "sessionHour",
                title: "ساعت"
            },
            {
                name: "sessionStateFa",
                title: "وضعیت برگزاری",
                align: "center",
                valueMap: {
                    "شروع نشده": "شروع نشده",
                    "در حال اجرا": "در حال اجرا",
                    "پایان": "پایان"
                }
            },
            {
                name: "studentStatus",
                title: "وضعیت شما",
                align: "center",
                valueMap: {
                    "ثبت نام شده": "ثبت نام شده",
                    "ثبت نام نشده": "ثبت نام نشده"
                }
            },
            {
                name: "studentPresentStatus",
                title: "وضعیت حضور و غیاب شما",
                align: "center",
                valueMap: {
                    "0": "نامشخص",
                    "1": "حاضر",
                    "2": "حاضر و اضافه کار",
                    "3": "غیبت غیر موجه",
                    "4": "غیبت موجه",
                }
            },
        ],
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
            HLayout_ListGrid_JspWeeklyTrainingSchedule
        ]
    });


    //