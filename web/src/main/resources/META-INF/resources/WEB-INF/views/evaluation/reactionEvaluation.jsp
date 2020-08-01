<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);%>
// <script>
    //----------------------------------------- Variables --------------------------------------------------------------
        var evalWait_RE;

        var classRecord_RE;

    //----------------------------------------- DataSources ------------------------------------------------------------
        var RestDataSource_student_RE = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {name: "student.id", hidden: true},
                {
                    name: "student.firstName",
                    title: "<spring:message code="firstName"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "student.lastName",
                    title: "<spring:message code="lastName"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "student.nationalCode",
                    title: "<spring:message code="national.code"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                },
                {
                    name: "applicantCompanyName",
                    title: "<spring:message code="company.applicant"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "presenceTypeId",
                    title: "<spring:message code="class.presence.type"/>",
                    filterOperator: "equals",
                    autoFitWidth: true
                },
                {
                    name: "student.companyName",
                    title: "<spring:message code="company.name"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "student.personnelNo",
                    title: "<spring:message code="personnel.no"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "student.personnelNo2",
                    title: "<spring:message code="personnel.no.6.digits"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "student.postTitle",
                    title: "<spring:message code="post"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "student.ccpArea",
                    title: "<spring:message code="reward.cost.center.area"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "evaluationStatusReaction",
                    title: "<spring:message code="evaluation.reaction.status"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "evaluationStatusLearning",
                    title: "<spring:message code="evaluation.learning.status"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "evaluationStatusBehavior",
                    title: "<spring:message code="evaluation.behavioral.status"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "evaluationStatusResults",
                    title: "<spring:message code="evaluation.results.status"/>",
                    filterOperator: "iContains"
                }
            ],
        });

    //----------------------------------------- DynamicForms -----------------------------------------------------------
        var DynamicForm_ReturnDate_RE = isc.DynamicForm.create({
            width: "150px",
            height: "10px",
            padding: 0,
            fields: [
                {
                    name: "evaluationReturnDate",
                    title: "<spring:message code='return.date'/>",
                    ID: "ReturnDate_RE",
                    width: "150px",
                    hint: "----/--/--",
                    keyPressFilter: "[0-9/]",
                    showHintInField: true,
                    icons: [{
                        src: "<spring:url value="calendar.png"/>",
                        click: function (form) {
                            closeCalendarWindow();
                            displayDatePicker('ReturnDate_RE', this, 'ymd', '/');
                        }
                    }],
                    textAlign: "center",
                    click: function (form) {

                    },
                    changed: function (form, item, value) {
                        evaluation_check_date_RE();
                    }
                }
            ]
        });

    //----------------------------------------- ListGrids --------------------------------------------------------------
        var ListGrid_student_RE = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_student_RE,
            selectionType: "single",
            showRecordComponents: true,
            showRecordComponentsByCell: true,
            sortField: 5,
            sortDirection: "descending",
            fields: [
                {name: "student.firstName"},
                {name: "student.lastName"},
                {name: "student.nationalCode",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {name: "student.personnelNo",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {name: "student.personnelNo2",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {
                    name: "applicantCompanyName",
                    textAlign: "center"
                },
                {
                    name: "evaluationStatusReaction",
                    valueMap: {
                        "0": "صادر نشده",
                        "1": "صادر شده",
                        "2": "تکمیل شده و کامل",
                        "3": "تکمیل شده و ناقص"
                    },
                    filterEditorProperties:{
                        pickListProperties: {
                            showFilterEditor: false
                        }
                    },
                    filterOnKeypress:true,
                    filterOperator: "equals"
                },
                {name: "sendForm", title: " ", align: "center", canSort: false, canFilter: false, autoFithWidth: true},
                {
                    name: "saveResults",
                    title: " ",
                    align: "center",
                    canSort: false,
                    canFilter: false,
                    autoFithWidth: true
                },
                {name: "removeForm", title: " ", align: "center", canSort: false, canFilter: false, autoFithWidth: true},
                {name: "printForm", title: " ", align: "center", canSort: false, canFilter: false, autoFithWidth: true}
            ],
            filterEditorSubmit: function () {
                ListGrid_student_RE.invalidateCache();
            },
            getCellCSSText: function (record, rowNum, colNum) {
                if ((!ListGrid_student_RE.getFieldByName("evaluationStatusReaction").hidden && record.evaluationStatusReaction === 1))
                    return "background-color : #d8e4bc";

                if ((!ListGrid_student_RE.getFieldByName("evaluationStatusReaction").hidden && (record.evaluationStatusReaction === 3 || record.evaluationStatusReaction === 2)))
                    return "background-color : #b7dee8";
            },
            createRecordComponent: function (record, colNum) {
                let fieldName = this.getFieldName(colNum);
                if (fieldName == "saveResults") {
                    let button = isc.IButton.create({
                        layoutAlign: "center",
                        title: "ثبت نتیجه ارزیابی",
                        width: "120",
                        baseStyle: "registerFile",
                        click: function () {
                                if (record.evaluationStatusReaction == "0" ||record.evaluationStatusReaction == null)
                                    createDialog("info", "فرم ارزیابی واکنشی برای این فراگیر صادر نشده است");
                                else
                                    register_Student_Reaction_Form_RE(record);
                        }
                    });
                    return button;
                }
                else if (fieldName == "sendForm") {
                    let button = isc.IButton.create({
                        layoutAlign: "center",
                        baseStyle: "sendFile",
                        title: "صدور فرم",
                        width: "120",
                        click: function () {
                            if(record.evaluationStatusReaction != "0" && record.evaluationStatusReaction != null)
                                createDialog("info", "قبلا فرم ارزیابی واکنشی برای این فراگیر صادر شده است");
                            else
                                Student_Reaction_Form_Inssurance_RE(record);
                        }
                    });
                    return button;
                }
                else if (fieldName == "removeForm") {
                    let recordCanvas = isc.HLayout.create({
                        height: "100%",
                        width: "100%",
                        layoutMargin: 5,
                        membersMargin: 10,
                        align: "center"
                    });
                    let removeIcon = isc.ImgButton.create({
                        showDown: false,
                        showRollOver: false,
                        layoutAlign: "center",
                        src: "[SKIN]/actions/remove.png",
                        prompt: "حذف فرم",
                        height: 16,
                        width: 16,
                        grid: this,
                        click: function () {
                            if (record.evaluationStatusReaction == "0" ||record.evaluationStatusReaction == null)
                                createDialog("info", "فرم ارزیابی واکنشی برای این فراگیر صادر نشده است");
                            else{
                                let Dialog_remove = createDialog("ask", "آیا از حذف فرم مطمئن هستید؟",
                                    "<spring:message code="verify.delete"/>");
                                Dialog_remove.addProperties({
                                    buttonClick: function (button, index) {
                                        this.close();
                                        if (index === 0) {
                                            let data = {};
                                            data.classId = classRecord_RE.id;
                                            data.evaluatorId = record.id;
                                            data.evaluatorTypeId = 188;
                                            data.evaluatedId = classRecord_RE.id;
                                            data.evaluatedTypeId = 504;
                                            data.questionnaireTypeId = 139;
                                            data.evaluationLevelId = 154;
                                            isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/deleteEvaluation" , "POST", JSON.stringify(data), function (resp) {
                                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                                    ListGrid_student_RE.invalidateCache();
                                                    const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                                    setTimeout(() => {
                                                        msg.close();
                                                    }, 3000);
                                                } else {
                                                    createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                                                }
                                            }))
                                        }
                                    }
                                });
                            }
                        }
                    });
                    recordCanvas.addMember(removeIcon);
                    return recordCanvas;
                }
                else if (fieldName == "printForm") {
                    let recordCanvas = isc.HLayout.create({
                        height: "100%",
                        width: "100%",
                        layoutMargin: 5,
                        membersMargin: 10,
                        align: "center"
                    });
                    let printIcon = isc.ImgButton.create({
                        showDown: false,
                        showRollOver: false,
                        layoutAlign: "center",
                        src: "[SKIN]/actions/print.png",
                        prompt: "چاپ فرم",
                        height: 16,
                        width: 16,
                        grid: this,
                        click: function () {
                            if (record.evaluationStatusReaction == "0" ||record.evaluationStatusReaction == null)
                                createDialog("info", "فرم ارزیابی واکنشی برای این فراگیر صادر نشده است");
                            else
                                print_Student_Reaction_Form_RE(record.id);
                        }
                    });
                    recordCanvas.addMember(printIcon);
                    return recordCanvas;
                }
                else {
                    return null;
                }
            },
        });

    //----------------------------------------- ToolStrips -------------------------------------------------------------
        var ToolStripButton_FormIssuanceForAll_RE = isc.ToolStripButton.create({
            title: "<spring:message code="students.form.issuance.Behavioral"/>",
            baseStyle: "sendFile",
            click: function () {
                set_print_Status_RE("all");
            }
        });

        var ToolStripButton_RefreshIssuance_RE = isc.ToolStripButtonRefresh.create({
            title: "<spring:message code="refresh"/>",
            click: function () {
                ListGrid_student_RE.invalidateCache();
            }
        });

        var ToolStrip_RE = isc.ToolStrip.create({
            width: "100%",
            membersMargin: 10,
            members: [
                isc.VLayout.create({
                    membersMargin: 5,
                    layoutAlign: "center",
                    defaultLayoutAlign: "center",
                    members: [
                        isc.DynamicForm.create({
                            height: "100%",
                            numCols: 8,
                            ID: "ToolStrip_SendForms_RE",
                            fields: [
                                {
                                    name: "sendButtonTeacher",
                                    title: "صدور فرم ارزیابی مدرس از کلاس",
                                    type: "button",
                                    startRow: false,
                                    endRow: false,
                                    baseStyle: "sendFile",
                                    click: function () {
                                        if(classRecord_RE.teacherEvalStatus != "0" && classRecord_RE.teacherEvalStatus != null)
                                            createDialog("info", "قبلا فرم ارزیابی واکنشی برای مدرس صادر شده است");
                                        else{
                                            if(classRecord_RE.teacherId == undefined)
                                                createDialog("info", "اطلاعات کلاس ناقص است!");
                                            else
                                                Teacher_Reaction_Form_Inssurance_RE();
                                        }
                                    },
                                    icons:[
                                        {
                                            name: "ok",
                                            src: "[SKIN]actions/ok.png",
                                            width: 15,
                                            height: 15,
                                            inline: true,
                                            prompt: "تائید صدور",
                                            click : function (form, item, icon) {
                                            }
                                        }
                                    ]
                                },
                                {name: "registerButtonTeacher",title: "ثبت نتایج ارزیابی مدرس از کلاس", type:"button",startRow: false,baseStyle: "registerFile",
                                    click:function () {
                                        if(classRecord_RE.teacherEvalStatus == "0" || classRecord_RE.teacherEvalStatus == null)
                                            createDialog("info", "فرم ارزیابی واکنشی برای مسئول آموزش صادر نشده است");
                                        else
                                            register_Teacher_Reaction_Form_RE();
                                    },
                                    icons:[
                                        {
                                            name: "ok",
                                            src: "[SKIN]actions/ok.png",
                                            width: 15,
                                            height: 15,
                                            inline: true,
                                            prompt: "تائید صدور",
                                            click : function (form, item, icon) {
                                            }
                                        },
                                        {
                                            name: "clear",
                                            src: "[SKIN]actions/remove.png",
                                            width: 15,
                                            height: 15,
                                            inline: true,
                                            prompt: "حذف فرم",
                                            click : function (form, item, icon) {
                                                if (classRecord_RE.teacherEvalStatus == "0" ||classRecord_RE.teacherEvalStatus == null)
                                                    createDialog("info", "فرم ارزیابی واکنشی برای مدرس صادر نشده است");
                                                else{
                                                    let Dialog_remove = createDialog("ask", "آیا از حذف فرم مطمئن هستید؟",
                                                        "<spring:message code="verify.delete"/>");
                                                    Dialog_remove.addProperties({
                                                        buttonClick: function (button, index) {
                                                            this.close();
                                                            if (index === 0) {
                                                                let data = {};
                                                                data.classId = classRecord_RE.id;
                                                                data.evaluatorId = classRecord_RE.teacherId;
                                                                data.evaluatorTypeId = 187;
                                                                data.evaluatedId = classRecord_RE.id;
                                                                data.evaluatedTypeId = 504;
                                                                data.questionnaireTypeId = 140;
                                                                data.evaluationLevelId = 154;
                                                                isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/deleteEvaluation" , "POST", JSON.stringify(data), function (resp) {
                                                                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                                                        const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                                                        setTimeout(() => {
                                                                            msg.close();
                                                                        }, 3000);
                                                                        classRecord_RE.teacherEvalStatus = 0;
                                                                        ToolStrip_SendForms_RE.getField("sendButtonTeacher").disableIcon("ok");
                                                                        ToolStrip_SendForms_RE.getField("registerButtonTeacher").disableIcon("ok");
                                                                    } else {
                                                                        createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                                                                    }
                                                                }))
                                                            }
                                                        }
                                                    });
                                                }
                                            }
                                        },
                                        {
                                            name: "print",
                                            src: "[SKIN]actions/print.png",
                                            width: 15,
                                            height: 15,
                                            inline: true,
                                            prompt: "چاپ فرم",
                                            click : function (form, item, icon) {
                                                if (classRecord_RE.teacherEvalStatus == "0" ||classRecord_RE.teacherEvalStatus == null)
                                                    createDialog("info", "فرم ارزیابی واکنشی برای مدرس صادر نشده است");
                                                else
                                                    print_Teacher_Reaction_Form_RE();
                                            }
                                        }
                                    ]},
                                {
                                    name: "sendButtonTraining",
                                    title: "صدور فرم ارزیابی آموزش از مدرس",
                                    type: "button",
                                    startRow: false,
                                    endRow: false,
                                    baseStyle: "sendFile",
                                    click: function () {
                                        if(classRecord_RE.trainingEvalStatus != "0" && classRecord_RE.trainingEvalStatus != null)
                                            createDialog("info", "قبلا فرم ارزیابی واکنشی برای مسئول آموزش صادر شده است");
                                        else{
                                            if(classRecord_RE.tclassSupervisor == undefined || classRecord_RE.teacherId == undefined)
                                                createDialog("info", "اطلاعات کلاس ناقص است!");
                                            else
                                                Training_Reaction_Form_Inssurance_RE();
                                        }
                                    },
                                    icons:[
                                        {
                                            name: "ok",
                                            src: "[SKIN]actions/ok.png",
                                            width: 15,
                                            height: 15,
                                            inline: true,
                                            prompt: "تائید صدور",
                                            click : function (form, item, icon) {
                                            }
                                        }
                                    ]
                                },
                                {name: "registerButtonTraining",title: "ثبت نتایج ارزیابی آموزش از مدرس", type:"button",startRow: false,endRow: false,baseStyle: "registerFile",
                                    click:function () {
                                        if(classRecord_RE.trainingEvalStatus == "0" || classRecord_RE.trainingEvalStatus == null)
                                            createDialog("info", "فرم ارزیابی واکنشی برای مسئول آموزش صادر نشده است");
                                        else
                                            register_Training_Reaction_Form_RE();

                                    },
                                    icons:[
                                        {
                                            name: "ok",
                                            src: "[SKIN]actions/ok.png",
                                            width: 15,
                                            height: 15,
                                            inline: true,
                                            prompt: "تائید ثبت",
                                            click : function (form, item, icon) {
                                            }
                                        },
                                        {
                                            name: "clear",
                                            src: "[SKIN]actions/remove.png",
                                            width: 15,
                                            height: 15,
                                            inline: true,
                                            prompt: "حذف فرم",
                                            click : function (form, item, icon) {
                                                if (classRecord_RE.trainingEvalStatus == "0" ||classRecord_RE.trainingEvalStatus == null)
                                                    createDialog("info", "فرم ارزیابی واکنشی برای مسئول آموزش صادر نشده است");
                                                else{
                                                    let Dialog_remove = createDialog("ask", "آیا از حذف فرم مطمئن هستید؟",
                                                        "<spring:message code="verify.delete"/>");
                                                    Dialog_remove.addProperties({
                                                        buttonClick: function (button, index) {
                                                            this.close();
                                                            if (index === 0) {
                                                                let data = {};
                                                                data.classId = classRecord_RE.id;
                                                                data.evaluatorId = classRecord_RE.tclassSupervisor;
                                                                data.evaluatorTypeId = 454;
                                                                data.evaluatedId = classRecord_RE.teacherId;
                                                                data.evaluatedTypeId = 187;
                                                                data.questionnaireTypeId = 141;
                                                                data.evaluationLevelId = 154;
                                                                isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/deleteEvaluation" , "POST", JSON.stringify(data), function (resp) {
                                                                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                                                        const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                                                        setTimeout(() => {
                                                                            msg.close();
                                                                        }, 3000);
                                                                        classRecord_RE.trainingEvalStatus = 0;
                                                                        ToolStrip_SendForms_RE.getField("sendButtonTraining").disableIcon("ok");
                                                                        ToolStrip_SendForms_RE.getField("registerButtonTraining").disableIcon("ok");
                                                                    } else {
                                                                        createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                                                                    }
                                                                }))
                                                            }
                                                        }
                                                    });
                                                }
                                            }
                                        },
                                        {
                                            name: "print",
                                            src: "[SKIN]actions/print.png",
                                            width: 15,
                                            height: 15,
                                            inline: true,
                                            prompt: "چاپ فرم",
                                            click : function (form, item, icon) {
                                                if (classRecord_RE.trainingEvalStatus == "0" ||classRecord_RE.trainingEvalStatus == null)
                                                    createDialog("info", "فرم ارزیابی واکنشی برای مسئول آموزش صادر نشده است");
                                                else
                                                    print_Training_Reaction_Form_RE();
                                            }
                                        }
                                    ]}
                            ]
                        })
                    ]
                }),
                // isc.VLayout.create({
                //     members: [
                //         ToolStripButton_FormIssuanceForAll_RE,
                //         isc.LayoutSpacer.create({height: "22"})
                //     ]
                // }),
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_RefreshIssuance_RE
                    ]
                })
            ]
        });

    //----------------------------------------- LayOut -----------------------------------------------------------------
        var HLayout_Actions_RE = isc.HLayout.create({
            width: "100%",
            height: "1%",
            members: [ToolStrip_RE]
        });

        var Hlayout_Grid_RE = isc.HLayout.create({
            width: "100%",
            height: "100%",
            members: [ListGrid_student_RE]
        });

        var HLayout_returnData_RE = isc.HLayout.create({
            width: "100%",
            members: [
                DynamicForm_ReturnDate_RE,
                isc.LayoutSpacer.create({width: "80%"}),
                isc.RibbonGroup.create({
                    ID: "fileGroup_RE",
                    title: "راهنمای رنگ بندی لیست",
                    numRows: 1,
                    colWidths: [ 40, "*" ],
                    height: "10px",
                    titleAlign: "center",
                    titleStyle : "gridHint",
                    controls: [
                        isc.IconButton.create(isc.addProperties({
                            title: "صادر نشده",
                            baseStyle: "gridHint",
                            backgroundColor: '#fffff'
                        })),
                        isc.IconButton.create(isc.addProperties({
                            title: "صادر شده",
                            baseStyle: "gridHint",
                            backgroundColor: '#d8e4bc'
                        })),
                        isc.IconButton.create(isc.addProperties({
                            title: "تکمیل شده",
                            baseStyle: "gridHint",
                            backgroundColor: '#b7dee8'
                        }))
                    ]
                })]
        });

        var VLayout_Body_RE = isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [HLayout_returnData_RE, HLayout_Actions_RE, Hlayout_Grid_RE]
        });

    //----------------------------------- New Funsctions ---------------------------------------------------------------
        function print_Reaction_Form_RE(questionnarieId, evaluatorId, evaluatorTypeId, evaluatedId, evaluatedTypeId,
                                            questionnarieTypeId, evaluationLevel) {}


        function Student_Reaction_Form_Inssurance_RE(studentRecord){
        let IButtonSave_SelectQuestionnarie_RE = isc.IButtonSave.create({
                title: "صدور/ارسال به کارتابل",
                width: 150,
                click: function () {
                    if(ListGrid_SelectQuestionnarie_RE.getSelectedRecord() == null || ListGrid_SelectQuestionnarie_RE.getSelectedRecord() == undefined){
                        createDialog("info", "پرسشنامه ای انتخاب نشده است.");
                    }
                    else{
                        Window_SelectQuestionnarie_RE.close();
                        create_evaluation_form_RE(null,ListGrid_SelectQuestionnarie_RE.getSelectedRecord().id, studentRecord.id, 188, classRecord_RE.id, 504, 139, 154);
                    }
                }
            });
        let RestDataSource_Questionnarie_RE = isc.TrDS.create({
                fields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
                    {name:"questionnaireTypeId",hidden:true},
                    {name:"questionnaireType.title",title:"<spring:message code="type"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
                    {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
                ],
                fetchDataURL: questionnaireUrl + "/iscList"
            });
        let ListGrid_SelectQuestionnarie_RE = isc.TrLG.create({
                width: "100%",
                dataSource: RestDataSource_Questionnarie_RE,
                selectionType: "single",
                selectionAppearance: "checkbox",
                fields: [{name: "title"},{name:"questionnaireType.title"},{name: "description"},{name: "id", hidden:true}]
            });
        let Window_SelectQuestionnarie_RE = isc.Window.create({
                width: 1024,
                placement: "fillScreen",
                keepInParentRect: true,
                title: "انتخاب پرسشنامه",
                items: [
                    isc.HLayout.create({
                        width: "100%",
                        height: "90%",
                        members: [ListGrid_SelectQuestionnarie_RE]
                    }),
                    isc.TrHLayoutButtons.create({
                        width: "100%",
                        height: "5%",
                        members: [
                            IButtonSave_SelectQuestionnarie_RE,
                            isc.IButtonSave.create({
                                title: "ارسال از طریق پیامک",
                                click: function () {
                                }
                            }),
                            isc.IButtonCancel.create({
                                click: function () {
                                    Window_SelectQuestionnarie_RE.close();
                                }
                            })
                        ]
                    })
                ],
                minWidth: 1024
            });
        let criteria = {
                _constructor:"AdvancedCriteria",
                operator:"and",
                criteria:[
                    {fieldName:"eEnabled", operator:"equals", value: 494},
                    {fieldName:"questionnaireTypeId", operator:"equals", value: 139}
                ]
            };
        ListGrid_SelectQuestionnarie_RE.fetchData(criteria);
        ListGrid_SelectQuestionnarie_RE.invalidateCache();
        Window_SelectQuestionnarie_RE.show();
    }

        function register_Student_Reaction_Form_RE(StdRecord){
            let evaluationResult_DS = isc.TrDS.create({
                fields:
                    [
                        {name: "id", primaryKey: true, hidden: true},
                        {name: "title", title: "<spring:message code="title"/>"},
                        {name: "code", title: "<spring:message code="code"/>"}
                    ],
                autoFetchData: false,
                autoCacheAllData: true,
                fetchDataURL: parameterUrl + "/iscList/EvaluationResult"
            });

            let evaluationId;

            let valueMapAnswer = {209: "خیلی ضعیف", 208: "ضعیف", 207: "متوسط", 206: "خوب", 205: "عالی"};

            let DynamicForm_Questions_Title_JspEvaluation = isc.DynamicForm.create({
                numCols: 6,
                width: "100%",
                borderRadius: "10px 10px 0px 0px",
                border: "2px solid black",
                titleAlign: "left",
                margin: 10,
                padding: 10,
                fields: [
                    {name: "code", title: "<spring:message code="class.code"/>:", canEdit: false},
                    {name: "titleClass", title: "<spring:message code='class.title'/>:", canEdit: false},
                    {name: "startDate", title: "<spring:message code='start.date'/>:", canEdit: false},
                    {name: "teacher", title: "<spring:message code='teacher'/>:", canEdit: false},
                    {name: "institute", title: "<spring:message code='institute'/>:", canEdit: false},
                    {name: "user", title: "<spring:message code='user'/>:", canEdit: false},
                    {name: "evaluationLevel", title: "<spring:message code="evaluation.level"/>:", canEdit: false},
                    {name: "evaluationType", title: "<spring:message code="evaluation.type"/>:", canEdit: false, endRow: true},
                    {name: "evaluator", title: "<spring:message code="evaluator"/>:", canEdit: false,},
                    {name: "evaluated", title: "<spring:message code="evaluation.evaluated"/>:", canEdit: false}
                ]
            });

            let DynamicForm_Questions_Body_JspEvaluation = isc.DynamicForm.create({
                validateOnExit: true,
                colWidths: ["45%", "50%"],
                cellBorder: 1,
                width: "100%",
                padding: 10,
                styleName: "teacher-form",
                fields: []
            });

            let DynamicForm_Description_JspEvaluation = isc.DynamicForm.create({
                width: "100%",
                fields: [
                    {
                        name: "description",
                        title: "<spring:message code='description'/>",
                        type: 'textArea'
                    }
                ]
            });

            let IButton_Questions_Save = isc.IButtonSave.create({
                click: function () {
                    let evaluationAnswerList = [];
                    let data = {};
                    let evaluationFull = true;

                    let questions = DynamicForm_Questions_Body_JspEvaluation.getFields();
                    for (let i = 0; i < questions.length; i++) {
                        if (DynamicForm_Questions_Body_JspEvaluation.getValue(questions[i].name) === undefined) {
                            evaluationFull = false;
                        }
                        let evaluationAnswer = {};
                        evaluationAnswer.answerID = DynamicForm_Questions_Body_JspEvaluation.getValue(questions[i].name);
                        evaluationAnswer.id = questions[i].name.substring(1);
                        evaluationAnswerList.push(evaluationAnswer);
                    }
                    data.evaluationAnswerList = evaluationAnswerList;
                    data.evaluationFull = evaluationFull;
                    data.description = DynamicForm_Description_JspEvaluation.getField("description").getValue();
                    data.classId = classRecord_RE.id;
                    data.evaluatorId = StdRecord.id;
                    data.evaluatorTypeId = 188;
                    data.evaluatedId = classRecord_RE.id;
                    data.evaluatedTypeId = 504;
                    data.questionnaireTypeId = 139;
                    data.evaluationLevelId = 154;
                    data.status = true;
                    isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/" + evaluationId, "PUT", JSON.stringify(data), function (resp) {
                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                            Window_Questions_JspEvaluation.close();
                            ListGrid_student_RE.invalidateCache();
                            // isc.RPCManager.sendRequest(TrDSRequest(evaluationAnalysisUrl + "/updateEvaluationAnalysis" + "/" +
                            //     LGRecord.id,
                            //     "GET", null, null));
                            const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                            setTimeout(() => {
                                msg.close();
                            }, 3000);
                        } else {
                            createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                        }
                    }))
                }
            });

            let Window_Questions_JspEvaluation = isc.Window.create({
                width: 1024,
                height: 768,
                keepInParentRect: true,
                title: "<spring:message code="record.evaluation.results"/>",
                items: [
                    DynamicForm_Questions_Title_JspEvaluation,
                    DynamicForm_Questions_Body_JspEvaluation,
                    DynamicForm_Description_JspEvaluation,
                    isc.TrHLayoutButtons.create({
                        members: [
                            IButton_Questions_Save,
                            isc.IButtonCancel.create({
                                click: function () {
                                    Window_Questions_JspEvaluation.close();
                                }
                            })]
                    })
                ],
                minWidth: 1024
            });

            let itemList = [];

            DynamicForm_Questions_Title_JspEvaluation.clearValues();
            DynamicForm_Description_JspEvaluation.clearValues();
            DynamicForm_Questions_Body_JspEvaluation.clearValue();

            DynamicForm_Questions_Title_JspEvaluation.getItem("code").setValue(classRecord_RE.tclassCode);
            DynamicForm_Questions_Title_JspEvaluation.getItem("titleClass").setValue(classRecord_RE.courseTitleFa);
            DynamicForm_Questions_Title_JspEvaluation.getItem("institute").setValue(classRecord_RE.instituteTitleFa);

            DynamicForm_Questions_Title_JspEvaluation.getItem("startDate").setValue(classRecord_RE.tclassStartDate);
            DynamicForm_Questions_Title_JspEvaluation.setValue("evaluated", classRecord_RE.courseTitleFa);
            DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationType").setValue("ارزیابی فراگیر از کلاس");
            DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationLevel").setValue("واکنشی");
            DynamicForm_Questions_Title_JspEvaluation.setValue("evaluator", StdRecord.student.firstName + " " + StdRecord.student.lastName);
            DynamicForm_Questions_Title_JspEvaluation.setValue("user", "<%= SecurityUtil.getFullName()%>");
            isc.RPCManager.sendRequest(TrDSRequest(teacherUrl + "teacherFullName/" + classRecord_RE.teacherId,"GET", null, function (resp) {
                DynamicForm_Questions_Title_JspEvaluation.getItem("teacher").setValue(resp.httpResponseText);
                load_evaluation_form_RS();
            }));

            Window_Questions_JspEvaluation.show();

            evalWait_RE = createDialog("wait");

            function load_evaluation_form_RS(criteria, criteriaEdit) {

                let data = {};
                data.classId = classRecord_RE.id;
                data.evaluatorId = StdRecord.id;
                data.evaluatorTypeId = 188;
                data.evaluatedId = classRecord_RE.id;
                data.evaluatedTypeId = 504;
                data.questionnaireTypeId = 139;
                data.evaluationLevelId = 154;

                let itemList = [];
                let description;
                let record = {};

                isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/getEvaluationForm", "POST", JSON.stringify(data), function (resp) {
                    let result = JSON.parse(resp.httpResponseText).response.data;
                    description = result[0].description;
                    evaluationId = result[0].evaluationId;
                    for(let i=0;i<result.size();i++){
                        let item = {};
                        if(result[i].questionSourceId == 199){
                            switch (result[i].domainId) {
                                case 54:
                                    item.name = "Q" + result[i].id;
                                    item.title = "امکانات: " + result[i].question;
                                    break;
                                case 138:
                                    item.name = "Q" + result[i].id;
                                    item.title = "کلاس: " + result[i].question;
                                    break;
                                case 53:
                                    item.name = "Q" + result[i].id;
                                    item.title = "مدرس: " + result[i].question;
                                    break;
                                case 1:
                                    item.name = "Q" + result[i].id;
                                    item.title = "مدرس: " + result[i].question;
                                    break;
                                case 183:
                                    item.name = "Q" + result[i].id;
                                    item.title = "محتواي کلاس: " + result[i].question;
                                    break;
                                default:
                                    item.name = "Q" + result[i].id;
                                    item.title = result[i].question;
                            }

                            item.type = "radioGroup";
                            item.vertical = false;
                            item.fillHorizontalSpace = true;
                            item.valueMap = valueMapAnswer;
                            item.icons = [
                                {
                                    name: "clear",
                                    src: "[SKIN]actions/remove.png",
                                    width: 15,
                                    height: 15,
                                    inline: true,
                                    prompt: "پاک کردن",
                                    click : function (form, item, icon) {
                                        item.clearValue();
                                        item.focusInItem();
                                    }
                                }
                            ];
                            record["Q" + result[i].id] = result[i].answerId;
                        }
                        else if(result[i].questionSourceId == 200){
                            item.name = "M" + result[i].id;
                            item.title = "هدف اصلی: " + result[i].question;
                            item.type = "radioGroup";
                            item.vertical = false;
                            item.fillHorizontalSpace = true;
                            item.valueMap = valueMapAnswer;
                            item.icons = [
                                {
                                    name: "clear",
                                    src: "[SKIN]actions/remove.png",
                                    width: 15,
                                    height: 15,
                                    inline: true,
                                    prompt: "پاک کردن",
                                    click : function (form, item, icon) {
                                        item.clearValue();
                                        item.focusInItem();
                                    }
                                }
                            ];
                            record["M" + result[i].id] = result[i].answerId;
                        }
                        else if(result[i].questionSourceId == 201){
                            item.name = "G" + result[i].id;
                            item.title = "هدف: " + result[i].question;
                            item.type = "radioGroup";
                            item.vertical = false;
                            item.fillHorizontalSpace = true;
                            item.valueMap = valueMapAnswer;
                            item.icons = [
                                {
                                    name: "clear",
                                    src: "[SKIN]actions/remove.png",
                                    width: 15,
                                    height: 15,
                                    inline: true,
                                    prompt: "پاک کردن",
                                    click : function (form, item, icon) {
                                        item.clearValue();
                                        item.focusInItem();
                                    }
                                }
                            ];
                            record["G" + result[i].id] = result[i].answerId;
                        }
                        itemList.add(item);
                    }
                    DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                    DynamicForm_Description_JspEvaluation.getField("description").setValue(description);
                    DynamicForm_Questions_Body_JspEvaluation.setValues(record);
                    evalWait_RE.close();
                }));
            }
    }

        function Training_Reaction_Form_Inssurance_RE(){
            let IButtonSave_SelectQuestionnarie_RE = isc.IButtonSave.create({
                title: "صدور/ارسال به کارتابل",
                width: 150,
                click: function () {
                    if(ListGrid_SelectQuestionnarie_RE.getSelectedRecord() == null || ListGrid_SelectQuestionnarie_RE.getSelectedRecord() == undefined){
                        createDialog("info", "پرسشنامه ای انتخاب نشده است.");
                    }
                    else{
                        Window_SelectQuestionnarie_RE.close();
                        create_evaluation_form_RE(null,ListGrid_SelectQuestionnarie_RE.getSelectedRecord().id, classRecord_RE.tclassSupervisor, 454, classRecord_RE.teacherId,187 , 141, 154);
                    }
                }
            });
            let RestDataSource_Questionnarie_RE = isc.TrDS.create({
                fields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
                    {name:"questionnaireTypeId",hidden:true},
                    {name:"questionnaireType.title",title:"<spring:message code="type"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
                    {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
                ],
                fetchDataURL: questionnaireUrl + "/iscList"
            });
            let ListGrid_SelectQuestionnarie_RE = isc.TrLG.create({
                width: "100%",
                dataSource: RestDataSource_Questionnarie_RE,
                selectionType: "single",
                selectionAppearance: "checkbox",
                fields: [{name: "title"},{name:"questionnaireType.title"},{name: "description"},{name: "id", hidden:true}]
            });
            let Window_SelectQuestionnarie_RE = isc.Window.create({
                width: 1024,
                placement: "fillScreen",
                keepInParentRect: true,
                title: "انتخاب پرسشنامه",
                items: [
                    isc.HLayout.create({
                        width: "100%",
                        height: "90%",
                        members: [ListGrid_SelectQuestionnarie_RE]
                    }),
                    isc.TrHLayoutButtons.create({
                        width: "100%",
                        height: "5%",
                        members: [
                            IButtonSave_SelectQuestionnarie_RE,
                            isc.IButtonSave.create({
                                title: "ارسال از طریق پیامک",
                                click: function () {
                                }
                            }),
                            isc.IButtonCancel.create({
                                click: function () {
                                    Window_SelectQuestionnarie_RE.close();
                                }
                            })
                        ]
                    })
                ],
                minWidth: 1024
            });
            let criteria = {
                _constructor:"AdvancedCriteria",
                operator:"and",
                criteria:[
                    {fieldName:"eEnabled", operator:"equals", value: 494},
                    {fieldName:"questionnaireTypeId", operator:"equals", value: 141}
                ]
            };
            ListGrid_SelectQuestionnarie_RE.fetchData(criteria);
            ListGrid_SelectQuestionnarie_RE.invalidateCache();
            Window_SelectQuestionnarie_RE.show();
    }

        function register_Training_Reaction_Form_RE(){
            let evaluationResult_DS = isc.TrDS.create({
                fields:
                    [
                        {name: "id", primaryKey: true, hidden: true},
                        {name: "title", title: "<spring:message code="title"/>"},
                        {name: "code", title: "<spring:message code="code"/>"}
                    ],
                autoFetchData: false,
                autoCacheAllData: true,
                fetchDataURL: parameterUrl + "/iscList/EvaluationResult"
            });

            let evaluationId;

            let valueMapAnswer = {209: "خیلی ضعیف", 208: "ضعیف", 207: "متوسط", 206: "خوب", 205: "عالی"};

            let DynamicForm_Questions_Title_JspEvaluation = isc.DynamicForm.create({
                numCols: 6,
                width: "100%",
                borderRadius: "10px 10px 0px 0px",
                border: "2px solid black",
                titleAlign: "left",
                margin: 10,
                padding: 10,
                fields: [
                    {name: "code", title: "<spring:message code="class.code"/>:", canEdit: false},
                    {name: "titleClass", title: "<spring:message code='class.title'/>:", canEdit: false},
                    {name: "startDate", title: "<spring:message code='start.date'/>:", canEdit: false},
                    {name: "teacher", title: "<spring:message code='teacher'/>:", canEdit: false},
                    {name: "institute", title: "<spring:message code='institute'/>:", canEdit: false},
                    {name: "user", title: "<spring:message code='user'/>:", canEdit: false},
                    {name: "evaluationLevel", title: "<spring:message code="evaluation.level"/>:", canEdit: false},
                    {name: "evaluationType", title: "<spring:message code="evaluation.type"/>:", canEdit: false, endRow: true},
                    {name: "evaluator", title: "<spring:message code="evaluator"/>:", canEdit: false,},
                    {name: "evaluated", title: "<spring:message code="evaluation.evaluated"/>:", canEdit: false}
                ]
            });

            let DynamicForm_Questions_Body_JspEvaluation = isc.DynamicForm.create({
                validateOnExit: true,
                colWidths: ["45%", "50%"],
                cellBorder: 1,
                width: "100%",
                padding: 10,
                styleName: "teacher-form",
                fields: []
            });

            let DynamicForm_Description_JspEvaluation = isc.DynamicForm.create({
                width: "100%",
                fields: [
                    {
                        name: "description",
                        title: "<spring:message code='description'/>",
                        type: 'textArea'
                    }
                ]
            });

            let IButton_Questions_Save = isc.IButtonSave.create({
                click: function () {
                    let evaluationAnswerList = [];
                    let data = {};
                    let evaluationFull = true;

                    let questions = DynamicForm_Questions_Body_JspEvaluation.getFields();
                    for (let i = 0; i < questions.length; i++) {
                        if (DynamicForm_Questions_Body_JspEvaluation.getValue(questions[i].name) === undefined) {
                            evaluationFull = false;
                        }
                        let evaluationAnswer = {};
                        evaluationAnswer.answerID = DynamicForm_Questions_Body_JspEvaluation.getValue(questions[i].name);
                        evaluationAnswer.id = questions[i].name.substring(1);
                        evaluationAnswerList.push(evaluationAnswer);
                    }
                    data.evaluationAnswerList = evaluationAnswerList;
                    data.evaluationFull = evaluationFull;
                    data.description = DynamicForm_Description_JspEvaluation.getField("description").getValue();
                    data.classId = classRecord_RE.id;
                    data.evaluatorId = classRecord_RE.tclassSupervisor;
                    data.evaluatorTypeId = 454;
                    data.evaluatedId = classRecord_RE.teacherId;
                    data.evaluatedTypeId = 187;
                    data.questionnaireTypeId = 141;
                    data.evaluationLevelId = 154;
                    isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/" + evaluationId, "PUT", JSON.stringify(data), function (resp) {
                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                            Window_Questions_JspEvaluation.close();
                            if(evaluationFull == true)
                                classRecord_RE.trainingEvalStatus = 2;
                            else
                                classRecord_RE.trainingEvalStatus = 3;
                            // isc.RPCManager.sendRequest(TrDSRequest(evaluationAnalysisUrl + "/updateEvaluationAnalysis" + "/" +
                            //     LGRecord.id,
                            //     "GET", null, null));
                            ToolStrip_SendForms_RE.getField("registerButtonTraining").enableIcon("ok");
                            const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                            setTimeout(() => {
                                msg.close();
                            }, 3000);
                        } else {
                            createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                        }
                    }))
                }
            });

            let Window_Questions_JspEvaluation = isc.Window.create({
                width: 1024,
                height: 768,
                keepInParentRect: true,
                title: "<spring:message code="record.evaluation.results"/>",
                items: [
                    DynamicForm_Questions_Title_JspEvaluation,
                    DynamicForm_Questions_Body_JspEvaluation,
                    DynamicForm_Description_JspEvaluation,
                    isc.TrHLayoutButtons.create({
                        members: [
                            IButton_Questions_Save,
                            isc.IButtonCancel.create({
                                click: function () {
                                    Window_Questions_JspEvaluation.close();
                                }
                            })]
                    })
                ],
                minWidth: 1024
            });

            let itemList = [];

            DynamicForm_Questions_Title_JspEvaluation.clearValues();
            DynamicForm_Description_JspEvaluation.clearValues();
            DynamicForm_Questions_Body_JspEvaluation.clearValue();

            DynamicForm_Questions_Title_JspEvaluation.getItem("code").setValue(classRecord_RE.tclassCode);
            DynamicForm_Questions_Title_JspEvaluation.getItem("titleClass").setValue(classRecord_RE.courseTitleFa);
            DynamicForm_Questions_Title_JspEvaluation.getItem("institute").setValue(classRecord_RE.instituteTitleFa);

            DynamicForm_Questions_Title_JspEvaluation.getItem("startDate").setValue(classRecord_RE.tclassStartDate);
            DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationType").setValue("ارزیابی مسئول آموزش از مدرس");
            DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationLevel").setValue("واکنشی");
            DynamicForm_Questions_Title_JspEvaluation.setValue("user", "<%= SecurityUtil.getFullName()%>");
            isc.RPCManager.sendRequest(TrDSRequest(teacherUrl + "teacherFullName/" + classRecord_RE.teacherId,"GET", null, function (resp1) {
                DynamicForm_Questions_Title_JspEvaluation.getItem("teacher").setValue(resp1.httpResponseText);
                DynamicForm_Questions_Title_JspEvaluation.setValue("evaluated", resp1.httpResponseText);
                isc.RPCManager.sendRequest(TrDSRequest(personnelUrl + "/personnelFullName/" + classRecord_RE.tclassSupervisor,"GET", null, function (resp2) {
                    DynamicForm_Questions_Title_JspEvaluation.setValue("evaluator", resp2.httpResponseText);
                    load_evaluation_form_RTr();
                }));
            }));

            Window_Questions_JspEvaluation.show();

            evalWait_RE = createDialog("wait");

            function load_evaluation_form_RTr(criteria, criteriaEdit) {

                let data = {};
                data.classId = classRecord_RE.id;
                data.evaluatorId = classRecord_RE.tclassSupervisor;
                data.evaluatorTypeId = 454;
                data.evaluatedId = classRecord_RE.teacherId;
                data.evaluatedTypeId = 187;
                data.questionnaireTypeId = 141;
                data.evaluationLevelId = 154;

                let itemList = [];
                let description;
                let record = {};

                isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/getEvaluationForm", "POST", JSON.stringify(data), function (resp) {
                    let result = JSON.parse(resp.httpResponseText).response.data;
                    description = result[0].description;
                    evaluationId = result[0].evaluationId;
                    for(let i=0;i<result.size();i++){
                        let item = {};
                        if(result[i].questionSourceId == 199){
                            switch (result[i].domainId) {
                                case 54:
                                    item.name = "Q" + result[i].id;
                                    item.title = "امکانات: " + result[i].question;
                                    break;
                                case 138:
                                    item.name = "Q" + result[i].id;
                                    item.title = "کلاس: " + result[i].question;
                                    break;
                                case 53:
                                    item.name = "Q" + result[i].id;
                                    item.title = "مدرس: " + result[i].question;
                                    break;
                                case 1:
                                    item.name = "Q" + result[i].id;
                                    item.title = "مدرس: " + result[i].question;
                                    break;
                                case 183:
                                    item.name = "Q" + result[i].id;
                                    item.title = "محتواي کلاس: " + result[i].question;
                                    break;
                                default:
                                    item.name = "Q" + result[i].id;
                                    item.title = result[i].question;
                            }

                            item.type = "radioGroup";
                            item.vertical = false;
                            item.fillHorizontalSpace = true;
                            item.valueMap = valueMapAnswer;
                            item.icons = [
                                {
                                    name: "clear",
                                    src: "[SKIN]actions/remove.png",
                                    width: 15,
                                    height: 15,
                                    inline: true,
                                    prompt: "پاک کردن",
                                    click : function (form, item, icon) {
                                        item.clearValue();
                                        item.focusInItem();
                                    }
                                }
                            ];
                            record["Q" + result[i].id] = result[i].answerId;
                        }
                        else if(result[i].questionSourceId == 200){
                            item.name = "M" + result[i].id;
                            item.title = "هدف اصلی: " + result[i].question;
                            item.type = "radioGroup";
                            item.vertical = false;
                            item.fillHorizontalSpace = true;
                            item.valueMap = valueMapAnswer;
                            item.icons = [
                                {
                                    name: "clear",
                                    src: "[SKIN]actions/remove.png",
                                    width: 15,
                                    height: 15,
                                    inline: true,
                                    prompt: "پاک کردن",
                                    click : function (form, item, icon) {
                                        item.clearValue();
                                        item.focusInItem();
                                    }
                                }
                            ];
                            record["M" + result[i].id] = result[i].answerId;
                        }
                        else if(result[i].questionSourceId == 201){
                            item.name = "G" + result[i].id;
                            item.title = "هدف: " + result[i].question;
                            item.type = "radioGroup";
                            item.vertical = false;
                            item.fillHorizontalSpace = true;
                            item.valueMap = valueMapAnswer;
                            item.icons = [
                                {
                                    name: "clear",
                                    src: "[SKIN]actions/remove.png",
                                    width: 15,
                                    height: 15,
                                    inline: true,
                                    prompt: "پاک کردن",
                                    click : function (form, item, icon) {
                                        item.clearValue();
                                        item.focusInItem();
                                    }
                                }
                            ];
                            record["G" + result[i].id] = result[i].answerId;
                        }
                        itemList.add(item);
                    }
                    DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                    DynamicForm_Description_JspEvaluation.getField("description").setValue(description);
                    DynamicForm_Questions_Body_JspEvaluation.setValues(record);
                    evalWait_RE.close();
                }));
            }
    }

        function Teacher_Reaction_Form_Inssurance_RE(){
        let IButtonSave_SelectQuestionnarie_RE = isc.IButtonSave.create({
            title: "صدور/ارسال به کارتابل",
            width: 150,
            click: function () {
                if(ListGrid_SelectQuestionnarie_RE.getSelectedRecord() == null || ListGrid_SelectQuestionnarie_RE.getSelectedRecord() == undefined){
                    createDialog("info", "پرسشنامه ای انتخاب نشده است.");
                }
                else{
                    Window_SelectQuestionnarie_RE.close();
                    create_evaluation_form_RE(null,ListGrid_SelectQuestionnarie_RE.getSelectedRecord().id, classRecord_RE.teacherId, 187, classRecord_RE.id,504 , 140, 154);
                }
            }
        });
        let RestDataSource_Questionnarie_RE = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
                {name:"questionnaireTypeId",hidden:true},
                {name:"questionnaireType.title",title:"<spring:message code="type"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
                {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
            ],
            fetchDataURL: questionnaireUrl + "/iscList"
        });
        let ListGrid_SelectQuestionnarie_RE = isc.TrLG.create({
            width: "100%",
            dataSource: RestDataSource_Questionnarie_RE,
            selectionType: "single",
            selectionAppearance: "checkbox",
            fields: [{name: "title"},{name:"questionnaireType.title"},{name: "description"},{name: "id", hidden:true}]
        });
        let Window_SelectQuestionnarie_RE = isc.Window.create({
            width: 1024,
            placement: "fillScreen",
            keepInParentRect: true,
            title: "انتخاب پرسشنامه",
            items: [
                isc.HLayout.create({
                    width: "100%",
                    height: "90%",
                    members: [ListGrid_SelectQuestionnarie_RE]
                }),
                isc.TrHLayoutButtons.create({
                    width: "100%",
                    height: "5%",
                    members: [
                        IButtonSave_SelectQuestionnarie_RE,
                        isc.IButtonSave.create({
                            title: "ارسال از طریق پیامک",
                            click: function () {
                            }
                        }),
                        isc.IButtonCancel.create({
                            click: function () {
                                Window_SelectQuestionnarie_RE.close();
                            }
                        })
                    ]
                })
            ],
            minWidth: 1024
        });
        let criteria = {
            _constructor:"AdvancedCriteria",
            operator:"and",
            criteria:[
                {fieldName:"eEnabled", operator:"equals", value: 494},
                {fieldName:"questionnaireTypeId", operator:"equals", value: 140}
            ]
        };
        ListGrid_SelectQuestionnarie_RE.fetchData(criteria);
        ListGrid_SelectQuestionnarie_RE.invalidateCache();
        Window_SelectQuestionnarie_RE.show();
    }

        function register_Teacher_Reaction_Form_RE(){
        let evaluationResult_DS = isc.TrDS.create({
            fields:
                [
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "title", title: "<spring:message code="title"/>"},
                    {name: "code", title: "<spring:message code="code"/>"}
                ],
            autoFetchData: false,
            autoCacheAllData: true,
            fetchDataURL: parameterUrl + "/iscList/EvaluationResult"
        });

        let evaluationId;

        let valueMapAnswer = {209: "خیلی ضعیف", 208: "ضعیف", 207: "متوسط", 206: "خوب", 205: "عالی"};

        let DynamicForm_Questions_Title_JspEvaluation = isc.DynamicForm.create({
            numCols: 6,
            width: "100%",
            borderRadius: "10px 10px 0px 0px",
            border: "2px solid black",
            titleAlign: "left",
            margin: 10,
            padding: 10,
            fields: [
                {name: "code", title: "<spring:message code="class.code"/>:", canEdit: false},
                {name: "titleClass", title: "<spring:message code='class.title'/>:", canEdit: false},
                {name: "startDate", title: "<spring:message code='start.date'/>:", canEdit: false},
                {name: "teacher", title: "<spring:message code='teacher'/>:", canEdit: false},
                {name: "institute", title: "<spring:message code='institute'/>:", canEdit: false},
                {name: "user", title: "<spring:message code='user'/>:", canEdit: false},
                {name: "evaluationLevel", title: "<spring:message code="evaluation.level"/>:", canEdit: false},
                {name: "evaluationType", title: "<spring:message code="evaluation.type"/>:", canEdit: false, endRow: true},
                {name: "evaluator", title: "<spring:message code="evaluator"/>:", canEdit: false,},
                {name: "evaluated", title: "<spring:message code="evaluation.evaluated"/>:", canEdit: false}
            ]
        });

        let DynamicForm_Questions_Body_JspEvaluation = isc.DynamicForm.create({
            validateOnExit: true,
            colWidths: ["45%", "50%"],
            cellBorder: 1,
            width: "100%",
            padding: 10,
            styleName: "teacher-form",
            fields: []
        });

        let DynamicForm_Description_JspEvaluation = isc.DynamicForm.create({
            width: "100%",
            fields: [
                {
                    name: "description",
                    title: "<spring:message code='description'/>",
                    type: 'textArea'
                }
            ]
        });

        let IButton_Questions_Save = isc.IButtonSave.create({
            click: function () {
                let evaluationAnswerList = [];
                let data = {};
                let evaluationFull = true;

                let questions = DynamicForm_Questions_Body_JspEvaluation.getFields();
                for (let i = 0; i < questions.length; i++) {
                    if (DynamicForm_Questions_Body_JspEvaluation.getValue(questions[i].name) === undefined) {
                        evaluationFull = false;
                    }
                    let evaluationAnswer = {};
                    evaluationAnswer.answerID = DynamicForm_Questions_Body_JspEvaluation.getValue(questions[i].name);
                    evaluationAnswer.id = questions[i].name.substring(1);
                    evaluationAnswerList.push(evaluationAnswer);
                }
                data.evaluationAnswerList = evaluationAnswerList;
                data.evaluationFull = evaluationFull;
                data.description = DynamicForm_Description_JspEvaluation.getField("description").getValue();
                data.classId = classRecord_RE.id;
                data.evaluatorId = classRecord_RE.teacherId;
                data.evaluatorTypeId = 187;
                data.evaluatedId = classRecord_RE.id;
                data.evaluatedTypeId = 504;
                data.questionnaireTypeId = 140;
                data.evaluationLevelId = 154;
                isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/" + evaluationId, "PUT", JSON.stringify(data), function (resp) {
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                        Window_Questions_JspEvaluation.close();
                        if(evaluationFull == true)
                            classRecord_RE.teacherEvalStatus = 2;
                        else
                            classRecord_RE.teacherEvalStatus = 3;
                        // isc.RPCManager.sendRequest(TrDSRequest(evaluationAnalysisUrl + "/updateEvaluationAnalysis" + "/" +
                        //     LGRecord.id,
                        //     "GET", null, null));
                        ToolStrip_SendForms_RE.getField("registerButtonTeacher").enableIcon("ok");
                        const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                        setTimeout(() => {
                            msg.close();
                        }, 3000);
                    } else {
                        createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                    }
                }))
            }
        });

        let Window_Questions_JspEvaluation = isc.Window.create({
            width: 1024,
            height: 768,
            keepInParentRect: true,
            title: "<spring:message code="record.evaluation.results"/>",
            items: [
                DynamicForm_Questions_Title_JspEvaluation,
                DynamicForm_Questions_Body_JspEvaluation,
                DynamicForm_Description_JspEvaluation,
                isc.TrHLayoutButtons.create({
                    members: [
                        IButton_Questions_Save,
                        isc.IButtonCancel.create({
                            click: function () {
                                Window_Questions_JspEvaluation.close();
                            }
                        })]
                })
            ],
            minWidth: 1024
        });

        let itemList = [];

        DynamicForm_Questions_Title_JspEvaluation.clearValues();
        DynamicForm_Description_JspEvaluation.clearValues();
        DynamicForm_Questions_Body_JspEvaluation.clearValue();

        DynamicForm_Questions_Title_JspEvaluation.getItem("code").setValue(classRecord_RE.tclassCode);
        DynamicForm_Questions_Title_JspEvaluation.getItem("titleClass").setValue(classRecord_RE.courseTitleFa);
        DynamicForm_Questions_Title_JspEvaluation.getItem("institute").setValue(classRecord_RE.instituteTitleFa);

        DynamicForm_Questions_Title_JspEvaluation.getItem("startDate").setValue(classRecord_RE.tclassStartDate);
        DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationType").setValue("ارزیابی استاد از کلاس");
        DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationLevel").setValue("واکنشی");
        DynamicForm_Questions_Title_JspEvaluation.setValue("user", "<%= SecurityUtil.getFullName()%>");
        DynamicForm_Questions_Title_JspEvaluation.setValue("evaluated", classRecord_RE.courseTitleFa);
        isc.RPCManager.sendRequest(TrDSRequest(teacherUrl + "teacherFullName/" + classRecord_RE.teacherId,"GET", null, function (resp1) {
            DynamicForm_Questions_Title_JspEvaluation.getItem("teacher").setValue(resp1.httpResponseText);
            DynamicForm_Questions_Title_JspEvaluation.setValue("evaluator", resp1.httpResponseText);
            load_evaluation_form_RTe();
        }));

        Window_Questions_JspEvaluation.show();

        evalWait_RE = createDialog("wait");

        function load_evaluation_form_RTe(criteria, criteriaEdit) {

            let data = {};
            data.classId = classRecord_RE.id;
            data.evaluatorId = classRecord_RE.teacherId;
            data.evaluatorTypeId = 187;
            data.evaluatedId = classRecord_RE.id;
            data.evaluatedTypeId = 504;
            data.questionnaireTypeId = 140;
            data.evaluationLevelId = 154;

            let itemList = [];
            let description;
            let record = {};

            isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/getEvaluationForm", "POST", JSON.stringify(data), function (resp) {
                let result = JSON.parse(resp.httpResponseText).response.data;
                description = result[0].description;
                evaluationId = result[0].evaluationId;
                for(let i=0;i<result.size();i++){
                    let item = {};
                    if(result[i].questionSourceId == 199){
                        switch (result[i].domainId) {
                            case 54:
                                item.name = "Q" + result[i].id;
                                item.title = "امکانات: " + result[i].question;
                                break;
                            case 138:
                                item.name = "Q" + result[i].id;
                                item.title = "کلاس: " + result[i].question;
                                break;
                            case 53:
                                item.name = "Q" + result[i].id;
                                item.title = "مدرس: " + result[i].question;
                                break;
                            case 1:
                                item.name = "Q" + result[i].id;
                                item.title = "مدرس: " + result[i].question;
                                break;
                            case 183:
                                item.name = "Q" + result[i].id;
                                item.title = "محتواي کلاس: " + result[i].question;
                                break;
                            default:
                                item.name = "Q" + result[i].id;
                                item.title = result[i].question;
                        }

                        item.type = "radioGroup";
                        item.vertical = false;
                        item.fillHorizontalSpace = true;
                        item.valueMap = valueMapAnswer;
                        item.icons = [
                            {
                                name: "clear",
                                src: "[SKIN]actions/remove.png",
                                width: 15,
                                height: 15,
                                inline: true,
                                prompt: "پاک کردن",
                                click : function (form, item, icon) {
                                    item.clearValue();
                                    item.focusInItem();
                                }
                            }
                        ];
                        record["Q" + result[i].id] = result[i].answerId;
                    }
                    else if(result[i].questionSourceId == 200){
                        item.name = "M" + result[i].id;
                        item.title = "هدف اصلی: " + result[i].question;
                        item.type = "radioGroup";
                        item.vertical = false;
                        item.fillHorizontalSpace = true;
                        item.valueMap = valueMapAnswer;
                        item.icons = [
                            {
                                name: "clear",
                                src: "[SKIN]actions/remove.png",
                                width: 15,
                                height: 15,
                                inline: true,
                                prompt: "پاک کردن",
                                click : function (form, item, icon) {
                                    item.clearValue();
                                    item.focusInItem();
                                }
                            }
                        ];
                        record["M" + result[i].id] = result[i].answerId;
                    }
                    else if(result[i].questionSourceId == 201){
                        item.name = "G" + result[i].id;
                        item.title = "هدف: " + result[i].question;
                        item.type = "radioGroup";
                        item.vertical = false;
                        item.fillHorizontalSpace = true;
                        item.valueMap = valueMapAnswer;
                        item.icons = [
                            {
                                name: "clear",
                                src: "[SKIN]actions/remove.png",
                                width: 15,
                                height: 15,
                                inline: true,
                                prompt: "پاک کردن",
                                click : function (form, item, icon) {
                                    item.clearValue();
                                    item.focusInItem();
                                }
                            }
                        ];
                        record["G" + result[i].id] = result[i].answerId;
                    }
                    itemList.add(item);
                }
                DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                DynamicForm_Description_JspEvaluation.getField("description").setValue(description);
                DynamicForm_Questions_Body_JspEvaluation.setValues(record);
                evalWait_RE.close();
            }));
        }
    }

        function print_Teacher_Reaction_Form_RE(){
            let myObj = {
                classId: classRecord_RE.id,
                evaluationLevelId: 154,
                questionnarieTypeId: 140,
                evaluatorId: classRecord_RE.teacherId,
                evaluatorTypeId: 187,
                evaluatedId: classRecord_RE.id,
                evaluatedTypeId: 504
            };
            trPrintWithCriteria("<spring:url value="/evaluation/printEvaluationForm"/>", null, JSON.stringify(myObj));
        }

        function print_Training_Reaction_Form_RE(){
        let myObj = {
            classId: classRecord_RE.id,
            evaluationLevelId: 154,
            questionnarieTypeId: 141,
            evaluatorId: classRecord_RE.tclassSupervisor,
            evaluatorTypeId: 454,
            evaluatedId: classRecord_RE.teacherId,
            evaluatedTypeId: 187
        };
        trPrintWithCriteria("<spring:url value="/evaluation/printEvaluationForm"/>", null, JSON.stringify(myObj));
    }

        function print_Student_Reaction_Form_RE(stdId){
        let myObj = {
            classId: classRecord_RE.id,
            evaluationLevelId: 154,
            questionnarieTypeId: 139,
            evaluatorId: stdId,
            evaluatorTypeId: 188,
            evaluatedId: classRecord_RE.id,
            evaluatedTypeId: 504
        };
        trPrintWithCriteria("<spring:url value="/evaluation/printEvaluationForm"/>", null, JSON.stringify(myObj));
    }

    //------------------------------------------------- Global Functions -----------------------------------------------
        function create_evaluation_form_RE(id,questionnarieId, evaluatorId,
                                    evaluatorTypeId, evaluatedId, evaluatedTypeId, questionnarieTypeId,
                                    evaluationLevel){
        let data = {};
        data.classId = classRecord_RE.id;
        data.status = false;
        if(ReturnDate_RE._value != undefined )
            data.returnDate =  ReturnDate_RE._value;
        data.sendDate = todayDate;
        data.evaluatorId = evaluatorId;
        data.evaluatorTypeId = evaluatorTypeId;
        data.evaluatedId = evaluatedId;
        data.evaluatedTypeId = evaluatedTypeId;
        data.questionnaireId =questionnarieId;
        data.questionnaireTypeId = questionnarieTypeId;
        data.evaluationLevelId = evaluationLevel;
        data.evaluationFull = false;
        data.description = null;

        isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl, "POST", JSON.stringify(data), function (resp) {
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                setTimeout(() => {
                    msg.close();
                }, 3000);
                if(questionnarieTypeId == 139){
                    ListGrid_student_RE.invalidateCache();
                    print_Student_Reaction_Form_RE(evaluatorId);
                }
                else if (questionnarieTypeId == 141) {
                    classRecord_RE.trainingEvalStatus = 1;
                    ToolStrip_SendForms_RE.getField("sendButtonTraining").enableIcon("ok");
                    print_Training_Reaction_Form_RE();
                }
                else if(questionnarieTypeId == 140){
                    classRecord_RE.teacherEvalStatus = 1;
                    ToolStrip_SendForms_RE.getField("sendButtonTeacher").enableIcon("ok");
                    print_Teacher_Reaction_Form_RE();
                }
            } else {
                createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
            }
        }));
        }

        function questionSourceConvert(s) {
        switch (s.charAt(0)) {
            case "G":
                return 201;
            case "M":
                return 200;
            case "Q":
                return 199;
        }
    }

        function evaluation_check_date_RE() {
            DynamicForm_ReturnDate_RE.clearFieldErrors("evaluationReturnDate", true);

            if (DynamicForm_ReturnDate_RE.getValue("evaluationReturnDate") !== undefined && !checkDate(DynamicForm_ReturnDate_RE.getValue("evaluationReturnDate"))) {
                DynamicForm_ReturnDate_RE.addFieldErrors("evaluationReturnDate", "<spring:message code='msg.correct.date'/>", true);
            } else if (DynamicForm_ReturnDate_RE.getValue("evaluationReturnDate") < classRecord_RE.startDate) {
                DynamicForm_ReturnDate_RE.addFieldErrors("evaluationReturnDate", "<spring:message code='return.date.before.class.start.date'/>", true);
            } else {
                DynamicForm_ReturnDate_RE.clearFieldErrors("evaluationReturnDate", true);
            }
        }


    //