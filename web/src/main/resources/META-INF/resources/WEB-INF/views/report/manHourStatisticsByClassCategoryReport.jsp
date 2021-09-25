<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

//<script>
    var listData, listDataTwo;

    RestDataSource_ClassCategory_JspManHourReport = isc.TrDS.create({
        fields: [

            {name: "planningCount"},
            {name: "inProgressCount"},
            {name: "finishedCount"},
            {name: "canceledCount"},
            {name: "lockedCount"},
            {
                name: "providedTaughtPercent",
            },
            {
                name: "presenceManHour"
            },
            {
                name: "absenceManHour"
            },
            {
                name: "unknownManHour"
            },
            {
                name: "personnelCount"
            },
            {
                name: "studentCount"
            },
            {
                name: "participationPercent"
            },
            {
                name: "presencePerPerson"
            },
            {
                name: "classStatus"
            },
            {
                name: "category"
            },
            {
                name: "categoryId"
            },
        ],
        transformResponse: function (dsResponse, dsRequest, data) {
            wait.close();
            if (data && data.response) {
                listData = data.response.dataSumByStatus;
                dsResponse.data = listData;
            }
            return this.Super("transformResponse", arguments);
        }
    });

    RestDataSource_ClassCategoryTwo_JspManHourReport = isc.TrDS.create({
        fields: [
            {name: "planningCount"},
            {name: "inProgressCount"},
            {name: "finishedCount"},
            {name: "canceledCount"},
            {name: "lockedCount"},
            {name: "category"}
        ],
        transformResponse: function (dsResponse, dsRequest, data) {
            if (data && data.response) {
                listDataTwo = data.response.dataSumByStatus;
                dsResponse.data = listDataTwo;
            }
            return this.Super("transformResponse", arguments);
        }
    });

    var DynamicForm_ManHourByCatReport = isc.DynamicForm.create({
        numCols: 8,
        padding: 10,
        titleAlign: "left",
//colWidths: [300, 300, 300, 300, 300, 300, 100, 100],
        fields: [
            {
                name: "mojtameCode",
                type: "SelectItem",
                title: "<spring:message code='complex'/>",
                optionDataSource: isc.TrDS.create({
                    fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
                    cacheAllData: true,
                    fetchDataURL: departmentUrl + "/organ-segment-iscList/mojtame"
                }),
                operator: "inSet",
                valueField: "code",
                displayField: "title",
                filterOnKeypress: true,
                multiple: true,
// layoutStyle: "vertical",
                vAlign: "top",
                pickListFields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "title", title: "<spring:message code='title'/>", width: "60%", filterOperator: "iContains"},
                ],
                changed: function (form, item, value) {
                    form.setValue("omorCode", null);
                    form.setValue("moavenatCode", null);
                },
            },
            {
                name: "moavenatCode",
                type: "SelectItem",
                title: "<spring:message code='assistance'/>",
                optionDataSource: isc.TrDS.create({
                    fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
                    fetchDataURL: departmentUrl + "/organ-segment-iscList/moavenat"
                }),
                operator: "inSet",
                valueField: "code",
                displayField: "title",
                filterOnKeypress: true,
                multiple: true,
                autoFitButtons: true,
                vAlign: "top",
                criteriaHasChanged: false,
                pickListFields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "title", title: "<spring:message code='title'/>", filterOperator: "iContains", width: "60%"},
                ],
                click(form, item) {
                    if (this.criteriaHasChanged) {
                        this.fetchData();
                        this.criteriaHasChanged = false;
                    }
                },
                changed: function (form, item, value) {
                    form.setValue("mojtameCode", null);
                    form.setValue("omorCode", null);
                }
            },
            {
                name: "omorCode",
                type: "SelectItem",
                title: "<spring:message code='affairs'/>",
                optionDataSource: isc.TrDS.create({
                    fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
                    fetchDataURL: departmentUrl + "/organ-segment-iscList/omor"
                }),
                operator: "inSet",
                valueField: "code",
                displayField: "title",
                filterOnKeypress: true,
                multiple: true,
                autoFitButtons: true,
                vAlign: "top",
                criteriaHasChanged: false,
                pickListFields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "title", title: "<spring:message code='title'/>", filterOperator: "iContains", width: "60%"},
                ],
                click(form, item) {
                    if (this.criteriaHasChanged) {
                        this.fetchData();
                        this.criteriaHasChanged = false;
                    }
                },
                changed: function (form, item, value) {
                    form.setValue("mojtameCode", null);
                    form.setValue("moavenatCode", null);
                }
            },
            {
                type: "SpacerItem",
                colSpan: 2
            },
            {
                name: "dateType",
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
                        form.getItem("fromDate").hide();
                        form.getItem("toDate").hide();
                        form.setValue("fromDate", null);
                        form.setValue("toDate", null);
                    } else {
                        form.getItem("year").hide();
                        form.getItem("termId").hide();
                        form.setValue("year", null);
                        form.setValue("termId", null);
                        form.getItem("fromDate").show();
                        form.getItem("toDate").show();
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
                name: "fromDate",
                hidden: false,
                width: 200,
                titleColSpan: 1,
                title: "<spring:message code='from.date'/>",
                ID: "fromDate_jspManHourByCatReport",
                required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('fromDate_jspManHourByCatReport', this, 'ymd', '/');
                    }
                }],
                textAlign: "center",
                changed: function (form, item, value) {
                    var dateCheck;
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        form.addFieldErrors("fromDate", "<spring:message code='msg.correct.date'/>", true);
                    } else {
                        form.clearFieldErrors("fromDate", true);
                    }
                }
            },
            {
                name: "toDate",
                hidden: false,
                titleColSpan: 1,
                width: 200,
                title: "<spring:message code='to.date'/>",
                ID: "toDate_jspManHourByCatReport",
                type: 'text', required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('toDate_jspManHourByCatReport', this, 'ymd', '/');
                    }
                }],
                textAlign: "center",
