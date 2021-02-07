<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    //Amin HK
    let hideRadioButtons=false;

    $(document).ready(()=>{
        let nameTab=mainTabSet.tabs[mainTabSet.selectedTab].title;
        if (nameTab=="اطلاعات پرسنل" || nameTab=="کلاس"){
            hideRadioButtons=true;

            [...Array(3).keys()].slice(1).forEach(idx=> {
                ReportTypeDF_NABOP.getItem("reportType").getItem(idx).setDisabled(true);
                ReportTypeDF_NABOP.getItem("personnelId").hide();
            });
        }
        else if (nameTab=="گزارشات نیازسنجی"){
            [...Array(4).keys()].slice(1).forEach(idx=> {
                if (ReportTypeDF_NABOP.getItem("reportType").getItem(idx)) {
                    ReportTypeDF_NABOP.getItem("reportType").getItem(idx).setDisabled(false);
                    ReportTypeDF_NABOP.getItem("personnelId").show();
                }
            });
            hideRadioButtons=false;
        }
    });
    ////////////////////////////////////

    let titleReportExcel;
    var postCode_NABOP = null;
    var passedStatusId_NABOP = 216;
    var priorities_NABOP;
    var wait_NABOP;
    var selectedPerson_NABOP = null;
    var selectedObject_NABOP = null;
    var reportType_NABOP = "0";
    var objectType_NABOP;
    var changeablePerson_NABOP = true;
    var changeableObject_NABOP = true;
    var chartData_NABOP = [
        {title: "<spring:message code='essential'/>",  type: "<spring:message code='total'/>", duration: 0},
        {title: "<spring:message code='essential'/>",  type: "<spring:message code='passed'/>", duration: 0},
        {title: "<spring:message code='improving'/>", type: "<spring:message code='total'/>", duration: 0},
        {title: "<spring:message code='improving'/>", type: "<spring:message code='passed'/>", duration: 0},
        {title: "<spring:message code='developmental'/>",  type: "<spring:message code='total'/>", duration: 0},
        {title: "<spring:message code='developmental'/>",  type: "<spring:message code='passed'/>", duration: 0}
    ];

    isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/iscList/NeedsAssessmentPriority", "GET", null, setPriorities_NABOP));

    //--------------------------------------------------------------------------------------------------------------------//
    //*chart form*/
    //--------------------------------------------------------------------------------------------------------------------//

    Chart_NABOP = isc.FacetChart.create({
        valueProperty: "duration",
        showTitle: false,
        filled: true,
        stacked: false,
    });

    Window_Chart_NABOP = isc.Window.create({
        placement: "fillScreen",
        title: "",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 720,
        minHeight: 540,
        items: [isc.TrVLayout.create({
            members: [Chart_NABOP]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*post form*/
    //--------------------------------------------------------------------------------------------------------------------//

    TrainingPostDS_NABOP = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "departmentId", title: "departmentId", primaryKey: true, canEdit: false, hidden: true},
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap:{"Personal" : "شرکتی", "ContractorPersonal" : "پیمان کار"},filterOnKeypress: true},
            {name: "code", title: "<spring:message code='code'/>", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "jobTitleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postGradeTitleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "description", hidden: true, title: "توضیحات", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "competenceCount", hidden: true, title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCount", hidden: true, title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "lastModifiedDateNA", title: "<spring:message code="update.date"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "modifiedByNA", title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, filterOnKeypress: true,valueMap:{74 : "غیر فعال"}}
        ],
        fetchDataURL: viewTrainingPostUrl + "/iscList"
    });

    PostDS_NABOP = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap:{"Personal" : "شرکتی", "ContractorPersonal" : "پیمان کار"},filterOnKeypress: true},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "jobTitleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postGradeTitleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceCount", hidden: true, title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCount", hidden: true, title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "lastModifiedDateNA", title: "<spring:message code="update.date"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "modifiedByNA", title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, filterOnKeypress: true,valueMap:{74 : "غیر فعال"}}
        ],
        fetchDataURL: viewPostUrl + "/iscList"
    });

    PostGroupDS_NABOP = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true, hidden: true},
                {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
                {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
                {name: "description", title: "<spring:message code='description'/>", filterOperator: "iContains", autoFitWidth: true},
                {name: "competenceCount", hidden: true, title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
                {name: "personnelCount", hidden: true, title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
                {name: "lastModifiedDateNA", title: "<spring:message code="update.date"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
                {name: "modifiedByNA", title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
                {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, filterOnKeypress: true,valueMap:{74 : "غیر فعال"}}
            ],
        fetchDataURL: viewPostGroupUrl + "/iscList"
    });

    JobDS_NABOP = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true, hidden: true},
                {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap:{"Personal" : "شرکتی", "ContractorPersonal" : "پیمان کار"},filterOnKeypress: true},
                {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
                {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
                {name: "description", title: "<spring:message code='description'/>", filterOperator: "iContains", autoFitWidth: true},
                {name: "competenceCount", hidden: true, title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
                {name: "personnelCount", hidden: true, title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
                {name: "lastModifiedDateNA", title: "<spring:message code="update.date"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
                {name: "modifiedByNA", title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
                {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, filterOnKeypress: true,valueMap:{74 : "غیر فعال"}}
            ],
        fetchDataURL: viewJobUrl + "/iscList"
    });

    JobGroupDS_NABOP = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true, hidden: true},
                {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
                {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
                {name: "description", title: "<spring:message code='description'/>", filterOperator: "iContains", autoFitWidth: true},
                {name: "competenceCount", hidden: true, title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
                {name: "personnelCount", hidden: true, title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
                {name: "lastModifiedDateNA", title: "<spring:message code="update.date"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
                {name: "modifiedByNA", title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
                {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, filterOnKeypress: true,valueMap:{74 : "غیر فعال"}}
            ],
        fetchDataURL: viewJobGroupUrl + "/iscList"
    });

    PostGradeDS_NABOP = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap:{"Personal" : "شرکتی", "ContractorPersonal" : "پیمان کار"},filterOnKeypress: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "description", title: "<spring:message code='description'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceCount", hidden: true, title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCount", hidden: true, title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "lastModifiedDateNA", title: "<spring:message code="update.date"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "modifiedByNA", title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, filterOnKeypress: true,valueMap:{74 : "غیر فعال"}}
        ],
        fetchDataURL: viewPostGradeUrl + "/iscList"
    });

    PostGradeGroupDS_NABOP = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code='title'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "description", title: "<spring:message code='description'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceCount", hidden: true, title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCount", hidden: true, title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "lastModifiedDateNA", title: "<spring:message code="update.date"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "modifiedByNA", title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, filterOnKeypress: true,valueMap:{74 : "غیر فعال"}}
        ],
        fetchDataURL: viewPostGradeGroupUrl + "/iscList"
    });

    Menu_Post_NABOP = isc.Menu.create({
        data: [{
            title: "<spring:message code="refresh"/>", click: function () {
                refreshLG(Tabset_Object_NABOP.getSelectedTab().pane);
            }
        }]
    });

    TrainingPostLG_NABOP = isc.TrLG.create({
        selectionType: "single",
        dataSource: TrainingPostDS_NABOP,
        contextMenu: Menu_Post_NABOP,
        autoFetchData: true,
        rowDoubleClick: "Select_Post_NABOP()",
        sortField: 1,
        sortDirection: "descending"
    });

    PostsLG_NABOP = isc.TrLG.create({
        dataSource: PostDS_NABOP,
        contextMenu: Menu_Post_NABOP,
        selectionType: "single",
        autoFetchData: true,
        // fields: [
        //     {name: "code"},
        //     {name: "titleFa"},
        //     {name: "job.titleFa"},
        //     {name: "postGrade.titleFa"},
        //     {name: "area"},
        //     {name: "assistance"},
        //     {name: "affairs"},
        //     {name: "section"},
        //     {name: "unit"},
        //     {name: "costCenterCode"},
        //     {name: "costCenterTitleFa"}
        // ],
        rowDoubleClick: "Select_Post_NABOP()",
        sortField: 1,
        sortDirection: "descending"
    });

    JobLG_NABOP = isc.TrLG.create({
        dataSource: JobDS_NABOP,
        contextMenu: Menu_Post_NABOP,
        selectionType: "single",
        autoFetchData: true,
        // fields: [
        //     {name: "code"},
        //     {name: "titleFa"},
        //     {name: "description"}
        // ],
        rowDoubleClick: "Select_Post_NABOP()",
        sortField: 1,
        sortDirection: "descending"
    });

    PostGradeLG_NABOP = isc.TrLG.create({
        dataSource: PostGradeDS_NABOP,
        contextMenu: Menu_Post_NABOP,
        selectionType: "single",
        autoFetchData: true,
        // fields: [
        //     {name: "code"},
        //     {name: "titleFa"},
        //     {name: "description"}
        // ],
        rowDoubleClick: "Select_Post_NABOP()",
        sortField: 1,
        sortDirection: "descending"
    });

    PostGroupLG_NABOP = isc.TrLG.create({
        dataSource: PostGroupDS_NABOP,
        contextMenu: Menu_Post_NABOP,
        selectionType: "single",
        autoFetchData: true,
        // fields: [
        //     {name: "code"},
        //     {name: "titleFa"},
        //     {name: "description"}
        // ],
        rowDoubleClick: "Select_Post_NABOP()",
        sortField: 1,
        sortDirection: "descending"
    });

    JobGroupLG_NABOP = isc.TrLG.create({
        dataSource: JobGroupDS_NABOP,
        contextMenu: Menu_Post_NABOP,
        selectionType: "single",
        autoFetchData: true,
        // fields: [
        //     {name: "code"},
        //     {name: "titleFa"},
        //     {name: "description"}
        // ],
        rowDoubleClick: "Select_Post_NABOP()",
        sortField: 1,
        sortDirection: "descending"
    });

    PostGradeGroupLG_NABOP = isc.TrLG.create({
        dataSource: PostGradeGroupDS_NABOP,
        contextMenu: Menu_Post_NABOP,
        selectionType: "single",
        autoFetchData: true,
        // fields: [
        //     {name: "code"},
        //     {name: "titleFa"},
        //     {name: "description"}
        // ],
        rowDoubleClick: "Select_Post_NABOP()",
        sortField: 1,
        sortDirection: "descending"
    });

    Tabset_Object_NABOP = isc.TabSet.create({
        tabBarPosition: "right",
        tabBarThickness: 100,
        tabs: [
            {title: "<spring:message code="post"/>", name: "TrainingPost", pane: TrainingPostLG_NABOP},
            {title: "<spring:message code="post.individual"/>", name: "Post", pane: PostsLG_NABOP},
            {title: "<spring:message code="job"/>", name: "Job", pane: JobLG_NABOP},
            {title: "<spring:message code="post.grade"/>", name: "PostGrade", pane: PostGradeLG_NABOP},
            {title: "<spring:message code="post.group"/>", name: "PostGroup", pane: PostGroupLG_NABOP},
            {title: "<spring:message code="job.group"/>", name: "JobGroup", pane: JobGroupLG_NABOP},
            {title: "<spring:message code="post.grade.group"/>", name: "PostGradeGroup", pane: PostGradeGroupLG_NABOP},
        ],
    });

    IButton_Post_Ok_NABOP = isc.IButtonSave.create({
        title: "<spring:message code="select"/>",
        click: "Select_Post_NABOP()"
    });

    HLayout_Post_Ok_NABOP = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Post_Ok_NABOP]
    });

    ToolStripButton_Post_Refresh_NABOP = isc.ToolStripButtonRefresh.create({
        click: function () {
            refreshLG(Tabset_Object_NABOP.getSelectedTab().pane);
        }
    });

    ToolStrip_Post_Actions_NABOP = isc.ToolStrip.create({
        width: "100%",
        align: "left",
        border: '0px',
        members: [
            ToolStripButton_Post_Refresh_NABOP
        ]
    });

    Window_Post_NABOP = isc.Window.create({
        placement: "fillScreen",
        title: "",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [isc.TrVLayout.create({
            members: [
                ToolStrip_Post_Actions_NABOP,
                Tabset_Object_NABOP,
                HLayout_Post_Ok_NABOP
            ]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*personnel form*/
    //--------------------------------------------------------------------------------------------------------------------//

    PersonnelDS_NABOP = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postCode", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpArea", title: "<spring:message code="reward.cost.center.area"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpAssistant", title: "<spring:message code="reward.cost.center.assistant"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpAffairs", title: "<spring:message code="reward.cost.center.affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpSection", title: "<spring:message code="reward.cost.center.section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpUnit", title: "<spring:message code="reward.cost.center.unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postId", hidden: true},
        ],
        fetchDataURL: personnelUrl + "/iscList"
    });

    Menu_Personnel_NABOP = isc.Menu.create({
        data: [{
            title: "<spring:message code="refresh"/>", click: function () {
                refreshLG(PersonnelsLG_NABOP);
            }
        }]
    });

    PersonnelsLG_NABOP = isc.TrLG.create({
        dataSource: PersonnelDS_NABOP,
        autoFitWidthApproach: "both",
        contextMenu: Menu_Personnel_NABOP,
        selectionType: "single",
        fields: [
            {name: "firstName"},
            {name: "lastName"},
            {name: "nationalCode",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "companyName"},
            {name: "personnelNo",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "personnelNo2",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "postTitle"},
            {name: "postCode",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {name: "ccpArea"},
            {name: "ccpAssistant"},
            {name: "ccpAffairs"},
            {name: "ccpSection"},
            {name: "ccpUnit"},
        ],
        rowDoubleClick: "Select_Person_NABOP()",
        implicitCriteria: {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [{fieldName: "deleted", operator: "equals", value: 0}]
        }
    });

    IButton_Personnel_Ok_NABOP = isc.IButtonSave.create({
        title: "<spring:message code="select"/>",
        click: "Select_Person_NABOP()"
    });

    HLayout_Personnel_Ok_NABOP = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Personnel_Ok_NABOP]
    });

    ToolStripButton_Personnel_Refresh_NABOP = isc.ToolStripButtonRefresh.create({
        click: function () {
            refreshLG(PersonnelsLG_NABOP);
        }
    });

    ToolStrip_Personnel_Actions_NABOP = isc.ToolStrip.create({
        width: "100%",
        align: "left",
        border: '0px',
        members: [
            ToolStripButton_Personnel_Refresh_NABOP
        ]
    });

    Window_Personnel_NABOP = isc.Window.create({
        placement: "fillScreen",
        title: "<spring:message code="personnel"/>",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [isc.TrVLayout.create({
            members: [
                ToolStrip_Personnel_Actions_NABOP,
                PersonnelsLG_NABOP,
                HLayout_Personnel_Ok_NABOP
            ]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*courses form*/
    //--------------------------------------------------------------------------------------------------------------------//

    PriorityDS_NABOP = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true, hidden: true},
                {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
                {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
            ],
        autoFetchData: false,
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/NeedsAssessmentPriority"
    });

    ScoresStateDS_NABOP = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/PassedStatus"
    });

    DomainDS_NABOP = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/NeedsAssessmentDomain"
    });

    CompetenceTypeDS_NABOP = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/competenceType"
    });

    CourseDS_NABOP = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "needsAssessmentPriorityId", title: "<spring:message code='priority'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "needsAssessmentDomainId", title: "<spring:message code='domain'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "competence.title", title: "<spring:message code="competence"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competence.competenceTypeId", title: "<spring:message code="competence.type"/>", filterOperator: "equals", autoFitWidth: true},
            {name: "skill.code", title: "<spring:message code="skill.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "skill.titleFa", title: "<spring:message code="skill"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "skill.course.theoryDuration", title: "<spring:message code="duration"/>", filterOperator: "equals", autoFitWidth: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "skill.course.scoresState", title: "<spring:message code='status'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "skill.course.code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "skill.course.titleFa", title: "<spring:message code="course"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: null
    });

    Menu_Courses_NABOP = isc.Menu.create({
        data: [{
            title: "<spring:message code="refresh"/>", click: function () {
                if (CourseDS_NABOP.fetchDataURL == null)
                    return;
                refreshLG_NABOP(CourseDS_NABOP);
            }
        }, {
            title: "نمایش نمودار", click: function () {
                showChart_NABOP();
            }
        },{
            isSeparator: true
        }, {
            title: "<spring:message code="global.form.print.pdf"/>",
            click: function () {
                print_NABOP("pdf");
            }
        }, {
            title: "<spring:message code="global.form.print.excel"/>",
            click: function () {
                print_NABOP("excel");
            }
        }, {
            title: "<spring:message code="global.form.print.html"/>",
            click: function () {
                print_NABOP("html");
            }
        }]
    });

    ReportTypeDF_NABOP = isc.DynamicForm.create({
        numCols: 3,
        padding: 5,
        titleAlign: "left",
        styleName: "teacher-form",
        colWidths: ["10%", "5%", "85%"],
        fields: [
            {
                name: "reportType",
                showTitle: false,
                type: "radioGroup",
                width: 700,
                autoFit: true,
                valueMap: {
                    0: "<spring:message code='needsAssessmentReport.personnel'/>",
                    1: "<spring:message code='needsAssessmentReport.post/job/postGrade'/>",
                    2: "<spring:message code='needsAssessmentReport.job.promotion'/>",
                },
                vertical: false,
                defaultValue: 0,
                changed: setReportType_NABOP
            },
            {
                name: "personnelId",
                title: "<spring:message code="personnel.choose"/>",
                type: "ButtonItem",
                align: "right",
                autoFit: true,
                startRow: false,
                endRow: false,
                click() {
                    PersonnelsLG_NABOP.fetchData();
                    Window_Personnel_NABOP.show();
                }
            },
            {
                name: "objectId",
                title: "<spring:message code='needsAssessmentReport.choose.post/job/postGrade'/>",
                hidden: true,
                type: "ButtonItem",
                align: "right",
                autoFit: true,
                startRow: false,
                endRow: false,
                click() {
                    PostsLG_NABOP.fetchData();
                    Window_Post_NABOP.show();
                }
            },
        ]
    });

    DynamicForm_Title_NABOP = isc.DynamicForm.create({
        numCols: 1,
        fields: [
            {
                name: "Title_NASB",
                type: "staticText",
                title: "<spring:message code='needsAssessmentReport'/>" + " <spring:message code='Mrs/Mr'/> " + getFormulaMessage("...", 2, "red", "b") + " <spring:message code='in.post'/> " + getFormulaMessage("...", 2, "red", "b"),
                titleAlign: "center",
                wrapTitle: false
            }
        ]
    });

    let fullSummaryFunc_NABOP = [
        function (records) {
            let total = 0;
            for (let i = 0; i < records.length; i++) {
                total += records[i].skill.course.theoryDuration;
            }
            let index = getIndexById_NABOP(records[0].needsAssessmentPriorityId);
            chartData_NABOP.find({title:priorities_NABOP[index].title, type:"<spring:message code='total'/>"}).duration = total;
            return "<spring:message code="duration.hour.sum"/>" + total;
        },
        function (records) {
            let passed = 0;
            for (let i = 0; i < records.length; i++) {
                if (records[i].skill.course.scoresState === passedStatusId_NABOP)
                    passed += records[i].skill.course.theoryDuration;
            }
            let index = getIndexById_NABOP(records[0].needsAssessmentPriorityId);
            chartData_NABOP.find({title:priorities_NABOP[index].title, type:"<spring:message code='passed'/>"}).duration = passed;
            return "<spring:message code="duration.hour.sum.passed"/>" + passed;
        },
        function (records) {
            if (!records.isEmpty() &&
                chartData_NABOP.find({title:priorities_NABOP[getIndexById_NABOP(records[0].needsAssessmentPriorityId)].title, type:"<spring:message code='total'/>"}).duration !== 0) {
                let index = getIndexById_NABOP(records[0].needsAssessmentPriorityId);
                return "<spring:message code="duration.percent.passed"/>" +
                    Math.round(chartData_NABOP.find({title:priorities_NABOP[index].title, type:"<spring:message code='passed'/>"}).duration /
                        chartData_NABOP.find({title:priorities_NABOP[index].title, type:"<spring:message code='total'/>"}).duration * 100);
            }
            return "<spring:message code="duration.percent.passed"/>" + 0;
        }
    ];

    let totalSummaryFunc_NABOP = [
        function (records) {
            let total = 0;
            for (let i = 0; i < records.length; i++) {
                total += records[i].skill.course.theoryDuration;
            }
            let index = getIndexById_NABOP(records[0].needsAssessmentPriorityId);
            chartData_NABOP.find({title:priorities_NABOP[index].title, type:"<spring:message code='total'/>"}).duration = total;
            return "<spring:message code="duration.hour.sum"/>" + total;
        }
    ];

    CoursesLG_NABOP = isc.TrLG.create({
        gridComponents: [ReportTypeDF_NABOP, DynamicForm_Title_NABOP, "header", "filterEditor", "body"],
        dataSource: CourseDS_NABOP,
        contextMenu: Menu_Courses_NABOP,
        selectionType: "single",
        autoFetchData: false,
        alternateRecordStyles: true,
        showAllRecords: true,
        groupByField: "needsAssessmentPriorityId",
        groupStartOpen: "all",
        showGroupSummary: true,
        useClientFiltering: true,
        fields: [
            {
                name: "needsAssessmentPriorityId",
                hidden: true,
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: PriorityDS_NABOP,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
                sortNormalizer(record){
                    switch (record.needsAssessmentPriorityId) {
                        case "عملکردی ضروری":
                            return 0;
                        case "عملکردی بهبود":
                            return 1;
                        case "عملکردی توسعه":
                            return 2;
                        default:
                            return record.needsAssessmentPriorityId;
                    }
                }
            },
            {
                name: "competence.title",
                // hidden: true
            },
            {
                name: "competence.competenceTypeId",
                // hidden: true,
                type: "SelectItem",
                filterOnKeypress: true,
                displayField: "title",
                valueField: "id",
                optionDataSource: CompetenceTypeDS_NABOP,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
            {
                name: "needsAssessmentDomainId",
                // hidden: true,
                // type: "IntegerItem",
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: DomainDS_NABOP,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
            {
                name: "skill.code",
                // hidden: true
            },
            {
                name: "skill.titleFa",
                // hidden: true
            },

            {name: "skill.course.code"},
            {name: "skill.course.titleFa"},
            {
                name: "skill.course.theoryDuration",
                showGroupSummary: true,
                summaryFunction: fullSummaryFunc_NABOP
            },
            {
                name: "skill.course.scoresState",
                // type: "IntegerItem",
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: ScoresStateDS_NABOP,
                addUnknownValues: false,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
        ],
        sortField: "needsAssessmentPriorityId",
        dataArrived: function () {
            priorities_NABOP.forEach(p => {
                if (this.originalData.localData.filter(d => d.needsAssessmentPriorityId === p.id).isEmpty()) {
                    chartData_NABOP.find({title: priorities_NABOP[getIndexById_NABOP(p.id)].title, type: "<spring:message code='total'/>"}).duration = 0;
                    chartData_NABOP.find({title: priorities_NABOP[getIndexById_NABOP(p.id)].title, type: "<spring:message code='passed'/>"}).duration = 0;
                }
            });
        },
        filterEditorSubmit: function () {
            return CourseDS_NABOP.fetchDataURL != null;
        }
    });

    ToolStripButton_Refresh_NABOP = isc.ToolStripButtonRefresh.create({
        click: function () {
            if (CourseDS_NABOP.fetchDataURL == null)
                return;
            refreshLG_NABOP(CourseDS_NABOP);
        }
    });
    ToolStripButton_ShowChart_NABOP = isc.ToolStripButton.create({
        title: "نمایش نمودار",
        click: function () {
            showChart_NABOP();
        }
    });
    ToolStripButton_Print_NABOP = isc.ToolStripButtonPrint.create({
        title: "<spring:message code='print'/>",
        click: function () {
            print_NABOP("pdf");
        }
    });

    let ToolStrip_NA_Report_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let result = ExportToFile.getAllFields(CoursesLG_NABOP);
                    let fields = result.fields;

                    fields.splice(1, 0, { title: "نوع نیازسنجی", name: "needsAssessmentPriorityId" });
                    let isValueMaps = result.isValueMap;
                    isValueMaps.splice(1, 0, false);
                    let rows = CourseDS_NABOP.getCacheData();

                    if (!rows) //bug fix
                        return;

                    rows.sort(function(a, b){return b.needsAssessmentPriorityId - a.needsAssessmentPriorityId});
                    let pi = PriorityDS_NABOP.getCacheData();
                    let data = [];
                    for (let i = 0; i < rows.length; i++) {
                        data[i] = {};
                        for (let j = 0; j < fields.length; j++) {
                            if (fields[j].name == 'rowNum') {
                                data[i][fields[j].name] = (i + 1).toString();
                            }else if(fields[j].name == 'needsAssessmentPriorityId'){
                                data[i][fields[j].name] = pi.find(x => x.id === rows[i].needsAssessmentPriorityId).title;
                            } else {
                                let tmpStr = ExportToFile.getData(rows[i], fields[j].name.split('.'), 0);
                                data[i][fields[j].name] = typeof (tmpStr) == 'undefined' ? '' : ((!isValueMaps[j]) ? tmpStr : CoursesLG_NABOP.getDisplayValue(fields[j].name, tmpStr));
                            }
                        }
                    }

                    if (CoursesLG_NABOP.data.size()>1)
                        ExportToFile.exportToExcelFromClient(result.fields, data, titleReportExcel, ReportTypeDF_NABOP.getField("reportType").valueMap[reportType_NABOP]);
                }
            })
        ]
    });



    ToolStrip_Actions_NABOP = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_Refresh_NABOP,
                ToolStripButton_ShowChart_NABOP,
                ToolStripButton_Print_NABOP,
                ToolStrip_NA_Report_Export2EXcel,
                // isc.ToolStrip.create({
                //     width: "100%",
                //     align: "left",
                //     border: '0px',
                //     members: [
                //         ToolStripButton_Refresh_NABOP
                //     ]
                // })
            ]
    });

    Main_HLayout_NABOP = isc.TrHLayout.create({
        members: [CoursesLG_NABOP]
    });

    Main_VLayout_NABOP = isc.TrVLayout.create({
        border: "2px solid blue",
        members: [ToolStrip_Actions_NABOP, Main_HLayout_NABOP]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function refreshLG_NABOP(listGrid) {
        listGrid.invalidateCache();
        listGrid.fetchData();
        CoursesLG_NABOP.invalidateCache();
        CoursesLG_NABOP.fetchData();
    }

    function Select_Person_NABOP(selected_Person) {
        selected_Person = (selected_Person == null) ? PersonnelsLG_NABOP.getSelectedRecord() : selected_Person;
        if (selected_Person == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }

        if (selected_Person.postId !== undefined && reportType_NABOP === "0") {
            wait_NABOP = createDialog("wait");
            selectedPerson_NABOP = selected_Person;
            isc.RPCManager.sendRequest(TrDSRequest(postUrl + "/get-by-id/" + selectedPerson_NABOP.postId, "GET", null, PostCodeSearch_result_NABOP));
        } else if (reportType_NABOP !== "0") {
            selectedPerson_NABOP = selected_Person;
            setTitle_NABOP();
            Window_Personnel_NABOP.close();
        } else {
            createDialog("info", "<spring:message code="personnel.without.postCode"/>");
        }
    }

    function PostCodeSearch_result_NABOP(resp) {
        wait_NABOP.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            selectedObject_NABOP = JSON.parse(resp.httpResponseText);
            setTitle_NABOP();
            Window_Personnel_NABOP.close();
        } else if (resp.httpResponseCode === 404 && resp.httpResponseText === "PostNotFound") {
            createDialog("info", "<spring:message code='needsAssessmentReport.postCode.not.Found'/>");
        } else {
            createDialog("info", "<spring:message code="msg.operation.error"/>");
        }
    }

    function Select_Post_NABOP(selected_Post) {
        selected_Post = (selected_Post == null) ? Tabset_Object_NABOP.getSelectedTab().pane.getSelectedRecord() : selected_Post;

        if (selected_Post == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }
        selectedObject_NABOP = selected_Post;
        setTitle_NABOP();
        Window_Post_NABOP.close();
    }

    function getIndexById_NABOP(needsAssessmentPriorityId) {
        for (let i = 0; i < priorities_NABOP.length; i++) {
            if (priorities_NABOP[i].id === needsAssessmentPriorityId)
                return i;
        }
    }

    function getIndexByCode_NABOP(code) {
        for (let i = 0; i < priorities_NABOP.length; i++) {
            if (priorities_NABOP[i].code === code)
                return i;
        }
    }

    function setPriorities_NABOP(resp){
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            priorities_NABOP = JSON.parse(resp.httpResponseText).response.data;
            for (let i = 0; i < priorities_NABOP.length; i++) {
                if (priorities_NABOP[i].title === "عملکردی ضروری")
                    priorities_NABOP[i].title = "<spring:message code='essential'/>";
                else if (priorities_NABOP[i].title === "عملکردی بهبود")
                    priorities_NABOP[i].title = "<spring:message code='improving'/>";
                else if (priorities_NABOP[i].title === "عملکردی توسعه")
                    priorities_NABOP[i].title = "<spring:message code='developmental'/>";
            }
        } else {
            createDialog("info", "<spring:message code="msg.operation.error"/>");
        }
    }

    function showChart_NABOP () {
        let facets;
        let chartType;
        if (reportType_NABOP === "1") {
            chartType = "Pie";
            facets = [{id: "title", title: "<spring:message code='priority'/>"}];
        } else {
            chartType = "Radar";
            facets = [
                {id: "title", title: "<spring:message code='priority'/>"},
                {id: "type", title: "<spring:message code='status'/>"}];
        }

        Chart_NABOP.setFacets(facets);
        Chart_NABOP.setData(chartData_NABOP);
        Chart_NABOP.setChartType(chartType);
        Window_Chart_NABOP.show();
    }

    function setReportType_NABOP(){
        if (changeablePerson_NABOP)
            selectedPerson_NABOP = null;
        if (changeableObject_NABOP)
            selectedObject_NABOP = null;
        let personName = selectedPerson_NABOP != null ? getFormulaMessage(selectedPerson_NABOP.firstName, 2, "red", "b") + " " + getFormulaMessage(selectedPerson_NABOP.lastName, 2, "red", "b") : getFormulaMessage("...", 2, "red", "b");
        let postName = selectedObject_NABOP != null ? getFormulaMessage(selectedObject_NABOP.titleFa, 2, "red", "b") : getFormulaMessage("...", 2, "red", "b");

        if (ReportTypeDF_NABOP.getValue("reportType") === "0") {
            reportType_NABOP = "0";
            if (!hideRadioButtons)
            changeablePerson_NABOP ? ReportTypeDF_NABOP.getItem("personnelId").show() : ReportTypeDF_NABOP.getItem("personnelId").hide();
            DynamicForm_Title_NABOP.getItem("Title_NASB").title = "<spring:message code='needsAssessmentReport'/>" + " <spring:message code='Mrs/Mr'/> " + personName + " <spring:message code='in.post'/> " + getFormulaMessage("...", 2, "red", "b");
            ReportTypeDF_NABOP.getItem("objectId").hide();
            CoursesLG_NABOP.showField("skill.course.scoresState");
            CoursesLG_NABOP.getField("skill.course.theoryDuration").summaryFunction = fullSummaryFunc_NABOP;
            Tabset_Object_NABOP.selectTab("TrainingPost");
        } else if (ReportTypeDF_NABOP.getValue("reportType") === "1") {
            reportType_NABOP = "1";
            ReportTypeDF_NABOP.getItem("personnelId").hide();
            changeableObject_NABOP ? ReportTypeDF_NABOP.getItem("objectId").show() : ReportTypeDF_NABOP.getItem("objectId").hide();
            DynamicForm_Title_NABOP.getItem("Title_NASB").title = "<spring:message code='needsAssessmentReport.post/job/postGrade'/> " + postName;
            ReportTypeDF_NABOP.getItem("objectId").setTitle("<spring:message code='needsAssessmentReport.choose.post/job/postGrade'/>");
            CoursesLG_NABOP.hideField("skill.course.scoresState");
            CoursesLG_NABOP.getField("skill.course.theoryDuration").summaryFunction = totalSummaryFunc_NABOP;
            Tabset_Object_NABOP.tabs.forEach(tab => Tabset_Object_NABOP.enableTab(tab));
        } else if (ReportTypeDF_NABOP.getValue("reportType") === "2") {
            reportType_NABOP = "2";
            changeablePerson_NABOP ? ReportTypeDF_NABOP.getItem("personnelId").show() : ReportTypeDF_NABOP.getItem("personnelId").hide();
            changeableObject_NABOP ? ReportTypeDF_NABOP.getItem("objectId").show() : ReportTypeDF_NABOP.getItem("objectId").hide();
            ReportTypeDF_NABOP.getItem("objectId").setTitle("<spring:message code='needsAssessmentReport.choose.post'/>");
            DynamicForm_Title_NABOP.getItem("Title_NASB").title = "<spring:message code='needsAssessmentReport.job.promotion'/> " + " <spring:message code='Mrs/Mr'/> " + personName + " <spring:message code='in.post'/> " + postName;
            CoursesLG_NABOP.showField("skill.course.scoresState");
            CoursesLG_NABOP.getField("skill.course.theoryDuration").summaryFunction = fullSummaryFunc_NABOP;
            for (let i = 1; i < Tabset_Object_NABOP.tabs.length; i++)
                Tabset_Object_NABOP.disableTab(Tabset_Object_NABOP.tabs[i]);
            Tabset_Object_NABOP.selectTab("TrainingPost");
        }
        DynamicForm_Title_NABOP.getItem("Title_NASB").redraw();
        CoursesLG_NABOP.setData([]);
        CourseDS_NABOP.fetchDataURL = null;
        chartData_NABOP = [
            {title: "<spring:message code='essential'/>",  type: "<spring:message code='total'/>", duration: 0},
            {title: "<spring:message code='essential'/>",  type: "<spring:message code='passed'/>", duration: 0},
            {title: "<spring:message code='improving'/>", type: "<spring:message code='total'/>", duration: 0},
            {title: "<spring:message code='improving'/>", type: "<spring:message code='passed'/>", duration: 0},
            {title: "<spring:message code='developmental'/>",  type: "<spring:message code='total'/>", duration: 0},
            {title: "<spring:message code='developmental'/>",  type: "<spring:message code='passed'/>", duration: 0}
        ];
    }

    function setTitle_NABOP() {
        chartData_NABOP.forEach(value1 => value1.duration=0);
        switch (reportType_NABOP) {
            case "0":
                titleReportExcel="<spring:message code='needsAssessmentReport'/> " + "<spring:message code='Mrs/Mr'/> " +
                     selectedPerson_NABOP.firstName+ " " + selectedPerson_NABOP.lastName +
                    " <spring:message code='national.code'/> " + selectedPerson_NABOP.nationalCode +
                    " <spring:message code='in.post'/> " + selectedPerson_NABOP.postTitle +
                    " <spring:message code='post.code'/> " + selectedPerson_NABOP.postCode +
                    " <spring:message code='area'/> " + selectedPerson_NABOP.ccpArea +
                    " <spring:message code='affairs'/> " + selectedPerson_NABOP.ccpAffairs

                CourseDS_NABOP.fetchDataURL = needsAssessmentReportsUrl + "?objectId=" + selectedObject_NABOP.id + "&personnelId=" + selectedPerson_NABOP.id + "&objectType=Post";
                DynamicForm_Title_NABOP.getItem("Title_NASB").title = "<spring:message code='needsAssessmentReport'/> " + "<spring:message code='Mrs/Mr'/> " +
                    getFormulaMessage(selectedPerson_NABOP.firstName, 2, "red", "b") + " " + getFormulaMessage(selectedPerson_NABOP.lastName, 2, "red", "b") +
                    " <spring:message code='national.code'/> " + getFormulaMessage(selectedPerson_NABOP.nationalCode, 2, "red", "b") +
                    " <spring:message code='in.post'/> " + getFormulaMessage(selectedPerson_NABOP.postTitle, 2, "red", "b") +
                    " <spring:message code='post.code'/> " + getFormulaMessage(selectedPerson_NABOP.postCode, 2, "red", "b") +
                    " <spring:message code='area'/> " + getFormulaMessage(selectedPerson_NABOP.ccpArea, 2, "red", "b") +
                    " <spring:message code='affairs'/> " + getFormulaMessage(selectedPerson_NABOP.ccpAffairs, 2, "red", "b");
                DynamicForm_Title_NABOP.getItem("Title_NASB").redraw();
                refreshLG_NABOP(CourseDS_NABOP);
                break;
            case "1":
                titleReportExcel="<spring:message code='needsAssessmentReport'/> " + Tabset_Object_NABOP.getSelectedTab().title + " " + selectedObject_NABOP.titleFa;
                CourseDS_NABOP.fetchDataURL = needsAssessmentReportsUrl + "?objectId=" + selectedObject_NABOP.id + "&objectType=" + Tabset_Object_NABOP.getSelectedTab().name;
                DynamicForm_Title_NABOP.getItem("Title_NASB").title = "<spring:message code='needsAssessmentReport'/> " +
                    Tabset_Object_NABOP.getSelectedTab().title + " " + getFormulaMessage(selectedObject_NABOP.titleFa, 2, "red", "b");
                DynamicForm_Title_NABOP.getItem("Title_NASB").redraw();
                refreshLG_NABOP(CourseDS_NABOP);
                break;
            case "2":
                if (selectedPerson_NABOP != null && selectedObject_NABOP != null) {
                    CourseDS_NABOP.fetchDataURL = needsAssessmentReportsUrl + "?objectId=" + selectedObject_NABOP.id + "&personnelId=" + selectedPerson_NABOP.id + "&objectType=TrainingPost";
                    refreshLG_NABOP(CourseDS_NABOP);
                }
                let personName = selectedPerson_NABOP != null ? getFormulaMessage(selectedPerson_NABOP.firstName, 2, "red", "b") + " " + getFormulaMessage(selectedPerson_NABOP.lastName, 2, "red", "b") : getFormulaMessage("...", 2, "red", "b");
                let nationalCode = selectedPerson_NABOP != null ? " <spring:message code='national.code'/> " + getFormulaMessage(selectedPerson_NABOP.nationalCode, 2, "red", "b") : "";
                let postName = selectedObject_NABOP != null ? " <spring:message code='in.post'/> " + getFormulaMessage(selectedObject_NABOP.titleFa, 2, "red", "b") : getFormulaMessage("...", 2, "red", "b");
                let postCode = selectedObject_NABOP != null ? " <spring:message code='post.code'/> " + getFormulaMessage(selectedObject_NABOP.code, 2, "red", "b") : "";
                let area = selectedObject_NABOP != null ? " <spring:message code='area'/> " + getFormulaMessage(selectedObject_NABOP.area ? selectedObject_NABOP.area: "", 2, "red", "b") : "";
                let affairs = selectedObject_NABOP != null ? " <spring:message code='affairs'/> " + getFormulaMessage(selectedObject_NABOP.affairs ? selectedObject_NABOP.affairs : "", 2, "red", "b") : "";

                if (selectedObject_NABOP && selectedPerson_NABOP)
                    titleReportExcel="<spring:message code='needsAssessmentReport.job.promotion'/> " + "<spring:message code='Mrs/Mr'/> " +  selectedPerson_NABOP.firstName + " " + selectedPerson_NABOP.lastName + " <spring:message code='national.code'/>"  + selectedPerson_NABOP.nationalCode + " <spring:message code='in.post'/> " +  selectedObject_NABOP.titleFa + " <spring:message code='post.code'/> " + selectedObject_NABOP.code + " <spring:message code='area'/> " + selectedObject_NABOP.area + " <spring:message code='affairs'/> " + selectedObject_NABOP.affairs;

                DynamicForm_Title_NABOP.getItem("Title_NASB").title = "<spring:message code='needsAssessmentReport.job.promotion'/> " + "<spring:message code='Mrs/Mr'/> " + personName + nationalCode + postName + postCode + area + affairs;
                DynamicForm_Title_NABOP.getItem("Title_NASB").redraw();
        }
    }

    function print_NABOP(type) {
        if (selectedPerson_NABOP == null && reportType_NABOP !== "1") {
            createDialog("info", "<spring:message code="personnel.not.selected"/>");
            return;
        }
        let records = CourseDS_NABOP.getCacheData();
        if (records === undefined) {
            createDialog("info", "<spring:message code='print.no.data.to.print'/>");
            return;
        }
        let groupedRecords = [[], [], []];

        for (let i = 0; i < records.length; i++) {
            groupedRecords[getIndexById_NABOP(records[i].needsAssessmentPriorityId)].add(records[i]);
        }

        let params = {};
        params.essentialTotal = (chartData_NABOP.find({title:priorities_NABOP[getIndexByCode_NABOP("AZ")].title, type:"<spring:message code='total'/>"}).duration).toString();
        params.essentialPassed = (chartData_NABOP.find({title:priorities_NABOP[getIndexByCode_NABOP("AZ")].title, type:"<spring:message code='passed'/>"}).duration).toString();
        params.improvingTotal = (chartData_NABOP.find({title:priorities_NABOP[getIndexByCode_NABOP("AB")].title, type:"<spring:message code='total'/>"}).duration).toString();
        params.improvingPassed = (chartData_NABOP.find({title:priorities_NABOP[getIndexByCode_NABOP("AB")].title, type:"<spring:message code='passed'/>"}).duration).toString();
        params.developmentalTotal = (chartData_NABOP.find({title:priorities_NABOP[getIndexByCode_NABOP("AT")].title, type:"<spring:message code='total'/>"}).duration).toString();
        params.developmentalPassed = (chartData_NABOP.find({title:priorities_NABOP[getIndexByCode_NABOP("AT")].title, type:"<spring:message code='passed'/>"}).duration).toString();
        params.essentialPercent = (params.essentialTotal === "0" ? 0 : Math.round(params.essentialPassed / params.essentialTotal * 100)).toString();
        params.improvingPercent = (params.improvingTotal === "0" ? 0 : Math.round(params.improvingPassed / params.improvingTotal * 100)).toString();
        params.developmentalPercent = (params.developmentalTotal === "0" ? 0 : Math.round(params.developmentalPassed / params.developmentalTotal * 100)).toString();

        if (reportType_NABOP === "0" || reportType_NABOP === "2") {
            params.firstName = selectedPerson_NABOP.firstName;
            params.lastName = selectedPerson_NABOP.lastName;
            params.nationalCode = selectedPerson_NABOP.nationalCode;
            params.personnelNo2 = selectedPerson_NABOP.personnelNo2;
            params.code = selectedObject_NABOP.code;
            params.titleFa = selectedObject_NABOP.titleFa;
            params.area = selectedObject_NABOP.area;
            params.assistance = selectedObject_NABOP.assistance;
            params.affairs = selectedObject_NABOP.affairs;
            params.unit = selectedObject_NABOP.unit;
        }
        else
            params.objectType = "نیازسنجی " + Tabset_Object_NABOP.getSelectedTab().title + " " + selectedObject_NABOP.titleFa;

        let criteriaForm_course = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="needsAssessment-reports/print/"/>" + type,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "essentialRecords", type: "hidden"},
                    {name: "improvingRecords", type: "hidden"},
                    {name: "developmentalRecords", type: "hidden"},
                    {name: "params", type: "hidden"},
                    {name: "params", type: "hidden"},
                    {name: "reportType", type: "hidden"},
                ]
        });
        criteriaForm_course.setValue("essentialRecords", JSON.stringify(groupedRecords[getIndexByCode_NABOP("AZ")]));
        criteriaForm_course.setValue("improvingRecords", JSON.stringify(groupedRecords[getIndexByCode_NABOP("AB")]));
        criteriaForm_course.setValue("developmentalRecords", JSON.stringify(groupedRecords[getIndexByCode_NABOP("AT")]));
        criteriaForm_course.setValue("params", JSON.stringify(params));
        criteriaForm_course.setValue("reportType", reportType_NABOP);
        criteriaForm_course.show();
        criteriaForm_course.submitForm();
    }

    //*************this function calls from personnelInformation page**************
    function call_needsAssessmentReports(reportType, changeableReportType, selected_Person, changeablePerson, selectedObject, changeableObject, objectType) {

        CourseDS_NABOP.invalidateCache();

        if (reportType != null)
            ReportTypeDF_NABOP.getItem("reportType").setValue(reportType);
        if (objectType != null)
            Tabset_Object_NABOP.selectTab(objectType);
        if (changeablePerson != null)
            changeablePerson_NABOP = changeablePerson;
        if (changeableObject != null)
            changeableObject_NABOP = changeableObject;
        if (changeableReportType === false)
            ReportTypeDF_NABOP.getItem("reportType").hide();

        setReportType_NABOP();

        if (selected_Person != null)
            selectedPerson_NABOP = selected_Person;
        if (selectedObject != null)
            selectedObject_NABOP = selectedObject;

        if (selectedObject != null && selected_Person == null)
            Select_Post_NABOP(selectedObject);
        else if (selected_Person != null )
            Select_Person_NABOP(selected_Person);

    }

    //</script>