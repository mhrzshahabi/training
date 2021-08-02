<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    <%--//---------------------------------------------------- REST DataSources--------------------------------------------------------//--%>

    RestDataSource_unAssignee_needs_report = isc.TrDS.create({
        fields: [
            {name: "code"},
            {name: "createdBy"},
            {name: "type"},
            {name: "title"}
        ],
        fetchDataURL: unAssigneeNeedsAssessmentsReport + "/iscList?_endRow=10000"
    });



    var ListGrid_unAssigneeNeedsAssessmentsReport = isc.TrLG.create({
        ID: "unAssigneeNeedsAssessmentsReport",
        filterOnKeypress: false,
        showFilterEditor: true,
        autoFetchData: true,
        gridComponents: ["filterEditor", "header", "body"],
        dataSource: RestDataSource_unAssignee_needs_report,
        fields: [
            {name: "code", title: "کد پست"},
            {name: "createdBy", title: "کاربر ایجاد کننده"},
            {name: "type", title: "نوع پست"},
            {name: "title",title: "عنوان پست"}
        ]
    });



    //</script>