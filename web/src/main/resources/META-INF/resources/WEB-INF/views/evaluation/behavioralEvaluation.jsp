<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);%>
// <script>
    //----------------------------------------- Variables --------------------------------------------------------------
        var evalWait_BE;

        var localQuestions_BE;

        var evaluation_Audience_BE = null;

        var evaluation_numberOfStudents_BE = null;

        var classRecord_BE;

    //----------------------------------------- DataSources ------------------------------------------------------------
        var AudienceTypeDS_BE = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
                {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
            ],
            cacheAllData: true,
            fetchDataURL: parameterUrl + "/iscList/EvaluatorType",
            implicitCriteria: {
                _constructor:"AdvancedCriteria",
                operator:"and",
                criteria:[{ fieldName: "code", operator: "inSet", value: ["21","32","42","4"]}]
            }
        });

        var EvaluationDS_PersonList_BE = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {
                    name: "firstName",
                    title: "<spring:message code="firstName"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "lastName",
                    title: "<spring:message code="lastName"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "nationalCode",
                    title: "<spring:message code="national.code"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "companyName",
                    title: "<spring:message code="company.name"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "personnelNo",
                    title: "<spring:message code="personnel.no"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "personnelNo2",
                    title: "<spring:message code="personnel.no.6.digits"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "postTitle",
                    title: "<spring:message code="post"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "ccpArea",
                    title: "<spring:message code="reward.cost.center.area"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "ccpAssistant",
                    title: "<spring:message code="reward.cost.center.assistant"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "ccpAffairs",
                    title: "<spring:message code="reward.cost.center.affairs"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "ccpSection",
                    title: "<spring:message code="reward.cost.center.section"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "ccpUnit",
                    title: "<spring:message code="reward.cost.center.unit"/>",
                    filterOperator: "iContains"
                }
            ],
            // fetchDataURL: personnelUrl + "/iscList"
        });

        var RestDataSource_student_BE = isc.TrDS.create({
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
                },
                {
                    name: "evaluationAudienceTypeId",
                    title: "<spring:message code="evaluation.audience.type"/>",
                    type: "SelectItem",
                    optionDataSource: AudienceTypeDS_BE,
                    pickListProperties: {
                        showFilterEditor: false
                    },
                    pickListFields: [
                        {name: "title"}
                    ],
                    filterOnKeypress: true,
                    filterFields: ["title"],
                    valueField: "id",
                    displayField: "title",
                    filterOperator: "iContains"
                }
            ],
        });

    //----------------------------------------- DynamicForms -----------------------------------------------------------
        var DynamicForm_ReturnDate_BE = isc.DynamicForm.create({
            width: "150px",
            height: "10px",
            padding: 0,
            fields: [
                <sec:authorize access="hasAuthority('Evaluation_PrintPreTest')">
                {
                    name: "evaluationReturnDate",
                    title: "<spring:message code='return.date'/>",
                    ID: "ReturnDate_BE",
                    width: "150px",
                    hint: "----/--/--",
                    keyPressFilter: "[0-9/]",
                    showHintInField: true,
                    icons: [{
                        src: "<spring:url value="calendar.png"/>",
                        click: function (form) {
                            closeCalendarWindow();
                            displayDatePicker('ReturnDate_BE', this, 'ymd', '/');
                        }
                    }],
                    textAlign: "center",
                    click: function (form) {

                    },
                    changed: function (form, item, value) {

                        evaluation_check_date_BE();
                    }
                }
                </sec:authorize>
            ]
        });

    //----------------------------------------- ListGrids --------------------------------------------------------------
        var EvaluationListGrid_PeronalLIst_BE = isc.TrLG.create({
            dataSource: EvaluationDS_PersonList_BE,
            selectionType: "single",
            fields: [
                {name: "id", hidden: true},
                {name: "firstName"},
                {name: "lastName"},
                {name: "nationalCode"},
                {name: "companyName"},
                {name: "personnelNo"},
                {name: "personnelNo2"},
                {name: "postTitle"},
                {name: "ccpArea"},
                {name: "ccpAssistant"},
                {name: "ccpAffairs"},
                {name: "ccpSection"},
                {name: "ccpUnit"}
            ],
            selectionAppearance: "checkbox"
        });

        var ListGrid_student_BE = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_student_BE,
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
                    name: "evaluationStatusBehavior",
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
                {name: "evaluationAudienceTypeId",title: "<spring:message code="evaluation.audience.type"/>"},
                {name: "sendForm", title: " ", align: "center", canSort: false, canFilter: false, autoFithWidth: true},
                {
                    name: "saveResults",
                    title: " ",
                    align: "center",
                    canSort: false,
                    canFilter: false,
                    autoFithWidth: true
                }
            ],
            filterEditorSubmit: function () {
                ListGrid_student_BE.invalidateCache();
            },
            getCellCSSText: function (record, rowNum, colNum) {
                if (!ListGrid_student_BE.getFieldByName("evaluationStatusBehavior").hidden && record.evaluationStatusBehavior === 1)
                    return "background-color : #d8e4bc";

                if (!ListGrid_student_BE.getFieldByName("evaluationStatusBehavior").hidden && (record.evaluationStatusBehavior === 3 || record.evaluationStatusBehavior === 2))
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
                                register_evaluation_result_behavioral_student(record);
                        }
                    });
                    return button;
                } else if (fieldName == "sendForm") {
                    let button = isc.IButton.create({
                        layoutAlign: "center",
                        baseStyle: "sendFile",
                        title: "صدور فرم",
                        width: "120",
                        click: function () {
                            set_print_Status_BE("single", record);
                        }
                    });
                    return button;
                } else {
                    return null;
                }
            },
        });

    //----------------------------------------- ToolStrips -------------------------------------------------------------
        var ToolStripButton_FormIssuanceForAll_BE = isc.ToolStripButton.create({
            title: "<spring:message code="students.form.issuance.Behavioral"/>",
            baseStyle: "sendFile",
            click: function () {
                set_print_Status_BE("all");
            }
        });

        var ToolStripButton_RefreshIssuance_BE = isc.ToolStripButtonRefresh.create({
            title: "<spring:message code="refresh"/>",
            click: function () {
                ListGrid_student_BE.invalidateCache();
            }
        });

        var ToolStrip_BE = isc.ToolStrip.create({
            width: "100%",
            membersMargin: 10,
            members: [
                <sec:authorize access="hasAuthority('Evaluation_PrintPreTest')">
                isc.VLayout.create({
                    members: [
                        ToolStripButton_FormIssuanceForAll_BE,
                        isc.LayoutSpacer.create({height: "22"})
                    ]
                }),
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_RefreshIssuance_BE
                    ]
                })
                </sec:authorize>
            ]
        });

    //----------------------------------------- LayOut -----------------------------------------------------------------
        var HLayout_Actions_BE = isc.HLayout.create({
            width: "100%",
            height: "1%",
            members: [ToolStrip_BE]
        });

        var Hlayout_Grid_BE = isc.HLayout.create({
            width: "100%",
            height: "100%",
            members: [ListGrid_student_BE]
        });

        var HLayout_returnData_BE = isc.HLayout.create({
            width: "100%",
            members: [
                DynamicForm_ReturnDate_BE,
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

        var VLayout_Body_BE = isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [HLayout_returnData_BE, HLayout_Actions_BE, Hlayout_Grid_BE]
        });

    //----------------------------------------- Functions --------------------------------------------------------------
        function evaluation_check_date_BE() {
            DynamicForm_ReturnDate_BE.clearFieldErrors("evaluationReturnDate", true);

            if (DynamicForm_ReturnDate_BE.getValue("evaluationReturnDate") !== undefined && !checkDate(DynamicForm_ReturnDate_BE.getValue("evaluationReturnDate"))) {
                DynamicForm_ReturnDate_BE.addFieldErrors("evaluationReturnDate", "<spring:message code='msg.correct.date'/>", true);
            } else if (DynamicForm_ReturnDate_BE.getValue("evaluationReturnDate") < classRecord_BE.startDate) {
                DynamicForm_ReturnDate_BE.addFieldErrors("evaluationReturnDate", "<spring:message code='return.date.before.class.start.date'/>", true);
            } else {
                DynamicForm_ReturnDate_BE.clearFieldErrors("evaluationReturnDate", true);
            }
        }

        function print_Student_Behavioral_Form_Inssuance(record){
            let evaluation_Audience_Type = isc.DynamicForm.create({
                fields: [
                    {
                        name: "audiencePost",
                        type: "SelectItem",
                        optionDataSource: AudienceTypeDS_BE,
                        title: "نوع مخاطب : ",
                        pickListProperties: {
                            showFilterEditor: false
                        },
                        pickListFields: [
                            {name: "title"}
                        ],
                        valueField: "id",
                        displayField: "title",
                        changed: function (form, item, value) {
                            if(value == 190)
                                EvaluationDS_PersonList_BE.fetchDataURL =  personnelUrl + "/getParentEmployee/" + record.student.nationalCode;
                            else if(value == 189)
                                EvaluationDS_PersonList_BE.fetchDataURL =  personnelUrl + "/getSiblingsEmployee/" + record.student.nationalCode;
                            else if(value == 454)
                                EvaluationDS_PersonList_BE.fetchDataURL =  personnelUrl + "/getTraining/" +  "<%= SecurityUtil.getNationalCode()%>";
                            else if(value == 188)
                                EvaluationDS_PersonList_BE.fetchDataURL =  personnelUrl + "/getStudent/" + record.student.nationalCode;
                            else
                                EvaluationDS_PersonList_BE.fetchDataURL =  personnelUrl + "/iscList";
                            EvaluationListGrid_PeronalLIst_BE.dataSource = EvaluationDS_PersonList_BE;
                            EvaluationListGrid_PeronalLIst_BE.fetchData();
                            EvaluationListGrid_PeronalLIst_BE.invalidateCache();
                        }
                    },
                ]
            });
            let Buttons_List_HLayout = isc.HLayout.create({
                width: "100%",
                height: "30px",
                autoDraw: false,
                padding: "5px",
                align: "center",
                membersMargin: 5,
                members: [
                    isc.IButton.create({
                        title: "صدور و چاپ",
                        click: function () {
                            if (EvaluationListGrid_PeronalLIst_BE.getSelectedRecord() !== null && (evaluation_Audience_Type.getValue("audiencePost") !== null && evaluation_Audience_Type.getValue("audiencePost") !== undefined)) {
                                evaluation_Audience_BE = EvaluationListGrid_PeronalLIst_BE.getSelectedRecord().firstName + " " + EvaluationListGrid_PeronalLIst_BE.getSelectedRecord().lastName;
                                let evaluationType = (evaluation_Audience_Type.getValue("audiencePost") === null || evaluation_Audience_Type.getValue("audiencePost") === undefined ? "" : evaluation_Audience_Type.getField("audiencePost").getDisplayValue());
                                print_Student_FormIssuance_BE("pdf", evaluation_numberOfStudents_BE,record,null,evaluationType);
                                create_Student_BehavioralForm(evaluation_numberOfStudents_BE,record,EvaluationListGrid_PeronalLIst_BE.getSelectedRecord(),evaluation_Audience_Type.getValue("audiencePost"));
                                EvaluationWin_PersonList.close();
                            } else if(evaluation_Audience_Type.getValue("audiencePost") === null || evaluation_Audience_Type.getValue("audiencePost") === undefined){
                                createDialog('info', "<spring:message code="select.audience.post.ask"/>", "<spring:message code="global.message"/>");
                            } else {
                                isc.Dialog.create({
                                    message: "<spring:message code="select.audience.ask"/>",
                                    icon: "[SKIN]ask.png",
                                    title: "<spring:message code="global.message"/>",
                                    buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
                                    buttonClick: function (button, index) {
                                        this.close();
                                    }
                                });
                            }
                        }
                    }),
                    isc.IButton.create({
                        title: "ارسال از طریق پیامک",
                        click: function () {
                        }
                    }),
                    isc.IButton.create({
                        title: "<spring:message code="logout"/>",
                        click: function () {
                            evaluation_Audience_BE = null;
                            evaluation_Audience_Type.setValues(null);
                            EvaluationWin_PersonList.close();
                        }
                    })
                ]
            });
            let evaluation_personnel_List_VLayout = isc.VLayout.create({
                width: "100%",
                height: "100%",
                autoDraw: false,
                members: [
                    evaluation_Audience_Type,
                    EvaluationListGrid_PeronalLIst_BE,
                    Buttons_List_HLayout
                ]
            });
            evaluation_Audience_Type.setValues(null);
            let EvaluationWin_PersonList = isc.Window.create({
                title: "<spring:message code="select.audience"/>",
                width: 600,
                height: 400,
                minWidth: 600,
                minHeight: 400,
                autoSize: false,
                visibility: "hidden",
                items: [
                    evaluation_personnel_List_VLayout
                ],
                close : function () {
                    evaluation_Audience_Type.setValues(null);
                    this.Super("close",arguments);
                }
            });
            EvaluationDS_PersonList_BE.fetchDataURL =  "";
            EvaluationListGrid_PeronalLIst_BE.dataSource = EvaluationDS_PersonList_BE;
            EvaluationWin_PersonList.show();
            EvaluationListGrid_PeronalLIst_BE.invalidateCache();
            EvaluationListGrid_PeronalLIst_BE.fetchData();
        }

        function set_print_Status_BE(numberOfStudents,record) {
            evaluation_check_date_BE();

            if (DynamicForm_ReturnDate_BE.hasErrors())
                return;

            if (Detail_Tab_Evaluation.getSelectedTab().id === "TabPane_Behavior") {
                evaluation_numberOfStudents_BE = numberOfStudents;
                let selectedStudent = record;
                if (numberOfStudents === "all" || (numberOfStudents === "single" && selectedStudent !== null && selectedStudent !== undefined)) {
                    print_Student_Behavioral_Form_Inssuance(record);
                } else {
                    isc.Dialog.create({
                        message: "<spring:message code="msg.no.records.selected"/>",
                        icon: "[SKIN]ask.png",
                        title: "<spring:message code="global.message"/>",
                        buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
                        buttonClick: function (button, index) {
                            this.close();
                        }
                    });
                }

            } else {
                print_Student_FormIssuance_BE("pdf", numberOfStudents,record);
            }
        }

        function create_Student_BehavioralForm(numberOfStudents,record,evaluatorRecord,evaluatorType){
            if (ListGrid_student_BE.getTotalRows() > 0) {
                let selectedClass = classRecord_BE;
                let selectedStudent = record;
                let selectedTab = Detail_Tab_Evaluation.getSelectedTab();

                if (numberOfStudents === "single" && selectedStudent !== null && selectedStudent !== undefined) {

                    let studentId = selectedStudent.id;
                    let data = {};
                    data.questionnaireTypeId = 230;
                    data.evaluationLevelId = 156;
                    data.evaluatedId = studentId;
                    data.classId = selectedClass.id;
                    data.evaluatorId = evaluatorRecord.id;
                    data.evaluatorTypeId = evaluatorType;
                    data.evaluatedTypeId = null;
                    data.status = false;
                    data.returnDate = ReturnDate_BE._value !== undefined ? ReturnDate_BE._value.replaceAll("/", "-") : "noDate";

                    isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl, "POST", JSON.stringify(data), function (resp) {
                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                            const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                            setTimeout(() => {
                                msg.close();
                        }, 3000);
                        }
                        else if(resp.httpResponseCode === 406){
                            createDialog("info", "فرم ارزیابی قبلا برای این فرد صادر شده است.");
                        }
                        else {
                            createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                        }
                    }));

                    evaluation_Audience_BE = null;
                }
                else if (numberOfStudents === "all") {

                } else {
                    isc.Dialog.create({
                        message: "<spring:message code="msg.no.records.selected"/>",
                        icon: "[SKIN]ask.png",
                        title: "<spring:message code="global.message"/>",
                        buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
                        buttonClick: function (button, index) {
                            this.close();
                        }
                    });
                }
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

        function print_Student_FormIssuance_BE(type, numberOfStudents,record, audienceName, audienceType, formReturnDate) {
            if (ListGrid_student_BE.getTotalRows() > 0) {
                let selectedClass = classRecord_BE;
                let selectedStudent = record;
                let selectedTab = Detail_Tab_Evaluation.getSelectedTab();

                if (numberOfStudents === "all" || (numberOfStudents === "single" && selectedStudent !== null && selectedStudent !== undefined)) {

                    let studentId = (numberOfStudents === "single" ? selectedStudent.student.id : -1);
                    let returnDate = ReturnDate_BE._value !== undefined ? ReturnDate_BE._value.replaceAll("/", "-") : "noDate";
                    if(audienceName == null)
                        audienceName = evaluation_Audience_BE;
                    if(formReturnDate == null)
                        formReturnDate = returnDate;

                    let myObj = {
                        evaluationAudienceType: audienceType,
                        courseId: selectedClass.course.id,
                        studentId: studentId,
                        evaluationType: selectedTab.id,
                        evaluationReturnDate: formReturnDate,
                        evaluationAudience: audienceName
                    };

                    let advancedCriteria_unit = ListGrid_student_BE.getCriteria();
                    let criteriaForm_operational = isc.DynamicForm.create({
                        method: "POST",
                        action: "<spring:url value="/evaluation/printWithCriteria/"/>" + type + "/" + selectedClass.id,
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

                    criteriaForm_operational.setValue("CriteriaStr", JSON.stringify(advancedCriteria_unit));
                    criteriaForm_operational.setValue("myToken", "<%=accessToken%>");
                    criteriaForm_operational.setValue("printData", JSON.stringify(myObj));
                    criteriaForm_operational.show();
                    criteriaForm_operational.submit();
                    criteriaForm_operational.submit(set_evaluation_status_BE(numberOfStudents,record,audienceName, audienceType));

                    evaluation_Audience_BE = null;

                } else {
                    isc.Dialog.create({
                        message: "<spring:message code="msg.no.records.selected"/>",
                        icon: "[SKIN]ask.png",
                        title: "<spring:message code="global.message"/>",
                        buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
                        buttonClick: function (button, index) {
                            this.close();
                        }
                    });
                }
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

        function set_evaluation_status_BE(numberOfStudents,record,audienceName, audienceType) {


            let listOfStudent = [];

            getStudentList(setStudentStatus);

            function getStudentList(callback) {

                if (numberOfStudents === "single") {

                    listOfStudent.push(record);
                    callback(listOfStudent);

                } else if (numberOfStudents === "all") {

                    ListGrid_student_BE.selectAllRecords();

                    ListGrid_student_BE.getSelectedRecords().forEach(function (selectedStudent) {
                        listOfStudent.push(selectedStudent);
                    });

                    ListGrid_student_BE.deselectAllRecords();
                    callback(listOfStudent);
                }
            }

            function setStudentStatus(listOfStudent) {

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
                                "evaluationAudienceId": EvaluationListGrid_PeronalLIst_BE.getSelectedRecord().id,
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
                    isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/setStudentFormIssuance/", "PUT", JSON.stringify(evaluationData), show_EvaluationActionResult_BE));

                })
            }
        }

        function show_EvaluationActionResult_BE(resp) {
            let respCode = resp.httpResponseCode;
            if (respCode === 200 || respCode === 201) {

                let gridState;
                let selectedStudent = ListGrid_student_BE.getSelectedRecord();
                if (selectedStudent !== null)
                    gridState = "[{id:" + selectedStudent.id + "}]";

                ListGrid_student_BE.invalidateCache();

                if (selectedStudent !== null)
                    setTimeout(function () {

                        ListGrid_student_BE.setSelectedState(gridState);

                        ListGrid_student_BE.scrollToRow(ListGrid_student_BE.getRecordIndex(ListGrid_student_BE.getSelectedRecord()), 0);

                    }, 600);
            }
        }

        function register_evaluation_result_behavioral_student(StdRecord){
            let LGRecord = classRecord_BE;
            let RestDataSource_BehavioralRegisteration_JSPEvaluation = isc.TrDS.create({
                fields: [
                    {name: "evaluatorTypeId"},
                    {name: "evaluatorName"},
                    {name: "status"},
                    {name: "id", primaryKey: true},
                    {name: "evaluatorId"},
                    {name: "returnDate"},
                    {name: "evaluatorTypeTitle"}
                ],
                fetchDataURL : evaluationUrl + "/getBehavioralForms/" + StdRecord.id + "/" + LGRecord.id
            });
            let Listgrid_BehavioralRegisteration_JSPEvaluation = isc.TrLG.create({
                width: "100%",
                height: "100%",
                dataSource: RestDataSource_BehavioralRegisteration_JSPEvaluation,
                sortField: 0,
                sortDirection: "Descending",
                showRecordComponents: true,
                showRecordComponentsByCell: true,
                showFilterEditor: false,
                fields: [
                    {
                        name: "evaluatorTypeId",
                        title: "نوع مخاطب",
                        width: "45%",
                        type: "SelectItem",
                        optionDataSource: AudienceTypeDS_BE,
                        filterEditorProperties:{
                            pickListProperties: {
                                showFilterEditor: false
                            }
                        },
                        canFilter: false,
                        valueField: "id",
                        displayField: "title"
                    },
                    {
                        name: "evaluatorName",
                        title: "نام مخاطب",
                        canFilter: false,
                        width: "45%"
                    },
                    {name: "evaluatorId",hidden: true},
                    {name: "status", hidden: true},
                    {name: "id", hidden: true},
                    {name: "returnDate", hidden: true},
                    {name: "evaluatorTypeTitle",hidden: true},
                    {name: "editForm",title: " ", align: "center",canSort:false,canFilter:false, width: "10%"},
                    {name: "removeForm",title: " ", align: "center",canSort:false,canFilter:false, width: "10%"},
                    {name: "printForm",title: " ", align: "center",canSort:false,canFilter:false, width: "10%"}
                ],
                filterEditorSubmit: function () {
                    Listgrid_BehavioralRegisteration_JSPEvaluation.invalidateCache();
                },
                createRecordComponent: function (record, colNum) {
                    let fieldName = this.getFieldName(colNum);
                    if (fieldName == "editForm") {
                        let recordCanvas = isc.HLayout.create({
                            height: "100%",
                            width: "100%",
                            layoutMargin: 5,
                            membersMargin: 10,
                            align: "center"
                        });
                        let editIcon = isc.ImgButton.create({
                            showDown: false,
                            showRollOver: false,
                            layoutAlign: "center",
                            src: "[SKIN]/actions/edit.png",
                            prompt: "ویرایش فرم",
                            height: 16,
                            width: 16,
                            grid: this,
                            click: function () {
                                register_behavioral_evaluation_result(StdRecord,LGRecord,record.evaluatorName,
                                    record.evaluatorId,record.evaluatorTypeId,record.id);
                            }
                        });
                        recordCanvas.addMember(editIcon);
                        return recordCanvas;
                    }
                    else if (fieldName == "removeForm") {
                        let recordCanvas = isc.HLayout.create({
                            height: "100%",
                            width: "100%",
                            layoutMargin: 5,
                            membersMargin: 10,
                            align: "center"
                        });
                        let addIcon = isc.ImgButton.create({
                            showDown: false,
                            showRollOver: false,
                            layoutAlign: "center",
                            src: "[SKIN]/actions/remove.png",
                            prompt: "حذف فرم",
                            height: 16,
                            width: 16,
                            grid: this,
                            click: function () {
                                let Dialog_Remove = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                                    "<spring:message code="verify.delete"/>");
                                Dialog_Remove.addProperties({
                                    buttonClick: function (button, index) {
                                        this.close();
                                        if (index === 0) {
                                            isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/" + record.id , "DELETE", null, function (resp) {
                                                Listgrid_BehavioralRegisteration_JSPEvaluation.invalidateCache();}));
                                        }
                                    }
                                });
                            }
                        });
                        recordCanvas.addMember(addIcon);
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
                        let addIcon = isc.ImgButton.create({
                            showDown: false,
                            showRollOver: false,
                            layoutAlign: "center",
                            src: "[SKIN]/actions/print.png",
                            prompt: "چاپ فرم",
                            height: 16,
                            width: 16,
                            grid: this,
                            click: function () {
                                print_Student_FormIssuance_BE("pdf","single",StdRecord,record.evaluatorName, record.evaluatorTypeTitle, record.returnDate);
                            }
                        });
                        recordCanvas.addMember(addIcon);
                        return recordCanvas;
                    }else
                        return null;
                },
                cellHeight: 43,
                filterOperator: "iContains",
                filterOnKeypress: false,
                allowAdvancedCriteria: true,
                allowFilterExpressions: true,
                selectionType: "single",
                autoFetchData: true,
                filterUsingText: "<spring:message code='filterUsingText'/>",
                groupByText: "<spring:message code='groupByText'/>",
                freezeFieldText: "<spring:message code='freezeFieldText'/>"
            });
            let Window_BehavioralRegisteration_JSPEvaluation = isc.Window.create({
                placement: "fillScreen",
                title: "لیست فرم های صادر شده",
                canDragReposition: true,
                align: "center",
                autoDraw: true,
                border: "1px solid gray",
                items: [isc.TrVLayout.create({
                    members: [
                        Listgrid_BehavioralRegisteration_JSPEvaluation
                    ]
                })]
            });
            Window_BehavioralRegisteration_JSPEvaluation.show();
        }

        function register_behavioral_evaluation_result(StdRecord,LGRecord,EvaluatorName,EvaluatorId,EvaluatorTypeId,EvaluationId){
            let studentIdJspEvaluation;
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
            let vm_JspEvaluation = isc.ValuesManager.create({});
            let itemList = [];
            let evaluatorId;

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
                        case "OEFS":
                            data.questionnaireTypeId = 230;
                            data.evaluatorId = EvaluatorId;
                            data.evaluatedId = StdRecord.id;
                            data.evaluationLevelId = evaluationLevelId;
                            break;
                    }
                    data.classId = LGRecord.id;
                    isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/" + EvaluationId, "PUT", JSON.stringify(data), function (resp) {
                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                            Window_Questions_JspEvaluation.close();
                            ListGrid_student_BE.invalidateCache();
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
                        required: true,
                        disabled: true
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

            DynamicForm_Questions_Body_JspEvaluation.clearValues();
            DynamicForm_Description_JspEvaluation.clearValues();
            DynamicForm_Questions_Title_JspEvaluation.clearValues();
            DynamicForm_Questions_Title_JspEvaluation.editRecord(LGRecord);
            DynamicForm_Questions_Title_JspEvaluation.setValue("user", "<%= SecurityUtil.getFullName()%>");
            DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationLevel").setValue("Behavioral");
            DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationType").setValue("OEFS");
            DynamicForm_Questions_Title_JspEvaluation.setValue("evaluator",EvaluatorName);
            DynamicForm_Questions_Title_JspEvaluation.setValue("evaluated", StdRecord.student.firstName + " " + StdRecord.student.lastName);
            evaluatorId = EvaluatorId;

            let criteria = '';
            let criteriaEdit =
                '{"fieldName":"classId","operator":"equals","value":' + LGRecord.id + '},';
            criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":"OEFS"}';
            criteriaEdit +=
                '{"fieldName":"questionnaireTypeId","operator":"equals","value":230},' +
                '{"fieldName":"evaluatorId","operator":"equals","value":' + EvaluatorId + '},' +
                '{"fieldName":"evaluatedId","operator":"equals","value":' + StdRecord.id + '},' +
                '{"fieldName":"evaluatorTypeId","operator":"equals","value":' + EvaluatorTypeId + '},';
            criteriaEdit += '{"fieldName":"evaluationLevelId","operator":"equals","value":156}';
            evaluationLevelId = 156;
            requestEvaluationQuestions_BE(criteria, criteriaEdit, 1);

            evalWait_BE = createDialog("wait");
            Window_Questions_JspEvaluation.show();

            function requestEvaluationQuestions_BE(criteria, criteriaEdit, type = 0) {
                isc.RPCManager.sendRequest(TrDSRequest(questionnaireUrl + "/iscList?operator=or&_constructor=AdvancedCriteria&criteria=" + criteria, "GET", null, function (resp) {
                    if (JSON.parse(resp.data).response.data.length > 0) {
                        let criteria = '{"fieldName":"questionnaireId","operator":"equals","value":' + JSON.parse(resp.data).response.data[0].id + '}';
                        isc.RPCManager.sendRequest(TrDSRequest(questionnaireQuestionUrl + "/iscList?operator=or&_constructor=AdvancedCriteria&criteria=" + criteria, "GET", null, function (resp) {
                            localQuestions_BE = JSON.parse(resp.data).response.data;
                            for (let i = 0; i < localQuestions_BE.length; i++) {
                                let item = {};
                                switch (localQuestions_BE[i].evaluationQuestion.domain.code) {
                                    case "EQP":
                                        item.name = "Q" + localQuestions_BE[i].id;
                                        item.title = "امکانات: " + localQuestions_BE[i].evaluationQuestion.question;
                                        break;
                                    case "CLASS":
                                        item.name = "Q" + localQuestions_BE[i].id;
                                        item.title = "کلاس: " + localQuestions_BE[i].evaluationQuestion.question;
                                        break;
                                    case "SAT":
                                        item.name = "Q" + localQuestions_BE[i].id;
                                        item.title = "مدرس: " + localQuestions_BE[i].evaluationQuestion.question;
                                        break;
                                    case "TRAINING":
                                        item.name = "Q" + localQuestions_BE[i].id;
                                        item.title = "مدرس: " + localQuestions_BE[i].evaluationQuestion.question;
                                        break;
                                    case "Content":
                                        item.name = "Q" + localQuestions_BE[i].id;
                                        item.title = "محتواي کلاس: " + localQuestions_BE[i].evaluationQuestion.question;
                                        break;
                                    default:
                                        item.name = "Q" + localQuestions_BE[i].id;
                                        item.title = localQuestions_BE[i].evaluationQuestion.question;
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
                                    localQuestions_BE = JSON.parse(resp.data);
                                    for (let i = 0; i < localQuestions_BE.length; i++) {
                                        let item = {};
                                        switch (localQuestions_BE[i].type) {
                                            case "goal":
                                                item.name = "G" + localQuestions_BE[i].id;
                                                item.title = "هدف: " + localQuestions_BE[i].title;
                                                break;
                                            case "skill":
                                                item.name = "M" + localQuestions_BE[i].id;
                                                item.title = "هدف اصلي: " + localQuestions_BE[i].title;
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
                                    requestEvaluationQuestionsEdit_BE(criteriaEdit);
                                }));
                            } else {
                                DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                                requestEvaluationQuestionsEdit_BE(criteriaEdit);
                            }
                        }));
                    } else {
                        if (type !== 0) {
                            isc.RPCManager.sendRequest(TrDSRequest(courseUrl + "goal-mainObjective/" + LGRecord.courseId, "GET", null, function (resp) {
                                localQuestions_BE = JSON.parse(resp.data);
                                for (let i = 0; i < localQuestions_BE.length; i++) {
                                    let item = {};
                                    switch (localQuestions_BE[i].type) {
                                        case "goal":
                                            item.name = "G" + localQuestions_BE[i].id;
                                            item.title = "هدف: " + (i + 1).toString() + "- " + localQuestions_BE[i].title;
                                            break;
                                        case "skill":
                                            item.name = "M" + localQuestions_BE[i].id;
                                            item.title = "هدف اصلي: " + (i + 1).toString() + "- " + localQuestions_BE[i].title;
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
                                requestEvaluationQuestionsEdit_BE(criteriaEdit);
                            }));
                        } else {
                            DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                            requestEvaluationQuestionsEdit_BE(criteriaEdit);
                        }
                    }
                    evalWait_BE.close();
                }));

            }
            function requestEvaluationQuestionsEdit_BE(criteria) {
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
