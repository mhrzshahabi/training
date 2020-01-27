<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>
    // ------------------------------------------- Rest Data Source ----------------------------------------------------
    var RestDataSource_Teacher_JspBlackList = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "personality.id"},
            {name: "teacherCode"},
            {name: "personality.firstNameFa"},
            {name: "personality.lastNameFa"},
            {name: "enableStatus"},
            {name: "inBlackList"}
        ],
        fetchDataURL: teacherUrl + "full-spec-list"
    });
    // ------------------------------------------- Menu ----------------------------------------------------------------
    var Menu_ListGrid_JspBlackList = isc.Menu.create({
        width: 150,
        data: [{
            title: "<spring:message code='refresh'/>", click: function () {
                ListGrid_blackList_refresh();
            }
        }, {
            title: "<spring:message code='add.or.delete.blackList'/>", click: function () {
                ListGrid_blackList_edit();
            }
        }
        ]
    });
    // ------------------------------------------- ListGrid ------------------------------------------------------------
    ListGrid_Teacher_JspBlackList = isc.TrLG.create({
        ID: "blackListLG_blackList",
        dataSource: RestDataSource_Teacher_JspBlackList,
        contextMenu: Menu_ListGrid_JspBlackList,
        sortField: 1,
        sortDirection: "descending",
        filterOnKeypress: true,
        fields: [
            {name: "id", title: "id", canEdit: false, hidden: true},
            {
                name: "inBlackList",
                type: "boolean",
                canFilter: false,
                hidden: true
            },
            {
                name: "teacherCode",
                title: "<spring:message code='code'/>",
                align: "center"
            },
            {
                name: "personality.firstNameFa",
                title: "<spring:message code='firstName'/>",
                align: "center",
                sortNormalizer: function (record) {
                    return record.personality.firstNameFa;
                }
            },
            {
                name: "personality.lastNameFa",
                title: "<spring:message code='lastName'/>",
                align: "center",
                sortNormalizer: function (record) {
                    return record.personality.lastNameFa;
                }
            },
            {
                name: "enableStatus",
                title: "<spring:message code='status'/>",
                align: "center",
                type: "boolean",
                canFilter: false
            }
        ],
        autoFetchData: true,
        rowDoubleClick: function () {
            ListGrid_blackList_edit();
        },
        getCellCSSText: function (record, rowNum, colNum) {
            if (record.inBlackList) {
                return "color:red;font-size: 12px;";
            }
            if (!record.inBlackList) {
                return "color:green;font-size: 12px;";
            }
        }
    });
    // ------------------------------------------- ToolStrip -----------------------------------------------------------
    var ToolStripButton_Refresh_JspBlackList = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_blackList_refresh();
        }
    });

    var ToolStripButton_Edit_JspBlackList = isc.ToolStripButton.create({
        title: "<spring:message code='add.or.delete.blackList'/>",
        click: function () {
            ListGrid_blackList_edit();
        }
    });
    // ------------------------------------------- Page UI -------------------------------------------------------------
    var ToolStrip_Actions_JspBlackList = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            ToolStripButton_Edit_JspBlackList,
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh_JspBlackList
                ]
            })
        ]
    });

    var HLayout_Grid_JspBlackList = isc.TrHLayout.create({
        members: [ListGrid_Teacher_JspBlackList]
    });

    var HLayout_Actions_JspBlackList = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_JspBlackList]
    });

    var VLayout_Body_JspBlackList = isc.TrVLayout.create({
        members: [
            HLayout_Actions_JspBlackList,
            HLayout_Grid_JspBlackList
        ]
    });

    //------------------------------------------ Functions -------------------------------------------------------------
    function ListGrid_blackList_refresh() {
        ListGrid_Teacher_JspBlackList.invalidateCache();
        ListGrid_Teacher_JspTeacher.invalidateCache();
        ListGrid_Teacher_JspBlackList.invalidateCache();
    }

    function ListGrid_blackList_edit() {
        var record = ListGrid_Teacher_JspBlackList.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            return;
        }
        if (record.inBlackList) {
            var Dialog_Remove_Ask = createDialog("ask", "<spring:message code='msg.remove.black.list'/>",
                "<spring:message code='global.warning'/>");
            Dialog_Remove_Ask.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        isc.RPCManager.sendRequest(TrDSRequest(teacherUrl + "blackList/" + record.inBlackList + "/" + record.id, "GET", null, null));
                        setTimeout(function () {
                            ListGrid_blackList_refresh();
                        }, 300);
                    }
                }
            });
        }

        if (!record.inBlackList) {
            var Dialog_Add_Ask = createDialog("ask", "<spring:message code='msg.add.black.list'/>",
                "<spring:message code='global.warning'/>");
            Dialog_Add_Ask.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        isc.RPCManager.sendRequest(TrDSRequest(teacherUrl + "blackList/" + record.inBlackList + "/" + record.id, "GET", null, null));
                        setTimeout(function () {
                            ListGrid_blackList_refresh();
                        }, 300);
                    }
                }
            });
        }

    }
