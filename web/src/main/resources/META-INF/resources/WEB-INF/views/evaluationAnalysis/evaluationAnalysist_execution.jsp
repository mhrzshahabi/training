<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>
    var execution_chartData=null ;
    var classRecord_evaluationAnalysist_execution;
    //----------------------------------------------------Reaction Evaluation-------------------------------------------

    var vm_execution_evaluation = isc.ValuesManager.create({});

    DynamicForm_Execution_EvaluationAnalysis_Header = isc.DynamicForm.create({
        canSubmit: true,
        border: "3px solid orange",
        titleWidth: 120,
        valuesManager: vm_execution_evaluation,
        titleAlign: "right",
        showInlineErrors: true,
        showErrorText: false,
        styleName: "evaluation-form",
        numCols: 2,
        margin: 5,
        canTabToIcons: false,
        fields: [
            {
                name: "studentCount",
                title: "<spring:message code='student.count'/>",
                baseStyle: "evaluation-code",
                canEdit: false
            },

            {
                name: "numberOfInCompletedExecutionEvaluationForms",
                title: "<spring:message code='numberOfInCompletedReactionEvaluationForms'/>",
                baseStyle: "evaluation-code",
                canEdit: false,
                hidden: true
            },

            {
                name: "filledFormsInfoExecution",
                title: "<spring:message code='numberOfFilledReactionEvaluationForms'/>",
                baseStyle: "evaluation-code",
                canEdit: false
            },

            {
                name: "numberOfEmptyExecutionEvaluationForms",
                title:"<spring:message code='numberOfEmptyReactionEvaluationForms'/>",
                baseStyle: "evaluation-code",
                canEdit: false

            },
            {
                name: "percentOfFilledExecutionEvaluationForms",
                title: "<spring:message code='percenetOfFilledReactionEvaluationForms'/>",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {
                name: "numberOfExportedExecutionEvaluationForms",
                title: "<spring:message code='numberOfExportedReactionEvaluationForms'/>",
                hidden: true
            },
            {name:"numberOfFilledExecutionEvaluationForms",hidden: true}
        ]
    });

    DynamicForm_Execution_EvaluationAnalysis_Footer = isc.DynamicForm.create({
        canSubmit: true,
        titleAlign: "right",
        titleWidth: 120,
        border: "3px solid orange",
        showInlineErrors: true,
        showErrorText: false,
        valuesManager: vm_execution_evaluation,
        styleName: "teacher-form",
        numCols: 2,
        margin: 5,
        canTabToIcons: false,
        fields: [


            {
                name: "FEEPass",
                hidden: true
            },

            {name: "executionEvaluationStatus",
                title: "<spring:message code='evaluation.status'/>",
                baseStyle: "evaluation-code",
                canEdit: false,

            },

            {name: "FEEGrade",
                title: "<spring:message code='students.average.grade'/>",
                baseStyle: "evaluation-code",
                canEdit: false,
            },
            {name: "z9",
                title: "<spring:message code='execution.grade.limits'/>",
                baseStyle: "evaluation-code",
                canEdit: false,

            },

            {name: "studentsGradeToTeacher",hidden: true},
            {name: "studentsGradeToFacility" , hidden: true},
            {name: "studentsGradeToGoals", hidden: true},
            {name: "differ", hidden: true}

        ]

    });




    DynamicForm_Execution_EvaluationAnalysis_Header.getItem('studentCount').setCellStyle('evaluation-code-label');
    DynamicForm_Execution_EvaluationAnalysis_Header.getItem('studentCount').titleStyle = 'evaluation-code-title';
    DynamicForm_Execution_EvaluationAnalysis_Header.getItem('numberOfInCompletedExecutionEvaluationForms').setCellStyle('evaluation-code-label');
    DynamicForm_Execution_EvaluationAnalysis_Header.getItem('numberOfInCompletedExecutionEvaluationForms').titleStyle = 'evaluation-code-title';
    DynamicForm_Execution_EvaluationAnalysis_Header.getItem('numberOfEmptyExecutionEvaluationForms').setCellStyle('evaluation-code-label');
    DynamicForm_Execution_EvaluationAnalysis_Header.getItem('numberOfEmptyExecutionEvaluationForms').titleStyle = 'evaluation-code-title';
    DynamicForm_Execution_EvaluationAnalysis_Header.getItem("filledFormsInfoExecution").setCellStyle('evaluation-code-label');
    DynamicForm_Execution_EvaluationAnalysis_Header.getItem("filledFormsInfoExecution").titleStyle = 'evaluation-code-title';
    DynamicForm_Execution_EvaluationAnalysis_Header.getItem("percentOfFilledExecutionEvaluationForms").setCellStyle('evaluation-code-label');
    DynamicForm_Execution_EvaluationAnalysis_Header.getItem("percentOfFilledExecutionEvaluationForms").titleStyle = 'evaluation-code-title';
    DynamicForm_Execution_EvaluationAnalysis_Header.getItem("numberOfFilledExecutionEvaluationForms").setCellStyle('evaluation-code-label');
    DynamicForm_Execution_EvaluationAnalysis_Header.getItem("numberOfFilledExecutionEvaluationForms").titleStyle = 'evaluation-code-title';

    DynamicForm_Execution_EvaluationAnalysis_Footer.getItem("FEEGrade").setCellStyle('evaluation-code-label');
    DynamicForm_Execution_EvaluationAnalysis_Footer.getItem("FEEGrade").setCellStyle('evaluation-code-label');
    DynamicForm_Execution_EvaluationAnalysis_Footer.getItem('studentsGradeToTeacher').setCellStyle('evaluation-code-label');
    DynamicForm_Execution_EvaluationAnalysis_Footer.getItem('studentsGradeToTeacher').titleStyle = 'evaluation-code-title';
    DynamicForm_Execution_EvaluationAnalysis_Footer.getItem("executionEvaluationStatus").setCellStyle('evaluation-code-label');
    DynamicForm_Execution_EvaluationAnalysis_Footer.getItem("executionEvaluationStatus").titleStyle = 'evaluation-code-title';
    DynamicForm_Execution_EvaluationAnalysis_Footer.getItem("z9").setCellStyle('evaluation-code-label');
    DynamicForm_Execution_EvaluationAnalysis_Footer.getItem("z9").titleStyle = 'evaluation-code-title';
    DynamicForm_Execution_EvaluationAnalysis_Footer.getItem("differ").setCellStyle('evaluation-code-label');
    DynamicForm_Execution_EvaluationAnalysis_Footer.getItem("differ").titleStyle = 'evaluation-code-title';





    var IButton_Print_ExecutionEvaluation_Evaluation_Analysis = isc.IButton.create({
        top: 260,
        width: "300",
        height: "25",
        margin: 2,
        title: "چاپ خلاصه نتیجه ارزیابی حین دوره",
        click: function () {

            var obj1 = vm_execution_evaluation.getValues();
            var obj2 =  classRecord_evaluationAnalysist_execution;
            var obj1_str = JSON.stringify(obj1);
            var obj2_str = JSON.stringify(obj2);
            obj1_str = obj1_str.substr(0,obj1_str.length-1);
            obj1_str = obj1_str + ",";
            obj2_str = obj2_str.substr(1,obj2_str.length);
            var object = obj1_str + obj2_str;
            trPrintWithCriteria("<spring:url value="/evaluationAnalysis/printExecutionEvaluation"/>",null,object);
        }
    });



    var VLayout_Body_evaluation_analysis_execution = isc.VLayout.create({
        defaultLayoutAlign: "center",
        members: [ DynamicForm_Execution_EvaluationAnalysis_Header,
            DynamicForm_Execution_EvaluationAnalysis_Footer,
            IButton_Print_ExecutionEvaluation_Evaluation_Analysis]
    });

    var ExecutionEvaluationChart = isc.FacetChart.create({
        titleAlign: "center",
        minLabelGap: 5,
        barMargin: "100",
        allowedChartTypes: [],
        axisStartValue: 0,
        axisEndValue: 100,
        showDataValues:true,
        brightenAllOnHover:true,
        showValueOnHover:true,
        hoverLabelPadding: -7,
        chartType: "Column",
        facets: [
            {id: "questionTitle", title: "سوالات پرسشنامه"},

        ],
        data: execution_chartData,
        valueProperty: "grade",
        valueTitle: "نمره ارزیابی از صد",
        title: "تحلیل ارزیابی سوالات پرسشنامه",



        minDataPointSize: 10,
        maxDataPointSize: 50,

        showChartRect: true,
        chartRectProperties: {
            lineWidth: 1,
            lineColor: "#bbbbbb",
            rounding: 0.05
        },
        bandedBackground: false,
        chartRectMargin: 15,
        showValueOnHover: true,
        autoDraw: false,

        chartBackgroundDrawn : function() {
            avgLineY =this.getYCoord(65.00);

            isc.DrawLine.create({
                drawPane: this,
                startPoint: [this.getChartLeft(), avgLineY],
                endPoint : [this.getChartLeft() + this.getChartWidth(), avgLineY],
                autoDraw: true
            }, {
                lineWidth: 4,
                lineColor: "red",
                linePattern: "dash"
            });
        }




    });



    var ExecutionEvaluationChartLayout =  isc.VLayout.create({
        defaultLayoutAlign: "center",
        height: "600",
        members: [ ExecutionEvaluationChart]
    });

    var Hlayout_ExecutionEvaluationResult = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [
            VLayout_Body_evaluation_analysis_execution,
            ExecutionEvaluationChartLayout
        ]
    });

    DynamicForm_Execution_EvaluationAnalysis_Header.hide();
    DynamicForm_Execution_EvaluationAnalysis_Footer.hide();
    IButton_Print_ExecutionEvaluation_Evaluation_Analysis.hide();
    ExecutionEvaluationChart.hide();
    ExecutionEvaluationChart.setChartType("Column");

