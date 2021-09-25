<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

//<script>
    var allData;
    var gridMap = new Map();
    var fromDate, toDate;
    var classStatusValueMap = {
        "1": "برنامه ریزی",
        "2": "در حال اجرا",
        "3": "پایان یافته",
        "4": "لغو شده",
        "5": "اختتام",
    }

    var RestDataSource_Class_JspManHourReport = generateDataSource(data => {
        wait.close();

        if (data && data.response) {
            allData = data.response.allData;
            if (DynamicForm_ManHourReport.getValue("groupByType") && DynamicForm_ManHourReport.getValue("groupByType").includes('CLASS_STATUS')) {
                ListGrid_CLASS_STATUS.setData(getListAfterGroupingAndStoringData('CLASS_STATUS'));
                ListGrid_CLASS_STATUS.redraw();
            }
            if (DynamicForm_ManHourReport.getValue("groupByType") && DynamicForm_ManHourReport.getValue("groupByType").includes('CLASS_TEACHING_TYPE')) {
                ListGrid_CLASS_TEACHING_TYPE.setData(getListAfterGroupingAndStoringData("CLASS_TEACHING_TYPE"));
                ListGrid_CLASS_TEACHING_TYPE.redraw();
            }
            if (DynamicForm_ManHourReport.getValue("groupByType") && DynamicForm_ManHourReport.getValue("groupByType").includes('COURSE_TECHNICAL_TYPE')) {
                ListGrid_COURSE_TECHNICAL_TYPE.setData(getListAfterGroupingAndStoringData("COURSE_TECHNICAL_TYPE"));
                ListGrid_COURSE_TECHNICAL_TYPE.redraw();
            }
            if (DynamicForm_ManHourReport.getValue("groupByType") && DynamicForm_ManHourReport.getValue("groupByType").includes('COURSE_RUN_TYPE')) {
                ListGrid_COURSE_RUN_TYPE.setData(getListAfterGroupingAndStoringData("COURSE_RUN_TYPE"));
                ListGrid_COURSE_RUN_TYPE.redraw();
            }
            if (DynamicForm_ManHourReport.getValue("groupByType") && DynamicForm_ManHourReport.getValue("groupByType").includes('COURSE_THEO_TYPE')) {
                ListGrid_COURSE_THEO_TYPE.setData(getListAfterGroupingAndStoringData("COURSE_THEO_TYPE"));
                ListGrid_COURSE_THEO_TYPE.redraw();
            }
            if (DynamicForm_ManHourReport.getValue("groupByType") && DynamicForm_ManHourReport.getValue("groupByType").includes('COURSE_LEVEL_TYPE')) {
                ListGrid_COURSE_LEVEL_TYPE.setData(getListAfterGroupingAndStoringData("COURSE_LEVEL_TYPE"));
                ListGrid_COURSE_LEVEL_TYPE.redraw();
            }
        }
    });

    var DynamicForm_ManHourReport = isc.DynamicForm.create({
        numCols: 8,
        padding: 10,
        titleAlign: "left",
        fields: [
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
                    hideDataGrids();
                    setTimeout(function () {
                        fromDate = form.getValue("fromDate");
                        toDate = form.getValue("toDate");
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
                            .concat("&groupBys=").concat(form.getValue("groupByType")).concat("&reportFor=COMPLEX").concat("&depId=");
                        RestDataSource_Class_JspManHourReport.fetchDataURL = url;
                        RestDataSource_Class_JspManHourReport.fetchData();
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
                    form.getItem("year").hide();
                    form.getItem("termId").hide();
                    form.setValue("year", null);
                    form.setValue("termId", null);
                    form.getItem("fromDate").show();
                    form.getItem("toDate").show();
                    allData = null , fromDate = null, toDate = null;
                    gridMap = new Map();
                    hideDataGrids();
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

    var commonFields = [
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
            hidden: true,
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
    ];

    var ListGrid_CLASS_STATUS = generateDepGrid("COMPLEX", "CLASS_STATUS");

    var ListGrid_CLASS_TEACHING_TYPE = generateDepGrid("COMPLEX", "CLASS_TEACHING_TYPE");

    var ListGrid_COURSE_TECHNICAL_TYPE = generateDepGrid("COMPLEX", "COURSE_TECHNICAL_TYPE");

    var ListGrid_COURSE_RUN_TYPE = generateDepGrid("COMPLEX", "COURSE_RUN_TYPE");

    var ListGrid_COURSE_THEO_TYPE = generateDepGrid("COMPLEX", "COURSE_THEO_TYPE");

    var ListGrid_COURSE_LEVEL_TYPE = generateDepGrid("COMPLEX", "COURSE_LEVEL_TYPE");

    var VLayout_Body_ = isc.VLayout.create({
        width: "100%",
        members: [
            DynamicForm_ManHourReport,
            isc.VLayout.create({
                width: "100%",
                overflow: "auto",
                align: "top",
                members: [
                    ListGrid_CLASS_STATUS,
                    ListGrid_CLASS_TEACHING_TYPE,
                    ListGrid_COURSE_TECHNICAL_TYPE,
                    ListGrid_COURSE_RUN_TYPE,
                    ListGrid_COURSE_THEO_TYPE,
                    ListGrid_COURSE_LEVEL_TYPE,
                ]
            }),
        ]
    });

    function hideDataGrids() {
        if (DynamicForm_ManHourReport.getValue("groupByType") && DynamicForm_ManHourReport.getValue("groupByType").includes('CLASS_TEACHING_TYPE'))
            ListGrid_CLASS_TEACHING_TYPE.show();
        else
            ListGrid_CLASS_TEACHING_TYPE.hide();

        if (DynamicForm_ManHourReport.getValue("groupByType") && DynamicForm_ManHourReport.getValue("groupByType").includes('CLASS_STATUS'))
            ListGrid_CLASS_STATUS.show();
        else
            ListGrid_CLASS_STATUS.hide();

        if (DynamicForm_ManHourReport.getValue("groupByType") && DynamicForm_ManHourReport.getValue("groupByType").includes('COURSE_TECHNICAL_TYPE'))
            ListGrid_COURSE_TECHNICAL_TYPE.show();
        else
            ListGrid_COURSE_TECHNICAL_TYPE.hide();

        if (DynamicForm_ManHourReport.getValue("groupByType") && DynamicForm_ManHourReport.getValue("groupByType").includes('COURSE_RUN_TYPE'))
            ListGrid_COURSE_RUN_TYPE.show();
        else
            ListGrid_COURSE_RUN_TYPE.hide();

        if (DynamicForm_ManHourReport.getValue("groupByType") && DynamicForm_ManHourReport.getValue("groupByType").includes('COURSE_THEO_TYPE'))
            ListGrid_COURSE_THEO_TYPE.show();
        else
            ListGrid_COURSE_THEO_TYPE.hide();

        if (DynamicForm_ManHourReport.getValue("groupByType") && DynamicForm_ManHourReport.getValue("groupByType").includes('COURSE_LEVEL_TYPE'))
            ListGrid_COURSE_LEVEL_TYPE.show();
        else
            ListGrid_COURSE_LEVEL_TYPE.hide();

        ListGrid_CLASS_STATUS.setData([]);
        ListGrid_CLASS_TEACHING_TYPE.setData([]);
        ListGrid_COURSE_TECHNICAL_TYPE.setData([]);
        ListGrid_COURSE_RUN_TYPE.setData([]);
        ListGrid_COURSE_THEO_TYPE.setData([]);
        ListGrid_COURSE_LEVEL_TYPE.setData([]);
    };

    function exportExcel(type_, depId) {
        let pivot = DynamicForm_ManHourReport.getItem('groupByType').valueMap[type_];

        let detailFields = "presenceManHourStr,absenceManHourStr,unknownManHourStr,studentCountStr,participationPercentStr,presencePerPersonStr";
        let detailHeaders = '<spring:message code="report.presence.man.hour"/>,<spring:message code="report.absence.man.hour"/>,<spring:message
    code="report.unknown.man.hour"/>,<spring:message code="report.student.count"/>,<spring:message code="report.participation.percent"/>,<spring:message
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
        let mojtameTitle = gridMap.get(type_.concat(depId)).dep.mojtameTitle;
        if (mojtameTitle) {
            masterData['<spring:message code="complex"/>'] = mojtameTitle;
        }
        let moavenatTitle = gridMap.get(type_.concat(depId)).dep.moavenatTitle;
        if (moavenatTitle) {
            masterData['<spring:message code="assistance"/>'] = moavenatTitle;
        }
        let omorTitle = gridMap.get(type_.concat(depId)).dep.omorTitle;
        if (omorTitle) {
            masterData['<spring:message code="affairs"/>'] = omorTitle;
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
        let listData = gridMap.get(type_.concat(depId)).list;
        listData.forEach(d => d.participationPercentStr = d.participationPercent);
        listData.forEach(d => d.presenceManHourStr = d.presenceManHour);
        listData.forEach(d => d.absenceManHourStr = d.absenceManHour);
        listData.forEach(d => d.unknownManHourStr = d.unknownManHour);
        listData.forEach(d => d.studentCountStr = d.studentCount);
        listData.forEach(d => d.presencePerPersonStr = d.presencePerPerson);
        if (type_ == 'CLASS_STATUS') {
            listData.forEach(d =>
                d.classStatus = (classStatusValueMap[d.classStatus] == null ? d.classStatus : classStatusValueMap[d.classStatus]));
        }
        downloadForm.setValue("masterData", JSON.stringify(masterData));
        downloadForm.setValue("detailFields", detailFields);
        downloadForm.setValue("detailHeaders", detailHeaders);
        downloadForm.setValue("detailData", JSON.stringify(listData));
        downloadForm.setValue("title", title);
        downloadForm.setValue("detailDto", "com.nicico.training.dto.ClassCourseSumByFeaturesAndDepartmentReportDTO$ClassFeatures");
        downloadForm.show();
        downloadForm.submitForm();
    };

    function generateGrid(dep, type_, depId) {
        let fs;
        switch (type_) {
            case 'CLASS_STATUS':
                fs = {
                    name: "classStatus",
                    title: "<spring:message code='class.status'/>",
                    valueMap: classStatusValueMap
                };
                break;
            case 'CLASS_TEACHING_TYPE':
                fs = {
                    name: "classTeachingType",
                    title: "<spring:message code='class.teaching.type'/>"
                };
                break;
            case 'COURSE_TECHNICAL_TYPE':
                fs = {
                    name: "courseTechnicalType",
                    title: "<spring:message code='course.technicalType'/>"
                };
                break;
            case 'COURSE_RUN_TYPE':
                fs = {
                    name: "courseRunType",
                    title: "<spring:message code='course.run.type'/>"
                };
                break;
            case 'COURSE_THEO_TYPE':
                fs = {
                    name: "courseTheoType",
                    title: "<spring:message code='course_etheoType'/>"
                };
                break;
            case 'COURSE_LEVEL_TYPE':
                fs = {
                    name: "courseLevelType",
                    title: "<spring:message code='cousre_elevelType'/>"
                };
                break;
        }
        return isc.TrLG.create({
            showFilterEditor: false,
            height: 220,
            overflow: "auto",
            gridComponents: [isc.HLayout.create({
                alignment: 'right',
                align: "right",
                members: [
                    isc.ToolStripButtonExcel.create({
                        click: function () {
                            exportExcel(type_, depId);
                        }
                    }),
                ]
            }), "header", "body"],
            fields: [...commonFields, fs],
            data: gridMap.get(type_.concat(depId)).list
        });
    };

    function generateDepGrid(dep, type_, hideTitle) {
        let depField = [{name: "depId", hidden: true, autoFitWidth: true}];
        let h, bckColor;
        switch (dep) {
            case 'COMPLEX':
                depField.push(
                    {
                        name: "mojtameTitle",
                        title: "<spring:message code='complex'/>",
                        width: "100%"
                    }
                );
                h = 650;
                bckColor = "#acd1e8";
                break;
            case 'ASSISTANT':
                depField.push(
                    {
                        name: "moavenatTitle",
                        title: "<spring:message code='assistance'/>",
                        width: "100%"
                    }
                );
                h = 300;
                bckColor = "#a491a7";
                break;
            case 'AFFAIR':
                depField.push(
                    {
                        name: "omorTitle",
                        title: "<spring:message code='affairs'/>",
                        width: "100%"
                    }
                );
                h = 250;
                bckColor = "#606d48";
                break;
        }
        let gComponents = ["header", "body"];
        if (!hideTitle)
            gComponents.unshift(isc.Label.create({
                height: "10%",
                width: "100%",
                align: "center",
                contents: "<span style='font-weight:bolder;font-size:14px;color:black'><spring:message code='report.pivot'/> : " + DynamicForm_ManHourReport.getItem("groupByType").valueMap[type_] + "<span>"
            }));
        return isc.TrLG.create({
            showFilterEditor: false,
            height: h,
            width: "100%",
            overflow: "auto",
            backgroundColor: bckColor,
            getCellCSSText: function () {
                return "background-color:" + bckColor + ";color:black;font-size: 12px;";
            },

            canExpandRecords: true,
            canExpandMultipleRecords: false,
            gridComponents: gComponents,
            fields: [
                ...depField,
            ],
            getExpansionComponent: function (record, rowNum, colNum) {
                let depGrid;
                let nextLevel;
                switch (dep) {
                    case 'COMPLEX':
                        nextLevel = "ASSISTANT";
                        break;
                    case 'ASSISTANT':
                        nextLevel = "AFFAIR";
                        break;
                    case 'AFFAIR':
                        depGrid = null;
                        break;
                }
                if (nextLevel && record.depId) {
                    depGrid = generateDepGrid(nextLevel, type_, true);
                    wait.show();
                    let ds = generateDataSource(data => {
                        wait.close();
                        if (data && data.response) {
                            allData = data.response.allData;
                            depGrid.setData(getListAfterGroupingAndStoringData(type_));
                            depGrid.redraw();
                        }
                    });
                    let url = manHourStatisticsByClassFeaturesReportUrl.concat("/list?fromDate=").concat(fromDate).concat("&toDate=").concat(toDate)
                        .concat("&groupBys=").concat(type_).concat("&reportFor=").concat(nextLevel).concat("&depId=").concat(record.depId ? record.depId : '');
                    ds.fetchDataURL = url;
                    ds.fetchData();
                }
                return isc.VLayout.create({
                    width: "98%",
                    members: [generateGrid(dep, type_, record.depId),
                        depGrid
                    ]
                });
            },
        });
    }

    function getListAfterGroupingAndStoringData(type_) {

        let depIds = allData[type_].toArray().map(r => r.depId).filter((value, index, self) => {
            return self.indexOf(value) === index
        });

        allData[type_].forEach(d => {
            gridMap.set(type_.concat(d.depId), {dep: {depId: d.depId, mojtameTitle: d.mojtameTitle, moavenatTitle: d.moavenatTitle, omorTitle: d.omorTitle}, list: []})
        });

        allData[type_].forEach(d => {
            gridMap.get(type_.concat(d.depId)).list.push(d);
        });
        let arr = [];
        depIds.forEach(k => arr.push(gridMap.get(type_.concat(k)).dep));
        return arr;
    }

    function generateDataSource(responseCallBack) {
        return isc.TrDS.create({
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
                responseCallBack(data);
                return this.Super("transformResponse", arguments);
            }
        });
    }

    hideDataGrids();
    //</script>