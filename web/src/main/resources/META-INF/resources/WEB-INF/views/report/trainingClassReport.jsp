<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
// <script>
    //----------------------------------------------------Variables-----------------------------------------------------
    var isCriteriaCategoriesChanged_JspTClassReport = false;
    var startDate1Check_JspTClassReport = true;
    var startDate2Check_JspTClassReport = true;
    var startDateCheck_Order_JspTClassReport = true;
    var endDate1Check_JspTClassReport = true;
    var endDate2Check_JspTClassReport = true;
    var endDateCheck_Order_JspTClassReport = true;

    var data_values = null;

    var courseInfo_print = "";
    var classTimeInfo_print = "";
    var executionInfo_print = "";
    var evaluationInfo_print = "";

    var titr = isc.HTMLFlow.create({
        align: "center",
        border: "1px solid black",
        width: "25%"
    });
    var courseInfo = isc.HTMLFlow.create({
        align: "center"
    });
    var classTimeInfo = isc.HTMLFlow.create({
        align: "center"
    });
    var executionInfo = isc.HTMLFlow.create({
        align: "center"
    });
    var reactionEvaluationInfo = isc.HTMLFlow.create({
        align: "center"
    });
    var learningEvaluationInfo = isc.HTMLFlow.create({
        align: "center"
    });
    var behavioralEvaluationInfo = isc.HTMLFlow.create({
        align: "center"
    });
    var evaluationInfo = isc.HTMLFlow.create({
        align: "center"
    });
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

    var RestDataSource_Category_JspTClassReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "spec-list"
    });

    var RestDataSource_SubCategory_JspTClassReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });

    var RestDataSource_Course_JspTClassReport = isc.TrDS.create({
        ID: "courseDS",
        fields: [
            {name: "id", type: "Integer", primaryKey: true},
            {name: "code"},
            {name: "titleFa"}
        ],
        fetchDataURL: courseUrl + "spec-safe-list"
    });

    var RestDataSource_Term_JspTClassReport = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
        ]
    });

    var RestDataSource_Year_JspTClassReport = isc.TrDS.create({
        fields: [
            {name: "year", primaryKey: true}
        ],
        fetchDataURL: termUrl + "yearList"
    });

    var RestDataSource_Teacher_JspTClassReport = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "fullNameFa"},
            {name: "personality.nationalCode"}
        ],
        fetchDataURL: teacherUrl + "fullName-list"
    });

    var RestDataSource_Institute_JspTClassReport = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"},
            {name: "manager.firstNameFa"},
            {name: "manager.lastNameFa"}
        ],
        fetchDataURL: instituteUrl + "iscList"
    });
    //----------------------------------------------------ListGrid Result-----------------------------------------------
    var Menu_ListGrid_JspTClassReport= isc.Menu.create({
        width: 150,
        data: [
         {
            title: "<spring:message code='print.pdf'/>", icon: "<spring:url value="pdf.png"/>", click: function () {
                 Reporting();

                 var dataParams = new Object();
                 dataParams.courseInfo = courseInfo_print;
                 dataParams.classTimeInfo = classTimeInfo_print;
                 dataParams.executionInfo = executionInfo_print;
                 dataParams.evaluationInfo = evaluationInfo_print;

                 trPrintWithCriteria("<spring:url value="/tclass/reportPrint/"/>" + "pdf", data_values,JSON.stringify(dataParams));
         }
        },
        {
            title: "<spring:message code='print.excel'/>", icon: "<spring:url value="excel.png"/>", click: function () {
                Reporting();

                var dataParams = new Object();
                dataParams.courseInfo = courseInfo_print;
                dataParams.classTimeInfo = classTimeInfo_print;
                dataParams.executionInfo = executionInfo_print;
                dataParams.evaluationInfo = evaluationInfo_print;

                trPrintWithCriteria("<spring:url value="/tclass/reportPrint/"/>" + "excel", data_values,JSON.stringify(dataParams));
            }
        },
        {
            title: "<spring:message code='print.html'/>", icon: "<spring:url value="html.png"/>", click: function () {
                Reporting();

                var dataParams = new Object();
                dataParams.courseInfo = courseInfo_print;
                dataParams.classTimeInfo = classTimeInfo_print;
                dataParams.executionInfo = executionInfo_print;
                dataParams.evaluationInfo = evaluationInfo_print;

                trPrintWithCriteria("<spring:url value="/tclass/reportPrint/"/>" + "html", data_values,JSON.stringify(dataParams));
            }
        }
        ]
    });

    var ListGrid_Result_JspTClassReport = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Class_JspClassResult,
        contextMenu: Menu_ListGrid_JspTClassReport,
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

    var Window_Result_JspTClassReport = isc.Window.create({
        placement: "fillScreen",
        title: "گزارش کلاس های آموزشی",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [
            isc.TrVLayout.create({
                members: [
                    titr,
                    courseInfo,
                    classTimeInfo,
                    executionInfo,
                    reactionEvaluationInfo,
                    learningEvaluationInfo,
                    behavioralEvaluationInfo,
                    evaluationInfo,
                    isc.ToolStripButtonExcel.create({
                        margin:5,
                        click: function() {
                            ExportToFile.showDialog(null, ListGrid_Result_JspTClassReport, 'trainingClassReport', 0, null, '',  "گزارش کلاس هاي آموزشي", ListGrid_Result_JspTClassReport.data.criteria, null);
                        }
                    }),
                    ListGrid_Result_JspTClassReport
                ]
            })
        ]
    });
    //----------------------------------------------------Criteria Form------------------------------------------------
    var DynamicForm_CriteriaForm_JspTClassReport = isc.DynamicForm.create({
        align: "right",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 6,
        colWidths: ["5%", "25%", "5%", "25%","5%","25%"],
        fields: [
            {
                name: "course.code",
                title: "کد دوره",
                hint: "کدهای دوره را با ; از یکدیگر جدا کنید",
                prompt: "کدهای دوره فقط میتوانند شامل حروف انگلیسی بزرگ، اعداد و - باشند",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                       // DynamicForm_SelectCourses_JspTClassReport.clearValues();
                        Window_SelectCourses_JspTClassReport.show();
                    }
                }],
                keyPressFilter: "[A-Z|0-9|;-]"
            },
            {
                name: "course.titleFa",
                title: "نام دوره",
                length: 100,
                filterOperator: "iContains"
            },
            {
                name: "courseFilterOperator",
                title: "فیلترینگ نام دوره",
                type: "radioGroup",
                vertical: false,
                valueMap: {
                    "starts with": "شروع با",
                    "ends with": "خاتمه با",
                    "iContains": "شامل",
                    "equals": "دقیقا شامل"
                },
                defaultValue: "iContains"
            },
            {
                name: "hDurationStart",
                title: "مدت کلاس: از",
                keyPressFilter: "[0-9]",
                length: 3,
                showHintInField: true,
                hint: "ساعت",
                editorExit: function (form, item, value) {
                   var endDuratiorn = form.getValue("hDurationEnd");
                   if (endDuratiorn != undefined && parseFloat(endDuratiorn) < parseFloat(value)) {
                        form.clearFieldErrors("hDurationStart", true);
                        form.addFieldErrors("hDurationStart", "حداکثر مدت کلاس باید بیشتر از حداقل مدت کلاس باشد", true);
                    } else {
                        form.clearFieldErrors("hDurationStart", true);
                        form.clearFieldErrors("hDurationEnd", true);
                    }
                }
            },
            {
                name: "hDurationEnd",
                title: "تا",
                length: 3,
                keyPressFilter: "[0-9]",
                showHintInField: true,
                hint: "ساعت",
                editorExit: function (form, item, value) {
                    var startDuratiorn = form.getValue("hDurationStart");
                    if (startDuratiorn != undefined && parseFloat(startDuratiorn) > parseFloat(value)) {
                        form.clearFieldErrors("hDurationEnd", true);
                        form.addFieldErrors("hDurationEnd", "حداکثر مدت کلاس باید بیشتر از حداقل مدت کلاس باشد", true);
                    } else {
                        form.clearFieldErrors("hDurationStart", true);
                        form.clearFieldErrors("hDurationEnd", true);
                    }
                }
            },
            {
                name: "temp1",
                title: "",
                canEdit: false
            },
            {
                name: "startDate1",
                ID: "startDate1_JspTClassReport",
                title: "تاریخ شروع کلاس: از",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate1_JspTClassReport', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("startDate2","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("startDate1", true);
                        startDateCheck_Order_JspTClassReport = true;
                        startDate1Check_JspTClassReport = true;
                        return;
                    }
                    var dateCheck;
                    var endDate = form.getValue("startDate2");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        startDate1Check_JspTClassReport = false;
                        startDateCheck_Order_JspTClassReport = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        startDateCheck_Order_JspTClassReport = false;
                        startDate1Check_JspTClassReport = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    }
                    else {
                        startDate1Check_JspTClassReport = true;
                        startDateCheck_Order_JspTClassReport = true;
                        form.clearFieldErrors("startDate1", true);
                    }
                }
            },
            {
                name: "startDate2",
                ID: "startDate2_JspTClassReport",
                title: "تا",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate2_JspTClassReport', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("startDate1","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("startDate2", true);
                        startDateCheck_Order_JspTClassReport = true;
                        startDate2Check_JspTClassReport = true;
                        return;
                    }
                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("startDate1");
                    if (dateCheck === false) {
                        startDate2Check_JspTClassReport = false;
                        startDateCheck_Order_JspTClassReport = true;
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "<spring:message code='msg.correct.date'/>", true);
                    } else if (startDate != undefined && value < startDate) {
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        startDate2Check_JspTClassReport = true;
                        startDateCheck_Order_JspTClassReport = false;
                    } else {
                        form.clearFieldErrors("startDate2", true);
                        startDate2Check_JspTClassReport = true;
                        startDateCheck_Order_JspTClassReport = true;
                    }
                }
            },
            {
                name: "temp2",
                title: "",
                canEdit: false
            },
            {
                name: "endDate1",
                ID: "endDate1_JspTClassReport",
                title: "تاریخ پایان کلاس: از",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('endDate1_JspTClassReport', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("endDate2","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("endDate1", true);
                        endDateCheck_Order_JspTClassReport = true;
                        endDate1Check_JspTClassReport = true;
                        return;
                    }
                    var dateCheck;
                    var endDate = form.getValue("endDate2");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        endDate1Check_JspTClassReport = false;
                        endDateCheck_Order_JspTClassReport = true;
                        form.clearFieldErrors("endDate1", true);
                        form.addFieldErrors("endDate1", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        endDateCheck_Order_JspTClassReport = false;
                        endDate1Check_JspTClassReport = true;
                        form.clearFieldErrors("endDate1", true);
                        form.addFieldErrors("endDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    } else {
                        endDate1Check_JspTClassReport = true;
                        endDateCheck_Order_JspTClassReport = true;
                        form.clearFieldErrors("endDate1", true);
                    }
                }
            },
            {
                name: "endDate2",
                ID: "endDate2_JspTClassReport",
                title: "تا",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate2_JspTClassReport', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("endDate1","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("endDate2", true);
                        endDateCheck_Order_JspTClassReport = true;
                        endDate2Check_JspTClassReport = true;
                        return;
                    }
                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("endDate1");
                    if (dateCheck === false) {
                        endDate2Check_JspTClassReport = false;
                        endDateCheck_Order_JspTClassReport = true;
                        form.clearFieldErrors("endDate2", true);
                        form.addFieldErrors("endDate2", "<spring:message code='msg.correct.date'/>", true);
                    } else if (startDate != undefined && value < startDate) {
                        form.clearFieldErrors("endDate2", true);
                        form.addFieldErrors("endDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        endDate2Check_JspTClassReport = true;
                        endDateCheck_Order_JspTClassReport = false;
                    } else {
                        form.clearFieldErrors("endDate2", true);
                        endDate2Check_JspTClassReport = true;
                        endDateCheck_Order_JspTClassReport = true;
                    }
                }
            },
            {
                name: "temp3",
                title: "",
                canEdit: false
            },
            {
                name: "course.categoryId",
                title: "گروه کاری",
                type: "SelectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_Category_JspTClassReport,
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
                    isCriteriaCategoriesChanged_JspTClassReport = true;
                    var subCategoryField = DynamicForm_CriteriaForm_JspTClassReport.getField("course.subCategoryId");
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
                name: "course.subCategoryId",
                title: "زیرگروه کاری",
                type: "SelectItem",
                textAlign: "center",
                autoFetchData: false,
                disabled: true,
                optionDataSource: RestDataSource_SubCategory_JspTClassReport,
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
                    if (isCriteriaCategoriesChanged_JspTClassReport) {
                        isCriteriaCategoriesChanged_JspTClassReport = false;
                        var ids = DynamicForm_CriteriaForm_JspTClassReport.getField("course.categoryId").getValue();
                        if (ids === []) {
                            RestDataSource_SubCategory_JspTClassReport.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_JspTClassReport.implicitCriteria = {
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
                name: "temp4",
                title: "",
                canEdit: false
            },
            {
                name: "workYear",
                title: "سال کاری",
                type: "SelectItem",
                multiple: true,
                optionDataSource: RestDataSource_Year_JspTClassReport,
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
                                        var item = DynamicForm_CriteriaForm_JspTClassReport.getField("workYear"),
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
                                        var item = DynamicForm_CriteriaForm_JspTClassReport.getField("workYear");
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
                        RestDataSource_Term_JspTClassReport.fetchDataURL = termUrl + "listByYear/" + value[0];
                        DynamicForm_CriteriaForm_JspTClassReport.getField("termId").optionDataSource = RestDataSource_Term_JspTClassReport;
                        DynamicForm_CriteriaForm_JspTClassReport.getField("termId").fetchData();
                        DynamicForm_CriteriaForm_JspTClassReport.getField("termId").enable();
                    } else {
                        form.getField("termId").disabled = true;
                        form.getField("termId").clearValue();
                    }
                }
            },
            {
                name: "termId",
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
                                        var item = DynamicForm_CriteriaForm_JspTClassReport.getField("termId"),
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
                                        var item = DynamicForm_CriteriaForm_JspTClassReport.getField("termId");
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
                name: "temp5",
                title: "",
                canEdit: false
            },
            {
                name: "teacherId",
                title: "مدرس",
                type: "SelectItem",
                filterOperator: "equals",
                allowEmptyValue: true,
                optionDataSource: RestDataSource_Teacher_JspTClassReport,
                valueField: "id",
                displayField: "fullNameFa",
                filterFields: ["fullNameFa", "personality.nationalCode"],
                filterLocally: true,
                pickListFields: [{name: "fullNameFa", title: "نام و نام خانوادگی"},
                                {name: "personality.nationalCode", title: "کد ملی"}],
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                }
            },
            {
                name: "teacherPayingStatus",
                title: "وضعیت هزینه ی مدرس",
                type: "SelectItem",
                defaultValue: "3",
                valueMap: {
                    "1": "پرداخت شده",
                    "2": "پرداخت نشده",
                    "3": "همه"
                },
                pickListProperties: {
                    showFilterEditor: false
                },
            },
            {
                name: "organizerId",
                title: "برگزار کننده",
                type: "SelectItem",
                filterOperator: "equals",
                allowEmptyValue: true,
                optionDataSource: RestDataSource_Institute_JspTClassReport,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa", "mobile", "manager.firstNameFa", "manager.lastNameFa"],
                pickListFields: [
                    {name: "titleFa", title: "نام موسسه", filterOperator: "iContains", autoFitWidth: true},
                    {name: "manager.firstNameFa", title: "نام مدیر", filterOperator: "iContains"},
                    {name: "manager.lastNameFa", title: "نام خانوادگی مدیر", filterOperator: "iContains"}
                ],
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true
                }
            },
            {
                name: "courseStatus",
                title: "نوع دوره",
                type: "SelectItem",
                defaultValue: "3",
                filterOperator: "equals",
                valueMap: {
                    "1": "وابسته به نیازسنجی مشاغل",
                    "2": "عدم نیازسنجی",
                    "3": "همه"
                },
                pickListProperties: {
                    showFilterEditor: false
                }
            },
            {
                name: "classStatus",
                title: "وضعیت کلاس",
                wrapTitle: true,
                type: "radioGroup",
                vertical: false,
                filterOperator: "equals",
                fillHorizontalSpace: true,
                defaultValue: "1",
                valueMap: {
                    "1": "برنامه ریزی",
                    "2": "در حال اجرا",
                    "3": "پایان یافته"
                }
            },
            {
                name: "temp6",
                title: "",
                canEdit: false
            },
            {
                name: "reactionEvaluation",
                title: "نمره ارزیابی واکنشی کلاس",
                type: "checkbox",
                changed: function (form, item, value) {
                    if (value == true) {
                        form.getField("reactionEvaluationOperator").disabled = false;
                        form.getField("reactionEvaluationGrade").enable();
                    } else if (value == false) {
                        form.getField("reactionEvaluationOperator").disabled = true;
                        form.getField("reactionEvaluationOperator").clearValue();
                        form.getField("reactionEvaluationGrade").disabled = true;
                        form.getField("reactionEvaluationGrade").clearValue();
                    }
                }
            },
            {
                name: "reactionEvaluationOperator",
                title: "",
                type: "SelectItem",
                valueMap: {
                    "1": "کمتر از",
                    "2": "بیشتر از"
                },
                disabled: true,
                hint: "اپراتور مقایسه ی مد نظر را انتخاب کنید",
                showHintInField: true,
                pickListProperties: {
                    showFilterEditor: false
                },
            },
            {
                name: "reactionEvaluationGrade",
                title: "",
                disabled: true,
                hint: "نمره ی ارزیابی واکنشی مد نظر را وارد کنید",
                showHintInField: true,
                length: 3,
                keyPressFilter: "[0-9]"
            },
            {
                name: "learningEvaluation",
                title: "نمره ارزیابی یادگیری کلاس",
                type: "checkbox",
                changed: function (form, item, value) {
                    if (value == true) {
                        form.getField("learningEvaluationOperator").disabled = false;
                        form.getField("learningEvaluationGrade").enable();
                    } else if (value == false) {
                        form.getField("learningEvaluationOperator").disabled = true;
                        form.getField("learningEvaluationOperator").clearValue();
                        form.getField("learningEvaluationGrade").disabled = true;
                        form.getField("learningEvaluationGrade").clearValue();
                    }
                }
            },
            {
                name: "learningEvaluationOperator",
                title: "",
                type: "SelectItem",
                valueMap: {
                    "1": "کمتر از",
                    "2": "بیشتر از"
                },
                disabled: true,
                hint: "اپراتور مقایسه ی مد نظر را انتخاب کنید",
                showHintInField: true,
                pickListProperties: {
                    showFilterEditor: false
                },
            },
            {
                name: "learningEvaluationGrade",
                title: "",
                disabled: true,
                hint: "نمره ی ارزیابی یادگیری مد نظر را وارد کنید",
                showHintInField: true,
                length: 3,
                keyPressFilter: "[0-9]"
            },
            {
                name: "behavioralEvaluation",
                title: "نمره ارزیابی رفتاری کلاس",
                type: "checkbox",
                changed: function (form, item, value) {
                    if (value == true) {
                        form.getField("behavioralEvaluationOperator").disabled = false;
                        form.getField("behavioralEvaluationGrade").enable();
                    } else if (value == false) {
                        form.getField("behavioralEvaluationOperator").disabled = true;
                        form.getField("behavioralEvaluationOperator").clearValue();
                        form.getField("behavioralEvaluationGrade").disabled = true;
                        form.getField("behavioralEvaluationGrade").clearValue();
                    }
                }
            },
            {
                name: "behavioralEvaluationOperator",
                title: "",
                type: "SelectItem",
                valueMap: {
                    "1": "کمتر از",
                    "2": "بیشتر از"
                },
                disabled: true,
                hint: "اپراتور مقایسه ی مد نظر را انتخاب کنید",
                showHintInField: true,
                pickListProperties: {
                    showFilterEditor: false
                },
            },
            {
                name: "behavioralEvaluationGrade",
                title: "",
                disabled: true,
                hint: "نمره ی ارزیابی رفتاری مد نظر را وارد کنید",
                showHintInField: true,
                length: 3,
                keyPressFilter: "[0-9]"
            },
            {
                name: "evaluation",
                title: "نمره اثربخشی کلاس",
                type: "checkbox",
                changed: function (form, item, value) {
                    if (value == true) {
                        form.getField("evaluationOperator").disabled = false;
                        form.getField("evaluationGrade").enable();
                    } else if (value == false) {
                        form.getField("evaluationOperator").disabled = true;
                        form.getField("evaluationOperator").clearValue();
                        form.getField("evaluationGrade").disabled = true;
                        form.getField("evaluationGrade").clearValue();
                    }
                }
            },
            {
                name: "evaluationOperator",
                title: "",
                type: "SelectItem",
                valueMap: {
                    "1": "کمتر از",
                    "2": "بیشتر از"
                },
                disabled: true,
                hint: "اپراتور مقایسه ی مد نظر را انتخاب کنید",
                showHintInField: true,
                pickListProperties: {
                    showFilterEditor: false
                },
            },
            {
                name: "evaluationGrade",
                title: "",
                disabled: true,
                hint: "نمره ی اثربخشی مد نظر را وارد کنید",
                showHintInField: true,
                length: 3,
                keyPressFilter: "[0-9]"
            }
        ]
    });

    var initialLayoutStyle = "vertical";
    var DynamicForm_SelectCourses_JspTClassReport = isc.DynamicForm.create({
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
                optionDataSource: RestDataSource_Course_JspTClassReport
            }
        ]
    });
    DynamicForm_SelectCourses_JspTClassReport.getField("course.code").comboBox.setHint("دوره های مورد نظر را انتخاب کنید");
    DynamicForm_SelectCourses_JspTClassReport.getField("course.code").comboBox.pickListFields =
        [{name: "titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"},
            {
                name: "code", title: "کد دوره", width: "30%", filterOperator: "iContains"
            }];
    DynamicForm_SelectCourses_JspTClassReport.getField("course.code").comboBox.filterFields = ["titleFa", "code"];

    IButton_ConfirmCourseSelections_JspTClassReport = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            var criteriaDisplayValues = "";
            var selectorDisplayValues = DynamicForm_SelectCourses_JspTClassReport.getItem("course.code").getValue();
            if (DynamicForm_CriteriaForm_JspTClassReport.getField("course.code").getValue() != undefined
                && DynamicForm_CriteriaForm_JspTClassReport.getField("course.code").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectCourses_JspTClassReport.getField("course.code").getValue().join(";");
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

            if (typeof criteriaDisplayValues != "undefined") {
                let uniqueNames = [];

                $.each(criteriaDisplayValues.split(";"), function (i, el) {
                    if ($.inArray(el, uniqueNames) === -1) uniqueNames.push(el);
                });
                criteriaDisplayValues = uniqueNames.join(";");
            }

            criteriaDisplayValues = criteriaDisplayValues == ";undefined" ? "" : criteriaDisplayValues;

            DynamicForm_CriteriaForm_JspTClassReport.getField("course.code").setValue(criteriaDisplayValues);
            Window_SelectCourses_JspTClassReport.close();
        }
    });

    var Window_SelectCourses_JspTClassReport = isc.Window.create({
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
                    DynamicForm_SelectCourses_JspTClassReport,
                    IButton_ConfirmCourseSelections_JspTClassReport
                ]
            })
        ]
    });

    IButton_Confirm_JspTClassReport = isc.IButtonSave.create({
        top: 260,
        title: "گزارش گیری",
        width: 300,
        click: function () {
            DynamicForm_CriteriaForm_JspTClassReport.validate();
            if (DynamicForm_CriteriaForm_JspTClassReport.hasErrors())
                return;
            var startDuratiorn = DynamicForm_CriteriaForm_JspTClassReport.getValue("hDurationStart");
            var endDuratiorn = DynamicForm_CriteriaForm_JspTClassReport.getValue("hDurationEnd");
            if (startDuratiorn != undefined && endDuratiorn != undefined &&  parseFloat(startDuratiorn) > parseFloat(endDuratiorn)){
                DynamicForm_CriteriaForm_JspTClassReport.clearFieldErrors("hDurationEnd", true);
                DynamicForm_CriteriaForm_JspTClassReport.clearFieldErrors("hDurationStart", true);
                DynamicForm_CriteriaForm_JspTClassReport.addFieldErrors("hDurationEnd", "حداکثر مدت کلاس باید بیشتر از حداقل مدت کلاس باشد", true);
                DynamicForm_CriteriaForm_JspTClassReport.addFieldErrors("hDurationStart", "حداکثر مدت کلاس باید بیشتر از حداقل مدت کلاس باشد", true);
                return;
            }
            else{
                DynamicForm_CriteriaForm_JspTClassReport.clearFieldErrors("hDurationEnd", true);
                DynamicForm_CriteriaForm_JspTClassReport.clearFieldErrors("hDurationStart", true);
            }
            if (!DynamicForm_CriteriaForm_JspTClassReport.validate() ||
                startDateCheck_Order_JspTClassReport == false ||
                startDate2Check_JspTClassReport == false ||
                startDate1Check_JspTClassReport == false ||
                endDateCheck_Order_JspTClassReport == false ||
                endDate2Check_JspTClassReport == false ||
                endDate1Check_JspTClassReport == false) {

                if (startDateCheck_Order_JspTClassReport == false) {
                    DynamicForm_CriteriaForm_JspTClassReport.clearFieldErrors("startDate2", true);
                    DynamicForm_CriteriaForm_JspTClassReport.addFieldErrors("startDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                }
                if (startDateCheck_Order_JspTClassReport == false) {
                    DynamicForm_CriteriaForm_JspTClassReport.clearFieldErrors("startDate1", true);
                    DynamicForm_CriteriaForm_JspTClassReport.addFieldErrors("startDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                }
                if (startDate2Check_JspTClassReport == false) {
                    DynamicForm_CriteriaForm_JspTClassReport.clearFieldErrors("startDate2", true);
                    DynamicForm_CriteriaForm_JspTClassReport.addFieldErrors("startDate2", "<spring:message
        code='msg.correct.date'/>", true);
                }
                if (startDate1Check_JspTClassReport == false) {
                    DynamicForm_CriteriaForm_JspTClassReport.clearFieldErrors("startDate1", true);
                    DynamicForm_CriteriaForm_JspTClassReport.addFieldErrors("startDate1", "<spring:message
        code='msg.correct.date'/>", true);
                }

                if (endDateCheck_Order_JspTClassReport == false) {
                    DynamicForm_CriteriaForm_JspTClassReport.clearFieldErrors("endDate2", true);
                    DynamicForm_CriteriaForm_JspTClassReport.addFieldErrors("endDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                }
                if (endDateCheck_Order_JspTClassReport == false) {
                    DynamicForm_CriteriaForm_JspTClassReport.clearFieldErrors("endDate1", true);
                    DynamicForm_CriteriaForm_JspTClassReport.addFieldErrors("endDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                }
                if (endDate2Check_JspTClassReport == false) {
                    DynamicForm_CriteriaForm_JspTClassReport.clearFieldErrors("endDate2", true);
                    DynamicForm_CriteriaForm_JspTClassReport.addFieldErrors("endDate2", "<spring:message code='msg.correct.date'/>", true);
                }
                if (endDate1Check_JspTClassReport == false) {
                    DynamicForm_CriteriaForm_JspTClassReport.clearFieldErrors("endDate1", true);
                    DynamicForm_CriteriaForm_JspTClassReport.addFieldErrors("endDate1", "<spring:message code='msg.correct.date'/>", true);
                }
                return;
            }
            Reporting();

            ListGrid_Result_JspTClassReport.invalidateCache();
            ListGrid_Result_JspTClassReport.fetchData(data_values);
            Window_Result_JspTClassReport.show();
        }
    });

    IButton_Print_JspTClassReport = isc.IButtonSave.create({
        top: 260,
        title: "چاپ گزارش",
        width: 300,
        icon: "<spring:url value="pdf.png"/>",
        click: function () {
            DynamicForm_CriteriaForm_JspTClassReport.validate();
            if (DynamicForm_CriteriaForm_JspTClassReport.hasErrors())
                return;
            var startDuratiorn = DynamicForm_CriteriaForm_JspTClassReport.getValue("hDurationStart");
            var endDuratiorn = DynamicForm_CriteriaForm_JspTClassReport.getValue("hDurationEnd");
            if (startDuratiorn != undefined && endDuratiorn != undefined &&  parseFloat(startDuratiorn) > parseFloat(endDuratiorn)){
                DynamicForm_CriteriaForm_JspTClassReport.clearFieldErrors("hDurationEnd", true);
                DynamicForm_CriteriaForm_JspTClassReport.clearFieldErrors("hDurationStart", true);
                DynamicForm_CriteriaForm_JspTClassReport.addFieldErrors("hDurationEnd", "حداکثر مدت کلاس باید بیشتر از حداقل مدت کلاس باشد", true);
                DynamicForm_CriteriaForm_JspTClassReport.addFieldErrors("hDurationStart", "حداکثر مدت کلاس باید بیشتر از حداقل مدت کلاس باشد", true);
                return;
            }
            if (!DynamicForm_CriteriaForm_JspTClassReport.validate() ||
                startDateCheck_Order_JspTClassReport == false ||
                startDate2Check_JspTClassReport == false ||
                startDate1Check_JspTClassReport == false ||
                endDateCheck_Order_JspTClassReport == false ||
                endDate2Check_JspTClassReport == false ||
                endDate1Check_JspTClassReport == false) {

                if (startDateCheck_Order_JspTClassReport == false) {
                    DynamicForm_CriteriaForm_JspTClassReport.clearFieldErrors("startDate2", true);
                    DynamicForm_CriteriaForm_JspTClassReport.addFieldErrors("startDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                }
                if (startDateCheck_Order_JspTClassReport == false) {
                    DynamicForm_CriteriaForm_JspTClassReport.clearFieldErrors("startDate1", true);
                    DynamicForm_CriteriaForm_JspTClassReport.addFieldErrors("startDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                }
                if (startDate2Check_JspTClassReport == false) {
                    DynamicForm_CriteriaForm_JspTClassReport.clearFieldErrors("startDate2", true);
                    DynamicForm_CriteriaForm_JspTClassReport.addFieldErrors("startDate2", "<spring:message
        code='msg.correct.date'/>", true);
                }
                if (startDate1Check_JspTClassReport == false) {
                    DynamicForm_CriteriaForm_JspTClassReport.clearFieldErrors("startDate1", true);
                    DynamicForm_CriteriaForm_JspTClassReport.addFieldErrors("startDate1", "<spring:message
        code='msg.correct.date'/>", true);
                }

                if (endDateCheck_Order_JspTClassReport == false) {
                    DynamicForm_CriteriaForm_JspTClassReport.clearFieldErrors("endDate2", true);
                    DynamicForm_CriteriaForm_JspTClassReport.addFieldErrors("endDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                }
                if (endDateCheck_Order_JspTClassReport == false) {
                    DynamicForm_CriteriaForm_JspTClassReport.clearFieldErrors("endDate1", true);
                    DynamicForm_CriteriaForm_JspTClassReport.addFieldErrors("endDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                }
                if (endDate2Check_JspTClassReport == false) {
                    DynamicForm_CriteriaForm_JspTClassReport.clearFieldErrors("endDate2", true);
                    DynamicForm_CriteriaForm_JspTClassReport.addFieldErrors("endDate2", "<spring:message code='msg.correct.date'/>", true);
                }
                if (endDate1Check_JspTClassReport == false) {
                    DynamicForm_CriteriaForm_JspTClassReport.clearFieldErrors("endDate1", true);
                    DynamicForm_CriteriaForm_JspTClassReport.addFieldErrors("endDate1", "<spring:message code='msg.correct.date'/>", true);
                }
                return;
            }
            Reporting();

            var dataParams = new Object();
            dataParams.courseInfo = courseInfo_print;
            dataParams.classTimeInfo = classTimeInfo_print;
            dataParams.executionInfo = executionInfo_print;
            dataParams.evaluationInfo = evaluationInfo_print;

            trPrintWithCriteria("<spring:url value="/tclass/reportPrint/"/>" + "pdf", data_values,JSON.stringify(dataParams));
        }
    });
    //----------------------------------- functions --------------------------------------------------------------------
    function Reporting(){
        data_values = null;
        data_values = DynamicForm_CriteriaForm_JspTClassReport.getValuesAsAdvancedCriteria();
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
                data_values.criteria[i].operator = DynamicForm_CriteriaForm_JspTClassReport.getField("courseFilterOperator").getValue();
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

        titr.contents = "";
        courseInfo.contents = "";
        classTimeInfo.contents = "";
        executionInfo.contents = "";
        reactionEvaluationInfo.contents = "";
        learningEvaluationInfo.contents = "";
        behavioralEvaluationInfo.contents = "";
        evaluationInfo.contents = "";

        courseInfo_print = "";
        classTimeInfo_print = "";
        executionInfo_print = "";
        evaluationInfo_print = "";

        if (DynamicForm_CriteriaForm_JspTClassReport.getField("course.code").getValue() != undefined) {
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "کد دوره: " + "</span>";
            courseInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("course.code").getDisplayValue() + "</span>";
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            courseInfo_print +=  "کد دوره: " ;
            courseInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("course.code").getDisplayValue();
            courseInfo_print +=  ", " ;
        }
        if (DynamicForm_CriteriaForm_JspTClassReport.getField("course.titleFa").getValue() != undefined) {
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "نام دوره: " + "</span>";
            courseInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("course.titleFa").getDisplayValue() + "</span>";
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            courseInfo_print +=  "نام دوره: " ;
            courseInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("course.titleFa").getValue();
            courseInfo_print +=  ", " ;
        }
        if (DynamicForm_CriteriaForm_JspTClassReport.getField("course.categoryId").getValue() != undefined) {
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "گروه های کاری: " + "</span>";
            courseInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("course.categoryId").getDisplayValue() + "</span>";
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            courseInfo_print  += "گروه های کاری: " ;
            courseInfo_print  += DynamicForm_CriteriaForm_JspTClassReport.getField("course.categoryId").getDisplayValue() ;
            courseInfo_print  +=   ", " ;
        }
        if (DynamicForm_CriteriaForm_JspTClassReport.getField("course.subCategoryId").getValue() != undefined) {
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "زیرگروه های کاری: " + "</span>";
            courseInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("course.subCategoryId").getDisplayValue() + "</span>";
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            courseInfo_print +=   "زیرگروه های کاری: " ;
            courseInfo_print  += DynamicForm_CriteriaForm_JspTClassReport.getField("course.subCategoryId").getDisplayValue() ;
            courseInfo_print  += ", " ;
        }
        if (DynamicForm_CriteriaForm_JspTClassReport.getField("courseStatus").getValue() != undefined) {
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "نوع دوره: " + "</span>";
            courseInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("courseStatus").getDisplayValue() + "</span>";
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            courseInfo_print += "نوع دوره: ";
            courseInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("courseStatus").getDisplayValue() ;
            courseInfo_print +=  ", " ;
        }
        if (DynamicForm_CriteriaForm_JspTClassReport.getField("classStatus").getValue() != undefined) {
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "وضعیت کلاس: " + "</span>";
            courseInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("classStatus").getDisplayValue() + "</span>";
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            courseInfo_print +=  "وضعیت کلاس: " ;
            courseInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("classStatus").getDisplayValue();
            courseInfo_print += ", ";
        }

        if (DynamicForm_CriteriaForm_JspTClassReport.getField("hDurationStart").getValue() != undefined) {
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "مدت کلاس: از " + "</span>";
            classTimeInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("hDurationStart").getDisplayValue() + "</span>";
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "ساعت، " + "</span>";

            classTimeInfo_print +=  "مدت کلاس: از ";
            classTimeInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("hDurationStart").getDisplayValue();
            classTimeInfo_print += "ساعت، " ;
        }
        if (DynamicForm_CriteriaForm_JspTClassReport.getField("hDurationEnd").getValue() != undefined) {
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "مدت کلاس: تا " + "</span>";
            classTimeInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("hDurationEnd").getDisplayValue() + "</span>";
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "ساعت، " + "</span>";

            classTimeInfo_print += "مدت کلاس: تا " ;
            classTimeInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("hDurationEnd").getDisplayValue();
            classTimeInfo_print +=  "ساعت، " ;
        }
        if (DynamicForm_CriteriaForm_JspTClassReport.getField("startDate1").getValue() != undefined) {
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "تاریخ شروع کلاس: از " + "</span>";
            classTimeInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("startDate1").getDisplayValue() + "</span>";
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            classTimeInfo_print += "تاریخ شروع کلاس: از " ;
            classTimeInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("startDate1").getDisplayValue();
            classTimeInfo_print +=  ", " ;
        }
        if (DynamicForm_CriteriaForm_JspTClassReport.getField("startDate2").getValue() != undefined) {
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "تاریخ شروع کلاس: تا " + "</span>";
            classTimeInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("startDate2").getDisplayValue() + "</span>";
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            classTimeInfo_print +=   "تاریخ شروع کلاس: تا ";
            classTimeInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("startDate2");
            classTimeInfo_print +=  ", " ;
        }
        if (DynamicForm_CriteriaForm_JspTClassReport.getField("endDate1").getValue() != undefined) {
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "تاریخ پایان کلاس: از " + "</span>";
            classTimeInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("endDate1").getDisplayValue() + "</span>";
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            classTimeInfo_print +=  "تاریخ پایان کلاس: از " ;
            classTimeInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("endDate1") ;
            classTimeInfo_print +=  ", " ;
        }
        if (DynamicForm_CriteriaForm_JspTClassReport.getField("endDate2").getValue() != undefined) {
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "تاریخ پایان کلاس: تا " + "</span>";
            classTimeInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("endDate2").getDisplayValue() + "</span>";
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            classTimeInfo_print += "تاریخ پایان کلاس: تا " ;
            classTimeInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("endDate2").getDisplayValue();
            classTimeInfo_print += ", " ;
        }
        if (DynamicForm_CriteriaForm_JspTClassReport.getField("workYear").getValue() != undefined) {
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "سال کاری: " + "</span>";
            classTimeInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("workYear").getDisplayValue() + "</span>";
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            classTimeInfo_print +=  "سال کاری: " ;
            classTimeInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("workYear").getValue();
            classTimeInfo_print += ", ";
        }
        if (DynamicForm_CriteriaForm_JspTClassReport.getField("termId").getValue() != undefined) {
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "ترم کاری: " + "</span>";
            classTimeInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("termId").getDisplayValue() + "</span>";
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            classTimeInfo_print  +=  "ترم کاری: " ;
            classTimeInfo_print  += DynamicForm_CriteriaForm_JspTClassReport.getField("termId").getDisplayValue();
            classTimeInfo_print  +=  ", " ;
        }

        if (DynamicForm_CriteriaForm_JspTClassReport.getField("teacherId").getValue() != undefined) {
            executionInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "مدرس: " + "</span>";
            executionInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("teacherId").getDisplayValue() + "</span>";
            executionInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            executionInfo_print +="مدرس: " ;
            executionInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("teacherId").getDisplayValue();
            executionInfo_print += ", " ;
        }
        if (DynamicForm_CriteriaForm_JspTClassReport.getField("teacherPayingStatus").getValue() != undefined) {
            executionInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "وضعیت هزینه ی مدرس: " + "</span>";
            executionInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("teacherPayingStatus").getDisplayValue() + "</span>";
            executionInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            executionInfo_print  +=  "وضعیت هزینه ی مدرس: ";
            executionInfo_print  += DynamicForm_CriteriaForm_JspTClassReport.getField("teacherPayingStatus").getDisplayValue();
            executionInfo_print  += ", ";
        }
        if (DynamicForm_CriteriaForm_JspTClassReport.getField("organizerId").getValue() != undefined) {
            executionInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "برگزار کننده: " + "</span>";
            executionInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("organizerId").getDisplayValue() + "</span>";
            executionInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            executionInfo_print +=  "برگزار کننده: " ;
            executionInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("organizerId").getDisplayValue() ;
            executionInfo_print +=  ", " ;
        }

        if (DynamicForm_CriteriaForm_JspTClassReport.getField("reactionEvaluationOperator").getValue() != undefined &&
            DynamicForm_CriteriaForm_JspTClassReport.getField("reactionEvaluationGrade").getValue() != undefined) {
            reactionEvaluationInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "نمره ارزیابی واکنشی کلاس: " + "</span>";
            reactionEvaluationInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("reactionEvaluationOperator").getDisplayValue() + "</span>";
            reactionEvaluationInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("reactionEvaluationGrade").getValue() + "</span>";

            evaluationInfo_print += "نمره ارزیابی واکنشی کلاس: " ;
            evaluationInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("reactionEvaluationOperator").getDisplayValue();
            evaluationInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("reactionEvaluationGrade").getDisplayValue();
            evaluationInfo_print +=  ", " ;
        }

        if (DynamicForm_CriteriaForm_JspTClassReport.getField("learningEvaluationOperator").getValue() != undefined &&
            DynamicForm_CriteriaForm_JspTClassReport.getField("learningEvaluationGrade").getValue() != undefined) {
            learningEvaluationInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "نمره ارزیابی یادگیری کلاس: " + "</span>";
            learningEvaluationInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("learningEvaluationOperator").getDisplayValue() + "</span>";
            learningEvaluationInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("learningEvaluationGrade").getDisplayValue() + "</span>";

            evaluationInfo_print += "نمره ارزیابی یادگیری کلاس: " ;
            evaluationInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("learningEvaluationOperator").getDisplayValue();
            evaluationInfo_print +=  DynamicForm_CriteriaForm_JspTClassReport.getField("learningEvaluationGrade").getValue();
            evaluationInfo_print +=  ", " ;
        }

        if (DynamicForm_CriteriaForm_JspTClassReport.getField("behavioralEvaluationOperator").getValue() != undefined &&
            DynamicForm_CriteriaForm_JspTClassReport.getField("behavioralEvaluationGrade").getValue() != undefined) {
            behavioralEvaluationInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "نمره ارزیابی رفتاری کلاس: " + "</span>";
            behavioralEvaluationInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("behavioralEvaluationOperator").getDisplayValue() + "</span>";
            behavioralEvaluationInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("behavioralEvaluationGrade").getDisplayValue() + "</span>";

            evaluationInfo_print += "نمره ارزیابی رفتاری کلاس: " ;
            evaluationInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("behavioralEvaluationOperator").getDisplayValue();
            evaluationInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("behavioralEvaluationGrade").getDisplayValue();
            evaluationInfo_print +=  ", " ;
        }

        if (DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationOperator").getValue() != undefined &&
            DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationGrade").getValue() != undefined) {
            evaluationInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "نمره اثربخشی کلاس: " + "</span>";
            evaluationInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationOperator").getDisplayValue() + "</span>";
            evaluationInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationGrade").getDisplayValue() + "</span>";

            evaluationInfo_print += "نمره اثربخشی کلاس: " ;
            evaluationInfo_print  += DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationOperator").getDisplayValue() ;
            evaluationInfo_print  +=  DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationGrade").getDisplayValue();
            evaluationInfo_print +=  ", " ;
        }

        titr.contents = "<span style='color:#050505; font-size:13px;'>" + "گزارش کلاس های آموزشی با توجه به محدودیت های اعمال شده:" + "</span>";

        titr.redraw();
        courseInfo.redraw();
        classTimeInfo.redraw();
        executionInfo.redraw();
        reactionEvaluationInfo.redraw();
        learningEvaluationInfo.redraw();
        behavioralEvaluationInfo.redraw();
        evaluationInfo.redraw();
    }

    let Window_CriteriaForm_JspTClassReport = isc.Window.create({
        placement: "fillScreen",
        title: "",
        showCloseButton: false,
        showMaximizeButton: false,
        canDragReposition: false,
        showMinimizeButton: false,
        canDragResize: false,
        closeClick: false,
        minimize: false,
        items: [DynamicForm_CriteriaForm_JspTClassReport]
    });

    //----------------------------------- layOut -----------------------------------------------------------------------
    var HLayOut_CriteriaForm_JspTClassReport = isc.TrHLayoutButtons.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "100%",
        alignLayout: "center",
        members: [
            Window_CriteriaForm_JspTClassReport
        ]
    });
    var HLayOut_Confirm_JspTClassReport = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Confirm_JspTClassReport,
            IButton_Print_JspTClassReport
        ]
    });


    var VLayout_Body_JspTClassReport = isc.TrVLayout.create({
        members: [
            HLayOut_CriteriaForm_JspTClassReport,
            HLayOut_Confirm_JspTClassReport
        ]
    });
    //----------------------------------------------------End-----------------------------------------------------------
    Window_Result_JspTClassReport.hide();