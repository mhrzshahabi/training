<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
// <script>
    //----------------------------------------------------Rest DataSource-----------------------------------------------
    RestDataSource_JspUnitReport = isc.TrDS.create({
        fields: [
            {name: "studentPersonnelNo", title:"<spring:message code='personnel.no'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentPersonnelNo2", title:"<spring:message code='personnel.no.6.digits'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentNationalCode", title:"<spring:message code='national.code'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentFirstName", title:"<spring:message code='firstName'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentLastName", title:"<spring:message code='lastName'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelComplexTitle", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classStudentApplicantCompanyName", title:"<spring:message code='company.applicant'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCcpAssistant", title:"<spring:message code='assistance'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCcpSection", title:"<spring:message code='section'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCcpUnit", title:"<spring:message code='unit'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCcpAffairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentWorkPlaceTitle", title: "<spring:message code="geographical.location.of.service"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentPostGradeTitle", title: "<spring:message code="post.grade"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentJobTitle", title: "<spring:message code="job"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classCode", title:"<spring:message code="class.code"/>", autoFitWidth: true},
            {name: "courseCode", title:"<spring:message code='course.code'/>", autoFitWidth: true},
            {name: "courseTitleFa", title:"<spring:message code='course'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseDuration", title:"<spring:message code='course_theoryDuration'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseTheoType", title:"<spring:message code='course_etheoType'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classTeachingType", title: "<spring:message code="teaching.type"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classStartDate", title:"<spring:message code="start.date"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classEndDate", title:"<spring:message code="end.date"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "teacherFirstName", title:"نام استاد", filterOperator: "iContains", autoFitWidth: true},
            {name: "teacherLastName", title:"نام خانوادگی استاد", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseTeacherStatus", title:"<spring:message code="teacher.type"/>", filterOperator: "iContains", autoFitWidth: true, valueMap: {
                    "1" : "<spring:message code='company.staff'/>",
                    "0" : "<spring:message code='external.teacher'/>"
                }},
            {name: "sessionDate", title:"تاریخ جلسه", filterOperator: "iContains", autoFitWidth: true},
            {name: "presenceHour", title:"حضور بر حسب ساعت", filterOperator: "equals", autoFitWidth: true},
            {name: "presenceMinute", title:"حضور بر حسب دقیقه", filterOperator: "equals", autoFitWidth: true},
            {name: "absenceHour", title:"غیبت بر حسب ساعت", filterOperator: "equals", autoFitWidth: true},
            {name: "absenceMinute", title:"غیبت بر حسب دقیقه", filterOperator: "equals", autoFitWidth: true},
            {name: "instituteTitleFa", title: "<spring:message code="institute"/>", filterOperator: "iContains", autoFitWidth: true},

            {name: "evaluationReactionStatus",title: "ارزیابی واکنشی", autoFitWidth: true,filterOperator: "equals",valueMap: {true: "انجام شده", false: "انجام نشده"}},
            {name: "evaluationReactionPass",title: "وضعیت ارزیابی واکنشی", autoFitWidth: true,filterOperator: "equals",valueMap: {true: "تائید شده", false: "تائید نشده"}},
            {name: "evaluationLearningStatus",title:"ارزیابی یادگیری", autoFitWidth: true,filterOperator: "equals",valueMap: {true: "انجام شده", false: "انجام نشده"}},
            {name: "evaluationLearningPass",title: "وضعیت ارزیابی یادگیری" , autoFitWidth: true,filterOperator: "equals",valueMap: {true: "تائید شده", false: "تائید نشده"}},
            {name: "evaluationBehavioralStatus" ,title: "ارزیابی رفتاری", autoFitWidth: true,filterOperator: "equals",valueMap: {true: "انجام شده", false: "انجام نشده"}},
            {name: "evaluationBehavioralPass", title:"وضعیت ارزیابی رفتاری", autoFitWidth: true,filterOperator: "equals",valueMap: {true: "تائید شده", false: "تائید نشده"}},
            {name: "evaluationEffectivenessStatus", title: "اثربخشی", autoFitWidth: true,filterOperator: "equals",valueMap: {true: "انجام شده", false: "انجام نشده"}},
            {name: "evaluationEffectivenessPass",title: "وضعیت اثربخشی", autoFitWidth: true,filterOperator: "equals",valueMap: {true: "تائید شده", false: "تائید نشده"}},
            {name: "evaluationResultsStatus", title: "ارزیابی نتایج", autoFitWidth: true,filterOperator: "equals",valueMap: {true: "انجام شده", false: "انجام نشده"}},
            {name: "evaluationResultsPass",title: "وضعیت ارزیابی نتایج", autoFitWidth: true,filterOperator: "equals",valueMap: {true: "تائید شده", false: "تائید نشده"}},

            {name: "classId", hidden: true, filterOperator: "equals"},
            {name: "studentId", hidden: true, filterOperator: "equals"},
            {name: "evaluationAnalysisId", hidden: true, filterOperator: "equals"},
            {name: "termId", hidden: true, filterOperator: "equals"},
            {name: "courseId", hidden: true, filterOperator: "equals"},
            {name: "categoryId", hidden: true,filterOperator: "equals"},
            {name: "subCategoryId", hidden: true,filterOperator: "equals"},
            {name: "classPlanner", hidden: true, filterOperator: "equals"},
            {name: "classSupervisor", hidden: true, filterOperator: "equals"},

        ],
        fetchDataURL: statisticsUnitReportUrl
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
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=complexTitle"
    });

    AssistantDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=ccpAssistant"
    });

    AffairsDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=ccpAffairs"
    });

    SectionDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="term.code"/>", filterOperator: "iContains", autoFitWidth: true, primaryKey: true},
        ],
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=ccpSection"
    });

    UnitDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=ccpUnit"
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
            criteria:[{ fieldName: "active", operator: "equals", value: 1}]
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
            criteria:[{ fieldName: "active", operator: "equals", value: 1}]
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
    //----------------------------------------------------ListGrid Result-----------------------------------------------
    var ListGrid_JspUnitReport = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource : RestDataSource_JspUnitReport,
        cellHeight: 43,
        sortField: 0,
        showFilterEditor: false,
        selectionType: "single",
        showRecordComponents: true,
        showRecordComponentsByCell: true
    });

    IButton_JspUnitReport_FullExcel = isc.IButtonSave.create({
        top: 260,
        title: "گزارش اکسل",
        width: 300,
        click: function () {
            ExportToFile.showDialog(null, ListGrid_JspUnitReport, 'statisticsUnitReport', 0, null, '',  "گزارش واحد آمار", ListGrid_JspUnitReport.data.criteria, null);
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
        title: "گزارش واحد آمار",
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
    //----------------------------------------------------Criteria Form------------------------------------------------
    var DynamicForm_CriteriaForm_JspUnitReport = isc.DynamicForm.create({
        align: "right",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 6,
        colWidths: ["5%", "25%", "5%", "25%","5%","25%"],
        fields: [
            {
                name: "personnelComplexTitle",
                title: "<spring:message code="complex"/>",
                optionDataSource: ComplexDS_PresenceReport,
                valueField: "value",
                displayField: "value",
            },
            {
                name: "classStudentApplicantCompanyName",
                title: "<spring:message code="company"/>",
                valueField: "value",
                displayField: "value",
                optionDataSource: CompanyDS_PresenceReport,
            },
            {
                name: "studentCcpAssistant",
                title: "<spring:message code="assistance"/>",
                valueField: "value",
                displayField: "value",
                optionDataSource: AssistantDS_PresenceReport,
            },
            {
                name: "studentCcpSection",
                title: "<spring:message code="section.cost"/>",
                valueField: "value",
                displayField: "value",
                optionDataSource: SectionDS_PresenceReport,
            },
            {
                name: "studentCcpUnit",
                title: "<spring:message code="unitName"/>",
                optionDataSource: UnitDS_PresenceReport,
                valueField: "value",
                displayField: "value",
            },
            {
                name: "studentCcpAffairs",
                title: "<spring:message code="affairs"/>",
                optionDataSource: AffairsDS_PresenceReport,
                valueField: "value",
                displayField: "value",
            },
            {
                name: "courseCode",
                title: "کد دوره",
                hint: "کدهای دوره را با , از یکدیگر جدا کنید",
                prompt: "کدهای دوره فقط میتوانند شامل حروف انگلیسی بزرگ، اعداد و - باشند",
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
                name: "temp1",
                title: "",
                canEdit: false
            },
            {
                name: "classCode",
                title: "کد کلاس",
                hint: "کدهای کلاس را با , از یکدیگر جدا کنید",
                prompt: "کدهای کلاس فقط میتوانند شامل حروف انگلیسی بزرگ، اعداد و - باشند",
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
                },
                pickListProperties: {
                    showFilterEditor: false
                },
                defaultValue:  ["1","2","3"]
            },
            {
                name: "temp2",
                title: "",
                canEdit: false
            },
            {
                name: "classStartDate",
                title: "تاریخ کلاس: از",
                ID: "startDate_jspAttendanceReport",
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate_jspAttendanceReport', this, 'ymd', '/');
                    }
                }],
                textAlign: "center",
                changed: function (form, item, value) {
                    var dateCheck;
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        form.addFieldErrors("classStartDate", "<spring:message code='msg.correct.date'/>", true);
                    } else {
                        form.clearFieldErrors("classStartDate", true);
                    }
                }
            },
            {
                name: "classEndDate",
                title: "تا",
                ID: "endDate_jspAttendanceReport",
                type: 'text',
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate_jspAttendanceReport', this, 'ymd', '/');
                    }
                }],
                textAlign: "center",
                changed: function (form, item, value) {
                    let dateCheck;
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        form.clearFieldErrors("classEndDate", true);
                        form.addFieldErrors("classEndDate", "<spring:message code='msg.correct.date'/>", true);
                    } else {
                        form.clearFieldErrors("classEndDate", true);
                    }
                }
            },
            {
                name: "temp4",
                title: "",
                canEdit: false
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
                name: "temp5",
                title: "",
                canEdit: false
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
                name: "temp6",
                title: "",
                canEdit: false
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
                name: "temp7",
                title: "",
                canEdit: false
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
            if (DynamicForm_CriteriaForm_JspUnitReport.getField("courseCode").getValue() != undefined
                && DynamicForm_CriteriaForm_JspUnitReport.getField("courseCode").getValue() != "") {
                criteriaDisplayValues = DynamicForm_CriteriaForm_JspUnitReport.getField("courseCode").getValue();
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
            if (DynamicForm_SelectClasses_JspUnitReport.getField("class.code").getValue() != undefined && DynamicForm_SelectClasses_JspUnitReport.getField("class.code").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectClasses_JspUnitReport.getField("class.code").getValue().join(",");
                let ALength = criteriaDisplayValues.length;
                let lastChar = criteriaDisplayValues.charAt(ALength - 1);
                if (lastChar != ";")
                    criteriaDisplayValues += ",";
            }
            if (selectorDisplayValues != undefined) {
                for (let i = 0; i < selectorDisplayValues.size() - 1; i++) {
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

            criteriaDisplayValues = criteriaDisplayValues == ";undefined" ? "" : criteriaDisplayValues;

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
            if (DynamicForm_CriteriaForm_JspUnitReport.getField("courseCode").getValue() != undefined
                && DynamicForm_CriteriaForm_JspUnitReport.getField("courseCode").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectCourses_JspUnitReportReport.getField("courseCode").getValue().join(",");
                var ALength = criteriaDisplayValues.length;
                var lastChar = criteriaDisplayValues.charAt(ALength - 1);
                if (lastChar != ";")
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

            criteriaDisplayValues = criteriaDisplayValues == ";undefined" ? "" : criteriaDisplayValues;

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

            if(Object.keys(DynamicForm_CriteriaForm_JspUnitReport.getValuesAsCriteria()).length <= 1) {
                createDialog("info","فیلتری انتخاب نشده است.");
                return;
            }

            let criteria = DynamicForm_CriteriaForm_JspUnitReport.getValuesAsAdvancedCriteria();

           // criteria=criteria.criteria1.criteria.filter(x=>x.fieldName=="classStatus")
            console.log(criteria);

            DynamicForm_CriteriaForm_JspUnitReport.validate();
            if (DynamicForm_CriteriaForm_JspUnitReport.hasErrors())
                return;

            else{
                let cr = [];

                if(DynamicForm_CriteriaForm_JspUnitReport.getValue("classCode") !== undefined){
                    criteria.criteria=criteria.criteria.splice(criteria.criteria.findIndex(x=>x.fieldName=="classCode" && x.operator=="inContains"),1);
                    criteria.criteria.push({fieldName: "classCode", operator: "inSet", value: DynamicForm_CriteriaForm_JspUnitReport.getValue("classCode").split(',').toArray()});
                }

                if(DynamicForm_CriteriaForm_JspUnitReport.getValue("courseCode") !== undefined){
                    criteria.criteria=criteria.criteria.splice(criteria.criteria.findIndex(x=>x.fieldName=="courseCode" && x.operator=="inContains"),1);
                    criteria.criteria.push({fieldName: "courseCode", operator: "inSet", value: DynamicForm_CriteriaForm_JspUnitReport.getValue("courseCode").split(',').toArray()});
                }

                // if(DynamicForm_CriteriaForm_JspUnitReport.getValue("classStatus") !== undefined){
                //     criteria.criteria=criteria.criteria.splice(criteria.criteria.findIndex(x=>x.fieldName=="classStatus" && x.operator=="inSet"),1);
                //     criteria.criteria.push({fieldName: "classStatus", operator: "inSet", value: DynamicForm_CriteriaForm_JspUnitReport.getValue("classStatus")});
                // }

                if(DynamicForm_CriteriaForm_JspUnitReport.getValue("instituteId") !== undefined){

                    criteria.criteria.push({fieldName: "instituteId", operator: "equals", value: DynamicForm_CriteriaForm_JspUnitReport.getValue("instituteId")});
                }

                criteria.criteria.push({fieldName: "studentLastName", operator: "iContains", value: "بازدار"});

                //if (cr.length!=0)
                //criteria.criteria = cr;

                console.log(criteria);

                ListGrid_JspUnitReport.invalidateCache();
                //RestDataSource_JspUnitReport.implicitCriteria=[];
                //RestDataSource_JspUnitReport.implicitCriteria = criteria;
                ListGrid_JspUnitReport.fetchData(criteria);
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
        height: "100%",
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
            HLayOut_CriteriaForm_JspUnitReport,
            HLayOut_Confirm_JspUnitReport
        ]
    });
    //----------------------------------------------------End-----------------------------------------------------------
    Window_JspUnitReport.hide();