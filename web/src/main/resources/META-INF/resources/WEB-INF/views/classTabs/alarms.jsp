<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>

    // <<========== Global - Variables ==========
    {

    }
    // ============ Global - Variables ========>>


    // <<-------------------------------------- Create - RestDataSource & ListGrid ----------------------------
    {
        var RestDataSource_alarm = isc.TrDS.create({
            fields:
                [
                    {name: "classId", hidden: true},
                    {name: "sessionId", hidden: true},
                    {name: "teacherId", hidden: true},
                    {name: "studentId", hidden: true},
                    {name: "instituteId", hidden: true},
                    {name: "trainingPlaceId", hidden: true},
                    {name: "reservationId", hidden: true},
                    {name: "targetRecordId", autoFitWidth: true},
                    {name: "alarmTypeTitleFa", width: 140},
                    {name: "alarmTypeTitleEn", hidden: true},
                    {name: "tabName", autoFitWidth: true},
                    {name: "pageAddress", autoFitWidth: true},
                    {name: "alarm"},
                    {name: "detailRecordId", hidden: true},
                    {name: "sortField", hidden: true},
                    {name: "classIdConflict", hidden: true},
                    {name: "sessionIdConflict", hidden: true},
                    {name: "instituteIdConflict", hidden: true},
                    {name: "trainingPlaceIdConflict", hidden: true},
                    {name: "reservationIdConflict", hidden: true}
                ]
        });


        var ListGrid_alarm = isc.TrLG.create({
            width: "100%",
            height: "100%",
            <sec:authorize access="hasAuthority('TclassAlarmsTab_R')">
            dataSource: RestDataSource_alarm,
            </sec:authorize>
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
                    name: "alarmTypeTitleFa",
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
                select_target();
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

        var ToolStripButton_ExportToExcel = isc.ToolStripButtonExcel.create({
            click: function () {
                let classRecord = ListGrid_Class_JspClass.getSelectedRecord();
                if (!(classRecord === undefined || classRecord == null)) {
                    ExportToFile.downloadExcelRestUrl(null, ListGrid_alarm, classAlarm + "list" + "/" + ListGrid_Class_JspClass.getSelectedRecord().id, 0, ListGrid_Class_JspClass, '', "کلاس - هشدارها", ListGrid_alarm.getCriteria(), null);
                }
            }
        })

        var ToolStrip_alarm = isc.ToolStrip.create({
            width: "100%",
            members: [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        <sec:authorize access="hasAuthority('TclassAlarmsTab_P')">
                        ToolStripButton_ExportToExcel,
                        </sec:authorize>
                        isc.LayoutSpacer.create({width: "*"}),
                        <sec:authorize access="hasAuthority('TclassAlarmsTab_R')">
                        ToolStripButton_Refresh
                        </sec:authorize>
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
        //*****select target tab*****
        function select_target() {

            var currentAlarm = ListGrid_alarm.getSelectedRecord();

            if (currentAlarm !== null) {

                tabSetClass.selectTab(currentAlarm.tabName);

            }

        }

        //*****fetch alarms when select alarm tab*****
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