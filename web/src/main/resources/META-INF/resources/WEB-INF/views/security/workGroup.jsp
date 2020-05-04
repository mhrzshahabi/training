<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    var entityList_Permission = [
        // "Post",
        "Job",
        "PostGrade",
        // "Skill",
        "PostGroup",
        "JobGroup",
        "PostGradeGroup",
        "SkillGroup"
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

    UnassignedPostDS_JspWorkGroup = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "code",
                title: "<spring:message code="post.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "titleFa",
                title: "<spring:message code="post.title"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "job.titleFa",
                title: "<spring:message code="job.title"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "postGrade.titleFa",
                title: "<spring:message code="post.grade.title"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {
                name: "assistance",
                title: "<spring:message code="assistance"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "affairs",
                title: "<spring:message code="affairs"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "section",
                title: "<spring:message code="section"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {
                name: "costCenterCode",
                title: "<spring:message code="reward.cost.center.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "costCenterTitleFa",
                title: "<spring:message code="reward.cost.center.title"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },

        ],
        fetchDataURL: postUrl + "/unassigned-iscList"
    });


    //--------------------------------------------------------------------------------------------------------------------//
    //*Unassigned*/
    //--------------------------------------------------------------------------------------------------------------------//

    Menu_Unassigned_JspWorkGroup = isc.Menu.create({
        data: [{
            title: "<spring:message code='refresh'/>", click: function () {
                refreshLG(ListGrid_Unassigned_JspWorkGroup);
            }
        }]
    });

    ListGrid_Unassigned_JspWorkGroup = isc.TrLG.create({
        dataSource: UnassignedPostDS_JspWorkGroup,
        fields: [
            {name: "code",},
            {name: "titleFa",},
            {name: "job.titleFa",},
            {name: "postGrade.titleFa",},
            {name: "area",},
            {name: "assistance",},
            {name: "affairs",},
            {name: "section",},
            {name: "unit",},
            {name: "costCenterCode",},
            {name: "costCenterTitleFa",},
        ],
        autoFetchData: true,
        contextMenu: Menu_Unassigned_JspWorkGroup,
        allowAdvancedCriteria: true,
        sortField: 0
    });


    ToolStrip_Unassigned_JspWorkGroup = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        isc.ToolStripButtonRefresh.create({
                            click: function () {
                                refreshLG(ListGrid_Unassigned_JspWorkGroup);
                            }
                        })
                    ]
                })
            ]
    });

    VLayout_Unassigned_JspWorkGroup = isc.TrVLayout.create({
        members: [
            ToolStrip_Unassigned_JspWorkGroup,
            ListGrid_Unassigned_JspWorkGroup,
        ]
    });

    Window_Unassigned_JspWorkGroup = isc.Window.create({
        placement: "fillScreen",
        minWidth: "1024",
        align: "center",
        autoDraw: false,
        border: "1px solid gray",
        title: "<spring:message code='unassignedPostToWorkGroup'/>",
        items: [VLayout_Unassigned_JspWorkGroup]
    });

    function Show_Unassigned_Posts_JspWorkGroup() {
        Window_Unassigned_JspWorkGroup.show();
    }

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

    IButton_Save_Permission = isc.IButtonSave.create({
        top: 260,
        click: function () {
            DynamicForm_WorkGroup_edit();
        }
    });

    IButton_Cancel_Permission = isc.IButtonCancel.create({
        click: function () {
            Windows_Permissions_Permission.close();
        }
    });

    HLayout_SaveOrExit_Permission = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Save_Permission, IButton_Cancel_Permission]
    });

    ToolStripButton_Refresh_Permission = isc.ToolStripButtonRefresh.create({
        click: function () {
            DynamicForm_Permissions_refresh();
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
        title: "<spring:message code="permissions"/>",
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
                title: "<spring:message code="title"/>",
                required: true,
                validateOnExit: true,
                length: 255
            },
            {
                name: "description",
                title: "<spring:message code="description"/>",
                length: 255
            },
            {
                name: "userIds",
                type: "MultiComboBoxItem",
                title: "<spring:message code="users"/>",
                optionDataSource: UserDS_JspWorkGroup,
                valueField: "id",
                displayField: "lastName",
                filterOnKeypress: true,
                multiple: true,
                comboBoxProperties: {
                    hint: "",
                    filterFields: ["firstName", "lastName", "username", "nationalCode"],
                    textMatchStyle: "substring",
                    pickListWidth: 335,
                    pickListProperties: {
                        autoFitWidthApproach: "both",
                        gridComponents: [
                            isc.ToolStrip.create({
                                autoDraw:false,
                                height:30,
                                width: "100%",
                                members: [
                                    isc.ToolStripButton.create({
                                        width:"50%",
                                        icon: "[SKIN]/actions/approve.png",
                                        title: "<spring:message code='select.all'/>",
                                        click:function() {
                                            let fItem = DynamicForm_JspWorkGroup.getField("userIds");
                                            fItem.setValue(fItem.comboBox.pickList.data.localData.map(user => user.id));
                                            fItem.comboBox.pickList.hide();
                                        }
                                    }),
                                    isc.ToolStripButton.create({
                                        width:"50%",
                                        icon: "[SKIN]/actions/close.png",
                                        title: "<spring:message code='deselect.all'/>",
                                        click:function() {
                                            let fItem = DynamicForm_JspWorkGroup.getField("userIds");
                                            fItem.setValue([]);
                                            fItem.comboBox.pickList.hide();
                                        }
                                    })
                                ]
                            }),
                            "header","body"
                        ]
                    },
                    pickListFields: [
                        {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
                        {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains"},
                        {name: "username", title: "<spring:message code="username"/>", filterOperator: "iContains", autoFitWidth: true},
                        {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true}
                    ],
                }
            }
        ]
    });

    IButton_Save_JspWorkGroup = isc.IButtonSave.create({
        top: 260,
        click: function () {
            if (!DynamicForm_JspWorkGroup.validate())
                return;
            if (!DynamicForm_JspWorkGroup.valuesHaveChanged()) {
                Window_JspWorkGroup.close();
                return;
            }
            wait_Permission = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlWorkGroup,
                methodWorkGroup,
                JSON.stringify(DynamicForm_JspWorkGroup.getValues()),
                WorkGroup_save_result));
        }
    });

    IButton_Cancel_JspWorkGroup = isc.IButtonCancel.create({
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
        title: "<spring:message code="workGroup"/>",
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
            title: "<spring:message code="permissions"/>", click: function () {
                Add_Permission_To_WorkGroup_Jsp();
            }
        }, {
            title: "<spring:message code='unassignedPostToWorkGroup'/>", click: function () {
                Show_Unassigned_Posts_JspWorkGroup();
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
                canSort: false,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
                    {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
                    {name: "username", title: "<spring:message code="username"/>", filterOperator: "iContains", autoFitWidth: true},
                    {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true}
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
    ToolStripButton_Add_JspWorkGroup = isc.ToolStripButtonCreate.create({
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
        title: "<spring:message code='permissions'/>",
        click: function () {
            Add_Permission_To_WorkGroup_Jsp();
        }
    });
    ToolStripButton_Unassigned_Jsp = isc.ToolStripButton.create({
        title: "<spring:message code='unassignedPostToWorkGroup'/>",
        click: function () {
            Show_Unassigned_Posts_JspWorkGroup();
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
                ToolStripButton_Unassigned_Jsp,
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
            ListGrid_JspWorkGroup,
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
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
            refreshLG(ListGrid_JspWorkGroup);
            Window_JspWorkGroup.close();
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            if (resp.httpResponseCode === 406 && resp.httpResponseText === "DuplicateRecord") {
                createDialog("info", "<spring:message code="msg.record.duplicate"/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>");
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
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
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
        if (TabSet_Permission.getTab(permission.entityName) != null) {
            let DF = TabSet_Permission.getTab(permission.entityName).pane;
            DF.setValue(permission.entityName + "__" + permission.attributeName + "__" + permission.attributeType + "__Permission",
                permission.attributeValues);
        }
    }

    function DynamicForm_Permissions_refresh() {
        for (var i = TabSet_Permission.tabs.length - 1; i > -1; i--) {
            TabSet_Permission.removeTab(i);
        }
        let selectedStudent = ListGrid_JspWorkGroup.getSelectedRecord();
        let gridState = "[{id:" + selectedStudent.id + "}]";
        isFormDataListArrived = false;
        isc.RPCManager.sendRequest(TrDSRequest(workGroupUrl + "/form-data", "POST", JSON.stringify(entityList_Permission), setFormData));
        refreshLG(ListGrid_JspWorkGroup, setTimeout(function () {
            ListGrid_JspWorkGroup.setSelectedState(gridState);
            Add_Permission_To_WorkGroup_Jsp();
        }, 600));
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
            name: item.entityName,
            pane: newDynamicForm(item),
            title: setTitle(item.entityName)
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
            let colValues = [];
            for (let j = 0; j < item.columnDataList[i].attributeValues.length; j++) {
                colValues.add({"value": item.columnDataList[i].attributeValues[j]});
            }
            let fName = item.entityName + "__" + item.columnDataList[i].attributeName + "__" + item.columnDataList[i].attributeType + "__Permission";
            DF.addField({
                ID: fName,
                name: fName,
                title: setTitle(item.columnDataList[i].attributeName),
                optionDataSource: isc.DataSource.create({
                    clientOnly: true,
                    fields: [{name: "value", primaryKey: true}],
                    testData: colValues,
                }),
                type: "MultiComboBoxItem",
                comboBoxWidth: 200,
                textAlign: "center",
                multiple: true,
                colSpan: 8,
                titleOrientation: "top",
                addUnknownValues: false,

                valueField: "value",
                displayField: "value",
                useClientFiltering: true,
                comboBoxProperties: {
                    hint: "",
                    pickListFields: [{name: "value"}],
                    filterFields: ["value"],
                    textMatchStyle: "substring",
                    pickListProperties: {
                        gridComponents: [
                            isc.ToolStrip.create({
                                autoDraw:false,
                                height:30,
                                width: "100%",
                                members: [
                                    isc.ToolStripButton.create({
                                        width:"50%",
                                        icon: "[SKIN]/actions/approve.png",
                                        title: "<spring:message code='select.all'/>",
                                        click:function() {
                                            let fItem = DF.getField(fName);
                                            fItem.setValue(item.columnDataList[i].attributeValues);
                                            fItem.comboBox.pickList.hide();
                                        }
                                    }),
                                    isc.ToolStripButton.create({
                                        width:"50%",
                                        icon: "[SKIN]/actions/close.png",
                                        title: "<spring:message code='deselect.all'/>",
                                        click:function() {
                                            let fItem = DF.getField(fName);
                                            fItem.setValue([]);
                                            fItem.comboBox.pickList.hide();
                                        }
                                    })
                                ]
                            }),
                            "header","body"
                        ]
                    }
                }
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
                        p => p.entityName === ((fields[i].getID()).split('__'))[0] &&
                            p.attributeName === ((fields[i].getID()).split('__'))[1])).length > 0
                ) {
                    toUpdate.add({
                        "entityName": ((fields[i].getID()).split('__'))[0],
                        "attributeName": ((fields[i].getID()).split('__'))[1],
                        "attributeValues": fields[i].getValue(),
                        "attributeType": ((fields[i].getID()).split('__'))[2]
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
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
            setTimeout(function () {
                OK.close();
            }, 2000);
        } else {
            createDialog("info", "<spring:message code="msg.operation.error"/>");
        }
    }

    function setTitle(name) {
        switch (name) {

            case "com.nicico.training.model.Job":
                return "<spring:message code="job"/>";
            case "com.nicico.training.model.Post":
                return "<spring:message code="post"/>";
            case "com.nicico.training.model.PostGrade":
                return "<spring:message code="post.grade"/>";
            case "com.nicico.training.model.Skill":
                return "<spring:message code="skill"/>";
            case "com.nicico.training.model.PostGroup":
                return "<spring:message code="post.group"/>";
            case "com.nicico.training.model.JobGroup":
                return "<spring:message code="job.group"/>";
            case "com.nicico.training.model.PostGradeGroup":
                return "<spring:message code="post.grade.group"/>";
            case "com.nicico.training.model.SkillGroup":
                return "<spring:message code="skill.group"/>";

            case "Job":
                return "<spring:message code="job"/>";
            case "Post":
                return "<spring:message code="post"/>";
            case "PostGrade":
                return "<spring:message code="post.grade"/>";
            case "Skill":
                return "<spring:message code="skill"/>";
            case "PostGroup":
                return "<spring:message code="post.group"/>";
            case "JobGroup":
                return "<spring:message code="job.group"/>";
            case "PostGradeGroup":
                return "<spring:message code="post.grade.group"/>";
            case "SkillGroup":
                return "<spring:message code="skill.group"/>";

            case "code":
                return "<spring:message code="code"/>";
            case "titleFa":
                return "<spring:message code="title"/>";
            case "titleEn":
                return "<spring:message code="title.en"/>";
            case "description":
                return "<spring:message code="description"/>";
            case "area":
                return "<spring:message code="area"/>";
            case "assistance":
                return "<spring:message code="assistance"/>";
            case "affairs":
                return "<spring:message code="affairs"/>";
            case "section":
                return "<spring:message code="section"/>";
            case "unit":
                return "<spring:message code="unit"/>";
            case "costCenterCode":
                return "<spring:message code="cost.center.code"/>";
            case "costCenterTitleFa":
                return "<spring:message code="cost.center.title"/>";
            default:
                return name.split('_').last();
        }
    }

    isc.RPCManager.sendRequest(TrDSRequest(workGroupUrl + "/form-data", "POST", JSON.stringify(entityList_Permission), setFormData));

    //</script>