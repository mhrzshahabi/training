<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>

// <script>

    //----------------------------------------------------Variables-----------------------------------------------------
    let reportCriteria_Cost_REFR = null;
    //----------------------------------------------------Default Rest--------------------------------------------------

    //----------------------------------------------------Rest DataSource-----------------------------------------------


    RestDataSource_Cost_REFR = isc.TrDS.create({
        fields: [
            { name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "classCode", title: "<spring:message code="class.code"/>", filterOperator: "iContains"},
            {name: "classTitle", title: "<spring:message code="class.title"/>", filterOperator: "iContains"},
            {name: "teacher", title: "استاد", filterOperator: "iContains"},
            {name: "teacherNationalCode", title: "کد ملی استاد", filterOperator: "iContains"},
            {name: "isPersonnel", title: "نوع استاد", filterOperator: "iContains"},
            {name: "startDate", title: "<spring:message code="start.date"/>", filterOperator: "iContains"},
            {name: "endDate", title: "<spring:message code="end.date"/>", filterOperator: "iContains"},
            {name: "acceptanceLimit", title: "حد قبولی کلاس", filterOperator: "iContains"},
            {name: "courseCode", title: "کد دوره", filterOperator: "iContains"},
            {name: "courseTitle", title: "عنوان دوره", filterOperator: "iContains"},
            {name: "complex", title: "مجتمع", filterOperator: "iContains"},
            {name: "moavenat", title: "معاونت", filterOperator: "iContains"},
            {name: "omor", title: "امور", filterOperator: "iContains"},
            {name: "totalStudent", title: "تعداد دانشجویان کلاس", filterOperator: "iContains"},
            {name: "studentCost", title: "هزینه هر دانشجو", filterOperator: "iContains"},
            {name: "currency", title: "واحد", filterOperator: "iContains"},
            {name: "cost", title: "هزینه کلی", filterOperator: "iContains"},

        ],
        fetchDataURL: viewClassCostReportUrl + "/iscList",
    });

    //----------------------------------------------------Criteria Form------------------------------------------------
    ToolStripButton_Excel_Cost_REFR = isc.ToolStripButtonExcel.create({
        click: function () {
            makeExcelCost();
        }
    });
    ToolStripButton_Refresh_Cost_REFR = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Cost_REFR.invalidateCache();
        }
    });
    ToolStrip_Actions_Cost_REFR = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_Cost_REFR,
                        ToolStripButton_Excel_Cost_REFR
                    ]
                })
            ]
    });

    DynamicForm_CriteriaForm_Cost_REFR = isc.DynamicForm.create({
        align: "right",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 6,
        colWidths: ["10%", "25%", "25%", "10%", "25%", "25%"],
        fields: [
            {
                name: "startDate",
                title: "بازه کلاس: شروع از",
                ID: "startDate_jspCER_cost",
                colSpan: 1,
                titleColSpan: 1,
                required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate_jspCER_cost', this, 'ymd', '/');
                    }
                }],
                textAlign: "center",
                changed: function (form, item, value) {
                    var dateCheck;
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        form.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                    } else {
                        form.clearFieldErrors("startDate", true);
                    }
                }
            },
            {
                colSpan: 1,
                name: "temp1",
                canEdit: false,
                showTitle: false
            },
            {
                name: "endDate",
                title: "بازه کلاس: پایان تا",
                ID: "endDate_jspCER_cost",
                colSpan: 1,
                titleColSpan: 1,
                type: 'text',
                required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate_jspCER_cost', this, 'ymd', '/');
                    }
                }],
                textAlign: "center",
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
                colSpan: 1,
                name: "temp2",
                canEdit: false,
                showTitle: false
            }
        ]
    });


    IButton_Report_Cost_REFR = isc.IButtonSave.create({
        top: 260,
        title: "نمایش گزارش",
        width: 300,
        click: function () {

            reportCriteria_Cost_REFR = null;
            let form = DynamicForm_CriteriaForm_Cost_REFR;

            if(form.getValue("endDate") == null || form.getValue("startDate") == null) {
                createDialog("info","بازه کلاس مشخص نشده است");
                return;
            }

            if(form.getValue("endDate") < form.getValue("startDate")) {
                createDialog("info","تاریخ پایان نمی تواند کوچکتر از تاریخ شروع باشد");
                return;
            }

            data_values = DynamicForm_CriteriaForm_Cost_REFR.getValuesAsAdvancedCriteria();

            for (let i = 0; i < data_values.criteria.size(); i++) {

               if (data_values.criteria[i].fieldName === "startDate") {
                    data_values.criteria[i].fieldName = "startDate";
                    data_values.criteria[i].operator = "greaterOrEqual";
                } else if (data_values.criteria[i].fieldName === "endDate") {
                    data_values.criteria[i].fieldName = "endDate";
                    data_values.criteria[i].operator = "lessOrEqual";
                }
            }


            reportCriteria_Cost_REFR = data_values;
            ListGrid_Cost_REFR.invalidateCache();
            ListGrid_Cost_REFR.fetchData(reportCriteria_Cost_REFR);
        }
    });
    IButton_Clear_Cost_REFR = isc.IButtonSave.create({
        top: 260,
        title: "پاک کردن",
        width: 300,
        click: function () {

            ListGrid_Cost_REFR.setData([]);
            DynamicForm_CriteriaForm_Cost_REFR.clearValues();
            DynamicForm_CriteriaForm_Cost_REFR.clearErrors();
            ListGrid_Cost_REFR.setFilterEditorCriteria(null);
        }
    });

    //----------------------------------- layOut -----------------------------------------------------------------------
    var VLayOut_CriteriaForm_Cost_REFR = isc.VLayout.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        members: [
            DynamicForm_CriteriaForm_Cost_REFR

        ]
    });
    var HLayOut_Confirm_Cost_REFR = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Report_Cost_REFR,
            IButton_Clear_Cost_REFR
        ]
    });
    var ListGrid_Cost_REFR = isc.TrLG.create({
        height: "70%",
        dataPageSize: 1000,
        filterOnKeypress: false,
        showFilterEditor: true,
        gridComponents: ["filterEditor", "header", "body"],
        dataSource: RestDataSource_Cost_REFR,
        fields: [
            {name: "classCode"},
            {name: "classTitle"},
            {name: "teacher"},
            {name: "teacherNationalCode"},
            {name: "isPersonnel"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "acceptanceLimit"},
            {name: "courseCode"},
            {name: "courseTitle"},
            {name: "complex"},
            {name: "moavenat"},
            {name: "omor"},
            {name: "totalStudent"},
            {name: "studentCost"},
            {name: "currency"},
            {name: "cost"},



        ]
    });
    var VLayout_Body_Cost_REFR = isc.TrVLayout.create({
        border: "2px solid blue",
        padding: 20,
        members: [
            ToolStrip_Actions_Cost_REFR,
            VLayOut_CriteriaForm_Cost_REFR,
            HLayOut_Confirm_Cost_REFR,
            ListGrid_Cost_REFR
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------
    //
    function makeExcelCost() {
        if (ListGrid_Cost_REFR.getOriginalData().localData === undefined)
            createDialog("info", "ابتدا نمایش گزارش را انتخاب کنید");
        else
            ExportToFile.downloadExcelRestUrl(null, ListGrid_Cost_REFR, viewClassCostReportUrl + "/iscList", 0, null, '',"گزارش هزینه کلاس ها"  , reportCriteria_Cost_REFR, null);

        // if (ListGrid_Cost_REFR.getOriginalData().localData === undefined)
        //     createDialog("info", "ابتدا چاپ گزارش را انتخاب کنید");
        // else {
        //     let records = ListGrid_Cost_REFR.data.localData.toArray();
        //     excelData = [];
        //     excelData.add({
        //         classCode: "کد کلاس",
        //         classTitle: "عنوان کلاس",
        //         teacher: "استاد ",
        //         teacherNationalCode: "کد ملی استاد",
        //         isPersonnel: "نوع استاد",
        //         startDate: "تاریخ شروع",
        //         endDate: "تاریخ پایان",
        //         acceptanceLimit: "حد قبولی کلاس",
        //         courseCode: "کد دوره",
        //         courseTitle: "عنوان دوره",
        //         complex: "مجتمع",
        //         moavenat: "معاونت",
        //         omor: "امور",
        //         totalStudent: "تعداد دانشجویان کلاس",
        //         studentCost: "هزینه هر دانشجو",
        //         currency: "واحد",
        //         cost: "هزینه کلی",
        //     });
        //
        //     if(records) {
        //         for (let j = 0; j < records.length; j++) {
        //             excelData.add({
        //                 rowNum: j+1,
        //                 classCode: records[j].classCode,
        //                 classTitle: records[j].classTitle,
        //                 teacher: records[j].teacher,
        //                 teacherNationalCode: records[j].teacherNationalCode,
        //                 isPersonnel: records[j].isPersonnel,
        //                 startDate: records[j].startDate,
        //                 endDate: records[j].endDate,
        //                 acceptanceLimit: records[j].acceptanceLimit,
        //                 courseCode: records[j].courseCode,
        //                 courseTitle: records[j].courseTitle,
        //                 complex: records[j].complex,
        //                 moavenat: records[j].moavenat,
        //                 omor: records[j].omor,
        //                 totalStudent: records[j].totalStudent,
        //                 studentCost: records[j].studentCost,
        //                 currency: records[j].currency,
        //                 cost: records[j].cost
        //             });
        //
        //         }
        //     }
        //     let fields = [
        //         {name: "id"},
        //         {name: "classCode"},
        //         {name: "classTitle"},
        //         {name: "teacher"},
        //         {name: "teacherNationalCode"},
        //         {name: "isPersonnel"},
        //         {name: "startDate"},
        //         {name: "endDate"},
        //         {name: "acceptanceLimit"},
        //         {name: "courseCode"},
        //         {name: "courseTitle"},
        //         {name: "complex"},
        //         {name: "moavenat"},
        //         {name: "omor"},
        //         {name: "totalStudent"},
        //         {name: "studentCost"},
        //         {name: "currency"},
        //         {name: "cost"}
        //     ];
        //     ExportToFile.exportToExcelFromClient(fields, excelData, "", "گزارش هزینه کلاس ها ", null);
        // }
    }
    // </script>