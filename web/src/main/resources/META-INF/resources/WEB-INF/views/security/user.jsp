<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    // ------------------------------------------- Menu -------------------------------------------
    isc.Menu.create({
        ID: "UserMenu_user",
        data: [
            {title: "<spring:message code="refresh"/>", click: function () { refreshListGrid(UserLG_user); }},
            {title: "<spring:message code="user.roles"/>", click: function () { editUser_user()}},
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    isc.ToolStrip.create({
        ID: "UserTS_user",
        width: "100%",
        membersMargin: 5,
        border: "0px solid",
        members: [
            isc.ToolStripButtonRefresh.create({click: function () { refreshListGrid(UserLG_user); }}),
            isc.ToolStripButton.create({title: "<spring:message code="user.roles"/>", click: function () { editUser_user()}}),
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "CountUserLG_user"}),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    UserDS_user = isc.TrDS.create({
        ID: "UserDS_user",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "username", title: "<spring:message code="username"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "version", hidden: true}
        ],
        fetchDataURL: oauthUserUrl + "/spec-list"
    });

    UserLG_user = isc.TrLG.create({
        ID: "UserLG_user",
        dataSource: UserDS_user,
        autoFetchData: true,
        fields: [
            {name: "firstName",},
            {name: "lastName",},
            {name: "username",},
            {name: "nationalCode",},
        ],
        sortField: 0,
        showResizeBar: true,
        gridComponents: [
            UserTS_user, "filterEditor", "header", "body"
        ],
        contextMenu: UserMenu_user,
        dataChanged: function () {
            this.Super("dataChanged", arguments);
            let totalRows = this.data.getLength();
            if (totalRows >= 0 && this.data.lengthIsKnown())
                CountUserLG_user.setContents("<spring:message code="records.count"/>" + ":&nbsp;<b>" + totalRows + "</b>");
            else
                CountUserLG_user.setContents("&nbsp;");
        },
        doubleClick: function () { editUser_user(); },
        selectionUpdated: function () {
        },
    });

    // ------------------------------------------- TabSet -------------------------------------------

    let UserTabs_user = isc.TabSet.create({
        tabs: [
            {
                ID: "RoleTab_user",
                title: "<spring:message code="roles"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "web/oaRole"}),
                // tabSelected: function (tabSet, tabNum, tabPane, ID, tab) {
                //     if (checkRecordAsSelected(UserLG_user.getSelectedRecord())) {
                //         RoleDS_role.fetchDataURL
                //     }
                //     // isc.Log.logWarn("zero" + tabPane + " null:" + (tabPane == null));
                //     //
                //     // if (tabPane == null) {
                //     //     isc.DynamicForm.create({
                //     //         ID: "preferencesPane",
                //     //         fields: [{
                //     //             name: "useISCTabs",
                //     //             title: "Use SmartClient tabs",
                //     //             type: "checkbox",
                //     //             defaultValue: false,
                //     //             required: true
                //     //         }]
                //     //     });
                //     //     tabSet.updateTab(ID, preferencesPane);
                //     // }
                // },
                // tabDeselected: function (tabSet, tabNum, tabPane, ID, tab, newTab) {
                //     // if (!tabPane.getValue("useISCTabs")) {
                //     //     return false;
                //     // }
                // }
            },
            {
                ID: "PermissionGroupTab_user",
                title: "<spring:message code="permission.groups"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "web/oaGroup"})
            },
            {
                ID: "PermissionTab_user",
                title: "<spring:message code="permissions"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "web/oaPermission"})
            },
        ],
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrVLayout.create({
        members: [UserLG_user, isc.HLayout.create({members: [UserTabs_user]})],
    });

    // ------------------------------------------- Functions -------------------------------------------
    function editUser_user() {
        userRecord = UserLG_user.getSelectedRecord();
        if (checkRecordAsSelected(userRecord, true)) {
        }
    }