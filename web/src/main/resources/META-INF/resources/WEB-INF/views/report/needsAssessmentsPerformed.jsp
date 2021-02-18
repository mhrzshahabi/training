<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    RestDataSource_Class_JspNeedAssessmentsPerformed = isc.TrDS.create({
        fields: [
            {name: "postType"},
            {name: "postCode"},
            {name: "postTitle"},
            {name: "updateBy"},
            {name: "updateAt"}
        ]
    });
    function gregorianDate(date) {
        let dates = date.split("/");
        return JalaliDate.jalaliToGregorian(dates[0],dates[1],dates[2]).join("-");
    }
    var DynamicForm_NeedsAssessmentsPerformed = isc.DynamicForm.create({
        numCols: 6,
        padding: 10,
        titleAlign: "left",
        colWidths: [70, 200, 70, 200, 100, 100],
        fields: [
            {
                name: "startDate",
                titleColSpan: 1,
                title: "<spring:message code='start.date'/>",
                ID: "startDate_jspNeedAssessmentsPerformed",
                required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate_jspNeedAssessmentsPerformed', this, 'ymd', '/');
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
                ID: "endDate_jspNeedAssessmentsPerformed",
                type: 'text', required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate_jspNeedAssessmentsPerformed', this, 'ymd', '/');
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
                ID: "searchBtnJspNeedsAssessmentsPerformed",
                title: "<spring:message code="search"/>",
                type: "ButtonItem",
                width: "*",
                startRow: false,
                endRow: false,
                click(form) {
                    if(form.getValue("endDate") < form.getValue("startDate")) {
                        createDialog("info","تاریخ پایان نمی تواند کوچکتر از تاریخ شروع باشد");
                        return;
                    }
                    if(DynamicForm_NeedsAssessmentsPerformed.getValuesAsAdvancedCriteria()==null || DynamicForm_NeedsAssessmentsPerformed.getValuesAsAdvancedCriteria().criteria.size() <= 1) {
                        createDialog("info","فیلتری انتخاب نشده است.");
                        return;
                    }

                    DynamicForm_NeedsAssessmentsPerformed.validate();
                    if (DynamicForm_NeedsAssessmentsPerformed.hasErrors())
                        return;


                    else {
                        var training_over_time_wait = createDialog("wait");
                        setTimeout(function () {
                            let url = needsAssessmentsPerformedUrl + "/list/" + gregorianDate(form.getValue("startDate")) + "/" + gregorianDate(form.getValue("endDate"));
                            RestDataSource_Class_JspNeedAssessmentsPerformed.fetchDataURL = url;

                            ListGrid_NeedAssessmentsPerformed.invalidateCache();
                            ListGrid_NeedAssessmentsPerformed.fetchData();
                            training_over_time_wait.close();

                        }, 100);

                        // data_values = DynamicForm_NeedsAssessmentsPerformed.getValuesAsAdvancedCriteria();
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
                        //     ListGrid_NeedAssessmentsPerformed.invalidateCache();
                        //     ListGrid_NeedAssessmentsPerformed.fetchData(data_values);
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
                    ListGrid_NeedAssessmentsPerformed.setData([]);
                }
            },
        ],
        itemKeyPress: function (item, keyName) {
            if (keyName == "Enter") {
                searchBtnJspNeedsAssessmentsPerformed.click(DynamicForm_NeedsAssessmentsPerformed);
            }
        }
    });
    var ListGrid_NeedAssessmentsPerformed = isc.TrLG.create({
        ID: "NeedAssessmentsPerformedGrid",
        //dynamicTitle: true,
        filterOnKeypress: false,
        showFilterEditor:false,
        gridComponents: [DynamicForm_NeedsAssessmentsPerformed,
            isc.ToolStripButtonExcel.create({
                margin:5,
                click:function() {
                    makeExcelOutput();

                    // let title="گزارش نیازسنجی های انجام شده از تاریخ "+DynamicForm_NeedsAssessmentsPerformed.getItem("startDate").getValue()+ " الی "+DynamicForm_NeedsAssessmentsPerformed.getItem("endDate").getValue();
                    //
                    // ExportToFile.downloadExcel(null, ListGrid_NeedAssessmentsPerformed, 'needAssessmentsPerformed', 0, null, '', title, DynamicForm_NeedsAssessmentsPerformed.getValuesAsAdvancedCriteria(), null,2);
                }
            })
            , "header", "filterEditor", "body"],
        // groupByField:"name",
        // groupStartOpen:"none",
        // groupByMaxRecords:5000000,
        // showGridSummary:true,
        // showGroupSummary:true,
        dataSource: RestDataSource_Class_JspNeedAssessmentsPerformed,

        fields: [
            {name: "postType", title: "نوع پست"},
            {name: "postCode", title: "کد پست"},
            {name: "postTitle", title: "عنوان پست"},
            {name: "updateBy", title: "ویرایش توسط"},
            {name: "updateAt", title: "ویرایش در تاریخ", hidden: true}
        ]
    });
    var VLayout_Body_NeedAssessmentsPerformed = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            ListGrid_NeedAssessmentsPerformed
        ]
    });

    function makeExcelOutput() {

        let fieldNames = "postType,postCode,postTitle,updateBy";

        let headerNames = 'نوع پست,کد پست,عنوان پست ,کارشناس';

        let downloadForm = isc.DynamicForm.create({
            method: "POST",
            action: "/training/reportsToExcel/needsAssessmentsPerformed",
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "fields", type: "hidden"},
                    {name: "headers", type: "hidden"},
                    {name: "start", type: "hidden"},
                    {name: "end", type: "hidden"}
                ]
        });
        downloadForm.setValue("fields", fieldNames);
        downloadForm.setValue("headers", headerNames);
        downloadForm.setValue("start", gregorianDate(DynamicForm_NeedsAssessmentsPerformed.getItem("startDate").getValue()));
        downloadForm.setValue("end", gregorianDate(DynamicForm_NeedsAssessmentsPerformed.getItem("endDate").getValue()));

        downloadForm.show();
        downloadForm.submitForm();
    }

    //</script>
