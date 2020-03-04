<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
    var vm_Behavioral_evaluation = isc.ValuesManager.create({});

    DynamicForm_Behavioral_EvaluationAnalysis_Header = isc.DynamicForm.create({
        width: "60%",
        canSubmit: true,
        border: "3px solid orange",
        titleWidth: 120,
        valuesManager: vm_Behavioral_evaluation,
        titleAlign: "right",
        showInlineErrors: true,
        showErrorText: false,
        styleName: "evaluation-form",
        numCols: 2,
        margin: 10,
        newPadding: 5,
        canTabToIcons: false,
        fields: [
            {
                name: "studentCount",
                title: "<spring:message code='student.count'/>",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {
                name: "numberOfFilledBehavioralEvaluationForms",
                title: "<spring:message code='numberOfFilledBehavioralEvaluationForms'/>",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {
                name: "numberOfInCompletedBehavioralEvaluationForms",
                title: "<spring:message code='numberOfInCompletedBehavioralEvaluationForms'/>",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {
                name: "numberOfEmptyBehavioralEvaluationForms",
                title: "<spring:message code='numberOfEmptyBehavioralEvaluationForms'/>",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {
                name: "percenetOfFilledBehavioralEvaluationForms",
                title: "<spring:message code='percenetOfFilledBehavioralEvaluationForms'/>",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {
                name: "numberOfExportedBehavioralEvaluationForms",
                title: "<spring:message code='numberOfExportedBehavioralEvaluationForms'/>",
                hidden: true
            }
        ]
    });

    DynamicForm_Behavioral_EvaluationAnalysis_Footer = isc.DynamicForm.create({
        canSubmit: true,
        titleAlign: "right",
        titleWidth: 120,
        width: "54%",
        border: "3px solid orange",
        showInlineErrors: true,
        showErrorText: false,
        valuesManager: vm_Behavioral_evaluation,
        styleName: "teacher-form",
        numCols: 2,
        margin: 10,
        newPadding: 5,
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
                title: "<spring:message code='FETGrade'/>",
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
            {name: "studentsGradeToFacility", hidden: true},
            {name: "studentsGradeToGoals", hidden: true},
            {name: "trainingGradeToTeacher", hidden: true}
        ]
    });

    DynamicForm_Behavioral_EvaluationAnalysis_Header.getItem('studentCount').setCellStyle('evaluation-code-label');
    DynamicForm_Behavioral_EvaluationAnalysis_Header.getItem('studentCount').titleStyle = 'evaluation-code-title';
    DynamicForm_Behavioral_EvaluationAnalysis_Header.getItem('numberOfFilledBehavioralEvaluationForms').setCellStyle('evaluation-code-label');
    DynamicForm_Behavioral_EvaluationAnalysis_Header.getItem('numberOfFilledBehavioralEvaluationForms').titleStyle = 'evaluation-code-title';
    DynamicForm_Behavioral_EvaluationAnalysis_Header.getItem('numberOfInCompletedBehavioralEvaluationForms').setCellStyle('evaluation-code-label');
    DynamicForm_Behavioral_EvaluationAnalysis_Header.getItem('numberOfInCompletedBehavioralEvaluationForms').titleStyle = 'evaluation-code-title';
    DynamicForm_Behavioral_EvaluationAnalysis_Header.getItem('numberOfEmptyBehavioralEvaluationForms').setCellStyle('evaluation-code-label');
    DynamicForm_Behavioral_EvaluationAnalysis_Header.getItem('numberOfEmptyBehavioralEvaluationForms').titleStyle = 'evaluation-code-title';
    DynamicForm_Behavioral_EvaluationAnalysis_Header.getItem('percenetOfFilledBehavioralEvaluationForms').setCellStyle('evaluation-code-label');
    DynamicForm_Behavioral_EvaluationAnalysis_Header.getItem('percenetOfFilledBehavioralEvaluationForms').titleStyle = 'evaluation-code-title';

    DynamicForm_Behavioral_EvaluationAnalysis_Footer.getItem('FERGrade').setCellStyle('evaluation-code-label');
    DynamicForm_Behavioral_EvaluationAnalysis_Footer.getItem('FERGrade').titleStyle = 'evaluation-code-title';
    DynamicForm_Behavioral_EvaluationAnalysis_Footer.getItem('FETGrade').setCellStyle('evaluation-code-label');
    DynamicForm_Behavioral_EvaluationAnalysis_Footer.getItem('FETGrade').titleStyle = 'evaluation-code-title';
    DynamicForm_Behavioral_EvaluationAnalysis_Footer.getItem('FECRGrade').setCellStyle('evaluation-code-label');
    DynamicForm_Behavioral_EvaluationAnalysis_Footer.getItem('FECRGrade').titleStyle = 'evaluation-code-title';
    DynamicForm_Behavioral_EvaluationAnalysis_Footer.getItem('FECRPass').setCellStyle('evaluation-code-label');
    DynamicForm_Behavioral_EvaluationAnalysis_Footer.getItem('FECRPass').titleStyle = 'evaluation-code-title';

    var IButton_Print_BehavioralEvaluation_Evaluation_Analysis = isc.IButton.create({
        top: 260,
        width: "300",
        height: "25",
        title: "چاپ خلاصه نتیجه ارزیابی واکنشی",
        click: function () {
            var obj1 = vm_Behavioral_evaluation.getValues();
            var obj2 = ListGrid_evaluationAnalysis_class.getSelectedRecord();
            delete obj1['studentCount'];
            var obj1_str = JSON.stringify(obj1);
            var obj2_str = JSON.stringify(obj2);
            obj1_str = obj1_str.substr(0, obj1_str.length - 1);
            obj1_str = obj1_str + ",";
            obj2_str = obj2_str.substr(1, obj2_str.length);
            var object = obj1_str + obj2_str;
            trPrintWithCriteria("<spring:url value="/evaluationAnalysis/printBehavioralEvaluation"/>", null, object);
        }
    });

    var Hlayout_Tab_BehavioralEvaluation_Evaluation_Analysis_Print = isc.HLayout.create({
        width: "100%",
        height: "49%",
        align: "center",
        members: [
            IButton_Print_BehavioralEvaluation_Evaluation_Analysis
        ]
    });

    var Vlayout_DynamicForms_BehavioralEvaluation = isc.VLayout.create({
        defaultLayoutAlign: "center",
        members: [
            isc.LayoutSpacer.create({
                height: 20,
                width: "*",
            }),
            DynamicForm_Behavioral_EvaluationAnalysis_Header,
            isc.LayoutSpacer.create({
                height: 40,
                width: "*",
            }),
            DynamicForm_Behavioral_EvaluationAnalysis_Footer
        ]
    });

    var VLayout_Body_evaluation_analysis_Behavioral = isc.VLayout.create({
        width: "50%",
        height: "100%",
        members: [Vlayout_DynamicForms_BehavioralEvaluation,
            isc.LayoutSpacer.create({
                height: 20,
                width: "*",
            }),
            Hlayout_Tab_BehavioralEvaluation_Evaluation_Analysis_Print]
    });

    var BehavioralEvaluationChart = isc.FacetChart.create({
        titleAlign: "center",
        minLabelGap: 5,
        width: "80%",
        height: "90%",
        barMargin: "100",
        allowedChartTypes: [],
        facets: [
            {id: "region", title: "حیطه"}],
        data: chartData,
        valueProperty: "grade",
        valueTitle: "نمره ارزیابی از صد",
        title: "تحلیل ارزیابی واکنشی کلاس",
    });


    var chartSelector = isc.DynamicForm.create({
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
            changed: function (form, item, value) {
                if (value == "ستونی") {
                    BehavioralEvaluationChart.setChartType("Column");
                }
                if (value == "راداری") {
                    BehavioralEvaluationChart.setChartType("Radar");
                }
            }
        }]
    });

    var BehavioralEvaluationChartLayout = isc.VLayout.create({
        defaultLayoutAlign: "center",
        width: "50%",
        height: "100%",
        members: [chartSelector, BehavioralEvaluationChart]
    });

    var Hlayout_BehavioralEvaluationResult = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [
            VLayout_Body_evaluation_analysis_Behavioral,
            BehavioralEvaluationChartLayout
        ]
    });