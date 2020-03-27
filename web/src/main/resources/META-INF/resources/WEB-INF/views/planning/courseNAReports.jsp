<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    var postCode_CNAR = null;
    var totalDuration_CNAR = [0, 0, 0];
    var passedDuration_CNAR = [0, 0, 0];
    var passedStatusId_CNAR = "216";
    var priorities_CNAR;
    var wait_CNAR;
    var selectedPerson_CNAR = null;
    var selectedObject_CNAR = null;
    var reportType_CNAR = "0";
    var objectType_CNAR;
    var chartData_CNAR = [
        {title: "<spring:message code='essential'/>",  type: "<spring:message code='total'/>", duration: 0},
        {title: "<spring:message code='essential'/>",  type: "<spring:message code='passed'/>", duration: 0},
        {title: "<spring:message code='improving'/>", type: "<spring:message code='total'/>", duration: 0},
        {title: "<spring:message code='improving'/>", type: "<spring:message code='passed'/>", duration: 0},
        {title: "<spring:message code='developmental'/>",  type: "<spring:message code='total'/>", duration: 0},
        {title: "<spring:message code='developmental'/>",  type: "<spring:message code='passed'/>", duration: 0}
    ];

    //--------------------------------------------------------------------------------------------------------------------//
    //*course form*/
    //--------------------------------------------------------------------------------------------------------------------//

    PostDS_CNAR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "job.titleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postGrade.titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},

        ],
        fetchDataURL: postUrl + "/iscList"
    });

    Menu_Post_CNAR = isc.Menu.create({
        data: [{
            title: "<spring:message code="refresh"/>", click: function () {
                refreshLG(PostsLG_CNAR);
            }
        }]
    });

    PostsLG_CNAR = isc.TrLG.create({
        dataSource: PostDS_CNAR,
        contextMenu: Menu_Post_CNAR,
        selectionType: "single",
        autoFetchData: true,
        fields: [
            {name: "code"},
            {name: "titleFa"},
            {name: "job.titleFa"},
            {name: "postGrade.titleFa"},
            {name: "area"},
            {name: "assistance"},
            {name: "affairs"},
            {name: "section"},
            {name: "unit"},
            {name: "costCenterCode"},
            {name: "costCenterTitleFa"}
        ],
        // rowDoubleClick: Select_Post_CNAR
    });

    IButton_Post_Ok_CNAR = isc.IButtonSave.create({
        title: "<spring:message code="select"/>",
        // click: Select_Post_CNAR
    });

    HLayout_Post_Ok_CNAR = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Post_Ok_CNAR]
    });

    ToolStripButton_Post_Refresh_CNAR = isc.ToolStripButtonRefresh.create({
        click: function () {
            refreshLG(PostsLG_CNAR);
        }
    });

    ToolStrip_Post_Actions_CNAR = isc.ToolStrip.create({
        width: "100%",
        align: "left",
        border: '0px',
        members: [
            ToolStripButton_Post_Refresh_CNAR
        ]
    });

    Window_Post_CNAR = isc.Window.create({
        placement: "fillScreen",
        title: "",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [isc.TrVLayout.create({
            members: [
                ToolStrip_Post_Actions_CNAR,
                PostsLG_CNAR,
                HLayout_Post_Ok_CNAR
            ]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*personnel form*/
    //--------------------------------------------------------------------------------------------------------------------//

    PersonnelDS_CNAR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains",},
            {name: "postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postCode", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpArea", title: "<spring:message code="reward.cost.center.area"/>", filterOperator: "iContains"},
            {name: "ccpAssistant", title: "<spring:message code="reward.cost.center.assistant"/>", filterOperator: "iContains"},
            {name: "ccpAffairs", title: "<spring:message code="reward.cost.center.affairs"/>", filterOperator: "iContains"},
            {name: "ccpSection", title: "<spring:message code="reward.cost.center.section"/>", filterOperator: "iContains"},
            {name: "ccpUnit", title: "<spring:message code="reward.cost.center.unit"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: personnelUrl + "/iscList"
    });

    Menu_Personnel_CNAR = isc.Menu.create({
        data: [{
            title: "<spring:message code="refresh"/>", click: function () {
                refreshLG(PersonnelsLG_CNAR);
            }
        }]
    });

    PersonnelsLG_CNAR = isc.TrLG.create({
        dataSource: PersonnelDS_CNAR,
        contextMenu: Menu_Personnel_CNAR,
        selectionType: "single",
        fields: [
            {name: "firstName"},
            {name: "lastName"},
            {name: "nationalCode"},
            {name: "companyName"},
            {name: "personnelNo"},
            {name: "personnelNo2"},
            {name: "postTitle"},
            {name: "postCode"},
            {name: "ccpArea"},
            {name: "ccpAssistant"},
            {name: "ccpAffairs"},
            {name: "ccpSection"},
            {name: "ccpUnit"},
        ],
        // rowDoubleClick: Select_Person_CNAR
    });

    IButton_Personnel_Ok_CNAR = isc.IButtonSave.create({
        title: "<spring:message code="select"/>",
        // click: Select_Person_CNAR
    });

    HLayout_Personnel_Ok_CNAR = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Personnel_Ok_CNAR]
    });

    ToolStripButton_Personnel_Refresh_CNAR = isc.ToolStripButtonRefresh.create({
        click: function () {
            refreshLG(PersonnelsLG_CNAR);
        }
    });

    ToolStrip_Personnel_Actions_CNAR = isc.ToolStrip.create({
        width: "100%",
        align: "left",
        border: '0px',
        members: [
            ToolStripButton_Personnel_Refresh_CNAR
        ]
    });

    Window_Personnel_CNAR = isc.Window.create({
        placement: "fillScreen",
        title: "<spring:message code="personnel"/>",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [isc.TrVLayout.create({
            members: [
                ToolStrip_Personnel_Actions_CNAR,
                PersonnelsLG_CNAR,
                HLayout_Personnel_Ok_CNAR
            ]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*courses form*/
    //--------------------------------------------------------------------------------------------------------------------//

    PriorityDS_CNAR = isc.TrDS.create({
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

    ScoresStateDS_CNAR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/PassedStatus"
    });

    DomainDS_CNAR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/NeedsAssessmentDomain"
    });

    CompetenceTypeDS_CNAR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/competenceType"
    });

    CourseDS_CNAR = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "needsAssessmentPriorityId", title: "<spring:message code='priority'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "needsAssessmentDomainId", title: "<spring:message code='domain'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "competence.title", title: "<spring:message code="competence"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competence.competenceTypeId", title: "<spring:message code="competence.type"/>", filterOperator: "equals", autoFitWidth: true},
            {name: "skill.code", title: "<spring:message code="skill.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "skill.titleFa", title: "<spring:message code="skill"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "skill.course.theoryDuration", title: "<spring:message code="duration"/>", filterOperator: "equals", autoFitWidth: true},
            {name: "skill.course.scoresState", title: "<spring:message code='status'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "skill.course.code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "skill.course.titleFa", title: "<spring:message code="course"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: null
    });

    Menu_Courses_CNAR = isc.Menu.create({
        data: [{
            title: "<spring:message code="refresh"/>", click: function () {
                if (CourseDS_CNAR.fetchDataURL == null)
                    return;
                // refreshLG_CNAR(CourseDS_CNAR);
            }
        <%--}, {--%>
        <%--    isSeparator: true--%>
        <%--}, {--%>
        <%--    title: "<spring:message code="format.pdf"/>",--%>
        <%--    click: function () {--%>
        <%--        print_CNAR("pdf");--%>
        <%--    }--%>
        <%--}, {--%>
        <%--    title: "<spring:message code="format.excel"/>",--%>
        <%--    click: function () {--%>
        <%--        print_CNAR("excel");--%>
        <%--    }--%>
        <%--}, {--%>
        <%--    title: "<spring:message code="format.html"/>",--%>
        <%--    click: function () {--%>
        <%--        print_CNAR("html");--%>
        <%--    }--%>
        }]
    });

    isc.Menu.create({
        ID: "menu",
        autoDraw: false,
        showShadow: true,
        shadowDepth: 10,
        data: [
            {title: "New", keyTitle: "Ctrl+N"},
            {title: "Open", keyTitle: "Ctrl+O"},
            {isSeparator: true},
            {title: "Save", keyTitle: "Ctrl+S"},
            {title: "Save As"},
            {isSeparator: true},
            {title: "Recent Documents", submenu: [
                    {title: "data.xml", checked: true},
                    {title: "Component Guide.doc"},
                    {title: "SmartClient.doc", checked: true},
                    {title: "AJAX.doc"}
                ]},
            {isSeparator: true},
            {title: "Export as...", submenu: [
                    {title: "XML"},
                    {title: "CSV"},
                    {title: "Plain text"}
                ]},
            {isSeparator: true},
            {title: "Print", enabled: false, keyTitle: "Ctrl+P"}
        ]
    });

    menuButton = isc.MenuButton.create({
        ID: "menuButton",
        autoDraw: false,
        title: "File",
        // padding: 10,
        // width: 100,
        menu: menu
    });

    HeaderDF_CNAR = isc.DynamicForm.create({
        // numCols: 6,
        // padding: 10,
        titleAlign: "left",
        // colWidths: [700, 150, 150],
        fields: [
            // {
            //     name: "groupingType",
            //     type: "ButtonItem",
            //     title: "انتخاب پرسنل",
            //     // width: 100,
            //     menu: menu
            // },
            <%--{--%>
            <%--    name: "personnelId",--%>
            <%--    title: "<spring:message code="personnel.choose"/>",--%>
            <%--    type: "ButtonItem",--%>
            <%--    width: "*",--%>
            <%--    startRow: false,--%>
            <%--    endRow: false,--%>
            <%--    click() {--%>
            <%--        PersonnelsLG_CNAR.fetchData();--%>
            <%--        Window_Personnel_CNAR.show();--%>
            <%--    }--%>
            <%--},--%>
            {
                name: "courseId",
                title: "انتخاب دوره",
                // disabled: true,
                type: "ButtonItem",
                // width: "*",
                // startRow: false,
                // endRow: false,
                click() {
                    // PostsLG_CNAR.fetchData();
                    // Window_Post_CNAR.show();
                }
            },
        ]
    });

    Buttoms_HLayout_CNAR = isc.TrHLayout.create({
        height: "50px",
        padding: 10,
        members: [menuButton, HeaderDF_CNAR]
    });

    DynamicForm_Title_CNAR = isc.DynamicForm.create({
        numCols: 1,
        fields: [
            {
                name: "Title_NASB",
                type: "staticText",
                title: "<spring:message code='needsAssessmentReport'/>" + " <spring:message code='Mrs/Mr'/> " + getFormulaMessage("...", 2, "red", "b"),
                titleAlign: "center",
                wrapTitle: false
            }
        ]
    });

    <%--let fullSummaryFunc_CNAR = [--%>
    <%--    function (records) {--%>
    <%--        let total = 0;--%>
    <%--        for (let i = 0; i < records.length; i++) {--%>
    <%--            total += records[i].skill.course.theoryDuration;--%>
    <%--        }--%>
    <%--        let index = getIndexById_CNAR(records[0].needsAssessmentPriorityId);--%>
    <%--        if (total !== 0) {--%>
    <%--            totalDuration_CNAR[index] = total;--%>
    <%--            chartData_CNAR.find({title:priorities_CNAR[index].title, type:"<spring:message code='total'/>"}).duration = total;--%>
    <%--        }--%>
    <%--        return "<spring:message code="duration.hour.sum"/>" + total;--%>
    <%--    },--%>
    <%--    function (records) {--%>
    <%--        let passed = 0;--%>
    <%--        for (let i = 0; i < records.length; i++) {--%>
    <%--            if (records[i].skill.course.scoresState === passedStatusId_CNAR)--%>
    <%--                passed += records[i].skill.course.theoryDuration;--%>
    <%--        }--%>
    <%--        let index = getIndexById_CNAR(records[0].needsAssessmentPriorityId);--%>
    <%--        if (passed !== 0) {--%>
    <%--            passedDuration_CNAR[index] = passed;--%>
    <%--            chartData_CNAR.find({title:priorities_CNAR[index].title, type:"<spring:message code='passed'/>"}).duration = passed;--%>
    <%--        }--%>
    <%--        return "<spring:message code="duration.hour.sum.passed"/>" + passed;--%>
    <%--    },--%>
    <%--    function (records) {--%>
    <%--        if (!records.isEmpty() && totalDuration_CNAR[getIndexById_CNAR(records[0].needsAssessmentPriorityId)] !== 0) {--%>
    <%--            return "<spring:message code="duration.percent.passed"/>" +--%>
    <%--                Math.round(passedDuration_CNAR[getIndexById_CNAR(records[0].needsAssessmentPriorityId)] /--%>
    <%--                    totalDuration_CNAR[getIndexById_CNAR(records[0].needsAssessmentPriorityId)] * 100);--%>
    <%--        }--%>
    <%--        return "<spring:message code="duration.percent.passed"/>" + 0;--%>
    <%--    }--%>
    <%--];--%>

    <%--let totalSummaryFunc_CNAR = [--%>
    <%--    function (records) {--%>
    <%--        let total = 0;--%>
    <%--        for (let i = 0; i < records.length; i++) {--%>
    <%--            total += records[i].skill.course.theoryDuration;--%>
    <%--        }--%>
    <%--        let index = getIndexById_CNAR(records[0].needsAssessmentPriorityId);--%>
    <%--        if (total !== 0) {--%>
    <%--            totalDuration_CNAR[index] = total;--%>
    <%--            chartData_CNAR.find({title:priorities_CNAR[index].title, type:"<spring:message code='total'/>"}).duration = total;--%>
    <%--        }--%>
    <%--        return "<spring:message code="duration.hour.sum"/>" + total;--%>
    <%--    }--%>
    <%--];--%>

    CoursesLG_CNAR = isc.TrLG.create({
        gridComponents: [Buttoms_HLayout_CNAR, DynamicForm_Title_CNAR, "header", "filterEditor", "body"],
        dataSource: CourseDS_CNAR,
        contextMenu: Menu_Courses_CNAR,
        selectionType: "single",
        autoFetchData: false,
        alternateRecordStyles: true,
        showAllRecords: true,
        groupByField: "needsAssessmentPriorityId",
        groupStartOpen: "all",
        showGroupSummary: true,
        fields: [
            {
                name: "needsAssessmentPriorityId",
                hidden: true,
                // type: "IntegerItem",
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: PriorityDS_CNAR,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
            {name: "competence.title", hidden: true},
            {
                name: "competence.competenceTypeId",
                hidden: true,
                type: "SelectItem",
                filterOnKeypress: true,
                // editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: CompetenceTypeDS_CNAR,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
            {
                name: "needsAssessmentDomainId",
                hidden: true,
                // type: "IntegerItem",
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: DomainDS_CNAR,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
            {name: "skill.code", hidden: true},
            {name: "skill.titleFa", hidden: true},


            {name: "skill.course.code"},
            {name: "skill.course.titleFa"},
            {
                name: "skill.course.theoryDuration",
                showGroupSummary: true,
                // summaryFunction: fullSummaryFunc_CNAR
            },
            {
                name: "skill.course.scoresState",
                // type: "IntegerItem",
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: ScoresStateDS_CNAR,
                addUnknownValues: false,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
        ],
        dataArrived: function () {
            Main_HLayout_CNAR.getMember("Chart_CNAR").setData(chartData_CNAR);
        }
    });

    ToolStripButton_Refresh_CNAR = isc.ToolStripButtonRefresh.create({
        click: function () {
            if (CourseDS_CNAR.fetchDataURL == null)
                return;
            // refreshLG_CNAR(CourseDS_CNAR);
        }
    });
    <%--ToolStripButton_Print_CNAR = isc.ToolStripButtonPrint.create({--%>
    <%--    title: "<spring:message code='print'/>",--%>
    <%--    click: function () {--%>
    <%--        print_CNAR("pdf");--%>
    <%--    }--%>
    <%--});--%>

    ToolStrip_Actions_CNAR = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                // ToolStripButton_Print_CNAR,
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_CNAR
                    ]
                })
            ]
    });

    Main_HLayout_CNAR = isc.TrHLayout.create({
        members: [CoursesLG_CNAR]
    });

    Main_VLayout_CNAR = isc.TrVLayout.create({
        border: "2px solid blue",
        members: [ToolStrip_Actions_CNAR, Main_HLayout_CNAR]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    <%--function refreshLG_CNAR(listGrid) {--%>
    <%--    listGrid.invalidateCache();--%>
    <%--    listGrid.fetchData();--%>
    <%--    CoursesLG_CNAR.invalidateCache();--%>
    <%--    CoursesLG_CNAR.fetchData();--%>
    <%--}--%>

    <%--function Select_Person_CNAR() {--%>

    <%--    if (PersonnelsLG_CNAR.getSelectedRecord() == null) {--%>
    <%--        createDialog("info", "<spring:message code='msg.no.records.selected'/>");--%>
    <%--        return;--%>
    <%--    }--%>

    <%--    if (PersonnelsLG_CNAR.getSelectedRecord().postCode !== undefined && reportType_CNAR === "0") {--%>
    <%--        postCode_CNAR = PersonnelsLG_CNAR.getSelectedRecord().postCode.replace("/", ".");--%>
    <%--        wait_CNAR = createDialog("wait");--%>
    <%--        isc.RPCManager.sendRequest(TrDSRequest(postUrl + "/" + postCode_CNAR, "GET", null, PostCodeSearch_result_CNAR));--%>
    <%--    } else if (reportType_CNAR !== 0) {--%>
    <%--        selectedPerson_CNAR = PersonnelsLG_CNAR.getSelectedRecord();--%>
    <%--        setTitle_CNAR();--%>
    <%--        Window_Personnel_CNAR.close();--%>
    <%--    } else {--%>
    <%--        postCode_CNAR = null;--%>
    <%--        createDialog("info", "<spring:message code="personnel.without.postCode"/>");--%>
    <%--    }--%>
    <%--}--%>

    <%--function PostCodeSearch_result_CNAR(resp) {--%>
    <%--    wait_CNAR.close();--%>
    <%--    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 200) {--%>
    <%--        selectedPerson_CNAR = PersonnelsLG_CNAR.getSelectedRecord();--%>
    <%--        setTitle_CNAR(JSON.parse(resp.httpResponseText).id);--%>
    <%--        Window_Personnel_CNAR.close();--%>
    <%--    } else if (resp.httpResponseCode === 404 && resp.httpResponseText === "PostNotFound") {--%>
    <%--        createDialog("info", "<spring:message code='needsAssessmentReport.postCode.not.Found'/>");--%>
    <%--    } else {--%>
    <%--        createDialog("info", "<spring:message code="msg.operation.error"/>");--%>
    <%--    }--%>
    <%--}--%>

    <%--function Select_Post_CNAR() {--%>
    <%--    if (Tabset_Object_CNAR.getSelectedTab().pane.getSelectedRecord() == null) {--%>
    <%--        createDialog("info", "<spring:message code='msg.no.records.selected'/>");--%>
    <%--        return;--%>
    <%--    }--%>
    <%--    selectedObject_CNAR = Tabset_Object_CNAR.getSelectedTab().pane.getSelectedRecord();--%>
    <%--    setTitle_CNAR();--%>
    <%--    Window_Post_CNAR.close();--%>
    <%--}--%>

    <%--function setTitle_CNAR(postId = null) {--%>
    <%--    chartData_CNAR.forEach(value1 => value1.duration=0);--%>
    <%--    for (let i = 0; i < priorities_CNAR.length; i++) {--%>
    <%--        totalDuration_CNAR[i] = 0;--%>
    <%--        passedDuration_CNAR[i] = 0;--%>
    <%--    }--%>
    <%--    switch (reportType_CNAR) {--%>
    <%--        case "0":--%>
    <%--            CourseDS_CNAR.fetchDataURL = needsAssessmentReportsUrl + "?objectId=" + postId + "&personnelNo=" + selectedPerson_CNAR.personnelNo + "&objectType=Post";--%>
    <%--            DynamicForm_Title_CNAR.getItem("Title_NASB").title = "<spring:message code='needsAssessmentReport'/> " +--%>
    <%--                "<spring:message code='Mrs/Mr'/> " +--%>
    <%--                getFormulaMessage(selectedPerson_CNAR.firstName, 2, "red", "b") + " " +--%>
    <%--                getFormulaMessage(selectedPerson_CNAR.lastName, 2, "red", "b");--%>
    <%--            DynamicForm_Title_CNAR.getItem("Title_NASB").redraw();--%>
    <%--            refreshLG_CNAR(CourseDS_CNAR);--%>
    <%--            break;--%>
    <%--        case "1":--%>
    <%--            CourseDS_CNAR.fetchDataURL = needsAssessmentReportsUrl + "?objectId=" + selectedObject_CNAR.id + "&objectType=" + Tabset_Object_CNAR.getSelectedTab().name;--%>
    <%--            DynamicForm_Title_CNAR.getItem("Title_NASB").title = "<spring:message code='needsAssessmentReport'/> " +--%>
    <%--                Tabset_Object_CNAR.getSelectedTab().title + " " +--%>
    <%--                getFormulaMessage(selectedObject_CNAR.titleFa, 2, "red", "b");--%>
    <%--            DynamicForm_Title_CNAR.getItem("Title_NASB").redraw();--%>
    <%--            refreshLG_CNAR(CourseDS_CNAR);--%>
    <%--            break;--%>
    <%--        case "2":--%>
    <%--            if (selectedPerson_CNAR != null && selectedObject_CNAR != null) {--%>
    <%--                CourseDS_CNAR.fetchDataURL = needsAssessmentReportsUrl + "?objectId=" + selectedObject_CNAR.id + "&personnelNo=" + selectedPerson_CNAR.personnelNo + "&objectType=Post";--%>
    <%--                refreshLG_CNAR(CourseDS_CNAR);--%>
    <%--            }--%>
    <%--            let personName = selectedPerson_CNAR != null ? getFormulaMessage(selectedPerson_CNAR.firstName, 2, "red", "b") + " " + getFormulaMessage(selectedPerson_CNAR.lastName, 2, "red", "b") : getFormulaMessage("...", 2, "red", "b");--%>
    <%--            let postName = selectedObject_CNAR != null ? getFormulaMessage(selectedObject_CNAR.titleFa, 2, "red", "b") : getFormulaMessage("...", 2, "red", "b");--%>
    <%--            DynamicForm_Title_CNAR.getItem("Title_NASB").title = "<spring:message code='needsAssessmentReport.job.promotion'/> " + "<spring:message code='Mrs/Mr'/> " + personName + " <spring:message code='in.post'/> " + postName;--%>
    <%--            DynamicForm_Title_CNAR.getItem("Title_NASB").redraw();--%>
    <%--    }--%>
    <%--}--%>

    <%--function print_CNAR(type) {--%>
    <%--    if (selectedPerson_CNAR == null) {--%>
    <%--        createDialog("info", "<spring:message code="personnel.not.selected"/>");--%>
    <%--        return;--%>
    <%--    }--%>
    <%--    let records = CourseDS_CNAR.getCacheData();--%>
    <%--    if (records === undefined) {--%>
    <%--        createDialog("info", "<spring:message code='print.no.data.to.print'/>");--%>
    <%--        return;--%>
    <%--    }--%>
    <%--    let groupedRecords = [[], [], []];--%>
    <%--    for (let i = 0; i < records.length; i++) {--%>
    <%--        groupedRecords[getIndexById_CNAR(records[i].needsAssessmentPriorityId)].add({--%>
    <%--            "id": records[i].id,--%>
    <%--            "code": records[i].code,--%>
    <%--            "titleFa": records[i].titleFa,--%>
    <%--            "theoryDuration": records[i].theoryDuration,--%>
    <%--            "needsAssessmentPriorityId": records[i].needsAssessmentPriorityId,--%>
    <%--            "status": records[i].skill.course.scoresState--%>
    <%--        });--%>
    <%--    }--%>
    <%--    let personnel = {--%>
    <%--        "id": selectedPerson_CNAR.id,--%>
    <%--        "firstName": selectedPerson_CNAR.firstName,--%>
    <%--        "lastName": selectedPerson_CNAR.lastName,--%>
    <%--        "nationalCode": selectedPerson_CNAR.nationalCode,--%>
    <%--        "companyName": selectedPerson_CNAR.companyName,--%>
    <%--        "personnelNo": selectedPerson_CNAR.personnelNo,--%>
    <%--        "personnelNo2": selectedPerson_CNAR.personnelNo2,--%>
    <%--    };--%>
    <%--    let criteriaForm_course = isc.DynamicForm.create({--%>
    <%--        method: "POST",--%>
    <%--        action: "<spring:url value="web/personnel-needs-assessment-report-print/"/>" + type,--%>
    <%--        target: "_Blank",--%>
    <%--        canSubmit: true,--%>
    <%--        fields:--%>
    <%--            [--%>
    <%--                {name: "essentialRecords", type: "hidden"},--%>
    <%--                {name: "improvingRecords", type: "hidden"},--%>
    <%--                {name: "developmentalRecords", type: "hidden"},--%>
    <%--                {name: "totalEssentialHours", type: "hidden"},--%>
    <%--                {name: "passedEssentialHours", type: "hidden"},--%>
    <%--                {name: "totalImprovingHours", type: "hidden"},--%>
    <%--                {name: "passedImprovingHours", type: "hidden"},--%>
    <%--                {name: "totalDevelopmentalHours", type: "hidden"},--%>
    <%--                {name: "passedDevelopmentalHours", type: "hidden"},--%>
    <%--                {name: "personnel", type: "hidden"},--%>
    <%--                {name: "myToken", type: "hidden"}--%>
    <%--            ]--%>
    <%--    });--%>
    <%--    criteriaForm_course.setValue("essentialRecords", JSON.stringify(groupedRecords[getIndexByCode_CNAR("AZ")]));--%>
    <%--    criteriaForm_course.setValue("improvingRecords", JSON.stringify(groupedRecords[getIndexByCode_CNAR("AB")]));--%>
    <%--    criteriaForm_course.setValue("developmentalRecords", JSON.stringify(groupedRecords[getIndexByCode_CNAR("AT")]));--%>
    <%--    criteriaForm_course.setValue("totalEssentialHours", JSON.stringify(totalDuration_CNAR[getIndexByCode_CNAR("AZ")]));--%>
    <%--    criteriaForm_course.setValue("passedEssentialHours", JSON.stringify(passedDuration_CNAR[getIndexByCode_CNAR("AZ")]));--%>
    <%--    criteriaForm_course.setValue("totalImprovingHours", JSON.stringify(totalDuration_CNAR[getIndexByCode_CNAR("AB")]));--%>
    <%--    criteriaForm_course.setValue("passedImprovingHours", JSON.stringify(passedDuration_CNAR[getIndexByCode_CNAR("AB")]));--%>
    <%--    criteriaForm_course.setValue("totalDevelopmentalHours", JSON.stringify(totalDuration_CNAR[getIndexByCode_CNAR("AT")]));--%>
    <%--    criteriaForm_course.setValue("passedDevelopmentalHours", JSON.stringify(passedDuration_CNAR[getIndexByCode_CNAR("AT")]));--%>
    <%--    criteriaForm_course.setValue("personnel", JSON.stringify(personnel));--%>
    <%--    criteriaForm_course.setValue("myToken", "<%=accessToken%>");--%>
    <%--    criteriaForm_course.show();--%>
    <%--    criteriaForm_course.submitForm();--%>
    <%--}--%>

    <%--function getIndexById_CNAR(needsAssessmentPriorityId) {--%>
    <%--    for (let i = 0; i < priorities_CNAR.length; i++) {--%>
    <%--        if (priorities_CNAR[i].id === needsAssessmentPriorityId)--%>
    <%--            return i;--%>
    <%--    }--%>
    <%--}--%>

    <%--function getIndexByCode_CNAR(code) {--%>
    <%--    for (let i = 0; i < priorities_CNAR.length; i++) {--%>
    <%--        if (priorities_CNAR[i].code === code)--%>
    <%--            return i;--%>
    <%--    }--%>
    <%--}--%>

    <%--isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/iscList/NeedsAssessmentPriority", "GET", null, setPriorities_CNAR));--%>

    <%--function setPriorities_CNAR(resp){--%>
    <%--    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {--%>
    <%--        priorities_CNAR = JSON.parse(resp.httpResponseText).response.data;--%>
    <%--        for (let i = 0; i < priorities_CNAR.length; i++) {--%>
    <%--            if (priorities_CNAR[i].title === "عملکردی ضروری")--%>
    <%--                priorities_CNAR[i].title = "<spring:message code='essential'/>";--%>
    <%--            else if (priorities_CNAR[i].title === "عملکردی بهبود")--%>
    <%--                priorities_CNAR[i].title = "<spring:message code='improving'/>";--%>
    <%--            else if (priorities_CNAR[i].title === "عملکردی توسعه")--%>
    <%--                priorities_CNAR[i].title = "<spring:message code='developmental'/>";--%>
    <%--        }--%>
    <%--    } else {--%>
    <%--        createDialog("info", "<spring:message code="msg.operation.error"/>");--%>
    <%--    }--%>
    <%--}--%>

    <%--createChart_CNAR();--%>
    <%--function createChart_CNAR () {--%>
    <%--    let Chart_CNAR = isc.Canvas.getById("Chart_CNAR");--%>
    <%--    if (Chart_CNAR) {--%>
    <%--        Chart_CNAR.destroy();--%>
    <%--    }--%>
    <%--    chartData_CNAR = [--%>
    <%--        {title: "<spring:message code='essential'/>",  type: "<spring:message code='total'/>", duration: 0},--%>
    <%--        {title: "<spring:message code='essential'/>",  type: "<spring:message code='passed'/>", duration: 0},--%>
    <%--        {title: "<spring:message code='improving'/>", type: "<spring:message code='total'/>", duration: 0},--%>
    <%--        {title: "<spring:message code='improving'/>", type: "<spring:message code='passed'/>", duration: 0},--%>
    <%--        {title: "<spring:message code='developmental'/>",  type: "<spring:message code='total'/>", duration: 0},--%>
    <%--        {title: "<spring:message code='developmental'/>",  type: "<spring:message code='passed'/>", duration: 0}--%>
    <%--    ];--%>
    <%--    let facets;--%>
    <%--    let chartType;--%>
    <%--    if (reportType_CNAR === "1") {--%>
    <%--        chartType = "Pie";--%>
    <%--        facets = [{id: "title", title: "<spring:message code='priority'/>"}];--%>
    <%--    } else {--%>
    <%--        chartType = "Radar";--%>
    <%--        facets = [--%>
    <%--            {id: "title", title: "<spring:message code='priority'/>"},--%>
    <%--            {id: "type", title: "<spring:message code='status'/>"}];--%>
    <%--    }--%>
    <%--    Chart_CNAR = isc.FacetChart.create({--%>
    <%--        ID: "Chart_CNAR",--%>
    <%--        width: "35%",--%>
    <%--        facets: facets,--%>
    <%--        data: chartData_CNAR,--%>
    <%--        valueProperty: "duration",--%>
    <%--        chartType: chartType,--%>
    <%--        showTitle: false,--%>
    <%--        filled: true,--%>
    <%--        stacked: false,--%>
    <%--    });--%>
    <%--    Main_HLayout_CNAR.addMember(Chart_CNAR);--%>
    <%--}--%>

    //</script>