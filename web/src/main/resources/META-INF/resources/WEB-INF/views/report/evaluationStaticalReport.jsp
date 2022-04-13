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
    let waiting;

    var data_values = null;

    let societies = [];

    var classCount_reaction = 0;
    var classCount_learning = 0;
    var classCount_behavioral = 0;
    var classCount_results = 0;
    var classCount_teacher = 0;
    var classCount_effectiveness = 0;

    var passed_reaction = 0;
    var passed_learning = 0;
    var passed_behavioral = 0;
    var passed_results = 0;
    var passed_teacher = 0;
    var passed_effectiveness = 0;

    var failed_reaction = 0;
    var failed_learning = 0;
    var failed_behavioral = 0;
    var failed_results = 0;
    var failed_teacher = 0;
    var failed_effectiveness = 0;

    var RestDataSource_StaticalResult_JspEvaluationStaticalReport = [
        {
            index: 1,
            evaluationType:"واکنشی",
            classCount: classCount_reaction,
            passedCount: passed_reaction,
            failedCount:failed_reaction
        },
        {
            index: 2,
            evaluationType:"یادگیری",
            classCount: classCount_learning,
            passedCount: passed_learning,
            failedCount:failed_learning
        },
        {
            index: 3,
            evaluationType:"رفتاری",
            classCount: classCount_behavioral,
            passedCount: passed_behavioral,
            failedCount:failed_behavioral
        },
        {
            index: 4,
            evaluationType:"نتایج",
            classCount: classCount_results,
            passedCount: passed_results,
            failedCount:failed_results
        },
        {
            index: 5,
            evaluationType:"مدرس",
            classCount: classCount_teacher,
            passedCount: passed_teacher,
            failedCount:failed_teacher
        },
        {
            index: 6,
            evaluationType:"اثربخشی",
            classCount: classCount_effectiveness,
            passedCount: passed_effectiveness,
            failedCount:failed_effectiveness
        }

    ];

    $(document).ready(()=>{
        setTimeout(()=>{
            $("input[name='courseCode']").attr("disabled","disabled");
            $("input[name='tclassCode']").attr("disabled","disabled");
        },0)}
    );

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    var RestDataSource_ListResult_JspEvaluationStaticalReport = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "tclassCode"},
            {name: "courseCode"},
            {name: "courseTitleFa"},
            {name: "tclassStudentsCount"},
            {name: "evaluationReactionStatus"},
            {name: "evaluationReactionGrade"},
            {name: "evaluationReactionPass"},
            {name: "evaluationLearningStatus"},
            {name: "evaluationLearningGrade"},
            {name: "evaluationLearningPass"},
            {name: "evaluationBehavioralStatus"},
            {name: "evaluationBehavioralPass"},
            {name: "evaluationResultsStatus"},
            {name: "evaluationResultsPass"},
            {name: "evaluationEffectivenessStatus"},
            {name: "evaluationEffectivenessPass"},
            {name: "evaluationTeacherStatus"},
            {name: "evaluationTeacherPass"}
        ],
        fetchDataURL: viewEvaluationStaticalReportUrl + "/iscList"
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

    var RestDataSource_TargetSociety_JspEvaluationStaticalReport =  isc.DataSource.create({
        clientOnly: true,
        testData: societies,
        fields: [
            {name: "societyId", primaryKey: true},
            {name: "title", type: "text"}
        ]
    });

    var RestDataSource_Institute_JspEvaluationStaticalReport = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", title: "نام موسسه"},
            {name: "manager.firstNameFa", title: "نام مدیر"},
            {name: "manager.lastNameFa", title: "نام خانوادگی مدیر"},
            {name: "mobile", title: "موبایل"},
            {name: "restAddress", title: "آدرس"},
            {name: "phone", title: "تلفن"}
        ],
        fetchDataURL: instituteUrl + "spec-list",
        allowAdvancedCriteria: true
    });
    //----------------------------------------------------ListGrid Result-----------------------------------------------
    var ListGrid_ListResult_JspEvaluationStaticalReport = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_ListResult_JspEvaluationStaticalReport,
        fields: [
            {name: "id", title: "id", canEdit: false, hidden: true},
            {name: "tclassCode", title: "کد کلاس"},
            {name: "courseCode", title: "کد دوره"},
            {name: "courseTitleFa", title: "نام دوره"},
            {name: "tclassStudentsCount", title: "تعداد فراگیران" , filterOperator: "equals"},
            {name: "evaluationReactionStatus",title: "ارزیابی واکنشی",valueMap: {true: "انجام شده", false: "انجام نشده"},
                filterEditorProperties:{
                    pickListProperties: {
                        showFilterEditor: false
                    }
                },filterOperator: "equals"},
            {name: "evaluationReactionGrade", title: "نمره ارزیابی واکنشی"},
            {name: "evaluationReactionPass", title: "وضعیت ارزیابی واکنشی",valueMap: {true: "تائید شده", false: "تائید نشده"},
                filterEditorProperties:{
                    pickListProperties: {
                        showFilterEditor: false
                    }
                },filterOperator: "equals"},
            {name: "evaluationLearningStatus", title:  "ارزیابی یادگیری" ,valueMap: {true: "انجام شده", false: "انجام نشده"},
                filterEditorProperties:{
                    pickListProperties: {
                        showFilterEditor: false
                    }
                },filterOperator: "equals"},
            {name: "evaluationLearningGrade", title: "نمره ارزیابی یادگیری"},
            {name: "evaluationLearningPass", title: "وضعیت ارزیابی یادگیری" ,valueMap: {true: "تائید شده", false: "تائید نشده"},
                filterEditorProperties:{
                    pickListProperties: {
                        showFilterEditor: false
                    }
                },filterOperator: "equals"},
            {name: "evaluationBehavioralStatus", title: "ارزیابی رفتاری" ,valueMap: {true: "انجام شده", false: "انجام نشده"},
                filterEditorProperties:{
                    pickListProperties: {
                        showFilterEditor: false
                    }
                },filterOperator: "equals"},
            {name: "evaluationBehavioralPass", title:"وضعیت ارزیابی رفتاری" ,valueMap: {true: "تائید شده", false: "تائید نشده"},
                filterEditorProperties:{
                    pickListProperties: {
                        showFilterEditor: false
                    }
                },filterOperator: "equals"},
            {name: "evaluationEffectivenessStatus", title: "اثربخشی" ,valueMap: {true: "انجام شده", false: "انجام نشده"},
                filterEditorProperties:{
                    pickListProperties: {
                        showFilterEditor: false
                    }
                },filterOperator: "equals"},
            {name: "evaluationEffectivenessPass", title: "وضعیت اثربخشی" ,valueMap: {true: "تائید شده", false: "تائید نشده"},
                filterEditorProperties:{
                    pickListProperties: {
                        showFilterEditor: false
                    }
                },filterOperator: "equals"},
            {name: "evaluationTeacherStatus",title: "ارزیابی مدرس" ,valueMap: {true: "انجام شده", false: "انجام نشده"},
                filterEditorProperties:{
                    pickListProperties: {
                        showFilterEditor: false
                    }
                },filterOperator: "equals"},
            {name: "evaluationTeacherPass",title: "وضعیت ارزیابی مدرس",valueMap: {true: "تائید شده", false: "تائید نشده"},
                filterEditorProperties:{
                    pickListProperties: {
                        showFilterEditor: false
                    }
                },filterOperator: "equals"},
            {name: "evaluationResultsStatus", title:"ارزیابی نتایج",valueMap: {true: "انجام شده", false: "انجام نشده"},
                filterEditorProperties:{
                    pickListProperties: {
                        showFilterEditor: false
                    }
                },filterOperator: "equals" },
            {name: "evaluationResultsPass", title: "وضعیت ارزیابی نتایج" ,valueMap: {true: "تائید شده", false: "تائید نشده"},
                filterEditorProperties:{
                    pickListProperties: {
                        showFilterEditor: false
                    }
                },filterOperator: "equals"}
        ],
        cellHeight: 43,
        sortField: 1,
        filterOperator: "iContains",
        filterOnKeypress: true,
        autoFetchData: false,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        selectionType: "single",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
    });

    var Window_ListResult_JspEvaluationStaticalReport = isc.Window.create({
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
                    ListGrid_ListResult_JspEvaluationStaticalReport
                ]
            })
        ]
    });

    var ListGrid_StaticalResult_JspEvaluationStaticalReport = isc.TrLG.create({
        width: "100%",
        height: "100%",
        data: RestDataSource_StaticalResult_JspEvaluationStaticalReport,
        fields: [
            {name: "index",hidden:true},
            {name: "evaluationType", title: "نوع ارزیابی"},
            {name: "classCount", title: "تعداد کلاس"},
            {name: "passedCount", title: "تعداد تائید شده"},
            {name: "failedCount", title: "تعداد تائید نشده"}
        ],
        cellHeight: 43,
        sortField: 0,
        showFilterEditor: false,
        selectionType: "single"
    });

    var Window_StaticalResult_JspEvaluationStaticalReport = isc.Window.create({
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
                    ListGrid_StaticalResult_JspEvaluationStaticalReport
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
                name: "tclassCode",
                title: "کد کلاس",
                hint: "کد کلاس را انتخاب نمائيد",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                       // DynamicForm_SelectClasses_JspEvaluationStaticalReport.clearValues();
                        Window_SelectClasses_JspEvaluationStaticalReport.show();
                    }
                }],
                keyPressFilter: "[A-Z|0-9|;-]"
            },
            // {
            //     name: "unitId",
            //     title: "واحد",
            //     type: "SelectItem",
            //     pickListProperties: {
            //         showFilterEditor: false
            //     },
            //     textAlign: "center",
            //     wrapTitle: false,
            //     filterOperator: "equals",
            //     optionDataSource: RestDataSource_TargetSociety_JspEvaluationStaticalReport,
            //     displayField: "title",
            //     valueField: "societyId"
            // },
            {
                name: "instituteId",
                title: "برگزارکننده",
                editorType: "TrComboAutoRefresh",
                optionDataSource: RestDataSource_Institute_JspEvaluationStaticalReport,
                displayField: "titleFa",
                filterOperator: "equals",
                valueField: "id",
                textAlign: "center",
                filterFields: ["titleFa", "titleFa"],
                showHintInField: true,
                hint: "موسسه",
                pickListWidth: 500,
                textMatchStyle: "substring",
                pickListFields: [
                    {name: "titleFa", filterOperator: "iContains"},
                    {name: "manager.firstNameFa", filterOperator: "iContains"},
                    {name: "manager.lastNameFa", filterOperator: "iContains"}
                ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                }
            },
            {
                name: "temp0",
                title: "",
                canEdit: false
            },
            {
                name: "teacherId",
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
                name: "tclassYear",
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
                        DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("termId").optionDataSource = RestDataSource_Term_JspEvaluationStaticalReport;
                        DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("termId").fetchData();
                        DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("termId").enable();
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
                                        var item = DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("termId"),
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
                                        var item = DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("termId");
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
                name: "courseCode",
                title: "کد دوره",
                hint: "کد دوره را انتخاب نمائيد",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                        Window_SelectCourses_JspEvaluationStaticalReport.show();
                    }
                }],
                keyPressFilter: "[A-Z|0-9|;-]"
            },
            {
                name: "courseCategory",
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
                    var subCategoryField = DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("courseSubCategory");
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
                name: "courseSubCategory",
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
                        var ids = DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("courseCategory").getValue();
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
                name: "classEvaluation",
                title: "نوع ارزیابی",
                type: "SelectItem",
                required: true,
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
            if (DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("courseCode").getValue() != undefined
                && DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("courseCode").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectCourses_JspEvaluationStaticalReport.getField("course.code").getValue().join(",");
                var ALength = criteriaDisplayValues.length;
                var lastChar = criteriaDisplayValues.charAt(ALength - 1);
                if (lastChar != ",")
                    criteriaDisplayValues += ",";
            }
            if (selectorDisplayValues != undefined) {
                for (var i = 0; i < selectorDisplayValues.size() - 1; i++) {
                    criteriaDisplayValues += selectorDisplayValues [i] + ",";
                }
                criteriaDisplayValues += selectorDisplayValues [selectorDisplayValues.size() - 1];
            }

            if (typeof criteriaDisplayValues != "undefined") {
                let uniqueNames = [];

                $.each(criteriaDisplayValues.split(","), function (i, el) {
                    if ($.inArray(el, uniqueNames) === -1) uniqueNames.push(el);
                });
                criteriaDisplayValues = uniqueNames.join(",");
            }

            criteriaDisplayValues = criteriaDisplayValues == ",undefined" ? "" : criteriaDisplayValues;
// console.log(criteriaDisplayValues);
            DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("courseCode").setValue(criteriaDisplayValues);
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
            if (DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("tclassCode").getValue() != undefined
                && DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("tclassCode").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectClasses_JspEvaluationStaticalReport.getItem("class.code").getValue().join(",");
                var ALength = criteriaDisplayValues.length;
                var lastChar = criteriaDisplayValues.charAt(ALength - 1);
                if (lastChar != ",")
                    criteriaDisplayValues += ",";
            }
            if (selectorDisplayValues != undefined) {
                for (var i = 0; i < selectorDisplayValues.size() - 1; i++) {
                    criteriaDisplayValues += selectorDisplayValues [i] + ",";
                }
                criteriaDisplayValues += selectorDisplayValues [selectorDisplayValues.size() - 1];
            }

            if (typeof criteriaDisplayValues != "undefined") {
                let uniqueNames = [];

                $.each(criteriaDisplayValues.split(","), function (i, el) {
                    if ($.inArray(el, uniqueNames) === -1) uniqueNames.push(el);
                });
                criteriaDisplayValues = uniqueNames.join(",");
            }

            criteriaDisplayValues = criteriaDisplayValues == ",undefined" ? "" : criteriaDisplayValues;

            DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getField("tclassCode").setValue(criteriaDisplayValues);
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
            waiting = createDialog("wait");
            data_values = DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getValues();
            isc.RPCManager.sendRequest(TrDSRequest(viewEvaluationStaticalReportUrl + "/staticalResult" ,"POST", JSON.stringify(data_values), "callback: fill_statical_result(rpcResponse)"));
        }
    });

    function fill_statical_result(resp) {
        if (resp.httpResponseCode === 200) {
            classCount_reaction = JSON.parse(resp.httpResponseText).classCount_reaction;
            classCount_learning = JSON.parse(resp.httpResponseText).classCount_learning;
            classCount_behavioral = JSON.parse(resp.httpResponseText).classCount_behavioral;
            classCount_results = JSON.parse(resp.httpResponseText).classCount_results;
            classCount_teacher = JSON.parse(resp.httpResponseText).classCount_teacher;
            classCount_effectiveness = JSON.parse(resp.httpResponseText).classCount_effectiveness;

            passed_reaction = JSON.parse(resp.httpResponseText).passed_reaction;
            passed_learning = JSON.parse(resp.httpResponseText).passed_learning;
            passed_behavioral = JSON.parse(resp.httpResponseText).passed_behavioral;
            passed_results = JSON.parse(resp.httpResponseText).passed_results;
            passed_teacher = JSON.parse(resp.httpResponseText).passed_teacher;
            passed_effectiveness = JSON.parse(resp.httpResponseText).passed_effectiveness;

            failed_reaction = JSON.parse(resp.httpResponseText).failed_reaction;
            failed_learning = JSON.parse(resp.httpResponseText).failed_learning;
            failed_behavioral = JSON.parse(resp.httpResponseText).failed_behavioral;
            failed_results = JSON.parse(resp.httpResponseText).failed_results;
            failed_teacher = JSON.parse(resp.httpResponseText).failed_teacher;
            failed_effectiveness = JSON.parse(resp.httpResponseText).failed_effectiveness;

            var RestDataSource_StaticalResult_JspEvaluationStaticalReport = [
                {
                    index: 1,
                    evaluationType:"واکنشی",
                    classCount: classCount_reaction,
                    passedCount: passed_reaction,
                    failedCount:failed_reaction
                },
                {
                    index: 2,
                    evaluationType:"یادگیری",
                    classCount: classCount_learning,
                    passedCount: passed_learning,
                    failedCount:failed_learning
                },
                {
                    index: 3,
                    evaluationType:"رفتاری",
                    classCount: classCount_behavioral,
                    passedCount: passed_behavioral,
                    failedCount:failed_behavioral
                },
                {
                    index: 4,
                    evaluationType:"نتایج",
                    classCount: classCount_results,
                    passedCount: passed_results,
                    failedCount:failed_results
                },
                {
                    index: 5,
                    evaluationType:"مدرس",
                    classCount: classCount_teacher,
                    passedCount: passed_teacher,
                    failedCount:failed_teacher
                },
                {
                    index: 6,
                    evaluationType:"اثربخشی",
                    classCount: classCount_effectiveness,
                    passedCount: passed_effectiveness,
                    failedCount:failed_effectiveness
                }

            ];

            ListGrid_StaticalResult_JspEvaluationStaticalReport.data = RestDataSource_StaticalResult_JspEvaluationStaticalReport;
            ListGrid_StaticalResult_JspEvaluationStaticalReport.invalidateCache();
            ListGrid_StaticalResult_JspEvaluationStaticalReport.fetchData();
            Window_StaticalResult_JspEvaluationStaticalReport.show();
            waiting.close();
        }
    }


    IButton_ListReport_JspEvaluationStaticalReport = isc.IButtonSave.create({
        top: 260,
        title: "گزارش لیستی",
        width: 300,
        click: function () {
            DynamicForm_CriteriaForm_JspEvaluationStaticalReport.validate();
            if (DynamicForm_CriteriaForm_JspEvaluationStaticalReport.hasErrors())
                return;
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

            ListGrid_ListResult_JspEvaluationStaticalReport.invalidateCache();
            ListGrid_ListResult_JspEvaluationStaticalReport.fetchData(data_values);
            Window_ListResult_JspEvaluationStaticalReport.show();
        }});


    //----------------------------------- functions --------------------------------------------------------------------
    function Reporting(){
        data_values = null;
        data_values = DynamicForm_CriteriaForm_JspEvaluationStaticalReport.getValuesAsAdvancedCriteria();
        for (var i = 0; i < data_values.criteria.size(); i++) {
            if (data_values.criteria[i].fieldName == "courseCode") {
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
            else if (data_values.criteria[i].fieldName == "tclassCode") {
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
            else if (data_values.criteria[i].fieldName == "startDate1") {
                data_values.criteria[i].fieldName = "tclassStartDate";
                data_values.criteria[i].operator = "greaterOrEqual";
            }
            else if (data_values.criteria[i].fieldName == "startDate2") {
                data_values.criteria[i].fieldName = "tclassStartDate";
                data_values.criteria[i].operator = "lessOrEqual";
            }
            else if (data_values.criteria[i].fieldName == "endDate1") {
                data_values.criteria[i].fieldName = "tclassEndDate";
                data_values.criteria[i].operator = "greaterOrEqual";
            }
            else if (data_values.criteria[i].fieldName == "endDate2") {
                data_values.criteria[i].fieldName = "tclassEndDate";
                data_values.criteria[i].operator = "lessOrEqual";
            }
            else if (data_values.criteria[i].fieldName == "workYear") {
                data_values.criteria[i].fieldName = "tclassYear";
                data_values.criteria[i].operator = "inSet";
            }
            else if(data_values.criteria[i].fieldName == "courseCategory"){
                data_values.criteria[i].operator = "inSet";
            }
            else if(data_values.criteria[i].fieldName == "courseSubCategory"){
                data_values.criteria[i].operator = "inSet";
            }
            else if(data_values.criteria[i].fieldName == "classEvaluation"){
                data_values.criteria[i].operator = "inSet";
            }
            else
                data_values.criteria[i].operator = "equals";
        }
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
    Window_ListResult_JspEvaluationStaticalReport.hide();
    Window_StaticalResult_JspEvaluationStaticalReport.hide();

    // </script>