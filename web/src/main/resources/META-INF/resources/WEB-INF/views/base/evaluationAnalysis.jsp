<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

        var RestDataSource_evaluationAnalysis_class = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true},
                {name: "code"},
                {name: "course.code"},
                {name: "course.titleFa"},
                {name: "startDate"},
                {name: "endDate"},
                {name: "term.titleFa"},
                {name: "teacher"},
                {name: "studentCount"},
                {name: "institute.titleFa"},
                {name: "classStatus"},
                {name: "course.evaluation"},
                {name: "evaluationStatus"},
                {name: "course.id"},
                {name: "instituteId"}
            ],
            fetchDataURL: classUrl + "spec-list-evaluated"
        });

        var ListGrid_evaluationAnalysis_class = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_evaluationAnalysis_class,
            // contextMenu: Menu_ListGrid_evaluationAnalysis_class,
            canAddFormulaFields: false,
            autoFetchData: true,
            showFilterEditor: true,
            allowAdvancedCriteria: true,
            allowFilterExpressions: true,
            filterOnKeypress: true,
            sortField: 0,

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
                    name: "course.code",
                    title: "<spring:message code='course.code'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFithWidth: true
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
                    name: "startDate",
                    title: "<spring:message code='start.date'/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "endDate",
                    title: "<spring:message code='end.date'/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "term.titleFa",
                    title:  "<spring:message code='term'/>" ,
                    align: "center",
                    filterOperator: "iContains",
                },
                {
                    name: "teacher",
                    title:  "<spring:message code='teacher'/>",
                    align: "center",
                    filterOperator: "iContains",
                },
                {
                    name: "studentCount",
                    title: "<spring:message code='student.count'/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "institute.titleFa",
                    title: "<spring:message code='presenter'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "classStatus", title: "<spring:message code='class.status'/>", align: "center",
                    valueMap: {
                        "1": "برنامه ریزی",
                        "2": "در حال اجرا",
                        "3": "پایان یافته",
                    },
                },
                {
                    name: "course.evaluation",
                    title: "<spring:message code='evaluation.type'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    valueMap: {
                        "1": "واکنشی",
                        "2": "یادگیری",
                        "3": "رفتاری",
                        "4": "نتایج"
                    }
                },
                {name: "evaluationStatus",hidden:true}
            ],
            selectionUpdated: function () {
                // loadSelectedTab_data(Detail_Tab_Evaluation.getSelectedTab());
                // set_Evaluation_Tabset_status();
            }
        });

        var Detail_Tab_Evaluation = isc.TabSet.create({
            ID: "tabSetEvaluation",
            tabBarPosition: "top",
            enabled: false,
            tabs: [
                {
                    id: "TabPane_Reaction",
                    title: "<spring:message code="evaluation.reaction"/>"
                    // pane: VLayout_Body_evaluation
                }
                ,
                {
                    id: "TabPane_Learning",
                    title: "<spring:message code="evaluation.learning"/>"
                    // pane: VLayout_Body_evaluation
                },
                {
                    id: "TabPane_Behavior",
                    title: "<spring:message code="evaluation.behavioral"/>"
                    // pane: VLayout_Body_evaluation
                },
                {
                    id: "TabPane_Results",
                    title: "<spring:message code="evaluation.results"/>"
                    // pane: VLayout_Body_evaluation
                }
            ],
            tabSelected: function (tabNum, tabPane, ID, tab, name) {
                // if (isc.Page.isLoaded())
                //     loadSelectedTab_data(tab);
            }

        });

        var ToolStripButton_Refresh = isc.ToolStripButtonRefresh.create({
            title: "<spring:message code="refresh"/>",
            click: function () {
                ListGrid_evaluationAnalysis_class.invalidateCache();
            }
        });

        var ToolStrip_operational = isc.ToolStrip.create({
            width: "100%",
            membersMargin: 5,
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

        var HLayout_Actions_operational = isc.HLayout.create({
            width: "100%",
            height: "1%",
            members: [ToolStrip_operational]
        });


        var Hlayout_Grid_operational = isc.HLayout.create({
            width: "100%",
            height: "50%",
            showResizeBar: true,
            members: [ListGrid_evaluationAnalysis_class]
        });

        var Hlayout_Tab_Evaluation = isc.HLayout.create({
            width: "100%",
            height: "49%",
            members: [
                Detail_Tab_Evaluation
            ]
        });

        var VLayout_Body_operational = isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [HLayout_Actions_operational, Hlayout_Grid_operational, Hlayout_Tab_Evaluation]
        });