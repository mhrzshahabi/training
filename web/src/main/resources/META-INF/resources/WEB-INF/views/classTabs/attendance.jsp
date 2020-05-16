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
    var sessionsForStudent = [];
    var filterValuesUnique = [];
    var filterValuesUnique1 = [];
    var filterValues = [];
    var filterValues1 = [];
    var sessionDateData;
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
            {name: "personalNum", type: "text", title: "شماره پرسنلی"},
            {name: "nationalCode", type: "text", title: "کد ملی"},
            {name: "company", type: "text", title: "شرکت"},
            {name: "studentState", type: "text", title: "وضعیت"},
        ],
    });
    var DataSource_SessionsForStudent = isc.DataSource.create({
        ID: "attendanceStudentDS",
        clientOnly: true,
        testData: sessionsForStudent,
        // dataFormat: "json",
        // dataURL: attendanceUrl + "/session-in-date",
        fields: [
            {name: "studentId", hidden: true},
            {name: "sessionId", hidden: true, primaryKey: true},
            {name: "studentState", hidden:true, type: "text", title: "وضعیت"},
            {name: "sessionType", title:"نوع جلسه"},
            {name: "sessionDate", type: "text", title: "تاریخ"},
            {name: "startHour", type: "text", title: "ساعت شروع"},
            {name: "endHour", type: "text", title: "ساعت پایان"},
            {name: "state", type: "text", title: "وضعیت"},
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
    var RestData_Student_AttendanceJSP = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "studentId"},
            {name: "firstName"},
            {name: "lastName"},
            {name: "nationalCode"},
            {name: "companyName"},
            {name: "personnelNo"},
            {name: "personnelNo2"},
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
                                if(ListGrid_JspAttachment.getSelectedRecord() == undefined){
                                    createDialog("info", "لطفاً رکوردی را انتخاب نمایید.", "پیغام");
                                }
                                if(trTrim(ListGrid_JspAttachment.getSelectedRecord().description) != null) {
                                    absenceForm.setValue("cause", ListGrid_JspAttachment.getSelectedRecord().description);
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
                VLayout_Body_JspAttachment.addMembers([
                    HLayout_Actions_JspAttachment,
                    HLayout_Grid_JspAttachment
                ]);
                ListGrid_JspAttachment.setShowFilterEditor(true);
                this.Super("hide",arguments);
                DynamicForm_JspAttachments.getItem("description").title = "<spring:message code="description"/>";
                ListGrid_JspAttachment.getField("description").title = "<spring:message code="description"/>";
            },
            show(){
                VLayout_Attachment_JspAttendance.addMembers([
                    HLayout_Actions_JspAttachment,
                    HLayout_Grid_JspAttachment
                ]);
                // ListGrid_JspAttachment.invalidateCache();
                // VLayout_Attachment_JspAttendance.redraw();
                ListGrid_JspAttachment.getField("description").title = "شماره نامه";
                this.Super("show",arguments);
                DynamicForm_JspAttachments.getItem("description").title = "شماره نامه:";
            }
    });
    var ToolStrip_Attendance_JspAttendance = isc.ToolStrip.create({
        members: [
            isc.ToolStripButton.create({
                title: "تبدیل همه به 'حاضر'",
                click: function () {
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
                    for (let i = 0; i < ListGrid_Attendance_AttendanceJSP.getData().localData.length ; i++) {
                        for (let j = 5; j < attendanceGrid.getAllFields().length; j++) {
                            if(attendanceGrid.getCellRecord(i).studentState != "kh") {
                                attendanceGrid.setEditValue(i, j, "2");
                            }
                        }
                    }
                }
            }),
            isc.ToolStripButtonExcel.create({
                // title: "خروجی اکسل",
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
                    }
                    else{
                        for (let i = 0; i < allRows.length; i++) {
                            allRows[i]["state"] = attendanceState[allRows[i]["state"]];
                        }
                    }
                    exportToExcel(sendFields, allRows);
                }
            }),
            isc.ToolStripButtonPrint.create({
                // title: "خروجی اکسل",
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
                      // loadPage_Attendance();
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
                          {name: "sessionDate", title: "تاریخ"}
                      ];
                      form.getItem("sessionDate").displayField = "sessionDate";
                      form.getItem("sessionDate").valueField = "sessionDate";
                      form.getItem("sessionDate").optionDataSource = RestData_SessionDate_AttendanceJSP;
                      form.getItem("sessionDate").pickListWidth = 200;
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
                  }
                  sessionsForStudent.length = 0;
                  sessionInOneDate.length = 0;
                  ListGrid_Attendance_AttendanceJSP.invalidateCache();
                  form.setValue("sessionDate","");
                }
            },
            {
                name: "sessionDate",
                autoFetchData: false,
                width:200,
                type: "SelectItem",
                showTitle:false,
                optionDataSource: RestData_SessionDate_AttendanceJSP,
                textAlign: "center",
                sortField: 1,
                sortDirection: "descending",
                pickListFields: [
                    {name: "dayName", title: "روز هفته"},
                    {name: "sessionDate", title: "تاریخ"}
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
                    var wait = createDialog("wait");
                    if (form.getValue("filterType") == 1) {
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
                                let fields1 = [
                                    {name: "studentName", title: "نام", valueMap: filterValuesUnique1, multiple: true},
                                    {name: "studentFamily", title: "نام خانوادگی", valueMap: filterValuesUnique, multiple: true},
                                    {name: "nationalCode", title: "کد ملی"},
                                    {name: "company", title: "شرکت"},
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
                                                                            loadPage_attachment("Tclass", classGridRecordInAttendanceJsp.id, "<spring:message code="attachment"/>",{4:"نامه غیبت موجه"});
                                                                            Window_Attach.show();
                                                                            ListGrid_JspAttachment.fetchData({"fileTypeId":4});
                                                                            ListGrid_JspAttachment.filterByEditor();
                                                                            ListGrid_JspAttachment.setShowFilterEditor(false);
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
                                                                            // alert(item.getFieldName())
                                                                            // alert(attendanceGrid.getSelectedRecord().studentId)
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
                                            } else if (value == 3) {
                                                var sessionIds = [];
                                                sessionIds.add(item.getFieldName().substr(2));
                                                for (let i = 5; i < this.grid.getAllFields().length; i++) {
                                                    if (this.grid.getEditValue(this.rowNum, i) == 3) {
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
                                                        if (!JSON.parse(resp.data)) {
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
                                                                        record1.studentState = "kh";
                                                                        attendanceGrid.updateData(record1);
                                                                        attendanceGrid.focusInFilterEditor();
                                                                        isc.RPCManager.sendRequest({
                                                                            actionURL: parameterValueUrl + "/get-id/?code=kh",
                                                                            httpMethod: "GET",
                                                                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                                                            useSimpleHttp: true,
                                                                            contentType: "application/json; charset=utf-8",
                                                                            showPrompt: false,
                                                                            serverOutputAsString: false,
                                                                            callback: function (resp) {
                                                                                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                                                                                    let data = {
                                                                                        "presenceTypeId": JSON.parse(resp.data)
                                                                                    };
                                                                                    isc.RPCManager.sendRequest({
                                                                                        actionURL: tclassStudentUrl + "/" + record1.classStudentId,
                                                                                        httpMethod: "PUT",
                                                                                        httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                                                                        useSimpleHttp: true,
                                                                                        contentType: "application/json; charset=utf-8",
                                                                                        showPrompt: false,
                                                                                        serverOutputAsString: false,
                                                                                        data: JSON.stringify(data),
                                                                                        callback: function (resp) {}
                                                                                    });
                                                                                    return;
                                                                                }
                                                                            }
                                                                        });
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
                                            if (this.colNum == 5 && (value == 1 || value == 2)) {
                                                for (let i = 6; i < this.grid.getAllFields().length; i++) {
                                                    this.grid.setEditValue(this.rowNum, i, value);
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
                                        }
                                    });
                                }
                                attendanceGrid.fetchData();
                            }
                        });
                    }
                    if (form.getValue("filterType") == 2) {
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
                                            title: "تاریخ",
                                            valueMap: filterValuesUnique,
                                            multiple: true
                                        },
                                        {name: "startHour", title: "ساعت شروع"},
                                        {name: "endHour", title: "ساعت پایان"},
                                        {name: "state", title: "وضعیت", valueMap:attendanceState},
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
                                                                            ListGrid_JspAttachment.fetchData({"fileTypeId":4});
                                                                            ListGrid_JspAttachment.filterByEditor();
                                                                            ListGrid_JspAttachment.setShowFilterEditor(false);
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
                                                                            // alert(item.getFieldName())
                                                                            // alert(attendanceGrid.getSelectedRecord().studentId)
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
                                            } else if (value == 3) {
                                                var sessionIds = [];
                                                sessionIds.add(attendanceGrid.getSelectedRecord().sessionId);
                                                for (let i = 0; i < this.grid.getAllEditRows().length; i++) {
                                                    if (this.grid.getEditValue(this.grid.getAllEditRows()[i], "state") == 3) {
                                                        sessionIds.add(this.grid.getRecord(this.grid.getAllEditRows()[i]).sessionId)
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
                                                        if (!JSON.parse(resp.data)) {
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
                                                                        for (let i = 0; i <attendanceGrid.getData().allRows.length ; i++) {
                                                                            let record1 = attendanceGrid.getRecord(i);
                                                                            record1.studentState = "kh";
                                                                            attendanceGrid.updateData(record1);
                                                                        }
                                                                        // attendanceGrid.saveEdits(null,null,this.rowNum);
                                                                        attendanceGrid.focusInFilterEditor();
                                                                        isc.RPCManager.sendRequest({
                                                                            actionURL: parameterValueUrl + "/get-id/?code=kh",
                                                                            httpMethod: "GET",
                                                                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                                                            useSimpleHttp: true,
                                                                            contentType: "application/json; charset=utf-8",
                                                                            showPrompt: false,
                                                                            serverOutputAsString: false,
                                                                            callback: function (resp) {
                                                                                if(resp.httpResponseCode == 200 || resp.httpResponseCode == 201){
                                                                                    let data = {
                                                                                        "presenceTypeId": JSON.parse(resp.data)
                                                                                    };
                                                                                    isc.RPCManager.sendRequest({
                                                                                        actionURL: tclassStudentUrl + "/" + attendanceForm.getValue("sessionDate"),
                                                                                        httpMethod: "PUT",
                                                                                        httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                                                                        useSimpleHttp: true,
                                                                                        contentType: "application/json; charset=utf-8",
                                                                                        showPrompt: false,
                                                                                        serverOutputAsString: false,
                                                                                        data: JSON.stringify(data),
                                                                                        callback: function (resp) {
                                                                                        }
                                                                                    });
                                                                                    return;
                                                                                }
                                                                            }
                                                                        });
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
                                    // for (let i = 5; i < attendanceGrid.getAllFields().size(); i++) {
                                    // }
                                    attendanceGrid.fetchData();
                                    $.each(filterValues, function(i, el){
                                        if($.inArray(el, filterValuesUnique) === -1) filterValuesUnique.push(el);
                                    });
                                    filterValuesUnique.sort()
                                }
                            }
                        })
                    }
                },
                dataArrived: function (startRow, endRow, data) {
                    this.Super("dataArrived", arguments);
                    sessionDateData = data;
                },
            },

            <%--{--%>
                <%--name: "presentAll",--%>
                <%--title: "تبدیل همه به 'حاضر'",--%>
                <%--type: "ButtonItem",--%>
                <%--startRow:true,--%>
                <%--endRow:false,--%>
                <%--labelAsTitle: true,--%>
                <%--click (form, item) {--%>
                        <%--for (let i = 0; i < ListGrid_Attendance_AttendanceJSP.getData().localData.length ; i++) {--%>
                            <%--for (let j = 5; j < attendanceGrid.getAllFields().length; j++) {--%>
                                <%--if(attendanceGrid.getCellRecord(i).studentState != "kh") {--%>
                                    <%--attendanceGrid.setEditValue(i, j, "1");--%>
                                <%--}--%>
                            <%--}--%>
                        <%--}--%>
                <%--}--%>
            <%--},--%>
            <%--{--%>
                <%--name: "presentExtendAll",--%>
                <%--title: "تبدیل همه به 'حاضر و اضافه کار'",--%>
                <%--type: "ButtonItem",--%>
                <%--startRow:false,--%>
                <%--endRow:false,--%>
                <%--labelAsTitle: true,--%>
                <%--click (form, item) {--%>
                        <%--for (let i = 0; i < ListGrid_Attendance_AttendanceJSP.getData().localData.length ; i++) {--%>
                            <%--for (let j = 5; j < attendanceGrid.getAllFields().length; j++) {--%>
                                <%--if(attendanceGrid.getCellRecord(i).studentState != "kh") {--%>
                                    <%--attendanceGrid.setEditValue(i, j, "2");--%>
                                <%--}--%>
                            <%--}--%>
                        <%--}--%>

                <%--}--%>
            <%--},--%>
            <%--{--%>
                <%--name: "printBtn",--%>
                <%--ID: "printBtnAttendanceJsp",--%>
                <%--// showTitle: false,--%>
                <%--title: "خروجی اکسل",--%>
                <%--&lt;%&ndash;prompt:"<spring:message code="refresh"/>",&ndash;%&gt;--%>
                <%--startRow:false,--%>
                <%--type: "ButtonItem",--%>
                <%--// icon: "[SKIN]/actions/refresh.png",--%>
                <%--endRow:false,--%>
                <%--click () {--%>
                    <%--let fields = ListGrid_Attendance_AttendanceJSP.getFields();--%>
                    <%--let sendFields = [];--%>
                    <%--for (let i = 1; i < fields.length; i++) {--%>
                        <%--let record = {};--%>
                        <%--record.title = fields[i].title;--%>
                        <%--record.name = fields[i].name;--%>
                        <%--sendFields.push(record)--%>
                    <%--}--%>
                    <%--let allRows = ListGrid_Attendance_AttendanceJSP.data.allRows.toArray();--%>
                    <%--let keys = Object.keys(ListGrid_Attendance_AttendanceJSP.data.allRows[0]);--%>
                    <%--let sessionKeys = keys.filter(k => k.startsWith("se"));--%>
                    <%--if(sessionKeys.indexOf("sessionDate") == -1) {--%>
                        <%--for (let i = 0; i < allRows.length; i++) {--%>
                            <%--for (let j = 0; j < sessionKeys.length; j++) {--%>
                                <%--allRows[i][sessionKeys[j]] = attendanceState[allRows[i][sessionKeys[j]]];--%>
                            <%--}--%>
                        <%--}--%>
                    <%--}--%>
                    <%--else{--%>
                        <%--for (let i = 0; i < allRows.length; i++) {--%>
                            <%--allRows[i]["state"] = attendanceState[allRows[i]["state"]];--%>
                        <%--}--%>
                    <%--}--%>
                    <%--exportToExcel(sendFields, allRows);--%>
                <%--}--%>
            <%--},--%>
            <%--{--%>
                <%--name: "printBtn1",--%>
                <%--// showTitle: false,--%>
                <%--title: "چاپ",--%>
                <%--&lt;%&ndash;prompt:"<spring:message code="refresh"/>",&ndash;%&gt;--%>
                <%--startRow:false,--%>
                <%--type: "ButtonItem",--%>
                <%--// icon: "[SKIN]/actions/refresh.png",--%>
                <%--endRow:false,--%>
                <%--click () {--%>
                    <%--let params = {};--%>
                    <%--params.code = classGridRecordInAttendanceJsp.code;--%>
                    <%--params.titleClass = classGridRecordInAttendanceJsp.titleClass;--%>
                    <%--params.startDate = classGridRecordInAttendanceJsp.startDate;--%>
                    <%--params.teacher = classGridRecordInAttendanceJsp.teacher;--%>
                    <%--params.institute = classGridRecordInAttendanceJsp.institute.titleFa;--%>
                    <%--params.date = DynamicForm_Attendance.getValue("sessionDate");--%>
                    <%--let localData = ListGrid_Attendance_AttendanceJSP.data.localData.toArray();--%>
                    <%--let data = [];--%>
                    <%--if(DynamicForm_Attendance.getValue("filterType") == "1") {--%>
                        <%--let keys = Object.keys(ListGrid_Attendance_AttendanceJSP.data.allRows[0]);--%>
                        <%--let sessionKeys = keys.filter(k => k.startsWith("se"));--%>
                        <%--sessionKeys.sort();--%>
                        <%--for (let k = 0; k < sessionKeys.length; k++) {--%>
                            <%--params["se" + (k + 1).toString()] = ListGrid_Attendance_AttendanceJSP.getField(sessionKeys[k]).title;--%>
                        <%--}--%>
                        <%--for (let i = 0; i < localData.length; i++) {--%>
                            <%--let obj = {};--%>
                            <%--obj.fullName = localData[i].studentName + " " + localData[i].studentFamily;--%>
                            <%--obj.nationalCode = localData[i].nationalCode;--%>
                            <%--obj.personalNum = localData[i].personalNum;--%>
                            <%--for (let j = 0; j < sessionKeys.length; j++) {--%>
                                <%--obj["session" + (j + 1).toString()] = printAttendanceState[localData[i][sessionKeys[j]]]--%>
                            <%--}--%>
                            <%--data.push(obj);--%>
                        <%--}--%>
                        <%--printToJasper(data, params, "attendance.jasper");--%>
                    <%--}--%>
                <%--}--%>
            <%--},--%>
            <%--{--%>
                <%--name: "refreshBtn",--%>
                <%--ID: "refreshBtnAttendanceJsp",--%>
                <%--// showTitle: false,--%>
                <%--title: "",--%>
                <%--prompt:"<spring:message code="refresh"/>",--%>
                <%--startRow:false,--%>
                <%--type: "ButtonItem",--%>
                <%--icon: "[SKIN]/actions/refresh.png",--%>
                <%--endRow:false,--%>
                <%--click () {--%>
                    <%--loadPage_Attendance()--%>
                <%--}--%>
            <%--},--%>
        ],
    });
    var ListGrid_Attendance_AttendanceJSP = isc.TrLG.create({
        ID: "attendanceGrid",
        dynamicTitle: true,
        // confirmDiscardEdits: false,
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
        showHeaderContextMenu:false,
        gridComponents: [DynamicForm_Attendance, ToolStrip_Attendance_JspAttendance, "header", "filterEditor", "body", isc.TrHLayoutButtons.create({
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
        canHover:true,
        canEditCell(rowNum, colNum){
            return colNum >= 5 && attendanceGrid.getSelectedRecord().studentState !== "kh";
        },
        saveAllEdits(){
            this.Super("saveAllEdits",arguments);
            setTimeout(function () {
                if(attendanceForm.getValue("filterType")==1) {
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
                }
                else if(attendanceForm.getValue("filterType")==2) {
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
                            if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                                simpleDialog("<spring:message code="create"/>", "<spring:message code="msg.operation.successful"/>", 2000, "say");
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
        if(classGridRecordInAttendanceJsp == ListGrid_Class_JspClass.getSelectedRecord()){
            ListGrid_Attendance_Refresh();
            return;
        }
        classGridRecordInAttendanceJsp = ListGrid_Class_JspClass.getSelectedRecord();
        if (!(classGridRecordInAttendanceJsp == null)) {
            // DynamicForm_Attendance.setValue("sessionDate", "");
            DynamicForm_Attendance.setValue("attendanceTitle", "کلاس " + classGridRecordInAttendanceJsp.titleClass + " گروه " + classGridRecordInAttendanceJsp.group);
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
    }

    function ListGrid_Attendance_Refresh(form = attendanceForm) {
        let oldValue = form.getValue("sessionDate");
        form.getItem("filterType").changed(form, form.getItem("filterType"), form.getValue("filterType"));
        form.getItem("sessionDate").click(form, form.getItem("sessionDate"));
        if(form.getValue("filterType") == 2) {
            setTimeout(function () {
                for (let i = 0; i < sessionDateData.allRows.length; i++) {
                    if (sessionDateData.allRows[i].id == oldValue) {
                        form.setValue("sessionDate", oldValue);
                        form.getItem("sessionDate").changed(form, form.getItem("sessionDate"), form.getValue("sessionDate"));
                        return;
                    }
                }
            }, 500)
        }
        else{
            setTimeout(function () {
                for (let i = 0; i < sessionDateData.allRows.length; i++) {
                    if (sessionDateData.allRows[i].sessionDate == oldValue) {
                        form.setValue("sessionDate", oldValue);
                        form.getItem("sessionDate").changed(form, form.getItem("sessionDate"), form.getValue("sessionDate"));
                        return;
                    }
                }
            }, 500)
        }
    }


    // isc.confirm.addProperties({
    //     buttonClick: function (button, index) {
    //         this.close();
    //         if (index === 1) {
    //             console.log("save click shod")
    //         }
    //     }
    // });

    //</script>