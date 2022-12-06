<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
// <script>

    //----------------------------------------------------Variables-----------------------------------------------------
    let isCriteriaCategoriesChanged_BEFR = false;
    let reportCriteria_BEFR = null;
    let excelData = [];

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    RestDataSource_Category_BEFR = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "spec-list"
    });
    RestDataSource_SubCategory_BEFR = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}, {name: "category.titleFa"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });
    RestDataSource_ClassDS_finalTest = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "group"},
            {name: "c"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "studentCount", canFilter: false, canSort: false},
            {name: "code"},
            {name: "term.titleFa"},
            {name: "course.titleFa"},
            {name: "course.id"},
            {name: "teacherId"},
            {name: "teacher"},
            {name: "teacher.personality.lastNameFa"},
            {name: "reason"},
            {name: "classStatus"},
            {name: "topology"},
            {name: "trainingPlaceIds"},
            {name: "instituteId"},
            {name: "workflowEndingStatusCode"},
            {name: "workflowEndingStatus"},
            {name: "preCourseTest", type: "boolean"},
            {name: "course.code"},
            {name: "course.theoryDuration"},
            {name: "scoringMethod"},
            {name: "evaluation"}
        ],
        fetchDataURL: classUrl + "spec-list",
        implicitCriteria: {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [{fieldName: "evaluation", operator: "equals", value: "3"}]
        }
    });

    //----------------------------------------------------Criteria Form------------------------------------------------
    DynamicForm_CriteriaForm_BEFR = isc.DynamicForm.create({
        align: "right",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 6,
        colWidths: ["10%", "25%", "25%", "10%", "25%", "25%"],
        fields: [
            {
                name: "startDate",
                title: "بازه کلاس: شروع از",
                ID: "startDate_jspREFR",
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
                        displayDatePicker('startDate_jspREFR', this, 'ymd', '/');
                    }
                }],
                textAlign: "center",
                changed: function (form, item, value) {
                    let dateCheck;
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
                title: "بازه کلاس: پایان تا",
                ID: "endDate_jspREFR",
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
                        displayDatePicker('endDate_jspREFR', this, 'ymd', '/');
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
            },
            {
                name: "courseCategory",
                title: "گروه کاری",
                type: "SelectItem",
                textAlign: "center",
                colSpan: 2,
                titleColSpan: 1,
                optionDataSource: RestDataSource_Category_BEFR,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
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

                    isCriteriaCategoriesChanged_BEFR = true;
                    let subCategoryField = DynamicForm_CriteriaForm_BEFR.getField("courseSubCategory");
                    subCategoryField.clearValue();
                    if (this.getSelectedRecords() == null) {
                        subCategoryField.clearValue();
                        subCategoryField.disable();
                        return;
                    }
                    subCategoryField.enable();
                    if (subCategoryField.getValue() === undefined)
                        return;
                    let subCategories = subCategoryField.getSelectedRecords();
                    let categoryNames = this.getValue();
                    let SubCats = [];
                    for (let i = 0; i < subCategories.length; i++) {
                        if (categoryNames.contains(subCategories[i].category.id))
                            SubCats.add(subCategories[i].id);
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
                optionDataSource: RestDataSource_SubCategory_BEFR,
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

                    if (isCriteriaCategoriesChanged_BEFR) {
                        isCriteriaCategoriesChanged_BEFR = false;
                        let names = DynamicForm_CriteriaForm_BEFR.getField("courseCategory").getValue();
                        if (names === []) {
                            RestDataSource_SubCategory_BEFR.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_BEFR.implicitCriteria = {
                                _constructor: "AdvancedCriteria",
                                operator: "and",
                                criteria: [{fieldName: "category.id", operator: "inSet", value: names}]
                            };
                        }
                        this.fetchData();
                    }
                }
            },
            {
                name: "tclassId",
                title: "<spring:message code="class"/>",
                required: false,
                textAlign: "center",
                autoFetchData: false,
                // width: "*",
                colSpan: 2,
                displayField: "code",
                valueField: "code",
                optionDataSource: RestDataSource_ClassDS_finalTest,
                sortField: ["id"],
                filterFields: ["id"],
                autoFitWidth: true,
                pickListFields: [
                    {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
                    {
                        name: "code",
                        title: "<spring:message code='class.code'/>",
                        align: "center",
                        filterOperator: "iContains"
                    },
                    {
                        name: "course.titleFa",
                        title: "<spring:message code='course.title'/>",
                        align: "center",
                        filterOperator: "iContains",
                        sortNormalizer: function (record) {
                            return record.course.titleFa;
                        }
                    },
                    {
                        name: "term.titleFa",
                        title: "term",
                        align: "center",
                        filterOperator: "iContains",
                        hidden: true
                    },
                    {
                        name: "startDate",
                        title: "<spring:message code='start.date'/>",
                        align: "center",
                        filterOperator: "iContains",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9/]"
                        },
                        hidden: true
                    },
                    {
                        name: "endDate",
                        title: "<spring:message code='end.date'/>",
                        align: "center",
                        filterOperator: "iContains",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9/]"
                        },
                        hidden: true
                    },
                    {
                        name: "teacher",
                        title: "<spring:message code='teacher'/>",
                        displayField: "teacher.personality.lastNameFa",
                        displayValueFromRecord: false,
                        type: "TextItem",
                        sortNormalizer(record) {
                            return record.teacher.personality.lastNameFa;
                        },
                        align: "center",
                        filterOperator: "iContains"
                    },
                    {
                        name: "evaluation",
                        title: "<spring:message code='class.evaluation'/>",
                        align: "center",
                        filterEditorProperties: {
                            pickListProperties: {
                                showFilterEditor: false
                            },
                        },
                        filterOnKeypress: true,
                        // autoFitWidth: true,
                        hidden: true
                    },
                ],
                pickListProperties: {
                    showFilterEditor: true
                },
                // pickListWidth: 800,
                icons: [
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click: function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();

                        }
                    }
                ],
                endRow: true,
                startRow: false
            }
        ]
    });

    IButton_Excel_Course_Report = isc.IButtonSave.create({
        top: 260,
        baseStyle: 'MSG-btn-orange',
        icon: "<spring:url value="excel.png"/>",
        title: "درخواست گزارش اکسل(براساس دوره)",
        width: 300,
        click: function () {
            reportCriteria_BEFR = null;
            let form = DynamicForm_CriteriaForm_BEFR;

            if(form.getValue("endDate") == null || form.getValue("startDate") == null) {
                createDialog("info","بازه کلاس مشخص نشده است");
                return;
            }

            if(form.getValue("endDate") < form.getValue("startDate")) {
                createDialog("info","تاریخ پایان نمی تواند کوچکتر از تاریخ شروع باشد");
                return;
            }
            data_values = DynamicForm_CriteriaForm_BEFR.getValuesAsAdvancedCriteria();

            for (let i = 0; i < data_values.criteria.size(); i++) {
                if (data_values.criteria[i].fieldName === "courseCategory") {
                    data_values.criteria[i].fieldName = "categoryId";
                    data_values.criteria[i].operator = "inSet";
                } else if (data_values.criteria[i].fieldName === "courseSubCategory") {
                    data_values.criteria[i].fieldName = "subCategoryId";
                    data_values.criteria[i].operator = "inSet";
                } else if (data_values.criteria[i].fieldName === "startDate") {
                    data_values.criteria[i].fieldName = "classStartDate";
                    data_values.criteria[i].operator = "greaterOrEqual";
                } else if (data_values.criteria[i].fieldName === "endDate") {
                    data_values.criteria[i].fieldName = "classEndDate";
                    data_values.criteria[i].operator = "lessOrEqual";
                } else if (data_values.criteria[i].fieldName === "tclassId") {
                    data_values.criteria[i].fieldName = "classCode"
                    data_values.criteria[i].operator = "equals";
                }
            }
            let downloadForm = isc.DynamicForm.create({
                method: "POST",
                action: "/training/export/excel/formula/behavioral",
                target: "_Blank",
                canSubmit: true,
                fields:
                    [
                        {name: "criteria", type: "hidden"},
                    ]
            });
            downloadForm.setValue("criteria", JSON.stringify(data_values));
            downloadForm.show();
            downloadForm.submitForm();
        }
    });

    IButton_Excel_Student_Report = isc.IButtonSave.create({
        top: 260,
        baseStyle: 'MSG-btn-orange',
        icon: "<spring:url value="excel.png"/>",
        title: "درخواست گزارش اکسل(براساس فراگیر)",
        width: 300,
        click: function () {

            reportCriteria_BEFR = null;
            let form = DynamicForm_CriteriaForm_BEFR;

            if(form.getValue("endDate") == null || form.getValue("startDate") == null) {
                createDialog("info","بازه کلاس مشخص نشده است");
                return;
            }

            if(form.getValue("endDate") < form.getValue("startDate")) {
                createDialog("info","تاریخ پایان نمی تواند کوچکتر از تاریخ شروع باشد");
                return;
            }
            data_values = DynamicForm_CriteriaForm_BEFR.getValuesAsAdvancedCriteria();

            for (let i = 0; i < data_values.criteria.size(); i++) {

                if (data_values.criteria[i].fieldName === "courseCategory") {
                    data_values.criteria[i].fieldName = "categoryTitleFa";
                    data_values.criteria[i].operator = "inSet";
                } else if (data_values.criteria[i].fieldName === "courseSubCategory") {
                    data_values.criteria[i].fieldName = "subCategoryId";
                    data_values.criteria[i].operator = "inSet";
                } else if (data_values.criteria[i].fieldName === "startDate") {
                    data_values.criteria[i].fieldName = "classStartDate";
                    data_values.criteria[i].operator = "greaterOrEqual";
                } else if (data_values.criteria[i].fieldName === "endDate") {
                    data_values.criteria[i].fieldName = "classEndDate";
                    data_values.criteria[i].operator = "lessOrEqual";
                } else if (data_values.criteria[i].fieldName === "tclassId") {
                    data_values.criteria[i].fieldName = "code"
                    data_values.criteria[i].operator = "equals";
                }
            }

            let downloadForm = isc.DynamicForm.create({
                method: "POST",
                action: "/training/export/excel/behavioral2",
                target: "_Blank",
                canSubmit: true,
                fields:
                    [
                        {name: "criteria", type: "hidden"},
                    ]
            });
            downloadForm.setValue("criteria", JSON.stringify(data_values));
            downloadForm.show();
            downloadForm.submitForm();

        }
    });

    IButton_Clear_BEFR = isc.IButtonSave.create({
        top: 260,
        title: "پاک کردن",
        width: 300,
        click: function () {
            DynamicForm_CriteriaForm_BEFR.clearValues();
            DynamicForm_CriteriaForm_BEFR.clearErrors();
        }
    });

    //----------------------------------- layOut -----------------------------------------------------------------------
    let VLayOut_CriteriaForm_BEFR = isc.VLayout.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        members: [
            DynamicForm_CriteriaForm_BEFR
        ]
    });
    let HLayOut_Confirm_BEFR = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Clear_BEFR,
            // IButton_Excel_Student_Report,
            IButton_Excel_Course_Report
        ]
    });
    let VLayout_Body_BEFR = isc.TrVLayout.create({
        border: "2px solid blue",
        padding: 20,
        members: [
            VLayOut_CriteriaForm_BEFR,
            HLayOut_Confirm_BEFR,
        ]
    });

    // </script>