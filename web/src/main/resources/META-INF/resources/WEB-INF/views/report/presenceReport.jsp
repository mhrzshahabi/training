<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    MainGridDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "presenceHour", title:"حضور بر حسب ساعت", filterOperator: "equals", autoFitWidth: true},
            {name: "presenceMinute", title:"حضور بر حسب دقیقه", filterOperator: "equals", autoFitWidth: true},
            {name: "absenceHour", title:"غیبت بر حسب ساعت", filterOperator: "equals", autoFitWidth: true},
            {name: "absenceMinute", title:"غیبت بر حسب دقیقه", filterOperator: "equals", autoFitWidth: true},
            {name: "classId", hidden: true, filterOperator: "equals", autoFitWidth: true},
            {name: "classCode", title:"<spring:message code="class.code"/>", filterOperator: "iContains", autoFitWidth: true},
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
    TermDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="term.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach:true},
        ],
        fetchDataURL: termUrl + "spec-list"
    });
    YearDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "year", title: "<spring:message code="year"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: termUrl + "yearList"
    });
    CourseDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code", title: "<spring:message code="corse_code"/>"},
            {name: "titleFa", title: "<spring:message code="course_fa_name"/>"},
        ],
        fetchDataURL: courseUrl + "spec-list"
    });

    CriteriaForm_PresenceReport = isc.DynamicForm.create({
        numCols: 11,
        padding: 10,
        readOnlyDisplay: "readOnly",
        margin:0,
        titleAlign:"left",
        wrapItemTitles: true,
        colWidths:[50,150,50,150,50,150,50,150, 50, 100, 50],
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
                colSpan: 2,
                title:"<spring:message code="lastName"/> ",
                textAlign: "center",
                width: "*"
            },
            {
                name: "studentComplexTitle",
                title: "<spring:message code="complex"/>",
                optionDataSource: ComplexDS_PresenceReport,
                type: "MultiComboBoxItem",
                comboBoxWidth: 155,
                valueField: "value",
                displayField: "value",
            },
            {
                name: "studentCompanyName",
                title: "<spring:message code="company"/>",
                type: "MultiComboBoxItem",
                comboBoxWidth: 155,
                valueField: "value",
                displayField: "value",
                optionDataSource: CompanyDS_PresenceReport,
            },
            {
                name: "studentCcpAssistant",
                title: "<spring:message code="assistance"/>",
                type: "MultiComboBoxItem",
                comboBoxWidth: 155,
                valueField: "value",
                displayField: "value",
                optionDataSource: AssistantDS_PresenceReport,
            },
            {
                name: "studentCcpSection",
                title: "<spring:message code="section.cost"/>",
                type: "MultiComboBoxItem",
                comboBoxWidth: 155,
                valueField: "value",
                displayField: "value",
                optionDataSource: SectionDS_PresenceReport,
            },
            {
                name: "studentCcpUnit",
                title: "<spring:message code="unitName"/>",
                optionDataSource: UnitDS_PresenceReport,
                type: "MultiComboBoxItem",
                comboBoxWidth: 155,
                valueField: "value",
                displayField: "value",
            },
            {
                name: "studentCcpAffairs",
                title: "<spring:message code="affairs"/>",
                optionDataSource: AffairsDS_PresenceReport,
                type: "MultiComboBoxItem",
                comboBoxWidth: 155,
                valueField: "value",
                displayField: "value",
            },
            {
                name: "courseCode",
                title: "<spring:message code="course"/>",
                optionDataSource: CourseDS_PresenceReport,
                valueField: "code",
                displayField: "code",
                type: "MultiComboBoxItem",
                textMatchStyle: "substring",
                comboBoxWidth: 155,
                comboBoxProperties: {
                    pickListWidth: 400,
                    useClientFiltering: true,
                },
            },
            {
                name: "termTitleFa",
                title: "<spring:message code="term"/>",
                type: "SelectItem",
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
                optionDataSource: TermDS_PresenceReport,
            },
            {
                name: "fromDate",
                titleColSpan: 3,
                title: "تاریخ شروع کلاس: از",
                ID: "startDate_PresenceReport",
                hint: "--/--/----",
                criteriaField: "classStartDate",
                operator: "greaterOrEqual",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate_PresenceReport', this, 'ymd', '/');
                    }
                }],
                textAlign: "center",
                changed: function (form, item, value) {
                    let dateCheck;
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
                ID: "endDate_PresenceReport",
                hint: "--/--/----",
                criteriaField: "classStartDate",
                operator: "lessOrEqual",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('endDate_PresenceReport', this, 'ymd', '/');
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
                ID: "searchBtn_PresenceReport",
                title: "<spring:message code="reporting"/>",
                type: "ButtonItem",
                colSpan: 1,
                width:"*",
                startRow:false,
                endRow:false,
                click (form) {
                    let criteria = form.getValuesAsAdvancedCriteria();
                    if(criteria === null || Object.keys(form.getValuesAsCriteria()).length === 0) {
                        MainLG_PresenceReport.setData([]);
                        createDialog("info","فیلتری انتخاب نشده است.");
                    }
                    else{
                        if(form.getValue("studentPersonnelNo2") !== undefined){
                            let cr = [];
                            for (let i = 0; i < criteria.criteria.length; i++) {
                                if(criteria.criteria[i]["fieldName"] !== "studentPersonnelNo2"){
                                    cr.push(criteria.criteria[i])
                                }
                            }
                            cr.push({fieldName: "studentPersonnelNo2", operator: "inSet", value: form.getValue("studentPersonnelNo2").split(',').toArray()});
                            criteria.criteria = cr;
                        }
                        MainLG_PresenceReport.invalidateCache();
                        MainGridDS_PresenceReport.implicitCriteria = criteria;
                        MainLG_PresenceReport.fetchData(criteria)
                    }
                }
            },
            {
                name: "clearBtn",
                title: "<spring:message code="clear"/>",
                type: "ButtonItem",
                width:"*",
                colSpan: 2,
                startRow:false,
                endRow:false,
                click (form) {
                    form.clearValues();
                    MainLG_PresenceReport.setData([]);
                }
            }
        ],
        itemChanged (){
            MainLG_PresenceReport.setData([]);
        },
    });

    CriteriaForm_PresenceReport.getField("courseCode").comboBox.pickListFields = [
        {name: "code", autoFitWidth: true},
        {name: "titleFa"},
    ];
    CriteriaForm_PresenceReport.getField("courseCode").comboBox.setHint("دوره های مورد نظر را انتخاب کنید");
    CriteriaForm_PresenceReport.getField("courseCode").comboBox.filterFields = ["titleFa", "code"];
    CriteriaForm_PresenceReport.getField("courseCode").comboBox.textMatchStyle="substring";
    CriteriaForm_PresenceReport.getField("courseCode").comboBox.pickListProperties= {
        showFilterEditor: false,
        pickListWidth: 400,
        showClippedValuesOnHover: true,
    };
    CriteriaForm_PresenceReport.getField("studentCcpAffairs").comboBox.filterFields = ["value", "value"];
    CriteriaForm_PresenceReport.getField("studentCcpAffairs").comboBox.textMatchStyle="substring";
    CriteriaForm_PresenceReport.getField("studentCcpAffairs").comboBox.setHint("امورهای مورد نظر را انتخاب کنید");
    CriteriaForm_PresenceReport.getField("studentCcpAffairs").comboBox.pickListProperties= {
        showFilterEditor: false,
        pickListWidth: 400,
        showClippedValuesOnHover: true,
    };
    CriteriaForm_PresenceReport.getField("studentCcpUnit").comboBox.filterFields = ["value", "value"];
    CriteriaForm_PresenceReport.getField("studentCcpUnit").comboBox.textMatchStyle="substring";
    CriteriaForm_PresenceReport.getField("studentCcpUnit").comboBox.setHint("واحدهای مورد نظر را انتخاب کنید");
    CriteriaForm_PresenceReport.getField("studentCcpUnit").comboBox.pickListProperties= {
        showFilterEditor: false,
        pickListWidth: 400,
        showClippedValuesOnHover: true,
    };
    CriteriaForm_PresenceReport.getField("studentCcpSection").comboBox.filterFields = ["value", "value"];
    CriteriaForm_PresenceReport.getField("studentCcpSection").comboBox.textMatchStyle="substring";
    CriteriaForm_PresenceReport.getField("studentCcpSection").comboBox.setHint("مرکز هزینه های مورد نظر را انتخاب کنید");
    CriteriaForm_PresenceReport.getField("studentCcpSection").comboBox.pickListProperties= {
        showFilterEditor: false,
        pickListWidth: 400,
        showClippedValuesOnHover: true,
    };
    CriteriaForm_PresenceReport.getField("studentCcpAssistant").comboBox.filterFields = ["value", "value"];
    CriteriaForm_PresenceReport.getField("studentCcpAssistant").comboBox.textMatchStyle="substring";
    CriteriaForm_PresenceReport.getField("studentCcpAssistant").comboBox.setHint("معاونت های مورد نظر را انتخاب کنید");
    CriteriaForm_PresenceReport.getField("studentCcpAssistant").comboBox.pickListProperties= {
        showFilterEditor: false,
        showClippedValuesOnHover: true,
    };
    CriteriaForm_PresenceReport.getField("studentCompanyName").comboBox.filterFields = ["value", "value"];
    CriteriaForm_PresenceReport.getField("studentCompanyName").comboBox.textMatchStyle="substring";
    CriteriaForm_PresenceReport.getField("studentCompanyName").comboBox.pickListProperties= {
        showFilterEditor: false,
        showClippedValuesOnHover: true,
    };
    CriteriaForm_PresenceReport.getField("studentComplexTitle").comboBox.filterFields = ["value", "value"];
    CriteriaForm_PresenceReport.getField("studentComplexTitle").comboBox.textMatchStyle="substring";
    CriteriaForm_PresenceReport.getField("studentComplexTitle").comboBox.pickListProperties= {
        showFilterEditor: false,
        showClippedValuesOnHover: true,
    };

    MainGridMenu_PresenceReport = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="global.form.print.excel"/>",
                click: function () {
                    // ExportToFile.downloadExcelFromClient(MainLG_PresenceReport,null,"","دوره های گذرانده پرسنل");
                }
            }
        ]
    });
    
    ExcelButton_PresenceReport = isc.ToolStripButtonExcel.create({
        margin:5,
        click: function() {

            let criteria = CriteriaForm_PresenceReport.getValuesAsAdvancedCriteria();

            if(criteria != null && Object.keys(criteria).length !== 0) {

                if(CriteriaForm_PresenceReport.getValue("studentPersonnelNo2") !== undefined){
                    let cr = [];
                    for (let i = 0; i < criteria.criteria.length; i++) {
                        if(criteria.criteria[i]["fieldName"] !== "studentPersonnelNo2"){
                            cr.push(criteria.criteria[i])
                        }
                    }
                    cr.push({fieldName: "studentPersonnelNo2", operator: "inSet", value: CriteriaForm_PresenceReport.getValue("studentPersonnelNo2").split(',').toArray()});
                    criteria.criteria = cr;
                }
            }else{
                return ;
            }

            ExportToFile.showDialog(null, MainLG_PresenceReport, 'studentClassReport', 0, null, '',  "دوره هاي گذراننده پرسنل", criteria, null);
        }
    });

    MainLG_PresenceReport = isc.TrLG.create({
        ID: "MainLG_PresenceReport",
        dynamicTitle: true,
        autoFetchData: false,
        allowAdvancedCriteria: true,
        contextMenu: MainGridMenu_PresenceReport,
        dataSource: MainGridDS_PresenceReport,
        filterOnKeypress: false,
        showFilterEditor: true,

        gridComponents: [CriteriaForm_PresenceReport, ExcelButton_PresenceReport, "header", "filterEditor", "body"],
        <%--fields:[--%>
        <%--    {--%>
        <%--        name: "studentPersonnelNo2",--%>
        <%--    },--%>
        <%--    {name: "studentNationalCode",--%>
        <%--        keyPressFilter: "[0-9]"--%>
        <%--    },--%>
        <%--    {name: "studentFirstName"},--%>
        <%--    {name: "studentLastName"},--%>
        <%--    {name: "studentCcpAffairs"},--%>
        <%--    {name: "studentCcpUnit"},--%>
        <%--    {name: "studentPostCode"},--%>
        <%--    {name: "studentPostTitle"},--%>
        <%--    {name: "courseCode"},--%>
        <%--    {name: "courseTitleFa"},--%>
        <%--    {name: "classHDuration"},--%>
        <%--    {name: "classStartDate"},--%>
        <%--    {name: "classEndDate", title:"<spring:message code="end.date"/>", filterOperator: "equals", autoFitWidth: true}--%>
        <%--]--%>
    });

    isc.VLayout.create({
        width: "100%",
        height: "100%",
        overflow: "visible",
        members: [MainLG_PresenceReport]
    });

    //</script>
