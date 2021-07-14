<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
// <script>
    $(document).ready(()=>{
        setTimeout(()=>{
            $("input[name='studentPersonnelNo']").attr("disabled","disabled");
            $("input[name='classCode']").attr("disabled","disabled");
        },0)}
    );

    var startDate1Check_JspStaticalUnitReport = true;
    var startDate2Check_JspStaticalUnitReport = true;
    var startDateCheck_Order_JspStaticalUnitReport = true;
    var endDate1Check_JspStaticalUnitReport = true;
    var endDate2Check_JspStaticalUnitReport = true;
    var endDateCheck_Order_JspStaticalUnitReport = true;

    let presenceReport_Criteria = null;

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    RestDataSource_JspAttendanceReport = isc.TrDS.create({
        fields: [
            {name: "studentFirstName", title:"<spring:message code='firstName'/>", filterOperator: "iContains",autoFitWidth: true},
            {name: "studentLastName", title:"<spring:message code='lastName'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentNationalCode", title:"<spring:message code='national.code'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "presenceHour", title:"حضور بر حسب ساعت", filterOperator: "equals", autoFitWidth: true},
            {name: "presenceMinute", title:"حضور بر حسب دقیقه", filterOperator: "equals", autoFitWidth: true},
            {name: "absenceHour", title:"غیبت بر حسب ساعت", filterOperator: "equals", autoFitWidth: true},
            {name: "absenceMinute", title:"غیبت بر حسب دقیقه", filterOperator: "equals", autoFitWidth: true},
            {name: "classId", hidden: true, filterOperator: "equals", autoFitWidth: true},
            {name: "classCode", title:"<spring:message code="class.code"/>", filterOperator: "inSet", autoFitWidth: true},
            {name: "classStartDate", title:"<spring:message code="start.date"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classEndDate", title:"<spring:message code="end.date"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "holdingClassTypeTitle", title:"<spring:message code="course_eruntype"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "teachingMethodTitle", title:"<spring:message code="teaching.type"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "sessionDate", title:"تاریخ جلسه", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentId", hidden: true, filterOperator: "equals", autoFitWidth: true},
            {name: "studentPersonnelNo", title:"<spring:message code='personnel.no'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentPersonnelNo2", title:"<spring:message code='personnel.no.6.digits'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCcpAssistant", title:"<spring:message code='assistance'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCcpAffairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCcpSection", title:"<spring:message code='section'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCcpUnit", title:"<spring:message code='unit'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classStudentApplicantCompanyName", title:"<spring:message code='company.applicant'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelComplexTitle", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseId", hidden: true, title:"<spring:message code='identity'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "courseCode", title:"<spring:message code='course.code'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseTitleFa", title:"<spring:message code='course'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseRunType", title:"<spring:message code='course_eruntype'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseTheoType", title:"<spring:message code='course_etheoType'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseLevelType", title:"<spring:message code='cousre_elevelType'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseTechnicalType", title: "<spring:message code="technical.type"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "instituteId", hidden: true, title: "<spring:message code="identity"/>", filterOperator: "equals", autoFitWidth: true},
            {name: "instituteTitleFa", title: "<spring:message code="institute"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: presenceReportUrl
    });

    PersonnelDS_PTSR_DF = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains"},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "postCode", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "ccpArea", title: "<spring:message code="reward.cost.center.area"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "ccpAssistant", title: "<spring:message code="reward.cost.center.assistant"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "ccpAffairs", title: "<spring:message code="reward.cost.center.affairs"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "ccpSection", title: "<spring:message code="reward.cost.center.section"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "ccpUnit", title: "<spring:message code="reward.cost.center.unit"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
        ],
        fetchDataURL: personnelUrl + "/iscList",
        implicitCriteria: {
            _constructor:"AdvancedCriteria",
            operator:"and",
            criteria:[{ fieldName: "active", operator: "equals", value: 1},{ fieldName: "deleted", operator: "equals", value: 0}]
        },
    });

    var RestDataSource_Course_JspAttendanceReport = isc.TrDS.create({
        ID: "courseDS",
        fields: [
            {name: "id", type: "Integer", primaryKey: true},
            {name: "code"},
            {name: "titleFa"}
        ],
        fetchDataURL: courseUrl + "info-tuple-list"
    });

    var RestDataSource_Class_JspAttendancePresenceReport = isc.TrDS.create({
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
    //----------------------------------------------------ListGrid Result-----------------------------------------------
    var ListGrid_JspAttendanceReport = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource : RestDataSource_JspAttendanceReport,
        cellHeight: 43,
        sortField: 0,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        selectionType: "single",
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        overflow: "auto",
        autoFitExpandField: true,
        autoFitWidth: true,
        wrapCells: false,
        virtualScrolling: true,
        // headerBaseStyle: "jasper-report-form-header",
        initialSort: [
            {property: "studentId", direction: "ascending",primarySort: true}
        ],
    });

    IButton_JspAttendancePresenceReport_FullExcel = isc.IButtonSave.create({
        top: 260,
        title: "گزارش اکسل",
        width: 150,
        click: function () {
            ExportToFile.downloadExcelRestUrl(null, ListGrid_JspAttendanceReport, presenceReportUrl, 0, null, '', "گزارش حضور و غياب کلاس های آموزشي", ListGrid_JspAttendanceReport.getCriteria(), null);
        }
    });

    IButton_JspAttendancePresenceReport_Word = isc.IButtonSave.create({
        top: 260,
        title: "گزارش ورد",
        width: 150,
        click: function () {
            let result = ExportToFile.getAllData(ListGrid_JspAttendanceReport, null);
            let downloadForm = isc.DynamicForm.create({
                method: "POST",
                action: "/training/export-to-file/exportWordFromClient/",
                target: "_Blank",
                canSubmit: true,
                fields:
                    [
                        {name: "myToken", type: "hidden"},
                        {name: "fields", type: "hidden"},
                        {name: "criteriaStr", type: "hidden"},
                        {name: "titr", type: "hidden"},
                        {name: "pageName", type: "hidden"}
                    ]
            });
            downloadForm.setValue("fields", JSON.stringify(result.fields.toArray()));
            downloadForm.setValue("criteriaStr", JSON.stringify(presenceReport_Criteria));
            downloadForm.setValue("titr", "");
            downloadForm.setValue("pageName", "گزارش حضور و غياب کلاس های آموزشي");
            downloadForm.show();
            downloadForm.submitForm();
        }
    });

    var HLayOut_CriteriaForm_JspAttendanceReport_Details = isc.TrHLayoutButtons.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "100%",
        alignLayout: "center",
        members: [
            ListGrid_JspAttendanceReport
        ]
    });

    var HLayOut_Confirm_JspAttendanceReport_AttendanceExcel = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_JspAttendancePresenceReport_FullExcel,
            IButton_JspAttendancePresenceReport_Word
        ]
    });

    var Window_JspAttendanceReport = isc.Window.create({
        placement: "fillScreen",
        title: "گزارش حضور و غیاب کلاسهای آموزشی",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        width: "100%",
        border: "1px solid gray",
        items: [
            isc.TrVLayout.create({
                members: [
                    HLayOut_CriteriaForm_JspAttendanceReport_Details,HLayOut_Confirm_JspAttendanceReport_AttendanceExcel
                ]
            })
        ]
    });
    //----------------------------------------------------Criteria Form------------------------------------------------
    var DynamicForm_CriteriaForm_JspAttendanceReport = isc.DynamicForm.create({
        align: "right",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 6,
        colWidths: ["5%", "25%", "5%", "25%","5%","25%"],
        fields: [
            {
                name: "studentPersonnelNo",
                title: "شماره پرسنلي",
                hint: "شماره پرسنلي را انتخاب نمائيد",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                        Window_SelectPeople_JspUnitReport.show();
                    }}],
                keyPressFilter: "[A-Z|0-9|,-]"
            },
            {
                name: "temp0",
                title: "",
                canEdit: false
            },
            {
                name: "temp1",
                title: "",
                canEdit: false
            },
            {
                name: "personnelComplexTitle",
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
                name: "classStudentApplicantCompanyName",
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
                name: "studentCcpAssistant",
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
                name: "studentCcpSection",
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
                name: "studentCcpUnit",
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
                name: "studentCcpAffairs",
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
                name: "classCode",
                title: "کد کلاس",
                hint: "کد کلاس را انتخاب نمائيد",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                        Window_SelectClasses_JspAttendanceReport.show();
                    }}],
                keyPressFilter: "[A-Z|0-9|,-]"
            },
            {
                name: "temp2",
                title: "",
                canEdit: false
            },
            {
                name: "temp3",
                title: "",
                canEdit: false
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
                        displayDatePicker('startDate2_JspStaticalUnitReport', this, 'ymd', '/');
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
                name: "temp41",
                title: "",
                canEdit: false
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
                        displayDatePicker('endDate2_JspStaticalUnitReport', this, 'ymd', '/');
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
                name: "temp4",
                title: "",
                canEdit: false
            },
            {
                name: "sessionStartDate",
                title: "تاریخ جلسه: از",
                ID: "startDateSession_jspAttendanceReport",
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDateSession_jspAttendanceReport', this, 'ymd', '/');
                    }
                }],
                textAlign: "center",
                changed: function (form, item, value) {
                    var dateCheck;
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        form.addFieldErrors("sessionStartDate", "<spring:message code='msg.correct.date'/>", true);
                    } else {
                        form.clearFieldErrors("sessionStartDate", true);
                    }
                }
            },
            {
                name: "sessionEndDate",
                title: "تا",
                ID: "endDateSession_jspAttendanceReport",
                type: 'text',
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDateSession_jspAttendanceReport', this, 'ymd', '/');
                    }
                }],
                textAlign: "center",
                changed: function (form, item, value) {
                    let dateCheck;
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        form.clearFieldErrors("sessionEndDate", true);
                        form.addFieldErrors("sessionEndDate", "<spring:message code='msg.correct.date'/>", true);
                    } else {
                        form.clearFieldErrors("sessionEndDate", true);
                    }
                }
            }
        ]
    });

    var initialLayoutStyle = "vertical";
    var DynamicForm_SelectCourses_JspAttendanceReport = isc.DynamicForm.create({
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
                optionDataSource: RestDataSource_Course_JspAttendanceReport
            }
        ]
    });
    DynamicForm_SelectCourses_JspAttendanceReport.getField("course.code").comboBox.setHint("دوره های مورد نظر را انتخاب کنید");
    DynamicForm_SelectCourses_JspAttendanceReport.getField("course.code").comboBox.pickListFields =
        [{name: "titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"},
            {
                name: "code", title: "کد دوره", width: "30%", filterOperator: "iContains"
            }];
    DynamicForm_SelectCourses_JspAttendanceReport.getField("course.code").comboBox.filterFields = ["titleFa", "code"];

    IButton_ConfirmCourseSelections_JspAttendanceReport = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            var criteriaDisplayValues = "";
            var selectorDisplayValues = DynamicForm_SelectCourses_JspAttendanceReport.getItem("course.code").getValue();
            if (DynamicForm_CriteriaForm_JspAttendanceReport.getField("courseCode").getValue() != undefined
                && DynamicForm_CriteriaForm_JspAttendanceReport.getField("courseCode").getValue() != "") {
                criteriaDisplayValues = DynamicForm_CriteriaForm_JspAttendanceReport.getField("courseCode").getValue();
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
            DynamicForm_CriteriaForm_JspAttendanceReport.getField("courseCode").setValue(criteriaDisplayValues);
            Window_SelectCourses_JspAttendanceReport.close();
        }
    });

    var Window_SelectCourses_JspAttendanceReport = isc.Window.create({
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
                    DynamicForm_SelectCourses_JspAttendanceReport,
                    IButton_ConfirmCourseSelections_JspAttendanceReport
                ]
            })
        ]
    });

    var DynamicForm_SelectClasses_JspAttendanceReport = isc.DynamicForm.create({
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
                optionDataSource: RestDataSource_Class_JspAttendancePresenceReport
            }
        ]
    });

    DynamicForm_SelectClasses_JspAttendanceReport.getField("class.code").comboBox.setHint("کلاسهای مورد نظر را انتخاب کنید");
    DynamicForm_SelectClasses_JspAttendanceReport.getField("class.code").comboBox.pickListFields =
        [
            {name: "titleClass", title: "نام کلاس", width: "30%", filterOperator: "iContains"},
            {name: "code", title: "کد کلاس", width: "30%", filterOperator: "iContains"},
            {name: "course.titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"}];
    DynamicForm_SelectClasses_JspAttendanceReport.getField("class.code").comboBox.filterFields = ["titleClass", "code", "course.titleFa"];

    IButton_ConfirmClassesSelections_JspAttendanceReport = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            let criteriaDisplayValues = "";
            let selectorDisplayValues = DynamicForm_SelectClasses_JspAttendanceReport.getItem("class.code").getValue();
            if (DynamicForm_SelectClasses_JspAttendanceReport.getField("class.code").getValue() != undefined && DynamicForm_SelectClasses_JspAttendanceReport.getField("class.code").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectClasses_JspAttendanceReport.getField("class.code").getValue().join(",");
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

            criteriaDisplayValues = criteriaDisplayValues == "undefined" ? "" : criteriaDisplayValues;

            DynamicForm_CriteriaForm_JspAttendanceReport.getField("classCode").setValue(criteriaDisplayValues);
            Window_SelectClasses_JspAttendanceReport.close();
        }
    });

    var Window_SelectClasses_JspAttendanceReport = isc.Window.create({
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
                    DynamicForm_SelectClasses_JspAttendanceReport,
                    IButton_ConfirmClassesSelections_JspAttendanceReport,
                ]
            })
        ]
    });

    var initialLayoutStyle = "vertical";
    var DynamicForm_SelectPeople_JspUnitReport = isc.DynamicForm.create({
        align: "center",
        titleWidth: 0,
        titleAlign: "center",
        width: 500,
        height: 300,
        fields: [
            {
                name: "people.code",
                align: "center",
                title: "",
                editorType: "MultiComboBoxItem",
                multiple: true,
                defaultValue: null,
                changeOnKeypress: true,
                showHintInField: true,
                displayField: "personnelNo",
                comboBoxWidth: 500,
                valueField: "personnelNo",
                layoutStyle: initialLayoutStyle,
                optionDataSource: PersonnelDS_PTSR_DF
            }
        ]
    });

    DynamicForm_SelectPeople_JspUnitReport.getField("people.code").comboBox.setHint("پرسنل مورد نظر را انتخاب کنید");
    DynamicForm_SelectPeople_JspUnitReport.getField("people.code").comboBox.pickListFields =
        [
            {name: "firstName", title: "نام", autoFitWidth:true, filterOperator: "iContains"},
            {name: "lastName", title: "نام خانوادگي", autoFitWidth:true, filterOperator: "iContains"},
            {name: "nationalCode", title: "کدملي", autoFitWidth:true, filterOperator: "iContains"},
            {name: "personnelNo", title: "کد پرسنلي", autoFitWidth:true, filterOperator: "iContains"},
            {name: "personnelNo2", title: "کد پرسنلي 6 رقمي", autoFitWidth:true, filterOperator: "iContains"},
        ];
    DynamicForm_SelectPeople_JspUnitReport.getField("people.code").comboBox.filterFields = ["firstName","lastName","nationalCode","personnelNo","personnelNo2"];

    IButton_ConfirmPeopleSelections_JspUnitReport = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            let criteriaDisplayValues = "";
            let selectorDisplayValues = DynamicForm_SelectPeople_JspUnitReport.getItem("people.code").getValue();
            if (DynamicForm_SelectPeople_JspUnitReport.getField("people.code").getValue() != undefined && DynamicForm_SelectPeople_JspUnitReport.getField("people.code").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectPeople_JspUnitReport.getField("people.code").getValue().join(",");
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

            criteriaDisplayValues = criteriaDisplayValues == "undefined" ? "" : criteriaDisplayValues;

            DynamicForm_CriteriaForm_JspAttendanceReport.getField("studentPersonnelNo").setValue(criteriaDisplayValues);
            Window_SelectPeople_JspUnitReport.close();
        }
    });

    var Window_SelectPeople_JspUnitReport = isc.Window.create({
        placement: "center",
        title: "انتخاب پرسنل",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "2px solid gray",
        width: 500,
        height: 300,
        items: [
            isc.TrVLayout.create({
                members: [
                    DynamicForm_SelectPeople_JspUnitReport,
                    IButton_ConfirmPeopleSelections_JspUnitReport,
                ]
            })
        ]
    });

    IButton_JspAttendancePresenceReport = isc.IButtonSave.create({
        top: 260,
        title: "چاپ گزارش",
        width: 300,
        click: function () {

            presenceReport_Criteria = null;

            if(DynamicForm_CriteriaForm_JspAttendanceReport.getValuesAsAdvancedCriteria()==null) {
                createDialog("info","فیلتری انتخاب نشده است.");
                return;
            }

            DynamicForm_CriteriaForm_JspAttendanceReport.validate();
            if (DynamicForm_CriteriaForm_JspAttendanceReport.hasErrors())
                return;

            else{
                data_values = DynamicForm_CriteriaForm_JspAttendanceReport.getValuesAsAdvancedCriteria();
                for (let i = 0; i < data_values.criteria.size(); i++) {
                     if (data_values.criteria[i].fieldName == "classCode") {
                        let codesString = data_values.criteria[i].value;
                        let codesArray;
                        codesArray = codesString.split(",");
                        for (var j = 0; j < codesArray.length; j++) {
                            if (codesArray[j] == "" || codesArray[j] == " ") {
                                codesArray.remove(codesArray[j]);
                            }
                        }
                        data_values.criteria[i].operator = "inSet";
                        data_values.criteria[i].value = codesArray;
                    }

                    else if (data_values.criteria[i].fieldName == "studentPersonnelNo") {
                        let codesString = data_values.criteria[i].value;
                        let codesArray;
                        codesArray = codesString.split(",");
                        for (var j = 0; j < codesArray.length; j++) {
                            if (codesArray[j] == "" || codesArray[j] == " ") {
                                codesArray.remove(codesArray[j]);
                            }
                        }
                        data_values.criteria[i].operator = "inSet";
                        data_values.criteria[i].value = codesArray;
                    }

                    else if (data_values.criteria[i].fieldName == "personnelComplexTitle") {
                        data_values.criteria[i].fieldName = "personnelComplexTitle";
                        data_values.criteria[i].operator = "iContains";
                    }

                    else if (data_values.criteria[i].fieldName == "classStudentApplicantCompanyName") {
                        data_values.criteria[i].fieldName = "classStudentApplicantCompanyName";
                        data_values.criteria[i].operator = "iContains";
                    }
                    else if (data_values.criteria[i].fieldName == "studentCcpAssistant") {
                        data_values.criteria[i].fieldName = "studentCcpAssistant";
                        data_values.criteria[i].operator = "iContains";
                    }
                    else if (data_values.criteria[i].fieldName == "studentCcpUnit") {
                        data_values.criteria[i].fieldName = "studentCcpUnit";
                        data_values.criteria[i].operator = "iContains";
                    }
                    else if (data_values.criteria[i].fieldName == "studentCcpAffairs") {
                        data_values.criteria[i].fieldName = "studentCcpAffairs";
                        data_values.criteria[i].operator = "iContains";
                    }
                    else if (data_values.criteria[i].fieldName == "studentCcpSection") {
                        data_values.criteria[i].fieldName = "studentCcpSection";
                        data_values.criteria[i].operator = "iContains";
                    }

                     else if (data_values.criteria[i].fieldName == "startDate1") {
                         data_values.criteria[i].fieldName = "classStartDate";
                         data_values.criteria[i].operator = "greaterOrEqual";
                     }
                     else if (data_values.criteria[i].fieldName == "startDate2") {
                         data_values.criteria[i].fieldName = "classStartDate";
                         data_values.criteria[i].operator = "lessOrEqual";
                     }
                     else if (data_values.criteria[i].fieldName == "endDate1") {
                         data_values.criteria[i].fieldName = "classEndDate";
                         data_values.criteria[i].operator = "greaterOrEqual";
                     }
                     else if (data_values.criteria[i].fieldName == "endDate2") {
                         data_values.criteria[i].fieldName = "classEndDate";
                         data_values.criteria[i].operator = "lessOrEqual";
                     }

                     else if (data_values.criteria[i].fieldName == "sessionStartDate") {
                         data_values.criteria[i].fieldName = "sessionDate";
                         data_values.criteria[i].operator = "greaterOrEqual";
                     }

                     else if (data_values.criteria[i].fieldName == "sessionEndDate") {
                         data_values.criteria[i].fieldName = "sessionDate";
                         data_values.criteria[i].operator = "lessOrEqual";
                     }

                     else if (data_values.criteria[i].fieldName == "studentPersonnelNo") {
                         data_values.criteria[i].fieldName = "studentPersonnelNo";
                         data_values.criteria[i].operator = "iContains";
                     }

                    else if (data_values.criteria[i].fieldName == "studentPersonnelNo2") {
                        data_values.criteria[i].fieldName = "studentPersonnelNo2";
                        data_values.criteria[i].operator = "iContains";
                    }

                    else if (data_values.criteria[i].fieldName == "studentNationalCode") {
                        data_values.criteria[i].fieldName = "studentNationalCode";
                        data_values.criteria[i].operator = "iContains";
                    }

                     else if (data_values.criteria[i].fieldName == "studentFirstName") {
                         data_values.criteria[i].fieldName = "studentFirstName";
                         data_values.criteria[i].operator = "iContains";
                     }

                     else if (data_values.criteria[i].fieldName == "studentLastName") {
                         data_values.criteria[i].fieldName = "studentLastName";
                         data_values.criteria[i].operator = "iContains";
                     }
                }

                presenceReport_Criteria = data_values;
                ListGrid_JspAttendanceReport.invalidateCache();
                ListGrid_JspAttendanceReport.fetchData(data_values);
                Window_JspAttendanceReport.show();
            }
        }
    });

    //----------------------------------- functions --------------------------------------------------------------------
    let Window_CriteriaForm_JspAttendanceReport = isc.Window.create({
        placement: "fillScreen",
        title: "",
        showCloseButton: false,
        showMaximizeButton: false,
        canDragReposition: false,
        showMinimizeButton: false,
        canDragResize: false,
        closeClick: false,
        minimize: false,
        items: [DynamicForm_CriteriaForm_JspAttendanceReport]
    });
    //----------------------------------- layOut -----------------------------------------------------------------------
    var HLayOut_CriteriaForm_JspAttendanceReport = isc.TrHLayoutButtons.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "100%",
        alignLayout: "center",
        members: [
            Window_CriteriaForm_JspAttendanceReport
        ]
    });

    var HLayOut_Confirm_JspAttendanceReport = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_JspAttendancePresenceReport
        ]
    });

    var VLayout_Body_JspAttendanceReport = isc.TrVLayout.create({
        members: [
            HLayOut_CriteriaForm_JspAttendanceReport,
            HLayOut_Confirm_JspAttendanceReport
        ]
    });
    //----------------------------------------------------End-----------------------------------------------------------
    Window_JspAttendanceReport.hide();
