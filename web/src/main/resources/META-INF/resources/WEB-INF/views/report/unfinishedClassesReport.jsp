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
        var RestDataSource_UCReport = isc.TrDS.create({
            fields:
                [
                    {name: "classId"},
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
            fetchDataURL: unfinishedClasses
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
                    name: "classId",
                    title: "classId",
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
                    autoFitWidth: true,
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {
                    name: "startDate",
                    title: "<spring:message code="start.date"/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    filterEditorProperties: {
                        keyPressFilter: "[0-9/]"
                    }
                },
                {
                    name: "endDate",
                    title: "<spring:message code="end.date"/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    filterEditorProperties: {
                        keyPressFilter: "[0-9/]"
                    }
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
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "firstName",
                    title: "studentFirstName",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "lastName",
                    title: "studentLastName",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                }
            ]
        });

    }
    // ---------------------------------------- Create - RestDataSource & ListGrid -------------------------->>

    var ToolStripButton_Print_UCReport = isc.ToolStripButtonPrint.create({
        click: function () {
            print_UCReport("pdf");
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
           // ToolStripButton_Print_UCReport,
            isc.ToolStrip.create({
                width: "100%",
                align: "right",
                members: [isc.ToolStripButtonExcel.create({
                    click: function() {
                        ExportToFile.showDialog(null, ListGrid_UCReport, 'unfinishedClassesReport', 0, null, '',  "کلاس هاي پايان نيافته", ListGrid_UCReport.data.criteria, null);
                    }
                })]
            }),
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
        //*****print*****
        function print_UCReport(type) {
            var advancedCriteria_unit = ListGrid_UCReport.getCriteria();
            var criteriaForm_UCReport = isc.DynamicForm.create({
                method: "POST",
                action: "<spring:url value="/unfinishedClasses-report/printWithCriteria/"/>" + type,
                target: "_Blank",
                canSubmit: true,
                fields:
                    [
                        {name: "CriteriaStr", type: "hidden"},
                        {name: "myToken", type: "hidden"}
                    ]
            });

            criteriaForm_UCReport.setValue("CriteriaStr", JSON.stringify(advancedCriteria_unit));
            criteriaForm_UCReport.setValue("myToken", "<%=accessToken%>");
            criteriaForm_UCReport.show();
            criteriaForm_UCReport.submitForm();
        }
    }
    // ------------------------------------------------- Functions ------------------------------------------>>

    // </script>