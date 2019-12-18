<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    // <<========== Global - Variables ==========
    {

    }
    // ============ Global - Variables ========>>


    // <<-------------------------------------- Create - RestDataSource & ListGrid ----------------------------
    {
        var RestDataSource_alarm = isc.TrDS.create({
            transformRequest: function (dsRequest) {
                dsRequest.httpHeaders = {
                    "Authorization": "Bearer <%= accessToken %>"
                };
                return this.Super("transformRequest", arguments);
            },
            fields:
                [
                    // {name: "id", primaryKey: true},
                    {name: "targetRecordId", autoFitWidth: true},
                    {name: "tabName", autoFitWidth: true},
                    {name: "pageAddress", autoFitWidth: true},
                    {name: "alarmType", autoFitWidth: true},
                    {name: "alarm"}
                ]
            ////// ,
            ////// fetchDataURL: classAlarm + "list"
        });


        var ListGrid_alarm = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_alarm,
            canAddFormulaFields: false,
            showFilterEditor: true,
            allowAdvancedCriteria: true,
            allowFilterExpressions: true,
            filterOnKeypress: true,
            initialSort: [
                {property: "alarmType", direction: "ascending"},
                {property: "targetRecordId", direction: "ascending"}
            ],
            selectionType: "single",
            fields: [
                {
                    name: "targetRecordId",
                    title: "targetRecordId",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "tabName",
                    title: "tabName",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "pageAddress",
                    title: "pageAddress",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "alarmType",
                    title: "<spring:message code="alarm.type"/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "alarm",
                    title: "<spring:message code="alarms"/>",
                    align: "center",
                    filterOperator: "iContains"
                }
            ],
            doubleClick: function () {
                select_Target();
            }
        });

    }
    // ---------------------------------------- Create - RestDataSource & ListGrid -------------------------->>


    // <<-------------------------------------- Create - ToolStripButton --------------------------------------
    {
        var ToolStripButton_Refresh = isc.ToolStripButtonRefresh.create({
            click: function () {
                ListGrid_alarm.invalidateCache();
            }
        });

        var ToolStrip_alarm = isc.ToolStrip.create({
            width: "100%",
            members: [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh
                    ]
                })
            ]
        });
    }
    // ---------------------------------------- Create - ToolStripButton ------------------------------------>>


    // <<-------------------------------------- Create - HLayout & VLayout ------------------------------------
    {
        var HLayout_Actions_alarm = isc.HLayout.create({
            width: "100%",
            members: [ToolStrip_alarm]
        });

        var Hlayout_Grid_alarm = isc.HLayout.create({
            width: "100%",
            height: "100%",
            members: [ListGrid_alarm]
        });

        var VLayout_Body_alarm = isc.TrVLayout.create({
            width: "100%",
            height: "100%",
            members: [HLayout_Actions_alarm, Hlayout_Grid_alarm]
        });
    }
    // ---------------------------------------- Create - HLayout & VLayout ---------------------------------->>


    // <<----------------------------------------------- Functions --------------------------------------------
    {

        function loadPage_alarm() {
            classRecord = ListGrid_Class_JspClass.getSelectedRecord();
            if (!(classRecord == undefined || classRecord == null)) {
                RestDataSource_alarm.fetchDataURL = classAlarm + "list" + "/" + ListGrid_Class_JspClass.getSelectedRecord().id;
                ListGrid_alarm.invalidateCache();
                ListGrid_alarm.fetchData();
            }
        }

    }
    // ------------------------------------------------- Functions ------------------------------------------>>


    //</script>