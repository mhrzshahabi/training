<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>
    var selectedRecordClassGrid;
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
        numCols: 6,
        padding: 10,
        fields: [
            {
                name: "sessionDate",
                autoFetchData: false,
                title: "حضور و غیاب براساس تاریخ:",
                type: "SelectItem",
                optionDataSource: RestData_SessionDate_AttendanceJSP,
                textAlign: "center",
                pickListFields: [
                    {name: "dayName", title: "روز هفته"},
                    {name: "sessionDate", title: "تاریخ"}
                ],
                click: function (form, item) {
                    attendanceGrid.endEditing();
                    if (attendanceGrid.getAllEditRows().isEmpty()) {
                        RestData_SessionDate_AttendanceJSP.fetchDataURL = attendanceUrl + "/session-date?classId=" + ListGrid_Class_JspClass.getSelectedRecord().id;
                        item.fetchData();
                    } else {
                        isc.MyYesNoDialog.create({
                            title: "<spring:message code='message'/>",
                            message: "<spring:message code='msg.save.changes?'/>",
                            buttonClick: function (button, index) {
                                this.close();
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
                                field1.showHover = true;
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
                                    for (let j = 0; j < data1[0].length; j++) {
                                        //     alert(JSON.parse(resp1.data)[j]);
                                        attendanceDS.addData(data1[0][j]);
                                        // alert(0)
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
                                                                title: "لطفاً علت غیبت یا شماره نامه را در کادر زیر وارد کنید:",
                                                            }
                                                        ]
                                                    }),
                                                    isc.TrHLayoutButtons.create({
                                                        members: [
                                                            isc.IButtonSave.create({
                                                                click: function () {
                                                                    if (absenceForm.getValue("cause") == null) {
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
                                                            isc.IButtonCancel.create({
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
                                    },
                                    // hoverHTML:"causeOfAbsence.forEach(function (value){if(value.studentId.equals(record.studentId))return value.description;})"
                                    hoverHTML(record, value, rowNum, colNum, grid) {
                                        // alert(record.studentId)
                                        // alert(value)
                                        // alert(colNum)
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
            {
                type: "SpacerItem"
            },
            {
                name: "presentAll",
                title: "تبدیل نامشخص به حاضر:",
                type: "checkbox",
                labelAsTitle: true,
                changed(form, item, value) {
                    if (value) {

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
        canEdit: true,
        modalEditing: true,
        editEvent: "none",
        editOnFocus: true,
        editByCell: true,
        gridComponents: [DynamicForm_Attendance, "header", "filterEditor", "body", isc.TrHLayoutButtons.create({
            members: [
                isc.IButtonSave.create({
                    ID: "saveBtn",
                    click: function () {
                        attendanceGrid.endEditing();
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
        // fields:[]
        // optionDataSource: DataSource_SessionInOneDate,
        // autoFetchData:true,

    });
    var Hlayout_absence_SaveOrExit = isc.TrHLayoutButtons.create({
        members: [
            isc.IButtonSave.create({
                ID: "absenceBtnSave",
            }),
            isc.IButtonCancel.create({
                ID: "absenceBtnCancel",
                title: "لغو",
                click: function () {
                    // DynamicForm_Goal.clearValues();
                    // Window_Goal.close();
                }
            })
        ]
    });
    var DynamicForm_Absence = isc.DynamicForm.create({
        fields: [
            {
                name: "titleFa",
                title: "علت غیبت",
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|a-z|A-Z|0-9 ]",
                // validators: [TrValidators.NotEmpty],
            },
        ],
    });
    var Window_Absence = isc.Window.create({
        title: "علت غیبت",
        items: [isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [DynamicForm_Absence, Hlayout_absence_SaveOrExit]
        })],
        width: "400",
        height: "150",
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
            DynamicForm_Attendance.setValue("sessionDate", "");
            sessionInOneDate.length = 0;
            ListGrid_Attendance_AttendanceJSP.invalidateCache();
        }
    }

    //</script>