<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>
    //----------------------------------------------------Variables-----------------------------------------------------
    var teacherGradeToClass = 0;
    var studentsGradeToTeacher = 0;
    var studentsGradeToFacility = 0;
    var studentsGradeToGoals = 0;
    var userId = "<%= SecurityUtil.getUserId()%>";
    var listGrid_record = null;
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
            {name: "titleClass"},
            {name: "scoringMethod"}
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
        selectionUpdated: function (record) {
            listGrid_record = ListGrid_evaluationAnalysis_class.getSelectedRecord();
            set_evaluation_analysis_tabset_status();
            Detail_Tab_Evaluation_Analysis.selectTab(0);
        },
    });

    //----------------------------------------------------ToolStrips & Page Layout--------------------------------------

    var Detail_Tab_Evaluation_Analysis = isc.TabSet.create({
        ID: "tabSetEvaluationAnalysis",
        tabBarPosition: "top",
        enabled: false,
        tabs: [
            {
                ID: "TabPane_Reaction_Evaluation_Analysis",
                enabled: false,
                title: "<spring:message code="evaluation.reaction"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "evaluationAnalysis/evaluationAnalysis-reactionTab/show-form"})
            }
            ,
            {
                ID: "TabPane_Learning_Evaluation_Analysis",
                enabled: false,
                title: "<spring:message code="evaluation.learning"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "evaluationAnalysist-learning/evaluationAnalysis-learningTab"})
            },
            {
                ID: "TabPane_Behavioral_Evaluation_Analysis",
                enabled: false,
                title: "<spring:message code="evaluation.behavioral"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "evaluationAnalysis/evaluationAnalysis-behavioralTab/show-form"})
            },
            {
                ID: "TabPane_Results_Evaluation_Analysis",
                enabled: false,
                title: "<spring:message code="evaluation.results"/>"
            }
        ],
        tabSelected: function (tabNum, tabPane, ID, tab, name) {
        }

    });


    var ToolStripButton_Refresh_Evaluation_Analysis = isc.ToolStripButtonRefresh.create({
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_evaluationAnalysis_class.invalidateCache();
            DynamicForm_Reaction_EvaluationAnalysis_Header.hide();
            DynamicForm_Reaction_EvaluationAnalysis_Footer.hide();
            ListGrid_evaluationAnalysist_learning.setData([])
            IButton_Print_ReactionEvaluation_Evaluation_Analysis.hide();
            chartSelector.hide();
            ReactionEvaluationChart.hide();
            ReactionEvaluationChart.setChartType("Column");
            Detail_Tab_Evaluation_Analysis.disableTab(0);
            Detail_Tab_Evaluation_Analysis.disableTab(1);
            Detail_Tab_Evaluation_Analysis.disableTab(2);
            Detail_Tab_Evaluation_Analysis.disableTab(3);
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

    var HLayout_Actions_Evaluation_Analysis = isc.HLayout.create({
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
            fill_reaction_evaluation_result();
            Detail_Tab_Evaluation_Analysis.enableTab(0);
            Detail_Tab_Evaluation_Analysis.disableTab(1);
            Detail_Tab_Evaluation_Analysis.disableTab(2);
            Detail_Tab_Evaluation_Analysis.disableTab(3);
        } else if (evaluationType === "2") {
            fill_reaction_evaluation_result();
            evaluationAnalysist_learning();
            Detail_Tab_Evaluation_Analysis.enableTab(0);
            Detail_Tab_Evaluation_Analysis.enableTab(1);
            Detail_Tab_Evaluation_Analysis.disableTab(2);
            Detail_Tab_Evaluation_Analysis.disableTab(3);
        } else if (evaluationType === "3") {
            fill_reaction_evaluation_result();
            evaluationAnalysist_learning();
            fill_behavioral_evaluation_result();
            Detail_Tab_Evaluation_Analysis.enableTab(0);
            Detail_Tab_Evaluation_Analysis.enableTab(1);
            Detail_Tab_Evaluation_Analysis.enableTab(2);
            Detail_Tab_Evaluation_Analysis.disableTab(3);
        } else if (evaluationType === "4") {
            fill_reaction_evaluation_result();
            evaluationAnalysist_learning();
            fill_behavioral_evaluation_result();
            Detail_Tab_Evaluation_Analysis.enableTab(0);
            Detail_Tab_Evaluation_Analysis.enableTab(1);
            Detail_Tab_Evaluation_Analysis.enableTab(2);
            Detail_Tab_Evaluation_Analysis.enableTab(3);
        }

        /////////////////////////TEMP////////////////////////
        // fill_reaction_evaluation_result();
        // evaluationAnalysist_learning();
        // fill_behavioral_evaluation_result();
        // Detail_Tab_Evaluation_Analysis.enableTab(0);
        // Detail_Tab_Evaluation_Analysis.enableTab(1);
        // Detail_Tab_Evaluation_Analysis.enableTab(2);
        // Detail_Tab_Evaluation_Analysis.enableTab(3);
        ////////////////////////TEMP///////////////////////
    }

    function load_reaction_evluation_analysis_data(record) {
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

        teacherGradeToClass = record.teacherGradeToClass;
        studentsGradeToTeacher = record.studentsGradeToTeacher;
        studentsGradeToFacility = record.studentsGradeToFacility;
        studentsGradeToGoals = record.studentsGradeToGoals;

        if (DynamicForm_Reaction_EvaluationAnalysis_Footer.getField("FERPass").getValue() == true) {
            DynamicForm_Reaction_EvaluationAnalysis_Footer.getItem('FERGrade').setCellStyle('evaluation-code-pass-label');
        }

        else if (DynamicForm_Reaction_EvaluationAnalysis_Footer.getField("FERPass").getValue() == false) {
            DynamicForm_Reaction_EvaluationAnalysis_Footer.getItem('FERGrade').setCellStyle('evaluation-code-fail-label');
        }

        if (DynamicForm_Reaction_EvaluationAnalysis_Footer.getField("FETPass").getValue() == true) {
            DynamicForm_Reaction_EvaluationAnalysis_Footer.getItem('FETGrade').setCellStyle('evaluation-code-pass-label');
        }

        else if (DynamicForm_Reaction_EvaluationAnalysis_Footer.getField("FETPass").getValue() == false) {
            DynamicForm_Reaction_EvaluationAnalysis_Footer.getItem('FETGrade').setCellStyle('evaluation-code-fail-label');
        }

        reaction_chartData  = [
            {region: "محتوی", grade: studentsGradeToGoals},
            {region: "مدرس", grade: studentsGradeToTeacher},
            {region: "امکانات", grade: studentsGradeToFacility},
            {region: "نظر استاد", grade: teacherGradeToClass}
        ];

        ReactionEvaluationChart.setData(reaction_chartData);
    }

    function load_behavioral_evluation_analysis_data(record) {
        DynamicForm_Behavioral_EvaluationAnalysis_Header.getField("studentCount").setValue(listGrid_record.studentCount);
        DynamicForm_Behavioral_EvaluationAnalysis_Header.getField("classPassedTime").setValue(record.classPassedTime);
        DynamicForm_Behavioral_EvaluationAnalysis_Header.getField("numberOfFilledFormsBySuperviosers").setValue(record.numberOfFilledFormsBySuperviosers);
        DynamicForm_Behavioral_EvaluationAnalysis_Header.getField("numberOfFilledFormsByStudents").setValue(record.numberOfFilledFormsByStudents);

        DynamicForm_Behavioral_EvaluationAnalysis_Footer.getField("studentsMeanGrade").setValue(record.studentsMeanGrade);
        DynamicForm_Behavioral_EvaluationAnalysis_Footer.getField("supervisorsMeanGrade").setValue(record.supervisorsMeanGrade);
        DynamicForm_Behavioral_EvaluationAnalysis_Footer.getField("FEBGrade").setValue(record.febgrade);
        DynamicForm_Behavioral_EvaluationAnalysis_Footer.getField("FEBPass").setValue(record.febpass);
        DynamicForm_Behavioral_EvaluationAnalysis_Footer.getField("FECBGrade").setValue(record.fecbgrade);
        DynamicForm_Behavioral_EvaluationAnalysis_Footer.getField("FECBPass").setValue(record.fecbpass);

        behavioral_chartData = new Array();
        var i = 0;
        for (i=0;i<record.supervisorsGrade.size();i++) {
            behavioral_chartData.add({student: record.classStudentsName.get(i), grade: record.studentsGrade.get(i) , evaluator :  "<spring:message code='student'/>"});
            behavioral_chartData.add({student: record.classStudentsName.get(i), grade: record.supervisorsGrade.get(i), evaluator : "<spring:message code='boss'/>"});
        }

        BehavioralEvaluationChart.setData(behavioral_chartData);
    }

    function fill_reaction_evaluation_result() {
        DynamicForm_Reaction_EvaluationAnalysis_Header.show();
        DynamicForm_Reaction_EvaluationAnalysis_Footer.show();
        IButton_Print_ReactionEvaluation_Evaluation_Analysis.show();
        chartSelector.show();
        ReactionEvaluationChart.show();
        isc.RPCManager.sendRequest(TrDSRequest(classUrl + "reactionEvaluationResult/" + ListGrid_evaluationAnalysis_class.getSelectedRecord().id + "/" + userId, "GET", null,
            "callback: fill_reaction_evaluation_result_resp(rpcResponse)"));
    }

    function fill_reaction_evaluation_result_resp(resp) {
        load_reaction_evluation_analysis_data(JSON.parse(resp.data));
    }

    function fill_behavioral_evaluation_result() {
        isc.RPCManager.sendRequest(TrDSRequest(classUrl + "behavioralEvaluationResult/" + ListGrid_evaluationAnalysis_class.getSelectedRecord().id , "GET", null,
            "callback: fill_behavioral_evaluation_result_resp(rpcResponse)"));
    }

    function fill_behavioral_evaluation_result_resp(resp) {
        load_behavioral_evluation_analysis_data(JSON.parse(resp.data));
    }




