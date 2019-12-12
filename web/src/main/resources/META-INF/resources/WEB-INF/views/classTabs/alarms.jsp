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
                    {name: "id", primaryKey: true},
                    {name: "alarmTarget"},
                    {name: "alarmTargetId"},
                    {name: "alarmCode"},
                    {name: "alarmType"},
                    {name: "description"}
                ],
                     fetchDataURL: classAlarm + "list"
        });


        var ListGrid_alarm = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_alarm,
            canAddFormulaFields: false,
             autoFetchData: true,
            showFilterEditor: true,
            allowAdvancedCriteria: true,
            allowFilterExpressions: true,
            filterOnKeypress: true,
            selectionType: "single",
            // initialSort: [
            //     {property: "sessionDate", direction: "ascending"},
            //     {property: "sessionStartHour", direction: "ascending"}
            // ],
        // {name: ""},
        // {name: ""},
        // {name: ""},
        // {name: ""}
            fields: [
                {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
                {
                    name: "alarmTarget",
                    title: "alarmTarget",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "alarmTargetId",
                    title: "alarmTargetId",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "alarmCode",
                    title: "alarmCode",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "alarmType",
                    title: "alarmType",
                    align: "center",
                    filterOperator: "iContains"
                },
                 {
                    name: "description",
                    title: "<spring:message code="description"/>",
                    align: "center",
                    filterOperator: "iContains"
                }
            ],
            doubleClick: function () {
                show_alarmEditForm();
            }
        });

        var RestDataSource_Institute_JspAlarm = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true},
                {name: "titleFa", title: "<spring:message code="institution.name"/>"},
                {name: "manager.firstNameFa", title: "<spring:message code="manager.name"/>"},
                {name: "manager.lastNameFa", title: "<spring:message code="manager.family"/>"},
                {name: "mobile", title: "<spring:message code="mobile"/>"},
                {name: "restAddress", title: "<spring:message code="address"/>"},
                {name: "phone", title: "<spring:message code="telephone"/>"}
            ],
            fetchDataURL: instituteUrl + "spec-list"
        });

        var RestDataSource_TrainingPlace_JspAlarm = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true},
                {name: "titleFa", title: "<spring:message code="location.name"/>"},
                {name: "capacity", title: "<spring:message code="capacity"/>"}
            ],
            fetchDataURL: instituteUrl + "0/training-places"
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
            // classRecord = ListGrid_Class_JspClass.getSelectedRecord();
            // if (!(classRecord == undefined || classRecord == null)) {
            //     RestDataSource_alarm.fetchDataURL = sessionServiceUrl + "load-sessions" + "/" + ListGrid_Class_JspClass.getSelectedRecord().id;
            //     ListGrid_alarm.invalidateCache();
            //     ListGrid_alarm.fetchData();
            // }
        }

    }
    // ------------------------------------------------- Functions ------------------------------------------>>


    //</script>