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
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.student.firstName;
                }
            },
            {
                name: "student.lastName",
                title: "<spring:message code="lastName"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.student.lastName;
                }
            },
            {
                name: "student.gender",
                title: "<spring:message code="gender"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.student.gender;
                }
            },
            {
                name: "student.nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.student.nationalCode;
                }
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
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.student.companyName;
                }
            },
            {
                name: "student.personnelNo",
                title: "<spring:message code="personnel.no"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.student.personnelNo;
                }
            },
            {
                name: "student.personnelNo2",
                title: "<spring:message code="personnel.no.6.digits"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.student.personnelNo2;
                }
            },
            {
                name: "student.postTitle",
                title: "<spring:message code="post"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.student.postTitle;
                }
            },
            {
                name: "student.ccpArea",
                title: "<spring:message code="reward.cost.center.area"/>",
                filterOperator: "iContains",
                sortNormalizer: function (record) {
                    return record.student.ccpArea;
                }
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
            },
            {
                name: "student.contactInfo.smSMobileNumber",
                title: "<spring:message code="cellPhone"/>",
                filterOperator: "iContains",
            },
        ],
    });

    var RestDataSource_Messages_reaction = isc.TrDS.create({
        fields: [
            {name: "code", title: "<spring:message code='course.code'/>", filterOperator: "equals"},
            {name: "title", title: "<spring:message code='group.code'/>", filterOperator: "iContains"},
            {name: "description", title: "<spring:message code='course.title'/>", filterOperator: "iContains"},
        ]
    });

    var RestDataSource_Result_Evaluation = isc.TrDS.create({
        fields: [
            {name: "surname", title: 'نام'},
            {name: "lastName", title: 'نام خانوادگی'},
            {name: "description", title: 'توضیحات'},
            {name: "answers", hidden: true },
        ]
    });

    var RestDataSource_Result_Answers_Evaluation = isc.TrDS.create({
        fields: [
            {name: "question", title: 'سوال'},
            {name: "answer", title: 'پاسخ'},
        ]
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

    /*var MSG_Window_MSG_Main = isc.Window.create({
        placement: "center",
        title: "ارسال پیام",
        overflow: "auto",
        width: 900,
        height: 760,
        isModal: false,
        autoDraw: false,
        autoSize: false,
        items: [
            MSG_main_layout
        ],
        closeClick: function () {
            MSG_initMSG()
            this.clear()
            this.close();
        },
    });*/
    //----------------------------------------- ListGrids --------------------------------------------------------------
    var ListGrid_student_RE = isc.TrLG.create({
        width: "100%",
        height: "100%",
        <sec:authorize access="hasAuthority('Evaluation_Reaction_R')">
        dataSource: RestDataSource_student_RE,
        </sec:authorize>
        selectionType: "single",
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        sortField: 5,
        dataPageSize: 200,
        sortDirection: "descending",
        fields: [
            {name: "student.firstName"},
            {name: "student.lastName"},
            {name: "student.gender"},
            {
                name: "student.nationalCode",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {
                name: "student.personnelNo",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {
                name: "student.personnelNo2",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "student.postTitle"},
            {name: "student.contactInfo.smSMobileNumber"},
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
                filterEditorProperties: {
                    pickListProperties: {
                        showFilterEditor: false
                    }
                },
                filterOnKeypress: true,
                filterOperator: "equals"
            },
            {name: "classAttendanceStatus", title: "وضعیت حضور در کلاس",valueMap: {"true":"حاضر","false":"غایب"}, align: "center", canSort: false, canFilter: false, autoFithWidth: true},
            // {name: "sendForm", title: " ", align: "center", canSort: false, canFilter: false, autoFithWidth: true},
            {
                name: "saveResults",
                title: " ",
                align: "center",
                canSort: false,
                canFilter: false,
                autoFithWidth: true
            },
            {name: "removeForm", title: " ", align: "center", canSort: false, canFilter: false, autoFithWidth: true, hidden: true},
            {name: "printForm", title: " ", align: "center", canSort: false, canFilter: false, autoFithWidth: true}
        ],
        <sec:authorize access="hasAuthority('Evaluation_Reaction_Actions')">
        cellClick: function (record, rowNum, colNum) {
            editMobileForm.callBack = (contactInfo ,m) => {record.student.contactInfo = contactInfo;record.student.contactInfo.smSMobileNumber = m;};
            if (this.getFieldName(colNum) == "student.contactInfo.smSMobileNumber") {
                if (record.student.contactInfo) {
                    record.student.contactInfo.parentId = record.student.id;
                    editMobileForm.editRecord(record.student.contactInfo);
                    switch (record.student.contactInfo.mobileForSMS) {
                        case 2:
                            editMobileForm.getItem('mobile2_c').setValue(true);
                            break;
                        case 3:
                            editMobileForm.getItem('hrMobile_c').setValue(true);
                            break;
                        case 4:
                            editMobileForm.getItem('mdmsMobile_c').setValue(true);
                            break;
                        default:
                            editMobileForm.getItem('mobile_c').setValue(true);
                            editMobileForm.getValues().mobileForSMS = 1;
                    }
                    Window_EditMobile.show();
                } else {
                    isc.RPCManager.sendRequest(TrDSRequest(rootUrl.concat("/contactInfo/createNewFor/").concat(record.student.id), "POST", "Student", (r) => {
                        editMobileForm.clearValues();
                        editMobileForm.clearErrors();
                        editMobileForm.editRecord(JSON.parse(r.data));
                        editMobileForm.getItem('mobile_c').setValue(true);
                        editMobileForm.getValues().mobileForSMS = 1;
                        Window_EditMobile.show();
                    }));
                }
            }
        },
        </sec:authorize>
        filterEditorSubmit: function () {
            ListGrid_student_RE.invalidateCache();
        },
        getCellCSSText: function (record, rowNum, colNum) {
            if ((!ListGrid_student_RE.getFieldByName("evaluationStatusReaction").hidden && record.evaluationStatusReaction === 1))
                return "background-color : #d8e4bc";

            if ((!ListGrid_student_RE.getFieldByName("evaluationStatusReaction").hidden && (record.evaluationStatusReaction === 3 || record.evaluationStatusReaction === 2)))
                return "background-color : #b7dee8";

            if (this.getFieldName(colNum) == "student.contactInfo.smSMobileNumber")
                return  ";color: #0066cc !important;text-decoration: underline !important;cursor: pointer !important;"
        },
        createRecordComponent: function (record, colNum) {
            let fieldName = this.getFieldName(colNum);
            if (fieldName == "saveResults") {
                <sec:authorize access="hasAuthority('Evaluation_Reaction_R')">
                let button = isc.IButton.create({
                    layoutAlign: "center",
                    title: "ثبت و مشاهده نتیجه ارزیابی",
                    width: "150",
                    baseStyle: "registerFile",
                    click: function () {
                        if (record.evaluationStatusReaction == "0" || record.evaluationStatusReaction == null)
                            createDialog("info", "فرم ارزیابی واکنشی برای این فراگیر صادر نشده است");
                        else
                            register_Student_Reaction_Form_RE(record);
                    }
                });
                return button;
                </sec:authorize>
            } else if (fieldName == "sendForm") {
                <sec:authorize access="hasAuthority('Evaluation_Reaction_Actions')">
                let button = isc.IButton.create({
                    layoutAlign: "center",
                    baseStyle: "sendFile",
                    title: "صدور فرم",
                    width: "120",
                    click: function () {
                        if (record.evaluationStatusReaction != "0" && record.evaluationStatusReaction != null)
                            createDialog("info", "قبلا فرم ارزیابی واکنشی برای این فراگیر صادر شده است");
                        else
                            Student_Reaction_Form_Inssurance_RE(record);
                    }
                });
                return button;
                </sec:authorize>
            } else if (fieldName == "removeForm") {
                <sec:authorize access="hasAuthority('Evaluation_Reaction_Actions')">
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
                        if (record.evaluationStatusReaction == "0" || record.evaluationStatusReaction == null)
                            createDialog("info", "فرم ارزیابی واکنشی برای این فراگیر صادر نشده است");
                        else {
                            let Dialog_remove = createDialog("ask", "آیا از حذف فرم مطمئن هستید؟در صورت حذف, ارزیابی از سیستم آنلاین هم حذف خواهد شد.",
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
                                        data.alow = true;
                                        data.nationalCode = record.student.nationalCode;
                                        data.isTeacher = false;
                                        wait.show();
                                        isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/deleteEvaluation", "POST", JSON.stringify(data), function (resp) {
                                            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                                wait.close();
                                                ListGrid_student_RE.invalidateCache();
                                                isc.RPCManager.sendRequest(TrDSRequest(evaluationAnalysisUrl + "/updateEvaluationAnalysis" + "/" +
                                                    classRecord_RE.id,"GET", null, null));
                                                const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                                if (classRecord_RE.classStudentOnlineEvalStatus) {
                                                    ToolStripButton_OnlineFormIssuanceForAll_RE.setDisabled(false);
                                                    classRecord_RE.classStudentOnlineEvalStatus= false;
                                                    ListGrid_class_Evaluation.getSelectedRecord().classStudentOnlineEvalStatus = false;
                                                }
                                                setTimeout(() => {
                                                    msg.close();
                                                }, 3000);
                                            } else {
                                                wait.close();
                                                createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                                            }
                                        }))
                                    }
                                }
                            });
                        }
                    }
                });
                // recordCanvas.addMember(removeIcon);
                return recordCanvas;
                </sec:authorize>
            } else if (fieldName == "printForm") {
                <sec:authorize access="hasAuthority('Evaluation_Reaction_Actions')">
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
                        if (record.evaluationStatusReaction == "0" || record.evaluationStatusReaction == null)
                            createDialog("info", "فرم ارزیابی واکنشی برای این فراگیر صادر نشده است");
                        else
                            print_Student_Reaction_Form_RE(record.id);
                    }
                });
                recordCanvas.addMember(printIcon);
                return recordCanvas;
                </sec:authorize>
            } else {
                return null;
            }
        },
    });

    //----------------------------------------- ToolStrips -------------------------------------------------------------
    var ToolStripButton_MSG_RE = isc.IButton.create({
        baseStyle: 'MSG-btn-orange',
        icon: '../static/img/msg/mail.svg',
        title: "ارسال پیام", width: 80,
        click: function () {
            let row = ListGrid_class_Evaluation.getSelectedRecord();
            let wait = createDialog("wait");
            RestDataSource_student_RE.implicitCriteria = null;
            if (contactSelector_RE.getValue() == 1) {//ارسال پیام به فراگیران کلاس
                isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/students-iscList/" + row.id, "GET", null, function (resp) {
                    if (generalGetResp(resp)) {
                        if (resp.httpResponseCode == 200) {

                            isc.RPCManager.sendRequest(TrDSRequest(parameterValueUrl + "/iscList/481?operator=and&_constructor=AdvancedCriteria&criteria={\"fieldName\":\"code\",\"operator\":\"equals\",\"value\":\"MCS1\",\"_constructor\":\"AdvancedCriteria\"}&_startRow=0&_endRow=75&_sortBy=title", "GET", null, function (resp2) {
                                wait.close();
                                if (generalGetResp(resp)) {
                                    if (resp.httpResponseCode == 200) {

                                        let id = [];
                                        JSON.parse(resp.data).response.data.filter(p => p.student.contactInfo.smSMobileNumber && (p.evaluationStatusReaction == 1)).forEach(p => id.push(p.id));

                                        if (JSON.parse(resp.data).response.data.filter(p => (p.evaluationStatusReaction == 1)).length == 0) {

                                            createDialog("warning", "فراگیری که وضعیت ارزیابی آن «صادر شده» باشد وجود ندارد", "<spring:message code="error"/>");
                                            return;
                                        }

                                        MSG_sendTypesItems = [];
                                         MSG_msgContent.type = [];
                                        MSG_sendTypesItems.push('MSG_messageType_sms');
                                        MSG_msgContent.type = MSG_sendTypesItems;

                                        sendMessageFunc = sendMessage_evaluation;
                                        RestDataSource_student_RE.fetchDataURL = tclassStudentUrl + "/students-iscList/" + row.id;
                                        MSG_selectUsersForm.getItem("multipleSelect").optionDataSource = RestDataSource_student_RE;
                                        RestDataSource_student_RE.implicitCriteria = {
                                            _constructor: "AdvancedCriteria",
                                            operator: "or",
                                            criteria: [{
                                                "fieldName": "evaluationStatusReaction",
                                                "operator": "inSet",
                                                "value": [1]
                                            }, {"fieldName": "evaluationStatusReaction", "operator": "isNull"}]
                                        };
                                        MSG_selectUsersForm.getItem("multipleSelect").pickListFields = [
                                            {
                                                name: "student.firstName",
                                                title: "<spring:message code="firstName"/>",
                                                autoFitWidth: false,
                                                align: "center"
                                            },
                                            {
                                                name: "student.lastName",
                                                title: "<spring:message code="lastName"/>",
                                                autoFitWidth: false,
                                                align: "center"
                                            },
                                            {
                                                name: "student.gender",
                                                title: "<spring:message code="gender"/>",
                                                filterOperator: "iContains",
                                                autoFitWidth: true,
                                                sortNormalizer: function (record) {
                                                    return record.student.gender;
                                                }
                                            },
                                            {
                                                name: "student.nationalCode",
                                                title: "<spring:message code="national.code"/>",
                                                width: 100,
                                                align: "center"
                                            },
                                            {
                                                name: "student.personnelNo",
                                                title: "<spring:message code="personnel.no"/>",
                                                width: 100,
                                                align: "center"
                                            },
                                            {
                                                name: "student.personnelNo2",
                                                title: "<spring:message code="personnel.no.6.digits"/>",
                                                width: 100,
                                                align: "center"
                                            },
                                            {
                                                name: "student.contactInfo.smSMobileNumber",
                                                title: "<spring:message code="mobile"/>",
                                                width: 100,
                                                align: "center"
                                            },
                                        ];
                                        MSG_selectUsersForm.getItem("multipleSelect").displayField = "fullName";
                                        MSG_selectUsersForm.getItem("multipleSelect").valueField = "id";
                                        MSG_selectUsersForm.getItem("multipleSelect").dataArrived = function (startRow, endRow) {
                                            let ids = MSG_selectUsersForm.getItem("multipleSelect").pickList.data.getAllCachedRows().filter(p => !p.student.contactInfo.smSMobileNumber || !(p.evaluationStatusReaction == 1)).map(function (item) {
                                                return item.id;
                                            });

                                            let findRows = MSG_selectUsersForm.getItem("multipleSelect").pickList.findAll({
                                                _constructor: "AdvancedCriteria",
                                                operator: "and",
                                                criteria: [{fieldName: "id", operator: "inSet", value: ids}]
                                            });

                                            findRows.setProperty("enabled", false);

                                            MSG_selectUsersForm.getItem("multipleSelect").setValue(id);
                                        }
                                        MSG_selectUsersForm.getItem("multipleSelect").fetchData();

                                        // MSG_textEditorValue = JSON.parse(resp2.data).response.data[0].description;
                                        // MSG_contentEditor.setValue("");

                                        linkFormMLanding.getItem('link').setValue('');

                                        if (JSON.parse(resp.data).response.data.filter(p => !p.student.contactInfo.smSMobileNumber && (p.evaluationStatusReaction == 1)).length != 0) {
                                            ErrorMsg.setContents('برای ' + JSON.parse(resp.data).response.data.filter(p => !p.student.contactInfo.smSMobileNumber && (p.evaluationStatusReaction == 1)).length + ' فراگیر، شماره موبایل تعریف نشده است.');
                                        } else if (JSON.parse(resp.data).response.data.filter(p => p.student.contactInfo.smSMobileNumber && (p.evaluationStatusReaction == 1)).length == 0) {
                                            ErrorMsg.setContents('هیچ مخاطبی انتخاب نشده است');
                                        } else {
                                            ErrorMsg.setContents('');
                                        }
                                        MSG_userType = "classStudent";
                                        MSG_classID = row.id;

                                        MSG_repeatOptions.getItem('maxRepeat').setValue(0);
                                        MSG_repeatOptions.getItem('timeBMessages').setValue(1);
                                        linkFormMLanding.getItem('link').setValue('');
                                        linkFormMLanding.getItem('link').setRequired(false);
                                        linkFormMLanding.getItem('link').enable();
                                        MSG_Window_MSG_Main.show();
                                        RestDataSource_Messages_reaction.fetchDataURL =  parameterValueUrl + "/messages/evaluation/student";
                                        MSG_main_layout.members[0].getField("messageType").optionDataSource = RestDataSource_Messages_reaction;
                                        MSG_main_layout.members[0].getField("messageType").fetchData();




                                    } else {
                                        createDialog("warning", "<spring:message code="exception.server.connection"/>", "<spring:message code="error"/>");
                                    }
                                }
                            }));

                        } else {
                            wait.close();
                            createDialog("warning", "<spring:message code="exception.server.connection"/>", "<spring:message code="error"/>");
                        }
                    } else {
                        wait.close();
                    }
                }));
            } else if (contactSelector_RE.getValue() == 2) {//ارسال پیام به مدرس کلاس

                if(ListGrid_class_Evaluation.getSelectedRecord().teacherEvalStatus!=1){
                    wait.close();
                    createDialog("warning", "امکان ارسال پیام به مدرس وجود ندارد.", "<spring:message code="error"/>");

                    return;
                }

                isc.RPCManager.sendRequest(TrDSRequest(teacherUrl + "spec-list?_constructor=AdvancedCriteria&_endRow=1000&_sortBy=id&_startRow=0&criteria=%7B%22operator%22%3A%22equals%22%2C%22fieldName%22%3A%22tclasse.id%22%2C%22value%22%3A%22" + row.id + "%22%7D&operator=and", "GET", null, function (resp) {
                    if (generalGetResp(resp)) {
                        if (resp.httpResponseCode == 200) {

                            isc.RPCManager.sendRequest(TrDSRequest(parameterValueUrl + "/iscList/481?operator=and&_constructor=AdvancedCriteria&criteria={\"fieldName\":\"code\",\"operator\":\"equals\",\"value\":\"MTeacher2\",\"_constructor\":\"AdvancedCriteria\"}&_startRow=0&_endRow=75&_sortBy=title", "GET", null, function (resp2) {
                                wait.close();
                                if (generalGetResp(resp)) {
                                    if (resp.httpResponseCode == 200) {

                                        let id = [];
                                        JSON.parse(resp.data).response.data.filter(p => p.personality?.contactInfo?.mobile).forEach(p => id.push(p.id));
                                        MSG_sendTypesItems = [];
                                        MSG_msgContent.type = [];
                                        MSG_sendTypesItems.push('MSG_messageType_sms');
                                        MSG_msgContent.type = MSG_sendTypesItems;

                                        sendMessageFunc = sendMessage_evaluation;
                                        RestDataSource_student_RE.fetchDataURL = teacherUrl + "spec-list";
                                        RestDataSource_student_RE.implicitCriteria = {
                                            _constructor: "AdvancedCriteria",
                                            operator: "and",
                                            criteria: [{fieldName: "tclasse.id", operator: "equals", value: row.id}]
                                        };
                                        MSG_selectUsersForm.getItem("multipleSelect").optionDataSource = RestDataSource_student_RE;
                                        MSG_selectUsersForm.getItem("multipleSelect").pickListFields = [
                                            {
                                                name: "teacherCode",
                                                title: "<spring:message code="national.code"/>",
                                                autoFitWidth: false,
                                                align: "center"
                                            },
                                            {
                                                name: "personality.firstNameFa",
                                                title: "<spring:message code="firstName"/>",
                                                autoFitWidth: false,
                                                align: "center"
                                            },
                                            {
                                                name: "personality.lastNameFa",
                                                title: "<spring:message code="lastName"/>",
                                                width: 100,
                                                align: "center"
                                            },
                                            {
                                                name: "personnelCode",
                                                title: "<spring:message code="personnel.code.six.digit"/>",
                                                width: 100,
                                                align: "center"
                                            },
                                            {
                                                name: "personality.contactInfo.mobile",
                                                title: "<spring:message code="mobile"/>",
                                                width: 100,
                                                align: "center"
                                            },
                                            {
                                                name: "enableStatus",
                                                title: "<spring:message code="status"/>",
                                                width: 100,
                                                align: "center",
                                                type: "boolean"
                                            },
                                        ];
                                        MSG_selectUsersForm.getItem("multipleSelect").displayField = "fullName";
                                        MSG_selectUsersForm.getItem("multipleSelect").valueField = "id";
                                        MSG_selectUsersForm.getItem("multipleSelect").dataArrived = function (startRow, endRow) {
                                            let ids = MSG_selectUsersForm.getItem("multipleSelect").pickList.data.getAllCachedRows().filter(p => !p?.personality?.contactInfo?.mobile).map(function (item) {
                                                return item.id;
                                            });
                                            let findRows = MSG_selectUsersForm.getItem("multipleSelect").pickList.findAll({
                                                _constructor: "AdvancedCriteria",
                                                operator: "and",
                                                criteria: [{fieldName: "id", operator: "inSet", value: ids}]
                                            });
                                            findRows.setProperty("enabled", false);

                                            MSG_selectUsersForm.getItem("multipleSelect").setValue(id);
                                        }
                                        MSG_selectUsersForm.getItem("multipleSelect").fetchData();

                                        // MSG_textEditorValue = JSON.parse(resp2.data).response.data[0].description;
                                        // MSG_contentEditor.setValue("");


                                        linkFormMLanding.getItem('link').setValue('');

                                        if (JSON.parse(resp.data).response.data.length == 1 && JSON.parse(resp.data).response.data.filter(p => !p?.personality?.contactInfo?.mobile).length != 0) {
                                            ErrorMsg.setContents('برای مدرس این کلاس، شماره موبایل تعریف نشده است.');
                                        } else if (JSON.parse(resp.data).response.data.filter(p => !p?.personality?.contactInfo?.mobile).length != 0) {
                                            ErrorMsg.setContents('برای ' + JSON.parse(resp.data).response.data.filter(p => !p?.personality?.contactInfo?.mobile).length + ' مدرس، شماره موبایل تعریف نشده است.');
                                        } else {
                                            ErrorMsg.setContents('');
                                        }
                                        MSG_userType = "classTeacher";
                                        MSG_classID = row.id;
                                        MSG_repeatOptions.getItem('maxRepeat').setValue(0);
                                        MSG_repeatOptions.getItem('timeBMessages').setValue(1);
                                        linkFormMLanding.getItem('link').setValue('');
                                        linkFormMLanding.getItem('link').setRequired(false);
                                        linkFormMLanding.getItem('link').enable();
                                        MSG_Window_MSG_Main.show();


                                        RestDataSource_Messages_reaction.fetchDataURL =  parameterValueUrl + "/messages/evaluation/teacher";
                                        MSG_main_layout.members[0].getField("messageType").optionDataSource = RestDataSource_Messages_reaction;
                                        MSG_main_layout.members[0].getField("messageType").fetchData();

                                    }
                                }
                            }));
                        } else {
                            wait.close();
                            createDialog("warning", "<spring:message code="exception.server.connection"/>", "<spring:message code="error"/>");
                        }
                    } else {
                        wait.close();
                    }
                }));

            } else {
                wait.close();
            }

        }
    });

    var ToolStripButton_FormIssuanceForAll_RE = isc.ToolStripButton.create({
        title: "صدور فرم ارزیابی واکنشی برای همه فراگیران",
        baseStyle: "sendFile",
        click: function () {
            Student_Reaction_Form_Inssurance_All_RE();
        }
    });

    var ToolStripButton_OnlineFormIssuanceForAll_RE = isc.ToolStripButton.create({
        title: "ارسال فرم ارزیابی به سیستم ارزشیابی آنلاین برای همه فراگیران",
        width: "100%",
        maxWidth: 500,
        baseStyle: 'MSG-btn-orange',
        click: function () {
            showOnlineResults('eval');
        }
    });


    var ToolStripButton_OnlineFormIssuanceResultForAll_RE = isc.ToolStripButton.create({
        title: "مشاهده نتیجه ارزیابی همه فراگیران",
        width: "100%",
        maxWidth: 500,
        baseStyle: "MSG-btn-orange",
        click: function () {
            showOnlineResults('evalResult');
        }
    });

    var ToolStripButton_FormIssuanceDeleteForAll_RE = isc.ToolStripButton.create({
        title: "حذف فرم ارزیابی واکنشی برای همه فراگیران",
        baseStyle: "sendFile",
        click: function () {
            let Dialog_remove = createDialog("ask", "آیا از حذف  همه ی فرم ها مطمئن هستید؟",
                "<spring:message code="verify.delete"/>");
            Dialog_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        evalWait_RE = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/deleteAllReactionEvaluationForms/" +
                            classRecord_RE.id+"/true", "GET", null, function (resp) {
                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                    ListGrid_student_RE.invalidateCache();
                                    isc.RPCManager.sendRequest(TrDSRequest(evaluationAnalysisUrl + "/updateEvaluationAnalysis" + "/" +
                                        classRecord_RE.id,"GET", null, null));
                                    const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                    if (classRecord_RE.classStudentOnlineEvalStatus) {
                                        ToolStripButton_OnlineFormIssuanceForAll_RE.setDisabled(false);
                                        classRecord_RE.classStudentOnlineEvalStatus= false;
                                        ListGrid_class_Evaluation.getSelectedRecord().classStudentOnlineEvalStatus = false;

                                    }
                                    setTimeout(() => {
                                        msg.close();
                                    }, 3000);
                                } else {
                                    createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                                }
                                evalWait_RE.close();
                            }
                        ))
                    }
                }
            });
        }
    });

    var ToolStripButton_RefreshIssuance_RE = isc.ToolStripButtonRefresh.create({
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_student_RE.invalidateCache();
        }
    });

    var ToolStripButton_Excel_RE = isc.ToolStripButtonExcel.create({
        click: function () {
            ExportToFile.downloadExcelRestUrl(null, ListGrid_student_RE, tclassStudentUrl, 0,
                null, '',  "لیست فراگیران", ListGrid_student_RE.data.getCriteria(), null);
        }
    });
    var ToolStripButton_Print_RE = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "<spring:message code='print'/>",
        click: function () {
            printStudentList(ListGrid_student_RE);
        }
    });
    var ToolStripButton_FormIssuance‌InCompleteUsers = isc.ToolStripButton.create({
        title: "نمایش لیست کاربران کلاس بااطلاعات ناقص",
        baseStyle: "sendFile",
        click: function () {
            console.log("1")
            showOnlineInCompleteUsers();
        }
    });

    var ToolStrip_RE = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 10,
        members: [
            isc.VLayout.create({
                width:"100%",
                height: "100%",
                members: [
                    isc.HLayout.create({
                        members: [
                            isc.HLayout.create({
                                width:"50%",
                                membersMargin: 5,
                                layoutAlign: "center",
                                defaultLayoutAlign: "center",
                                members: [
                                    isc.DynamicForm.create({
                                        height: "100%",
                                        numCols: 8,
                                        defaultLayoutAlign: "center",
                                        ID: "ToolStrip_SendForms_RE",
                                        fields: [
                                            <sec:authorize access="hasAuthority('Evaluation_Reaction_Actions')">
                                            {
                                                name: "sendButtonTeacher",
                                                title: "صدور فرم ارزیابی مدرس از کلاس",
                                                type: "button",
                                                width: 170,
                                                startRow: false,
                                                endRow: false,
                                                baseStyle: "sendFile",
                                                click: function () {
                                                    if (classRecord_RE.teacherEvalStatus != "0" && classRecord_RE.teacherEvalStatus != null)
                                                        createDialog("info", "قبلا فرم ارزیابی واکنشی برای مدرس صادر شده است");
                                                    else {
                                                        if (classRecord_RE.teacherId == undefined)
                                                            createDialog("info", "اطلاعات کلاس ناقص است!");
                                                        else
                                                            Teacher_Reaction_Form_Inssurance_RE();
                                                    }
                                                },
                                                icons: [
                                                    {
                                                        name: "ok",
                                                        src: "[SKIN]actions/ok.png",
                                                        width: 15,
                                                        height: 15,
                                                        inline: true,
                                                        prompt: "تائید صدور",
                                                        click: function (form, item, icon) {
                                                        }
                                                    }
                                                ]
                                            },
                                            </sec:authorize>
                                            <sec:authorize access="hasAuthority('Evaluation_Reaction_R')">
                                            {
                                                name: "registerButtonTeacher",
                                                title: "ثبت و مشاهده نتایج ارزیابی مدرس از کلاس",
                                                type: "button",
                                                width: 220,
                                                startRow: false,
                                                endRow: false,
                                                baseStyle: "registerFile",
                                                click: function () {
                                                    if (classRecord_RE.teacherEvalStatus == "0" || classRecord_RE.teacherEvalStatus == null)
                                                        createDialog("info", "فرم ارزیابی واکنشی برای مسئول آموزش صادر نشده است");
                                                    else
                                                        register_Teacher_Reaction_Form_RE();
                                                },
                                                icons: [
                                                    <sec:authorize access="hasAuthority('Evaluation_Reaction_Actions')">
                                                    {
                                                        name: "ok",
                                                        src: "[SKIN]actions/ok.png",
                                                        width: 15,
                                                        height: 15,
                                                        inline: true,
                                                        prompt: "تائید صدور",
                                                        click: function (form, item, icon) {
                                                        }
                                                    },
                                                    {
                                                        name: "clear",
                                                        src: "[SKIN]actions/remove.png",
                                                        width: 15,
                                                        height: 15,
                                                        inline: true,
                                                        prompt: "حذف فرم",
                                                        click: function (form, item, icon) {
                                                            if (classRecord_RE.teacherEvalStatus == "0" || classRecord_RE.teacherEvalStatus == null)
                                                                createDialog("info", "فرم ارزیابی واکنشی برای مدرس صادر نشده است");
                                                            else {
                                                                let Dialog_remove = createDialog("ask", "آیا از حذف فرم مطمئن هستید؟در صورت حذف, ارزیابی از سیستم آنلاین هم حذف خواهد شد.",
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
                                                                            data.alow = true;
                                                                            data.isTeacher = true;
                                                                            wait.show();

                                                                            isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/deleteEvaluation", "POST", JSON.stringify(data), function (resp) {
                                                                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                                                                    wait.close();
                                                                                    const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                                                                    setTimeout(() => {
                                                                                        msg.close();
                                                                                    }, 3000);
                                                                                    isc.RPCManager.sendRequest(TrDSRequest(evaluationAnalysisUrl + "/updateEvaluationAnalysis" + "/" +
                                                                                        classRecord_RE.id,"GET", null, null));
                                                                                    classRecord_RE.teacherEvalStatus = 0;
                                                                                    ToolStrip_SendForms_RE.getField("sendButtonTeacher").hideIcon("ok");
                                                                                    ToolStrip_SendForms_RE.getField("sendToEls_teacher").setDisabled(true);
                                                                                    ToolStrip_SendForms_RE.getField("showResultsEls_teacher").setDisabled(true);
                                                                                    if (classRecord_RE.classTeacherOnlineEvalStatus) {

                                                                                        classRecord_RE.classTeacherOnlineEvalStatus= false;
                                                                                        ListGrid_class_Evaluation.getSelectedRecord().classTeacherOnlineEvalStatus = false;

                                                                                    }

                                                                                    ToolStrip_SendForms_RE.getField("registerButtonTeacher").hideIcon("ok");
                                                                                    classRecord_RE.classTeacherOnlineEvalStatus= false;
                                                                                    ToolStrip_SendForms_RE.redraw();
                                                                                } else {
                                                                                    wait.close();
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
                                                        click: function (form, item, icon) {
                                                            if (classRecord_RE.teacherEvalStatus == "0" || classRecord_RE.teacherEvalStatus == null)
                                                                createDialog("info", "فرم ارزیابی واکنشی برای مدرس صادر نشده است");
                                                            else
                                                                print_Teacher_Reaction_Form_RE();
                                                        }
                                                    }
                                                    </sec:authorize>
                                                ]
                                            },
                                            </sec:authorize>
                                            <sec:authorize access="hasAuthority('Evaluation_Reaction_Actions')">
                                            {
                                                name: "sendToEls_teacher",
                                                title: "ارسال به سیستم ارزشیابی آنلاین",
                                                type: "button",
                                                startRow: false,
                                                // disabled: classRecord_RE.classTeacherOnlineEvalStatus,
                                                // disabled: true,
                                                endRow: false,
                                                click: function () {
                                                    if (classRecord_RE.teacherEvalStatus == "0" || classRecord_RE.teacherEvalStatus == null)
                                                        createDialog("info", "فرم ارزیابی واکنشی برای مدرس صادر نشده است");
                                                    sendToEls('teacher');
                                                }
                                            },
                                            </sec:authorize>
                                            {
                                                name: "showResultsEls_teacher",
                                                title: "مشاهده نتایج ارزیابی",
                                                type: "button",
                                                hidden: true,
                                                startRow: false,
                                                click: function () {
                                                    showResults('teacher')
                                                }
                                            },

                                            {
                                                name: "sendButtonTraining",
                                                title: "صدور فرم ارزیابی آموزش از مدرس",
                                                hidden: true,
                                                width: 170,
                                                type: "button",
                                                startRow: false,
                                                endRow: false,
                                                baseStyle: "sendFile",
                                                click: function () {
                                                    if (classRecord_RE.trainingEvalStatus != "0" && classRecord_RE.trainingEvalStatus != null)
                                                        createDialog("info", "قبلا فرم ارزیابی واکنشی برای مسئول آموزش صادر شده است");
                                                    else {
                                                        if (classRecord_RE.tclassSupervisor == undefined || classRecord_RE.teacherId == undefined)
                                                            createDialog("info", "اطلاعات کلاس ناقص است!");
                                                        else
                                                            Training_Reaction_Form_Inssurance_RE();
                                                    }
                                                },
                                                icons: [
                                                    {
                                                        name: "ok",
                                                        src: "[SKIN]actions/ok.png",
                                                        width: 15,
                                                        height: 15,
                                                        inline: true,
                                                        prompt: "تائید صدور",
                                                        click: function (form, item, icon) {
                                                        }
                                                    }
                                                ]
                                            },
                                            {
                                                name: "registerButtonTraining",
                                                title: "ثبت نتایج ارزیابی آموزش از مدرس",
                                                hidden: true,
                                                width: 170,
                                                type: "button",
                                                startRow: false,
                                                endRow: false,
                                                baseStyle: "registerFile",
                                                click: function () {
                                                    if (classRecord_RE.trainingEvalStatus == "0" || classRecord_RE.trainingEvalStatus == null)
                                                        createDialog("info", "فرم ارزیابی واکنشی برای مسئول آموزش صادر نشده است");
                                                    else
                                                        register_Training_Reaction_Form_RE();

                                                },
                                                icons: [
                                                    {
                                                        name: "ok",
                                                        src: "[SKIN]actions/ok.png",
                                                        width: 15,
                                                        height: 15,
                                                        inline: true,
                                                        prompt: "تائید ثبت",
                                                        click: function (form, item, icon) {
                                                        }
                                                    },
                                                    {
                                                        name: "clear",
                                                        src: "[SKIN]actions/remove.png",
                                                        width: 15,
                                                        height: 15,
                                                        inline: true,
                                                        prompt: "حذف فرم",
                                                        click: function (form, item, icon) {
                                                            if (classRecord_RE.trainingEvalStatus == "0" || classRecord_RE.trainingEvalStatus == null)
                                                                createDialog("info", "فرم ارزیابی واکنشی برای مسئول آموزش صادر نشده است");
                                                            else {
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
                                                                            isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/deleteEvaluation", "POST", JSON.stringify(data), function (resp) {
                                                                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                                                                    const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                                                                    setTimeout(() => {
                                                                                        msg.close();
                                                                                    }, 3000);
                                                                                    isc.RPCManager.sendRequest(TrDSRequest(evaluationAnalysisUrl + "/updateEvaluationAnalysis" + "/" +
                                                                                        classRecord_RE.id,"GET", null, null));
                                                                                    classRecord_RE.trainingEvalStatus = 0;
                                                                                    ToolStrip_SendForms_RE.getField("sendButtonTraining").hideIcon("ok");
                                                                                    // ToolStrip_SendForms_RE.getField("sendToEls_supervisor").setDisabled(true);
                                                                                    // ToolStrip_SendForms_RE.getField("showResultsEls_supervisor").setDisabled(true);

                                                                                    ToolStrip_SendForms_RE.getField("registerButtonTraining").hideIcon("ok");
                                                                                    ToolStrip_SendForms_RE.redraw();
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
                                                        click: function (form, item, icon) {
                                                            if (classRecord_RE.trainingEvalStatus == "0" || classRecord_RE.trainingEvalStatus == null)
                                                                createDialog("info", "فرم ارزیابی واکنشی برای مسئول آموزش صادر نشده است");
                                                            else
                                                                print_Training_Reaction_Form_RE();
                                                        }
                                                    }
                                                ]
                                            },
                                            // {
                                            //     name: "sendToEls_supervisor",
                                            //     title: "ارسال به آزمون آنلاین",
                                            //     type: "button",
                                            //     startRow: false,
                                            //     endRow: false,
                                            //     click: function () {
                                            //         console.log('send')
                                            //         sendToEls('supervisor')
                                            //     }
                                            // },
                                            // {
                                            //     name: "showResultsEls_supervisor",
                                            //     title: "مشاهده نتایج ارزیابی",
                                            //     type: "button",
                                            //     startRow: false,
                                            //     click: function () {
                                            //         console.log('show')
                                            //          showResults('supervisor')
                                            //     }
                                            // }
                                        ]
                                    }),

                                ]
                            }),
                            isc.HLayout.create({
                                width:"40%",
                                layoutAlign: "center",
                                defaultLayoutAlign: "center",
                                members: [
                                    isc.VLayout.create({
                                        membersMargin: 5,
                                        members: [
                                            <sec:authorize access="hasAuthority('Evaluation_Reaction_Actions')">
                                            ToolStripButton_FormIssuanceForAll_RE,
                                            ToolStripButton_FormIssuanceDeleteForAll_RE,
                                            </sec:authorize>
                                            <sec:authorize access="hasAuthority('Evaluation_Reaction_R')">
                                            ToolStripButton_FormIssuance‌InCompleteUsers
                                            </sec:authorize>
                                        ]
                                    }),
                                    isc.LayoutSpacer.create({height: "22"})
                                ]
                            }),
                            isc.RibbonGroup.create({
                                ID: "fileGroup_RE",
                                title: "راهنمای رنگ بندی لیست",
                                numRows: 1,
                                colWidths: [40, "*"],
                                height: "10px",
                                titleAlign: "center",
                                titleStyle: "gridHint",
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
                            })
                        ]
                    }),
                    isc.HLayout.create({
                        width:"100%",
                        height: "100%",
                        members: [
                            isc.HLayout.create({
                                width:"43%",
                                height: "100%",
                                layoutAlign: "center",
                                defaultLayoutAlign: "center",
                                members: [
                                    <sec:authorize access="hasAuthority('Evaluation_Reaction_Actions')">
                                    isc.DynamicForm.create({
                                        height: "100%",
                                        width: 400,
                                        margin: 0,
                                        fields: [
                                            {
                                                ID: 'contactSelector_RE',
                                                type: "SelectItem",
                                                textAlign: "center",
                                                pickListProperties: {
                                                    showFilterEditor: false
                                                },
                                                valueMap: {
                                                    1: "ارسال پیام به فراگیران تکمیل نکرده",
                                                    2: "ارسال پیام به مدرس  تکمیل نکرده",
                                                    //3: "ارسال پیام به فراگیرانی که فرم ارزیابی مدرس را تکمیل نکرده<spring:message code="title"/>اند"
                                                },
                                                defaultValue: 1
                                            }
                                        ]
                                    }),
                                    ToolStripButton_MSG_RE,
                                    </sec:authorize>
                                ]
                            }),
                            isc.HLayout.create({
                                layoutAlign: "center",
                                defaultLayoutAlign: "center",
                                align:"center",
                                width: "19%",
                                members: [
                                    isc.VLayout.create({
                                        membersMargin: 5,
                                        members: [
                                            <sec:authorize access="hasAuthority('Evaluation_Reaction_Actions')">
                                            ToolStripButton_OnlineFormIssuanceForAll_RE
                                            </sec:authorize>
                                        ]
                                    }),
                                ]
                            }),
                            isc.ToolStrip.create({
                                width: "30%",
                                align: "left",
                                border: '0px',
                                members: [
                                    <sec:authorize access="hasAuthority('Evaluation_Reaction_Actions')">
                                    ToolStripButton_Excel_RE,
                                    ToolStripButton_Print_RE,
                                    </sec:authorize>
                                    <sec:authorize access="hasAuthority('Evaluation_Reaction_R')">
                                    ToolStripButton_RefreshIssuance_RE
                                    </sec:authorize>
                                ]
                            })
                        ]
                    })
                ]
            })
        ]
    });

    function NCodeAndMobileValidation(nationalCode, mobileNum, gender) {
        console.log("4")

        let isValid = true;
        if (nationalCode===undefined || nationalCode===null) {
            isValid = false;
        } else isValid = !(nationalCode.length !== 10 || !(/^-?\d+$/.test(nationalCode)));
        return isValid;

        // let isValid = true;
        // if (nationalCode===undefined || nationalCode===null || mobileNum===undefined || mobileNum===null)
        // {
        //     isValid = false;
        // }
        // else
        // {
        //     if (nationalCode.length !== 10 || !(/^-?\d+$/.test(nationalCode)))
        //         isValid = false;
        //
        //     if((mobileNum.length !== 10 && mobileNum.length !== 11) || !(/^-?\d+$/.test(mobileNum)))
        //         isValid = false;
        //
        //     if(mobileNum.length === 10 && !mobileNum.startsWith("9"))
        //         isValid = false;
        //
        //     if(mobileNum.length === 11 && !mobileNum.startsWith("09"))
        //         isValid = false;
        // }
        // return isValid;
    }

    function toElsRquest(data,type) {
        wait.show()
        isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/getEvaluationForm", "POST", JSON.stringify(data), function (resp) {
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                let result = JSON.parse(resp.httpResponseText).response.data;
                isc.RPCManager.sendRequest(TrDSRequest("/training/anonymous/els/teacherEval/" + result[0].evaluationId, "GET", null, function (resp) {
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                        var OK = isc.Dialog.create({
                            message: "<spring:message code="msg.operation.successful"/>",
                            icon: "[SKIN]say.png",
                            title: "<spring:message code='message'/>"
                        });
                        if(type !== 'supervisor') {
                            ToolStrip_SendForms_RE.getField("sendToEls_teacher").setDisabled(true);
                            ToolStrip_SendForms_RE.getField("showResultsEls_teacher").setDisabled(false);
                            ListGrid_class_Evaluation.getSelectedRecord().classTeacherOnlineEvalStatus = true;
                        }
                        setTimeout(function () {
                            OK.close();
                        }, 2000);
                    } else {
                        if (resp.httpResponseCode === 500)
                            createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                        else
                            createDialog("info",JSON.parse(resp.httpResponseText).message, "<spring:message code="error"/>");
                    }
                    wait.close()
                }))
            } else {
                var ERROR = isc.Dialog.create({
                    message: "<spring:message code='exception.un-managed'/>",
                    icon: "[SKIN]stop.png",
                    title: "<spring:message code='message'/>"
                });
                setTimeout(function () {
                    ERROR.close();
                }, 2000);
                wait.close();
            }

        }));
    }
    function sendToEls(type) {
        let data = {};
        if(type === 'supervisor') {

            data.classId = classRecord_RE.id;
            data.evaluatorId = classRecord_RE.tclassSupervisor;
            data.evaluatorTypeId = 454;
            data.evaluatedId = classRecord_RE.teacherId;
            data.evaluatedTypeId = 187;
            data.questionnaireTypeId = 141;
            data.evaluationLevelId = 154;
            toElsRquest(data,type);
        } else {

            data.classId = classRecord_RE.id;
            data.evaluatorId = classRecord_RE.teacherId;
            data.evaluatorTypeId = 187;
            data.evaluatedId = classRecord_RE.id;
            data.evaluatedTypeId = 504;
            data.questionnaireTypeId = 140;
            data.evaluationLevelId = 154;

            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(teacherUrl + "" + data.evaluatorId, "GET", null, function (resp) {
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    toElsRquest(data,type);

                    <%--let teacherInfo = JSON.parse(resp.httpResponseText)--%>
                    <%--wait.close()--%>
                    <%--if (teacherInfo.personality !== null) {--%>
                    <%--    let isValid = NCodeAndMobileValidation(teacherInfo.personality.nationalCode, null, null);--%>
                    <%--    if (!isValid) {--%>
                    <%--        let stop = isc.Dialog.create({--%>
                    <%--            message: "کدملی مدرس بدرستی ثبت نشده است؛"+" "+--%>
                    <%--                "<spring:message code='msg.check.teacher.mobile.ncode.message'/>",--%>
                    <%--            icon: "[SKIN]stop.png",--%>
                    <%--            title: "<spring:message code='message'/>"--%>
                    <%--        });--%>
                    <%--        stop.show();--%>
                    <%--        return;--%>
                    <%--    } else {--%>
                    <%--        toElsRquest(data,type);--%>
                    <%--    }--%>
                    <%--} else {--%>
                    <%--    let stop = isc.Dialog.create({--%>
                    <%--        message: "کدملی مدرس بدرستی ثبت نشده است؛",--%>
                    <%--        icon: "[SKIN]stop.png",--%>
                    <%--        title: "<spring:message code='message'/>"--%>
                    <%--    });--%>
                    <%--    stop.show();--%>
                    <%--    return;--%>
                    <%--}--%>
                } else {
                    wait.close();
                    return;
                }
            }));
        }
    }
    function showResults(type) {
        let data = {};
        if(type == 'supervisor') {
            data.classId = classRecord_RE.id;
            data.evaluatorId = classRecord_RE.tclassSupervisor;
            data.evaluatorTypeId = 454;
            data.evaluatedId = classRecord_RE.teacherId;
            data.evaluatedTypeId = 187;
            data.questionnaireTypeId = 141;
            data.evaluationLevelId = 154;
        }else {
            data.classId = classRecord_RE.id;
            data.evaluatorId = classRecord_RE.teacherId;
            data.evaluatorTypeId = 187;
            data.evaluatedId = classRecord_RE.id;
            data.evaluatedTypeId = 504;
            data.questionnaireTypeId = 140;
            data.evaluationLevelId = 154;
        }


        let ListGrid_Result_evaluation = isc.TrLG.create({
            width: "100%",
            height: 700,
            dataSource: RestDataSource_Result_Evaluation,
            showRecordComponents: true,
            showRecordComponentsByCell: true,
            fields: [
                {name: "surname", title: 'نام',  width: "20%"},
                {name: "lastName", title: 'نام خانوادگی' , width: "20%"},
                {name: "description", title: 'توضیحات' , width:"20%"},
                { name: "iconField", title: " ", width: "10%"},
            ],
            createRecordComponent: function (record, colNum) {
                var fieldName = this.getFieldName(colNum);
                if (fieldName == "iconField") {
                    let button = isc.IButton.create({
                        layoutAlign: "center",
                        title: "پاسخ ها",
                        width: "120",
                        click: function () {
                            ListGrid_show_ansewrs(record.answers);
                        }
                    });
                    return button;
                } else {
                    return null;
                }
            }
        });


        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/getEvaluationForm", "POST", JSON.stringify(data), function (resp) {
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                let result = JSON.parse(resp.httpResponseText).response.data;
                isc.RPCManager.sendRequest(TrDSRequest("/training/anonymous/els/evalResult/" + result[0].evaluationId, "GET", null, function (resp) {
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                        let results = JSON.parse(resp.data).data;
                        ListGrid_Result_evaluation.setData(results);
                        let Window_result_JspEvaluation = isc.Window.create({
                            width: 1024,
                            height: 768,
                            keepInParentRect: true,
                            title: "مشاهده نتایج ارزیابی",
                            items: [
                                isc.VLayout.create({
                                    width: "100%",
                                    height: "100%",
                                    defaultLayoutAlign: "center",
                                    align: "center",
                                    members: [
                                        isc.HLayout.create({
                                            width: "100%",
                                            height: "90%",
                                            members: [ListGrid_Result_evaluation]
                                        }),
                                        isc.HLayout.create({
                                            width: "100%",
                                            height: "90%",
                                            align: "center",
                                            membersMargin: 10,
                                            members: [
                                                isc.IButtonCancel.create({
                                                    click: function () {
                                                        Window_result_JspEvaluation.close();
                                                    }
                                                })
                                            ]
                                        })]
                                })
                            ],
                            minWidth: 1024
                        });
                        Window_result_JspEvaluation.show();
                    } else {
                        var ERROR = isc.Dialog.create({
                            message: "<spring:message code='exception.un-managed'/>",
                            icon: "[SKIN]stop.png",
                            title: "<spring:message code='message'/>"
                        });
                        setTimeout(function () {
                            ERROR.close();
                        }, 8000);
                    }
                    wait.close();
                }))
            } else {
                wait.close()
                var ERROR = isc.Dialog.create({
                    message: "<spring:message code='exception.un-managed'/>",
                    icon: "[SKIN]stop.png",
                    title: "<spring:message code='message'/>"
                });
                setTimeout(function () {
                    ERROR.close();
                }, 8000);
            }
        }));
    }

    function printTeacherClearForm(id) {
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest("/training/anonymous/els/getEvalReport/" +id, "GET", null, function (resp) {
            <%--if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {--%>
            <%--    wait.close();--%>
            <%--} else {--%>
            <%--    var ERROR = isc.Dialog.create({--%>
            <%--        message: "<spring:message code='exception.un-managed'/>",--%>
            <%--        icon: "[SKIN]stop.png",--%>
            <%--        title: "<spring:message code='message'/>"--%>
            <%--    });--%>
            <%--    setTimeout(function () {--%>
            <%--        ERROR.close();--%>
            <%--    }, 8000);--%>
            <%--}--%>
            wait.close();
        }));
    }

    function studentsToElsRquest(data, type) {
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/getEvaluationForm", "POST", JSON.stringify(data), function (resp) {
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                let result = JSON.parse(resp.httpResponseText).response.data;

                if (type == 'eval') {

                    isc.RPCManager.sendRequest(TrDSRequest("/training/anonymous/els/eval/139/" + result[0].evaluationId, "GET", null, function (resp) {
                        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                            wait.close();
                            var OK = isc.Dialog.create({
                                message: "<spring:message code="msg.operation.successful"/>",
                                icon: "[SKIN]say.png",
                                title: "<spring:message code='message'/>"
                            });

                            ToolStripButton_OnlineFormIssuanceForAll_RE.setDisabled(true);
                            ToolStripButton_OnlineFormIssuanceResultForAll_RE.setDisabled(false);
                            ListGrid_class_Evaluation.getSelectedRecord().classStudentOnlineEvalStatus = true;
                            classRecord_RE.classStudentOnlineEvalStatus = true;
                            setTimeout(function () {
                                OK.close();
                            }, 2000);
                        } else {
                            wait.close();
                            if (resp.httpResponseCode === 500)
                                createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                            else if (resp.httpResponseCode === 406)
                                createDialog("info",  JSON.parse(resp.httpResponseText).message, "<spring:message code="error"/>");
                            else if (resp.httpResponseCode === 408)
                                createDialog("info", "<spring:message code="msg.els.timeOut"/>", "<spring:message code="error"/>");
                            else
                                createDialog("info",JSON.parse(resp.httpResponseText).message, "<spring:message code="error"/>");
                        }
                    }));
                }
                if (type == 'evalResult') {

                    isc.RPCManager.sendRequest(TrDSRequest("/training/anonymous/els/evalResult/" + result[0].evaluationId, "GET", null, function (resp) {
                        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                            wait.close();
                            let results = JSON.parse(resp.data).data;
                            var OK = isc.Dialog.create({
                                message: "<spring:message code="msg.operation.successful"/>",
                                icon: "[SKIN]say.png",
                                title: "<spring:message code='message'/>"
                            });
                            setTimeout(function () {
                                OK.close();
                            }, 2000);

                            ListGrid_Result_evaluation.setData(results);

                            let Window_result_JspEvaluation = isc.Window.create({
                                width: 1024,
                                height: 768,
                                keepInParentRect: true,
                                title: "مشاهده نتایج ارزیابی",
                                items: [
                                    isc.VLayout.create({
                                        width: "100%",
                                        height: "100%",
                                        defaultLayoutAlign: "center",
                                        align: "center",
                                        members: [
                                            isc.HLayout.create({
                                                width: "100%",
                                                height: "90%",
                                                members: [ListGrid_Result_evaluation]
                                            }),
                                            isc.HLayout.create({
                                                width: "100%",
                                                height: "90%",
                                                align: "center",
                                                membersMargin: 10,
                                                members: [
                                                    isc.IButtonCancel.create({
                                                        click: function () {
                                                            Window_result_JspEvaluation.close();
                                                        }
                                                    })
                                                ]
                                            })]
                                    })
                                ],
                                minWidth: 1024
                            });
                            Window_result_JspEvaluation.show();
                        } else {

                            var ERROR = isc.Dialog.create({
                                message: "<spring:message code='exception.un-managed'/>",
                                icon: "[SKIN]stop.png",
                                title: "<spring:message code='message'/>"
                            });
                            setTimeout(function () {
                                ERROR.close();
                            }, 8000);
                        }
                        wait.close();
                    }));
                }
            } else {
                wait.close()
                var ERROR = isc.Dialog.create({
                    message: "<spring:message code='exception.un-managed'/>",
                    icon: "[SKIN]stop.png",
                    title: "<spring:message code='message'/>"
                });
                setTimeout(function () {
                    ERROR.close();
                }, 8000);
            }
        }));
    }
    function showOnlineResults(type) {
        let data = {};

        if (ListGrid_student_RE.getData().localData.size() == 0){
            createDialog("info", "کلاس هیچ شرکت کننده ای ندارد");
            evalWait_RE.close();
        } else {
            let check = true;
            for (let j = 0; j < ListGrid_student_RE.getData().localData.size(); j++) {
                let record = ListGrid_student_RE.getData().localData[j];
                if (record.evaluationStatusReaction === null
                    || record.evaluationStatusReaction === 0
                    || record.evaluationStatusReaction === undefined) {
                    check = false;
                }
            }

            if(check && classRecord_RE.id) {
                let rec=ListGrid_student_RE.getData().localData[0];

                data.classId = classRecord_RE.id;
                data.evaluatorId = rec.id;
                data.evaluatorTypeId = 188;
                data.evaluatedId = classRecord_RE.id;
                data.evaluatedTypeId = 504;
                data.questionnaireTypeId = 139;
                data.evaluationLevelId = 154;

                let ListGrid_Result_evaluation = isc.TrLG.create({
                    width: "100%",
                    height: 700,
                    dataSource: RestDataSource_Result_Evaluation,
                    showRecordComponents: true,
                    showRecordComponentsByCell: true,
                    fields: [
                        {name: "surname", title: 'نام',  width: "20%"},
                        {name: "lastName", title: 'نام خانوادگی' , width: "20%"},
                        {name: "description", title: 'توضیحات' , width:"20%"},
                        { name: "iconField", title: " ", width: "10%"},
                    ],
                    createRecordComponent: function (record, colNum) {
                        var fieldName = this.getFieldName(colNum);
                        if (fieldName == "iconField") {
                            let button = isc.IButton.create({
                                layoutAlign: "center",
                                title: "پاسخ ها",
                                width: "120",
                                click: function () {
                                    ListGrid_show_ansewrs(record.answers);
                                }
                            });
                            return button;
                        } else {
                            return null;
                        }
                    }
                });

                studentsToElsRquest(data, type);

                <%--let gridData = ListGrid_student_RE.getData().localData;--%>
                <%--let inValidStudents = [];--%>

                <%--for (let i = 0; i < gridData.length; i++) {--%>

                <%--    let studentData = gridData[i].student;--%>
                <%--    // if (!NCodeAndMobileValidation(studentData.nationalCode, studentData.contactInfo.smSMobileNumber, studentData.gender)) {--%>
                <%--    if (!NCodeAndMobileValidation(studentData.nationalCode, null, null)) {--%>
                <%--        inValidStudents.add({--%>
                <%--            firstName: studentData.firstName,--%>
                <%--            lastName: studentData.lastName--%>
                <%--        });--%>
                <%--    }--%>
                <%--}--%>

                <%--if (inValidStudents.length) {--%>

                <%--    let DynamicForm_InValid_Students = isc.DynamicForm.create({--%>
                <%--        width: 600,--%>
                <%--        height: 100,--%>
                <%--        padding: 6,--%>
                <%--        titleAlign: "right",--%>
                <%--        fields: [--%>
                <%--            {--%>
                <%--                name: "text",--%>
                <%--                width: "100%",--%>
                <%--                colSpan: 2,--%>
                <%--                value: "کدملی فراگیران با اسامی زیر صحیح نیست؛"+" "+"<spring:message code='msg.check.student.mobile.ncode.message'/>",--%>
                <%--                showTitle: false,--%>
                <%--                editorType: 'staticText'--%>
                <%--            },--%>
                <%--            {--%>
                <%--                type: "RowSpacerItem"--%>
                <%--            },--%>
                <%--            {--%>
                <%--                name: "invalidNames",--%>
                <%--                width: "100%",--%>
                <%--                colSpan: 2,--%>
                <%--                title: "<spring:message code="title"/>",--%>
                <%--                showTitle: false,--%>
                <%--                editorType: 'textArea',--%>
                <%--                canEdit: false--%>
                <%--            }--%>
                <%--        ]--%>
                <%--    });--%>

                <%--    let names = "";--%>
                <%--    for (var j = 0; j < inValidStudents.length; j++) {--%>

                <%--        names = names.concat(inValidStudents[j].firstName + " " + inValidStudents[j].lastName  + "\n");--%>
                <%--    }--%>
                <%--    DynamicForm_InValid_Students.setValue("invalidNames", names);--%>

                <%--    let Window_InValid_Students = isc.Window.create({--%>
                <%--        width: 600,--%>
                <%--        height: 150,--%>
                <%--        numCols: 2,--%>
                <%--        title: "فراگیران با کدملی ناقص",--%>
                <%--        items: [--%>
                <%--            DynamicForm_InValid_Students,--%>
                <%--            isc.MyHLayoutButtons.create({--%>
                <%--                members: [--%>
                <%--                    isc.IButtonSave.create({--%>
                <%--                        title: "<spring:message code="continue"/>",--%>
                <%--                        click: function () {--%>

                <%--                            studentsToElsRquest(data, type);--%>
                <%--                            Window_InValid_Students.close();--%>
                <%--                        }}),--%>
                <%--                    isc.IButtonCancel.create({--%>
                <%--                        title: "<spring:message code="cancel"/>",--%>
                <%--                        click: function () {--%>
                <%--                            Window_InValid_Students.close();--%>
                <%--                        }--%>
                <%--                    })],--%>
                <%--            })]--%>
                <%--    });--%>
                <%--    Window_InValid_Students.show();--%>
                <%--} else {--%>
                <%--    studentsToElsRquest(data, type);--%>
                <%--}--%>
            } else {

                createDialog("info", "فرم ارزیابی برای همه ی شرکت کنندگان صادر نشده است.");
                evalWait_RE.close();
            }

        }

    }
    function showOnlineInCompleteUsers(){
        console.log("2")

        if (ListGrid_student_RE.getData().localData.size() == 0){
            createDialog("info", "کلاس هیچ شرکت کننده ای ندارد");
            evalWait_RE.close();
        } else {
            let check = true;
            for (let j = 0; j < ListGrid_student_RE.getData().localData.size(); j++) {
                let record = ListGrid_student_RE.getData().localData[j];
                if (record.evaluationStatusReaction === null
                    || record.evaluationStatusReaction === 0
                    || record.evaluationStatusReaction === undefined) {
                    check = false;
                }
            }

            if( classRecord_RE.id) {
                // let rec=ListGrid_student_RE.getData().localData[0];
                let gridData = ListGrid_student_RE.getData().localData;
                let inValidStudents = [];

                for (let i = 0; i < gridData.length; i++) {
                    console.log("3")

                    let studentData = gridData[i].student;
                    console.log(studentData.nationalCode)

                    // if (!NCodeAndMobileValidation(studentData.nationalCode, studentData.contactInfo.smSMobileNumber, studentData.gender)) {
                    if (!NCodeAndMobileValidation(studentData.nationalCode, null, null)) {

                        inValidStudents.add({
                            firstName: studentData.firstName,
                            lastName: studentData.lastName
                        });
                    }
                }

                if (inValidStudents.length) {

                    let DynamicForm_InValid_Students = isc.DynamicForm.create({
                        width: 600,
                        height: 100,
                        padding: 6,
                        titleAlign: "right",
                        fields: [
                            {
                                name: "text",
                                width: "100%",
                                colSpan: 2,
                                value: "کدملی فراگیران با اسامی زیر صحیح نیست؛"+" "+"<spring:message code='msg.check.student.mobile.ncode.message'/>",
                                showTitle: false,
                                editorType: 'staticText'
                            },
                            {
                                type: "RowSpacerItem"
                            },
                            {
                                name: "invalidNames",
                                width: "100%",
                                colSpan: 2,
                                title: "<spring:message code="title"/>",
                                showTitle: false,
                                editorType: 'textArea',
                                canEdit: false
                            }
                        ]
                    });

                    let names = "";
                    for (var j = 0; j < inValidStudents.length; j++) {

                        names = names.concat(inValidStudents[j].firstName + " " + inValidStudents[j].lastName  + "\n");
                    }
                    DynamicForm_InValid_Students.setValue("invalidNames", names);

                    let Window_InValid_Students = isc.Window.create({
                        width: 600,
                        height: 150,
                        numCols: 2,
                        title: "فراگیران با کدملی ناقص",
                        items: [
                            DynamicForm_InValid_Students,
                            isc.MyHLayoutButtons.create({
                                members: [
                                    isc.IButtonCancel.create({
                                        title: "<spring:message code="cancel"/>",
                                        click: function () {
                                            Window_InValid_Students.close();
                                        }
                                    })],
                            })]
                    });
                    Window_InValid_Students.show();
                } else {
                    createDialog("info", "در این کلاس فراگیر با اطلاعات ناقص وجود ندارد");
                }
            } else {

                createDialog("info", "برای مشاهده فراگیران با اطلاعات ناقص ابتدا کلاس مورد نظر را انتخاب کنید");
                evalWait_RE.close();
            }

        }
    }

    function ListGrid_show_ansewrs(answers) {
        let ListGrid_Result_Answer_evaluation = isc.TrLG.create({
            width: "100%",
            height: 700,
            dataSource: RestDataSource_Result_Answers_Evaluation,
            fields: [],
        });

        ListGrid_Result_Answer_evaluation.setData(answers)
        // ListGrid_Result_Answer_evaluation.invalidateCache();

        let Window_result_Answer_JspEvaluation = isc.Window.create({
            width: 1024,
            height: 768,
            keepInParentRect: true,
            title: "مشاهده پاسخ ها",
            items: [
                isc.VLayout.create({
                    width: "100%",
                    height: "100%",
                    defaultLayoutAlign: "center",
                    align: "center",
                    members: [
                        isc.HLayout.create({
                            width: "100%",
                            height: "90%",
                            members: [ListGrid_Result_Answer_evaluation]
                        }),
                        isc.IButtonCancel.create({
                            click: function () {
                                Window_result_Answer_JspEvaluation.close();
                            }
                        })]
                })
            ],
            minWidth: 1024
        })
        Window_result_Answer_JspEvaluation.show();
    }

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

        ]
    });

    var VLayout_Body_RE = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [HLayout_returnData_RE, HLayout_Actions_RE, Hlayout_Grid_RE]
    });

    //----------------------------------- New Funsctions ---------------------------------------------------------------
    function Student_Reaction_Form_Inssurance_RE(studentRecord) {
        let titr = isc.HTMLFlow.create({
            align: "center",
            border: "1px solid black",
            width: "25%"
        });
        titr.contents = "";


        let IButtonSave_SelectQuestionnarie_RE = isc.IButtonSave.create({
            title: "صدور/ارسال به کارتابل",
            width: 150,
            click: function () {
                if (ListGrid_SelectQuestionnarie_RE.getSelectedRecord() == null || ListGrid_SelectQuestionnarie_RE.getSelectedRecord() == undefined) {
                    createDialog("info", "پرسشنامه ای انتخاب نشده است.");
                } else {
                    Window_SelectQuestionnarie_RE.close();
                    create_evaluation_form_RE(null, ListGrid_SelectQuestionnarie_RE.getSelectedRecord().id, studentRecord.id, 188, classRecord_RE.id, 504, 139, 154);
                }
            }
        });
        let RestDataSource_Questionnarie_RE = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {
                    name: "title",
                    title: "<spring:message code="title"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {name: "questionnaireTypeId", hidden: true},
                {
                    name: "questionnaireType.title",
                    title: "<spring:message code="type"/>",
                    required: true,
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
            ],
            fetchDataURL: questionnaireUrl + "/iscList/validQestionnaries/" + classRecord_RE.id
        });
        let ListGrid_SelectQuestionnarie_RE = isc.TrLG.create({
            width: "100%",
            dataSource: RestDataSource_Questionnarie_RE,
            selectionType: "single",
            selectionAppearance: "checkbox",
            fields: [{name: "title"}, {name: "questionnaireType.title"}, {name: "description"}, {
                name: "id",
                hidden: true
            }]
        });
        let Window_SelectQuestionnarie_RE = isc.Window.create({
            width: 1024,
            placement: "fillScreen",
            keepInParentRect: true,
            title: "انتخاب پرسشنامه",
            items: [
                isc.HLayout.create({
                    width: "100%",
                    height: "80%",
                    members: [ListGrid_SelectQuestionnarie_RE]
                }),
                isc.TrHLayoutButtons.create({
                    width: "100%",
                    height: "5%",
                    members: [
                        titr
                    ]
                }),
                isc.TrHLayoutButtons.create({
                    width: "100%",
                    height: "5%",
                    members: [
                        IButtonSave_SelectQuestionnarie_RE,
                        isc.IButtonCancel.create({
                            click: function () {
                                Window_SelectQuestionnarie_RE.close();
                            }
                        })
                    ]
                }),
            ],
            minWidth: 1024
        });
        let criteria = {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [
                {fieldName: "enabled", operator: "isNull"},
                {fieldName: "questionnaireTypeId", operator: "equals", value: 139}
            ]
        };
        ListGrid_SelectQuestionnarie_RE.fetchData(criteria);
        ListGrid_SelectQuestionnarie_RE.invalidateCache();
        Window_SelectQuestionnarie_RE.show();
        titr.contents = "<span style='color:rgba(199,23,15,0.91); font-size:13px;'>" + "کاربر گرامی در صورتی که قبلا فرم ارزیابی واکنشی برای این کلاس صادر شده باشد، فقط پرسشنامه ی منتخب قبلی در اینجا به شما نشان داده می شود، در صورتی که پرسشنامه ای مشاهده نمیکنید، فعال و غیرفعال بودن پرسشنامه ها را چک کنید." + "</span>";
        titr.redraw();
    }

    function Student_Reaction_Form_Inssurance_All_RE() {
        let check = false;
        for (let j = 0; j < ListGrid_student_RE.getData().localData.size(); j++) {
            let record = ListGrid_student_RE.getData().localData[j];
            if (record.evaluationStatusReaction == null
                || record.evaluationStatusReaction == 0
                || record.evaluationStatusReaction == undefined) {
                check = true;
            }
        }
        if (check) {
            let titr = isc.HTMLFlow.create({
                align: "center",
                border: "1px solid black",
                width: "25%"
            });
            titr.contents = "";
            let IButtonSave_SelectQuestionnarie_RE = isc.IButtonSave.create({
                title: "صدور/ارسال به کارتابل",
                width: 150,
                click: function () {
                    if (ListGrid_SelectQuestionnarie_RE.getSelectedRecord() == null || ListGrid_SelectQuestionnarie_RE.getSelectedRecord() == undefined) {
                        createDialog("info", "پرسشنامه ای انتخاب نشده است.");
                    } else {
                        let stdIds = new Array();
                        Window_SelectQuestionnarie_RE.close();
                        for (let j = 0; j < ListGrid_student_RE.getData().localData.size(); j++) {
                            let record = ListGrid_student_RE.getData().localData[j];
                            if (record.evaluationStatusReaction == null
                                || record.evaluationStatusReaction == 0
                                || record.evaluationStatusReaction == undefined) {
                                stdIds.push(record.id);
                            }
                        }
                        create_multiple_evaluation_form_RE(null, ListGrid_SelectQuestionnarie_RE.getSelectedRecord().id, stdIds, 188, classRecord_RE.id, 504, 139, 154, check)
                    }
                }
            });
            let RestDataSource_Questionnarie_RE = isc.TrDS.create({
                fields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {
                        name: "title",
                        title: "<spring:message code="title"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {name: "questionnaireTypeId", hidden: true},
                    {
                        name: "questionnaireType.title",
                        title: "<spring:message code="type"/>",
                        required: true,
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
                ],
                fetchDataURL: questionnaireUrl + "/iscList/validQestionnaries/" + classRecord_RE.id
            });
            let ListGrid_SelectQuestionnarie_RE = isc.TrLG.create({
                width: "100%",
                dataSource: RestDataSource_Questionnarie_RE,
                selectionType: "single",
                selectionAppearance: "checkbox",
                fields: [{name: "title"}, {name: "questionnaireType.title"}, {name: "description"}, {
                    name: "id",
                    hidden: true
                }]
            });
            let Window_SelectQuestionnarie_RE = isc.Window.create({
                width: 1024,
                placement: "fillScreen",
                keepInParentRect: true,
                title: "انتخاب پرسشنامه",
                items: [
                    isc.HLayout.create({
                        width: "100%",
                        height: "80%",
                        members: [ListGrid_SelectQuestionnarie_RE]
                    }),
                    isc.TrHLayoutButtons.create({
                        width: "100%",
                        height: "5%",
                        members: [
                            titr
                        ]
                    }),
                    isc.TrHLayoutButtons.create({
                        width: "100%",
                        height: "5%",
                        members: [
                            IButtonSave_SelectQuestionnarie_RE,

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
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [
                    {fieldName: "enabled", operator: "isNull"},
                    {fieldName: "questionnaireTypeId", operator: "equals", value: 139}
                ]
            };
            ListGrid_SelectQuestionnarie_RE.fetchData(criteria);
            ListGrid_SelectQuestionnarie_RE.invalidateCache();
            Window_SelectQuestionnarie_RE.show();
            titr.contents = "<span style='color:rgba(199,23,15,0.91); font-size:13px;'>" + "کاربر گرامی در صورتی که قبلا فرم ارزیابی واکنشی برای این کلاس صادر شده باشد، فقط پرسشنامه ی منتخب  قبلی در اینجا به شما نشان داده می شود، در صورتی که پرسشنامه ای مشاهده نمیکنید، فعال و غیرفعال بودن پرسشنامه ها را چک کنید." + "</span>";
            titr.redraw();
        }
        else{
            createDialog("info", "برای تمام فراگیران کلاس فرم ارزیابی واکنشی صادر شده است.");
            evalWait_RE.close();
        }
    }

    function register_Student_Reaction_Form_RE(StdRecord) {
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
                {
                    name: "evaluationType",
                    title: "<spring:message code="evaluation.type"/>:",
                    canEdit: false,
                    endRow: true
                },
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
                    title: "<spring:message code='suggestions'/>",
                    type: 'textArea',
                    height: 100,
                    length: "600",
                    enforceLength : true
                }
            ]
        });

        let IButton_Questions_Save = isc.IButtonSave.create({
            click: function () {
                let evaluationAnswerList = [];
                let data = {};
                let evaluationFull = true;
                let evaluationEmpty = true;

                let questions = DynamicForm_Questions_Body_JspEvaluation.getFields();
                for (let i = 0; i < questions.length; i++) {
                    if (DynamicForm_Questions_Body_JspEvaluation.getValue(questions[i].name) === undefined) {
                        evaluationFull = false;
                    }
                    else{
                        evaluationEmpty = false;
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
                if(evaluationEmpty == false){
                    isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/" + evaluationId, "PUT", JSON.stringify(data), function (resp) {
                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                            Window_Questions_JspEvaluation.close();
                            ListGrid_student_RE.invalidateCache();
                            isc.RPCManager.sendRequest(TrDSRequest(evaluationAnalysisUrl + "/updateEvaluationAnalysis" + "/" +
                                classRecord_RE.id,"GET", null, null));
                            const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                            setTimeout(() => {
                                msg.close();
                            }, 3000);
                        } else if (JSON.parse(resp.httpResponseText).errors.get(0).code === "EvaluationDeadline") {
                            createDialog("info", "<spring:message code="evaluation.deadline"/>", "<spring:message code="error"/>");
                        } else {
                            createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                        }
                    }))
                }
                else{
                    createDialog("info", "حداقل به یکی از سوالات فرم ارزیابی باید جواب داده شود", "<spring:message code="error"/>");
                }

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
                        <sec:authorize access="hasAuthority('Evaluation_Reaction_Actions')">
                        IButton_Questions_Save,
                        </sec:authorize>
                        isc.IButtonCancel.create({
                            click: function () {
                                Window_Questions_JspEvaluation.close();
                            }
                        })]
                }),
                isc.HLayout.create({
                    width: "100%",
                    align: "center",
                    members: [
                        isc.ToolStripButton.create({
                            title: "مشاهده تاریخچه نتایج ارزیابی",
                            width: "150",
                            click: function () {
                                showEvalAnswerHistory(evaluationId);
                            }
                        })
                    ]
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
        isc.RPCManager.sendRequest(TrDSRequest(teacherUrl + "teacherFullName/" + classRecord_RE.teacherId, "GET", null, function (resp) {
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
                for (let i = 0; i < result.size(); i++) {
                    let item = {};
                    if (result[i].questionSourceId === 199) {
                        switch (result[i].domainId) {
                            case 54:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
                                item.title = "امکانات: " + result[i].question;
                                break;
                            case 138:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
                                item.title = "کلاس: " + result[i].question;
                                break;
                            case 53:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
                                item.title = "مدرس: " + result[i].question;
                                break;
                            case 1:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
                                item.title = "مدرس: " + result[i].question;
                                break;
                            case 183:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
                                item.title = "محتواي کلاس: " + result[i].question;
                                break;
                            case 659:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
                                item.title = "فراگیر: " + result[i].question;
                                break;
                            default:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
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
                                click: function (form, item, icon) {
                                    item.clearValue();
                                    item.focusInItem();
                                }
                            }
                        ];
                        record["Q" + result[i].id] = result[i].answerId;
                    } else if (result[i].questionSourceId === 200) {
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
                                click: function (form, item, icon) {
                                    item.clearValue();
                                    item.focusInItem();
                                }
                            }
                        ];
                        record["M" + result[i].id] = result[i].answerId;
                    } else if (result[i].questionSourceId === 201) {
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
                                click: function (form, item, icon) {
                                    item.clearValue();
                                    item.focusInItem();
                                }
                            }
                        ];
                        record["G" + result[i].id] = result[i].answerId;
                    }
                    itemList.add(item);
                }
                itemList.sortByProperty("domainId", true);
                DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                DynamicForm_Description_JspEvaluation.getField("description").setValue(description);
                DynamicForm_Questions_Body_JspEvaluation.setValues(record);
                evalWait_RE.close();
            }));
        }
    }

    function Training_Reaction_Form_Inssurance_RE() {
        let IButtonSave_SelectQuestionnarie_RE = isc.IButtonSave.create({
            title: "صدور/ارسال به کارتابل",
            width: 150,
            click: function () {
                if (ListGrid_SelectQuestionnarie_RE.getSelectedRecord() == null || ListGrid_SelectQuestionnarie_RE.getSelectedRecord() == undefined) {
                    createDialog("info", "پرسشنامه ای انتخاب نشده است.");
                } else {
                    Window_SelectQuestionnarie_RE.close();
                    create_evaluation_form_RE(null, ListGrid_SelectQuestionnarie_RE.getSelectedRecord().id, classRecord_RE.tclassSupervisor, 454, classRecord_RE.teacherId, 187, 141, 154);
                }
            }
        });
        let RestDataSource_Questionnarie_RE = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {
                    name: "title",
                    title: "<spring:message code="title"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {name: "questionnaireTypeId", hidden: true},
                {
                    name: "questionnaireType.title",
                    title: "<spring:message code="type"/>",
                    required: true,
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
            ],
            fetchDataURL: questionnaireUrl + "/iscList/validQestionnaries/" + classRecord_RE.id
        });
        let ListGrid_SelectQuestionnarie_RE = isc.TrLG.create({
            width: "100%",
            dataSource: RestDataSource_Questionnarie_RE,
            selectionType: "single",
            selectionAppearance: "checkbox",
            fields: [{name: "title"}, {name: "questionnaireType.title"}, {name: "description"}, {
                name: "id",
                hidden: true
            }]
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
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [
                {fieldName: "enabled", operator: "isNull"},
                {fieldName: "questionnaireTypeId", operator: "equals", value: 141}
            ]
        };
        ListGrid_SelectQuestionnarie_RE.fetchData(criteria);
        ListGrid_SelectQuestionnarie_RE.invalidateCache();
        Window_SelectQuestionnarie_RE.show();
    }

    function register_Training_Reaction_Form_RE() {
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
                {
                    name: "evaluationType",
                    title: "<spring:message code="evaluation.type"/>:",
                    canEdit: false,
                    endRow: true
                },
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
                    title: "<spring:message code='suggestions'/>",
                    type: 'textArea',
                    height: 100,
                    length: "600",
                    enforceLength : true
                }
            ]
        });

        let IButton_Questions_Save = isc.IButtonSave.create({
            click: function () {
                let evaluationAnswerList = [];
                let data = {};
                let evaluationFull = true;
                let evaluationEmpty = true;

                let questions = DynamicForm_Questions_Body_JspEvaluation.getFields();
                for (let i = 0; i < questions.length; i++) {
                    if (DynamicForm_Questions_Body_JspEvaluation.getValue(questions[i].name) === undefined) {
                        evaluationFull = false;
                    }
                    else{
                        evaluationEmpty = false;
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
                if(evaluationEmpty == false ){
                    isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/" + evaluationId, "PUT", JSON.stringify(data), function (resp) {
                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                            Window_Questions_JspEvaluation.close();
                            if (evaluationFull == true)
                                classRecord_RE.trainingEvalStatus = 2;
                            else
                                classRecord_RE.trainingEvalStatus = 3;
                            isc.RPCManager.sendRequest(TrDSRequest(evaluationAnalysisUrl + "/updateEvaluationAnalysis" + "/" +
                                classRecord_RE.id,"GET", null, null));
                            ToolStrip_SendForms_RE.getField("registerButtonTraining").showIcon("ok");
                            ToolStrip_SendForms_RE.redraw();
                            const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                            setTimeout(() => {
                                msg.close();
                            }, 3000);
                        } else {
                            createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                        }
                    }))
                }
                else{
                    createDialog("info", "حداقل به یکی از سوالات فرم ارزیابی باید جواب داده شود", "<spring:message code="error"/>");
                }

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
        isc.RPCManager.sendRequest(TrDSRequest(teacherUrl + "teacherFullName/" + classRecord_RE.teacherId, "GET", null, function (resp1) {
            DynamicForm_Questions_Title_JspEvaluation.getItem("teacher").setValue(resp1.httpResponseText);
            DynamicForm_Questions_Title_JspEvaluation.setValue("evaluated", resp1.httpResponseText);
            isc.RPCManager.sendRequest(TrDSRequest(personnelUrl + "/personnelFullName/" + classRecord_RE.tclassSupervisor, "GET", null, function (resp2) {
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
                for (let i = 0; i < result.size(); i++) {
                    let item = {};
                    if (result[i].questionSourceId === 199) {
                        switch (result[i].domainId) {
                            case 54:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
                                item.title = "امکانات: " + result[i].question;
                                break;
                            case 138:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
                                item.title = "کلاس: " + result[i].question;
                                break;
                            case 53:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
                                item.title = "مدرس: " + result[i].question;
                                break;
                            case 1:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
                                item.title = "مدرس: " + result[i].question;
                                break;
                            case 183:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
                                item.title = "محتواي کلاس: " + result[i].question;
                                break;
                            case 659:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
                                item.title = "فراگیر: " + result[i].question;
                                break;
                            default:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
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
                                click: function (form, item, icon) {
                                    item.clearValue();
                                    item.focusInItem();
                                }
                            }
                        ];
                        record["Q" + result[i].id] = result[i].answerId;
                    } else if (result[i].questionSourceId === 200) {
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
                                click: function (form, item, icon) {
                                    item.clearValue();
                                    item.focusInItem();
                                }
                            }
                        ];
                        record["M" + result[i].id] = result[i].answerId;
                    } else if (result[i].questionSourceId === 201) {
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
                                click: function (form, item, icon) {
                                    item.clearValue();
                                    item.focusInItem();
                                }
                            }
                        ];
                        record["G" + result[i].id] = result[i].answerId;
                    }
                    itemList.add(item);
                }
                itemList.sortByProperty("domainId", true);
                DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                DynamicForm_Description_JspEvaluation.getField("description").setValue(description);
                DynamicForm_Questions_Body_JspEvaluation.setValues(record);
                evalWait_RE.close();
            }));
        }
    }

    function Teacher_Reaction_Form_Inssurance_RE() {
        let IButtonSave_SelectQuestionnarie_RE = isc.IButtonSave.create({
            title: "صدور/ارسال به کارتابل",
            width: 150,
            click: function () {
                if (ListGrid_SelectQuestionnarie_RE.getSelectedRecord() == null || ListGrid_SelectQuestionnarie_RE.getSelectedRecord() == undefined) {
                    createDialog("info", "پرسشنامه ای انتخاب نشده است.");
                } else {
                    Window_SelectQuestionnarie_RE.close();
                    create_evaluation_form_RE(null, ListGrid_SelectQuestionnarie_RE.getSelectedRecord().id, classRecord_RE.teacherId, 187, classRecord_RE.id, 504, 140, 154);
                }
            }
        });
        let RestDataSource_Questionnarie_RE = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {
                    name: "title",
                    title: "<spring:message code="title"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {name: "questionnaireTypeId", hidden: true},
                {
                    name: "questionnaireType.title",
                    title: "<spring:message code="type"/>",
                    required: true,
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
            ],
            fetchDataURL: questionnaireUrl + "/iscList/validQestionnaries/" + classRecord_RE.id
        });
        let ListGrid_SelectQuestionnarie_RE = isc.TrLG.create({
            width: "100%",
            dataSource: RestDataSource_Questionnarie_RE,
            selectionType: "single",
            selectionAppearance: "checkbox",
            fields: [{name: "title"}, {name: "questionnaireType.title"}, {name: "description"}, {
                name: "id",
                hidden: true
            }]
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
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [
                {fieldName: "enabled", operator: "isNull"},
                {fieldName: "questionnaireTypeId", operator: "equals", value: 140}
            ]
        };
        ListGrid_SelectQuestionnarie_RE.fetchData(criteria);
        ListGrid_SelectQuestionnarie_RE.invalidateCache();
        Window_SelectQuestionnarie_RE.show();
    }

    function register_Teacher_Reaction_Form_RE() {
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
                {
                    name: "evaluationType",
                    title: "<spring:message code="evaluation.type"/>:",
                    canEdit: false,
                    endRow: true
                },
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
                    title: "<spring:message code='suggestions'/>",
                    type: 'textArea',
                    height: 100,
                    length: "600",
                    enforceLength : true
                }
            ]
        });

        let IButton_Questions_Save = isc.IButtonSave.create({
            click: function () {
                let evaluationAnswerList = [];
                let data = {};
                let evaluationFull = true;
                let evaluationEmpty = true;

                let questions = DynamicForm_Questions_Body_JspEvaluation.getFields();
                for (let i = 0; i < questions.length; i++) {
                    if (DynamicForm_Questions_Body_JspEvaluation.getValue(questions[i].name) === undefined) {
                        evaluationFull = false;
                    }
                    else{
                        evaluationEmpty = false;
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
                if(evaluationEmpty == false){
                    isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/" + evaluationId, "PUT", JSON.stringify(data), function (resp) {
                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                            Window_Questions_JspEvaluation.close();
                            if (evaluationFull == true)
                                classRecord_RE.teacherEvalStatus = 2;
                            else
                                classRecord_RE.teacherEvalStatus = 3;
                            isc.RPCManager.sendRequest(TrDSRequest(evaluationAnalysisUrl + "/updateEvaluationAnalysis" + "/" +
                                classRecord_RE.id,"GET", null, null));
                            ToolStrip_SendForms_RE.getField("registerButtonTeacher").showIcon("ok");
                            ToolStrip_SendForms_RE.redraw();
                            const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                            setTimeout(() => {
                                msg.close();
                            }, 3000);
                        } else if (JSON.parse(resp.httpResponseText).errors.get(0).code === "EvaluationDeadline") {
                            createDialog("info", "<spring:message code="evaluation.deadline"/>", "<spring:message code="error"/>");
                        }
                        else {
                            createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                        }
                    }))
                }
                else{
                    createDialog("info", "حداقل به یکی از سوالات فرم ارزیابی باید جواب داده شود", "<spring:message code="error"/>");
                }
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
                        <sec:authorize access="hasAuthority('Evaluation_Reaction_Actions')">
                        IButton_Questions_Save,
                        </sec:authorize>
                        isc.IButtonCancel.create({
                            click: function () {
                                Window_Questions_JspEvaluation.close();
                            }
                        })]
                }),
                isc.HLayout.create({
                    width: "100%",
                    align: "center",
                    members: [
                        isc.ToolStripButton.create({
                            title: "مشاهده تاریخچه نتایج ارزیابی",
                            width: "150",
                            click: function () {
                                showEvalAnswerHistory(evaluationId);
                            }
                        })
                    ]
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
        isc.RPCManager.sendRequest(TrDSRequest(teacherUrl + "teacherFullName/" + classRecord_RE.teacherId, "GET", null, function (resp1) {
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
                for (let i = 0; i < result.size(); i++) {
                    let item = {};
                    if (result[i].questionSourceId === 199) {
                        switch (result[i].domainId) {
                            case 54:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
                                item.title = "امکانات: " + result[i].question;
                                break;
                            case 138:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
                                item.title = "کلاس: " + result[i].question;
                                break;
                            case 53:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
                                item.title = "مدرس: " + result[i].question;
                                break;
                            case 1:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
                                item.title = "مدرس: " + result[i].question;
                                break;
                            case 183:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
                                item.title = "محتواي کلاس: " + result[i].question;
                                break;
                            case 659:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
                                item.title = "فراگیر: " + result[i].question;
                                break;
                            default:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
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
                                click: function (form, item, icon) {
                                    item.clearValue();
                                    item.focusInItem();
                                }
                            }
                        ];
                        record["Q" + result[i].id] = result[i].answerId;
                    } else if (result[i].questionSourceId === 200) {
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
                                click: function (form, item, icon) {
                                    item.clearValue();
                                    item.focusInItem();
                                }
                            }
                        ];
                        record["M" + result[i].id] = result[i].answerId;
                    } else if (result[i].questionSourceId === 201) {
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
                                click: function (form, item, icon) {
                                    item.clearValue();
                                    item.focusInItem();
                                }
                            }
                        ];
                        record["G" + result[i].id] = result[i].answerId;
                    }
                    itemList.add(item);
                }
                itemList.sortByProperty("domainId", true);
                DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                DynamicForm_Description_JspEvaluation.getField("description").setValue(description);
                DynamicForm_Questions_Body_JspEvaluation.setValues(record);
                evalWait_RE.close();
            }));
        }
    }

    function print_Teacher_Reaction_Form_RE() {
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

    function print_Training_Reaction_Form_RE() {
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

    function print_Student_Reaction_Form_RE(stdId) {
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
    function create_evaluation_form_RE(id, questionnarieId, evaluatorId,
                                       evaluatorTypeId, evaluatedId, evaluatedTypeId, questionnarieTypeId,
                                       evaluationLevel,check) {
        let data = {};
        data.classId = classRecord_RE.id;
        data.status = false;
        if (ReturnDate_RE._value != undefined)
            data.returnDate = ReturnDate_RE._value;
        data.sendDate = todayDate;
        data.evaluatorId = evaluatorId;
        data.evaluatorTypeId = evaluatorTypeId;
        data.evaluatedId = evaluatedId;
        data.evaluatedTypeId = evaluatedTypeId;
        data.questionnaireId = questionnarieId;
        data.questionnaireTypeId = questionnarieTypeId;
        data.evaluationLevelId = evaluationLevel;
        data.evaluationFull = false;
        data.description = null;

        isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl, "POST", JSON.stringify(data), function (resp) {
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                if(check == true){}
                else{
                    const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                    setTimeout(() => {
                        msg.close();
                    }, 3000);
                }
                if (questionnarieTypeId == 139) {
                    ListGrid_student_RE.invalidateCache();
                } else if (questionnarieTypeId == 141) {
                    classRecord_RE.trainingEvalStatus = 1;

                    ToolStrip_SendForms_RE.getField("sendButtonTraining").showIcon("ok");
                    //  ToolStrip_SendForms_RE.getField("sendToEls_supervisor").setDisabled(false);
                    //  ToolStrip_SendForms_RE.getField("showResultsEls_supervisor").setDisabled(false);

                    ToolStrip_SendForms_RE.redraw();
                } else if (questionnarieTypeId == 140) {
                    classRecord_RE.teacherEvalStatus = 1;

                    ToolStrip_SendForms_RE.getField("sendButtonTeacher").showIcon("ok");
                    ToolStrip_SendForms_RE.getField("sendToEls_teacher").setDisabled(false);
                    ToolStrip_SendForms_RE.getField("showResultsEls_teacher").setDisabled(true);

                    ToolStrip_SendForms_RE.redraw();
                }
            } else {
                createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
            }
        }));
    }

    function create_multiple_evaluation_form_RE(id, questionnarieId, evaluatorIds, evaluatorTypeId, evaluatedId,
                                                evaluatedTypeId, questionnarieTypeId, evaluationLevel,check){

        let data = {};
        data.classId = classRecord_RE.id;
        data.status = false;
        if (ReturnDate_RE._value != undefined)
            data.returnDate = ReturnDate_RE._value;
        data.sendDate = todayDate;
        data.evaluatorTypeId = evaluatorTypeId;
        data.evaluatedId = evaluatedId;
        data.evaluatedTypeId = evaluatedTypeId;
        data.questionnaireId = questionnarieId;
        data.questionnaireTypeId = questionnarieTypeId;
        data.evaluationLevelId = evaluationLevel;
        data.evaluationFull = false;
        data.description = null;

        evalWait_RE = createDialog("wait");
        isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/groupCreate/" + evaluatorIds, "POST", JSON.stringify(data), function (resp) {
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    if(check == true){}
                    else{
                        const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                        setTimeout(() => {
                            msg.close();
                        }, 3000);
                    }
                    if (questionnarieTypeId == 139) {
                        ListGrid_student_RE.invalidateCache();
                    } else if (questionnarieTypeId == 141) {
                        classRecord_RE.trainingEvalStatus = 1;

                        ToolStrip_SendForms_RE.getField("sendButtonTraining").showIcon("ok");
                        //  ToolStrip_SendForms_RE.getField("sendToEls_supervisor").setDisabled(false);
                        // ToolStrip_SendForms_RE.getField("showResultsEls_supervisor").setDisabled(false);

                        ToolStrip_SendForms_RE.redraw();
                    } else if (questionnarieTypeId == 140) {
                        classRecord_RE.teacherEvalStatus = 1;

                        ToolStrip_SendForms_RE.getField("sendButtonTeacher").showIcon("ok");
                        ToolStrip_SendForms_RE.getField("sendToEls_teacher").setDisabled(false);
                        ToolStrip_SendForms_RE.getField("showResultsEls_teacher").setDisabled(false);

                        ToolStrip_SendForms_RE.redraw();
                    }
                } else {
                    createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                }
                evalWait_RE.close();
            }
        ));

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
            DynamicForm_ReturnDate_RE.addFieldErrors("evaluationReturnDate", "<spring:message
        code='return.date.before.class.start.date'/>", true);
        } else {
            DynamicForm_ReturnDate_RE.clearFieldErrors("evaluationReturnDate", true);
        }
    }

    function sendMessage_evaluation() {

        let data = {
            type: ['sms'],
            //classStudent:MSG_msgContent.users,
            message: MSG_msgContent.text,
            maxRepeat: MSG_repeatOptions.getItem('maxRepeat').getValue(),
            timeBMessages: MSG_repeatOptions.getItem('timeBMessages').getValue(),
            link: linkFormMLanding.getItem('link').getValue(),
        }
        if (MSG_userType == "classStudent") {
            data.classStudent = MSG_msgContent.users;
            data.classID = MSG_classID;
        } else if (MSG_userType == "classTeacher") {
            data.classTeacher = MSG_msgContent.users;
            data.classID = MSG_classID;
        }  else if (MSG_userType == "behavioral") {
            data.classStudentHaventEvaluation = MSG_msgContent.users;
            data.classID = MSG_classID;
        }

        let wait = createDialog("wait");

        isc.RPCManager.sendRequest(TrDSRequest(sendMessageUrl +
            "/sendSMS",
            "POST",
            JSON.stringify(data),
            function (resp) {
                wait.close();
                if (generalGetResp(resp)) {
                    if (resp.httpResponseCode == 200) {
                        var ERROR = isc.Dialog.create({
                            message: "پیام با موفقیت ارسال شد",
                            icon: "[SKIN]say.png",
                            title: "متن پیام"
                        });

                        setTimeout(function () {
                            ERROR.close();
                        }, 1000);

                        MSG_initMSG()
                        MSG_Window_MSG_Main.clear()
                        MSG_Window_MSG_Main.close();

                    } else {
                        createDialog("warning", "<spring:message code="exception.server.connection"/>", "<spring:message code="error"/>");
                    }
                }
            })
        );
    }

    function showEvalAnswerHistory(evaluationId) {

        let RestDataSource_Eval_Answer_History = isc.TrDS.create({
            fields: [
                {name: "evaluationId"},
                {name: "evaluationQuestionId"},
                {name: "questionSourceId"},
                {name: "answerId"},
                {name: "question"},
                {name: "answerTitle"},
                {name: "createdBy"},
                {name: "modifiedBy"},
                {name: "modifiedDate"}
            ],
            fetchDataURL: evalAnswerAuditUrl + evaluationId
        });
        let ListGrid_Eval_Answer_History = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_Eval_Answer_History,
            selectionType: "single",
            autoFetchData: true,
            initialSort: [
                {property: "modifiedDate", direction: "descending"}
            ],
            fields: [
                {
                    name: "question",
                    title: "سوال",
                    align: "center",
                    width: "10%",
                    canFilter: false
                },
                {
                    name: "answerTitle",
                    title: "پاسخ",
                    align: "center",
                    width: "10%",
                    canFilter: false
                },
                // {
                //     name: "createdBy",
                //     title: "ایجاد کننده",
                //     align: "center",
                //     width: "10%",
                //     canFilter: false
                //     // filterOperator: "iContains"
                // },
                {
                    name: "modifiedBy",
                    title: "ویرایش کننده",
                    align: "center",
                    width: "10%",
                    canFilter: false,
                    formatCellValue: function (value) {
                        if (value === "anonymousUser")
                            return "آموزش آنلاین";
                        else
                            return value;
                    }
                    // filterOperator: "iContains"
                },
                {
                    name: "modifiedDate",
                    title: "تاریخ ویرایش",
                    align: "center",
                    width: "10%",
                    canFilter: false
                }
            ]
        });
        let Window_Eval_Answer_History = isc.Window.create({
            title: "تاریخچه ثبت ارزیابی",
            autoSize: false,
            width: "60%",
            height: "60%",
            canDragReposition: true,
            canDragResize: true,
            autoDraw: false,
            autoCenter: true,
            isModal: false,
            items: [
                ListGrid_Eval_Answer_History
            ]
        });
        Window_Eval_Answer_History.show();
    }

// </script>
