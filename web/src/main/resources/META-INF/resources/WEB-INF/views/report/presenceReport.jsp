<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
// <script>
    //----------------------------------------------------Rest DataSource-----------------------------------------------
    RestDataSource_JspAttendanceReport = isc.TrDS.create({
        fields: [
            {name: "presenceHour", title:"حضور بر حسب ساعت", filterOperator: "equals", autoFitWidth: true},
            {name: "presenceMinute", title:"حضور بر حسب دقیقه", filterOperator: "equals", autoFitWidth: true},
            {name: "absenceHour", title:"غیبت بر حسب ساعت", filterOperator: "equals", autoFitWidth: true},
            {name: "absenceMinute", title:"غیبت بر حسب دقیقه", filterOperator: "equals", autoFitWidth: true},
            {name: "classId", hidden: true, filterOperator: "equals", autoFitWidth: true},
            {name: "classCode", title:"<spring:message code="class.code"/>", filterOperator: "inSet", autoFitWidth: true},
            {name: "classStartDate", title:"<spring:message code="start.date"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classEndDate", title:"<spring:message code="end.date"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classTeachingType", title:"<spring:message code="teaching.type"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "sessionDate", title:"تاریخ جلسه", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentId", hidden: true, filterOperator: "equals", autoFitWidth: true},
            {name: "studentPersonnelNo", title:"<spring:message code='personnel.no'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentPersonnelNo2", title:"<spring:message code='personnel.no.6.digits'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentFirstName", title:"<spring:message code='firstName'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentLastName", title:"<spring:message code='lastName'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentNationalCode", title:"<spring:message code='national.code'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCcpAssistant", title:"<spring:message code='assistance'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCcpAffairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCcpSection", title:"<spring:message code='section'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCcpUnit", title:"<spring:message code='unit'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classStudentApplicantCompanyName", title:"<spring:message code='company.applicant'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelComplexTitle", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseId", hidden: true, title:"<spring:message code='identity'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "courseCode", title:"<spring:message code='course.code'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseTitleFa", title:"<spring:message code='course'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "categoryId", title:"<spring:message code='category'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "courseRunType", title:"<spring:message code='course_eruntype'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseTheoType", title:"<spring:message code='course_etheoType'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseLevelType", title:"<spring:message code='cousre_elevelType'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseTechnicalType", title: "<spring:message code="technical.type"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "instituteId", hidden: true, title: "<spring:message code="identity"/>", filterOperator: "equals", autoFitWidth: true},
            {name: "instituteTitleFa", title: "<spring:message code="institute"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: presenceReportUrl
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

    var RestDataSource_Class_JspAttendanceReport = isc.TrDS.create({
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
        showFilterEditor: false,
        selectionType: "single",
        showRecordComponents: true,
        showRecordComponentsByCell: true
    });

    IButton_JspAttendanceReport_FullExcel = isc.IButtonSave.create({
        top: 260,
        title: "گزارش اکسل",
        width: 300,
        click: function () {
            ExportToFile.downloadExcelFromClient(ListGrid_JspAttendanceReport, null, '', 'گزارش حضور و غياب کلاس های آموزشي')
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
            IButton_JspAttendanceReport_FullExcel
        ]
    });

    var Window_JspAttendanceReport = isc.Window.create({
        placement: "fillScreen",
        title: "گزارش حضور و غیاب کلاسهای آموزشی",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
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
                name: "studentPersonnelNo2",
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
                name: "studentPersonnelNo",
                title:"<spring:message code="personnel.no"/> ",
                textAlign: "center",
                width: "*"
            },
            {
                name: "studentNationalCode",
                title:"<spring:message code="national.code"/> ",
                textAlign: "center",
                width: "*",
            },
            {
                name: "studentFirstName",
                title:"<spring:message code="firstName"/> ",
                textAlign: "center",
                width: "*"
            },
            {
                name: "studentLastName",
                title:"<spring:message code="lastName"/> ",
                textAlign: "center",
                width: "*"
            },
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
                name: "classCode",
                title: "کد کلاس",
                hint: "کدهای کلاس را با , از یکدیگر جدا کنید",
                prompt: "کدهای کلاس فقط میتوانند شامل حروف انگلیسی بزرگ، اعداد و - باشند",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                        Window_SelectClasses_JspAttendanceReport.show();
                    }}],
                keyPressFilter: "[A-Z|0-9|,-]"
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
                name: "temp1",
                title: "",
                canEdit: false
            },
            {
                name: "sessionDate",
                title: "تاریخ جلسه:",
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
                        form.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                    } else {
                        form.clearFieldErrors("startDate", true);
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
                optionDataSource: RestDataSource_Class_JspAttendanceReport
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

            criteriaDisplayValues = criteriaDisplayValues == ";undefined" ? "" : criteriaDisplayValues;

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

    IButton_JspAttendanceReport = isc.IButtonSave.create({
        top: 260,
        title: "چاپ گزارش",
        width: 300,
        click: function () {
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

                    else if (data_values.criteria[i].fieldName == "classStartDate") {
                        data_values.criteria[i].fieldName = "classStartDate";
                        data_values.criteria[i].operator = "iContains";
                    }
                    else if (data_values.criteria[i].fieldName == "classEndDate") {
                        data_values.criteria[i].fieldName = "classEndDate";
                        data_values.criteria[i].operator = "iContains";
                    }

                     else if (data_values.criteria[i].fieldName == "sessionDate") {
                         data_values.criteria[i].fieldName = "sessionDate";
                         data_values.criteria[i].operator = "iContains";
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
            IButton_JspAttendanceReport
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