<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    let fromDateCheck_type_of_enter = true;
    let toDateCheck_type_of_enter = true;
    let dateCheck_Order_type_of_enter = true;
    let reportCriteria_type_of_enter;
    let data_values_type_of_enter = null;

    //---------------------------------------------------- REST DataSources--------------------------------------------------------//
    RestDataSource_type_of_enter= isc.TrDS.create({
        fields: [
            {name: "title", title: "نوع ورود به کلاس"},
            {name: "complex", title: "مجتمع"},
            {name: "baseOnComplex", title: "تعداد فراگیر براساس مجتمع"},
            {name: "assistant", title: "معاونت"},
            {name: "baseOnAssistant", title: "تعداد فراگیر براساس معاونت"},
            {name: "darsadMoavenatAzComplex", title: "درصد معاونت از مجتمع"},
            {name: "affairs", title: "امور"},
            {name: "baseOnAffairs", title: "تعداد فراگیر براساس امور"},
            {name: "darsadOmorAzMoavenat", title: "درصد امور از معاونت"},
            {name: "darsadOmorAzMojtame", title: "درصد امور از مجتمع"}
        ],
        fetchDataURL: typeOfEnterToClassUrl + "/iscList"
    });

    //---------------------------------------------------- Main Window--------------------------------------------------------------//
    ToolStripButton_Excel_type_of_enter= isc.ToolStripButtonExcel.create({
        click: function () {
            if (ListGrid_type_of_enter.getOriginalData().localData === undefined)
                createDialog("info", "ابتدا نمایش گزارش را انتخاب کنید");
            else
                ExportToFile.downloadExcelFromClient(ListGrid_type_of_enter, null, '', "گزارش آماری نحوه ورود افراد به کلاس");
        }
    });
    ToolStrip_Actions_type_of_enter= isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Excel_type_of_enter
                    ]
                })
            ]
    });

    organSegmentFilter_type_of_enter= init_OrganSegmentFilterDF(true, true, true, true, true, null, "complexTitle","assistant","affairs", "section", "unit");
    DynamicForm_type_of_enter= isc.DynamicForm.create({
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
                ID: "fromDate_type_of_enter",
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
                        displayDatePicker('fromDate_type_of_enter', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value === undefined || value == null) {
                        form.clearFieldErrors("toDate","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("fromDate", true);
                        dateCheck_Order_type_of_enter = true;
                        fromDateCheck_type_of_enter = true;
                        return;
                    }
                    let dateCheck;
                    let endDate = form.getValue("toDate");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        fromDateCheck_type_of_enter = false;
                        dateCheck_Order_type_of_enter = true;
                        form.clearFieldErrors("fromDate", true);
                        form.addFieldErrors("fromDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        dateCheck_Order_type_of_enter = false;
                        fromDateCheck_type_of_enter = true;
                        form.clearFieldErrors("fromDate", true);
                        form.addFieldErrors("fromDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    }
                    else {
                        fromDateCheck_type_of_enter = true;
                        dateCheck_Order_type_of_enter = true;
                        form.clearFieldErrors("fromDate", true);
                    }
                }
            },
            {
                name: "toDate",
                ID: "toDate_type_of_enter",
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
                        displayDatePicker('toDate_type_of_enter', this, 'ymd', '/', 'right');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value === undefined || value === null) {
                        form.clearFieldErrors("fromDate","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("toDate", true);
                        dateCheck_Order_type_of_enter = true;
                        toDateCheck_type_of_enter = true;
                        return;
                    }
                    let dateCheck;
                    dateCheck = checkDate(value);
                    let fromDate = form.getValue("fromDate");
                    if (dateCheck === false) {
                        toDateCheck_type_of_enter = false;
                        dateCheck_Order_type_of_enter = true;
                        form.clearFieldErrors("toDate", true);
                        form.addFieldErrors("toDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (fromDate !== undefined && value < fromDate) {
                        form.clearFieldErrors("toDate", true);
                        form.addFieldErrors("toDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        toDateCheck_type_of_enter = true;
                        dateCheck_Order_type_of_enter = false;
                    } else {
                        form.clearFieldErrors("toDate", true);
                        toDateCheck_type_of_enter = true;
                        dateCheck_Order_type_of_enter = true;
                    }
                }
            }
        ]
    });

    IButton_Show_type_of_enter= isc.IButtonSave.create({
        top: 260,
        title: "نمایش گزارش",
        width: 300,
        click: function () {
            if (!DynamicForm_type_of_enter.validate())
                return;
            ListGrid_type_of_enter.setData([]);
            Reporting_type_of_enter();
        }
    });
    IButton_Clear_type_of_enter= isc.IButtonSave.create({
        top: 260,
        title: "پاک کردن",
        width: 300,
        click: function () {
            DynamicForm_type_of_enter.clearValues();
            DynamicForm_type_of_enter.clearErrors();
            organSegmentFilter_type_of_enter.clearValues();
            ListGrid_type_of_enter.setData([]);
        }
    });
    HLayOut_Confirm_type_of_enter= isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Show_type_of_enter,
            IButton_Clear_type_of_enter
        ]
    });

    ListGrid_type_of_enter= isc.TrLG.create({
        filterOnKeypress: false,
        showFilterEditor: false,
        dataSource: RestDataSource_type_of_enter,
        gridComponents: ["filterEditor", "header", "body"],
        fields: [
            {name: "title", title: "نوع ورود به کلاس"},
            {name: "complex", title: "مجتمع"},
            {name: "baseOnComplex", title: "تعداد فراگیر براساس مجتمع"},
            {name: "assistant", title: "معاونت"},
            {name: "baseOnAssistant", title: "تعداد فراگیر براساس معاونت"},
            {name: "darsadMoavenatAzMojtame", title: "درصد معاونت از مجتمع"},
            {name: "affairs", title: "امور"},
            {name: "baseOnAffairs", title: "تعداد فراگیر براساس امور"},
            {name: "darsadOmorAzMoavenat", title: "درصد امور از معاونت"},
            {name: "darsadOmorAzMojtame", title: "درصد امور از مجتمع"}
        ]
    });

    VLayout_Body_type_of_enter= isc.VLayout.create({
        border: "2px solid blue",
        width: "100%",
        height: "100%",
        members: [
            ToolStrip_Actions_type_of_enter,
            organSegmentFilter_type_of_enter,
            DynamicForm_type_of_enter,
            HLayOut_Confirm_type_of_enter,
            ListGrid_type_of_enter
        ]
    });

    //---------------------------------------------------- Functions --------------------------------------------------------------//
    function Reporting_type_of_enter() {

        data_values_type_of_enter = null;
        data_values_type_of_enter = DynamicForm_type_of_enter.getValuesAsAdvancedCriteria();

        if (organSegmentFilter_type_of_enter.getCriteria() !== undefined) {
            reportCriteria_type_of_enter = organSegmentFilter_type_of_enter.getCriteria();
            for (let i = 0; i < reportCriteria_type_of_enter.criteria.size(); i++) {
                if (reportCriteria_type_of_enter.criteria[i].fieldName === "complexTitle") {
                    reportCriteria_type_of_enter.criteria[i].fieldName = "complex";
                    data_values_type_of_enter.criteria.add(reportCriteria_type_of_enter.criteria[i]);
                } else if (reportCriteria_type_of_enter.criteria[i].fieldName === "assistant") {
                    reportCriteria_type_of_enter.criteria[i].fieldName = "assistant";
                    data_values_type_of_enter.criteria.add(reportCriteria_type_of_enter.criteria[i]);
                } else if (reportCriteria_type_of_enter.criteria[i].fieldName === "affairs") {
                    reportCriteria_type_of_enter.criteria[i].fieldName = "affairs";
                    data_values_type_of_enter.criteria.add(reportCriteria_type_of_enter.criteria[i]);
                }
            }
        }

        ListGrid_type_of_enter.fetchData(data_values_type_of_enter);
    }

    //</script>
