<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    var DynamicForm_TrainingOverTime = isc.DynamicForm.create({
        numCols: 6,
        padding: 10,
        titleAlign: "left",
        colWidths: [70, 200, 70, 200, 100, 100],
        fields: [
            {
                name: "startDate",
                titleColSpan: 1,
// type:"staticText",
                title: "<spring:message code='start.date'/>",
                ID: "startDate_jspClass",
                required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate_jspClass', this, 'ymd', '/');
                    }
                }],
                textAlign: "center",
                // colSpan: 2,
                changed: function (form, item, value) {
                    var dateCheck;
                    // var endDate = form.getValue("endDate");
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
                ID: "endDate_jspClass",
                type: 'text', required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate_jspClass', this, 'ymd', '/');
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
                name: "searchBtn",
                ID: "searchBtnJspTrainingOverTime",
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
                    var wait = createDialog("wait");
                    ListGrid_TrainingOverTime_TrainingOverTimeJSP.setData([]);
                    let url = trainingOverTimeReportUrl + "/list?startDate=" + form.getValue("startDate") + "&endDate=" + form.getValue("endDate");
                    isc.RPCManager.sendRequest(TrDSRequest(url, "GET", null, function (resp) {
                        wait.close();
                        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                            ListGrid_TrainingOverTime_TrainingOverTimeJSP.setData(JSON.parse(resp.data));
                        }
                    }))
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
                    ListGrid_TrainingOverTime_TrainingOverTimeJSP.setData([]);
                }
            },
        ],
        itemKeyPress: function (item, keyName) {
            if (keyName == "Enter") {
                searchBtnJspTrainingOverTime.click(DynamicForm_TrainingOverTime);
            }
        }
    });
    var ListGrid_TrainingOverTime_TrainingOverTimeJSP = isc.TrLG.create({
        ID: "TrainingOverTimeGrid",
        dynamicTitle: true,
        filterOnKeypress: true,
        gridComponents: [DynamicForm_TrainingOverTime, "header", "filterEditor", "body"],
        groupByField:"name", groupStartOpen:"all",
        showGridSummary:true,
        showGroupSummary:true,
        fields: [
            {name: "personalNum", title: "<spring:message code='personnel.no'/>"},
            {name: "personalNum2", title: "<spring:message code='personnel.no.6.digits'/>", autoFitWidth:true},
            {name: "nationalCode", title: "<spring:message code='national.code'/>"},
            {
                name: "name",
                title: "<spring:message code='student'/>",
            },
            {name: "ccpArea", title: "<spring:message code='area'/>"},
            {name: "classCode", title: "<spring:message code="class.code"/>"},
            {name: "className", title: "<spring:message code="class.title"/>"},
            {name: "date", title: "<spring:message code="date"/>"},
            {
                name: "time",
                title: "<spring:message code="time"/>",
                includeInRecordSummary:false,
                summaryFunction:"sum",
                // type:"summary",
                // recordSummaryFunction:"multiplier",
                // summaryFunction:"sum",
                // showGridSummary:true,
                // showGroupSummary:true,
                // getGridSummary:function (records, summaryField) {
                //     return "base";
                // }
                // showGridSummary:true,
                // summaryFunction:"sum",
                // format: "#.## ساعت",
                formatCellValue (value, record, rowNum, colNum, grid){
                    return (value + "دقیقه");
                }
            },
        ]
    });
    var VLayout_Body_Training_OverTime = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            ListGrid_TrainingOverTime_TrainingOverTimeJSP
        ]
    });

    //</script>