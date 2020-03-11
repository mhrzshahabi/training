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
        })

        var RestDataSource_Section_MSReport = isc.TrDS.create({
            fields: [
                {name: "ccpSection", title: "<spring:message code="telephone"/>"}
            ],
            fetchDataURL: personnelUrl + "/statisticalReport/section"
        })

        var RestDataSource_Unit_MSReport = isc.TrDS.create({
            fields: [
                {name: "ccpUnit", title: "<spring:message code="telephone"/>"}
            ],
            fetchDataURL: personnelUrl + "/statisticalReport/unit"
        })


        var RestDataSource_session = isc.TrDS.create({
            transformRequest: function (dsRequest) {
                dsRequest.httpHeaders = {
                    "Authorization": "Bearer <%= accessToken %>"
                };
                return this.Super("transformRequest", arguments);
            },
            fields:
                [
                    {name: "id", primaryKey: true},
                    {name: "dayCode"},
                    {name: "dayName"},
                    {name: "sessionDate"},
                    {name: "sessionStartHour"},
                    {name: "sessionEndHour"},
                    {name: "sessionTypeId"},
                    {name: "sessionType"},
                    {name: "instituteId"},
                    {name: "institute.titleFa"},
                    {name: "trainingPlaceId"},
                    {name: "trainingPlace.titleFa"},
                    {name: "teacherId"},
                    {name: "teacher"},
                    {name: "sessionState"},
                    {name: "sessionStateFa"},
                    {name: "description"}
                ]
            //// fetchDataURL: sessionServiceUrl + "load-sessions/428"
            //// fetchDataURL: sessionServiceUrl + "spec-list"
        });

        var ListGrid_session = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_session,
            canAddFormulaFields: false,
            // autoFetchData: true,
            showFilterEditor: true,
            allowAdvancedCriteria: true,
            allowFilterExpressions: true,
            filterOnKeypress: true,
            selectionType: "single",
            initialSort: [
                {property: "sessionDate", direction: "ascending"},
                {property: "sessionStartHour", direction: "ascending"}
            ],
            fields: [
                {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
                {
                    name: "dayCode",
                    title: "dayCode",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "dayName",
                    title: "<spring:message code="week.day"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "sessionDate",
                    title: "<spring:message code="date"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "sessionStartHour",
                    title: "<spring:message code="start.time"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "sessionEndHour",
                    title: "<spring:message code="end.time"/>",
                    align: "center",
                    filterOperator: "iContains"
                }, {
                    name: "sessionTypeId",
                    title: "sessionTypeId",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "sessionType",
                    title: "<spring:message code="session.type"/>",
                    align: "center",
                    filterOperator: "iContains"
                }, {
                    name: "instituteId",
                    title: "instituteId",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "institute.titleFa",
                    title: "<spring:message code="presenter"/>",
                    align: "center",
                    filterOperator: "iContains"
                }, {
                    name: "trainingPlaceId",
                    title: "trainingPlaceId",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                }
                , {
                    name: "trainingPlace.titleFa",
                    title: "<spring:message code="present.location"/>",
                    align: "center",
                    filterOperator: "iContains"
                }, {
                    name: "teacherId",
                    title: "teacherId",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "teacher",
                    title: "<spring:message code="trainer"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "sessionState",
                    title: "sessionState",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "sessionStateFa",
                    title: "<spring:message code="session.state"/>",
                    align: "center",
                    filterOperator: "iContains"
                }, {
                    name: "description",
                    title: "<spring:message code="description"/>",
                    align: "center",
                    filterOperator: "iContains"
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
            border: "1px solid red",
            fields: [
                {
                    name: "firstDate_MSReport",
                    title: "از تاریخ",
                    ID: "firstDate_MSReport",
                    width: "100px",
                    hint: "----/--/--",
                    keyPressFilter: "[0-9/]",
                    showHintInField: true,
                    icons: [{
                        src: "<spring:url value="calendar.png"/>",
                        click: function (form) {
                            closeCalendarWindow();
                            displayDatePicker('firstDate_MSReport', this, 'ymd', '/');
                        }
                    }],
                    textAlign: "center",
                    click: function (form) {

                    },
                    changed: function (form, item, value) {

                        evaluation_check_date();
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
                    icons: [{
                        src: "<spring:url value="calendar.png"/>",
                        click: function (form) {
                            closeCalendarWindow();
                            displayDatePicker('secondDate_MSReport', this, 'ymd', '/');
                        }
                    }],
                    textAlign: "center",
                    click: function (form) {

                    },
                    changed: function (form, item, value) {

                        evaluation_check_date();
                    }

                },
                {
                    name: "complex_MSReport",
                    // colSpan: 5,
                    // editorType: "TrComboAutoRefresh",
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
                    multiple: false,
                    title: "معاونت",
                    autoFetchData: true,
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
                    multiple: false,
                    title: "امور",
                    autoFetchData: true,
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
                    multiple: false,
                    title: "قسمت",
                    autoFetchData: true,
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
                    multiple: false,
                    title: "واحد",
                    autoFetchData: true,
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
                    height:30,
                    colSpan:2,
                    align: "left",
                    title: "جستجو",

                    click: function () {
                        alert("here");
                    }
                }
            ]
        })

        var VLayout_DynamicForm_MSReport = isc.VLayout.create({
            width: "230px",
            height: "100%",
            border: "1px solid blue",
            members: [DynamicForm_MSReport]
        })

        var VLayout_ListGrid_MSReport = isc.VLayout.create({
            width: "95%",
            height: "100%",
            border: "1px solid green",
            members: [ListGrid_session]
        })

        var Hlayout_Body_MSReport = isc.HLayout.create({
            width: "100%",
            height: "100%",
            members: [VLayout_DynamicForm_MSReport, VLayout_ListGrid_MSReport]
        })

    }
    // ----------------------------------- Create - DynamicForm & Window & Layout --------------------------->>

    // </script>