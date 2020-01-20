<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    // <<========== Global - Variables ==========
    {
        var evaluation_method = "POST";
    }
    // ============ Global - Variables ========>>

    // <<-------------------------------------- Create - contextMenu ------------------------------------------
    {
        Menu_ListGrid_evaluation_class = isc.Menu.create({
            data: [
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
                    name: "institute.titleFa",
                    title: "<spring:message code='presenter'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "course.evaluation",
                    title: "نوع ارزیابی",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    valueMap: {
                        "1": "واکنش",
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
                        "3": "پایان یافته",
                    },
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
            // ,
            // doubleClick: function () {
            //     show_OperationalUnitEditForm();
            // }
        });


        //*****VAKONESH*****
        var RestDataSource_evaluation_student = isc.TrDS.create({
            <%--transformRequest: function (dsRequest) {--%>
            <%--    dsRequest.httpHeaders = {--%>
            <%--        "Authorization": "Bearer <%= accessToken1 %>"--%>
            <%--    };--%>
            <%--    return this.Super("transformRequest", arguments);--%>
            <%--},--%>
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
                    title: "وضعیت ارزیابی واکنشی",
                    filterOperator: "iContains"
                },
                {
                    name: "evaluationStatusLearning",
                    title: "وضعیت ارزیابی یادگیری",
                    filterOperator: "iContains"
                },
                {
                    name: "evaluationStatusBehavior",
                    title: "وضعیت ارزیابی رفتاری",
                    filterOperator: "iContains"
                },
                {
                    name: "evaluationStatusResults",
                    title: "وضعیت ارزیابی نتایج",
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
            //,
            // gridComponents: [StudentTS_student, "filterEditor", "header", "body"]
            <%--,--%>
            <%-- dataChanged: function () {--%>
            <%--     this.Super("dataChanged", arguments);--%>
            <%--     totalRows = this.data.getLength();--%>
            <%--     if (totalRows >= 0 && this.data.lengthIsKnown()) {--%>
            <%--         StudentsCount_student.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");--%>
            <%--     } else {--%>
            <%--         StudentsCount_student.setContents("&nbsp;");--%>
            <%--     }--%>
            <%-- }--%>
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
            title: "صدور فرم",
            click: function () {
                print_Student_FormIssuance("pdf");
            }
        });

        var ToolStripButton_FormIssuanceForAll = isc.ToolStripButton.create({
            title: "صدور فرم برای همه",
            click: function () {
                alert("صدور فرم برای همه");
            }
        });

        var ToolStripButton_RefreshIssuance = isc.ToolStripButtonRefresh.create({
            title: "<spring:message code="refresh"/>",
            click: function () {
               ListGrid_evaluation_student.invalidateCache();
            }
        })

        var ToolStrip_evaluation = isc.ToolStrip.create({
            width: "100%",
            membersMargin: 5,
            members: [
                ToolStripButton_FormIssuance,
                ToolStripButton_FormIssuanceForAll,
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

        var Hlayout_Grid_evaluation = isc.HLayout.create({
            width: "100%",
            height: "100%",
            members: [ListGrid_evaluation_student]
        });

        var VLayout_Body_evaluation = isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [HLayout_Actions_evaluation, Hlayout_Grid_evaluation]
        });

        var Detail_Tab_Evaluation = isc.TabSet.create({
            ID: "tabSetEvaluation",
            tabBarPosition: "top",
            enabled: false,
            tabs: [
                {
                    id: "TabPane_Reaction",
                    title: "واکنش",
                    pane: VLayout_Body_evaluation
                }
                ,
                {
                    id: "TabPane_Learning",
                    title: "یادگیری",
                    pane: VLayout_Body_evaluation
                },
                {
                    id: "TabPane_Behavior",
                    title: "رفتار",
                    pane: VLayout_Body_evaluation
                },
                {
                    id: "TabPane_Results",
                    title: "نتایج",
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
        //*****open insert window*****
        function create_OperationalUnit() {
            evaluation_method = "POST";
            DynamicForm_OperationalUnit.clearValues();
            Window_OperationalUnit.show();
        }

        //*****insert function*****
        function save_OperationalUnit() {

            if (!DynamicForm_OperationalUnit.validate())
                return;

            let operationalUnitData = DynamicForm_OperationalUnit.getValues();
            let operationalUnitSaveUrl = operationalUnitUrl;

            isc.RPCManager.sendRequest(TrDSRequest(operationalUnitSaveUrl, evaluation_method, JSON.stringify(operationalUnitData), show_OperationalUnitActionResult));
        }

        //*****open update window*****
        function show_OperationalUnitEditForm() {

            let record = ListGrid_evaluation_class.getSelectedRecord();

            if (record == null || record.id == null) {
                isc.Dialog.create({
                    message: "<spring:message code="msg.no.records.selected"/>",
                    icon: "[SKIN]ask.png",
                    title: "<spring:message code="global.message"/>",
                    buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            } else {

                evaluation_method = "PUT";
                DynamicForm_OperationalUnit.clearValues();
                DynamicForm_OperationalUnit.editRecord(record);
                Window_OperationalUnit.show();
            }
        }

        //*****update function*****
        function edit_OperationalUnit() {
            let operationalUnitData = DynamicForm_OperationalUnit.getValues();
            let operationalUnitEditUrl = operationalUnitUrl;
            if (evaluation_method.localeCompare("PUT") === 0) {
                let selectedRecord = ListGrid_evaluation_class.getSelectedRecord();
                operationalUnitEditUrl += selectedRecord.id;
            }
            isc.RPCManager.sendRequest(TrDSRequest(operationalUnitEditUrl, evaluation_method, JSON.stringify(operationalUnitData), show_OperationalUnitActionResult));
        }

        //*****delete function*****
        function remove_OperationalUnit() {
            var record = ListGrid_evaluation_class.getSelectedRecord();
            if (record == null || record.id == null) {
                isc.Dialog.create({
                    message: "<spring:message code="msg.no.records.selected"/>",
                    icon: "[SKIN]ask.png",
                    title: "<spring:message code="global.message"/>",
                    buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            } else {
                isc.MyYesNoDialog.create({
                    message: "<spring:message code="global.grid.record.remove.ask"/>",
                    title: "<spring:message code="verify.delete"/>",
                    buttonClick: function (button, index) {
                        this.close();
                        if (index === 0) {
                            isc.RPCManager.sendRequest(TrDSRequest(operationalUnitUrl + record.id, "DELETE", null, show_OperationalUnitActionResult));
                        }
                    }
                });
            }

        }

        //*****show action result function*****
        var MyOkDialog_Operational;

        function show_OperationalUnitActionResult(resp) {
            var respCode = resp.httpResponseCode;
            if (respCode === 200 || respCode === 201) {
                ListGrid_evaluation_class.invalidateCache();
                MyOkDialog_Operational = isc.MyOkDialog.create({
                    message: "<spring:message code="global.form.request.successful"/>"
                });

                close_MyOkDialog_Operational();
                Window_OperationalUnit.close();

            } else {
                let respText = resp.httpResponseText;
                if (resp.httpResponseCode === 406) {

                    MyOkDialog_Operational = isc.MyOkDialog.create({
                        message: "<spring:message code="msg.record.duplicate"/>"
                    });

                    close_MyOkDialog_Operational()

                } else {

                    MyOkDialog_Operational = isc.MyOkDialog.create({
                        message: "<spring:message code="msg.operation.error"/>"
                    });

                    close_MyOkDialog_Operational();
                }
            }
        }

        //*****close dialog*****
        function close_MyOkDialog_Operational() {
            setTimeout(function () {
                MyOkDialog_Operational.close();
            }, 3000);
        }

        //*****print student form issuance*****
        function print_Student_FormIssuance(type) {

            let selectedStudent = ListGrid_evaluation_student.getSelectedRecord();

            if (selectedStudent !== null && selectedStudent !== undefined) {

                //*****print*****
                var advancedCriteria_unit = ListGrid_evaluation_student.getCriteria();
                var criteriaForm_operational = isc.DynamicForm.create({
                    method: "POST",
                    action: "<spring:url value="/operational-unit/printWithCriteria/"/>" + type,
                    target: "_Blank",
                    canSubmit: true,
                    fields:
                        [
                            {name: "CriteriaStr", type: "hidden"},
                            {name: "myToken", type: "hidden"}
                        ]
                });
                criteriaForm_operational.setValue("CriteriaStr", JSON.stringify(advancedCriteria_unit));
                criteriaForm_operational.setValue("myToken", "<%=accessToken%>");
                criteriaForm_operational.show();
                criteriaForm_operational.submitForm();

                //*****set evaluation status*****
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
        }

        //*****callback for print student form issuance*****
        function show_EvaluationActionResult(resp) {
            var respCode = resp.httpResponseCode;
            if (respCode === 200 || respCode === 201) {

                let selectedStudent = ListGrid_evaluation_student.getSelectedRecord();
                let gridState = "[{id:" + selectedStudent.id + "}]";

                ListGrid_evaluation_student.invalidateCache();

                MyOkDialog_Session = isc.MyOkDialog.create({
                    message: "<spring:message code="global.form.request.successful"/>"
                });

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
    // ------------------------------------------------- Functions ------------------------------------------>>


    //