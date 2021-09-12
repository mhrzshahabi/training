<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    //----------------------------------------------------Variables-----------------------------------------------------
    let reportCriteria_ULR = null;

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    RestDataSource_ULR = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "username", title: "<spring:message code="username"/>", filterOperator: "iContains"},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains"},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains"},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains"},
            {name: "createDate", title: "<spring:message code="date"/>", filterOperator: "iContains"},
            {name: "state", title: "<spring:message code="status"/>", valueMap: {LOGIN: "ورود", LOG_OUT: "خروج"}},
            {name: "hashToken", title: "HashToken", filterOperator: "iContains"}
        ],
        fetchDataURL: loginLogUrl + "/user/list"
    });

    //----------------------------------- layOut -----------------------------------------------------------------------
    ToolStripButton_Excel_ULR = isc.ToolStripButtonExcel.create({

        click: function () {
            makeExcelOutput();
        }
    });
    ToolStripButton_Refresh_ULR = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_ULR.invalidateCache();
        }
    });
    ToolStrip_Actions_ULR = isc.ToolStrip.create({
        width: "100%",
        height: "5%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_ULR,
                        ToolStripButton_Excel_ULR
                    ]
                })
            ]
    });

    DynamicForm_CriteriaForm_ULR = isc.DynamicForm.create({
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
                title: "بازه تاریخ: از",
                ID: "startDate_jspULR",
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
                        displayDatePicker('startDate_jspULR', this, 'ymd', '/');
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
                title: "بازه تاریخ: تا",
                ID: "endDate_jspULR",
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
                        displayDatePicker('endDate_jspULR', this, 'ymd', '/');
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

    IButton_Report_ULR = isc.IButtonSave.create({
        top: 260,
        title: "نمایش گزارش",
        width: 300,
        click: function () {

            reportCriteria_ULR = null;
            let form = DynamicForm_CriteriaForm_ULR;

            if(form.getValue("endDate") == null || form.getValue("startDate") == null) {
                createDialog("info","بازه تاریخ مشخص نشده است");
                return;
            }

            if(form.getValue("endDate") < form.getValue("startDate")) {
                createDialog("info","تاریخ پایان نمی تواند کوچکتر از تاریخ شروع باشد");
                return;
            }

            data_values = DynamicForm_CriteriaForm_ULR.getValuesAsAdvancedCriteria();

            for (let i = 0; i < data_values.criteria.size(); i++) {

                if (data_values.criteria[i].fieldName === "startDate") {
                    data_values.criteria[i].fieldName = "createDate";
                    data_values.criteria[i].operator = "greaterOrEqual";
                } else if (data_values.criteria[i].fieldName === "endDate") {
                    data_values.criteria[i].fieldName = "createDate";
                    data_values.criteria[i].operator = "lessOrEqual";
                }
            }

            reportCriteria_ULR = data_values;
            ListGrid_ULR.invalidateCache();
            ListGrid_ULR.fetchData(reportCriteria_ULR);
        }
    });
    IButton_Clear_ULR = isc.IButtonSave.create({
        top: 260,
        title: "پاک کردن",
        width: 300,
        click: function () {

            ListGrid_ULR.setData([]);
            DynamicForm_CriteriaForm_ULR.clearValues();
            DynamicForm_CriteriaForm_ULR.clearErrors();
            ListGrid_ULR.setFilterEditorCriteria(null);
        }
    });
    HLayOut_Confirm_ULR = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Report_ULR,
            IButton_Clear_ULR
        ]
    });

    ListGrid_ULR = isc.TrLG.create({
        height: "90%",
        filterOnKeypress: false,
        showFilterEditor: true,
        gridComponents: ["filterEditor", "header", "body"],
        dataSource: RestDataSource_ULR,
        initialSort: [
            {property: "createDate", direction: "descending"}
        ],
        fields: [
            {name: "username"},
            {name: "firstName"},
            {name: "lastName"},
            {name: "nationalCode"},
            {
                name: "createDate",
                canFilter: false,
                formatCellValue (value) {
                    if (value) {
                        let date = new Date (value);
                        return date.toBrowserLocaleString('fa-IR');
                    }
                }
            },
            {name: "state"}
        ]
    });

    VLayout_Body_ULR = isc.TrVLayout.create({
        border: "2px solid blue",
        padding: 20,
        members: [
            ToolStrip_Actions_ULR,
            DynamicForm_CriteriaForm_ULR,
            HLayOut_Confirm_ULR,
            ListGrid_ULR
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------
    function makeExcelOutput() {

        if (ListGrid_ULR.getData().localData.length === 0)
            createDialog("info", "داده ای برای خروجی اکسل وجود ندارد");
        else
            ExportToFile.downloadExcelRestUrl(null, ListGrid_ULR, loginLogUrl + "/user/excelList", 0, null, '',"گزارش ورود و خروج کاربران"  , reportCriteria_ULR, null);
    }

    // </script>