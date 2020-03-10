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
                <%--{name: "id", primaryKey: true},--%>
                <%--{name: "titleFa", title: "<spring:message code="institution.name"/>"},--%>
                <%--{name: "manager.firstNameFa", title: "<spring:message code="manager.name"/>"},--%>
                <%--{name: "manager.lastNameFa", title: "<spring:message code="manager.family"/>"},--%>
                <%--{name: "mobile", title: "<spring:message code="mobile"/>"},--%>
                <%--{name: "restAddress", title: "<spring:message code="address"/>"},--%>
                <%--{name: "phone", title: "<spring:message code="telephone"/>"}--%>
                {name: "complexTitle", title: "<spring:message code="telephone"/>"}
            ],
            // fetchDataURL: instituteUrl + "spec-list"
            fetchDataURL: personnelUrl + "/complex"
        });

    }
    // ---------------------------------------- Create - RestDataSource & ListGrid -------------------------->>

    // <<--------------------------------- Create - DynamicForm & Window & Layout -----------------------------
    {
        //*****report main dynamic form*****
        var DynamicForm_MSReport = isc.DynamicForm.create({
            width: "50%",
            height: "70px",
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
                    width:"100px",
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
                    type: "ComboBoxItem",
                    multiple: false,
                    title: "مجتمع",
                    autoFetchData: false,
                    useClientFiltering: true,
                    optionDataSource: RestDataSource_Complex_MSReport,
                    displayField: "titleFa",
                    valueField: "id",
                    textAlign: "center",
                    requiredMessage: "<spring:message code="msg.field.is.required"/>",
                    pickListFields: [
                        // {name: "titleFa"},
                        // {name: "manager.firstNameFa"},
                        // {name: "manager.lastNameFa"}
                        {name: "complexTitle"}
                    ],
                    // filterFields: ["titleFa", "manager.firstNameFa", "manager.lastNameFa"]
                    filterFields: ["complexTitle"]
                }
            ]
        })

        var Vlayout_Body_MSReport = isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [DynamicForm_MSReport]
        })

    }
    // ----------------------------------- Create - DynamicForm & Window & Layout --------------------------->>

    // </script>