<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    let fromDateCheckـattendanceـperson = true;
    let toDateCheckـattendanceـperson = true;
    let dateCheck_Orderـattendanceـperson = true;
    let reportCriteriaـattendanceـperson;
    let data_valuesـattendanceـperson = null;

    //---------------------------------------------------- REST DataSources--------------------------------------------------------//
    RestDataSourceـattendanceـperson= isc.TrDS.create({
        fields: [
            {name: "complex", title: "مجتمع"},
            {name: "assistant", title: "معاونت"},
            {name: "affairs", title: "امور"},
            {name: "baseOnComplex", title: "نتیجه براساس مجتمع"},
            {name: "baseOnAssistant", title: "نتیجه براساس معاونت"},
            {name: "baseOnAffairs", title: "نتیجه براساس امور"}
        ],
        fetchDataURL: typeOfEnterToClassUrl + "/iscList"
    });

    //---------------------------------------------------- Main Window--------------------------------------------------------------//
    ToolStripButton_Excelـattendanceـperson= isc.ToolStripButtonExcel.create({
        click: function () {
            if (ListGridـattendanceـperson.getOriginalData().localData === undefined)
                createDialog("info", "ابتدا نمایش گزارش را انتخاب کنید");
            else
                ExportToFile.downloadExcelFromClient(ListGridـattendanceـperson, null, '', "گزارش آماری نحوه ورود افراد به کلاس");
        }
    });
    ToolStrip_Actionsـattendanceـperson= isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Excelـattendanceـperson
                    ]
                })
            ]
    });

    organSegmentFilterـattendanceـperson= init_OrganSegmentFilterDF(true, true, true, true, true, null, "complexTitle","assistant","affairs", "section", "unit");
    DynamicFormـattendanceـperson= isc.DynamicForm.create({
        align: "right",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 4,
        colWidths: ["7%", "43%", "7%", "43%"],
        fields: [
            {
                name: "fromDate",
                ID: "fromDateـattendanceـperson",
                title: "از تاریخ",
                hint: todayDate,
                required: true,
                showHintInField: true,
                length: 10,
                filterOperator: "equals",
                type: 'text',
                keyPressFilter: "[\u200E\u200F ]",
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('fromDateـattendanceـperson', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value === undefined || value == null) {
                        form.clearFieldErrors("toDate","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("fromDate", true);
                        dateCheck_Orderـattendanceـperson = true;
                        fromDateCheckـattendanceـperson = true;
                        return;
                    }
                    let dateCheck;
                    let endDate = form.getValue("toDate");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        fromDateCheckـattendanceـperson = false;
                        dateCheck_Orderـattendanceـperson = true;
                        form.clearFieldErrors("fromDate", true);
                        form.addFieldErrors("fromDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        dateCheck_Orderـattendanceـperson = false;
                        fromDateCheckـattendanceـperson = true;
                        form.clearFieldErrors("fromDate", true);
                        form.addFieldErrors("fromDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    }
                    else {
                        fromDateCheckـattendanceـperson = true;
                        dateCheck_Orderـattendanceـperson = true;
                        form.clearFieldErrors("fromDate", true);
                    }
                }
            },
            {
                name: "toDate",
                ID: "toDateـattendanceـperson",
                title: "تا تاریخ",
                hint: todayDate,
                required: true,
                showHintInField: true,
                length: 10,
                filterOperator: "equals",
                type: 'text',
                keyPressFilter: "[\u200E\u200F ]",
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('toDateـattendanceـperson', this, 'ymd', '/', 'right');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value === undefined || value === null) {
                        form.clearFieldErrors("fromDate","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("toDate", true);
                        dateCheck_Orderـattendanceـperson = true;
                        toDateCheckـattendanceـperson = true;
                        return;
                    }
                    let dateCheck;
                    dateCheck = checkDate(value);
                    let fromDate = form.getValue("fromDate");
                    if (dateCheck === false) {
                        toDateCheckـattendanceـperson = false;
                        dateCheck_Orderـattendanceـperson = true;
                        form.clearFieldErrors("toDate", true);
                        form.addFieldErrors("toDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (fromDate !== undefined && value < fromDate) {
                        form.clearFieldErrors("toDate", true);
                        form.addFieldErrors("toDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        toDateCheckـattendanceـperson = true;
                        dateCheck_Orderـattendanceـperson = false;
                    } else {
                        form.clearFieldErrors("toDate", true);
                        toDateCheckـattendanceـperson = true;
                        dateCheck_Orderـattendanceـperson = true;
                    }
                }
            }
        ]
    });

    IButton_Showـattendanceـperson= isc.IButtonSave.create({
        top: 260,
        title: "نمایش گزارش",
        width: 300,
        click: function () {
            if (!DynamicFormـattendanceـperson.validate())
                return;
            ListGridـattendanceـperson.setData([]);
            Reportingـattendanceـperson();
        }
    });
    IButton_Clearـattendanceـperson= isc.IButtonSave.create({
        top: 260,
        title: "پاک کردن",
        width: 300,
        click: function () {
            DynamicFormـattendanceـperson.clearValues();
            DynamicFormـattendanceـperson.clearErrors();
            organSegmentFilterـattendanceـperson.clearValues();
            ListGridـattendanceـperson.setData([]);
        }
    });
    HLayOut_Confirmـattendanceـperson= isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Showـattendanceـperson,
            IButton_Clearـattendanceـperson
        ]
    });

    ListGridـattendanceـperson= isc.TrLG.create({
        filterOnKeypress: false,
        showFilterEditor: false,
        dataSource: RestDataSourceـattendanceـperson,
        gridComponents: ["filterEditor", "header", "body"],
        fields: [
            {name: "complex", title: "مجتمع"},
            {name: "assistant", title: "معاونت"},
            {name: "affairs", title: "امور"},
            {name: "baseOnComplex", title: "نتیجه براساس مجتمع"},
            {name: "baseOnAssistant", title: "نتیجه براساس معاونت"},
            {name: "baseOnAffairs", title: "نتیجه براساس امور"}
        ]
    });

    VLayout_Bodyـattendanceـperson= isc.VLayout.create({
        border: "2px solid blue",
        width: "100%",
        height: "100%",
        members: [
            ToolStrip_Actionsـattendanceـperson,
            organSegmentFilterـattendanceـperson,
            DynamicFormـattendanceـperson,
            HLayOut_Confirmـattendanceـperson,
            ListGridـattendanceـperson
        ]
    });

    //---------------------------------------------------- Functions --------------------------------------------------------------//
    function Reportingـattendanceـperson() {

        data_valuesـattendanceـperson = null;
        data_valuesـattendanceـperson = DynamicFormـattendanceـperson.getValuesAsAdvancedCriteria();

        if (organSegmentFilterـattendanceـperson.getCriteria() !== undefined) {
            reportCriteriaـattendanceـperson = organSegmentFilterـattendanceـperson.getCriteria();
            for (let i = 0; i < reportCriteriaـattendanceـperson.criteria.size(); i++) {
                if (reportCriteriaـattendanceـperson.criteria[i].fieldName === "complexTitle") {
                    reportCriteriaـattendanceـperson.criteria[i].fieldName = "complex";
                    data_valuesـattendanceـperson.criteria.add(reportCriteriaـattendanceـperson.criteria[i]);
                } else if (reportCriteriaـattendanceـperson.criteria[i].fieldName === "assistant") {
                    reportCriteriaـattendanceـperson.criteria[i].fieldName = "assistant";
                    data_valuesـattendanceـperson.criteria.add(reportCriteriaـattendanceـperson.criteria[i]);
                } else if (reportCriteriaـattendanceـperson.criteria[i].fieldName === "affairs") {
                    reportCriteriaـattendanceـperson.criteria[i].fieldName = "affairs";
                    data_valuesـattendanceـperson.criteria.add(reportCriteriaـattendanceـperson.criteria[i]);
                }
            }
        }

        ListGridـattendanceـperson.fetchData(data_valuesـattendanceـperson);
    }

    //</script>
