<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

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
            transformRequest: function (dsRequest) {
                dsRequest.httpHeaders = {
                    "Authorization": "Bearer <%= accessToken %>"
                };
                return this.Super("transformRequest", arguments);
            },
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
            // autoFetchData: true,
            showFilterEditor: true,
            allowAdvancedCriteria: true,
            allowFilterExpressions: true,
            filterOnKeypress: true,
            selectionType: "single",
            initialSort: [
                {property: "ccp_unit", direction: "ascending"}
            ],
            fields: [
                {
                    name: "ccp_unit",
                    title: "نام واحد",
                    <%--title: "<spring:message code="week.day"/>",--%>
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "present",
                    title: "جمع ساعت حاضر",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "overtime",
                    title: "جمع ساعت حاضر و اضافه کار",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "unjustifiedAbsence",
                    title: "جمع ساعت غیبت غیر موجه",
                    align: "center",
                    filterOperator: "iContains"
                }, {
                    name: "acceptableAbsence",
                    title: "جمع ساعت غیبت موجه",
                    align: "center",
                    filterOperator: "iContains",
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
                    title: "از تاریخ",
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
                        checkFirstDate()
                        MSReport_check_date();
                    }
                },
                {
                    name: "secondDate_MSReport",
                    title: "تا تاریخ",
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
                    emptyDisplayValue:"همه",
                    multiple: false,
                    title: "مجتمع",
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
                    emptyDisplayValue:"همه",
                    multiple: false,
                    title: "معاونت",
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
                    emptyDisplayValue:"همه",
                    multiple: false,
                    title: "امور",
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
                    emptyDisplayValue:"همه",
                    multiple: false,
                    title: "قسمت",
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
                    emptyDisplayValue:"همه",
                    multiple: false,
                    title: "واحد",
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
                    type: "button",
                    width: "100%",
                    height: 30,
                    colSpan: 2,
                    align: "left",
                    title: "جستجو",
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
                complex_title: DynamicForm_MSReport.getValue("complex_MSReport") !==undefined ? DynamicForm_MSReport.getValue("complex_MSReport") : "همه",
                assistant:  DynamicForm_MSReport.getValue("Assistant") !==undefined ? DynamicForm_MSReport.getValue("Assistant") : "همه",
                affairs:  DynamicForm_MSReport.getValue("Affairs") !==undefined ? DynamicForm_MSReport.getValue("Affairs") : "همه",
                section:  DynamicForm_MSReport.getValue("Section") !==undefined ? DynamicForm_MSReport.getValue("Section") : "همه",
                unit:  DynamicForm_MSReport.getValue("Unit") !==undefined ? DynamicForm_MSReport.getValue("Unit") : "همه"
            };


            RestDataSource_MSReport.fetchDataURL = monthlyStatistical + "list" + "/" + JSON.stringify(reportParameters);
            ListGrid_MSReport.invalidateCache();
            ListGrid_MSReport.fetchData();

        }

    }
    // ------------------------------------------------- Functions ------------------------------------------>>

    //