<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
// <script>
    //************************************************************************************
    // RestDataSource & ListGrid
    //************************************************************************************
    var RestDataSource_registerScorePreTest = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleClass"},
            {name: "term.titleFa"},
            {name: "course.titleFa"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "teacher"},
            {name: "group"},
            {name: "preCourseTest", type: "boolean"}
           ],
        fetchDataURL: classUrl + "spec-list"
    });
    var ListGrid_RegisterScorePreTtest = isc.TrLG.create({
     dataSource: RestDataSource_registerScorePreTest,
        canAddFormulaFields: true,
        autoFetchData: true,
        implicitCriteria : criteria_RegisterScorePreTest,
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {
                name: "code",
                title: "<spring:message code='class.code'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "titleClass",
                title: "titleClass",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true,
                hidden: true
            },
            {
                name: "course.titleFa",
                title: "<spring:message code='course.title'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.course.titleFa;
                }
            },
            {
                name: "term.titleFa",
                title: "term",
                align: "center",
                filterOperator: "iContains",
                hidden: true
            },
            {
                name: "startDate",
                title: "<spring:message code='start.date'/>",
                align: "center",
                filterOperator: "iContains"
            },
            {name: "endDate", title: "<spring:message code='end.date'/>", align: "center", filterOperator: "iContains"},
            {
                name: "group",
                title: "<spring:message code='group'/>",
                align: "center",
                filterOperator: "equals",
                autoFitWidth: true
            },

            {name: "teacher", title: "<spring:message code='teacher'/>", align: "center", filterOperator: "iContains"},

        ],
        recordDoubleClick: function () {
          //  DynamicForm_Term.clearValues();
           // show_TermEditForm();
        },
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: true,
        sortField: 0,
    });

    var ToolStripButton_Refresh = isc.ToolStripButtonRefresh.create({
// icon: "<spring:url value="refresh.png"/>",
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_RegisterScorePreTtest.invalidateCache();
        }
    });

    var ToolStrip_Actions = isc.ToolStrip.create({
        width: "100%",
        members: [

            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh,
                ]
            })
        ]
    });
    //***********************************************************************************
    var criteria_RegisterScorePreTest = {
        _constructor: "AdvancedCriteria",
        operator: "and",
        criteria: [

            {fieldName: "preCourseTest", operator: "equals", value: true}
        ]
    };
    //***********************************************************************************
    //HLayout
    //***********************************************************************************
    var HLayout_Actions_Group = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions]
    });

    var HLayout_Grid_RegisterScorePreTtest = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_RegisterScorePreTtest]
    });

    var VLayout_Body_Group = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            HLayout_Actions_Group
            , HLayout_Grid_RegisterScorePreTtest
        ]
    });










