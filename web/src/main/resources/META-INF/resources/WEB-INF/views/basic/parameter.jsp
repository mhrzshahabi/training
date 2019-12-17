<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    let parameterMethod_parameter;
    let parameterValueMethod_parameter;

    // ------------------------------------------- Menu -------------------------------------------
    isc.Menu.create({
        ID: "ParameterMenu_parameter",
        data: [
            {
                title: "<spring:message code="refresh"/>",
                click: function () {
                    refreshParameterLG_parameter();
                }
            },
            {
                title: "<spring:message code="create"/>",
                click: function () {
                    createParameter_parameter();
                }
            },
            {
                title: "<spring:message code="edit"/>",
                click: function () {
                    editParameter_parameter();
                }
            },
            {
                title: "<spring:message code="remove"/>",
                click: function () {
                    removeParameter_parameter();
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
        ID: "ParameterTS_parameter",
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonCreate.create({
                click: function () {
                    createParameter_parameter();
                }
            }),
            isc.ToolStripButtonEdit.create({
                click: function () {
                    editParameter_parameter();
                }
            }),
            isc.ToolStripButtonRemove.create({
                click: function () {
                    removeParameter_parameter();
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
                            refreshParameterLG_parameter();
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
    ParameterDS_parameter = isc.TrDS.create({
        ID: "ParameterDS_parameter",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: parameterUrl + "/iscList"
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

    ParameterLG_parameter = isc.TrLG.create({
        ID: "ParameterLG_parameter",
        dataSource: ParameterDS_parameter,
        fields: [
            {name: "title",},
            {name: "description",},
        ],
        autoFetchData: true,
        gridComponents: [ParameterTS_parameter, "filterEditor", "header", "body"],
        contextMenu: ParameterMenu_parameter,
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
            editParameter_parameter();
        }
    });

    ParameterValueLG_parameter = isc.TrLG.create({
        ID: "ParameterValueLG_parameter",
        dataSource: ParameterValueDS_parameter,
        fields: [
            {name: "title",},
            {name: "description",},
        ],
        autoFetchData: true,
        gridComponents: [ParameterValueTS_parameter, "filterEditor", "header", "body"],
        contextMenu: ParameterValueMenu_parameter,
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
            editParameterValue_parameter();
        }
    });

    // ------------------------------------------- DynamicForm & Window -------------------------------------------
    ParameterDF_parameter = isc.DynamicForm.create({
        ID: "ParameterDF_parameter",
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

    ParameterWin_parameter = isc.Window.create({
        ID: "ParameterWin_parameter",
        width: 800,
        items: [ParameterDF_parameter, isc.TrHLayoutButtons.create({
            members: [
                isc.IButtonSave.create({
                    click: function () {
                        if (!ParameterDF_parameter.validate()) {
                            return;
                        }
                        let parameterSaveUrl = parameterUrl;
                        let parameterAction = '<spring:message code="create"/>';
                        if (parameterMethod_parameter.localeCompare("PUT") == 0) {
                            let record = ParameterLG_parameter.getSelectedRecord();
                            parameterSaveUrl += "/" + record.id;
                            parameterAction = '<spring:message code="edit"/>';
                        }
                        let data = ParameterDF_parameter.getValues();
                        isc.RPCManager.sendRequest(
                            TrDSRequest(parameterSaveUrl, parameterMethod_parameter, JSON.stringify(data), "callback: studyResponse(rpcResponse, '" + parameterAction + "','" + "<spring:message code="parameter.type"/>" + "')")
                        );
                    }
                }),
                isc.IButtonCancel.create({
                    click: function () {
                        ParameterWin_parameter.close();
                    }
                }),
            ],
        }),]
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [ParameterLG_parameter],
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refreshParameterLG_parameter() {
        ParameterLG_parameter.invalidateCache();
        ParameterLG_parameter.filterByEditor();
    }

    function createParameter_parameter() {
        parameterMethod_parameter = "POST";
        ParameterDF_parameter.clearValues();
        ParameterWin_parameter.show();
    }

    function editParameter_parameter() {
        let record = ParameterLG_parameter.getSelectedRecord();
        if (checkRecordAsSelected(record, true)) {
            parameterMethod_parameter = "PUT";
            ParameterDF_parameter.clearValues();
            ParameterDF_parameter.editRecord(record)
            ParameterWin_parameter.show();
        }
    }

    function removeParameter_parameter() {
        let record = ParameterLG_parameter.getSelectedRecord();
        if (checkRecordAsSelected(record, true)) {
            let dialog = createDialog('ask', "<spring:message code="msg.record.remove.ask"/>");
            dialog.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index == 0) {
                        isc.RPCManager.sendRequest(
                            TrDSRequest(parameterUrl + "/" + record.id, "DELETE", null, "callback: studyResponse(rpcResponse, '" + "<spring:message code="remove"/>" + "','" + "<spring:message code="parameter.type"/>" + "')")
                        );
                    }
                }
            })
        }
    }

    function printParameterLG_parameter(type) {
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
            ParameterWin_parameter.close();
            refreshParameterLG_parameter();
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