<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    // ------------------------------------------- Menu -------------------------------------------
    isc.Menu.create({
        ID: "RoleMenu_role",
        data: [
            {title: "<spring:message code="refresh"/>", click: function () { refreshRoleLG_role(); }},
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
            isc.ToolStripButtonRefresh.create({click: function () { refreshRoleLG_role(); }}),
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
        fields: [
            {name: "title",},
        ],
        sortField: 0,
        autoFetchData: true,
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

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [RoleLG_role],
    });

    // ------------------------------------------- Functions -------------------------------------------
    function refreshRoleLG_role(selectedState) {
        RoleLG_role.invalidateCache();
        RoleLG_role.filterByEditor();
    }