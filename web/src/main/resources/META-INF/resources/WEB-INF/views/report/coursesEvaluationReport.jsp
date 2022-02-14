<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    let reportCriteria_CER;
    let isCriteriaCategoriesChanged_CER = false;

    //------------------------------------------------- REST DataSources------------------------------------------------

    RestDataSource_Category_CER = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "spec-list"
    });
    RestDataSource_SubCategory_CER = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });
    RestDataSource_Class_CER = isc.TrDS.create({
        fields: [
            { name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "classCode", title: "<spring:message code="class.code"/>", filterOperator: "iContains"},
            {name: "classStatus", title: "<spring:message code="class.status"/>", filterOperator: "iContains"},
            {name: "classStartDate", title: "<spring:message code="start.date"/>", filterOperator: "iContains"},
            {name: "classEndDate", title: "<spring:message code="end.date"/>", filterOperator: "iContains"},
            {name: "courseCode", title: "<spring:message code="course.code"/>", filterOperator: "iContains"},
            {name: "courseTitleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains"},
            {name: "categoryTitleFa", title: "<spring:message code="category"/>", filterOperator: "iContains"},
            {name: "subCategoryTitleFa", title: "<spring:message code="subcategory"/>", filterOperator: "iContains"},
            {name: "classStudentStatusReaction", title: "وضعیت ارزیابی واکنشی فراگیران"},
            {name: "evaluationAnalysisReactionGrade", title: "نمره ارزیابی واکنشی فراگیران"},
            {name: "evaluationAnalysisTeacherGrade", title: "نمره ارزیابی نهایی مدرس"}
        ],
        fetchDataURL: viewCoursesEvaluationReportUrl + "/iscList"
    });

    //------------------------------------------------- Main Window ----------------------------------------------------

    ToolStripButton_Excel_CER = isc.ToolStripButtonExcel.create({

        click: function () {
            makeExcelOutput();
        }
    });
    ToolStripButton_Refresh_CER = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_CER.invalidateCache();
        }
    });

    ToolStrip_Actions_CER = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_CER,
                        ToolStripButton_Excel_CER
                    ]
                })
            ]
    });

    // var organSegmentFilter_CER = init_OrganSegmentFilterDF(true, true , null, "complexTitle","assistant","affairs", "section", "unit");

    var DynamicForm_CER = isc.DynamicForm.create({
        align: "right",
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 6,
        colWidths: ["10%", "25%", "25%", "10%", "25%", "25%"],
        fields: [
            {
                name: "courseCategory",
                title: "گروه کاری",
                type: "SelectItem",
                textAlign: "center",
                colSpan: 2,
                titleColSpan: 1,
                optionDataSource: RestDataSource_Category_CER,
                valueField: "titleFa",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    canSelectAll: true,
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                pickListFields: [
                    {
                        name: "id",
                        hidden: true,
                        align: "center"
                    },
                    {
                        name: "titleFa",
                        title: "عنوان گروه",
                        align: "center"
                    }
                ],
                changed: function () {
                    isCriteriaCategoriesChanged_CER = true;
                    var subCategoryField = DynamicForm_CER.getField("courseSubCategory");
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
                    var categoryNames = this.getValue();
                    var SubCats = [];
                    if (subCategories !== undefined && subCategories !== null) {
                        for (var i = 0; i < subCategories.length; i++) {
                            if (categoryNames.contains(subCategories[i].category.titleFa))
                                SubCats.add(subCategories[i].titleFa);
                        }
                    }
                    subCategoryField.setValue(SubCats);
                    subCategoryField.focus(this.form, subCategoryField);
                }
            },
            {
                name: "courseSubCategory",
                title: "زیرگروه کاری",
                type: "SelectItem",
                textAlign: "center",
                colSpan: 2,
                titleColSpan: 1,
                autoFetchData: false,
                disabled: true,
                optionDataSource: RestDataSource_SubCategory_CER,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    canSelectAll: true,
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                pickListFields: [
                    {
                        name: "id",
                        hidden: true,
                        align: "center"
                    },
                    {
                        name: "category.titleFa",
                        title: "عنوان گروه",
                        align: "center",
                        sortNormalizer: function (record) {
                            return record.category.titleFa;
                        }
                    },
                    {
                        name: "titleFa",
                        title: "عنوان زیرگروه",
                        align: "center"
                    }
                ],
                focus: function () {
                    if (isCriteriaCategoriesChanged_CER) {
                        isCriteriaCategoriesChanged_CER = false;
                        var names = DynamicForm_CER.getField("courseCategory").getValue();
                        if (names === []) {
                            RestDataSource_SubCategory_CER.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_CER.implicitCriteria = {
                                _constructor: "AdvancedCriteria",
                                operator: "and",
                                criteria: [{fieldName: "category.titleFa", operator: "inSet", value: names}]
                            };
                        }
                        this.fetchData();
                    }
                }
            },
            {
                name: "startDate",
                title: "بازه خاتمه کلاس: از",
                ID: "startDate_jspCER",
                colSpan: 1,
                titleColSpan: 1,
                required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate_jspCER', this, 'ymd', '/');
                    }
                }],
                textAlign: "center",
                changed: function (form, item, value) {
                    var dateCheck;
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        form.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                    } else {
                        form.clearFieldErrors("startDate", true);
                    }
                }
            },
            {
                colSpan: 1,
                name: "temp1",
                canEdit: false,
                showTitle: false
            },
            {
                name: "endDate",
                title: "بازه خاتمه کلاس: تا",
                ID: "endDate_jspCER",
                colSpan: 1,
                titleColSpan: 1,
                type: 'text',
                required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate_jspCER', this, 'ymd', '/');
                    }
                }],
                textAlign: "center",
                changed: function (form, item, value) {
                    let dateCheck;
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        form.clearFieldErrors("endDate", true);
                        form.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                    } else {
                        form.clearFieldErrors("endDate", true);
                    }
                }
            },
            {
                colSpan: 1,
                name: "temp2",
                canEdit: false,
                showTitle: false
            }
        ]
    });

    IButton_Report_CER = isc.IButtonSave.create({
        top: 260,
        title: "نمایش گزارش",
        width: 300,
        click: function () {

            reportCriteria_CER = null;
            let form = DynamicForm_CER;

            if(form.getValue("endDate") == null || form.getValue("startDate") == null) {
                createDialog("info","بازه خاتمه کلاس مشخص نشده است");
                return;
            }

            if(form.getValue("endDate") < form.getValue("startDate")) {
                createDialog("info","تاریخ پایان نمی تواند کوچکتر از تاریخ شروع باشد");
                return;
            }

            data_values = DynamicForm_CER.getValuesAsAdvancedCriteria();

            for (let i = 0; i < data_values.criteria.size(); i++) {

                if (data_values.criteria[i].fieldName === "courseCategory") {
                    data_values.criteria[i].fieldName = "categoryTitleFa";
                    data_values.criteria[i].operator = "inSet";
                } else if (data_values.criteria[i].fieldName === "courseSubCategory") {
                    data_values.criteria[i].fieldName = "subCategoryId";
                    data_values.criteria[i].operator = "inSet";
                } else if (data_values.criteria[i].fieldName === "startDate") {
                    data_values.criteria[i].fieldName = "classEndDate";
                    data_values.criteria[i].operator = "greaterOrEqual";
                } else if (data_values.criteria[i].fieldName === "endDate") {
                    data_values.criteria[i].fieldName = "classEndDate";
                    data_values.criteria[i].operator = "lessOrEqual";
                }
            }

            reportCriteria_CER = data_values;
            ListGrid_CER.invalidateCache();
            ListGrid_CER.fetchData(reportCriteria_CER);
        }
    });
    IButton_Clear_CER = isc.IButtonSave.create({
        top: 260,
        title: "پاک کردن",
        width: 300,
        click: function () {

            ListGrid_CER.setData([]);
            DynamicForm_CER.clearValues();
            DynamicForm_CER.clearErrors();
            ListGrid_CER.setFilterEditorCriteria(null);
        }
    });

    var HLayOut_Confirm_CER = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Report_CER,
            IButton_Clear_CER
        ]
    });

    var ListGrid_CER = isc.TrLG.create({
        filterOnKeypress: false,
        showFilterEditor: true,
        gridComponents: ["filterEditor", "header", "body"],
        dataSource: RestDataSource_Class_CER,
        fields: [
            {name: "classCode"},
            {
                name: "classStatus",
                valueMap: {
                    "1": "برنامه ریزی",
                    "2": "در حال اجرا",
                    "3": "پایان یافته",
                    "4": "لغو شده",
                    "5": "اختتام"
                }
            },
            {name: "classStartDate"},
            {name: "classEndDate"},
            {name: "courseCode"},
            {name: "courseTitleFa"},
            {name: "categoryTitleFa"},
            {name: "subCategoryTitleFa"},
            {
                name: "classStudentStatusReaction",
                canFilter: false,
                formatCellValue: function (value) {
                    if (value === 0) {
                        return "نهایی شده";
                    } else if (value) {
                        return "ناقص";
                    }
                }
            },
            {
                name: "evaluationAnalysisReactionGrade",
                canFilter: false,
                formatCellValue: function (value) {
                    if (value) {
                        return NumberUtil.format(Number(value), "0.##");
                    }
                }
            },
            {
                name: "evaluationAnalysisTeacherGrade",
                canFilter: false,
                formatCellValue: function (value) {
                    if (value) {
                        return NumberUtil.format(Number(value), "0.##");
                    }
                }
            }
        ]
    });

    var VLayout_Body_CER = isc.VLayout.create({
        border: "2px solid blue",
        padding: 20,
        width: "100%",
        height: "100%",
        members: [
            ToolStrip_Actions_CER,
            // organSegmentFilter_CER,
            DynamicForm_CER,
            HLayOut_Confirm_CER,
            ListGrid_CER
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------

    function makeExcelOutput() {

        if (ListGrid_CER.getOriginalData().localData === undefined)
            createDialog("info", "ابتدا چاپ گزارش را انتخاب کنید");
        else
            ExportToFile.downloadExcelRestUrl(null, ListGrid_CER, viewCoursesEvaluationReportUrl + "/iscList", 0, null, '',"گزارش ارزیابی دوره ها"  , reportCriteria_CER, null);
    }

    //</script>
