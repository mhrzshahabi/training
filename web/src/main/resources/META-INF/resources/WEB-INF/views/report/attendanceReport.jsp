<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    RestDataSource_Class_JspAttendanceReport = isc.TrDS.create({
        fields: [
            {name: "personalNum"},
            {name: "personalNum2"},
            {name: "nationalCode"},
            {name: "name"},
            {name: "ccpArea"},
            {name: "ccpAffairs"},
            {name: "peopleType"},
            {name: "classCode"},
            {name: "className"},
            {name: "attendanceStatus"},
            {name: "date"},
            {name: "fixTime"},
        ]
    });

    var DynamicForm_AttendanceReport = isc.DynamicForm.create({
        numCols: 8,
        padding: 10,
        titleAlign: "left",
        colWidths: [70, 200, 70, 200,70,200, 100, 100],
        fields: [
            {
                name: "startDate",
                titleColSpan: 1,
                title: "<spring:message code='start.date'/>",
                ID: "startDate_jspAttendanceReport",
                required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate_jspAttendanceReport', this, 'ymd', '/');
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
                ID: "endDate_jspAttendanceReport",
                type: 'text', required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate_jspAttendanceReport', this, 'ymd', '/');
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
                name: "absentType",
                title:"نوع غيبت",
                width: 150,
                defaultValue:5,
                textAlign: "center",
                valueMap:{
                    "3": "غيرموجه",
                    "4": "موجه",
                    "5": "موجه و غیر موجه"
                }
            },
            {
                name: "searchBtn",
                ID: "searchBtnJspAttendanceReport",
                title: "<spring:message code="search"/>",
                type: "ButtonItem",
                width: "*",
                startRow: false,
                endRow: false,
                click(form) {
                    form.validate();
                    if (form.hasErrors()) {
                        return
                    }
                    var attendance_Report_wait = createDialog("wait");
                    setTimeout(function () {
                        let url = attendanceReportUrl + "/list?startDate=" + form.getValue("startDate") + "&endDate=" + form.getValue("endDate")+ "&absentType=" + form.getValue("absentType");

                        RestDataSource_Class_JspAttendanceReport.fetchDataURL = url;

                        ListGrid_AttendanceReport_AttendanceReportJSP.invalidateCache();
                        ListGrid_AttendanceReport_AttendanceReportJSP.fetchData();
                        attendance_Report_wait.close();

                    }, 100);
                }
            },
            {
                name: "clearBtn",
                title: "<spring:message code="clear"/>",
                type: "ButtonItem",
                width: "*",
                startRow: false,
                endRow: false,
                click(form, item) {
                    form.clearValues();
                    form.clearErrors();
                    ListGrid_AttendanceReport_AttendanceReportJSP.setData([]);
                }
            },
        ],
        itemKeyPress: function (item, keyName) {
            if (keyName == "Enter") {
                searchBtnJspAttendanceReport.click(DynamicForm_AttendanceReport);
            }
        }
    });
    var ListGrid_AttendanceReport_AttendanceReportJSP = isc.TrLG.create({
        ID: "AttendanceReportGrid",
        //dynamicTitle: true,
        filterOnKeypress: false,
        showFilterEditor:true,
        gridComponents: [DynamicForm_AttendanceReport,
            isc.ToolStripButtonExcel.create({
                margin:5,
                click:function() {
                    let title="گزارش غیبت ها از تاریخ "+DynamicForm_AttendanceReport.getItem("startDate").getValue()+ " الی "+DynamicForm_AttendanceReport.getItem("endDate").getValue();
                    ExportToFile.showDialog(null, ListGrid_AttendanceReport_AttendanceReportJSP , 'attendanceReport', 0, null, '',title  , DynamicForm_AttendanceReport.getValuesAsAdvancedCriteria(), null);
                   //ExportToFile.downloadExcelFromClient(ListGrid_AttendanceReport_AttendanceReportJSP, null, '', title)
                }
            })
            , "header", "filterEditor", "body"],
        dataSource: RestDataSource_Class_JspAttendanceReport,

        fields: [
            {name: "personalNum", title: "<spring:message code='personnel.no'/>",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "personalNum2", title: "<spring:message code='personnel.no.6.digits'/>", autoFitWidth:true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "nationalCode", title: "<spring:message code='national.code'/>",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "name", title: "<spring:message code='student'/>",},
            {name: "peopleType", title: "نوع فراگیر",valueMap:
                    {
                        "personnel_registered": "متفرقه",
                        "Personal": "شرکتی",
                        "ContractorPersonal": "پیمانکار"
                    }},
            {name: "ccpArea", title: "<spring:message code='area'/>"},
            {name: "ccpAffairs", title: "<spring:message code='affairs'/>"},
            {name: "classCode", title: "<spring:message code="class.code"/>"},
            {name: "className", title: "<spring:message code="class.title"/>"},
            {name: "attendanceStatus", title: "<spring:message code="absent.type"/>",
             valueMap:
                    {
                        "3": "غیر موجه",
                        "4": "موجه"
                    }
            },
            {name: "date", title: "<spring:message code="date"/>",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {
                name: "time",
                title: "<spring:message code="time.hour"/>",
                includeInRecordSummary:false,
            },
        ]
    });
    var VLayout_Body_Training_OverTime = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            ListGrid_AttendanceReport_AttendanceReportJSP
        ]
    });
    //</script>