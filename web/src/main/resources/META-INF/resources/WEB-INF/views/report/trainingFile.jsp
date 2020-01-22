<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    var classGridRecordInTrainingFileJsp = null;
    var causeOfAbsence = [];
    var sessionInOneDate = [];
    var sessionsForStudent = [];
    var filterValuesUnique = [];
    var filterValuesUnique1 = [];
    var filterValues = [];
    var filterValues1 = [];
    var sessionDateData;
    var TrainingFileState = {
        "0": "نامشخص",
        "1": "حاضر",
        "2": "حاضر و اضافه کار",
        "3": "غیبت غیر موجه",
        "4": "غیبت موجه",
    };
    var DataSource_SessionInOneDate = isc.DataSource.create({
        ID: "TrainingFileDS",
        clientOnly: true,
        testData: sessionInOneDate,
        // dataFormat: "json",
        // dataURL: TrainingFileUrl + "/session-in-date",
        fields: [
            {name: "studentId", hidden: true, primaryKey: true},
            {name: "studentName", type: "text", title: "نام"},
            {name: "studentFamily", type: "text", title: "نام خانوادگی"},
            {name: "nationalCode", type: "text", title: "کد ملی"},
            {name: "company", type: "text", title: "شرکت"},
            {name: "studentState", type: "text", title: "وضعیت"},
        ],
    });
    var DataSource_SessionsForStudent = isc.DataSource.create({
        ID: "TrainingFileStudentDS",
        clientOnly: true,
        testData: sessionsForStudent,
        // dataFormat: "json",
        // dataURL: TrainingFileUrl + "/session-in-date",
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
    var RestData_SessionDate_TrainingFileJSP = isc.TrDS.create({
        fields: [
            {name: "sessionDate", primaryKey: true},
            {name: "dayName"},
        ],
        autoFetchData: false,
        fetchDataURL: TrainingFileUrl + "/session-date?id=0"
    });
    var RestData_Student_TrainingFileJSP = isc.TrDS.create({
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
        fetchDataURL: TrainingFileUrl + "/students?classId=0"
    });
    var VLayout_Attachment_JspTrainingFile = isc.TrVLayout.create({
        members:[],
    });
    var Window_Attach = isc.Window.create({
            ID:"attachWindow",
            title: "علت غیبت",
            autoSize: false,
            width: "70%",
            height:"60%",
            items:[
                VLayout_Attachment_JspTrainingFile,
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
                VLayout_Attachment_JspTrainingFile.addMembers([
                    HLayout_Actions_JspAttachment,
                    HLayout_Grid_JspAttachment
                ]);
                // ListGrid_JspAttachment.invalidateCache();
                // VLayout_Attachment_JspTrainingFile.redraw();
                ListGrid_JspAttachment.getField("description").title = "شماره نامه";
                this.Super("show",arguments);
                DynamicForm_JspAttachments.getItem("description").title = "شماره نامه:";
            }
    });
    var DynamicForm_TrainingFile = isc.DynamicForm.create({
        ID: "TrainingFileForm",
        numCols: 6,
        padding: 10,
        // cellBorder:2,
        colWidths:[250,200,200,100,100,50],
        fields: [
            {
                name: "personnelNo2",
                text:"<spring:message code="personnel.no.6.digits"/> ",
                // textBoxStyle: "font-weight:bold; font-color:red;",
                textAlign: "center",
                width: "*"
            },{
                name: "personnelNo",
                text:"<spring:message code="personnel.no"/> ",
                // textBoxStyle: "font-weight:bold; font-color:red;",
                textAlign: "center",
                width: "*"
            },{
                name: "firstName",
                text:"<spring:message code="personnel.no"/> ",
                // textBoxStyle: "font-weight:bold; font-color:red;",
                textAlign: "center",
                width: "*"
            },{
                name: "lastName",
                text:"<spring:message code="personnel.no"/> ",
                // textBoxStyle: "font-weight:bold; font-color:red;",
                textAlign: "center",
                width: "*"
            },{
                name: "nationalCode",
                text:"<spring:message code="personnel.no"/> ",
                // textBoxStyle: "font-weight:bold; font-color:red;",
                textAlign: "center",
                width: "*"
            },
            // {
            //     type: "SpacerItem"
            // },
            {
                name: "presentAll",
                title: "تبدیل همه به 'حاضر'",
                type: "ButtonItem",
                startRow:false,
                endRow:false,
                labelAsTitle: true,
                click (form, item) {
                        for (let i = 0; i < ListGrid_TrainingFile_TrainingFileJSP.getData().localData.length ; i++) {
                            for (let j = 5; j < TrainingFileGrid.getAllFields().length; j++) {
                                if(TrainingFileGrid.getCellRecord(i).studentState != "kh") {
                                    TrainingFileGrid.setEditValue(i, j, "1");
                                }
                            }
                        }
                }
            },
            {
                name: "presentExtendAll",
                title: "تبدیل همه به 'حاضر و اضافه کار'",
                type: "ButtonItem",
                startRow:false,
                endRow:false,
                labelAsTitle: true,
                click (form, item) {
                        for (let i = 0; i < ListGrid_TrainingFile_TrainingFileJSP.getData().localData.length ; i++) {
                            for (let j = 5; j < TrainingFileGrid.getAllFields().length; j++) {
                                if(TrainingFileGrid.getCellRecord(i).studentState != "kh") {
                                    TrainingFileGrid.setEditValue(i, j, "2");
                                }
                            }
                        }

                }
            },
            {
                name: "refreshBtn",
                ID: "refreshBtnTrainingFileJsp",
                // showTitle: false,
                title: "",
                prompt:"<spring:message code="refresh"/>",
                startRow:false,
                type: "ButtonItem",
                icon: "[SKIN]/actions/refresh.png",
                endRow:false,
                click () {
                    loadPage_TrainingFile()
                }
            },
        ],
    });
    var ListGrid_TrainingFile_TrainingFileJSP = isc.TrLG.create({
        ID: "TrainingFileGrid",
        dynamicTitle: true,
        // confirmDiscardEdits: false,
        dynamicProperties: true,
        autoSaveEdits: false,
        // allowFilterExpressions: true,
        // allowAdvancedCriteria: true,
        filterOnKeypress: true,
        // filterLocalData:true,
        dataSource: "TrainingFileDS",
        // data:sessionInOneDate,
        // canEdit: true,
        modalEditing: true,
        editEvent: "none",
        editOnFocus: true,
        editByCell: true,
        gridComponents: [DynamicForm_TrainingFile, "header", "filterEditor", "body", isc.TrHLayoutButtons.create({
            members: [
                isc.IButtonSave.create({
                    ID: "saveBtn",
                    click: function () {
                        if(TrainingFileGrid.getAllEditRows().length <= 0){
                            createDialog("[SKIN]error","تغییری رخ نداده است.","خطا");
                            return;
                        }
                        TrainingFileGrid.endEditing();
                        TrainingFileGrid.saveAllEdits();


                        // TrainingFileGrid.endEditing();
                    }
                }),
                isc.IButtonCancel.create({
                    ID: "cancelBtn",
                    click: function () {
                        TrainingFileGrid.discardAllEdits()
                        // TrainingFileForm.getItem("sessionDate").changed(TrainingFileForm,TrainingFileForm.getItem("sessionDate"),TrainingFileForm.getValue("sessionDate"));
                    }
                })
            ]
        })],
        canHover:true,
        canEditCell(rowNum, colNum){
            return colNum >= 5 && TrainingFileGrid.getSelectedRecord().studentState !== "kh";
        },
        saveAllEdits(){
            this.Super("saveAllEdits",arguments);
            setTimeout(function () {
                if(TrainingFileForm.getValue("filterType")==1) {
                    isc.RPCManager.sendRequest({
                        actionURL: TrainingFileUrl + "/save-TrainingFile?classId=" + classGridRecordInTrainingFileJsp.id + "&date=" + DynamicForm_TrainingFile.getValue("sessionDate"),
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
                else if(TrainingFileForm.getValue("filterType")==2) {
                    isc.RPCManager.sendRequest({
                        actionURL: TrainingFileUrl + "/student-TrainingFile-save",
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
        }
        // fields:[]
        // optionDataSource: DataSource_SessionInOneDate,
        // autoFetchData:true,

    });
    var VLayout_Body_Training_File = isc.VLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [
            // DynamicForm_TrainingFile,
            ListGrid_TrainingFile_TrainingFileJSP
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

    function loadPage_TrainingFile() {
        // if(ListGrid_Class_JspClass.getSelectedRecord() === classGridRecordInTrainingFileJsp){
        //     return;
        // }
        if(TrainingFileGrid.getAllEditRows().length>0){
            createDialog("[SKIN]error","حضور و غیاب ذخیره نشده است.","یادآوری");
            return;
        }
        if(classGridRecordInTrainingFileJsp == ListGrid_Class_JspClass.getSelectedRecord()){
            ListGrid_TrainingFile_Refresh();
            return;
        }
        classGridRecordInTrainingFileJsp = ListGrid_Class_JspClass.getSelectedRecord();
        if (!(classGridRecordInTrainingFileJsp == null)) {
            // DynamicForm_TrainingFile.setValue("sessionDate", "");
            DynamicForm_TrainingFile.setValue("TrainingFileTitle", "کلاس " + classGridRecordInTrainingFileJsp.titleClass + " گروه " + classGridRecordInTrainingFileJsp.group);
            DynamicForm_TrainingFile.setValue("sessionDate","");
            DynamicForm_TrainingFile.redraw();
            sessionInOneDate.length = 0;
            sessionsForStudent.length = 0;
            ListGrid_TrainingFile_TrainingFileJSP.invalidateCache();
        }
        else{
            DynamicForm_TrainingFile.setValue("TrainingFileTitle", "");
            DynamicForm_TrainingFile.redraw();
            sessionInOneDate.length = 0;
            sessionsForStudent.length = 0;
            ListGrid_TrainingFile_TrainingFileJSP.invalidateCache();
        }
    }

    function ListGrid_TrainingFile_Refresh(form = TrainingFileForm) {
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