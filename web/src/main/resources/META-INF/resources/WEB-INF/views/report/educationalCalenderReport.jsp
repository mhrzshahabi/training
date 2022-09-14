<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%
%>
// <script>
    let mainCriteria = {};
    //----------------------------------------------------Variables-----------------------------------------------------


    //----------------------------------------------------Default Rest--------------------------------------------------


    //----------------------------------------------------Rest DataSource-----------------------------------------------
    var RestDataSource_educationalCalenderReport = isc.TrDS.create({

        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"}



        ],
        fetchDataURL: educationalCalenderUrl + "spec-list",
        autoFetchData: true,
    });
    var RestDataSource_JspCalenderBasicGoals = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true},
                {name: "mainGoal"},
                {name: "classCode"},
                {name: "calenderId"}
            ],

    });


    var RestDataSource_JspCalenderPrerequisite = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true},
                {name: "prerequisite"},
                {name: "classCode"},
                {name: "calenderId"}
            ],

    });
    var RestDataSource_JspCalenderHeadlines = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true},
                {name: "headline"},
                {name: "classCode"},
                {name: "calenderId"}
            ],

    });

    var RestDataSource_JspCalenderSessions = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true},
                {name: "sessionDay"},
                {name: "sessionDate"},
                {name : "sessionStartHour"},
                {name : "sessionEndHour"},
                {name: "calenderId"},
                {name: "classCode"},
            ],


    });

    var RestDataSource_JspCalenderCourses = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true},
                {name: "calenderId"},
                {name: "codeDoreh"},
                {name: "mahalBarghozari"},
                {name: "nomreh"},
                {name: "hazinehDore"},
                {name: "nahveBargozari"},
                {name: "sharayetSherkatKonandeghan"},
                {name: "tarikhBargozari"},
                {name: "modatDore"},
            ],

    });
    //----------------------------------------------------Criteria Form------------------------------------------------


    DynamicForm_Calender_Report= isc.DynamicForm.create({
        width: "600",
        height: 10,
        numCols: 6,
        colWidths: ["2%", "28%", "2%", "68%"],
        fields: [
            {
                name: "calenderFilter",
                title: "<spring:message code='calender'/>",
                width: "300",
                height: 30,
                optionDataSource: RestDataSource_educationalCalenderReport,
                autoFetchData: false,
                displayField: "titleFa",
                valueField: "id",
                // valueField: "title",
                textAlign: "center",
                icons: [
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click: function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();
                        }
                    }
                ],
                pickListFields: [
                    {
                        name: "titleFa",
                        title: "<spring:message code="title"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    }
                ],
                changed: function (form, item, value) {
                    load_details_by_calender(value);

                },
            },
        ]
    });




    basicGoals_actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
          isc.ToolStripButtonExcel.create({

                    click: function () {
                        makeExcelOutputOfMainGoals();
                    }

            })
        ]
    });
    prerequauires_actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({

                click: function () {
                    makeExcelOutputOfPrerequisite();
                }

            })
        ]
    });
    headlines_actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({

                click: function () {
                    makeExcelOutputHeadlines();
                }

            })
        ]
    });
    sessions_actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({

                click: function () {
                    makeExcelOutputSessions();
                }

            })
        ]
    });
    courses_actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({

                click: function () {
                     makeExcelOutputOfCourses();
                }

            })
        ]
    });

    ListGrid_Calender_BasicGoals = isc.ListGrid.create({
        dataSource: RestDataSource_JspCalenderBasicGoals,
        // contextMenu: Menu_JspOperationalChart,
        sortField: 0,
        sortDirection: "descending",
        dataPageSize: 200,
        autoFetchData: false,
        showFilterEditor: true,
        filterOnKeypress: true,
        canAutoFitFields: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        align: "center",
        fields: [
            {
                name: "mainGoal",
                title: "هدف اصلی",
                filterOperator: "iContains"
            },
            {
                name: "classCode",
                title: "کد کلاس",
                filterOperator: "iContains"
            }

        ],
        gridComponents: [basicGoals_actions, "filterEditor", "header", "body", "summaryRow"],

        filterEditorSubmit: function () {
           ListGrid_Calender_BasicGoals.invalidateCache();
        },

        filterEditorSubmit: function () {
            debugger
            ListGrid_Calender_BasicGoals.invalidateCache();
        }



    });
    ListGrid_Calender_Prerequaires = isc.ListGrid.create({
        dataSource: RestDataSource_JspCalenderPrerequisite,
        sortField: 0,
        sortDirection: "descending",
        dataPageSize: 200,
        autoFetchData: false,
        showFilterEditor: true,
        filterOnKeypress: true,
        canAutoFitFields: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        align: "center",
        fields: [
            {
                name: "prerequisite",
                title: "پیشنیازها",
                filterOperator: "iContains",
                showHover : true
            },
            {
                name: "classCode",
                title: "کد کلاس",
                filterOperator: "iContains"
            }

        ],
        gridComponents: [prerequauires_actions, "filterEditor", "header", "body", "summaryRow"],

        filterEditorSubmit: function () {
            ListGrid_Calender_Prerequaires.invalidateCache();
        }



    });
    ListGrid_Calender_Headlines = isc.ListGrid.create({
        dataSource: RestDataSource_JspCalenderHeadlines,
        sortField: 0,
        sortDirection: "descending",
        dataPageSize: 200,
        autoFetchData: false,
        showFilterEditor: true,
        filterOnKeypress: true,
        canAutoFitFields: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        align: "center",
        fields: [
            {
                name: "headline",
                title: "سرفصل ها",
                filterOperator: "iContains",
                showHover : true
            },
            {
                name: "classCode",
                title: "کد کلاس",
                filterOperator: "iContains"
            }

        ],
        gridComponents: [headlines_actions, "filterEditor", "header", "body", "summaryRow"],

        filterEditorSubmit: function () {
            ListGrid_Calender_Headlines.invalidateCache();
        }



    });
    ListGrid_Calender_Sessions = isc.ListGrid.create({
        dataSource: RestDataSource_JspCalenderSessions,
        sortField: 0,
        sortDirection: "descending",
        dataPageSize: 200,
        autoFetchData: false,
        showFilterEditor: true,
        filterOnKeypress: true,
        canAutoFitFields: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        align: "center",
        initialSort: [
            {property: "sessionDate", direction: "descending", primarySort: true}
        ],
        fields: [
            {
                name: "sessionDate",
                title: "تاریخ جلسه",
                filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                },
            },
            {
                name: "sessionDay",
                title: "روز جلسه",
                filterOperator: "iContains"
            },
            {
                name: "sessionStartHour",
                title: "ساعت شروع",
                filterOperator: "iContains"
            },
            {
                name: "sessionEndHour",
                title: "ساعت پایان",
                filterOperator: "iContains"
            },
            {
                name: "classCode",
                title: " کد کلاس",
                filterOperator: "iContains"
            },


        ],
        gridComponents: [sessions_actions, "filterEditor", "header", "body", "summaryRow"],

        filterEditorSubmit: function () {
            ListGrid_Calender_Sessions.invalidateCache();
        }


    });
    ListGrid_Calender_Courses = isc.ListGrid.create({
        dataSource: RestDataSource_JspCalenderCourses,
        sortField: 0,
        sortDirection: "descending",
        dataPageSize: 200,
        autoFetchData: false,
        showFilterEditor: true,
        filterOnKeypress: true,
        canAutoFitFields: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        align: "center",
        fields: [
            {
                name: "codeDoreh",
                title: "کد دوره",
                filterOperator: "iContains"
            },
            {
                name: "mahalBarghozari",
                title: "محل برگزاری",
                filterOperator: "iContains"
            },
            {
                name: "nomreh",
                title: "نمره",
                filterOperator: "iContains"
            },
            {
                name: "hazinehDore",
                title: "هزینه دوره",
                filterOperator: "iContains"
            },
            {
                name: "nahveBargozari",
                title: "نحوه برگزاری",
                filterOperator: "iContains"
            },
            {
                name: "sharayetSherkatKonandeghan",
                title: "شرایط شرکت کنندگان",
                filterOperator: "iContains"
            },
            {
                name: "tarikhBargozari",
                title: "تاریخ برگزاری",
                filterOperator: "iContains"
            },
            {
                name: "modatDore",
                title: "مدت دوره",
                filterOperator: "iContains"
            }

        ],
        gridComponents: [courses_actions, "filterEditor", "header", "body", "summaryRow"],

        filterEditorSubmit: function () {
            ListGrid_Calender_Courses.invalidateCache();
        },

        filterEditorSubmit: function () {
            ListGrid_Calender_Courses.invalidateCache();
        }



    });

    //----------------------------------------------------Actions --------------------------------------------------


    //////////////////// tab ////////////////////////////////////////////


    EducationalCalenderReport_Tabs = isc.TabSet.create({
        height : "100%",
        tabBarPosition: "top",
        tabs: [
            {name: "TabPane_BasicGoals", title: "اهداف اصلی", pane: ListGrid_Calender_BasicGoals},
            {name: "TabPane_prerequires", title: "پیشنیازها", pane: ListGrid_Calender_Prerequaires},
            {name: "TabPane_Headlines", title: "سرفصل ها", pane: ListGrid_Calender_Headlines},
            {name: "TabPane_sessions", title: "جلسات", pane: ListGrid_Calender_Sessions},
            {name: "TabPane_courses", title: "دوره ها", pane: ListGrid_Calender_Courses},

        ],
        tabSelected: function () {
            selectionUpdatedCalender_Tabs();
        }
    });



    //----------------------------------- layOut -----------------------------------------------------------------------


    let ToolStrip_Actions_calenderFilter = isc.ToolStrip.create({
        width: "100%",
        align : "right",
        membersMargin: 5,
        members:
            [

                DynamicForm_Calender_Report

            ]
    });
    VLayout_Body_Calender = isc.TrVLayout.create({
        height : "10%",
        members: [
            // ToolStrip_Actions_Decision,
           ToolStrip_Actions_calenderFilter
        ]
    });

    HLayout_Tabs_Calender = isc.HLayout.create({
        minWidth: "100%",
        width: "100%",
        height: "90%",
        members: [EducationalCalenderReport_Tabs]
    });

    VLayout_Body_Decision_Jsp = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            VLayout_Body_Calender,
            HLayout_Tabs_Calender
        ]
    });


    //------------------------------------------------- Functions ------------------------------------------------------

    function selectionUpdatedCalender_Tabs() {

        let record =  DynamicForm_Calender_Report.getField("calenderFilter").getValue();
        let tab = EducationalCalenderReport_Tabs.getSelectedTab();

        if (record == null && tab.pane != null) {
            tab.pane.setData([]);
            return;
        }

    }
    function makeExcelOutputOfMainGoals() {
        if (ListGrid_Calender_BasicGoals.getOriginalData().localData === undefined)
            createDialog("info", "ابتدا چاپ گزارش را انتخاب کنید");
        else
            ExportToFile.downloadExcelRestUrl(null,ListGrid_Calender_BasicGoals, educationalCalenderReportUrl + "/mainGoals/iscList", 0, null, '',"گزارش اهداف اصلی تقویم"  , mainCriteria, null);
    }
    function makeExcelOutputOfPrerequisite() {
        if (ListGrid_Calender_Prerequaires.getOriginalData().localData === undefined)
            createDialog("info", "ابتدا چاپ گزارش را انتخاب کنید");
        else
            ExportToFile.downloadExcelRestUrl(null,ListGrid_Calender_Prerequaires, educationalCalenderReportUrl +   "/prerequisite/iscList", 0, null, '',"گزارش پیشنیازهای تقویم"  , mainCriteria, null);
    }

    function makeExcelOutputHeadlines() {
        if (ListGrid_Calender_Headlines.getOriginalData().localData === undefined)
            createDialog("info", "ابتدا چاپ گزارش را انتخاب کنید");
        else
            ExportToFile.downloadExcelRestUrl(null,ListGrid_Calender_Headlines, educationalCalenderReportUrl + "/headlines/iscList", 0, null, '',"گزارش سرفصلهای تقویم"  , mainCriteria, null);
    }

    function makeExcelOutputSessions() {
        if (ListGrid_Calender_BasicGoals.getOriginalData().localData === undefined)
            createDialog("info", "ابتدا چاپ گزارش را انتخاب کنید");
        else
            ExportToFile.downloadExcelRestUrl(null,ListGrid_Calender_Sessions, educationalCalenderReportUrl + "/sessions/iscList", 0, null, '',"گزارش جلسات تقویم"  , mainCriteria, null);
    }
    function makeExcelOutputOfCourses() {
        if (ListGrid_Calender_Courses.getOriginalData().localData === undefined)
            createDialog("info", "ابتدا چاپ گزارش را انتخاب کنید");
        else
            ExportToFile.downloadExcelRestUrl(null,ListGrid_Calender_Courses, educationalCalenderReportUrl + "/courses/iscList", 0, null, '',"گزارش اهداف اصلی تقویم"  , mainCriteria, null);
    }
    function createMainCriteriaInCalender(value) {
        let mainCriteria = {};
        mainCriteria._constructor = "AdvancedCriteria";
        mainCriteria.operator = "and";
        mainCriteria.criteria =
            [
                {
                    fieldName: "calenderId", operator: "inSet", value: value
                }
            ];

        return mainCriteria;
    }

    function load_details_by_calender(value) {
        if (value !== undefined) {
            RestDataSource_JspCalenderBasicGoals.fetchDataURL = educationalCalenderReportUrl + "/mainGoals/iscList";
            RestDataSource_JspCalenderPrerequisite.fetchDataURL=   educationalCalenderReportUrl +   "/prerequisite/iscList";
            RestDataSource_JspCalenderHeadlines.fetchDataURL=educationalCalenderReportUrl + "/headlines/iscList";
            RestDataSource_JspCalenderSessions.fetchDataURL= educationalCalenderReportUrl +"/sessions/iscList";
            RestDataSource_JspCalenderCourses.fetchDataURL= educationalCalenderReportUrl +"/courses/iscList";
            let mainCriteria = createMainCriteriaInCalender(value);
            ListGrid_Calender_BasicGoals.invalidateCache();
            ListGrid_Calender_BasicGoals.fetchData(mainCriteria);
            ListGrid_Calender_Prerequaires.invalidateCache();
            ListGrid_Calender_Prerequaires.fetchData(mainCriteria);
            ListGrid_Calender_Headlines.invalidateCache();
            ListGrid_Calender_Headlines.fetchData(mainCriteria);
            ListGrid_Calender_Sessions.invalidateCache();
            ListGrid_Calender_Sessions.fetchData(mainCriteria);
            ListGrid_Calender_Courses.invalidateCache();
            ListGrid_Calender_Courses.fetchData(mainCriteria);

        } else {
            createDialog("info", "<spring:message code="msg.select.calender.ask"/>", "<spring:message code="message"/>")
        }

    }

    // </script>