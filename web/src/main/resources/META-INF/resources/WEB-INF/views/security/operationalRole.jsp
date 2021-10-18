<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

//<script>
    "use strict"

    var methodOperationalRole;
    var saveActionUrlOperationalRole;
    var wait_Permission;
    let departmentCriteria = [];
    //--------------------------------------------------------------------------------------------------------------------//
    /*DS*/
    //--------------------------------------------------------------------------------------------------------------------//

    var RestDataSource_JspOperationalRole = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true},
                {name: "code"},
                {name: "title"},
                {name: "description"},
                {name: "operationalUnit.operationalUnit"},
                {name: "userIds", title: "<spring:message code="post"/>", filterOperator: "inSet"},
                {name: "postIds", title: "<spring:message code="users"/>", filterOperator: "inSet"},
                {name: "complexId"}
            ],
    });

    var UserDS_JspOperationalRole = isc.TrDS.create({
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

    let RestDataSource_OperationalRole_Department_Filter = isc.TrDS.create({
        fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/organ-segment-iscList/mojtame"
    });


    var RestDataSource_JspOperationalUnit = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true},
                {name: "unitCode"},
                {name: "operationalUnit"}
            ],
        fetchDataURL: operationalUnitUrl + "spec-list"
    });


    var PostDS_OperationalRole = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "peopleType", title: "<spring:message code="people.type"/>", filterOperator: "equals", autoFitWidth: true, valueMap:{"Personal" : "شرکتی", "ContractorPersonal" : "پیمان کار"},filterOnKeypress: true},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "jobTitleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postGradeTitleFa", hidden: true, title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "assistance", hidden: true, title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "affairs", hidden: true, title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "section", hidden: true, title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "unit", hidden: true, title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterCode", hidden: true, title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", hidden: true, title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceCount", hidden: true, title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCount", hidden: true, title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "lastModifiedDateNA", hidden: true, title: "<spring:message code="update.date"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "modifiedByNA", hidden: true, title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "enabled", hidden: true, title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, filterOnKeypress: true,valueMap:{74 : "غیر فعال"}}
        ],
        fetchDataURL: viewPostUrl + "/iscList"
        // fetchDataURL: viewPostUrl + "/rolePostList"
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*Menu*/
    //--------------------------------------------------------------------------------------------------------------------//

    var Menu_JspOperationalRole = isc.Menu.create({
        data: [{
            title: "<spring:message code='refresh'/>", click: function () {
                refreshLG(ListGrid_JspOperationalRole);
            }
        }, {
            title: "<spring:message code='create'/>", click: function () {
                ListGrid_OperationalRole_Add();
            }
        }, {
            title: "<spring:message code='edit'/>", click: function () {
                ListGrid_OperationalRole_Edit();
            }
        }, {
            title: "<spring:message code='remove'/>", click: function () {
                ListGrid_OperationalRole_Remove();
            }
        },
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*ListGrid*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ListGrid_JspOperationalRole = isc.TrLG.create({
        dataSource: RestDataSource_JspOperationalRole,
        contextMenu: Menu_JspOperationalRole,
        sortField: 0,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
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
                name: "operationalUnit.operationalUnit",
                title: "<spring:message code="unitName"/>",
                filterOperator: "iContains"
            },
            {
                name: "userIds",
                type: "selectItem",
                title: "<spring:message code="users"/>",
                filterOperator: "inSet",
                optionDataSource: UserDS_JspOperationalRole,
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
            ListGrid_OperationalRole_Edit();
        },
        filterEditorSubmit: function () {
            ListGrid_JspOperationalRole.invalidateCache();
        }
    });

    //--------------------------------------------------------------------------------------------------------------------//
    /*DynamicForm */
    //--------------------------------------------------------------------------------------------------------------------//


    var DynamicForm_JspOperationalRole = isc.DynamicForm.create({
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
                name: "complexId",
                editorType: "ComboBoxItem",
                title: "<spring:message code="complex"/>:",
                pickListWidth: 200,
                optionDataSource: RestDataSource_OperationalRole_Department_Filter,
                displayField: "title",
                autoFetchData: true,
                valueField: "id",
                textAlign: "center",
                required: true,
                textMatchStyle: "substring",
                pickListFields: [
                    {name: "title", autoFitWidth: true, autoFitWidthApproach: true},
                ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                },
            },
            {
                name: "operationalUnitId",
                title: "<spring:message code="unitName"/>",
                optionDataSource: RestDataSource_JspOperationalUnit,
                valueField: "id",
                displayField: "operationalUnit",
                required: true,
                validateOnExit: true,
                length: 255,
                canSort: false,
            },
            {
                name: "postIds",
                type: "MultiComboBoxItem",
                title: "<spring:message code="post"/>",
                optionDataSource: PostDS_OperationalRole,
                valueField: "id",
                displayField: "titleFa",
                filterOnKeypress: true,
                multiple: true,
                comboBoxProperties: {
                    hint: "",
                    filterFields: ["code", "titleFa", "jobTitleFa", "postGradeTitleFa"],
                    textMatchStyle: "substring",
                    pickListWidth: 450,
                    pickListProperties: {
                        autoFitWidthApproach: "both",
                    },
                    pickListFields: [
                        {
                            name: "code",
                            filterOperator: "iContains",
                            autoFitWidth: true
                        },
                        {name: "titleFa",  filterOperator: "iContains"},
                        {
                            name: "jobTitleFa",
                            filterOperator: "iContains",
                            autoFitWidth: true
                        },
                        {
                            name: "postGradeTitleFa",
                            filterOperator: "iContains",
                            autoFitWidth: true
                        }
                    ],
                }
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
                optionDataSource: UserDS_JspOperationalRole,
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
                                autoDraw: false,
                                height: 30,
                                width: "100%",
                                members: [
                                    isc.ToolStripButton.create({
                                        width: "50%",
                                        icon: "[SKIN]/actions/approve.png",
                                        title: "<spring:message code='select.all'/>",
                                        click: function () {
                                            let fItem = DynamicForm_JspOperationalRole.getField("userIds");
                                            fItem.setValue(fItem.comboBox.pickList.data.localData.map(user => user.id));
                                            fItem.comboBox.pickList.hide();
                                        }
                                    }),
                                    isc.ToolStripButton.create({
                                        width: "50%",
                                        icon: "[SKIN]/actions/close.png",
                                        title: "<spring:message code='deselect.all'/>",
                                        click: function () {
                                            let fItem = DynamicForm_JspOperationalRole.getField("userIds");
                                            fItem.setValue([]);
                                            fItem.comboBox.pickList.hide();
                                        }
                                    })
                                ]
                            }),
                            "header", "body"
                        ]
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
                    ],
                }
            }
        ]
    });

    var IButton_Save_JspOperationalRole = isc.IButtonSave.create({
        top: 260,
        click: function () {
            if (!DynamicForm_JspOperationalRole.validate())
                return;
            if (!DynamicForm_JspOperationalRole.valuesHaveChanged()) {
                Window_JspOperationalRole.close();
                return;
            }
            wait_Permission = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlOperationalRole,
                methodOperationalRole,
                JSON.stringify(DynamicForm_JspOperationalRole.getValues()),
                OperationalRole_save_result));
        }
    });

    var IButton_Cancel_JspOperationalRole = isc.IButtonCancel.create({
        click: function () {
            DynamicForm_JspOperationalRole.clearValues();
            Window_JspOperationalRole.close();
        }
    });

    var HLayout_SaveOrExit_JspOperationalRole = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Save_JspOperationalRole, IButton_Cancel_JspOperationalRole]
    });

    var Window_JspOperationalRole = isc.Window.create({
        width: "550",
        minWidth: "550",
        align: "center",
        border: "1px solid gray",
        title: "<spring:message code="operational.role"/>",
        items: [isc.TrVLayout.create({
            members: [DynamicForm_JspOperationalRole,
                HLayout_SaveOrExit_JspOperationalRole
            ]
        })]
    });

    var DynamicForm_departmentFilter_Filter = isc.DynamicForm.create({
        width: "600",
        height: 30,
        numCols: 6,
        colWidths: ["2%", "28%", "2%", "68%"],
        fields: [
            {
                name: "departmentFilter",
                title: "<spring:message code='complex'/>",
                width: "300",
                height: 30,
                optionDataSource: RestDataSource_OperationalRole_Department_Filter,
                autoFetchData: false,
                displayField: "title",
                valueField: "id",
                textAlign: "center",
                pickListFields: [
                    {
                        name: "title",
                        title: "<spring:message code="title"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    }
                ],
                changed: function (form, item, value) {
                    load_roles_by_department(value);
                },
            },
        ]
    });


    //--------------------------------------------------------------------------------------------------------------------//
    /*ToolStrips and Layout*/
    //--------------------------------------------------------------------------------------------------------------------//

    var ToolStripButton_Refresh_JspOperationalRole = isc.ToolStripButtonRefresh.create({
        click: function () {
            refreshLG(ListGrid_JspOperationalRole);
        }
    });

    var ToolStripButton_Edit_JspOperationalRole = isc.ToolStripButtonEdit.create({
        click: function () {
            ListGrid_OperationalRole_Edit();
        }
    });
    var ToolStripButton_Add_JspOperationalRole = isc.ToolStripButtonCreate.create({
        click: function () {
            ListGrid_OperationalRole_Add();
        }
    });
    var ToolStripButton_Remove_JspOperationalRole = isc.ToolStripButtonRemove.create({
        click: function () {
            ListGrid_OperationalRole_Remove();
        }
    });

    var ToolStrip_Actions_JspOperationalRole = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_Add_JspOperationalRole,
                ToolStripButton_Edit_JspOperationalRole,
                ToolStripButton_Remove_JspOperationalRole,
                DynamicForm_departmentFilter_Filter,
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_JspOperationalRole
                    ]
                })
            ]
    });

    var VLayout_Body_JspOperationalRole = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_JspOperationalRole,
            ListGrid_JspOperationalRole,
        ]
    });

    //--------------------------------------------------------------------------------------------------------------------//
    //*functions*/
    //--------------------------------------------------------------------------------------------------------------------//

    function ListGrid_OperationalRole_Add() {
        methodOperationalRole = "POST";
        saveActionUrlOperationalRole = operationalRoleUrl;
        DynamicForm_JspOperationalRole.clearValues();
        Window_JspOperationalRole.show();
    }

    function ListGrid_OperationalRole_Edit() {
        let record = ListGrid_JspOperationalRole.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            methodOperationalRole = "PUT";
            saveActionUrlOperationalRole = operationalRoleUrl + "/" + record.id;
            DynamicForm_JspOperationalRole.clearValues();
            DynamicForm_JspOperationalRole.editRecord(record);
            Window_JspOperationalRole.show();
        }
    }

    function OperationalRole_save_result(resp) {
        wait_Permission.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
            refreshLG(ListGrid_JspOperationalRole);
            Window_JspOperationalRole.close();
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

    function ListGrid_OperationalRole_Remove() {
        let recordIds = ListGrid_JspOperationalRole.getSelectedRecords().map(r => r.id);
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
                        isc.RPCManager.sendRequest(TrDSRequest(operationalRoleUrl + "/" + recordIds,
                            "DELETE",
                            null,
                            OperationalRole_remove_result));
                    }
                }
            });
        }
    }

    function OperationalRole_remove_result(resp) {
        wait_Permission.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            refreshLG(ListGrid_JspOperationalRole);
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

    function load_roles_by_department(value) {
        if (value !== undefined) {
            let criteria = {
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [
                    {
                        fieldName: "complexId", operator: "inSet", value: value
                    }
                ]
            };
            RestDataSource_JspOperationalRole.fetchDataURL = operationalRoleUrl + "/spec-list";
            departmentCriteria = criteria;
            let mainCriteria = createMainCriteriaInRoles();
            ListGrid_JspOperationalRole.invalidateCache();
            ListGrid_JspOperationalRole.fetchData(mainCriteria);
        } else {
            createDialog("info", "<spring:message code="msg.select.complex.ask"/>", "<spring:message code="message"/>")
        }

    }

    function createMainCriteriaInRoles() {
        let mainCriteria = {};
        mainCriteria._constructor = "AdvancedCriteria";
        mainCriteria.operator = "and";
        mainCriteria.criteria = [];
        mainCriteria.criteria.add(departmentCriteria);
        return mainCriteria;
    }

//</script>