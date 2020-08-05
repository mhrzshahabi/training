<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>
    //----------------------------------------- properties ----------------->>

    let needsAssessmentStateValueMap = {"1": "نیازسنجی", "2": "غیر نیازسنجی", "3": "همه"};
    let acceptanceStateValueMap = {"1": "گذرانده", "2": "نگذرانده", "3": "همه"};
    let classStateValueMap = {"1": "ثبت شده در پرونده", "2": "ثبت نام شده در کلاس", "3": "در حال اجرای کلاس", "4": "همه"};

    // <<-------------------------------------- Create - RestDataSource  ----------------------------
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

    AffairsDS_PTSR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=ccpAffairs"
    });

    AreaDS_PTSR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=ccpArea"
    });

    AssistantDS_PTSR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpAssistant"
    });

    UnitDS_PTSR = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpUnit"
    });

    var RestDataSource_PostGradeLvl_PTSR = isc.TrDS.create({
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

    CourseDS_PTSR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code", title: "<spring:message code="course.code"/>"},
            {name: "titleFa", title: "<spring:message code="course.title"/>"},
        ],
        fetchDataURL: courseUrl + "spec-list",
    });

    PersonnelTrainingStatusReport_DS = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "organizer", title: "<spring:message code="organizer"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNoTD", title: "<spring:message code="personnel.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelFirstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelLastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelJobCode", title: "<spring:message code="job.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "PersonnelJobTitle", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelPostTitle", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnel_Post_code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "company", title: "<spring:message code="company"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelAssisstant", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelUnit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelCppArea", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelCppAffairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseCode", title: "<spring:message code='course.code'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseTitleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "needsAssessmentState", title: "<spring:message code='needsAssessment.type'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "personnelPostGradeCode", title: "<spring:message code="post.grade.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelPostGradeTitle", title: "<spring:message code='post.grade'/>", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "skillCode", title: "<spring:message code='skill.code'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "skillTitle", title: "<spring:message code='skill.title'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "acceptanceState", title: "<spring:message code='acceptanceState.state'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "needsAssessmentPriority", title: "<spring:message code='priority'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "classState", title: "<spring:message code='class.status'/>", filterOperator: "equals", autoFitWidth: true},

        ],
        fetchDataURL: viewPersonnelTrainingStatusReportUrl + "/iscList"
    });

    //------------------------------------------ Menu ---------------------------------------------->>

    PersonnelTrainingStatusReport_Menu = isc.Menu.create({
        data: [{
            title: "<spring:message code="refresh"/>", click: function () {
            }
        }]
    });

    // <<--------------------------------- Create - DynamicForm & Window & Layout -----------------------------

    FilterDF_PTSR = isc.DynamicForm.create({
        border: "1px solid black",
        numCols: 10,
        padding: 10,
        margin:0,
        titleAlign:"left",
        wrapItemTitles: true,
        fields: [
            {
                name: "personnelNo",
                title:"انتخاب پرسنل",
                operator: "inSet",
                textAlign: "center",
                optionDataSource: PersonnelDS_PTSR_DF,
                autoFetchData: false,
                type: "MultiComboBoxItem",
                valueField: "personnelNo",
                displayField: "personnelNo",
                endRow: false,
                colSpan: 7,
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
                name: "needsAssessmentState",
                colSpan: 2,
                title: "<spring:message code="needsAssessment.type"/>:",
                wrapTitle: true,
                type: "radioGroup",
                vertical: true,
                fillHorizontalSpace: true,
                defaultValue: "1",
// endRow:true,
                valueMap: {
                    "1": "فقط نیازسنجی",
                    "2": "فقط غیر نیازسنجی",
                    "3": "همه",
                },
            },
            {
                name: "acceptanceState",
                colSpan: 2,
                title: "<spring:message code="acceptanceState.state"/>:",
                wrapTitle: true,
                type: "radioGroup",
                vertical: true,
                fillHorizontalSpace: true,
                defaultValue: "1",
// endRow:true,
                valueMap: {
                    "1": "گذرانده",
                    "2": "نگذرانده",
                    "3": "همه",
                },
            },
            {
                name: "classState",
                colSpan: 2,
                title: "<spring:message code="class.status"/>:",
                wrapTitle: true,
                type: "radioGroup",
                vertical: true,
                fillHorizontalSpace: true,
                defaultValue: "1",
// endRow:true,
                valueMap: {
                    "1": "ثبت شده در پرونده",
                    "2": "ثبت نام شده در کلاس",
                    "2": "در حال اجرای کلاس",
                    "4": "همه",
                },
            },
            {
                name: "personnelCppArea",
                title: "<spring:message code="area"/>",
                filterFields: ["value", "value"],
                // pickListWidth: 300,
                colSpan: 1,
                type: "ComboBoxItem",
                textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                optionDataSource: AreaDS_PTSR,
                autoFetchData: false,
                valueField: "value",
                displayField: "value",
                specialValues: { "**emptyValue**": ""},
                separateSpecialValues: true
            },
            {
                name: "personnelCcpAssistant",
                colSpan: 1,
                title: "<spring:message code="assistance"/>",
                filterFields: ["value", "value"],
                pickListWidth: 300,
                type: "ComboBoxItem",
                textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                optionDataSource: AssistantDS_PTSR,
                autoFetchData: false,
                valueField: "value",
                displayField: "value",
                specialValues: { "**emptyValue**": ""},
                separateSpecialValues: true
            },
            {
                name: "personnelCppAffairs",
                title: "<spring:message code="affairs"/>",
                optionDataSource: AffairsDS_PTSR,
                colSpan: 1,
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
                name: "personnelCcpUnit",
                colSpan: 1,
                title: "<spring:message code="unitName"/>",
                filterFields: ["value", "value"],
                pickListWidth: 300,
                type: "ComboBoxItem",
                textMatchStyle: "substring",
                pickListProperties: {
                    showFilterEditor: false,
                    showClippedValuesOnHover: true,
                },
                optionDataSource: UnitDS_PTSR,
                autoFetchData: false,
                valueField: "value",
                displayField: "value",
                specialValues: { "**emptyValue**": ""},
                separateSpecialValues: true
            },
            {
                name: "courseCode",
                title: "<spring:message code="course"/>",
                operator: "inSet",
                optionDataSource: CourseDS_PTSR,
                colSpan: 1,
                autoFetchData: false,
                type: "MultiComboBoxItem",
                valueField: "code",
                displayField: "code",
                endRow: false,
                layoutStyle: "horizontal",
                comboBoxWidth: 175,
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
                name: "personnelPostGradeTitle",
                title:"<spring:message code='post.grade'/>",
                operator: "inSet",
                textAlign: "center",
                optionDataSource: RestDataSource_PostGradeLvl_PTSR,
                autoFetchData: false,
                type: "MultiComboBoxItem",
                valueField: "titleFa",
                displayField: "titleFa",
                endRow: false,
                colSpan: 1,
                comboBoxWidth: 175,
                layoutStyle: "horizontal",
                comboBoxProperties: {
                    hint: "",
                    // pickListWidth: 300,
                    pickListFields: [
                        {name: "titleFa"},
                    ],
                    filterFields: ["titleFa"],
                    pickListProperties: {
                        sortField: 1,
                        showFilterEditor: true
                    },
                    textMatchStyle: "substring",
                },
            },
            {type: "SpacerItem"},
            {
                name: "reportBottom",
                title: "گزارش گیری",
                type: "ButtonItem",
                align: "right",
                endRow: false,
                click: function () {
                    if (!hasFilters()) {
                        createDialog("info", "فیلتری انتخاب نشده است.");
                    } else {
                        var criteria = FilterDF_PTSR.getValuesAsAdvancedCriteria();
                        criteria.criteria.remove(criteria.criteria.find({fieldName: "needsAssessmentState"}));
                        criteria.criteria.remove(criteria.criteria.find({fieldName: "acceptanceState"}));
                        criteria.criteria.remove(criteria.criteria.find({fieldName: "classState"}));
                        let needsAssessmentStateval = needsAssessmentStateValueMap[FilterDF_PTSR.getItem("needsAssessmentState").getValue()];
                        let acceptanceStateVal = acceptanceStateValueMap[FilterDF_PTSR.getItem("acceptanceState").getValue()];
                        let classStateVal = classStateValueMap[FilterDF_PTSR.getItem("classState").getValue()];
                        if (needsAssessmentStateval !== "همه")
                            criteria.criteria.push({fieldName: "needsAssessmentState", operator: "equals", value: needsAssessmentStateval});
                        if(acceptanceStateVal !== "همه")
                            criteria.criteria.push({fieldName: "acceptanceState", operator: "equals", value: acceptanceStateVal});
                        if(classStateVal !== "همه")
                            criteria.criteria.push({fieldName: "classState", operator: "equals", value: classStateVal});
                        PersonnelTrainingStatusReport_LG.implicitCriteria = criteria;
                        PersonnelTrainingStatusReport_LG.invalidateCache();
                        PersonnelTrainingStatusReport_LG.fetchData();
                    }
                }
            },
            {
                title: "<spring:message code="global.form.print.excel"/>",
                type: "ButtonItem",
                startRow: false,
                click: function () {
                    if(hasFilters()) {
                        createDialog("info","فیلتری انتخاب نشده است.");
                    } else{
                        var criteria = FilterDF_PTSR.getValuesAsAdvancedCriteria();
                        criteria.criteria.remove(criteria.criteria.find({fieldName: "needsAssessmentState"}));
                        let val = needsAssessmentStateValueMap[FilterDF_PTSR.getItem("needsAssessmentState").getValue()];
                        if (val !== "همه")
                            criteria.criteria.push({fieldName: "needsAssessmentState", operator: "equals", value: val});
                        if(criteria.criteria.length < 1)
                            criteria = {};
                        ExportToFile.showDialog(null, PersonnelTrainingStatusReport_LG, "viewPersonnelTrainingStatusReport", 0, null, '',"گزارش وضعیت آموزشی افراد"  , criteria, null);

                    }
                }
            }
        ],
    });

    // <<----------------------------------------------- List Grid --------------------------------------------
    PersonnelTrainingStatusReport_LG = isc.TrLG.create({
        dataSource: PersonnelTrainingStatusReport_DS,
        contextMenu: PersonnelTrainingStatusReport_Menu,
        selectionType: "none",
        allowAdvancedCriteria: true,
        autoFetchData: false,
        fields: [
            {name: "id",hidden: true},
            {name: "organizer"},
            {name: "personnelNo"},
            {name: "personnelNoTD"},
            {name: "personnelNationalCode"},
            {name: "personnelFirstName"},
            {name: "personnelLastName"},
            {name: "personnelJobCode"},
            {name: "PersonnelJobTitle"},
            {name: "personnelPostTitle"},
            {name: "personnel_Post_code"},
            {name: "company"},
            {name: "personnelAssisstant"},
            {name: "personnelUnit"},
            {name: "personnelCppArea"},
            {name: "personnelCppAffairs"},
            {name: "courseCode"},
            {name: "courseTitleFa"},
            {name: "needsAssessmentState"},
            {name: "personnelPostGradeCode"},
            {name: "personnelPostGradeTitle"},
            {name: "skillCode"},
            {name: "skillTitle"},
            {name: "acceptanceState"},
            {name: "needsAssessmentPriority"},
            {name: "classState"},
        ],
    });
    // <<----------------------------------------------- Layout -------------------------------------------->>

    VLayout_Body_PTSR = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            FilterDF_PTSR,
            PersonnelTrainingStatusReport_LG
        ]
    });

    // <<----------------------------------------------- Functions --------------------------------------------
    function hasFilters(){
        if(Object.keys(FilterDF_PTSR.getValuesAsCriteria()).length < 3 && FilterDF_PTSR.getValuesAsCriteria().criteria === undefined)
            return false;
        else if(FilterDF_PTSR.getValuesAsCriteria().criteria !== undefined && Object.keys(FilterDF_PTSR.getValuesAsCriteria().criteria).length < 4)
            return false
        else
            return true;
    }

    // </script>