<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    var postCode_NABOP = null;
    var totalDuration_NABOP = [0, 0, 0];
    var passedDuration_NABOP = [0, 0, 0];
    var passedStatusId_NABOP = "216";
    var priorities_NABOP;
    var wait_NABOP;
    var selectedPerson_NABOP = null;
    var selectedPost_NABOP = null;
    var reportType_NABOP = "0";
    var temp;

    //--------------------------------------------------------------------------------------------------------------------//
    //*post form*/
    //--------------------------------------------------------------------------------------------------------------------//

    PostDS_NABOP = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "code",
                title: "<spring:message code="post.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "titleFa",
                title: "<spring:message code="post.title"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "job.titleFa",
                title: "<spring:message code="job.title"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "postGrade.titleFa",
                title: "<spring:message code="post.grade.title"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {
                name: "assistance",
                title: "<spring:message code="assistance"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "affairs",
                title: "<spring:message code="affairs"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "section",
                title: "<spring:message code="section"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {
                name: "costCenterCode",
                title: "<spring:message code="reward.cost.center.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "costCenterTitleFa",
                title: "<spring:message code="reward.cost.center.title"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },

        ],
        fetchDataURL: postUrl + "/iscList"
    });

    Menu_Post_NABOP = isc.Menu.create({
        data: [{
            title: "<spring:message code="refresh"/>", click: function () {
                refreshLG(PostsLG_NABOP);
            }
        }]
    });

    PostsLG_NABOP = isc.TrLG.create({
        dataSource: PostDS_NABOP,
        contextMenu: Menu_Post_NABOP,
        selectionType: "single",
        fields: [
            {name: "code",},
            {name: "titleFa",},
            {name: "job.titleFa",},
            {name: "postGrade.titleFa",},
            {name: "area",},
            {name: "assistance",},
            {name: "affairs",},
            {name: "section",},
            {name: "unit",},
            {name: "costCenterCode",},
            {name: "costCenterTitleFa",},
        ],
        rowDoubleClick: Select_Post_NABOP
    });

    IButton_Post_Ok_NABOP = isc.IButtonSave.create({
        title: "<spring:message code="select"/>",
        click: Select_Post_NABOP
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
            refreshLG(PostsLG_NABOP);
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
        title: "<spring:message code="post"/>",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [isc.TrVLayout.create({
            members: [
                ToolStrip_Post_Actions_NABOP,
                PostsLG_NABOP,
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
            {
                name: "firstName",
                title: "<spring:message code="firstName"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "lastName",
                title: "<spring:message code="lastName"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "companyName",
                title: "<spring:message code="company.name"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "personnelNo",
                title: "<spring:message code="personnel.no"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "personnelNo2",
                title: "<spring:message code="personnel.no.6.digits"/>",
                filterOperator: "iContains",
            },
            {
                name: "postTitle",
                title: "<spring:message code="post"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "postCode",
                title: "<spring:message code="post.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "ccpArea", title: "<spring:message code="reward.cost.center.area"/>", filterOperator: "iContains"},
            {
                name: "ccpAssistant",
                title: "<spring:message code="reward.cost.center.assistant"/>",
                filterOperator: "iContains"
            },
            {
                name: "ccpAffairs",
                title: "<spring:message code="reward.cost.center.affairs"/>",
                filterOperator: "iContains"
            },
            {
                name: "ccpSection",
                title: "<spring:message code="reward.cost.center.section"/>",
                filterOperator: "iContains"
            },
            {name: "ccpUnit", title: "<spring:message code="reward.cost.center.unit"/>", filterOperator: "iContains"},
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
        contextMenu: Menu_Personnel_NABOP,
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
        rowDoubleClick: Select_Person_NABOP
    });

    IButton_Personnel_Ok_NABOP = isc.IButtonSave.create({
        title: "<spring:message code="select"/>",
        click: Select_Person_NABOP
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
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/NeedsAssessmentPriority"
    });

    StatusDS_NABOP = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/PassedStatus"
    });

    CourseDS_NABOP = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "code",
                title: "<spring:message code="code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "titleFa",
                title: "<spring:message code="title"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "theoryDuration",
                title: "<spring:message code="duration"/>",
                filterOperator: "equals",
                autoFitWidth: true
            },
            {
                name: "needsAssessmentPriorityId",
                title: "<spring:message code='priority'/>",
                filterOperator: "equals",
                autoFitWidth: true
            },
            {
                name: "status",
                title: "<spring:message code='status'/>",
                filterOperator: "equals",
                autoFitWidth: true
            }

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
            isSeparator: true
        }, {
            title: "<spring:message code="format.pdf"/>",
            click: function () {
                print_NABOP("pdf");
            }
        }, {
            title: "<spring:message code="format.excel"/>",
            click: function () {
                print_NABOP("excel");
            }
        }, {
            title: "<spring:message code="format.html"/>",
            click: function () {
                print_NABOP("html");
            }
        }]
    });

    ReportTypeDF_NABOP = isc.DynamicForm.create({
        numCols: 7,
        padding: 10,
        titleAlign: "left",
        colWidths: [500, 100, 100, 100, 100, 150, 100],
        fields: [
            {
                name: "reportType",
                showTitle: false,
                type: "radioGroup",
                width: "*",
                valueMap: {
                    0: "گزارش نیازسنجی پرسنل",
                    1: "گزارش نیازسنجی پست",
                    2: "گزارش نیازسنجی ارتقاء پرسنل",
                },
                vertical: false,
                defaultValue: 0,
                changed: function (form, item, value) {
                    selectedPerson_NABOP = null;
                    selectedPost_NABOP = null;
                    form.getItem("showReport").disable();
                    if (value === "0") {
                        reportType_NABOP = "0";
                        form.getItem("personnelId").enable();
                        form.getItem("postId").disable();
                        DynamicForm_Title_NABOP.getItem("Title_NASB").title = "گزارش نیازسنجی خانم/آقای " + getFormulaMessage("...", 2, "red", "b");
                        CoursesLG_NABOP.showField("status");
                        CoursesLG_NABOP.getField("theoryDuration").summaryFunction = fullSummaryFunc_NABOP;
                    } else if (value === "1") {
                        reportType_NABOP = "1";
                        form.getItem("personnelId").disable();
                        form.getItem("postId").enable();
                        DynamicForm_Title_NABOP.getItem("Title_NASB").title = "گزارش نیازسنجی پست " + getFormulaMessage("...", 2, "red", "b");
                        CoursesLG_NABOP.hideField("status");
                        CoursesLG_NABOP.getField("theoryDuration").summaryFunction = totalSummaryFunc_NABOP;
                    } else {
                        reportType_NABOP = "2";
                        form.getItem("personnelId").enable();
                        form.getItem("postId").enable();
                        DynamicForm_Title_NABOP.getItem("Title_NASB").title = "گزارش نیازسنجی ارتقاء خانم/آقای " + getFormulaMessage("...", 2, "red", "b") + " در پست " + getFormulaMessage("...", 2, "red", "b");
                        CoursesLG_NABOP.showField("status");
                        CoursesLG_NABOP.getField("theoryDuration").summaryFunction = fullSummaryFunc_NABOP;
                    }
                    DynamicForm_Title_NABOP.getItem("Title_NASB").redraw();
                    CoursesLG_NABOP.setData([]);
                    CourseDS_NABOP.fetchDataURL = null;
                }
            },
            {
                name: "personnelId",
                title: "<spring:message code="personnel.choose"/>",
                type: "ButtonItem",
                width: "*",
                startRow: false,
                endRow: false,
                click() {
                    PersonnelsLG_NABOP.fetchData();
                    Window_Personnel_NABOP.show();
                }
            },
            {
                name: "postId",
                title: "انتخاب پست",
                disabled: true,
                type: "ButtonItem",
                width: "*",
                startRow: false,
                endRow: false,
                click() {
                    PostsLG_NABOP.fetchData();
                    Window_Post_NABOP.show();
                }
            },
            {
                name: "showReport",
                title: "نمایش گزارش",
                disabled: true,
                type: "ButtonItem",
                width: "*",
                startRow: false,
                endRow: false,
                click() {
                    refreshLG_NABOP(CourseDS_NABOP);
                }
            }
        ]
    });

    DynamicForm_Title_NABOP = isc.DynamicForm.create({
        numCols: 1,
        fields: [
            {
                name: "Title_NASB",
                type: "staticText",
                title: "گزارش نیازسنجی خانم/آقای " + getFormulaMessage("...", 2, "red", "b"),
                titleAlign: "center",
                wrapTitle: false
            }
        ]
    });

    let fullSummaryFunc_NABOP = [
        function (records) {
            let total = 0;
            for (let i = 0; i < records.length; i++) {
                total += records[i].theoryDuration;
            }
            if (total !== 0)
                totalDuration_NABOP[getIndexById_NABOP(records[0].needsAssessmentPriorityId)] = total;
            return "<spring:message code="duration.hour.sum"/>" + total;
        },
        function (records) {
            let passed = 0;
            for (let i = 0; i < records.length; i++) {
                if (records[i].status === passedStatusId_NABOP)
                    passed += records[i].theoryDuration;
            }
            if (passed !== 0)
                passedDuration_NABOP[getIndexById_NABOP(records[0].needsAssessmentPriorityId)] = passed;
            return "<spring:message code="duration.hour.sum.passed"/>" + passed;
        },
        function (records) {
            if (!records.isEmpty() && totalDuration_NABOP[getIndexById_NABOP(records[0].needsAssessmentPriorityId)] !== 0) {
                return "<spring:message code="duration.percent.passed"/>" +
                    Math.round(passedDuration_NABOP[getIndexById_NABOP(records[0].needsAssessmentPriorityId)] /
                        totalDuration_NABOP[getIndexById_NABOP(records[0].needsAssessmentPriorityId)] * 100);
            }
            return "<spring:message code="duration.percent.passed"/>" + 0;
        }
    ];

    let totalSummaryFunc_NABOP = [
        function (records) {
            let total = 0;
            for (let i = 0; i < records.length; i++) {
                total += records[i].theoryDuration;
            }
            if (total !== 0)
                totalDuration_NABOP[getIndexById_NABOP(records[0].needsAssessmentPriorityId)] = total;
            return "<spring:message code="duration.hour.sum"/>" + total;
        }
    ];

    CoursesLG_NABOP = isc.TrLG.create({
        gridComponents: [ReportTypeDF_NABOP, DynamicForm_Title_NABOP, "header", "filterEditor", "body"],
        dataSource: CourseDS_NABOP,
        contextMenu: Menu_Courses_NABOP,
        selectionType: "single",
        filterLocally: true,
        autoFetchData: false,
        alternateRecordStyles: true,
        showAllRecords: true,
        groupByField: "needsAssessmentPriorityId",
        groupStartOpen: "all",
        showGroupSummary: true,
        fields: [
            {name: "code"},
            {name: "titleFa"},
            {
                name: "theoryDuration",
                showGroupSummary: true,
                summaryFunction: fullSummaryFunc_NABOP
            },
            {
                name: "needsAssessmentPriorityId",
                hidden: true,
                type: "IntegerItem",
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: PriorityDS_NABOP,
                addUnknownValues: false,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
            {
                name: "status",
                type: "IntegerItem",
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: StatusDS_NABOP,
                addUnknownValues: false,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
        ],
    });

    ToolStripButton_Refresh_NABOP = isc.ToolStripButtonRefresh.create({
        click: function () {
            if (CourseDS_NABOP.fetchDataURL == null)
                return;
            refreshLG_NABOP(CourseDS_NABOP);
        }
    });
    ToolStripButton_Print_NABOP = isc.ToolStripButtonPrint.create({
        title: "<spring:message code='print'/>",
        click: function () {
            print_NABOP("pdf");
        }
    });

    ToolStrip_Actions_NABOP = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_Print_NABOP,
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_NABOP
                    ]
                })
            ]
    });

    Main_VLayout_NABOP = isc.TrVLayout.create({
        border: "2px solid blue",
        members: [ToolStrip_Actions_NABOP, CoursesLG_NABOP]
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

    function Select_Person_NABOP() {
        priorities_NABOP = PriorityDS_NABOP.getCacheData();
        if (PersonnelsLG_NABOP.getSelectedRecord() == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }
        for (let i = 0; i < 3; i++) {
            totalDuration_NABOP[i] = 0;
            passedDuration_NABOP[i] = 0;
        }
        if (PersonnelsLG_NABOP.getSelectedRecord().postCode !== undefined && reportType_NABOP === "0") {
            postCode_NABOP = PersonnelsLG_NABOP.getSelectedRecord().postCode.replace("/", ".");
            wait_NABOP = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(postUrl + "/" + postCode_NABOP, "GET", null, PostCodeSearch_result_NABOP));
        } else if (reportType_NABOP !== 0) {
            selectedPerson_NABOP = PersonnelsLG_NABOP.getSelectedRecord();
            setTitle_NABOP();
            Window_Personnel_NABOP.close();
        } else {
            postCode_NABOP = null;
            createDialog("info", "<spring:message code="personnel.without.postCode"/>");
        }
    }

    function PostCodeSearch_result_NABOP(resp) {
        wait_NABOP.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 200) {
            temp = resp;
            selectedPerson_NABOP = PersonnelsLG_NABOP.getSelectedRecord();
            setTitle_NABOP(JSON.parse(resp.httpResponseText).id);
            Window_Personnel_NABOP.close();
        } else if (resp.httpResponseCode === 404 && resp.httpResponseText === "PostNotFound") {
            createDialog("info", "<spring:message code='needsAssessmentReport.postCode.not.Found'/>");
        } else {
            createDialog("info", "<spring:message code="msg.operation.error"/>");
        }
    }

    function Select_Post_NABOP() {
        priorities_NABOP = PriorityDS_NABOP.getCacheData();
        if (PostsLG_NABOP.getSelectedRecord() == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }
        for (let i = 0; i < 3; i++) {
            totalDuration_NABOP[i] = 0;
            passedDuration_NABOP[i] = 0;
        }
        selectedPost_NABOP = PostsLG_NABOP.getSelectedRecord();
        setTitle_NABOP();
        Window_Post_NABOP.close();
    }

    function setTitle_NABOP(postId = null) {
        switch (reportType_NABOP) {
            case "0":
                ReportTypeDF_NABOP.getItem("showReport").enable();
                CourseDS_NABOP.fetchDataURL = needsAssessmentReportsUrl + "?postId=" + postId + "&personnelNo=" + selectedPerson_NABOP.personnelNo;
                DynamicForm_Title_NABOP.getItem("Title_NASB").title = "گزارش نیازسنجی خانم/آقای " +
                    getFormulaMessage(selectedPerson_NABOP.firstName, 2, "red", "b") + " " +
                    getFormulaMessage(selectedPerson_NABOP.lastName, 2, "red", "b");
                DynamicForm_Title_NABOP.getItem("Title_NASB").redraw();
                break;
            case "1":
                ReportTypeDF_NABOP.getItem("showReport").enable();
                CourseDS_NABOP.fetchDataURL = needsAssessmentReportsUrl + "?postId=" + selectedPost_NABOP.id;
                DynamicForm_Title_NABOP.getItem("Title_NASB").title = "گزارش نیازسنجی پست " +
                    getFormulaMessage(selectedPost_NABOP.titleFa, 2, "red", "b");
                DynamicForm_Title_NABOP.getItem("Title_NASB").redraw();
                break;
            case "2":
                if (selectedPerson_NABOP != null && selectedPost_NABOP != null) {
                    ReportTypeDF_NABOP.getItem("showReport").enable();
                    CourseDS_NABOP.fetchDataURL = needsAssessmentReportsUrl + "?postId=" + selectedPost_NABOP.id + "&personnelNo=" + selectedPerson_NABOP.personnelNo;
                }
                let personName = selectedPerson_NABOP != null ? getFormulaMessage(selectedPerson_NABOP.firstName, 2, "red", "b") + " " + getFormulaMessage(selectedPerson_NABOP.lastName, 2, "red", "b") : getFormulaMessage("...", 2, "red", "b");
                let postName = selectedPost_NABOP != null ? getFormulaMessage(selectedPost_NABOP.titleFa, 2, "red", "b") : getFormulaMessage("...", 2, "red", "b");
                DynamicForm_Title_NABOP.getItem("Title_NASB").title = "گزارش نیازسنجی ارتقاء خانم/آقای " + personName + " در پست " + postName;
                DynamicForm_Title_NABOP.getItem("Title_NASB").redraw();
        }
    }

    function print_NABOP(type) {
        if (selectedPerson_NABOP == null) {
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
            groupedRecords[getIndexById_NABOP(records[i].needsAssessmentPriorityId)].add({
                "id": records[i].id,
                "code": records[i].code,
                "titleFa": records[i].titleFa,
                "theoryDuration": records[i].theoryDuration,
                "needsAssessmentPriorityId": records[i].needsAssessmentPriorityId,
                "status": records[i].status
            });
        }
        let personnel = {
            "id": selectedPerson_NABOP.id,
            "firstName": selectedPerson_NABOP.firstName,
            "lastName": selectedPerson_NABOP.lastName,
            "nationalCode": selectedPerson_NABOP.nationalCode,
            "companyName": selectedPerson_NABOP.companyName,
            "personnelNo": selectedPerson_NABOP.personnelNo,
            "personnelNo2": selectedPerson_NABOP.personnelNo2,
        };
        let criteriaForm_course = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="web/personnel-needs-assessment-report-print/"/>" + type,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "essentialRecords", type: "hidden"},
                    {name: "improvingRecords", type: "hidden"},
                    {name: "developmentalRecords", type: "hidden"},
                    {name: "totalEssentialHours", type: "hidden"},
                    {name: "passedEssentialHours", type: "hidden"},
                    {name: "totalImprovingHours", type: "hidden"},
                    {name: "passedImprovingHours", type: "hidden"},
                    {name: "totalDevelopmentalHours", type: "hidden"},
                    {name: "passedDevelopmentalHours", type: "hidden"},
                    {name: "personnel", type: "hidden"},
                    {name: "myToken", type: "hidden"}
                ]
        });
        criteriaForm_course.setValue("essentialRecords", JSON.stringify(groupedRecords[getIndexByCode_NABOP("AZ")]));
        criteriaForm_course.setValue("improvingRecords", JSON.stringify(groupedRecords[getIndexByCode_NABOP("AB")]));
        criteriaForm_course.setValue("developmentalRecords", JSON.stringify(groupedRecords[getIndexByCode_NABOP("AT")]));
        criteriaForm_course.setValue("totalEssentialHours", JSON.stringify(totalDuration_NABOP[getIndexByCode_NABOP("AZ")]));
        criteriaForm_course.setValue("passedEssentialHours", JSON.stringify(passedDuration_NABOP[getIndexByCode_NABOP("AZ")]));
        criteriaForm_course.setValue("totalImprovingHours", JSON.stringify(totalDuration_NABOP[getIndexByCode_NABOP("AB")]));
        criteriaForm_course.setValue("passedImprovingHours", JSON.stringify(passedDuration_NABOP[getIndexByCode_NABOP("AB")]));
        criteriaForm_course.setValue("totalDevelopmentalHours", JSON.stringify(totalDuration_NABOP[getIndexByCode_NABOP("AT")]));
        criteriaForm_course.setValue("passedDevelopmentalHours", JSON.stringify(passedDuration_NABOP[getIndexByCode_NABOP("AT")]));
        criteriaForm_course.setValue("personnel", JSON.stringify(personnel));
        criteriaForm_course.setValue("myToken", "<%=accessToken%>");
        criteriaForm_course.show();
        criteriaForm_course.submitForm();
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

    //</script>