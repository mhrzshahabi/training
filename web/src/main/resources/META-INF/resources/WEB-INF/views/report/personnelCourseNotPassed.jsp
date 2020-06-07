<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    PersonnelCourseDS_PCNP = isc.TrDS.create({
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

    CompanyDS_PCNP = isc.TrDS.create({
        fields: [{name: "value", title: "<spring:message code="company"/>", filterOperator: "iContains", autoFitWidth: true}],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=companyName"
    });

    AreaDS_PCNP = isc.TrDS.create({
        fields: [{name: "value", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true}],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=ccpArea"
    });

    ComplexDS_PCNP = isc.TrDS.create({
        fields: [{name: "value", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true}],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=complexTitle"
    });

    AssistantDS_PCNP = isc.TrDS.create({
        fields: [{name: "value", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true}],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=ccpAssistant"
    });

    AffairsDS_PCNP = isc.TrDS.create({
        fields: [{name: "value", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true}],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=ccpAffairs"
    });

    UnitDS_PCNP = isc.TrDS.create({
        fields: [{name: "value", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true}],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=ccpUnit"
    });

    SectionDS_PCNP = isc.TrDS.create({
        fields: [{name: "value", title: "<spring:message code="term.code"/>", filterOperator: "iContains", autoFitWidth: true}],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=ccpSection"
    });

    CourseDS_PCNP = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains"}
        ],
        fetchDataURL: courseUrl + "spec-list"
    });

    CategoryDS_PCNP = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", title: "<spring:message code="category"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true}
        ],
        cacheAllData: true,
        fetchDataURL: categoryUrl + "spec-list"
    });

    PersonnelDS_PCNP = isc.TrDS.create({
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

    FilterDF_PCNP = isc.DynamicForm.create({
        border: "1px solid black",
        numCols: 10,
        padding: 10,
        margin: 0,
        titleAlign: "left",
        wrapItemTitles: true,
        fields: [
            {
                name: "personnelPersonnelNo",
                title:"انتخاب پرسنل",
                operator: "inSet",
                textAlign: "center",
                optionDataSource: PersonnelDS_PCNP,
                autoFetchData: false,
                type: "MultiComboBoxItem",
                valueField: "personnelNo",
                displayField: "personnelNo",
                endRow: true,
                colSpan: 10,
                // comboBoxWidth: 200,
                layoutStyle: "horizontal",
                comboBoxProperties: {
                    hint: "",
                    pickListWidth: 550,
                    pickListFields: [
                        {name: "personnelNo2"},
                        {name: "firstName"},
                        {name: "lastName"},
                        {name: "nationalCode"},
                        {name: "personnelNo"}
                    ],
                    filterFields: ["personnelNo2", "firstName", "lastName", "nationalCode", "personnelNo"],
                    pickListProperties: {sortField: "personnelNo"},
                    textMatchStyle: "substring",
                },
            },
            <%--{--%>
            <%--    name: "personnelPersonnelNo2",--%>
            <%--    title: "پرسنلی 6رقمی",--%>
            <%--    &lt;%&ndash;title:"<spring:message code="personnel.no.6.digits"/>",&ndash;%&gt;--%>
            <%--    textAlign: "center",--%>
            <%--    optionDataSource: PersonnelDS_PCNP,--%>
            <%--    autoFetchData: false,--%>
            <%--    type: "MultiComboBoxItem",--%>
            <%--    valueField: "personnelNo2",--%>
            <%--    displayField: "personnelNo2",--%>
            <%--    endRow: false,--%>
            <%--    // comboBoxWidth: 200,--%>
            <%--    // layoutStyle: "horizontal",--%>
            <%--    comboBoxProperties: {--%>
            <%--        hint: "",--%>
            <%--        pickListWidth: 150,--%>
            <%--        pickListFields: [{name: "personnelNo2"}],--%>
            <%--        filterFields: ["personnelNo2", "personnelNo2"],--%>
            <%--        textMatchStyle: "substring",--%>
            <%--    },--%>
            <%--},--%>
            <%--{--%>
            <%--    name: "personnelPersonnelNo",--%>
            <%--    title: "<spring:message code="personnel.no"/> ",--%>
            <%--    textAlign: "center",--%>
            <%--    optionDataSource: PersonnelDS_PCNP,--%>
            <%--    autoFetchData: false,--%>
            <%--    type: "MultiComboBoxItem",--%>
            <%--    valueField: "personnelNo",--%>
            <%--    displayField: "personnelNo",--%>
            <%--    endRow: false,--%>
            <%--    // comboBoxWidth: 200,--%>
            <%--    // layoutStyle: "horizontal",--%>
            <%--    comboBoxProperties: {--%>
            <%--        hint: "",--%>
            <%--        pickListWidth: 150,--%>
            <%--        pickListFields: [{name: "personnelNo"}],--%>
            <%--        filterFields: ["personnelNo", "personnelNo"],--%>
            <%--        textMatchStyle: "substring",--%>
            <%--    },--%>
            <%--},--%>
            <%--{--%>
            <%--    name: "personnelNationalCode",--%>
            <%--    title: "<spring:message code="national.code"/> ",--%>
            <%--    textAlign: "center",--%>
            <%--    optionDataSource: PersonnelDS_PCNP,--%>
            <%--    autoFetchData: false,--%>
            <%--    type: "MultiComboBoxItem",--%>
            <%--    valueField: "nationalCode",--%>
            <%--    displayField: "nationalCode",--%>
            <%--    endRow: false,--%>
            <%--    // comboBoxWidth: 200,--%>
            <%--    // layoutStyle: "horizontal",--%>
            <%--    comboBoxProperties: {--%>
            <%--        hint: "",--%>
            <%--        pickListWidth: 150,--%>
            <%--        pickListFields: [{name: "nationalCode"}],--%>
            <%--        filterFields: ["nationalCode", "nationalCode"],--%>
            <%--        textMatchStyle: "substring",--%>
            <%--    },--%>
            <%--},--%>
            <%--{--%>
            <%--    name: "personnelFirstName",--%>
            <%--    title: "<spring:message code="firstName"/> ",--%>
            <%--    textAlign: "center",--%>
            <%--    optionDataSource: PersonnelDS_PCNP,--%>
            <%--    autoFetchData: false,--%>
            <%--    type: "MultiComboBoxItem",--%>
            <%--    valueField: "firstName",--%>
            <%--    displayField: "firstName",--%>
            <%--    endRow: false,--%>
            <%--    // comboBoxWidth: 200,--%>
            <%--    // layoutStyle: "horizontal",--%>
            <%--    comboBoxProperties: {--%>
            <%--        hint: "",--%>
            <%--        pickListWidth: 150,--%>
            <%--        pickListFields: [{name: "firstName"}],--%>
            <%--        filterFields: ["firstName", "firstName"],--%>
            <%--        textMatchStyle: "substring",--%>
            <%--    },--%>
            <%--},--%>
            <%--{--%>
            <%--    name: "personnelLastName",--%>
            <%--    title: "<spring:message code="lastName"/> ",--%>
            <%--    textAlign: "center",--%>
            <%--    optionDataSource: PersonnelDS_PCNP,--%>
            <%--    autoFetchData: false,--%>
            <%--    type: "MultiComboBoxItem",--%>
            <%--    valueField: "lastName",--%>
            <%--    displayField: "lastName",--%>
            <%--    endRow: false,--%>
            <%--    // comboBoxWidth: 200,--%>
            <%--    // layoutStyle: "horizontal",--%>
            <%--    comboBoxProperties: {--%>
            <%--        hint: "",--%>
            <%--        pickListWidth: 150,--%>
            <%--        pickListFields: [{name: "lastName"}],--%>
            <%--        filterFields: ["lastName", "lastName"],--%>
            <%--        textMatchStyle: "substring",--%>
            <%--    },--%>
            <%--},--%>
            {
                name: "personnelComplexTitle",
                title: "<spring:message code="complex"/>",
                optionDataSource: ComplexDS_PCNP,
                autoFetchData: false,
                filterFields: ["value", "value"],
                pickListWidth: 300,
                type: "ComboBoxItem",
                textMatchStyle: "substring",
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
                name: "personnelCompanyName",
                title: "<spring:message code="company"/>",
                filterFields: ["value", "value"],
                pickListWidth: 300,
                type: "ComboBoxItem",
                textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                optionDataSource: CompanyDS_PCNP,
                autoFetchData: false,
                valueField: "value",
                displayField: "value",
                specialValues: { "**emptyValue**": ""},
                separateSpecialValues: true
            },
            {
                name: "personnelCcpArea",
                title: "<spring:message code="area"/>",
                filterFields: ["value", "value"],
                pickListWidth: 300,
                type: "ComboBoxItem",
                textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                optionDataSource: AreaDS_PCNP,
                autoFetchData: false,
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
                optionDataSource: AssistantDS_PCNP,
                autoFetchData: false,
                valueField: "value",
                displayField: "value",
                specialValues: { "**emptyValue**": ""},
                separateSpecialValues: true
            },
            {
                name: "personnelCcpSection",
                title: "<spring:message code="section.cost"/>",
                filterFields: ["value", "value"],
                pickListWidth: 300,
                type: "ComboBoxItem",
                textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                optionDataSource: SectionDS_PCNP,
                autoFetchData: false,
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
                type: "ComboBoxItem",
                textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                optionDataSource: UnitDS_PCNP,
                autoFetchData: false,
                valueField: "value",
                displayField: "value",
                specialValues: { "**emptyValue**": ""},
                separateSpecialValues: true
            },
            {
                name: "personnelCcpAffairs",
                title: "<spring:message code="affairs"/>",
                optionDataSource: AffairsDS_PCNP,
                autoFetchData: false,
                filterFields: ["value", "value"],
                type: "ComboBoxItem",
                textMatchStyle: "substring",
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
                name: "courseId",
                title: "<spring:message code="course"/>",
                operator: "inSet",
                optionDataSource: CourseDS_PCNP,
                autoFetchData: false,
                type: "MultiComboBoxItem",
                valueField: "id",
                displayField: "code",
                // comboBoxWidth: 200,
                // layoutStyle: "horizontal",
                comboBoxProperties: {
                    hint: "",
                    pickListWidth: 500,
                    pickListFields: [
                        {name: "code"},
                        {name: "titleFa"},
                    ],
                    filterFields: ["titleFa", "code"],
                    textMatchStyle: "substring",
                },
            },
            {
                name: "categoryId",
                title: "<spring:message code="category"/>",
                operator: "inSet",
                optionDataSource: CategoryDS_PCNP,
                autoFetchData: false,
                type: "MultiComboBoxItem",
                valueField: "id",
                displayField: "code",
                endRow: false,
                // comboBoxWidth: 200,
                // layoutStyle: "horizontal",
                comboBoxProperties: {
                    hint: "",
                    pickListWidth: 150,
                    pickListFields: [
                        {name: "code"},
                        {name: "titleFa"},
                    ],
                    filterFields: ["titleFa", "code"],
                    textMatchStyle: "substring",
                },
            },
            {type: "SpacerItem"},
            {
                name: "reportBottom",
                title: "گزارش گیری",
                type: "ButtonItem",
                align: "right",
                startRow: false,
                click: function () {
                    if (Object.keys(FilterDF_PCNP.getValuesAsCriteria()).length === 0) {
                        createDialog("info", "فیلتری انتخاب نشده است.");
                    } else {
                        PersonnelCourseLG_PCNP.implicitCriteria = FilterDF_PCNP.getValuesAsAdvancedCriteria();
                        PersonnelCourseLG_PCNP.invalidateCache();
                        PersonnelCourseLG_PCNP.fetchData();
                    }
                }
            }
        ],
    });

    PersonnelCourseLG_PCNP = isc.TrLG.create({
        dynamicTitle: true,
        autoFetchData: false,
        allowAdvancedCriteria: true,
        dataSource: PersonnelCourseDS_PCNP,
        // filterOnKeypress: true,
        // showFilterEditor: false,
        gridComponents: [FilterDF_PCNP,
            isc.ToolStripButtonExcel.create({
                margin:5,
                click:function() {
                    ExportToFile.showDialog(null, PersonnelCourseLG_PCNP, 'personnelCourseNotPassed', 0, null, '',  "گزارش عدم آموزش", FilterDF_PCNP.getValuesAsCriteria(), null);
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
            {name: "personnelCcpUnit"},
            {name: "personnelCcpSection"},
            {name: "personnelCcpAssistant"},
            {name: "personnelCcpArea"},
            {name: "personnelComplexTitle"},
            {name: "personnelCcpAffairs"},
            {name: "personnelCompanyName"},

            {name: "courseCode"},
            {name: "courseTitleFa"},
        ]
    });

    VLayout_Body_PCNP = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [PersonnelCourseLG_PCNP]
    });

    //</script>