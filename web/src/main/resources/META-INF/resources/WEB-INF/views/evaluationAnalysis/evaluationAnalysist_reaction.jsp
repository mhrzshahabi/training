<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>
    var reaction_chartData = null;
    var classRecord_evaluationAnalysist_reaction;
    //----------------------------------------------------Reaction Evaluation-------------------------------------------

    var vm_reaction_evaluation = isc.ValuesManager.create({});

    DynamicForm_Reaction_EvaluationAnalysis_Header = isc.DynamicForm.create({
        canSubmit: true,
        border: "3px solid orange",
        titleWidth: 120,
        valuesManager: vm_reaction_evaluation,
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
                name: "numberOfFilledReactionEvaluationForms",
                title: "<spring:message code='numberOfFilledReactionEvaluationForms'/>",
                baseStyle: "evaluation-code",
                canEdit: false,
                hidden: true
            },
            {
                name: "numberOfInCompletedReactionEvaluationForms",
                title: "<spring:message code='numberOfInCompletedReactionEvaluationForms'/>",
                baseStyle: "evaluation-code",
                canEdit: false,
                hidden: true
            },
            {
                name: "filledFormsInfo",
                title: "<spring:message code='numberOfFilledReactionEvaluationForms'/>",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {
                name: "numberOfAbsentForm",
                title: "تعداد فراگیران غایب",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {
                name: "numberOfEmptyReactionEvaluationForms",
                title:"<spring:message code='numberOfEmptyReactionEvaluationForms'/>",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {
                name: "percenetOfFilledReactionEvaluationForms",
                title: "<spring:message code='percenetOfFilledReactionEvaluationForms'/>",
                baseStyle: "evaluation-code",
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
        canSubmit: true,
        titleAlign: "right",
        titleWidth: 120,
        border: "3px solid orange",
        showInlineErrors: true,
        showErrorText: false,
        valuesManager: vm_reaction_evaluation,
        styleName: "teacher-form",
        numCols: 2,
        margin: 5,
        canTabToIcons: false,
        fields: [
            {
                name: "FERGrade",
                title: "<spring:message code='FERGrade'/>",
                baseStyle: "evaluation-code",
                fillHorizontalSpace: true,
                canEdit: false
            },
            {
                name: "FETGrade",
                title:"نمره ارزیابی مدرس کلاس",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {
                name: "FECRGrade",
                title: "<spring:message code='FECRGrade'/>",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {
                name: "FECRPass",
                title: "<spring:message code='evaluation.status'/>",
                baseStyle: "evaluation-code",
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

    DynamicForm_Reaction_EvaluationAnalysis_Header.getItem('studentCount').setCellStyle('evaluation-code-label');
    DynamicForm_Reaction_EvaluationAnalysis_Header.getItem('studentCount').titleStyle = 'evaluation-code-title';
    DynamicForm_Reaction_EvaluationAnalysis_Header.getItem('numberOfFilledReactionEvaluationForms').setCellStyle('evaluation-code-label');
    DynamicForm_Reaction_EvaluationAnalysis_Header.getItem('numberOfFilledReactionEvaluationForms').titleStyle = 'evaluation-code-title';
    DynamicForm_Reaction_EvaluationAnalysis_Header.getItem('numberOfInCompletedReactionEvaluationForms').setCellStyle('evaluation-code-label');
    DynamicForm_Reaction_EvaluationAnalysis_Header.getItem('numberOfInCompletedReactionEvaluationForms').titleStyle = 'evaluation-code-title';
    DynamicForm_Reaction_EvaluationAnalysis_Header.getItem('numberOfAbsentForm').setCellStyle('evaluation-code-label');
    DynamicForm_Reaction_EvaluationAnalysis_Header.getItem('numberOfAbsentForm').titleStyle = 'evaluation-code-title';
    DynamicForm_Reaction_EvaluationAnalysis_Header.getItem('numberOfEmptyReactionEvaluationForms').setCellStyle('evaluation-code-label');
    DynamicForm_Reaction_EvaluationAnalysis_Header.getItem('numberOfEmptyReactionEvaluationForms').titleStyle = 'evaluation-code-title';
    DynamicForm_Reaction_EvaluationAnalysis_Header.getItem('percenetOfFilledReactionEvaluationForms').setCellStyle('evaluation-code-label');
    DynamicForm_Reaction_EvaluationAnalysis_Header.getItem('percenetOfFilledReactionEvaluationForms').titleStyle = 'evaluation-code-title';
    DynamicForm_Reaction_EvaluationAnalysis_Header.getItem('filledFormsInfo').setCellStyle('evaluation-code-label');
    DynamicForm_Reaction_EvaluationAnalysis_Header.getItem('filledFormsInfo').titleStyle = 'evaluation-code-title';

    DynamicForm_Reaction_EvaluationAnalysis_Footer.getItem('FERGrade').setCellStyle('evaluation-code-label');
    DynamicForm_Reaction_EvaluationAnalysis_Footer.getItem('FERGrade').titleStyle = 'evaluation-code-title';
    DynamicForm_Reaction_EvaluationAnalysis_Footer.getItem('FETGrade').setCellStyle('evaluation-code-label');
    DynamicForm_Reaction_EvaluationAnalysis_Footer.getItem('FETGrade').titleStyle = 'evaluation-code-title';
    DynamicForm_Reaction_EvaluationAnalysis_Footer.getItem('FECRGrade').setCellStyle('evaluation-code-label');
    DynamicForm_Reaction_EvaluationAnalysis_Footer.getItem('FECRGrade').titleStyle = 'evaluation-code-title';
    DynamicForm_Reaction_EvaluationAnalysis_Footer.getItem('FECRPass').setCellStyle('evaluation-code-label');
    DynamicForm_Reaction_EvaluationAnalysis_Footer.getItem('FECRPass').titleStyle = 'evaluation-code-title';

    var IButton_Print_ReactionEvaluation_Evaluation_Analysis = isc.IButton.create({
        top: 260,
        width: "300",
        height: "25",
        margin: 2,
        title: "چاپ خلاصه نتیجه ارزیابی واکنشی",
        click: function () {
            var obj1 = vm_reaction_evaluation.getValues();
            var obj2 =  classRecord_evaluationAnalysist_reaction;
            var obj1_str = JSON.stringify(obj1);
            var obj2_str = JSON.stringify(obj2);
            obj1_str = obj1_str.substr(0,obj1_str.length-1);
            obj1_str = obj1_str + ",";
            obj2_str = obj2_str.substr(1,obj2_str.length);
            var object = obj1_str + obj2_str;
            trPrintWithCriteria("<spring:url value="/evaluationAnalysis/printReactionEvaluation"/>",null,object);
        }
    });

    var VLayout_Body_evaluation_analysis_reaction = isc.VLayout.create({
        defaultLayoutAlign: "center",
        members: [ DynamicForm_Reaction_EvaluationAnalysis_Header,
            DynamicForm_Reaction_EvaluationAnalysis_Footer,
            IButton_Print_ReactionEvaluation_Evaluation_Analysis]
    });

    var ReactionEvaluationChart = isc.FacetChart.create({
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
        data: reaction_chartData,
        valueProperty: "grade",
        valueTitle: "نمره ارزیابی از صد",
        title: "تحلیل ارزیابی واکنشی کلاس",
    });


    var chartSelector  = isc.DynamicForm.create({
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
                    ReactionEvaluationChart.setChartType("Column");
                }
                if(value == "راداری"){
                    ReactionEvaluationChart.setChartType("Radar");
                }
            }
        }]
    });

    var ReactionEvaluationChartLayout =  isc.VLayout.create({
        defaultLayoutAlign: "center",
        height: "600",
        members: [chartSelector, ReactionEvaluationChart]
    });

    var Hlayout_ReactionEvaluationResult = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [
            VLayout_Body_evaluation_analysis_reaction,
            ReactionEvaluationChartLayout
        ]
    });

    DynamicForm_Reaction_EvaluationAnalysis_Header.hide();
    DynamicForm_Reaction_EvaluationAnalysis_Footer.hide();
    IButton_Print_ReactionEvaluation_Evaluation_Analysis.hide();
    chartSelector.hide();
    ReactionEvaluationChart.hide();
    ReactionEvaluationChart.setChartType("Column");
