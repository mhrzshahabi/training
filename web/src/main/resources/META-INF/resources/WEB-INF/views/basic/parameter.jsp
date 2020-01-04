<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    let parameterMethod_parameter;
    let parameterValueMethod_parameter;

    // ------------------------------------------- Menu -------------------------------------------
    isc.Menu.create({
        ID: "ParameterMenu_parameter",
        data: [
            {title: "<spring:message code="refresh"/>", click: function () { refreshListGrid(ParameterLG_parameter, cleanListGrid(ParameterValueLG_parameter)); }},
            {title: "<spring:message code="create"/>", click: function () { createParameter_parameter(); }},
            {title: "<spring:message code="edit"/>", click: function () { editParameter_parameter(); }},
            {title: "<spring:message code="remove"/>", click: function () { removeParameter_parameter(); }},
        ]
    });

    isc.Menu.create({
        ID: "ParameterValueMenu_parameter",
        data: [
            {title: "<spring:message code="refresh"/>", click: function () { refreshParameterValueLG_parameter(); }},
            {title: "<spring:message code="create"/>", click: function () { createParameterValue_parameter(); }},
            {title: "<spring:message code="edit"/>", click: function () { editParameterValue_parameter(); }},
            {title: "<spring:message code="remove"/>", click: function () { removeParameterValue_parameter(); }},
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    isc.ToolStrip.create({
        ID: "ParameterTS_parameter",
        border: "0px solid",
        members: [
            isc.ToolStripButtonRefresh.create({click: function () { refreshListGrid(ParameterLG_parameter, cleanListGrid(ParameterValueLG_parameter)); }}),
            isc.ToolStripButtonCreate.create({click: function () { createParameter_parameter(); }}),
            isc.ToolStripButtonEdit.create({click: function () { editParameter_parameter(); }}),
            isc.ToolStripButtonRemove.create({click: function () { removeParameter_parameter(); }}),
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "CountParameterLG_parameter"}),
        ]
    });

    isc.ToolStrip.create({
        ID: "ParameterValueTS_parameter",
        width: "100%",
        membersMargin: 5,
        border: "0px solid",
        members: [
            isc.ToolStripButtonRefresh.create({click: function () { refreshParameterValueLG_parameter(); }}),
            isc.ToolStripButtonCreate.create({click: function () { createParameterValue_parameter(); }}),
            isc.ToolStripButtonEdit.create({click: function () { editParameterValue_parameter(); }}),
            isc.ToolStripButtonRemove.create({click: function () { removeParameterValue_parameter(); }}),
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "CountParameterValueLG_parameter"}),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    ParameterDS_parameter = isc.TrDS.create({
        ID: "ParameterDS_parameter",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "type", title: "<spring:message code="type"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: parameterUrl + "/iscList"
    });

    ParameterLG_parameter = isc.TrLG.create({
        ID: "ParameterLG_parameter",
        dataSource: ParameterDS_parameter,
        autoFetchData: true,
        fields: [
            {name: "title",},
            {name: "code",},
            {name: "type",},
            {name: "description",},
        ],
        sortField: 0,
        gridComponents: [
            isc.Label.create({
                contents: "<span><b>" + "<spring:message code="type"/>" + "</b></span>", height: "30", align: "center", showEdges: true, edgeOffset: 5, edgeSize: 2
            }),
            ParameterTS_parameter, "filterEditor", "header", "body"
        ],
        contextMenu: ParameterMenu_parameter,
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            let totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown())
                CountParameterLG_parameter.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            else
                CountParameterLG_parameter.setContents("&nbsp;");
        },
        doubleClick: function () { editParameter_parameter(); },
        selectionUpdated: function (record) { refreshParameterValueLG_parameter(); }
    });

    ParameterValueDS_parameter = isc.TrDS.create({
        ID: "ParameterValueDS_parameter",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "type", title: "<spring:message code="type"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "value", title: "<spring:message code="value"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
            {name: "parameter.id", hidden: true},
            {name: "parameter.title", hidden: true},
        ],
    });

    ParameterValueLG_parameter = isc.TrLG.create({
        ID: "ParameterValueLG_parameter",
        dataSource: ParameterValueDS_parameter,
        fields: [
            {name: "title",},
            {name: "code",},
            {name: "type",},
            {name: "value",},
            {name: "description",},
        ],
        sortField: 0,
        gridComponents: [
            isc.Label.create({
                ID: "ParameterValueLGHeader_parameter",
                contents: "<span><b>" + "<spring:message code="values"/>" + "</b></span>", height: "30", align: "center", showEdges: true, edgeOffset: 5, edgeSize: 2
            }),
            ParameterValueTS_parameter, "filterEditor", "header", "body"
        ],
        contextMenu: ParameterValueMenu_parameter,
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            let totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown())
                CountParameterValueLG_parameter.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            else
                CountParameterValueLG_parameter.setContents("&nbsp;");
        },
        doubleClick: function () {
            editParameterValue_parameter();
        }
    });

    // ------------------------------------------- DynamicForm & Window -------------------------------------------
    ParameterDF_parameter = isc.DynamicForm.create({
        ID: "ParameterDF_parameter",
        fields: [
            {name: "id", hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, validators: [TrValidators.NotEmpty],},
            {name: "code", title: "<spring:message code="code"/>", required: true, validators: [TrValidators.NotEmpty],},
            {name: "type", title: "<spring:message code="type"/>"},
            {name: "description", title: "<spring:message code="description"/>", type: "TextAreaItem",},
        ]
    });

    ParameterWin_parameter = isc.Window.create({
        ID: "ParameterWin_parameter",
        width: 800,
        items: [ParameterDF_parameter, isc.TrHLayoutButtons.create({
            members: [
                isc.IButtonSave.create({click: function () { saveParameter_parameter(); }}),
                isc.IButtonCancel.create({click: function () { ParameterWin_parameter.close(); }}),
            ],
        }),]
    });

    ParameterValueDF_parameter = isc.DynamicForm.create({
        ID: "ParameterValueDF_parameter",
        fields: [
            {name: "id", hidden: true},
            {name: "parameter.id", hidden: true,},
            {name: "parameter.title", title: "<spring:message code="parameter.type"/>", canEdit: false},
            {name: "title", title: "<spring:message code="title"/>", required: true, validators: [TrValidators.NotEmpty],},
            {name: "code", title: "<spring:message code="code"/>",},
            {name: "value", title: "<spring:message code="value"/>",},
            {name: "type", title: "<spring:message code="type"/>",},
            {name: "description", title: "<spring:message code="description"/>", type: "TextAreaItem",},
        ]
    });

    ParameterValueWin_parameter = isc.Window.create({
        ID: "ParameterValueWin_parameter",
        width: 800,
        items: [ParameterValueDF_parameter, isc.TrHLayoutButtons.create({
            members: [
                isc.IButtonSave.create({click: function () { saveParameterValue_parameter(); }}),
                isc.IButtonCancel.create({click: function () { ParameterValueWin_parameter.close(); }}),
            ],
        }),]
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrHLayout.create({
        members: [ParameterLG_parameter, ParameterValueLG_parameter]
    });

    // ------------------------------------------- Functions -------------------------------------------

    function refreshParameterValueLG_parameter() {
       ParameterValueLGHeader_parameter.set
            contents: "<span><b>" + "<spring:message code="values"/>" + "</b></span>"

        var record = ParameterLG_parameter.getSelectedRecord();
        if (checkRecordAsSelected(record, false)) {
            refreshListGridSource(ParameterValueLG_parameter, ParameterValueDS_parameter, parameterValueUrl + "/iscList/" + record.id)
        }
    }

    function createParameter_parameter() {
        parameterMethod_parameter = "POST";
        ParameterDF_parameter.clearValues();
        ParameterWin_parameter.setTitle("<spring:message code="create"/>&nbsp;" + "<spring:message code="parameter.type"/>");
        ParameterWin_parameter.show();
    }

    function saveParameter_parameter() {
        if (!ParameterDF_parameter.validate()) {
            return;
        }
        let parameterSaveUrl = parameterUrl;
        action = '<spring:message code="create"/>';
        if (parameterMethod_parameter.localeCompare("PUT") == 0) {
            let record = ParameterLG_parameter.getSelectedRecord();
            parameterSaveUrl += "/" + record.id;
            action = '<spring:message code="edit"/>';
        }
        let data = ParameterDF_parameter.getValues();
        isc.RPCManager.sendRequest(
            TrDSRequest(parameterSaveUrl, parameterMethod_parameter, JSON.stringify(data), "callback: studyResponse(rpcResponse, '" + action + "','" + "<spring:message code="parameter.type"/>" +
                "', ParameterWin_parameter, ParameterLG_parameter)")
        );
    }



    function createParameterValue_parameter() {
        let record = ParameterLG_parameter.getSelectedRecord();
        if (checkRecordAsSelected(record, true, "<spring:message code="parameter.type"/>")) {
            parameterValueMethod_parameter = "POST";
            ParameterValueDF_parameter.clearValues();
            ParameterValueDF_parameter.getItem("parameter.id").setValue(record.id);
            ParameterValueDF_parameter.getItem("parameter.title").setValue(record.title);
            ParameterValueWin_parameter.setTitle("<spring:message code="create"/>&nbsp;" + "<spring:message code="parameter.value"/>");
            ParameterValueWin_parameter.show();
        }
    }

    function saveParameterValue_parameter() {
        if (!ParameterValueDF_parameter.validate()) {
            return;
        }
        let parameterValueSaveUrl = parameterValueUrl;
        let action = '<spring:message code="create"/>';
        if (parameterValueMethod_parameter.localeCompare("PUT") == 0) {
            let record = ParameterValueLG_parameter.getSelectedRecord();
            parameterValueSaveUrl += "/" + record.id;
            action = '<spring:message code="edit"/>';
        }
        let data = ParameterValueDF_parameter.getValues();
        isc.RPCManager.sendRequest(
            TrDSRequest(parameterValueSaveUrl, parameterValueMethod_parameter, JSON.stringify(data), "callback: studyResponse(rpcResponse, '" + action + "','" + "<spring:message code="parameter.value"/>" + "')")
        );
    }

    function editParameter_parameter() {
        let record = ParameterLG_parameter.getSelectedRecord();
        if (checkRecordAsSelected(record, true, "<spring:message code="parameter.type"/>")) {
            parameterMethod_parameter = "PUT";
            ParameterDF_parameter.clearValues();
            ParameterDF_parameter.editRecord(record);
            ParameterWin_parameter.setTitle("<spring:message code="edit"/>&nbsp;" + "<spring:message code="parameter.type"/>");
            ParameterWin_parameter.show();
        }
    }

    function editParameterValue_parameter() {
        let record = ParameterValueLG_parameter.getSelectedRecord();
        if (checkRecordAsSelected(record, true, "<spring:message code="parameter.value"/>")) {
            parameterValueMethod_parameter = "PUT";
            ParameterValueDF_parameter.clearValues();
            ParameterValueDF_parameter.editRecord(record);
            ParameterValueWin_parameter.setTitle("<spring:message code="edit"/>&nbsp;" + "<spring:message code="parameter.value"/>");
            ParameterValueWin_parameter.show();
        }
    }

    function removeParameter_parameter() {
        let record = ParameterLG_parameter.getSelectedRecord();
        if (checkRecordAsSelected(record, true, "<spring:message code="parameter.type"/>")) {
            let dialog = createDialog('ask', "<spring:message code="msg.record.remove.ask"/>");
            dialog.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index == 0) {
                        isc.RPCManager.sendRequest(
                            TrDSRequest(parameterUrl + "/" + record.id, "DELETE", null, "callback: studyResponse(rpcResponse, '" + "<spring:message code="remove"/>" + "','" + "<spring:message
                            code="parameter.type"/>" + "','" + record.title + "')")
                        );
                    }
                }
            })
        }
    }

    function removeParameterValue_parameter() {
        let record = ParameterValueLG_parameter.getSelectedRecord();
        if (checkRecordAsSelected(record, true, "<spring:message code="parameter.value"/>")) {
            let dialog = createDialog('ask', "<spring:message code="msg.record.remove.ask"/>");
            dialog.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index == 0) {
                        isc.RPCManager.sendRequest(
                            TrDSRequest(parameterValueUrl + "/" + record.id, "DELETE", null, "callback: studyResponse(rpcResponse, '" + "<spring:message code="remove"/>" + "','" + "<spring:message
                            code="parameter.value"/>" + "','" + record.title + "')")
                        );
                    }
                }
            })
        }
    }

    <%--function studyResponse(resp, action, entityTypeName, entityName) {--%>
    <%--    let msg;--%>
    <%--    let selectedState;--%>
    <%--    if (resp == null) {--%>
    <%--        msg = "<spring:message code="msg.error.connecting.to.server"/>";--%>
    <%--    } else {--%>
    <%--        let respCode = resp.httpResponseCode;--%>
    <%--        if (respCode == 200) {--%>
    <%--            selectedState = "[{id:" + JSON.parse(resp.data).id + "}]";--%>
    <%--            console.log('selectedState:');--%>
    <%--            console.log(selectedState);--%>
    <%--            let entityName = JSON.parse(resp.httpResponseText).title;--%>
    <%--            if ((action == null || action == undefined) || (entityTypeName == null || entityTypeName == undefined) || (entityName == null || entityName == undefined)) {--%>
    <%--                msg = "<spring:message code="msg.operation.successful"/>";--%>
    <%--            } else {--%>
    <%--                msg = action + '&nbsp;' + entityTypeName + '&nbsp;\'<b>' + entityName + '</b>\'&nbsp;' + "<spring:message code="msg.successfully.done"/>";--%>
    <%--            }--%>
    <%--        } else {--%>
    <%--            if (respCode == 409) {--%>
    <%--                msg = action + '&nbsp;' + entityTypeName + '&nbsp;\'<b>' + entityName + '</b>\'&nbsp;' + "<spring:message code="msg.is.not.possible"/>";--%>
    <%--            } else {--%>
    <%--                msg = "<spring:message code='msg.operation.error'/>";--%>
    <%--            }--%>
    <%--        }--%>
    <%--        var dialog = createDialog("info", msg);--%>
    <%--        Timer.setTimeout(function () {--%>
    <%--            dialog.close();--%>
    <%--        }, dialogShowTime * 1.5);--%>
    <%--        ParameterWin_parameter.close();--%>
    <%--        ParameterValueWin_parameter.close();--%>
    <%--        refreshParameterLG_parameter(selectedState);--%>
    <%--    }--%>
    <%--}--%>

    function checkRecordAsSelected(record, showDialog, entityName, msg) {
        if (record ? (record.constructor === Array ? ((record.length > 0) ? true : false) : true) : false) {
            return true;
        }
        if (showDialog) {
            let dialog = createDialog("info", msg ? msg : (entityName ? "<spring:message code="from"/>&nbsp;<b>" + entityName + "</b>&nbsp;<spring:message code="msg.no.records.selected"/>" : "<spring:message code="msg.no.records.selected"/>"));
            Timer.setTimeout(function () {
                dialog.close();
            }, dialogShowTime);
        }
        return false;
    }
