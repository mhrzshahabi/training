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
    });

    Menu_Courses_NABOP = isc.Menu.create({
        data: [{
            title: "<spring:message code="refresh"/>", click: function () {
                if (postCode_NABOP == null)
                    return;
                refreshLG_NABOP(CourseDS_NABOP);
            }
        }, {
            title: "<spring:message code="personnel.choose"/>",
            click: function () {
                PersonnelsLG_NABOP.fetchData();
                Window_Personnel_NABOP.show();
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

    CoursesLG_NABOP = isc.TrLG.create({
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
                summaryFunction: [
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
                ]
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

    DynamicForm_Title_NABOP = isc.DynamicForm.create({
        numCols: 1,
        fields: [
            {
                name: "Title_NASB",
                type: "staticText",
                title: "",
                titleAlign: "center",
                wrapTitle: false
            }
        ]
    });

    ToolStripButton_Refresh_NABOP = isc.ToolStripButtonRefresh.create({
        click: function () {
            if (postCode_NABOP == null)
                return;
            refreshLG_NABOP(CourseDS_NABOP);
        }
    });
    ToolStripButton_ShowPersonnel_NABOP = isc.ToolStripButton.create({
        title: "<spring:message code="personnel.choose"/>",
        click: function () {
            PersonnelsLG_NABOP.fetchData();
            Window_Personnel_NABOP.show();
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
                ToolStripButton_ShowPersonnel_NABOP,
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
        members: [ToolStrip_Actions_NABOP, DynamicForm_Title_NABOP, CoursesLG_NABOP]
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

    function PostCodeSearch_result_NABOP(resp) {
        wait_NABOP.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 200) {
            selectedPerson_NABOP = PersonnelsLG_NABOP.getSelectedRecord();
            CourseDS_NABOP.fetchDataURL = needsAssessmentReportsUrl + "/courses-for-post/" + postCode_NABOP;
            refreshLG_NABOP(CourseDS_NABOP);
            DynamicForm_Title_NABOP.getItem("Title_NASB").title =
                getFormulaMessage(selectedPerson_NABOP.firstName, 2, "red", "b") + " " +
                getFormulaMessage(selectedPerson_NABOP.lastName, 2, "red", "b");
            DynamicForm_Title_NABOP.getItem("Title_NASB").redraw();
            Window_Personnel_NABOP.close();
        } else if (resp.httpResponseCode === 404 && resp.httpResponseText === "PostNotFound") {
            createDialog("info", "<spring:message code='needsAssessmentReport.postCode.not.Found'/>");
        } else {
            createDialog("info", "<spring:message code="msg.operation.error"/>");
        }
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
        if (PersonnelsLG_NABOP.getSelectedRecord().postCode !== undefined) {
            postCode_NABOP = PersonnelsLG_NABOP.getSelectedRecord().postCode.replace("/", ".");
            wait_NABOP = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(postUrl + "/" + postCode_NABOP, "GET", null, PostCodeSearch_result_NABOP));
        } else {
            postCode_NABOP = null;
            createDialog("info", "<spring:message code="personnel.without.postCode"/>");
        }
    }

    function print_NABOP(type) {
        if (selectedPerson_NABOP == null) {
            createDialog("info", "<spring:message code="personnel.not.selected"/>");
            return;
        }
        let records = CourseDS_NABOP.getCacheData();
        if (records === undefined){
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