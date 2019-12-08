<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>
    var sessionInOneDate = [];
    var DataSourse_SessionInOneDate = isc.DataSource.create({
        clientOnly: true,
        testData: sessionInOneDate,
        // dataFormat: "json",
        // dataURL: attendanceUrl + "session-in-date",
        fields: [
            {name: "id", type: "integer", primaryKey: true},
            {name: "titleFa", type: "text", title: "نام دوره"}
        ],
    });
    var RestData_SessionDate_AttendanceJSP = isc.TrDS.create({
        fields: [
           {name:"sessionDate",primaryKey:true},
           {name:"dayName"},
       ],
        autoFetchData:false,
        fetchDataURL: attendanceUrl + "session-date?id=0"
    });
    var DynamicForm_Attendance = isc.DynamicForm.create({
        numCols:6,
        fields:[
           {
               name:"sessionDate",
               autoFetchData:false,
               title:"حضور و غیاب براساس تاریخ:",
               type:"SelectItem",
               optionDataSource: RestData_SessionDate_AttendanceJSP,
               // valueMap:[1,2,3],
               textAlign:"center",
               pickListFields: [
                   {name: "dayName",title:"روز هفته"},
                   {name: "sessionDate",title:"تاریخ"}
               ],
               click: function (form,item) {
                   RestData_SessionDate_AttendanceJSP.fetchDataURL = attendanceUrl + "session-date?classId=" + ListGrid_Class_JspClass.getSelectedRecord().id;
                   item.fetchData();
               },
               changed: function(form, item, value) {
                   // alert("1")
                   // isc.RPCManager.sendRequest(TrDSRequest(attendanceUrl + "session-in-date?classId=" + ListGrid_Class_JspClass.getSelectedRecord().id + "&date=" + value, "GET", JSON.stringify(JSONObj), "callback: sessions_for_one_date(rpcResponse)"));
                   isc.RPCManager.sendRequest({
                       actionURL: attendanceUrl + "session-in-date?classId=" + ListGrid_Class_JspClass.getSelectedRecord().id + "&date=" + value,
                       httpMethod: "GET",
                       httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                       useSimpleHttp: true,
                       contentType: "application/json; charset=utf-8",
                       showPrompt: false,
                       serverOutputAsString: false,
                       callback: function (resp) {
                           let fields1 = [{name:""}];
                           for (let i = 0; i < JSON.parse(resp.data).length; i++) {
                               alert(JSON.parse(resp.data)[i].id);
                               let field1 = {};
                               field1.name = JSON.parse(resp.data)[i].id;
                               field1.title = JSON.parse(resp.data)[i].sessionStartHour + " - " + JSON.parse(resp.data)[i].sessionEndHour;
                               // ListGrid_Attendance_AttendanceJSP.setFields({name:JSON.parse(resp.data)[i].id,title:JSON.parse(resp.data)[i].sessionStartHour + " - " + JSON.parse(resp.data)[i].sessionEndHour});
                               // ListGrid_Attendance_AttendanceJSP.setFields([field]);
                               fields1.add(field1);
                               alert("2");
                           }
                           ListGrid_Attendance_AttendanceJSP.setFields(fields1);
                           isc.RPCManager.sendRequest({
                               actionURL: attendanceUrl + "auto-create?classId=" + ListGrid_Class_JspClass.getSelectedRecord().id + "&date=" + value,
                               httpMethod: "GET",
                               httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                               useSimpleHttp: true,
                               contentType: "application/json; charset=utf-8",
                               showPrompt: false,
                               serverOutputAsString: false,
                               callback: function (resp) {
                                   DataSourse_SessionInOneDate.addData(JSON.parse(resp.data)[i]);
                               }
                           })
                       }
                   });
               }
           }
        ],
    });
    var ListGrid_Attendance_AttendanceJSP = isc.TrLG.create({
        dynamicTitle:true,
        dynamicProperties:true,
        fields:[]
        // optionDataSource: DataSourse_SessionInOneDate,
        // autoFetchData:true,

    });


    var VLayout_Body_All_Goal = isc.VLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [
            DynamicForm_Attendance,
            ListGrid_Attendance_AttendanceJSP
        ]
    });
    function sessions_for_one_date(resp) {
        for (var i = 0; i < JSON.parse(resp.data).length; i++) {
            DataSourse_SessionInOneDate.addData(JSON.parse(resp.data)[i]);
        }
        <%--if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {--%>
            <%--resp.data--%>
        <%--}--%>
        <%--else {--%>
            <%--isc.say("<spring:message code='error'/>");--%>
        <%--}--%>
    }


//</script>