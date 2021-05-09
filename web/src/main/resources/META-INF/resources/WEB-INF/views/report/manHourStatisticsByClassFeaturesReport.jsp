<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

//<script>
    var allData;

    RestDataSource_Class_JspManHourReport = isc.TrDS.create({
        fields: [
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
                name: "classTeachingType"
            },
            {
                name: "classStatus"
            },
            {
                name: "courseTechnicalType"
            },
            {
                name: "courseRunType"
            },
            {
                name: "courseTheoType"
            },
            {
                name: "courseLevelType"
            },
            {
                name: "mojtameCode"
            },
            {
                name: "mojtameTitle"
            },
            {
                name: "moavenatCode"
            },
            {
                name: "moavenatTitle"
            },
            {
                name: "omorCode"
            },
            {
                name: "omorTitle"
            },
            {
                name: "ghesmatCode"
            },
            {
                name: "ghesmatTitle"
            },
        ],
        transformResponse: function (dsResponse, dsRequest, data) {
            if (data && data.response) {
                allData = data.response.allData;
                dsResponse.data = allData[Object.keys(allData)[0]];
                dsResponse.startRow = 0;
                dsResponse.endRow = dsResponse.data.length;
                dsResponse.totalRows = dsResponse.data.length;
            }
            return this.Super("transformResponse", arguments);
        }
    });

    var DynamicForm_ManHourReport = isc.DynamicForm.create({
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
                multiple: false,
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
                multiple: false,
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
                multiple: false,
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
                        RestDataSource_Term_JspUnitReport.fetchDataURL = termUrl + "listByYear/" + value;
                        form.getField("termId").optionDataSource = RestDataSource_Term_JspUnitReport;
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
                ID: "fromDate_jspManHourReport",
                required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('fromDate_jspManHourReport', this, 'ymd', '/');
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
                ID: "toDate_jspManHourReport",
                type: 'text', required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('toDate_jspManHourReport', this, 'ymd', '/');
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
                name: "groupByType",
                title: "<spring:message code='report.pivot'/>",
                required: true,
//width: 200,
//defaultValue: 5,
                textAlign: "center",
                multiple: true,
                valueMap: {
                    "CLASS_STATUS": "<spring:message code='class.status'/>",
                    "CLASS_TEACHING_TYPE": "<spring:message code='class.teaching.type'/>",
                    "COURSE_TECHNICAL_TYPE": "<spring:message code='course.technicalType'/>",
                    "COURSE_RUN_TYPE": "<spring:message code='course.run.type'/>",
                    "COURSE_THEO_TYPE": "<spring:message code='course_etheoType'/>",
                    "COURSE_LEVEL_TYPE": "<spring:message code='cousre_elevelType'/>",
                }
            },
            {
                type: "SpacerItem",
                colSpan: 2
            },
            {
                name: "searchBtn",
                ID: "searchBtnJspManHourReport",
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
                    hideColumns();
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
                        let url = manHourStatisticsByClassFeaturesReportUrl.concat("/list?fromDate=").concat(fromDate).concat("&toDate=").concat(toDate)
                            .concat("&groupBys=").concat(form.getValue("groupByType")).concat("&omorCode=");
                        if (form.getValue("omorCode")) url = url.concat(form.getValue("omorCode"));
                        url = url.concat("&moavenatCode=");
                        if (form.getValue("moavenatCode")) url = url.concat(form.getValue("moavenatCode"));
                        url = url.concat("&mojtameCode=");
                        if (form.getValue("mojtameCode")) url = url.concat(form.getValue("mojtameCode"));

                        RestDataSource_Class_JspManHourReport.fetchDataURL = url;

                        ListGrid_ManHourReportJSP.invalidateCache();
                        ListGrid_ManHourReportJSP.fetchData();
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
                    ListGrid_ManHourReportJSP.setData([]);
                }
            },
        ],
        itemKeyPress: function (item, keyName) {
            if (keyName == "Enter") {
                searchBtnJspManHourReport.click(DynamicForm_ManHourReport);
            }
        }
    });
    var RestDataSource_Term_JspUnitReport = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
        ]
    });
    var ListGrid_ManHourReportJSP = isc.TrLG.create({
        ID: "ManHourReportGrid",
//dynamicTitle: true,
        filterOnKeypress: false,
        showFilterEditor: true,
        gridComponents: [DynamicForm_ManHourReport,
            isc.HLayout.create({
                alignment: 'center',
                align: "center",
                vAlign: "center",
                members: [
                    isc.ToolStripButtonExcel.create({
                        margin: 5,
                        click: function () {
                            let t = 0;
                            Object.keys(allData).forEach(type_ => setTimeout(() => exportExcel(type_), (t++) * 500));
                        }
                    })
                ]
            })
            , "header", "filterEditor", "body"],
        dataSource: RestDataSource_Class_JspManHourReport,

        fields: [
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
                title: "<spring:message code='report.unknown.man.hour'/>"
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
            {
                name: "classTeachingType",
                title: "<spring:message code='class.teaching.type'/>",
                hidden: true,
            },
            {
                name: "classStatus",
                title: "<spring:message code='class.status'/>",
                hidden: true,
                valueMap: {
                    "1": "برنامه ریزی",
                    "2": "در حال اجرا",
                    "3": "پایان یافته",
                    "4": "لغو شده",
                    "5": "اختتام",
                }
            },
            {
                name: "courseTechnicalType",
                title: "<spring:message code='course.technicalType'/>",
                hidden: true,
            },
            {
                name: "courseRunType",
                title: "<spring:message code='course.run.type'/>",
                hidden: true
            },
            {
                name: "courseTheoType",
                title: "<spring:message code='course_etheoType'/>",
                hidden: true,
            },
            {
                name: "courseLevelType",
                title: "<spring:message code='cousre_elevelType'/>",
                hidden: true,
            },
            {
                name: "mojtameTitle",
                title: "<spring:message code='complex'/>",
                hidden: true,
            },
            {
                name: "moavenatTitle",
                title: "<spring:message code='assistance'/>",
                hidden: true,
            },
            {
                name: "omorTitle",
                title: "<spring:message code='affairs'/>",
                hidden: true,
            },
            {
                name: "ghesmatTitle",
                title: "<spring:message code='section'/>",
                hidden: true,
            },
        ]
    });
    var VLayout_Body_ = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            ListGrid_ManHourReportJSP
        ]
    });

    function hideColumns() {

        ListGrid_ManHourReportJSP.hideField("mojtameTitle");
        ListGrid_ManHourReportJSP.hideField("moavenatTitle");
        ListGrid_ManHourReportJSP.hideField("omorTitle");
        ListGrid_ManHourReportJSP.hideField("ghesmatTitle");

        if (DynamicForm_ManHourReport.getValue("mojtameCode"))
            ListGrid_ManHourReportJSP.showField("moavenatTitle");
        else if (DynamicForm_ManHourReport.getValue("moavenatCode"))
            ListGrid_ManHourReportJSP.showField("omorTitle");
        else if (DynamicForm_ManHourReport.getValue("omorCode"))
            ListGrid_ManHourReportJSP.showField("ghesmatTitle");
        else
            ListGrid_ManHourReportJSP.showField("mojtameTitle");

        ListGrid_ManHourReportJSP.hideField("classTeachingType");
        ListGrid_ManHourReportJSP.hideField("classStatus");
        ListGrid_ManHourReportJSP.hideField("courseTechnicalType");
        ListGrid_ManHourReportJSP.hideField("courseRunType");
        ListGrid_ManHourReportJSP.hideField("courseTheoType");
        ListGrid_ManHourReportJSP.hideField("courseLevelType");

        if (DynamicForm_ManHourReport.getValue("groupByType").includes('CLASS_TEACHING_TYPE'))
            ListGrid_ManHourReportJSP.showField("classTeachingType");
        if (DynamicForm_ManHourReport.getValue("groupByType").includes('CLASS_STATUS'))
            ListGrid_ManHourReportJSP.showField("classStatus");
        if (DynamicForm_ManHourReport.getValue("groupByType").includes('COURSE_TECHNICAL_TYPE'))
            ListGrid_ManHourReportJSP.showField("courseTechnicalType");
        if (DynamicForm_ManHourReport.getValue("groupByType").includes('COURSE_RUN_TYPE'))
            ListGrid_ManHourReportJSP.showField("courseRunType");
        if (DynamicForm_ManHourReport.getValue("groupByType").includes('COURSE_THEO_TYPE'))
            ListGrid_ManHourReportJSP.showField("courseTheoType");
        if (DynamicForm_ManHourReport.getValue("groupByType").includes('COURSE_LEVEL_TYPE'))
            ListGrid_ManHourReportJSP.showField("courseLevelType");

    };

    function exportExcel(type_) {

        let pivot = DynamicForm_ManHourReport.getItem('groupByType').valueMap[type_];

        let detailFields = "presenceManHourStr,absenceManHourStr,unknownManHourStr,participationPercentStr,presencePerPersonStr";
        let detailHeaders = '<spring:message code="report.presence.man.hour"/>,<spring:message code="report.absence.man.hour"/>,<spring:message
	code="report.unknown.man.hour"/>,<spring:message code="report.participation.percent"/>,<spring:message
    code="report.presence.per.person"/>';
        detailHeaders = detailHeaders.concat(',').concat(pivot);
        switch (type_) {
            case 'CLASS_TEACHING_TYPE':
                detailFields = detailFields.concat(',').concat('classTeachingType');
                break;
            case 'CLASS_STATUS':
                detailFields = detailFields.concat(',').concat('classStatus');
                break;
            case 'COURSE_TECHNICAL_TYPE':
                detailFields = detailFields.concat(',').concat('courseTechnicalType');
                break;
            case 'COURSE_RUN_TYPE':
                detailFields = detailFields.concat(',').concat('courseRunType');
                break;
            case 'COURSE_THEO_TYPE':
                detailFields = detailFields.concat(',').concat('courseTheoType');
                break;
            case 'COURSE_LEVEL_TYPE':
                detailFields = detailFields.concat(',').concat('courseLevelType');
                break;
        }

        let masterData = {'<spring:message code="report.pivot"/>': pivot};
        let dateType = DynamicForm_ManHourReport.getItem('dateType').getValue();
        if (dateType == 2) {
            let terms = DynamicForm_ManHourReport.getItem('termId').getValueMap();
            masterData['<spring:message code="year"/>'] = DynamicForm_ManHourReport.getItem('year').getValue();
            masterData['<spring:message code="term"/>'] = terms[DynamicForm_ManHourReport.getItem('termId').getValue()];
        } else {
            masterData['<spring:message code="from.date"/>'] = DynamicForm_ManHourReport.getItem('fromDate').getValue();
            masterData['<spring:message code="to.date"/>'] = DynamicForm_ManHourReport.getItem('toDate').getValue();
        }
        let mojtameCode = DynamicForm_ManHourReport.getItem('mojtameCode').getValue();
        if (mojtameCode) {
            let mojtameha = DynamicForm_ManHourReport.getItem('mojtameCode').getValueMap();
            masterData['<spring:message code="complex"/>'] = mojtameha[mojtameCode];
        }
        let moavenatCode = DynamicForm_ManHourReport.getItem('moavenatCode').getValue();
        if (moavenatCode) {
            let moavenatha = DynamicForm_ManHourReport.getItem('moavenatCode').getValueMap();
            masterData['<spring:message code="assistance"/>'] = moavenatha[moavenatCode];
        }
        let omorCode = DynamicForm_ManHourReport.getItem('omorCode').getValue();
        if (omorCode) {
            let omorha = DynamicForm_ManHourReport.getItem('omorCode').getValueMap();
            masterData['<spring:message code="affairs"/>'] = omorha[omorCode];
        }

        if (mojtameCode) {
            detailFields = detailFields.concat(",moavenatTitle");
            detailHeaders = detailHeaders.concat(',<spring:message code="assistance"/>');
        } else if (moavenatCode) {
            detailFields = detailFields.concat(",omorTitle");
            detailHeaders = detailHeaders.concat(',<spring:message code="affairs"/>');
        } else if (omorCode) {
            detailFields = detailFields.concat(",ghesmatTitle");
            detailHeaders = detailHeaders.concat(',<spring:message code="section"/>');
        } else {
            detailFields = detailFields.concat(",mojtameTitle");
            detailHeaders = detailHeaders.concat(',<spring:message code="complex"/>');
        }
        let title = '<spring:message code="man.hour.statistics.by.class.features.report"/>';
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
        let listData = allData[type_];
        listData.forEach(d => d.participationPercentStr = d.participationPercent == null ? '' :
            d.participationPercent.toFixed(2));
        listData.forEach(d => d.presenceManHourStr = d.presenceManHour);
        listData.forEach(d => d.absenceManHourStr = d.absenceManHour);
        listData.forEach(d => d.unknownManHourStr = d.unknownManHour);

        listData.forEach(d => d.presencePerPersonStr = d.presencePerPerson == null ? '' : d.presencePerPerson.toFixed(2));
        if (type_ == 'CLASS_STATUS') {
            let classStatusList = ListGrid_ManHourReportJSP.getField('classStatus').valueMap;
            listData.forEach(d =>
                d.classStatus = (classStatusList[d.classStatus] == null ? d.classStatus : classStatusList[d.classStatus]));
        }
        downloadForm.setValue("masterData", JSON.stringify(masterData));
        downloadForm.setValue("detailFields", detailFields);
        downloadForm.setValue("detailHeaders", detailHeaders);
        downloadForm.setValue("detailData", JSON.stringify(listData));
        downloadForm.setValue("title", title);
        downloadForm.setValue("detailDto", "com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO");
        downloadForm.show();
        downloadForm.submitForm();
    }

    //</script>