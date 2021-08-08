<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

//<script>


    var RestDataSource_Term_JspManHourReport = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
        ]
    });

    RestDataSource_ManHourReport = isc.TrDS.create({
        fields: [
            {
                name: "mojtameTitle",
                title: "<spring:message code="complex"/>",
                filterOperator: "iContains",
            },
            {
                name: "presenceManHour",
                title: "<spring:message code='report.presence.man.hour'/>", filterOperator: "iContains",
            },
            {
                name: "absenceManHour",
                title: "<spring:message code='report.absence.man.hour'/>", filterOperator: "equals",
            },
            {
                name: "personnelCount",
                title: "<spring:message code='report.department.personnel.count'/>",
                filterOperator: "iContains",
            },
            {
                name: "participationPercent",
                format: "00.00",
                title: "<spring:message code='report.participation.percent'/>", filterOperator: "iContains",
            },
            {
                name: "presencePerPerson",
                title: "<spring:message code='report.presence.per.person'/>", filterOperator: "iContains",
            },
        ],
        transformResponse: function (dsResponse, dsRequest, data) {
            criteriaInHeader = data.response.criteriaStr;
            return this.Super("transformResponse", arguments);
        },
        fetchDataURL: manHourStatisticsPerDepartmentReportUrl
    });
    var DynamicForm_CriteriaForm_ManHourReport = isc.DynamicForm.create({
        numCols: 8,
        padding: 10,
        titleAlign: "left",
        fields: [
            {
                name: "timeStatus",
                title: "<spring:message code='date.selection.type'/>",
                defaultValue: 1,
                valueMap: {
                    "1": "<spring:message code='date.from.to.date'/>",
                    "2": "<spring:message code='date.year.month'/>"
                },
                changed: function (form, item, value) {
                    if (value == 2) {
                        form.getItem("year").show();
                        form.getItem("termId").show();
                        form.getItem("startDate").hide();
                        form.getItem("endDate").hide();
                        form.setValue("startDate", null);
                        form.setValue("endDate", null);
                    } else {
                        form.getItem("year").hide();
                        form.getItem("termId").hide();
                        form.setValue("year", null);
                        form.setValue("termId", null);
                        form.getItem("startDate").show();
                        form.getItem("endDate").show();
                    }
                }
            },
            {
                name: "year",
                hidden: true,
                required: true,
                title: "<spring:message code='year'/>",
                displayField: "year",
                valueField: "year",
                optionDataSource: isc.TrDS.create({
                    fields: [
                        {name: "year"}
                    ],
                    fetchDataURL: termUrl + "years",
                    autoFetchData: true
                }),
                filterFields: ["year"],
                sortField: ["year"],
                sortDirection: "descending",
                useClientFiltering: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                },
                pickListFields: [
                    {
                        name: "year",
                        title: "<spring:message code='year'/>",
                        filterOperator: "iContains",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9]"
                        }
                    }
                ],
                changed: function (form, item, value) {
                    if (value != null && value != undefined) {
                        RestDataSource_Term_JspManHourReport.fetchDataURL = termUrl + "listByYear/" + value;
                        form.getField("termId").optionDataSource = RestDataSource_Term_JspManHourReport;
                        form.getField("termId").fetchData();
                        form.getField("termId").enable();
                        form.getField("termId").clearValue();
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
                hidden: true,
                multiple: false,
                filterOperator: "equals",
                disabled: true,
                valueField: "id",
                displayField: "titleFa",
                filterLocally: true,
                cachePickListResults: true
            },
            {
                name: "startDate",
                hidden: false,
                width: 200,
                titleColSpan: 1,
                title: "<spring:message code='from.date'/>",
                ID: "startDate_jspManHourByDep",
                required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate_jspManHourByDep', this, 'ymd', '/');
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
                name: "endDate",
                hidden: false,
                titleColSpan: 1,
                width: 200,
                title: "<spring:message code='to.date'/>",
                ID: "endDate_jspManHourByDep",
                type: 'text', required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate_jspManHourByDep', this, 'ymd', '/');
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
                type: "SpacerItem",
                colSpan: 2
            },
            {
                name: "classStatus",
                title: "<spring:message code="class.status"/>",
                type: "SelectItem",
                operator: "inSet",
                required: true,
                multiple: true,
                valueMap: {
                    "1": "برنامه ریزی",
                    "2": "در حال اجرا",
                    "3": "پایان یافته",
                    "4": "لغو شده",
                    "5": "اختتام",
                },
                pickListProperties: {
                    showFilterEditor: false
                },
                defaultValue: ["1", "2", "3", "4", "5"]
            },
            {
                type: "SpacerItem",
                colSpan: 2
            },
            {
                name: "searchBtn",
                ID: "searchBtnJspManHourByDep",
                title: "<spring:message code="search"/>",
                type: "ButtonItem",
                width: "*",
                startRow: false,
                endRow: false,
                width: 200,
                click(form) {
                    form.validate();
                    if (form.hasErrors()) {
                        return
                    }
                    var ManHour_Report_wait = createDialog("wait");
                    setTimeout(function () {
                        if (DynamicForm_CriteriaForm_ManHourReport.getValuesAsAdvancedCriteria().criteria.size() <= 1) {
                            createDialog("info", "فیلتری انتخاب نشده است.");
                            return;
                        }

                        DynamicForm_CriteriaForm_ManHourReport.validate();
                        if (DynamicForm_CriteriaForm_ManHourReport.hasErrors()) {
                            return;
                        } else {
                            data_values = DynamicForm_CriteriaForm_ManHourReport.getValuesAsAdvancedCriteria();
                            for (var i = 0; i < data_values.criteria.size(); i++) {
                                if (data_values.criteria[i].fieldName == "startDate") {
                                    data_values.criteria[i].fieldName = "startDate";
                                    data_values.criteria[i].operator = "greaterOrEqual";
                                } else if (data_values.criteria[i].fieldName == "endDate") {
                                    data_values.criteria[i].fieldName = "endDate";
                                    data_values.criteria[i].operator = "lessOrEqual";
                                } else if (data_values.criteria[i].fieldName == "year") {
                                    data_values.criteria[i].fieldName = "year";
                                    data_values.criteria[i].operator = "iContains";
                                } else if (data_values.criteria[i].fieldName == "termId") {
                                    data_values.criteria[i].fieldName = "termId";
                                    data_values.criteria[i].operator = "equals";
                                } else if (data_values.criteria[i].fieldName == "classStatus") {
                                    data_values.criteria[i].fieldName = "classStatus";
                                    data_values.criteria[i].operator = "inSet";
                                }
                            }

                            ListGrid_ManHourMojtameReport.invalidateCache();
                            ListGrid_ManHourMojtameReport.fetchData(data_values);
                        }
                        ManHour_Report_wait.close();
                    }, 100);
                }
            },
            {
                name: "clearBtn",
                title: "<spring:message code="clear"/>",
                type: "ButtonItem",
                width: "*",
                startRow: false,
                endRow: false,
                width: 200,
                click(form, item) {
                    form.clearValues();
                    form.clearErrors();
                    ListGrid_ManHourMojtameReport.setData([]);
                    form.setValue("timeStatus", 1);
                    form.getItem("year").hide();
                    form.getItem("termId").hide();
                    form.setValue("year", null);
                    form.setValue("termId", null);
                    form.getItem("startDate").show();
                    form.getItem("endDate").show();
                }
            },
            {
                type: "SpacerItem",
                colSpan: 2
            },
        ],
    });
    var ListGrid_ManHourMojtameReport = isc.TrLG.create({
        ID: "ManHourByDepReportGrid",
        height: "100%",
        overflow: "auto",
        filterOnKeypress: false,
        showFilterEditor: false,
        gridComponents: [
            isc.HLayout.create({
                alignment: 'right',
                align: "right",
                members: [
                    isc.ToolStripButtonExcel.create({
                        click: function () {
                            exportExcelBy("complex", Object.assign([], ListGrid_ManHourMojtameReport.data.localData));
                        }
                    }),
                ]
            })
            , "header", "filterEditor", "body"],
        dataSource: RestDataSource_ManHourReport,
        canExpandRecords: true,
        canExpandMultipleRecords: false,
        fields: [
            {
                name: "mojtameTitle",
                title: "<spring:message code="complex"/>",
                filterOperator: "iContains",
            },
            {
                name: "presenceManHour",
                title: "<spring:message code='report.presence.man.hour'/>", filterOperator: "iContains",
            },
            {
                name: "absenceManHour",
                title: "<spring:message code='report.absence.man.hour'/>", filterOperator: "equals",
            },
            {
                name: "personnelCount",
                title: "<spring:message code='report.department.personnel.count'/>",
                filterOperator: "iContains",
            },
            {
                name: "participationPercent",
                format: "00.00",
                title: "<spring:message code='report.participation.percent'/>", filterOperator: "iContains",
            },
            {
                name: "presencePerPerson",
                title: "<spring:message code='report.presence.per.person'/>", filterOperator: "iContains",
            },
        ],
        getExpansionComponent: function (record, rowNum, colNum) {
            if (record.mojtameCode) {
                let crit = Object.assign({}, DynamicForm_CriteriaForm_ManHourReport.getValuesAsAdvancedCriteria());
                crit.criteria.push({fieldName: "mojtameCode", operator: "equals", value: record.mojtameCode});
                return getCcpAssistantGrid(crit);
            } else return isc.VLayout.create({
                padding: 8,
                backgroundColor: "#92aaba",
                members: []
            });
            ;
        },

    });

    function getCcpAssistantGrid(crit) {
        let assistanceDetail = isc.TrLG.create({
            height: "400",
            padding: 4,
            backgroundColor: "#acd1e8",
            canExpandRecords: true,
            canExpandMultipleRecords: false,
            gridComponents: [
                isc.HLayout.create({
                    alignment: 'right',
                    align: "right",
                    members: [
                        isc.ToolStripButtonExcel.create({
                            click: function () {
                                exportExcelBy("assistant", Object.assign([], this.parentElement.parentElement.data.localData));
                            }
                        }),
                    ]
                })
                , "header", "filterEditor", "body"],
            getCellCSSText: function () {
                return "background-color:#acd1e8;color:black;font-size: 12px;";
            },
            filterOnKeypress: false,
            showFilterEditor: false,
            fields: [
                {
                    name: "moavenatTitle",
                    title: "<spring:message code='assistance'/>",
                    filterOperator: "iContains",
                },
                {
                    name: "presenceManHour",
                    title: "<spring:message code='report.presence.man.hour'/>", filterOperator: "iContains",
                },
                {
                    name: "absenceManHour",
                    title: "<spring:message code='report.absence.man.hour'/>", filterOperator: "equals",
                },
                {
                    name: "personnelCount",
                    title: "<spring:message code='report.department.personnel.count'/>",
                    filterOperator: "iContains",
                },
                {
                    name: "participationPercent",
                    format: "00.00",
                    title: "<spring:message code='report.participation.percent'/>", filterOperator: "iContains",
                },
                {
                    name: "presencePerPerson",
                    title: "<spring:message code='report.presence.per.person'/>", filterOperator: "iContains",
                },
            ],
            dataSource: isc.TrDS.create({fetchDataURL: manHourStatisticsPerDepartmentReportUrl}),
            getExpansionComponent: function (record, rowNum, colNum) {
                let crit = Object.assign({}, DynamicForm_CriteriaForm_ManHourReport.getValuesAsAdvancedCriteria());
                crit.criteria.push({fieldName: "ccpAssistant", operator: "equals", value: record.moavenatCode});
                return getCcpAffairsGrid(crit);
            },
        });
        assistanceDetail.invalidateCache();
        assistanceDetail.fetchData(crit);
        return isc.VLayout.create({
            padding: 4,
            backgroundColor: "#92aaba",
            members: [assistanceDetail]
        });
    }

    function getCcpAffairsGrid(crit) {
        let affairsDetail = isc.TrLG.create({
            height: "250",
            padding: 4,
            filterOnKeypress: false,
            showFilterEditor: false,
            backgroundColor: "#d7b5dc",
            dataSource: isc.TrDS.create({fetchDataURL: manHourStatisticsPerDepartmentReportUrl}),
            gridComponents: [
                isc.HLayout.create({
                    alignment: 'right',
                    align: "right",
                    members: [
                        isc.ToolStripButtonExcel.create({
                            click: function () {
                                exportExcelBy("affairs", Object.assign([], this.parentElement.parentElement.data.localData));
                            }
                        }),
                    ]
                })
                , "header", "filterEditor", "body"],
            getCellCSSText: function () {
                return "background-color:#d7b5dc;color:black;font-size: 12px;";
            },
            fields: [
                {
                    name: "omorTitle",
                    title: "<spring:message code="affairs"/>",
                },
                {
                    name: "presenceManHour",
                    title: "<spring:message code='report.presence.man.hour'/>", filterOperator: "iContains",
                },
                {
                    name: "absenceManHour",
                    title: "<spring:message code='report.absence.man.hour'/>", filterOperator: "equals",
                },
                {
                    name: "personnelCount",
                    title: "<spring:message code='report.department.personnel.count'/>",
                    filterOperator: "iContains",
                },
                {
                    name: "participationPercent",
                    format: "00.00",
                    title: "<spring:message code='report.participation.percent'/>", filterOperator: "iContains",
                },
                {
                    name: "presencePerPerson",
                    title: "<spring:message code='report.presence.per.person'/>", filterOperator: "iContains",
                },
            ],
        });
        affairsDetail.invalidateCache();
        affairsDetail.fetchData(crit);
        return isc.VLayout.create({
            padding: 4,
            backgroundColor: "#a491a7",
            members: [affairsDetail]
        });
    }

    var VLayout_Body_ByCat = isc.VLayout.create({
        width: "100%",
        members: [
            DynamicForm_CriteriaForm_ManHourReport,
            isc.VLayout.create({
                width: "100%",
                overflow: "auto",
                align: "top",
                members: [
                    ListGrid_ManHourMojtameReport,
                ]
            })
        ]
    });

    function exportExcelBy(by, listData) {
        let detailFields = (by == "complex" ? "mojtameTitle" : (by == "assistant" ? "moavenatTitle" : "omorTitle"));
        let detailHeaders = (by == "complex" ? '<spring:message code="complex"/>' : (by == "assistant" ? '<spring:message code="assistance"/>' : '<spring:message code="affairs"/>'));

        let masterData = {};
        let timeStatus = DynamicForm_CriteriaForm_ManHourReport.getItem('timeStatus').getValue();
        if (timeStatus == 2) {
            let terms = DynamicForm_CriteriaForm_ManHourReport.getItem('termId').getValueMap();
            masterData['<spring:message code="year"/>'] = DynamicForm_CriteriaForm_ManHourReport.getItem('year').getValue();
            masterData['<spring:message code="term"/>'] = terms[DynamicForm_CriteriaForm_ManHourReport.getItem('termId').getValue()];
        } else {
            masterData['<spring:message code="to.date"/>'] = DynamicForm_CriteriaForm_ManHourReport.getItem('endDate').getValue();
            masterData['<spring:message code="from.date"/>'] = DynamicForm_CriteriaForm_ManHourReport.getItem('startDate').getValue();
        }

        detailFields = detailFields.concat(",presenceManHourStr,absenceManHourStr,unknownManHourStr,personnelCount,studentCount,participationPercentStr,presencePerPersonStr");
        detailHeaders = detailHeaders.concat(',<spring:message code="report.presence.man.hour"/>,<spring:message code="report.absence.man.hour"/>,<spring:message code="report.unknown.man.hour"/>,<spring:message code="report.department.personnel.count"/>');
        detailHeaders = detailHeaders.concat(',<spring:message code="report.student.count"/>,<spring:message code="report.participation.percent"/>,<spring:message code="report.presence.per.person"/>');

        let title = '<spring:message code="man.hour.statistics.per.department.report"/>';
        let downloadForm = isc.DynamicForm.create({
            method: "POST",
            action: "/training/reportsToExcel/masterDetail",
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "masterData", type: "hidden"},
                    {name: "detailFields", type: "hidden"},
                    {name: "detailHeaders", type: "hidden"},
                    {name: "detailDto", type: "hidden"},
                    {name: "title", type: "hidden"},
                    {name: "detailData", type: "hidden"},
                ]
        });
        listData.forEach(d => d.participationPercentStr = d.participationPercent);
        listData.forEach(d => d.presenceManHourStr = d.presenceManHour);
        listData.forEach(d => d.absenceManHourStr = d.absenceManHour);
        listData.forEach(d => d.unknownManHourStr = d.unknownManHour);
        listData.forEach(d => d.presencePerPersonStr = d.presencePerPerson);
        listData.forEach(d => d.providedTaughtPercentStr = d.providedTaughtPercent);

        downloadForm.setValue("masterData", JSON.stringify(masterData));
        downloadForm.setValue("detailFields", detailFields);
        downloadForm.setValue("detailHeaders", detailHeaders);
        downloadForm.setValue("detailData", JSON.stringify(listData));
        downloadForm.setValue("title", title);
        downloadForm.setValue("detailDto", "com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO$ClassSumByStatus");
        downloadForm.show();
        downloadForm.submitForm();

    }

    //</script>