<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    let parameterTypeMethod_parameter;

    // ------------------------------------------- Menu -------------------------------------------
    isc.Menu.create({
        ID: "ParameterTypeMenu_parameter",
        data: [
            {
                title: "<spring:message code="refresh"/>",
                click: function () {
                    refreshParameterTypeLG_parameter();
                }
            },
            {
                title: "<spring:message code="create"/>",
                click: function () {
                    createParameterType_parameter();
                }
            },
            {
                title: "<spring:message code="edit"/>",
                click: function () {
                    editParameterType_parameter();
                }
            },
            {
                title: "<spring:message code="remove"/>",
                click: function () {
                    removeParameterType_parameter();
                }
            },
        ]
    });

    isc.Menu.create({
        ID: "ParameterValueMenu_parameter",
        data: [
            {
                title: "<spring:message code="refresh"/>",
                click: function () {
                    refreshParameterValueLG_parameter();
                }
            },
            {
                title: "<spring:message code="create"/>",
                click: function () {
                    createParameterValue_parameter();
                }
            },
            {
                title: "<spring:message code="edit"/>",
                click: function () {
                    editParameterValue_parameter();
                }
            },
            {
                title: "<spring:message code="remove"/>",
                click: function () {
                    removeParameterValue_parameter();
                }
            },
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    isc.ToolStrip.create({
        ID: "ParameterTypeTS_parameter",
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonCreate.create({
                click: function () {
                    createParameterType_parameter();
                }
            }),
            isc.ToolStripButtonEdit.create({
                click: function () {
                    editParameterType_parameter();
                }
            }),
            isc.ToolStripButtonRemove.create({
                click: function () {
                    removeParameterType_parameter();
                }
            }),
            isc.LayoutSpacer.create({
                width: "*"
            }),
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    isc.Label.create({
                        ID: "totalsLabel_parameter"
                    }),
                    isc.ToolStripButtonRefresh.create({
                        click: function () {
                            refreshParameterTypeLG_parameter();
                        }
                    }),
                ]
            })
        ]
    });

    isc.ToolStrip.create({
        ID: "ParameterValueTS_parameter",
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonCreate.create({
                click: function () {
                    createParameterValue_parameter();
                }
            }),
            isc.ToolStripButtonEdit.create({
                click: function () {
                    editParameterValue_parameter();
                }
            }),
            isc.ToolStripButtonRemove.create({
                click: function () {
                    removeParameterValue_parameter();
                }
            }),
            isc.LayoutSpacer.create({
                width: "*"
            }),
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    isc.Label.create({
                        ID: "totalsLabel_parameter"
                    }),
                    isc.ToolStripButtonRefresh.create({
                        click: function () {
                            refreshParameterValueLG_parameter();
                        }
                    }),
                ]
            })
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    ParameterTypeDS_parameter = isc.TrDS.create({
        ID: "ParameterTypeDS_parameter",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: parameterTypeUrl + "/iscList"
    });

    ParameterValueDS_parameter = isc.TrDS.create({
        ID: "ParameterValueDS_parameter",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: parameterValueUrl + "/iscList"
    });

    ParameterTypeLG_parameter = isc.TrLG.create({
        ID: "ParameterTypeLG_parameter",
        dataSource: ParameterTypeDS_parameter,
        fields: [
            {name: "title",},
            {name: "description",},
        ],
        autoFetchData: true,
        gridComponents: [ParameterTypeTS_parameter, "filterEditor", "header", "body"],
        contextMenu: ParameterTypeMenu_parameter,
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            let totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown()) {
                totalsLabel_parameter.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            } else {
                totalsLabel_parameter.setContents("&nbsp;");
            }
        },
        doubleClick: function() {
            editParameterType_parameter();
        }
    });

    // ------------------------------------------- DynamicForm & Window -------------------------------------------
    ParameterTypeDF_parameter = isc.DynamicForm.create({
        ID: "ParameterTypeDF_parameter",
        fields: [
            {name: "id", hidden: true},
            {
                name: "title", title: "<spring:message code="title"/>",
                required: true, validators: [TrValidators.NotEmpty],
            },
            {
                name: "description", title: "<spring:message code="description"/>",
                type: "TextAreaItem",
            },
        ]
    });

    ParameterTypeWin_parameter = isc.Window.create({
        ID: "ParameterTypeWin_parameter",
        width: 800,
        items: [ParameterTypeDF_parameter, isc.TrHLayoutButtons.create({
            members: [
                isc.IButtonSave.create({
                    click: function () {
                        if (!ParameterTypeDF_parameter.validate()) {
                            return;
                        }
                        let parameterTypeSaveUrl = parameterTypeUrl;
                        let parameterTypeAction = '<spring:message code="create"/>';
                        if (parameterTypeMethod_parameter.localeCompare("PUT") == 0) {
                            let record = ParameterTypeLG_parameter.getSelectedRecord();
                            parameterTypeSaveUrl += "/" + record.id;
                            parameterTypeAction = '<spring:message code="edit"/>';
                        }
                        let data = ParameterTypeDF_parameter.getValues();
                        isc.RPCManager.sendRequest(
                            TrDSRequest(parameterTypeSaveUrl, parameterTypeMethod_parameter, JSON.stringify(data), "callback: studyResponse(rpcResponse, '" + parameterTypeAction + "','" + "<spring:message code="parameter.type"/>" + "')")
                        );
                    }
                }),
                isc.IButtonCancel.create({
                    click: function () {
                        ParameterTypeWin_parameter.close();
                    }
                }),
            ],
        }),]
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [ParameterTypeLG_parameter],
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refreshParameterTypeLG_parameter() {
        ParameterTypeLG_parameter.invalidateCache();
        ParameterTypeLG_parameter.filterByEditor();
    }

    function createParameterType_parameter() {
        parameterTypeMethod_parameter = "POST";
        ParameterTypeDF_parameter.clearValues();
        ParameterTypeWin_parameter.show();
    }

    function editParameterType_parameter() {
        let record = ParameterTypeLG_parameter.getSelectedRecord();
        if (checkRecordAsSelected(record, true)) {
            parameterTypeMethod_parameter = "PUT";
            ParameterTypeDF_parameter.clearValues();
            ParameterTypeDF_parameter.editRecord(record)
            ParameterTypeWin_parameter.show();
        }
    }

    function removeParameterType_parameter() {
        let record = ParameterTypeLG_parameter.getSelectedRecord();
        if (checkRecordAsSelected(record, true)) {
            let dialog = createDialog('ask', "<spring:message code="msg.record.remove.ask"/>");
            dialog.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index == 0) {
                        isc.RPCManager.sendRequest(
                            TrDSRequest(parameterTypeUrl + "/" + record.id, "DELETE", null, "callback: studyResponse(rpcResponse, '" + "<spring:message code="remove"/>" + "','" + "<spring:message code="parameter.type"/>" + "')")
                        );
                    }
                }
            })
        }
    }

    function printParameterTypeLG_parameter(type) {
    }

    function studyResponse(resp, action, entityTypeName) {
        let msg;
        if (resp == null) {
            msg = "<spring:message code="msg.error.connecting.to.server"/>";
        } else {
            let entityName = JSON.parse(resp.httpResponseText).title
            let respCode = resp.httpResponseCode;
            if (respCode == 200) {
                if ((action == null || action == undefined) || (entityTypeName == null || entityTypeName == undefined) || (entityName == null || entityName == undefined)) {
                    msg = "<spring:message code="msg.operation.successful"/>";
                } else {
                    msg = action + '&nbsp;' + entityTypeName + '&nbsp;\'<b>' + entityName + '</b>\'&nbsp' + "<spring:message code="msg.successfully.done"/>";
                }
            } else {
                msg = "<spring:message code='msg.operation.error'/>";
            }
            createDialog("info", msg);
            ParameterTypeWin_parameter.close();
            refreshParameterTypeLG_parameter();
        }
    }

    function checkRecordAsSelected(record, showDialog, msg) {
        if (record ? (record.constructor === Array ? ((record.length > 0) ? true : false) : true) : false) {
            return true;
        }
        if (showDialog) {
            let dialog = createDialog("info", msg ? msg : "<spring:message code="msg.no.records.selected"/>");
        }
        return false;
    }