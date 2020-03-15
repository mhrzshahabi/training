<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    // <<-------------------------------------- Create - RestDataSource & ListGrid ----------------------------
    {
        var RestDataSource_Complex_MSReport = isc.TrDS.create({
            fields: [
                {name: "complexTitle", title: "<spring:message code="telephone"/>"}
            ],
            fetchDataURL: personnelUrl + "/statisticalReport/complex"
        });

        var RestDataSource_Assistant_MSReport = isc.TrDS.create({
            fields: [
                {name: "ccpAssistant", title: "<spring:message code="telephone"/>"}
            ],
            fetchDataURL: personnelUrl + "/statisticalReport/assistant"
        });

        var RestDataSource_Affairs_MSReport = isc.TrDS.create({
            fields: [
                {name: "ccpAffairs", title: "<spring:message code="telephone"/>"}
            ],
            fetchDataURL: personnelUrl + "/statisticalReport/affairs"
        });

        var RestDataSource_Section_MSReport = isc.TrDS.create({
            fields: [
                {name: "ccpSection", title: "<spring:message code="telephone"/>"}
            ],
            fetchDataURL: personnelUrl + "/statisticalReport/section"
        });

        var RestDataSource_Unit_MSReport = isc.TrDS.create({
            fields: [
                {name: "ccpUnit", title: "<spring:message code="telephone"/>"}
            ],
            fetchDataURL: personnelUrl + "/statisticalReport/unit"
        });


        var RestDataSource_MSReport = isc.TrDS.create({
            fields:
                [
                    {name: "ccp_unit"},
                    {name: "present"},
                    {name: "Overtime"},
                    {name: "UnjustifiedAbsence"},
                    {name: "AcceptableAbsence"}
                ]
        });

        var ListGrid_MSReport = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_MSReport,
            canAddFormulaFields: false,
            showFilterEditor: true,
            allowAdvancedCriteria: true,
            allowFilterExpressions: true,
            filterOnKeypress: true,
            selectionType: "single",
            showGridSummary: true,
            initialSort: [
                {property: "ccp_unit", direction: "ascending"}
            ],
            fields: [
                {
                    name: "ccp_unit",
                    title: "<spring:message code="unitName"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: totalSummary
                },
                {
                    name: "present",
                    title: "<spring:message code="sum.of.present.hours"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: totalPresent
                },
                {
                    name: "overtime",
                    title: "<spring:message code="total.hours.of.overtime"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: totalOvertime
                },
                {
                    name: "unjustifiedAbsence",
                    title: "<spring:message code="sum.of.unjustified.absence.hours"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: totalUnjustifiedAbsence
                }, {
                    name: "acceptableAbsence",
                    title: "<spring:message code="sum.of.justified.absence.hours"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: totalAcceptableAbsence
                }
            ]
        });

    }
    // ---------------------------------------- Create - RestDataSource & ListGrid -------------------------->>

    // <<--------------------------------- Create - DynamicForm & Window & Layout -----------------------------
    {
        //*****report main dynamic form*****
        var DynamicForm_MSReport = isc.DynamicForm.create({
            width: "230px",
            height: "100%",
            padding: 5,
            cellPadding: 5,
            numCols: 2,
            colWidths: ["1%", "99%"],
            fields: [
                {
                    name: "firstDate_MSReport",
                    title: "<spring:message code="start.date"/>",
                    ID: "firstDate_MSReport",
                    width: "100px",
                    hint: "----/--/--",
                    keyPressFilter: "[0-9/]",
                    showHintInField: true,
                    required: true,
                    icons: [{
                        src: "<spring:url value="calendar.png"/>",
                        click: function (form) {
                            closeCalendarWindow();
                            displayDatePicker('firstDate_MSReport', this, 'ymd', '/');
                        }
                    }],
                    textAlign: "center",
                    blur: function (form, item, value) {
                        checkFirstDate();
                        MSReport_check_date();
                    }
                },
                {
                    name: "secondDate_MSReport",
                    title: "<spring:message code="end.date"/>",
                    ID: "secondDate_MSReport",
                    width: "100px",
                    hint: "----/--/--",
                    keyPressFilter: "[0-9/]",
                    showHintInField: true,
                    required: true,
                    icons: [{
                        src: "<spring:url value="calendar.png"/>",
                        click: function (form) {
                            closeCalendarWindow();
                            displayDatePicker('secondDate_MSReport', this, 'ymd', '/');
                        }
                    }],
                    textAlign: "center",
                    blur: function (form, item, value) {
                        checkSecondDate();
                        MSReport_check_date();
                    }

                },
                {
                    name: "complex_MSReport",
                    ID: "complex_MSReport",
                    emptyDisplayValue: "همه",
                    multiple: false,
                    title: "<spring:message code="complex"/>",
                    autoFetchData: false,
                    useClientFiltering: true,
                    optionDataSource: RestDataSource_Complex_MSReport,
                    displayField: "complexTitle",
                    valueField: "complexTitle",
                    textAlign: "center",
                    pickListFields: [
                        {name: "complexTitle"}
                    ],
                    filterFields: ["complexTitle"]
                },
                {
                    name: "Assistant",
                    ID: "Assistant",
                    emptyDisplayValue: "همه",
                    multiple: false,
                    title: "<spring:message code="assistance"/>",
                    autoFetchData: false,
                    useClientFiltering: true,
                    optionDataSource: RestDataSource_Assistant_MSReport,
                    displayField: "ccpAssistant",
                    valueField: "ccpAssistant",
                    textAlign: "center",
                    pickListFields: [
                        {name: "ccpAssistant"}
                    ],
                    filterFields: ["ccpAssistant"]
                },
                {
                    name: "Affairs",
                    ID: "Affairs",
                    emptyDisplayValue: "همه",
                    multiple: false,
                    title: "<spring:message code="affairs"/>",
                    autoFetchData: false,
                    useClientFiltering: true,
                    optionDataSource: RestDataSource_Affairs_MSReport,
                    displayField: "ccpAffairs",
                    valueField: "ccpAffairs",
                    textAlign: "center",
                    pickListFields: [
                        {name: "ccpAffairs"}
                    ],
                    filterFields: ["ccpAffairs"]
                },
                {
                    name: "Section",
                    ID: "Section",
                    emptyDisplayValue: "همه",
                    multiple: false,
                    title: "<spring:message code="section"/>",
                    autoFetchData: false,
                    useClientFiltering: true,
                    optionDataSource: RestDataSource_Section_MSReport,
                    displayField: "ccpSection",
                    valueField: "ccpSection",
                    textAlign: "center",
                    pickListFields: [
                        {name: "ccpSection"}
                    ],
                    filterFields: ["ccpSection"]
                },
                {
                    name: "Unit",
                    ID: "Unit",
                    emptyDisplayValue: "همه",
                    multiple: false,
                    title: "<spring:message code="unit"/>",
                    autoFetchData: false,
                    useClientFiltering: true,
                    optionDataSource: RestDataSource_Unit_MSReport,
                    displayField: "ccpUnit",
                    valueField: "ccpUnit",
                    textAlign: "center",
                    pickListFields: [
                        {name: "ccpUnit"}
                    ],
                    filterFields: ["ccpUnit"]
                },
                {
                    ID: "ffffff",
                    type: "button",
                    width: "100%",
                    height: 30,
                    colSpan: 2,
                    align: "left",
                    title: "<spring:message code="search"/>",
                    click: function () {
                        searchResult();
                    }
                }
            ]
        });


        var VLayout_DynamicForm_MSReport = isc.VLayout.create({
            width: "230px",
            height: "100%",
            members: [DynamicForm_MSReport]
        });

        var VLayout_ListGrid_MSReport = isc.VLayout.create({
            width: "95%",
            height: "100%",
            border: "1px solid green",
            members: [ListGrid_MSReport]
        });

        var Hlayout_Body_MSReport = isc.HLayout.create({
            width: "100%",
            height: "100%",
            members: [VLayout_DynamicForm_MSReport, VLayout_ListGrid_MSReport]
        })

    }
    // ----------------------------------- Create - DynamicForm & Window & Layout --------------------------->>

    // <<----------------------------------------------- Functions --------------------------------------------
    {
        //*****check date is valid*****
        function checkFirstDate() {

            DynamicForm_MSReport.clearFieldErrors("firstDate_MSReport", true);

            if (DynamicForm_MSReport.getValue("firstDate_MSReport") === undefined || !checkDate(DynamicForm_MSReport.getValue("firstDate_MSReport"))) {
                DynamicForm_MSReport.addFieldErrors("firstDate_MSReport", "<spring:message code='msg.correct.date'/>", true);
            } else {
                DynamicForm_MSReport.clearFieldErrors("firstDate_MSReport", true);
            }
        }

        function checkSecondDate() {

            DynamicForm_MSReport.clearFieldErrors("secondDate_MSReport", true);

            if (DynamicForm_MSReport.getValue("secondDate_MSReport") === undefined || !checkDate(DynamicForm_MSReport.getValue("secondDate_MSReport"))) {
                DynamicForm_MSReport.addFieldErrors("secondDate_MSReport", "<spring:message code='msg.correct.date'/>", true);
            } else {
                DynamicForm_MSReport.clearFieldErrors("secondDate_MSReport", true);
            }
        }

        function MSReport_check_date() {

            if (DynamicForm_MSReport.getValue("firstDate_MSReport") !== undefined && DynamicForm_MSReport.getValue("secondDate_MSReport") !== undefined) {
                if (DynamicForm_MSReport.getValue("firstDate_MSReport") > DynamicForm_MSReport.getValue("secondDate_MSReport")) {
                    DynamicForm_MSReport.addFieldErrors("firstDate_MSReport", "<spring:message code="start.date.must.be.shorter.than.end.date"/>");
                    DynamicForm_MSReport.addFieldErrors("secondDate_MSReport", "<spring:message code="start.date.must.be.shorter.than.end.date"/> ");
                } else {
                    DynamicForm_MSReport.clearFieldErrors("firstDate_MSReport", true);
                    DynamicForm_MSReport.clearFieldErrors("secondDate_MSReport", true);
                }
            }

        }

        //***************************

        //*****search report result*****
        function searchResult() {

            checkSecondDate();
            checkFirstDate();
            MSReport_check_date();

            if (DynamicForm_MSReport.hasErrors())
                return;

            var reportParameters = {
                firstDate: firstDate_MSReport._value.replace(/\//g, "^"),
                secondDate: secondDate_MSReport._value.replace(/\//g, "^"),
                complex_title: DynamicForm_MSReport.getValue("complex_MSReport") !== undefined ? DynamicForm_MSReport.getValue("complex_MSReport") : "همه",
                assistant: DynamicForm_MSReport.getValue("Assistant") !== undefined ? DynamicForm_MSReport.getValue("Assistant") : "همه",
                affairs: DynamicForm_MSReport.getValue("Affairs") !== undefined ? DynamicForm_MSReport.getValue("Affairs") : "همه",
                section: DynamicForm_MSReport.getValue("Section") !== undefined ? DynamicForm_MSReport.getValue("Section") : "همه",
                unit: DynamicForm_MSReport.getValue("Unit") !== undefined ? DynamicForm_MSReport.getValue("Unit") : "همه"
            };


            RestDataSource_MSReport.fetchDataURL = monthlyStatistical + "list" + "/" + JSON.stringify(reportParameters);
            ListGrid_MSReport.invalidateCache();
            ListGrid_MSReport.fetchData();

        }

    }

    //*****calculate total summary*****
    function totalSummary() {
        return "جمع کل :";
    }

    function totalPresent(records) {

        let hours = 0;
        let minutes = 0;
        for (let i = 0; i < records.length; i++) {
            if (records[i].present !== "0") {
                hours += parseInt(records[i].present.split(":")[0]);
                minutes += parseInt(records[i].present.split(":")[1]);
            }
        }

        hours += Math.floor(minutes / 60);
        minutes = minutes % 60;

        return String(hours).padStart(2, '0') + ":" + String(minutes).padStart(2, '0');
    }

    function totalOvertime(records) {

        let hours = 0;
        let minutes = 0;
        for (let i = 0; i < records.length; i++) {
            if (records[i].overtime !== "0") {
                hours += parseInt(records[i].overtime.split(":")[0]);
                minutes += parseInt(records[i].overtime.split(":")[1]);
            }
        }

        hours += Math.floor(minutes / 60);
        minutes = minutes % 60;

        return String(hours).padStart(2, '0') + ":" + String(minutes).padStart(2, '0');
    }

    function totalUnjustifiedAbsence(records) {

        let hours = 0;
        let minutes = 0;
        for (let i = 0; i < records.length; i++) {
            if (records[i].unjustifiedAbsence !== "0") {
                hours += parseInt(records[i].unjustifiedAbsence.split(":")[0]);
                minutes += parseInt(records[i].unjustifiedAbsence.split(":")[1]);
            }
        }

        hours += Math.floor(minutes / 60);
        minutes = minutes % 60;

        return String(hours).padStart(2, '0') + ":" + String(minutes).padStart(2, '0');
    }

    function totalAcceptableAbsence(records) {

        let hours = 0;
        let minutes = 0;
        for (let i = 0; i < records.length; i++) {
            if (records[i].acceptableAbsence !== "0") {
                hours += parseInt(records[i].acceptableAbsence.split(":")[0]);
                minutes += parseInt(records[i].acceptableAbsence.split(":")[1]);
            }
        }

        hours += Math.floor(minutes / 60);
        minutes = minutes % 60;

        return String(hours).padStart(2, '0') + ":" + String(minutes).padStart(2, '0');
    }

    //***********************************

    // ------------------------------------------------- Functions ------------------------------------------>>

    // </script>