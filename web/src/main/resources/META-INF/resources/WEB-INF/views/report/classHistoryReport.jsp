<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>

// <script>

    //----------------------------------------------------Variables-----------------------------------------------------
    var isCriteriaCategoriesChanged_Comment_REFR = false;
    let reportCriteria_Comment_REFR = null;
    let excelData = [];
    //----------------------------------------------------Default Rest--------------------------------------------------

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    RestDataSource_Category_Comment_REFR = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "spec-list"
    });
    RestDataSource_SubCategory_Comment_REFR = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });
    RestDataSource_Class_Comment_REFR = isc.TrDS.create({
        ID: "RestDataSource_Class_REFR_comment",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleClass"},
            {name: "code"},
            {name: "course.titleFa"}
        ],
        fetchDataURL: classUrl + "info-tuple-list"
    });
    RestDataSource_Comment_REFR = isc.TrDS.create({
        fields: [
            { name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "classCode", title: "<spring:message code="class.code"/>", filterOperator: "iContains"},
            {name: "classTitle", title: "<spring:message code="class.title"/>", filterOperator: "iContains"},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains"},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains"},
            {name: "startDate", title: "<spring:message code="start.date"/>", filterOperator: "iContains"},
            {name: "endDate", title: "<spring:message code="end.date"/>", filterOperator: "iContains"},
            {name: "titleCategory", title: "<spring:message code="category"/>", filterOperator: "iContains"},
            {name: "titleSubCategory", title: "<spring:message code="subcategory"/>", filterOperator: "iContains"},
            {name: "description", title: "<spring:message code="suggestions"/>", filterOperator: "iContains"},

        ],
        fetchDataURL: viewReactionEvaluationCommentUrl + "/list/"+"teacher",
    });

    //----------------------------------------------------Criteria Form------------------------------------------------
    ToolStripButton_Excel_Comment_REFR = isc.ToolStripButtonExcel.create({
        click: function () {
            makeExcelComments();
        }
    });
    ToolStripButton_Refresh_Comment_REFR = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Comment_REFR.invalidateCache();
        }
    });

    DynamicForm_CriteriaForm_Comment_REFR = isc.DynamicForm.create({
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
                ID: "startDate_jspCER_comment",
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
                        displayDatePicker('startDate_jspCER_comment', this, 'ymd', '/');
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
                title: "بازه کلاس: پایان تا",
                ID: "endDate_jspCER_comment",
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
                        displayDatePicker('endDate_jspCER_comment', this, 'ymd', '/');
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
                name: "titleCategory",
                title: "گروه کاری",
                type: "SelectItem",
                textAlign: "center",
                colSpan: 2,
                titleColSpan: 1,
                optionDataSource: RestDataSource_Category_Comment_REFR,
                valueField: "titleFa",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                changed: function () {

                    isCriteriaCategoriesChanged_Comment_REFR = true;
                    var subCategoryField = DynamicForm_CriteriaForm_Comment_REFR.getField("titleSubCategory");
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
                    for (var i = 0; i < subCategories.length; i++) {
                        if (categoryNames.contains(subCategories[i].category.titleFa))
                            SubCats.add(subCategories[i].titleFa);
                    }
                    subCategoryField.setValue(SubCats);
                    subCategoryField.focus(this.form, subCategoryField);
                }
            },
            {
                name: "titleSubCategory",
                title: "زیرگروه کاری",
                type: "SelectItem",
                textAlign: "center",
                colSpan: 2,
                titleColSpan: 1,
                autoFetchData: false,
                disabled: true,
                optionDataSource: RestDataSource_SubCategory_Comment_REFR,
                valueField: "titleFa",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                focus: function () {

                    if (isCriteriaCategoriesChanged_Comment_REFR) {
                        isCriteriaCategoriesChanged_Comment_REFR = false;
                        var names = DynamicForm_CriteriaForm_Comment_REFR.getField("titleCategory").getValue();
                        if (names === []) {
                            RestDataSource_SubCategory_Comment_REFR.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_Comment_REFR.implicitCriteria = {
                                _constructor: "AdvancedCriteria",
                                operator: "and",
                                criteria: [{fieldName: "category.titleFa", operator: "inSet", value: names}]
                            };
                        }
                        this.fetchData();
                    }
                }
            }
        ]
    });
    DynamicForm_choose_report_type_REFR = isc.DynamicForm.create({
        align: "right",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 6,
        colWidths: ["10%", "25%", "25%", "10%", "25%", "25%"],
        fields: [
            {
                name: "reportTypeComments",
                title: "انتقادات و پیشنهادات توسط : ",
                valueMap: {
                    "teacher": "استاد",
                    "student": "فراگیر",
                    "personnel": "کارکنان آموزش",
                },
                type: "SelectItem",
                textAlign: "center",
                defaultValue:  ["teacher"],
                colSpan: 2,
                allowAdvancedCriteria: false,
                titleColSpan: 1,
                required: true,
                changed: function (form, item, value) {
                    RestDataSource_Comment_REFR.fetchDataURL = viewReactionEvaluationCommentUrl + "/list/"+value

                }

            }
        ]
    });

    //----------------------------------- layOut -----------------------------------------------------------------------
    var ListGrid_Comment_REFR = isc.TrLG.create({
        height: "70%",
        dataPageSize: 1000,
        filterOnKeypress: false,
        showFilterEditor: true,
        gridComponents: ["filterEditor", "header", "body"],
        dataSource: RestDataSource_Comment_REFR,
        fields: [
            {name: "classCode"},
            {name: "classTitle"},
            {name: "firstName"},
            {name: "lastName"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "titleCategory"},
            {name: "titleSubCategory"},
            {name: "description"},

        ]
    });
    var VLayout_Body_Comment_REFR = isc.TrVLayout.create({
        border: "2px solid blue",
        padding: 20,
        members: [
            ListGrid_Comment_REFR
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------
    //
    function makeExcelComments() {

        if (ListGrid_Comment_REFR.getOriginalData().localData === undefined)
            createDialog("info", "ابتدا چاپ گزارش را انتخاب کنید");
        else {
            let records = ListGrid_Comment_REFR.data.localData.toArray();
            excelData = [];
            excelData.add({
                classCode: "کد کلاس",
                classTitle: "عنوان کلاس",
                firstName: "نام ",
                lastName: "نام خانوادگی ",
                startDate: "تاریخ شروع",
                endDate: "تاریخ پایان",
                titleCategory: "گروه",
                titleSubCategory: "زیرگروه",
                description: "نظرات",
            });

            if(records) {
                for (let j = 0; j < records.length; j++) {
                    excelData.add({
                        rowNum: j+1,
                        classCode: records[j].classCode,
                        classTitle: records[j].classTitle,
                        firstName: records[j].firstName,
                        lastName: records[j].lastName,
                        startDate: records[j].startDate,
                        endDate: records[j].endDate,
                        titleCategory: records[j].titleCategory,
                        titleSubCategory: records[j].titleSubCategory,
                        description: records[j].description
                    });

                }
            }
            let fields = [
                {name: "rowNum"},
                {name: "classCode"},
                {name: "classTitle"},
                {name: "firstName"},
                {name: "lastName"},
                {name: "startDate"},
                {name: "endDate"},
                {name: "titleCategory"},
                {name: "titleSubCategory"},
                {name: "description"}
            ];
            ExportToFile.exportToExcelFromClient(fields, excelData, "", "گزارش نظرات ارزیابی ", null);
        }
    }
    // </script>