// colSpan: 2,
                changed: function (form, item, value) {
                    let dateCheck;
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        form.clearFieldErrors("toDate", true);
                        form.addFieldErrors("toDate", "<spring:message code='msg.correct.date'/>", true);
                    } else {
                        form.clearFieldErrors("toDate", true);
                    }
                }
            },
            {
                type: "SpacerItem",
                colSpan: 2
            },
            {
                type: "SpacerItem",
                colSpan: 4
            },
            {
                name: "searchBtn",
                ID: "searchBtnJspManHourByCatReport",
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
                        let fromDate = form.getValue("fromDate");
                        let toDate = form.getValue("toDate");
                        if (form.getValue("dateType") == 2) {
                            if (form.getValue("termId") == null) {
                                fromDate = form.getValue("year") + "/01/01";
                                toDate = form.getValue("year") + "/12/29";
                            } else {
                                toDate = form.getItem("termId").getAllLocalOptions().filter(d => d.id == form.getValue("termId"))[0].endDate.trim();
                                fromDate = form.getItem("termId").getAllLocalOptions().filter(d => d.id == form.getValue("termId"))[0].startDate.trim();
                            }
                        }
                        let url = manHourStatisticsByClassCategoryReportUrl.concat("/list?fromDate=").concat(fromDate).concat("&toDate=").concat(toDate).concat("&omorCodes=");
                        if (form.getValue("omorCode")) url = url.concat(form.getValue("omorCode"));
                        url = url.concat("&moavenatCodes=");
                        if (form.getValue("moavenatCode")) url = url.concat(form.getValue("moavenatCode"));
                        url = url.concat("&mojtameCodes=");
                        if (form.getValue("mojtameCode")) url = url.concat(form.getValue("mojtameCode"));

                        RestDataSource_ClassCategory_JspManHourReport.fetchDataURL = url;
                        RestDataSource_ClassCategoryTwo_JspManHourReport.fetchDataURL = url.replace('/list?', '/summeryGroupByCategory?');

                        ListGrid_ManHourByCatReportJSP.invalidateCache();
                        ListGrid_ManHourByCatReportJSP.fetchData();
                        ListGrid_ByCatReportTwoJSP.invalidateCache();
                        ListGrid_ByCatReportTwoJSP.fetchData();
                        ManHour_Report_wait.close();
                        wait.show();
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
                    ListGrid_ManHourByCatReportJSP.setData([]);
                    ListGrid_ByCatReportTwoJSP.setData([]);
                    form.setValue("dateType", 1);
                    form.getItem("year").hide();
                    form.getItem("termId").hide();
                    form.setValue("year", null);
                    form.setValue("termId", null);
                    form.getItem("fromDate").show();
                    form.getItem("toDate").show();
                }
            },
        ],
        itemKeyPress: function (item, keyName) {
            if (keyName == "Enter") {
                searchBtnJspManHourReport.click(DynamicForm_ManHourByCatReport);
            }
        }
    });
    var RestDataSource_Term_JspManHourReport = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
        ]
    });
    var ListGrid_ManHourByCatReportJSP = isc.TrLG.create({
        ID: "ManHourByCatReportGrid",
        height: 500,
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
                            exportExcelByCat();
                        }
                    }),
                    isc.Label.create({
                        contents: "<span style='color: red; font-weight: bold; font-size: smaller;margin-top:5;margin-right:10'><spring:message code="report.statistics.by.class.category.warning.header.one"/></span>"
                    })
                ]
            })
            , "header", "filterEditor", "body"],
        dataSource: RestDataSource_ClassCategory_JspManHourReport,
        fields: [
            {
                name: "category", title: "<spring:message code='category'/>"
            },
            {
                name: "providedTaughtPercent",
                title: "<spring:message code='report.provided.taught.percent'/>"
            },
            {name: "planningCount", title: "<spring:message code='report.planning.class.count'/>"},
            {name: "inProgressCount", title: "<spring:message code='report.in.progress.class.count'/>"},
            {name: "finishedCount", title: "<spring:message code='report.finished.class.count'/>"},
            {name: "canceledCount", title: "<spring:message code='report.canceled.class.count'/>"},
            {name: "lockedCount", title: "<spring:message code='report.locked.class.count'/>"},
            {
                name: "presenceManHour",
                title: "<spring:message code='report.presence.man.hour'/>"
            },
            {
                name: "absenceManHour",
                title: "<spring:message code='report.absence.man.hour'/>"
            },
            {
                name: "unknownManHour",
                title: "<spring:message code='report.unknown.man.hour'/>", hidden: true
            },
            {
                name: "studentCount",
                title: "<spring:message code='report.student.count'/>"
            },
            {
                name: "participationPercent",
                type: "float",
                format: "00.00",
                title: "<spring:message code='report.participation.percent'/>"
            },
            {
                name: "presencePerPerson",
                title: "<spring:message code='report.presence.per.person'/>",
            },
        ]
    });

    var ListGrid_ByCatReportTwoJSP = isc.TrLG.create({
        ID: "ByCatReportTwoGrid",
        height: 550,
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
                            exportExcelByCatTwo();
                        }
                    }),
                    isc.Label.create({
                        contents: "<span style='color: red; font-weight: bold; font-size: smaller;margin-top:5;margin-right:10'><spring:message code="report.statistics.by.class.category.warning.header.two"/></span>"
                    })
                ]
            })
            , "header", "filterEditor", "body"],
        dataSource: RestDataSource_ClassCategoryTwo_JspManHourReport,
        fields: [
            {name: "category", title: "<spring:message code='category'/>"},
            {name: "planningCount", title: "<spring:message code='report.planning.class.count'/>"},
            {name: "inProgressCount", title: "<spring:message code='report.in.progress.class.count'/>"},
            {name: "finishedCount", title: "<spring:message code='report.finished.class.count'/>"},
            {name: "canceledCount", title: "<spring:message code='report.canceled.class.count'/>"},
            {name: "lockedCount", title: "<spring:message code='report.locked.class.count'/>"},
        ]
    });

    var VLayout_Body_ByCat = isc.VLayout.create({
        width: "100%",
        //  height: "100%",
        members: [
            DynamicForm_ManHourByCatReport,
            isc.VLayout.create({
                width: "100%",
                overflow: "auto",
                align: "top",
                members: [
                    ListGrid_ManHourByCatReportJSP,
                    ListGrid_ByCatReportTwoJSP
                ]
            })
        ]
    });

    function exportExcelByCat() {

        let detailFields = "category";
        let detailHeaders = '<spring:message code="category"/>';

        let masterData = {};
        let dateType = DynamicForm_ManHourByCatReport.getItem('dateType').getValue();
        if (dateType == 2) {
            let terms = DynamicForm_ManHourByCatReport.getItem('termId').getValueMap();
            masterData['<spring:message code="year"/>'] = DynamicForm_ManHourByCatReport.getItem('year').getValue();
            masterData['<spring:message code="term"/>'] = terms[DynamicForm_ManHourByCatReport.getItem('termId').getValue()];
        } else {
            masterData['<spring:message code="from.date"/>'] = DynamicForm_ManHourByCatReport.getItem('fromDate').getValue();
            masterData['<spring:message code="to.date"/>'] = DynamicForm_ManHourByCatReport.getItem('toDate').getValue();
        }
        let mojtameCode = DynamicForm_ManHourByCatReport.getItem('mojtameCode').getValue();
        if (mojtameCode) {
            masterData['<spring:message code="complex"/>'] = DynamicForm_ManHourByCatReport.getItem("mojtameCode").getDisplayValue().toString();
        }
        let moavenatCode = DynamicForm_ManHourByCatReport.getItem('moavenatCode').getValue();
        if (moavenatCode) {
            masterData['<spring:message code="assistance"/>'] = DynamicForm_ManHourByCatReport.getItem("moavenatCode").getDisplayValue().toString();
        }
        let omorCode = DynamicForm_ManHourByCatReport.getItem('omorCode').getValue();
        if (omorCode) {
            masterData['<spring:message code="affairs"/>'] = DynamicForm_ManHourByCatReport.getItem("omorCode").getDisplayValue().toString();
        }

        detailFields = detailFields.concat(",providedTaughtPercentStr,planningCount,inProgressCount,finishedCount,canceledCount,lockedCount");
        detailFields = detailFields.concat(",presenceManHourStr,absenceManHourStr,unknownManHourStr,studentCount,participationPercentStr,presencePerPersonStr");
        detailHeaders = detailHeaders.concat(',<spring:message code="report.provided.taught.percent"/>,<spring:message code="report.planning.class.count"/>,');
        detailHeaders = detailHeaders.concat('<spring:message code="report.in.progress.class.count"/>,<spring:message code="report.finished.class.count"/>,');
        detailHeaders = detailHeaders.concat('<spring:message code="report.canceled.class.count"/>,<spring:message code="report.locked.class.count"/>,');
        detailHeaders = detailHeaders.concat('<spring:message code="report.presence.man.hour"/>,<spring:message code="report.absence.man.hour"/>,<spring:message code="report.unknown.man.hour"/>,');
        detailHeaders = detailHeaders.concat('<spring:message code="report.student.count"/>,<spring:message code="report.participation.percent"/>,<spring:message code="report.presence.per.person"/>');

        let title = '<spring:message code="man.hour.statistics.by.class.category.report"/>';
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


    function exportExcelByCatTwo() {

        let detailFields = "category";
        let detailHeaders = '<spring:message code="category"/>';

        let masterData = {};
        let dateType = DynamicForm_ManHourByCatReport.getItem('dateType').getValue();
        if (dateType == 2) {
            let terms = DynamicForm_ManHourByCatReport.getItem('termId').getValueMap();
            masterData['<spring:message code="year"/>'] = DynamicForm_ManHourByCatReport.getItem('year').getValue();
            masterData['<spring:message code="term"/>'] = terms[DynamicForm_ManHourByCatReport.getItem('termId').getValue()];
        } else {
            masterData['<spring:message code="from.date"/>'] = DynamicForm_ManHourByCatReport.getItem('fromDate').getValue();
            masterData['<spring:message code="to.date"/>'] = DynamicForm_ManHourByCatReport.getItem('toDate').getValue();
        }
        let mojtameCode = DynamicForm_ManHourByCatReport.getItem('mojtameCode').getValue();
        if (mojtameCode) {
            masterData['<spring:message code="complex"/>'] = DynamicForm_ManHourByCatReport.getItem("mojtameCode").getDisplayValue().toString();
        }
        let moavenatCode = DynamicForm_ManHourByCatReport.getItem('moavenatCode').getValue();
        if (moavenatCode) {
            masterData['<spring:message code="assistance"/>'] = DynamicForm_ManHourByCatReport.getItem("moavenatCode").getDisplayValue().toString();
        }
        let omorCode = DynamicForm_ManHourByCatReport.getItem('omorCode').getValue();
        if (omorCode) {
            masterData['<spring:message code="affairs"/>'] = DynamicForm_ManHourByCatReport.getItem("omorCode").getDisplayValue().toString();
        }

        detailFields = detailFields.concat(",planningCount,inProgressCount,finishedCount,canceledCount,lockedCount");
        detailHeaders = detailHeaders.concat(',<spring:message code="report.planning.class.count"/>,');
        detailHeaders = detailHeaders.concat('<spring:message code="report.in.progress.class.count"/>,<spring:message code="report.finished.class.count"/>,');
        detailHeaders = detailHeaders.concat('<spring:message code="report.canceled.class.count"/>,<spring:message code="report.locked.class.count"/>');

        let title = '<spring:message code="man.hour.statistics.by.class.category.report"/>';
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

        downloadForm.setValue("masterData", JSON.stringify(masterData));
        downloadForm.setValue("detailFields", detailFields);
        downloadForm.setValue("detailHeaders", detailHeaders);
        downloadForm.setValue("detailData", JSON.stringify(listDataTwo));
        downloadForm.setValue("title", title);
        downloadForm.setValue("detailDto", "com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO$ClassSumByStatus");
        downloadForm.show();
        downloadForm.submitForm();
    }


    //</script>