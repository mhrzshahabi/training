<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>


    let titleReportExcelGap;
    let PersonnelSelected;
    let SynonymPersonnelSelected;

    let wait_NAGap;
    let selectedPerson_NAGap = null;
    let selectedObject_NAGap = null;
    let reportType_NAGap = "2";

    //--------------------------------------------------------------------------------------------------------------------//
    //*chart form*/
    //--------------------------------------------------------------------------------------------------------------------//


    //--------------------------------------------------------------------------------------------------------------------//
    //*post form*/
    //--------------------------------------------------------------------------------------------------------------------//

    TrainingPostDS_NAGap = isc.TrDS.create({
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

    PostDS_NAGap = isc.TrDS.create({
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

    PostGroupDS_NAGap = isc.TrDS.create({
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

    JobDS_NAGap = isc.TrDS.create({
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

    JobGroupDS_NAGap = isc.TrDS.create({
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

    PostGradeDS_NAGap = isc.TrDS.create({
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

    PostGradeGroupDS_NAGap = isc.TrDS.create({
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



    TrainingPostLG_NAGap = isc.TrLG.create({
        selectionType: "single",
        dataSource: TrainingPostDS_NAGap,
        // contextMenu: Menu_Post_NABOP,
        autoFetchData: true,
        rowDoubleClick: "Select_Post_NAGap()",
        sortField: 1,
        sortDirection: "descending"
    });

    PostsLG_NAGap = isc.TrLG.create({
        dataSource: PostDS_NAGap,
        // contextMenu: Menu_Post_NABOP,
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
        rowDoubleClick: "Select_Post_NAGap()",
        sortField: 1,
        sortDirection: "descending"
    });

    JobLG_NAGap = isc.TrLG.create({
        dataSource: JobDS_NAGap,
        // contextMenu: Menu_Post_NABOP,
        selectionType: "single",
        autoFetchData: true,
        // fields: [
        //     {name: "code"},
        //     {name: "titleFa"},
        //     {name: "description"}
        // ],
        rowDoubleClick: "Select_Post_NAGap()",
        sortField: 1,
        sortDirection: "descending"
    });

    PostGradeLG_NAGap = isc.TrLG.create({
        dataSource: PostGradeDS_NAGap,
        // contextMenu: Menu_Post_NABOP,
        selectionType: "single",
        autoFetchData: true,
        // fields: [
        //     {name: "code"},
        //     {name: "titleFa"},
        //     {name: "description"}
        // ],
        rowDoubleClick: "Select_Post_NAGap()",
        sortField: 1,
        sortDirection: "descending"
    });

    PostGroupLG_NAGap = isc.TrLG.create({
        dataSource: PostGroupDS_NAGap,
        // contextMenu: Menu_Post_NABOP,
        selectionType: "single",
        autoFetchData: true,
        // fields: [
        //     {name: "code"},
        //     {name: "titleFa"},
        //     {name: "description"}
        // ],
        rowDoubleClick: "Select_Post_NAGap()",
        sortField: 1,
        sortDirection: "descending"
    });

    JobGroupLG_NAGap = isc.TrLG.create({
        dataSource: JobGroupDS_NAGap,
        // contextMenu: Menu_Post_NABOP,
        selectionType: "single",
        autoFetchData: true,
        // fields: [
        //     {name: "code"},
        //     {name: "titleFa"},
        //     {name: "description"}
        // ],
        rowDoubleClick: "Select_Post_NAGap()",
        sortField: 1,
        sortDirection: "descending"
    });

    PostGradeGroupLG_NAGap = isc.TrLG.create({
        dataSource: PostGradeGroupDS_NAGap,
        // contextMenu: Menu_Post_NABOP,
        selectionType: "single",
        autoFetchData: true,
        // fields: [
        //     {name: "code"},
        //     {name: "titleFa"},
        //     {name: "description"}
        // ],
        rowDoubleClick: "Select_Post_NAGap()",
        sortField: 1,
        sortDirection: "descending"
    });

    Tabset_Object_NAGap = isc.TabSet.create({
        tabBarPosition: "right",
        tabBarThickness: 100,
        tabs: [
            {title: "<spring:message code="post"/>", name: "TrainingPost", pane: TrainingPostLG_NAGap},
            {title: "<spring:message code="post.individual"/>", name: "Post", pane: PostsLG_NAGap},
            {title: "<spring:message code="job"/>", name: "Job", pane: JobLG_NAGap},
            {title: "<spring:message code="post.grade"/>", name: "PostGrade", pane: PostGradeLG_NAGap},
            {title: "<spring:message code="post.group"/>", name: "PostGroup", pane: PostGroupLG_NAGap},
            {title: "<spring:message code="job.group"/>", name: "JobGroup", pane: JobGroupLG_NAGap},
            {title: "<spring:message code="post.grade.group"/>", name: "PostGradeGroup", pane: PostGradeGroupLG_NAGap},
        ],
    });

    IButton_Post_Ok_NAGap = isc.IButtonSave.create({
        title: "<spring:message code="select"/>",
        click: "Select_Post_NAGap()"
    });

    HLayout_Post_Ok_NAGap = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Post_Ok_NAGap]
    });

    ToolStripButton_Post_Refresh_NAGap = isc.ToolStripButtonRefresh.create({
        click: function () {
            refreshLG(Tabset_Object_NAGap.getSelectedTab().pane);
        }
    });

    ToolStrip_Post_Actions_NAGap = isc.ToolStrip.create({
        width: "100%",
        align: "left",
        border: '0px',
        members: [
            ToolStripButton_Post_Refresh_NAGap
        ]
    });

    Window_Post_NAGap = isc.Window.create({
        placement: "fillScreen",
        title: "",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [isc.TrVLayout.create({
            members: [
                ToolStrip_Post_Actions_NAGap,
                Tabset_Object_NAGap,
                HLayout_Post_Ok_NAGap
            ]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*personnel form*/
    //--------------------------------------------------------------------------------------------------------------------//

    PersonnelDS_NAGap = isc.TrDS.create({
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



    PersonnelsLG_NAGap = isc.TrLG.create({
        dataSource: PersonnelDS_NAGap,
        autoFitWidthApproach: "both",
        // contextMenu: Menu_Personnel_NABOP,
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
        rowDoubleClick: function () {
            SynonymPersonnelSelected = false;
            PersonnelSelected = true;
            Select_Person_NAGap();
        },
        implicitCriteria: {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [{fieldName: "deleted", operator: "equals", value: 0}]
        }
    });


    IButton_Personnel_Ok_NAGap = isc.IButtonSave.create({
        title: "<spring:message code="select"/>",
        click: function () {
            SynonymPersonnelSelected = false;
            PersonnelSelected = true;
            Select_Person_NAGap();
        }
    });


    HLayout_Personnel_Ok_NAGap = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Personnel_Ok_NAGap]
    });



    ToolStripButton_Personnel_Refresh_NAGap = isc.ToolStripButtonRefresh.create({
        click: function () {
            refreshLG(PersonnelsLG_NAGap);
        }
    });



    ToolStrip_Personnel_Actions_NAGap = isc.ToolStrip.create({
        width: "100%",
        align: "left",
        border: '0px',
        members: [
            ToolStripButton_Personnel_Refresh_NAGap
        ]
    });



    Window_Personnel_NAGap = isc.Window.create({
        placement: "fillScreen",
        title: "<spring:message code="personnel"/>",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [isc.TrVLayout.create({
            members: [
                ToolStrip_Personnel_Actions_NAGap,
                PersonnelsLG_NAGap,
                HLayout_Personnel_Ok_NAGap
            ]
        })]
    });



    //--------------------------------------------------------------------------------------------------------------------//
    //*courses form*/
    //--------------------------------------------------------------------------------------------------------------------//

    PriorityDS_NAGap = isc.TrDS.create({
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

    ScoresStateDS_NAGap = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/PassedStatus"
    });

    DomainDS_NAGap = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/NeedsAssessmentDomain"
    });



    CourseDS_NAGap = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "needsAssessmentPriorityId", title: "<spring:message code='priority'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "needsAssessmentDomainId", title: "<spring:message code='domain'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "limitSufficiency", title: "حد بسندگی", filterOperator: "equals", autoFitWidth: true},
            {name: "competence.title", title: "<spring:message code="competence"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competence.competenceType.title", title: "<spring:message code="competence.type"/>", filterOperator: "iContains", autoFitWidth: true},
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
            {name: "committeeScore", title: "نمره داده شده توسط کمیته", filterOperator: "iContains",
                autoFitWidth: true,canEdit:true, filterOnKeypress: true,keyPressFilter: "[0-9.]",editEvent: "click"},
            {name: "competenceStatus", title: "وضعیت شایستگی", filterOperator: "iContains", autoFitWidth: true}
        ],
        cacheAllData: true,
        fetchDataURL: null
    });



    ReportTypeDF_NAGap = isc.DynamicForm.create({
        numCols: 4,
        padding: 5,
        titleAlign: "left",
        styleName: "teacher-form",
        colWidths: ["10%", "10%", "5%", "75%"],
        fields: [

            {
                name: "personnelId",
                title: "<spring:message code="personnel.choose"/>",
                type: "ButtonItem",
                align: "right",
                autoFit: true,
                startRow: false,
                endRow: false,
                click() {
                    PersonnelsLG_NAGap.fetchData();
                    Window_Personnel_NAGap.show();
                }
            },
            {
                name: "objectId",
                title: "<spring:message code='needsAssessmentReport.choose.post/job/postGrade'/>",
                // hidden: true,
                type: "ButtonItem",
                align: "right",
                autoFit: true,
                startRow: false,
                endRow: false,
                click() {
                    PostsLG_NAGap.fetchData();
                    Window_Post_NAGap.show();
                }
            },
        ]
    });

    DynamicForm_Title_NAGap = isc.DynamicForm.create({
        numCols: 1,
        fields: [
            {
                name: "Title_NASBGap",
                type: "staticText",
                title: "<spring:message code='needsAssessmentReport.job.gap'/>" + " <spring:message code='Mrs/Mr'/> " + getFormulaMessage("...", 2, "red", "b") + " <spring:message code='in.post'/> " + getFormulaMessage("...", 2, "red", "b"),
                titleAlign: "center",
                wrapTitle: false
            }
        ]
    });





    CoursesLG_NAGap = isc.TrLG.create({
        gridComponents: [
            ReportTypeDF_NAGap,
            DynamicForm_Title_NAGap,
            "header",
            "filterEditor",
            "body"
        ],
        dataSource: CourseDS_NAGap,
        // contextMenu: Menu_Courses_NABOP,
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
                optionDataSource: PriorityDS_NAGap,
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
                name: "competence.competenceType.title",
                // hidden: true,
                // type: "SelectItem",
                filterOnKeypress: true,
                // displayField: "title",
                // valueField: "id",
                // optionDataSource: CompetenceTypeDS_NAGap,
                // pickListProperties: {
                //     showFilterEditor: false
                // },
                // pickListFields: [
                //     {name: "title", width: "30%"}
                // ],
            },
            {
                name: "needsAssessmentDomainId",
                // hidden: true,
                // type: "IntegerItem",
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: DomainDS_NAGap,
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
                name: "limitSufficiency",
                // hidden: true
            },
            {
                name: "skill.titleFa",
                // hidden: true
            },

            {name: "skill.course.code"},
            {name: "skill.course.titleFa"},

            {
                name: "skill.course.scoresState",
                // type: "IntegerItem",
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: ScoresStateDS_NAGap,
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
            {name: "committeeScore",
                canEdit:true, filterOnKeypress: true,keyPressFilter: "[0-9.]",editEvent: "click"
            },
            {name: "competenceStatus"}
        ],
        canEditCell(rowNum, colNum){
            if(this.getFieldName(colNum) === "committeeScore") {
                let record = this.getRecord(rowNum);
                if ((record.needsAssessmentDomainId === 109 && (record.skill.course.scoresState===216  )) ||
                    (record.needsAssessmentDomainId === 110 && (record.skill.course.scoresState===216  ))) {
                    return true;
                }
            }
            return false;
        },
        sortField: "needsAssessmentPriorityId",
        dataArrived: function () {
        },
        filterEditorSubmit: function () {
            return CourseDS_NAGap.fetchDataURL != null;
        }
    });

    ToolStripButton_Refresh_NAGap = isc.ToolStripButtonRefresh.create({
        click: function () {
            if (CourseDS_NAGap.fetchDataURL == null)
                return;
            refreshLG_NAGap(CourseDS_NAGap);
        }
    });
    ToolStripButton_SendToGap_NAGap = isc.ToolStripButtonAdd.create({
        margin : 20,
        title: "ثبت نمرات کمیته",
        click: function () {
            if (CoursesLG_NAGap.getOriginalData().localData === undefined)
                createDialog("info", "داده ای برای  ارسال وجود ندارد");
            else {
                let records = ExportToFile.getAllData(CoursesLG_NAGap, null).data;

                let validRecords = [];
                for (let i = 1; i < records.size()+1; i++) {
                    let dataRecord = CoursesLG_NAGap.getEditValue(i, CoursesLG_NAGap.getField("committeeScore").masterIndex);

                    if ( dataRecord !== undefined &&
                        dataRecord !== null &&
                        dataRecord !== ''){
                        if ( Number( dataRecord )<= 100){
                            let rec = CoursesLG_NAGap.getOriginalData().localData.get(i-1)
                            let  data={};
                            data.course=rec.skill.course.code;
                            data.score=dataRecord;
                            data.nationalCode=selectedPerson_NAGap.nationalCode;
                            validRecords.add(data);
                        }
                        else {
                            createDialog("info", "نمره ی کمیته از ۱ تا ۱۰۰ وارد شود");
                        }

                    }
                }

                if (validRecords.length === 0) {
                    createDialog("info", "داده ای برای  ارسال وجود ندارد");
                } else {
                    wait.show();
                    isc.RPCManager.sendRequest(TrDSRequest("/training/api/scores-by-committee/add-scores", "POST", JSON.stringify(validRecords), function (resp) {
                        let respText = JSON.parse(resp.httpResponseText);
                        if (respText.status === 200) {
                            createDialog("info", "عملیات با موفقیت انجام شد");
                            wait.close();

                        } else {
                            createDialog("info", respText.message);
                            wait.close();

                        }
                    }));


                }
                }


        }
    });




    ToolStrip_Actions_NAGap = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_Refresh_NAGap,
            ]
    });

    Main_HLayout_NAGap = isc.TrHLayout.create({
        members: [CoursesLG_NAGap]
    });

    Main_VLayout_NAGap = isc.TrVLayout.create({
        border: "2px solid blue",
        align : "center",
        members: [ToolStrip_Actions_NAGap, Main_HLayout_NAGap,ToolStripButton_SendToGap_NAGap]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function refreshLG_NAGap(dataSource) {
        dataSource.invalidateCache();
        dataSource.fetchData();
        CoursesLG_NAGap.invalidateCache();
        CoursesLG_NAGap.fetchData();
    }

    function Select_Person_NAGap(selected_Person) {

            if (PersonnelSelected) {
            selected_Person = (selected_Person == null) ? PersonnelsLG_NAGap.getSelectedRecord() : selected_Person;
        }

        if (selected_Person == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }

        if (selected_Person.postId !== undefined && reportType_NAGap === "0") {
            wait_NAGap = createDialog("wait");
            selectedPerson_NAGap = selected_Person;
            isc.RPCManager.sendRequest(TrDSRequest(postUrl + "/get-by-id/" + selectedPerson_NAGap.postId, "GET", null, PostCodeSearch_result_NAGap));
        } else if (reportType_NAGap !== "0") {
            selectedPerson_NAGap = selected_Person;
            setTitle_NAGap();
            Window_Personnel_NAGap.close();
            // Window_SynonymPersonnel_NABOP.close();
        } else {
            createDialog("info", "<spring:message code="personnel.without.postCode"/>");
        }
    }

    function PostCodeSearch_result_NAGap(resp) {
        wait_NAGap.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            selectedObject_NAGap = JSON.parse(resp.httpResponseText);
            setTitle_NAGap();
            Window_Personnel_NAGap.close();
            // Window_SynonymPersonnel_NABOP.close();
        } else if (resp.httpResponseCode === 404 && resp.httpResponseText === "PostNotFound") {
            createDialog("info", "<spring:message code='needsAssessmentReport.postCode.not.Found'/>");
        } else {
            createDialog("info", "<spring:message code="msg.operation.error"/>");
        }
    }

    function Select_Post_NAGap(selected_Post) {
        selected_Post = (selected_Post == null) ? Tabset_Object_NAGap.getSelectedTab().pane.getSelectedRecord() : selected_Post;

        if (selected_Post == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }
        selectedObject_NAGap = selected_Post;
        setTitle_NAGap();
        Window_Post_NAGap.close();
    }



    function setTitle_NAGap() {
        // chartData_NABOP.forEach(value1 => value1.duration=0);
        switch (reportType_NAGap) {
            case "0":


                CourseDS_NAGap.fetchDataURL = needsAssessmentReportsWithGapUrl + "?objectId=" + selectedObject_NAGap.id + "&personnelId=" + selectedPerson_NAGap.id + "&objectType=Post";
                DynamicForm_Title_NAGap.getItem("Title_NASBGap").title = "<spring:message code='needsAssessmentReport.job.gap'/> " + "<spring:message code='Mrs/Mr'/> " +
                    getFormulaMessage(selectedPerson_NAGap.firstName, 2, "red", "b") + " " + getFormulaMessage(selectedPerson_NAGap.lastName, 2, "red", "b") +
                    " <spring:message code='national.code'/> " + getFormulaMessage(selectedPerson_NAGap.nationalCode, 2, "red", "b") +
                    " <spring:message code='in.post'/> " + getFormulaMessage(selectedPerson_NAGap.postTitle, 2, "red", "b") +
                    " <spring:message code='post.code'/> " + getFormulaMessage(selectedPerson_NAGap.postCode, 2, "red", "b") +
                    " <spring:message code='area'/> " + getFormulaMessage(selectedPerson_NAGap.ccpArea, 2, "red", "b") +
                    " <spring:message code='affairs'/> " + getFormulaMessage(selectedPerson_NAGap.ccpAffairs, 2, "red", "b");
                DynamicForm_Title_NAGap.getItem("Title_NASBGap").redraw();
                refreshLG_NAGap(CourseDS_NAGap);
                break;

            case "2":
                if (selectedPerson_NAGap != null && selectedObject_NAGap != null) {
                    CourseDS_NAGap.fetchDataURL = needsAssessmentReportsWithGapUrl + "?objectId=" + selectedObject_NAGap.id + "&personnelId=" + selectedPerson_NAGap.id + "&objectType="+ Tabset_Object_NAGap.getSelectedTab().name;
                    refreshLG_NAGap(CourseDS_NAGap);
                }
                let personName = selectedPerson_NAGap != null ? getFormulaMessage(selectedPerson_NAGap.firstName, 2, "red", "b") + " " + getFormulaMessage(selectedPerson_NAGap.lastName, 2, "red", "b") : getFormulaMessage("...", 2, "red", "b");
                let nationalCode = selectedPerson_NAGap != null ? " <spring:message code='national.code'/> " + getFormulaMessage(selectedPerson_NAGap.nationalCode, 2, "red", "b") : "";
                let postName = selectedObject_NAGap != null ? " <spring:message code='in.post'/> " + getFormulaMessage(selectedObject_NAGap.titleFa, 2, "red", "b") : getFormulaMessage("...", 2, "red", "b");
                let postCode = selectedObject_NAGap != null ? " <spring:message code='post.code'/> " + getFormulaMessage(selectedObject_NAGap.code, 2, "red", "b") : "";
                let area = selectedObject_NAGap != null ? " <spring:message code='area'/> " + getFormulaMessage(selectedObject_NAGap.area ? selectedObject_NAGap.area: "", 2, "red", "b") : "";
                let affairs = selectedObject_NAGap != null ? " <spring:message code='affairs'/> " + getFormulaMessage(selectedObject_NAGap.affairs ? selectedObject_NAGap.affairs : "", 2, "red", "b") : "";


                DynamicForm_Title_NAGap.getItem("Title_NASBGap").title = "<spring:message code='needsAssessmentReport.job.gap'/> " + "<spring:message code='Mrs/Mr'/> " + personName + nationalCode + postName + postCode + area + affairs;
                DynamicForm_Title_NAGap.getItem("Title_NASBGap").redraw();
        }
    }


    // //</script>