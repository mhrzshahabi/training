<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    // <<-------------------------------------- Create - RestDataSource & ListGrid ----------------------------
    {
        var RestDataSource_MSReport = isc.TrDS.create({
            fields:
                [
                    {name: "id"},
                    {name: "classCode"},
                    {name: "courseId"},
                    {name: "courseCode"},
                    {name: "courseName"},
                    {name: "duration"},
                    {name: "startDate"},
                    {name: "endDate"},
                    {name: "firstSession"},
                    {name: "instituteName"},
                    {name: "sessionCount"},
                    {name: "heldSessions"},
                    {name: "teacher"},
                    {name: "studentId"},
                    {name: "nationalCode"},
                    {name: "firstName"},
                    {name: "lastName"}
                ],
            fetchDataURL: unfinishedClasses + "list"
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
            autoFetchData: true,
            initialSort: [
                {property: "startDate", direction: "ascending"}
            ],
            fields: [

                {
                    name: "id",
                    title: "<spring:message code="unitName"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "classCode",
                    title: "<spring:message code="unitName"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "courseId",
                    title: "<spring:message code="unitName"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "courseCode",
                    title: "<spring:message code="unitName"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "courseName",
                    title: "<spring:message code="unitName"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "duration",
                    title: "<spring:message code="unitName"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "startDate",
                    title: "<spring:message code="unitName"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "endDate",
                    title: "<spring:message code="unitName"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "firstSession",
                    title: "<spring:message code="unitName"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "instituteName",
                    title: "<spring:message code="unitName"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "sessionCount",
                    title: "<spring:message code="unitName"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "heldSessions",
                    title: "<spring:message code="unitName"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "teacher",
                    title: "<spring:message code="unitName"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "studentId",
                    title: "<spring:message code="unitName"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "nationalCode",
                    title: "<spring:message code="unitName"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "firstName",
                    title: "<spring:message code="unitName"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "lastName",
                    title: "<spring:message code="unitName"/>",
                    align: "center",
                    filterOperator: "iContains"
                }
            ]
        });

    }
    // ---------------------------------------- Create - RestDataSource & ListGrid -------------------------->>

    // <<--------------------------------- Create - DynamicForm & Window & Layout -----------------------------
    {

        var Hlayout_Body_MSReport = isc.HLayout.create({
            width: "100%",
            height: "100%",
            members: [ListGrid_MSReport]
        })

    }
    // ----------------------------------- Create - DynamicForm & Window & Layout --------------------------->>

    // <<----------------------------------------------- Functions --------------------------------------------
    {
        //*****search report result*****
        // function searchResult() {
        // RestDataSource_MSReport.fetchDataURL = monthlyStatistical + "list" + "/" + JSON.stringify(reportParameters);
        //     ListGrid_MSReport.invalidateCache();
        //     ListGrid_MSReport.fetchData();
        //
        // }
    }
    // ------------------------------------------------- Functions ------------------------------------------>>

    // </script>