<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
// <script>


    // timeInterference_actions = isc.ToolStrip.create({
    //     width: "100%",
    //     membersMargin: 5,
    //     members: [
    //         isc.ToolStripButtonExcel.create({
    //
    //             click: function () {
    //                 makeExcelOutputOfTimeInterference();
    //             }
    //
    //         })
    //     ]
    // });

    var RestDataSource_TimeInterference_ReportOf_Comprehensive_Classes = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true},
                {name: "studentName"},
                {name: "studentFamily"},
                {name: "nationalCode"},
                {name: "classCode"},
                {name: "sessionDay"},
                {name: "sessionHour"}
            ],

    });

    ListGrid_TimeInterference_ReportOf_Comprehensive_Classes = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_TimeInterference_ReportOf_Comprehensive_Classes,
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
                name: "studentName",
                title: "نام فراگیر",
                width: "10%",
                align: "center",
                filterOperator: "iContains"
            },
            {
                name: "studentFamily",
                title: "نام خانوادگی فراگیر",
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
                name: "classCode",
                title: "کد کلاس",
                width: "10%",
                align: "center",
                filterOperator: "iContains"
            },
            {
                name: "sessionDay",
                title: "روز جلسه",
                width: "10%",
                align: "center",
                canFilter: false
            },
            {
                name: "sessionHour",
                title: "ساعت جلسه",
                width: "10%",
                align: "center",
                canFilter: false
            }
         ],

    });



    function makeExcelOutputOfTimeInterference() {
        if (ListGrid_TimeInterference_ReportOf_Comprehensive_Classes.getOriginalData().localData === undefined)
            createDialog("info", "ابتدا چاپ گزارش را انتخاب کنید");
        else
            ExportToFile.downloadExcelRestUrl(null,ListGrid_TimeInterference_ReportOf_Comprehensive_Classes, timeInterferenceComprehensiveClassesReportUrl , 0, null, '',"گزارش تداخل زمانی کلاسهای فراگیر"  , mainCriteria, null);
    }

// </script>