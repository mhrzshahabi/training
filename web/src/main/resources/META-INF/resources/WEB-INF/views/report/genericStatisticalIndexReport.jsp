<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    let fromDateCheck_GSIR = true;
    let toDateCheck_GSIR = true;
    let dateCheck_Order_GSIR = true;
    let reportCriteria_GSIR;
    let data_values_GSIR = null;

    //---------------------------------------------------- REST DataSources--------------------------------------------------------//
    RestDataSource_GSIR = isc.TrDS.create({
        fields: [
            {name: "complex", title: "مجتمع"},
            {name: "assistant", title: "معاونت"},
            {name: "affairs", title: "امور"},
            {name: "baseOnComplex", title: "نتیجه براساس مجتمع"},
            {name: "baseOnAssistant", title: "نتیجه براساس معاونت"},
            {name: "baseOnAffairs", title: "نتیجه براساس امور"}
        ],
        fetchDataURL: genericStatisticalIndexReportUrl + "/iscList"
    });

    //---------------------------------------------------- Main Window--------------------------------------------------------------//
    ToolStripButton_Excel_GSIR = isc.ToolStripButtonExcel.create({
        click: function () {
            if (ListGrid_GSIR.getOriginalData().localData === undefined)
                createDialog("info", "ابتدا نمایش گزارش را انتخاب کنید");
            else
                ExportToFile.downloadExcelFromClient(ListGrid_GSIR, null, '', "گزارش شاخص های آماری");
        }
    });
    ToolStrip_Actions_GSIR = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Excel_GSIR
                    ]
                })
            ]
    });

    organSegmentFilter_GSIR = init_OrganSegmentFilterDF(true, true, true, true, true, null, "complexTitle","assistant","affairs", "section", "unit");
    DynamicForm_GSIR = isc.DynamicForm.create({
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
                ID: "fromDate_GSIR",
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
                        displayDatePicker('fromDate_GSIR', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value === undefined || value == null) {
                        form.clearFieldErrors("toDate","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("fromDate", true);
                        dateCheck_Order_GSIR = true;
                        fromDateCheck_GSIR = true;
                        return;
                    }
                    let dateCheck;
                    let endDate = form.getValue("toDate");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        fromDateCheck_GSIR = false;
                        dateCheck_Order_GSIR = true;
                        form.clearFieldErrors("fromDate", true);
                        form.addFieldErrors("fromDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        dateCheck_Order_GSIR = false;
                        fromDateCheck_GSIR = true;
                        form.clearFieldErrors("fromDate", true);
                        form.addFieldErrors("fromDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    }
                    else {
                        fromDateCheck_GSIR = true;
                        dateCheck_Order_GSIR = true;
                        form.clearFieldErrors("fromDate", true);
                    }
                }
            },
            {
                name: "toDate",
                ID: "toDate_GSIR",
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
                        displayDatePicker('toDate_GSIR', this, 'ymd', '/', 'right');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value === undefined || value === null) {
                        form.clearFieldErrors("fromDate","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("toDate", true);
                        dateCheck_Order_GSIR = true;
                        toDateCheck_GSIR = true;
                        return;
                    }
                    let dateCheck;
                    dateCheck = checkDate(value);
                    let fromDate = form.getValue("fromDate");
                    if (dateCheck === false) {
                        toDateCheck_GSIR = false;
                        dateCheck_Order_GSIR = true;
                        form.clearFieldErrors("toDate", true);
                        form.addFieldErrors("toDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (fromDate !== undefined && value < fromDate) {
                        form.clearFieldErrors("toDate", true);
                        form.addFieldErrors("toDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        toDateCheck_GSIR = true;
                        dateCheck_Order_GSIR = false;
                    } else {
                        form.clearFieldErrors("toDate", true);
                        toDateCheck_GSIR = true;
                        dateCheck_Order_GSIR = true;
                    }
                }
            },
            {
                name: "reportType",
                title: "نوع شاخص",
                required: true,
                valueMap: {
                    "report01": "شاخص میزان کل نیازهای شناسایی شده",
                    "report02": "مجموع ساعات آموزش اجرا شده",
                    "report03": "سرانه انباشت سابقه آموزشی عمومی",
                    "report04": "سرانه انباشت سابقه آموزشی تخصصی",
                    "report05": "سرانه انباشت سابقه آموزشی مدیریتی",
                    "report06": " نرخ گذر آموزش",
                    "report07": " نرخ پوشش ارزشيابي سطح یادگیری",
                    "report08": "نسبت نیازهای آموزشی تخصصی",
                    "report09": "نسبت نیازهای آموزشی مهارتی",
                    "report10": "نرخ پوشش نیازسنجی فردی",

                }
            }
        ]
    });

    IButton_Show_GSIR = isc.IButtonSave.create({
        top: 260,
        title: "نمایش گزارش",
        width: 300,
        click: function () {
            if (!DynamicForm_GSIR.validate())
                return;
            ListGrid_GSIR.setData([]);
            Reporting_GSIR();
        }
    });
    IButton_Clear_GSIR = isc.IButtonSave.create({
        top: 260,
        title: "پاک کردن",
        width: 300,
        click: function () {
            DynamicForm_GSIR.clearValues();
            DynamicForm_GSIR.clearErrors();
            organSegmentFilter_GSIR.clearValues();
            ListGrid_GSIR.setData([]);
        }
    });
    HLayOut_Confirm_GSIR = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Show_GSIR,
            IButton_Clear_GSIR
        ]
    });

    ListGrid_GSIR = isc.TrLG.create({
        filterOnKeypress: false,
        showFilterEditor: false,
        dataSource: RestDataSource_GSIR,
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

    VLayout_Body_GSIR = isc.VLayout.create({
        border: "2px solid blue",
        width: "100%",
        height: "100%",
        members: [
            ToolStrip_Actions_GSIR,
            organSegmentFilter_GSIR,
            DynamicForm_GSIR,
            HLayOut_Confirm_GSIR,
            ListGrid_GSIR
        ]
    });

    //---------------------------------------------------- Functions --------------------------------------------------------------//
    function Reporting_GSIR() {

        data_values_GSIR = null;
        data_values_GSIR = DynamicForm_GSIR.getValuesAsAdvancedCriteria();

        if (organSegmentFilter_GSIR.getCriteria() !== undefined) {
            reportCriteria_GSIR = organSegmentFilter_GSIR.getCriteria();
            for (let i = 0; i < reportCriteria_GSIR.criteria.size(); i++) {
                if (reportCriteria_GSIR.criteria[i].fieldName === "complexTitle") {
                    reportCriteria_GSIR.criteria[i].fieldName = "complex";
                    data_values_GSIR.criteria.add(reportCriteria_GSIR.criteria[i]);
                } else if (reportCriteria_GSIR.criteria[i].fieldName === "assistant") {
                    reportCriteria_GSIR.criteria[i].fieldName = "assistant";
                    data_values_GSIR.criteria.add(reportCriteria_GSIR.criteria[i]);
                } else if (reportCriteria_GSIR.criteria[i].fieldName === "affairs") {
                    reportCriteria_GSIR.criteria[i].fieldName = "affairs";
                    data_values_GSIR.criteria.add(reportCriteria_GSIR.criteria[i]);
                }
            }
        }

        ListGrid_GSIR.fetchData(data_values_GSIR);
    }

    //</script>
