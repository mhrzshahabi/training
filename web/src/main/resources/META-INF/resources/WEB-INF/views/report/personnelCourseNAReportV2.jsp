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

    isPassedDS_PCNR = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true, hidden: true},
                {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidthApproach: "both", autoFitWidth: true},
                {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
            ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/PassedStatus"
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
            {name: "personnelPostGradeTitle", title: "<spring:message code='post.grade'/>", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
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
            {name: "personnelPostTitle"},
            {name: "personnelPostGradeTitle"},
            {name: "personnelCcpAffairs"},
            {name: "personnelCcpSection"},
            {name: "personnelCcpUnit"},
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
    NAMinCourseDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "courseId", primaryKey: true, hidden: true},
            {name: "courseCode", title:"<spring:message code='course.code'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseTitleFa", title:"<spring:message code='course.title'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelFirstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelLastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelNationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelPersonnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelPersonnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelPostTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelPostCode", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCcpAffairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCcpSection", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCcpUnit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "priorityId", title: "<spring:message code='priority'/>", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "isPassed", title: "<spring:message code='status'/>", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelPostGradeTitle", title: "<spring:message code='post.grade'/>", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
        ],
        fetchDataURL: personnelCourseNAReportUrl + "/minList"
    });


    NACourseDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "courseId", primaryKey: true, hidden: true},
            {name: "courseCode", title:"<spring:message code='course.code'/>", filterOperator: "iContains", autoFitWidth: true},
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
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpArea"
    });
    AssistantDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpAssistant"
    });
    AffairsDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpAffairs"
    });

    UnitDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpUnit"
    });
    SectionDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="term.code"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpSection"
    });

    CourseDS_PCNR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code", title: "<spring:message code="course.code"/>"},
            {name: "titleFa", title: "<spring:message code="course.title"/>"},
        ],
        fetchDataURL: courseUrl + "spec-list",
    });

    PersonnelDS_PCNR_DF = isc.TrDS.create({
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

    var RestDataSource_PostGradeLvl_PCNR = isc.TrDS.create({
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

    FilterDF_PCNR = isc.DynamicForm.create({
        border: "1px solid black",
        numCols: 10,
        padding: 10,
        margin:0,
        titleAlign:"left",
        wrapItemTitles: true,
        fields: [
            {
                name: "personnelNationalCode",

                title:"انتخاب پرسنل",
                operator: "inSet",
                textAlign: "center",
                optionDataSource: PersonnelDS_PCNR_DF,
                autoFetchData: false,
                type: "MultiComboBoxItem",
                valueField: "nationalCode",
                displayField: "personnelNo",
                endRow: false,
                colSpan: 3,
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
            {
                name: "postGradeId",
                title:"<spring:message code='post.grade'/>",
                operator: "inSet",
                textAlign: "center",
                optionDataSource: RestDataSource_PostGradeLvl_PCNR,
                autoFetchData: false,
                type: "MultiComboBoxItem",
                valueField: "id",
                displayField: "titleFa",
                endRow: false,
                colSpan: 4,
                width: 300,
                layoutStyle: "horizontal",
                comboBoxProperties: {
                    hint: "",
                    pickListWidth: 300,
                    pickListFields: [
                        {name: "titleFa"},
                    ],
                    filterFields: ["titleFa"],
                    pickListProperties: {
                        sortField: 1,
                        showFilterEditor: true},
                    textMatchStyle: "substring",
                },
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
                separateSpecialValues: true,
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
                separateSpecialValues: true,
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
                separateSpecialValues: true,
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
                separateSpecialValues: true,
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
                separateSpecialValues: true,
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
                separateSpecialValues: true,
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
            {
                ID: "reportType",
                name: "reportType",
                colSpan: 1,
                // rowSpan: 1,
                title: "نوع گزارش :",
                wrapTitle: false,
                type: "radioGroup",
                vertical: false,
                endRow: true,
                fillHorizontalSpace: true,
                defaultValue: "2",
                valueMap: {
                    "1": "آماری",
                    "2": "لیستی",
                },
                change: function (form, item, value, oldValue) {


                    if (value === "1"){
                        VLayout_Body_PCNR.addMember(CourseLG_PCNR);
                        VLayout_Body_PCNR.removeMember(CourseLG_MinPCNR);
                    }
                    else if(value === "2"){
                        VLayout_Body_PCNR.removeMember(CourseLG_PCNR);
                        VLayout_Body_PCNR.addMember(CourseLG_MinPCNR);
                    }
                    else
                        return false;

                }
            },
            {type: "SpacerItem"},
            {
                name: "reportBottom",
                title: "گزارش گیری",
                type: "ButtonItem",
                align: "right",
                endRow: false,
                click: function () {
                    if(!hasFilters()) {
                        createDialog("info","فیلتری انتخاب نشده است.");
                    } else{
                        var criteria = FilterDF_PCNR.getValuesAsAdvancedCriteria();
                        criteria.criteria.remove(criteria.criteria.find({fieldName: "reportType"}));

                        CourseLG_PCNR.implicitCriteria = criteria;
                        CourseLG_PCNR.invalidateCache();
                        CourseLG_PCNR.fetchData();

                        CourseLG_MinPCNR.implicitCriteria = criteria;
                        CourseLG_MinPCNR.invalidateCache();
                        CourseLG_MinPCNR.fetchData();
                    }
                }
            },
            {
                title: "<spring:message code="global.form.print.excel"/>",
                type: "ButtonItem",
                startRow: false,
                click: function () {
                    if(!hasFilters()) {
                        createDialog("info","فیلتری انتخاب نشده است.");
                    } else{
                        let criteria = FilterDF_PCNR.getValuesAsAdvancedCriteria();
                        criteria.criteria.remove(criteria.criteria.find({fieldName: "reportType"}));

                        if (FilterDF_PCNR.getItem("reportType").getValue() === "1"){
                            // ExportToFile.showDialog(null, CourseLG_PCNR, "personnelCourseNAR", 0, null, '',"آمار دوره های نیازسنجی افراد - آماری"  , criteria, null);
                            ExportToFile.downloadExcelFromClient(CourseLG_PCNR,null,"","آمار دوره های نیازسنجی افراد - آماری");
                        }
                        else if(FilterDF_PCNR.getItem("reportType").getValue() === "2"){
                            ExportToFile.showDialog(null, CourseLG_MinPCNR, "personnelCourseNAR", 0, null, '',"آمار دوره های نیازسنجی افراد - لیستی"  , criteria, null);
                            // ExportToFile.downloadExcelFromClient(CourseLG_MinPCNR,null,"","آمار دوره های نیازسنجی افراد - لیستی");
                        }
                    }
                }
            }
        ],
    });

    CourseLG_PCNR = isc.TrLG.create({
        dynamicTitle: true,
        autoFetchData: false,
        allowAdvancedCriteria: true,
        dataSource: NACourseDS_PCNR,
        filterLocally: true,
        filterOnKeypress: false,
        showFilterEditor: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        useClientFiltering: true,
        gridComponents: [ "header", "filterEditor", "body"],
        fields:[
            {name: "courseCode"},
            {name: "courseTitleFa"},
            {name: "totalEssentialPersonnelCount"},
            {name: "notPassedEssentialPersonnelCount"},
            {name: "totalImprovingPersonnelCount"},
            {name: "notPassedImprovingPersonnelCount"},
            {name: "totalDevelopmentalPersonnelCount"},
            {name: "notPassedDevelopmentalPersonnelCount"},
            {
                name: "totalNotPassed",
                title: "جمع کل پرسنل نگذرانده",
                filterOperator: "equals",
                autoFitWidth: true,
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

                        var criteria = FilterDF_PCNR.getValuesAsAdvancedCriteria();
                        criteria.criteria.remove(criteria.criteria.find({fieldName: "reportType"}));

                        PersonnelsLG_PCNR.implicitCriteria = criteria;
                        PersonnelsLG_PCNR.implicitCriteria.criteria.addAll([
                            {fieldName: "isPassed" ,operator: "equals", value: isPassedDS_PCNR.cacheResultSet.allRows.find({code:"false"}).id},
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

    CourseLG_MinPCNR = isc.TrLG.create({
        dynamicTitle: true,
        autoFetchData: false,
        allowAdvancedCriteria: true,
        hidden:true,
        dataSource: NAMinCourseDS_PCNR,
        filterOnKeypress: false,
        showFilterEditor: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        useClientFiltering: true,
        gridComponents: [ "header", "filterEditor", "body"],
        // FilterDF_PCNR
        fields:[
            {name: "personnelPersonnelNo"},
            {name: "personnelPersonnelNo2"},
            {name: "personnelNationalCode"},
            {name: "personnelFirstName"},
            {name: "personnelLastName"},
            {name: "courseCode"},
            {name: "courseTitleFa"},
            {
                name: "priorityId",
                filterOnKeypress: true,
                editorType: "ComboBoxItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: PriorityDS_PCNR,
                pickListProperties: {
                    autoFitWidthApproach: "both",
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
            {
                name: "isPassed",
                filterOnKeypress: true,
                editorType: "ComboBoxItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: isPassedDS_PCNR,
                pickListProperties: {
                    autoFitWidthApproach: "both",
                    autoFitWidth: true,
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
            {name: "personnelPostCode"},
            {name: "personnelPostTitle"},
            {name: "personnelCcpAffairs"},
            {name: "personnelCcpSection"},
            {name: "personnelCcpUnit"},
            {name: "personnelPostGradeTitle"},
        ],
    });

    VLayout_Body_PCNR = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            FilterDF_PCNR,
            CourseLG_MinPCNR,
        ]
    });


    //##--------------------#Functions#---------------------------------##

    function hasFilters(){
        let state = FilterDF_PCNR.getValuesAsCriteria().criteria;
        let arry = state !== undefined ? state : Object.keys(FilterDF_PCNR.getValuesAsCriteria());
        if(state === undefined && arry.length < 2)
            return false;
        else if(state === undefined)
            return true;
        else if(state.length < 2 && arry.length < 3)
            return false;
        else
            return true;
    }

    //</script>