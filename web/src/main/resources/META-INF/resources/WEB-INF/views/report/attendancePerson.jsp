<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    let fromDateCheck_attendance_person = true;
    let toDateCheck_attendance_person = true;
    let dateCheck_Order_attendance_person = true;
    let reportCriteria_attendance_person;
    let data_values_attendance_person = null;

    //---------------------------------------------------- REST DataSources--------------------------------------------------------//
    RestDataSource_attendance_person= isc.TrDS.create({
        fields: [
            {name: "complex", title: "مجتمع"},
            {name: "baseOnComplex", title: "ساعات حضور  براساس مجتمع"},
            {name: "assistant", title: "معاونت"},
            {name: "baseOnAssistant", title: "ساعات حضور براساس معاونت"},
            {name: "darsadMoavenatAzMojtame", title: "درصد معاونت از مجتمع"},
            {name: "affairs", title: "امور"},
            {name: "baseOnAffairs", title: "ساعات حضور براساس امور"},
            {name: "darsadOmorAzMoavenat", title: "درصد امور از معاونت"},
            {name: "darsadOmorAzMojtame", title: "درصد امور از مجتمع"}
        ],
        fetchDataURL: attendancePersonUrl + "/iscList"
    });

    //---------------------------------------------------- Main Window--------------------------------------------------------------//
    ToolStripButton_Excel_attendance_person= isc.ToolStripButtonExcel.create({
        click: function () {
            if (ListGrid_attendance_person.getOriginalData().localData === undefined)
                createDialog("info", "ابتدا نمایش گزارش را انتخاب کنید");
            else
                ExportToFile.downloadExcelFromClient(ListGrid_attendance_person, null, '', "گزارش ساعت حضور فراگیران در کلاس");
        }
    });
    ToolStrip_Actions_attendance_person= isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Excel_attendance_person
                    ]
                })
            ]
    });

    organSegmentFilter_attendance_person= init_OrganSegmentFilterDF(true, true, true, true, true, null, "complexTitle","assistant","affairs", "section", "unit");
    DynamicForm_attendance_person= isc.DynamicForm.create({
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
                ID: "fromDate_attendance_person",
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
                        displayDatePicker('fromDate_attendance_person', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value === undefined || value == null) {
                        form.clearFieldErrors("toDate","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("fromDate", true);
                        dateCheck_Order_attendance_person = true;
                        fromDateCheck_attendance_person = true;
                        return;
                    }
                    let dateCheck;
                    let endDate = form.getValue("toDate");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        fromDateCheck_attendance_person = false;
                        dateCheck_Order_attendance_person = true;
                        form.clearFieldErrors("fromDate", true);
                        form.addFieldErrors("fromDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        dateCheck_Order_attendance_person = false;
                        fromDateCheck_attendance_person = true;
                        form.clearFieldErrors("fromDate", true);
                        form.addFieldErrors("fromDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    }
                    else {
                        fromDateCheck_attendance_person = true;
                        dateCheck_Order_attendance_person = true;
                        form.clearFieldErrors("fromDate", true);
                    }
                }
            },
            {
                name: "toDate",
                ID: "toDate_attendance_person",
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
                        displayDatePicker('toDate_attendance_person', this, 'ymd', '/', 'right');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value === undefined || value === null) {
                        form.clearFieldErrors("fromDate","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("toDate", true);
                        dateCheck_Order_attendance_person = true;
                        toDateCheck_attendance_person = true;
                        return;
                    }
                    let dateCheck;
                    dateCheck = checkDate(value);
                    let fromDate = form.getValue("fromDate");
                    if (dateCheck === false) {
                        toDateCheck_attendance_person = false;
                        dateCheck_Order_attendance_person = true;
                        form.clearFieldErrors("toDate", true);
                        form.addFieldErrors("toDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (fromDate !== undefined && value < fromDate) {
                        form.clearFieldErrors("toDate", true);
                        form.addFieldErrors("toDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        toDateCheck_attendance_person = true;
                        dateCheck_Order_attendance_person = false;
                    } else {
                        form.clearFieldErrors("toDate", true);
                        toDateCheck_attendance_person = true;
                        dateCheck_Order_attendance_person = true;
                    }
                }
            }
        ]
    });

    IButton_Show_attendance_person= isc.IButtonSave.create({
        top: 260,
        title: "نمایش گزارش",
        width: 300,
        click: function () {
            if (!DynamicForm_attendance_person.validate())
                return;
            ListGrid_attendance_person.setData([]);
            Reporting_attendance_person();
        }
    });
    IButton_Clear_attendance_person= isc.IButtonSave.create({
        top: 260,
        title: "پاک کردن",
        width: 300,
        click: function () {
            DynamicForm_attendance_person.clearValues();
            DynamicForm_attendance_person.clearErrors();
            organSegmentFilter_attendance_person.clearValues();
            ListGrid_attendance_person.setData([]);
        }
    });
    HLayOut_Confirm_attendance_person= isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Show_attendance_person,
            IButton_Clear_attendance_person
        ]
    });

    ListGrid_attendance_person= isc.TrLG.create({
        filterOnKeypress: false,
        showFilterEditor: false,
        dataSource: RestDataSource_attendance_person,
        gridComponents: ["filterEditor", "header", "body"],
        fields: [
            {name: "complex", title: "مجتمع"},
            {name: "baseOnComplex", title: "ساعات حضور  براساس مجتمع"},
            {name: "assistant", title: "معاونت"},
            {name: "baseOnAssistant", title: "ساعات حضور براساس معاونت"},
            {name: "darsadMoavenatAzMojtame", title: "درصد معاونت از مجتمع"},
            {name: "affairs", title: "امور"},
            {name: "baseOnAffairs", title: "ساعات حضور براساس امور"},
            {name: "darsadOmorAzMoavenat", title: "درصد امور از معاونت"},
            {name: "darsadOmorAzMojtame", title: "درصد امور از مجتمع"}
        ]
    });

    VLayout_Body_attendance_person= isc.VLayout.create({
        border: "2px solid blue",
        width: "100%",
        height: "100%",
        members: [
            ToolStrip_Actions_attendance_person,
            organSegmentFilter_attendance_person,
            DynamicForm_attendance_person,
            HLayOut_Confirm_attendance_person,
            ListGrid_attendance_person
        ]
    });

    //---------------------------------------------------- Functions --------------------------------------------------------------//
    function Reporting_attendance_person() {

        data_values_attendance_person = null;
        data_values_attendance_person = DynamicForm_attendance_person.getValuesAsAdvancedCriteria();

        if (organSegmentFilter_attendance_person.getCriteria() !== undefined) {
            reportCriteria_attendance_person = organSegmentFilter_attendance_person.getCriteria();
            for (let i = 0; i < reportCriteria_attendance_person.criteria.size(); i++) {
                if (reportCriteria_attendance_person.criteria[i].fieldName === "complexTitle") {
                    reportCriteria_attendance_person.criteria[i].fieldName = "complex";
                    data_values_attendance_person.criteria.add(reportCriteria_attendance_person.criteria[i]);
                } else if (reportCriteria_attendance_person.criteria[i].fieldName === "assistant") {
                    reportCriteria_attendance_person.criteria[i].fieldName = "assistant";
                    data_values_attendance_person.criteria.add(reportCriteria_attendance_person.criteria[i]);
                } else if (reportCriteria_attendance_person.criteria[i].fieldName === "affairs") {
                    reportCriteria_attendance_person.criteria[i].fieldName = "affairs";
                    data_values_attendance_person.criteria.add(reportCriteria_attendance_person.criteria[i]);
                }
            }
        }

        ListGrid_attendance_person.fetchData(data_values_attendance_person);
    }

    //</script>
