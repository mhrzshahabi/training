<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
// <script>
    //----------------------------------------------------Variables-----------------------------------------------------
    var isCriteriaCategoriesChanged_JspEvaluationStaticalReport = false;
    var startDate1Check_JspEvaluationStaticalReport = true;
    var startDate2Check_JspEvaluationStaticalReport = true;
    var startDateCheck_Order_JspEvaluationStaticalReport = true;
    var endDate1Check_JspEvaluationStaticalReport = true;
    var endDate2Check_JspEvaluationStaticalReport = true;
    var endDateCheck_Order_JspEvaluationStaticalReport = true;

    var data_values = null;
    //----------------------------------------------------Rest DataSource-----------------------------------------------
    var RestDataSource_Class_JspClassResult = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "code"},
            {name: "course.code"},
            {name: "course.titleFa"},
            {name: "hduration"},
            {name: "teacher"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "year"},
            {name: "classStatus"},
            {name: "studentsCount"}
        ],
        fetchDataURL: classUrl + "list-training-report"
    });

    var RestDataSource_Category_JspEvaluationStaticalReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "spec-list"
    });

    var RestDataSource_SubCategory_JspEvaluationStaticalReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });

    var RestDataSource_Course_JspEvaluationStaticalReport = isc.TrDS.create({
        ID: "courseDS",
        fields: [
            {name: "id", type: "Integer", primaryKey: true},
            {name: "code"},
            {name: "titleFa"}
        ],
        fetchDataURL: courseUrl + "info-tuple-list"
    });

    var RestDataSource_Class_JspEvaluationStaticalReport = isc.TrDS.create({
        ID: "classDS",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleClass"},
            {name: "code"},
            {name: "course.titleFa"}
        ],
        fetchDataURL: classUrl + "info-tuple-list"
    });

    var RestDataSource_Term_JspEvaluationStaticalReport = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
        ]
    });

    var RestDataSource_Year_JspEvaluationStaticalReport = isc.TrDS.create({
        fields: [
            {name: "year", primaryKey: true}
        ],
        fetchDataURL: termUrl + "yearList"
    });

    var RestDataSource_Teacher_JspEvaluationStaticalReport = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "personality.firstNameFa",filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personality.lastNameFa"},
            {name: "personality.nationalCode"},
            {name: "fullNameFa"}
        ],
        fetchDataURL: teacherUrl + "info-tuple-list"
    });

    var RestDataSource_Institute_JspEvaluationStaticalReport = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"},
            {name: "manager.firstNameFa"},
            {name: "manager.lastNameFa"}
        ],
        fetchDataURL: instituteUrl + "iscList"
    });
    //----------------------------------------------------ListGrid Result-----------------------------------------------
    var ListGrid_Result_JspEvaluationStaticalReport = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Class_JspClassResult,
        fields: [
            {name: "id", title: "id", canEdit: false, hidden: true},
            {
                name: "code",
                title: "کد کلاس"
            },
            {
                name: "course.code",
                title: "کد دوره"
            },
            {
                name: "course.titleFa",
                title: "نام دوره"
            },
            {
                name: "hduration",
                title: "مدت به ساعت"
            },
            {
                name: "teacher",
                title: "مدرس"
            },
            {
                name: "startDate",
                title: "تاریخ شروع"
            },
            {
                name: "endDate",
                title: "تاریخ خاتمه"
            },
            {
                name: "year",
                title: "سال"
            },
            {
                name: "classStatus",
                title: "وضعیت کلاس",
                valueMap: {
                    "1": "برنامه ریزی",
                    "2": "در حال اجرا",
                    "3": "پایان یافته"
                }
            },
            {
                name: "studentsCount",
                title: "تعداد فراگیران"
            }
        ],
        cellHeight: 43,
        filterOperator: "iContains",
        filterOnKeypress: true,
        autoFetchData: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        selectionType: "single",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>"
    });

    var Window_Result_JspEvaluationStaticalReport = isc.Window.create({
        placement: "fillScreen",
        title: "گزارش آمار اثربخشی کلاسهای آموزشی",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [
            isc.TrVLayout.create({
                members: [
                    ListGrid_Result_JspEvaluationStaticalReport
                ]
            })
        ]
    });
    //----------------------------------------------------Criteria Form------------------------------------------------
    var DynamicForm_CriteriaForm_JspEvaluationStaticalReport = isc.DynamicForm.create({
        align: "right",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 6,
        colWidths: ["5%", "25%", "5%", "25%","5%","25%"],
        fields: [
            {
                name: "TclassCode",
                title: "کد کلاس",
                hint: "کدهای کلاس را با ; از یکدیگر جدا کنید",
                prompt: "کدهای کلاس فقط میتوانند شامل حروف انگلیسی بزرگ، اعداد و - باشند",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                        DynamicForm_SelectClasses_JspEvaluationStaticalReport.clearValues();
                        Window_SelectClasses_JspEvaluationStaticalReport.show();
                    }
                }],
                keyPressFilter: "[A-Z|0-9|;-]"
            },
            {
                name: "UnitId",
                title: "واحد",
                length: 100,
                filterOperator: "iContains"
            },
            {
                name: "InstituteId",
                title: "محل برگزاری",
                length: 100,
                filterOperator: "iContains"
            },
            {
                name: "TeacherId",
                title: "مدرس",
                type: "ComboBoxItem",
                optionDataSource: RestDataSource_Teacher_JspEvaluationStaticalReport,
                displayField: "fullNameFa",
                valueField: "id",
                addUnknownValues: false,
                changeOnKeypress: false,
                filterOnKeypress: true,
                autoFetchData: false,
                textMatchStyle: "startsWith",
                generateExactMatchCriteria: true,
                filterFields: ["personality.firstNameFa","personality.lastNameFa","personality.nationalCode"],
                pickListFields: [
                    {name: "personality.firstNameFa", title: "نام"},
                    {name: "personality.lastNameFa", title: "نام خانوادگی"},
                    {name: "personality.nationalCode", title: "کد ملی"}],
                pickListProperties: {
                    showFilterEditor: false,
                    alternateRecordStyles: true,
                    autoFitWidthApproach: "both"
                }
            },
            {
                name: "TclassYear",
                title: "سال کاری",
                type: "SelectItem",
                multiple: true,
                optionDataSource: RestDataSource_Year_JspEvaluationStaticalReport,
                valueField: "year",
                displayField: "year",
                filterFields: ["year"],
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains",
                    gridComponents: [
                        isc.ToolStrip.create({
                            autoDraw: false,
                            height: 30,
                            width: "100%",
                            members: [
                                isc.ToolStripButton.create({
                                    width: "50%",
                                    icon: "[SKIN]/actions/approve.png",
                                    title: "انتخاب همه",
                                    click: function () {
                                        var item = DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("TclassYear"),
                                            fullData = item.pickList.data,
                                            cache = fullData.localData,
                                            values = [];

                                        for (var i = 0; i < cache.length; i++) {
                                            values[i] = cache[i].year;
                                        }
                                        item.setValue(values);
                                        item.pickList.hide();
                                    }
                                }),
                                isc.ToolStripButton.create({
                                    width: "50%",
                                    icon: "[SKIN]/actions/close.png",
                                    title: "حذف همه",
                                    click: function () {
                                        var item = DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("TclassYear");
                                        item.setValue([]);
                                        item.pickList.hide();
                                    }
                                })
                            ]
                        }),
                        "header", "body"
                    ]
                },
                changed: function (form, item, value) {
                    if (value != null && value != undefined && value.size() == 1) {
                        RestDataSource_Term_JspEvaluationStaticalReport.fetchDataURL = termUrl + "listByYear/" + value[0];
                        DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("TermId").optionDataSource = RestDataSource_Term_JspEvaluationStaticalReport;
                        DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("TermId").fetchData();
                        DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("TermId").enable();
                    } else {
                        form.getField("TermId").disabled = true;
                        form.getField("TermId").clearValue();
                    }
                }
            },
            {
                name: "TermId",
                title: "ترم",
                type: "SelectItem",
                multiple: true,
                filterOperator: "equals",
                disabled: true,
                valueField: "id",
                displayField: "titleFa",
                filterLocally: true,
                pickListProperties: {
                    gridComponents: [
                        isc.ToolStrip.create({
                            autoDraw: false,
                            height: 30,
                            width: "100%",
                            members: [
                                isc.ToolStripButton.create({
                                    width: "50%",
                                    icon: "[SKIN]/actions/approve.png",
                                    title: "انتخاب همه",
                                    click: function () {
                                        var item = DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("TermId"),
                                            fullData = item.pickList.data,
                                            cache = fullData.localData,
                                            values = [];

                                        for (var i = 0; i < cache.length; i++) {
                                            values[i] = cache[i].titleFa;
                                        }
                                        item.setValue(values);
                                        item.pickList.hide();
                                    }
                                }),
                                isc.ToolStripButton.create({
                                    width: "50%",
                                    icon: "[SKIN]/actions/close.png",
                                    title: "حذف همه",
                                    click: function () {
                                        var item = DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("TermId");
                                        item.setValue([]);
                                        item.pickList.hide();
                                    }
                                })
                            ]
                        }),
                        "header", "body"
                    ]
                }
            },
            {
                name: "startDate1",
                ID: "startDate1_JspEvaluationStaticalReport",
                title: "تاریخ شروع کلاس: از",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate1_JspEvaluationStaticalReport', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("startDate2","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("startDate1", true);
                        startDateCheck_Order_JspEvaluationStaticalReport = true;
                        startDate1Check_JspEvaluationStaticalReport = true;
                        return;
                    }
                    var dateCheck;
                    var endDate = form.getValue("startDate2");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        startDate1Check_JspEvaluationStaticalReport = false;
                        startDateCheck_Order_JspEvaluationStaticalReport = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        startDateCheck_Order_JspEvaluationStaticalReport = false;
                        startDate1Check_JspEvaluationStaticalReport = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    }
                    else {
                        startDate1Check_JspEvaluationStaticalReport = true;
                        startDateCheck_Order_JspEvaluationStaticalReport = true;
                        form.clearFieldErrors("startDate1", true);
                    }
                }
            },
            {
                name: "startDate2",
                ID: "startDate2_JspEvaluationStaticalReport",
                title: "تا",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate2_JspEvaluationStaticalReport', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("startDate1","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("startDate2", true);
                        startDateCheck_Order_JspEvaluationStaticalReport = true;
                        startDate2Check_JspEvaluationStaticalReport = true;
                        return;
                    }
                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("startDate1");
                    if (dateCheck === false) {
                        startDate2Check_JspEvaluationStaticalReport = false;
                        startDateCheck_Order_JspEvaluationStaticalReport = true;
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "<spring:message code='msg.correct.date'/>", true);
                    } else if (startDate != undefined && value < startDate) {
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        startDate2Check_JspEvaluationStaticalReport = true;
                        startDateCheck_Order_JspEvaluationStaticalReport = false;
                    } else {
                        form.clearFieldErrors("startDate2", true);
                        startDate2Check_JspEvaluationStaticalReport = true;
                        startDateCheck_Order_JspEvaluationStaticalReport = true;
                    }
                }
            },
            {
                name: "temp1",
                title: "",
                canEdit: false
            },
            {
                name: "endDate1",
                ID: "endDate1_JspEvaluationStaticalReport",
                title: "تاریخ پایان کلاس: از",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('endDate1_JspEvaluationStaticalReport', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("endDate2","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("endDate1", true);
                        endDateCheck_Order_JspEvaluationStaticalReport = true;
                        endDate1Check_JspEvaluationStaticalReport = true;
                        return;
                    }
                    var dateCheck;
                    var endDate = form.getValue("endDate2");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        endDate1Check_JspEvaluationStaticalReport = false;
                        endDateCheck_Order_JspEvaluationStaticalReport = true;
                        form.clearFieldErrors("endDate1", true);
                        form.addFieldErrors("endDate1", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        endDateCheck_Order_JspEvaluationStaticalReport = false;
                        endDate1Check_JspEvaluationStaticalReport = true;
                        form.clearFieldErrors("endDate1", true);
                        form.addFieldErrors("endDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    } else {
                        endDate1Check_JspEvaluationStaticalReport = true;
                        endDateCheck_Order_JspEvaluationStaticalReport = true;
                        form.clearFieldErrors("endDate1", true);
                    }
                }
            },
            {
                name: "endDate2",
                ID: "endDate2_JspEvaluationStaticalReport",
                title: "تا",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate2_JspEvaluationStaticalReport', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("endDate1","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("endDate2", true);
                        endDateCheck_Order_JspEvaluationStaticalReport = true;
                        endDate2Check_JspEvaluationStaticalReport = true;
                        return;
                    }
                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("endDate1");
                    if (dateCheck === false) {
                        endDate2Check_JspEvaluationStaticalReport = false;
                        endDateCheck_Order_JspEvaluationStaticalReport = true;
                        form.clearFieldErrors("endDate2", true);
                        form.addFieldErrors("endDate2", "<spring:message code='msg.correct.date'/>", true);
                    } else if (startDate != undefined && value < startDate) {
                        form.clearFieldErrors("endDate2", true);
                        form.addFieldErrors("endDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        endDate2Check_JspEvaluationStaticalReport = true;
                        endDateCheck_Order_JspEvaluationStaticalReport = false;
                    } else {
                        form.clearFieldErrors("endDate2", true);
                        endDate2Check_JspEvaluationStaticalReport = true;
                        endDateCheck_Order_JspEvaluationStaticalReport = true;
                    }
                }
            },
            {
                name: "temp2",
                title: "",
                canEdit: false
            },
            {
                name: "CourseCode",
                title: "کد دوره",
                hint: "کدهای دوره را با ; از یکدیگر جدا کنید",
                prompt: "کدهای دوره فقط میتوانند شامل حروف انگلیسی بزرگ، اعداد و - باشند",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                        DynamicForm_SelectCourses_JspEvaluationStaticalReport.clearValues();
                        Window_SelectCourses_JspEvaluationStaticalReport.show();
                    }
                }],
                keyPressFilter: "[A-Z|0-9|;-]"
            },
            {
                name: "CourseCategory",
                title: "گروه کاری",
                type: "SelectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_Category_JspEvaluationStaticalReport,
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
                    isCriteriaCategoriesChanged_JspEvaluationStaticalReport = true;
                    var subCategoryField = DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("CourseSubCategory");
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
                name: "CourseSubCategory",
                title: "زیرگروه کاری",
                type: "SelectItem",
                textAlign: "center",
                autoFetchData: false,
                disabled: true,
                optionDataSource: RestDataSource_SubCategory_JspEvaluationStaticalReport,
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
                    if (isCriteriaCategoriesChanged_JspEvaluationStaticalReport) {
                        isCriteriaCategoriesChanged_JspEvaluationStaticalReport = false;
                        var ids = DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("CourseCategory").getValue();
                        if (ids === []) {
                            RestDataSource_SubCategory_JspEvaluationStaticalReport.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_JspEvaluationStaticalReport.implicitCriteria = {
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
                name: "evaluationType",
                title: "نوع ارزیابی",
                type: "SelectItem",
                multiple: true,
                valueMap: {
                    "1": "واکنشی",
                    "2": "یادگیری",
                    "3": "رفتاری",
                    "4": "نتایج"
                },
                pickListProperties: {
                    showFilterEditor: false
                },
                defaultValue:  [ "1", "2", "3", "4" ]
            }
        ]
    });

    var initialLayoutStyle = "vertical";
    var DynamicForm_SelectCourses_JspEvaluationStaticalReport = isc.DynamicForm.create({
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
                optionDataSource: RestDataSource_Course_JspEvaluationStaticalReport
            }
        ]
    });
    DynamicForm_SelectCourses_JspEvaluationStaticalReport.getField("course.code").comboBox.setHint("دوره های مورد نظر را انتخاب کنید");
    DynamicForm_SelectCourses_JspEvaluationStaticalReport.getField("course.code").comboBox.pickListFields =
        [{name: "titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"},
            {
                name: "code", title: "کد دوره", width: "30%", filterOperator: "iContains"
            }];
    DynamicForm_SelectCourses_JspEvaluationStaticalReport.getField("course.code").comboBox.filterFields = ["titleFa", "code"];

    IButton_ConfirmCourseSelections_JspEvaluationStaticalReport = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            var criteriaDisplayValues = "";
            var selectorDisplayValues = DynamicForm_SelectCourses_JspEvaluationStaticalReport.getItem("course.code").getValue();
            if (DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("CourseCode").getValue() != undefined
                && DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("CourseCode").getValue() != "") {
                criteriaDisplayValues = DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("CourseCode").getValue();
                var ALength = criteriaDisplayValues.length;
                var lastChar = criteriaDisplayValues.charAt(ALength - 1);
                if (lastChar != ";")
                    criteriaDisplayValues += ";";
            }
            if (selectorDisplayValues != undefined) {
                for (var i = 0; i < selectorDisplayValues.size() - 1; i++) {
                    criteriaDisplayValues += selectorDisplayValues [i] + ";";
                }
                criteriaDisplayValues += selectorDisplayValues [selectorDisplayValues.size() - 1];
            }
            DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("CourseCode").setValue(criteriaDisplayValues);
            Window_SelectCourses_JspEvaluationStaticalReport.close();
        }
    });

    var Window_SelectCourses_JspEvaluationStaticalReport = isc.Window.create({
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
                    DynamicForm_SelectCourses_JspEvaluationStaticalReport,
                    IButton_ConfirmCourseSelections_JspEvaluationStaticalReport
                ]
            })
        ]
    });

    var DynamicForm_SelectClasses_JspEvaluationStaticalReport = isc.DynamicForm.create({
        align: "center",
        titleWidth: 0,
        titleAlign: "center",
        width: 500,
        height: 300,
        fields: [
            {
                name: "class.code",
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
                optionDataSource: RestDataSource_Class_JspEvaluationStaticalReport
            }
        ]
    });

    DynamicForm_SelectClasses_JspEvaluationStaticalReport.getField("class.code").comboBox.setHint("کلاسهای مورد نظر را انتخاب کنید");
    DynamicForm_SelectClasses_JspEvaluationStaticalReport.getField("class.code").comboBox.pickListFields =
        [
            {name: "titleClass", title: "نام کلاس", width: "30%", filterOperator: "iContains"},
            {name: "code", title: "کد کلاس", width: "30%", filterOperator: "iContains"},
            {name: "course.titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"}];
    DynamicForm_SelectClasses_JspEvaluationStaticalReport.getField("class.code").comboBox.filterFields = ["titleClass", "code", "course.titleFa"];

    IButton_ConfirmClassesSelections_JspEvaluationStaticalReport = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            var criteriaDisplayValues = "";
            var selectorDisplayValues = DynamicForm_SelectClasses_JspEvaluationStaticalReport.getItem("class.code").getValue();
            if (DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("TclassCode").getValue() != undefined
                && DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("TclassCode").getValue() != "") {
                criteriaDisplayValues = DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("TclassCode").getValue();
                var ALength = criteriaDisplayValues.length;
                var lastChar = criteriaDisplayValues.charAt(ALength - 1);
                if (lastChar != ";")
                    criteriaDisplayValues += ";";
            }
            if (selectorDisplayValues != undefined) {
                for (var i = 0; i < selectorDisplayValues.size() - 1; i++) {
                    criteriaDisplayValues += selectorDisplayValues [i] + ";";
                }
                criteriaDisplayValues += selectorDisplayValues [selectorDisplayValues.size() - 1];
            }
            DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("TclassCode").setValue(criteriaDisplayValues);
            Window_SelectClasses_JspEvaluationStaticalReport.close();
        }
    });

    var Window_SelectClasses_JspEvaluationStaticalReport = isc.Window.create({
        placement: "center",
        title: "انتخاب کلاس ها",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "2px solid gray",
        width: 500,
        height: 300,
        items: [
            isc.TrVLayout.create({
                members: [
                    DynamicForm_SelectClasses_JspEvaluationStaticalReport,
                    IButton_ConfirmClassesSelections_JspEvaluationStaticalReport
                ]
            })
        ]
    });

    IButton_StaticalReport_JspEvaluationStaticalReport = isc.IButtonSave.create({
        top: 260,
        title: "گزارش آماری",
        width: 300,
        click: function () {
            DynamicForm_CriteriaForm_JspEvaluationStaticalReport.validate();
            if (DynamicForm_CriteriaForm_JspEvaluationStaticalReport.hasErrors())
                return;
            var startDuratiorn = DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getValue("hDurationStart");
            var endDuratiorn = DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getValue("hDurationEnd");
            if (startDuratiorn != undefined && endDuratiorn != undefined &&  parseFloat(startDuratiorn) > parseFloat(endDuratiorn)){
                DynamicForm_CriteriaForm_JspEvaluationStaticalReport.clearFieldErrors("hDurationEnd", true);
                DynamicForm_CriteriaForm_JspEvaluationStaticalReport.clearFieldErrors("hDurationStart", true);
                DynamicForm_CriteriaForm_JspEvaluationStaticalReport.addFieldErrors("hDurationEnd", "حداکثر مدت کلاس باید بیشتر از حداقل مدت کلاس باشد", true);
                DynamicForm_CriteriaForm_JspEvaluationStaticalReport.addFieldErrors("hDurationStart", "حداکثر مدت کلاس باید بیشتر از حداقل مدت کلاس باشد", true);
                return;
            }
            else{
                DynamicForm_CriteriaForm_JspEvaluationStaticalReport.clearFieldErrors("hDurationEnd", true);
                DynamicForm_CriteriaForm_JspEvaluationStaticalReport.clearFieldErrors("hDurationStart", true);
            }
            if (!DynamicForm_CriteriaForm_JspEvaluationStaticalReport.validate() ||
                startDateCheck_Order_JspEvaluationStaticalReport == false ||
                startDate2Check_JspEvaluationStaticalReport == false ||
                startDate1Check_JspEvaluationStaticalReport == false ||
                endDateCheck_Order_JspEvaluationStaticalReport == false ||
                endDate2Check_JspEvaluationStaticalReport == false ||
                endDate1Check_JspEvaluationStaticalReport == false) {

                if (startDateCheck_Order_JspEvaluationStaticalReport == false) {
                    DynamicForm_CriteriaForm_JspEvaluationStaticalReport.clearFieldErrors("startDate2", true);
                    DynamicForm_CriteriaForm_JspEvaluationStaticalReport.addFieldErrors("startDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                }
                if (startDateCheck_Order_JspEvaluationStaticalReport == false) {
                    DynamicForm_CriteriaForm_JspEvaluationStaticalReport.clearFieldErrors("startDate1", true);
                    DynamicForm_CriteriaForm_JspEvaluationStaticalReport.addFieldErrors("startDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                }
                if (startDate2Check_JspEvaluationStaticalReport == false) {
                    DynamicForm_CriteriaForm_JspEvaluationStaticalReport.clearFieldErrors("startDate2", true);
                    DynamicForm_CriteriaForm_JspEvaluationStaticalReport.addFieldErrors("startDate2", "<spring:message
        code='msg.correct.date'/>", true);
                }
                if (startDate1Check_JspEvaluationStaticalReport == false) {
                    DynamicForm_CriteriaForm_JspEvaluationStaticalReport.clearFieldErrors("startDate1", true);
                    DynamicForm_CriteriaForm_JspEvaluationStaticalReport.addFieldErrors("startDate1", "<spring:message
        code='msg.correct.date'/>", true);
                }

                if (endDateCheck_Order_JspEvaluationStaticalReport == false) {
                    DynamicForm_CriteriaForm_JspEvaluationStaticalReport.clearFieldErrors("endDate2", true);
                    DynamicForm_CriteriaForm_JspEvaluationStaticalReport.addFieldErrors("endDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                }
                if (endDateCheck_Order_JspEvaluationStaticalReport == false) {
                    DynamicForm_CriteriaForm_JspEvaluationStaticalReport.clearFieldErrors("endDate1", true);
                    DynamicForm_CriteriaForm_JspEvaluationStaticalReport.addFieldErrors("endDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                }
                if (endDate2Check_JspEvaluationStaticalReport == false) {
                    DynamicForm_CriteriaForm_JspEvaluationStaticalReport.clearFieldErrors("endDate2", true);
                    DynamicForm_CriteriaForm_JspEvaluationStaticalReport.addFieldErrors("endDate2", "<spring:message code='msg.correct.date'/>", true);
                }
                if (endDate1Check_JspEvaluationStaticalReport == false) {
                    DynamicForm_CriteriaForm_JspEvaluationStaticalReport.clearFieldErrors("endDate1", true);
                    DynamicForm_CriteriaForm_JspEvaluationStaticalReport.addFieldErrors("endDate1", "<spring:message code='msg.correct.date'/>", true);
                }
                return;
            }
            Reporting();

            ListGrid_Result_JspEvaluationStaticalReport.invalidateCache();
            ListGrid_Result_JspEvaluationStaticalReport.fetchData(data_values);
            Window_Result_JspEvaluationStaticalReport.show();
        }
    });

    IButton_ListReport_JspEvaluationStaticalReport = isc.IButtonSave.create({
        top: 260,
        title: "گزارش لیستی",
        width: 300,
        click: function () {}});


    //----------------------------------- functions --------------------------------------------------------------------
    function Reporting(){
        data_values = null;
        data_values = DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getValuesAsAdvancedCriteria();
        var removedObjects = [];
        for (var i = 0; i < data_values.criteria.size(); i++) {

            if (data_values.criteria[i].fieldName == "course.code") {
                var codesString = data_values.criteria[i].value;
                var codesArray;
                codesArray = codesString.split(";");
                for (var j = 0; j < codesArray.length; j++) {
                    if (codesArray[j] == "" || codesArray[j] == " ") {
                        codesArray.remove(codesArray[j]);
                    }
                }
                data_values.criteria[i].operator = "equals";
                data_values.criteria[i].value = codesArray;
            }

            else if (data_values.criteria[i].fieldName == "course.titleFa") {
                data_values.criteria[i].operator = DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("courseFilterOperator").getValue();
            }
            else if (data_values.criteria[i].fieldName == "hDurationStart") {
                data_values.criteria[i].fieldName = "hDuration";
                data_values.criteria[i].operator = "greaterOrEqual";
            }
            else if (data_values.criteria[i].fieldName == "hDurationEnd") {
                data_values.criteria[i].fieldName = "hDuration";
                data_values.criteria[i].operator = "lessOrEqual";
            }
            else if (data_values.criteria[i].fieldName == "startDate1") {
                data_values.criteria[i].fieldName = "startDate";
                data_values.criteria[i].operator = "greaterThan";
            }
            else if (data_values.criteria[i].fieldName == "startDate2") {
                data_values.criteria[i].fieldName = "startDate";
                data_values.criteria[i].operator = "lessThan";
            }
            else if (data_values.criteria[i].fieldName == "endDate1") {
                data_values.criteria[i].fieldName = "endDate";
                data_values.criteria[i].operator = "greaterThan";
            }
            else if (data_values.criteria[i].fieldName == "endDate2") {
                data_values.criteria[i].fieldName = "endDate";
                data_values.criteria[i].operator = "lessThan";
            }
            else if (data_values.criteria[i].fieldName == "workYear") {
                data_values.criteria[i].fieldName = "startDate";
                data_values.criteria[i].operator = "inSet";
            }
            else if(data_values.criteria[i].fieldName == "course.categoryId"){
                data_values.criteria[i].operator = "inSet";
            }
            else if(data_values.criteria[i].fieldName == "course.subCategoryId"){
                data_values.criteria[i].operator = "inSet";
            }
            else if (data_values.criteria[i].fieldName == "courseFilterOperator") {
                removedObjects.add(data_values.criteria[i]);
            }
            else if (data_values.criteria[i].fieldName == "reactionEvaluation") {
                removedObjects.add(data_values.criteria[i]);
            }
            else if (data_values.criteria[i].fieldName == "learningEvaluation") {
                removedObjects.add(data_values.criteria[i]);
            }
            else if (data_values.criteria[i].fieldName == "behavioralEvaluation") {
                removedObjects.add(data_values.criteria[i]);
            }
            else if (data_values.criteria[i].fieldName == "evaluation") {
                removedObjects.add(data_values.criteria[i]);
            }
            //-----------------------------------TEMP----------------------------
            // else if (data_values.criteria[i].fieldName == "reactionEvaluationOperator") {
            //     removedObjects.add(data_values.criteria[i]);
            // }
            // else if (data_values.criteria[i].fieldName == "reactionEvaluationGrade") {
            //     removedObjects.add(data_values.criteria[i]);
            // }
            // else if (data_values.criteria[i].fieldName == "learningEvaluationOperator") {
            //     removedObjects.add(data_values.criteria[i]);
            // }
            // else if (data_values.criteria[i].fieldName == "learningEvaluationGrade") {
            //     removedObjects.add(data_values.criteria[i]);
            // }
            // else if (data_values.criteria[i].fieldName == "behavioralEvaluationOperator") {
            //     removedObjects.add(data_values.criteria[i]);
            // }
            // else if (data_values.criteria[i].fieldName == "behavioralEvaluationGrade") {
            //     removedObjects.add(data_values.criteria[i]);
            // }
            // else if (data_values.criteria[i].fieldName == "evaluationOperator") {
            //     removedObjects.add(data_values.criteria[i]);
            // }
            // else if (data_values.criteria[i].fieldName == "evaluationGrade") {
            //     removedObjects.add(data_values.criteria[i]);
            // }
            //-----------------------------------TEMP----------------------------
            else if (data_values.criteria[i].fieldName == "teacherPayingStatus") {
                removedObjects.add(data_values.criteria[i]);
            }
        }
        data_values.criteria.removeList(removedObjects);
    }

    let Window_CriteriaForm_JspEvaluationStaticalReport = isc.Window.create({
        placement: "fillScreen",
        title: "",
        showCloseButton: false,
        showMaximizeButton: false,
        canDragReposition: false,
        showMinimizeButton: false,
        canDragResize: false,
        closeClick: false,
        minimize: false,
        items: [DynamicForm_CriteriaForm_JspEvaluationStaticalReport]
    });

    //----------------------------------- layOut -----------------------------------------------------------------------
    var HLayOut_CriteriaForm_JspEvaluationStaticalReport = isc.TrHLayoutButtons.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "100%",
        alignLayout: "center",
        members: [
            Window_CriteriaForm_JspEvaluationStaticalReport
        ]
    });
    var HLayOut_Confirm_JspEvaluationStaticalReport = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_StaticalReport_JspEvaluationStaticalReport,
            IButton_ListReport_JspEvaluationStaticalReport
        ]
    });


    var VLayout_Body_JspEvaluationStaticalReport = isc.TrVLayout.create({
        members: [
            HLayOut_CriteriaForm_JspEvaluationStaticalReport,
            HLayOut_Confirm_JspEvaluationStaticalReport
        ]
    });
    //----------------------------------------------------End-----------------------------------------------------------
    Window_Result_JspEvaluationStaticalReport.hide();