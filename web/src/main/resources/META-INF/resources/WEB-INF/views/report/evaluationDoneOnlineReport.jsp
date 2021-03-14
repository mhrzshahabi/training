<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

//<script>

    RestDataSource_Class_JspEvaluationDoneOnline = isc.TrDS.create({
        fields: [
            {name: "evalTitle"},
            {name: "instructor"},
            {name: "evalCreateDate"},
            {name: "course"},
            {name: "users"},
            {name: "createDate"},
            {name: "unAnsweredCount"},
            {name: "answeredCount"},
        ],
    });

    function gregorianDateJoined(date, j) {
        let dates = date.split("/");
        if (!j)
            j = '';
        else j = '-';
        let arr = JalaliDate.jalaliToGregorian(dates[0], dates[1], dates[2]);
        return arr[0].toString().concat(j).concat(arr[1].toString().padStart(2, 0)).concat(j).concat(arr[2].toString().padStart(2, 0));
    }

    var DynamicForm_EvaluationDoneOnline = isc.DynamicForm.create({
        numCols: 6,
        padding: 10,
        titleAlign: "left",
        colWidths: [70, 200, 70, 200, 100, 100],
        fields: [
            {
                name: "startDate",
                titleColSpan: 1,
                title: "<spring:message code='start.date'/>",
                ID: "startDate_jspEvaluationDoneOnline",
                required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate_jspEvaluationDoneOnline', this, 'ymd', '/');
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
                ID: "endDate_jspEvaluationDoneOnline",
                type: 'text', required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate_jspEvaluationDoneOnline', this, 'ymd', '/');
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
                ID: "searchBtnJspEvaluationDoneOnline",
                title: "<spring:message code="search"/>",
                type: "ButtonItem",
                width: "*",
                startRow: false,
                endRow: false,
                click(form) {
                    if (form.getValue("endDate") < form.getValue("startDate")) {
                        createDialog("info", "تاریخ پایان نمی تواند کوچکتر از تاریخ شروع باشد");
                        return;
                    }
                    if (DynamicForm_EvaluationDoneOnline.getValuesAsAdvancedCriteria() == null || DynamicForm_EvaluationDoneOnline.getValuesAsAdvancedCriteria().criteria.size() <= 1) {
                        createDialog("info", "فیلتری انتخاب نشده است.");
                        return;
                    }

                    DynamicForm_EvaluationDoneOnline.validate();
                    if (DynamicForm_EvaluationDoneOnline.hasErrors())
                        return;


                    else {
                        var training_over_time_wait = createDialog("wait");
                        setTimeout(function () {
                            let url = rootUrl + "/evaluationDoneOnline/" + gregorianDateJoined(form.getValue("startDate"))
                                + "/" + gregorianDateJoined(form.getValue("endDate"));
                            RestDataSource_Class_JspEvaluationDoneOnline.fetchDataURL = url;
                            ListGrid_EvaluationDoneOnline.invalidateCache();
                            ListGrid_EvaluationDoneOnline.fetchData();
                            training_over_time_wait.close();

                        }, 100);
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
                    ListGrid_EvaluationDoneOnline.setData([]);
                }
            },
        ],
        itemKeyPress: function (item, keyName) {
            if (keyName == "Enter") {
                searchBtnJspEvaluationDoneOnline.click(DynamicForm_EvaluationDoneOnline);
            }
        }
    });
    var ListGrid_EvaluationDoneOnline = isc.TrLG.create({
        ID: "EvaluationDoneOnlineGrid",
        //dynamicTitle: true,
        filterOnKeypress: false,
        showFilterEditor: false,
        canExpandRecords: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        gridComponents: [DynamicForm_EvaluationDoneOnline,
            "header", "filterEditor", "body"],
        dataSource: RestDataSource_Class_JspEvaluationDoneOnline,
        fields: [
            {name: "evalTitle", title: '<spring:message code="reports.online.evaluation.evalTitle"/>'},
            {name: "course", title: '<spring:message code="class"/>'},
            {name: "instructor", title: '<spring:message code="teacher"/>'},
            {name: "evalCreateDate", title: '<spring:message code="reports.online.evaluation.evalCreateDate"/>'},
            {name: "answeredCount", title: '<spring:message code="reports.online.evaluation.answereds"/>'},
            {name: "unAnsweredCount", title: '<spring:message code="reports.online.evaluation.withoutAnswereds"/>'},
            {name: "excelBtn", title: " ", width: "110"},
        ],
        getExpansionComponent: function (record, rowNum, colNum) {
            let detail = isc.TrLG.create({
                height: "250",
                filterOnKeypress: false,
                showFilterEditor: false,
                fields: [
                    {name: "fullName", title: '<spring:message code="full.name"/>'},
                    {name: "nationalCode", title: '<spring:message code="national.code"/>'},
                    {name: "phoneNumber", title: '<spring:message code="cellPhone"/>'},
                    {name: "answered", title: '<spring:message code="reports.online.evaluation.answered"/>',
                        valueMap: {
                            true: "<spring:message code='yes'/>",
                            false: "<spring:message code='no'/>",
                        }
                    },
                ],
                getCellCSSText: function (record) {
                    if (record.answered)
                        return "color:green";
                    else
                        return "color:red";
                },
            });
            if (record.users)
                detail.setData(Object.values(record.users));
            return isc.VLayout.create({
                members: [detail]
            });
        },
        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);
            if (fieldName === "excelBtn") {
                let button = isc.ToolStripButtonExcel.create({
                    margin: 5,
                    click: function () {
                        makeExcelOutput(record, JSON.stringify(Object.values(record.users)));
                    }
                });
                return button;
            }
        }
    });
    var VLayout_Body_EvaluationDoneOnline = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            ListGrid_EvaluationDoneOnline
        ]
    });

    function makeExcelOutput(record, detailData) {
        let masterData = {
            '<spring:message code="reports.online.evaluation.evalTitle"/>': record.evalTitle,
            '<spring:message code="reports.online.evaluation.answereds"/>': record.answeredCount + " ",
            '<spring:message code="reports.online.evaluation.withoutAnswereds"/>': record.unAnsweredCount + " ",
            '<spring:message code="teacher"/>': record.instructor,
            '<spring:message code="reports.online.evaluation.evalCreateDate"/>': record.evalCreateDate,
            '<spring:message code="class"/>': record.course,
        };
        let detailFields = "fullName,nationalCode,phoneNumber,answered";
        let detailHeaders = '<spring:message code="full.name"/>,<spring:message code="national.code"/>,<spring:message code="cellPhone"/>,<spring:message code="reports.online.evaluation.answered"/>';
        let title = '<spring:message code="reports.done.evaluations"/>' + ' ' +
            DynamicForm_EvaluationDoneOnline.getItem("startDate").getValue() + ' تا ' + DynamicForm_EvaluationDoneOnline.getItem("endDate").getValue();
        let downloadForm = isc.DynamicForm.create({
            method: "POST",
            action: "/training/reportsToExcel/masterDetail",
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "masterData", type: "hidden"},
                    {name: "detailFields", type: "hidden"},
                    {name: "detailHeaders", type: "hidden"},
                    {name: "detailDto", type: "hidden"},
                    {name: "title", type: "hidden"},
                    {name: "detailData", type: "hidden"},
                ]
        });
        downloadForm.setValue("masterData", JSON.stringify(masterData));
        downloadForm.setValue("detailFields", detailFields);
        downloadForm.setValue("detailHeaders", detailHeaders);
        downloadForm.setValue("detailData", detailData);
        downloadForm.setValue("title", title);
        downloadForm.setValue("detailDto", "response.evaluation.dto.EvaluationDoneOnlineDto$UserDetailDto");
        downloadForm.show();
        downloadForm.submitForm();
    }

//</script>
