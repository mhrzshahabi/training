<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
// <script>

    $(document).ready(()=>{
        setTimeout(()=>{
        $("input[name='personnelNo']").attr("disabled","disabled");
        $("input[name='courseCode']").attr("disabled","disabled");
        $("input[name='postGrade']").attr("disabled","disabled");
    },0)}
    );

    var startDate1Check_JspStaticalStudentClassReport = true;
    var startDate2Check_JspStaticalStudentClassReport = true;
    var startDateCheck_Order_JspStaticalStudentClassReport = true;
    var endDate1Check_JspStaticalStudentClassReport = true;
    var endDate2Check_JspStaticalStudentClassReport = true;
    var endDateCheck_Order_JspStaticalStudentClassReport = true;

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    ScoresStateDS_SCRV = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        cacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/StudentScoreState"
    });

    RestDataSource_JspStudentClassPersonnel = isc.TrDS.create({
        fields: [
            {name: "classStudentId", primaryKey: true, hidden: true},
            {name: "studentPersonnelNo2", title:"<spring:message code='personnel.no.6.digits'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentNationalCode", title:"<spring:message code='national.code'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentFirstName", title:"<spring:message code='firstName'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentLastName", title:"<spring:message code='lastName'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCcpAffairs", title:"<spring:message code='affairs'/>", filterOperator: "iContains", autoFitWidth: true},
	        {name: "studentCcpUnit", title:"<spring:message code='unit'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentPostCode", title:"<spring:message code='post.code'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentPostTitle", title:"<spring:message code='post.title'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseCode", title:"<spring:message code='corse_code'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseTitleFa", title:"<spring:message code='course'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classHDuration", title:"<spring:message code="duration"/>", autoFitWidth: true, filterOperator: "equals"},
            {name: "classStartDate", title:"<spring:message code="start.date"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classEndDate",title:"<spring:message code="end.date"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classStudentScore", title:"<spring:message code="score"/>", filterOperator: "equals", autoFitWidth: true},
            {name: "classStudentScoresState", title:"<spring:message code="score.state"/>", filterOperator: "equals", autoFitWidth: true,displayField: "title", valueField: "id",optionDataSource: ScoresStateDS_SCRV,},
        ],
        fetchDataURL: studentClassReportUrl
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
            {name: "postGradeTitle", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
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
            criteria:[{fieldName: "deleted", operator: "equals", value: 0}]
        },
    });

    RestDataSource_Class_JspStudentClassPersonnel = isc.TrDS.create({
        ID: "classDS",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleClass"},
            {name: "code"},
            {name: "course.titleFa"}
        ],
        fetchDataURL: classUrl + "info-tuple-list"
    });

    RestDataSource_Category_JspStudentClassReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "spec-list"
    });

    RestDataSource_Course_JspStudentClassReport = isc.TrDS.create({
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

    var RestDataSource_PostGradeLvl_PCNR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "peopleType", title: "<spring:message code="people.type"/>",filterOnKeypress: true, filterOperator: "equals", autoFitWidth: true, valueMap:peopleTypeMap},
            {
                name: "code",
                title: "<spring:message code="post.grade.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains"},
            {
                name: "enabled",
                title: "<spring:message code="active.status"/>",
                align: "center",
                filterOperator: "equals",
                autoFitWidth: true,
                autoFitWidthApproach: "both",
                valueMap:{
                    74 : "غیر فعال"
                },filterOnKeypress: true,
            },
        ],
        fetchDataURL: viewPostGradeUrl + "/iscList"
    });

    RestDataSource_Term_JspStudentClassReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="term.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach:true},
        ],
        fetchDataURL: termUrl + "spec-list"
    });
    //----------------------------------------------------ListGrid Result-----------------------------------------------
    var ListGrid_JspStudentClassPersonnel = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource : RestDataSource_JspStudentClassPersonnel,
        cellHeight: 43,
        initialSort: [
            {property: "classStudentId", direction: "ascending",primarySort: true}
        ],
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        selectionType: "single",
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        border: "1px solid #4a4444",
        margin: 5
    });

    IButton_JspStudentClassPersonnel_FullExcel = isc.IButtonSave.create({
        top: 260,
        title: "گزارش اکسل",
        width: 300,
        click: function () {
            ExportToFile.downloadExcelRestUrl(null, ListGrid_JspStudentClassPersonnel, studentClassReportUrl, 0, null, '',  "گزارش دوره های گذرانده پرسنل", ListGrid_JspStudentClassPersonnel.data.getCriteria(), null);
        }
    });

    var HLayOut_CriteriaForm_JspStudentClassPersonnel_Details = isc.TrHLayoutButtons.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "100%",
        alignLayout: "center",
        members: [
            ListGrid_JspStudentClassPersonnel
        ]
    });

    var HLayOut_Confirm_JspStudentClassPersonnel_StudentClassExcel = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_JspStudentClassPersonnel_FullExcel
        ]
    });

    var Window_JspStudentClassPersonnel = isc.Window.create({
        placement: "fillScreen",
        title: "گزارش دوره های گذرانده پرسنل",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [
            isc.TrVLayout.create({
                members: [
                    HLayOut_CriteriaForm_JspStudentClassPersonnel_Details,HLayOut_Confirm_JspStudentClassPersonnel_StudentClassExcel
                ]
            })
        ]
    });
    //----------------------------------------------------Criteria Form------------------------------------------------
    var DynamicForm_CriteriaForm_JspStudentClassPersonnel = isc.DynamicForm.create({
        align: "right",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 6,
        colWidths: ["5%", "25%", "5%", "25%","5%","25%"],
        fields: [
            {
                name: "personnelNo",
                title: "شماره پرسنلي",
                hint: "شماره پرسنلي را انتخاب نمایید",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                        Window_SelectPeople_JspStudentClass.show();
                    }}],
                keyPressFilter: "[A-Z|0-9|,-]"
            },
            {
                name: "classStudentScoresState",
                title: "<spring:message code="score.state"/>",
                optionDataSource: ScoresStateDS_SCRV,
                type: "SelectItem",
                // criteriaField: "value",
                pickListProperties: {
                    showFilterEditor: false,
                    // showClippedValuesOnHover: true,
                },
                pickListFields: [
                    {name: "title"},
                    // {name: "id", hidden: true}
                ],
                multiple: true,
                valueField: "id",
                displayField: "title",
            },
            {
                name: "temp1",
                title: "",
                canEdit: false
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
                name: "unit",
                title: "<spring:message code="unit"/>",
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
                name: "courseCode",
                title: "کد دوره",
                hint: "کد دوره را وارد نمایید",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                        Window_SelectCourses_JspStudentClassReport.show();
                    }
                }],
                keyPressFilter: "[A-Z|0-9|;-]"
            },
            {
                name: "termId",
                title: "<spring:message code="term"/>",
                type: "SelectItem",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                multiple: true,
                valueField: "id",
                displayField: "titleFa",
                initialSort: [
                    {property: "titleFa", direction: "descending", primarySort: true}
                ],
                optionDataSource: RestDataSource_Term_JspStudentClassReport,
            },
            {
                name: "temp1",
                title: "",
                canEdit: false
            },
            {
                name: "startDate1",
                ID: "startDate1_JspStaticalStudentClassReport",
                title: "تاریخ شروع کلاس: از",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate1_JspStaticalStudentClassReport', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("startDate2","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("startDate1", true);
                        startDateCheck_Order_JspStaticalStudentClassReport = true;
                        startDate1Check_JspStaticalStudentClassReport = true;
                        return;
                    }

                    var dateCheck;
                    var endDate = form.getValue("startDate2");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        startDate1Check_JspStaticalStudentClassReport = false;
                        startDateCheck_Order_JspStaticalStudentClassReport = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        startDateCheck_Order_JspStaticalStudentClassReport = false;
                        startDate1Check_JspStaticalStudentClassReport = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    }
                    else {
                        startDate1Check_JspStaticalStudentClassReport = true;
                        startDateCheck_Order_JspStaticalStudentClassReport = true;
                        form.clearFieldErrors("startDate1", true);
                    }
                }
            },
            {
                name: "startDate2",
                ID: "startDate2_JspStaticalStudentClassReport",
                title: "تا",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate2_JspStaticalStudentClassReport', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("startDate1","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("startDate2", true);
                        startDateCheck_Order_JspStaticalStudentClassReport = true;
                        startDate2Check_JspStaticalStudentClassReport = true;
                        return;
                    }

                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("startDate1");
                    if (dateCheck === false) {
                        startDate2Check_JspStaticalStudentClassReport = false;
                        startDateCheck_Order_JspStaticalStudentClassReport = true;
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "<spring:message code='msg.correct.date'/>", true);
                    } else if (startDate != undefined && value < startDate) {
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        startDate2Check_JspStaticalStudentClassReport = true;
                        startDateCheck_Order_JspStaticalStudentClassReport = false;
                    } else {
                        form.clearFieldErrors("startDate2", true);
                        startDate2Check_JspStaticalStudentClassReport = true;
                        startDateCheck_Order_JspStaticalStudentClassReport = true;
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
        ],
    });

    var initialLayoutStyle = "vertical";

    var DynamicForm_SelectPeople_JspStudentClass = isc.DynamicForm.create({
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

    DynamicForm_SelectPeople_JspStudentClass.getField("people.code").comboBox.setHint("پرسنل مورد نظر را انتخاب کنید");
    DynamicForm_SelectPeople_JspStudentClass.getField("people.code").comboBox.pickListFields =
            [
                {name: "firstName", title: "نام", autoFitWidth:true, filterOperator: "iContains"},
                {name: "lastName", title: "نام خانوادگي", autoFitWidth:true, filterOperator: "iContains"},
                {name: "nationalCode", title: "کدملي", autoFitWidth:true, filterOperator: "iContains"},
                {name: "personnelNo", title: "کد پرسنلي", autoFitWidth:true, filterOperator: "iContains"},
                {name: "personnelNo2", title: "کد پرسنلي 6 رقمي",autoFitWidth:true, filterOperator: "iContains"},
            ];
    DynamicForm_SelectPeople_JspStudentClass.getField("people.code").comboBox.filterFields = ["firstName","lastName","nationalCode","personnelNo","personnelNo2"];

    IButton_ConfirmPeopleSelections_JspStudentClass = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            let criteriaDisplayValues = "";
            let selectorDisplayValues = DynamicForm_SelectPeople_JspStudentClass.getItem("people.code").getValue();
            if (DynamicForm_SelectPeople_JspStudentClass.getField("people.code").getValue() != undefined && DynamicForm_SelectPeople_JspStudentClass.getField("people.code").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectPeople_JspStudentClass.getField("people.code").getValue().join(",");
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

            DynamicForm_CriteriaForm_JspStudentClassPersonnel.getField("personnelNo").setValue(criteriaDisplayValues);
            Window_SelectPeople_JspStudentClass.close();
        }
    });

    var Window_SelectPeople_JspStudentClass = isc.Window.create({
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
                    DynamicForm_SelectPeople_JspStudentClass,
                    IButton_ConfirmPeopleSelections_JspStudentClass,
                ]
            })
        ]
    });

    var DynamicForm_SelectPostGrade_JspStudentClass = isc.DynamicForm.create({
        align: "center",
        titleWidth: 0,
        titleAlign: "center",
        width: 500,
        height: 300,
        fields: [
            {
                name: "PostGrade.code",
                align: "center",
                title: "",
                editorType: "MultiComboBoxItem",
                multiple: true,
                defaultValue: null,
                changeOnKeypress: true,
                showHintInField: true,
                displayField: "titleFa",
                comboBoxWidth: 500,
                valueField: "id",
                layoutStyle: initialLayoutStyle,
                optionDataSource: RestDataSource_PostGradeLvl_PCNR,
            },
        ]
    });

    DynamicForm_SelectPostGrade_JspStudentClass.getField("PostGrade.code").comboBox.setHint("رده پستی مورد نظر را انتخاب کنید");
    DynamicForm_SelectPostGrade_JspStudentClass.getField("PostGrade.code").comboBox.pickListFields =
            [
                {name: "titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains"},
                {name: "peopleType",  title: "نوع فراگیر",valueMap: {"personnel_registered": "متفرقه", "Personal": "شرکتی", "ContractorPersonal": "پیمانکار"}},
                {name: "enabled", title: "فعال/غیرفعال", valueMap: {"undefined": "فعال", "74": "غیرفعال"}}
            ];
    DynamicForm_SelectPostGrade_JspStudentClass.getField("PostGrade.code").comboBox.filterFields = ["titleFa","peopleType","enabled"];

    IButton_ConfirmPostGradeSelections_JspStudentClass = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            let criteriaDisplayValues = "";
            let selectorDisplayValues = DynamicForm_SelectPostGrade_JspStudentClass.getItem("PostGrade.code").getValue();
            if (DynamicForm_SelectPostGrade_JspStudentClass.getField("PostGrade.code").getValue() != undefined && DynamicForm_SelectPostGrade_JspStudentClass.getField("PostGrade.code").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectPostGrade_JspStudentClass.getField("PostGrade.code").getValue().join(",");
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

            criteriaDisplayValuesPostGrade=criteriaDisplayValues;
            DynamicForm_CriteriaForm_JspStudentClassPersonnel.getField("postGrade").setValue(DynamicForm_SelectPostGrade_JspStudentClass.getItem("PostGrade.code").getDisplayValue().join(","));
            Window_SelectPostGrade_JspStudentClass.close();
        }
    });

    var Window_SelectPostGrade_JspStudentClass = isc.Window.create({
        placement: "center",
        title: "انتخاب رده پستی",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "2px solid gray",
        width: 500,
        height: 300,
        items: [
            isc.TrVLayout.create({
                members: [
                    DynamicForm_SelectPostGrade_JspStudentClass,
                    IButton_ConfirmPostGradeSelections_JspStudentClass,
                ]
            })
        ]
    });

    var DynamicForm_SelectCourses_JspStudentClassReport = isc.DynamicForm.create({
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
                optionDataSource: RestDataSource_Course_JspStudentClassReport
            }
        ]
    });
    DynamicForm_SelectCourses_JspStudentClassReport.getField("courseCode").comboBox.setHint("دوره های مورد نظر را انتخاب کنید");
    DynamicForm_SelectCourses_JspStudentClassReport.getField("courseCode").comboBox.pickListFields =
            [{name: "titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"},
                {
                    name: "code", title: "کد دوره", width: "30%", filterOperator: "iContains"
                }];
    DynamicForm_SelectCourses_JspStudentClassReport.getField("courseCode").comboBox.filterFields = ["titleFa", "code"];

    IButton_ConfirmCourseSelections_JspStudentClassReport = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            var criteriaDisplayValues = "";
            var selectorDisplayValues = DynamicForm_SelectCourses_JspStudentClassReport.getItem("courseCode").getValue();
            if (DynamicForm_SelectCourses_JspStudentClassReport.getField("courseCode").getValue() != undefined
                    && DynamicForm_SelectCourses_JspStudentClassReport.getField("courseCode").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectCourses_JspStudentClassReport.getField("courseCode").getValue().join(",");
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

            criteriaDisplayValues = criteriaDisplayValues == "undefined" ? "" : criteriaDisplayValues;

            DynamicForm_CriteriaForm_JspStudentClassPersonnel.getField("courseCode").setValue(criteriaDisplayValues);
            Window_SelectCourses_JspStudentClassReport.close();
        }
    });

    var Window_SelectCourses_JspStudentClassReport = isc.Window.create({
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
                    DynamicForm_SelectCourses_JspStudentClassReport,
                    IButton_ConfirmCourseSelections_JspStudentClassReport
                ]
            })
        ]
    });

    IButton_JspStudentClassPersonnel = isc.IButtonSave.create({
        top: 260,
        title: "چاپ گزارش",
        width: 300,
        click: function () {
            if(DynamicForm_CriteriaForm_JspStudentClassPersonnel.getValuesAsAdvancedCriteria()==null) {
                createDialog("info","فیلتری انتخاب نشده است.");
                return;
            }
            DynamicForm_CriteriaForm_JspStudentClassPersonnel.validate();
            if (DynamicForm_CriteriaForm_JspStudentClassPersonnel.hasErrors())
                return;

            else{
                data_values = DynamicForm_CriteriaForm_JspStudentClassPersonnel.getValuesAsAdvancedCriteria();
                for (let i = 0; i < data_values.criteria.size(); i++) {
                    if (data_values.criteria[i].fieldName == "personnelNo") {
                        var codesString = data_values.criteria[i].value;
                        var codesArray;
                        codesArray = codesString.split(",");
                        for (var j = 0; j < codesArray.length; j++) {
                            if (codesArray[j] == "" || codesArray[j] == " ") {
                                codesArray.remove(codesArray[j]);
                            }
                        }

                        data_values.criteria[i].fieldName = "studentPersonnelNo";
                        data_values.criteria[i].operator = "inSet";
                        data_values.criteria[i].value = codesArray;
                    }

                    else if (data_values.criteria[i].fieldName == "classStudentScoresState") {
                        data_values.criteria[i].operator = "inSet";
                    }

                    else if (data_values.criteria[i].fieldName == "courseCode") {
                        var codesString = data_values.criteria[i].value;
                        var codesArray;
                        codesArray = codesString.split(",");
                        for (var j = 0; j < codesArray.length; j++) {
                            if (codesArray[j] == "" || codesArray[j] == " ") {
                                codesArray.remove(codesArray[j]);
                            }
                        }
                        data_values.criteria[i].operator = "inSet";
                        data_values.criteria[i].value = codesArray;
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

                    else if (data_values.criteria[i].fieldName == "companyName") {
                        data_values.criteria[i].fieldName = "studentCompanyName";
                        data_values.criteria[i].operator = "iContains";
                    }
                    else if (data_values.criteria[i].fieldName == "assistant") {
                        data_values.criteria[i].fieldName = "studentCcpAssistant";
                        data_values.criteria[i].operator = "iContains";
                    }
                    else if (data_values.criteria[i].fieldName == "unit") {
                        data_values.criteria[i].fieldName = "studentCcpUnit";
                        data_values.criteria[i].operator = "iContains";
                    }
                    else if (data_values.criteria[i].fieldName == "affairs") {
                        data_values.criteria[i].fieldName = "studentCcpAffairs";
                        data_values.criteria[i].operator = "iContains";
                    }
                    else if (data_values.criteria[i].fieldName == "section") {
                        data_values.criteria[i].fieldName = "studentCcpSection";
                        data_values.criteria[i].operator = "iContains";
                    }

                    else if (data_values.criteria[i].fieldName == "complexTitle") {
                        data_values.criteria[i].fieldName = "studentComplexTitle";
                        data_values.criteria[i].operator = "iContains";
                    }

                    else if (data_values.criteria[i].fieldName == "termId") {
                        data_values.criteria[i].operator = "inSet";
                    }
                }

                ListGrid_JspStudentClassPersonnel.invalidateCache();
                ListGrid_JspStudentClassPersonnel.fetchData(data_values);
                Window_JspStudentClassPersonnel.show();
            }
        }
    });

    //----------------------------------- layOut -----------------------------------------------------------------------
    var HLayOut_CriteriaForm_JspStudentClassPersonnel = isc.TrHLayoutButtons.create({
        showEdges: false,
        margin:20,
        edgeImage: "",
        width: "100%",
        height: "100%",
        alignLayout: "center",
        members: [
            DynamicForm_CriteriaForm_JspStudentClassPersonnel
        ]
    });

    var HLayOut_Confirm_JspStudentClassPersonnel = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_JspStudentClassPersonnel
        ]
    });

    isc.TrVLayout.create({
        members: [
            HLayOut_CriteriaForm_JspStudentClassPersonnel,
            HLayOut_Confirm_JspStudentClassPersonnel
        ]
    });
    //----------------------------------------------------End-----------------------------------------------------------
    Window_JspStudentClassPersonnel.hide();