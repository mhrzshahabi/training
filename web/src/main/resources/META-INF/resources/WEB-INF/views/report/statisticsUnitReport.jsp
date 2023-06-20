<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>

// <script>

    $(document).ready(()=>{
        setTimeout(()=>{
            $("input[name='courseCode']").attr("disabled","disabled");
            $("input[name='classCode']").attr("disabled","disabled");
        },0)}
    );

    var startDate1Check_JspStaticalUnitReport = true;
    var startDate2Check_JspStaticalUnitReport = true;
    var startDateCheck_Order_JspStaticalUnitReport = true;
    var endDate1Check_JspStaticalUnitReport = true;
    var endDate2Check_JspStaticalUnitReport = true;
    var endDateCheck_Order_JspStaticalUnitReport = true;
    //----------------------------------------------------Rest DataSource-----------------------------------------------
    RestDataSource_JspUnitReport = isc.TrDS.create({
        fields: [
            {name: "studentPersonnelNo", title:"<spring:message code='personnel.no'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentPersonnelNo2", title:"<spring:message code='personnel.no.6.digits'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentNationalCode", title:"<spring:message code='national.code'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentFirstName", title:"<spring:message code='firstName'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentLastName", title:"<spring:message code='lastName'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelComplexTitle", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCcpAssistant", title:"<spring:message code='assistance'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCcpAffairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCcpSection", title:"<spring:message code='section'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCcpUnit", title:"<spring:message code='unit'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classStudentApplicantCompanyName", title:"<spring:message code='company.applicant'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentWorkPlaceTitle", title: "<spring:message code="geographical.location.of.service"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentPostGradeTitle", title: "<spring:message code="post.grade"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentJobTitle", title: "<spring:message code="job"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classCode", title:"<spring:message code="class.code"/>", autoFitWidth: true},
            {name: "classStudentScore", title:"نمره", autoFitWidth: true},
            {name: "status", title:"وضعیت نمره", autoFitWidth: true},
            {name: "classCreator", title:"ایجاد کننده کلاس", autoFitWidth: true},
            {name: "classStatus", title:"<spring:message code="class.status"/>", autoFitWidth: true,
                valueMap: {"1": "برنامه ريزی", "2": "در حال اجرا", "3": "پایان یافته", "4": "لغو شده", "5": "اختتام"}
            },
            {name: "courseCode", title:"<spring:message code='course.code'/>", autoFitWidth: true},
            {name: "courseTitleFa", title:"<spring:message code='course'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseETechnicalType", title:"<spring:message code='course_etechnicalType'/>", filterOperator: "iContains", autoFitWidth: true, valueMap: {
                1: "عمومي", 2: "فني", 3: "مديريتي"}},
            {name: "courseDuration", title:"<spring:message code='course_theoryDuration'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "courseTheoType", title:"<spring:message code='course_etheoType'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "teachingMethodTitle", title: "<spring:message code="teaching.type"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classReason", title: "<spring:message code="training.request"/>", filterOperator: "iContains", autoFitWidth: true, valueMap: {
                    "1": "نیازسنجی", "2": "درخواست واحد", "3": "نیاز موردی"}},
            {name: "classTargetPopulationTypeId", title: "دوره ویژه", filterOperator: "iContains", autoFitWidth: true},
            {name: "classHoldingClassTypeId", title: "<spring:message code="course_eruntype"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classStartDate", title:"<spring:message code="start.date"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classEndDate", title:"<spring:message code="end.date"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "teacherFirstName", title:"نام استاد", filterOperator: "iContains", autoFitWidth: true},
            {name: "teacherLastName", title:"نام خانوادگی استاد", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseTeacherStatus", title:"<spring:message code="teacher.type"/>",filterOnKeypress: true, filterOperator: "equals", autoFitWidth: true, valueMap: {
                    "1" : "<spring:message code='company.staff'/>",
                    "0" : "<spring:message code='external.teacher'/>"
                }},
            {name: "sessionDate", title:"تاریخ جلسه", filterOperator: "iContains", autoFitWidth: true},
            {name: "presenceHour", title:"حضور بر حسب ساعت", filterOperator: "equals", autoFitWidth: true},
            {name: "presenceMinute", title:"حضور بر حسب دقیقه", filterOperator: "equals", autoFitWidth: true},
            {name: "absenceHour", title:"غیبت بر حسب ساعت", filterOperator: "equals", autoFitWidth: true},
            {name: "absenceMinute", title:"غیبت بر حسب دقیقه", filterOperator: "equals", autoFitWidth: true},
            {name: "instituteTitleFa", title: "واحد آموزشی برگزار کننده", filterOperator: "iContains", autoFitWidth: true},

            {name: "evaluationReactionStatus",title: "ارزیابی واکنشی",filterOperator: "equals",filterOnKeypress:true,autoFitWidth: true,valueMap: {true: "انجام شده", false: "انجام نشده"}},
            {name: "evaluationReactionPass",title: "وضعیت ارزیابی واکنشی", filterOnKeypress: true,autoFitWidth: true,valueMap: {true: "تائید شده", false: "تائید نشده"}},
            {name: "evaluationLearningStatus",title:"ارزیابی یادگیری", filterOnKeypress: true,autoFitWidth: true,filterOperator: "equals",valueMap: {true: "انجام شده", false: "انجام نشده"}},
            {name: "evaluationLearningPass",title: "وضعیت ارزیابی یادگیری" ,filterOnKeypress: true, autoFitWidth: true,filterOperator: "equals",valueMap: {true: "تائید شده", false: "تائید نشده"}},
            {name: "evaluationBehavioralStatus" ,title: "ارزیابی رفتاری", filterOnKeypress: true,autoFitWidth: true,filterOperator: "equals",valueMap: {true: "انجام شده", false: "انجام نشده"}},
            {name: "evaluationBehavioralPass", title:"وضعیت ارزیابی رفتاری", filterOnKeypress: true,autoFitWidth: true,filterOperator: "equals",valueMap: {true: "تائید شده", false: "تائید نشده"}},
            {name: "evaluationEffectivenessStatus", title: "اثربخشی", filterOnKeypress: true,autoFitWidth: true,filterOperator: "equals",valueMap: {true: "انجام شده", false: "انجام نشده"}},
            {name: "evaluationEffectivenessPass",title: "وضعیت اثربخشی", filterOnKeypress: true,autoFitWidth: true,filterOperator: "equals",valueMap: {true: "تائید شده", false: "تائید نشده"}},
            {name: "evaluationResultsStatus", title: "ارزیابی نتایج", filterOnKeypress: true,autoFitWidth: true,filterOperator: "equals",valueMap: {true: "انجام شده", false: "انجام نشده"}},
            {name: "evaluationResultsPass",title: "وضعیت ارزیابی نتایج", filterOnKeypress: true,autoFitWidth: true,filterOperator: "equals",valueMap: {true: "تائید شده", false: "تائید نشده"}},

            {name: "classId", hidden: true, filterOperator: "equals"},
            {name: "studentId", hidden: true, filterOperator: "equals"},
            {name: "evaluationAnalysisId", hidden: true, filterOperator: "equals"},
            {name: "termId", hidden: true, filterOperator: "equals"},
            {name: "courseId", hidden: true, filterOperator: "equals"},
            {name: "categoryId", hidden: true,filterOperator: "equals"},
            {name: "subCategoryId", hidden: true,filterOperator: "equals"},
            {name: "classPlanner", hidden: true, filterOperator: "equals"},
            {name: "classSupervisor", hidden: true, filterOperator: "equals"},
            {name: "answeredReactionEvalPercent", title: "فرم های تکمیلی ارزیابی واکنشی(%)", filterOperator: "iContains"},
            {name: "answeredBehavioralEvalPercent", title: "فرم های تکمیلی ارزیابی رفتاری(%)", filterOperator: "iContains"},
        ],
        fetchDataURL: statisticsUnitReportUrl +"/list"
    });

    var RestDataSource_Course_JspUnitReport = isc.TrDS.create({
        ID: "courseDS",
        fields: [
            {name: "id", type: "Integer", primaryKey: true},
            {name: "code"},
            {name: "titleFa"}
        ],
        fetchDataURL: courseUrl + "info-tuple-list"
    });

    var RestDataSource_Class_JspUnitReport = isc.TrDS.create({
        ID: "classDS",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleClass"},
            {name: "code"},
            {name: "course.titleFa"}
        ],
        fetchDataURL: classUrl + "info-tuple-list"
    });

    CourseDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code", title: "<spring:message code="corse_code"/>"},
            {name: "titleFa", title: "<spring:message code="course_fa_name"/>"},
        ],
        fetchDataURL: courseUrl + "spec-list"
    });

    CompanyDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="company"/>", filterOperator: "iContains", autoFitWidth: true, primaryKey:true},
        ],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=companyName"
    });

    ComplexDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=complexTitle"
    });

    AssistantDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpAssistant"
    });

    AffairsDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpAffairs"
    });

    SectionDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="term.code"/>", filterOperator: "iContains", autoFitWidth: true, primaryKey: true},
        ],
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpSection"
    });

    UnitDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpUnit"
    });

    var RestDataSource_Course_JspUnitReportReport = isc.TrDS.create({
        ID: "courseDS",
        fields: [
            {name: "id", type: "Integer", primaryKey: true},
            {name: "code"},
            {name: "titleFa"}
        ],
        fetchDataURL: courseUrl + "spec-safe-list"
    });

    var RestDataSource_Teacher_JspUnitReport = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "personality.firstNameFa", filterOperator: "iContains"},
            {name: "personality.lastNameFa", filterOperator: "iContains"},
            {name: "personality.nationalCode", filterOperator: "iContains"},
            {name: "fullNameFa"}
        ],
        fetchDataURL: teacherUrl + "fullName"
    });

    var RestDataSource_Term_JspUnitReport = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
        ]
    });

    var RestDataSource_Year_JspUnitReport = isc.TrDS.create({
        fields: [
            {name: "year", primaryKey: true}
        ],
        fetchDataURL: termUrl + "yearList"
    });

    var RestDataSource_Category_JspUnitReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "spec-list"
    });

    var RestDataSource_SubCategory_JspUnitReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: subCategoryUrl + "iscList"
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
        fetchDataURL: personnelUrl + "/iscList",
        implicitCriteria: {
            _constructor:"AdvancedCriteria",
            operator:"and",
            criteria:[{ fieldName: "active", operator: "equals", value: 1},{ fieldName: "deleted", operator: "equals", value: 0}]
        }
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
        fetchDataURL: personnelUrl + "/iscList",
        implicitCriteria: {
            _constructor:"AdvancedCriteria",
            operator:"and",
            criteria:[{ fieldName: "active", operator: "equals", value: 1},{ fieldName: "deleted", operator: "equals", value: 0}]
        }
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

    var RestDataSource_Target_Population_JspTClassReport = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>"},
            {name: "code", title: "<spring:message code="code"/>"}
        ],
        fetchDataURL: parameterValueUrl + "/listByCode/TargetPopulation"
    });

    var RestDataSource_Holding_Class_Type_JspTClassReport = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>"},
            {name: "code", title: "<spring:message code="code"/>"}
        ],
        fetchDataURL: parameterValueUrl + "/listByCode/HoldingClassType"
    });
    //----------------------------------------------------ListGrid Result-----------------------------------------------
    var ListGrid_JspUnitReport = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource : RestDataSource_JspUnitReport,
        cellHeight: 43,
        sortField: 0,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        selectionType: "single",
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        initialSort: [
            {property: "studentId", direction: "ascending",primarySort: true}
        ],
        fields: [
            {name: "studentPersonnelNo"},
            {name: "studentPersonnelNo2"},
            {name: "studentNationalCode"},
            {name: "studentFirstName"},
            {name: "studentLastName"},
            {name: "personnelComplexTitle"},
            {name: "studentCcpAssistant"},
            {name: "studentCcpAffairs"},
            {name: "studentCcpSection"},
            {name: "studentCcpUnit"},
            {name: "classStudentApplicantCompanyName"},
            {name: "studentWorkPlaceTitle"},
            {name: "studentPostGradeTitle"},
            {name: "studentJobTitle"},
            {name: "classCode"},
            {name: "classCreator"},
            {name: "classStatus"},
            {name: "courseCode"},
            {name: "courseTitleFa"},
            {name: "courseETechnicalType"},
            {name: "courseDuration"},
            {name: "courseTheoType"},
            {name: "teachingMethodTitle"},
            {name: "classReason"},
            {
                name: "classTargetPopulationTypeId",
                optionDataSource: RestDataSource_Target_Population_JspTClassReport,
                autoFetchData: false,
                valueField: "id",
                displayField: "title",
                pickListFields: [
                    {name: "title", autoFitWidth: true, autoFitWidthApproach: true}
                ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                }
            },
            {
                name: "classHoldingClassTypeId",
                optionDataSource: RestDataSource_Holding_Class_Type_JspTClassReport,
                displayField: "title",
                autoFetchData: false,
                valueField: "id",
                pickListFields: [
                    {name: "title", autoFitWidth: true, autoFitWidthApproach: true}
                ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                }
            },
            {name: "classStartDate"},
            {name: "classEndDate"},
            {name: "teacherFirstName"},
            {name: "teacherLastName"},
            {name: "courseTeacherStatus"},
            {name: "sessionDate"},
            {name: "presenceHour"},
            {name: "presenceMinute"},
            {name: "absenceHour"},
            {name: "absenceMinute"},
            {name: "instituteTitleFa"},
            {name: "evaluationReactionStatus"},
            {name: "answeredReactionEvalPercent"},
            {name: "evaluationReactionPass"},
            {name: "evaluationLearningStatus"},
            {name: "evaluationLearningPass"},
            {name: "evaluationBehavioralStatus"},
            {name: "answeredBehavioralEvalPercent"},
            {name: "classStudentScore"},
            {name: "status"},
            {name: "evaluationBehavioralPass"},
            {name: "evaluationEffectivenessStatus"},
            {name: "evaluationEffectivenessPass"},
            {name: "evaluationResultsStatus"},
            {name: "evaluationResultsPass"}
        ]
    });

    IButton_JspUnitReport_FullExcel = isc.IButtonSave.create({
        top: 260,
        title: "گزارش اکسل",
        width: 300,
        click: function () {
            ExportToFile.downloadExcelRestUrl(null, ListGrid_JspUnitReport, statisticsUnitReportUrl+ "/excel-search" , 0, null, '',  "گزارش اصلی واحد آمار", ListGrid_JspUnitReport.data.getCriteria(), null);
        }
    });

    var HLayOut_CriteriaForm_JspUnitReport_Details = isc.TrHLayoutButtons.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "100%",
        alignLayout: "center",
        members: [
            ListGrid_JspUnitReport
        ]
    });

    var HLayOut_Confirm_JspUnitReport_UnitExcel = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_JspUnitReport_FullExcel
        ]
    });

    var Window_JspUnitReport = isc.Window.create({
        placement: "fillScreen",
        title: "گزارش اصلی واحد آمار",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [
            isc.TrVLayout.create({
                members: [
                    HLayOut_CriteriaForm_JspUnitReport_Details,HLayOut_Confirm_JspUnitReport_UnitExcel
                ]
            })
        ]
    });

    var organizationFilter = init_OrganSegmentFilterDF(true, true, true, false, false, null, "personnelComplexTitle","studentCcpAssistant","studentCcpAffairs", "studentCcpSection", "studentCcpUnit");

    //----------------------------------------------------Criteria Form------------------------------------------------
    var DynamicForm_CriteriaForm_JspUnitReport = isc.DynamicForm.create({
        align: "right",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 4,
        colWidths: ["5%", "25%", "5%", "25%","5%","25%"],
        fields: [
            {
                name: "courseCode",
                title: "کد دوره",
                hint: "کد دوره را وارد نمایید",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                        Window_SelectCourses_JspUnitReportReport.show();
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
                name: "classCode",
                title: "کد کلاس",
                hint: "کد کلاس را وارد نمایید",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                        Window_SelectClasses_JspUnitReport.show();
                    }}],
                keyPressFilter: "[A-Z|0-9|,-]"
            },
            {
                name: "classStatus",
                title: "وضعیت کلاس",
                type: "SelectItem",
                operator: "inSet",
                required: true,
                multiple: true,
                valueMap: {
                    "1": "برنامه ريزی",
                    "2": "در حال اجرا",
                    "3": "پایان یافته",
                    "4": "لغو شده",
                    "5": "اختتام"
                },
                pickListProperties: {
                    showFilterEditor: false
                },
                defaultValue:  ["1","2","3"]
            },
            {
                name: "startDate1",
                ID: "startDate1_JspStaticalUnitReport",
                title: "تاریخ شروع کلاس: از",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate1_JspStaticalUnitReport', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("startDate2","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("startDate1", true);
                        startDateCheck_Order_JspStaticalUnitReport = true;
                        startDate1Check_JspStaticalUnitReport = true;
                        return;
                    }

                    var dateCheck;
                    var endDate = form.getValue("startDate2");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        startDate1Check_JspStaticalUnitReport = false;
                        startDateCheck_Order_JspStaticalUnitReport = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        startDateCheck_Order_JspStaticalUnitReport = false;
                        startDate1Check_JspStaticalUnitReport = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    }
                    else {
                        startDate1Check_JspStaticalUnitReport = true;
                        startDateCheck_Order_JspStaticalUnitReport = true;
                        form.clearFieldErrors("startDate1", true);
                    }
                }
            },
            {
                name: "startDate2",
                ID: "startDate2_JspStaticalUnitReport",
                title: "تا",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate2_JspStaticalUnitReport', this, 'ymd', '/', 'right');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("startDate1","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("startDate2", true);
                        startDateCheck_Order_JspStaticalUnitReport = true;
                        startDate2Check_JspStaticalUnitReport = true;
                        return;
                    }

                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("startDate1");
                    if (dateCheck === false) {
                        startDate2Check_JspStaticalUnitReport = false;
                        startDateCheck_Order_JspStaticalUnitReport = true;
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "<spring:message code='msg.correct.date'/>", true);
                    } else if (startDate != undefined && value < startDate) {
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        startDate2Check_JspStaticalUnitReport = true;
                        startDateCheck_Order_JspStaticalUnitReport = false;
                    } else {
                        form.clearFieldErrors("startDate2", true);
                        startDate2Check_JspStaticalUnitReport = true;
                        startDateCheck_Order_JspStaticalUnitReport = true;
                    }
                }
            },
            {
                name: "endDate1",
                ID: "endDate1_JspStaticalUnitReport",
                title: "تاریخ پایان کلاس: از",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('endDate1_JspStaticalUnitReport', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("endDate2","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("endDate1", true);
                        endDateCheck_Order_JspStaticalUnitReport = true;
                        endDate1Check_JspStaticalUnitReport = true;
                        return;
                    }

                    var dateCheck;
                    var endDate = form.getValue("endDate2");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        endDate1Check_JspStaticalUnitReport = false;
                        endDateCheck_Order_JspStaticalUnitReport = true;
                        form.clearFieldErrors("endDate1", true);
                        form.addFieldErrors("endDate1", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        endDateCheck_Order_JspStaticalUnitReport = false;
                        endDate1Check_JspStaticalUnitReport = true;
                        form.clearFieldErrors("endDate1", true);
                        form.addFieldErrors("endDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    } else {
                        endDate1Check_JspStaticalUnitReport = true;
                        endDateCheck_Order_JspStaticalUnitReport = true;
                        form.clearFieldErrors("endDate1", true);
                    }
                }
            },
            {
                name: "endDate2",
                ID: "endDate2_JspStaticalUnitReport",
                title: "تا",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate2_JspStaticalUnitReport', this, 'ymd', '/', 'right');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("endDate1","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("endDate2", true);
                        endDateCheck_Order_JspStaticalUnitReport = true;
                        endDate2Check_JspStaticalUnitReport = true;
                        return;
                    }

                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("endDate1");
                    if (dateCheck === false) {
                        endDate2Check_JspStaticalUnitReport = false;
                        endDateCheck_Order_JspStaticalUnitReport = true;
                        form.clearFieldErrors("endDate2", true);
                        form.addFieldErrors("endDate2", "<spring:message code='msg.correct.date'/>", true);
                    } else if (startDate != undefined && value < startDate) {
                        form.clearFieldErrors("endDate2", true);
                        form.addFieldErrors("endDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        endDate2Check_JspStaticalUnitReport = true;
                        endDateCheck_Order_JspStaticalUnitReport = false;
                    } else {
                        form.clearFieldErrors("endDate2", true);
                        endDate2Check_JspStaticalUnitReport = true;
                        endDateCheck_Order_JspStaticalUnitReport = true;
                    }
                }
            },
            {
                name: "courseTeacherId",
                title: "مدرس",
                type: "ComboBoxItem",
                autoFetchData: false,
                optionDataSource: RestDataSource_Teacher_JspUnitReport,
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
            {
                name: "instituteId",
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
                name: "classYear",
                title: "سال کاری",
                type: "SelectItem",
                multiple: true,
                optionDataSource: RestDataSource_Year_JspUnitReport,
                valueField: "year",
                displayField: "year",
                filterFields: ["year"],
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                changed: function (form, item, value) {
                    if (value != null && value != undefined && value.size() == 1) {
                        RestDataSource_Term_JspUnitReport.fetchDataURL = termUrl + "listByYear/" + value[0];
                        DynamicForm_CriteriaForm_JspUnitReport.getField("termId").optionDataSource = RestDataSource_Term_JspUnitReport;
                        DynamicForm_CriteriaForm_JspUnitReport.getField("termId").fetchData();
                        DynamicForm_CriteriaForm_JspUnitReport.getField("termId").enable();
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
                filterLocally: true
            },
            {
                name: "courseCategory",
                title: "گروه کاری",
                type: "SelectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_Category_JspUnitReport,
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
                    isCriteriaCategoriesChanged_JspUnitReport = true;
                    var subCategoryField = DynamicForm_CriteriaForm_JspUnitReport.getField("courseSubCategory");
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
                optionDataSource: RestDataSource_SubCategory_JspUnitReport,
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
                    if (isCriteriaCategoriesChanged_JspUnitReport) {
                        isCriteriaCategoriesChanged_JspUnitReport = false;
                        var ids = DynamicForm_CriteriaForm_JspUnitReport.getField("courseCategory").getValue();
                        if (ids === []) {
                            RestDataSource_SubCategory_JspUnitReport.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_JspUnitReport.implicitCriteria = {
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
                name: "classSupervisor",
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
                name: "classPlanner",
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
            }
        ]
    });

    var initialLayoutStyle = "vertical";
    var DynamicForm_SelectCourses_JspUnitReport = isc.DynamicForm.create({
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
                optionDataSource: RestDataSource_Course_JspUnitReport
            }
        ]
    });
    DynamicForm_SelectCourses_JspUnitReport.getField("course.code").comboBox.setHint("دوره های مورد نظر را انتخاب کنید");
    DynamicForm_SelectCourses_JspUnitReport.getField("course.code").comboBox.pickListFields =
        [{name: "titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"},
            {
                name: "code", title: "کد دوره", width: "30%", filterOperator: "iContains"
            }];
    DynamicForm_SelectCourses_JspUnitReport.getField("course.code").comboBox.filterFields = ["titleFa", "code"];

    IButton_ConfirmCourseSelections_JspUnitReport = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            var criteriaDisplayValues = "";
            var selectorDisplayValues = DynamicForm_SelectCourses_JspUnitReport.getItem("course.code").getValue();
            if (DynamicForm_CriteriaForm_JspUnitReport.getField("courseCode").getValue() !== undefined
                && DynamicForm_CriteriaForm_JspUnitReport.getField("courseCode").getValue() !== "") {
                criteriaDisplayValues = DynamicForm_CriteriaForm_JspUnitReport.getField("courseCode").getValue();
                var ALength = criteriaDisplayValues.length;
                var lastChar = criteriaDisplayValues.charAt(ALength - 1);
                if (lastChar !== ";")
                    criteriaDisplayValues += ";";
            }
            if (selectorDisplayValues !== undefined) {
                for (var i = 0; i < selectorDisplayValues.size() - 1; i++) {
                    criteriaDisplayValues += selectorDisplayValues [i] + ";";
                }
                criteriaDisplayValues += selectorDisplayValues [selectorDisplayValues.size() - 1];
            }
            DynamicForm_CriteriaForm_JspUnitReport.getField("courseCode").setValue(criteriaDisplayValues);
            Window_SelectCourses_JspUnitReport.close();
        }
    });

    var Window_SelectCourses_JspUnitReport = isc.Window.create({
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
                    DynamicForm_SelectCourses_JspUnitReport,
                    IButton_ConfirmCourseSelections_JspUnitReport
                ]
            })
        ]
    });

    var DynamicForm_SelectClasses_JspUnitReport = isc.DynamicForm.create({
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
                optionDataSource: RestDataSource_Class_JspUnitReport
            }
        ]
    });

    DynamicForm_SelectClasses_JspUnitReport.getField("class.code").comboBox.setHint("کلاسهای مورد نظر را انتخاب کنید");
    DynamicForm_SelectClasses_JspUnitReport.getField("class.code").comboBox.pickListFields =
        [
            {name: "titleClass", title: "نام کلاس", width: "30%", filterOperator: "iContains"},
            {name: "code", title: "کد کلاس", width: "30%", filterOperator: "iContains"},
            {name: "course.titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"}];
    DynamicForm_SelectClasses_JspUnitReport.getField("class.code").comboBox.filterFields = ["titleClass", "code", "course.titleFa"];

    IButton_ConfirmClassesSelections_JspUnitReport = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            let criteriaDisplayValues = "";
            let selectorDisplayValues = DynamicForm_SelectClasses_JspUnitReport.getItem("class.code").getValue();
            if (DynamicForm_SelectClasses_JspUnitReport.getField("class.code").getValue() !== undefined && DynamicForm_SelectClasses_JspUnitReport.getField("class.code").getValue() !== "") {
                criteriaDisplayValues = DynamicForm_SelectClasses_JspUnitReport.getField("class.code").getValue().join(",");
                let ALength = criteriaDisplayValues.length;
                let lastChar = criteriaDisplayValues.charAt(ALength - 1);
                if (lastChar !== ";")
                    criteriaDisplayValues += ",";
            }
            if (selectorDisplayValues !== undefined) {
                for (let i = 0; i < selectorDisplayValues.size() - 1; i++) {
                    criteriaDisplayValues += selectorDisplayValues [i] + ",";
                }
                criteriaDisplayValues += selectorDisplayValues [selectorDisplayValues.size() - 1];
            }

            if (typeof criteriaDisplayValues !== "undefined") {
                let uniqueNames = [];

                $.each(criteriaDisplayValues.split(","), function (i, el) {
                    if ($.inArray(el, uniqueNames) === -1) uniqueNames.push(el);
                });
                criteriaDisplayValues = uniqueNames.join(",");
            }

            criteriaDisplayValues = criteriaDisplayValues === "undefined" ? "" : criteriaDisplayValues;

            DynamicForm_CriteriaForm_JspUnitReport.getField("classCode").setValue(criteriaDisplayValues);
            Window_SelectClasses_JspUnitReport.close();
        }
    });

    var Window_SelectClasses_JspUnitReport = isc.Window.create({
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
                    DynamicForm_SelectClasses_JspUnitReport,
                    IButton_ConfirmClassesSelections_JspUnitReport,
                ]
            })
        ]
    });

    var DynamicForm_SelectCourses_JspUnitReportReport = isc.DynamicForm.create({
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
                optionDataSource: RestDataSource_Course_JspUnitReportReport
            }
        ]
    });
    DynamicForm_SelectCourses_JspUnitReportReport.getField("courseCode").comboBox.setHint("دوره های مورد نظر را انتخاب کنید");
    DynamicForm_SelectCourses_JspUnitReportReport.getField("courseCode").comboBox.pickListFields =
        [{name: "titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"},
            {
                name: "code", title: "کد دوره", width: "30%", filterOperator: "iContains"
            }];
    DynamicForm_SelectCourses_JspUnitReportReport.getField("courseCode").comboBox.filterFields = ["titleFa", "code"];

    IButton_ConfirmCourseSelections_JspUnitReportReport = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            var criteriaDisplayValues = "";
            var selectorDisplayValues = DynamicForm_SelectCourses_JspUnitReportReport.getItem("courseCode").getValue();
            if (DynamicForm_CriteriaForm_JspUnitReport.getField("courseCode").getValue() !== undefined
                && DynamicForm_CriteriaForm_JspUnitReport.getField("courseCode").getValue() !== "") {
                criteriaDisplayValues = DynamicForm_SelectCourses_JspUnitReportReport.getField("courseCode").getValue().join(",");
                var ALength = criteriaDisplayValues.length;
                var lastChar = criteriaDisplayValues.charAt(ALength - 1);
                if (lastChar !== ";")
                    criteriaDisplayValues += ",";
            }
            if (selectorDisplayValues !== undefined) {
                for (var i = 0; i < selectorDisplayValues.size() - 1; i++) {
                    criteriaDisplayValues += selectorDisplayValues [i] + ",";
                }
                criteriaDisplayValues += selectorDisplayValues [selectorDisplayValues.size() - 1];
            }

            if (typeof criteriaDisplayValues !== "undefined") {
                let uniqueNames = [];

                $.each(criteriaDisplayValues.split(","), function (i, el) {
                    if ($.inArray(el, uniqueNames) === -1) uniqueNames.push(el);
                });
                criteriaDisplayValues = uniqueNames.join(",");
            }

            // console.log(criteriaDisplayValues);

            criteriaDisplayValues = criteriaDisplayValues === ",undefined" ? "" : criteriaDisplayValues;

            DynamicForm_CriteriaForm_JspUnitReport.getField("courseCode").setValue(criteriaDisplayValues);
            Window_SelectCourses_JspUnitReportReport.close();
        }
    });

    var Window_SelectCourses_JspUnitReportReport = isc.Window.create({
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
                    DynamicForm_SelectCourses_JspUnitReportReport,
                    IButton_ConfirmCourseSelections_JspUnitReportReport
                ]
            })
        ]
    });

    IButton_JspUnitReport = isc.IButtonSave.create({
        top: 260,
        title: "چاپ گزارش",
        width: 300,
        click: function () {

            if(DynamicForm_CriteriaForm_JspUnitReport.getValuesAsAdvancedCriteria().criteria.size() <= 1 ||
                (organizationFilter.getCriteria(DynamicForm_CriteriaForm_JspUnitReport.getValuesAsAdvancedCriteria())).criteria.length <= 1) {
                createDialog("info","فیلتری انتخاب نشده است.");
                return;
            }

            DynamicForm_CriteriaForm_JspUnitReport.validate();
            if (DynamicForm_CriteriaForm_JspUnitReport.hasErrors() || organizationFilter.hasErrors())
                return;

            else {
                data_values = organizationFilter.getCriteria(DynamicForm_CriteriaForm_JspUnitReport.getValuesAsAdvancedCriteria());
                for (var i = 0; i < data_values.criteria.size(); i++) {
                    if (data_values.criteria[i].fieldName === "courseCode") {
                        var codesString = data_values.criteria[i].value;
                        var codesArray;
                        codesArray = codesString.split(",");
                        for (var j = 0; j < codesArray.length; j++) {
                            if (codesArray[j] === "" || codesArray[j] === " ") {
                                codesArray.remove(codesArray[j]);
                            }
                        }
                        data_values.criteria[i].operator = "inSet";
                        data_values.criteria[i].value = codesArray;
                    }

                    else if (data_values.criteria[i].fieldName === "classCode") {
                        var codesString = data_values.criteria[i].value;
                        var codesArray;
                        codesArray = codesString.split(",");
                        for (var j = 0; j < codesArray.length; j++) {
                            if (codesArray[j] === "" || codesArray[j] === " ") {
                                codesArray.remove(codesArray[j]);
                            }
                        }
                        data_values.criteria[i].operator = "inSet";
                        data_values.criteria[i].value = codesArray;
                    }

                    else if (data_values.criteria[i].fieldName === "instituteId") {
                        data_values.criteria[i].fieldName = "instituteId";
                        data_values.criteria[i].operator = "equals";
                    }

                    else if (data_values.criteria[i].fieldName === "personnelComplexTitle") {
                        data_values.criteria[i].fieldName = "personnelComplexTitle";
                        data_values.criteria[i].operator = "inSet";
                    }

                    else if (data_values.criteria[i].fieldName === "classStudentApplicantCompanyName") {
                        data_values.criteria[i].fieldName = "classStudentApplicantCompanyName";
                        data_values.criteria[i].operator = "iContains";
                    }
                    else if (data_values.criteria[i].fieldName === "studentCcpAssistant") {
                        data_values.criteria[i].fieldName = "studentCcpAssistant";
                        data_values.criteria[i].operator = "inSet";
                    }
                    else if (data_values.criteria[i].fieldName === "studentCcpUnit") {
                        data_values.criteria[i].fieldName = "studentCcpUnit";
                        data_values.criteria[i].operator = "inSet";
                    }
                    else if (data_values.criteria[i].fieldName === "studentCcpAffairs") {
                        data_values.criteria[i].fieldName = "studentCcpAffairs";
                        data_values.criteria[i].operator = "inSet";
                    }
                    else if (data_values.criteria[i].fieldName === "studentCcpSection") {
                        data_values.criteria[i].fieldName = "studentCcpSection";
                        data_values.criteria[i].operator = "inSet";
                    }
                    else if (data_values.criteria[i].fieldName === "courseTitleFa") {
                        data_values.criteria[i].fieldName = "courseTitleFa";
                        data_values.criteria[i].operator = "iContains";
                    }
                    else if (data_values.criteria[i].fieldName === "startDate1") {
                        data_values.criteria[i].fieldName = "classStartDate";
                        data_values.criteria[i].operator = "greaterOrEqual";
                    }
                    else if (data_values.criteria[i].fieldName === "startDate2") {
                        data_values.criteria[i].fieldName = "classStartDate";
                        data_values.criteria[i].operator = "lessOrEqual";
                    }
                    else if (data_values.criteria[i].fieldName === "endDate1") {
                        data_values.criteria[i].fieldName = "classEndDate";
                        data_values.criteria[i].operator = "greaterOrEqual";
                    }
                    else if (data_values.criteria[i].fieldName === "endDate2") {
                        data_values.criteria[i].fieldName = "classEndDate";
                        data_values.criteria[i].operator = "lessOrEqual";
                    }
                    else if (data_values.criteria[i].fieldName === "classPlanner") {
                        data_values.criteria[i].fieldName = "classPlanner";
                        data_values.criteria[i].operator = "equals";
                    }

                    else if (data_values.criteria[i].fieldName === "classSupervisor") {
                        data_values.criteria[i].fieldName = "classSupervisor";
                        data_values.criteria[i].operator = "equals";
                    }

                    else if (data_values.criteria[i].fieldName === "courseTeacherId") {
                        data_values.criteria[i].fieldName = "courseTeacherId";
                        data_values.criteria[i].operator = "equals";
                    }

                    else if (data_values.criteria[i].fieldName === "classYear") {
                        data_values.criteria[i].fieldName = "classYear";
                        data_values.criteria[i].operator = "iContains";
                    }

                    else if (data_values.criteria[i].fieldName === "termId") {
                        data_values.criteria[i].fieldName = "termId";
                        data_values.criteria[i].operator = "equals";
                    }

                    else if (data_values.criteria[i].fieldName === "courseCategory") {
                        data_values.criteria[i].fieldName = "courseCategory";
                        data_values.criteria[i].operator = "equals";
                    }

                    else if (data_values.criteria[i].fieldName === "courseSubCategory") {
                        data_values.criteria[i].fieldName = "courseSubCategory";
                        data_values.criteria[i].operator = "equals";
                    }
                }

                ListGrid_JspUnitReport.invalidateCache();
                ListGrid_JspUnitReport.fetchData(data_values);
                Window_JspUnitReport.show();
            }
        }
    });

    //----------------------------------- functions --------------------------------------------------------------------
    let Window_CriteriaForm_JspUnitReport = isc.Window.create({
        placement: "fillScreen",
        title: "",
        showCloseButton: false,
        showMaximizeButton: false,
        canDragReposition: false,
        showMinimizeButton: false,
        canDragResize: false,
        closeClick: false,
        minimize: false,
        items: [DynamicForm_CriteriaForm_JspUnitReport]
    });
    //----------------------------------- layOut -----------------------------------------------------------------------
    var HLayOut_CriteriaForm_JspUnitReport = isc.TrHLayoutButtons.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "20%",
        alignLayout: "center",
        members: [
            Window_CriteriaForm_JspUnitReport
        ]
    });

    var HLayOut_Confirm_JspUnitReport = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_JspUnitReport
        ]
    });

    var VLayout_Body_JspUnitReport = isc.TrVLayout.create({
        members: [
            organizationFilter,
            DynamicForm_CriteriaForm_JspUnitReport,
            HLayOut_Confirm_JspUnitReport
        ]
    });
    //----------------------------------------------------End-----------------------------------------------------------
    Window_JspUnitReport.hide();

    //</script>