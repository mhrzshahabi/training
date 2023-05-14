<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    let fromDateCheck_financial_expenses_of_the_organization = true;
    let toDateCheck_financial_expenses_of_the_organization = true;
    let dateCheck_Order_financial_expenses_of_the_organization = true;
    let reportCriteria_financial_expenses_of_the_organization;
    let data_values_financial_expenses_of_the_organization = null;

    //---------------------------------------------------- REST DataSources--------------------------------------------------------//
    RestDataSource_financial_expenses_of_the_organization= isc.TrDS.create({
        fields: [
            {name: "complex", title: "مجتمع"},
            {name: "baseOnComplex", title: "کل هزینه براساس مجتمع"},
            {name: "assistant", title: "معاونت"},
            {name: "baseOnAssistant", title: "کل هزینه براساس معاونت"},
            {name: "darsadMoavenatAzMojtame", title: "درصد معاونت از مجتمع"},
            {name: "affairs", title: "امور"},
            {name: "baseOnAffairs", title: "کل هزینه براساس امور"},
            {name: "darsadOmorAzMoavenat", title: "درصد امور از معاونت"},
            {name: "darsadOmorAzMojtame", title: "درصد امور از مجتمع"}
        ],
        fetchDataURL: financialExpensesOfTheOrganizationUrl + "/iscList"
    });

    //---------------------------------------------------- Main Window--------------------------------------------------------------//
    ToolStripButton_Excel_financial_expenses_of_the_organization= isc.ToolStripButtonExcel.create({
        click: function () {
            if (ListGrid_financial_expenses_of_the_organization.getOriginalData().localData === undefined)
                createDialog("info", "ابتدا نمایش گزارش را انتخاب کنید");
            else
                ExportToFile.downloadExcelFromClient(ListGrid_financial_expenses_of_the_organization, null, '', "گزارش آماری هزینه های مالی سازمان");
        }
    });
    ToolStrip_Actions_financial_expenses_of_the_organization= isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Excel_financial_expenses_of_the_organization
                    ]
                })
            ]
    });

    organSegmentFilter_financial_expenses_of_the_organization= init_OrganSegmentFilterDF(true, true, true, true, true, null, "complexTitle","assistant","affairs", "section", "unit");
    DynamicForm_financial_expenses_of_the_organization= isc.DynamicForm.create({
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
                ID: "fromDate_financial_expenses_of_the_organization",
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
                        displayDatePicker('fromDate_financial_expenses_of_the_organization', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value === undefined || value == null) {
                        form.clearFieldErrors("toDate","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("fromDate", true);
                        dateCheck_Order_financial_expenses_of_the_organization = true;
                        fromDateCheck_financial_expenses_of_the_organization = true;
                        return;
                    }
                    let dateCheck;
                    let endDate = form.getValue("toDate");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        fromDateCheck_financial_expenses_of_the_organization = false;
                        dateCheck_Order_financial_expenses_of_the_organization = true;
                        form.clearFieldErrors("fromDate", true);
                        form.addFieldErrors("fromDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        dateCheck_Order_financial_expenses_of_the_organization = false;
                        fromDateCheck_financial_expenses_of_the_organization = true;
                        form.clearFieldErrors("fromDate", true);
                        form.addFieldErrors("fromDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    }
                    else {
                        fromDateCheck_financial_expenses_of_the_organization = true;
                        dateCheck_Order_financial_expenses_of_the_organization = true;
                        form.clearFieldErrors("fromDate", true);
                    }
                }
            },
            {
                name: "toDate",
                ID: "toDate_financial_expenses_of_the_organization",
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
                        displayDatePicker('toDate_financial_expenses_of_the_organization', this, 'ymd', '/', 'right');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value === undefined || value === null) {
                        form.clearFieldErrors("fromDate","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("toDate", true);
                        dateCheck_Order_financial_expenses_of_the_organization = true;
                        toDateCheck_financial_expenses_of_the_organization = true;
                        return;
                    }
                    let dateCheck;
                    dateCheck = checkDate(value);
                    let fromDate = form.getValue("fromDate");
                    if (dateCheck === false) {
                        toDateCheck_financial_expenses_of_the_organization = false;
                        dateCheck_Order_financial_expenses_of_the_organization = true;
                        form.clearFieldErrors("toDate", true);
                        form.addFieldErrors("toDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (fromDate !== undefined && value < fromDate) {
                        form.clearFieldErrors("toDate", true);
                        form.addFieldErrors("toDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        toDateCheck_financial_expenses_of_the_organization = true;
                        dateCheck_Order_financial_expenses_of_the_organization = false;
                    } else {
                        form.clearFieldErrors("toDate", true);
                        toDateCheck_financial_expenses_of_the_organization = true;
                        dateCheck_Order_financial_expenses_of_the_organization = true;
                    }
                }
            }
        ]
    });

    IButton_Show_financial_expenses_of_the_organization= isc.IButtonSave.create({
        top: 260,
        title: "نمایش گزارش",
        width: 300,
        click: function () {
            if (!DynamicForm_financial_expenses_of_the_organization.validate())
                return;
            ListGrid_financial_expenses_of_the_organization.setData([]);
            Reporting_financial_expenses_of_the_organization();
        }
    });
    IButton_Clear_financial_expenses_of_the_organization= isc.IButtonSave.create({
        top: 260,
        title: "پاک کردن",
        width: 300,
        click: function () {
            DynamicForm_financial_expenses_of_the_organization.clearValues();
            DynamicForm_financial_expenses_of_the_organization.clearErrors();
            organSegmentFilter_financial_expenses_of_the_organization.clearValues();
            ListGrid_financial_expenses_of_the_organization.setData([]);
        }
    });
    HLayOut_Confirm_financial_expenses_of_the_organization= isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Show_financial_expenses_of_the_organization,
            IButton_Clear_financial_expenses_of_the_organization
        ]
    });

    ListGrid_financial_expenses_of_the_organization= isc.TrLG.create({
        filterOnKeypress: false,
        showFilterEditor: false,
        dataSource: RestDataSource_financial_expenses_of_the_organization,
        gridComponents: ["filterEditor", "header", "body"],
        fields: [
            {name: "complex", title: "مجتمع"},
            {name: "baseOnComplex", title: "کل هزینه براساس مجتمع"},
            {name: "assistant", title: "معاونت"},
            {name: "baseOnAssistant", title: "کل هزینه براساس معاونت"},
            {name: "darsadMoavenatAzMojtame", title: "درصد معاونت از مجتمع"},
            {name: "affairs", title: "امور"},
            {name: "baseOnAffairs", title: "کل هزینه براساس امور"},
            {name: "darsadOmorAzMoavenat", title: "درصد امور از معاونت"},
            {name: "darsadOmorAzMojtame", title: "درصد امور از مجتمع"}
        ]
    });

    VLayout_Body_financial_expenses_of_the_organization= isc.VLayout.create({
        border: "2px solid blue",
        width: "100%",
        height: "100%",
        members: [
            ToolStrip_Actions_financial_expenses_of_the_organization,
            organSegmentFilter_financial_expenses_of_the_organization,
            DynamicForm_financial_expenses_of_the_organization,
            HLayOut_Confirm_financial_expenses_of_the_organization,
            ListGrid_financial_expenses_of_the_organization
        ]
    });

    //---------------------------------------------------- Functions --------------------------------------------------------------//
    function Reporting_financial_expenses_of_the_organization() {

        data_values_financial_expenses_of_the_organization = null;
        data_values_financial_expenses_of_the_organization = DynamicForm_financial_expenses_of_the_organization.getValuesAsAdvancedCriteria();

        if (organSegmentFilter_financial_expenses_of_the_organization.getCriteria() !== undefined) {
            reportCriteria_financial_expenses_of_the_organization = organSegmentFilter_financial_expenses_of_the_organization.getCriteria();
            for (let i = 0; i < reportCriteria_financial_expenses_of_the_organization.criteria.size(); i++) {
                if (reportCriteria_financial_expenses_of_the_organization.criteria[i].fieldName === "complexTitle") {
                    reportCriteria_financial_expenses_of_the_organization.criteria[i].fieldName = "complex";
                    data_values_financial_expenses_of_the_organization.criteria.add(reportCriteria_financial_expenses_of_the_organization.criteria[i]);
                } else if (reportCriteria_financial_expenses_of_the_organization.criteria[i].fieldName === "assistant") {
                    reportCriteria_financial_expenses_of_the_organization.criteria[i].fieldName = "assistant";
                    data_values_financial_expenses_of_the_organization.criteria.add(reportCriteria_financial_expenses_of_the_organization.criteria[i]);
                } else if (reportCriteria_financial_expenses_of_the_organization.criteria[i].fieldName === "affairs") {
                    reportCriteria_financial_expenses_of_the_organization.criteria[i].fieldName = "affairs";
                    data_values_financial_expenses_of_the_organization.criteria.add(reportCriteria_financial_expenses_of_the_organization.criteria[i]);
                }
            }
        }

        ListGrid_financial_expenses_of_the_organization.fetchData(data_values_financial_expenses_of_the_organization);
    }

    //</script>
