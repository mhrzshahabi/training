<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>
    var execution_chartData = null;
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
            }
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
            {name: "executionEvaluationAveGrade",
                title: "<spring:message code='FEEGrade'/>",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {name: "executionEvaluationStatus",
                title: "<spring:message code='evaluation.status'/>",
                baseStyle: "evaluation-code",
                canEdit: false,
                valueMap: {
                    "true": "تائید",
                    "false": "عدم تائید"
                }
            },
            {name: "teacherGradeToClass", hidden: true},
            {name: "studentsGradeToTeacher", hidden: true},
            {name: "studentsGradeToFacility" , hidden: true},
            {name: "studentsGradeToGoals", hidden: true},
            {name: "trainingGradeToTeacher", hidden: true}
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

    DynamicForm_Execution_EvaluationAnalysis_Footer.getItem('executionEvaluationAveGrade').setCellStyle('evaluation-code-label');
    DynamicForm_Execution_EvaluationAnalysis_Footer.getItem('executionEvaluationAveGrade').titleStyle = 'evaluation-code-title';
    DynamicForm_Execution_EvaluationAnalysis_Footer.getItem("executionEvaluationStatus").setCellStyle('evaluation-code-label');
    DynamicForm_Execution_EvaluationAnalysis_Footer.getItem("executionEvaluationStatus").titleStyle = 'evaluation-code-title';



    var IButton_Print_ExecutionEvaluation_Evaluation_Analysis = isc.IButton.create({
        top: 260,
        width: "300",
        height: "25",
        margin: 2,
        title: "چاپ خلاصه نتیجه ارزیابی حین دوره",
        click: function () {
            var obj1 = vm_reaction_evaluation.getValues();
            var obj2 =  classRecord_evaluationAnalysist_execution;
            var obj1_str = JSON.stringify(obj1);
            var obj2_str = JSON.stringify(obj2);
            obj1_str = obj1_str.substr(0,obj1_str.length-1);
            obj1_str = obj1_str + ",";
            obj2_str = obj2_str.substr(1,obj2_str.length);
            var object = obj1_str + obj2_str;
            trPrintWithCriteria("<spring:url value="/evaluationAnalysis/printReactionEvaluation"/>",null,object);
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
        hoverLabelPadding: -7,
        facets: [
            {id: "region", title: "حیطه"}],
        data: execution_chartData,
        valueProperty: "grade",
        valueTitle: "نمره ارزیابی از صد",
        title: "تحلیل ارزیابی واکنشی کلاس",
    });


    var chartSelector_execution  = isc.DynamicForm.create({
        canSubmit: true,
        titleAlign: "right",
        titleWidth: 120,
        width: "200",
        fields: [{
            name: "chartType",
            title: "انتخاب نوع نمودار",
            type: "select",
            width: "200",
            valueMap: ["ستونی", "راداری"],
            defaultValue: "ستونی",
            pickListProperties: {
                showFilterEditor: false
            },
            changed : function (form, item, value) {
                if(value == "ستونی"){
                    ExecutionEvaluationChart.setChartType("Column");
                }
                if(value == "راداری"){
                    ExecutionEvaluationChart.setChartType("Radar");
                }
            }
        }]
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
    chartSelector_execution.hide();
    ExecutionEvaluationChart.hide();
    ExecutionEvaluationChart.setChartType("Column");

