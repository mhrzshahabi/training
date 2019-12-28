<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>
    var classGridRecordInAttendanceJsp = null;
    var causeOfAbsence = [];
    var sessionInOneDate = [];
    var attendanceState = {
        "0": "نامشخص",
        "1": "حاضر",
        "2": "حاضر و اضافه کار",
        "3": "غیبت غیر موجه",
        "4": "غیبت موجه",
    };
    var DataSource_SessionInOneDate = isc.DataSource.create({
        ID: "attendanceDS",
        clientOnly: true,
        testData: sessionInOneDate,
        // dataFormat: "json",
        // dataURL: attendanceUrl + "/session-in-date",
        fields: [
            {name: "studentId", hidden: true, primaryKey: true},
            {name: "studentName", type: "text", title: "نام"},
            {name: "studentFamily", type: "text", title: "نام خانوادگی"},
            {name: "nationalCode", type: "text", title: "کد ملی"},
            {name: "studentState", type: "text", title: "وضعیت"},
        ],
    });
    var RestData_SessionDate_AttendanceJSP = isc.TrDS.create({
        fields: [
            {name: "sessionDate", primaryKey: true},
            {name: "dayName"},
        ],
        autoFetchData: false,
        fetchDataURL: attendanceUrl + "/session-date?id=0"
    });
    var DynamicForm_Attendance = isc.DynamicForm.create({
        ID: "attendanceForm",
        numCols: 4,
        padding: 10,
        fields: [
            {
                name:"attendanceTitle",
                type:"StaticItem",
                showTitle:false,
                width:"*"
            },
            {
                name: "filterType",
                showTitle: false,
                width:190,
                defaultValue:1,
                valueMap: {
                    1:"حضور و غیاب براساس تاریخ:",
                    2:"حضور و غیاب براساس فراگیر:"
                }
            },
            {
                name: "sessionDate",
                autoFetchData: false,
                width:200,
                title: "حضور و غیاب براساس تاریخ:",
                type: "SelectItem",
                showTitle:false,
                optionDataSource: RestData_SessionDate_AttendanceJSP,
                textAlign: "center",
                sortField: 1,
                // sortDirection: "descending",
                pickListFields: [
                    {name: "dayName", title: "روز هفته"},
                    {name: "sessionDate", title: "تاریخ"}
                ],
                click: function (form, item) {
                    attendanceGrid.endEditing();
                    if (attendanceGrid.getAllEditRows().isEmpty()) {
                        RestData_SessionDate_AttendanceJSP.fetchDataURL = attendanceUrl + "/session-date?classId=" + classGridRecordInAttendanceJsp.id;
                        item.fetchData();
                    } else {
                        isc.MyYesNoDialog.create({
                            title: "<spring:message code='message'/>",
                            message: "<spring:message code='msg.save.changes?'/>",
                            buttonClick: function (button, index) {
                                this.close();
                                if (index === 0) {
                                    saveBtn.click();
                                } else {
                                    cancelBtn.click();
                                }
                            }
                        });
                    }
                },
                changed: function (form, item, value) {
                    isc.RPCManager.sendRequest({
                        actionURL: attendanceUrl + "/session-in-date?classId=" + classGridRecordInAttendanceJsp.id + "&date=" + value,
                        httpMethod: "GET",
                        httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                        useSimpleHttp: true,
                        contentType: "application/json; charset=utf-8",
                        showPrompt: false,
                        serverOutputAsString: false,
                        callback: function (resp) {
                            let fields1 = [
                                {name: "studentName", title: "نام"},
                                {name: "studentFamily", title: "نام خانوادگی"},
                                {name: "nationalCode", title: "کد ملی"},
                            ];
                            for (let i = 0; i < JSON.parse(resp.data).length; i++) {
                                let field1 = {};
                                field1.name = "se" + JSON.parse(resp.data)[i].id;
                                field1.title = JSON.parse(resp.data)[i].sessionEndHour + " - " + JSON.parse(resp.data)[i].sessionStartHour;
                                field1.valueMap = attendanceState;
                                field1.canFilter = false;
                                field1.showHover = true;
                                fields1.add(field1);
                            }
                            isc.RPCManager.sendRequest({
                                actionURL: attendanceUrl + "/auto-create?classId=" + classGridRecordInAttendanceJsp.id + "&date=" + value,
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
                                    for (let j = 0; j < data1[0].length; j++) {
                                        attendanceDS.addData(data1[0][j]);
                                    }
                                    causeOfAbsence = data1[1];
                                }
                            });
                            if (attendanceGrid.originalFields.size() != 0) {
                                attendanceGrid.originalFields = [];
                                attendanceGrid.fields = [];
                                attendanceGrid.data.localData = [];
                                attendanceGrid.data.allRows = [];
                            }
                            attendanceGrid.setFields(fields1);
                            for (let i = 4; i < attendanceGrid.getAllFields().size(); i++) {
                                attendanceGrid.setFieldProperties(i, {
                                    change(form, item, value, oldValue) {
                                        if (value == 4) {
                                            isc.Window.create({
                                                ID: "absenceWindow",
                                                title: "علت غیبت",
                                                autoSize: true,
                                                width: 400,
                                                // height:200,
                                                items: [
                                                    isc.DynamicForm.create({
                                                        ID: "absenceForm",
                                                        numCols: 1,
                                                        padding: 10,
                                                        fields: [
                                                            {
                                                                name: "cause",
                                                                width: "100%",
                                                                // showTitle: false,
                                                                titleOrientation: "top",
                                                                title: "لطفاً علت غیبت یا شماره نامه را در کادر زیر وارد کنید:"
                                                            }
                                                        ]
                                                    }),
                                                    isc.TrHLayoutButtons.create({
                                                        members: [
                                                            isc.IButton.create({
                                                                title:"تایید",
                                                                click: function () {
                                                                    if (trTrim(absenceForm.getValue("cause")) == "") {
                                                                        item.setValue(oldValue);
                                                                        absenceWindow.close();
                                                                    } else {
                                                                        // for (let i = 0; i <causeOfAbsence.length ; i++) {
                                                                        let i = 0;
                                                                        let update = false;
                                                                        do {
                                                                            if ((!causeOfAbsence.isEmpty()) && (causeOfAbsence[i].studentId == attendanceGrid.getSelectedRecord().studentId) && (causeOfAbsence[i].sessionId == item.getFieldName().substr(2))) {
                                                                                causeOfAbsence[i].description = absenceForm.getValue("cause");
                                                                                update = true;
                                                                            }
                                                                            i++;
                                                                        } while (i < causeOfAbsence.length);
                                                                        if (!update) {
                                                                            let data = {};
                                                                            data.sessionId = item.getFieldName().substr(2);
                                                                            data.studentId = attendanceGrid.getSelectedRecord().studentId;
                                                                            data.description = absenceForm.getValue("cause");
                                                                            causeOfAbsence.add(data);
                                                                        }
                                                                        absenceWindow.close();
                                                                        // alert(item.getFieldName())
                                                                        // alert(attendanceGrid.getSelectedRecord().studentId)
                                                                    }
                                                                }
                                                            }),
                                                            isc.IButton.create({
                                                                title:"لغو",
                                                                click: function () {
                                                                    item.setValue(oldValue);
                                                                    absenceWindow.close();
                                                                }
                                                            }),
                                                        ]
                                                    })
                                                ]
                                            });
                                            absenceWindow.show();
                                            for (let i = 0; i < causeOfAbsence.length; i++) {
                                                if (causeOfAbsence[i].studentId == attendanceGrid.getSelectedRecord().studentId) {
                                                    if (causeOfAbsence[i].sessionId == item.getFieldName().substr(2)) {
                                                        absenceForm.setValue("cause", causeOfAbsence[i].description);
                                                        break;
                                                    } else {
                                                        absenceForm.setValue("cause", causeOfAbsence[i].description);
                                                    }
                                                }
                                            }
                                            // isc.askForValue("لطفاً علت غیبت را وارد کنید:",function (value1) {
                                            //     // alert(value1);
                                            //     if(value1 == null){
                                            //         item.setValue(oldValue);
                                            //     }
                                            //     else if(value1 == ""){
                                            //         item.setValue(oldValue);
                                            //     }
                                            //     else{
                                            //
                                            //     }
                                            // },{
                                            //     title:"علت غیبت",
                                            //     defaultValue: "123",
                                            //     // buttonClick: function (button, index) {
                                            //     //     if(index === 1){
                                            //     //         // alert("2");
                                            //     //         item.setValue(oldValue);
                                            //     //     }
                                            //     //     else {
                                            //     //         // alert(value1)
                                            //     //         // if(value == ""){
                                            //     //         //     item.setValue(oldValue);
                                            //     //         // }
                                            //     //     }
                                            //     // }
                                            // });
                                        }
                                        else if(value == 3){
                                            var sessionIds = [];
                                            sessionIds.add(item.getFieldName().substr(2));
                                            for (let i = 4; i < this.grid.getAllFields().length ; i++) {
                                                if(this.grid.getEditValue(this.rowNum,i) == 3){
                                                    sessionIds.add(this.grid.getAllFields()[i].name.substr(2))
                                                }
                                            }
                                            isc.RPCManager.sendRequest({
                                                actionURL: attendanceUrl + "/accept-absent-student?classId=" + classGridRecordInAttendanceJsp.id + "&studentId=" + form.getValue("studentId") + "&sessionId=" + sessionIds,
                                                httpMethod: "GET",
                                                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                                useSimpleHttp: true,
                                                contentType: "application/json; charset=utf-8",
                                                showPrompt: false,
                                                serverOutputAsString: false,
                                                callback: function (resp) {
                                                    if(!JSON.parse(resp.data)){
                                                        // createDialog("info", "تعداد غیبت ها از تعداد غیبت های مجاز عبور میکند و وضعیت دانشجو در کلاس بصورت خودکار به 'خودآموخته' تغییر خواهد کرد");
                                                        isc.MyYesNoDialog.create({
                                                            title: "<spring:message code='message'/>",
                                                            message: "تعداد غیبت ها از تعداد غیبت های مجاز عبور میکند و وضعیت دانشجو در کلاس بصورت خودکار به 'خودآموخته' تغییر خواهد کرد",
                                                            buttons: [
                                                                isc.IButtonSave.create({title: "موافقم",}),
                                                                isc.IButtonCancel.create({title: "مخالفم",})],
                                                            buttonClick: function (button, index) {
                                                                this.close();
                                                                if (index === 0) {
                                                                    let record1 = attendanceGrid.getSelectedRecord();
                                                                    record1.studentState = "1";
                                                                    attendanceGrid.updateData(record1);
                                                                    // attendanceGrid.saveEdits(null,null,this.rowNum);
                                                                    attendanceGrid.focusInFilterEditor();
                                                                    return;
                                                                }
                                                                item.setValue(oldValue);
                                                            },
                                                            closeClick: function () {
                                                                item.setValue(oldValue);
                                                                this.close();
                                                            }
                                                        });
                                                    }
                                                }
                                            });
                                        }
                                        if(this.colNum == 4 && (value == 1 || value == 2)){
                                            for (let i = 5; i < this.grid.getAllFields().length ; i++) {
                                                this.grid.setEditValue(this.rowNum,i,value);
                                            }
                                        }
                                    },
                                    hoverHTML(record, value, rowNum, colNum, grid) {
                                        if (value == "غیبت موجه") {
                                            let i = 0;
                                            do {
                                                if ((!causeOfAbsence.isEmpty()) && (causeOfAbsence[i].studentId == record.studentId) && (causeOfAbsence[i].sessionId == grid.getFieldName(colNum).substr(2))) {
                                                    return causeOfAbsence[i].description;
                                                }
                                                i++;
                                            } while (i < causeOfAbsence.length);
                                        }
                                        // return "sghl";
                                    }
                                });
                            }
                            attendanceGrid.fetchData();
                        }
                    });
                }
            },
            // {
            //     type: "SpacerItem"
            // },
            {
                name: "presentAll",
                title: "تبدیل همه به حاضر",
                type: "ButtonItem",
                startRow:false,
                labelAsTitle: true,
                click (form, item) {
                        for (let i = 0; i < sessionInOneDate.length ; i++) {
                            for (let j = 4; j < attendanceGrid.getAllFields().length; j++) {
                                attendanceGrid.setEditValue(i,j,"1");
                            }
                        }

                }
            }
        ],
    });
    var ListGrid_Attendance_AttendanceJSP = isc.TrLG.create({
        ID: "attendanceGrid",
        dynamicTitle: true,
        dynamicProperties: true,
        autoSaveEdits: false,
        // allowFilterExpressions: true,
        // allowAdvancedCriteria: true,
        filterOnKeypress: true,
        // filterLocalData:true,
        dataSource: "attendanceDS",
        // data:sessionInOneDate,
        // canEdit: true,
        modalEditing: true,
        editEvent: "none",
        editOnFocus: true,
        editByCell: true,
        gridComponents: [DynamicForm_Attendance, "header", "filterEditor", "body", isc.TrHLayoutButtons.create({
            members: [
                isc.IButtonSave.create({
                    ID: "saveBtn",
                    click: function () {
                        if(attendanceGrid.getAllEditRows().length <= 0){
                            createDialog("[SKIN]error","تغییری رخ نداده است.","خطا");
                            return;
                        }
                        attendanceGrid.endEditing();
                        attendanceGrid.saveAllEdits();
                        setTimeout(function () {
                            isc.RPCManager.sendRequest({
                                actionURL: attendanceUrl + "/save-attendance?classId=" + classGridRecordInAttendanceJsp.id + "&date=" + DynamicForm_Attendance.getValue("sessionDate"),
                                willHandleError: true,
                                httpMethod: "POST",
                                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                useSimpleHttp: true,
                                contentType: "application/json; charset=utf-8",
                                showPrompt: false,
                                data: JSON.stringify([sessionInOneDate, causeOfAbsence]),
                                serverOutputAsString: false,
                                callback: function (resp) {
                                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                                        simpleDialog("<spring:message code="create"/>", "<spring:message code="msg.operation.successful"/>", 2000, "say");
                                    } else {
                                        simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.error"/>", 2000, "stop");
                                    }

                                }
                            });
                        }, 100)
                        // attendanceGrid.endEditing();
                    }
                }),
                isc.IButtonCancel.create({
                    ID: "cancelBtn",
                    click: function () {
                        attendanceGrid.discardAllEdits()
                        // attendanceForm.getItem("sessionDate").changed(attendanceForm,attendanceForm.getItem("sessionDate"),attendanceForm.getValue("sessionDate"));
                    }
                })
            ]
        })],
        canEditCell(rowNum, colNum){
            return colNum >= 4 && attendanceGrid.getSelectedRecord().studentState !== "1";
        }
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
        // if(ListGrid_Class_JspClass.getSelectedRecord() === classGridRecordInAttendanceJsp){
        //     return;
        // }
        if(attendanceGrid.getAllEditRows().length>0){
            createDialog("[SKIN]error","حضور و غیاب ذخیره نشده است.","یادآوری");
            return;
        }
        classGridRecordInAttendanceJsp = ListGrid_Class_JspClass.getSelectedRecord();
        if (!(classGridRecordInAttendanceJsp == null)) {
            DynamicForm_Attendance.setValue("sessionDate", "");
            DynamicForm_Attendance.getItem("sessionDate").title = "حضور و غیاب کلاس " + getFormulaMessage(classGridRecordInAttendanceJsp.titleClass,"2px","blue","b") + " گروه" + getFormulaMessage(classGridRecordInAttendanceJsp.group,"2px","red","u") + " براساس تاریخ:";
            DynamicForm_Attendance.redraw();
            sessionInOneDate.length = 0;
            ListGrid_Attendance_AttendanceJSP.invalidateCache();
        }
        else{
            DynamicForm_Attendance.getItem("sessionDate").title = "حضور و غیاب کلاس براساس تاریخ:";
            DynamicForm_Attendance.redraw();
        }
    }

    //</script>