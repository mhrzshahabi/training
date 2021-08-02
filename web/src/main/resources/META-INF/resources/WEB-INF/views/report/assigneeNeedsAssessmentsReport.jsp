<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    <%--//---------------------------------------------------- REST DataSources--------------------------------------------------------//--%>

    RestDataSource_assignee_needs_report = isc.TrDS.create({
        fields: [
            {name: "code"},
            {name: "des"},
            {name: "assignee"},
            {name: "time"}
        ],
        fetchDataURL: assigneeNeedsAssessmentsReport + "/iscList?_endRow=10000"
    });



    var ListGrid_AssigneeNeedsAssessmentsReport = isc.TrLG.create({
        ID: "AssigneeNeedsAssessmentsReport",
        filterOnKeypress: false,
        showFilterEditor: true,
        autoFetchData: true,
        gridComponents: ["filterEditor", "header", "body"],
        dataSource: RestDataSource_assignee_needs_report,
        fields: [
            {name: "code", title: "کد پست"},
            {name: "des", title: "توضیحات"},
            {name: "assignee", title: "سرپرست مورد نظر"},
            {name: "time",title: "زمان درخواست",
                canFilter: false,
                formatCellValue: function (value) {
                    if (value) {
                        let d = new Date(value);
                        return d.toLocaleString('fa',{ year: 'numeric', month: 'numeric', day: 'numeric' });
                    }
                }
            }
        ]
    });



    //</script>
