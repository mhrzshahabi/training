<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    var postCode = null;
    var totalDuration = [0, 0, 0, 0];
    var passedDuration = [0, 0, 0, 0];
    var percentDuration = [0, 0, 0, 0];
    var passedStatusId = "216";
    var groupedRecords = [];

    var temp;

    //--------------------------------------------------------------------------------------------------------------------//
    //*personel form*/
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
        fetchDataURL: personnelUrl + "/iscList",
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
            {name: "id", hidden: true},
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
        selectionAppearance: "checkbox",
    });

    IButton_Personnel_Ok_NABOP = isc.IButtonSave.create({
        title: "انتخاب",
        click: function () {
            if (PersonnelsLG_NABOP.getSelectedRecord() == null) {
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            if (PersonnelsLG_NABOP.getSelectedRecord().postCode !== undefined) {
                postCode = PersonnelsLG_NABOP.getSelectedRecord().postCode.replace("/", ".");
                CourseDS_NABOP.fetchDataURL = needsAssessmentReportsUrl + "/courses-for-post/" + postCode;
                // CourseDS_NABOP.fetchData(null, setSummaries, null);
                // CoursesLG_NABOP.invalidateCache();
                refreshLG(CoursesLG_NABOP);
            } else {
                postCode = null;
                CourseDS_NABOP.fetchDataURL = null;
                CoursesLG_NABOP.setData([]);
                createDialog("info", "<spring:message code="personnel.without.postCode"/>");
                return;
            }
            groupedRecords = [];
            Window_Personnel_NABOP.close();
        }
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
                {name: "titleFa", title: "<spring:message code="title"/>"}
            ],
        fetchDataURL: enumUrl + "eNeedAssessmentPriority/spec-list"
    });

    StatusDS_NABOP = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
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
                name: "eneedAssessmentPriorityId",
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
        // fetchDataURL: needsAssessmentReportsUrl + "/courses-for-post/84031244.5",
    });

    Menu_Courses_NABOP = isc.Menu.create({
        data: [{
            title: "<spring:message code="refresh"/>", click: function () {
                if (postCode == null)
                    return;
                refreshLG(CoursesLG_NABOP);
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
        // autoFetchData: true,
        selectionType: "single",
        filterLocally: true,

        alternateRecordStyles: true,
        showAllRecords: true,
        groupByField: "eneedAssessmentPriorityId",
        groupStartOpen: "all",
        showGroupSummary: true,


        fields: [
            {name: "id", hidden: true},
            {name: "code"},
            {name: "titleFa"},
            {
                name: "theoryDuration",
                showGroupSummary: true,
                summaryFunction: [
                    function (records) {
                        let total = 0;
                        for (var i = 0; i < records.length; i++) {
                            var record = records[i];
                            total += record.theoryDuration;
                        }
                        totalDuration[record.eneedAssessmentPriorityId] = total;
                        return "<spring:message code="duration.hour.sum"/>" + total;
                    },
                    function (records) {
                        let passed = 0;
                        for (var i = 0; i < records.length; i++) {
                            var record = records[i];
                            if (record.status === passedStatusId)
                                passed += record.theoryDuration;
                        }
                        passedDuration[record.eneedAssessmentPriorityId] = passed;
                        return "<spring:message code="duration.hour.sum.passed"/>" + passed;
                    },
                    function (records) {
                        if (totalDuration[records[0].eneedAssessmentPriorityId] === 0)
                            percentDuration[records[0].eneedAssessmentPriorityId] = 0;
                        else
                            percentDuration[records[0].eneedAssessmentPriorityId] = Math.round(passedDuration[records[0].eneedAssessmentPriorityId] / totalDuration[records[0].eneedAssessmentPriorityId] * 100);
                        groupedRecords.addList(records);
                        return "<spring:message code="duration.percent.passed"/>" + percentDuration[records[0].eneedAssessmentPriorityId];
                    }
                ]
            },
            {
                name: "eneedAssessmentPriorityId",
                hidden: true,
                type: "IntegerItem",
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: PriorityDS_NABOP,
                addUnknownValues: false,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "titleFa", width: "30%"}
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
            if (postCode == null)
                return;
            refreshLG(CoursesLG_NABOP);
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
        members: [ToolStrip_Actions_NABOP, CoursesLG_NABOP]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function print_NABOP(type) {
        let selectedPerson = PersonnelsLG_NABOP.getSelectedRecord();
        if (selectedPerson == null) {
            createDialog("info", "<spring:message code="personnel.not.selected"/>");
            return;
        }
        let records = [];
        records [0] = [];
        records [1] = [];
        records [2] = [];
        records [3] = [];
        for (let i = 0; i < groupedRecords.length; i++) {
            records[groupedRecords[i].eneedAssessmentPriorityId].add({
                "id": groupedRecords[i].id,
                "code": groupedRecords[i].code,
                "titleFa": groupedRecords[i].titleFa,
                "theoryDuration": groupedRecords[i].theoryDuration,
                "eneedAssessmentPriorityId": groupedRecords[i].eneedAssessmentPriorityId,
                "status": groupedRecords[i].status
            });
        }
        let personnel = {
            "id": selectedPerson.id,
            "firstName": selectedPerson.firstName,
            "lastName": selectedPerson.lastName,
            "nationalCode": selectedPerson.nationalCode,
            "companyName": selectedPerson.companyName,
            "personnelNo": selectedPerson.personnelNo,
            "personnelNo2": selectedPerson.personnelNo2,
        };
        temp = records;
        var criteriaForm_course = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="web/personnel-needs-assessment-report-print/"/>" + type,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "essentialRecords", type: "hidden"},
                    {name: "improvingRecords", type: "hidden"},
                    {name: "developmentalRecords", type: "hidden"},
                    {name: "totalHours", type: "hidden"},
                    {name: "passedHours", type: "hidden"},
                    {name: "passedPercent", type: "hidden"},
                    {name: "personnel", type: "hidden"},
                    {name: "myToken", type: "hidden"}
                ]
        });
        criteriaForm_course.setValue("essentialRecords", JSON.stringify(records[1]));
        criteriaForm_course.setValue("improvingRecords", JSON.stringify(records[2]));
        criteriaForm_course.setValue("developmentalRecords", JSON.stringify(records[3]));
        criteriaForm_course.setValue("totalHours", JSON.stringify(totalDuration));
        criteriaForm_course.setValue("passedHours", JSON.stringify(passedDuration));
        criteriaForm_course.setValue("passedPercent", JSON.stringify(percentDuration));
        criteriaForm_course.setValue("personnel", JSON.stringify(personnel));
        criteriaForm_course.setValue("myToken", "<%=accessToken%>");
        criteriaForm_course.show();
        criteriaForm_course.submitForm();
    }

    // function setSummaries(resp) {
    //     if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
    //
    //     } else {
    //         let errors = JSON.parse(resp.httpResponseText).errors;
    //         let message = "";
    //         for (let i = 0; i < errors.length; i++) {
    //             message += errors[i].message + "<br/>";
    //         }
    //         createDialog("info", message);
    //     }
    // }

    //</script>