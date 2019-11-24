<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
<%--<script>--%>
    var CheckList_method = "POST";
    var CheckListItem_method = "POST";
    var totalRows;

    var RestDataSource_CheckList = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"},
        ],
        fetchDataURL: checklistUrl + "spec-list?_startRow=0&_endRow=1000",
    });

    var RestDataSource_ClassCheckList = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"},
        ],

    });

    var RestDataSource_Class_Item = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "checkListItem.titleFa", title: "<spring:message code="title"/>", align: "center"},
            {name: "description", title: "<spring:message code="description"/>", align: "center"},
            {name: "enableStatus", title: "<spring:message code="status"/>", align: "center"},
        ],

        fetchDataURL: classCheckListUrl + "spec-list?_startRow=0&_endRow=1000",
        updateDataURL: classCheckListUrl + "edit",
    });


    var RestDataSource_SelectCheckList = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"}
        ],
        fetchDataURL: checklistUrl + "spec-list",
    });


    var RestDataSource_CheckListItem = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {name: "checkListId", hidden: true},
            {name: "titleFa", title: "<spring:message code="item"/>", align: "center"},
            {name: "group", title: "<spring:message code="group"/>", align: "center"},
            {name: "isDeleted", hidden: true}
        ],
    });

    Menu_ListGrid_CheckList = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    ListGrid_CheckList.invalidateCache();
                }
            }, {
                title: "<spring:message code="create"/>", icon: "<spring:url value="create.png"/>", click: function () {
                    show_CheckListAddForm();
                }
            }, {
                title: "<spring:message code="edit"/>", icon: "<spring:url value="edit.png"/>", click: function () {
                    show_CheckListEditForm();
                }
            }, {
                title: "<spring:message code="remove"/>", icon: "<spring:url value="remove.png"/>", click: function () {
                    show_CheckListDeleteForm();
                }
            }]
    });

    Menu_ListGrid_CheckListItem = isc.Menu.create({
        data: [
            {
                title: "<spring:message code="refresh"/>",
                icon: "<spring:url value="refresh.png"/>",
                click: function () {
                    ListGrid_CheckListItem.invalidateCache();
                    ListGrid_CheckListItem_DetailViewer.setData([]);
                }
            }, {
                title: "<spring:message code="create"/>", icon: "<spring:url value="create.png"/>", click: function () {
                    show_CheckListItemAddForm();
                }
            }, {
                title: "<spring:message code="edit"/>", icon: "<spring:url value="edit.png"/>", click: function () {
                    show_CheckListItemEditForm();
                }
            }, {


                title: "<spring:message code="deactivate"/>",
                icon: "<spring:url value="remove.png"/>",
                click: function () {
                    is_Delete();
                }
            }]
    });


    var ToolStripButton_CheckList_Refresh = isc.ToolStripButton.create({
        icon: "<spring:url value="refresh.png"/>",
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_CheckList.invalidateCache(ListGrid_CheckListItem.setData([]));
            totalRecords_Item.setContents("تعداد آیتم ها" + ":&nbsp;<b>" + "" + "</b>");
        }
    });
    var ToolStripButton_CheckList_Edit = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "<spring:message code="edit"/>",
        click: function () {
            show_CheckListEditForm();
        }
    });
    var ToolStripButton_CheckList_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "<spring:message code="create"/>",
        click: function () {
            show_CheckListAddForm();
        }
    });
    var ToolStripButton_CheckList_Remove = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "<spring:message code="remove"/>",
        click: function () {
            show_CheckListDeleteForm();
        }
    });
    //---------------------------------------------------------------------------
    var ToolStripButton_CheckListItem_Refresh = isc.ToolStripButton.create({
        icon: "<spring:url value="refresh.png"/>",
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_CheckListItem.invalidateCache();
            ListGrid_CheckListItem_DetailViewer.setData([]);
        }
    });
    var ToolStripButton_CheckListItem_Edit = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "<spring:message code="edit"/>",
        click: function () {
            show_CheckListItemEditForm();
        }
    });
    var ToolStripButton_CheckListItem_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "<spring:message code="create"/>",
        click: function () {
            show_CheckListItemAddForm();
        }
    });
    var ToolStripButton_CheckListItem_Remove = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "<spring:message code="deactivate"/>",
        click: function () {
            is_Delete();
        }
    });

    var ToolStripButton_CheckListItem_Space = isc.LayoutSpacer.create({
        width: "150",
    });
    var ToolStripButton_CheckListItem_Label = isc.Label.create({
        ID: "totalRecords_Item",

    });

    //============================================================================

    isc.ToolStrip.create({
        ID: "gridEditControls",
        width: "100%", height: 24,
        members: [
            isc.Label.create({
                padding: 5,
                ID: "totalsLabel"
            }),
            isc.LayoutSpacer.create({width: "*"}),
            isc.ToolStripButton.create({
                icon: "[SKIN]/actions/edit.png",
                prompt: "Edit selected record",
                click: function () {
                    var record = ListGrid_CheckList.getSelectedRecord();
                    if (record == null) return;
                    ListGrid_CheckList.startEditing(ListGrid_CheckList.data.indexOf(record));
                }
            }),
            isc.ToolStripButton.create({
                icon: "[SKIN]/actions/remove.png",
                prompt: "Remove selected record",
                click: function () {
                    var record = ListGrid_CheckList.getSelectedRecord();
                    if (record == null) return;
                }
            })
        ]
    });

    var ListGrid_CheckListItem = isc.TrLG.create({
        filterOperator: "iContains",
        alternateRecordStyles: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        showFilterEditor: true,
        contextMenu: Menu_ListGrid_CheckListItem,
        dataSource: RestDataSource_CheckListItem,
        fields: [
            {name: "id", hidden: true},
            {name: "checkListId", hidden: true},
            {name: "titleFa",  title: "<spring:message code="item"/>", width: "80%"},
            {name: "group", title: "<spring:message code="group"/>", width: "20%"},
            {name: "isDeleted", hidden: true}],
        getCellCSSText: function (record, rowNum, colNum) {
            if (record.isDeleted) {
                return "color:red;font-size: 12px;";
            }
        },

        recordClick: function (ListGrid, ListGridRecord, number, ListGridField, number, any, any) {
            return ListGrid_CheckListItem_DetailViewer.setData(ListGridRecord);
        },
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {

                totalRecords_Item.setContents("<spring:message code="number.of.Items"/>" + ":&nbsp;<b>" + totalRows + "</b>");

            } else {
                totalRecords_Item.setContents("&nbsp;");
            }
        },
    });

    var ListGrid_CheckList = isc.TrLG.create({
        filterOperator: "iContains",
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        showFilterEditor: true,
        dataSource: RestDataSource_CheckList,
        contextMenu: Menu_ListGrid_CheckList,
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa", title: "<spring:message code="form"/>", align: "center"},
        ],
        click: function () {
            var record = ListGrid_CheckList.getSelectedRecord();
            RestDataSource_CheckListItem.fetchDataURL = checklistUrl + record.id + "/getCheckListItem";
            ListGrid_CheckListItem.fetchData();
            ListGrid_CheckListItem.invalidateCache();
        },
        selectionUpdated: function () {
            ListGrid_CheckListItem_DetailViewer.setData([])
        },
        autoFetchData: true,

    });


    var ListGrid_CheckListItem_DetailViewer = isc.DetailViewer.create({
        autoFetchData: true,
        ID: "ListGrid_CheckListItem_DetailViewer",
        width: "100%",
        fields: [
            {name: "titleFa", title: "<spring:message code="title"/>"},
            {
                name: "group", title: "<spring:message code="group"/>",
                formatCellValue: function (value, record, rowNum, colNum, grid) {
                    if (typeof value === "undefined")
                        return "ندارد"; else return value;
                },
                length: "250"
            },
        ],
        emptyMessage: " "
    })


    //============================================================================
    var ToolStrip_Actions_CheckList = isc.ToolStrip.create({
        width: "40%",
        members: [ToolStripButton_CheckList_Refresh, ToolStripButton_CheckList_Add, ToolStripButton_CheckList_Edit, ToolStripButton_CheckList_Remove]
    });

    var ToolStrip_Actions_CheckListItem = isc.ToolStrip.create({
        width: "100%",
        members: [ToolStripButton_CheckListItem_Refresh, ToolStripButton_CheckListItem_Add, ToolStripButton_CheckListItem_Edit, ToolStripButton_CheckListItem_Remove, ToolStripButton_CheckListItem_Space, ToolStripButton_CheckListItem_Label]
    });


    HLayout_Action_CheckListItem = isc.HLayout.create({
        width: "100%",
        height: "3%",
        <%--border: "2px solid blue",--%>
        members: [ToolStrip_Actions_CheckListItem]
    });


    var HLayout_Action_CheckList = isc.HLayout.create({
//width: "20%",
        height: "3%",

        <%--border: "2px solid blue",--%>
        members: [ToolStrip_Actions_CheckList]
    });
    //========================DynamicForm==============================

    var DynamicForm_CheckList = isc.DynamicForm.create({
        ID: "DynamicForm_CheckList_Add",
        padding: 6,
        hiliteIconRightPadding: 4,
        titleAlign: "right",
        fields: [{name: "id", hidden: true},
            {
                name: "titleFa",
                title: "<spring:message code="title"/>",
                required: true,
                type: 'text',
                height: 35,
                width: "171",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber, TrValidators.NotContainSpecialChar]
            },
        ]
    });

    var DynamicForm_CheckListItem_Add = isc.DynamicForm.create({
        ID: "DynamicForm_CheckListItem_Add",
        titleAlign: "center",
        wrapTitle: true,

        fields:
            [
                {name: "id", hidden: true},
                {name: "checkListId", hidden: true},
                {
                    name: "titleFa",
                    title: "<spring:message code="title"/>",
                    type: 'text',
                    required: true,
                    height: 35,
                    requiredMessage: "در نام فارسی می توانید از عدد و حروف انگلیسی هم استفاده کنید",
                    width: "*",
                },
                {name: "group", title: "<spring:message code="group"/>", type: 'text', height: 35, width: "*"},
            ]
    });

    //=================================================================


    var VLayout_Body_CheckListItem = isc.VLayout.create({
        width: "100%",
        height: "100%",

        members: [HLayout_Action_CheckListItem, ListGrid_CheckListItem, ListGrid_CheckListItem_DetailViewer],
    });


    var VLayout_Body_CheckList = isc.VLayout.create({
        width: "50%",
        height: "100%",
        members: [HLayout_Action_CheckList, ListGrid_CheckList],
    });

    //=================================================================
    var HLayout_Body = isc.HLayout.create({
        width: "100%",
        showEdges: true,
        members: [VLayout_Body_CheckList, VLayout_Body_CheckListItem]
    });


    //==========================================Window========================
    var Window_CheckList_Design = isc.Window.create({
        title: "<spring:message code="checkList.Design"/>",
        minWidth: 1024,
        autoSize: false,
        width: 1000,
        height: 500,
        closeClick: function () {
            this.hide();
        },
        show: function () {
            this.Super("show", arguments);
// ListGrid_CheckList.fetchData();
// ListGrid_CheckList.refreshCells();

// ListGrid_CheckListItem.fetchData();
// ListGrid_CheckListItem.refreshCells();
        },
        items: [isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [HLayout_Body]
        })],
    });


    var Window_CheckList_Add = isc.Window.create({
        width: 300,
        items: [DynamicForm_CheckList, isc.MyHLayoutButtons.create({
            members: [isc.Button.create({
                title: "<spring:message code="save"/>",
                icon: "pieces/16/save.png",
                click: function () {
                    if (CheckList_method === "POST") {
                        save_CheckList()
                    } else {
                        edit_CheckList();

                    }
                }
            }), isc.Button.create({
                title: "<spring:message code="cancel"/>",
                icon: "[SKIN]ask.png",
                click: function () {
                    Window_CheckList_Add.close();
                }
            })],
        }),]
    });

    var Window_CheckListItem_Add = isc.Window.create({
        width: 500,
        items: [DynamicForm_CheckListItem_Add, isc.MyHLayoutButtons.create({
            members: [isc.Button.create({
                title: "<spring:message code="save"/>",
                icon: "pieces/16/save.png",
                click: function () {
                    if (CheckListItem_method === "POST") {
                        save_CheckListItem()
                    } else {
                        edit_CheckListItem();
                    }
                }
            }), isc.Button.create({
                title: "<spring:message code="cancel"/>",
                icon: "[SKIN]ask.png",
                click: function () {
                    Window_CheckListItem_Add.close();
                }
            })],
        }),]
    });

    //================================= تکمیل چک لیست===============================================تکمیل چک لیست=========================================تکمیل چک لیست======================================تکمیل چک لیست=====================
    var ListGrid_Class_Item = isc.ListGrid.create({
        showRowNumbers: false,
        alternateRecordStyles: true,
        showFilterEditor: false,
        autoFetchData: true,
        editEvent: "click",
        editByCell: true,
        modalEditing: true,
        height: 500,
        showGroupSummary: true,
        showGroupSummaryInHeader: true,
        groupStartOpen: "all",
        groupByField: ['checkListItem.group'],
        nullGroupTitle: "",
        dataSource: RestDataSource_Class_Item,
        fields: [
            {name: "checkListItem.group", title: "<spring:message code="group"/>", align: "center", hidden: true},
            {name: "id", primaryKey: true, hidden: true},
            {name: "checkListItem.titleFa", title: "<spring:message code="title"/>", canEdit: false, align: "center"},

            {
                name: "description",
                title: "<spring:message code="description"/>",
                canEdit: true,
                align: "center",
                change: function (form, item, value) {
                    if (value == null) {
                        item.setValue("")
                    }
                }

            },
            {
                name: "enableStatus",
                title: "<spring:message code="active/deactivate"/>",
                canEdit: true,
                type: "boolean",
                align: "center"
            },
        ],

    });


    var HLayOut_thisCommittee_AddUsers_Jsp = isc.HLayout.create({
        width: "100%",
        border: "0px solid yellow",
        align: "center",
        members: [ListGrid_Class_Item]
    });
    var VLayOut_User_Committee_Jsp = isc.VLayout.create({
        width: "100%",
        autoDraw: false,
        border: "3px solid gray", layoutMargin: 5,
        members: [HLayOut_thisCommittee_AddUsers_Jsp]
    });

    var Window_Add_User_TO_Committee = isc.Window.create({
        minWidth: 1024,
        title: "<spring:message code="complete.checkList"/>",
        width: 1024,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,
        closeClick: function () {
            this.hide();
        },
        items: [
            VLayOut_User_Committee_Jsp
        ]
    });

    //================================== تب چک لیست =====================================


    var ListGrid_ClassCheckList = isc.TrLG.create({
        selectionType: "none",
        showFilterEditor: false,
        dataSource: RestDataSource_ClassCheckList,
        styleName: "myparent",
// showRowNumbers:false,
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa", title: "<spring:message code="form"/>", align: "center"},
        ],


    })

    var DynamicForm_ClassCheckList = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        numCols: 6,
        padding: 20,
        colWidths: ["1%", "30%", "49%", "20%", "30"],
        items: [
            {
                name: "checkList",
                ID: "checkListDynamicFormField",
                title: "<spring:message code="selectForm"/>",
                editorType: "ComboBoxItem",
                filterOperator: "iContains",
                changeOnKeypress: true,
                textMatchStyle: "startsWith",
                textAlign: "center",
                optionDataSource: RestDataSource_SelectCheckList,
                width: "270",
                filterOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                filterFields: ["titleFa"],
                pickListFields: [
                    {
                        name: "titleFa",
                        changeOnKeypress: true,
                        filterOperator: "iContains"
                    }
                ],
                changed: function (form, item, value) {

                },

            },

            {
                type: "button",
                title: "<spring:message code="add.complete.checkList"/>",
                icon: "<spring:url value="check-mark.png"/>",
                width: 180,
                showDownIcon: true,
                startRow: false,
                endRow: false,
                click: function () {
                    if (!checkselected()) {
                        return;
                    }
                    var a1 = ListGrid_Class_JspClass.getSelectedRecord().id;
                    var a2 = checkListDynamicFormField.getValue();

                    isc.RPCManager.sendRequest(TrDSRequest(classCheckListUrl + "fill-Table/" + a1.toString() + "/" + a2.toString(), "GET", null, "callback:fill(rpcResponse)"));
                }
            },
            {
                type: "SpacerItem",

            },
            {
                type: "button",
                title: "<spring:message code="checkList.Design"/>",
                icon: "<spring:url value="editCheckList.png"/>",
                iconOrientation: "right",
                showDownIcon: true,
                width: 150,
                startRow: false,
                endRow: true,
                click: function () {
                    Window_CheckList_Design.show();
                }
            },
        ]
    })


    var HLayout_Body_Top = isc.HLayout.create({
        width: "100%",
        height: "50%",

        members: [DynamicForm_ClassCheckList],
    });


    var HLayout_Body_Down = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_ClassCheckList],
    });


    var All_Body = isc.VLayout.create({
        width: "100%",
        showEdges: true,
        members: [HLayout_Body_Top, HLayout_Body_Down]
    });

    //========================================FUNCTION=======================================


    function is_Delete() {
        var record = ListGrid_CheckListItem.getSelectedRecord();
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
                message: "<spring:message code="msg.record.deactivate.ask"/>",
                buttonClick: function (button, index) {
                    this.close();
                    if (index == 0) {
                        var CheckListItem_Save_Url = checklistItemUrl;
                        isc.RPCManager.sendRequest(TrDSRequest(CheckListItem_Save_Url + "is_Delete/" + record.id, "PUT", JSON.stringify(record), "callback:show_CheckListItem_is_Delete(rpcResponse)"));
                    }
                }
            });
        }
    }

    function fill(resp) {
        checkselected();
        var a1 = checkListDynamicFormField.getValue();
        var a2 = ListGrid_Class_JspClass.getSelectedRecord().id;

        ListGrid_Class_Item.fetchData(
            {
                operator: "and", criteria: [
                    {fieldName: "tclassId", operator: "equals", value: a2},
                    {fieldName: "checkListItem.checkListId", operator: "equals", value: a1},
                ]
            }
        );
        Window_Add_User_TO_Committee.show();
        setTimeout(function () {
            ListGrid_ClassCheckList.fetchData();
            ListGrid_ClassCheckList.invalidateCache();
        }, 2000);

    }
    ;

    function checkselected() {
        if (ListGrid_Class_JspClass.getSelectedRecord() == null) {
            {
                var OK = isc.Dialog.create({
                    message: "<spring:message code="msg.record.select.class.ask"/>",
                    icon: "[SKIN]say.png",
                    title: "<spring:message code="global.form.command.done"/>",
                });
                setTimeout(function () {
                    OK.close();
                }, 3000);
                return false;
            }

        }

        if (typeof (checkListDynamicFormField.getValue()) === "undefined") {
            var OK = isc.Dialog.create({
                message: "<spring:message code="msg.select.form.ask"/>",
                icon: "[SKIN]say.png",
                title: "<spring:message code="global.form.command.done"/>",
            });
            setTimeout(function () {
                OK.close();
            }, 3000);
            return false;
        }
        return true;
    };

    function save_CheckList() {
        if (!DynamicForm_CheckList.validate()) {
            return;
        }
        var CheckList = DynamicForm_CheckList.getValues();
        var CheckList_Save_Url = checklistUrl;
        if (CheckList_method.localeCompare("PUT") == 0) {
            var Record = DynamicForm_CheckList.getSelectedRecord();
            CheckList_Save_Url += Record.id;
        }
        isc.RPCManager.sendRequest(TrDSRequest(CheckList_Save_Url, CheckList_method, JSON.stringify(CheckList), "callback:show_checkListDynamicFormField(rpcResponse)"));
    };

    function save_CheckListItem() {
        if (!DynamicForm_CheckListItem_Add.validate()) {
            return;
        }
        var CheckListItem = DynamicForm_CheckListItem_Add.getValues();
        var checklistItem_Save_Url = checklistItemUrl;
        isc.RPCManager.sendRequest(TrDSRequest(checklistItem_Save_Url, CheckListItem_method, JSON.stringify(CheckListItem), "callback:show_CheckListItemActionResult(rpcResponse)"));
    };

    function edit_CheckList() {
        if (!DynamicForm_CheckList.validate()) {
            return;
        }
        var record = ListGrid_CheckList.getSelectedRecord();
        data = DynamicForm_CheckList.getValues();
        var CheckList_Save_Url = checklistUrl;
        isc.RPCManager.sendRequest(TrDSRequest(CheckList_Save_Url + record.id, CheckList_method, JSON.stringify(data), "callback:show_CheckListActionResult(rpcResponse)"));
    }


    function edit_CheckListItem() {
        if (!DynamicForm_CheckListItem_Add.validate()) {
            return;
        }
        var record = ListGrid_CheckListItem.getSelectedRecord();
        data = DynamicForm_CheckListItem_Add.getValues();
        var CheckList_Edit_Url = checklistItemUrl;
        isc.RPCManager.sendRequest(TrDSRequest(CheckList_Edit_Url + record.id, CheckListItem_method, JSON.stringify(data), "callback:show_CheckListItemActionResult(rpcResponse)"));
    }

    function show_CheckListAddForm() {
        CheckList_method = "POST";
        DynamicForm_CheckList.clearValues();
        Window_CheckList_Add.setTitle("<spring:message code="create.checklistTitle"/>)
        Window_CheckList_Add.show();


    };

    function show_CheckListItemAddForm() {
        var SelectedCheckList = ListGrid_CheckList.getSelectedRecord();
        if (SelectedCheckList == null || SelectedCheckList.id == null) {
            isc.Dialog.create({
                message: "<spring:message code="msg.select.form.ask"/>",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            CheckListItem_method = "POST";
            DynamicForm_CheckListItem_Add.clearValues();
            DynamicForm_CheckListItem_Add.getItem("checkListId").setValue(SelectedCheckList.id);
            Window_CheckListItem_Add.setTitle("<spring:message code="create"/>");
            Window_CheckListItem_Add.show();
        }
    };


    function show_CheckListDeleteForm() {
        var record = ListGrid_CheckList.getSelectedRecord();
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
                message: "global.grid.record.remove.ask",
                buttonClick: function (button, index) {
                    this.close();
                    if (index == 0) {
                        var CheckList_Save_Url = checklistUrl;
                        isc.RPCManager.sendRequest(TrDSRequest(CheckList_Save_Url + "delete/" + record.id, "DELETE", null, "callback:show_CheckListActionResult_Delete(rpcResponse)"));
                    }
                }
            });
        }
    };

    function show_CheckListEditForm() {
        var record = ListGrid_CheckList.getSelectedRecord();
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
            CheckList_method = "PUT";
            DynamicForm_CheckList.clearValues();
            DynamicForm_CheckList.editRecord(record);
            Window_CheckList_Add.setTitle("<spring:message code="edit.checklistTitle"/>")
            Window_CheckList_Add.show();
        }
    };


    function show_CheckListItemEditForm() {
        var record = ListGrid_CheckListItem.getSelectedRecord();
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
            CheckListItem_method = "PUT";
            DynamicForm_CheckListItem_Add.clearValues();
            DynamicForm_CheckListItem_Add.editRecord(record);
            Window_CheckListItem_Add.setTitle("<spring:message code="edit"/>");
            Window_CheckListItem_Add.show();
        }
    };


    function show_CheckListActionResult_Delete(resp) {
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

            if (resp.data == "true") {
                ListGrid_CheckListItem.setData([]);
                ListGrid_CheckList.invalidateCache();
                checkListDynamicFormField.fetchData();
                var OK = isc.Dialog.create({
                    message: "global.form.request.successful",
                    icon: "[SKIN]say.png",
                    title: "<spring:message code="global.form.command.done"/>"
                });
                setTimeout(function () {
                    OK.close();
                }, 2000);
            } else {
                var OK = isc.Dialog.create({
                    message: "آیتم های فرم مورد نظر در کلاس استفاده شده و قابل حذف نمی باشد",
                    icon: "[SKIN]say.png",
                    title: "<spring:message code="warning"/>"
                });
                setTimeout(function () {
                    OK.close();
                }, 3000);
            }
        } else {
            var OK = isc.Dialog.create({
                message: "<spring:message code="msg.operation.error"/>",
                icon: "[SKIN]say.png",
                title: "<spring:message code="warning"/>"
            });
            setTimeout(function () {
                OK.close();
            }, 3000);
        }
    }

    function show_CheckListItem_is_Delete(resp) {
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            ListGrid_Class_Item.invalidateCache();
            var OK = isc.Dialog.create({
                message: "<spring:message code="msg.operation.successful"/>",
                icon: "[SKIN]say.png",
                title: "<spring:message code="global.form.command.done"/>"
            });
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            var OK = isc.Dialog.create({
                message: "<spring:message code="msg.operation.error"/>",
                icon: "[SKIN]say.png",
                title: "<spring:message code="global.form.command.done"/>"
            });
            setTimeout(function () {
                OK.close();
            }, 3000);
        }
    }

    function show_CheckListActionResult(resp) {
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            ListGrid_CheckList.invalidateCache();
            var OK = isc.Dialog.create({
                message: "<spring:message code="msg.operation.successful"/>",
                icon: "[SKIN]say.png",
                title: "<spring:message code="global.form.command.done"/>"
            });
            setTimeout(function () {
                OK.close();
            }, 3000);
            Window_CheckList_Add.close();
        } else {
            var OK = isc.Dialog.create({
                message: "<spring:message code="msg.operation.error"/>",
                icon: "[SKIN]say.png",
                title: "<spring:message code="global.form.command.done"/>"
            });
            setTimeout(function () {
                OK.close();
            }, 3000);
        }
    };

    function show_checkListDynamicFormField(resp) {
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            ListGrid_CheckList.invalidateCache();
            checkListDynamicFormField.fetchData();
            var OK = isc.Dialog.create({
                message: "<spring:message code="msg.operation.successful"/>",
                icon: "[SKIN]say.png",
                title: "<spring:message code="global.form.command.done"/>"
            });
            Window_CheckList_Add.close();
            setTimeout(function () {
                OK.close();
            }, 1000);
        } else {
            var OK = isc.Dialog.create({
                message: "<spring:message code="msg.operation.error"/>",
                icon: "[SKIN]say.png",
                title: "<spring:message code="global.form.command.done"/>"
            });
            setTimeout(function () {
                OK.close();
            }, 3000);
        }

    };


    function show_CheckListItemActionResult1111111(resp) {
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            var OK = isc.Dialog.create({
                message: "<spring:message code="msg.operation.successful"/>",
                icon: "[SKIN]say.png",
                title: "<spring:message code="global.form.command.done"/>"
            });
            setTimeout(function () {
                OK.close();
            }, 3000);
        }
    }


    function show_CheckListItemActionResult(resp) {
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            ListGrid_CheckListItem.invalidateCache();
            ListGrid_Class_Item.invalidateCache();

            var OK = isc.Dialog.create({
                message: "<spring:message code="msg.operation.successful"/>",
                icon: "[SKIN]say.png",
                title: "<spring:message code="global.form.command.done"/>"
            });
            setTimeout(function () {
                OK.close();
            }, 3000);
            Window_CheckListItem_Add.close();
        } else {
            var OK = isc.Dialog.create({
                message: "<spring:message code="msg.operation.error"/>",
                icon: "[SKIN]say.png",
                title: "<spring:message code="global.form.command.done"/>"
            });
            setTimeout(function () {
                OK.close();
            }, 3000);
        }

    };


    // isc.RPCManager.sendRequest(TrDSRequest(classCheckListUrl + "spec-list","GET", null,"callback: All_Priority_Result_NASB_JPA(rpcResponse)"));
    //
    // function All_Priority_Result_NASB_JPA(resp){
    // All_Priorities = (JSON.parse(resp.data)).response.data;
    // // console.log(All_Priorities)
    // for (let i = 0; i < All_Priorities.length; i++) {
    //
    //
    // }
    // };
    function fireCheckList(record) {

        if (record != -1) {
            RestDataSource_ClassCheckList.fetchDataURL = checklistUrl + "getchecklist" + "/" + record.id;
            ListGrid_ClassCheckList.setFieldProperties(1, {title: "&nbsp;<b>" + 'فرم های دوره' + "&nbsp;<b>" + record.course.titleFa + "&nbsp;<b>" + 'با کد کلاس' + "&nbsp;<b>" + record.code});
            ListGrid_ClassCheckList.fetchData();
            ListGrid_ClassCheckList.invalidateCache();
        } else {
            ListGrid_ClassCheckList.setFieldProperties(1, {title: " "});
            ListGrid_ClassCheckList.setData([]);
        }
    };


