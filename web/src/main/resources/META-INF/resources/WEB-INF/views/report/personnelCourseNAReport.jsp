<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    //--------------------------------------------------------------------------------------------------------------------//
    //*personnel form*/
    //--------------------------------------------------------------------------------------------------------------------//

    PriorityDS_PCNR = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true, hidden: true},
                {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
                {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
            ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/NeedsAssessmentPriority"
    });

    PersonnelDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "personnelId", primaryKey: true, hidden: true},
            {name: "personnelPersonnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelPersonnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelFirstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelLastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelPostTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelCcpAffairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelCcpSection", title: "<spring:message code='section'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelCcpUnit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "priorityId", title: "<spring:message code='priority'/>", filterOperator: "equals", autoFitWidth: true},
        ],
        fetchDataURL: personnelCourseNAReportUrl + "/personnel-list"
    });

    Menu_Personnel_PCNR = isc.Menu.create({
        data: [{
            title: "<spring:message code="refresh"/>", click: function () {
                refreshLG(PersonnelsLG_PCNR);
            }
        }]
    });

    PersonnelsLG_PCNR = isc.TrLG.create({
        dataSource: PersonnelDS_PCNR,
        contextMenu: Menu_Personnel_PCNR,
        selectionType: "none",
        allowAdvancedCriteria: true,
        autoFetchData: false,
        fields: [
            {name: "personnelPersonnelNo"},
            {name: "personnelPersonnelNo2"},
            {name: "personnelNationalCode"},
            {name: "personnelFirstName"},
            {name: "personnelLastName"},
            {name: "personnelPostTitle"},
            {name: "personnelCcpAffairs"},
            {name: "personnelCcpSection"},
            {name: "personnelCcpUnit"},
            {
                name: "priorityId",
                filterOnKeypress: true,
                editorType: "ComboBoxItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: PriorityDS_PCNR,
                pickListProperties: {
                    showFilterEditor: false,
                    autoFitWidthApproach: "both",
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
        ],
    });

    ToolStripButton_Personnel_Refresh_PCNR = isc.ToolStripButtonRefresh.create({
        click: function () {
            refreshLG(PersonnelsLG_PCNR);
        }
    });

    ToolStrip_Personnel_Actions_PCNR = isc.ToolStrip.create({
        width: "100%",
        align: "left",
        border: '0px',
        members: [
            ToolStripButton_Personnel_Refresh_PCNR
        ]
    });

    Window_Personnel_PCNR = isc.Window.create({
        placement: "fillScreen",
        title: "لیست پرسنل",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [isc.TrVLayout.create({
            members: [
                ToolStrip_Personnel_Actions_PCNR,
                PersonnelsLG_PCNR
            ]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*course form*/
    //--------------------------------------------------------------------------------------------------------------------//

    NACourseDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "courseId", primaryKey: true, hidden: true},
            {name: "courseCode", title:"<spring:message code='course.code'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "courseTitleFa", title:"<spring:message code='course.title'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "totalEssentialPersonnelCount", title: "تعداد کل پرسنل در اولویت ضروری", filterOperator: "equals", autoFitWidth: true},
            {name: "notPassedEssentialPersonnelCount", title:"تعداد پرسنل نگذرانده در اولویت ضروری", filterOperator: "equals", autoFitWidth: true},
            {name: "totalImprovingPersonnelCount", title: "تعداد کل پرسنل در اولویت کل بهبود", filterOperator: "equals", autoFitWidth: true},
            {name: "notPassedImprovingPersonnelCount", title:"تعداد پرسنل نگذرانده در اولویت بهبود", filterOperator: "equals", autoFitWidth: true},
            {name: "totalDevelopmentalPersonnelCount", title: "تعداد کل پرسنل در اولویت توسعه ای", filterOperator: "equals", autoFitWidth: true},
            {name: "notPassedDevelopmentalPersonnelCount", title:"تعداد پرسنل نگذرانده در اولویت توسعه ای", filterOperator: "equals", autoFitWidth: true},
        ],
        fetchDataURL: personnelCourseNAReportUrl
    });

    CompanyDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="company"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=companyName"
    });
    AreaDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=ccpArea"
    });
    ComplexDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=complexTitle"
    });
    AssistantDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=ccpAssistant"
    });
    AffairsDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=ccpAffairs"
    });
    
    UnitDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=ccpUnit"
    });
    SectionDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="term.code"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=ccpSection"
    });

    CourseDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code", title: "<spring:message code="course.code"/>"},
            {name: "titleFa", title: "<spring:message code="course.title"/>"},
        ],
        fetchDataURL: courseUrl + "spec-list",
    });

    PersonnelDS_PCNR = isc.TrDS.create({
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

    FilterDF_PCNR = isc.DynamicForm.create({
        border: "1px solid black",
        numCols: 10,
        padding: 10,
        margin:0,
        titleAlign:"left",
        wrapItemTitles: true,
        fields: [
            {
                name: "personnelPersonnelNo",
                title:"انتخاب پرسنل",
                operator: "inSet",
                textAlign: "center",
                optionDataSource: PersonnelDS_PCNR,
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
            <%--    title:"پرسنلی 6رقمی",--%>
            <%--    &lt;%&ndash;title:"<spring:message code="personnel.no.6.digits"/>",&ndash;%&gt;--%>
            <%--    textAlign: "center",--%>
            <%--},--%>
            <%--{--%>
            <%--    name: "personnelPersonnelNo",--%>
            <%--    title:"<spring:message code="personnel.no"/> ",--%>
            <%--    textAlign: "center",--%>
            <%--},--%>
            <%--{--%>
            <%--    name: "personnelNationalCode",--%>
            <%--    title:"<spring:message code="national.code"/> ",--%>
            <%--    textAlign: "center",--%>
            <%--},--%>
            <%--{--%>
            <%--    name: "personnelFirstName",--%>
            <%--    title:"<spring:message code="firstName"/> ",--%>
            <%--    textAlign: "center",--%>
            <%--},--%>
            <%--{--%>
            <%--    name: "personnelLastName",--%>
            <%--    title:"<spring:message code="lastName"/> ",--%>
            <%--    textAlign: "center",--%>
            <%--},--%>
            {
                name: "personnelComplexTitle",
                title: "<spring:message code="complex"/>",
                optionDataSource: ComplexDS_PCNR,
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
                optionDataSource: CompanyDS_PCNR,
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
                optionDataSource: AreaDS_PCNR,
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
                optionDataSource: AssistantDS_PCNR,
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
                optionDataSource: SectionDS_PCNR,
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
                optionDataSource: UnitDS_PCNR,
                autoFetchData: false,
                valueField: "value",
                displayField: "value",
                specialValues: { "**emptyValue**": ""},
                separateSpecialValues: true
            },
            {
                name: "personnelCcpAffairs",
                title: "<spring:message code="affairs"/>",
                optionDataSource: AffairsDS_PCNR,
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
                optionDataSource: CourseDS_PCNR,
                autoFetchData: false,
                type: "MultiComboBoxItem",
                valueField: "id",
                displayField: "code",
                endRow: false,
                layoutStyle: "horizontal",
                // comboBoxWidth: 200,
                // layoutStyle: "horizontal",
                comboBoxProperties: {
                    hint: "",
                    pickListWidth: 400,
                    pickListFields: [
                        {name: "code", autoFitWidth: true},
                        {name: "titleFa"},
                    ],
                    filterFields: ["titleFa", "code"],
                    pickListProperties: {},
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
                    if(Object.keys(FilterDF_PCNR.getValuesAsCriteria()).length === 0) {
                        createDialog("info","فیلتری انتخاب نشده است.");
                    } else{
                        CourseLG_PCNR.implicitCriteria = FilterDF_PCNR.getValuesAsAdvancedCriteria();
                        CourseLG_PCNR.invalidateCache();
                        CourseLG_PCNR.fetchData();
                    }
                }
            }
        ],
    });

    CourseLG_PCNR = isc.TrLG.create({
        dynamicTitle: true,
        autoFetchData: false,
        allowAdvancedCriteria: true,
        // contextMenu: Menu_Courses_PCNR,
        dataSource: NACourseDS_PCNR,
        filterOnKeypress: true,
        showFilterEditor: false,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        useClientFiltering: true,
        gridComponents: [FilterDF_PCNR, "header", "filterEditor", "body"],
        fields:[
            {name: "courseCode"},
            {name: "courseTitleFa"},
            {name: "totalEssentialPersonnelCount", canFilter: false},
            {name: "notPassedEssentialPersonnelCount", canFilter: false},
            {name: "totalImprovingPersonnelCount", canFilter: false},
            {name: "notPassedImprovingPersonnelCount", canFilter: false},
            {name: "totalDevelopmentalPersonnelCount", canFilter: false},
            {name: "notPassedDevelopmentalPersonnelCount", canFilter: false},
            {
                name: "totalNotPassed",
                title: "جمع کل پرسنل نگذرانده",
                filterOperator: "equals",
                autoFitWidth: true,
                canFilter: false,
                formatCellValue: function (value, record) {
                    return record.notPassedEssentialPersonnelCount + record.notPassedImprovingPersonnelCount + record.notPassedDevelopmentalPersonnelCount;
                },
                sortNormalizer: function (record) {
                    return record.notPassedEssentialPersonnelCount + record.notPassedImprovingPersonnelCount + record.notPassedDevelopmentalPersonnelCount;
                }
            },
            { name: "personnelList", title: "لیست پرسنل", align: "center", width: 130, canFilter: false},
        ],
        createRecordComponent : function (record, colNum) {
            let fieldName = this.getFieldName(colNum);
            if (fieldName === "personnelList") {
                return isc.IButton.create({
                    width: 120,
                    layoutAlign: "center",
                    title: "مشاهده لیست پرسنل",
                    click: function () {
                        Window_Personnel_PCNR.show();
                        PersonnelsLG_PCNR.implicitCriteria = FilterDF_PCNR.getValuesAsAdvancedCriteria();
                        PersonnelsLG_PCNR.implicitCriteria.criteria.addAll([
                            {fieldName: "isPassed" ,operator: "equals", value: false},
                            {fieldName: "courseId", operator: "equals", value: record.courseId}
                        ]);
                        PersonnelsLG_PCNR.invalidateCache();
                        PersonnelsLG_PCNR.fetchData();
                    }
                });
            } else {
                return null;
            }
        }
    });

    VLayout_Body_PCNR = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [CourseLG_PCNR]
    });

 //</script>