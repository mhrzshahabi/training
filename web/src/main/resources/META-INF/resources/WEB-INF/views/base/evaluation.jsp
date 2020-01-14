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
        var operational_method = "POST";
    }
    // ============ Global - Variables ========>>

    // <<-------------------------------------- Create - contextMenu ------------------------------------------
    {
        Menu_ListGrid_operational = isc.Menu.create({
            data: [
                {
                    title: "<spring:message code="refresh"/>",
                    icon: "<spring:url value="refresh.png"/>",
                    click: function () {
                        ListGrid_operational.invalidateCache();
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
                        print_OperationalUnitListGrid("pdf");
                    }
                },
                {
                    title: "<spring:message code="print.excel"/>",
                    icon: "<spring:url value="excel.png"/>",
                    click: function () {
                        print_OperationalUnitListGrid("excel");
                    }
                },
                {
                    title: "<spring:message code="print.html"/>",
                    icon: "<spring:url value="html.png"/>",
                    click: function () {
                        print_OperationalUnitListGrid("html");
                    }
                }
            ]
        })
    }
    // ---------------------------------------- Create - contextMenu ---------------------------------------->>


    // <<-------------------------------------- Create - RestDataSource & ListGrid ----------------------------
    {

        var RestDataSource_operational = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true},
                {name: "group"},
                {name: "titleClass"},
                {name: "startDate"},
                {name: "endDate"},
                {name: "code"},
                {name: "term.titleFa"},
                {name: "course.titleFa"},
                {name: "course.id"},
                {name: "teacherId"},
                {name: "teacher"},
                {name: "reason"},
                {name: "classStatus"},
                {name: "topology"},
                {name: "trainingPlaceIds"},
                {name: "instituteId"},
                {name: "workflowEndingStatusCode"},
                {name: "workflowEndingStatus"}
            ],
            fetchDataURL: classUrl + "spec-list"
        });

        var ListGrid_operational = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_operational,
            contextMenu: Menu_ListGrid_operational,
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
                    name: "group",
                    title: "<spring:message code='group'/>",
                    align: "center",
                    filterOperator: "equals",
                    autoFitWidth: true
                },
                {
                    name: "teacher",
                    title: "<spring:message code='teacher'/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "reason", title: "<spring:message code='training.request'/>", align: "center",
                    valueMap: {
                        "1": "نیازسنجی",
                        "2": "درخواست واحد",
                        "3": "نیاز موردی",
                    },
                },
                {
                    name: "classStatus", title: "<spring:message code='class.status'/>", align: "center",
                    valueMap: {
                        "1": "برنامه ریزی",
                        "2": "در حال اجرا",
                        "3": "پایان یافته",
                    },
                },
                {
                    name: "topology", title: "<spring:message code='place.shape'/>", align: "center", valueMap: {
                        "1": "U شکل",
                        "2": "عادی",
                        "3": "مدور",
                        "4": "سالن"
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
            doubleClick: function () {
                show_OperationalUnitEditForm();
            }
        });
    }
    // ---------------------------------------- Create - RestDataSource & ListGrid -------------------------->>


    // <<-------------------------------------- Create - ToolStripButton --------------------------------------
    {
        var ToolStripButton_Refresh = isc.ToolStripButtonRefresh.create({
// icon: "[SKIN]/actions/refresh.png",
            title: "<spring:message code="refresh"/>",
            click: function () {
                ListGrid_operational.invalidateCache();
            }
        });

        var ToolStripButton_Add = isc.ToolStripButtonAdd.create({

            title: "<spring:message code="create"/>",
            click: function () {
                create_OperationalUnit();
            }
        });

        var ToolStripButton_Edit = isc.ToolStripButtonEdit.create({

            title: "<spring:message code="edit"/>",
            click: function () {
                show_OperationalUnitEditForm();
            }
        });

        var ToolStripButton_Remove = isc.ToolStripButtonRemove.create({

            title: "<spring:message code="remove"/>",
            click: function () {
                remove_OperationalUnit();
            }
        });

        var ToolStripButton_Print = isc.ToolStripButtonPrint.create({
//icon: "[SKIN]/RichTextEditor/print.png",
            title: "<spring:message code="print"/>",
            click: function () {
                print_OperationalUnitListGrid("pdf");
            }
        });

        var ToolStrip_operational = isc.ToolStrip.create({
            width: "100%",
            membersMargin: 5,
            members: [
                ToolStripButton_Add,
                ToolStripButton_Edit,
                ToolStripButton_Remove,
                ToolStripButton_Print,
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
                            if (operational_method === "POST") {
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
    var Detail_Tab_Evaluation = isc.TabSet.create({
        ID: "tabSetEvaluation",
        tabBarPosition: "top",
        tabs: [
            {
                // id: "TabPane_Goal_Syllabus",
                title: "واکنش"
            },
            {
                // id: "TabPane_Job",
                title: "یادگیری"
            },
            {
                // id: "TabPane_Post",
                title: "رفتار"
            },
            {
                // id: "TabPane_Skill",
                title: "نتایج"

            }
        ]

    });
    // ---------------------------------------- Create - TabSet & Tab --------------------------------------->>

    // <<-------------------------------------- Create - HLayout & VLayout ------------------------------------
    {
        var HLayout_Actions_operational = isc.HLayout.create({
            width: "100%",
            height:"1%",
            members: [ToolStrip_operational]
        });

        var Hlayout_Grid_operational = isc.HLayout.create({
            width: "100%",
            height: "50%",
            showResizeBar: true,
            members: [ListGrid_operational]
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
            operational_method = "POST";
            DynamicForm_OperationalUnit.clearValues();
            Window_OperationalUnit.show();
        }

//*****insert function*****
        function save_OperationalUnit() {

            if (!DynamicForm_OperationalUnit.validate())
                return;

            let operationalUnitData = DynamicForm_OperationalUnit.getValues();
            let operationalUnitSaveUrl = operationalUnitUrl;

            isc.RPCManager.sendRequest(TrDSRequest(operationalUnitSaveUrl, operational_method, JSON.stringify(operationalUnitData), show_OperationalUnitActionResult));
        }

//*****open update window*****
        function show_OperationalUnitEditForm() {

            let record = ListGrid_operational.getSelectedRecord();

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

                operational_method = "PUT";
                DynamicForm_OperationalUnit.clearValues();
                DynamicForm_OperationalUnit.editRecord(record);
                Window_OperationalUnit.show();
            }
        }

//*****update function*****
        function edit_OperationalUnit() {
            let operationalUnitData = DynamicForm_OperationalUnit.getValues();
            let operationalUnitEditUrl = operationalUnitUrl;
            if (operational_method.localeCompare("PUT") === 0) {
                let selectedRecord = ListGrid_operational.getSelectedRecord();
                operationalUnitEditUrl += selectedRecord.id;
            }
            isc.RPCManager.sendRequest(TrDSRequest(operationalUnitEditUrl, operational_method, JSON.stringify(operationalUnitData), show_OperationalUnitActionResult));
        }

//*****delete function*****
        function remove_OperationalUnit() {
            var record = ListGrid_operational.getSelectedRecord();
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
                ListGrid_operational.invalidateCache();
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

//*****print*****
        function print_OperationalUnitListGrid(type) {
            var advancedCriteria_unit = ListGrid_operational.getCriteria();
            var criteriaForm_course = isc.DynamicForm.create({
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
            criteriaForm_course.setValue("CriteriaStr", JSON.stringify(advancedCriteria_unit));
            criteriaForm_course.setValue("myToken", "<%=accessToken%>");
            criteriaForm_course.show();
            criteriaForm_course.submitForm();
        }
    }
    // ------------------------------------------------- Functions ------------------------------------------>>


    //</script>