<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    let fromDateCheck_number_of_specialized_courses = true;
    let toDateCheck_number_of_specialized_courses = true;
    let dateCheck_Order_number_of_specialized_courses = true;
    let reportCriteria_number_of_specialized_courses;
    let data_values_number_of_specialized_courses = null;

    //---------------------------------------------------- REST DataSources--------------------------------------------------------//
    RestDataSource_number_of_specialized_courses= isc.TrDS.create({
        fields: [
            {name: "title", title: "عنوان گروه"},
            {name: "complex", title: "مجتمع"},
            {name: "baseOnComplex", title: "تعداد کلاس براساس مجتمع"},
            {name: "assistant", title: "معاونت"},
            {name: "baseOnAssistant", title: "تعداد کلاس براساس معاونت"},
            {name: "darsadMoavenatAzMojtame", title: "درصد معاونت از مجتمع"},
            {name: "affairs", title: "امور"},
            {name: "baseOnAffairs", title: "تعداد کلاس براساس امور"},
            {name: "darsadOmorAzMoavenat", title: "درصد امور از معاونت"},
            {name: "darsadOmorAzMojtame", title: "درصد امور از مجتمع"}
        ],
        fetchDataURL: numberOfSpecializedCoursesReportUrl + "/iscList"
    });

    //---------------------------------------------------- Main Window--------------------------------------------------------------//
    ToolStripButton_Excel_number_of_specialized_courses= isc.ToolStripButtonExcel.create({
        click: function () {
            if (ListGrid_number_of_specialized_courses.getOriginalData().localData === undefined)
                createDialog("info", "ابتدا نمایش گزارش را انتخاب کنید");
            else
                ExportToFile.downloadExcelFromClient(ListGrid_number_of_specialized_courses, null, '', "گزارش آماری تعداد کلاس های تشکیل شده");
        }
    });
    ToolStrip_Actions_number_of_specialized_courses= isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Excel_number_of_specialized_courses
                    ]
                })
            ]
    });

    organSegmentFilter_number_of_specialized_courses= init_OrganSegmentFilterDF(true, true, true, true, true, null, "complexTitle","assistant","affairs", "section", "unit");
    DynamicForm_number_of_specialized_courses= isc.DynamicForm.create({
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
                ID: "fromDate_number_of_specialized_courses",
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
                        displayDatePicker('fromDate_number_of_specialized_courses', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value === undefined || value == null) {
                        form.clearFieldErrors("toDate","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("fromDate", true);
                        dateCheck_Order_number_of_specialized_courses = true;
                        fromDateCheck_number_of_specialized_courses = true;
                        return;
                    }
                    let dateCheck;
                    let endDate = form.getValue("toDate");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        fromDateCheck_number_of_specialized_courses = false;
                        dateCheck_Order_number_of_specialized_courses = true;
                        form.clearFieldErrors("fromDate", true);
                        form.addFieldErrors("fromDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        dateCheck_Order_number_of_specialized_courses = false;
                        fromDateCheck_number_of_specialized_courses = true;
                        form.clearFieldErrors("fromDate", true);
                        form.addFieldErrors("fromDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    }
                    else {
                        fromDateCheck_number_of_specialized_courses = true;
                        dateCheck_Order_number_of_specialized_courses = true;
                        form.clearFieldErrors("fromDate", true);
                    }
                }
            },
            {
                name: "toDate",
                ID: "toDate_number_of_specialized_courses",
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
                        displayDatePicker('toDate_number_of_specialized_courses', this, 'ymd', '/', 'right');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value === undefined || value === null) {
                        form.clearFieldErrors("fromDate","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("toDate", true);
                        dateCheck_Order_number_of_specialized_courses = true;
                        toDateCheck_number_of_specialized_courses = true;
                        return;
                    }
                    let dateCheck;
                    dateCheck = checkDate(value);
                    let fromDate = form.getValue("fromDate");
                    if (dateCheck === false) {
                        toDateCheck_number_of_specialized_courses = false;
                        dateCheck_Order_number_of_specialized_courses = true;
                        form.clearFieldErrors("toDate", true);
                        form.addFieldErrors("toDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (fromDate !== undefined && value < fromDate) {
                        form.clearFieldErrors("toDate", true);
                        form.addFieldErrors("toDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        toDateCheck_number_of_specialized_courses = true;
                        dateCheck_Order_number_of_specialized_courses = false;
                    } else {
                        form.clearFieldErrors("toDate", true);
                        toDateCheck_number_of_specialized_courses = true;
                        dateCheck_Order_number_of_specialized_courses = true;
                    }
                }
            }
        ]
    });

    IButton_Show_number_of_specialized_courses= isc.IButtonSave.create({
        top: 260,
        title: "نمایش گزارش",
        width: 300,
        click: function () {
            if (!DynamicForm_number_of_specialized_courses.validate())
                return;
            ListGrid_number_of_specialized_courses.setData([]);
            Reporting_number_of_specialized_courses();
        }
    });
    IButton_Clear_number_of_specialized_courses= isc.IButtonSave.create({
        top: 260,
        title: "پاک کردن",
        width: 300,
        click: function () {
            DynamicForm_number_of_specialized_courses.clearValues();
            DynamicForm_number_of_specialized_courses.clearErrors();
            organSegmentFilter_number_of_specialized_courses.clearValues();
            ListGrid_number_of_specialized_courses.setData([]);
        }
    });
    HLayOut_Confirm_number_of_specialized_courses= isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Show_number_of_specialized_courses,
            IButton_Clear_number_of_specialized_courses
        ]
    });

    ListGrid_number_of_specialized_courses= isc.TrLG.create({
        filterOnKeypress: false,
        showFilterEditor: false,
        dataSource: RestDataSource_number_of_specialized_courses,
        gridComponents: ["filterEditor", "header", "body"],
        fields: [
            {name: "title", title: "عنوان گروه"},
            {name: "complex", title: "مجتمع"},
            {name: "baseOnComplex", title: "تعداد کلاس براساس مجتمع"},
            {name: "assistant", title: "معاونت"},
            {name: "baseOnAssistant", title: "تعداد کلاس براساس معاونت"},
            {name: "darsadMoavenatAzMojtame", title: "درصد معاونت از مجتمع"},
            {name: "affairs", title: "امور"},
            {name: "baseOnAffairs", title: "تعداد کلاس براساس امور"},
            {name: "darsadOmorAzMoavenat", title: "درصد امور از معاونت"},
            {name: "darsadOmorAzMojtame", title: "درصد امور از مجتمع"}
        ]
    });

    VLayout_Body_number_of_specialized_courses= isc.VLayout.create({
        border: "2px solid blue",
        width: "100%",
        height: "100%",
        members: [
            ToolStrip_Actions_number_of_specialized_courses,
            organSegmentFilter_number_of_specialized_courses,
            DynamicForm_number_of_specialized_courses,
            HLayOut_Confirm_number_of_specialized_courses,
            ListGrid_number_of_specialized_courses
        ]
    });

    //---------------------------------------------------- Functions --------------------------------------------------------------//
    function Reporting_number_of_specialized_courses() {

        data_values_number_of_specialized_courses = null;
        data_values_number_of_specialized_courses = DynamicForm_number_of_specialized_courses.getValuesAsAdvancedCriteria();

        if (organSegmentFilter_number_of_specialized_courses.getCriteria() !== undefined) {
            reportCriteria_number_of_specialized_courses = organSegmentFilter_number_of_specialized_courses.getCriteria();
            for (let i = 0; i < reportCriteria_number_of_specialized_courses.criteria.size(); i++) {
                if (reportCriteria_number_of_specialized_courses.criteria[i].fieldName === "complexTitle") {
                    reportCriteria_number_of_specialized_courses.criteria[i].fieldName = "complex";
                    data_values_number_of_specialized_courses.criteria.add(reportCriteria_number_of_specialized_courses.criteria[i]);
                } else if (reportCriteria_number_of_specialized_courses.criteria[i].fieldName === "assistant") {
                    reportCriteria_number_of_specialized_courses.criteria[i].fieldName = "assistant";
                    data_values_number_of_specialized_courses.criteria.add(reportCriteria_number_of_specialized_courses.criteria[i]);
                } else if (reportCriteria_number_of_specialized_courses.criteria[i].fieldName === "affairs") {
                    reportCriteria_number_of_specialized_courses.criteria[i].fieldName = "affairs";
                    data_values_number_of_specialized_courses.criteria.add(reportCriteria_number_of_specialized_courses.criteria[i]);
                }
            }
        }

        ListGrid_number_of_specialized_courses.fetchData(data_values_number_of_specialized_courses);
    }

    //</script>
