<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    // <<-------------------------------------- Create - RestDataSource & ListGrid ----------------------------
    {
        var RestDataSource_UCReport = isc.TrDS.create({
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

        var  ListGrid_UCReport = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_UCReport,
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
                    title: "id",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "classCode",
                    title: "<spring:message code="class.code"/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "courseId",
                    title: "courseId",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "courseCode",
                    title: "<spring:message code="course.code"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "courseName",
                    title: "<spring:message code="course.title"/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "duration",
                    title: "<spring:message code="class.duration"/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "startDate",
                    title: "<spring:message code="start.date"/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "endDate",
                    title: "<spring:message code="end.date"/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "firstSession",
                    title: "<spring:message code="first.session"/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "instituteName",
                    title: "<spring:message code="present.location"/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "sessionCount",
                    title: "<spring:message code="sessions.count"/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "heldSessions",
                    title: "<spring:message code="held.sessions"/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "teacher",
                    title: "<spring:message code="teacher"/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "studentId",
                    title: "studentId",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "nationalCode",
                    title: "<spring:message code="national.code"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "firstName",
                    title: "studentFirstName",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "lastName",
                    title: "studentLastName",
                    align: "center",
                    filterOperator: "iContains"
                }
            ]
        });

    }
    // ---------------------------------------- Create - RestDataSource & ListGrid -------------------------->>

    var ToolStripButton_Print_UCReport = isc.ToolStripButtonPrint.create({
        click: function () {
            alert("hi");
        }
    });

    var ToolStripButton_Refresh_UCReport = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_UCReport.invalidateCache();
        }
    });

    var ToolStrip_UCReport = isc.ToolStrip.create({
        width: "100%",
        height: "100%",
        members: [
            ToolStripButton_Print_UCReport,
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                members: [ToolStripButton_Refresh_UCReport]
            })
        ]

    });

    // <<--------------------------------- Create - DynamicForm & Window & Layout -----------------------------
    {

        var Hlayout_ToolStrip_UCReport = isc.HLayout.create({
            width: "100%",
            height: "5%",
            members: [ToolStrip_UCReport]
        });

        var Hlayout_Body_UCReport = isc.VLayout.create({
            width: "100%",
            height: "95%",
            members: [Hlayout_ToolStrip_UCReport,  ListGrid_UCReport]
        });

    }
    // ----------------------------------- Create - DynamicForm & Window & Layout --------------------------->>

    // <<----------------------------------------------- Functions --------------------------------------------
    {
        //*****search report result*****
        // function searchResult() {
        // RestDataSource_UCReport.fetchDataURL = monthlyStatistical + "list" + "/" + JSON.stringify(reportParameters);
        //      ListGrid_UCReport.invalidateCache();
        //      ListGrid_UCReport.fetchData();
        //
        // }
    }
    // ------------------------------------------------- Functions ------------------------------------------>>

    // </script>