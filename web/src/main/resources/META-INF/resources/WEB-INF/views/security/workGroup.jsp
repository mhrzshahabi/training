<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>

// <script>

    const userId = '<%= SecurityUtil.getUserId()%>';
    var DynamicForm_Permission;
    var entityList_Permission = [
        // "com.nicico.training.model.Post",
        "com.nicico.training.model.Job",
        "com.nicico.training.model.PostGrade",
        "com.nicico.training.model.Skill",
        "com.nicico.training.model.PostGroup",
        "com.nicico.training.model.JobGroup",
        "com.nicico.training.model.PostGradeGroup",
        "com.nicico.training.model.SkillGroup"
    ];
    var isFormDataListArrived = false;
    var formDataList_Permission;
    var wait_Permission;
    var methodWorkGroup;
    var saveActionUrlWorkGroup;
    var temp;

    //--------------------------------------------------------------------------------------------------------------------//
    /*DS*/
    //--------------------------------------------------------------------------------------------------------------------//

    UserDS_JspWorkGroup = isc.TrDS.create({
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
                name: "username",
                title: "<spring:message code="username"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "version", hidden: true}
        ],
        fetchDataURL: oauthUserUrl + "/spec-list"
    });

    WorkGroupDS_JspWorkGroup = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {
                name: "description",
                title: "<spring:message code="description"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "userIds", title: "<spring:message code="users"/>", filterOperator: "inSet"},
            {name: "permissions"},
            {name: "version", hidden: true}
        ],
        fetchDataURL: workGroupUrl + "/iscList"
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Permissions*/
    //--------------------------------------------------------------------------------------------------------------------//

    TabSet_Permission = isc.TabSet.create({
        tabBarPosition: "right",
        tabBarThickness: 100,
        titleEditorTopOffset: 2,
        tabSelected: function () {
            DynamicForm_Permission = (TabSet_Permission.getSelectedTab().pane);
        }
    });

    IButton_Save_Permission = isc.TrSaveBtn.create({
        top: 260,
        click: function () {
            // if (!DynamicForm_Permission.valuesHaveChanged() || !DynamicForm_Permission.validate())
            //     return;
            DynamicForm_WorkGroup_edit();
        }
    });

    HLayout_SaveOrExit_Permission = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Save_Permission]
    });

    ToolStripButton_Refresh_Permission = isc.ToolStripButtonRefresh.create({
        click: function () {
            DynamicForm_WorkGroup_refresh();
        }
    });

    ToolStrip_Actions_Permission = isc.ToolStrip.create({
        width: "100%",
        align: "left",
        border: '0px',
        members: [
            ToolStripButton_Refresh_Permission
        ]
    });

    VLayout_Permission = isc.TrVLayout.create({
        members: [ToolStrip_Actions_Permission, TabSet_Permission, HLayout_SaveOrExit_Permission]
    });

    Windows_Permissions_Permission = isc.Window.create({
        placement: "fillScreen",
        title: "دسترسی ها",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        minWidth: 1024,
        items: [VLayout_Permission]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*WorkGroup DF*/
    //--------------------------------------------------------------------------------------------------------------------//

    DynamicForm_JspWorkGroup = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        titleAlign: "left",
        fields: [
            {name: "id", hidden: true},
            {
                name: "title",
                title: "<spring:message code="title"/>"
            },
            {
                name: "description",
                title: "<spring:message code="description"/>"
            },
            {
                name: "userIds",
                type: "selectItem",
                title: "<spring:message code="users"/>",
                optionDataSource: UserDS_JspWorkGroup,
                valueField: "id",
                displayField: "lastName",
                filterField: "lastName",
                filterOnKeypress: true,
                multiple: true,
                filterLocally: false,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {
                        name: "firstName",
                        title: "<spring:message code="firstName"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains"},
                    {
                        name: "username",
                        title: "<spring:message code="username"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "nationalCode",
                        title: "<spring:message code="national.code"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    }
                ]
            }
        ]
    });

    IButton_Save_JspWorkGroup = isc.TrSaveBtn.create({
        top: 260,
        click: function () {
            if (!DynamicForm_JspWorkGroup.valuesHaveChanged() || !DynamicForm_JspWorkGroup.validate())
                return;
            wait_Permission = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlWorkGroup,
                methodWorkGroup,
                JSON.stringify(DynamicForm_JspWorkGroup.getValues()),
                WorkGroup_save_result));
        }
    });

    IButton_Cancel_JspWorkGroup = isc.TrCancelBtn.create({
        click: function () {
            DynamicForm_JspWorkGroup.clearValues();
            Window_JspWorkGroup.close();
        }
    });

    HLayout_SaveOrExit_JspWorkGroup = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Save_JspWorkGroup, IButton_Cancel_JspWorkGroup]
    });

    Window_JspWorkGroup = isc.Window.create({
        width: "550",
        minWidth: "550",
        align: "center",
        border: "1px solid gray",
        title: "گروه کاری",
        items: [isc.TrVLayout.create({
            members: [DynamicForm_JspWorkGroup, HLayout_SaveOrExit_JspWorkGroup]
        })]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*WorkGroup Grid*/
    //--------------------------------------------------------------------------------------------------------------------//

    Menu_JspWorkGroup = isc.Menu.create({
        data: [{
            title: "<spring:message code='refresh'/>", click: function () {
                refreshLG(ListGrid_JspWorkGroup);
            }
        }, {
            title: "<spring:message code='create'/>", click: function () {
                ListGrid_WorkGroup_Add();
            }
        }, {
            title: "<spring:message code='edit'/>", click: function () {
                ListGrid_WorkGroup_Edit();
            }
        }, {
            title: "<spring:message code='remove'/>", click: function () {
                ListGrid_WorkGroup_Remove();
            }
        }, {
            title: "دسترسی", click: function () {
                Add_Permission_To_WorkGroup_Jsp();
            }
        }
        ]
    });

    ListGrid_JspWorkGroup = isc.TrLG.create({
        dataSource: WorkGroupDS_JspWorkGroup,
        contextMenu: Menu_JspWorkGroup,
        sortField: 0,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        align: "center",
        fields: [
            {
                name: "title",
                title: "<spring:message code="title"/>",
                filterOperator: "iContains"
            },
            {
                name: "description",
                title: "<spring:message code="description"/>",
                filterOperator: "iContains"
            },
            {
                name: "userIds",
                type: "selectItem",
                title: "<spring:message code="users"/>",
                filterOperator: "inSet",
                optionDataSource: UserDS_JspWorkGroup,
                valueField: "id",
                displayField: "lastName",
                filterField: "lastName",
                filterOnKeypress: true,
                multiple: true,
                filterLocally: false,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
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
                        name: "username",
                        title: "<spring:message code="username"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "nationalCode",
                        title: "<spring:message code="national.code"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    }
                ]
            }
        ],
        rowDoubleClick: function () {
            ListGrid_WorkGroup_Edit();
        },
        filterEditorSubmit: function () {
            ListGrid_JspWorkGroup.invalidateCache();
        }
    });

    ToolStripButton_Refresh_JspWorkGroup = isc.ToolStripButtonRefresh.create({
        click: function () {
            refreshLG(ListGrid_JspWorkGroup);
        }
    });

    ToolStripButton_Edit_JspWorkGroup = isc.ToolStripButtonEdit.create({
        click: function () {
            ListGrid_WorkGroup_Edit();
        }
    });
    ToolStripButton_Add_JspWorkGroup = isc.ToolStripButtonAdd.create({
        click: function () {
            ListGrid_WorkGroup_Add();
        }
    });
    ToolStripButton_Remove_JspWorkGroup = isc.ToolStripButtonRemove.create({
        click: function () {
            ListGrid_WorkGroup_Remove();
        }
    });
    ToolStripButton_Add_Permission_To_WorkGroup_Jsp = isc.ToolStripButton.create({
        title: "دسترسی",
        click: function () {
            Add_Permission_To_WorkGroup_Jsp();
        }
    });

    ToolStrip_Actions_JspWorkGroup = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_Add_JspWorkGroup,
                ToolStripButton_Edit_JspWorkGroup,
                ToolStripButton_Remove_JspWorkGroup,
                ToolStripButton_Add_Permission_To_WorkGroup_Jsp,
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_JspWorkGroup
                    ]
                })
            ]
    });

    VLayout_Body_JspWorkGroup = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_JspWorkGroup,
            ListGrid_JspWorkGroup
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function ListGrid_WorkGroup_Add() {
        methodWorkGroup = "POST";
        saveActionUrlWorkGroup = workGroupUrl;
        DynamicForm_JspWorkGroup.clearValues();
        Window_JspWorkGroup.show();
    }

    function ListGrid_WorkGroup_Edit() {
        var record = ListGrid_JspWorkGroup.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            methodWorkGroup = "PUT";
            saveActionUrlWorkGroup = workGroupUrl + "/" + record.id;
            DynamicForm_JspWorkGroup.clearValues();
            DynamicForm_JspWorkGroup.editRecord(record);
            Window_JspWorkGroup.show();
        }
    }

    function WorkGroup_save_result(resp) {
        wait_Permission.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            refreshLG(ListGrid_JspWorkGroup);
            Window_JspWorkGroup.close();
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            if (resp.httpResponseCode === 406 && resp.httpResponseText === "DuplicateRecord") {
                createDialog("info", "<spring:message code="msg.record.duplicate"/>",
                    "<spring:message code="message"/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>",
                    "<spring:message code="message"/>");
            }
        }
    }

    function ListGrid_WorkGroup_Remove() {
        let recordIds = ListGrid_JspWorkGroup.getSelectedRecords().map(r => r.id);
        if (recordIds == null || recordIds.length === 0) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            let Dialog_Delete = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code='verify.delete'/>");
            Dialog_Delete.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        wait_Permission = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(workGroupUrl + "/" + recordIds,
                            "DELETE",
                            null,
                            WorkGroup_remove_result));
                    }
                }
            });
        }
    }

    function WorkGroup_remove_result(resp) {
        wait_Permission.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            refreshLG(ListGrid_JspWorkGroup);
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            let respText = resp.httpResponseText;
            if (resp.httpResponseCode === 406 && respText === "NotDeletable") {
                createDialog("info", "<spring:message code='msg.record.cannot.deleted'/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>");
            }
        }
    }

    function Add_Permission_To_WorkGroup_Jsp() {
        let record = ListGrid_JspWorkGroup.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }
        if (wait_Permission != null)
            wait_Permission.close();
        if (isFormDataListArrived === false) {
            wait_Permission = createDialog("wait");
            setTimeout(function () {
                Add_Permission_To_WorkGroup_Jsp()
            }, 2000);
            return;
        }
        Windows_Permissions_Permission.show();
        TabSet_Permission.tabs.forEach(tab => tab.pane.clearValues());
        record.permissions.forEach(Windows_Permissions_Set_Values);
    }

    //--------------------------------------------------------------------------------------------------------------------//
    //*functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function Windows_Permissions_Set_Values(permission) {
        temp = permission;
        let DF = TabSet_Permission.getTab(permission.entityName).pane;
        DF.setValue(permission.entityName + "_" + permission.attributeName + "_" + permission.attributeType + "_Permission",
            permission.attributeValues);
    }

    function DynamicForm_WorkGroup_refresh() {
        // TabSet_Permission.tabs.forEach(TabSet_Permission.removeTab)
        for (var i = TabSet_Permission.tabs.length - 1; i > -1; i--) {
            TabSet_Permission.removeTab(i);
        }
        isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/config-list", "GET", null, setConfigTypes));
    }

    function setFormData(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            isFormDataListArrived = true;
            formDataList_Permission = (JSON.parse(resp.data));
            formDataList_Permission.forEach(addTab);
        } else {

        }
    }


    function addTab(item) {
        var newTab = {
            title: item.entityName.split('.').last(),
            name: item.entityName,
            <%--title: "<spring:message code=code/>","code":item.entityName.split('.').last(),--%>
            pane: newDynamicForm(item)
        };
        TabSet_Permission.addTab(newTab);
    }

    function newDynamicForm(item) {
        var DF = isc.DynamicForm.create({
            height: "100%",
            width: "90%",
            title: item.entityName,
            titleAlign: "left",
            align: "center",
            canSubmit: true,
            showInlineErrors: true,
            showErrorText: false,
            margin: 20,
            numCols: 8
        });
        for (let i = 0; i < item.columnDataList.length; i++) {
            DF.addField({
                ID: item.entityName + "_" + item.columnDataList[i].attributeName + "_" + item.columnDataList[i].attributeType + "_Permission",
                name: item.entityName + "_" + item.columnDataList[i].attributeName + "_" + item.columnDataList[i].attributeType + "_Permission",
                title: item.columnDataList[i].attributeName,
                valueMap: item.columnDataList[i].attributeValues,
                type: "selectItem",
                textAlign: "center",
                multiple: true,
                colSpan: 8
            })
        }
        return DF;
    }

    function DynamicForm_WorkGroup_edit() {
        let toUpdate = [];
        let record = ListGrid_JspWorkGroup.getSelectedRecord();
        for (let j = 0; j < TabSet_Permission.tabs.length; j++) {
            let fields = TabSet_Permission.tabs[j].pane.getAllFields();
            for (let i = 0; i < fields.length; i++) {

                if (
                    fields[i].getValue() != null ||
                    (record.permissions.filter(
                        p => p.entityName === ((fields[i].getID()).split('_'))[0] &&
                            p.attributeName === ((fields[i].getID()).split('_'))[1])).length > 0
                ) {
                    toUpdate.add({
                        "entityName": ((fields[i].getID()).split('_'))[0],
                        "attributeName": ((fields[i].getID()).split('_'))[1],
                        "attributeValues": fields[i].getValue(),
                        "attributeType": ((fields[i].getID()).split('_'))[2]
                    });
                }
            }
        }
        if (toUpdate.length > 0) {
            wait_Permission = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(workGroupUrl + "/edit-permission-list/" + record.id,
                "PUT", JSON.stringify(toUpdate), Edit_Result_Permission));
        }
    }

    function Edit_Result_Permission(resp) {
        wait_Permission.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            refreshLG(ListGrid_JspWorkGroup);
            Windows_Permissions_Permission.close();
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                OK.close();
            }, 2000);
        } else {
            createDialog("info", "<spring:message code="msg.operation.error"/>",
                "<spring:message code="message"/>");
        }
    }

    isc.RPCManager.sendRequest(TrDSRequest(workGroupUrl + "/form-data", "POST", JSON.stringify(entityList_Permission), setFormData));

    //</script>