<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    let fromDateCheckـnumber_of_specialized_courses = true;
    let toDateCheckـnumber_of_specialized_courses = true;
    let dateCheck_Orderـnumber_of_specialized_courses = true;
    let reportCriteriaـnumber_of_specialized_courses;
    let data_valuesـnumber_of_specialized_courses = null;

    //---------------------------------------------------- REST DataSources--------------------------------------------------------//
    RestDataSourceـnumber_of_specialized_courses= isc.TrDS.create({
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
    ToolStripButton_Excelـnumber_of_specialized_courses= isc.ToolStripButtonExcel.create({
        click: function () {
            if (ListGridـnumber_of_specialized_courses.getOriginalData().localData === undefined)
                createDialog("info", "ابتدا نمایش گزارش را انتخاب کنید");
            else
                ExportToFile.downloadExcelFromClient(ListGridـnumber_of_specialized_courses, null, '', "گزارش آماری نحوه ورود افراد به کلاس");
        }
    });
    ToolStrip_Actionsـnumber_of_specialized_courses= isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Excelـnumber_of_specialized_courses
                    ]
                })
            ]
    });

    organSegmentFilterـnumber_of_specialized_courses= init_OrganSegmentFilterDF(true, true, true, true, true, null, "complexTitle","assistant","affairs", "section", "unit");
    DynamicFormـnumber_of_specialized_courses= isc.DynamicForm.create({
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
                ID: "fromDateـnumber_of_specialized_courses",
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
                        displayDatePicker('fromDateـnumber_of_specialized_courses', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value === undefined || value == null) {
                        form.clearFieldErrors("toDate","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("fromDate", true);
                        dateCheck_Orderـnumber_of_specialized_courses = true;
                        fromDateCheckـnumber_of_specialized_courses = true;
                        return;
                    }
                    let dateCheck;
                    let endDate = form.getValue("toDate");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        fromDateCheckـnumber_of_specialized_courses = false;
                        dateCheck_Orderـnumber_of_specialized_courses = true;
                        form.clearFieldErrors("fromDate", true);
                        form.addFieldErrors("fromDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        dateCheck_Orderـnumber_of_specialized_courses = false;
                        fromDateCheckـnumber_of_specialized_courses = true;
                        form.clearFieldErrors("fromDate", true);
                        form.addFieldErrors("fromDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    }
                    else {
                        fromDateCheckـnumber_of_specialized_courses = true;
                        dateCheck_Orderـnumber_of_specialized_courses = true;
                        form.clearFieldErrors("fromDate", true);
                    }
                }
            },
            {
                name: "toDate",
                ID: "toDateـnumber_of_specialized_courses",
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
                        displayDatePicker('toDateـnumber_of_specialized_courses', this, 'ymd', '/', 'right');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value === undefined || value === null) {
                        form.clearFieldErrors("fromDate","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("toDate", true);
                        dateCheck_Orderـnumber_of_specialized_courses = true;
                        toDateCheckـnumber_of_specialized_courses = true;
                        return;
                    }
                    let dateCheck;
                    dateCheck = checkDate(value);
                    let fromDate = form.getValue("fromDate");
                    if (dateCheck === false) {
                        toDateCheckـnumber_of_specialized_courses = false;
                        dateCheck_Orderـnumber_of_specialized_courses = true;
                        form.clearFieldErrors("toDate", true);
                        form.addFieldErrors("toDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (fromDate !== undefined && value < fromDate) {
                        form.clearFieldErrors("toDate", true);
                        form.addFieldErrors("toDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        toDateCheckـnumber_of_specialized_courses = true;
                        dateCheck_Orderـnumber_of_specialized_courses = false;
                    } else {
                        form.clearFieldErrors("toDate", true);
                        toDateCheckـnumber_of_specialized_courses = true;
                        dateCheck_Orderـnumber_of_specialized_courses = true;
                    }
                }
            }
        ]
    });

    IButton_Showـnumber_of_specialized_courses= isc.IButtonSave.create({
        top: 260,
        title: "نمایش گزارش",
        width: 300,
        click: function () {
            if (!DynamicFormـnumber_of_specialized_courses.validate())
                return;
            ListGridـnumber_of_specialized_courses.setData([]);
            Reportingـnumber_of_specialized_courses();
        }
    });
    IButton_Clearـnumber_of_specialized_courses= isc.IButtonSave.create({
        top: 260,
        title: "پاک کردن",
        width: 300,
        click: function () {
            DynamicFormـnumber_of_specialized_courses.clearValues();
            DynamicFormـnumber_of_specialized_courses.clearErrors();
            organSegmentFilterـnumber_of_specialized_courses.clearValues();
            ListGridـnumber_of_specialized_courses.setData([]);
        }
    });
    HLayOut_Confirmـnumber_of_specialized_courses= isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Showـnumber_of_specialized_courses,
            IButton_Clearـnumber_of_specialized_courses
        ]
    });

    ListGridـnumber_of_specialized_courses= isc.TrLG.create({
        filterOnKeypress: false,
        showFilterEditor: false,
        dataSource: RestDataSourceـnumber_of_specialized_courses,
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

    VLayout_Bodyـnumber_of_specialized_courses= isc.VLayout.create({
        border: "2px solid blue",
        width: "100%",
        height: "100%",
        members: [
            ToolStrip_Actionsـnumber_of_specialized_courses,
            organSegmentFilterـnumber_of_specialized_courses,
            DynamicFormـnumber_of_specialized_courses,
            HLayOut_Confirmـnumber_of_specialized_courses,
            ListGridـnumber_of_specialized_courses
        ]
    });

    //---------------------------------------------------- Functions --------------------------------------------------------------//
    function Reportingـnumber_of_specialized_courses() {

        data_valuesـnumber_of_specialized_courses = null;
        data_valuesـnumber_of_specialized_courses = DynamicFormـnumber_of_specialized_courses.getValuesAsAdvancedCriteria();

        if (organSegmentFilterـnumber_of_specialized_courses.getCriteria() !== undefined) {
            reportCriteriaـnumber_of_specialized_courses = organSegmentFilterـnumber_of_specialized_courses.getCriteria();
            for (let i = 0; i < reportCriteriaـnumber_of_specialized_courses.criteria.size(); i++) {
                if (reportCriteriaـnumber_of_specialized_courses.criteria[i].fieldName === "complexTitle") {
                    reportCriteriaـnumber_of_specialized_courses.criteria[i].fieldName = "complex";
                    data_valuesـnumber_of_specialized_courses.criteria.add(reportCriteriaـnumber_of_specialized_courses.criteria[i]);
                } else if (reportCriteriaـnumber_of_specialized_courses.criteria[i].fieldName === "assistant") {
                    reportCriteriaـnumber_of_specialized_courses.criteria[i].fieldName = "assistant";
                    data_valuesـnumber_of_specialized_courses.criteria.add(reportCriteriaـnumber_of_specialized_courses.criteria[i]);
                } else if (reportCriteriaـnumber_of_specialized_courses.criteria[i].fieldName === "affairs") {
                    reportCriteriaـnumber_of_specialized_courses.criteria[i].fieldName = "affairs";
                    data_valuesـnumber_of_specialized_courses.criteria.add(reportCriteriaـnumber_of_specialized_courses.criteria[i]);
                }
            }
        }

        ListGridـnumber_of_specialized_courses.fetchData(data_valuesـnumber_of_specialized_courses);
    }

    //</script>
