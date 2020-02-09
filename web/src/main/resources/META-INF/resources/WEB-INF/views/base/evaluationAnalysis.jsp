<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

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
                title: "<spring:message code='term'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "teacher",
                title: "<spring:message code='teacher'/>",
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
            {name: "evaluationStatus", hidden: true}
        ],
        selectionUpdated: function () {
            fill_evaluation_result();
        }
    });

    DynamicForm_Reaction_EvaluationAnalysis_Header = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "right",
        titleWidth: 0,
        showInlineErrors: true,
        showErrorText: false,
        valuesManager: "vm",
        fields: [
            {
                name: "studentCount",
                title: "<spring:message code='student.count'/>"
            },
            {
                name: "numberOfFilledReactionEvaluationForms",
                title: "تعداد فرم های ثبت شده"
            },
            {
                name: "numberOfInCompletedReactionEvaluationForms",
                title: "تعداد فرم های ناقص"
            },
            {
                name: "numberOfEmptyReactionEvaluationForms",
                title: "تعداد فرم های ثبت نشده"
            },
            {
                name: "percenetOfFilledReactionEvaluationForms",
                title: "درصد فرم های ثبت شده"
            }
        ]
    });

    DynamicForm_Reaction_EvaluationAnalysis_Footer = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "right",
        titleWidth: 0,
        showInlineErrors: true,
        showErrorText: false,
        valuesManager: "vm",
        fields: [
            {
                name: "s",
                title: "نمره ارزیابی واکنشی کلاس"
            },
            {
                name: "n",
                title: "نمره ارزیابی استاد بعد از تدریس دوره"
            },
            {
                name: "n",
                title: "نمره اثربخشی"
            },
            {
                name: "t",
                title: "تائید/عدم تائید"
            }
        ]
    });

    // var scrollChart = isc.FacetChart.create({
    //     facets: [{
    //         id: "season",    // the key used for this facet in the data above
    //         title: "Season"  // the user-visible title you want in the chart
    //     }],
    //     valueProperty: "temp", // the property in our data that is the numerical value to chart
    //     data: [
    //         {season: "Spring", temp: 79},
    //         {season: "Summer", temp: 102},
    //         {season: "Autumn", temp: 81},
    //         {season: "Winter", temp: 59}
    //     ],
    //     title: "Average temperature in Las Vegas"
    // });

    <%--<SCRIPT SRC=isomorphic/system/modules/ISC_Charts.js></SCRIPT>--%>

    var VLayout_Body_evaluation_analysis_reaction = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [DynamicForm_Reaction_EvaluationAnalysis_Header,
            DynamicForm_Reaction_EvaluationAnalysis_Footer]
    });


    var Detail_Tab_Evaluation_Analysis = isc.TabSet.create({
        ID: "tabSetEvaluationAnalysis",
        tabBarPosition: "top",
        enabled: false,
        tabs: [
            {
                id: "TabPane_Reaction",
                title: "<spring:message code="evaluation.reaction"/>",
                pane: VLayout_Body_evaluation_analysis_reaction
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
            Detail_Tab_Evaluation_Analysis
        ]
    });

    var VLayout_Body_operational = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [HLayout_Actions_operational, Hlayout_Grid_operational, Hlayout_Tab_Evaluation]
    });

    function set_evaluation_analysis_tabset_status() {

        var classRecord = ListGrid_evaluationAnalysis_class.getSelectedRecord();
        var evaluationType = classRecord.course.evaluation;

        Detail_Tab_Evaluation_Analysis.enable();

        if (evaluationType === "1") {
            Detail_Tab_Evaluation_Analysis.enableTab(0);
            Detail_Tab_Evaluation_Analysis.disableTab(1);
            Detail_Tab_Evaluation_Analysis.disableTab(2);
            Detail_Tab_Evaluation_Analysis.disableTab(3);
        } else if (evaluationType === "2") {
            Detail_Tab_Evaluation_Analysis.enableTab(0);
            Detail_Tab_Evaluation_Analysis.enableTab(1);
            Detail_Tab_Evaluation_Analysis.disableTab(2);
            Detail_Tab_Evaluation_Analysis.disableTab(3);
        } else if (evaluationType === "3") {
            Detail_Tab_Evaluation_Analysis.enableTab(0);
            Detail_Tab_Evaluation_Analysis.enableTab(1);
            Detail_Tab_Evaluation_Analysis.enableTab(2);
            Detail_Tab_Evaluation_Analysis.disableTab(3);
        } else if (evaluationType === "4") {
            Detail_Tab_Evaluation_Analysis.enableTab(0);
            Detail_Tab_Evaluation_Analysis.enableTab(1);
            Detail_Tab_Evaluation_Analysis.enableTab(2);
            Detail_Tab_Evaluation_Analysis.enableTab(3);
        }
    }

    function load_evluation_analysis_data(record) {
        DynamicForm_Reaction_EvaluationAnalysis_Header.getField("studentCount").setValue(record.studentCount);
        DynamicForm_Reaction_EvaluationAnalysis_Header.getField("numberOfFilledReactionEvaluationForms").setValue(record.numberOfFilledReactionEvaluationForms);
        DynamicForm_Reaction_EvaluationAnalysis_Header.getField("numberOfInCompletedReactionEvaluationForms").setValue(record.numberOfInCompletedReactionEvaluationForms);
        DynamicForm_Reaction_EvaluationAnalysis_Header.getField("numberOfEmptyReactionEvaluationForms").setValue(record.numberOfEmptyReactionEvaluationForms);
        DynamicForm_Reaction_EvaluationAnalysis_Header.getField("percenetOfFilledReactionEvaluationForms").setValue(record.percenetOfFilledReactionEvaluationForms);
    }

    function fill_evaluation_result() {
        isc.RPCManager.sendRequest(TrDSRequest(classUrl + "evaluationResult/" + ListGrid_evaluationAnalysis_class.getSelectedRecord().id , "GET", null,
            "callback: fill_evaluation_result_resp(rpcResponse)"));
    }

    function fill_evaluation_result_resp(resp){
        load_evluation_analysis_data(JSON.parse(rpcResponse.data));
        set_evaluation_analysis_tabset_status();
        Detail_Tab_Evaluation_Analysis.selectTab(0);
    }

