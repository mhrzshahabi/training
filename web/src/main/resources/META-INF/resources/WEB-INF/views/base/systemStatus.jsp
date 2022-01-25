<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN); %>

// <script>

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    RestDataSource_System_Status = isc.TrDS.create({
        fields: [
            {name: "systemName", title: "نام سیستم", filterOperator: "iContains"},
            {name: "status", title: "<spring:message code="status"/>", filterOperator: "iContains"}
        ],
        transformRequest: function (dsRequest) {
            dsRequest.params = {
                "token": "<%= accessToken %>"
            };
            return this.Super("transformRequest", arguments);
        },
        fetchDataURL: systemStatusUrl + "/get-status"
    });

    //-------------------------------------------------- layOut --------------------------------------------------------
    ToolStripButton_System_Status_Refresh = isc.ToolStripButtonRefresh.create({
        click: function () {
            System_Status_Refresh();
        }
    });
    ToolStrip_Actions_System_Status = isc.ToolStrip.create({
        width: "100%",
        height: "5%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_System_Status_Refresh
                    ]
                })
            ]
    });

    ListGrid_System_Status = isc.TrLG.create({
        height: "90%",
        autoFetchData: true,
        showFilterEditor: true,
        filterOnKeypress: false,
        dataSource: RestDataSource_System_Status,
        gridComponents: ["filterEditor", "header", "body"],
        fields: [
            {name: "systemName"},
            {name: "status"}
        ],
        getCellCSSText: function (record) {
            if (record.status === "UP")
                return "background-color : #d8e4bc";
            else
                return "background-color : #e67e7e";
        },
    });

    VLayout_Body_System_Status = isc.TrVLayout.create({
        members: [
            ToolStrip_Actions_System_Status,
            ListGrid_System_Status
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------
    function System_Status_Refresh() {
        ListGrid_System_Status.invalidateCache();
    }

// </script>