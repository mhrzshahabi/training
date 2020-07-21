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

        var localQuestions_RE;

        var evaluation_numberOfStudents_RE = null;

        var classRecord_RE;

        var studentRecord_RE;

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
                <sec:authorize access="hasAuthority('Evaluation_PrintPreTest')">
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
                </sec:authorize>
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
                                if (record.evaluationStatusReaction == "0")
                                    createDialog("info", "فرمی صادر نشده است");
                                else
                                    register_evaluation_result_reaction_student(record);
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
                <sec:authorize access="hasAuthority('Evaluation_PrintPreTest')">
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
                                        setReactionStatus(1,10);
                                        print_Teacher_FormIssuance();
                                        ToolStrip_SendForms_RE.getField("sendButtonTeacher").enableIcon("ok");
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
                                        isc.RPCManager.sendRequest(TrDSRequest(classUrl + "getTeacherReactionStatus/" + classRecord_RE.id , "GET", null, function (resp) {
                                            if(resp.httpResponseText == "1")
                                                register_evaluation_result_reaction(0);
                                            else
                                                createDialog('info', "برای مدرس فرمی صادر نشده است.");
                                        }));
                                    },
                                    icons:[
                                        {
                                            name: "clear",
                                            src: "[SKIN]actions/remove.png",
                                            width: 15,
                                            height: 15,
                                            inline: true,
                                            prompt: "حذف فرم",
                                            click : function (form, item, icon) {
                                                alert('حذف فرم');
                                            }
                                        },
                                        {
                                            name: "edit",
                                            src: "[SKIN]actions/edit.png",
                                            width: 15,
                                            height: 15,
                                            inline: true,
                                            prompt: "ویرایش فرم",
                                            click : function (form, item, icon) {
                                                alert('ویرایش فرم');
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
                                                alert('چاپ فرم');
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
                                        setReactionStatus(10,1);
                                        print_Training_FormIssuance();
                                        ToolStrip_SendForms_RE.getField("sendButtonTraining").enableIcon("ok");
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
                                                alert('تائید صدور');
                                            }
                                        }
                                    ]
                                },
                                {name: "registerButtonTraining",title: "ثبت نتایج ارزیابی آموزش از مدرس", type:"button",startRow: false,endRow: false,baseStyle: "registerFile",
                                    click:function () {
                                        isc.RPCManager.sendRequest(TrDSRequest(classUrl + "getTrainingReactionStatus/" + classRecord_RE.id , "GET", null, function (resp) {
                                            if(resp.httpResponseText == "1")
                                                register_evaluation_result_reaction(1);
                                            else
                                                createDialog('info', "برای مسئول آموزش فرمی صادر نشده است.");
                                        }));
                                    },
                                    icons:[
                                        {
                                            name: "clear",
                                            src: "[SKIN]actions/remove.png",
                                            width: 15,
                                            height: 15,
                                            inline: true,
                                            prompt: "حذف فرم",
                                            click : function (form, item, icon) {
                                                alert('حذف فرم');
                                            }
                                        },
                                        {
                                            name: "edit",
                                            src: "[SKIN]actions/edit.png",
                                            width: 15,
                                            height: 15,
                                            inline: true,
                                            prompt: "ویرایش فرم",
                                            click : function (form, item, icon) {
                                                alert('ویرایش فرم');
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
                                                alert('چاپ فرم');
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
                </sec:authorize>
            ]
        });

        ToolStrip_SendForms_RE.getField("sendButtonTeacher").disableIcon("ok");

        ToolStrip_SendForms_RE.getField("sendButtonTraining").disableIcon("ok");

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
                    ID: "fileGroup",
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
                    ],
                    autoDraw: false
                })]
        });

        var VLayout_Body_RE = isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [HLayout_returnData_RE, HLayout_Actions_RE, Hlayout_Grid_RE]
        });

    //----------------------------------------- Functions --------------------------------------------------------------
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

        function print_Teacher_FormIssuance() {
        if (ListGrid_student_RE.getTotalRows() > 0) {
            let selectedClass = classRecord_RE;
            let selectedTab = Detail_Tab_Evaluation.getSelectedTab();
            let returnDate = ReturnDate_RE._value !== undefined ? ReturnDate_RE._value.replaceAll("/", "-") : "noDate";

            let myObj = {
                classId: selectedClass.id,
                evaluationType: selectedTab.id,
                evaluationReturnDate: returnDate
            };

            let criteriaForm_operational = isc.DynamicForm.create({
                method: "POST",
                action: "<spring:url value="/evaluation/printTeacherReactionForm/"/>" + "pdf" + "/" + selectedClass.id,
                target: "_Blank",
                canSubmit: true,
                fields:
                    [
                        {name: "CriteriaStr", type: "hidden"},
                        {name: "myToken", type: "hidden"},
                        {name: "printData", type: "hidden"}
                    ],
                show: function () {
                    this.Super("show", arguments);
                }
            });

            criteriaForm_operational.setValue("myToken", "<%=accessToken%>");
            criteriaForm_operational.setValue("printData", JSON.stringify(myObj));
            criteriaForm_operational.show();
            criteriaForm_operational.submit();

        } else {
            isc.Dialog.create({
                message: "<spring:message code="no.student.class"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="global.message"/>",
                buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        }
    }

        function print_Training_FormIssuance() {

        if (ListGrid_student_RE.getTotalRows() > 0) {
            let selectedClass = classRecord_RE;
            let selectedTab = Detail_Tab_Evaluation.getSelectedTab();
            let returnDate = ReturnDate_RE._value !== undefined ? ReturnDate_RE._value.replaceAll("/", "-") : "noDate";

            let myObj = {
                classId: selectedClass.id,
                evaluationType: selectedTab.id,
                evaluationReturnDate: returnDate,
                training: "<%= SecurityUtil.getFullName()%>"
            };

            let criteriaForm_operational = isc.DynamicForm.create({
                method: "POST",
                action: "<spring:url value="/evaluation/printTrainingReactionForm/"/>" + "pdf" + "/" + selectedClass.id,
                target: "_Blank",
                canSubmit: true,
                fields:
                    [
                        {name: "CriteriaStr", type: "hidden"},
                        {name: "myToken", type: "hidden"},
                        {name: "printData", type: "hidden"}
                    ],
                show: function () {
                    this.Super("show", arguments);
                }
            });

            criteriaForm_operational.setValue("myToken", "<%=accessToken%>");
            criteriaForm_operational.setValue("printData", JSON.stringify(myObj));
            criteriaForm_operational.show();
            criteriaForm_operational.submit();

        } else {
            isc.Dialog.create({
                message: "<spring:message code="no.student.class"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="global.message"/>",
                buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        }
    }

        function register_evaluation_result_reaction_student(StdRecord){
            let LGRecord = classRecord_RE;
            let studentIdJspEvaluation;
            let teacherIdJspEvaluation = LGRecord.teacherId;
            let evaluationLevelId;
            let saveMethod;
            let saveUrl = evaluationUrl;
            let valueMapAnswer = {209: "خیلی ضعیف", 208: "ضعیف", 207: "متوسط", 206: "خوب", 205: "عالی"};
            let RestData_EvaluationType_JspEvaluation = isc.TrDS.create({
                fields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {
                        name: "title",
                        title: "<spring:message code="title"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "code",
                        title: "<spring:message code="code"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "type",
                        title: "<spring:message code="type"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "value",
                        title: "<spring:message code="value"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "description",
                        title: "<spring:message code="description"/>",
                        filterOperator: "iContains"
                    }
                ],
                fetchDataURL: parameterValueUrl + "/iscList/143"
            });
            let RestData_EvaluationLevel_JspEvaluation = isc.TrDS.create({
                fields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {
                        name: "title",
                        title: "<spring:message code="title"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "code",
                        title: "<spring:message code="code"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "type",
                        title: "<spring:message code="type"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "value",
                        title: "<spring:message code="value"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "description",
                        title: "<spring:message code="description"/>",
                        filterOperator: "iContains"
                    }
                ],
                fetchDataURL: parameterValueUrl + "/iscList/163"
            });
            let RestData_Students_JspEvaluation = isc.TrDS.create({
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
                        autoFitWidth: true
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
                        filterOperator: "iContains"
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
                        name: "student.ccpAssistant",
                        title: "<spring:message code="reward.cost.center.assistant"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "student.ccpAffairs",
                        title: "<spring:message code="reward.cost.center.affairs"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "student.ccpSection",
                        title: "<spring:message code="reward.cost.center.section"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "student.ccpUnit",
                        title: "<spring:message code="reward.cost.center.unit"/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "evaluationAudienceId"
                    }
                ],
                fetchDataURL: tclassStudentUrl + "/students-iscList/"
            });
            let vm_JspEvaluation = isc.ValuesManager.create({});
            let DynamicForm_Questions_Title_JspEvaluation = isc.DynamicForm.create({
                ID: "DynamicForm_Questions_Title_JspEvaluation",
                validateOnChange: true,
                numCols: 6,
                valuesManager: vm_JspEvaluation,
                width: "100%",
                borderRadius: "10px 10px 0px 0px",
                border: "2px solid black",
                titleAlign: "left",
                margin: 10,
                padding: 10,
                fields: [
                    {name: "code", title: "<spring:message code="class.code"/>:", canEdit: false},
                    {
                        name: "titleClass",
                        title: "<spring:message code='class.title'/>:",
                        canEdit: false
                    },
                    {
                        name: "startDate",
                        title: "<spring:message code='start.date'/>:",
                        canEdit: false
                    },
                    {name: "teacher", title: "<spring:message code='teacher'/>:", canEdit: false},
                    {
                        name: "institute.titleFa",
                        title: "<spring:message code='institute'/>:",
                        canEdit: false
                    },
                    {name: "user", title: "<spring:message code='user'/>:", canEdit: false},
                    {
                        name: "evaluationLevel",
                        title: "<spring:message code="evaluation.level"/>",
                        type: "SelectItem",
                        pickListProperties: {showFilterEditor: false},
                        optionDataSource: RestData_EvaluationLevel_JspEvaluation,
                        valueField: "code",
                        displayField: "title",
                        disabled: true,
                        required: true,
                        changed: function (form, item, value) {
                        }
                    },
                    {
                        name: "evaluationType",
                        title: "<spring:message code="evaluation.type"/>",
                        type: "SelectItem",
                        optionDataSource: RestData_EvaluationType_JspEvaluation,
                        pickListProperties: {showFilterEditor: false},
                        valueField: "code",
                        required: true,
                        disabled: true,
                        displayField: "title",
                        endRow: true,
                        changed: function (form, item, value) {
                            DynamicForm_Questions_Body_JspEvaluation.clearValues();
                            DynamicForm_Description_JspEvaluation.clearValues();
                            form.clearErrors(true);
                            let criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":""}';
                            DynamicForm_Questions_Body_JspEvaluation.setFields([]);
                            form.getItem("evaluationLevel").disable();
                            let criteriaEdit =
                                '{"fieldName":"classId","operator":"equals","value":' + LGRecord.id + '},';
                            switch (value) {
                                case "SEFT":
                                    DynamicForm_Description_JspEvaluation.show();
                                    criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":"SEFT"}';
                                    criteriaEdit +=
                                        '{"fieldName":"questionnaireTypeId","operator":"equals","value":141},' +
                                        '{"fieldName":"evaluatorId","operator":"equals","value":<%= SecurityUtil.getUserId()%>},' +
                                        '{"fieldName":"evaluatorTypeId","operator":"equals","value":189},' +
                                        '{"fieldName":"evaluatedId","operator":"equals","value":' + teacherIdJspEvaluation + '},' +
                                        '{"fieldName":"evaluatedTypeId","operator":"equals","value":187}';
                                    form.setValue("evaluator", form.getValue("user"));
                                    form.setValue("evaluated", form.getValue("teacher"));
                                    form.getItem("evaluationLevel").setRequired(false);
                                    break;
                                case "SEFC":

                                    return;
                                case "TEFC":
                                    DynamicForm_Description_JspEvaluation.show();
                                    criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":"TEFC"}';
                                    criteriaEdit +=
                                        '{"fieldName":"questionnaireTypeId","operator":"equals","value":140},' +
                                        '{"fieldName":"evaluatorId","operator":"equals","value":' + teacherIdJspEvaluation + '},' +
                                        '{"fieldName":"evaluatorTypeId","operator":"equals","value":187}';
                                    form.setValue("evaluator", form.getValue("teacher"));
                                    form.setValue("evaluated", form.getValue("titleClass"));
                                    form.getItem("evaluationLevel").setRequired(false);
                                    break;
                                case "OEFS":
                                    criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":"OEFS"}';
                                    criteriaEdit +=
                                        '{"fieldName":"questionnaireTypeId","operator":"equals","value":230},' +
                                        '{"fieldName":"evaluatorId","operator":"equals","value":' + studentIdJspEvaluation + '},' +
                                        '{"fieldName":"evaluatorTypeId","operator":"equals","value":188}';
                                    form.getItem("evaluationLevel").setValue("Behavioral");
                                    criteriaEdit += '{"fieldName":"evaluationLevelId","operator":"equals","value":156}';
                                    evaluationLevelId = 156;
                                    requestEvaluationQuestions_RS(criteria, criteriaEdit, 1);
                                    break;
                            }
                            requestEvaluationQuestions_RS(criteria, criteriaEdit);
                        }
                    },
                    {
                        name: "evaluator",
                        title: "<spring:message code="evaluator"/>",
                        required: true,
                        disabled: true
                    },
                    {
                        name: "evaluated",
                        title: "<spring:message code="evaluation.evaluated"/>",
                        required: true,
                        disabled: true
                    }
                ]
            });
            let DynamicForm_Questions_Body_JspEvaluation = isc.DynamicForm.create({
                ID: "DynamicForm_Questions_Body_JspEvaluation",
                validateOnExit: true,
                valuesManager: vm_JspEvaluation,
                colWidths: ["45%", "50%"],
                cellBorder: 1,
                width: "100%",
                padding: 10,
                fields: []
            });
            let DynamicForm_Description_JspEvaluation = isc.DynamicForm.create({
                ID: "DynamicForm_Description_JspEvaluation",
                validateOnExit: true,
                valuesManager: vm_JspEvaluation,
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
                    if (!DynamicForm_Questions_Title_JspEvaluation.validate()) {
                        return;
                    }
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
                        evaluationAnswer.evaluationQuestionId = questions[i].name.substring(1);
                        evaluationAnswer.questionSourceId = questionSourceConvert(questions[i].name);
                        evaluationAnswerList.push(evaluationAnswer);
                    }
                    data.evaluationAnswerList = evaluationAnswerList;
                    data.evaluationFull = evaluationFull;
                    data.description = DynamicForm_Description_JspEvaluation.getField("description").getValue();
                    switch (DynamicForm_Questions_Title_JspEvaluation.getValue("evaluationType")) {
                        case "SEFT":
                            data.evaluatorId = "<%= SecurityUtil.getUserId()%>";
                            data.evaluatedId = LGRecord.teacherId;
                            data.evaluatorTypeId = 189;
                            data.evaluatedTypeId = 187;
                            data.questionnaireTypeId = 141;
                            break;
                        case "TEFC":
                            data.evaluatorId = LGRecord.teacherId;
                            data.evaluatedId = null;
                            data.evaluatorTypeId = 187;
                            data.evaluatedTypeId = null;
                            data.questionnaireTypeId = 140;
                            break;
                        case "SEFC":
                            data.evaluatorId = studentIdJspEvaluation;
                            data.evaluatedId = null;
                            data.evaluatorTypeId = 188;
                            data.evaluatedTypeId = null;
                            data.evaluationLevelId = evaluationLevelId;
                            data.questionnaireTypeId = 139;
                            break;
                        case "OEFS":
                            data.questionnaireTypeId = 230;
                            data.evaluatorId = eeid;
                            data.evaluatedId = studentIdJspEvaluation;
                            data.evaluationLevelId = evaluationLevelId;
                            break;
                    }
                    data.classId = LGRecord.id;
                    isc.RPCManager.sendRequest(TrDSRequest(saveUrl, saveMethod, JSON.stringify(data), function (resp) {
                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                            Window_Questions_JspEvaluation.close();
                            ListGrid_student_RE.invalidateCache();
                            isc.RPCManager.sendRequest(TrDSRequest(evaluationAnalysisUrl + "/updateEvaluationAnalysis" + "/" +
                                LGRecord.id,
                                "GET", null, null));
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
            let eeid;
            DynamicForm_Questions_Title_JspEvaluation.clearValues();
            DynamicForm_Description_JspEvaluation.clearValues();
            DynamicForm_Description_JspEvaluation.hide();
            DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationType").clearValue();
            DynamicForm_Questions_Title_JspEvaluation.getItem("evaluator").clearValue();
            DynamicForm_Questions_Title_JspEvaluation.getItem("evaluated").clearValue();
            DynamicForm_Description_JspEvaluation.clearValues();
            DynamicForm_Description_JspEvaluation.show();
            RestData_Students_JspEvaluation.fetchDataURL = tclassStudentUrl + "/students-iscList/" + LGRecord.id;
            evaluationLevelId = 154;
            DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationType").disable();
            DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationLevel").disable();
            studentIdJspEvaluation = StdRecord.id;
            let criteriaEdit = '';

            let criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":"SEFC"}';
            criteriaEdit += '{"fieldName":"evaluationLevelId","operator":"equals","value":154},'+
                '{"fieldName":"evaluatorId","operator":"equals","value":' + studentIdJspEvaluation + '}' ;

            evalWait_RE = createDialog("wait");
            requestEvaluationQuestions_RS(criteria, criteriaEdit, 1);
            Window_Questions_JspEvaluation.show();

            DynamicForm_Questions_Title_JspEvaluation.getItem("code").setValue(LGRecord.code);
            DynamicForm_Questions_Title_JspEvaluation.getItem("titleClass").setValue(LGRecord.titleClass);
            DynamicForm_Questions_Title_JspEvaluation.getItem("institute.titleFa").setValue(LGRecord.institute.titleFa);
            DynamicForm_Questions_Title_JspEvaluation.getItem("teacher").setValue(LGRecord.teacher);
            DynamicForm_Questions_Title_JspEvaluation.getItem("startDate").setValue(LGRecord.startDate);

            DynamicForm_Questions_Title_JspEvaluation.setValue("evaluated", DynamicForm_Questions_Title_JspEvaluation.getValue("titleClass"));
            DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationType").setValue("SEFC");
            DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationLevel").setValue("Reactive");
            DynamicForm_Questions_Title_JspEvaluation.setValue("evaluator", StdRecord.student.firstName + " " + StdRecord.student.lastName);
            DynamicForm_Questions_Title_JspEvaluation.setValue("user", "<%= SecurityUtil.getFullName()%>");

            function requestEvaluationQuestions_RS(criteria, criteriaEdit, type = 0) {
                isc.RPCManager.sendRequest(TrDSRequest(questionnaireUrl + "/iscList?operator=or&_constructor=AdvancedCriteria&criteria=" + criteria, "GET", null, function (resp) {
                    if (JSON.parse(resp.data).response.data.length > 0) {
                        let criteria = '{"fieldName":"questionnaireId","operator":"equals","value":' + JSON.parse(resp.data).response.data[0].id + '}';
                        isc.RPCManager.sendRequest(TrDSRequest(questionnaireQuestionUrl + "/iscList?operator=or&_constructor=AdvancedCriteria&criteria=" + criteria, "GET", null, function (resp) {
                            localQuestions_RE = JSON.parse(resp.data).response.data;
                            for (let i = 0; i < localQuestions_RE.length; i++) {
                                let item = {};
                                switch (localQuestions_RE[i].evaluationQuestion.domain.code) {
                                    case "EQP":
                                        item.name = "Q" + localQuestions_RE[i].id;
                                        item.title = "امکانات: " + localQuestions_RE[i].evaluationQuestion.question;
                                        break;
                                    case "CLASS":
                                        item.name = "Q" + localQuestions_RE[i].id;
                                        item.title = "کلاس: " + localQuestions_RE[i].evaluationQuestion.question;
                                        break;
                                    case "SAT":
                                        item.name = "Q" + localQuestions_RE[i].id;
                                        item.title = "مدرس: " + localQuestions_RE[i].evaluationQuestion.question;
                                        break;
                                    case "TRAINING":
                                        item.name = "Q" + localQuestions_RE[i].id;
                                        item.title = "مدرس: " + localQuestions_RE[i].evaluationQuestion.question;
                                        break;
                                    case "Content":
                                        item.name = "Q" + localQuestions_RE[i].id;
                                        item.title = "محتواي کلاس: " + localQuestions_RE[i].evaluationQuestion.question;
                                        break;
                                    default:
                                        item.name = "Q" + localQuestions_RE[i].id;
                                        item.title = localQuestions_RE[i].evaluationQuestion.question;
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
                                itemList.add(item);
                            }
                            ;
                            if (type !== 0) {
                                isc.RPCManager.sendRequest(TrDSRequest(courseUrl + "goal-mainObjective/" + LGRecord.course.id, "GET", null, function (resp) {
                                    localQuestions_RE = JSON.parse(resp.data);
                                    for (let i = 0; i < localQuestions_RE.length; i++) {
                                        let item = {};
                                        switch (localQuestions_RE[i].type) {
                                            case "goal":
                                                item.name = "G" + localQuestions_RE[i].id;
                                                item.title = "هدف: " + localQuestions_RE[i].title;
                                                break;
                                            case "skill":
                                                item.name = "M" + localQuestions_RE[i].id;
                                                item.title = "هدف اصلي: " + localQuestions_RE[i].title;
                                                break;
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
                                        itemList.add(item);
                                    }
                                    DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                                    requestEvaluationQuestionsEdit_RS(criteriaEdit);
                                }));
                            } else {
                                DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                                requestEvaluationQuestionsEdit_RS(criteriaEdit);
                            }
                        }));
                    } else {
                        if (type !== 0) {
                            isc.RPCManager.sendRequest(TrDSRequest(courseUrl + "goal-mainObjective/" + LGRecord.course.id, "GET", null, function (resp) {
                                localQuestions_RE = JSON.parse(resp.data);
                                for (let i = 0; i < localQuestions_RE.length; i++) {
                                    let item = {};
                                    switch (localQuestions_RE[i].type) {
                                        case "goal":
                                            item.name = "G" + localQuestions_RE[i].id;
                                            item.title = "هدف: " + (i + 1).toString() + "- " + localQuestions_RE[i].title;
                                            break;
                                        case "skill":
                                            item.name = "M" + localQuestions_RE[i].id;
                                            item.title = "هدف اصلي: " + (i + 1).toString() + "- " + localQuestions_RE[i].title;
                                            break;
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
                                    itemList.add(item);
                                }
                                DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                                requestEvaluationQuestionsEdit_RS(criteriaEdit);
                            }));
                        } else {
                            DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                            requestEvaluationQuestionsEdit_RS(criteriaEdit);
                        }
                    }
                    evalWait_RE.close();
                }));
            }
            function requestEvaluationQuestionsEdit_RS(criteria) {
                isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/spec-list?operator=and&_constructor=AdvancedCriteria&criteria=" + criteria, "GET", null, function (resp) {
                    if (resp.httpResponseCode == 201 || resp.httpResponseCode == 200) {
                        let data = JSON.parse(resp.data).response.data;
                        let record = {};
                        if (!data.isEmpty()) {
                            let answer = data[0].evaluationAnswerList;
                            let description = data[0].description;
                            for (let i = 0; i < answer.length; i++) {
                                switch (answer[i].questionSourceId) {
                                    case 199:
                                        record["Q" + answer[i].evaluationQuestionId] = answer[i].answerId;
                                        break;
                                    case 200:
                                        record["M" + answer[i].evaluationQuestionId] = answer[i].answerId;
                                        break;
                                    case 201:
                                        record["G" + answer[i].evaluationQuestionId] = answer[i].answerId;
                                        break;
                                }
                            }
                            DynamicForm_Questions_Body_JspEvaluation.setValues(record);
                            DynamicForm_Description_JspEvaluation.getField("description").setValue(description);
                            saveMethod = "PUT";
                            saveUrl = evaluationUrl + "/" + data[0].id;
                            return;
                        }
                        saveMethod = "POST";
                        saveUrl = evaluationUrl;
                    }
                }))
            }
        }

        function register_evaluation_result_reaction(eType){
            let LGRecord = classRecord_RE;
            let teacherIdJspEvaluation = LGRecord.teacherId;
            let evaluationLevelId;
            let saveMethod;
            let saveUrl = evaluationUrl;
            let valueMapAnswer = {209: "خیلی ضعیف", 208: "ضعیف", 207: "متوسط", 206: "خوب", 205: "عالی"};
            let RestData_EvaluationType_JspEvaluation = isc.TrDS.create({
                fields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {
                        name: "title",
                        title: "<spring:message code="title"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "code",
                        title: "<spring:message code="code"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "type",
                        title: "<spring:message code="type"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "value",
                        title: "<spring:message code="value"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "description",
                        title: "<spring:message code="description"/>",
                        filterOperator: "iContains"
                    }
                ],
                fetchDataURL: parameterValueUrl + "/iscList/143"
            });
            let RestData_EvaluationLevel_JspEvaluation = isc.TrDS.create({
                fields: [
                    {name: "id", primaryKey: true, hidden: true},
                    {
                        name: "title",
                        title: "<spring:message code="title"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "code",
                        title: "<spring:message code="code"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "type",
                        title: "<spring:message code="type"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "value",
                        title: "<spring:message code="value"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "description",
                        title: "<spring:message code="description"/>",
                        filterOperator: "iContains"
                    }
                ],
                fetchDataURL: parameterValueUrl + "/iscList/163"
            });
            let DynamicForm_Questions_Title_JspEvaluation = isc.DynamicForm.create({
                ID: "DynamicForm_Questions_Title_JspEvaluation",
                validateOnChange: true,
                numCols: 6,
                width: "100%",
                borderRadius: "10px 10px 0px 0px",
                border: "2px solid black",
                titleAlign: "left",
                margin: 10,
                padding: 10,
                fields: [
                    {name: "code", title: "<spring:message code="class.code"/>:", canEdit: false},
                    {
                        name: "titleClass",
                        title: "<spring:message code='class.title'/>:",
                        canEdit: false
                    },
                    {
                        name: "startDate",
                        title: "<spring:message code='start.date'/>:",
                        canEdit: false
                    },
                    {name: "teacher", title: "<spring:message code='teacher'/>:", canEdit: false},
                    {
                        name: "institute.titleFa",
                        title: "<spring:message code='institute'/>:",
                        canEdit: false
                    },
                    {name: "user", title: "<spring:message code='user'/>:", canEdit: false},
                    {
                        name: "evaluationLevel",
                        title: "<spring:message code="evaluation.level"/>",
                        type: "SelectItem",
                        pickListProperties: {showFilterEditor: false},
                        optionDataSource: RestData_EvaluationLevel_JspEvaluation,
                        valueField: "code",
                        displayField: "title",
                        disabled:true
                    },
                    {
                        name: "evaluationType",
                        title: "<spring:message code="evaluation.type"/>",
                        type: "SelectItem",
                        optionDataSource: RestData_EvaluationType_JspEvaluation,
                        pickListProperties: {showFilterEditor: false},
                        valueField: "code",
                        required: true,
                        disabled: true,
                        displayField: "title",
                        endRow: true
                    },
                    {
                        name: "evaluator",
                        title: "<spring:message code="evaluator"/>",
                        required: true,
                        disabled: true
                    },
                    {
                        name: "evaluated",
                        title: "<spring:message code="evaluation.evaluated"/>",
                        required: true,
                        disabled: true
                    }
                ]
            });
            let DynamicForm_Questions_Body_JspEvaluation = isc.DynamicForm.create({
                ID: "DynamicForm_Questions_Body_JspEvaluation",
                validateOnExit: true,
                colWidths: ["45%", "50%"],
                cellBorder: 1,
                width: "100%",
                padding: 10,
                fields: []
            });
            let DynamicForm_Description_JspEvaluation = isc.DynamicForm.create({
                ID: "DynamicForm_Description_JspEvaluation",
                validateOnExit: true,
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
                    if (!DynamicForm_Questions_Title_JspEvaluation.validate()) {
                        return;
                    }
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
                        evaluationAnswer.evaluationQuestionId = questions[i].name.substring(1);
                        evaluationAnswer.questionSourceId = questionSourceConvert(questions[i].name);
                        evaluationAnswerList.push(evaluationAnswer);
                    }
                    data.evaluationAnswerList = evaluationAnswerList;
                    data.evaluationFull = evaluationFull;
                    data.description = DynamicForm_Description_JspEvaluation.getField("description").getValue();
                    switch (DynamicForm_Questions_Title_JspEvaluation.getValue("evaluationType")) {
                        case "SEFT":
                            data.evaluatorId = "<%= SecurityUtil.getUserId()%>";
                            data.evaluatedId = LGRecord.teacherId;
                            data.evaluatorTypeId = 189;
                            data.evaluatedTypeId = 187;
                            data.questionnaireTypeId = 141;
                            break;
                        case "TEFC":
                            data.evaluatorId = LGRecord.teacherId;
                            data.evaluatedId = null;
                            data.evaluatorTypeId = 187;
                            data.evaluatedTypeId = null;
                            data.questionnaireTypeId = 140;
                            break;
                        case "SEFC":
                            data.evaluatorId = studentIdJspEvaluation;
                            data.evaluatedId = null;
                            data.evaluatorTypeId = 188;
                            data.evaluatedTypeId = null;
                            data.evaluationLevelId = evaluationLevelId;
                            data.questionnaireTypeId = 139;
                            break;
                    }
                    data.classId = LGRecord.id;
                    isc.RPCManager.sendRequest(TrDSRequest(saveUrl, saveMethod, JSON.stringify(data), function (resp) {
                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                            Window_Questions_JspEvaluation.close();
                            ListGrid_student_RE.invalidateCache();
                            isc.RPCManager.sendRequest(TrDSRequest(evaluationAnalysisUrl + "/updateEvaluationAnalysis" + "/" +
                                LGRecord.id,
                                "GET", null, null));
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
            DynamicForm_Questions_Title_JspEvaluation.clearValues();
            DynamicForm_Description_JspEvaluation.clearValues();
            DynamicForm_Questions_Body_JspEvaluation.clearValues();
            DynamicForm_Questions_Body_JspEvaluation.setFields([]);
            let criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":""}';
            let criteriaEdit =
                '{"fieldName":"classId","operator":"equals","value":' + LGRecord.id + '},';

            switch (eType) {
                case 1:
                    criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":"SEFT"}';
                    criteriaEdit +=
                        '{"fieldName":"questionnaireTypeId","operator":"equals","value":141},' +
                        '{"fieldName":"evaluatorId","operator":"equals","value":<%= SecurityUtil.getUserId()%>},' +
                        '{"fieldName":"evaluatorTypeId","operator":"equals","value":189},' +
                        '{"fieldName":"evaluatedId","operator":"equals","value":' + teacherIdJspEvaluation + '},' +
                        '{"fieldName":"evaluatedTypeId","operator":"equals","value":187}';
                    DynamicForm_Questions_Title_JspEvaluation.setValue("evaluator", "<%= SecurityUtil.getFullName()%>");
                    DynamicForm_Questions_Title_JspEvaluation.setValue("evaluated", LGRecord.teacher);
                    DynamicForm_Questions_Title_JspEvaluation.setValue("evaluationLevel", "Reactive");
                    DynamicForm_Questions_Title_JspEvaluation.setValue("evaluationType", "SEFT");
                    break;
                case 0:
                    DynamicForm_Description_JspEvaluation.show();
                    criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":"TEFC"}';
                    criteriaEdit +=
                        '{"fieldName":"questionnaireTypeId","operator":"equals","value":140},' +
                        '{"fieldName":"evaluatorId","operator":"equals","value":' + teacherIdJspEvaluation + '},' +
                        '{"fieldName":"evaluatorTypeId","operator":"equals","value":187}';
                    DynamicForm_Questions_Title_JspEvaluation.setValue("evaluator", LGRecord.teacher);
                    DynamicForm_Questions_Title_JspEvaluation.setValue("evaluated", LGRecord.titleClass);
                    DynamicForm_Questions_Title_JspEvaluation.setValue("evaluationLevel", "Reactive");
                    DynamicForm_Questions_Title_JspEvaluation.setValue("evaluationType", "TEFC");
                    break;
            }
            requestEvaluationQuestions_RT(criteria, criteriaEdit);

            let itemList = [];
            let eeid;

            evalWait_RE = createDialog("wait");
            Window_Questions_JspEvaluation.show();
            DynamicForm_Questions_Title_JspEvaluation.getItem("code").setValue(LGRecord.code);
            DynamicForm_Questions_Title_JspEvaluation.getItem("titleClass").setValue(LGRecord.titleClass);
            DynamicForm_Questions_Title_JspEvaluation.getItem("institute.titleFa").setValue(LGRecord.institute.titleFa);
            DynamicForm_Questions_Title_JspEvaluation.getItem("teacher").setValue(LGRecord.teacher);
            DynamicForm_Questions_Title_JspEvaluation.getItem("startDate").setValue(LGRecord.startDate);
            DynamicForm_Questions_Title_JspEvaluation.setValue("user", "<%= SecurityUtil.getFullName()%>");

            function requestEvaluationQuestions_RT(criteria, criteriaEdit, type = 0) {
                isc.RPCManager.sendRequest(TrDSRequest(questionnaireUrl + "/iscList?operator=or&_constructor=AdvancedCriteria&criteria=" + criteria, "GET", null, function (resp) {
                    if (JSON.parse(resp.data).response.data.length > 0) {
                        let criteria = '{"fieldName":"questionnaireId","operator":"equals","value":' + JSON.parse(resp.data).response.data[0].id + '}';
                        isc.RPCManager.sendRequest(TrDSRequest(questionnaireQuestionUrl + "/iscList?operator=or&_constructor=AdvancedCriteria&criteria=" + criteria, "GET", null, function (resp) {
                            localQuestions_RE = JSON.parse(resp.data).response.data;
                            for (let i = 0; i < localQuestions_RE.length; i++) {
                                let item = {};
                                switch (localQuestions_RE[i].evaluationQuestion.domain.code) {
                                    case "EQP":
                                        item.name = "Q" + localQuestions_RE[i].id;
                                        item.title = "امکانات: " + localQuestions_RE[i].evaluationQuestion.question;
                                        break;
                                    case "CLASS":
                                        item.name = "Q" + localQuestions_RE[i].id;
                                        item.title = "کلاس: " + localQuestions_RE[i].evaluationQuestion.question;
                                        break;
                                    case "SAT":
                                        item.name = "Q" + localQuestions_RE[i].id;
                                        item.title = "مدرس: " + localQuestions_RE[i].evaluationQuestion.question;
                                        break;
                                    case "TRAINING":
                                        item.name = "Q" + localQuestions_RE[i].id;
                                        item.title = "مدرس: " + localQuestions_RE[i].evaluationQuestion.question;
                                        break;
                                    case "Content":
                                        item.name = "Q" + localQuestions_RE[i].id;
                                        item.title = "محتواي کلاس: " + localQuestions_RE[i].evaluationQuestion.question;
                                        break;
                                    default:
                                        item.name = "Q" + localQuestions_RE[i].id;
                                        item.title = localQuestions_RE[i].evaluationQuestion.question;
                                }

                                item.type = "radioGroup";
                                item.vertical = false;
                                // item.required = true;
                                item.fillHorizontalSpace = true;
                                item.valueMap = valueMapAnswer;
                                // item.colSpan = ,
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
                                itemList.add(item);
                            }
                            ;
                            if (type !== 0) {
                                isc.RPCManager.sendRequest(TrDSRequest(courseUrl + "goal-mainObjective/" + LGRecord.course.id, "GET", null, function (resp) {
                                    localQuestions_RE = JSON.parse(resp.data);
                                    for (let i = 0; i < localQuestions_RE.length; i++) {
                                        let item = {};
                                        switch (localQuestions_RE[i].type) {
                                            case "goal":
                                                item.name = "G" + localQuestions_RE[i].id;
                                                item.title = "هدف: " + localQuestions_RE[i].title;
                                                break;
                                            case "skill":
                                                item.name = "M" + localQuestions_RE[i].id;
                                                item.title = "هدف اصلي: " + localQuestions_RE[i].title;
                                                break;
                                            // default:
                                            //     return;
                                        }
                                        item.type = "radioGroup";
                                        item.vertical = false;
                                        // item.required = true;
                                        item.fillHorizontalSpace = true;
                                        item.valueMap = valueMapAnswer;
                                        // item.colSpan = ,
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
                                        itemList.add(item);
                                    }
                                    DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                                    requestEvaluationQuestionsEdit_RT(criteriaEdit);
                                }));
                            } else {
                                DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                                requestEvaluationQuestionsEdit_RT(criteriaEdit);
                            }
                        }));
                    } else {
                        if (type !== 0) {
                            isc.RPCManager.sendRequest(TrDSRequest(courseUrl + "goal-mainObjective/" + LGRecord.course.id, "GET", null, function (resp) {
                                localQuestions_RE = JSON.parse(resp.data);
                                for (let i = 0; i < localQuestions_RE.length; i++) {
                                    let item = {};
                                    switch (localQuestions_RE[i].type) {
                                        case "goal":
                                            item.name = "G" + localQuestions_RE[i].id;
                                            item.title = "هدف: " + (i + 1).toString() + "- " + localQuestions_RE[i].title;
                                            break;
                                        case "skill":
                                            item.name = "M" + localQuestions_RE[i].id;
                                            item.title = "هدف اصلي: " + (i + 1).toString() + "- " + localQuestions_RE[i].title;
                                            break;
                                        // default:
                                        //     return;
                                    }
                                    item.type = "radioGroup";
                                    item.vertical = false;
                                    // item.required = true;
                                    item.fillHorizontalSpace = true;
                                    item.valueMap = valueMapAnswer;
                                    // item.colSpan = ,
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
                                    itemList.add(item);
                                }
                                DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                                requestEvaluationQuestionsEdit_RT(criteriaEdit);
                            }));
                        } else {
                            DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                            requestEvaluationQuestionsEdit_RT(criteriaEdit);
                        }
                    }
                    evalWait_RE.close();
                }));

            }
            function requestEvaluationQuestionsEdit_RT(criteria) {
                isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/spec-list?operator=and&_constructor=AdvancedCriteria&criteria=" + criteria, "GET", null, function (resp) {
                    if (resp.httpResponseCode == 201 || resp.httpResponseCode == 200) {
                        let data = JSON.parse(resp.data).response.data;
                        let record = {};
                        if (!data.isEmpty()) {
                            let answer = data[0].evaluationAnswerList;
                            let description = data[0].description;
                            for (let i = 0; i < answer.length; i++) {
                                switch (answer[i].questionSourceId) {
                                    case 199:
                                        record["Q" + answer[i].evaluationQuestionId] = answer[i].answerId;
                                        break;
                                    case 200:
                                        record["M" + answer[i].evaluationQuestionId] = answer[i].answerId;
                                        break;
                                    case 201:
                                        record["G" + answer[i].evaluationQuestionId] = answer[i].answerId;
                                        break;
                                }
                            }
                            DynamicForm_Questions_Body_JspEvaluation.setValues(record);
                            DynamicForm_Description_JspEvaluation.getField("description").setValue(description);
                            saveMethod = "PUT";
                            saveUrl = evaluationUrl + "/" + data[0].id;
                            return;
                        }
                        saveMethod = "POST";
                        saveUrl = evaluationUrl;
                    }
                }))
            }
        }

        function setReactionStatus(teacherReactionStatus,trainingReactionStatus){
        isc.RPCManager.sendRequest(TrDSRequest(classUrl + "setReactionStatus/" + teacherReactionStatus + "/"
            + trainingReactionStatus + "/" + classRecord_RE.id, "GET", null, null));
    }

        function set_print_Status_RE(numberOfStudents,record) {
            evaluation_check_date_RE();
            if (DynamicForm_ReturnDate_RE.hasErrors())
                return;
            print_Student_FormIssuance_RE("pdf", numberOfStudents,record);
        }

        function show_EvaluationActionResult_RE(resp) {
            let respCode = resp.httpResponseCode;
            if (respCode === 200 || respCode === 201) {

                let gridState;
                let selectedStudent = ListGrid_student_RE.getSelectedRecord();
                if (selectedStudent !== null)
                    gridState = "[{id:" + selectedStudent.id + "}]";

                ListGrid_student_RE.invalidateCache();

                if (selectedStudent !== null)
                    setTimeout(function () {

                        ListGrid_student_RE.setSelectedState(gridState);

                        ListGrid_student_RE.scrollToRow(ListGrid_student_RE.getRecordIndex(ListGrid_student_RE.getSelectedRecord()), 0);

                    }, 600);
            }
        }

        function set_evaluation_status_RE(numberOfStudents,record,audienceName, audienceType) {
            let listOfStudent = [];

            getStudentList_RE(setStudentStatus_RE);

            function getStudentList_RE(callback) {

                if (numberOfStudents === "single") {

                    listOfStudent.push(record);
                    callback(listOfStudent);

                } else if (numberOfStudents === "all") {

                    ListGrid_student_RE.selectAllRecords();

                    ListGrid_student_RE.getSelectedRecords().forEach(function (selectedStudent) {
                        listOfStudent.push(selectedStudent);
                    });

                    ListGrid_student_RE.deselectAllRecords();
                    callback(listOfStudent);
                }
            }

            function setStudentStatus_RE(listOfStudent) {

                listOfStudent.forEach(function (selectedStudent) {

                    let selectedTab = Detail_Tab_Evaluation.getSelectedTab();

                    let evaluationData = {};

                    switch (selectedTab.id) {
                        case "TabPane_Reaction": {

                            evaluationData = {
                                "evaluationAudienceType": null,
                                "idClassStudent": selectedStudent.id,
                                "reaction": 1,
                                "learning": selectedStudent.evaluationStatusLearning || 0,
                                "behavior": selectedStudent.evaluationStatusBehavior || 0,
                                "results": selectedStudent.evaluationStatusResults || 0
                            };

                            break;
                        }
                        case "TabPane_Learning": {
                            evaluationData = {
                                "evaluationAudienceType": null,
                                "idClassStudent": selectedStudent.id,
                                "reaction": selectedStudent.evaluationStatusReaction || 0,
                                "learning": 1,
                                "behavior": selectedStudent.evaluationStatusBehavior || 0,
                                "results": selectedStudent.evaluationStatusResults || 0
                            };

                            break;
                        }
                        case "TabPane_Behavior": {

                            evaluationData = {
                                "evaluationAudienceType": audienceType,
                                "evaluationAudienceId": EvaluationListGrid_PeronalLIst.getSelectedRecord().id,
                                "idClassStudent": selectedStudent.id,
                                "reaction": selectedStudent.evaluationStatusReaction || 0,
                                "learning": selectedStudent.evaluationStatusLearning || 0,
                                "behavior": 1,
                                "results": selectedStudent.evaluationStatusResults || 0
                            };

                            break;
                        }
                        case "TabPane_Results": {

                            evaluationData = {
                                "evaluationAudienceType": null,
                                "idClassStudent": selectedStudent.id,
                                "reaction": selectedStudent.evaluationStatusReaction || 0,
                                "learning": selectedStudent.evaluationStatusLearning || 0,
                                "behavior": selectedStudent.evaluationStatusBehavior || 0,
                                "results": 1
                            };

                            break;
                        }
                    }
                    isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/setStudentFormIssuance/", "PUT", JSON.stringify(evaluationData), show_EvaluationActionResult_RE));

                })
            }
    }

    //----------------------------------- new Funsctions ---------------------------------------------------------------
    function print_Student_Reaction_Form_RE(questionnarieId, evaluatorId, evaluatorTypeId, evaluatedId, evaluatedTypeId,
                                            questionnarieTypeId, evaluationLevel) {
    }


    function Student_Reaction_Form_Inssurance_RE(studentRecord){
        let IButtonSave_SelectQuestionnarie_RE = isc.IButtonSave.create({
                title: "صدور و چاپ",
                click: function () {
                    if(ListGrid_SelectQuestionnarie_RE.getSelectedRecord() == null || ListGrid_SelectQuestionnarie_RE.getSelectedRecord() == undefined){
                        createDialog("info", "پرسشنامه ای انتخاب نشده است.");
                    }
                    else{
                        Window_SelectQuestionnarie_RE.close();
                        createOrUpdate_evaluation_form(null,ListGrid_SelectQuestionnarie_RE.getSelectedRecord().id, studentRecord.id, 188, classRecord_RE.id, 504, 139, 154);
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
                            isc.IButtonCancel.create({
                                click: function () {
                                    Window_SelectQuestionnarie_RE.close();
                                }
                            }),
                            isc.IButtonSave.create({
                                title: "ارسال از طریق پیامک",
                                click: function () {
                                }
                            }),
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

    //--------------------- global functions ----------------------
    function createOrUpdate_evaluation_form(id,questionnarieId, evaluatorId,
                                    evaluatorTypeId, evaluatedId, evaluatedTypeId, questionnarieTypeId,
                                    evaluationLevel){
        let data = {};
        data.classId = classRecord_RE.id;
        data.status = false;
        if(ReturnDate_BE._value != undefined )
            data.returnDate =  ReturnDate_BE._value;
        data.sendDate = todayDate;
        data.evaluatorId = evaluatorId;
        data.evaluatorTypeId = evaluatorTypeId;
        data.evaluatedId = evaluatedId;
        data.evaluatedTypeId = evaluatedTypeId;
        data.questionnarieId =questionnarieId;
        data.questionnarieTypeId = questionnarieTypeId;
        data.evaluationLevel = evaluationLevel;
        data.evaluationFull = false;
        data.description = null;

        isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl, "POST", JSON.stringify(data), function (resp) {
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                setTimeout(() => {
                    msg.close();
                }, 3000);
                print_Student_Reaction_Form_RE(questionnarieId, evaluatorId,
                    evaluatorTypeId, evaluatedId, evaluatedTypeId, questionnarieTypeId,
                    evaluationLevel);
                ListGrid_student_RE.invalidateCache();
            }
            else {
                createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
            }
        }));
    }





    // </script>