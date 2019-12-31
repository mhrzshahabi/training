<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    var groupMethod_group;

    // ------------------------------------------- Menu -------------------------------------------
    isc.Menu.create({
        ID: "GroupMenu_group",
        data: [
            {title: "<spring:message code="refresh"/>", click: function () {refreshListGrid(GroupLG_group); }},
            {title: "<spring:message code="create"/>", click: function () { createGroup_group(); }},
            {title: "<spring:message code="edit"/>", click: function () { editGroup_group(); }},
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    isc.ToolStrip.create({
        ID: "GroupTS_group",
        width: "100%",
        membersMargin: 5,
        border: "0px solid",
        members: [
            isc.ToolStripButtonRefresh.create({click: function () {refreshListGrid(GroupLG_group); }}),
            isc.ToolStripButtonCreate.create({click: function () { createGroup_group(); }}),
            isc.ToolStripButtonEdit.create({click: function () { editGroup_group(); }}),
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "CountGroupLG_group"}),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    GroupDS_group = isc.TrDS.create({
        ID: "GroupDS_group",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "version", hidden: true}
        ],
        fetchDataURL: oauthGroupUrl + "/spec-list"
    });

    GroupLG_group = isc.TrLG.create({
        ID: "GroupLG_group",
        dataSource: GroupDS_group,
        fields: [
            {name: "title",},
        ],
        sortField: 0,
        autoFetchData: true,
        gridComponents: [
            GroupTS_group, "filterEditor", "header", "body"
        ],
        contextMenu: GroupMenu_group,
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            let totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown())
                CountGroupLG_group.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            else
                CountGroupLG_group.setContents("&nbsp;");
        },
        doubleClick: function () {
            editGroup_group();
        }
    });

    // ------------------------------------------- DynamicForm & Window -------------------------------------------
    GroupDF_group = isc.DynamicForm.create({
        ID: "GroupDF_group",
        fields: [
            {name: "id", hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, validators: [TrValidators.NotEmpty],},
            {name: "version", hidden: true},
        ]
    });

    GroupWin_group = isc.Window.create({
        ID: "GroupWin_group",
        width: 800,
        items: [GroupDF_group, isc.TrHLayoutButtons.create({
            members: [
                isc.IButtonSave.create({click: function () { saveGroup_group(); }}),
                isc.IButtonCancel.create({click: function () { GroupWin_group.close(); }}),
            ],
        }),]
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [GroupLG_group],
    });

    // ------------------------------------------- Functions -------------------------------------------

    function createGroup_group() {
        groupMethod_group = "POST";
        GroupDF_group.clearValues();
        GroupWin_group.setTitle("<spring:message code="create"/>&nbsp;" + "<spring:message code="group"/>");
        GroupWin_group.show();
    }

    function editGroup_group() {
        let record = GroupLG_group.getSelectedRecord();
        if (checkRecordAsSelected(record, true, "<spring:message code="permission.groups"/>")) {
            groupMethod_group = "PUT";
            GroupDF_group.clearValues();
            GroupDF_group.editRecord(record);
            GroupWin_group.setTitle("<spring:message code="edit"/>&nbsp;" + "<spring:message code="group"/>");
            GroupWin_group.show();
        }
    }

    function saveGroup_group() {
        if (!GroupDF_group.validate()) {
            return;
        }
        let groupSaveUrl = oauthGroupUrl;
        action = '<spring:message code="create"/>';
        if (groupMethod_group.localeCompare("PUT") == 0) {
            let record = GroupLG_group.getSelectedRecord();
            groupSaveUrl += "/" + record.id;
            action = '<spring:message code="edit"/>';
        }
        let data = GroupDF_group.getValues();
        isc.RPCManager.sendRequest(
            TrDSRequest(groupSaveUrl, groupMethod_group, JSON.stringify(data), "callback: studyResponse(rpcResponse, '" + action + "','" + "<spring:message code="permission.group"/>" +
                "', GroupWin_group, GroupLG_group)")
        );
    }