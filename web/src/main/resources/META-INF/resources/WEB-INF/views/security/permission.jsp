<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    var permissionMethod_permission;

    // ------------------------------------------- Menu -------------------------------------------
    isc.Menu.create({
        ID: "PermissionMenu_permission",
        data: [
            {title: "<spring:message code="refresh"/>", click: function () {refreshListGrid(PermissionLG_permission); }},
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    isc.ToolStrip.create({
        ID: "PermissionTS_permission",
        width: "100%",
        membersMargin: 5,
        border: "0px solid",
        members: [
            isc.ToolStripButtonRefresh.create({click: function () {refreshListGrid(PermissionLG_permission); }}),
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "CountPermissionLG_permission"}),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    PermissionDS_permission = isc.TrDS.create({
        ID: "PermissionDS_permission",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "version", hidden: true}
        ],
        fetchDataURL: oauthPermissionUrl + "/spec-list"
    });

    PermissionLG_permission = isc.TrLG.create({
        ID: "PermissionLG_permission",
        dataSource: PermissionDS_permission,
        fields: [
            {name: "title",},
            {name: "code",},
        ],
        sortField: 0,
        autoFetchData: true,
        gridComponents: [
            PermissionTS_permission, "filterEditor", "header", "body"
        ],
        contextMenu: PermissionMenu_permission,
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            let totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown())
                CountPermissionLG_permission.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            else
                CountPermissionLG_permission.setContents("&nbsp;");
        },
        doubleClick: function () {
            editPermission_permission();
        }
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [PermissionLG_permission],
    });