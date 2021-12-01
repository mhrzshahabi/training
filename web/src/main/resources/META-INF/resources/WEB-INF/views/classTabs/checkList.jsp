<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>
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
            {name: "checkListItem.group"},
            {name: "checkListItem.titleFa", title: "<spring:message code="title"/>", align: "center"},
            {name: "description", title: "<spring:message code="description"/>", align: "center"},
            {name: "enableStatus", title: "<spring:message code="status"/>", align: "center"},
        ],

        fetchDataURL: classCheckListUrl + "spec-list?_startRow=0&_endRow=1000",
// updateDataURL: classCheckListUrl + "edit",
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
// ListGrid_CheckListItem_DetailViewer.setData([]);
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


    var ToolStripButton_CheckList_Refresh = isc.ToolStripButtonRefresh.create({
//icon: "<spring:url value="refresh.png"/>",
        title: "<spring:message code="refresh"/>",
        click: function () {
            let gridState = null;
            if (ListGrid_CheckList.getSelectedRecord() !== null) {
                gridState = "[{id:" + ListGrid_CheckList.getSelectedRecord().id + "}]";
                ListGrid_CheckList.invalidateCache();
                setTimeout(function () {
                    ListGrid_CheckList.setSelectedState(gridState);
                }, 1000)
            } else
                ListGrid_CheckList.invalidateCache(ListGrid_CheckListItem.setData([]));
            totalRecords_Item.setContents("<spring:message code="number.of.Items"/>" + ":&nbsp;<b>" + "" + "</b>");
        }
    });
    var ToolStripButton_CheckList_Edit = isc.ToolStripButtonEdit.create({

        title: "<spring:message code="edit"/>",
        click: function () {
            show_CheckListEditForm();
        }
    });
    var ToolStripButton_CheckList_Add = isc.ToolStripButtonAdd.create({

        title: "<spring:message code="create"/>",
        click: function () {
            show_CheckListAddForm();
        }
    });
    var ToolStripButton_CheckList_Remove = isc.ToolStripButtonRemove.create({

        title: "<spring:message code="remove"/>",
        click: function () {
            show_CheckListDeleteForm();
        }
    });
    //---------------------------------------------------------------------------
    var ToolStripButton_CheckListItem_Refresh = isc.ToolStripButtonRefresh.create({
//icon: "<spring:url value="refresh.png"/>",
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_CheckListItem.invalidateCache();
// ListGrid_CheckListItem_DetailViewer.setData([]);
        }
    });
    var ToolStripButton_CheckListItem_Edit = isc.ToolStripButtonEdit.create({

        title: "<spring:message code="edit"/>",
        click: function () {
            show_CheckListItemEditForm();
        }
    });
    var ToolStripButton_CheckListItem_Add = isc.ToolStripButtonAdd.create({

        title: "<spring:message code="create"/>",
        click: function () {
            show_CheckListItemAddForm();
        }
    });
    var ToolStripButton_CheckListItem_Remove = isc.ToolStripButtonRemove.create({

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
// canHover:true,
        filterOnKeypress: false,
        showFilterEditor: true,
        contextMenu: Menu_ListGrid_CheckListItem,
        dataSource: RestDataSource_CheckListItem,
        fields: [
            {name: "titleFa", title: "<spring:message code="item"/>", width: "80%"},
            {name: "group", title: "<spring:message code="group"/>", width: "20%"},
        ],
        getCellCSSText: function (record, rowNum, colNum) {
            if (record.isDeleted) {
                return "color:red;font-size: 12px;";
            }
        },

        recordClick: function (ListGrid, ListGridRecord, number, ListGridField, number, any, any) {
// return ListGrid_CheckListItem_DetailViewer.setData(ListGridRecord);
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
        recordDoubleClick: function () {
            show_CheckListItemEditForm();
        }


    });

    var ListGrid_CheckList = isc.TrLG.create({
        filterOperator: "iContains",
        allowAdvancedCriteria: true,
// canHover:true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        showFilterEditor: true,
        autoFetchData: true,
        dataSource: RestDataSource_CheckList,
        contextMenu: Menu_ListGrid_CheckList,
        fields: [

            {name: "titleFa", title: "<spring:message code="checkList"/>", align: "center"},
        ],
        recordDoubleClick: function () {
            show_CheckListEditForm();
        },
        recordClick: function () {

        },
        selectionUpdated: function () {
// ListGrid_CheckListItem_DetailViewer.setData([])
            var record = ListGrid_CheckList.getSelectedRecord();
            RestDataSource_CheckListItem.fetchDataURL = checklistUrl + record.id + "/getCheckListItem";
            ListGrid_CheckListItem.fetchData();
            ListGrid_CheckListItem.invalidateCache();
        },

    });


    <%--var ListGrid_CheckListItem_DetailViewer = isc.DetailViewer.create({--%>
    <%--    autoFetchData: true,--%>
    <%--    ID: "ListGrid_CheckListItem_DetailViewer",--%>
    <%--    width: "100%",--%>
    <%--    fields: [--%>
    <%--        {name: "titleFa", title: "<spring:message code="title"/>"},--%>
    <%--        {--%>
    <%--            name: "group", title: "<spring:message code="group"/>",--%>
    <%--            formatCellValue: function (value, record, rowNum, colNum, grid) {--%>
    <%--                if (typeof value === "undefined")--%>
    <%--                    return "ندارد"; else return value;--%>
    <%--            },--%>
    <%--            length: "250"--%>
    <%--        },--%>
    <%--    ],--%>
    <%--    emptyMessage: " "--%>
    <%--})--%>


    //============================================================================
    var ToolStrip_Actions_CheckList = isc.ToolStrip.create({
        width: "40%",
        membersMargin: 5,
        members: [
            ToolStripButton_CheckList_Add,
            ToolStripButton_CheckList_Edit,
            ToolStripButton_CheckList_Remove,
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_CheckList_Refresh,
                ]
            }),
        ]
    });

    var ToolStrip_Actions_CheckListItem = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            ToolStripButton_CheckListItem_Add,
            ToolStripButton_CheckListItem_Edit,
            ToolStripButton_CheckListItem_Remove,
            ToolStripButton_CheckListItem_Space,
            ToolStripButton_CheckListItem_Label,
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_CheckListItem_Refresh,
                ]
            })
        ]
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
                    width: "*",
                },
                {name: "group", title: "<spring:message code="group"/>", type: 'text', height: 35, width: "*"},
            ]
    });

    //=================================================================


    var VLayout_Body_CheckListItem = isc.VLayout.create({
        width: "100%",
        height: "100%",

        members: [HLayout_Action_CheckListItem, ListGrid_CheckListItem]//, ListGrid_CheckListItem_DetailViewer],
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
            members: [isc.IButtonSave.create({
                title: "<spring:message code="save"/>",

                click: function () {
                    if (CheckList_method === "POST") {
                        save_CheckList()
                    } else {
                        edit_CheckList();

                    }
                }


            }), isc.IButtonCancel.create({
                title: "<spring:message code="cancel"/>",
                click: function () {
                    Window_CheckList_Add.close();
                }
            })],
        }),]
    });

    var Window_CheckListItem_Add = isc.Window.create({
        width: 500,
        items: [DynamicForm_CheckListItem_Add, isc.MyHLayoutButtons.create({
            members: [isc.IButtonSave.create({
                title: "<spring:message code="save"/>",

                click: function () {
                    if (CheckListItem_method === "POST") {
                        save_CheckListItem()
                    } else {
                        edit_CheckListItem();
                    }
                }
            }), isc.IButtonCancel.create({
                title: "<spring:message code="cancel"/>",
                click: function () {
                    Window_CheckListItem_Add.close();
                }
            })],
        }),]
    });

    //================================= تکمیل چک لیست===============================================تکمیل چک لیست=========================================تکمیل چک لیست======================================تکمیل چک لیست=====================
    var list = [];
    var ListGrid_Class_Item = isc.TrLG.create({
        showRowNumbers: false,
        alternateRecordStyles: true,
        showFilterEditor: false,
        autoFetchData: true,
// sortField: 0,
        sortAvailableFields: false,
        canSort: false,
        editByCell: true,
        modalEditing: true,
        height: 500,
        showGroupSummary: true,
        groupStartOpen: "all",
        groupByField: 'checkListItem.group',
        groupByMaxRecords:1000,
        nullGroupTitle: "",
        dataSource: RestDataSource_Class_Item,
        canEdit: true,
        editEvent: "click",
        listEndEditAction: "next",
        autoSaveEdits: false,
        saveLocally: true,
        gridComponents: ["header", "filterEditor", "body", isc.TrHLayoutButtons.create({
            members: [
                isc.IButtonSave.create({

                    click: function () {
                        isc.RPCManager.sendRequest(TrDSRequest(classCheckListUrl + "edit", "POST", JSON.stringify(list), "callback:refreshData_jsp(rpcResponse)"));


                    }
                }),
                isc.IButtonCancel.create({

                    click: function () {
                        list.clearAll()
                        Window_Add_User_TO_Committee.close();
                    }
                })
            ]
        })],
        fields: [
            {name: "checkListItem.group", title: "<spring:message code="group"/>", align: "center", hidden: true},
            {name: "checkListItem.titleFa", title: "<spring:message code="title"/>", canEdit: false, align: "center"},
            {
                name: "description", title: "<spring:message code="description"/>", canEdit: true, align: "center",
                change: function (form, item, value) {
                    if (value == null) {
                        item.setValue("")
                    }
                }
            },
            {
                name: "enableStatus",
                title: "<spring:message code="status"/>",
                canEdit: true,
                type: "boolean",
                align: "center"
            },
        ],
        editorExit: function (editCompletionEvent, record, newValue, rowNum, colNum, grid) {
            {
                let obj;
                if (colNum == 1) {
                    obj = {id: record.id, description: newValue}
                    if (list.filter(function (x) {
                        return x.id == record.id
                    }) == 0) {

                        list.push(obj);
                    }

                    list.filter(function (x) {
                        return x.id == record.id
                    }).map(function (x) {
                        return x.description = newValue;
                    });

                }
                if (colNum == 2) {
                    obj = {id: record.id, enableStatus: newValue}
                    if (list.filter(function (x) {
                        return x.id == record.id
                    }) == 0) {
                        list.push(obj);
                    }

                    list.filter(function (x) {
                        return x.id == record.id
                    }).map(function (x) {
                        return x.enableStatus = newValue;
                    });
                }

            }
        }
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
        ],

    });

    //================================== تب چک لیست =====================================


    var ListGrid_ClassCheckList = isc.TrLG.create({
        selectionType: "none",
        showFilterEditor: true,
        <sec:authorize access="hasAuthority('TclassCheckListTab_R')">
        dataSource: RestDataSource_ClassCheckList,
        </sec:authorize>
        styleName: "myparent",
        filterOperator: "iContains",
        allowFilterExpressions: true,
        filterOnKeypress: false,
        <sec:authorize access="hasAuthority('TclassCheckListTab_classStatus_ShowOption')">
        canRemoveRecords: true,
        </sec:authorize>
        removeRecordClick: function (rowNum) {
            let Dialog_Delete = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code='verify.delete'/>");
            Dialog_Delete.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        ListGrid_ClassCheckList.data.removeAt(rowNum);
                        wait.show();
                        var classId = ListGrid_Class_JspClass.getSelectedRecord().id;
                        isc.RPCManager.sendRequest(TrDSRequest(classCheckListUrl + "delete-checkList/" + classId.toString() + "/" + ListGrid_ClassCheckList.getRecord(rowNum).id.toString(), "DELETE", null, (resp) => {
                            wait.close()
                            checkList_delete_result(resp);
                            refreshLG(ListGrid_ClassCheckList);
                        }));
                    }
                }
            });
        },
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa", title: "<spring:message code="form"/>", align: "center"},
        ],


    })

    function checkList_delete_result(resp) {
        wait.close();
        if (resp.httpResponseCode === 200) {
            // TO DO refresh the grid
            var OK = createDialog("info", "<spring:message code='msg.operation.successful'/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
            // TO DO refresh the grid
        } else if (resp.httpResponseCode === 406 && resp.httpResponseText === "NotDeletable") {
            createDialog("info", "<spring:message code='global.grid.record.cannot.deleted'/>");
        } else {
            createDialog("warning", (JSON.parse(resp.httpResponseText).message === undefined ? "خطا" : JSON.parse(resp.httpResponseText).message));
        }
    }

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
        colWidths: ["1%", "20%", "15%", "30"],
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
                width: "220",
                height: "30",
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
// icon: "<spring:url value="check-mark.png"/>",
                fontsize: 2,
                width: 160,
                height: "30",
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
// {
// type: "SpacerItem",
//
// },
            {
                type: "button",
                title: "<spring:message code="checkList.Design"/>",
//icon: "<spring:url value="editCheckList.png"/>",
                iconOrientation: "right",
                showDownIcon: true,
                width: 160,
                height: "30",
                startRow: false,
                endRow: false,
                click: function () {
                    Window_CheckList_Design.show();
                }
            },
            {
                type: "button",
                title: "ارسال به Excel",
                width: 160,
                height: "30",
                startRow: false,
                endRow: true,
                click: function () {
                    let classRecord = ListGrid_Class_JspClass.getSelectedRecord();
                    if (!(classRecord === undefined || classRecord == null)) {
                        ExportToFile.downloadExcelRestUrl(null, ListGrid_ClassCheckList, checklistUrl + "getchecklist" + "/" + classRecord.id, 0, ListGrid_Class_JspClass, '', "کلاس - چک ليست", ListGrid_ClassCheckList.getCriteria(), null);
                    }
                }
            },
        ]
    });


    var HLayout_Body_Top = isc.HLayout.create({
        width: "100%",
        height: "50%",
        members: [
            <sec:authorize access="hasAuthority('TclassCheckListTab_classStatus_ShowOption')">
            DynamicForm_ClassCheckList
            </sec:authorize>
        ],
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
            createDialog("info", "<spring:message code='msg.not.selected.record'/>");
        } else {
            var Dialog_Class_remove = createDialog("ask", "<spring:message code="msg.record.deactivate.ask"/>",
                "<spring:message code="verify.deactivate"/>");
            Dialog_Class_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
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
        ListGrid_Class_Item.invalidateCache()
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
        }, 500);

    }
    ;

    function checkselected() {
        if (ListGrid_Class_JspClass.getSelectedRecord() == null) {
            {
                var OK = isc.Dialog.create({
                    message: "<spring:message code="msg.record.select.class.ask"/>",
                    icon: "[SKIN]say.png",
                    title: "<spring:message code="warning"/>",
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
                title: "<spring:message code="warning"/>",
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
        Window_CheckList_Add.setTitle("<spring:message code="create.checklistTitle"/>");
        Window_CheckList_Add.show();


    };

    function show_CheckListItemAddForm() {
        var SelectedCheckList = ListGrid_CheckList.getSelectedRecord();
        if (SelectedCheckList == null || SelectedCheckList.id == null) {
            isc.Dialog.create({
                message: "<spring:message code="msg.select.form.ask"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="warning"/>",
                buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            CheckListItem_method = "POST";
            DynamicForm_CheckListItem_Add.clearValues();
            DynamicForm_CheckListItem_Add.getItem("checkListId").setValue(SelectedCheckList.id);
            Window_CheckListItem_Add.setTitle("<spring:message code="create.item"/>");
            Window_CheckListItem_Add.show();
        }
    };


    function show_CheckListDeleteForm() {
        var record = ListGrid_CheckList.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.not.selected.record'/>");
        } else {
            var Dialog_Class_remove = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code="verify.delete"/>");
            Dialog_Class_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
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
                title: "<spring:message code="message"/>",

                buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
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
                title: "<spring:message code="message"/>",
                buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            CheckListItem_method = "PUT";
            DynamicForm_CheckListItem_Add.clearValues();
            DynamicForm_CheckListItem_Add.editRecord(record);
            Window_CheckListItem_Add.setTitle("<spring:message code="edit.Item"/>");
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
                    message: "<spring:message code="global.form.request.successful"/>",
                    icon: "[SKIN]say.png",
                    title: "<spring:message code="global.form.command.done"/>"
                });
                setTimeout(function () {
                    OK.close();
                }, 2000);
            } else {
                var OK = isc.Dialog.create({
                    message: "<spring:message code="msg.Item.cannot.delete"/>",
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
            ListGrid_CheckListItem.fetchData();
            ListGrid_CheckListItem.invalidateCache();
            ListGrid_Class_Item.invalidateCache();
            var OK = isc.Dialog.create({
                message: "<spring:message code="msg.operation.successful"/>",
                icon: "[SKIN]say.png",
                title: "<spring:message code="global.form.command.done"/>"
            });
            setTimeout(function () {
                OK.close();
            }, 2000);
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
            let gridState = "[{id:" + JSON.parse(resp.httpResponseText).id + "}]";
            ListGrid_CheckListItem.invalidateCache();
            ListGrid_Class_Item.invalidateCache();

            var OK = isc.Dialog.create({
                message: "<spring:message code="msg.operation.successful"/>",
                icon: "[SKIN]say.png",
                title: "<spring:message code="global.form.command.done"/>"
            });
            setTimeout(function () {
                ListGrid_CheckListItem.setSelectedState(gridState);
                OK.close();
            }, 3000);
            Window_CheckListItem_Add.close();
        } else {
            var OK = isc.Dialog.create({
                message: "<spring:message code="msg.operation.error"/>",
                icon: "[SKIN]say.png",
                title: "<spring:message code="message"/>"
            });
        }

    };

    function loadPage_checkList() {
      var  classRecord = ListGrid_Class_JspClass.getSelectedRecord();
        if (!(classRecord == undefined || classRecord == null)) {
            RestDataSource_ClassCheckList.fetchDataURL = checklistUrl + "getchecklist" + "/" + classRecord.id;
           // ListGrid_ClassCheckList.setFieldProperties(1, {title: "&nbsp;<b>" + "<spring:message code='class.checkList.forms'/>" + "&nbsp;<b>" + classRecord.course.titleFa + "&nbsp;<b>" + "<spring:message code='class.code'/>" + "&nbsp;<b>" + classRecord.code});

            if(classRecord.classStatus === "3")
            {

                <sec:authorize access="hasAnyAuthority('TclassCheckListTab_classStatus_ShowOption')">
                DynamicForm_ClassCheckList.setVisibility(false)
                </sec:authorize>
            }
            else
            {
                <sec:authorize access="hasAnyAuthority('TclassCheckListTab_classStatus_ShowOption')">
                DynamicForm_ClassCheckList.setVisibility(true)
                </sec:authorize>
            }
            if (classRecord.classStatus === "3")
            {
                DynamicForm_ClassCheckList.setVisibility(true)
            }
            ListGrid_ClassCheckList.fetchData();
            ListGrid_ClassCheckList.invalidateCache();
        } else {
            ListGrid_ClassCheckList.setFieldProperties(1, {title: " "});
            ListGrid_ClassCheckList.setData([]);
        }
    }

    function save_All_Data() {
        let list = [];
        let size = ListGrid_Class_Item.data.size();

        for (let i = 0; i < size; i++) {

            if (typeof (ListGrid_Class_Item.data.get(i).customStyle) === "undefined") {

                continue;
            } else {
                let size1 = ListGrid_Class_Item.data.get(i).groupMembers.size();

                for (let j = 0; j < size1; j++) {
                    let obj = {
                        id: ListGrid_Class_Item.data.get(i).groupMembers[j].id,
                        description: ListGrid_Class_Item.data.get(i).groupMembers[j].description,
                        enableStatus: ListGrid_Class_Item.data.get(i).groupMembers[j].enableStatus
                    };

                    if (typeof (obj.enableStatus) === "undefined") {
                        obj.enableStatus = false;
                    }

                    if (typeof (obj.description) === "undefined") {
                        obj.description = '';
                    }

                    list.push(obj);
                }
            }
        }

        return list;

    }

    function refreshData_jsp(resp) {
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

            var a1 = checkListDynamicFormField.getValue();
            var a2 = ListGrid_Class_JspClass.getSelectedRecord().id;


            ListGrid_Class_Item.invalidateCache()
            ListGrid_Class_Item.fetchData(
                {
                    operator: "and", criteria: [
                        {fieldName: "tclassId", operator: "equals", value: a2},
                        {fieldName: "checkListItem.checkListId", operator: "equals", value: a1},
                    ]
                }
// ListGrid_Class_Item.invalidateCache()

            );
            Window_Add_User_TO_Committee.close()

        }


    }

