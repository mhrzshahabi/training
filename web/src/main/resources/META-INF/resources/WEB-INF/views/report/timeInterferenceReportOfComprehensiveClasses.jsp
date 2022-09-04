<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
// <script>




    var RestDataSource_TimeInterference = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true},
                {name: "studentFullName"},
                {name: "nationalCode"},
                {name: "studentWorkCode"},
                {name: "studentAffairs"},
                {name: "concurrentCourses"},
                {name: "dateAdded"},
                {name: "addingUser"},
                {name: "sessionDate"}
            ],

    });

    ListGrid_TimeInterference = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_TimeInterference,
        autoFetchData: true,
        sortDirection: "descending",
        initialSort: [
            {property: "id", direction: "descending"}
        ],
        // gridComponents: [timeInterference_actions],
        recordClick: function () {

        },
        fields: [
            {
                name: "id",
                hidden: true,
                primaryKey: true,
                canEdit: false,
                align: "center"
            },
            {
                name: "studentFullName",
                title: "نام و نام خانوادگی فراگیر",
                width: "10%",
                align: "center",
                filterOperator: "iContains"
            },
            {
                name: "nationalCode",
                title: "کد ملی فراگیر",
                width: "10%",
                align: "center",
                filterOperator: "iContains"
            },
            {
                name: "studentWorkCode",
                title: "کد کار فراگیر",
                width: "10%",
                align: "center",
                filterOperator: "iContains"
            },
            {
                name: "studentAffairs",
                title: "امور فراگیر",
                width: "10%",
                align: "center",
                filterOperator: "iContains"
            },
            {
                name: "concurrentCourses",
                title: "دوره های همزمان",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "dateAdded",
                title: "تاریخ اضافه شدن",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "addingUser",
                title: "کاربر اضافه کننده",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "sessionDate",
                title: "تاریخ جلسه",
                width: "10%",
                align: "center",
                canFilter: false
            }
         ],

    });

    timeInterference_actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        align: "left",
        members: [
            isc.ToolStripButtonExcel.create({

                click: function () {
                    makeExcelOutputOfTimeInterference();
                }

            })
        ]
    });

    ToolStripButton_Refresh_TimeInterference = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_TimeInterference.invalidateCache();
        }
    });

    ToolStrip_Actions_TimeInterference = isc.ToolStrip.create({
        width: "100%",
        border: '0px',
        membersMargin: 5,
        members: [
            timeInterference_actions,
            isc.ToolStrip.create({
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh_TimeInterference
                ]
            })
        ]
    });

    VLayout_Body_TimeInterference = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_TimeInterference,
            ListGrid_TimeInterference
        ]
    });

    VLayout_Body_TimeInterference_Jsp = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            VLayout_Body_TimeInterference,
            ]
    });
//--------------------------------------------functions ---------------------------------------------------------------------
    function makeExcelOutputOfTimeInterference() {
        if (ListGrid_TimeInterference_ReportOf_Comprehensive_Classes.getOriginalData().localData === undefined)
            createDialog("info", "ابتدا چاپ گزارش را انتخاب کنید");
        else
            ExportToFile.downloadExcelRestUrl(null,ListGrid_TimeInterference , timeInterferenceComprehensiveClassesReportUrl , 0, null, '',"گزارش تداخل زمانی کلاسهای فراگیر"  , mainCriteria, null);
    }

// </script>