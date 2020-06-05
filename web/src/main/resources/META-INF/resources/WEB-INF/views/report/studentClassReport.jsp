<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    var selectedPerson_StudentClass = null;
    var printUrl_StudentClass = "<spring:url value="/web/print/class-student/"/>";

    var RestDataSource_Course_JspStudentClass = isc.TrDS.create({
        fields: [
            {name: "classStudentId", primaryKey: true, hidden: true},
            {name: "studentPersonnelNo2", title:"<spring:message code='personnel.no.6.digits'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "studentNationalCode", title:"<spring:message code='national.code'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "studentFirstName", title:"<spring:message code='firstName'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentLastName", title:"<spring:message code='lastName'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCcpUnit", title:"<spring:message code='unit'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "studentCcpSection", title:"<spring:message code='section'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "studentCcpAssistant", title:"<spring:message code='assistance'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "studentCcpArea", title:"<spring:message code='area'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "studentPostCode", title:"<spring:message code='post.code'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "studentPostTitle", title:"<spring:message code='post.title'/>", filterOperator: "equals"},
            {name: "courseCode", title:"<spring:message code='corse_code'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "termCode", title:"<spring:message code='term.code'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "courseTitleFa", title:"<spring:message code='course'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classStartDate", title:"<spring:message code="start.date"/>", filterOperator: "equals", autoFitWidth: true},
            {name: "classStudentScore", title:"<spring:message code="score"/>", filterOperator: "equals", autoFitWidth: true},
            {name: "studentComplexTitle", title: "<spring:message code="complex"/>", filterOperator: "equals"},
            {name: "studentCcpAffairs", title: "<spring:message code="affairs"/>", filterOperator: "equals"},
            {name: "studentCompanyName", title: "<spring:message code="company"/>", filterOperator: "equals"},
            {name: "classStudentScoresState", title:"<spring:message code="score.state"/>", filterOperator: "equals", autoFitWidth: true},
            {name: "classEndDate", filterOperator: "greaterOrEqual", autoFitWidth: true},
            {name: "classHDuration", title:"<spring:message code="duration"/>", autoFitWidth: true},
        ],
        fetchDataURL: studentClassReportUrl
    });
    var ScoresStateDS_SCRV = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="company"/>", filterOperator: "iContains", autoFitWidth: true, primaryKey:true},
        ],
        autoCacheAllData: true,
        fetchDataURL: studentClassReportUrl + "/all-field-values?fieldName=scoreState"
    });

    var CompanyDS_SCRV = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="company"/>", filterOperator: "iContains", autoFitWidth: true, primaryKey:true},
        ],
        cacheAllData: true,
        fetchDataURL: studentClassReportUrl + "/all-field-values?fieldName=company"
    });
    var AreaDS_SCRV = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: studentClassReportUrl + "/all-field-values?fieldName=area"
    });
    var ComplexDS_SCRV = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: studentClassReportUrl + "/all-field-values?fieldName=complex"
    });
    var AssistantDS_SCRV = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: studentClassReportUrl + "/all-field-values?fieldName=assistant"
    });
    var AffairsDS_SCRV = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: studentClassReportUrl + "/all-field-values?fieldName=affairs"
    });
    var CourseDS_SCRV = isc.TrDS.create({
        fields: [
            {name: "courseId", primaryKey: true},
            {name: "courseCode", title: "<spring:message code="corse_code"/>"},
            {name: "courseTitleFa", title: "<spring:message code="course_fa_name"/>"},
        ],
        fetchDataURL: studentClassReportUrl + "/all-courses",
    });
    var UnitDS_SCRV = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: studentClassReportUrl + "/all-field-values?fieldName=unit"
    });
    var TermDS_SCRV = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="term.code"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: termUrl + "spec-list"
    });
    var YearDS_SCRV = isc.TrDS.create({
        fields: [
            {name: "year", title: "<spring:message code="year"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: termUrl + "yearList"
    });
    var SectionDS_SCRV = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="term.code"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: studentClassReportUrl + "/all-field-values?fieldName=section"
    });

    var DynamicForm_StudentClass = isc.DynamicForm.create({
        numCols: 11,
        padding: 10,
        readOnlyDisplay: "readOnly",
        margin:0,
        // cellPadding: 10,
        titleAlign:"left",
        wrapItemTitles: true,
        colWidths:[50,150,50,150,50,150,50,150, 50, 100, 50],
        // sectionVisibilityMode: "mutex",
        fields: [
            // {
            //     defaultValue:"جستجو فرد", type:"section", sectionExpanded:true,canTabToHeader:true,
            //     itemIds: ["studentPersonnelNo2","studentPersonnelNo","studentNationalCode","searchBtn","studentFirstName","studentLastName","clearBtn"],
            //     width:"80%"
            // },
            {
                name: "studentPersonnelNo2",
                title:"پرسنلی 6رقمی",
                <%--title:"<spring:message code="personnel.no.6.digits"/>",--%>
                textAlign: "center",
                width: "*",
                keyPressFilter: "[0-9, ]",
                operator: "inSet",
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
                colSpan: 2,
                title:"<spring:message code="lastName"/> ",
                textAlign: "center",
                width: "*"
            },
            // {
            //     type: "SpacerItem"
            // },
            // {
            //     type: "SpacerItem"
            // },
            // {
            //     defaultValue:"جستجو گروه", type:"section",canTabToHeader:true,
            //     itemIds: ["classStudentScoresState","studentComplexTitle","studentCcpAffairs","studentCompanyName","courseTitle","termTitleFa"], width:"80%"
            // },
            {
                name: "classStudentScoresState",
                title: "<spring:message code="score.state"/>",
                type: "SelectItem",
                optionDataSource: ScoresStateDS_SCRV,
                multiple: true,
                valueField: "value",
                displayField: "value",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
            },
            {
                name: "studentComplexTitle",
                title: "<spring:message code="complex"/>",
                optionDataSource: ComplexDS_SCRV,
                // filterFields: ["value", "value"],
                pickListWidth: 300,
                type: "SelectItem",
                // textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                multiple: true,
                valueField: "value",
                displayField: "value",
            },
            {
                name: "studentCompanyName",
                title: "<spring:message code="company"/>",
                // filterFields: ["value", "value"],
                pickListWidth: 300,
                type: "SelectItem",
                // textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                multiple: true,
                valueField: "value",
                displayField: "value",
                optionDataSource: CompanyDS_SCRV,
            },
            {
                name: "studentCcpArea",
                title: "<spring:message code="area"/>",
                // filterFields: ["value", "value"],
                pickListWidth: 300,
                type: "SelectItem",
                // textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                multiple: true,
                valueField: "value",
                displayField: "value",
                optionDataSource: AreaDS_SCRV,
            },
            {
                name: "studentCcpAssistant",
                title: "<spring:message code="assistance"/>",
                // filterFields: ["value", "value"],
                pickListWidth: 300,
                type: "SelectItem",
                // textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                multiple: true,
                colSpan: 2,
                valueField: "value",
                displayField: "value",
                optionDataSource: AssistantDS_SCRV,
            },
            {
                name: "studentCcpSection",
                title: "<spring:message code="section.cost"/>",
                // filterFields: ["value", "value"],
                pickListWidth: 300,
                type: "SelectItem",
                // textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                multiple: true,
                valueField: "value",
                displayField: "value",
                optionDataSource: SectionDS_SCRV,
            },
            {
                name: "studentCcpUnit",
                title: "<spring:message code="unitName"/>",
                // filterFields: ["value", "value"],
                pickListWidth: 300,
                type: "SelectItem",
                // textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                multiple: true,
                valueField: "value",
                displayField: "value",
                optionDataSource: UnitDS_SCRV,
            },
            {
                name: "studentCcpAffairs",
                title: "<spring:message code="affairs"/>",
                optionDataSource: AffairsDS_SCRV,
                // filterFields: ["value", "value"],
                // pickListWidth: 300,
                type: "MultiComboBoxItem",
                textMatchStyle: "substring",
                comboBoxWidth: 155,
                layoutStyle: "verticalReverse",
                comboBoxProperties: {
                    pickListWidth: 300,
                },
                // pickListProperties: {
                //     showFilterEditor: false,
                //     showClippedValuesOnHover: true,
                // },
                valueField: "value",
                displayField: "value",
            },
            {
                name: "courseCode",
                title: "<spring:message code="course"/>",
                optionDataSource: CourseDS_SCRV,
                valueField: "courseCode",
                displayField: "courseCode",
                // comboBoxFields: [
                //     {name: "code", autoFitWidth: true},
                //     {name: "titleFa"},
                // ],
                // filterFields: ["titleFa", "code"],
                type: "MultiComboBoxItem",
                textMatchStyle: "substring",
                comboBoxWidth: 155,
                // layoutStyle: "horizontal",
                comboBoxProperties: {
                    pickListWidth: 400,
                    useClientFiltering: true,
                },
            },
            {
                name: "termTitleFa",
                title: "<spring:message code="term"/>",
                // filterFields: ["value", "value"],
                // pickListWidth: 100,
                type: "SelectItem",
                // textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                colSpan: 2,
                multiple: true,
                valueField: "titleFa",
                displayField: "titleFa",
                initialSort: [
                    {property: "titleFa", direction: "descending", primarySort: true}
                ],
                optionDataSource: TermDS_SCRV,
            },
            <%--{--%>
            <%--name: "year",--%>
            <%--title: "<spring:message code="year"/>",--%>
            <%--// filterFields: ["value", "value"],--%>
            <%--// pickListWidth: 100,--%>
            <%--type: "SelectItem",--%>
            <%--criteriaField: "termCode",--%>
            <%--operator: "contains",--%>
            <%--// textMatchStyle: "substring",--%>
            <%--pickListProperties: {--%>
            <%--showFilterEditor: false,--%>
            <%--showClippedValuesOnHover: true,--%>
            <%--},--%>
            <%--multiple: true,--%>
            <%--valueField: "year",--%>
            <%--displayField: "year",--%>
            <%--optionDataSource: YearDS_SCRV,--%>
            <%--},--%>
            // { name: "independence", editorType: "DateRangeItem", showTitle: false, allowRelativeDates: true },
            {
                name: "fromDate",
                titleColSpan: 3,
                title: "تاریخ شروع کلاس: از",
                ID: "startDate_jspStudentClassReport",
                hint: "--/--/----",
                criteriaField: "classStartDate",
                operator: "greaterOrEqual",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate_jspStudentClassReport', this, 'ymd', '/');
                    }
                }],
                textAlign: "center",
                // colSpan: 2,
                changed: function (form, item, value) {
                    var dateCheck;
                    // var endDate = form.getValue("endDate");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        form.addFieldErrors("fromDate", "<spring:message code='msg.correct.date'/>", true);
                    } else {
                        form.clearFieldErrors("fromDate", true);
                    }
                }
            },
            {
                name: "toDate",
                titleColSpan: 1,
                title: "تا",
                ID: "endDate_jspStudentClassReport",
                hint: "--/--/----",
                criteriaField: "classStartDate",
                operator: "lessOrEqual",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate_jspStudentClassReport', this, 'ymd', '/');
                    }
                }],
                textAlign: "center",
                // colSpan: 2,
                changed: function (form, item, value) {
                    let dateCheck;
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        form.clearFieldErrors("toDate", true);
                        form.addFieldErrors("toDate", "<spring:message code='msg.correct.date'/>", true);
                    } else {
                        form.clearFieldErrors("toDate", true);
                    }
                }
            },
            {type: "SpacerItem"},
            {
                name: "searchBtn",
                ID: "searchBtnJspStudentClass",
                <%--title: "<spring:message code="report"/>",--%>
                title: "<spring:message code="reporting"/>",
                type: "ButtonItem",
                colSpan: 1,
                width:"*",
                startRow:false,
                endRow:false,
                click (form) {
                    let criteria = form.getValuesAsAdvancedCriteria();
                    // console.log(criteria);

                    if(criteria == null || Object.keys(criteria).length === 0) {
                        ListGrid_StudentClass_StudentClassJSP.setData([])
                    }
                    else{
                        // delete criteria.fromDate;
                        // delete criteria.toDate;
                        // criteria.classEndDate = DynamicForm_StudentClass.getValue("fromDate");
                        if(form.getValue("studentPersonnelNo2") != undefined){
                            let cr = [];
                            for (let i = 0; i < criteria.criteria.length; i++) {
                                if(criteria.criteria[i]["fieldName"] != "studentPersonnelNo2"){
                                    cr.push(criteria.criteria[i])
                                }
                            }
                            cr.push({fieldName: "studentPersonnelNo2", operator: "inSet", value: form.getValue("studentPersonnelNo2").split(',').toArray()})
                            criteria.criteria = cr;
                        }
                        ListGrid_StudentClass_StudentClassJSP.invalidateCache();
                        RestDataSource_Course_JspStudentClass.implicitCriteria = criteria;
                        ListGrid_StudentClass_StudentClassJSP.fetchData(criteria)
                    }
                }
            },
            // {type:"SpacerItem"},
            {
                name: "clearBtn",
                title: "<spring:message code="clear"/>",
                type: "ButtonItem",
                width:"*",
                colSpan: 2,
                startRow:false,
                endRow:false,
                click (form, item) {
                    form.clearValues();
                    ListGrid_StudentClass_StudentClassJSP.setData([]);
                }
            },
        ],
        itemChanged (item, newValue){
            ListGrid_StudentClass_StudentClassJSP.setData([]);
        },
        // itemKeyPress: function(item, keyName) {
        //     if(keyName == "Enter"){
        //         // searchBtnJspStudentClass.click(DynamicForm_StudentClass);
        //     }
        // }
    });

    DynamicForm_StudentClass.getField("courseCode").comboBox.pickListFields = [
        {name: "courseCode", autoFitWidth: true},
        {name: "courseTitleFa"},
    ];
    DynamicForm_StudentClass.getField("courseCode").comboBox.setHint("دوره های مورد نظر را انتخاب کنید");
    DynamicForm_StudentClass.getField("courseCode").comboBox.filterFields = ["courseTitleFa", "courseCode"];
    DynamicForm_StudentClass.getField("courseCode").comboBox.textMatchStyle="substring";
    DynamicForm_StudentClass.getField("courseCode").comboBox.pickListProperties= {
        showFilterEditor: false,
        pickListWidth: 400,
        showClippedValuesOnHover: true,
    };
    DynamicForm_StudentClass.getField("studentCcpAffairs").comboBox.filterFields = ["value", "value"];
    DynamicForm_StudentClass.getField("studentCcpAffairs").comboBox.textMatchStyle="substring";
    DynamicForm_StudentClass.getField("studentCcpAffairs").comboBox.setHint("امور مورد نظر را انتخاب کنید");
    DynamicForm_StudentClass.getField("studentCcpAffairs").comboBox.pickListProperties= {
        showFilterEditor: false,
        pickListWidth: 300,
        showClippedValuesOnHover: true,
    };

    var Menu_Courses_StudentClassJSP = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="global.form.print.pdf"/>",
                click: function () {
                    let params = {};
                    params.complex = "مجتمع: " + (DynamicForm_StudentClass.getValue("studentComplexTitle")?DynamicForm_StudentClass.getValue("studentComplexTitle").toString():"-");
                    params.company = "شرکت: " + (DynamicForm_StudentClass.getValue("studentCompanyName")?DynamicForm_StudentClass.getValue("studentCompanyName").toString():"-");
                    params.area = "حوزه: " + (DynamicForm_StudentClass.getValue("studentCcpArea")?DynamicForm_StudentClass.getValue("studentCcpArea").toString():"-");
                    params.assistant = "معاونت: " + (DynamicForm_StudentClass.getValue("studentCcpAssistant")?DynamicForm_StudentClass.getValue("studentCcpAssistant").toString():"-");
                    params.section = "مرکز هزينه: " + (DynamicForm_StudentClass.getValue("studentCcpSection")?DynamicForm_StudentClass.getValue("studentCcpSection").toString():"-");
                    params.unit = "نام واحد: " + (DynamicForm_StudentClass.getValue("studentCcpUnit")?DynamicForm_StudentClass.getValue("studentCcpUnit").toString():"-");
                    params.affairs = "امور: " + (DynamicForm_StudentClass.getValue("studentCcpAffairs")?DynamicForm_StudentClass.getValue("studentCcpAffairs").toString():"-");
                    params.term = "کد ترم: " + (DynamicForm_StudentClass.getValue("termTitleFa")?DynamicForm_StudentClass.getValue("termTitleFa").toString():"-");
                    params.fromDate = "تاریخ شروع کلاس: از: " + (DynamicForm_StudentClass.getValue("fromDate")?DynamicForm_StudentClass.getValue("fromDate"):"-");
                    params.toDate = "تا: " + (DynamicForm_StudentClass.getValue("toDate")?DynamicForm_StudentClass.getValue("toDate"):"-");
                    printWithCriteria(DynamicForm_StudentClass.getValuesAsAdvancedCriteria(), params, "personnelCourses.jasper");
                    // printToJasper(ListGrid_StudentClass_StudentClassJSP.getData().localData.toArray(), params, "personnelCourses.jasper");
                }
            },
            {
                title: "<spring:message code="global.form.print.excel"/>",
                click: function () {
                    // console.log(ListGrid_StudentClass_StudentClassJSP.getFields().subList(1,10));
                    // exportToExcel(ListGrid_StudentClass_StudentClassJSP.getFields().subList(1,10) ,ListGrid_StudentClass_StudentClassJSP.getData().localData)
                    ExportToFile.DownloadExcelFormClient(ListGrid_StudentClass_StudentClassJSP,null,"","دوره های گذرانده پرسنل");
                }
            },
            <%--{--%>
            <%--title: "<spring:message code="global.form.print.html"/>",--%>
            <%--click: function () {--%>
            <%--printToJasper(ListGrid_StudentClass_StudentClassJSP.getData().localData.toArray(), params, "personnelCourses.jasper", "HTML");--%>
            <%--}--%>
            <%--}--%>
        ]
    });

    var ListGrid_StudentClass_StudentClassJSP = isc.TrLG.create({
        ID: "StudentClassGrid",
        dynamicTitle: true,
        autoFetchData: false,
        allowAdvancedCriteria: true,
        contextMenu: Menu_Courses_StudentClassJSP,
        dataSource: RestDataSource_Course_JspStudentClass,
        // overflow: "scroll",
        filterOnKeypress: true,
        showFilterEditor: false,

        gridComponents: [DynamicForm_StudentClass, "header", "filterEditor", "body"],
        fields:[
            {
                name: "studentPersonnelNo2",
            },
            {name: "studentNationalCode",
                keyPressFilter: "[0-9]"
            },
            {name: "studentFirstName"},
            {name: "studentLastName"},
            {name: "studentCcpUnit"},
            {name: "studentPostCode"},
            {name: "studentPostTitle"},
            {name: "courseCode"},
            {name: "courseTitleFa"},
            {name: "classHDuration"},
            {name: "classStartDate"},
            {name: "classEndDate", title:"<spring:message code="end.date"/>", filterOperator: "equals", autoFitWidth: true},
            {name: "classStudentScore"},
            {name: "classStudentScoresState"},
        ]
    });

    var ToolStripButton_Training_File = isc.ToolStripButtonPrint.create({
        <%--title: "<spring:message code='print'/>",--%>
        click: function () {
            print_Training_File();
        }
    });

    var ToolStrip_Actions_Training_File = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [ToolStripButton_Training_File]
    });

    var VLayout_Body_Training_File = isc.VLayout.create({
        width: "100%",
        height: "100%",
        overflow: "visible",
        members: [
            // ToolStrip_Actions_Training_File,
            ListGrid_StudentClass_StudentClassJSP
        ]
    });

    //*************this function calls from studentPortal page**************
    <%--function call_trainingFile(selected_person) {--%>
    <%--selectedPerson_StudentClass = selected_person;--%>
    <%--DynamicForm_StudentClass.hide();--%>
    <%--RestDataSource_Course_JspStudentClass.fetchDataURL = studentPortalUrl + "/class-student/classes-of-student/" + selectedPerson_StudentClass.nationalCode;--%>
    <%--printUrl_StudentClass = "<spring:url value="/web/print/student-portal/"/>";--%>
    <%--ListGrid_StudentClass_StudentClassJSP.invalidateCache();--%>
    <%--ListGrid_StudentClass_StudentClassJSP.fetchData();--%>
    <%--}--%>

    function print_Training_File(type = "pdf") {
        if (selectedPerson_StudentClass == null){
            createDialog("info", "<spring:message code='personnel.not.selected'/>");
            return;
        }
        let params = {};
        params.firstName = selectedPerson_StudentClass.firstName;
        params.lastName = selectedPerson_StudentClass.lastName;
        params.nationalCode = selectedPerson_StudentClass.nationalCode;
        params.personnelNo = selectedPerson_StudentClass.personnelNo;
        params.personnelNo2 = selectedPerson_StudentClass.personnelNo2;
        params.companyName = selectedPerson_StudentClass.companyName;

        let CriteriaForm_StudentClass = isc.DynamicForm.create({
            method: "POST",
            action: printUrl_StudentClass + type,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "CriteriaStr", type: "hidden"},
                    {name: "myToken", type: "hidden"},
                    {name: "params", type: "hidden"},
                    {name: "formData", type: "hidden"},
                ]
        });
        CriteriaForm_StudentClass.setValue("CriteriaStr", JSON.stringify(ListGrid_StudentClass_StudentClassJSP.getCriteria()));
        CriteriaForm_StudentClass.setValue("formData", JSON.stringify(selectedPerson_StudentClass.nationalCode));
        CriteriaForm_StudentClass.setValue("myToken", "<%=accessToken%>");
        CriteriaForm_StudentClass.setValue("params", JSON.stringify(params));
        CriteriaForm_StudentClass.show();
        CriteriaForm_StudentClass.submitForm();
    }

    //</script>
