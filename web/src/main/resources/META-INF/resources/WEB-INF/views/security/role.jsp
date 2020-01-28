<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    var roleMethod_role;

    // ------------------------------------------- Menu -------------------------------------------
    isc.Menu.create({
        ID: "RoleMenu_role",
        data: [
            {title: "<spring:message code="refresh"/>", click: function () {refreshListGrid(RoleLG_role); }},
            {title: "<spring:message code="create"/>", click: function () { createRole_role(); }},
            {title: "<spring:message code="edit"/>", click: function () { editRole_role(); }},
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    isc.ToolStrip.create({
        ID: "RoleTS_role",
        width: "100%",
        membersMargin: 5,
        border: "0px solid",
        members: [
            isc.ToolStripButtonRefresh.create({click: function () {refreshListGrid(RoleLG_role); }}),
            isc.ToolStripButtonCreate.create({click: function () { createRole_role(); }}),
            isc.ToolStripButtonEdit.create({click: function () { editRole_role(); }}),
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "CountRoleLG_role"}),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    RoleDS_role = isc.TrDS.create({
        ID: "RoleDS_role",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "version", hidden: true}
        ],
        fetchDataURL: oauthRoleUrl + "/spec-list"
    });

    RoleLG_role = isc.TrLG.create({
        ID: "RoleLG_role",
        dataSource: RoleDS_role,
        autoFetchData: true,
        fields: [
            {name: "title",},
        ],
        sortField: 0,
        gridComponents: [
            RoleTS_role, "filterEditor", "header", "body"
        ],
        contextMenu: RoleMenu_role,
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            let totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown())
                CountRoleLG_role.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            else
                CountRoleLG_role.setContents("&nbsp;");
        },
        doubleClick: function () {
            editRole_role();
        }
    });

    // ------------------------------------------- DynamicForm & Window -------------------------------------------
    RoleDF_role = isc.DynamicForm.create({
        ID: "RoleDF_role",
        fields: [
            {name: "id", hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, validators: [TrValidators.NotEmpty],},
            {name: "version", hidden: true},
        ]
    });

    RoleWin_role = isc.Window.create({
        ID: "RoleWin_role",
        width: 800,
        items: [RoleDF_role, isc.TrHLayoutButtons.create({
            members: [
                isc.IButtonSave.create({click: function () { saveRole_role(); }}),
                isc.IButtonCancel.create({click: function () { RoleWin_role.close(); }}),
            ],
        }),]
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [RoleLG_role],
    });

    // ------------------------------------------- Functions -------------------------------------------

    function createRole_role() {
        roleMethod_role = "POST";
        RoleDF_role.clearValues();
        RoleWin_role.setTitle("<spring:message code="create"/>&nbsp;" + "<spring:message code="role"/>");
        RoleWin_role.show();
    }

    function editRole_role() {
        let record = RoleLG_role.getSelectedRecord();
        if (checkRecordAsSelected(record, true, "<spring:message code="roles"/>")) {
            roleMethod_role = "PUT";
            RoleDF_role.clearValues();
            RoleDF_role.editRecord(record);
            RoleWin_role.setTitle("<spring:message code="edit"/>&nbsp;" + "<spring:message code="role"/>");
            RoleWin_role.show();
        }
    }

    function saveRole_role() {
        if (!RoleDF_role.validate()) {
            return;
        }
        let roleSaveUrl = oauthRoleUrl;
        action = '<spring:message code="create"/>';
        if (roleMethod_role.localeCompare("PUT") == 0) {
            let record = RoleLG_role.getSelectedRecord();
            roleSaveUrl += "/" + record.id;
            action = '<spring:message code="edit"/>';
        }
        let data = RoleDF_role.getValues();
        isc.RPCManager.sendRequest(
            TrDSRequest(roleSaveUrl, roleMethod_role, JSON.stringify(data), "callback: studyResponse(rpcResponse, '" + action + "','" + "<spring:message code="role"/>" + "', RoleWin_role, RoleLG_role)")
        );
    }

    function loadPage_role() {
        alert('loadPage_role');
        userRecord = UserLG_user.getSelectedRecord();
        if (checkRecordAsSelected(userRecord)) {alert()}
            //
    }