<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
// <script>
    var startDate1Check_JspStaticalCoursesPassedPersonnel = true;
    var startDate2Check_JspStaticalCoursesPassedPersonnel = true;
    var startDateCheck_Order_JspStaticalCoursesPassedPersonnel = true;
    var endDate1Check_JspStaticalCoursesPassedPersonnel = true;
    var endDate2Check_JspStaticalCoursesPassedPersonnel = true;
    var endDateCheck_Order_JspStaticalCoursesPassedPersonnel = true;
    //----------------------------------------------------Rest DataSource-----------------------------------------------
    RestDataSource_JspCoursesPassedPersonnel = isc.TrDS.create({
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
        fetchDataURL: viewCoursesPassedPersonnelReportUrl
    });

    var RestDataSource_Course_JspCoursesPassedPersonnel = isc.TrDS.create({
        ID: "courseDS",
        fields: [
            {name: "id", type: "Integer", primaryKey: true},
            {name: "code"},
            {name: "titleFa"}
        ],
        fetchDataURL: courseUrl + "info-tuple-list"
    });

    var RestDataSource_Class_JspCoursesPassedPersonnel = isc.TrDS.create({
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

    var RestDataSource_Course_JspCoursesPassedPersonnelReport = isc.TrDS.create({
        ID: "courseDS",
        fields: [
            {name: "id", type: "Integer", primaryKey: true},
            {name: "code"},
            {name: "titleFa"}
        ],
        fetchDataURL: courseUrl + "spec-safe-list"
    });

    var RestDataSource_Teacher_JspCoursesPassedPersonnel = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "personality.firstNameFa", filterOperator: "iContains"},
            {name: "personality.lastNameFa", filterOperator: "iContains"},
            {name: "personality.nationalCode", filterOperator: "iContains"},
            {name: "fullNameFa"}
        ],
        fetchDataURL: teacherUrl + "fullName"
    });

    var RestDataSource_Term_JspCoursesPassedPersonnel = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
        ]
    });

    var RestDataSource_Year_JspCoursesPassedPersonnel = isc.TrDS.create({
        fields: [
            {name: "year", primaryKey: true}
        ],
        fetchDataURL: termUrl + "yearList"
    });

    var RestDataSource_Category_JspCoursesPassedPersonnel = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "spec-list"
    });

    var RestDataSource_SubCategory_JspCoursesPassedPersonnel = isc.TrDS.create({
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


    let RestDataSource_PostGradeLvl_PCNR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "code",
                title: "<spring:message code="post.grade.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: viewPostGradeUrl + "/iscList"
    });
    //----------------------------------------------------ListGrid Result-----------------------------------------------
    var ListGrid_JspCoursesPassedPersonnel = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource : RestDataSource_JspCoursesPassedPersonnel,
        cellHeight: 43,
        sortField: 0,
        showFilterEditor: false,
        selectionType: "single",
        showRecordComponents: true,
        showRecordComponentsByCell: true
    });

    IButton_JspCoursesPassedPersonnel_FullExcel = isc.IButtonSave.create({
        top: 260,
        title: "گزارش اکسل",
        width: 300,
        click: function () {
            ExportToFile.showDialog(null, ListGrid_JspCoursesPassedPersonnel, 'statisticsCoursesPassedPersonnel', 0, null, '',  "گزارش واحد آمار", ListGrid_JspCoursesPassedPersonnel.data.criteria, null);
        }
    });

    var HLayOut_CriteriaForm_JspCoursesPassedPersonnel_Details = isc.TrHLayoutButtons.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "100%",
        alignLayout: "center",
        members: [
            ListGrid_JspCoursesPassedPersonnel
        ]
    });

    var HLayOut_Confirm_JspCoursesPassedPersonnel_UnitExcel = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_JspCoursesPassedPersonnel_FullExcel
        ]
    });

    var Window_JspCoursesPassedPersonnel = isc.Window.create({
        placement: "fillScreen",
        title: "گزارش دوره های گذرانده فرد",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [
            isc.TrVLayout.create({
                members: [
                    HLayOut_CriteriaForm_JspCoursesPassedPersonnel_Details,HLayOut_Confirm_JspCoursesPassedPersonnel_UnitExcel
                ]
            })
        ]
    });
    //----------------------------------------------------Criteria Form------------------------------------------------
    var DynamicForm_CriteriaForm_JspCoursesPassedPersonnel = isc.DynamicForm.create({
        align: "right",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 6,
        colWidths: ["5%", "25%", "5%", "25%","5%","25%"],
        fields: [
            {
                name: "empNo",
                title:"پرسنلی 6رقمی",
                textAlign: "center",
                width: "*",
                keyPressFilter: "[0-9, ]",
                operator: "inSet",
                editorType: "TextItem",
                length:10000,
                changed (form, item, value){
                    let res = value.split(" ");
                    item.setValue(res.toString())
                }
            },
            {
                name: "personnelNo",
                title:"<spring:message code="personnel.no"/> ",
                textAlign: "center",
                width: "*"
            },
            {
                name: "nationalCode",
                title:"<spring:message code="national.code"/> ",
                textAlign: "center",
                width: "*",
            },
            {
                name: "firstName",
                title:"<spring:message code="firstName"/> ",
                textAlign: "center",
                width: "*"
            },
            {
                name: "lastName",
                title:"<spring:message code="lastName"/> ",
                textAlign: "center",
                width: "*"
            },
            {
                name: "temp0",
                title: "",
                canEdit: false
            },
            {
                name: "complexTitle",
                title: "<spring:message code="complex"/>",
                optionDataSource: ComplexDS_PresenceReport,
                valueField: "value",
                displayField: "value",
                icons:[
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click : function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();
                            form.setValue(null);
                        }
                    }
                ],
            },
            {
                name: "companyName",
                title: "<spring:message code="company"/>",
                valueField: "value",
                displayField: "value",
                optionDataSource: CompanyDS_PresenceReport,
                icons:[
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click : function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();
                            form.setValue(null);
                        }
                    }
                ],
            },
            {
                name: "assistant",
                title: "<spring:message code="assistance"/>",
                valueField: "value",
                displayField: "value",
                optionDataSource: AssistantDS_PresenceReport,
                icons:[
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click : function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();
                            form.setValue(null);
                        }
                    }
                ],
            },
            {
                name: "section",
                title: "<spring:message code="section.cost"/>",
                valueField: "value",
                displayField: "value",
                optionDataSource: SectionDS_PresenceReport,
                icons:[
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click : function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();
                            form.setValue(null);
                        }
                    }
                ],
            },
            {
                name: "unit",
                title: "<spring:message code="unitName"/>",
                optionDataSource: UnitDS_PresenceReport,
                valueField: "value",
                displayField: "value",
                icons:[
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click : function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();
                            form.setValue(null);
                        }
                    }
                ],
            },
            {
                name: "affairs",
                title: "<spring:message code="affairs"/>",
                optionDataSource: AffairsDS_PresenceReport,
                valueField: "value",
                displayField: "value",
                icons:[
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click : function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();
                            form.setValue(null);
                        }
                    }
                ],
            },
            {
                name: "startDate1",
                ID: "startDate1_JspStaticalCoursesPassedPersonnel",
                title: "تاریخ شروع کلاس: از",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate1_JspStaticalCoursesPassedPersonnel', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("startDate2","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("startDate1", true);
                        startDateCheck_Order_JspStaticalCoursesPassedPersonnel = true;
                        startDate1Check_JspStaticalCoursesPassedPersonnel = true;
                        return;
                    }

                    form.getItem("startDate1").setValue(reformat(form.getValue("startDate1")));

                    var dateCheck;
                    var endDate = form.getValue("startDate2");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        startDate1Check_JspStaticalCoursesPassedPersonnel = false;
                        startDateCheck_Order_JspStaticalCoursesPassedPersonnel = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        startDateCheck_Order_JspStaticalCoursesPassedPersonnel = false;
                        startDate1Check_JspStaticalCoursesPassedPersonnel = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    }
                    else {
                        startDate1Check_JspStaticalCoursesPassedPersonnel = true;
                        startDateCheck_Order_JspStaticalCoursesPassedPersonnel = true;
                        form.clearFieldErrors("startDate1", true);
                    }
                }
            },
            {
                name: "startDate2",
                ID: "startDate2_JspStaticalCoursesPassedPersonnel",
                title: "تا",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate2_JspStaticalCoursesPassedPersonnel', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("startDate1","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("startDate2", true);
                        startDateCheck_Order_JspStaticalCoursesPassedPersonnel = true;
                        startDate2Check_JspStaticalCoursesPassedPersonnel = true;
                        return;
                    }

                    form.getItem("startDate2").setValue(reformat(form.getValue("startDate2")));

                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("startDate1");
                    if (dateCheck === false) {
                        startDate2Check_JspStaticalCoursesPassedPersonnel = false;
                        startDateCheck_Order_JspStaticalCoursesPassedPersonnel = true;
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "<spring:message code='msg.correct.date'/>", true);
                    } else if (startDate != undefined && value < startDate) {
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        startDate2Check_JspStaticalCoursesPassedPersonnel = true;
                        startDateCheck_Order_JspStaticalCoursesPassedPersonnel = false;
                    } else {
                        form.clearFieldErrors("startDate2", true);
                        startDate2Check_JspStaticalCoursesPassedPersonnel = true;
                        startDateCheck_Order_JspStaticalCoursesPassedPersonnel = true;
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
                ID: "endDate1_JspStaticalCoursesPassedPersonnel",
                title: "تاریخ پایان کلاس: از",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('endDate1_JspStaticalCoursesPassedPersonnel', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("endDate2","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("endDate1", true);
                        endDateCheck_Order_JspStaticalCoursesPassedPersonnel = true;
                        endDate1Check_JspStaticalCoursesPassedPersonnel = true;
                        return;
                    }

                    form.getItem("endDate1").setValue(reformat(form.getValue("endDate1")));

                    var dateCheck;
                    var endDate = form.getValue("endDate2");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        endDate1Check_JspStaticalCoursesPassedPersonnel = false;
                        endDateCheck_Order_JspStaticalCoursesPassedPersonnel = true;
                        form.clearFieldErrors("endDate1", true);
                        form.addFieldErrors("endDate1", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        endDateCheck_Order_JspStaticalCoursesPassedPersonnel = false;
                        endDate1Check_JspStaticalCoursesPassedPersonnel = true;
                        form.clearFieldErrors("endDate1", true);
                        form.addFieldErrors("endDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    } else {
                        endDate1Check_JspStaticalCoursesPassedPersonnel = true;
                        endDateCheck_Order_JspStaticalCoursesPassedPersonnel = true;
                        form.clearFieldErrors("endDate1", true);
                    }
                }
            },
            {
                name: "endDate2",
                ID: "endDate2_JspStaticalCoursesPassedPersonnel",
                title: "تا",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate2_JspStaticalCoursesPassedPersonnel', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("endDate1","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("endDate2", true);
                        endDateCheck_Order_JspStaticalCoursesPassedPersonnel = true;
                        endDate2Check_JspStaticalCoursesPassedPersonnel = true;
                        return;
                    }

                    form.getItem("endDate2").setValue(reformat(form.getValue("endDate2")));

                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("endDate1");
                    if (dateCheck === false) {
                        endDate2Check_JspStaticalCoursesPassedPersonnel = false;
                        endDateCheck_Order_JspStaticalCoursesPassedPersonnel = true;
                        form.clearFieldErrors("endDate2", true);
                        form.addFieldErrors("endDate2", "<spring:message code='msg.correct.date'/>", true);
                    } else if (startDate != undefined && value < startDate) {
                        form.clearFieldErrors("endDate2", true);
                        form.addFieldErrors("endDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        endDate2Check_JspStaticalCoursesPassedPersonnel = true;
                        endDateCheck_Order_JspStaticalCoursesPassedPersonnel = false;
                    } else {
                        form.clearFieldErrors("endDate2", true);
                        endDate2Check_JspStaticalCoursesPassedPersonnel = true;
                        endDateCheck_Order_JspStaticalCoursesPassedPersonnel = true;
                    }
                }
            },
            {
                name: "temp2",
                title: "",
                canEdit: false
            },
            {
                name: "classYear",
                title: "سال کاری",
                type: "SelectItem",
                multiple: true,
                optionDataSource: RestDataSource_Year_JspCoursesPassedPersonnel,
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
                        RestDataSource_Term_JspCoursesPassedPersonnel.fetchDataURL = termUrl + "listByYear/" + value[0];
                        DynamicForm_CriteriaForm_JspCoursesPassedPersonnel.getField("termId").optionDataSource = RestDataSource_Term_JspCoursesPassedPersonnel;
                        DynamicForm_CriteriaForm_JspCoursesPassedPersonnel.getField("termId").fetchData();
                        DynamicForm_CriteriaForm_JspCoursesPassedPersonnel.getField("termId").enable();
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
                name: "temp3",
                title: "",
                canEdit: false
            },
            {
                name: "pgCCode",
                title:"<spring:message code='post.grade'/>",
                operator: "inSet",
                optionDataSource: RestDataSource_PostGradeLvl_PCNR,
                valueField: "code",
                displayField: "titleFa",
            },
            // {
            //     name: "needAssessment",
            //     title: "وضعیت نیازسنجی",
            //     type: "SelectItem",
            //     valueMap: {
            //         "1": "نیازسنجی",
            //         "2": "غیرنیازسنجی",
            //         "3": "همه",
            //     },
            //     pickListProperties: {
            //         showFilterEditor: false
            //     },
            //     defaultValue:  ["3"]
            // },
        ]
    });

    var initialLayoutStyle = "vertical";
    var DynamicForm_SelectCourses_JspCoursesPassedPersonnel = isc.DynamicForm.create({
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
                optionDataSource: RestDataSource_Course_JspCoursesPassedPersonnel
            }
        ]
    });
    DynamicForm_SelectCourses_JspCoursesPassedPersonnel.getField("course.code").comboBox.setHint("دوره های مورد نظر را انتخاب کنید");
    DynamicForm_SelectCourses_JspCoursesPassedPersonnel.getField("course.code").comboBox.pickListFields =
        [{name: "titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"},
            {
                name: "code", title: "کد دوره", width: "30%", filterOperator: "iContains"
            }];
    DynamicForm_SelectCourses_JspCoursesPassedPersonnel.getField("course.code").comboBox.filterFields = ["titleFa", "code"];

    IButton_ConfirmCourseSelections_JspCoursesPassedPersonnel = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            var criteriaDisplayValues = "";
            var selectorDisplayValues = DynamicForm_SelectCourses_JspCoursesPassedPersonnel.getItem("course.code").getValue();
            if (DynamicForm_CriteriaForm_JspCoursesPassedPersonnel.getField("courseCode").getValue() != undefined
                && DynamicForm_CriteriaForm_JspCoursesPassedPersonnel.getField("courseCode").getValue() != "") {
                criteriaDisplayValues = DynamicForm_CriteriaForm_JspCoursesPassedPersonnel.getField("courseCode").getValue();
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
            DynamicForm_CriteriaForm_JspCoursesPassedPersonnel.getField("courseCode").setValue(criteriaDisplayValues);
            Window_SelectCourses_JspCoursesPassedPersonnel.close();
        }
    });

    var Window_SelectCourses_JspCoursesPassedPersonnel = isc.Window.create({
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
                    DynamicForm_SelectCourses_JspCoursesPassedPersonnel,
                    IButton_ConfirmCourseSelections_JspCoursesPassedPersonnel
                ]
            })
        ]
    });

    var DynamicForm_SelectClasses_JspCoursesPassedPersonnel = isc.DynamicForm.create({
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
                optionDataSource: RestDataSource_Class_JspCoursesPassedPersonnel
            }
        ]
    });

    DynamicForm_SelectClasses_JspCoursesPassedPersonnel.getField("class.code").comboBox.setHint("کلاسهای مورد نظر را انتخاب کنید");
    DynamicForm_SelectClasses_JspCoursesPassedPersonnel.getField("class.code").comboBox.pickListFields =
        [
            {name: "titleClass", title: "نام کلاس", width: "30%", filterOperator: "iContains"},
            {name: "code", title: "کد کلاس", width: "30%", filterOperator: "iContains"},
            {name: "course.titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"}];
    DynamicForm_SelectClasses_JspCoursesPassedPersonnel.getField("class.code").comboBox.filterFields = ["titleClass", "code", "course.titleFa"];

    IButton_ConfirmClassesSelections_JspCoursesPassedPersonnel = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            let criteriaDisplayValues = "";
            let selectorDisplayValues = DynamicForm_SelectClasses_JspCoursesPassedPersonnel.getItem("class.code").getValue();
            if (DynamicForm_SelectClasses_JspCoursesPassedPersonnel.getField("class.code").getValue() != undefined && DynamicForm_SelectClasses_JspCoursesPassedPersonnel.getField("class.code").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectClasses_JspCoursesPassedPersonnel.getField("class.code").getValue().join(",");
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

            DynamicForm_CriteriaForm_JspCoursesPassedPersonnel.getField("classCode").setValue(criteriaDisplayValues);
            Window_SelectClasses_JspCoursesPassedPersonnel.close();
        }
    });

    var Window_SelectClasses_JspCoursesPassedPersonnel = isc.Window.create({
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
                    DynamicForm_SelectClasses_JspCoursesPassedPersonnel,
                    IButton_ConfirmClassesSelections_JspCoursesPassedPersonnel,
                ]
            })
        ]
    });

    var DynamicForm_SelectCourses_JspCoursesPassedPersonnelReport = isc.DynamicForm.create({
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
                optionDataSource: RestDataSource_Course_JspCoursesPassedPersonnelReport
            }
        ]
    });
    DynamicForm_SelectCourses_JspCoursesPassedPersonnelReport.getField("courseCode").comboBox.setHint("دوره های مورد نظر را انتخاب کنید");
    DynamicForm_SelectCourses_JspCoursesPassedPersonnelReport.getField("courseCode").comboBox.pickListFields =
        [{name: "titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"},
            {
                name: "code", title: "کد دوره", width: "30%", filterOperator: "iContains"
            }];
    DynamicForm_SelectCourses_JspCoursesPassedPersonnelReport.getField("courseCode").comboBox.filterFields = ["titleFa", "code"];

    IButton_ConfirmCourseSelections_JspCoursesPassedPersonnelReport = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            var criteriaDisplayValues = "";
            var selectorDisplayValues = DynamicForm_SelectCourses_JspCoursesPassedPersonnelReport.getItem("courseCode").getValue();
            if (DynamicForm_CriteriaForm_JspCoursesPassedPersonnel.getField("courseCode").getValue() != undefined
                && DynamicForm_CriteriaForm_JspCoursesPassedPersonnel.getField("courseCode").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectCourses_JspCoursesPassedPersonnelReport.getField("courseCode").getValue().join(",");
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

            DynamicForm_CriteriaForm_JspCoursesPassedPersonnel.getField("courseCode").setValue(criteriaDisplayValues);
            Window_SelectCourses_JspCoursesPassedPersonnelReport.close();
        }
    });

    var Window_SelectCourses_JspCoursesPassedPersonnelReport = isc.Window.create({
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
                    DynamicForm_SelectCourses_JspCoursesPassedPersonnelReport,
                    IButton_ConfirmCourseSelections_JspCoursesPassedPersonnelReport
                ]
            })
        ]
    });

    IButton_JspCoursesPassedPersonnel = isc.IButtonSave.create({
        top: 260,
        title: "چاپ گزارش",
        width: 300,
        click: function () {

            // if(DynamicForm_CriteriaForm_JspCoursesPassedPersonnel.getValuesAsAdvancedCriteria().criteria.size() <= 1) {
            //     createDialog("info","فیلتری انتخاب نشده است.");
            //     return;
            // }

            DynamicForm_CriteriaForm_JspCoursesPassedPersonnel.validate();
            if (DynamicForm_CriteriaForm_JspCoursesPassedPersonnel.hasErrors())
                return;

            else{
                data_values = DynamicForm_CriteriaForm_JspCoursesPassedPersonnel.getValuesAsAdvancedCriteria();
                for (var i = 0; i < data_values.criteria.size(); i++) {
                    // if (data_values.criteria[i].fieldName == "courseCode") {
                    //     var codesString = data_values.criteria[i].value;
                    //     var codesArray;
                    //     codesArray = codesString.split(",");
                    //     for (var j = 0; j < codesArray.length; j++) {
                    //         if (codesArray[j] == "" || codesArray[j] == " ") {
                    //             codesArray.remove(codesArray[j]);
                    //         }
                    //     }
                    //     data_values.criteria[i].operator = "inSet";
                    //     data_values.criteria[i].value = codesArray;
                    // }
                    //
                    // else if (data_values.criteria[i].fieldName == "classCode") {
                    //     var codesString = data_values.criteria[i].value;
                    //     var codesArray;
                    //     codesArray = codesString.split(",");
                    //     for (var j = 0; j < codesArray.length; j++) {
                    //         if (codesArray[j] == "" || codesArray[j] == " ") {
                    //             codesArray.remove(codesArray[j]);
                    //         }
                    //     }
                    //     data_values.criteria[i].operator = "inSet";
                    //     data_values.criteria[i].value = codesArray;
                    // }
                    //
                    // else if (data_values.criteria[i].fieldName == "instituteId") {
                    //     data_values.criteria[i].fieldName = "instituteId";
                    //     data_values.criteria[i].operator = "equals";
                    // }

                     if (data_values.criteria[i].fieldName == "complexTitle") {
                        data_values.criteria[i].fieldName = "complexTitle";
                        data_values.criteria[i].operator = "iContains";
                    }

                    // else if (data_values.criteria[i].fieldName == "classStudentApplicantCompanyName") {
                    //     data_values.criteria[i].fieldName = "classStudentApplicantCompanyName";
                    //     data_values.criteria[i].operator = "iContains";
                    // }
                    // else if (data_values.criteria[i].fieldName == "studentCcpAssistant") {
                    //     data_values.criteria[i].fieldName = "studentCcpAssistant";
                    //     data_values.criteria[i].operator = "iContains";
                    // }
                    // else if (data_values.criteria[i].fieldName == "studentCcpUnit") {
                    //     data_values.criteria[i].fieldName = "studentCcpUnit";
                    //     data_values.criteria[i].operator = "iContains";
                    // }
                    // else if (data_values.criteria[i].fieldName == "studentCcpAffairs") {
                    //     data_values.criteria[i].fieldName = "studentCcpAffairs";
                    //     data_values.criteria[i].operator = "iContains";
                    // }
                    // else if (data_values.criteria[i].fieldName == "studentCcpSection") {
                    //     data_values.criteria[i].fieldName = "studentCcpSection";
                    //     data_values.criteria[i].operator = "iContains";
                    // }
                    // else if (data_values.criteria[i].fieldName == "courseTitleFa") {
                    //     data_values.criteria[i].fieldName = "courseTitleFa";
                    //     data_values.criteria[i].operator = "iContains";
                    // }
                    // else if (data_values.criteria[i].fieldName == "startDate1") {
                    //     data_values.criteria[i].fieldName = "classStartDate";
                    //     data_values.criteria[i].operator = "greaterThan";
                    // }
                    // else if (data_values.criteria[i].fieldName == "startDate2") {
                    //     data_values.criteria[i].fieldName = "classStartDate";
                    //     data_values.criteria[i].operator = "lessThan";
                    // }
                    // else if (data_values.criteria[i].fieldName == "endDate1") {
                    //     data_values.criteria[i].fieldName = "classEndDate";
                    //     data_values.criteria[i].operator = "greaterThan";
                    // }
                    // else if (data_values.criteria[i].fieldName == "endDate2") {
                    //     data_values.criteria[i].fieldName = "classEndDate";
                    //     data_values.criteria[i].operator = "lessThan";
                    // }
                    // else if (data_values.criteria[i].fieldName == "classPlanner") {
                    //     data_values.criteria[i].fieldName = "classPlanner";
                    //     data_values.criteria[i].operator = "equals";
                    // }
                    //
                    // else if (data_values.criteria[i].fieldName == "classSupervisor") {
                    //     data_values.criteria[i].fieldName = "classSupervisor";
                    //     data_values.criteria[i].operator = "equals";
                    // }
                    //
                    // else if (data_values.criteria[i].fieldName == "courseTeacherId") {
                    //     data_values.criteria[i].fieldName = "courseTeacherId";
                    //     data_values.criteria[i].operator = "equals";
                    // }
                    //
                    // else if (data_values.criteria[i].fieldName == "classYear") {
                    //     data_values.criteria[i].fieldName = "classYear";
                    //     data_values.criteria[i].operator = "iContains";
                    // }
                    //
                    // else if (data_values.criteria[i].fieldName == "termId") {
                    //     data_values.criteria[i].fieldName = "termId";
                    //     data_values.criteria[i].operator = "equals";
                    // }
                    //
                    // else if (data_values.criteria[i].fieldName == "courseCategory") {
                    //     data_values.criteria[i].fieldName = "courseCategory";
                    //     data_values.criteria[i].operator = "equals";
                    // }
                    //
                    // else if (data_values.criteria[i].fieldName == "courseSubCategory") {
                    //     data_values.criteria[i].fieldName = "courseSubCategory";
                    //     data_values.criteria[i].operator = "equals";
                    // }
                }

                ListGrid_JspCoursesPassedPersonnel.invalidateCache();
                ListGrid_JspCoursesPassedPersonnel.fetchData(data_values);
                Window_JspCoursesPassedPersonnel.show();
            }
        }
    });

    //----------------------------------- functions --------------------------------------------------------------------
    let Window_CriteriaForm_JspCoursesPassedPersonnel = isc.Window.create({
        placement: "fillScreen",
        title: "",
        showCloseButton: false,
        showMaximizeButton: false,
        canDragReposition: false,
        showMinimizeButton: false,
        canDragResize: false,
        closeClick: false,
        minimize: false,
        items: [DynamicForm_CriteriaForm_JspCoursesPassedPersonnel]
    });
    //----------------------------------- layOut -----------------------------------------------------------------------
    var HLayOut_CriteriaForm_JspCoursesPassedPersonnel = isc.TrHLayoutButtons.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "100%",
        alignLayout: "center",
        members: [
            Window_CriteriaForm_JspCoursesPassedPersonnel
        ]
    });

    var HLayOut_Confirm_JspCoursesPassedPersonnel = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_JspCoursesPassedPersonnel
        ]
    });

    var VLayout_Body_JspCoursesPassedPersonnel = isc.TrVLayout.create({
        members: [
            HLayOut_CriteriaForm_JspCoursesPassedPersonnel,
            HLayOut_Confirm_JspCoursesPassedPersonnel
        ]
    });
    //----------------------------------------------------End-----------------------------------------------------------
    Window_JspCoursesPassedPersonnel.hide();