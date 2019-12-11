<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>
    var selectedRecordClassGrid;
    var sessionInOneDate = [];
    var attendanceState = {
        "0" : "نامشخص",
        "1" : "حاضر",
        "2" : "حاضر و اضافه کار",
        "3" : "غیبت غیر موجه",
        "4" : "غیبت موجه",
    };
    var DataSource_SessionInOneDate = isc.DataSource.create({
        ID:"attendanceDS",
        clientOnly: true,
        testData: sessionInOneDate,
        // dataFormat: "json",
        // dataURL: attendanceUrl + "/session-in-date",
        fields: [
            {name: "studentId", hidden:true, primaryKey: true},
            {name: "studentName", type: "text", title: "نام"},
            {name: "studentFamily", type: "text", title: "نام خانوادگی"},
            {name: "nationalCode", type: "text", title: "کد ملی"},
        ],
    });
    var RestData_SessionDate_AttendanceJSP = isc.TrDS.create({
        fields: [
           {name:"sessionDate",primaryKey:true},
           {name:"dayName"},
       ],
        autoFetchData:false,
        fetchDataURL: attendanceUrl + "/session-date?id=0"
    });
    var DynamicForm_Attendance = isc.DynamicForm.create({
        ID:"attendanceForm",
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
                   if(attendanceGrid.getAllEditRows().isEmpty()) {
                       RestData_SessionDate_AttendanceJSP.fetchDataURL = attendanceUrl + "/session-date?classId=" + ListGrid_Class_JspClass.getSelectedRecord().id;
                       item.fetchData();
                   }
                   else{
                       isc.MyYesNoDialog.create({
                           title: "<spring:message code='message'/>",
                           message: "<spring:message code='msg.save.changes?'/>",
                           buttonClick: function (button, index) {
                               this.close();
                               this.close();
                               if (index === 0) {
                                   saveBtn.click();
                               }
                               else {
                                   cancelBtn.click();
                               }
                           }
                       });
                   }
               },
               changed: function(form, item, value) {
                       isc.RPCManager.sendRequest({
                           actionURL: attendanceUrl + "/session-in-date?classId=" + ListGrid_Class_JspClass.getSelectedRecord().id + "&date=" + value,
                           httpMethod: "GET",
                           httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                           useSimpleHttp: true,
                           contentType: "application/json; charset=utf-8",
                           showPrompt: false,
                           serverOutputAsString: false,
                           callback: function (resp) {
                               let fields1 = [
                                   {name: "studentName", title: "نام", canEdit: false},
                                   {name: "studentFamily", title: "نام خانوادگی", canEdit: false},
                                   {name: "nationalCode", title: "کد ملی", canEdit: false},
                               ];
                               for (let i = 0; i < JSON.parse(resp.data).length; i++) {
                                   let field1 = {};
                                   field1.name = "se" + JSON.parse(resp.data)[i].id;
                                   field1.title = JSON.parse(resp.data)[i].sessionStartHour + " - " + JSON.parse(resp.data)[i].sessionEndHour;
                                   field1.valueMap = attendanceState;
                                   field1.canFilter = false;
                                   fields1.add(field1);
                               }
                               isc.RPCManager.sendRequest({
                                   actionURL: attendanceUrl + "/auto-create?classId=" + ListGrid_Class_JspClass.getSelectedRecord().id + "&date=" + value,
                                   httpMethod: "GET",
                                   httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                   useSimpleHttp: true,
                                   contentType: "application/json; charset=utf-8",
                                   showPrompt: false,
                                   serverOutputAsString: false,
                                   callback: function (resp1) {
                                       var data1 = JSON.parse(resp1.data);
                                       // alert(JSON.parse(resp1.data).length);
                                       // sessionInOneDate.addList(JSON.parse(resp1.data));
                                       // alert(sessionInOneDate[0].getPropertyName())
                                       // sessionInOneDate = [];
                                       // if(attendanceGrid.fields.size() != 0) {
                                       //     delete attendanceGrid.fields;
                                       // }
                                       // if(attendanceDS.cacheData.size()!= 0){
                                       //     attendanceDS.cacheData = [];
                                       // }
                                       sessionInOneDate.length = 0;
                                       attendanceGrid.invalidateCache();
                                       for (let j = 0; j < data1.length; j++) {
                                           //     alert(JSON.parse(resp1.data)[j]);
                                           attendanceDS.addData(data1[j]);
                                           // alert(0)
                                       }

                                   }
                               });
                               if (attendanceGrid.originalFields.size() != 0) {
                                   attendanceGrid.originalFields = [];
                                   attendanceGrid.fields = [];
                                   attendanceGrid.data.localData = [];
                                   attendanceGrid.data.allRows = [];
                               }
                               attendanceGrid.setFields(fields1);
                               attendanceGrid.fetchData();
                           }
                       });
               }
           }
        ],
    });
    var ListGrid_Attendance_AttendanceJSP = isc.TrLG.create({
        ID:"attendanceGrid",
        dynamicTitle:true,
        dynamicProperties:true,
        autoSaveEdits:false,
        // allowFilterExpressions: true,
        // allowAdvancedCriteria: true,
        filterOnKeypress: true,
        // filterLocalData:true,
        dataSource: "attendanceDS",
        // data:sessionInOneDate,
        canEdit: true,
        editEvent: "none",
        editOnFocus: true,
        editByCell: true,
        gridComponents:[DynamicForm_Attendance,"header", "filterEditor", "body",isc.TrHLayoutButtons.create({
            members: [
                isc.IButtonSave.create({
                    ID:"saveBtn",
                    click: function () {
                    attendanceGrid.saveAllEdits();
                    setTimeout(function () {
                        isc.RPCManager.sendRequest({
                            actionURL: attendanceUrl + "/save-attendance?classId=" + ListGrid_Class_JspClass.getSelectedRecord().id + "&date=" + DynamicForm_Attendance.getValue("sessionDate"),
                            willHandleError: true,
                            httpMethod: "POST",
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            showPrompt: false,
                            data: JSON.stringify(sessionInOneDate),
                            serverOutputAsString: false,
                            callback: function (resp) {
                                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                                    simpleDialog("<spring:message code="create"/>", "<spring:message code="msg.operation.successful"/>", 2000, "say");
                                }
                                else {
                                    simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.error"/>", 2000, "stop");
                                }

                            }
                        });
                    },100)
                    // attendanceGrid.endEditing();
                }
            }),
                isc.IButtonCancel.create({
                    ID:"cancelBtn",
                    click:function () {
                        attendanceGrid.discardAllEdits()
                        // attendanceForm.getItem("sessionDate").changed(attendanceForm,attendanceForm.getItem("sessionDate"),attendanceForm.getValue("sessionDate"));
                    }
            })
            ]
        })],
        // fields:[]
        // optionDataSource: DataSource_SessionInOneDate,
        // autoFetchData:true,

    });


    var VLayout_Body_All_Goal = isc.VLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [
            // DynamicForm_Attendance,
            ListGrid_Attendance_AttendanceJSP
        ]
    });
    function sessions_for_one_date(resp) {
        for (var i = 0; i < JSON.parse(resp.data).length; i++) {
            DataSource_SessionInOneDate.addData(JSON.parse(resp.data)[i]);
        }
        <%--if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {--%>
            <%--resp.data--%>
        <%--}--%>
        <%--else {--%>
            <%--isc.say("<spring:message code='error'/>");--%>
        <%--}--%>
    }
    function loadPage_Attendance() {
        if (!(ListGrid_Class_JspClass.getSelectedRecord() == null)) {
            DynamicForm_Attendance.setValue("sessionDate","");
            sessionInOneDate.length = 0;
            ListGrid_Attendance_AttendanceJSP.invalidateCache();
        }
    }


//</script>