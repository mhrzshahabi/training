<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>

    <%
        final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
    %>

    var equipmentMethod = "get";
    var equipmentHomeUrl = rootUrl + "/equipment";
    var equipmentActionUrl = equipmentHomeUrl;

    var Menu_ListGrid_Equipment = isc.Menu.create({
        width: 150,
        data: [
            <sec:authorize access="hasAuthority('Equipment_R')">
            {
                title: "<spring:message code='refresh'/>", icon: "<spring:url value="refresh.png"/>", click: function () {
                ListGrid_Equipment_refresh();
            }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('Equipment_C')">
            {
                title: "<spring:message code='create'/>", icon: "<spring:url value="create.png"/>", click: function () {
                ListGrid_Equipment_Add();
            }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('Equipment_U')">
            {
                title: "<spring:message code='edit'/>", icon: "<spring:url value="edit.png"/>", click: function () {
                ListGrid_Equipment_edit();
            }
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('Equipment_D')">
            {
                title: "<spring:message code='remove'/>", icon: "<spring:url value="remove.png"/>", click: function () {
                ListGrid_Equipment_remove();
            }
            }
            </sec:authorize>
        ]
    });

    var RestDataSource_Equipment = isc.TrDS.create({
        fields: [{name: "id"}, {name: "code"}, {name: "titleFa"}, {name: "titleEn"},
            {name: "description"}
        ],

        fetchDataURL: equipmentHomeUrl + "/spec-list"
    });

    var ListGrid_Equipment = isc.ListGrid.create({
        width: "100%",
        height: "100%",
        <sec:authorize access="hasAuthority('Equipment_R')">
        dataSource: RestDataSource_Equipment,
        </sec:authorize>
        contextMenu: Menu_ListGrid_Equipment,
        doubleClick: function () {
            ListGrid_Equipment_edit();
        },
        fields: [
            // {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "<spring:message code='code'/>", align: "center",autoFitWidth:true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "titleFa", title: "<spring:message code='global.titleFa'/>", align: "center"},
            {name: "titleEn", title: "<spring:message code='title.en'/> ", align: "center"},
            {name: "description", title: "<spring:message code='description'/> ", align: "center"}
        ],
        canAddFormulaFields: false,
        filterOnKeypress: true,

        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        // filterOnKeypress: false,
        sortFieldAscendingText: "<spring:message code='sort.ascending'/>",
        sortFieldDescendingText: "<spring:message code='sort.descending'/>",
        configureSortText: "<spring:message code='configureSortText'/>",
        autoFitAllText: "<spring:message code='autoFitAllText'/>",
        autoFitFieldText: "<spring:message code='autoFitFieldText'/>",
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>"
    });
    var DynamicForm_Equipment = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        setMethod: equipmentMethod,
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
       // showErrorText: true,
        showErrorStyle: true,
        errorOrientation: "right",
        colWidths: ["30%", "*"],
        titleAlign: "right",
        requiredMessage: "<spring:message code='msg.field.is.required'/>",
        numCols: 2,
        margin: 10,
        newPadding: 5,
        fields: [{name: "id", hidden: true},
            {
                name: "code",
                title: "<spring:message code='code'/>",
                type: 'text',
                keyPressFilter: "[a-z|A-Z|0-9 ]",
                length: "10",
                width: "300",
                validators: [ TrValidators.NotContainSpecialChar,TrValidators.NotContainSpecialWords ],
                required: true,
            },
            {
                name: "titleFa",
                title: "<spring:message code='global.titleFa'/>",
                required: true,
                type: 'text',
                hint: "Persian/فارسی",
                keyPressFilter: "^[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9|a-z|A-Z ]",
                length: "255",
                validators: [TrValidators.NotContainSpecialChar,TrValidators.NotContainSpecialWords,{
                    validateOnExit: true,
                    type: "lengthRange",
                    min: 1,
                    max: 255,
                    stopOnError: true,
                    errorMessage: "<spring:message code='msg.length.error'/>"
                }],
                width: "300"
            },

            {
                name: "titleEn",
                title: "<spring:message code='title.en'/> ",
                type: 'text',
                keyPressFilter: "[a-z|A-Z|0-9 ]",
                length: "255",
                hint: "Latin",
                validators: [TrValidators.NotContainSpecialChar,TrValidators.NotContainSpecialWords,{
                    validateOnExit: true,
                    type: "lengthRange",
                    min: 0,
                    max: 250,
                    stopOnError: true,
                    errorMessage: "<spring:message code='msg.length.error'/>"
                }],
                width: "300"
            },
            {
                name: "description",
                showHintInField: true,
                title: "<spring:message code='description'/>",
                length: "500",
                width: "300",
                validators: [ TrValidators.NotContainSpecialChar,TrValidators.NotContainSpecialWords,
                    {
                        type: "regexp",
                        errorMessage: "<spring:message code="msg.field.length"/>",
                        expression: /^.{2,150}$/

                    }],
                type: 'areaText'
            }
        ]
    });

    var IButton_Equipment_Save = isc.IButtonSave.create({
        top: 260, title: "<spring:message code='save'/>",
//icon: "pieces/16/save.png",
        click: function () {

            DynamicForm_Equipment.validate();
            if (DynamicForm_Equipment.hasErrors()) {
                return;
            }
            var data = DynamicForm_Equipment.getValues();
            isc.RPCManager.sendRequest({
                actionURL: equipmentActionUrl,
                httpMethod: equipmentMethod,
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                showPrompt: false,
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                data: JSON.stringify(data),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                            "<spring:message code="msg.command.done"/>");
                        setTimeout(function () {
                            OK.close();
                        }, 3000);
                        ListGrid_Equipment_refresh();
                        Window_Equipment.close();
                    } else {
                        var OK = createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>",
                            "<spring:message code="error"/>");
                        setTimeout(function () {
                            ERROR.close();
                        }, 3000);
                    }
                }
            });
        }
    });
    var EquipmentSaveOrExitHlayout = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        alignLayout: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_Equipment_Save, isc.IButtonCancel.create({
            ID: "equipmentEditExitIButton",
            title: "<spring:message code='cancel'/>",
            prompt: "",
            width: 100,
//icon: "<spring:url value="remove.png"/>",
            orientation: "vertical",
            click: function () {
                Window_Equipment.close();
            }
        })]
    });
    var Window_Equipment = isc.Window.create({
        title: "<spring:message code='equipment.plural'/>",
        width: 500,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: false,
        border: "1px solid gray",
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items: [isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [DynamicForm_Equipment, EquipmentSaveOrExitHlayout]
        })]
    });

    function ListGrid_Equipment_refresh() {
        var record = ListGrid_Equipment.getSelectedRecord();
        if (record == null || record.id == null) {
        } else {
            ListGrid_Equipment.selectRecord(record);
        }
        ListGrid_Equipment.invalidateCache();
    };

    function ListGrid_Equipment_remove() {


        var record = ListGrid_Equipment.getSelectedRecord();
//console.log(record);
        if (record == null) {
            isc.Dialog.create({
                message: "<spring:message code='msg.no.records.selected'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='message'/>",
                buttons: [isc.Button.create({title: "<spring:message code='ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            var Dialog_Delete = isc.Dialog.create({
                message: "<spring:message code='msg.record.remove.ask'/>",
                icon: "[SKIN]ask.png",
                title:  "<spring:message code='msg.remove.title'/>",
                buttons: [isc.IButtonSave.create({title: "<spring:message code='yes'/>"}), isc.IButtonCancel.create({
                    title: "<spring:message code='no'/>"
                })],
                buttonClick: function (button, index) {
                    this.close();

                    if (index == 0) {
                        var equipmentWait = isc.Dialog.create({
                            message: "<spring:message code='global.form.do.operation'/>",
                            icon: "[SKIN]say.png",
                            title: "<spring:message code='global.message'/>"
                        });
                        isc.RPCManager.sendRequest({
                            actionURL: equipmentHomeUrl + "/" + record.id,
                            httpMethod: "DELETE",
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            showPrompt: true,
                            serverOutputAsString: false,
                            callback: function (resp) {
                                equipmentWait.close();
                                if (resp.data == "true") {
                                    ListGrid_Equipment.invalidateCache();
                                    var OK = isc.Dialog.create({
                                        message: "<spring:message code="msg.operation.successful"/>",
                                        icon: "[SKIN]say.png",
                                        title:  "<spring:message code='message'/>"
                                    });
                                    setTimeout(function () {
                                        OK.close();
                                    }, 2000);
                                } else {
                                    var ERROR = isc.Dialog.create({
                                        message:"<spring:message code='msg.student.remove.error'/>",
                                        icon: "[SKIN]stop.png",
                                        title:  "<spring:message code='message'/>"
                                    });
                                    setTimeout(function () {
                                        ERROR.close();
                                    }, 2000);
                                }
                            }
                        });
                    }
                }
            });
        }


    };

    function ListGrid_Equipment_Add() {
        equipmentMethod = "POST";
        equipmentActionUrl = equipmentHomeUrl;
        DynamicForm_Equipment.clearValues();
        Window_Equipment.setTitle("<spring:message code="equipment.new"/>");
        Window_Equipment.show();
    };

    function ListGrid_Equipment_edit() {
        var record = ListGrid_Equipment.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "<spring:message code='msg.no.records.selected'/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code='message'/>",
                buttons: [isc.Button.create({title: "<spring:message code='ok'/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            equipmentMethod = "PUT";
            DynamicForm_Equipment.clearFieldErrors("titleFa", true);
            DynamicForm_Equipment.clearValues();
            equipmentActionUrl = equipmentHomeUrl + "/" + record.id;
            DynamicForm_Equipment.editRecord(record);
            // Window_Equipment.setTitle("ویرایش تجهیز کمک آموزشی '" + record.titleFa + "'");
            Window_Equipment.setTitle("<spring:message code="equipment.edit"/> \'" + record.titleFa + "\'");

            Window_Equipment.show();
        }
    };

    var ToolStripButton_Refresh = isc.ToolStripButtonRefresh.create({
// icon: "<spring:url value="refresh.png"/>",
        title: "<spring:message code='refresh'/>",
        click: function () {
            ListGrid_Equipment_refresh();
        }
    });
    var ToolStripButton_Edit = isc.ToolStripButtonEdit.create({
//icon: "[SKIN]/actions/edit.png",
        title: "<spring:message code='edit'/>",
        click: function () {
            ListGrid_Equipment_edit();
        }
    });
    var ToolStripButton_Add = isc.ToolStripButtonAdd.create({

        title: "<spring:message code='add'/>",
        click: function () {
            ListGrid_Equipment_Add();
        }
    });
    var ToolStripButton_Remove = isc.ToolStripButtonRemove.create({
//icon: "[SKIN]/actions/remove.png",
        title: "<spring:message code='remove'/>",
        click: function () {
            ListGrid_Equipment_remove();
        }
    });

    let ToolStrip_Equipment_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = ListGrid_Equipment.getCriteria();
                    ExportToFile.downloadExcel(null, ListGrid_Equipment , "Equipment", 0, null, '',"لیست تجهیزات کمک آموزشی - آموزش"  , criteria, null);
                }
            })
        ]
    });

    var ToolStrip_Actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            <sec:authorize access="hasAuthority('Equipment_C')">
            ToolStripButton_Add,
            </sec:authorize>
            <sec:authorize access="hasAuthority('Equipment_U')">
            ToolStripButton_Edit,
            </sec:authorize>
            <sec:authorize access="hasAuthority('Equipment_D')">
            ToolStripButton_Remove,
            </sec:authorize>
            <sec:authorize access="hasAuthority('Equipment_P')">
            ToolStrip_Equipment_Export2EXcel,
            </sec:authorize>
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    <sec:authorize access="hasAuthority('Equipment_R')">
                    ToolStripButton_Refresh
                    </sec:authorize>
                ]
            })
        ]
    });
    var HLayout_Actions = isc.HLayout.create({width: "100%", members: [ToolStrip_Actions]});
    var HLayout_Grid = isc.HLayout.create({width: "100%", height: "100%", members: [ListGrid_Equipment]});
    var VLayout_Body = isc.VLayout.create({width: "100%", height: "100%", members: [HLayout_Actions, HLayout_Grid]});