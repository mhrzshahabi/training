<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
// <script>

    $(document).ready(()=>{
        setTimeout(()=>{
        $("input[name='personnelNo']").attr("disabled","disabled");
        $("input[name='courseCode']").attr("disabled","disabled");
        $("input[name='postGrade']").attr("disabled","disabled");
    },0)}
    );

    let criteriaDisplayValuesPostGrade;
    var isPassedDS_PCNR_data;
    let data_values;

    //----------------------------------------------------Rest DataSource-----------------------------------------------
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
        transformResponse: function (dsResponse, dsRequest, data) {
            isPassedDS_PCNR_data=data;
            return this.Super("transformResponse", arguments);
        },
        fetchDataURL: parameterUrl + "/iscList/PassedStatus"
    });

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
            {name: "courseCode", title:"<spring:message code='course.code'/>", filterOperator: "iContains"},
            {name: "courseTitleFa", title:"<spring:message code='course.title'/>", filterOperator: "iContains"},
            {name: "totalEssentialServicePersonnelCount", title: "تعداد کل پرسنل در اولویت ضروری ضمن خدمت", filterOperator: "equals"},
            {name: "notPassedEssentialServicePersonnelCount", title:"تعداد پرسنل نگذرانده در اولویت ضروری ضمن خدمت", filterOperator: "equals"},
            {name: "totalEssentialAppointmentPersonnelCount", title: "تعداد کل پرسنل در اولویت ضروری انتصاب سمت", filterOperator: "equals"},
            {name: "notPassedEssentialAppointmentPersonnelCount", title:"تعداد پرسنل نگذرانده در اولویت ضروری انتصاب سمت", filterOperator: "equals"},
            {name: "totalImprovingPersonnelCount", title: "تعداد کل پرسنل در اولویت بهبود", filterOperator: "equals"},
            {name: "notPassedImprovingPersonnelCount", title:"تعداد پرسنل نگذرانده در اولویت بهبود", filterOperator: "equals"},
            {name: "totalDevelopmentalPersonnelCount", title: "تعداد کل پرسنل در اولویت توسعه ای", filterOperator: "equals"},
            {name: "notPassedDevelopmentalPersonnelCount", title:"تعداد پرسنل نگذرانده در اولویت توسعه ای", filterOperator: "equals"},
        ],
        fetchDataURL: personnelCourseNAReportUrl
    });

    RestDataSource_JspCourseNAReportPersonnel = isc.TrDS.create({
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
            {name: "personnelPostGradeTitle", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseId", hidden: true},
            {name: "courseCode", title: "<spring:message code='course.code'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "courseTitleFa", title: "<spring:message code='course.title'/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: personnelCourseNotPassedReportUrl
    });

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
            {name: "postGradeTitle", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
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
            criteria:[{fieldName: "deleted", operator: "equals", value: 0}]
        },
    });

    RestDataSource_Class_JspCourseNAReportPersonnel = isc.TrDS.create({
        ID: "classDS",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleClass"},
            {name: "code"},
            {name: "course.titleFa"}
        ],
        fetchDataURL: classUrl + "info-tuple-list"
    });

    RestDataSource_Category_JspCourseNAReportReport = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "spec-list"
    });

    RestDataSource_Course_JspCourseNAReportReport = isc.TrDS.create({
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

    var RestDataSource_PostGradeLvl_PCNR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "peopleType", title: "<spring:message code="people.type"/>",filterOnKeypress: true, filterOperator: "equals", autoFitWidth: true, valueMap:peopleTypeMap},
            {
                name: "code",
                title: "<spring:message code="post.grade.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains"},
            {
                name: "enabled",
                title: "<spring:message code="active.status"/>",
                align: "center",
                filterOperator: "equals",
                autoFitWidth: true,
                autoFitWidthApproach: "both",
                valueMap: {"undefined": "فعال", "74": "غیرفعال"},
                filterOnKeypress: true
            },
        ],
        fetchDataURL: viewPostGradeUrl + "/iscList"
    });

    //----------------------------------------------------ListGrid Result-----------------------------------------------
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
    ToolStripButton_Personnel_Export2EXcel_PCNR = isc.ToolStripButtonExcel.create({
        click: function () {
            let titr = null;
            if(typeof(selectedCourse.courseCode) !== undefined) {
                titr = "کد دوره: " + selectedCourse.courseCode + " نام دوره: " + selectedCourse.courseTitleFa;
            }
            ExportToFile.downloadExcelRestUrl(null, PersonnelsLG_PCNR, personnelCourseNAReportUrl + "/personnel-list" , 0, null, titr,"آمار دوره های نیازسنجی افراد - لیست پرسنل", PersonnelsLG_PCNR.getCriteria(), null);
        }
    });
    ToolStrip_Personnel_Actions_PCNR = isc.ToolStrip.create({
        width: "100%",
        align: "right",
        border: '0px',
        members: [

            ToolStripButton_Personnel_Export2EXcel_PCNR,
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

    CourseLG_PCNR = isc.TrLG.create({
        dynamicTitle: true,
        autoFetchData: false,
        dataSource: NACourseDS_PCNR,
        filterOnKeypress: false,
        showFilterEditor: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        gridComponents: [ "header", "filterEditor", "body"],
        fields:[
            {name: "courseCode"},
            {name: "courseTitleFa"},
            {name: "totalEssentialServicePersonnelCount"},
            {name: "notPassedEssentialServicePersonnelCount"},
            {name: "totalEssentialAppointmentPersonnelCount"},
            {name: "notPassedEssentialAppointmentPersonnelCount"},
            {name: "totalImprovingPersonnelCount"},
            {name: "notPassedImprovingPersonnelCount"},
            {name: "totalDevelopmentalPersonnelCount"},
            {name: "notPassedDevelopmentalPersonnelCount"},
            {
                name: "totalNotPassed",
                title: "تعداد کل پرسنل نگذرانده",
                // filterOperator: "equals",
                autoFitWidth: true,
                canFilter: false,
                formatCellValue: function (value, record) {
                    if(record.notPassedEssentialServicePersonnelCount || record.notPassedEssentialAppointmentPersonnelCount ||
                        record.notPassedImprovingPersonnelCount || record.notPassedDevelopmentalPersonnelCount)
                        return record?.notPassedEssentialServicePersonnelCount + record?.notPassedEssentialAppointmentPersonnelCount +
                            record?.notPassedImprovingPersonnelCount + record?.notPassedDevelopmentalPersonnelCount;
                    return 0;
                },
                sortNormalizer: function (record) {
                    return record?.notPassedEssentialServicePersonnelCount + record?.notPassedEssentialAppointmentPersonnelCount +
                        record?.notPassedImprovingPersonnelCount + record?.notPassedDevelopmentalPersonnelCount;
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
                        selectedCourse = record;
                        Window_Personnel_PCNR.show();
                        PersonnelsLG_PCNR.implicitCriteria = JSON.parse(JSON.stringify(data_values));
                        PersonnelsLG_PCNR.implicitCriteria.criteria.addAll([
                            {
                                fieldName: "isPassed",
                                operator: "equals",
                                value: isPassedDS_PCNR_data.response.data.find({code: "false"}).id
                            },
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

    IButton_JspCourseNAReportPersonnel_FullExcel = isc.IButtonSave.create({
        top: 260,
        title: "گزارش اکسل",
        width: 300,
        click: function () {
            ExportToFile.downloadExcelRestUrl(null, CourseLG_MinPCNR, personnelCourseNAReportUrl + "/minList", 0, null, '',"آمار دوره های نیازسنجی افراد - لیستی"  , CourseLG_MinPCNR.data.getCriteria(), null);
        }
    });

    IButton_JspCourseNAReportPersonnel_FullExcelPart2 = isc.IButtonSave.create({
        top: 260,
        title: "گزارش اکسل",
        width: 300,
        click: function () {
            ExportToFile.downloadExcelRestUrl(null, CourseLG_PCNR, personnelCourseNAReportUrl, 0, null, '', "آمار دوره های نیازسنجی افراد - آماری", CourseLG_PCNR.data.getCriteria(), null, 1, false, ["totalNotPassed", "personnelList"]);
        }
    });

    var HLayOut_CriteriaForm_JspCourseNAReportPersonnel_Details = isc.TrHLayoutButtons.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "100%",
        alignLayout: "center",
        members: [
            CourseLG_MinPCNR
        ]
    });

    var HLayOut_Confirm_JspCourseNAReportPersonnel_UnitExcel = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_JspCourseNAReportPersonnel_FullExcel
        ]
    });

    var Window_JspCourseNAReportPersonnel = isc.Window.create({
        placement: "fillScreen",
        title: "گزارش آمار دوره های نیازسنجی افراد - لیستی",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [
            isc.TrVLayout.create({
                members: [
                    HLayOut_CriteriaForm_JspCourseNAReportPersonnel_Details,HLayOut_Confirm_JspCourseNAReportPersonnel_UnitExcel
                ]
            })
        ]
    });
    /////////////////////////////////////////////////////////

    var HLayOut_CriteriaForm_JspCourseNAReportPersonnel_DetailsPart2 = isc.TrHLayoutButtons.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "100%",
        alignLayout: "center",
        members: [
            CourseLG_PCNR
        ]
    });

    var HLayOut_Confirm_JspCourseNAReportPersonnel_UnitExcelPart2 = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_JspCourseNAReportPersonnel_FullExcelPart2
        ]
    });

    var Window_JspCourseNAReportPersonnelPart2 = isc.Window.create({
        placement: "fillScreen",
        title: "گزارش آمار دوره های نیازسنجی افراد - آماری",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [
            isc.TrVLayout.create({
                members: [
                    HLayOut_CriteriaForm_JspCourseNAReportPersonnel_DetailsPart2,HLayOut_Confirm_JspCourseNAReportPersonnel_UnitExcelPart2
                ]
            })
        ]
    });

    //----------------------------------------------------Criteria Form------------------------------------------------
    var DynamicForm_CriteriaForm_JspCourseNAReportPersonnel = isc.DynamicForm.create({
        align: "right",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 4,
        colWidths: ["5%", "25%", "5%", "25%","5%","25%"],
        fields: [
            {
                name: "personnelNo",
                title: "شماره پرسنلي",
                hint: "شماره پرسنلي را انتخاب نمایید",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                        Window_SelectPeople_JspCourseNAReport.show();
                    }}],
                keyPressFilter: "[A-Z|0-9|,-]"
            },
            {
                name: "postGrade",
                title: "رده پستی",
                hint: "رده پستی را انتخاب نمایید",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                        Window_SelectPostGrade_JspCourseNAReport.show();
                    }}],
                keyPressFilter: "[A-Z|0-9|,-]"
            },
            {
                name: "temp1",
                title: "",
                canEdit: false
            },
            {
                name: "courseCode",
                title: "کد دوره",
                hint: "کد دوره را وارد نمایید",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                        Window_SelectCourses_JspCourseNAReportReport.show();
                    }
                }],
                keyPressFilter: "[A-Z|0-9|;-]"
            },
            {
                name: "reportType",
                title: "نوع گزارش :",
                type: "radioGroup",
                vertical:false,
                defaultValue: "1",
                valueMap: {
                    "1": "آماری",
                    "2": "لیستی",
                }
            },
        ],
    });

    var organSegmentFilter = init_OrganSegmentFilterDF(true,true, true , null, "complexTitle","assistant","affairs", "section", "unit")

    var initialLayoutStyle = "vertical";

    var DynamicForm_SelectPeople_JspCourseNAReport = isc.DynamicForm.create({
        align: "center",
        titleWidth: 0,
        titleAlign: "center",
        width: 500,
        height: 300,
        fields: [
            {
                name: "people.code",
                align: "center",
                title: "",
                editorType: "MultiComboBoxItem",
                multiple: true,
                defaultValue: null,
                changeOnKeypress: true,
                showHintInField: true,
                displayField: "personnelNo",
                comboBoxWidth: 500,
                valueField: "personnelNo",
                layoutStyle: initialLayoutStyle,
                optionDataSource: PersonnelDS_PTSR_DF
            }
        ]
    });

    DynamicForm_SelectPeople_JspCourseNAReport.getField("people.code").comboBox.setHint("پرسنل مورد نظر را انتخاب کنید");
    DynamicForm_SelectPeople_JspCourseNAReport.getField("people.code").comboBox.pickListFields =
        [
            {name: "firstName", title: "نام", autoFitWidth:true, filterOperator: "iContains"},
            {name: "lastName", title: "نام خانوادگي", autoFitWidth:true, filterOperator: "iContains"},
            {name: "nationalCode", title: "کدملي", autoFitWidth:true, filterOperator: "iContains"},
            {name: "personnelNo", title: "کد پرسنلي", autoFitWidth:true, filterOperator: "iContains"},
            {name: "personnelNo2", title: "کد پرسنلي 6 رقمي",autoFitWidth:true, filterOperator: "iContains"},
        ];
    DynamicForm_SelectPeople_JspCourseNAReport.getField("people.code").comboBox.filterFields = ["firstName","lastName","nationalCode","personnelNo","personnelNo2"];

    IButton_ConfirmPeopleSelections_JspCourseNAReport = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            let criteriaDisplayValues = "";
            let selectorDisplayValues = DynamicForm_SelectPeople_JspCourseNAReport.getItem("people.code").getValue();
            if (DynamicForm_SelectPeople_JspCourseNAReport.getField("people.code").getValue() != undefined && DynamicForm_SelectPeople_JspCourseNAReport.getField("people.code").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectPeople_JspCourseNAReport.getField("people.code").getValue().join(",");
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

            criteriaDisplayValues = criteriaDisplayValues == "undefined" ? "" : criteriaDisplayValues;

            DynamicForm_CriteriaForm_JspCourseNAReportPersonnel.getField("personnelNo").setValue(criteriaDisplayValues);
            Window_SelectPeople_JspCourseNAReport.close();
        }
    });

    var Window_SelectPeople_JspCourseNAReport = isc.Window.create({
        placement: "center",
        title: "انتخاب پرسنل",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "2px solid gray",
        width: 500,
        height: 300,
        items: [
            isc.TrVLayout.create({
                members: [
                    DynamicForm_SelectPeople_JspCourseNAReport,
                    IButton_ConfirmPeopleSelections_JspCourseNAReport,
                ]
            })
        ]
    });

    var DynamicForm_SelectPostGrade_JspCourseNAReport = isc.DynamicForm.create({
        align: "center",
        titleWidth: 0,
        titleAlign: "center",
        width: 500,
        height: 120,
        fields: [
            {
                name: "PostGrade.code",
                align: "center",
                title: "",
                editorType: "SelectItem",
                multiple: true,
                defaultValue: null,
                showHintInField: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_PostGradeLvl_PCNR,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {name: "titleFa", title: "<spring:message code="post.grade.title"/>", width: "30%", filterOperator: "iContains"},
                    {name: "peopleType",  title: "نوع فراگیر", width: "30%", filterOperator: "iContains"},
                    {name: "enabled",  title: "فعال/غیرفعال", width: "30%", filterOperator: "iContains"}
                ],
                icons: [{
                    src: "[SKIN]/actions/remove.png",
                    prompt: "پاک کردن",
                    click: function (form) {
                        form.getField("PostGrade.code").setValue([]);
                    }
                }]
            }
        ]
    });
    DynamicForm_SelectPostGrade_JspCourseNAReport.getField("PostGrade.code").setHint("رده پستی مورد نظر را انتخاب کنید");

    IButton_ConfirmPostGradeSelections_JspCourseNAReport = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 150,
        click: function () {

            var selectorDisplayValues = DynamicForm_SelectPostGrade_JspCourseNAReport.getItem("PostGrade.code").getValue();
            criteriaDisplayValuesPostGrade = selectorDisplayValues;

            if (selectorDisplayValues != null) {
                DynamicForm_CriteriaForm_JspCourseNAReportPersonnel.getField("postGrade").setValue(selectorDisplayValues);
            } else {
                DynamicForm_CriteriaForm_JspCourseNAReportPersonnel.getField("postGrade").setValue([]);
            }

            DynamicForm_CriteriaForm_JspCourseNAReportPersonnel.getField("postGrade").setValue(DynamicForm_SelectPostGrade_JspCourseNAReport.getItem("PostGrade.code").getDisplayValue().join(","));
            Window_SelectPostGrade_JspCourseNAReport.close();
        }
    });
    IButton_CancelPostGradeSelections_JspCourseNAReport = isc.IButtonCancel.create({
        top: 260,
        title: "انصراف",
        width: 150,
        click: function () {
            Window_SelectPostGrade_JspCourseNAReport.close();
        }
    });

    var Window_SelectPostGrade_JspCourseNAReport = isc.Window.create({
        placement: "center",
        title: "انتخاب رده پستی",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "2px solid gray",
        width: 500,
        height: 150,
        items: [
            isc.TrVLayout.create({
                members: [
                    DynamicForm_SelectPostGrade_JspCourseNAReport,
                    isc.HLayout.create({
                        align: "center",
                        membersMargin: 10,
                        members: [
                            IButton_ConfirmPostGradeSelections_JspCourseNAReport,
                            IButton_CancelPostGradeSelections_JspCourseNAReport
                        ]
                    })
                ]
            })
        ]
    });

    var DynamicForm_SelectCourses_JspCourseNAReportReport = isc.DynamicForm.create({
        align: "center",
        titleWidth: 0,
        titleAlign: "center",
        width: 500,
        height: 300,
        fields: [
            {
                name: "courseCode",
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
                optionDataSource: RestDataSource_Course_JspCourseNAReportReport
            }
        ]
    });
    DynamicForm_SelectCourses_JspCourseNAReportReport.getField("courseCode").comboBox.setHint("دوره های مورد نظر را انتخاب کنید");
    DynamicForm_SelectCourses_JspCourseNAReportReport.getField("courseCode").comboBox.pickListFields =
        [{name: "titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"},
            {
                name: "code", title: "کد دوره", width: "30%", filterOperator: "iContains"
            }];
    DynamicForm_SelectCourses_JspCourseNAReportReport.getField("courseCode").comboBox.filterFields = ["titleFa", "code"];

    IButton_ConfirmCourseSelections_JspCourseNAReportReport = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            var criteriaDisplayValues = "";
            var selectorDisplayValues = DynamicForm_SelectCourses_JspCourseNAReportReport.getItem("courseCode").getValue();
            if (DynamicForm_SelectCourses_JspCourseNAReportReport.getField("courseCode").getValue() != undefined
                && DynamicForm_SelectCourses_JspCourseNAReportReport.getField("courseCode").getValue() != "") {
                criteriaDisplayValues = DynamicForm_SelectCourses_JspCourseNAReportReport.getField("courseCode").getValue().join(",");
                var ALength = criteriaDisplayValues.length;
                var lastChar = criteriaDisplayValues.charAt(ALength - 1);
                if (lastChar != ";")
                    criteriaDisplayValues += ",";
            }
            if (selectorDisplayValues != undefined) {
                for (var i = 0; i < selectorDisplayValues.size() - 1; i++) {
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

            criteriaDisplayValues = criteriaDisplayValues == "undefined" ? "" : criteriaDisplayValues;

            DynamicForm_CriteriaForm_JspCourseNAReportPersonnel.getField("courseCode").setValue(criteriaDisplayValues);
            Window_SelectCourses_JspCourseNAReportReport.close();
        }
    });

    var Window_SelectCourses_JspCourseNAReportReport = isc.Window.create({
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
                    DynamicForm_SelectCourses_JspCourseNAReportReport,
                    IButton_ConfirmCourseSelections_JspCourseNAReportReport
                ]
            })
        ]
    });

    IButton_JspCourseNAReportPersonnel = isc.IButtonSave.create({
        top: 260,
        title: "چاپ گزارش",
        width: 300,
        click: function () {
            if((organSegmentFilter.getCriteria(DynamicForm_CriteriaForm_JspCourseNAReportPersonnel.getValuesAsAdvancedCriteria())).criteria.length <= 1) {
                createDialog("info","فیلتری انتخاب نشده است.");
                return;
            }
            if (DynamicForm_CriteriaForm_JspCourseNAReportPersonnel.hasErrors() || organSegmentFilter.hasErrors())
                return;

            isPassedDS_PCNR.fetchData();

                data_values = organSegmentFilter.getCriteria(DynamicForm_CriteriaForm_JspCourseNAReportPersonnel.getValuesAsAdvancedCriteria());
                for (let i = 0; i < data_values.criteria.size(); i++) {
                    if (data_values.criteria[i].fieldName == "personnelNo") {
                        var codesString = data_values.criteria[i].value;
                        var codesArray;
                        codesArray = codesString.split(",");
                        for (var j = 0; j < codesArray.length; j++) {
                            if (codesArray[j] == "" || codesArray[j] == " ") {
                                codesArray.remove(codesArray[j]);
                            }
                        }

                        data_values.criteria[i].fieldName = "personnelPersonnelNo";
                        data_values.criteria[i].operator = "inSet";
                        data_values.criteria[i].value = codesArray;
                    }

                    else if (data_values.criteria[i].fieldName == "courseCode") {
                        var codesString = data_values.criteria[i].value;
                        var codesArray;
                        codesArray = codesString.split(",");
                        for (var j = 0; j < codesArray.length; j++) {
                            if (codesArray[j] == "" || codesArray[j] == " ") {
                                codesArray.remove(codesArray[j]);
                            }
                        }
                        data_values.criteria[i].operator = "inSet";
                        data_values.criteria[i].value = codesArray;
                    }

                    else if (data_values.criteria[i].fieldName == "postGrade")
                    {
                        data_values.criteria[i].fieldName = "postGradeId";
                        data_values.criteria[i].operator = "inSet";
                        data_values.criteria[i].value = criteriaDisplayValuesPostGrade;
                    }

                    else if (data_values.criteria[i].fieldName == "companyName") {
                        data_values.criteria[i].fieldName = "personnelCompanyName";
                        data_values.criteria[i].operator = "iContains";
                    }
                    else if (data_values.criteria[i].fieldName == "assistant") {
                        data_values.criteria[i].fieldName = "personnelCcpAssistant";
                        data_values.criteria[i].operator = "inSet";
                    }
                    else if (data_values.criteria[i].fieldName == "unit") {
                        data_values.criteria[i].fieldName = "personnelCcpUnit";
                        data_values.criteria[i].operator = "inSet";
                    }
                    else if (data_values.criteria[i].fieldName == "affairs") {
                        data_values.criteria[i].fieldName = "personnelCcpAffairs";
                        data_values.criteria[i].operator = "inSet";
                    }
                    else if (data_values.criteria[i].fieldName == "section") {
                        data_values.criteria[i].fieldName = "personnelCcpSection";
                        data_values.criteria[i].operator = "inSet";
                    }

                    else if (data_values.criteria[i].fieldName == "complexTitle") {
                        data_values.criteria[i].fieldName = "personnelComplexTitle";
                        data_values.criteria[i].operator = "inSet";
                    }

                    else if (data_values.criteria[i].fieldName == "courseCategory") {
                        data_values.criteria[i].fieldName = "categoryId";
                        data_values.criteria[i].operator = "inSet";
                    }
                }

                data_values.criteria.remove(data_values.criteria.find({fieldName: "reportType"}));

                if (DynamicForm_CriteriaForm_JspCourseNAReportPersonnel.getField("reportType").getValue()=="1")
                {
                    CourseLG_PCNR.invalidateCache();
                    CourseLG_PCNR.fetchData(data_values);
                    Window_JspCourseNAReportPersonnelPart2.show();
                }
                else{
                    CourseLG_MinPCNR.invalidateCache();
                    CourseLG_MinPCNR.fetchData(data_values);
                    Window_JspCourseNAReportPersonnel.show();
                }
            }
    });

    //----------------------------------- layOut -----------------------------------------------------------------------
    var HLayOut_CriteriaForm_JspCourseNAReportPersonnel = isc.TrHLayoutButtons.create({
        showEdges: false,
        margin:20,
        edgeImage: "",
        alignLayout: "center",
        members: [
            DynamicForm_CriteriaForm_JspCourseNAReportPersonnel
        ]
    });

    var HLayOut_Confirm_JspCourseNAReportPersonnel = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_JspCourseNAReportPersonnel
        ]
    });

    isc.TrVLayout.create({
        members: [
            DynamicForm_CriteriaForm_JspCourseNAReportPersonnel,
            organSegmentFilter,
            HLayOut_Confirm_JspCourseNAReportPersonnel
        ]
    });
    //----------------------------------------------------End-----------------------------------------------------------
    Window_JspCourseNAReportPersonnel.hide();