<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

//<script>


    //----------------------------------------------------Rest DataSource-----------------------------------------------

    CompanyDS_PresenceReport = isc.TrDS.create({
        fields: [
            {
                name: "value",
                title: "<spring:message code="company"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                primaryKey: true
            },
        ],
        cacheAllData: true,
        fetchDataURL: personnelUrl + "/all-field-values?fieldName=companyName"
    });

    ComplexDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=complexTitle"
    });

    AssistantDS_PresenceReport = isc.TrDS.create({
        fields: [
            {
                name: "value",
                title: "<spring:message code="assistance"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpAssistant"
    });

    AffairsDS_PresenceReport = isc.TrDS.create({
        fields: [
            {name: "value", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/all-field-values?fieldName=ccpAffairs"
    });

    var RestDataSource_Term_ManHourReport = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
        ]
    });

    var RestDataSource_Year_ManHourReport = isc.TrDS.create({
        fields: [
            {name: "year", primaryKey: true}
        ],
        fetchDataURL: termUrl + "yearList"
    });


    //---------------------------------------------------- variables -----------------------------------------------
    var organizationFilter = init_OrganSegmentFilterDF_optional(false, true, null, "complexTitle", "ccpAssistant", "ccpAffairs", null, null, false, false, false, true, true);

    var startDate1Check_JspStaticalUnitReport = true;
    var startDate2Check_JspStaticalUnitReport = true;
    var startDateCheck_Order_JspStaticalUnitReport = true;
    var criteriaInHeader = "";

    //----------------------------------------------------Criteria Form------------------------------------------------

    var DynamicForm_CriteriaForm_ManHourReport = isc.DynamicForm.create({
        align: "right",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 4,
        colWidths: ["5%", "25%", "5%", "25%", "5%", "25%"],
        fields: [
            {
                name: "timeStatus",
                title: "<spring:message code="man.hour.report.time.type"/>",
                type: "SelectItem",
                operator: "inSet",
                required: true,
                multiple: false,
                valueMap: {
                    "1": "گزارش بر اساس تاریخ شروع و پایان",
                    "2": "گزارش بر اساس سال و ترم",
                },
                pickListProperties: {
                    showFilterEditor: false
                },
                defaultValue: ["1"],
                changed: function (form, item, value) {
                    if (value != null && value != undefined) {
                        if (value == 2) {
                            DynamicForm_CriteriaForm_ManHourReport.getField("fromDate").hide();
                            DynamicForm_CriteriaForm_ManHourReport.getField("toDate").hide();
                            DynamicForm_CriteriaForm_ManHourReport.setValue("fromDate", "");
                            DynamicForm_CriteriaForm_ManHourReport.setValue("toDate", "");
                            DynamicForm_CriteriaForm_ManHourReport.getField("classYear").show();
                            DynamicForm_CriteriaForm_ManHourReport.getField("termId").show();
                        } else if (value == 1) {
                            DynamicForm_CriteriaForm_ManHourReport.getField("classYear").hide();
                            DynamicForm_CriteriaForm_ManHourReport.getField("termId").hide();
                            DynamicForm_CriteriaForm_ManHourReport.getField("classYear").clearValue();
                            DynamicForm_CriteriaForm_ManHourReport.getField("termId").clearValue();
                            DynamicForm_CriteriaForm_ManHourReport.setValue("fromDate", oneMonthBeforeToday);
                            DynamicForm_CriteriaForm_ManHourReport.setValue("toDate", todayDate);
                            DynamicForm_CriteriaForm_ManHourReport.getField("fromDate").show();
                            DynamicForm_CriteriaForm_ManHourReport.getField("toDate").show();
                        }
                    } else {
                        DynamicForm_CriteriaForm_ManHourReport.getField("classYear").hide();
                        DynamicForm_CriteriaForm_ManHourReport.getField("termId").hide();
                        DynamicForm_CriteriaForm_ManHourReport.getField("classYear").clearValue();
                        DynamicForm_CriteriaForm_ManHourReport.getField("termId").clearValue();
                        DynamicForm_CriteriaForm_ManHourReport.setValue("fromDate", oneMonthBeforeToday);
                        DynamicForm_CriteriaForm_ManHourReport.setValue("toDate", todayDate);
                        DynamicForm_CriteriaForm_ManHourReport.getField("fromDate").show();
                        DynamicForm_CriteriaForm_ManHourReport.getField("toDate").show();
                    }
                }
            },
            {type: "SpacerItem"},
            {
                name: "fromDate",
                ID: "fromDate_ManHourStatisticReport",
                title: "از تاریخ: ",
                hint: oneMonthBeforeToday,
                defaultValue: oneMonthBeforeToday,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('fromDate_ManHourStatisticReport', this, 'ymd', '/', 'right');
                    }
                }],
                editorExit: function (form, item, value) {
                    if (value == undefined || value == null) {
                        form.clearFieldErrors("toDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        form.clearFieldErrors("fromDate", true);
                        startDateCheck_Order_JspStaticalUnitReport = true;
                        startDate1Check_JspStaticalUnitReport = true;
                        return;
                    }

                    var dateCheck;
                    var endDate = form.getValue("toDate");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        startDate1Check_JspStaticalUnitReport = false;
                        startDateCheck_Order_JspStaticalUnitReport = true;
                        form.clearFieldErrors("fromDate", true);
                        form.addFieldErrors("fromDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        startDateCheck_Order_JspStaticalUnitReport = false;
                        startDate1Check_JspStaticalUnitReport = true;
                        form.clearFieldErrors("fromDate", true);
                        form.addFieldErrors("fromDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    } else {
                        startDate1Check_JspStaticalUnitReport = true;
                        startDateCheck_Order_JspStaticalUnitReport = true;
                        form.clearFieldErrors("fromDate", true);
                    }
                }
            },
            {
                name: "toDate",
                ID: "toDate_ManHourStatisticReport",
                title: "تا",
                hint: todayDate,
                defaultValue: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('toDate_ManHourStatisticReport', this, 'ymd', '/', 'right');
                    }
                }],
                editorExit: function (form, item, value) {
                    if (value == undefined || value == null) {
                        form.clearFieldErrors("fromDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                        form.clearFieldErrors("toDate", true);
                        startDateCheck_Order_JspStaticalUnitReport = true;
                        startDate2Check_JspStaticalUnitReport = true;
                        return;
                    }

                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("fromDate");
                    if (dateCheck === false) {
                        startDate2Check_JspStaticalUnitReport = false;
                        startDateCheck_Order_JspStaticalUnitReport = true;
                        form.clearFieldErrors("toDate", true);
                        form.addFieldErrors("toDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (startDate != undefined && value < startDate) {
                        form.clearFieldErrors("toDate", true);
                        form.addFieldErrors("toDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        startDate2Check_JspStaticalUnitReport = true;
                        startDateCheck_Order_JspStaticalUnitReport = false;
                    } else {
                        form.clearFieldErrors("toDate", true);
                        startDate2Check_JspStaticalUnitReport = true;
                        startDateCheck_Order_JspStaticalUnitReport = true;
                    }
                }
            },
            {
                name: "classYear",
                title: "سال کاری",
                type: "SelectItem",
                multiple: true,
                optionDataSource: RestDataSource_Year_ManHourReport,
                valueField: "year",
                displayField: "year",
                filterFields: ["year"],
                hidden: true,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                changed: function (form, item, value) {
                    if (value != null && value != undefined && value.size() == 1) {
                        RestDataSource_Term_ManHourReport.fetchDataURL = termUrl + "listByYear/" + value[0];
                        DynamicForm_CriteriaForm_ManHourReport.getField("termId").optionDataSource = RestDataSource_Term_ManHourReport;
                        DynamicForm_CriteriaForm_ManHourReport.getField("termId").fetchData();
                        DynamicForm_CriteriaForm_ManHourReport.getField("termId").enable();
                    } else {
                        form.getField("termId").disabled = true;
                        form.getField("termId").clearValue();
                    }
                }
            },
            {
                name: "termId",
                title: "ترم",
                type: "SelectItem",
                // multiple: true,
                filterOperator: "equals",
                disabled: true,
                hidden: true,
                valueField: "id",
                displayField: "titleFa",
                filterLocally: true
            },
            {
                name: "classStatus",
                title: "<spring:message code="class.status"/>",
                type: "SelectItem",
                operator: "inSet",
                required: true,
                multiple: true,
                valueMap: {
                    "1": "برنامه ريزی",
                    "2": "در حال اجرا",
                    "3": "پایان یافته",
                },
                pickListProperties: {
                    showFilterEditor: false
                },
                defaultValue: ["1", "2", "3"]
            },

        ]
    });


    IButton_ManHourReport = isc.IButtonSave.create({
        top: 260,
        title: "چاپ گزارش",
        width: 300,
        click: function () {

            if (DynamicForm_CriteriaForm_ManHourReport.getValuesAsAdvancedCriteria().criteria.size() <= 1 ||
                (organizationFilter.getCriteria(DynamicForm_CriteriaForm_ManHourReport.getValuesAsAdvancedCriteria())).criteria.length <= 1) {
                createDialog("info", "فیلتری انتخاب نشده است.");
                return;
            }

            DynamicForm_CriteriaForm_ManHourReport.validate();
            if (DynamicForm_CriteriaForm_ManHourReport.hasErrors() || organizationFilter.hasErrors()) {
                return;
            } else {
                data_values = organizationFilter.getCriteria(DynamicForm_CriteriaForm_ManHourReport.getValuesAsAdvancedCriteria());
                ListGrid_ManHourReport.showField("moavenatTitle");
                ListGrid_ManHourReport.showField("mojtameTitle");
                for (var i = 0; i < data_values.criteria.size(); i++) {
                    if (data_values.criteria[i].fieldName == "complexTitle") {
                        data_values.criteria[i].fieldName = "complexTitle";
                        data_values.criteria[i].operator = "inSet";
                        ListGrid_ManHourReport.hideField("mojtameTitle");
                        criteriaInHeader += DynamicForm_CriteriaForm_ManHourReport.getField("termId");
                    } else if (data_values.criteria[i].fieldName == "applicantCompanyName") {
                        data_values.criteria[i].fieldName = "applicantCompanyName";
                        data_values.criteria[i].operator = "iContains";
                    } else if (data_values.criteria[i].fieldName == "ccpAssistant") {
                        data_values.criteria[i].fieldName = "ccpAssistant";
                        data_values.criteria[i].operator = "inSet";
                        ListGrid_ManHourReport.hideField("moavenatTitle");
                        ListGrid_ManHourReport.hideField("mojtameTitle");

                    } else if (data_values.criteria[i].fieldName == "ccpAffairs") {
                        data_values.criteria[i].fieldName = "ccpAffairs";
                        data_values.criteria[i].operator = "inSet";
                        ListGrid_ManHourReport.hideField("moavenatTitle");
                        ListGrid_ManHourReport.hideField("mojtameTitle");
                    } else if (data_values.criteria[i].fieldName == "fromDate") {
                        //todo change the parameter for class sections
                        data_values.criteria[i].fieldName = "startDate";
                        data_values.criteria[i].operator = "greaterOrEqual";
                    } else if (data_values.criteria[i].fieldName == "toDate") {
                        //todo change the parameter for class sections
                        data_values.criteria[i].fieldName = "endDate";
                        data_values.criteria[i].operator = "lessOrEqual";
                    } else if (data_values.criteria[i].fieldName == "year") {
                        data_values.criteria[i].fieldName = "year";
                        data_values.criteria[i].operator = "iContains";
                    } else if (data_values.criteria[i].fieldName == "termId") {
                        data_values.criteria[i].fieldName = "termId";
                        data_values.criteria[i].operator = "equals";
                    }
                }

                ListGrid_ManHourReport.invalidateCache();
                ListGrid_ManHourReport.fetchData(data_values);
                Window_ManHourReport.show();

            }
        }
    });

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    RestDataSource_ManHourReport = isc.TrDS.create({
        fields: [
            {
                name: "mojtameTitle",
                title: "<spring:message code="complex"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "moavenatTitle",
                title: "<spring:message code='assistance'/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "omorTitle",
                title: "<spring:message code="affairs"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },

            {
                name: "presenceManHour",
                title: "نفرساعت حضور", filterOperator: "iContains", autoFitWidth: true
            },
            {
                name: "absenceManHour",
                title: "نفرساعت حذف و غیبت", filterOperator: "equals", autoFitWidth: true
            },
            {
                name: "personnelCount",
                title: "تعداد کل پرسنل دپارتمان",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "participationPercent",
                format: "00.00",
                title: "درصد مشارکت", filterOperator: "iContains", autoFitWidth: true
            },
            {
                name: "presencePerPerson",
                title: "سرانه", filterOperator: "iContains", autoFitWidth: true
            },

        ],
        transformResponse: function (dsResponse, dsRequest, data) {
            criteriaInHeader = data.response.criteriaStr;
            return this.Super("transformResponse", arguments);
        },
        fetchDataURL: manHourStatisticsPerDepartmentReportUrl
    });

    //----------------------------------------------------ListGrid Result-----------------------------------------------

    var ListGrid_ManHourReport = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_ManHourReport,
        gridComponents: [
            "filterEditor", "header", "body"
        ],
        cellHeight: 43,
        sortField: 0,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        selectionType: "single",
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        initialSort: [
            {property: "studentId", direction: "ascending", primarySort: true}
        ],
    });

    IButton_ManHourReport_FullExcel = isc.IButtonSave.create({
        top: 260,
        title: "گزارش اکسل",
        width: 300,
        click: function () {
            ExportToFile.downloadExcelRestUrl(null, ListGrid_ManHourReport, manHourStatisticsPerDepartmentReportUrl, 0, null, '', "گزارش آمار نفر ساعت بر اساس دپارتمان", ListGrid_ManHourReport.data.getCriteria(), null);
        }
    });

    var HLayOut_CriteriaForm_ManHourReport_Details = isc.TrHLayoutButtons.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "100%",
        alignLayout: "center",
        members: [
            ListGrid_ManHourReport
        ]
    });
    var HLayOut_Confirm_ManHourReport_UnitExcel = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_ManHourReport_FullExcel
        ]
    });

    var Window_ManHourReport = isc.Window.create({
        placement: "fillScreen",
        title: "گزارش آمار نفر ساعت بر اساس دپارتمان",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [
            isc.TrVLayout.create({
                members: [
                    HLayOut_CriteriaForm_ManHourReport_Details, HLayOut_Confirm_ManHourReport_UnitExcel
                ]
            })
        ],
        closeClick: function () {
            this.close();
        },
        close: function () {
            this.Super("close", arguments);

        }
    });

    //----------------------------------- layOut -----------------------------------------------------------------------

    var HLayOut_Confirm_ManHourReport = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "70%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_ManHourReport
        ]
    });

    var VLayout_Body_JspUnitReport = isc.TrVLayout.create({
        members: [
            organizationFilter,
            DynamicForm_CriteriaForm_ManHourReport,
            HLayOut_Confirm_ManHourReport
        ]
    });

//</script>
