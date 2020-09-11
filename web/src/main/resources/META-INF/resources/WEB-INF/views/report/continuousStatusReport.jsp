<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
// <script>

    $(document).ready(()=>{
        setTimeout(()=>{
            $("input[name='personnelNo']").attr("disabled","disabled");
            $("input[name='classCode']").attr("disabled","disabled");
            $("input[name='postGrade']").attr("disabled","disabled");
        },0)}
    );

    let criteriaDisplayValuesPostGrade;
    var startDate1Check_JspcontinuousPersonnel = true;
    var startDate2Check_JspcontinuousPersonnel = true;
    var startDateCheck_Order_JspcontinuousPersonnel = true;
    var endDate1Check_JspcontinuousPersonnel = true;
    var endDate2Check_JspcontinuousPersonnel = true;
    var endDateCheck_Order_JspcontinuousPersonnel = true;
    //----------------------------------------------------Rest DataSource-----------------------------------------------
    RestDataSource_JspcontinuousPersonnel = isc.TrDS.create({
        fields: [
            {name: "personnelNo", title:"<spring:message code='personnel.no'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "empNo", title:"<spring:message code='personnel.no.6.digits'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title:"<spring:message code='national.code'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "firstName", title:"<spring:message code='firstName'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title:"<spring:message code='lastName'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "complexTitle", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "companyName", title:"<spring:message code='company.applicant'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "assistant", title:"<spring:message code='assistance'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "section", title:"<spring:message code='section'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "unit", title:"<spring:message code='unit'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postTitle", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postGradeTitle", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},

            {name: "courseCode", title:"<spring:message code='course.code'/>", autoFitWidth: true},
            {name: "courseTitleFa", title:"<spring:message code='course'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classCode", title:"<spring:message code='class.code'/>", autoFitWidth: true},


            {name: "termTitleFa", title:"<spring:message code='term'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classYear", title:"<spring:message code='year'/>", filterOperator: "iContains", autoFitWidth: true},

            {name: "classHDduration", title:"<spring:message code='course_theoryDuration'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classStartDate", title:"<spring:message code="start.date"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classEndDate", title:"<spring:message code="end.date"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classStatus", title:"وضعیت کلاس", filterOperator: "equals", autoFitWidth: true, valueMap: {
                    "1": "برنامه ریزی",
                    "2": "در حال اجرا"
                }},

            {name: "courseType", title:"وضعیت نیازسنجی", filterOperator: "iContains", autoFitWidth: true},
            {name: "naPriorityId", title:"اولویت نیازسنجی", filterOperator: "equals",  autoFitWidth: true, valueMap: {
                    "111" : "عملکردی ضروری",
                    "113" : "عملکردی توسعه",
                    "112" : "عملکردی بهبود",
                    "0" : ""
                }},

            {name: "termId", hidden: true, filterOperator: "equals"},
            {name: "courseId", hidden: true, filterOperator: "equals"},
        ],
        fetchDataURL: continuousStatusReportViewUrl
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
            criteria:[{ fieldName: "active", operator: "equals", value: 1}]
        },
    });

    var RestDataSource_Class_JspcontinuousPersonnel = isc.TrDS.create({
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

    var RestDataSource_Term_JspcontinuousPersonnel = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
        ]
    });

    var RestDataSource_Year_JspcontinuousPersonnel = isc.TrDS.create({
        fields: [
            {name: "year", primaryKey: true}
        ],
        fetchDataURL: termUrl + "yearList"
    });

    var RestDataSource_PostGradeLvl_PCNR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "code",
                title: "<spring:message code="post.grade.code"/>",
                filterOperator: "iContains",
            },
            {name: "titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains"},
            {name: "peopleType",  title: "نوع فراگیر",valueMap: {"personnel_registered": "متفرقه", "Personal": "شرکتی", "ContractorPersonal": "پیمانکار"}},
            {name: "enabled", title: "فعال/غیرفعال", valueMap: {"undefined": "فعال", "74": "غیرفعال"}}
        ],
        fetchDataURL: viewPostGradeUrl + "/iscList"
    });

    //----------------------------------------------------ListGrid Result-----------------------------------------------
    var ListGrid_JspcontinuousPersonnel = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource : RestDataSource_JspcontinuousPersonnel,
        cellHeight: 43,
        sortField: 0,
        showFilterEditor: false,
        selectionType: "single",
        showRecordComponents: true,
        showRecordComponentsByCell: true
    });

    IButton_JspcontinuousPersonnel_FullExcel = isc.IButtonSave.create({
        top: 260,
        title: "گزارش اکسل",
        width: 300,
        click: function () {
            ExportToFile.downloadExcel(null, ListGrid_JspcontinuousPersonnel, 'continuousPersonnel', 0, null, '',  "گزارش مستمر", ListGrid_JspcontinuousPersonnel.data.criteria, null);
        }
    });

    var HLayOut_CriteriaForm_JspcontinuousPersonnel_Details = isc.TrHLayoutButtons.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "100%",
        alignLayout: "center",
        members: [
            ListGrid_JspcontinuousPersonnel
        ]
    });

    var HLayOut_Confirm_JspcontinuousPersonnel_UnitExcel = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_JspcontinuousPersonnel_FullExcel
        ]
    });

    var Window_JspcontinuousPersonnel = isc.Window.create({
        placement: "fillScreen",
        title: "گزارش مستمر",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [
            isc.TrVLayout.create({
                members: [
                    HLayOut_CriteriaForm_JspcontinuousPersonnel_Details,HLayOut_Confirm_JspcontinuousPersonnel_UnitExcel
                ]
            })
        ]
    });
    //----------------------------------------------------Criteria Form------------------------------------------------
    var DynamicForm_CriteriaForm_JspcontinuousPersonnel = isc.DynamicForm.create({
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
                        Window_SelectPeople_JspUnitReport.show();
                    }}],
                keyPressFilter: "[A-Z|0-9|,-]"
            },
            {
                name: "postGrade",
                title: "رده پستی",
                hint: "رده پستی را انتخاب نمایید",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                        Window_SelectPostGrade_JspUnitReport.show();
                    }}],
                keyPressFilter: "[A-Z|0-9|,-]"
            },
            {
                name: "temp1",
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
                name: "classCode",
                title: "کد کلاس",
                hint: "کد کلاس را انتخاب نمائيد",
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
                    "2": "در حال اجرا"
                },
                pickListProperties: {
                    showFilterEditor: false
                },
                defaultValue:  ["1","2"]
            },
            {
                name: "temp2",
                title: "",
                canEdit: false
            },
            {
                name: "startDate1",
                ID: "startDate1_JspcontinuousPersonnel",
                title: "تاریخ شروع کلاس: از",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate1_JspcontinuousPersonnel', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("startDate2","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("startDate1", true);
                        startDateCheck_Order_JspcontinuousPersonnel = true;
                        startDate1Check_JspcontinuousPersonnel = true;
                        return;
                    }

                    var dateCheck;
                    var endDate = form.getValue("startDate2");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        startDate1Check_JspcontinuousPersonnel = false;
                        startDateCheck_Order_JspcontinuousPersonnel = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        startDateCheck_Order_JspcontinuousPersonnel = false;
                        startDate1Check_JspcontinuousPersonnel = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    }
                    else {
                        startDate1Check_JspcontinuousPersonnel = true;
                        startDateCheck_Order_JspcontinuousPersonnel = true;
                        form.clearFieldErrors("startDate1", true);
                    }
                }
            },
            {
                name: "startDate2",
                ID: "startDate2_JspcontinuousPersonnel",
                title: "تا",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate2_JspcontinuousPersonnel', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("startDate1","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("startDate2", true);
                        startDateCheck_Order_JspcontinuousPersonnel = true;
                        startDate2Check_JspcontinuousPersonnel = true;
                        return;
                    }

                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("startDate1");
                    if (dateCheck === false) {
                        startDate2Check_JspcontinuousPersonnel = false;
                        startDateCheck_Order_JspcontinuousPersonnel = true;
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "<spring:message code='msg.correct.date'/>", true);
                    } else if (startDate != undefined && value < startDate) {
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        startDate2Check_JspcontinuousPersonnel = true;
                        startDateCheck_Order_JspcontinuousPersonnel = false;
                    } else {
                        form.clearFieldErrors("startDate2", true);
                        startDate2Check_JspcontinuousPersonnel = true;
                        startDateCheck_Order_JspcontinuousPersonnel = true;
                    }
                }
            },
            {
                name: "temp3",
                title: "",
                canEdit: false
            },
            {
                name: "endDate1",
                ID: "endDate1_JspcontinuousPersonnel",
                title: "تاریخ پایان کلاس: از",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('endDate1_JspcontinuousPersonnel', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("endDate2","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("endDate1", true);
                        endDateCheck_Order_JspcontinuousPersonnel = true;
                        endDate1Check_JspcontinuousPersonnel = true;
                        return;
                    }

                    var dateCheck;
                    var endDate = form.getValue("endDate2");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        endDate1Check_JspcontinuousPersonnel = false;
                        endDateCheck_Order_JspcontinuousPersonnel = true;
                        form.clearFieldErrors("endDate1", true);
                        form.addFieldErrors("endDate1", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        endDateCheck_Order_JspcontinuousPersonnel = false;
                        endDate1Check_JspcontinuousPersonnel = true;
                        form.clearFieldErrors("endDate1", true);
                        form.addFieldErrors("endDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    } else {
                        endDate1Check_JspcontinuousPersonnel = true;
                        endDateCheck_Order_JspcontinuousPersonnel = true;
                        form.clearFieldErrors("endDate1", true);
                    }
                }
            },
            {
                name: "endDate2",
                ID: "endDate2_JspcontinuousPersonnel",
                title: "تا",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate2_JspcontinuousPersonnel', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("endDate1","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("endDate2", true);
                        endDateCheck_Order_JspcontinuousPersonnel = true;
                        endDate2Check_JspcontinuousPersonnel = true;
                        return;
                    }

                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("endDate1");
                    if (dateCheck === false) {
                        endDate2Check_JspcontinuousPersonnel = false;
                        endDateCheck_Order_JspcontinuousPersonnel = true;
                        form.clearFieldErrors("endDate2", true);
                        form.addFieldErrors("endDate2", "<spring:message code='msg.correct.date'/>", true);
                    } else if (startDate != undefined && value < startDate) {
                        form.clearFieldErrors("endDate2", true);
                        form.addFieldErrors("endDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        endDate2Check_JspcontinuousPersonnel = true;
                        endDateCheck_Order_JspcontinuousPersonnel = false;
                    } else {
                        form.clearFieldErrors("endDate2", true);
                        endDate2Check_JspcontinuousPersonnel = true;
                        endDateCheck_Order_JspcontinuousPersonnel = true;
                    }
                }
            },
            {
                name: "temp4",
                title: "",
                canEdit: false
            },
            {
                name: "classYear",
                title: "سال کاری",
                type: "SelectItem",
                multiple: true,
                optionDataSource: RestDataSource_Year_JspcontinuousPersonnel,
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
                        RestDataSource_Term_JspcontinuousPersonnel.fetchDataURL = termUrl + "listByYear/" + value[0];
                        DynamicForm_CriteriaForm_JspcontinuousPersonnel.getField("termId").optionDataSource = RestDataSource_Term_JspcontinuousPersonnel;
                        DynamicForm_CriteriaForm_JspcontinuousPersonnel.getField("termId").fetchData();
                        DynamicForm_CriteriaForm_JspcontinuousPersonnel.getField("termId").enable();
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
                name: "temp5",
                title: "",
                canEdit: false
            },
            {
                name: "courseType",
                title: "وضعیت نیازسنجی",
                type: "SelectItem",
                valueMap: {
                    "1": "نیازسنجی",
                    "2": "غیر نیازسنجی",
                    "3": "همه",
                },
                pickListProperties: {
                    showFilterEditor: false
                },
                defaultValue:  ["3"]
            },
        ]
    });

    var initialLayoutStyle = "vertical";
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
                optionDataSource: RestDataSource_Class_JspcontinuousPersonnel
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

            criteriaDisplayValues = criteriaDisplayValues == "undefined" ? "" : criteriaDisplayValues;

            DynamicForm_CriteriaForm_JspcontinuousPersonnel.getField("classCode").setValue(criteriaDisplayValues);
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
            {name: "firstName", title: "نام", width: "30%", filterOperator: "iContains"},
            {name: "lastName", title: "نام خانوادگي", width: "30%", filterOperator: "iContains"},
            {name: "nationalCode", title: "کدملي", width: "30%", filterOperator: "iContains"},
            {name: "personnelNo", title: "کد پرسنلي", width: "30%", filterOperator: "iContains"},
            {name: "personnelNo2", title: "کد پرسنلي 6 رقمي", width: "30%", filterOperator: "iContains"},
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

            DynamicForm_CriteriaForm_JspcontinuousPersonnel.getField("personnelNo").setValue(criteriaDisplayValues);
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

    var DynamicForm_SelectPostGrade_JspUnitReport = isc.DynamicForm.create({
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
                optionDataSource: RestDataSource_PostGradeLvl_PCNR
            }
        ]
    });

    DynamicForm_SelectPostGrade_JspUnitReport.getField("PostGrade.code").comboBox.setHint("رده پستی مورد نظر را انتخاب کنید");
    DynamicForm_SelectPostGrade_JspUnitReport.getField("PostGrade.code").comboBox.pickListFields =
        [
            {name: "titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains"},
            {name: "peopleType",  title: "نوع فراگیر",valueMap: {"personnel_registered": "متفرقه", "Personal": "شرکتی", "ContractorPersonal": "پیمانکار"}},
            {name: "enabled", title: "فعال/غیرفعال", valueMap: {"undefined": "فعال", "74": "غیرفعال"}}
        ];
    DynamicForm_SelectPostGrade_JspUnitReport.getField("PostGrade.code").comboBox.filterFields = ["titleFa","peopleType","enabled"];

    IButton_ConfirmPostGradeSelections_JspUnitReport = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            let criteriaDisplayValues = "";
            let selectorDisplayValues = DynamicForm_SelectPostGrade_JspUnitReport.getItem("PostGrade.code").getValue();
            if (DynamicForm_SelectPostGrade_JspUnitReport.getField("PostGrade.code").getValue() != undefined && DynamicForm_SelectPostGrade_JspUnitReport.getField("PostGrade.code").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectPostGrade_JspUnitReport.getField("PostGrade.code").getValue().join(",");
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
            DynamicForm_CriteriaForm_JspcontinuousPersonnel.getField("postGrade").setValue(DynamicForm_SelectPostGrade_JspUnitReport.getItem("PostGrade.code").getDisplayValue().join(","));
            Window_SelectPostGrade_JspUnitReport.close();
        }
    });

    var Window_SelectPostGrade_JspUnitReport = isc.Window.create({
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
                    DynamicForm_SelectPostGrade_JspUnitReport,
                    IButton_ConfirmPostGradeSelections_JspUnitReport,
                ]
            })
        ]
    });

    IButton_JspcontinuousPersonnel = isc.IButtonSave.create({
        top: 260,
        title: "چاپ گزارش",
        width: 300,
        click: function () {
            if(DynamicForm_CriteriaForm_JspcontinuousPersonnel.getValuesAsAdvancedCriteria().criteria.size() <= 2) {
                createDialog("info","فیلتری انتخاب نشده است.");
                return;
            }

            DynamicForm_CriteriaForm_JspcontinuousPersonnel.validate();
            if (DynamicForm_CriteriaForm_JspcontinuousPersonnel.hasErrors())
                return;

            else{
                data_values = DynamicForm_CriteriaForm_JspcontinuousPersonnel.getValuesAsAdvancedCriteria();
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
                        data_values.criteria[i].operator = "inSet";
                        data_values.criteria[i].value = codesArray;
                    }

                    else if (data_values.criteria[i].fieldName == "classCode") {
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

                    else if (data_values.criteria[i].fieldName == "postGrade") {
                        var codesString = criteriaDisplayValuesPostGrade;
                        var codesArray;
                        codesArray = codesString.split(",");
                        for (var j = 0; j < codesArray.length; j++) {
                            if (codesArray[j] == "" || codesArray[j] == " ") {
                                codesArray.remove(codesArray[j]);
                            }
                        }

                        data_values.criteria[i].fieldName = "pgId";
                        data_values.criteria[i].operator = "inSet";
                        data_values.criteria[i].value = codesArray;
                    }

                    else if (data_values.criteria[i].fieldName == "companyName") {
                        data_values.criteria[i].fieldName = "companyName";
                        data_values.criteria[i].operator = "iContains";
                    }
                    else if (data_values.criteria[i].fieldName == "assistant") {
                        data_values.criteria[i].fieldName = "assistant";
                        data_values.criteria[i].operator = "iContains";
                    }
                    else if (data_values.criteria[i].fieldName == "unit") {
                        data_values.criteria[i].fieldName = "unit";
                        data_values.criteria[i].operator = "iContains";
                    }
                    else if (data_values.criteria[i].fieldName == "affairs") {
                        data_values.criteria[i].fieldName = "affairs";
                        data_values.criteria[i].operator = "iContains";
                    }
                    else if (data_values.criteria[i].fieldName == "section") {
                        data_values.criteria[i].fieldName = "section";
                        data_values.criteria[i].operator = "iContains";
                    }

                    else if (data_values.criteria[i].fieldName == "complexTitle") {
                        data_values.criteria[i].fieldName = "complexTitle";
                        data_values.criteria[i].operator = "iContains";
                    }

                    else if (data_values.criteria[i].fieldName == "startDate1") {
                        data_values.criteria[i].fieldName = "classStartDate";
                        data_values.criteria[i].operator = "greaterThan";
                    }
                    else if (data_values.criteria[i].fieldName == "startDate2") {
                        data_values.criteria[i].fieldName = "classStartDate";
                        data_values.criteria[i].operator = "lessThan";
                    }
                    else if (data_values.criteria[i].fieldName == "endDate1") {
                        data_values.criteria[i].fieldName = "classEndDate";
                        data_values.criteria[i].operator = "greaterThan";
                    }
                    else if (data_values.criteria[i].fieldName == "endDate2") {
                        data_values.criteria[i].fieldName = "classEndDate";
                        data_values.criteria[i].operator = "lessThan";
                    }

                    else if (data_values.criteria[i].fieldName == "classYear") {
                        data_values.criteria[i].fieldName = "classYear";
                        data_values.criteria[i].operator = "iContains";
                    }

                    else if (data_values.criteria[i].fieldName == "termId") {
                        data_values.criteria[i].fieldName = "termId";
                        data_values.criteria[i].operator = "equals";
                    }

                    else if (data_values.criteria[i].fieldName == "courseType") {
                        if (data_values.criteria[i].value=="1"){
                            data_values.criteria[i].value="نیازسنجی";
                            data_values.criteria[i].operator = "equals";
                        }

                        else if (data_values.criteria[i].value=="2"){
                            data_values.criteria[i].value="غیر نیازسنجی";
                            data_values.criteria[i].operator = "equals";
                        }

                        else{
                            data_values.criteria.remove(data_values.criteria.find({fieldName: "courseType"}));
                        }
                    }
                }

                ListGrid_JspcontinuousPersonnel.invalidateCache();
                ListGrid_JspcontinuousPersonnel.fetchData(data_values);
                Window_JspcontinuousPersonnel.show();
            }
        }
    });

    //----------------------------------- functions --------------------------------------------------------------------
    let Window_CriteriaForm_JspcontinuousPersonnel = isc.Window.create({
        placement: "fillScreen",
        title: "",
        showCloseButton: false,
        showMaximizeButton: false,
        canDragReposition: false,
        showMinimizeButton: false,
        canDragResize: false,
        closeClick: false,
        minimize: false,
        items: [DynamicForm_CriteriaForm_JspcontinuousPersonnel]
    });
    //----------------------------------- layOut -----------------------------------------------------------------------
    var HLayOut_CriteriaForm_JspcontinuousPersonnel = isc.TrHLayoutButtons.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "100%",
        alignLayout: "center",
        members: [
            Window_CriteriaForm_JspcontinuousPersonnel
        ]
    });

    var HLayOut_Confirm_JspcontinuousPersonnel = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_JspcontinuousPersonnel
        ]
    });

    var VLayout_Body_JspcontinuousPersonnel = isc.TrVLayout.create({
        members: [
            HLayOut_CriteriaForm_JspcontinuousPersonnel,
            HLayOut_Confirm_JspcontinuousPersonnel
        ]
    });
    //----------------------------------------------------End-----------------------------------------------------------
    Window_JspcontinuousPersonnel.hide();