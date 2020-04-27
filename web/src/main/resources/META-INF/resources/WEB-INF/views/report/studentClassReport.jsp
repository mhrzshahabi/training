<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>
    
    var selectedPerson_TrainingFile = null;
    var printUrl_TrainingFile = "<spring:url value="/web/print/class-student/"/>";

    var RestDataSource_Course_JspTrainingFile = isc.TrDS.create({
        fields: [
            {name: "classStudentId", primaryKey: true, hidden: true},
            {name: "studentPersonnelNo2", title:"<spring:message code='personnel.no.6.digits'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentNationalCode", title:"<spring:message code='national.code'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentFirstName", title:"<spring:message code='firstName'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentLastName", title:"<spring:message code='lastName'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentCcpUnit", title:"<spring:message code='unit'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "studentCcpSection", title:"<spring:message code='section'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "studentCcpAssistant", title:"<spring:message code='assistance'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "studentCcpArea", title:"<spring:message code='area'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "courseCode", title:"<spring:message code='corse_code'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "termCode", title:"<spring:message code='term.code'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "courseTitleFa", title:"<spring:message code='course'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "classStudentScore", title:"<spring:message code="score"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "studentComplexTitle", title: "<spring:message code="complex"/>", filterOperator: "equals"},
            {name: "studentCcpAffairs", title: "<spring:message code="affairs"/>", filterOperator: "equals"},
            {name: "studentCompanyName", title: "<spring:message code="company"/>", filterOperator: "equals"},
            {name: "classStudentScoresState", title:"<spring:message code="score.state"/>", filterOperator: "equals", autoFitWidth: true},
            {name: "classEndDate", filterOperator: "greaterOrEqual", autoFitWidth: true},
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

    var DynamicForm_TrainingFile = isc.DynamicForm.create({
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
                width: "*"
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
                ID: "searchBtnJspTrainingFile",
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
                        ListGrid_TrainingFile_TrainingFileJSP.setData([])
                    }
                    else{
                        // delete criteria.fromDate;
                        // delete criteria.toDate;
                        // criteria.classEndDate = DynamicForm_TrainingFile.getValue("fromDate");

                        ListGrid_TrainingFile_TrainingFileJSP.invalidateCache();
                        RestDataSource_Course_JspTrainingFile.implicitCriteria = criteria;
                        ListGrid_TrainingFile_TrainingFileJSP.fetchData(criteria)
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
                    ListGrid_TrainingFile_TrainingFileJSP.setData([]);
                }
            },
        ],
        itemChanged (item, newValue){
            ListGrid_TrainingFile_TrainingFileJSP.setData([]);
        },
        // itemKeyPress: function(item, keyName) {
        //     if(keyName == "Enter"){
        //         // searchBtnJspTrainingFile.click(DynamicForm_TrainingFile);
        //     }
        // }
    });

    DynamicForm_TrainingFile.getField("courseCode").comboBox.pickListFields = [
        {name: "courseCode", autoFitWidth: true},
        {name: "courseTitleFa"},
    ];
    DynamicForm_TrainingFile.getField("courseCode").comboBox.setHint("دوره های مورد نظر را انتخاب کنید");
    DynamicForm_TrainingFile.getField("courseCode").comboBox.filterFields = ["courseTitleFa", "courseCode"];
    DynamicForm_TrainingFile.getField("courseCode").comboBox.textMatchStyle="substring";
    DynamicForm_TrainingFile.getField("courseCode").comboBox.pickListProperties= {
        showFilterEditor: false,
        pickListWidth: 400,
        showClippedValuesOnHover: true,
    };
    DynamicForm_TrainingFile.getField("studentCcpAffairs").comboBox.filterFields = ["value", "value"];
    DynamicForm_TrainingFile.getField("studentCcpAffairs").comboBox.textMatchStyle="substring";
    DynamicForm_TrainingFile.getField("studentCcpAffairs").comboBox.setHint("امور مورد نظر را انتخاب کنید");
    DynamicForm_TrainingFile.getField("studentCcpAffairs").comboBox.pickListProperties= {
        showFilterEditor: false,
        pickListWidth: 300,
        showClippedValuesOnHover: true,
    };

    var Menu_Courses_TrainingFileJSP = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="global.form.print.pdf"/>",
                click: function () {
                    let params = {};
                    params.complex = "مجتمع: " + (DynamicForm_TrainingFile.getValue("studentComplexTitle")?DynamicForm_TrainingFile.getValue("studentComplexTitle").toString():"-");
                    params.company = "شرکت: " + (DynamicForm_TrainingFile.getValue("studentCompanyName")?DynamicForm_TrainingFile.getValue("studentCompanyName").toString():"-");
                    params.area = "حوزه: " + (DynamicForm_TrainingFile.getValue("studentCcpArea")?DynamicForm_TrainingFile.getValue("studentCcpArea").toString():"-");
                    params.assistant = "معاونت: " + (DynamicForm_TrainingFile.getValue("studentCcpAssistant")?DynamicForm_TrainingFile.getValue("studentCcpAssistant").toString():"-");
                    params.section = "مرکز هزينه: " + (DynamicForm_TrainingFile.getValue("studentCcpSection")?DynamicForm_TrainingFile.getValue("studentCcpSection").toString():"-");
                    params.unit = "نام واحد: " + (DynamicForm_TrainingFile.getValue("studentCcpUnit")?DynamicForm_TrainingFile.getValue("studentCcpUnit").toString():"-");
                    params.affairs = "امور: " + (DynamicForm_TrainingFile.getValue("studentCcpAffairs")?DynamicForm_TrainingFile.getValue("studentCcpAffairs").toString():"-");
                    params.term = "کد ترم: " + (DynamicForm_TrainingFile.getValue("termTitleFa")?DynamicForm_TrainingFile.getValue("termTitleFa").toString():"-");
                    params.fromDate = "تاریخ شروع کلاس: از: " + (DynamicForm_TrainingFile.getValue("fromDate")?DynamicForm_TrainingFile.getValue("fromDate"):"-");
                    params.toDate = "تا: " + (DynamicForm_TrainingFile.getValue("toDate")?DynamicForm_TrainingFile.getValue("toDate"):"-");
                    printWithCriteria(DynamicForm_TrainingFile.getValuesAsAdvancedCriteria(), params, "personnelCourses.jasper");
                    // printToJasper(ListGrid_TrainingFile_TrainingFileJSP.getData().localData.toArray(), params, "personnelCourses.jasper");
                }
            },
            {
                title: "<spring:message code="global.form.print.excel"/>",
                click: function () {
                    // console.log(ListGrid_TrainingFile_TrainingFileJSP.getFields().subList(1,10));
                    exportToExcel(ListGrid_TrainingFile_TrainingFileJSP.getFields().subList(1,10) ,ListGrid_TrainingFile_TrainingFileJSP.getData().localData)
                }
            },
            <%--{--%>
                <%--title: "<spring:message code="global.form.print.html"/>",--%>
                <%--click: function () {--%>
                    <%--printToJasper(ListGrid_TrainingFile_TrainingFileJSP.getData().localData.toArray(), params, "personnelCourses.jasper", "HTML");--%>
                <%--}--%>
            <%--}--%>
        ]
    });

    var ListGrid_TrainingFile_TrainingFileJSP = isc.TrLG.create({
        ID: "TrainingFileGrid",
        dynamicTitle: true,
        autoFetchData: false,
        allowAdvancedCriteria: true,
        contextMenu: Menu_Courses_TrainingFileJSP,
        dataSource: RestDataSource_Course_JspTrainingFile,
        // overflow: "scroll",
        filterOnKeypress: true,
        showFilterEditor: false,

        gridComponents: [DynamicForm_TrainingFile, "header", "filterEditor", "body"],
        fields:[
            {name: "studentPersonnelNo2"},
            {name: "studentNationalCode"},
            {name: "studentFirstName"},
            {name: "studentLastName"},
            {name: "studentCcpUnit"},
            {name: "courseCode"},
            {name: "courseTitleFa"},
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
            ListGrid_TrainingFile_TrainingFileJSP
        ]
    });

    //*************this function calls from studentPortal page**************
    <%--function call_trainingFile(selected_person) {--%>
        <%--selectedPerson_TrainingFile = selected_person;--%>
        <%--DynamicForm_TrainingFile.hide();--%>
        <%--RestDataSource_Course_JspTrainingFile.fetchDataURL = studentPortalUrl + "/class-student/classes-of-student/" + selectedPerson_TrainingFile.nationalCode;--%>
        <%--printUrl_TrainingFile = "<spring:url value="/web/print/student-portal/"/>";--%>
        <%--ListGrid_TrainingFile_TrainingFileJSP.invalidateCache();--%>
        <%--ListGrid_TrainingFile_TrainingFileJSP.fetchData();--%>
    <%--}--%>

    function print_Training_File(type = "pdf") {
        if (selectedPerson_TrainingFile == null){
            createDialog("info", "<spring:message code='personnel.not.selected'/>");
            return;
        }
        let params = {};
        params.firstName = selectedPerson_TrainingFile.firstName;
        params.lastName = selectedPerson_TrainingFile.lastName;
        params.nationalCode = selectedPerson_TrainingFile.nationalCode;
        params.personnelNo = selectedPerson_TrainingFile.personnelNo;
        params.personnelNo2 = selectedPerson_TrainingFile.personnelNo2;
        params.companyName = selectedPerson_TrainingFile.companyName;
        
        let CriteriaForm_TrainingFile = isc.DynamicForm.create({
            method: "POST",
            action: printUrl_TrainingFile + type,
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
        CriteriaForm_TrainingFile.setValue("CriteriaStr", JSON.stringify(ListGrid_TrainingFile_TrainingFileJSP.getCriteria()));
        CriteriaForm_TrainingFile.setValue("formData", JSON.stringify(selectedPerson_TrainingFile.nationalCode));
        CriteriaForm_TrainingFile.setValue("myToken", "<%=accessToken%>");
        CriteriaForm_TrainingFile.setValue("params", JSON.stringify(params));
        CriteriaForm_TrainingFile.show();
        CriteriaForm_TrainingFile.submitForm();
    }

 //</script>