<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    //Amin HK
    let hideRadioButtons_PI = false;

    $(document).ready(() => {

        hideRadioButtons_PI = true;
        [...Array(3).keys()].slice(1).forEach(idx=> {
            ReportTypeDF_NABOP_PI.getItem("reportType").getItem(idx).setDisabled(true);
            ReportTypeDF_NABOP_PI.getItem("personnelId").hide();
        });
    });

    //--------------------------------------------------------------------------------------------------------------------//

    let titleReportExcel;
    var passedStatusId_NABOPI = 216;
    var priorities_NABOP_PI;
    var wait_NABOP_PI;
    var selectedPerson_NABOP_PI = null;
    var selectedObject_NABOP_PI = null;
    var reportType_NABOP_PI = "0";
    var changeablePerson_NABOP_PI = true;
    var changeableObject_NABOP_PI = true;
    var chartData_NABOP_PI = [
        {title: "<spring:message code='essential.service'/>",  type: "<spring:message code='total'/>", duration: 0},
        {title: "<spring:message code='essential.service'/>",  type: "<spring:message code='passed'/>", duration: 0},
        {title: "<spring:message code='essential.appointment'/>",  type: "<spring:message code='total'/>", duration: 0},
        {title: "<spring:message code='essential.appointment'/>",  type: "<spring:message code='passed'/>", duration: 0},
        {title: "<spring:message code='improving'/>", type: "<spring:message code='total'/>", duration: 0},
        {title: "<spring:message code='improving'/>", type: "<spring:message code='passed'/>", duration: 0},
        {title: "<spring:message code='developmental'/>",  type: "<spring:message code='total'/>", duration: 0},
        {title: "<spring:message code='developmental'/>",  type: "<spring:message code='passed'/>", duration: 0}
    ];

    isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/iscList/NeedsAssessmentPriority", "GET", null, setPriorities_NABOP_PI));

    //--------------------------------------------------------------------------------------------------------------------//
    //*chart form*/
    //--------------------------------------------------------------------------------------------------------------------//

    Chart_NABOP_PI = isc.FacetChart.create({
        valueProperty: "duration",
        showTitle: false,
        filled: true,
        stacked: false,
    });

    Window_Chart_NABOP_PI = isc.Window.create({
        placement: "fillScreen",
        title: "",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 720,
        minHeight: 540,
        items: [isc.TrVLayout.create({
            members: [Chart_NABOP_PI]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*post form*/
    //--------------------------------------------------------------------------------------------------------------------//

    TrainingPostDS_NABOP_PI = isc.TrDS.create({
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
        transformRequest: function (dsRequest) {
            transformCriteriaForLastModifiedDateNA(dsRequest);
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: viewTrainingPostUrl + "/iscList"
    });

    PostDS_NABOP_PI = isc.TrDS.create({
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

    PostGroupDS_NABOP_PI = isc.TrDS.create({
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

    JobDS_NABOP_PI = isc.TrDS.create({
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
                {name: "modifiedByNA", title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
                {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, filterOnKeypress: true,valueMap:{74 : "غیر فعال"}}
            ],
        fetchDataURL: viewJobUrl + "/iscList"
    });

    JobGroupDS_NABOP_PI = isc.TrDS.create({
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
        fetchDataURL: viewJobGroupUrl + "/iscList"
    });

    PostGradeDS_NABOP_PI = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap:{"Personal" : "شرکتی", "ContractorPersonal" : "پیمان کار"},filterOnKeypress: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "description", title: "<spring:message code='description'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceCount", hidden: true, title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCount", hidden: true, title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "lastModifiedDateNA", title: "<spring:message code="update.date"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "modifiedByNA", title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, filterOnKeypress: true,valueMap:{74 : "غیر فعال"}}
        ],
        fetchDataURL: viewPostGradeUrl + "/iscList"
    });

    PostGradeGroupDS_NABOP_PI = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code='title'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "description", title: "<spring:message code='description'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceCount", hidden: true, title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCount", hidden: true, title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "lastModifiedDateNA", title: "<spring:message code="update.date"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "modifiedByNA", title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, filterOnKeypress: true,valueMap:{74 : "غیر فعال"}}
        ],
        fetchDataURL: viewPostGradeGroupUrl + "/iscList"
    });

    Menu_Post_NABOP_PI = isc.Menu.create({
        data: [{
            title: "<spring:message code="refresh"/>", click: function () {
                refreshLG(Tabset_Object_NABOP_PI.getSelectedTab().pane);
            }
        }]
    });

    TrainingPostLG_NABOP_PI = isc.TrLG.create({
        selectionType: "single",
        dataSource: TrainingPostDS_NABOP_PI,
        contextMenu: Menu_Post_NABOP_PI,
        autoFetchData: true,
        rowDoubleClick: "Select_Post_NABOP_PI()",
        sortField: 1,
        sortDirection: "descending"
    });

    PostsLG_NABOP_PI = isc.TrLG.create({
        dataSource: PostDS_NABOP_PI,
        contextMenu: Menu_Post_NABOP_PI,
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
        rowDoubleClick: "Select_Post_NABOP_PI()",
        sortField: 1,
        sortDirection: "descending"
    });

    JobLG_NABOP_PI = isc.TrLG.create({
        dataSource: JobDS_NABOP_PI,
        contextMenu: Menu_Post_NABOP_PI,
        selectionType: "single",
        autoFetchData: true,
        // fields: [
        //     {name: "code"},
        //     {name: "titleFa"},
        //     {name: "description"}
        // ],
        rowDoubleClick: "Select_Post_NABOP_PI()",
        sortField: 1,
        sortDirection: "descending"
    });

    PostGradeLG_NABOP_PI = isc.TrLG.create({
        dataSource: PostGradeDS_NABOP_PI,
        contextMenu: Menu_Post_NABOP_PI,
        selectionType: "single",
        autoFetchData: true,
        // fields: [
        //     {name: "code"},
        //     {name: "titleFa"},
        //     {name: "description"}
        // ],
        rowDoubleClick: "Select_Post_NABOP_PI()",
        sortField: 1,
        sortDirection: "descending"
    });

    PostGroupLG_NABOP_PI = isc.TrLG.create({
        dataSource: PostGroupDS_NABOP_PI,
        contextMenu: Menu_Post_NABOP_PI,
        selectionType: "single",
        autoFetchData: true,
        // fields: [
        //     {name: "code"},
        //     {name: "titleFa"},
        //     {name: "description"}
        // ],
        rowDoubleClick: "Select_Post_NABOP_PI()",
        sortField: 1,
        sortDirection: "descending"
    });

    JobGroupLG_NABOP_PI = isc.TrLG.create({
        dataSource: JobGroupDS_NABOP_PI,
        contextMenu: Menu_Post_NABOP_PI,
        selectionType: "single",
        autoFetchData: true,
        // fields: [
        //     {name: "code"},
        //     {name: "titleFa"},
        //     {name: "description"}
        // ],
        rowDoubleClick: "Select_Post_NABOP_PI()",
        sortField: 1,
        sortDirection: "descending"
    });

    PostGradeGroupLG_NABOP_PI = isc.TrLG.create({
        dataSource: PostGradeGroupDS_NABOP_PI,
        contextMenu: Menu_Post_NABOP_PI,
        selectionType: "single",
        autoFetchData: true,
        // fields: [
        //     {name: "code"},
        //     {name: "titleFa"},
        //     {name: "description"}
        // ],
        rowDoubleClick: "Select_Post_NABOP_PI()",
        sortField: 1,
        sortDirection: "descending"
    });

    Tabset_Object_NABOP_PI = isc.TabSet.create({
        tabBarPosition: "right",
        tabBarThickness: 100,
        tabs: [
            {title: "<spring:message code="post"/>", name: "TrainingPost", pane: TrainingPostLG_NABOP_PI},
            {title: "<spring:message code="post.individual"/>", name: "Post", pane: PostsLG_NABOP_PI},
            {title: "<spring:message code="job"/>", name: "Job", pane: JobLG_NABOP_PI},
            {title: "<spring:message code="post.grade"/>", name: "PostGrade", pane: PostGradeLG_NABOP_PI},
            {title: "<spring:message code="post.group"/>", name: "PostGroup", pane: PostGroupLG_NABOP_PI},
            {title: "<spring:message code="job.group"/>", name: "JobGroup", pane: JobGroupLG_NABOP_PI},
            {title: "<spring:message code="post.grade.group"/>", name: "PostGradeGroup", pane: PostGradeGroupLG_NABOP_PI},
        ],
    });

    IButton_Post_Ok_NABOP_PI = isc.IButtonSave.create({
        title: "<spring:message code="select"/>",
        click: "Select_Post_NABOP_PI()"
    });

    HLayout_Post_Ok_NABOP_PI = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Post_Ok_NABOP_PI]
    });

    ToolStripButton_Post_Refresh_NABOP_PI = isc.ToolStripButtonRefresh.create({
        click: function () {
            refreshLG(Tabset_Object_NABOP_PI.getSelectedTab().pane);
        }
    });

    ToolStrip_Post_Actions_NABOP_PI = isc.ToolStrip.create({
        width: "100%",
        align: "left",
        border: '0px',
        members: [
            ToolStripButton_Post_Refresh_NABOP_PI
        ]
    });

    Window_Post_NABOP_PI = isc.Window.create({
        placement: "fillScreen",
        title: "",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [isc.TrVLayout.create({
            members: [
                ToolStrip_Post_Actions_NABOP_PI,
                Tabset_Object_NABOP_PI,
                HLayout_Post_Ok_NABOP_PI
            ]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*personnel form*/
    //--------------------------------------------------------------------------------------------------------------------//

    PersonnelDS_NABOP_PI = isc.TrDS.create({
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

    Menu_Personnel_NABOP_PI = isc.Menu.create({
        data: [{
            title: "<spring:message code="refresh"/>", click: function () {
                refreshLG(PersonnelsLG_NABOP_PI);
            }
        }]
    });

    PersonnelsLG_NABOP_PI = isc.TrLG.create({
        dataSource: PersonnelDS_NABOP_PI,
        autoFitWidthApproach: "both",
        contextMenu: Menu_Personnel_NABOP_PI,
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
        rowDoubleClick: "Select_Person_NABOP_PI()",
        implicitCriteria: {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [{fieldName: "deleted", operator: "equals", value: 0}]
        }
    });

    IButton_Personnel_Ok_NABOP_PI = isc.IButtonSave.create({
        title: "<spring:message code="select"/>",
        click: "Select_Person_NABOP_PI()"
    });

    HLayout_Personnel_Ok_NABOP_PI = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Personnel_Ok_NABOP_PI]
    });

    ToolStripButton_Personnel_Refresh_NABOP_PI = isc.ToolStripButtonRefresh.create({
        click: function () {
            refreshLG(PersonnelsLG_NABOP_PI);
        }
    });

    ToolStrip_Personnel_Actions_NABOP_PI = isc.ToolStrip.create({
        width: "100%",
        align: "left",
        border: '0px',
        members: [
            ToolStripButton_Personnel_Refresh_NABOP_PI
        ]
    });

    Window_Personnel_NABOP_PI = isc.Window.create({
        placement: "fillScreen",
        title: "<spring:message code="personnel"/>",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [isc.TrVLayout.create({
            members: [
                ToolStrip_Personnel_Actions_NABOP_PI,
                PersonnelsLG_NABOP_PI,
                HLayout_Personnel_Ok_NABOP_PI
            ]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*courses form*/
    //--------------------------------------------------------------------------------------------------------------------//

    PriorityDS_NABOP_PI = isc.TrDS.create({
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

    ScoresStateDS_NABOP_PI = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/PassedStatus"
    });

    DomainDS_NABOP_PI = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/NeedsAssessmentDomain"
    });

    CompetenceTypeDS_NABOP_PI = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/competenceType"
    });

    CourseDS_NABOP_PI = isc.TrDS.create({
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
            {name: "skill.course.scoresStatus", title: "<spring:message code='score.state'/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "skill.course.code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "skill.course.titleFa", title: "<spring:message code="course"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: null
    });

    Menu_Courses_NABOP_PI = isc.Menu.create({
        data: [{
            title: "<spring:message code="refresh"/>", click: function () {
                if (CourseDS_NABOP_PI.fetchDataURL == null)
                    return;
                refreshLG_NABOP_PI(CourseDS_NABOP_PI);
            }
        }, {
            title: "<spring:message code="show.chart"/>", click: function () {
                showChart_NABOP_PI();
            }
        },{
            isSeparator: true
        }, {
            title: "<spring:message code="global.form.print.pdf"/>",
            click: function () {
                print_NABOP_PI("pdf");
            }
        }, {
            title: "<spring:message code="global.form.print.excel"/>",
            click: function () {
                print_NABOP_PI("excel");
            }
        }, {
            title: "<spring:message code="global.form.print.html"/>",
            click: function () {
                print_NABOP_PI("html");
            }
        }]
    });

    ReportTypeDF_NABOP_PI = isc.DynamicForm.create({
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
                changed: setReportType_NABOP_PI
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
                    PersonnelsLG_NABOP_PI.fetchData();
                    Window_Personnel_NABOP_PI.show();
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
                    PostsLG_NABOP_PI.fetchData();
                    Window_Post_NABOP_PI.show();
                }
            },
        ]
    });

    DynamicForm_Title_NABOP_PI = isc.DynamicForm.create({
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

    let fullSummaryFunc_NABOP_PI = [
        function (records) {
            let recWithoutDuplicate1 = [];
            let total = 0;
            for (let i = 0; i < records.length; i++) {
                if (!recWithoutDuplicate1.contains(records[i].skill.course.code))
                {
                    recWithoutDuplicate1.add(records[i].skill.course.code);
                    total += records[i].skill.course.theoryDuration;
                }
            }
            let index = getIndexById_NABOP_PI(records[0].needsAssessmentPriorityId);
            chartData_NABOP_PI.find({title:priorities_NABOP_PI[index].title, type:"<spring:message code='total'/>"}).duration = total;
            return "<spring:message code="duration.hour.sum"/>" + total;
        },
        function (records) {
            let recWithoutDuplicate2 = [];
            let passed = 0;
            for (let i = 0; i < records.length; i++) {

                if (!recWithoutDuplicate2.contains(records[i].skill.course.code)) {
                    recWithoutDuplicate2.add(records[i].skill.course.code);

                    if (records[i].skill.course.scoresState === passedStatusId_NABOPI)
                        passed += records[i].skill.course.theoryDuration;

                }
            }

            let index = getIndexById_NABOP_PI(records[0].needsAssessmentPriorityId);
            chartData_NABOP_PI.find({title:priorities_NABOP_PI[index].title, type:"<spring:message code='passed'/>"}).duration = passed;
            return "<spring:message code="duration.hour.sum.passed"/>" + passed;
        },
        function (records) {
            if (!records.isEmpty() &&
                chartData_NABOP_PI.find({title:priorities_NABOP_PI[getIndexById_NABOP_PI(records[0].needsAssessmentPriorityId)].title, type:"<spring:message code='total'/>"}).duration !== 0) {
                let index = getIndexById_NABOP_PI(records[0].needsAssessmentPriorityId);
                return "<spring:message code="duration.percent.passed"/>" +
                    Math.round(chartData_NABOP_PI.find({title:priorities_NABOP_PI[index].title, type:"<spring:message code='passed'/>"}).duration /
                        chartData_NABOP_PI.find({title:priorities_NABOP_PI[index].title, type:"<spring:message code='total'/>"}).duration * 100);
            }
            return "<spring:message code="duration.percent.passed"/>" + 0;
        }
    ];

    let totalSummaryFunc_NABOP_PI = [
        function (records) {
            let recWithoutDuplicate = [];
            let total = 0;
            for (let i = 0; i < records.length; i++) {
                if (!recWithoutDuplicate.contains(records[i].skill.course.code)) {
                    recWithoutDuplicate.add(records[i].skill.course.code);
                    total += records[i].skill.course.theoryDuration;
                }
            }


            let index = getIndexById_NABOP_PI(records[0].needsAssessmentPriorityId);
            chartData_NABOP_PI.find({title:priorities_NABOP_PI[index].title, type:"<spring:message code='total'/>"}).duration = total;
            return "<spring:message code="duration.hour.sum"/>" + total;
        }
    ];

    CoursesLG_NABOP_PI = isc.TrLG.create({
        gridComponents: [ReportTypeDF_NABOP_PI, DynamicForm_Title_NABOP_PI, "header", "filterEditor", "body"],
        dataSource: CourseDS_NABOP_PI,
        contextMenu: Menu_Courses_NABOP_PI,
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
                optionDataSource: PriorityDS_NABOP_PI,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
                sortNormalizer(record){
                    switch (record.needsAssessmentPriorityId) {
                        case 574:
                            return 0;
                        case 111:
                            return 1;
                        case 112:
                            return 2;
                        case 113:
                            return 3;
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
                optionDataSource: CompetenceTypeDS_NABOP_PI,
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
                optionDataSource: DomainDS_NABOP_PI,
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
                summaryFunction: fullSummaryFunc_NABOP_PI
            },
            {
                name: "skill.course.scoresState",
                // type: "IntegerItem",
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: ScoresStateDS_NABOP_PI,
                addUnknownValues: false,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
            {
                name: "skill.course.scoresStatus"
            },
        ],
        sortField: "needsAssessmentPriorityId",
        dataArrived: function () {
            priorities_NABOP_PI.forEach(p => {
                if (this.originalData.localData.filter(d => d.needsAssessmentPriorityId === p.id).isEmpty()) {
                    chartData_NABOP_PI.find({title: priorities_NABOP_PI[getIndexById_NABOP_PI(p.id)].title, type: "<spring:message code='total'/>"}).duration = 0;
                    chartData_NABOP_PI.find({title: priorities_NABOP_PI[getIndexById_NABOP_PI(p.id)].title, type: "<spring:message code='passed'/>"}).duration = 0;
                }
            });
        },
        filterEditorSubmit: function () {
            return CourseDS_NABOP_PI.fetchDataURL != null;
        }
    });

    ToolStripButton_Refresh_NABOP_PI = isc.ToolStripButtonRefresh.create({
        click: function () {
            if (CourseDS_NABOP_PI.fetchDataURL == null)
                return;
            refreshLG_NABOP_PI(CourseDS_NABOP_PI);
        }
    });
    ToolStripButton_ShowChart_NABOP_PI = isc.ToolStripButton.create({
        title: "<spring:message code='show.chart'/>",
        click: function () {
            showChart_NABOP_PI();
        }
    });
    ToolStripButton_Print_NABOP_PI = isc.ToolStripButtonPrint.create({
        title: "<spring:message code='print'/>",
        click: function () {
            print_NABOP_PI("pdf");
        }
    });
    ToolStrip_NA_Report_Export2EXcel_PI = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let result = ExportToFile.getAllFields(CoursesLG_NABOP_PI);
                    let fields = result.fields;

                    fields.splice(1, 0, { title: "نوع نیازسنجی", name: "needsAssessmentPriorityId" });
                    let isValueMaps = result.isValueMap;
                    isValueMaps.splice(1, 0, false);
                    let rows = CourseDS_NABOP_PI.getCacheData();

                    if (!rows) //bug fix
                        return;

                    rows.sort(function(a, b){return b.needsAssessmentPriorityId - a.needsAssessmentPriorityId});
                    let pi = PriorityDS_NABOP_PI.getCacheData();
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
                                data[i][fields[j].name] = typeof (tmpStr) == 'undefined' ? '' : ((!isValueMaps[j]) ? tmpStr : CoursesLG_NABOP_PI.getDisplayValue(fields[j].name, tmpStr));
                            }
                        }
                    }

                        let dataForExcel=getDataForExcel_PI(data);

                    var str =rows.length;

                    if(dataForExcel["totalAppointmentNecessary"]!==0 )
                    {

                        data[str] = {};
                        data[str][fields[1].name] = ("جمع کل ساعات ضروری انتصاب سمت:").toString();
                        data[str][fields[2].name] = (dataForExcel["totalAppointmentNecessary"]).toString();
                        data[str][fields[3].name] = ("جمع ساعات ضروری انتصاب سمت گذرانده شده:").toString();
                        data[str][fields[4].name] = (dataForExcel["passedAppointmentNecessary"]).toString();

                        str++;
                    }
                    if(dataForExcel["totalServiceNecessary"]!==0 )
                    {

                        data[str] = {};
                        data[str][fields[1].name] = ("جمع کل ساعات ضروری ضمن خدمت:").toString();
                        data[str][fields[2].name] = (dataForExcel["totalServiceNecessary"]).toString();
                        data[str][fields[3].name] = ("جمع ساعات ضروری ضمن خدمت گذرانده شده:").toString();
                        data[str][fields[4].name] = (dataForExcel["passedServiceNecessary"]).toString();

                        str++;
                    }
                    if(dataForExcel["totalImprovement"]!==0 )
                    {


                        data[str] = {};
                        data[str][fields[1].name] = ("جمع کل ساعات بهبودی:").toString();
                        data[str][fields[2].name] = (dataForExcel["totalImprovement"]).toString();
                        data[str][fields[3].name] = ("جمع ساعات بهبودی  گذرانده شده:").toString();
                        data[str][fields[4].name] = (dataForExcel["passedImprovement"]).toString();
                        str++;

                    }
                    if(dataForExcel["totalDevelopmental"]!==0 )
                    {


                        data[str] = {};
                        data[str][fields[1].name] = ("جمع کل ساعات توسعه ای:").toString();
                        data[str][fields[2].name] = (dataForExcel["totalDevelopmental"]).toString();
                        data[str][fields[3].name] = ("جمع ساعات توسعه ای  گذرانده شده:").toString();
                        data[str][fields[4].name] = (dataForExcel["passedDevelopmental"]).toString();
                        str++;
                    }

                    if (CoursesLG_NABOP_PI.data.size()>1)
                        ExportToFile.exportToExcelFromClient(result.fields, data, titleReportExcel, ReportTypeDF_NABOP_PI.getField("reportType").valueMap[reportType_NABOP_PI]);
                }
            })
        ]
    });

    ToolStrip_Actions_NABOP_PI = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_Refresh_NABOP_PI,
                ToolStripButton_ShowChart_NABOP_PI,
                ToolStripButton_Print_NABOP_PI,
                ToolStrip_NA_Report_Export2EXcel_PI,
                // isc.ToolStrip.create({
                //     width: "100%",
                //     align: "left",
                //     border: '0px',
                //     members: [
                //         ToolStripButton_Refresh_NABOP_PI
                //     ]
                // })
            ]
    });
    Main_HLayout_NABOP_PI = isc.TrHLayout.create({
        members: [CoursesLG_NABOP_PI]
    });

    Main_VLayout_NABOP_PI = isc.TrVLayout.create({
        border: "2px solid blue",
        members: [ToolStrip_Actions_NABOP_PI, Main_HLayout_NABOP_PI]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function refreshLG_NABOP_PI(listGrid) {
        listGrid.invalidateCache();
        listGrid.fetchData();
        CoursesLG_NABOP_PI.invalidateCache();
        CoursesLG_NABOP_PI.fetchData();
    }

    function Select_Person_NABOP_PI(selected_Person) {
        selected_Person = (selected_Person == null) ? PersonnelsLG_NABOP_PI.getSelectedRecord() : selected_Person;
        if (selected_Person == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }

        if (selected_Person.postId !== undefined && reportType_NABOP_PI === "0") {
            wait_NABOP_PI = createDialog("wait");
            selectedPerson_NABOP_PI = selected_Person;
            isc.RPCManager.sendRequest(TrDSRequest(postUrl + "/get-by-id/" + selectedPerson_NABOP_PI.postId, "GET", null, PostCodeSearch_result_NABOP_PI));
        } else if (reportType_NABOP_PI !== "0") {
            selectedPerson_NABOP_PI = selected_Person;
            setTitle_NABOP_PI();
            Window_Personnel_NABOP_PI.close();
        } else {
            createDialog("info", "<spring:message code="personnel.without.postCode"/>");
        }
    }

    function PostCodeSearch_result_NABOP_PI(resp) {
        wait_NABOP_PI.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            selectedObject_NABOP_PI = JSON.parse(resp.httpResponseText);
            setTitle_NABOP_PI();
            Window_Personnel_NABOP_PI.close();
        } else if (resp.httpResponseCode === 404 && resp.httpResponseText === "PostNotFound") {
            createDialog("info", "<spring:message code='needsAssessmentReport.postCode.not.Found'/>");
        } else {
            createDialog("info", "<spring:message code="msg.operation.error"/>");
        }
    }

    function Select_Post_NABOP_PI(selected_Post) {
        selected_Post = (selected_Post == null) ? Tabset_Object_NABOP_PI.getSelectedTab().pane.getSelectedRecord() : selected_Post;

        if (selected_Post == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }
        selectedObject_NABOP_PI = selected_Post;
        setTitle_NABOP_PI();
        Window_Post_NABOP_PI.close();
    }

    function getIndexById_NABOP_PI(needsAssessmentPriorityId) {
        for (let i = 0; i < priorities_NABOP_PI.length; i++) {
            if (priorities_NABOP_PI[i].id === needsAssessmentPriorityId)
                return i;
        }
    }

    function getIndexByCode_NABOP_PI(code) {
        for (let i = 0; i < priorities_NABOP_PI.length; i++) {
            if (priorities_NABOP_PI[i].code === code)
                return i;
        }
    }

    function setPriorities_NABOP_PI(resp){
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            priorities_NABOP_PI = JSON.parse(resp.httpResponseText).response.data;
            for (let i = 0; i < priorities_NABOP_PI.length; i++) {
                if (priorities_NABOP_PI[i].title === "ضروری ضمن خدمت")
                    priorities_NABOP_PI[i].title = "<spring:message code='essential.service'/>";
                else if (priorities_NABOP_PI[i].title === "عملکردی بهبود")
                    priorities_NABOP_PI[i].title = "<spring:message code='improving'/>";
                else if (priorities_NABOP_PI[i].title === "عملکردی توسعه")
                    priorities_NABOP_PI[i].title = "<spring:message code='developmental'/>";
                else if (priorities_NABOP_PI[i].title === "ضروری انتصاب سمت")
                    priorities_NABOP_PI[i].title = "<spring:message code='essential.appointment'/>";
            }
        } else {
            createDialog("info", "<spring:message code="msg.operation.error"/>");
        }
    }

    function showChart_NABOP_PI () {
        let facets;
        let chartType;
        if (reportType_NABOP_PI === "1") {
            chartType = "Pie";
            facets = [{id: "title", title: "<spring:message code='priority'/>"}];
        } else {
            chartType = "Radar";
            facets = [
                {id: "title", title: "<spring:message code='priority'/>"},
                {id: "type", title: "<spring:message code='status'/>"}];
        }

        Chart_NABOP_PI.setFacets(facets);
        Chart_NABOP_PI.setData(chartData_NABOP_PI);
        Chart_NABOP_PI.setChartType(chartType);
        Window_Chart_NABOP_PI.show();
    }

    function setReportType_NABOP_PI () {
        if (changeablePerson_NABOP_PI)
            selectedPerson_NABOP_PI = null;
        if (changeableObject_NABOP_PI)
            selectedObject_NABOP_PI = null;
        let personName = selectedPerson_NABOP_PI != null ? getFormulaMessage(selectedPerson_NABOP_PI.firstName, 2, "red", "b") + " " + getFormulaMessage(selectedPerson_NABOP_PI.lastName, 2, "red", "b") : getFormulaMessage("...", 2, "red", "b");
        let postName = selectedObject_NABOP_PI != null ? getFormulaMessage(selectedObject_NABOP_PI.titleFa, 2, "red", "b") : getFormulaMessage("...", 2, "red", "b");

        if (ReportTypeDF_NABOP_PI.getValue("reportType") === "0") {
            reportType_NABOP_PI = "0";
            if (!hideRadioButtons_PI)
                changeablePerson_NABOP_PI ? ReportTypeDF_NABOP_PI.getItem("personnelId").show() : ReportTypeDF_NABOP_PI.getItem("personnelId").hide();
            DynamicForm_Title_NABOP_PI.getItem("Title_NASB").title = "<spring:message code='needsAssessmentReport'/>" + " <spring:message code='Mrs/Mr'/> " + personName + " <spring:message code='in.post'/> " + getFormulaMessage("...", 2, "red", "b");
            ReportTypeDF_NABOP_PI.getItem("objectId").hide();
            CoursesLG_NABOP_PI.showField("skill.course.scoresState");
            CoursesLG_NABOP_PI.showField("skill.course.scoresStatus");
            CoursesLG_NABOP_PI.getField("skill.course.theoryDuration").summaryFunction = fullSummaryFunc_NABOP_PI;
            Tabset_Object_NABOP_PI.selectTab("TrainingPost");
        } else if (ReportTypeDF_NABOP_PI.getValue("reportType") === "1") {
            reportType_NABOP_PI = "1";
            ReportTypeDF_NABOP_PI.getItem("personnelId").hide();
            changeableObject_NABOP_PI ? ReportTypeDF_NABOP_PI.getItem("objectId").show() : ReportTypeDF_NABOP_PI.getItem("objectId").hide();
            DynamicForm_Title_NABOP_PI.getItem("Title_NASB").title = "<spring:message code='needsAssessmentReport.post/job/postGrade'/> " + postName;
            ReportTypeDF_NABOP_PI.getItem("objectId").setTitle("<spring:message code='needsAssessmentReport.choose.post/job/postGrade'/>");
            CoursesLG_NABOP_PI.hideField("skill.course.scoresState");
            CoursesLG_NABOP_PI.hideField("skill.course.scoresStatus");
            CoursesLG_NABOP_PI.getField("skill.course.theoryDuration").summaryFunction = totalSummaryFunc_NABOP_PI;
            Tabset_Object_NABOP_PI.tabs.forEach(tab => Tabset_Object_NABOP_PI.enableTab(tab));
        } else if (ReportTypeDF_NABOP_PI.getValue("reportType") === "2") {
            reportType_NABOP_PI = "2";
            changeablePerson_NABOP_PI ? ReportTypeDF_NABOP_PI.getItem("personnelId").show() : ReportTypeDF_NABOP_PI.getItem("personnelId").hide();
            changeableObject_NABOP_PI ? ReportTypeDF_NABOP_PI.getItem("objectId").show() : ReportTypeDF_NABOP_PI.getItem("objectId").hide();
            ReportTypeDF_NABOP_PI.getItem("objectId").setTitle("<spring:message code='needsAssessmentReport.choose.post'/>");
            DynamicForm_Title_NABOP_PI.getItem("Title_NASB").title = "<spring:message code='needsAssessmentReport.job.promotion'/> " + " <spring:message code='Mrs/Mr'/> " + personName + " <spring:message code='in.post'/> " + postName;
            CoursesLG_NABOP_PI.showField("skill.course.scoresState");
            CoursesLG_NABOP_PI.showField("skill.course.scoresStatus");
            CoursesLG_NABOP_PI.getField("skill.course.theoryDuration").summaryFunction = fullSummaryFunc_NABOP_PI;
            for (let i = 1; i < Tabset_Object_NABOP_PI.tabs.length; i++)
                Tabset_Object_NABOP_PI.disableTab(Tabset_Object_NABOP_PI.tabs[i]);
            Tabset_Object_NABOP_PI.selectTab("TrainingPost");
        }
        DynamicForm_Title_NABOP_PI.getItem("Title_NASB").redraw();
        CoursesLG_NABOP_PI.setData([]);
        CourseDS_NABOP_PI.fetchDataURL = null;
        chartData_NABOP_PI = [
            {title: "<spring:message code='essential.service'/>",  type: "<spring:message code='total'/>", duration: 0},
            {title: "<spring:message code='essential.service'/>",  type: "<spring:message code='passed'/>", duration: 0},
            {title: "<spring:message code='essential.appointment'/>",  type: "<spring:message code='total'/>", duration: 0},
            {title: "<spring:message code='essential.appointment'/>",  type: "<spring:message code='passed'/>", duration: 0},
            {title: "<spring:message code='improving'/>", type: "<spring:message code='total'/>", duration: 0},
            {title: "<spring:message code='improving'/>", type: "<spring:message code='passed'/>", duration: 0},
            {title: "<spring:message code='developmental'/>",  type: "<spring:message code='total'/>", duration: 0},
            {title: "<spring:message code='developmental'/>",  type: "<spring:message code='passed'/>", duration: 0}
        ];
    }

    function setTitle_NABOP_PI () {
        chartData_NABOP_PI.forEach(value1 => value1.duration=0);
        switch (reportType_NABOP_PI) {
            case "0":
                titleReportExcel="<spring:message code='needsAssessmentReport'/> " + "<spring:message code='Mrs/Mr'/> " +
                    selectedPerson_NABOP_PI.firstName+ " " + selectedPerson_NABOP_PI.lastName +
                    " <spring:message code='national.code'/> " + selectedPerson_NABOP_PI.nationalCode +
                    " <spring:message code='in.post'/> " + selectedPerson_NABOP_PI.postTitle +
                    " <spring:message code='post.code'/> " + selectedPerson_NABOP_PI.postCode +
                    " <spring:message code='area'/> " + selectedPerson_NABOP_PI.ccpArea +
                    " <spring:message code='affairs'/> " + selectedPerson_NABOP_PI.ccpAffairs

                CourseDS_NABOP_PI.fetchDataURL = needsAssessmentReportsUrl + "?objectId=" + selectedObject_NABOP_PI.id + "&personnelId=" + selectedPerson_NABOP_PI.id + "&objectType=Post";
                DynamicForm_Title_NABOP_PI.getItem("Title_NASB").title = "<spring:message code='needsAssessmentReport'/> " + "<spring:message code='Mrs/Mr'/> " +
                    getFormulaMessage(selectedPerson_NABOP_PI.firstName, 2, "red", "b") + " " + getFormulaMessage(selectedPerson_NABOP_PI.lastName, 2, "red", "b") +
                    " <spring:message code='national.code'/> " + getFormulaMessage(selectedPerson_NABOP_PI.nationalCode, 2, "red", "b") +
                    " <spring:message code='in.post'/> " + getFormulaMessage(selectedPerson_NABOP_PI.postTitle, 2, "red", "b") +
                    " <spring:message code='post.code'/> " + getFormulaMessage(selectedPerson_NABOP_PI.postCode, 2, "red", "b") +
                    " <spring:message code='area'/> " + getFormulaMessage(selectedPerson_NABOP_PI.ccpArea, 2, "red", "b") +
                    " <spring:message code='affairs'/> " + getFormulaMessage(selectedPerson_NABOP_PI.ccpAffairs, 2, "red", "b");
                DynamicForm_Title_NABOP_PI.getItem("Title_NASB").redraw();
                refreshLG_NABOP_PI(CourseDS_NABOP_PI);
                break;
            case "1":
                titleReportExcel="<spring:message code='needsAssessmentReport'/> " + Tabset_Object_NABOP_PI.getSelectedTab().title + " " + selectedObject_NABOP_PI.titleFa;
                CourseDS_NABOP_PI.fetchDataURL = needsAssessmentReportsUrl + "?objectId=" + selectedObject_NABOP_PI.id + "&objectType=" + Tabset_Object_NABOP_PI.getSelectedTab().name;
                DynamicForm_Title_NABOP_PI.getItem("Title_NASB").title = "<spring:message code='needsAssessmentReport'/> " +
                    Tabset_Object_NABOP_PI.getSelectedTab().title + " " + getFormulaMessage(selectedObject_NABOP_PI.titleFa, 2, "red", "b");
                DynamicForm_Title_NABOP_PI.getItem("Title_NASB").redraw();
                refreshLG_NABOP_PI(CourseDS_NABOP_PI);
                break;
            case "2":
                if (selectedPerson_NABOP_PI != null && selectedObject_NABOP_PI != null) {
                    CourseDS_NABOP_PI.fetchDataURL = needsAssessmentReportsUrl + "?objectId=" + selectedObject_NABOP_PI.id + "&personnelId=" + selectedPerson_NABOP_PI.id + "&objectType=TrainingPost";
                    refreshLG_NABOP_PI(CourseDS_NABOP_PI);
                }
                let personName = selectedPerson_NABOP_PI != null ? getFormulaMessage(selectedPerson_NABOP_PI.firstName, 2, "red", "b") + " " + getFormulaMessage(selectedPerson_NABOP_PI.lastName, 2, "red", "b") : getFormulaMessage("...", 2, "red", "b");
                let nationalCode = selectedPerson_NABOP_PI != null ? " <spring:message code='national.code'/> " + getFormulaMessage(selectedPerson_NABOP_PI.nationalCode, 2, "red", "b") : "";
                let postName = selectedObject_NABOP_PI != null ? " <spring:message code='in.post'/> " + getFormulaMessage(selectedObject_NABOP_PI.titleFa, 2, "red", "b") : getFormulaMessage("...", 2, "red", "b");
                let postCode = selectedObject_NABOP_PI != null ? " <spring:message code='post.code'/> " + getFormulaMessage(selectedObject_NABOP_PI.code, 2, "red", "b") : "";
                let area = selectedObject_NABOP_PI != null ? " <spring:message code='area'/> " + getFormulaMessage(selectedObject_NABOP_PI.area ? selectedObject_NABOP_PI.area: "", 2, "red", "b") : "";
                let affairs = selectedObject_NABOP_PI != null ? " <spring:message code='affairs'/> " + getFormulaMessage(selectedObject_NABOP_PI.affairs ? selectedObject_NABOP_PI.affairs : "", 2, "red", "b") : "";

                if (selectedObject_NABOP_PI && selectedPerson_NABOP_PI)
                    titleReportExcel="<spring:message code='needsAssessmentReport.job.promotion'/> " + "<spring:message code='Mrs/Mr'/> " +  selectedPerson_NABOP_PI.firstName + " " + selectedPerson_NABOP_PI.lastName + " <spring:message code='national.code'/>"  + selectedPerson_NABOP_PI.nationalCode + " <spring:message code='in.post'/> " +  selectedObject_NABOP_PI.titleFa + " <spring:message code='post.code'/> " + selectedObject_NABOP_PI.code + " <spring:message code='area'/> " + selectedObject_NABOP_PI.area + " <spring:message code='affairs'/> " + selectedObject_NABOP_PI.affairs;

                DynamicForm_Title_NABOP_PI.getItem("Title_NASB").title = "<spring:message code='needsAssessmentReport.job.promotion'/> " + "<spring:message code='Mrs/Mr'/> " + personName + nationalCode + postName + postCode + area + affairs;
                DynamicForm_Title_NABOP_PI.getItem("Title_NASB").redraw();
        }
    }

    function print_NABOP_PI (type) {
        if (selectedPerson_NABOP_PI == null && reportType_NABOP_PI !== "1") {
            createDialog("info", "<spring:message code="personnel.not.selected"/>");
            return;
        }
        let records = CourseDS_NABOP_PI.getCacheData();
        if (records === undefined) {
            createDialog("info", "<spring:message code='print.no.data.to.print'/>");
            return;
        }
        let groupedRecords = [[], [], [], []];

        for (let i = 0; i < records.length; i++) {
            groupedRecords[getIndexById_NABOP_PI(records[i].needsAssessmentPriorityId)].add(records[i]);
        }

        let params = {};
        params.essentialServiceTotal = (chartData_NABOP_PI.find({title:priorities_NABOP_PI[getIndexByCode_NABOP_PI("AZ")].title, type:"<spring:message code='total'/>"}).duration).toString();
        params.essentialAppointmentTotal = (chartData_NABOP_PI.find({title:priorities_NABOP_PI[getIndexByCode_NABOP_PI("AE")].title, type:"<spring:message code='total'/>"}).duration).toString();
        params.essentialServicePassed = (chartData_NABOP_PI.find({title:priorities_NABOP_PI[getIndexByCode_NABOP_PI("AZ")].title, type:"<spring:message code='passed'/>"}).duration).toString();
        params.essentialAppointmentPassed = (chartData_NABOP_PI.find({title:priorities_NABOP_PI[getIndexByCode_NABOP_PI("AE")].title, type:"<spring:message code='passed'/>"}).duration).toString();
        params.improvingTotal = (chartData_NABOP_PI.find({title:priorities_NABOP_PI[getIndexByCode_NABOP_PI("AB")].title, type:"<spring:message code='total'/>"}).duration).toString();
        params.improvingPassed = (chartData_NABOP_PI.find({title:priorities_NABOP_PI[getIndexByCode_NABOP_PI("AB")].title, type:"<spring:message code='passed'/>"}).duration).toString();
        params.developmentalTotal = (chartData_NABOP_PI.find({title:priorities_NABOP_PI[getIndexByCode_NABOP_PI("AT")].title, type:"<spring:message code='total'/>"}).duration).toString();
        params.developmentalPassed = (chartData_NABOP_PI.find({title:priorities_NABOP_PI[getIndexByCode_NABOP_PI("AT")].title, type:"<spring:message code='passed'/>"}).duration).toString();
        params.essentialServicePercent = (params.essentialServiceTotal === "0" ? 0 : Math.round(params.essentialServicePassed / params.essentialServiceTotal * 100)).toString();
        params.essentialAppointmentPercent = (params.essentialAppointmentTotal === "0" ? 0 : Math.round(params.essentialAppointmentPassed / params.essentialAppointmentTotal * 100)).toString();
        params.improvingPercent = (params.improvingTotal === "0" ? 0 : Math.round(params.improvingPassed / params.improvingTotal * 100)).toString();
        params.developmentalPercent = (params.developmentalTotal === "0" ? 0 : Math.round(params.developmentalPassed / params.developmentalTotal * 100)).toString();

        if (reportType_NABOP_PI === "0" || reportType_NABOP_PI === "2") {
            params.firstName = selectedPerson_NABOP_PI.firstName;
            params.lastName = selectedPerson_NABOP_PI.lastName;
            params.nationalCode = selectedPerson_NABOP_PI.nationalCode;
            params.personnelNo2 = selectedPerson_NABOP_PI.personnelNo2;
            params.code = selectedObject_NABOP_PI.code;
            params.titleFa = selectedObject_NABOP_PI.titleFa;
            params.area = selectedObject_NABOP_PI.area;
            params.assistance = selectedObject_NABOP_PI.assistance;
            params.affairs = selectedObject_NABOP_PI.affairs;
            params.unit = selectedObject_NABOP_PI.unit;
        }
        else
            params.objectType = "نیازسنجی " + Tabset_Object_NABOP_PI.getSelectedTab().title + " " + selectedObject_NABOP_PI.titleFa;

        let criteriaForm_course = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="needsAssessment-reports/print/"/>" + type,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "essentialServiceRecords", type: "hidden"},
                    {name: "essentialAppointmentRecords", type: "hidden"},
                    {name: "improvingRecords", type: "hidden"},
                    {name: "developmentalRecords", type: "hidden"},
                    {name: "params", type: "hidden"},
                    {name: "params", type: "hidden"},
                    {name: "reportType", type: "hidden"},
                ]
        });
        criteriaForm_course.setValue("essentialServiceRecords", JSON.stringify(groupedRecords[getIndexByCode_NABOP_PI("AZ")]));
        criteriaForm_course.setValue("essentialAppointmentRecords", JSON.stringify(groupedRecords[getIndexByCode_NABOP_PI("AE")]));
        criteriaForm_course.setValue("improvingRecords", JSON.stringify(groupedRecords[getIndexByCode_NABOP_PI("AB")]));
        criteriaForm_course.setValue("developmentalRecords", JSON.stringify(groupedRecords[getIndexByCode_NABOP_PI("AT")]));
        criteriaForm_course.setValue("params", JSON.stringify(params));
        criteriaForm_course.setValue("reportType", reportType_NABOP_PI);
        criteriaForm_course.show();
        criteriaForm_course.submitForm();
    }

    function getDataForExcel_PI (data) {

        let totalServiceNecessary = 0;
        let totalAppointmentNecessary = 0;
        let totalDevelopmental = 0;
        let totalImprovement = 0;

        let passedServiceNecessary = 0;
        let passedAppointmentNecessary = 0;
        let passedDevelopmental = 0;
        let passedImprovement = 0;

        let newRecServiceNecessary = [];
        let newRecAppointmentNecessary = [];
        let newRecDevelopmental = [];
        let newRecImprovement = [];

        for (let i = 0; i < data.length; i++) {

            if (data.get(i).needsAssessmentPriorityId.toString()==="ضروری انتصاب سمت")
            {
                if (!newRecAppointmentNecessary.contains(data[i]["skill.course.code"]))
                {
                    newRecAppointmentNecessary.add(data[i]["skill.course.code"]);
                    totalAppointmentNecessary += data[i]["skill.course.theoryDuration"];
                    if (data[i]["skill.course.scoresState"] === "گذرانده")
                        passedAppointmentNecessary += data[i]["skill.course.theoryDuration"];
                }
            }
            if (data.get(i).needsAssessmentPriorityId.toString()==="ضروری ضمن خدمت")
            {
                if (!newRecServiceNecessary.contains(data[i]["skill.course.code"]))
                {
                    newRecServiceNecessary.add(data[i]["skill.course.code"]);
                    totalServiceNecessary += data[i]["skill.course.theoryDuration"];
                    if (data[i]["skill.course.scoresState"] === "گذرانده")
                        passedServiceNecessary += data[i]["skill.course.theoryDuration"];
                }
            }
            if (data.get(i).needsAssessmentPriorityId.toString()==="عملکردی بهبود")
            {
                if (!newRecImprovement.contains(data[i]["skill.course.code"]))
                {
                    newRecImprovement.add(data[i]["skill.course.code"]);
                    totalImprovement += data[i]["skill.course.theoryDuration"];

                    if (data[i]["skill.course.scoresState"] === "گذرانده")
                        passedImprovement += data[i]["skill.course.theoryDuration"];

                }
            }
            if (data.get(i).needsAssessmentPriorityId.toString()==="عملکردی توسعه")
            {
                if (!newRecDevelopmental.contains(data[i]["skill.course.code"]))
                {
                    newRecDevelopmental.add(data[i]["skill.course.code"]);
                    totalDevelopmental += data[i]["skill.course.theoryDuration"];

                    if (data[i]["skill.course.scoresState"] === "گذرانده")
                        passedDevelopmental += data[i]["skill.course.theoryDuration"];
                }
            }
            }
        return {
            totalServiceNecessary: totalServiceNecessary,
            totalAppointmentNecessary: totalAppointmentNecessary,
            totalDevelopmental: totalDevelopmental,
            totalImprovement: totalImprovement,
            passedServiceNecessary: passedServiceNecessary,
            passedAppointmentNecessary: passedAppointmentNecessary,
            passedDevelopmental: passedDevelopmental,
            passedImprovement: passedImprovement
        };
    }


    //---------------------------------------calls from personnelInformation page--------------------------------------//
    function call_needsAssessmentReports(reportType, changeableReportType, selected_Person, changeablePerson, selectedObject, changeableObject, objectType) {

        CourseDS_NABOP_PI.invalidateCache();

        if (reportType != null)
            ReportTypeDF_NABOP_PI.getItem("reportType").setValue(reportType);
        if (objectType != null)
            Tabset_Object_NABOP_PI.selectTab(objectType);
        if (changeablePerson != null)
            changeablePerson_NABOP_PI = changeablePerson;
        if (changeableObject != null)
            changeableObject_NABOP_PI = changeableObject;
        if (changeableReportType === false)
            ReportTypeDF_NABOP_PI.getItem("reportType").hide();

        setReportType_NABOP_PI();

        if (selected_Person != null)
            selectedPerson_NABOP_PI = selected_Person;
        if (selectedObject != null)
            selectedObject_NABOP_PI = selectedObject;

        if (selectedObject != null && selected_Person == null)
            Select_Post_NABOP_PI(selectedObject);
        else if (selected_Person != null )
            Select_Person_NABOP_PI(selected_Person);
    }

    //</script>