<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
// <script>



//-----------------------------------------------------------------------------------------------------------------------

var DynamicForm_TimeInterference = isc.DynamicForm.create({
    numCols: 8,
    padding: 10,
    titleAlign: "left",
    colWidths: [70, 200, 70, 200,70,200, 100, 100],
    fields: [
        {
            name: "startDate",
            titleColSpan: 1,
            title: "<spring:message code='start.date'/>",
            ID: "startDate_jspTimeInterference",
            required: true,
            hint: "--/--/----",
            keyPressFilter: "[0-9/]",
            showHintInField: true,
            icons: [{
                src: "<spring:url value="calendar.png"/>",
                click: function (form) {
                    closeCalendarWindow();
                    displayDatePicker('startDate_jspTimeInterference', this, 'ymd', '/');
                }
            }],
            textAlign: "center",
            changed: function (form, item, value) {
                var dateCheck;
                dateCheck = checkDate(value);
                if (dateCheck === false) {
                    form.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                } else {
                    form.clearFieldErrors("startDate", true);
                }
            }
        },
        {
            name: "endDate",
            titleColSpan: 1,
            title: "<spring:message code='end.date'/>",
            ID: "endDate_jspTimeInterference",
            type: 'text', required: true,
            hint: "--/--/----",
            keyPressFilter: "[0-9/]",
            showHintInField: true,
            icons: [{
                src: "<spring:url value="calendar.png"/>",
                click: function (form) {
                    closeCalendarWindow();
                    displayDatePicker('endDate_jspTimeInterference', this, 'ymd', '/');
                }
            }],
            textAlign: "center",
            // colSpan: 2,
            changed: function (form, item, value) {
                let dateCheck;
                dateCheck = checkDate(value);
                if (dateCheck === false) {
                    form.clearFieldErrors("endDate", true);
                    form.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                } else {
                    form.clearFieldErrors("endDate", true);
                }
            }
        },
        {
            name: "runReportBtn",
            ID: "searchBtnJspTimeInterference",
            title: "تهیه گزارش",
            type: "ButtonItem",
            width: "150",
            startRow: false,
            endRow: false,
            click(form) {
                form.validate();
                if (form.hasErrors()) {
                    return
                }
                var timeInterference_Report_wait = createDialog("wait");
                setTimeout(function () {
                    let url = timeInterferenceComprehensiveClassesReportUrl + form.getValue("startDate") + "&endDate=" + form.getValue("endDate");

                    RestDataSource_TimeInterference.fetchDataURL = url;

                    ListGrid_TimeInterference.invalidateCache();
                    ListGrid_TimeInterference.fetchData();
                    timeInterference_Report_wait.close();

                }, 100);
            }
        },
        {
            name: "clearBtn",
            title: "<spring:message code="clear"/>",
            type: "ButtonItem",
            width: "150",
            startRow: false,
            endRow: false,
            click(form, item) {
                form.clearValues();
                form.clearErrors();
                ListGrid_TimeInterference.setData([]);
            }
        },
    ],

});
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
        gridComponents: [DynamicForm_TimeInterference,
        //     isc.ToolStripButtonExcel.create({
        //         margin:5,
        //         align: "left",
        //         click:function() {
        //             let title="گزارش تداخل زمانی کلاسهای فراگیر "+DynamicForm_TimeInterference.getItem("startDate").getValue()+ " الی "+DynamicForm_TimeInterference.getItem("endDate").getValue();
        //             ExportToFile.downloadExcel(null, ListGrid_TimeInterference , 'TimeInterferenceReport', 0, null, '',title  , DynamicForm_TimeInterference.getValuesAsAdvancedCriteria(), null,2);
        //         }
        //     })
        //     ,isc.ToolStripButtonRefresh.create({
        //         align: "left",
        //         click: function () {
        //             ListGrid_TimeInterference.invalidateCache();
        //         }
        //     })
            , "header", "filterEditor", "body"],
        autoFetchData: true,
        showFilterEditor:true,
        sortDirection: "descending",
        initialSort: [
            {property: "id", direction: "descending"}
        ],
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
//----------------------------------------------------------------------------------------------------------------
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
//----------------------------------------------------------------------------------
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
        if (ListGrid_TimeInterference.getOriginalData().localData === undefined)
            createDialog("info", "ابتدا چاپ گزارش را انتخاب کنید");
        else
            // let title="گزارش تداخل زمانی کلاسهای فراگیر "+DynamicForm_TimeInterference.getItem("startDate").getValue()+ " الی "+DynamicForm_TimeInterference.getItem("endDate").getValue();
            // ExportToFile.downloadExcelRestUrl(null,ListGrid_TimeInterference , timeInterferenceComprehensiveClassesReportUrl , 0, null, '',title  , mainCriteria, null);
            ExportToFile.downloadExcelRestUrl(null,ListGrid_TimeInterference , timeInterferenceComprehensiveClassesReportUrl , 0, null, '',"گزارش تداخل زمانی کلاسهای فراگیر"  , mainCriteria, null);
    }

// </script>