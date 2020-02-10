<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>
    var localQuestions;
    // <<========== Global - Variables ==========
    {
        var evaluation_method = "POST";
    }
    // ============ Global - Variables ========>>


    // <<-------------------------------------- Create - Window ------------------------------------
    {

        EvaluationDS_PersonList = isc.TrDS.create({
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
            fetchDataURL: personnelUrl + "/iscList",
        });

        EvaluationListGrid_PeronalLIst = isc.TrLG.create({
            dataSource: EvaluationDS_PersonList,
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

        var evaluation_Audience = null;
        var ealuation_numberOfStudents = null;
        var Buttons_List_HLayout = isc.HLayout.create({
            width: "100%",
            height: "30px",
            autoDraw: false,
            padding: "5px",
            align: "center",
            membersMargin: 5,
            members: [
                isc.IButton.create({
                    title: "<spring:message code="select" />",
                    click: function () {
                        if (EvaluationListGrid_PeronalLIst.getSelectedRecord() !== null) {
                            evaluation_Audience = EvaluationListGrid_PeronalLIst.getSelectedRecord().firstName + " " + EvaluationListGrid_PeronalLIst.getSelectedRecord().lastName;
                            print_Student_FormIssuance("pdf", ealuation_numberOfStudents);
                            EvaluationWin_PersonList.close();
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
                    title: "<spring:message code="logout"/>",
                    click: function () {
                        evaluation_Audience = null;
                        EvaluationWin_PersonList.close();
                    }
                })
            ]
        });

        var evaluation_personnel_List_VLayout = isc.VLayout.create({
            width: "100%",
            height: "100%",
            autoDraw: false,
            members: [
                EvaluationListGrid_PeronalLIst,
                Buttons_List_HLayout
            ]
        });

        EvaluationWin_PersonList = isc.Window.create({
            title: "<spring:message code="select.audience"/>",
            width: 600,
            height: 400,
            minWidth: 600,
            minHeight: 400,
            autoSize: false,
            visibility: "hidden",
            items: [
                evaluation_personnel_List_VLayout
            ]
        });
    }
    // ---------------------------------------- Create - Window ---------------------------------->>

    // <<-------------------------------------- Create - contextMenu ------------------------------------------
    {
        var Menu_ListGrid_evaluation_class = isc.Menu.create({
            data: [
                {
                    title: "<spring:message code="evaluation.teacher.supervisor"/>",
                    icon: "<spring:url value="refresh.png"/>",
                    click: function () {
                        let criteria = '{"fieldName":"domainId","operator":"equals","value":54}';
                        isc.RPCManager.sendRequest({
                            actionURL: configQuestionnaireUrl + "/iscList?operator=and&_constructor=AdvancedCriteria&criteria=" + criteria,
                            httpMethod: "GET",
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            showPrompt: false,
                            serverOutputAsString: false,
                            callback: function (resp) {
                                localQuestions = JSON.parse(resp.data).response.data;
                                var vm_JspEvaluation = isc.ValuesManager.create({});
                                var DynamicForm_Questions_Title_JspEvaluation = isc.DynamicForm.create({
                                    validateOnExit: true,
                                    // height: "10%",
                                    numCols: 6,
                                    valuesManager: vm_JspEvaluation,
                                    // colWidths:["29%","68%"],
                                    width: "100%",
                                    borderRadius: "10px 10px 0px 0px",
                                    border: "1px solid black",
                                    // titleAlign:"left",
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
                                        {name: "user", title: "<spring:message code='user'/>:", canEdit: false}
                                    ]
                                });
                                var DynamicForm_Questions_Body_JspEvaluation = isc.DynamicForm.create({
                                    validateOnExit: true,
                                    // height: "*",
                                    valuesManager: vm_JspEvaluation,
                                    colWidths: ["29%", "68%"],
                                    width: "100%",
                                    // borderRadius: "10px 0px",
                                    // borderBottom:"2px solid red",
                                    // titleAlign:"left",
                                    padding: 10,
                                    fields: []
                                });
                                var IButton_Questions_Save = isc.IButtonSave.create({
                                    click: function () {
                                        // let data = vm_JspEvaluation.getValues();

                                        let data = DynamicForm_Questions_Title_JspEvaluation.getValues()
                                        data.evaluationAnswerList = DynamicForm_Questions_Body_JspEvaluation.getValues();

                                        data.record = ListGrid_evaluation_class.getSelectedRecord();
                                        data.evaluator = "${username}";
                                        isc.RPCManager.sendRequest({
                                            actionURL: evaluationUrl,
                                            httpMethod: "POST",
                                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                            useSimpleHttp: true,
                                            contentType: "application/json; charset=utf-8",
                                            showPrompt: false,
                                            serverOutputAsString: false,
                                            data: JSON.stringify(data),
                                            callback: function (resp) {
                                                alert(resp.httpResponseCode)
                                            }
                                        });

                                    }
                                });
                                var IButton_Questions_Edit = isc.IButtonSave.create({
                                    title: "ویرایش",
                                    click: function () {
                                        // let data = vm_JspEvaluation.getValues();

                                        let data = DynamicForm_Questions_Title_JspEvaluation.getValues()
                                        data.evaluationAnswerList = DynamicForm_Questions_Body_JspEvaluation.getValues();

                                        data.record = ListGrid_evaluation_class.getSelectedRecord();
                                        data.evaluator = "${username}";
                                        isc.RPCManager.sendRequest({
                                            actionURL: evaluationUrl + "/" + 29,
                                            httpMethod: "PUT",
                                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                            useSimpleHttp: true,
                                            contentType: "application/json; charset=utf-8",
                                            showPrompt: false,
                                            serverOutputAsString: false,
                                            data: JSON.stringify(data),
                                            callback: function (resp) {
                                                alert(resp.httpResponseCode)
                                            }
                                        });

                                    }
                                });
                                var Window_Questions_JspEvaluation = isc.Window.create({
                                    placement: "fillScreen",
                                    title: "<spring:message code="evaluation.teacher.supervisor"/>",
                                    items: [
                                        DynamicForm_Questions_Title_JspEvaluation,
                                        DynamicForm_Questions_Body_JspEvaluation,
                                        isc.TrHLayoutButtons.create({
                                            members: [IButton_Questions_Save, IButton_Questions_Edit, isc.IButtonCancel.create({
                                                click: function () {
                                                    Window_Questions_JspEvaluation.close();
                                                }
                                            })]
                                        })
                                    ],
                                    minWidth: 1024
                                });
                                let itemList = [];
                                for (let i = 0; i < localQuestions.length; i++) {
                                    let item = {};
                                    item.name = "Q" + localQuestions[i].id;
                                    item.title = (i + 1).toString() + "- " + localQuestions[i].question;
                                    item.type = "radioGroup";
                                    item.vertical = false;
                                    // item.required = true;
                                    item.fillHorizontalSpace = true;
                                    item.valueMap = {0: "خیلی ضعیف", 1: "ضعیف", 2: "متوسط", 3: "خوب", 4: "عالی"};
                                    // item.colSpan = ,
                                    itemList.add(item);
                                }
                                DynamicForm_Questions_Title_JspEvaluation.editRecord(ListGrid_evaluation_class.getSelectedRecord());
                                DynamicForm_Questions_Title_JspEvaluation.setValue("user", "<%= SecurityUtil.getFullName()%>");
                                DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                                Window_Questions_JspEvaluation.show();
                            }
                        });
                    }
                },
                {
                    title: "<spring:message code="refresh"/>",
                    icon: "<spring:url value="refresh.png"/>",
                    click: function () {
                        ListGrid_evaluation_class.invalidateCache();
                    }
                },
                {
                    title: "<spring:message code="create"/>",
                    icon: "<spring:url value="create.png"/>",
                    click: function () {
                        create_OperationalUnit();
                    }
                },
                {
                    title: "<spring:message code="edit"/>",
                    icon: "<spring:url value="edit.png"/>",
                    click: function () {
                        show_OperationalUnitEditForm();
                    }
                },
                {
                    title: "<spring:message code="remove"/>",
                    icon: "<spring:url value="remove.png"/>",
                    click: function () {
                        remove_OperationalUnit();
                    }
                },
                {
                    isSeparator: true
                },
                {
                    title: "<spring:message code="print.pdf"/>",
                    icon: "<spring:url value="pdf.png"/>",
                    click: function () {
                        print_Student_FormIssuance("pdf");
                    }
                },
                {
                    title: "<spring:message code="print.excel"/>",
                    icon: "<spring:url value="excel.png"/>",
                    click: function () {
                        print_Student_FormIssuance("excel");
                    }
                },
                {
                    title: "<spring:message code="print.html"/>",
                    icon: "<spring:url value="html.png"/>",
                    click: function () {
                        print_Student_FormIssuance("html");
                    }
                }
            ]
        })
    }
    // ---------------------------------------- Create - contextMenu ---------------------------------------->>


    // <<-------------------------------------- Create - RestDataSource & ListGrid ----------------------------
    {

        var RestDataSource_evaluation_class = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true},
                {name: "titleClass"},
                {name: "startDate"},
                {name: "endDate"},
                {name: "code"},
                {name: "term.titleFa"},
                {name: "course.titleFa"},
                {name: "course.id"},
                {name: "course.code"},
                {name: "course.evaluation"},
                {name: "institute.titleFa"},
                {name: "studentCount"},
                {name: "numberOfStudentEvaluation"},
                {name: "classStatus"},
                {name: "trainingPlaceIds"},
                {name: "instituteId"},
                {name: "workflowEndingStatusCode"},
                {name: "workflowEndingStatus"}
            ],
            fetchDataURL: classUrl + "spec-list"
        });

        var ListGrid_evaluation_class = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_evaluation_class,
            contextMenu: Menu_ListGrid_evaluation_class,
            canAddFormulaFields: false,
            autoFetchData: true,
            showFilterEditor: true,
            allowAdvancedCriteria: true,
            allowFilterExpressions: true,
            filterOnKeypress: true,
            sortField: 0,

            fields: [
                {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
                {
                    name: "code",
                    title: "<spring:message code='class.code'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "titleClass",
                    title: "titleClass",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    hidden: true
                },
                {
                    name: "course.code",
                    title: "<spring:message code='course.code'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFithWidth: true
                },
                {
                    name: "course.titleFa",
                    title: "<spring:message code='course.title'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    sortNormalizer: function (record) {
                        return record.course.titleFa;
                    }
                },
                {
                    name: "term.titleFa",
                    title: "term",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "startDate",
                    title: "<spring:message code='start.date'/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "endDate",
                    title: "<spring:message code='end.date'/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "studentCount",
                    title: "<spring:message code='student.count'/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "numberOfStudentEvaluation",
                    title: "<spring:message code='evaluated'/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "institute.titleFa",
                    title: "<spring:message code='presenter'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "course.evaluation",
                    title: "<spring:message code='evaluation.type'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    valueMap: {
                        "1": "واکنشی",
                        "2": "یادگیری",
                        "3": "رفتاری",
                        "4": "نتایج"
                    }
                },
                {
                    name: "classStatus", title: "<spring:message code='class.status'/>", align: "center",
                    valueMap: {
                        "1": "برنامه ریزی",
                        "2": "در حال اجرا",
                        "3": "پایان یافته"
                    }
                },
                {name: "createdBy", hidden: true},
                {name: "createdDate", hidden: true},
                {
                    name: "workflowEndingStatusCode",
                    title: "workflowCode",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "workflowEndingStatus",
                    title: "<spring:message code="ending.class.status"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {name: "hasWarning", title: " ", width: 40, type: "image", imageURLPrefix: "", imageURLSuffix: ".gif"}

            ],
            selectionUpdated: function () {

                loadSelectedTab_data(Detail_Tab_Evaluation.getSelectedTab());

                set_Evaluation_Tabset_status();
            }
        });


        var RestDataSource_evaluation_student = isc.TrDS.create({
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
            ]
        });


        var ListGrid_evaluation_student = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_evaluation_student,
            selectionType: "single",
            fields: [
                {name: "student.firstName"},
                {name: "student.lastName"},
                {name: "student.nationalCode"},
                {name: "student.personnelNo"},
                {name: "student.personnelNo2"},
                {name: "student.postTitle"},
                {name: "student.ccpArea"},
                {
                    name: "evaluationStatusReaction",
                    valueMap: {
                        undefined: "صادر نشده",
                        "0": "صادر نشده",
                        "1": "صادر شده",
                        "2": "تکمیل شده"
                    }
                },
                {
                    name: "evaluationStatusLearning",
                    valueMap: {
                        undefined: "صادر نشده",
                        "0": "صادر نشده",
                        "1": "صادر شده",
                        "2": "تکمیل شده"
                    },
                    hidden: true
                },
                {
                    name: "evaluationStatusBehavior",
                    valueMap: {
                        undefined: "صادر نشده",
                        "0": "صادر نشده",
                        "1": "صادر شده",
                        "2": "تکمیل شده"
                    },
                    hidden: true
                },
                {
                    name: "evaluationStatusResults",
                    valueMap: {
                        undefined: "صادر نشده",
                        "0": "صادر نشده",
                        "1": "صادر شده",
                        "2": "تکمیل شده"
                    },
                    hidden: true
                }
            ],
            getCellCSSText: function (record, rowNum, colNum) {
                if ((!ListGrid_evaluation_student.getFieldByName("evaluationStatusReaction").hidden && record.evaluationStatusReaction === 1)
                    || (!ListGrid_evaluation_student.getFieldByName("evaluationStatusLearning").hidden && record.evaluationStatusLearning === 1)
                    || (!ListGrid_evaluation_student.getFieldByName("evaluationStatusBehavior").hidden && record.evaluationStatusBehavior === 1)
                    || (!ListGrid_evaluation_student.getFieldByName("evaluationStatusResults").hidden && record.evaluationStatusResults === 1))
                    return "background-color : #d8e4bc";

                if ((!ListGrid_evaluation_student.getFieldByName("evaluationStatusReaction").hidden && record.evaluationStatusReaction === 2)
                    || (!ListGrid_evaluation_student.getFieldByName("evaluationStatusLearning").hidden && record.evaluationStatusLearning === 2)
                    || (!ListGrid_evaluation_student.getFieldByName("evaluationStatusBehavior").hidden && record.evaluationStatusBehavior === 2)
                    || (!ListGrid_evaluation_student.getFieldByName("evaluationStatusResults").hidden && record.evaluationStatusResults === 2))
                    return "background-color : #b7dee8";

            }
        });


    }
    // ---------------------------------------- Create - RestDataSource & ListGrid -------------------------->>

    // <<-------------------------------------- Create - ToolStripButton --------------------------------------
    {
        //*****class toolStrip*****
        var ToolStripButton_Refresh = isc.ToolStripButtonRefresh.create({
            title: "<spring:message code="refresh"/>",
            click: function () {
                ListGrid_evaluation_class.invalidateCache();
            }
        });


        var ToolStrip_operational = isc.ToolStrip.create({
            width: "100%",
            membersMargin: 5,
            members: [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh
                    ]
                })

            ]
        });

        //*****evaluation toolStrip*****
        var ToolStripButton_FormIssuance = isc.ToolStripButton.create({
            title: "<spring:message code="student.form.issuance"/>",
            click: function () {
                set_print_Status("single");
            }
        });

        var ToolStripButton_FormIssuanceForAll = isc.ToolStripButton.create({
            title: "<spring:message code="students.form.issuance"/>",
            click: function () {
                set_print_Status("all");
            }
        });

        var ToolStripButton_Committee = isc.ToolStripButton.create({
            title: "send to committee",
            click: function () {
                sendNeedAssessment_CommitteeToWorkflow();
            },
            visibility: "hidden"

        });

        var ToolStripButton_Confirm = isc.ToolStripButton.create({
            title: "send to main confirm",
            click: function () {
                sendNeedAssessment_MainWorkflow();
            },
            visibility: "hidden"
        });

        var ToolStripButton_RefreshIssuance = isc.ToolStripButtonRefresh.create({
            title: "<spring:message code="refresh"/>",
            click: function () {
                ListGrid_evaluation_student.invalidateCache();
            }
        });


        var ToolStrip_evaluation = isc.ToolStrip.create({
            width: "100%",
            membersMargin: 5,
            members: [
                ToolStripButton_FormIssuance,
                ToolStripButton_FormIssuanceForAll,
                ToolStripButton_Committee,
                ToolStripButton_Confirm,
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_RefreshIssuance
                    ]
                })
            ]
        });
    }
    // ---------------------------------------- Create - ToolStripButton ------------------------------------>>

    // <<-------------------------------------- Create - DynamicForm & Window ---------------------------------
    {
//*****create fields*****
        var DynamicForm_OperationalUnit = isc.DynamicForm.create({
            fields:
                [
                    {
                        name: "unitCode",
                        title: "<spring:message code="unitCode"/>",
                        type: "text",
                        required: true,
                        length: 10
                    },
                    {
                        name: "operationalUnit",
                        title: "<spring:message code="unitName"/>",
                        type: "text",
                        required: true,
                        length: 100
                    }
                ]
        });

//*****create buttons*****
        var create_Buttons = isc.MyHLayoutButtons.create({
            members:
                [
                    isc.IButtonSave.create
                    ({
                        title: "<spring:message code="save"/> ",
                        click: function () {
                            if (evaluation_method === "POST") {
                                save_OperationalUnit();
                            } else {
                                edit_OperationalUnit();
                            }
                        }
                    }),
                    isc.IButtonCancel.create
                    ({
                        title: "<spring:message code="cancel"/>",
                        click: function () {
                            Window_OperationalUnit.close();
                        }
                    })
                ]
        });

//*****create insert/update window*****
        var Window_OperationalUnit = isc.Window.create({
            title: "<spring:message code="operational.unit"/> ",
            width: "40%",
            minWidth: 500,
            visibility: "hidden",
            items:
                [
                    DynamicForm_OperationalUnit, create_Buttons
                ]
        });
    }
    // ---------------------------------------- Create - DynamicForm $ Window ------------------------------->>

    // <<-------------------------------------- Create - TabSet & Tab -----------------------------------------
    {
        //*****evaluation HLayout & VLayout*****
        var HLayout_Actions_evaluation = isc.HLayout.create({
            width: "100%",
            height: "1%",
            members: [ToolStrip_evaluation]
        });

        var DynamicForm_ReturnDate = isc.DynamicForm.create({
            width: "150px",
            height: "10px",
            padding: 0,
            fields: [
                {
                    name: "evaluationReturnDate",
                    title: "<spring:message code='return.date'/>",
                    ID: "evaluation_ReturnDate",
                    width: "150px",
                    hint: "----/--/--",
                    keyPressFilter: "[0-9/]",
                    showHintInField: true,
                    icons: [{
                        src: "<spring:url value="calendar.png"/>",
                        click: function (form) {
                            closeCalendarWindow();
                            displayDatePicker('evaluation_ReturnDate', this, 'ymd', '/');
                        }
                    }],
                    textAlign: "center",
                    click: function (form) {

                    },
                    changed: function (form, item, value) {

                        evaluation_check_date();
                    }
                }
            ]
        });

        var Hlayout_Grid_evaluation = isc.HLayout.create({
            width: "100%",
            height: "100%",
            members: [ListGrid_evaluation_student]
        });

        var VLayout_Body_evaluation = isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [DynamicForm_ReturnDate, HLayout_Actions_evaluation, Hlayout_Grid_evaluation]
        });

        var Detail_Tab_Evaluation = isc.TabSet.create({
            ID: "tabSetEvaluation",
            tabBarPosition: "top",
            enabled: false,
            tabs: [
                {
                    id: "TabPane_Reaction",
                    title: "<spring:message code="evaluation.reaction"/>",
                    pane: VLayout_Body_evaluation
                }
                ,
                {
                    id: "TabPane_Learning",
                    title: "<spring:message code="evaluation.learning"/>",
                    pane: VLayout_Body_evaluation
                },
                {
                    id: "TabPane_Behavior",
                    title: "<spring:message code="evaluation.behavioral"/>",
                    pane: VLayout_Body_evaluation
                },
                {
                    id: "TabPane_Results",
                    title: "<spring:message code="evaluation.results"/>",
                    pane: VLayout_Body_evaluation
                }
            ],
            tabSelected: function (tabNum, tabPane, ID, tab, name) {
                if (isc.Page.isLoaded())
                    loadSelectedTab_data(tab);
            }

        });
    }
    // ---------------------------------------- Create - TabSet & Tab --------------------------------------->>

    // <<-------------------------------------- Create - HLayout & VLayout ------------------------------------
    {
        //*****class HLayout & VLayout*****
        var HLayout_Actions_operational = isc.HLayout.create({
            width: "100%",
            height: "1%",
            members: [ToolStrip_operational]
        });

        var Hlayout_Grid_operational = isc.HLayout.create({
            width: "100%",
            height: "50%",
            showResizeBar: true,
            members: [ListGrid_evaluation_class]
        });

        var Hlayout_Tab_Evaluation = isc.HLayout.create({
            width: "100%",
            height: "49%",
            members: [
                Detail_Tab_Evaluation
            ]
        });

        var VLayout_Body_operational = isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [HLayout_Actions_operational, Hlayout_Grid_operational, Hlayout_Tab_Evaluation]
        });


    }
    // ---------------------------------------- Create - HLayout & VLayout ---------------------------------->>


    // <<----------------------------------------------- Functions --------------------------------------------
    {
        //*****check date is valid*****
        function evaluation_check_date() {

            DynamicForm_ReturnDate.clearFieldErrors("evaluationReturnDate", true);

            if (DynamicForm_ReturnDate.getValue("evaluationReturnDate") !== undefined && !checkDate(DynamicForm_ReturnDate.getValue("evaluationReturnDate"))) {
                DynamicForm_ReturnDate.addFieldErrors("evaluationReturnDate", "<spring:message code='msg.correct.date'/>", true);
            } else if (DynamicForm_ReturnDate.getValue("evaluationReturnDate") < ListGrid_evaluation_class.getSelectedRecord().startDate) {
                DynamicForm_ReturnDate.addFieldErrors("evaluationReturnDate", "<spring:message code='return.date.before.class.start.date'/>", true);
            } else {
                DynamicForm_ReturnDate.clearFieldErrors("evaluationReturnDate", true);
            }
        }

        //*****show action result function*****
        var MyOkDialog_Operational;

        //*****close dialog*****
        function close_MyOkDialog_Operational() {
            setTimeout(function () {
                MyOkDialog_Operational.close();
            }, 3000);
        }

        function set_print_Status(numberOfStudents) {

            evaluation_check_date();

            if (DynamicForm_ReturnDate.hasErrors())
                return;

            if (Detail_Tab_Evaluation.getSelectedTab().id === "TabPane_Behavior") {
                ealuation_numberOfStudents = numberOfStudents;
                let selectedStudent = ListGrid_evaluation_student.getSelectedRecord();
                if (numberOfStudents === "all" || (numberOfStudents === "single" && selectedStudent !== null && selectedStudent !== undefined)) {
                    EvaluationWin_PersonList.show();
                    EvaluationListGrid_PeronalLIst.invalidateCache();
                    EvaluationListGrid_PeronalLIst.fetchData();
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
                print_Student_FormIssuance("pdf", numberOfStudents);
            }
        }

        //*****print student form issuance*****
        function print_Student_FormIssuance(type, numberOfStudents) {


            <%--if(Detail_Tab_Evaluation.getSelectedTab().id === "TabPane_Reaction" && ListGrid_evaluation_class.getSelectedRecord().classStatus !=="3" )--%>
            <%--{--%>
            <%--    isc.Dialog.create({--%>
            <%--        message: "اين كلاس هنوز خاتمه اوليه نخورده است",--%>
            <%--        icon: "[SKIN]ask.png",--%>
            <%--        title: "<spring:message code="global.message"/>",--%>
            <%--        buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],--%>
            <%--        buttonClick: function (button, index) {--%>
            <%--            this.close();--%>
            <%--        }--%>
            <%--    });--%>

            <%--    return;--%>
            <%--}--%>

            if (ListGrid_evaluation_student.getTotalRows() > 0) {
                let selectedClass = ListGrid_evaluation_class.getSelectedRecord();
                let selectedStudent = ListGrid_evaluation_student.getSelectedRecord();
                let selectedTab = Detail_Tab_Evaluation.getSelectedTab();


                if (numberOfStudents === "all" || (numberOfStudents === "single" && selectedStudent !== null && selectedStudent !== undefined)) {

                    let studentId = (numberOfStudents === "single" ? selectedStudent.student.id : -1);
                    let returnDate = evaluation_ReturnDate._value !== undefined ? evaluation_ReturnDate._value.replaceAll("/", "-") : "noDate";

                    var myObj = {
                        courseId: selectedClass.course.id,
                        studentId: studentId,
                        evaluationType: selectedTab.id,
                        evaluationReturnDate: returnDate,
                        evaluationAudience: evaluation_Audience
                    };

                    //*****print*****
                    var advancedCriteria_unit = ListGrid_evaluation_student.getCriteria();
                    var criteriaForm_operational = isc.DynamicForm.create({
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
                    criteriaForm_operational.submit(set_evaluation_status(numberOfStudents));

                    evaluation_Audience = null;

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

        //*****set evaluation status*****
        function set_evaluation_status(numberOfStudents) {


            var listOfStudent = [];

            getStudentList(setStudentStatus);

            function getStudentList(callback) {

                if (numberOfStudents === "single") {

                    listOfStudent.push(ListGrid_evaluation_student.getSelectedRecord());
                    callback(listOfStudent);

                } else if (numberOfStudents === "all") {

                    ListGrid_evaluation_student.selectAllRecords();

                    ListGrid_evaluation_student.getSelectedRecords().forEach(function (selectedStudent) {
                        listOfStudent.push(selectedStudent);
                    });

                    ListGrid_evaluation_student.deselectAllRecords();
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
                                "idClassStudent": selectedStudent.id,
                                "reaction": selectedStudent.evaluationStatusReaction || 0,
                                "learning": selectedStudent.evaluationStatusLearning || 0,
                                "behavior": selectedStudent.evaluationStatusBehavior || 0,
                                "results": 1
                            };

                            break;
                        }
                    }

                    isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/setStudentFormIssuance/", "PUT", JSON.stringify(evaluationData), show_EvaluationActionResult));

                })
            }
        }

        //*****callback for print student form issuance*****
        function show_EvaluationActionResult(resp) {
            var respCode = resp.httpResponseCode;
            if (respCode === 200 || respCode === 201) {

                let gridState;
                let selectedStudent = ListGrid_evaluation_student.getSelectedRecord();
                if (selectedStudent !== null)
                    gridState = "[{id:" + selectedStudent.id + "}]";

                ListGrid_evaluation_student.invalidateCache();

                if (selectedStudent !== null)
                    setTimeout(function () {

                        ListGrid_evaluation_student.setSelectedState(gridState);

                        ListGrid_evaluation_student.scrollToRow(ListGrid_evaluation_student.getRecordIndex(ListGrid_evaluation_student.getSelectedRecord()), 0);

                    }, 600);
            }
        }


        //*****Load student for tabs*****
        function loadSelectedTab_data(tab) {
            let classRecord = ListGrid_evaluation_class.getSelectedRecord();

            if (!(classRecord === undefined || classRecord === null)) {

                Detail_Tab_Evaluation.enable();

                switch (tab.id) {
                    case "TabPane_Reaction": {
                        ListGrid_evaluation_student.hideField("evaluationStatusLearning");
                        ListGrid_evaluation_student.hideField("evaluationStatusBehavior");
                        ListGrid_evaluation_student.hideField("evaluationStatusResults");
                        ListGrid_evaluation_student.showField("evaluationStatusReaction");

                        RestDataSource_evaluation_student.fetchDataURL = tclassStudentUrl + "/students-iscList/" + classRecord.id;
                        ListGrid_evaluation_student.invalidateCache();
                        ListGrid_evaluation_student.fetchData();
                        break;
                    }
                    case "TabPane_Learning": {
                        ListGrid_evaluation_student.hideField("evaluationStatusReaction");
                        ListGrid_evaluation_student.hideField("evaluationStatusBehavior");
                        ListGrid_evaluation_student.hideField("evaluationStatusResults");
                        ListGrid_evaluation_student.showField("evaluationStatusLearning");

                        RestDataSource_evaluation_student.fetchDataURL = tclassStudentUrl + "/students-iscList/" + classRecord.id;
                        ListGrid_evaluation_student.invalidateCache();
                        ListGrid_evaluation_student.fetchData();
                        break;
                    }
                    case "TabPane_Behavior": {
                        ListGrid_evaluation_student.hideField("evaluationStatusReaction");
                        ListGrid_evaluation_student.hideField("evaluationStatusLearning");
                        ListGrid_evaluation_student.hideField("evaluationStatusResults");
                        ListGrid_evaluation_student.showField("evaluationStatusBehavior");

                        RestDataSource_evaluation_student.fetchDataURL = tclassStudentUrl + "/students-iscList/" + classRecord.id;
                        ListGrid_evaluation_student.invalidateCache();
                        ListGrid_evaluation_student.fetchData();
                        break;
                    }
                    case "TabPane_Results": {
                        ListGrid_evaluation_student.hideField("evaluationStatusReaction");
                        ListGrid_evaluation_student.hideField("evaluationStatusLearning");
                        ListGrid_evaluation_student.hideField("evaluationStatusBehavior");
                        ListGrid_evaluation_student.showField("evaluationStatusResults");

                        RestDataSource_evaluation_student.fetchDataURL = tclassStudentUrl + "/students-iscList/" + classRecord.id;
                        ListGrid_evaluation_student.invalidateCache();
                        ListGrid_evaluation_student.fetchData();
                        break;
                    }
                }

            } else {
                Detail_Tab_Evaluation.disable();
            }
        }

        //*****set tabset status*****
        function set_Evaluation_Tabset_status() {

            let classRecord = ListGrid_evaluation_class.getSelectedRecord();
            let evaluationType = classRecord.course.evaluation;

            if (evaluationType === "1") {
                Detail_Tab_Evaluation.enableTab(0);
                Detail_Tab_Evaluation.disableTab(1);
                Detail_Tab_Evaluation.disableTab(2);
                Detail_Tab_Evaluation.disableTab(3);
            } else if (evaluationType === "2") {
                Detail_Tab_Evaluation.enableTab(0);
                Detail_Tab_Evaluation.enableTab(1);
                Detail_Tab_Evaluation.disableTab(2);
                Detail_Tab_Evaluation.disableTab(3);
            } else if (evaluationType === "3") {
                Detail_Tab_Evaluation.enableTab(0);
                Detail_Tab_Evaluation.enableTab(1);
                Detail_Tab_Evaluation.enableTab(2);
                Detail_Tab_Evaluation.disableTab(3);
            } else if (evaluationType === "4") {
                Detail_Tab_Evaluation.enableTab(0);
                Detail_Tab_Evaluation.enableTab(1);
                Detail_Tab_Evaluation.enableTab(2);
                Detail_Tab_Evaluation.enableTab(3);
            }

            VLayout_Body_evaluation.enable();

        }

    }


    // <<---------------------------------------- Send To Workflow ----------------------------------------
    function sendNeedAssessment_CommitteeToWorkflow() {
        <%--var sRecord = ListGrid_Course.getSelectedRecord();--%>

        <%--if (sRecord === null || sRecord.id === null) {--%>
        <%--    createDialog("info", "<spring:message code='msg.no.records.selected'/>");--%>
        <%--} else if (sRecord.workflowStatusCode === "2") {--%>
        <%--    createDialog("info", "<spring:message code='course.workflow.confirm'/>");--%>
        <%--} else if (sRecord.workflowStatusCode !== "0" && sRecord.workflowStatusCode !== "-3") {--%>
        <%--    createDialog("info", "<spring:message code='course.sent.to.workflow'/>");--%>
        <%--} else {--%>

        isc.MyYesNoDialog.create({
            message: "<spring:message code="record.sent.to.workflow.ask"/>",
            title: "<spring:message code="message"/>",
            buttonClick: function (button, index) {
                this.close();
                if (index === 0) {
                    var varParams = [{
                        "processKey": "needAssessment_CommitteeWorkflow",
                        "cId": 1,
                        "needAssessment": "نیازسنجی شغل برنامه نویسی انجام شد",
                        "needAssessmentCreatorId": "${username}",
                        "needAssessmentCreator": userFullName,
                        "REJECTVAL": "",
                        "REJECT": "",
                        "target": "/course/show-form",
                        "targetTitleFa": "نیازسنجی",
                        "workflowStatus": "ثبت اولیه",
                        "workflowStatusCode": "0"
                    }];

                    isc.RPCManager.sendRequest(TrDSRequest(workflowUrl + "/startProcess", "POST", JSON.stringify(varParams), startProcess_callback));
                }
            }
        });
        // }

    }

    function sendNeedAssessment_MainWorkflow() {
        <%--var sRecord = ListGrid_Course.getSelectedRecord();--%>

        <%--if (sRecord === null || sRecord.id === null) {--%>
        <%--    createDialog("info", "<spring:message code='msg.no.records.selected'/>");--%>
        <%--} else if (sRecord.workflowStatusCode === "2") {--%>
        <%--    createDialog("info", "<spring:message code='course.workflow.confirm'/>");--%>
        <%--} else if (sRecord.workflowStatusCode !== "0" && sRecord.workflowStatusCode !== "-3") {--%>
        <%--    createDialog("info", "<spring:message code='course.sent.to.workflow'/>");--%>
        <%--} else {--%>

        isc.MyYesNoDialog.create({
            message: "<spring:message code="record.sent.to.workflow.ask"/>",
            title: "<spring:message code="message"/>",
            buttonClick: function (button, index) {
                this.close();
                if (index === 0) {
                    var varParams = [{
                        "processKey": "needAssessment_MainWorkflow",
                        "cId": 1,
                        "needAssessment": "نیازسنجی پست معاونت انجام شد",
                        "needAssessmentCreatorId": "${username}",
                        "needAssessmentCreator": userFullName,
                        "REJECTVAL": "",
                        "REJECT": "",
                        "target": "/course/show-form",
                        "targetTitleFa": "نیازسنجی",
                        "workflowStatus": "ثبت اولیه",
                        "workflowStatusCode": "50"
                    }];

                    isc.RPCManager.sendRequest(TrDSRequest(workflowUrl + "/startProcess", "POST", JSON.stringify(varParams), startProcess_callback));
                }
            }
        });
        // }

    }

    function startProcess_callback(resp) {

        if (resp.httpResponseCode == 200) {
            isc.say("<spring:message code='course.set.on.workflow.engine'/>");
            ListGrid_Course_refresh()
        } else {
            isc.say("<spring:message code='workflow.bpmn.not.uploaded'/>");
        }
    }


    // ---------------------------------------- Send To Workflow ---------------------------------------->>

    // ------------------------------------------------- Functions ------------------------------------------>>
