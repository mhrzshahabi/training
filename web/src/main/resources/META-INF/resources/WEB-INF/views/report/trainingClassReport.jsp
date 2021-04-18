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

    $(document).ready(()=>{
        setTimeout(()=>{
            $("input[name='courseCode']").attr("disabled","disabled");
        },0)}
    );

    var data_values = null;
    let societies = [];

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
    var RestDataSource_RestDataSource_ListResult = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "courseCode"},
            {name: "courseTitleFa"},
            {name: "tclassDuration"},
            {name: "tclassStartDate"},
            {name: "tclassEndDate"},
            {name: "tclassYear"},
            {name: "termTitleFa"},
            {name: "teacherFullName"},
            {name: "tclassReason"},
            {name: "classEvaluation"},
            {name: "tclassStatus"},
            {name: "tclassTeachingType"},
            {name: "classCancelReasonId"},
            {name: "classCancelReasonTitle"},
            {name: "plannerComplex"},
            {name: "plannerName"},
            {name: "instituteName"},
            {name: "tclassPlanner"},
            {name: "tclassSupervisor"},
            {name: "tclassCode"},
            {name: "tclassStudentsCount"}
        ],
        fetchDataURL: viewEvaluationStaticalReportUrl + "/iscList"
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
            {name: "personality.firstNameFa", filterOperator: "iContains"},
            {name: "personality.lastNameFa", filterOperator: "iContains"},
            {name: "personality.nationalCode", filterOperator: "iContains"},
            {name: "fullNameFa"}
        ],
        fetchDataURL: teacherUrl + "fullName"
    });

    var RestDataSource_Institute_JspTClassReport = isc.TrDS.create({
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

    var RestDataSource_SupervisorDS_JspTClassReport = isc.TrDS.create({
        fields: [
            {name: "id", filterOperator: "equals", primaryKey: true, hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains"},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
        ],
        fetchDataURL: viewActivePersonnelUrl + "/iscList"
    });

    var RestDataSource_PlannerDS_JspTClassReport = isc.TrDS.create({
        fields: [
            {name: "id", filterOperator: "equals", primaryKey: true, hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains"},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
        ],
        fetchDataURL: viewActivePersonnelUrl + "/iscList"
    });

    var RestDataSource_TargetSociety_JspTClassReport =  isc.DataSource.create({
        clientOnly: true,
        testData: societies,
        fields: [
            {name: "societyId", primaryKey: true},
            {name: "title", type: "text"}
        ]
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
            title: "<spring:message code='print.html'/>", icon: "<spring:url value="html.jpg"/>", click: function () {
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
        dataSource: RestDataSource_RestDataSource_ListResult,
        contextMenu: Menu_ListGrid_JspTClassReport,
        fields: [
            {name: "id", title: "id", canEdit: false, hidden: true},
            {name: "tclassCode", title: "کد کلاس"},
            {name: "courseCode", title: "کد دوره"},
            {name: "courseTitleFa", title: "نام دوره"},
            {name: "tclassDuration", title: "مدت کلاس", filterOperator: "equals"},
            {name: "plannerComplex", title:"<spring:message code='organizer.complex'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "plannerName", title:"<spring:message code='planner.name'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "instituteName", title:"<spring:message code='institute.organizer.name'/>", filterOperator: "iContains", autoFitWidth: true },
            {name: "tclassStartDate", title: "تاریخ شروع"},
            {name: "tclassEndDate", title: "تاریخ پایان"},
            {name: "tclassYear", title: "سال کاری"},
            {name: "termTitleFa", title: "ترم"},
            {name: "teacherFullName", title: "استاد"},
            <%--{name: "tclassPlanner",  title: "<spring:message code="planner"/>"},--%>
            <%--{name: "tclassSupervisor",  title: "<spring:message code="supervisor"/>"},--%>
            {name: "tclassStudentsCount", title: "تعداد فراگیران" , filterOperator: "equals"},
            {
                name: "tclassReason",
                title: "<spring:message code="training.request"/>",
                valueMap: {
                    "1": "نیازسنجی",
                    "2": "درخواست واحد",
                    "3": "نیاز موردی",
                }
            },
            {
                name: "classEvaluation",
                title: "<spring:message code="evaluation.level"/>",
                valueMap: {
                    "1": "واکنشی",
                    "2": "یادگیری",
                    "3": "رفتاری",
                    "4": "نتایج",
                }
            },
            {name: "tclassStatus", title: "وضعیت کلاس",
                type: "SelectItem",
                valueMap: {
                    "1": "برنامه ریزی",
                    "2": "در حال اجرا",
                    "3": "پایان یافته",
                    "4": "لغو شده"
                }
            },
            {name: "tclassTeachingType",
                title: "<spring:message code='teaching.type'/>",
                type: "SelectItem",
                valueMap: {
                   "حضوری": "حضوری",
                   "غیر حضوری":"غیر حضوری",
                   "مجازی":"مجازی",
                   "عملی و کارگاهی":"عملی و کارگاهی",
                   "آموزش حین کار(OJT)":"آموزش حین کار(OJT)",
                   "اعزام":"اعزام",
                   "null":"همه"
                }
            },
            {name: "classCancelReasonTitle", title: "علت لغو" , filterOperator: "iContains"},
        ],
        cellHeight: 43,
        showFilterEditor: false,
        filterOperator: "iContains",
        filterOnKeypress: false,
        autoFetchData: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        selectionType: "single",
        sortField: 5,
        sortDirection: "descending",
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
                            // ListGrid_Result_JspTClassReport.sortFieldNum=6;
                            ExportToFile.downloadExcelRestUrl(null, ListGrid_Result_JspTClassReport, viewEvaluationStaticalReportUrl + "/iscList", 0, null, '',  "گزارش کلاس هاي آموزشي", ListGrid_Result_JspTClassReport.data.criteria, null);
                        }
                    }),
                    isc.ToolStripButtonPrint.create({
                        margin:5,
                        title: "چاپ گزارش",
                        click: function() {
                            Reporting();

                            var dataParams = new Object();
                            dataParams.courseInfo = courseInfo_print;
                            dataParams.classTimeInfo = classTimeInfo_print;
                            dataParams.executionInfo = executionInfo_print;
                            dataParams.evaluationInfo = evaluationInfo_print;

                            trPrintWithCriteria("<spring:url value="/tclass/reportPrint/"/>" + "pdf", ListGrid_Result_JspTClassReport.getCriteria(),JSON.stringify(dataParams));
                        }
                    }),
                    ListGrid_Result_JspTClassReport
                ]
            })
        ],
        close(){
            ListGrid_Result_JspTClassReport.setFilterEditorCriteria({});
            this.Super("close",arguments);
        }
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
                name: "courseCode",
                title: "کد دوره",
                hint: "کد دوره را وارد نمائيد",
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
                name: "courseTitleFa",
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
                    "startsWith": "شروع با",
                    "endsWith": "خاتمه با",
                    "contains": "شامل",
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
                hint: "yyyy/mm/dd",
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
                hint: "yyyy/mm/dd",
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
                hint: "yyyy/mm/dd",
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
                hint: "yyyy/mm/dd",
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
                name: "courseCategory",
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
                    var subCategoryField = DynamicForm_CriteriaForm_JspTClassReport.getField("courseSubCategory");
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
                        var ids = DynamicForm_CriteriaForm_JspTClassReport.getField("courseCategory").getValue();
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
                name: "tclassYear",
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
                                        var item = DynamicForm_CriteriaForm_JspTClassReport.getField("tclassYear"),
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
                                        var item = DynamicForm_CriteriaForm_JspTClassReport.getField("tclassYear");
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
                                            values[i] = cache[i].id;
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
                type: "ComboBoxItem",
                autoFetchData: false,
                optionDataSource: RestDataSource_Teacher_JspTClassReport,
                valueField: "id",
                displayField: "fullNameFa",
                filterFields: ["personality.firstNameFa", "personality.lastNameFa", "personality.nationalCode"],
                pickListFields: [
                                {name: "personality.firstNameFa", title: "نام"},
                                {name: "personality.lastNameFa", title: "نام خانوادگی"},
                                {name: "personality.nationalCode", title: "کد ملی"}],
                pickListProperties: {
                    showFilterEditor: true
                }
            },
            // {
            //     name: "teacherPayingStatus",
            //     title: "وضعیت هزینه ی مدرس",
            //     type: "SelectItem",
            //     defaultValue: "3",
            //     valueMap: {
            //         "1": "پرداخت شده",
            //         "2": "پرداخت نشده",
            //         "3": "همه"
            //     },
            //     pickListProperties: {
            //         showFilterEditor: false
            //     },
            // },
            {
                name: "tclassOrganizerId",
                title: "برگزار کننده",
                editorType: "TrComboAutoRefresh",
                optionDataSource: RestDataSource_Institute_JspTClassReport,
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
                name: "temp10",
                title: "",
                canEdit: false
            },
            {
                name: "tclassSupervisor",
                title: "<spring:message code="supervisor"/>:",
                type: "ComboBoxItem",
                textAlign: "center",
                optionDataSource: RestDataSource_SupervisorDS_JspTClassReport,
                autoFetchData: false,
                valueField: "id",
                displayField: "lastName",
                pickListWidth: 550,
                pickListFields: [{name: "personnelNo2"}, {name: "firstName"}, {name: "lastName"}, {name: "nationalCode"}, {name: "personnelNo"}],
                pickListProperties: {sortField: "personnelNo2", showFilterEditor: true}
            },
            {
                name: "tclassPlanner",
                wrapTitle: false,
                title: "<spring:message code="planner"/>:",
                type: "ComboBoxItem",
                textAlign: "center",
                optionDataSource: RestDataSource_PlannerDS_JspTClassReport,
                autoFetchData: false,
                valueField: "id",
                displayField: "lastName",
                pickListWidth: 550,
                pickListFields: [{name: "personnelNo2"}, {name: "firstName"}, {name: "lastName"}, {name: "nationalCode"}, {name: "personnelNo"}],
                pickListProperties: {sortField: "personnelNo2", showFilterEditor: true}
            },
            {
                name: "temp6",
                title: "",
                canEdit: false
            },
            {
                name: "tclassReason",
                colSpan: 1,
                textAlign: "center",
                wrapTitle: true,
                title: "<spring:message code="training.request"/>:",
                type: "ComboBoxItem",
                valueMap: {
                    "1": "نیازسنجی",
                    "2": "درخواست واحد",
                    "3": "نیاز موردی"
                },
            },
            {
                name: "classEvaluation",
                colSpan: 1,
                title: "<spring:message code="evaluation.level"/>:",
                type: "ComboBoxItem",
                textAlign: "center",
                valueMap: {
                    "1": "واکنشی",
                    "2": "یادگیری",
                    "3": "رفتاری",
                    "4": "نتایج"
                }
            },
            {
                name: "temp6",
                title: "",
                canEdit: false
            },
            {
                name: "tclassStatus",
                title: "وضعیت کلاس:",
                wrapTitle: true,
                type: "radioGroup",
                vertical: false,
                filterOperator: "equals",
                fillHorizontalSpace: true,
                defaultValue: "1",
                valueMap: {
                    "1": "برنامه ریزی",
                    "2": "در حال اجرا",
                    "3": "پایان یافته",
                    "4": "لفو شده",
                    "5": "همه"
                }
            },
            {
                name: "temp7",
                title: "",
                canEdit: false
            },
            {
                name: "temp8",
                title: "",
                canEdit: false
            },
            {
                name: "tclassTeachingType",
                title: "<spring:message code='teaching.type'/>:",
                type: "radioGroup",
                vertical: false,
                filterOperator: "equals",
                fillHorizontalSpace: true,
                defaultValue: "حضوری",
                valueMap: {
                    "حضوری": "حضوری",
                    "غیر حضوری":"غیر حضوری",
                    "مجازی":"مجازی",
                    "عملی و کارگاهی":"عملی و کارگاهی",
                    "آموزش حین کار(OJT)":"آموزش حین کار(OJT)",
                    "اعزام":"اعزام",
                    "null":"همه"
                }
            },
            {
                name: "reactionEvaluation",
                title: "نمره ارزیابی واکنشی کلاس",
                type: "checkbox",
                hidden: true,
                changed: function (form, item, value) {
                    if (value == true) {
                        form.getField("reactionEvaluationOperator").disabled = false;
                        form.getField("evaluationReactionGrade").enable();
                    } else if (value == false) {
                        form.getField("reactionEvaluationOperator").disabled = true;
                        form.getField("reactionEvaluationOperator").clearValue();
                        form.getField("evaluationReactionGrade").disabled = true;
                        form.getField("evaluationReactionGrade").clearValue();
                    }
                }
            },
            {
                name: "reactionEvaluationOperator",
                title: "",
                hidden: true,
                type: "SelectItem",
                valueMap: {
                    "lessOrEqual": "کمتر از",
                    "greaterOrEqual": "بیشتر از"
                },
                disabled: true,
                hint: "اپراتور مقایسه ی مد نظر را انتخاب کنید",
                showHintInField: true,
                pickListProperties: {
                    showFilterEditor: false
                },
            },
            {
                name: "evaluationReactionGrade",
                title: "",
                hidden: true,
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
                hidden: true,
                changed: function (form, item, value) {
                    if (value == true) {
                        form.getField("learningEvaluationOperator").disabled = false;
                        form.getField("evaluationLearningGrade").enable();
                    } else if (value == false) {
                        form.getField("learningEvaluationOperator").disabled = true;
                        form.getField("learningEvaluationOperator").clearValue();
                        form.getField("evaluationLearningGrade").disabled = true;
                        form.getField("evaluationLearningGrade").clearValue();
                    }
                }
            },
            {
                name: "learningEvaluationOperator",
                title: "",
                hidden: true,
                type: "SelectItem",
                valueMap: {
                    "lessOrEqual": "کمتر از",
                    "greaterOrEqual": "بیشتر از"
                },
                disabled: true,
                hint: "اپراتور مقایسه ی مد نظر را انتخاب کنید",
                showHintInField: true,
                pickListProperties: {
                    showFilterEditor: false
                },
            },
            {
                name: "evaluationLearningGrade",
                title: "",
                hidden: true,
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
                hidden: true,
                changed: function (form, item, value) {
                    if (value == true) {
                        form.getField("behavioralEvaluationOperator").disabled = false;
                        form.getField("evaluationBehavioralGrade").enable();
                    } else if (value == false) {
                        form.getField("behavioralEvaluationOperator").disabled = true;
                        form.getField("behavioralEvaluationOperator").clearValue();
                        form.getField("evaluationBehavioralGrade").disabled = true;
                        form.getField("evaluationBehavioralGrade").clearValue();
                    }
                }
            },
            {
                name: "behavioralEvaluationOperator",
                title: "",
                hidden: true,
                type: "SelectItem",
                valueMap: {
                    "lessOrEqual": "کمتر از",
                    "greaterOrEqual": "بیشتر از"
                },
                disabled: true,
                hint: "اپراتور مقایسه ی مد نظر را انتخاب کنید",
                showHintInField: true,
                pickListProperties: {
                    showFilterEditor: false
                }
            },
            {
                name: "evaluationBehavioralGrade",
                title: "",
                hidden: true,
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
                hidden: true,
                changed: function (form, item, value) {
                    if (value == true) {
                        form.getField("evaluationOperator").disabled = false;
                        form.getField("evaluationEffectivenessGrade").enable();
                    } else if (value == false) {
                        form.getField("evaluationOperator").disabled = true;
                        form.getField("evaluationOperator").clearValue();
                        form.getField("evaluationEffectivenessGrade").disabled = true;
                        form.getField("evaluationEffectivenessGrade").clearValue();
                    }
                }
            },
            {
                name: "evaluationOperator",
                title: "",
                hidden: true,
                type: "SelectItem",
                valueMap: {
                    "lessOrEqual": "کمتر از",
                    "greaterOrEqual": "بیشتر از"
                },
                disabled: true,
                hint: "اپراتور مقایسه ی مد نظر را انتخاب کنید",
                showHintInField: true,
                pickListProperties: {
                    showFilterEditor: false
                }
            },
            {
                name: "evaluationEffectivenessGrade",
                title: "",
                hidden: true,
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
                name: "courseCode",
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
    DynamicForm_SelectCourses_JspTClassReport.getField("courseCode").comboBox.setHint("دوره های مورد نظر را انتخاب کنید");
    DynamicForm_SelectCourses_JspTClassReport.getField("courseCode").comboBox.pickListFields = [
        {name: "titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"},
        {name: "code", title: "کد دوره", width: "30%", filterOperator: "iContains"}
    ];
    DynamicForm_SelectCourses_JspTClassReport.getField("courseCode").comboBox.filterFields = ["titleFa", "code"];

    IButton_ConfirmCourseSelections_JspTClassReport = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            var criteriaDisplayValues = "";
            var selectorDisplayValues = DynamicForm_SelectCourses_JspTClassReport.getItem("courseCode").getValue();
            if (DynamicForm_CriteriaForm_JspTClassReport.getField("courseCode").getValue() != undefined
                && DynamicForm_CriteriaForm_JspTClassReport.getField("courseCode").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectCourses_JspTClassReport.getField("courseCode").getValue().join(",");
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

            DynamicForm_CriteriaForm_JspTClassReport.getField("courseCode").setValue(criteriaDisplayValues);
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

    //----------------------------------- functions --------------------------------------------------------------------
    function Reporting() {
        data_values = null;
        data_values = DynamicForm_CriteriaForm_JspTClassReport.getValuesAsAdvancedCriteria();
        var removedObjects = [];
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
            else if (data_values.criteria[i].fieldName == "courseTitleFa") {
                data_values.criteria[i].operator = DynamicForm_CriteriaForm_JspTClassReport.getField("courseFilterOperator").getValue();
            }
            else if (data_values.criteria[i].fieldName == "hDurationStart") {
                data_values.criteria[i].fieldName = "tclassDuration";
                data_values.criteria[i].operator = "greaterOrEqual";
            }
            else if (data_values.criteria[i].fieldName == "hDurationEnd") {
                data_values.criteria[i].fieldName = "tclassDuration";
                data_values.criteria[i].operator = "lessOrEqual";
            }
            else if (data_values.criteria[i].fieldName == "startDate1") {
                data_values.criteria[i].fieldName = "tclassStartDate";
                data_values.criteria[i].operator = "greaterThan";
            }
            else if (data_values.criteria[i].fieldName == "startDate2") {
                data_values.criteria[i].fieldName = "tclassStartDate";
                data_values.criteria[i].operator = "lessThan";
            }
            else if (data_values.criteria[i].fieldName == "endDate1") {
                data_values.criteria[i].fieldName = "tclassEndDate";
                data_values.criteria[i].operator = "greaterThan";
            }
            else if (data_values.criteria[i].fieldName == "endDate2") {
                data_values.criteria[i].fieldName = "tclassEndDate";
                data_values.criteria[i].operator = "lessThan";
            }
            else if(data_values.criteria[i].fieldName == "tclassOrganizerId")
                data_values.criteria[i].operator = "equals";
            else if(data_values.criteria[i].fieldName == "tclassSupervisor")
                data_values.criteria[i].operator = "equals";
            else if(data_values.criteria[i].fieldName == "tclassPlanner")
                data_values.criteria[i].operator = "equals";
            else if(data_values.criteria[i].fieldName == "courseCategory"){
                data_values.criteria[i].operator = "inSet";
            }
            else if(data_values.criteria[i].fieldName == "courseSubCategory"){
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
            else if (data_values.criteria[i].fieldName == "reactionEvaluationOperator") {
                removedObjects.add(data_values.criteria[i]);
            }
            else if (data_values.criteria[i].fieldName == "learningEvaluationOperator") {
                removedObjects.add(data_values.criteria[i]);
            }
            else if (data_values.criteria[i].fieldName == "behavioralEvaluationOperator") {
                removedObjects.add(data_values.criteria[i]);
            }
            else if (data_values.criteria[i].fieldName == "evaluationOperator") {
                removedObjects.add(data_values.criteria[i]);
            }
            else if (data_values.criteria[i].fieldName == "evaluationReactionGrade") {
                data_values.criteria[i].operator = DynamicForm_CriteriaForm_JspTClassReport.getField("reactionEvaluationOperator").getValue();
            }
            else if (data_values.criteria[i].fieldName == "evaluationLearningGrade") {
                data_values.criteria[i].operator = DynamicForm_CriteriaForm_JspTClassReport.getField("learningEvaluationOperator").getValue();
            }
            else if (data_values.criteria[i].fieldName == "evaluationBehavioralGrade") {
                data_values.criteria[i].operator = DynamicForm_CriteriaForm_JspTClassReport.getField("behavioralEvaluationOperator").getValue();
            }
            else if (data_values.criteria[i].fieldName == "evaluationEffectivenessGrade") {
                data_values.criteria[i].operator = DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationOperator").getValue();
            }
            else if(data_values.criteria[i].fieldName == "tclassStatus" && data_values.criteria[i].value == "5")
                removedObjects.add(data_values.criteria[i]);
            else if(data_values.criteria[i].fieldName == "tclassTeachingType" && data_values.criteria[i].value == "null")
                removedObjects.add(data_values.criteria[i]);
            //-----------------------------------TEMP----------------------------
            // else if (data_values.criteria[i].fieldName == "teacherPayingStatus") {
            //     removedObjects.add(data_values.criteria[i]);
            // }
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

        if (DynamicForm_CriteriaForm_JspTClassReport.getField("courseCode").getValue() != undefined) {
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "کد دوره: " + "</span>";
            courseInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("courseCode").getDisplayValue() + "</span>";
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            courseInfo_print +=  "کد دوره: " ;
            courseInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("courseCode").getDisplayValue();
            courseInfo_print +=  ", " ;
        }
        if (DynamicForm_CriteriaForm_JspTClassReport.getField("courseTitleFa").getValue() != undefined) {
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "نام دوره: " + "</span>";
            courseInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("courseTitleFa").getDisplayValue() + "</span>";
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            courseInfo_print +=  "نام دوره: " ;
            courseInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("courseTitleFa").getValue();
            courseInfo_print +=  ", " ;
        }
        if (DynamicForm_CriteriaForm_JspTClassReport.getField("courseCategory").getValue() != undefined) {
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "گروه های کاری: " + "</span>";
            courseInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("courseCategory").getDisplayValue() + "</span>";
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            courseInfo_print  += "گروه های کاری: " ;
            courseInfo_print  += DynamicForm_CriteriaForm_JspTClassReport.getField("courseCategory").getDisplayValue() ;
            courseInfo_print  +=   ", " ;
        }
        if (DynamicForm_CriteriaForm_JspTClassReport.getField("courseSubCategory").getValue() != undefined) {
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "زیرگروه های کاری: " + "</span>";
            courseInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("courseSubCategory").getDisplayValue() + "</span>";
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            courseInfo_print +=   "زیرگروه های کاری: " ;
            courseInfo_print  += DynamicForm_CriteriaForm_JspTClassReport.getField("courseSubCategory").getDisplayValue() ;
            courseInfo_print  += ", " ;
        }

        if (DynamicForm_CriteriaForm_JspTClassReport.getField("tclassReason").getValue() !== undefined) {
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "درخواست آموزشی: " + "</span>";
            courseInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("tclassReason").getDisplayValue() + "</span>";
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            courseInfo_print +=  "درخواست آموزشی: " ;
            courseInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("tclassReason").getDisplayValue();
            courseInfo_print += ", ";
        }
        if (DynamicForm_CriteriaForm_JspTClassReport.getField("tclassStatus").getValue() !== undefined) {
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "وضعیت کلاس: " + "</span>";
            courseInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("tclassStatus").getDisplayValue() + "</span>";
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            courseInfo_print +=  "وضعیت کلاس: " ;
            courseInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("tclassStatus").getDisplayValue();
            courseInfo_print += ", ";
        }
        if (DynamicForm_CriteriaForm_JspTClassReport.getField("tclassTeachingType").getValue() !== undefined) {
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "روش آموزش: " + "</span>";
            courseInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("tclassTeachingType").getDisplayValue() + "</span>";
            courseInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            courseInfo_print +=  "روش آموزش: " ;
            courseInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("tclassTeachingType").getDisplayValue();
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
        if (DynamicForm_CriteriaForm_JspTClassReport.getField("tclassYear").getValue() != null &&
            DynamicForm_CriteriaForm_JspTClassReport.getField("tclassYear").getValue() != undefined &&
            DynamicForm_CriteriaForm_JspTClassReport.getField("tclassYear").getValue().size() != 0) {
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "سال کاری: " + "</span>";
            classTimeInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("tclassYear").getDisplayValue() + "</span>";
            classTimeInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            classTimeInfo_print +=  "سال کاری: " ;
            classTimeInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("tclassYear").getValue();
            classTimeInfo_print += ", ";
        }
        if (DynamicForm_CriteriaForm_JspTClassReport.getField("termId").getValue() != null &&
            DynamicForm_CriteriaForm_JspTClassReport.getField("termId").getValue() != undefined &&
            DynamicForm_CriteriaForm_JspTClassReport.getField("termId").getValue().size() != 0) {
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

        if (DynamicForm_CriteriaForm_JspTClassReport.getField("tclassOrganizerId").getValue() != undefined) {
            executionInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "برگزار کننده: " + "</span>";
            executionInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("tclassOrganizerId").getDisplayValue() + "</span>";
            executionInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            executionInfo_print +=  "برگزار کننده: " ;
            executionInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("tclassOrganizerId").getDisplayValue() ;
            executionInfo_print +=  ", " ;
        }

        if (DynamicForm_CriteriaForm_JspTClassReport.getField("classEvaluation").getValue() !== undefined) {
            evaluationInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "سطح ارزیابی: " + "</span>";
            evaluationInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("classEvaluation").getDisplayValue() + "</span>";
            evaluationInfo.contents += "<span style='color:#050505; font-size:12px;'>" + ", " + "</span>";

            evaluationInfo_print +=  "سطح ارزیابی: " ;
            evaluationInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("classEvaluation").getDisplayValue() ;
            evaluationInfo_print +=  ", " ;
        }

        if (DynamicForm_CriteriaForm_JspTClassReport.getField("reactionEvaluationOperator").getValue() != undefined &&
            DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationReactionGrade").getValue() != undefined) {
            reactionEvaluationInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "نمره ارزیابی واکنشی کلاس: " + "</span>";
            reactionEvaluationInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("reactionEvaluationOperator").getDisplayValue() + "</span>";
            reactionEvaluationInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationReactionGrade").getValue() + "</span>";

            evaluationInfo_print += "نمره ارزیابی واکنشی کلاس: " ;
            evaluationInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("reactionEvaluationOperator").getDisplayValue();
            evaluationInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationReactionGrade").getDisplayValue();
            evaluationInfo_print +=  ", " ;
        }

        if (DynamicForm_CriteriaForm_JspTClassReport.getField("learningEvaluationOperator").getValue() != undefined &&
            DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationLearningGrade").getValue() != undefined) {
            learningEvaluationInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "نمره ارزیابی یادگیری کلاس: " + "</span>";
            learningEvaluationInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("learningEvaluationOperator").getDisplayValue() + "</span>";
            learningEvaluationInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationLearningGrade").getDisplayValue() + "</span>";

            evaluationInfo_print += "نمره ارزیابی یادگیری کلاس: " ;
            evaluationInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("learningEvaluationOperator").getDisplayValue();
            evaluationInfo_print +=  DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationLearningGrade").getValue();
            evaluationInfo_print +=  ", " ;
        }

        if (DynamicForm_CriteriaForm_JspTClassReport.getField("behavioralEvaluationOperator").getValue() != undefined &&
            DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationBehavioralGrade").getValue() != undefined) {
            behavioralEvaluationInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "نمره ارزیابی رفتاری کلاس: " + "</span>";
            behavioralEvaluationInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("behavioralEvaluationOperator").getDisplayValue() + "</span>";
            behavioralEvaluationInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationBehavioralGrade").getDisplayValue() + "</span>";

            evaluationInfo_print += "نمره ارزیابی رفتاری کلاس: " ;
            evaluationInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("behavioralEvaluationOperator").getDisplayValue();
            evaluationInfo_print += DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationBehavioralGrade").getDisplayValue();
            evaluationInfo_print +=  ", " ;
        }

        if (DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationOperator").getValue() != undefined &&
            DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationEffectivenessGrade").getValue() != undefined) {
            evaluationInfo.contents += "<span style='color:#050505; font-size:12px;'>" + "نمره اثربخشی کلاس: " + "</span>";
            evaluationInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationOperator").getDisplayValue() + "</span>";
            evaluationInfo.contents += "<span style='color:rgba(199,23,15,0.91); font-size:12px;'>" +
                DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationEffectivenessGrade").getDisplayValue() + "</span>";

            evaluationInfo_print += "نمره اثربخشی کلاس: " ;
            evaluationInfo_print  += DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationOperator").getDisplayValue() ;
            evaluationInfo_print  +=  DynamicForm_CriteriaForm_JspTClassReport.getField("evaluationEffectivenessGrade").getDisplayValue();
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
            // IButton_Print_JspTClassReport
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