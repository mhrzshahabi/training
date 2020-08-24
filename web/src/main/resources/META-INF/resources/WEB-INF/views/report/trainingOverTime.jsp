<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    RestDataSource_Class_JspTrainingOverTime = isc.TrDS.create({
        fields: [
            {name: "personalNum"},
            {name: "personalNum2"},
            {name: "nationalCode"},
            {name: "name"},
            {name: "ccpArea"},
            {name: "ccpAffairs"},
            {name: "classCode"},
            {name: "className"},
            {name: "date"},
            {name: "time"},
        ]
    });

    var DynamicForm_TrainingOverTime = isc.DynamicForm.create({
        numCols: 6,
        padding: 10,
        titleAlign: "left",
        colWidths: [70, 200, 70, 200, 100, 100],
        fields: [
            {
                name: "startDate",
                titleColSpan: 1,
                title: "<spring:message code='start.date'/>",
                ID: "startDate_jspTrainingOverTime",
                required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate_jspTrainingOverTime', this, 'ymd', '/');
                    }
                }],
                textAlign: "center",
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
                ID: "endDate_jspTrainingOverTime",
                type: 'text', required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate_jspTrainingOverTime', this, 'ymd', '/');
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
                    if(DynamicForm_TrainingOverTime.getValuesAsAdvancedCriteria()==null || DynamicForm_TrainingOverTime.getValuesAsAdvancedCriteria().criteria.size() <= 1) {
                        createDialog("info","فیلتری انتخاب نشده است.");
                        return;
                    }

                    DynamicForm_TrainingOverTime.validate();
                    if (DynamicForm_TrainingOverTime.hasErrors())
                        return;


                    else {
                        var training_over_time_wait = createDialog("wait");
                        setTimeout(function () {
                            let url = trainingOverTimeReportUrl + "/list?startDate=" + form.getValue("startDate") + "&endDate=" + form.getValue("endDate");
                            RestDataSource_Class_JspTrainingOverTime.fetchDataURL = url;

                            ListGrid_TrainingOverTime_TrainingOverTimeJSP.invalidateCache();
                            ListGrid_TrainingOverTime_TrainingOverTimeJSP.fetchData();
                            training_over_time_wait.close();

                        }, 100);

                        // data_values = DynamicForm_TrainingOverTime.getValuesAsAdvancedCriteria();
                        // for (let i = 0; i < data_values.criteria.size(); i++) {
                        //
                        //     if (data_values.criteria[i].fieldName == "startDate") {
                        //         data_values.criteria[i].fieldName = "date";
                        //         data_values.criteria[i].operator = "greaterThan";
                        //     } else if (data_values.criteria[i].fieldName == "endDate") {
                        //         data_values.criteria[i].fieldName = "date";
                        //         data_values.criteria[i].operator = "lessThan";
                        //     }
                        // }
                        //
                        //     ListGrid_TrainingOverTime_TrainingOverTimeJSP.invalidateCache();
                        //     ListGrid_TrainingOverTime_TrainingOverTimeJSP.fetchData(data_values);
                        //
                        //     return;

                    }
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
        //dynamicTitle: true,
        filterOnKeypress: false,
        showFilterEditor:true,
        gridComponents: [DynamicForm_TrainingOverTime,
            isc.ToolStripButtonExcel.create({
                margin:5,
                click:function() {
                    let title="گزارش اضافه کاری آموزشی از تاریخ "+DynamicForm_TrainingOverTime.getItem("startDate").getValue()+ " الی "+DynamicForm_TrainingOverTime.getItem("endDate").getValue();

                    ExportToFile.showDialog(null, ListGrid_TrainingOverTime_TrainingOverTimeJSP, 'trainingOverTime', 0, null, '', title, ListGrid_TrainingOverTime_TrainingOverTimeJSP.data.criteria, null);
                }
            })
            , "header", "filterEditor", "body"],
        // groupByField:"name",
        // groupStartOpen:"none",
        // groupByMaxRecords:5000000,
        // showGridSummary:true,
        // showGroupSummary:true,
        dataSource: RestDataSource_Class_JspTrainingOverTime,

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
            {name: "ccpArea", title: "<spring:message code='area'/>"},
            {name: "ccpAffairs", title: "<spring:message code='affairs'/>"},
            {name: "classCode", title: "<spring:message code="class.code"/>"},
            {name: "className", title: "<spring:message code="class.title"/>"},
            {name: "date", title: "<spring:message code="date"/>",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {
                name: "fixTime",
                title: "<spring:message code="time.hour"/>",
                includeInRecordSummary:false,
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