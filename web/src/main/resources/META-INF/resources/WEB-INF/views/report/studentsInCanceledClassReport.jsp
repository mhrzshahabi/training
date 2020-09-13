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

    CourseDS_SICC = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains"}
        ],
        fetchDataURL: courseUrl + "spec-list"
    });

    CategoryDS_SICC = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", title: "<spring:message code="category"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true}
        ],
        cacheAllData: true,
        fetchDataURL: categoryUrl + "spec-list"
    });

    PostGradeDS_SICC = isc.TrDS.create({
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

    PersonnelDS_SICC = isc.TrDS.create({
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
            criteria:[{ fieldName: "active", operator: "equals", value: 1}]
        },
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
                name: "start_data",
                titleColSpan: 1,
                title: "<spring:message code='start.date'/>",
                ID: "startDate_SICC",
                required: true,
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
                name: "end_data",
                titleColSpan: 1,
                title: "<spring:message code='end.date'/>",
                ID: "endDate_SICC",
                type: 'text', required: true,
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
                name: "personnelComplexTitle",
                title: "<spring:message code="complex"/>",
                optionDataSource: ComplexDS_SICC,
                autoFetchData: false,
                filterFields: ["value", "value"],
                pickListWidth: 300,
                type: "ComboBoxItem",
                textMatchStyle: "substring",
                startRow: true,
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                valueField: "value",
                displayField: "value",
                specialValues: { "**emptyValue**": ""},
                separateSpecialValues: true
            },
            {
                name: "personnelCcpAssistant",
                title: "<spring:message code="assistance"/>",
                filterFields: ["value", "value"],
                pickListWidth: 300,
                type: "ComboBoxItem",
                textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                optionDataSource: AssistantDS_SICC,
                autoFetchData: false,
                valueField: "value",
                displayField: "value",
                specialValues: { "**emptyValue**": ""},
                separateSpecialValues: true
            },
            {
                name: "personnelCcpAffairs",
                title: "<spring:message code="affairs"/>",
                optionDataSource: AffairsDS_SICC,
                autoFetchData: false,
                operator: "inSet",
                multiple: true,
                filterFields: ["value", "value"],
                type: "SelectItem",
                textMatchStyle: "substring",
                pickListFields: [
                    {
                        name: "value",
                        title: "<spring:message code="affairs"/>",
                        filterOperator: "iContains",
                    }
                ],
                pickListProperties: {
                    showFilterEditor: true,
                    showClippedValuesOnHover: true,
                },
                valueField: "value",
                displayField: "value",
                specialValues: { "**emptyValue**": ""},
                separateSpecialValues: true
            },

            {
                name: "personnelCcpUnit",
                title: "<spring:message code="unitName"/>",
                filterFields: ["value", "value"],
                pickListWidth: 300,
                multiple: true,
                type: "SelectItem",
                textMatchStyle: "substring",
                pickListFields: [
                    {
                        name: "value",
                        title: "<spring:message code="unit"/>",
                        filterOperator: "iContains",
                    }
                ],
                pickListProperties: {
                    showFilterEditor: true,
                    showClippedValuesOnHover: true,
                },
                optionDataSource: UnitDS_SICC,
                autoFetchData: false,
                valueField: "value",
                displayField: "value",
                specialValues: { "**emptyValue**": ""},
                separateSpecialValues: true
            },
            {
                name: "personnelCcpSection",
                title: "<spring:message code="section"/>",
                filterFields: ["value", "value"],
                pickListWidth: 300,
                type: "ComboBoxItem",
                textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                optionDataSource: SectionDS_SICC,
                autoFetchData: false,
                valueField: "value",
                displayField: "value",
                specialValues: { "**emptyValue**": ""},
                separateSpecialValues: true
            },
            {type: "SpacerItem"},
            {
                name: "reportBottom",
                title: "گزارش گیری",
                type: "ButtonItem",
                align: "right",
                startRow: true,
                click: function () {
                    let tmp=FilterDF_SICC.getValuesAsAdvancedCriteria();

                    if(tmp==null)
                    {
                        createDialog("info", "فیلتری انتخاب نشده است.");
                        return;
                    }

                    /*let indexOf=tmp.criteria.indexOf(tmp.criteria.filter(p=>p.fieldName=="postGrade")[0]);
                    if(indexOf>=0)
                        tmp.criteria.splice(indexOf,1);*/

                    if (tmp.criteria.length === 0) {
                        createDialog("info", "فیلتری انتخاب نشده است.");
                    } else {


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
        dataSource: PersonnelCourseDS_SICC,
        // filterOnKeypress: true,
        // showFilterEditor: false,
        gridComponents: [FilterDF_SICC,
            isc.ToolStripButtonExcel.create({
                margin:5,
                click:function() {
                    let implicitCriteria = JSON.parse(JSON.stringify(FilterDF_SICC.getValuesAsCriteria())) ;
                    let criteria = PersonnelCourseLG_SICC.getCriteria();

                    if(PersonnelCourseLG_SICC.getCriteria().criteria){
                        for (let i = 0; i < criteria.criteria.length ; i++) {
                            implicitCriteria.criteria.push(criteria.criteria[i]);
                        }
                    }

                    ExportToFile.downloadExcelRestUrl(null, PersonnelCourseLG_SICC, personnelCourseNotPassedReportUrl, 0, null, '',  "گزارش عدم آموزش", FilterDF_SICC.getValuesAsCriteria(), null);
                }
            }), "header", "filterEditor", "body"],
        fields: [
            {name: "personnelPersonnelNo2",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "personnelNationalCode",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "personnelFirstName"},
            {name: "personnelLastName"},
            {name: "personnelCcpUnit",filterOperator: "inSet"},
            {name: "personnelCcpSection"},
            {name: "personnelCcpAssistant"},
            {name: "personnelCcpArea"},
            {name: "personnelComplexTitle"},
            {name: "personnelCcpAffairs"},
            {name: "personnelCompanyName"},

            {name: "courseCode"},
            {name: "courseTitleFa"},
        ],
        initialSort: [
            {property: "personnelPersonnelNo2", direction: "ascending"},
            {property: "courseCode", direction: "ascending"}
        ],
    });

    VLayout_Body_SICC = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [PersonnelCourseLG_SICC]
    });

    //</script>