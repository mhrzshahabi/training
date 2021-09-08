<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
// <script>
    var selfTaughts={};
    let isSelfTaught=false;
    let isAttendanceDate=true;
    var classGridRecordInAttendanceJsp = null;
    var causeOfAbsence = [];
    var sessionInOneDate = [];
    var sessionsForStudent = [];
    var filterValuesUnique = [];
    var filterValuesUnique1 = [];
    var filterValues = [];
    var filterValues1 = [];
    var sessionDateData;
    let classRecord = null;
    var attendanceState = {
        "0": "نامشخص",
        "1": "حاضر",
        "2": "حاضر و اضافه کار",
        "3": "غیبت غیر موجه",
        "4": "غیبت موجه",
    };
    var printAttendanceState = {
        "0": "",
        "1": "حاضر",
        "2": "اضافه کار",
        "3": "غیبت بدون مجوز",
        "4": "غیبت با مجوز",
    };
    var readOnlySession;
    var DataSource_SessionInOneDate = isc.DataSource.create({
        ID: "attendanceDS",
        clientOnly: true,
        testData: sessionInOneDate,
        fields: [
            {name: "studentId", hidden: true, primaryKey: true},
            {name: "studentName", type: "text", title: "نام",
                pickListProperties: {
                    showFilterEditor: false
                }
            },
            {name: "studentFamily", type: "text", title: "نام خانوادگی",
                pickListProperties: {
                    showFilterEditor: false
                }
            },
            {name: "personalNum", type: "text", title: "شماره پرسنلی"},
            {name: "nationalCode", type: "text", title: "کد ملی",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "company", type: "text", title: "شرکت"},
            {name: "studentState", type: "text", title: "وضعیت"},
        ],
    });
    var DataSource_SessionsForStudent = isc.DataSource.create({
        ID: "attendanceStudentDS",
        clientOnly: true,
        testData: sessionsForStudent,
        fields: [
            {name: "studentId", hidden: true},
            {name: "sessionId", hidden: true, primaryKey: true},
            {name: "studentState", hidden:true, type: "text", title: "وضعیت"},
            {name: "sessionType", title:"نوع جلسه"},
            {name: "sessionDate", type: "text", title: "تاریخ",
                valueMap: filterValuesUnique,
                multiple: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                },
                pickListProperties: {
                    showFilterEditor: false
                }
            },
            {name: "startHour", type: "text", title: "ساعت شروع",
                filterEditorProperties: {
                    keyPressFilter: "[0-9:]"
                }
            },
            {name: "endHour", type: "text", title: "ساعت پایان",
                filterEditorProperties: {
                    keyPressFilter: "[0-9:]"
                }
            },
            {name: "state", type: "text", title: "وضعیت",
                valueMap:attendanceState,
                pickListProperties: {
                    showFilterEditor: false
                }
            },
        ],
    });
    var RestData_SessionDate_AttendanceJSP = isc.TrDS.create({
        fields: [
            {name: "sessionDate", primaryKey: true},
            {name: "dayName"},
        ],
        fetchDataURL: attendanceUrl + "/session-date?id=0"
    });
    var RestData_Student_AttendanceJSP = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "studentId"},
            {name: "firstName"},
            {name: "lastName"},
            {name: "nationalCode",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "companyName"},
            {name: "personnelNo",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "personnelNo2",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
        ],
        autoFetchData: false,
        fetchDataURL: attendanceUrl + "/students?classId=0"
    });
    var VLayout_Attachment_JspAttendance = isc.TrVLayout.create({
        members:[],
    });
    var Window_Attach = isc.Window.create({
        ID:"attachWindow",
        title: "علت غیبت",
        autoSize: false,
        width: "70%",
        height:"60%",
        items:[
            VLayout_Attachment_JspAttendance,
            isc.TrHLayoutButtons.create({
                members:[
                    isc.IButton.create({
                        title:"ارسال شماره نامه",
                        click:function () {
                            if(oAttendanceLoadAttachments_Job.ListGrid_JspAttachment.getSelectedRecord() == undefined){
                                createDialog("info", "لطفاً رکوردی را انتخاب نمایید.", "پیغام");
                            }
                            if(trTrim(oAttendanceLoadAttachments_Job.ListGrid_JspAttachment.getSelectedRecord().description) != null) {
                                absenceForm.setValue("cause", oAttendanceLoadAttachments_Job.ListGrid_JspAttachment.getSelectedRecord().description);
                                attachWindow.close();
                                return;
                            }
                            createDialog("info", "لطفاً شماره نامه را مشخص نمایید.", "پیغام");
                        }
                    })
                ]
            })
        ],
        hide() {
            oAttendanceLoadAttachments_Job.VLayout_Body_JspAttachment.addMembers([
                oAttendanceLoadAttachments_Job.HLayout_Actions_JspAttachment,
                oAttendanceLoadAttachments_Job.HLayout_Grid_JspAttachment
            ]);
            oAttendanceLoadAttachments_Job.ListGrid_JspAttachment.setShowFilterEditor(true);
            this.Super("hide",arguments);
            oAttendanceLoadAttachments_Job.DynamicForm_JspAttachments.getItem("description").title = "<spring:message code="description"/>";
            oAttendanceLoadAttachments_Job.ListGrid_JspAttachment.getField("description").title = "<spring:message code="description"/>";
        },
        show(){
            VLayout_Attachment_JspAttendance.addMembers([
                oAttendanceLoadAttachments_Job. HLayout_Actions_JspAttachment,
                oAttendanceLoadAttachments_Job.HLayout_Grid_JspAttachment
            ]);
            oAttendanceLoadAttachments_Job.ListGrid_JspAttachment.getField("description").title = "شماره نامه";
            this.Super("show",arguments);
            oAttendanceLoadAttachments_Job.DynamicForm_JspAttachments.getItem("description").title = "شماره نامه:";
        }
    });
    <sec:authorize access="hasAnyAuthority('TclassAttendanceTab_classStatus','TclassAttendanceTab_ShowOption')">
    var ToolStrip_Attendance_JspAttendance = isc.ToolStrip.create({
        members: [
            isc.ToolStripButton.create({
                title: "تبدیل همه به 'نامشخص'",
                click: function () {
                    if(readOnlySession){
                        createDialog("info","تاریخ شروع کلاس " + DynamicForm_Attendance.values.sessionDate + " می باشد");
                        return false;
                    }
                    for (let i = 0; i < ListGrid_Attendance_AttendanceJSP.getData().localData.length ; i++) {
                        for (let j = 5; j < attendanceGrid.getAllFields().length; j++) {
                            if(attendanceGrid.getCellRecord(i).studentState != "kh") {
                                attendanceGrid.setEditValue(i, j, "0");
                            }
                        }
                    }
                }
            }),
            isc.ToolStripButton.create({
                title: "تبدیل همه به 'حاضر'",
                click: function () {
                    if(readOnlySession){
                        createDialog("info","تاریخ شروع کلاس " + DynamicForm_Attendance.values.sessionDate + " می باشد");
                        return false;
                    }
                    for (let i = 0; i < ListGrid_Attendance_AttendanceJSP.getData().localData.length ; i++) {
                        for (let j = 5; j < attendanceGrid.getAllFields().length; j++) {
                            if(attendanceGrid.getCellRecord(i).studentState != "kh") {
                                attendanceGrid.setEditValue(i, j, "1");
                            }
                        }
                    }
                }
            }),
            isc.ToolStripButton.create({
                title: "تبدیل همه به 'حاضر و اضافه کار'",
                click: function () {
                    if(readOnlySession){
                        createDialog("info","تاریخ شروع کلاس " + DynamicForm_Attendance.values.sessionDate + " می باشد");
                        return false;
                    }
                    for (let i = 0; i < ListGrid_Attendance_AttendanceJSP.getData().localData.length ; i++) {
                        for (let j = 5; j < attendanceGrid.getAllFields().length; j++) {
                            if(attendanceGrid.getCellRecord(i).studentState != "kh") {
                                attendanceGrid.setEditValue(i, j, "2");
                            }
                        }
                    }
                }
            }),
            isc.ToolStripButton.create({
                title: "تبدیل همه به 'غیبت غیرموجه'",
                click: function () {
                    if(readOnlySession){
                        createDialog("info","تاریخ شروع کلاس " + DynamicForm_Attendance.values.sessionDate + " می باشد");
                        return false;
                    }
                    // console.log(ListGrid_Attendance_AttendanceJSP.getData().localData);
                    // console.log(attendanceGrid.getAllFields())
                    for (let i = 0; i < ListGrid_Attendance_AttendanceJSP.getData().localData.length ; i++) {
                        for (let j = 5; j < attendanceGrid.getAllFields().length; j++) {
                            if(attendanceGrid.getCellRecord(i).studentState != "kh") {
                                attendanceGrid.setEditValue(i, j, "3");
                            }
                        }
                    }
                }
            }),
            isc.ToolStripButton.create({
                title: "تبدیل همه به 'غیبت موجه'",
                click: function () {
                    if(readOnlySession){
                        createDialog("info","تاریخ شروع کلاس " + DynamicForm_Attendance.values.sessionDate + " می باشد");
                        return false;
                    }
                    for (let i = 0; i < ListGrid_Attendance_AttendanceJSP.getData().localData.length ; i++) {
                        for (let j = 5; j < attendanceGrid.getAllFields().length; j++) {
                            if(attendanceGrid.getCellRecord(i).studentState != "kh") {
                                attendanceGrid.setEditValue(i, j, "4");
                            }
                        }
                    }
                }
            }),
            isc.ToolStripButton.create({
                title: "چاپ فرم خام",
                click: function () {
                    wait.show();
                    isc.RPCManager.sendRequest(TrDSRequest(sessionServiceUrl + "sessions/" + classGridRecordInAttendanceJsp.id, "GET", null,(resp)=>{
                        wait.close();
                        if(resp.httpResponseCode == 200){
                            const sessions = JSON.parse(resp.data);
                            let date = sessions[0].sessionDate;
                            let sessionList = [];
                            let i = 1;
                            let page = 0;
                            for(let s of sessions){
                                if(s.sessionDate == date){
                                    sessionList.push(s);
                                    continue;
                                }
                                else if(i<5){
                                    i++;
                                    date = s.sessionDate;
                                    sessionList.push(s);
                                    continue;
                                }
                                page++;
                                i=1;
                                printClearForm(sessionList,page);
                                date = s.sessionDate;
                                sessionList.length = 0;
                                sessionList.push(s);
                            }
                            page++;
                            printClearForm(sessionList,page);
                        }
                    }));
                }
            }),
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let fields = ListGrid_Attendance_AttendanceJSP.getFields();
                    let sendFields = [];
                    for (let i = 1; i < fields.length; i++) {
                        let record = {};
                        record.title = fields[i].title;
                        record.name = fields[i].name;
                        sendFields.push(record)
                    }
                    let allRows = ListGrid_Attendance_AttendanceJSP.data.allRows.toArray();
                    let keys = Object.keys(ListGrid_Attendance_AttendanceJSP.data.allRows[0]);
                    let sessionKeys = keys.filter(k => k.startsWith("se"));
                    if(sessionKeys.indexOf("sessionDate") == -1) {
                        for (let i = 0; i < allRows.length; i++) {
                            for (let j = 0; j < sessionKeys.length; j++) {
                                allRows[i][sessionKeys[j]] = attendanceState[allRows[i][sessionKeys[j]]];
                            }
                        }
                        ExportToFile.exportToExcelFromClient(sendFields,allRows,"لیست حضور و غیاب کلاس: " + classGridRecordInAttendanceJsp.titleClass + " - در تاریخ: " + DynamicForm_Attendance.getValue("sessionDate"),"کلاس - حضور و غیاب");
                    }
                    else{
                        for (let i = 0; i < allRows.length; i++) {
                            allRows[i]["state"] = attendanceState[allRows[i]["state"]];
                        }

                        ExportToFile.exportToExcelFromClient(sendFields,allRows,  "لیست حضور و غیاب کلاس: " + classGridRecordInAttendanceJsp.titleClass + " - برای فراگیر: " +
                            DynamicForm_Attendance.getItem("sessionDate").getSelectedRecord().firstName + " " + DynamicForm_Attendance.getItem("sessionDate").getSelectedRecord().lastName,"کلاس - حضور و غیاب");

                    }
                }
            }),
            isc.ToolStripButtonPrint.create({
                click: function () {
                    let params = {};
                    params.code = classGridRecordInAttendanceJsp.code;
                    params.titleClass = classGridRecordInAttendanceJsp.titleClass;
                    params.teacher = classGridRecordInAttendanceJsp.teacher;
                    params.institute = classGridRecordInAttendanceJsp.institute.titleFa;
                    params.startDate = classGridRecordInAttendanceJsp.startDate;
                    let localData = ListGrid_Attendance_AttendanceJSP.getData().localData.toArray();
                    let data = [];
                    if(DynamicForm_Attendance.getValue("filterType") == "1") {
                        params.date = DynamicForm_Attendance.getValue("sessionDate");
                        let keys = Object.keys(ListGrid_Attendance_AttendanceJSP.data.allRows[0]);
                        let sessionKeys = keys.filter(k => k.startsWith("se"));
                        sessionKeys.sort();
                        for (let k = 0; k < sessionKeys.length; k++) {
                            params["se" + (k + 1).toString()] = ListGrid_Attendance_AttendanceJSP.getField(sessionKeys[k]).title;
                        }
                        for (let i = 0; i < localData.length; i++) {
                            let obj = {};
                            obj.fullName = localData[i].studentName + " " + localData[i].studentFamily;
                            obj.nationalCode = localData[i].nationalCode;
                            obj.personalNum = localData[i].personalNum;
                            for (let j = 0; j < sessionKeys.length; j++) {
                                obj["session" + (j + 1).toString()] = printAttendanceState[localData[i][sessionKeys[j]]]
                            }
                            data.push(obj);
                        }
                        printToJasper(data, params, "attendance.jasper");
                    }
                    else{
                        params.fullName = DynamicForm_Attendance.getItem("sessionDate").getSelectedRecord().firstName+" "
                            + DynamicForm_Attendance.getItem("sessionDate").getSelectedRecord().lastName;
                        data = ListGrid_Attendance_AttendanceJSP.getData().localData.toArray();
                        printToJasper(data, params, "attendanceStudent.jasper");
                    }
                }
            }),
            isc.ToolStripButtonPrint.create({
                title: "فرم خام عمومی",
                click: function () {
                    printFullClearForm()
                }
            }),
            isc.IButtonCancel.create({
                    ID: "teacherAttendancePermission",
                    layoutAlign: "center",
                    // disabled: isEnableBtn(),
                    title: "<spring:message code="verify.change.permission"/>",
                    width: "150",
                    margin: 3,
                click: function () {
                    let Dialog_Delete = isc.Dialog.create({
                        message: "<spring:message code='msg.permission.class'/>",
                        icon: "[SKIN]ask.png",
                        title: "<spring:message code="verify.change.permission"/>",
                        buttons: [isc.IButtonSave.create({title: "<spring:message code='global.yes'/>"}), isc.IButtonCancel.create({
                            title: "<spring:message
        code='global.no'/>"
                        })],
                        buttonClick: function (button, index) {
                            this.close();
                            if (index == 0) {
                                // wait.show()
                                wait.show();
                                isc.RPCManager.sendRequest({
                                    actionURL: attendanceUrl + "/finalApprovalClass?classId=" + ListGrid_Class_JspClass.getSelectedRecord().id,
                                    httpMethod: "GET",
                                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                    useSimpleHttp: true,
                                    contentType: "application/json; charset=utf-8",
                                    showPrompt: false,
                                    serverOutputAsString: false,
                                    callback: function (resp) {

                                        if (resp.httpResponseText=='true') {
                                            // DynamicForm_Attendance.getItem("sessionDate").changed(DynamicForm_Attendance, DynamicForm_Attendance.getItem("sessionDate"), resp.httpResponseText);
                                            // DynamicForm_Attendance.setValue("sessionDate", resp.httpResponseText);
                                            ToolStrip_Attendance_JspAttendance.getItem("teacherAttendancePermission").setDisabled(true);

                                        }
                                        else{

                                        }
                                        wait.close();
                                    }
                                });

                            }
                        }
                    });
                }
            }),
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    isc.ToolStripButtonRefresh.create({
                        click: function () {
                            loadPage_Attendance()
                        }
                    })
                ]
            })
        ]
    });
    </sec:authorize>

    <sec:authorize access="hasAnyAuthority('TclassAttendanceTab_classStatus','TclassAttendanceTab_ShowOption')">
    var DynamicForm_Attendance = isc.DynamicForm.create({
        ID: "attendanceForm",
        numCols: 8,
        padding: 10,
        // cellBorder:2,
        colWidths:[250,200,200,100,100,20,20],
        fields: [
            {
                name: "attendanceTitle",
                showTitle: false,
                canEdit: false,
                textBoxStyle: "font-weight:bold; font-color:red;",
                textAlign: "center",
                width: "*"
            },
            {
                name: "filterType",
                showTitle: false,
                textAlign: "center",
                width:"*",
                defaultValue:1,
                valueMap: {
                    1:"حضور و غیاب براساس تاریخ:",
                    2:"حضور و غیاب براساس فراگیر:"
                },
                changed: function (form, item, value) {
                    if(attendanceGrid.getAllEditRows().length>0){
                        if(value==1){
                            item.setValue(2);
                        }
                        else{
                            item.setValue(1);
                        }
                        createDialog("[SKIN]error","حضور و غیاب ذخیره نشده است.","یادآوری");
                        return;
                    }
                    if(value == 1){
                        form.getItem("sessionDate").pickListFields = [
                            {name: "dayName", title: "روز هفته"},
                            {name: "sessionDate", title: "تاریخ"},
                            {name: "hasWarning", title: "کامل", width: 40, type: "image", imageURLPrefix: "", imageURLSuffix: ".gif",
                                showHover:true,
                                hoverWidth:200,
                                hoverHTML(record){
                                    if (record.hasWarning=="alarm")
                                    {
                                        return "جلسه کامل حضور و غياب نشده است"
                                    }
                                }
                            }
                        ];
                        form.getItem("sessionDate").displayField = "sessionDate";
                        form.getItem("sessionDate").valueField = "sessionDate";
                        form.getItem("sessionDate").optionDataSource = RestData_SessionDate_AttendanceJSP;
                        form.getItem("sessionDate").pickListWidth = 250;
                        isAttendanceDate=false;//true
                    }
                    if(value == 2){
                        form.getItem("sessionDate").pickListFields = [
                            {name: "firstName", title: "نام"},
                            {name: "lastName", title: "نام خانوادگی"},
                            {name: "nationalCode", title: "کد ملی"},
                            {name: "companyName", title: "شرکت"},
                            {name: "personnelNo", title: "شماره پرسنلی"},
                            {name: "personnelNo2", title: "شماره پرسنلی"},
                        ];
                        form.getItem("sessionDate").displayField = "lastName";
                        form.getItem("sessionDate").valueField = "id";
                        form.getItem("sessionDate").optionDataSource = RestData_Student_AttendanceJSP;
                        form.getItem("sessionDate").pickListWidth = 600;
                        isAttendanceDate=false;
                    }
                    sessionsForStudent.length = 0;
                    sessionInOneDate.length = 0;
                    ListGrid_Attendance_AttendanceJSP.invalidateCache();
                    form.setValue("sessionDate","");
                },
                pickListProperties: {showFilterEditor: false},
            },
            {
                name: "sessionDate",
                autoFetchData: false,
                width:250,
                type: "SelectItem",
                showTitle:false,
                optionDataSource: RestData_SessionDate_AttendanceJSP,
                textAlign: "center",
                sortField: 1,
                sortDirection: "descending",
                pickListFields: [
                    {name: "dayName", title: "روز هفته"},
                    {name: "sessionDate", title: "تاریخ"},
                    {name: "hasWarning", title: "کامل", width: 40, type: "image", imageURLPrefix: "", imageURLSuffix: ".gif",
                        showHover:true,
                        hoverWidth:200,
                        hoverHTML(record){
                            if (record.hasWarning=="alarm")
                            {
                                return "جلسه کامل حضور و غياب نشده است"
                            }
                        }
                    },
                ],
                click: function (form, item) {
                    attendanceGrid.endEditing();
                    if (attendanceGrid.getAllEditRows().isEmpty()) {
                        RestData_SessionDate_AttendanceJSP.fetchDataURL = attendanceUrl + "/session-date?classId=" + classGridRecordInAttendanceJsp.id;
                        RestData_Student_AttendanceJSP.fetchDataURL = attendanceUrl + "/students?classId=" + classGridRecordInAttendanceJsp.id;
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
                    if (form.getValue("filterType") == 1) {
                        wait.show();
                        isc.RPCManager.sendRequest({
                            actionURL: attendanceUrl + "/session-in-date?classId=" + classGridRecordInAttendanceJsp.id + "&date=" + value,
                            httpMethod: "GET",
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            showPrompt: false,
                            serverOutputAsString: false,
                            callback: function (resp) {
                                wait.close();
                                readOnlySession = JSON.parse(resp.data)[0].readOnly;
                                let fields1 = [
                                    {name: "studentName", title: "نام", valueMap: filterValuesUnique1, multiple: true,width:"20%",
                                        filterEditorProperties:{
                                            click:function () {
                                                setTimeout(()=> {
                                                    $('.comboBoxItemPickerrtl').eq(9).remove();
                                                },0);
                                            }
                                        },
                                    },
                                    {
                                        name: "studentFamily",
                                        title: "نام خانوادگی",
                                        valueMap: filterValuesUnique,
                                        multiple: true,
                                        width: "20%",
                                        filterEditorProperties: {
                                            click: function () {
                                                setTimeout(() => {
                                                    $('.comboBoxItemPickerrtl').eq(9).remove();
                                                }, 0);
                                            }
                                        }
                                    },
                                    {name: "nationalCode", title: "کد ملی",width:"10%"},
                                    {name: "personalNum", title: "شماره پرسنلي",width:"10%"},
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
                                wait.show();
                                isc.RPCManager.sendRequest({
                                    actionURL: attendanceUrl + "/auto-create?classId=" + classGridRecordInAttendanceJsp.id + "&date=" + value,
                                    httpMethod: "GET",
                                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                    useSimpleHttp: true,
                                    contentType: "application/json; charset=utf-8",
                                    showPrompt: false,
                                    serverOutputAsString: false,
                                    callback: function (resp1) {
                                        wait.close();
                                        let data1 = JSON.parse(resp1.data);
                                        filterValues.length = 0;
                                        filterValues1.length = 0;
                                        filterValuesUnique.length = 0;
                                        filterValuesUnique1.length = 0;
                                        sessionInOneDate.length = 0;
                                        attendanceGrid.invalidateCache();
                                        for (let j = 0; j < data1[0].length; j++) {
                                            if(data1[0][j].studentState.valueOf() == new String("ho").valueOf()){
                                                attendanceDS.addData(data1[0][j]);
                                                filterValues.add(data1[0][j].studentFamily);
                                                filterValues1.add(data1[0][j].studentName);
                                            }
                                        }
                                        causeOfAbsence = data1[1];
                                        //todo for fetch user data
                                        attendanceGrid.fetchData();
                                        $.each(filterValues, function(i, el){
                                            if($.inArray(el, filterValuesUnique) === -1) filterValuesUnique.push(el);
                                        });
                                        filterValuesUnique.sort()
                                        $.each(filterValues1, function(i, el){
                                            if($.inArray(el, filterValuesUnique1) === -1) filterValuesUnique1.push(el);
                                        });
                                        filterValuesUnique1.sort()
                                    }
                                });
                                if (attendanceGrid.originalFields.size() != 0) {
                                    attendanceGrid.originalFields = [];
                                    attendanceGrid.fields = [];
                                    attendanceGrid.data.localData = [];
                                    attendanceGrid.data.allRows = [];
                                }
                                ListGrid_Attendance_AttendanceJSP.dataSource = "attendanceDS";
                                attendanceGrid.setFields(fields1);
                                for (let i = 5; i < attendanceGrid.getAllFields().size(); i++) {
                                    attendanceGrid.setFieldProperties(i, {
                                        change(form, item, value, oldValue) {
                                            if(readOnlySession){
                                                createDialog("info","تاریخ شروع کلاس " + DynamicForm_Attendance.values.sessionDate + " می باشد");
                                                value = oldValue;
                                                return false;
                                            }
                                            if (value == 4) {
                                                let update = false;
                                                isc.Window.create({
                                                    ID: "absenceWindow",
                                                    title: "علت غیبت",
                                                    autoSize: true,
                                                    width: 400,
                                                    items: [
                                                        isc.DynamicForm.create({
                                                            ID: "absenceForm",
                                                            numCols: 1,
                                                            padding: 10,
                                                            fields: [
                                                                {
                                                                    name: "cause",
                                                                    width: "100%",
                                                                    titleOrientation: "top",
                                                                    title: "لطفاً علت غیبت یا شماره نامه را در کادر زیر وارد کنید:",
                                                                    suppressBrowserClearIcon:true,
                                                                    icons: [{
                                                                        name: "view",
                                                                        src: "[SKIN]actions/view.png",
                                                                        hspace: 5,
                                                                        inline: true,
                                                                        baseStyle: "roundedTextItemIcon",
                                                                        showRTL: true,
                                                                        tabIndex: -1,
                                                                        click: function (form, item, icon) {

                                                                            oAttendanceLoadAttachments_Job = new loadAttachments();
                                                                            oAttendanceLoadAttachments_Job.loadPage_attachment("Tclass", classGridRecordInAttendanceJsp.id, "<spring:message code="attachment"/>",{4:"نامه غیبت موجه"});
                                                                            Window_Attach.show();
                                                                            oAttendanceLoadAttachments_Job.ListGrid_JspAttachment.fetchData({"fileTypeId":4});
                                                                            oAttendanceLoadAttachments_Job.ListGrid_JspAttachment.filterByEditor();
                                                                            oAttendanceLoadAttachments_Job.ListGrid_JspAttachment.setShowFilterEditor(false);
                                                                        }
                                                                    }, {
                                                                        name: "clear",
                                                                        src: "[SKIN]actions/close.png",
                                                                        width: 10,
                                                                        height: 10,
                                                                        inline: true,
                                                                        prompt: "پاک کردن",
                                                                        click : function (form, item, icon) {
                                                                            item.clearValue();
                                                                            item.focusInItem();
                                                                        }
                                                                    }],
                                                                    iconWidth: 16,
                                                                    iconHeight: 16
                                                                }
                                                            ]
                                                        }),
                                                        isc.TrHLayoutButtons.create({
                                                            members: [
                                                                isc.IButton.create({
                                                                    title: "تایید",
                                                                    click: function () {
                                                                        if (trTrim(absenceForm.getValue("cause")) == "") {
                                                                            item.setValue(oldValue);
                                                                            absenceWindow.close();
                                                                        } else {
                                                                            let i = 0;
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
                                                                                update = true;
                                                                            }
                                                                            absenceWindow.close();
                                                                        }
                                                                    }
                                                                }),
                                                                isc.IButton.create({
                                                                    title: "لغو",
                                                                    click: function () {
                                                                        item.setValue(oldValue);
                                                                        absenceWindow.close();
                                                                    }
                                                                }),
                                                            ]
                                                        })
                                                    ],
                                                    hide(){
                                                        if(!update){
                                                            item.setValue(oldValue);
                                                        }
                                                        this.Super("hide",arguments)
                                                    }
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
                                            }
                                            else if (value == 3) {
                                                var sessionIds = [];
                                                sessionIds.add(item.getFieldName().substr(2));
                                                for (let i = 5; i < this.grid.getAllFields().length; i++) {
                                                    if (this.grid.getEditValue(this.rowNum, i) == 3) {
                                                        sessionIds.add(this.grid.getAllFields()[i].name.substr(2))
                                                    }
                                                }

                                                selfTaughts[form.getValue("studentId").toString()]={sessionIds,'fullName':form.getValue("studentName").trim()+" "+form.getValue("studentFamily").trim()};

                                                isSelfTaught=true;
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
                                        }
                                    });
                                }
                                attendanceGrid.fetchData();
                            }
                        });
                    }
                    if (form.getValue("filterType") == 2) {
                        if (item.getSelectedRecord()!==null){
                            isAttendanceDate=false;
                            wait.show();
                            isc.RPCManager.sendRequest({
                                actionURL: attendanceUrl + "/student?classId=" + classGridRecordInAttendanceJsp.id + "&studentId=" + item.getSelectedRecord().studentId,
                                httpMethod: "GET",
                                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                useSimpleHttp: true,
                                contentType: "application/json; charset=utf-8",
                                showPrompt: false,
                                serverOutputAsString: false,
                                callback: function (resp) {
                                    wait.close();
                                    if(resp.httpResponseCode == 200 || resp.httpResponseCode == 201){
                                        let fields1 = [
                                            {name: "sessionType", title: "نوع جلسه"},
                                            {
                                                name: "sessionDate",
                                                filterEditorProperties:{
                                                    click:function () {
                                                        setTimeout(()=> {
                                                            $('.comboBoxItemPickerrtl').eq(9).remove();
                                                        },0);
                                                    }
                                                },
                                            },
                                            {name: "startHour", title: "ساعت شروع"},
                                            {name: "endHour", title: "ساعت پایان"},
                                            {
                                                name: "state",
                                                filterEditorProperties:{
                                                    click:function () {
                                                        setTimeout(()=> {
                                                            $('.comboBoxItemPickerrtl').eq(9).remove();
                                                        },0);
                                                    }
                                                },
                                            },
                                        ];
                                        if (attendanceGrid.originalFields.size() != 0) {
                                            attendanceGrid.originalFields = [];
                                            attendanceGrid.fields = [];
                                            attendanceGrid.data.localData = [];
                                            attendanceGrid.data.allRows = [];
                                        }
                                        ListGrid_Attendance_AttendanceJSP.dataSource = "attendanceStudentDS";
                                        attendanceGrid.setFields(fields1);
                                        attendanceGrid.setFieldProperties(5, {
                                            hoverHTML(record, value, rowNum, colNum, grid) {
                                                if (value == "غیبت موجه") {
                                                    let i = 0;
                                                    do {
                                                        if ((!causeOfAbsence.isEmpty()) && (causeOfAbsence[i].studentId == record.studentId) && (causeOfAbsence[i].sessionId == record.sessionId)) {
                                                            return causeOfAbsence[i].description;
                                                        }
                                                        i++;
                                                    } while (i < causeOfAbsence.length);
                                                }
                                            },
                                            change(form, item, value, oldValue) {
                                                readOnlySession = item.record.readOnly == "true";
                                                if(readOnlySession){
                                                    createDialog("info","تاریخ شروع کلاس " + item.record.sessionDate + " می باشد");
                                                    value = oldValue;
                                                    return false;
                                                }
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
                                                                        suppressBrowserClearIcon:true,
                                                                        icons: [{
                                                                            name: "view",
                                                                            src: "[SKIN]actions/view.png",
                                                                            hspace: 5,
                                                                            inline: true,
                                                                            baseStyle: "roundedTextItemIcon",
                                                                            showRTL: true,
                                                                            tabIndex: -1,
                                                                            click: function (form, item, icon) {
                                                                                loadPage_attachment("Tclass", classGridRecordInAttendanceJsp.id, "<spring:message code="attachment"/>",{4:"نامه غیبت موجه"});
                                                                                Window_Attach.show();
                                                                                oAttendanceLoadAttachments_Job.ListGrid_JspAttachment.fetchData({"fileTypeId":4});
                                                                                oAttendanceLoadAttachments_Job.ListGrid_JspAttachment.filterByEditor();
                                                                                oAttendanceLoadAttachments_Job.ListGrid_JspAttachment.setShowFilterEditor(false);
                                                                            }
                                                                        }, {
                                                                            name: "clear",
                                                                            src: "[SKIN]actions/close.png",
                                                                            width: 10,
                                                                            height: 10,
                                                                            inline: true,
                                                                            prompt: "پاک کردن",
                                                                            click : function (form, item, icon) {
                                                                                item.clearValue();
                                                                                item.focusInItem();
                                                                            }
                                                                        }],
                                                                        iconWidth: 16,
                                                                        iconHeight: 16
                                                                    }
                                                                ]
                                                            }),
                                                            isc.TrHLayoutButtons.create({
                                                                members: [
                                                                    isc.IButton.create({
                                                                        title: "تایید",
                                                                        click: function () {
                                                                            if (trTrim(absenceForm.getValue("cause")) == "") {
                                                                                item.setValue(oldValue);
                                                                                absenceWindow.close();
                                                                            } else {
                                                                                // for (let i = 0; i <causeOfAbsence.length ; i++) {
                                                                                let i = 0;
                                                                                let update = false;
                                                                                do {
                                                                                    if ((!causeOfAbsence.isEmpty()) && (causeOfAbsence[i].studentId == attendanceGrid.getSelectedRecord().studentId) && (causeOfAbsence[i].sessionId == attendanceGrid.getSelectedRecord().sessionId)) {
                                                                                        causeOfAbsence[i].description = absenceForm.getValue("cause");
                                                                                        update = true;
                                                                                    }
                                                                                    i++;
                                                                                } while (i < causeOfAbsence.length);
                                                                                if (!update) {
                                                                                    let data = {};
                                                                                    data.sessionId = attendanceGrid.getSelectedRecord().sessionId;
                                                                                    data.studentId = attendanceGrid.getSelectedRecord().studentId;
                                                                                    data.description = absenceForm.getValue("cause");
                                                                                    causeOfAbsence.add(data);
                                                                                }
                                                                                absenceWindow.close();
                                                                            }
                                                                        }
                                                                    }),
                                                                    isc.IButton.create({
                                                                        title: "لغو",
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
                                                            if (causeOfAbsence[i].sessionId == attendanceGrid.getSelectedRecord().sessionId) {
                                                                absenceForm.setValue("cause", causeOfAbsence[i].description);
                                                                break;
                                                            } else {
                                                                absenceForm.setValue("cause", causeOfAbsence[i].description);
                                                            }
                                                        }
                                                    }
                                                } else if (value == 3) {
                                                    var sessionIds = [];
                                                    sessionIds.add(attendanceGrid.getSelectedRecord().sessionId);
                                                    for (let i = 0; i < this.grid.getAllEditRows().length; i++) {
                                                        if (this.grid.getEditValue(this.grid.getAllEditRows()[i], "state") == 3) {
                                                            sessionIds.add(this.grid.getRecord(this.grid.getAllEditRows()[i]).sessionId)
                                                        }
                                                    }
                                                    wait.show();
                                                    isc.RPCManager.sendRequest({
                                                        actionURL: attendanceUrl + "/accept-absent-student?classId=" + classGridRecordInAttendanceJsp.id + "&studentId=" + form.getValue("studentId") + "&sessionId=" + sessionIds,
                                                        httpMethod: "GET",
                                                        httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                                        useSimpleHttp: true,
                                                        contentType: "application/json; charset=utf-8",
                                                        showPrompt: false,
                                                        serverOutputAsString: false,
                                                        callback: function (resp) {
                                                            wait.close();
                                                            if (!JSON.parse(resp.data)) {
                                                                // createDialog("info", "تعداد غیبت ها از تعداد غیبت های مجاز عبور میکند و وضعیت دانشجو در کلاس بصورت خودکار به 'خودآموخته' تغییر خواهد کرد");
                                                                isc.MyYesNoDialog.create({
                                                                    title: "<spring:message code='message'/>",
                                                                    message: "تعداد غیبت ها از تعداد غیبت های مجاز عبور میکند، آیا مایل هستید که غیبت غیر موجه را برای فراگیر مورد نظر اعمال کنید؟",
                                                                    buttons: [
                                                                        isc.IButtonSave.create({title: "بلی",}),
                                                                        isc.IButtonCancel.create({title: "خیر",})],
                                                                    buttonClick: function (button, index) {
                                                                        this.close();
                                                                        if (index === 0) {
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
                                            },
                                        });
                                        ListGrid_Attendance_AttendanceJSP.clearSort();
                                        ListGrid_Attendance_AttendanceJSP.sortDirection = "descending";
                                        ListGrid_Attendance_AttendanceJSP.sort("sessionDate");
                                        var data2 = JSON.parse(resp.data);
                                        filterValues.length = 0;
                                        filterValuesUnique.length = 0;
                                        sessionsForStudent.length = 0;
                                        attendanceGrid.invalidateCache();
                                        for (let j = 0; j < data2[0].length; j++) {
                                            attendanceStudentDS.addData(data2[0][j]);
                                            filterValues.add(data2[0][j].sessionDate);
                                        }
                                        causeOfAbsence = data2[1];
                                        attendanceGrid.fetchData();
                                        $.each(filterValues, function(i, el){
                                            if($.inArray(el, filterValuesUnique) === -1) filterValuesUnique.push(el);
                                        });
                                        filterValuesUnique.sort()
                                    }
                                }
                            })
                        }
                        else
                        {
                            form.setValue("filterType",1)
                        }

                    }
                },
                dataArrived: function (startRow, endRow, data) {
                    this.Super("dataArrived", arguments);
                    sessionDateData = data;
                },
            },
        ],
    });
    </sec:authorize>

    <sec:authorize access="hasAnyAuthority('TclassAttendanceTab_classStatus','TclassAttendanceTab_ShowOption')">
    var TrHLayoutButtons= isc.TrHLayoutButtons.create({
        members: [
            isc.IButtonSave.create({
                ID: "saveBtn",
                click: function () {
                    if (isSelfTaught){
                        Object.keys(selfTaughts).forEach(x=>{
                            wait.show();
                            isc.RPCManager.sendRequest({
                                actionURL: attendanceUrl + "/accept-absent-student?classId=" + classGridRecordInAttendanceJsp.id + "&studentId=" + x + "&sessionId=" + selfTaughts[x].sessionIds,
                                httpMethod: "GET",
                                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                useSimpleHttp: true,
                                contentType: "application/json; charset=utf-8",
                                showPrompt: false,
                                serverOutputAsString: false,
                                callback: function (resp) {
                                    wait.close();
                                    if (!JSON.parse(resp.data)) {
                                        isc.MyYesNoDialog.create({
                                            title: "<spring:message code='message'/>",
                                            message: "تعداد غیبت های "+ selfTaughts[x].fullName +" از تعداد غیبت های مجاز عبور میکند، آیا مایل هستید که غیبت غیر موجه را برای فراگیر مورد نظر اعمال کنید؟",
                                            buttons: [
                                                isc.IButtonSave.create({title: "بلی"}),
                                                isc.IButtonCancel.create({title: "خیر"})],
                                            buttonClick: function (button, index) {
                                                this.close();
                                                attendanceGrid.setSelectedState([{studentId: x}]);
                                                let record1 = attendanceGrid.getSelectedRecord();
                                                if (index === 0) {
                                                    delete selfTaughts[x];
                                                    checkFinalSave();
                                                }
                                                else{
                                                    attendanceGrid.discardEdits(record1);
                                                    delete selfTaughts[x];
                                                    checkFinalSave();
                                                }
                                            },
                                            closeClick: function () {
                                                attendanceGrid.setSelectedState([{studentId: x}]);
                                                record1 = attendanceGrid.getSelectedRecord();
                                                attendanceGrid.discardEdits(record1);
                                                delete selfTaughts[x];
                                                checkFinalSave();
                                                this.close();
                                            }
                                        });
                                    }else {
                                        delete selfTaughts[x];
                                        checkFinalSave();
                                    }
                                }
                            });
                        });
                    }

                    if(attendanceGrid.getAllEditRows().length <= 0){
                        createDialog("[SKIN]error","تغییری رخ نداده است.","خطا");
                        return;
                    }

                    checkFinalSave();
                }
            }),
            isc.IButtonCancel.create({
                ID: "cancelBtn",
                click: function () {
                    attendanceGrid.discardAllEdits()
                    selfTaughts=[];
                    // attendanceForm.getItem("sessionDate").changed(attendanceForm,attendanceForm.getItem("sessionDate"),attendanceForm.getValue("sessionDate"));
                }
            })
        ]

    })
    </sec:authorize>

    function checkFinalSave(){
        if (Object.keys(selfTaughts).length==0) {
            attendanceGrid.endEditing();
            attendanceGrid.saveAllEdits();
        }
    }


    var ListGrid_Attendance_AttendanceJSP = isc.TrLG.create({
        ID: "attendanceGrid",
        dynamicTitle: true,
        dynamicProperties: true,
        autoSaveEdits: false,
        filterOnKeypress: true,
        dataPageSize: 200,
        dataSource: "attendanceDS",
        modalEditing: true,
        editEvent: "none",
        editOnFocus: true,
        editByCell: true,
        showHeaderContextMenu:false,
        gridComponents: [DynamicForm_Attendance, ToolStrip_Attendance_JspAttendance, "header", "filterEditor", "body",TrHLayoutButtons ],
        canHover:true,
        canEditCell(rowNum, colNum){
            if (attendanceGrid.getSelectedRecord()!==null)
                return (colNum >= 5 && attendanceGrid.getSelectedRecord().studentState !== "kh");
            else
                return false;
        },
        saveAllEdits() {
            this.Super("saveAllEdits",arguments);
            setTimeout(function () {
                if(attendanceForm.getValue("filterType") == 1) {
                    wait.show();
                    let sendObject = {};
                    sendObject.serialVersionUID = 7710786106266650447;
                    let sendList = [];
                    sessionInOneDate.forEach(a=>{
                        let sessions = Object.keys(a).findAll(b=>b.substr(0,2)==="se");
                        sessions.forEach( b => {
                            let record = {};
                            record.studentId = a.studentId;
                            record.sessionId = b.substr(2);
                            record.state = a[b];
                            sendList.push(record);

                        });
                    });
                    causeOfAbsence.forEach(c=>{
                        let findList = sendList.find(d => (c.sessionId === d.sessionId) && (c.studentId === d.studentId));
                        if(findList != null)
                            findList.description = c.description;
                    });
                    // if(causeOfAbsence.length !== 0) {
                    //     let cause = causeOfAbsence.find(c => ((c.sessionId === record.sessionId) && (c.studentId === record.studentId)));
                    //     console.log(record);
                    //     record.description = cause.description;
                    // }
                    sendObject.attendanceDtos = sendList;
                    isc.RPCManager.sendRequest({
                        actionURL: attendanceUrl + "/save-attendance",
                        willHandleError: true,
                        httpMethod: "POST",
                        httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                        useSimpleHttp: true,
                        contentType: "application/json; charset=utf-8",
                        showPrompt: false,
                        data: JSON.stringify(sendObject),
                        serverOutputAsString: false,
                        callback: function (resp) {
                            loadPage_Attendance();
                            wait.close();
                            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                let classRecord = ListGrid_Class_JspClass.getSelectedRecord();
                                if(classRecord.classStatus === "1") {
                                    isc.RPCManager.sendRequest(TrDSRequest(classUrl + "changeClassStatusToInProcess/" + classRecord.id, "GET", null, function (resp) {
                                        if (resp.httpResponseCode === 200) {
                                            ListGrid_Class_JspClass.invalidateCache();
                                            simpleDialog("<spring:message code="create"/>", "<spring:message code="msg.operation.successful"/>", 2000, "say");
                                        } else {
                                            simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.error"/>", 2000, "stop");
                                        }
                                    }));
                                } else {
                                    simpleDialog("<spring:message code="create"/>", "<spring:message code="msg.operation.successful"/>", 2000, "say");
                                }
                            } else {
                                simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.error"/>", 2000, "stop");
                            }
                        }
                    });
                } else if(attendanceForm.getValue("filterType") == 2) {
                    wait.show();
                    isc.RPCManager.sendRequest({
                        actionURL: attendanceUrl + "/student-attendance-save",
                        willHandleError: true,
                        httpMethod: "POST",
                        httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                        useSimpleHttp: true,
                        contentType: "application/json; charset=utf-8",
                        showPrompt: false,
                        data: JSON.stringify([sessionsForStudent, causeOfAbsence]),
                        serverOutputAsString: false,
                        callback: function (resp) {
                            loadPage_Attendance();
                            wait.close();
                            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                let classRecord = ListGrid_Class_JspClass.getSelectedRecord();
                                if(classRecord.classStatus === "1") {
                                    isc.RPCManager.sendRequest(TrDSRequest(classUrl + "changeClassStatusToInProcess/" + classRecord.id, "GET", null, function (resp) {
                                        if (resp.httpResponseCode === 200) {
                                            ListGrid_Class_JspClass.invalidateCache();
                                            simpleDialog("<spring:message code="create"/>", "<spring:message code="msg.operation.successful"/>", 2000, "say");
                                        } else {
                                            simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.error"/>", 2000, "stop");
                                        }
                                    }));
                                } else {
                                    simpleDialog("<spring:message code="create"/>", "<spring:message code="msg.operation.successful"/>", 2000, "say");
                                }
                            } else {
                                simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.error"/>", 2000, "stop");
                            }
                        }
                    });
                }
            }, 100)
        },
        getCellCSSText: function (record, rowNum, colNum){
            if(this.getFieldName(colNum).startsWith("se") || (this.getFieldName(colNum).valueOf()) == new String("state").valueOf()){
                let key = this.getFieldName(colNum);
                if(record[key] != this.getEditedCell(rowNum,colNum))
                    return "font-weight:bold; color:#0066ff;";
                switch(record[key]) {
                    case "1":
                        return "font-weight:bold; color:#199435;";
                        break;
                    case "2":
                        return "font-weight:bold; color:#199435;";
                        break;
                    case "3":
                        return "font-weight:bold; color:#FF0000;";
                        break;
                    case "4":
                        return "font-weight:bold; color:#FF0000;";
                        break;
                    default:

                }
            }
        },

    });
    var VLayout_Body_All_Goal = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            ListGrid_Attendance_AttendanceJSP
        ]
    });

    function sessions_for_one_date(resp) {
        for (var i = 0; i < JSON.parse(resp.data).length; i++) {
            DataSource_SessionInOneDate.addData(JSON.parse(resp.data)[i]);
        }
    }

    function refreshDate() {
        let oldValue =  DynamicForm_Attendance.getValue("sessionDate");
        if (isAttendanceDate)
        {
            wait.show();
            isc.RPCManager.sendRequest({
                actionURL: attendanceUrl + "/studentUnknownSessionsInClass?classId=" + ListGrid_Class_JspClass.getSelectedRecord().id,
                httpMethod: "GET",
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                showPrompt: false,
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseText) {
                        DynamicForm_Attendance.getItem("sessionDate").changed(DynamicForm_Attendance, DynamicForm_Attendance.getItem("sessionDate"), resp.httpResponseText);
                        DynamicForm_Attendance.setValue("sessionDate", resp.httpResponseText);
                    }
                    else{
                        ListGrid_Attendance_AttendanceJSP.setData([]);
                    }
                    wait.close();
                }
            });
        }else{
            DynamicForm_Attendance.getItem("sessionDate").changed(DynamicForm_Attendance, DynamicForm_Attendance.getItem("sessionDate"), oldValue);
            DynamicForm_Attendance.setValue("sessionDate", oldValue);
        }
    }

    function checkAttendanceListGrid() {

        classGridRecordInAttendanceJsp == ListGrid_Class_JspClass.getSelectedRecord()

        if(attendanceGrid.getAllEditRows().length>0){
            createDialog("[SKIN]error","حضور و غیاب ذخیره نشده است.","یادآوری");
            return;
        }
        if(classGridRecordInAttendanceJsp == ListGrid_Class_JspClass.getSelectedRecord()){
            ListGrid_Attendance_Refresh();
            return;
        }
        classGridRecordInAttendanceJsp = ListGrid_Class_JspClass.getSelectedRecord();
        if (!(classGridRecordInAttendanceJsp == null)) {
            DynamicForm_Attendance.setValue("attendanceTitle", "کلاس " + (classGridRecordInAttendanceJsp.titleClass?classGridRecordInAttendanceJsp.titleClass:classGridRecordInAttendanceJsp.course.titleFa) + " گروه " + classGridRecordInAttendanceJsp.group);
            DynamicForm_Attendance.setValue("sessionDate","");
            DynamicForm_Attendance.redraw();
            sessionInOneDate.length = 0;
            sessionsForStudent.length = 0;
            ListGrid_Attendance_AttendanceJSP.invalidateCache();
        }
        else{
            DynamicForm_Attendance.setValue("attendanceTitle", "");
            DynamicForm_Attendance.redraw();
            sessionInOneDate.length = 0;
            sessionsForStudent.length = 0;
            ListGrid_Attendance_AttendanceJSP.invalidateCache();
        }

        if(classGridRecordInAttendanceJsp.classStatus === "3")
        {
            <sec:authorize access="hasAnyAuthority('TclassAttendanceTab_ShowOption')">
            ToolStrip_Attendance_JspAttendance.setVisibility(false)
            TrHLayoutButtons.setVisibility(false)
            </sec:authorize>
        }
        else
        {
            <sec:authorize access="hasAnyAuthority('TclassAttendanceTab_ShowOption')">
            ToolStrip_Attendance_JspAttendance.setVisibility(true)
            TrHLayoutButtons.setVisibility(true)
            </sec:authorize>
        }
        if (classGridRecordInAttendanceJsp.classStatus === "3")
        {
            <sec:authorize access="hasAuthority('TclassAttendanceTab_classStatus')">
            ToolStrip_Attendance_JspAttendance.setVisibility(true)
            TrHLayoutButtons.setVisibility(true)
            </sec:authorize>
        }
    }

    function loadPage_Attendance() {
        if(classRecord === null || classRecord !== ListGrid_Class_JspClass.getSelectedRecord()){
            classRecord = ListGrid_Class_JspClass.getSelectedRecord();
            isAttendanceDate = true;
        }
        refreshDate();
        checkAttendanceListGrid();
        isAttendanceDate = false;
    }

    function ListGrid_Attendance_Refresh(form = attendanceForm) {
        let oldValue = form.getValue("sessionDate");
        form.getItem("filterType").changed(form, form.getItem("filterType"), form.getValue("filterType"));
        form.getItem("sessionDate").click(form, form.getItem("sessionDate"));
        if(form.getValue("filterType") == 2) {
            let myInterval = setInterval(function () {
                if(sessionDateData.allRows !== null && sessionDateData.allRows !== undefined){
                    for (let i = 0; i < sessionDateData.allRows.length; i++) {
                        if (sessionDateData.allRows[i].sessionDate == oldValue) {
                            form.setValue("sessionDate", oldValue);
                            form.getItem("sessionDate").changed(form, form.getItem("sessionDate"), form.getValue("sessionDate"));
                            clearInterval(myInterval)
                        }
                    }
                    clearInterval(myInterval);
                }
                form.setValue("sessionDate", oldValue);
            }, 250);
        }
        else{
            let myInterval = setInterval(function () {
                if(sessionDateData.allRows !== null && sessionDateData.allRows !== undefined){
                    for (let i = 0; i < sessionDateData.allRows.length; i++) {
                        if (sessionDateData.allRows[i].sessionDate === oldValue) {
                            form.setValue("sessionDate", oldValue);
                            form.getItem("sessionDate").changed(form, form.getItem("sessionDate"), form.getValue("sessionDate"));
                            clearInterval(myInterval);
                        }
                    }
                    clearInterval(myInterval);
                }
                form.setValue("sessionDate", oldValue);
            }, 250)
        }
    }

    function printClearForm(list,page) {
        let criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/attendance/clear-print/pdf"/>",
            target: "_Blank",
            canSubmit: true,
            fields:[
                {name: "classId", type: "hidden"},
                {name: "list", type: "hidden"},
                {name: "page", type: "hidden"},
            ]
        });
        criteriaForm.setValue("classId", classGridRecordInAttendanceJsp.id);
        criteriaForm.setValue("list", JSON.stringify(list));
        criteriaForm.setValue("page", page);
        criteriaForm.show();
        criteriaForm.submitForm();
    }
    function printFullClearForm() {
        let criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/attendance/full-clear-print/pdf"/>",
            target: "_Blank",
            canSubmit: true,
            numCols: 3,
            colWidths: [50,150,70],
            fields:
                [
                    {name: "txt", title: "تعداد سطر: ", keyPressFilter : "[0-9]", editorType: "SpinnerItem",
                        writeStackedIcons: false,
                        defaultValue: 20,
                        min: 1,
                        max: 500,
                    },
                    {name: "list", type: "hidden"},
                    {
                        name: "btnConfirm",
                        title: "چاپ",
                        startRow: false,
                        type:"Button",
                        click(){
                            if(criteriaForm.getValue("txt") != null){
                                let list = [];
                                for (let i = 1; i <= parseInt(criteriaForm.getValue("txt")) ; i++) {
                                    let object = {};
                                    object.row = i;
                                    list.push(object);
                                }
                                // console.log(list);
                                criteriaForm.setValue("list", JSON.stringify(list));
                                criteriaForm.submitForm();
                            }
                        }
                    }
                ]
        });
        let windowPrint = isc.Window.create({
            title: "",
            keepInParentRect: true,
            autoSize: true,
            items:[
                criteriaForm
            ]
        });
        windowPrint.show();
    }


    //</script>
