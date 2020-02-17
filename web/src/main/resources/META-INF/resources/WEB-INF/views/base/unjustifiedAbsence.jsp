<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
// <script>

    var DynamicForm_Report = isc.DynamicForm.create({
        colWidths: ["50", "210", "50", "230", "150"],
        numCols: 5,
        fields: [
            {

                name: "startDate",
                height: 35,
                title: "از تاریخ",
                ID: "startDate_jspTerm",
                type: 'text',
                width: 200,
                required: true,
                hint: "YYYY/MM/DD",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                focus: function () {
                    displayDatePicker('startDate_jspTerm', this, 'ymd', '/');
                },
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate_jspTerm', this, 'ymd', '/');
                    }
                }],

                changed: function (form, item, value) {
                    var startdate = DynamicForm_Report.getItem("startDate").getValue();
                    if (startdate != null) {
                        if (term_method == "POST")
                            getTermCodeRequest(startdate.substr(0, 4));
                    } else

                        simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.start.date.not.entered"/>", 3000, "say");
                },
                blur: function () {
                    var dateCheck = false;
                    dateCheck = checkDate(DynamicForm_Report.getValue("startDate"));
                    startDateCheckTerm = dateCheck;
                    if (dateCheck == false)
                        DynamicForm_Report.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                    if (dateCheck == true)
                        DynamicForm_Report.clearFieldErrors("startDate", true);

                    var endDate = DynamicForm_Report.getValue("endDate");
                    var startDate = DynamicForm_Report.getValue("startDate");
                    if (endDate != undefined && startDate > endDate) {
// DynamicForm_Report.clearFieldErrors("endDate", true);
                        DynamicForm_Report.addFieldErrors("endDate", "<spring:message code='msg.date.order'/>", true);
                        DynamicForm_Report.getItem("endDate").setValue();
                        endDateCheckTerm = false;
                    }
                }
            },
            {
                name: "endDate",
                height: 35,
                title: "تا تاریخ",
                ID: "endDate_jspTerm",
                width: 200,
                type: 'text',
                enabled: false,
                required: true,
                hint: "YYYY/MM/DD",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                focus: function () {
                    displayDatePicker('endDate_jspTerm', this, 'ymd', '/');
                },
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('endDate_jspTerm', this, 'ymd', '/');

                    }
                }],
                blur: function () {
                    var dateCheck = false;
                    dateCheck = checkDate(DynamicForm_Report.getValue("endDate"));
                    var endDate = DynamicForm_Report.getValue("endDate");
                    var startDate = DynamicForm_Report.getValue("startDate");
                    if (dateCheck == false) {
                        DynamicForm_Report.clearFieldErrors("endDate", true);
                        DynamicForm_Report.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                        endDateCheckTerm = false;
                    }
                    if (dateCheck == true) {
                        if (startDate == undefined)
                            DynamicForm_Report.clearFieldErrors("endDate", true);
                        if (startDate != undefined && startDate > endDate) {
                            DynamicForm_Report.clearFieldErrors("endDate", true);
                            DynamicForm_Report.addFieldErrors("endDate", "<spring:message code='msg.date.order'/>", true);
                            endDateCheckTerm = false;
                        }
                        if (startDate != undefined && startDate < endDate) {
                            DynamicForm_Report.clearFieldErrors("endDate", true);
                            endDateCheckTerm = true;
                        }
                    }
                }

            },
            {
                 type: "button",
                 title: "کلیک",
                 height:"30",
                 startRow: false,
                 width:"*",
                click:function () {
                    var strSData=DynamicForm_Report.getItem("startDate").getValue().replace(/(\/)/g, "");
                    var strEData = DynamicForm_Report.getItem("endDate").getValue().replace(/(\/)/g, "");
                   Print(strSData,strEData)
                }
            }
        ]
    })

    var Hlayout_Reaport_body = isc.HLayout.create({
        members: [DynamicForm_Report]
    })

    var Vlayout_Report_body = isc.VLayout.create({
        members: [Hlayout_Reaport_body]
    })

    function Print(startDate,endDate) {
            var criteriaForm = isc.DynamicForm.create({
                method: "POST",
                action: "<spring:url value="/unjustified/unjustifiedabsence"/>" +"/"+startDate + "/" + endDate,
                target: "_Blank",
                canSubmit: true,
                fields:
                    [
                       {name: "token", type: "hidden"}
                    ]
            })
            criteriaForm.setValue("token", "<%= accessToken %>")
        criteriaForm.show();
        criteriaForm.submitForm();
        }
