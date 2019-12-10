<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// script
    var RestData_SessionDate_AttendanceJSP = isc.TrDS.create({
        fields: [
            {name: "sessionDate", primaryKey: true}
        ],
        // fetchDataURL:
    });
    var DynamicForm_Attendance = isc.DynamicForm.create({
        numCols: 6,
        fields: [
            {
                name: "sessionDate",
                title: "حضور و غیاب براساس تاریخ:",
                type: "SelectItem",
                optionDataSource: RestData_SessionDate_AttendanceJSP,
                // valueMap:[1,2,3],
                textAlign: "center",
                click: function (form, item) {
                    RestData_SessionDate_AttendanceJSP.fetchDataURL = attendanceUrl + "session-date?classId=" + ListGrid_Class_JspClass.getSelectedRecord().id;
                    item.fetchData();
                }
            }
        ],
    });


    var VLayout_Body_All_Goal = isc.VLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [
            DynamicForm_Attendance
        ]
    });


    //</script>