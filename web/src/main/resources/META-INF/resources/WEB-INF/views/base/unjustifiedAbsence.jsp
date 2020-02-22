<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
// <script>

    var endDateCheckReport = true;
    var DynamicForm_Report = isc.DynamicForm.create({
       numCols: 9,
        colWidths: ["5%","10%","5%","10%","10%","20%"],
        fields: [
            {

                name: "startDate",
                height: 35,
                titleAlign:"left",
                title: "از تاریخ",
                ID: "startDate_jspReport",
                type: 'text',
                required: true,
                hint: "YYYY/MM/DD",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                focus: function () {
                    displayDatePicker('startDate_jspReport', this, 'ymd', '/');
                },
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate_jspReport', this, 'ymd', '/');
                    }
                }],


                blur: function () {
                    var dateCheck;
                    dateCheck = checkDate(DynamicForm_Report.getValue("startDate"));
                    if (dateCheck == false)
                        DynamicForm_Report.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                        endDateCheckReport = false;
                    if (dateCheck == true)
                        DynamicForm_Report.clearFieldErrors("startDate", true);
                        endDateCheckReport = true;
                    var endDate = DynamicForm_Report.getValue("endDate");
                    var startDate = DynamicForm_Report.getValue("startDate");
                    if (endDate != undefined && startDate > endDate) {
                        DynamicForm_Report.addFieldErrors("endDate", "<spring:message code='msg.date.order'/>", true);
                        DynamicForm_Report.getItem("endDate").setValue("");
                        endDateCheckReport = false;
                    }
                }
            },

            {
                name: "endDate",
                height: 35,
                titleAlign:"left",
                title: "تا تاریخ",
                ID: "endDate_jspReport",
                type: 'text',
                enabled: false,
                required: true,
                hint: "YYYY/MM/DD",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                focus: function () {
                    displayDatePicker('endDate_jspReport', this, 'ymd', '/');
                },
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('endDate_jspReport', this, 'ymd', '/');

                    }
                }],
                blur: function () {

                    var dateCheck;
                    dateCheck = checkDate(DynamicForm_Report.getValue("endDate"));
                    var endDate = DynamicForm_Report.getValue("endDate");
                    var startDate = DynamicForm_Report.getValue("startDate");
                    if (dateCheck == false) {
                        DynamicForm_Report.clearFieldErrors("endDate", true);
                        DynamicForm_Report.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                        endDateCheckReport = false;
                    }
                    if (dateCheck == true) {
                        if (startDate == undefined)
                            DynamicForm_Report.clearFieldErrors("endDate", true);
                            DynamicForm_Report.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                           endDateCheckReport = false;
                        if (startDate != undefined && startDate > endDate) {
                            DynamicForm_Report.clearFieldErrors("endDate", true);
                            DynamicForm_Report.addFieldErrors("endDate", "<spring:message code='msg.date.order'/>", true);
                            endDateCheckReport = false;
                        }
                        if (startDate != undefined && startDate < endDate) {
                            DynamicForm_Report.clearFieldErrors("endDate", true);
                            DynamicForm_Report.clearFieldErrors("startDate", true);
                            endDateCheckReport = true;
                        }
                    }
                }

            },
            {
                 type: "button",
                 title: "گزارش غيبت ناموجه",
                 height:"30",
                 align:"left",
                 endRow:false,
                 startRow: false,

                click:function () {
                    if (endDateCheckReport == false)
                        return;

                    if (!DynamicForm_Report.validate()) {
                        return;
                    }

                    var strSData=DynamicForm_Report.getItem("startDate").getValue().replace(/(\/)/g, "");
                    var strEData = DynamicForm_Report.getItem("endDate").getValue().replace(/(\/)/g, "");
                   Print(strSData,strEData)
                }
            },
            {
                type: "button",
                startRow:false,
                align:"left",
                title: "ليست افراد با نمره پيش تست بيشتر از حد مجاز",
                height:"30",
               click:function () {
                    if (endDateCheckReport == false)
                        return;
                    if (!DynamicForm_Report.validate()) {
                        return;
                    }
                    var strSData=DynamicForm_Report.getItem("startDate").getValue().replace(/(\/)/g, "");
                    var strEData = DynamicForm_Report.getItem("endDate").getValue().replace(/(\/)/g, "");
                    PrintPreTest(strSData,strEData)
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

        function  PrintPreTest(startDate,endDate)
        {
            var criteriaForm = isc.DynamicForm.create({
                method: "POST",
                action: "<spring:url value="/unjustified/printPreTestScore"/>" +"/"+startDate + "/" + endDate,
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
