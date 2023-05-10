<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    let fromDateCheckـfinancial_expenses_of_the_organization = true;
    let toDateCheckـfinancial_expenses_of_the_organization = true;
    let dateCheck_Orderـfinancial_expenses_of_the_organization = true;
    let reportCriteriaـfinancial_expenses_of_the_organization;
    let data_valuesـfinancial_expenses_of_the_organization = null;

    //---------------------------------------------------- REST DataSources--------------------------------------------------------//
    RestDataSourceـfinancial_expenses_of_the_organization= isc.TrDS.create({
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
    ToolStripButton_Excelـfinancial_expenses_of_the_organization= isc.ToolStripButtonExcel.create({
        click: function () {
            if (ListGridـfinancial_expenses_of_the_organization.getOriginalData().localData === undefined)
                createDialog("info", "ابتدا نمایش گزارش را انتخاب کنید");
            else
                ExportToFile.downloadExcelFromClient(ListGridـfinancial_expenses_of_the_organization, null, '', "گزارش آماری نحوه ورود افراد به کلاس");
        }
    });
    ToolStrip_Actionsـfinancial_expenses_of_the_organization= isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Excelـfinancial_expenses_of_the_organization
                    ]
                })
            ]
    });

    organSegmentFilterـfinancial_expenses_of_the_organization= init_OrganSegmentFilterDF(true, true, true, true, true, null, "complexTitle","assistant","affairs", "section", "unit");
    DynamicFormـfinancial_expenses_of_the_organization= isc.DynamicForm.create({
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
                ID: "fromDateـfinancial_expenses_of_the_organization",
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
                        displayDatePicker('fromDateـfinancial_expenses_of_the_organization', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value === undefined || value == null) {
                        form.clearFieldErrors("toDate","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("fromDate", true);
                        dateCheck_Orderـfinancial_expenses_of_the_organization = true;
                        fromDateCheckـfinancial_expenses_of_the_organization = true;
                        return;
                    }
                    let dateCheck;
                    let endDate = form.getValue("toDate");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        fromDateCheckـfinancial_expenses_of_the_organization = false;
                        dateCheck_Orderـfinancial_expenses_of_the_organization = true;
                        form.clearFieldErrors("fromDate", true);
                        form.addFieldErrors("fromDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        dateCheck_Orderـfinancial_expenses_of_the_organization = false;
                        fromDateCheckـfinancial_expenses_of_the_organization = true;
                        form.clearFieldErrors("fromDate", true);
                        form.addFieldErrors("fromDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    }
                    else {
                        fromDateCheckـfinancial_expenses_of_the_organization = true;
                        dateCheck_Orderـfinancial_expenses_of_the_organization = true;
                        form.clearFieldErrors("fromDate", true);
                    }
                }
            },
            {
                name: "toDate",
                ID: "toDateـfinancial_expenses_of_the_organization",
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
                        displayDatePicker('toDateـfinancial_expenses_of_the_organization', this, 'ymd', '/', 'right');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value === undefined || value === null) {
                        form.clearFieldErrors("fromDate","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("toDate", true);
                        dateCheck_Orderـfinancial_expenses_of_the_organization = true;
                        toDateCheckـfinancial_expenses_of_the_organization = true;
                        return;
                    }
                    let dateCheck;
                    dateCheck = checkDate(value);
                    let fromDate = form.getValue("fromDate");
                    if (dateCheck === false) {
                        toDateCheckـfinancial_expenses_of_the_organization = false;
                        dateCheck_Orderـfinancial_expenses_of_the_organization = true;
                        form.clearFieldErrors("toDate", true);
                        form.addFieldErrors("toDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (fromDate !== undefined && value < fromDate) {
                        form.clearFieldErrors("toDate", true);
                        form.addFieldErrors("toDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        toDateCheckـfinancial_expenses_of_the_organization = true;
                        dateCheck_Orderـfinancial_expenses_of_the_organization = false;
                    } else {
                        form.clearFieldErrors("toDate", true);
                        toDateCheckـfinancial_expenses_of_the_organization = true;
                        dateCheck_Orderـfinancial_expenses_of_the_organization = true;
                    }
                }
            }
        ]
    });

    IButton_Showـfinancial_expenses_of_the_organization= isc.IButtonSave.create({
        top: 260,
        title: "نمایش گزارش",
        width: 300,
        click: function () {
            if (!DynamicFormـfinancial_expenses_of_the_organization.validate())
                return;
            ListGridـfinancial_expenses_of_the_organization.setData([]);
            Reportingـfinancial_expenses_of_the_organization();
        }
    });
    IButton_Clearـfinancial_expenses_of_the_organization= isc.IButtonSave.create({
        top: 260,
        title: "پاک کردن",
        width: 300,
        click: function () {
            DynamicFormـfinancial_expenses_of_the_organization.clearValues();
            DynamicFormـfinancial_expenses_of_the_organization.clearErrors();
            organSegmentFilterـfinancial_expenses_of_the_organization.clearValues();
            ListGridـfinancial_expenses_of_the_organization.setData([]);
        }
    });
    HLayOut_Confirmـfinancial_expenses_of_the_organization= isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Showـfinancial_expenses_of_the_organization,
            IButton_Clearـfinancial_expenses_of_the_organization
        ]
    });

    ListGridـfinancial_expenses_of_the_organization= isc.TrLG.create({
        filterOnKeypress: false,
        showFilterEditor: false,
        dataSource: RestDataSourceـfinancial_expenses_of_the_organization,
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

    VLayout_Bodyـfinancial_expenses_of_the_organization= isc.VLayout.create({
        border: "2px solid blue",
        width: "100%",
        height: "100%",
        members: [
            ToolStrip_Actionsـfinancial_expenses_of_the_organization,
            organSegmentFilterـfinancial_expenses_of_the_organization,
            DynamicFormـfinancial_expenses_of_the_organization,
            HLayOut_Confirmـfinancial_expenses_of_the_organization,
            ListGridـfinancial_expenses_of_the_organization
        ]
    });

    //---------------------------------------------------- Functions --------------------------------------------------------------//
    function Reportingـfinancial_expenses_of_the_organization() {

        data_valuesـfinancial_expenses_of_the_organization = null;
        data_valuesـfinancial_expenses_of_the_organization = DynamicFormـfinancial_expenses_of_the_organization.getValuesAsAdvancedCriteria();

        if (organSegmentFilterـfinancial_expenses_of_the_organization.getCriteria() !== undefined) {
            reportCriteriaـfinancial_expenses_of_the_organization = organSegmentFilterـfinancial_expenses_of_the_organization.getCriteria();
            for (let i = 0; i < reportCriteriaـfinancial_expenses_of_the_organization.criteria.size(); i++) {
                if (reportCriteriaـfinancial_expenses_of_the_organization.criteria[i].fieldName === "complexTitle") {
                    reportCriteriaـfinancial_expenses_of_the_organization.criteria[i].fieldName = "complex";
                    data_valuesـfinancial_expenses_of_the_organization.criteria.add(reportCriteriaـfinancial_expenses_of_the_organization.criteria[i]);
                } else if (reportCriteriaـfinancial_expenses_of_the_organization.criteria[i].fieldName === "assistant") {
                    reportCriteriaـfinancial_expenses_of_the_organization.criteria[i].fieldName = "assistant";
                    data_valuesـfinancial_expenses_of_the_organization.criteria.add(reportCriteriaـfinancial_expenses_of_the_organization.criteria[i]);
                } else if (reportCriteriaـfinancial_expenses_of_the_organization.criteria[i].fieldName === "affairs") {
                    reportCriteriaـfinancial_expenses_of_the_organization.criteria[i].fieldName = "affairs";
                    data_valuesـfinancial_expenses_of_the_organization.criteria.add(reportCriteriaـfinancial_expenses_of_the_organization.criteria[i]);
                }
            }
        }

        ListGridـfinancial_expenses_of_the_organization.fetchData(data_valuesـfinancial_expenses_of_the_organization);
    }

    //</script>
