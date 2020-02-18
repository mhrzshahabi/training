<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>

    //----------------------------------------------------Rest Data Sources---------------------------------------------

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
            {name: "instituteId"},
            {name: "titleClass"}
        ],
        fetchDataURL: classUrl + "spec-list-evaluated"
    });

    //----------------------------------------------------List Grid-----------------------------------------------------

    var ListGrid_evaluationAnalysis_class = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_evaluationAnalysis_class,
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
                    "3": "پایان یافته"
                },
            },
            {
                name: "evaluationStatus", title: "<spring:message code='evaluation.status'/>", align: "center",
                valueMap: {
                    "1": "ارزیابی نشده",
                    "2": "در حال ارزیابی",
                    "3": "ارزیابی شده"
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
            {name: "titleClass", hidden: true}
        ],
        selectionUpdated: function () {
            scrollChart.show();
            DynamicForm_Reaction_EvaluationAnalysis_Header.show();
            DynamicForm_Reaction_EvaluationAnalysis_Footer.show();
            IButton_Print_ReactionEvaluation_Evaluation_Analysis.show();
            fill_evaluation_result();
        }
    });

    //----------------------------------------------------Reaction Evaluation-------------------------------------------

    var vm_reaction_evaluation = isc.ValuesManager.create({});

    DynamicForm_Reaction_EvaluationAnalysis_Header = isc.DynamicForm.create({
        align: "right",
        canSubmit: true,
        titleWidth: 120,
        width: "45%",
        valuesManager: vm_reaction_evaluation,
        titleAlign: "left",
        showInlineErrors: true,
        showErrorText: false,
        styleName: "teacher-form",
        numCols: 6,
        margin: 10,
        newPadding: 5,
        canTabToIcons: false,
        fields: [
            {
                name: "studentCount",
                title: "<spring:message code='student.count'/>",
                baseStyle: "teacher-code",
                canEdit: false
            },
            {
                name: "numberOfFilledReactionEvaluationForms",
                title: "<spring:message code='numberOfFilledReactionEvaluationForms'/>",
                baseStyle: "teacher-code",
                canEdit: false
            },
            {
                name: "numberOfInCompletedReactionEvaluationForms",
                title: "<spring:message code='numberOfInCompletedReactionEvaluationForms'/>",
                baseStyle: "teacher-code",
                canEdit: false
            },
            {
                name: "numberOfEmptyReactionEvaluationForms",
                title:"<spring:message code='numberOfEmptyReactionEvaluationForms'/>",
                baseStyle: "teacher-code",
                canEdit: false
            },
            {
                name: "percenetOfFilledReactionEvaluationForms",
                title: "<spring:message code='percenetOfFilledReactionEvaluationForms'/>",
                baseStyle: "teacher-code",
                canEdit: false
            },
            {
                name: "numberOfExportedReactionEvaluationForms",
                title: "<spring:message code='numberOfExportedReactionEvaluationForms'/>",
                hidden: true
            }
        ]
    });

    DynamicForm_Reaction_EvaluationAnalysis_Footer = isc.DynamicForm.create({
        width: "30%",
        align: "right",
        canSubmit: true,
        titleAlign: "left",
        titleWidth: 120,
        showInlineErrors: true,
        showErrorText: false,
        valuesManager: vm_reaction_evaluation,
        styleName: "teacher-form",
        numCols: 4,
        margin: 10,
        newPadding: 5,
        canTabToIcons: false,
        fields: [
            {
                name: "FERGrade",
                title: "<spring:message code='FERGrade'/>",
                baseStyle: "teacher-code",
                canEdit: false
            },
            {
                name: "FETGrade",
                title:"<spring:message code='FETGrade'/>",
                baseStyle: "teacher-code",
                canEdit: false
            },
            {
                name: "FECRGrade",
                title: "<spring:message code='FECRGrade'/>",
                baseStyle: "teacher-code",
                canEdit: false
            },
            {
                name: "FECRPass",
                title: "<spring:message code='status'/>",
                baseStyle: "teacher-code",
                canEdit: false,
                valueMap: {
                    "true": "تائید",
                    "false": "عدم تائید"
                }
            },
            {
                name: "FERPass",
                hidden: true
            },
            {
                name: "FETPass",
                hidden: true
            },
            {
                name: "minScore_ER",
                hidden: true
            },
            {
                name: "minScore_ET",
                hidden: true
            },
            {name: "teacherGradeToClass", hidden: true},
            {name: "studentsGradeToTeacher", hidden: true},
            {name: "studentsGradeToFacility" , hidden: true},
            {name: "studentsGradeToGoals", hidden: true},
            {name: "trainingGradeToTeacher", hidden: true}
        ]
    });

    DynamicForm_Reaction_EvaluationAnalysis_Header.getItem('studentCount').setCellStyle('teacher-code-label');
    DynamicForm_Reaction_EvaluationAnalysis_Header.getItem('studentCount').titleStyle = 'teacher-code-title';
    DynamicForm_Reaction_EvaluationAnalysis_Header.getItem('numberOfFilledReactionEvaluationForms').setCellStyle('teacher-code-label');
    DynamicForm_Reaction_EvaluationAnalysis_Header.getItem('numberOfFilledReactionEvaluationForms').titleStyle = 'teacher-code-title';
    DynamicForm_Reaction_EvaluationAnalysis_Header.getItem('numberOfInCompletedReactionEvaluationForms').setCellStyle('teacher-code-label');
    DynamicForm_Reaction_EvaluationAnalysis_Header.getItem('numberOfInCompletedReactionEvaluationForms').titleStyle = 'teacher-code-title';
    DynamicForm_Reaction_EvaluationAnalysis_Header.getItem('numberOfEmptyReactionEvaluationForms').setCellStyle('teacher-code-label');
    DynamicForm_Reaction_EvaluationAnalysis_Header.getItem('numberOfEmptyReactionEvaluationForms').titleStyle = 'teacher-code-title';
    DynamicForm_Reaction_EvaluationAnalysis_Header.getItem('percenetOfFilledReactionEvaluationForms').setCellStyle('teacher-code-label');
    DynamicForm_Reaction_EvaluationAnalysis_Header.getItem('percenetOfFilledReactionEvaluationForms').titleStyle = 'teacher-code-title';

    DynamicForm_Reaction_EvaluationAnalysis_Footer.getItem('FERGrade').setCellStyle('teacher-code-label');
    DynamicForm_Reaction_EvaluationAnalysis_Footer.getItem('FERGrade').titleStyle = 'teacher-code-title';
    DynamicForm_Reaction_EvaluationAnalysis_Footer.getItem('FETGrade').setCellStyle('teacher-code-label');
    DynamicForm_Reaction_EvaluationAnalysis_Footer.getItem('FETGrade').titleStyle = 'teacher-code-title';
    DynamicForm_Reaction_EvaluationAnalysis_Footer.getItem('FECRGrade').setCellStyle('teacher-code-label');
    DynamicForm_Reaction_EvaluationAnalysis_Footer.getItem('FECRGrade').titleStyle = 'teacher-code-title';
    DynamicForm_Reaction_EvaluationAnalysis_Footer.getItem('FECRPass').setCellStyle('teacher-code-label');
    DynamicForm_Reaction_EvaluationAnalysis_Footer.getItem('FECRPass').titleStyle = 'teacher-code-title';

    var scrollChart = isc.FacetChart.create({
        facets: [{
            id: "season",    // the key used for this facet in the data above
            title: "Season"  // the user-visible title you want in the chart
        }],
        valueProperty: "temp", // the property in our data that is the numerical value to chart
        data: [
            {season: "Spring", temp: 79},
            {season: "Summer", temp: 102},
            {season: "Autumn", temp: 81},
            {season: "Winter", temp: 59}
        ],
        title: "Average temperature in Las Vegas"
    });

    <%--<SCRIPT SRC=isomorphic/system/modules/ISC_Charts.js></SCRIPT>--%>

    var IButton_Print_ReactionEvaluation_Evaluation_Analysis = isc.IButton.create({
        top: 260,
        width: "300",
        height: "25",
        title: "چاپ خلاصه نتیجه ارزیابی واکنشی",
        click: function () {
            var obj1 = vm_reaction_evaluation.getValues();
            var obj2 = ListGrid_evaluationAnalysis_class.getSelectedRecord();
            delete obj1['studentCount'];
            var obj1_str = JSON.stringify(obj1);
            var obj2_str = JSON.stringify(obj2);
            obj1_str = obj1_str.substr(0,obj1_str.length-1);
            obj1_str = obj1_str + ",";
            obj2_str = obj2_str.substr(1,obj2_str.length);
            var object = obj1_str + obj2_str;
            trPrintWithCriteria("<spring:url value="/evaluationAnalysis/printReactionEvaluation"/>",null,object);
        }
    });

    var Hlayout_Tab_ReactionEvaluation_Evaluation_Analysis_Print = isc.HLayout.create({
        width: "100%",
        height: "49%",
        align: "center",
        members: [
            IButton_Print_ReactionEvaluation_Evaluation_Analysis
        ]
    });

    var VLayout_Body_evaluation_analysis_reaction = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [DynamicForm_Reaction_EvaluationAnalysis_Header,
            scrollChart,
            DynamicForm_Reaction_EvaluationAnalysis_Footer,
            Hlayout_Tab_ReactionEvaluation_Evaluation_Analysis_Print]
    });

    var Detail_Tab_Evaluation_Analysis = isc.TabSet.create({
        ID: "tabSetEvaluationAnalysis",
        tabBarPosition: "top",
        enabled: false,
        tabs: [
            {
                id: "TabPane_Reaction_Evaluation_Analysis",
                title: "<spring:message code="evaluation.reaction"/>",
                pane: VLayout_Body_evaluation_analysis_reaction
            }
            ,
            {
                id: "TabPane_Learning_Evaluation_Analysis",
                title: "<spring:message code="evaluation.learning"/>"
                // pane: VLayout_Body_evaluation
            },
            {
                id: "TabPane_Behavior_Evaluation_Analysis",
                title: "<spring:message code="evaluation.behavioral"/>"
                // pane: VLayout_Body_evaluation
            },
            {
                id: "TabPane_Results_Evaluation_Analysis",
                title: "<spring:message code="evaluation.results"/>"
                // pane: VLayout_Body_evaluation
            }
        ],
        tabSelected: function (tabNum, tabPane, ID, tab, name) {
        }

    });

    //----------------------------------------------------ToolStrips & Page Layout--------------------------------------

    var ToolStripButton_Refresh_Evaluation_Analysis = isc.ToolStripButtonRefresh.create({
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_evaluationAnalysis_class.invalidateCache();
        }
    });

    var ToolStrip_Evaluation_Analysis = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh_Evaluation_Analysis
                ]
            })
        ]
    });

    var HLayout_Actions_Evaluation_Analysis= isc.HLayout.create({
        width: "100%",
        height: "1%",
        members: [ToolStrip_Evaluation_Analysis]
    });


    var Hlayout_Grid_Evaluation_Analysis = isc.HLayout.create({
        width: "100%",
        height: "50%",
        showResizeBar: true,
        members: [ListGrid_evaluationAnalysis_class]
    });

    var Hlayout_Tab_Evaluation_Analysis = isc.HLayout.create({
        width: "100%",
        height: "49%",
        members: [
            Detail_Tab_Evaluation_Analysis
        ]
    });

    var VLayout_Body_Evaluation_Analysis = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [HLayout_Actions_Evaluation_Analysis, Hlayout_Grid_Evaluation_Analysis,
                  Hlayout_Tab_Evaluation_Analysis]
    });

    //----------------------------------------------------Functions-----------------------------------------------------

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
        DynamicForm_Reaction_EvaluationAnalysis_Header.getField("numberOfExportedReactionEvaluationForms").setValue(record.numberOfExportedReactionEvaluationForms);

        DynamicForm_Reaction_EvaluationAnalysis_Footer.getField("FERGrade").setValue(record.fergrade);
        DynamicForm_Reaction_EvaluationAnalysis_Footer.getField("FETGrade").setValue(record.fetgrade);
        DynamicForm_Reaction_EvaluationAnalysis_Footer.getField("FECRGrade").setValue(record.fecrgrade);
        DynamicForm_Reaction_EvaluationAnalysis_Footer.getField("FERPass").setValue(record.ferpass);
        DynamicForm_Reaction_EvaluationAnalysis_Footer.getField("FETPass").setValue(record.fetpass);
        DynamicForm_Reaction_EvaluationAnalysis_Footer.getField("FECRPass").setValue(record.fecrpass);

        DynamicForm_Reaction_EvaluationAnalysis_Footer.getField("minScore_ER").setValue(record.minScore_ER);
        DynamicForm_Reaction_EvaluationAnalysis_Footer.getField("minScore_ET").setValue(record.minScore_ET);

        DynamicForm_Reaction_EvaluationAnalysis_Footer.getField("teacherGradeToClass").setValue(record.teacherGradeToClass);
        DynamicForm_Reaction_EvaluationAnalysis_Footer.getField("studentsGradeToTeacher").setValue(record.studentsGradeToTeacher);
        DynamicForm_Reaction_EvaluationAnalysis_Footer.getField("studentsGradeToFacility").setValue(record.studentsGradeToFacility);
        DynamicForm_Reaction_EvaluationAnalysis_Footer.getField("studentsGradeToGoals").setValue(record.studentsGradeToGoals);
        DynamicForm_Reaction_EvaluationAnalysis_Footer.getField("trainingGradeToTeacher").setValue(record.trainingGradeToTeacher);
    }

    function fill_evaluation_result() {
        isc.RPCManager.sendRequest(TrDSRequest(classUrl + "evaluationResult/" + ListGrid_evaluationAnalysis_class.getSelectedRecord().id , "GET", null,
            "callback: fill_evaluation_result_resp(rpcResponse)"));
    }

    function fill_evaluation_result_resp(resp){
        load_evluation_analysis_data(JSON.parse(resp.data));
        set_evaluation_analysis_tabset_status();
        Detail_Tab_Evaluation_Analysis.selectTab(0);
    }

    //------------------------------------------------------------------------------------------------------------------

    DynamicForm_Reaction_EvaluationAnalysis_Header.hide();
    DynamicForm_Reaction_EvaluationAnalysis_Footer.hide();
    scrollChart.hide();
    IButton_Print_ReactionEvaluation_Evaluation_Analysis.hide();