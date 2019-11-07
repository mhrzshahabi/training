<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    var operational_method = "POST";


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

                    }
                },
                {
                    title: "<spring:message code="print.excel"/>",
                    icon: "<spring:url value="excel.png"/>",
                    click: function () {

                    }
                },
                {
                    title: "<spring:message code="print.html"/>",
                    icon: "<spring:url value="html.png"/>",
                    click: function () {

                    }
                }
            ]
        })
    }
    // ---------------------------------------- Create - contextMenu ---------------------------------------->>


    // <<-------------------------------------- Create - RestDataSource & ListGrid ----------------------------
    {
        var RestDataSource_operational = isc.TrDS.create({
            transformRequest: function (dsRequest) {
                dsRequest.httpHeaders = {
                    "Authorization": "Bearer <%= accessToken %>"
                };
                return this.Super("transformRequest", arguments);
            },
            fields:
                [
                    {name: "id", primaryKey: true},
                    {name: "unitCode"},
                    {name: "operationalUnit"}
                ],
            dataFormat: "json",
            fetchDataURL: operationalUnitUrl + "spec-list"
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
                    name: "unitCode",
                    title: "<spring:message code="unitCode"/>",
                    align: "center",
                    filterOperator: "contains"
                },
                {
                    name: "operationalUnit",
                    title: "<spring:message code="unitName"/>",
                    align: "center",
                    filterOperator: "contains"
                }
            ],
            doubleClick: function () {
                show_OperationalUnitEditForm();
            }
        });
    }
    // ---------------------------------------- Create - RestDataSource & ListGrid -------------------------->>


    // <<-------------------------------------- Create - ToolStripButton --------------------------------------
    {
        var ToolStripButton_Refresh = isc.ToolStripButton.create({
            icon: "[SKIN]/actions/refresh.png",
            title: "<spring:message code="refresh"/>",
            click: function () {
                ListGrid_operational.invalidateCache();
            }
        });

        var ToolStripButton_Add = isc.ToolStripButton.create({
            icon: "[SKIN]/actions/add.png",
            title: "<spring:message code="create"/>",
            click: function () {
                create_OperationalUnit();
            }
        });

        var ToolStripButton_Edit = isc.ToolStripButton.create({
            icon: "[SKIN]/actions/edit.png",
            title: "<spring:message code="edit"/>",
            click: function () {
                show_OperationalUnitEditForm();
            }
        });

        var ToolStripButton_Remove = isc.ToolStripButton.create({
            icon: "[SKIN]/actions/remove.png",
            title: "<spring:message code="remove"/>",
            click: function () {
                remove_OperationalUnit();
            }
        });

        var ToolStripButton_Print = isc.ToolStripButton.create({
            icon: "[SKIN]/RichTextEditor/print.png",
            title: "<spring:message code="print"/>",
            click: function () {

            }
        });

        var ToolStrip_operational = isc.ToolStrip.create({
            width: "100%",
            members: [ToolStripButton_Refresh, ToolStripButton_Add, ToolStripButton_Edit, ToolStripButton_Remove, ToolStripButton_Print]
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
                        required: true
                    },
                    {
                        name: "operationalUnit",
                        title: "<spring:message code="unitName"/>",
                        type: "text",
                        required: true
                    }
                ]
        });

        //*****create buttons*****
        var create_Buttons = isc.MyHLayoutButtons.create({
            members:
                [
                    isc.Button.create
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
                    isc.Button.create
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
            title: "<spring:message code="create"/> ",
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


    // <<-------------------------------------- Create - HLayout & VLayout ------------------------------------
    {
        var HLayout_Actions_operational = isc.HLayout.create({
            width: "100%",
            members: [ToolStrip_operational]
        });

        var Hlayout_Grid_operational = isc.HLayout.create({
            width: "100%",
            height: "100%",
            members: [ListGrid_operational]
        });

        var VLayout_Body_operational = isc.TrVLayout.create({
            width: "100%",
            height: "100%",
            members: [HLayout_Actions_operational, Hlayout_Grid_operational]
        });
    }
    // ---------------------------------------- Create - HLayout & VLayout ---------------------------------->>


    // <<----------------------------------------------- Functions --------------------------------------------
    {
        //*****open insert window*****
        function create_OperationalUnit() {
            operational_method = "POST";
            DynamicForm_OperationalUnit.clearValues();
            Window_OperationalUnit.setTitle("<spring:message code="create"/>");
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
                    message: "<spring:message code="msg.not.selected.record"/>",
                    icon: "[SKIN]ask.png",
                    title: "<spring:message code="course_Warning"/>",
                    buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            } else {

                operational_method = "PUT";
                DynamicForm_OperationalUnit.clearValues();
                DynamicForm_OperationalUnit.editRecord(record);
                Window_OperationalUnit.setTitle("<spring:message code="edit"/>");
                Window_OperationalUnit.show();
            }
        }

        //*****update function*****
        function edit_OperationalUnit() {
            let operationalUnitData = DynamicForm_OperationalUnit.getValues();
            let operationalUnitSaveUrl = operationalUnitUrl;
            if (operational_method.localeCompare("PUT") === 0) {
                let selectedRecord = ListGrid_operational.getSelectedRecord();
                operationalUnitSaveUrl += selectedRecord.id;
            }
            isc.RPCManager.sendRequest(TrDSRequest(operationalUnitSaveUrl, operational_method, JSON.stringify(operationalUnitData), show_OperationalUnitActionResult));
        }

        //*****delete function*****
        function remove_OperationalUnit() {
            var record = ListGrid_operational.getSelectedRecord();
            if (record == null || record.id == null) {
                isc.Dialog.create({
                    message: "<spring:message code="msg.not.selected.record"/>",
                    icon: "[SKIN]ask.png",
                    title: "<spring:message code="course_Warning"/>",
                    buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });
            } else {
                isc.MyYesNoDialog.create({
                    message: "<spring:message code="global.grid.record.remove.ask"/>",
                    buttonClick: function (button, index) {
                        this.close();
                        if (index == 0) {
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
            if (respCode == 200 || respCode == 201) {
                ListGrid_operational.invalidateCache();
                MyOkDialog_Operational = isc.MyOkDialog.create({
                    message: "<spring:message code="global.form.request.successful"/>"
                });

                close_MyOkDialog_Operational()
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

                    close_MyOkDialog_Operational()
                }
            }
        }

        //*****close dialog*****
        function close_MyOkDialog_Operational() {
            setTimeout(function () {
                MyOkDialog_Operational.close();
            }, 3000);
        }
    }
    // ------------------------------------------------- Functions ------------------------------------------>>


    //</script>