<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>

    let parameterMethod_parameter;
    let parameterValueMethod_parameter;

    // ------------------------------------------- Menu -------------------------------------------
    isc.Menu.create({
        ID: "ParameterMenu_parameter",
        data: [
            {title: "<spring:message code="refresh"/>", click: function () { refreshLG(ParameterLG_parameter, cleanLG(ParameterValueLG_parameter)); }},
            <sec:authorize access="hasAuthority('Parameter_C')">
            {title: "<spring:message code="create"/>", click: function () { createParameter_parameter(); }},
            </sec:authorize>
            // {title: "<spring:message code="edit"/>", click: function () { editParameter_parameter(); }},
            // {title: "<spring:message code="remove"/>", click: function () { removeParameter_parameter(); }},
        ]
    });

    isc.Menu.create({
        ID: "ParameterValueMenu_parameter",
        data: [
            {title: "<spring:message code="refresh"/>", click: function () { refreshParameterValueLG_parameter(); }},
            <sec:authorize access="hasAuthority('Parameter_C')">
            {title: "<spring:message code="create"/>", click: function () { createParameterValue_parameter(); }},
            </sec:authorize>
            // {title: "<spring:message code="edit"/>", click: function () { editParameterValue_parameter(); }},
            // {title: "<spring:message code="remove"/>", click: function () { removeParameterValue_parameter(); }},
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    isc.ToolStrip.create({
        ID: "ParameterTS_parameter",
        members: [
            isc.ToolStripButtonRefresh.create({click: function () { refreshLG(ParameterLG_parameter, cleanLG(ParameterValueLG_parameter)); }}),
            <sec:authorize access="hasAuthority('Parameter_C')">
            isc.ToolStripButtonCreate.create({click: function () { createParameter_parameter(); }}),
            </sec:authorize>
            // isc.ToolStripButtonEdit.create({click: function () { editParameter_parameter(); }}),
            // isc.ToolStripButtonRemove.create({click: function () { removeParameter_parameter(); }}),
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "ParameterLGCountLabel_parameter"}),
        ]
    });

    isc.ToolStrip.create({
        ID: "ParameterValueTS_parameter",
        members: [
            isc.ToolStripButtonRefresh.create({click: function () { refreshParameterValueLG_parameter(); }}),
            <sec:authorize access="hasAuthority('Parameter_C')">
            isc.ToolStripButtonCreate.create({click: function () { createParameterValue_parameter(); }}),
            </sec:authorize>
            // isc.ToolStripButtonEdit.create({click: function () { editParameterValue_parameter(); }}),
            // isc.ToolStripButtonRemove.create({click: function () { removeParameterValue_parameter(); }}),
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "ParameterValueLGCount_parameter"}),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    ParameterDS_parameter = isc.TrDS.create({
        ID: "ParameterDS_parameter",
        fields: [
            {name: "id", primaryKey: true, title: "<spring:message code="identity"/>", filterOperator: "equals", autoFitWidth: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "type", title: "<spring:message code="type"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: parameterUrl + "/iscList",
    });

    ParameterLG_parameter = isc.TrLG.create({
        ID: "ParameterLG_parameter",
        <sec:authorize access="hasAuthority('Parameter_R')">
        dataSource: ParameterDS_parameter,
        </sec:authorize>
        autoFetchData: true,
        fields: [{name: "id", filterEditorProperties: {keyPressFilter: "[0-9]"}}, {name: "title"}, {name: "code"}, {name: "type"}, {name: "description"},],
        gridComponents: [
            isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="type"/>" + "</b></span>",}),
            ParameterTS_parameter, "filterEditor", "header", "body"
        ],
        contextMenu: ParameterMenu_parameter,
        dataChanged: function () { updateCountLabel(this, ParameterLGCountLabel_parameter)},
        // recordDoubleClick: function () { editParameter_parameter(); },
        selectionUpdated: function () { refreshParameterValueLG_parameter(); }
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
        ],
    });

    ParameterValueLG_parameter = isc.TrLG.create({
        ID: "ParameterValueLG_parameter",
        <sec:authorize access="hasAuthority('Parameter_R')">
        dataSource: ParameterValueDS_parameter,
        </sec:authorize>
        fields: [{name: "title"}, {name: "code"}, {name: "type"}, {name: "value"}, {name: "description"},],
        gridComponents: [
            isc.LgLabel.create({
                contents: "<span><b>" + "<spring:message code="values"/>" + "</b></span>"
            }),
            ParameterValueTS_parameter, "filterEditor", "header", "body"
        ],
        contextMenu: ParameterValueMenu_parameter,
        dataChanged: function () { updateCountLabel(this, ParameterValueLGCount_parameter)},
        // recordDoubleClick: function () { editParameterValue_parameter(); }
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
            {name: "parameter.id", dataPath: "parameterId", hidden: true,},
            {name: "parameter.title", title: "<spring:message code="parameter.type"/>", canEdit: false},
            {name: "title", title: "<spring:message code="title"/>", required: true, validators: [TrValidators.NotEmpty],},
            {name: "code", title: "<spring:message code="code"/>", required: true,},
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
    function createParameter_parameter() {
        parameterMethod_parameter = "POST";
        ParameterDF_parameter.clearValues();
        ParameterWin_parameter.setTitle("<spring:message code="create"/>&nbsp;" + "<spring:message code="parameter.type"/>");
        ParameterWin_parameter.show();
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

    function saveParameter_parameter() {
        if (!ParameterDF_parameter.validate()) {
            return;
        }
        let parameterSaveUrl = parameterUrl;
        let action = '<spring:message code="create"/>';
        if (parameterMethod_parameter.localeCompare("PUT") === 0) {
            let record = ParameterLG_parameter.getSelectedRecord();
            parameterSaveUrl += "/" + record.id;
            action = '<spring:message code="edit"/>';
        }
        let data = ParameterDF_parameter.getValues();
        isc.RPCManager.sendRequest(
            TrDSRequest(parameterSaveUrl, parameterMethod_parameter, JSON.stringify(data),
                "callback: studyResponse(rpcResponse, '" + action + "','<spring:message code="parameter"/>', ParameterWin_parameter, ParameterLG_parameter, '" + ParameterDF_parameter.getValue("title") + "')")
        );
    }

    function removeParameter_parameter() {
        let record = ParameterLG_parameter.getSelectedRecord();
        let entityType = '<spring:message code="parameter.type"/>';
        if (checkRecordAsSelected(record, true, entityType)) {
            removeRecord(parameterUrl + "/" + record.id, entityType, record.title, 'ParameterLG_parameter');
        }
    }

    // ---------------------------------------------------------------------------------------------------

    function refreshParameterValueLG_parameter() {
        let record = ParameterLG_parameter.getSelectedRecord();
        if (checkRecordAsSelected(record, false)) {
            refreshLgDs(ParameterValueLG_parameter, ParameterValueDS_parameter, parameterValueUrl + "/iscList/" + record.id)
        }
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

    function editParameterValue_parameter() {
        let parameterRecord = ParameterLG_parameter.getSelectedRecord();
        let record = ParameterValueLG_parameter.getSelectedRecord();
        if (checkRecordAsSelected(record, true, "<spring:message code="parameter.value"/>")) {
            parameterValueMethod_parameter = "PUT";
            ParameterValueDF_parameter.clearValues();
            ParameterValueDF_parameter.editRecord(record);
            ParameterValueDF_parameter.getItem("parameter.id").setValue(parameterRecord.id);
            ParameterValueDF_parameter.getItem("parameter.title").setValue(parameterRecord.title);
            ParameterValueWin_parameter.setTitle("<spring:message code="edit"/>&nbsp;" + "<spring:message code="parameter.value"/>");
            ParameterValueWin_parameter.show();
        }
    }

    function saveParameterValue_parameter() {
        if (!ParameterValueDF_parameter.validate()) {
            return;
        }
        let parameterValueSaveUrl = parameterValueUrl;
        let action = '<spring:message code="create"/>';
        if (parameterValueMethod_parameter.localeCompare("PUT") === 0) {
            let record = ParameterValueLG_parameter.getSelectedRecord();
            parameterValueSaveUrl += "/" + record.id;
            action = '<spring:message code="edit"/>';
        }
        let data = ParameterValueDF_parameter.getValues();
        isc.RPCManager.sendRequest(
            TrDSRequest(parameterValueSaveUrl, parameterValueMethod_parameter, JSON.stringify(data), "callback: studyResponse(rpcResponse, '" + action + "','" + "<spring:message code="parameter.value"/>" +
                "', ParameterValueWin_parameter, ParameterValueLG_parameter, '" + ParameterValueDF_parameter.getValue("title") + "')")
        );
    }

    function removeParameterValue_parameter() {
        let record = ParameterValueLG_parameter.getSelectedRecord();
        let entityType = '<spring:message code="parameter.value"/>';
        if (checkRecordAsSelected(record, true, entityType)) {
            removeRecord(parameterValueUrl + "/" + record.id, entityType, record.title, 'ParameterValueLG_parameter');
        }
    }

    //</script>