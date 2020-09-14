<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%--
  ~ Author: Mehran Golrokhi
  ~ Created Date: 2020/09/13
  ~ Last Modified: 2020/09/13
  --%>

// <script>


    PersonnelCourseDS_SICC = isc.TrDS.create({
        fields: [
            {name: "personnelId", hidden: true},
            {name: "personnelPersonnelNo2", title: "<spring:message code='personnel.no.6.digits'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNationalCode", title: "<spring:message code='national.code'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelFirstName", title: "<spring:message code='firstName'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelLastName", title: "<spring:message code='lastName'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelCcpUnit", title: "<spring:message code='unit'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelCcpSection", title: "<spring:message code='section'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelCcpAssistant", title: "<spring:message code='assistance'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelCcpArea", title: "<spring:message code='area'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelComplexTitle", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelCcpAffairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelCompanyName", title: "<spring:message code="company"/>", filterOperator: "iContains", autoFitWidth: true},

            {name: "courseId", hidden: true},
            {name: "courseCode", title: "<spring:message code='course.code'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseTitleFa", title: "<spring:message code='course.title'/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: personnelCourseNotPassedReportUrl
    });

    CompanyDS_SICC = isc.TrDS.create({
        fields: [{name: "value", title: "<spring:message code="company"/>", filterOperator: "iContains", autoFitWidth: true}],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=companyName"
    });

    AreaDS_SICC = isc.TrDS.create({
        fields: [{name: "value", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true}],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpArea"
    });

    ComplexDS_SICC = isc.TrDS.create({
        fields: [{name: "value", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true}],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=complexTitle"
    });

    AssistantDS_SICC = isc.TrDS.create({
        fields: [{name: "value", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true}],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpAssistant"
    });

    AffairsDS_SICC = isc.TrDS.create({
        fields: [{name: "value", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true}],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpAffairs"
    });

    UnitDS_SICC = isc.TrDS.create({
        fields: [{name: "value", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true}],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpUnit"
    });

    SectionDS_SICC = isc.TrDS.create({
        fields: [{name: "value", title: "<spring:message code="term.code"/>", filterOperator: "iContains", autoFitWidth: true}],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpSection"
    });


    StudentInClassDS_SICC = isc.TrDS.create({
        fields: [
            {name: "personalNum", title: "<spring:message code='personnel.no'/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personalNum2", title: "<spring:message code='personnel.no.6.digits'/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "nationalCode", title: "<spring:message code='national.code'/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "name", title: "<spring:message code='student'/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "ccpComplex", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "ccpAssistant", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "ccpAffairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "ccpUnit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "ccpSection", title: "<spring:message code="section"/>", filterOperator: "iContains"},
            {name: "classCode", title: "<spring:message code="class.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "className", title: "<spring:message code="class.title"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "startDate", title: "<spring:message code="start.date"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "endDate", title: "<spring:message code="end.date"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personelType", title: "نوع فراگیر", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
        ],
        fetchDataURL: viewStudentsInCanceledClassReportUrl + "/spec-list",
    });

    FilterDF_SICC = isc.DynamicForm.create({
        border: "1px solid black",
        numCols: 10,
        padding: 10,
        margin: 0,
        titleAlign: "left",
        wrapItemTitles: true,
        fields: [
            {
                name: "startDate",
                titleColSpan: 1,
                title: "<spring:message code='start.date'/>",
                ID: "startDate_SICC",
                //required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate_SICC', this, 'ymd', '/');
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
            },
            {
                name: "endDate",
                titleColSpan: 1,
                title: "<spring:message code='end.date'/>",
                ID: "endDate_SICC",
                type: 'text',
                //required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate_SICC', this, 'ymd', '/');
                    }
                }],
                textAlign: "center",
                // colSpan: 2,
                changed: function (form, item, value) {
                    let dateCheck;
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        form.clearFieldErrors("endDate", true);
                        form.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                    } else {
                        form.clearFieldErrors("endDate", true);
                    }
                }
            },
            {
                name: "ccpComplex",
                title: "<spring:message code="area"/>",
                optionDataSource: ComplexDS_SICC,
                startRow: true,
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
                name: "ccpAssistant",
                title: "<spring:message code="assistance"/>",
                optionDataSource: AssistantDS_SICC,
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
                name: "ccpAffairs",
                title: "<spring:message code="affairs"/>",
                optionDataSource: AffairsDS_SICC,
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
                name: "ccpUnit",
                title: "<spring:message code="unitName"/>",
                optionDataSource: UnitDS_SICC,
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
                name: "ccpSection",
                title: "<spring:message code="section"/>",
                optionDataSource: SectionDS_SICC,
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
            {type: "SpacerItem"},
            {
                name: "reportBottom",
                title: "گزارش گیری",
                type: "ButtonItem",
                align: "right",
                startRow: true,
                click: function () {
                    let tmp = FilterDF_SICC.getValuesAsAdvancedCriteria();

                    if(tmp == null)
                    {
                        createDialog("info", "فیلتری انتخاب نشده است.");
                        return;
                    }

                    let indexOf=tmp.criteria.filter(p=>p.fieldName=="startDate");
                    if(indexOf.length==0) {
                        createDialog("info", "فیلتری انتخاب نشده است.");
                        return;
                    }

                    indexOf=tmp.criteria.filter(p=>p.fieldName=="endDate");
                    if(indexOf.length==0) {
                        createDialog("info", "فیلتری انتخاب نشده است.");
                        return;
                    }

                    if (tmp.criteria.length === 0) {
                        createDialog("info", "فیلتری انتخاب نشده است.");
                    } else {

                        for (let i = 0; i < tmp.criteria.size(); i++) {

                            if (tmp.criteria[i].fieldName == "startDate") {
                                tmp.criteria[i].operator = "greaterOrEqual";
                            } else if (tmp.criteria[i].fieldName == "endDate") {
                                tmp.criteria[i].operator = "lessOrEqual";
                            }
                        }

                        PersonnelCourseLG_SICC.implicitCriteria = tmp;

                        PersonnelCourseLG_SICC.invalidateCache();
                        PersonnelCourseLG_SICC.fetchData();
                    }
                }
            }
        ],
    });

    PersonnelCourseLG_SICC = isc.TrLG.create({
        dynamicTitle: true,
        autoFetchData: false,
        allowAdvancedCriteria: true,
        dataSource: StudentInClassDS_SICC,
        // filterOnKeypress: true,
        // showFilterEditor: false,
        gridComponents: [FilterDF_SICC,
            isc.ToolStripButtonExcel.create({
                margin:5,
                click:function() {

                    let implicitCriteria = JSON.parse(JSON.stringify(PersonnelCourseLG_SICC.getImplicitCriteria())) ;

                    if(implicitCriteria == null)
                    {
                        createDialog("info", "فیلتری انتخاب نشده است.");
                        return;
                    }

                    let indexOf=implicitCriteria.criteria.filter(p=>p.fieldName=="startDate");
                    if(indexOf.length==0) {
                        createDialog("info", "فیلتری انتخاب نشده است.");
                        return;
                    }

                    indexOf=implicitCriteria.criteria.filter(p=>p.fieldName=="endDate");
                    if(indexOf.length==0) {
                        createDialog("info", "فیلتری انتخاب نشده است.");
                        return;
                    }


                    if (implicitCriteria.criteria.length === 0) {
                        createDialog("info", "فیلتری انتخاب نشده است.");
                    } else {

                        for (let i = 0; i < implicitCriteria.criteria.size(); i++) {

                            if (implicitCriteria.criteria[i].fieldName == "startDate") {
                                implicitCriteria.criteria[i].operator = "greaterOrEqual";
                            } else if (implicitCriteria.criteria[i].fieldName == "endDate") {
                                implicitCriteria.criteria[i].operator = "lessOrEqual";
                            }
                        }


                        let criteria = PersonnelCourseLG_SICC.getCriteria();

                        if(PersonnelCourseLG_SICC.getCriteria().criteria){
                            for (let i = 0; i < criteria.criteria.length ; i++) {
                                implicitCriteria.criteria.push(criteria.criteria[i]);
                            }
                        }


                        ExportToFile.downloadExcelRestUrl(null, PersonnelCourseLG_SICC, viewStudentsInCanceledClassReportUrl + "/spec-list", 0, null, '',  "گزارش کلاس های حذف شده", criteria, null);


                    }

                }
            }), "header", "filterEditor", "body"],
        fields: [
            {name: "personalNum",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "personalNum2",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "nationalCode"},
            {name: "name"},
            {name: "personelType",valueMap:
                    {
                        "personnel_registered": "متفرقه",
                        "Personal": "شرکتی",
                        "ContractorPersonal": "پیمانکار"
                    }},
            {name: "ccpComplex"},
            {name: "ccpAssistant"},
            {name: "ccpAffairs"},
            {name: "ccpUnit"},
            {name: "classCode"},
            {name: "className"},
            {name: "startDate"},
            {name: "endDate"},
        ],
        initialSort: [
            {property: "personalNum", direction: "ascending"},
            {property: "classCode", direction: "ascending"}
        ],
    });

    VLayout_Body_SICC = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [PersonnelCourseLG_SICC]
    });

    //</script>