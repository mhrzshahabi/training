<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>
    var behavioral_chartData = null;

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
                name: "classPassedTime",
                title: "<spring:message code='passed.time.from.class'/>",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {
                name: "numberOfFilledFormsBySuperviosers",
                title: "<spring:message code='number.of.supervisors.answers'/>",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {
                name: "numberOfFilledFormsByStudents",
                title:  "<spring:message code='number.of.students.answers'/>",
                baseStyle: "evaluation-code",
                canEdit: false,
                hidden: true
            }
        ]
    });

    DynamicForm_Behavioral_EvaluationAnalysis_Footer = isc.DynamicForm.create({
        canSubmit: true,
        titleAlign: "right",
        titleWidth: 120,
        width: "64%",
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
                name: "studentsMeanGrade",
                title:  "<spring:message code='students.average.grade'/>",
                baseStyle: "evaluation-code",
                fillHorizontalSpace: true,
                canEdit: false
            },
            {
                name: "supervisorsMeanGrade",
                title: "<spring:message code='supervisors.average.grade'/>",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {
                name: "FEBGrade",
                title: "نمره ارزیابی رفتاری دوره",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {
                name: "FEBPass",
                title: "نتیجه ارزیابی رفتاری",
                baseStyle: "evaluation-code",
                canEdit: false,
                valueMap: {
                    "true": "تائید",
                    "false": "عدم تائید"
                }
            },
            {
                name: "FECBGrade",
                title:  "<spring:message code='FECRGrade'/>",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {
                name: "FECBPass",
                title: "نتیجه اثربخشی",
                baseStyle: "evaluation-code",
                canEdit: false,
                valueMap: {
                    "true": "تائید",
                    "false": "عدم تائید"
                }
            },

        ]
    });

    DynamicForm_Behavioral_EvaluationAnalysis_Header.getItem('studentCount').setCellStyle('evaluation-code-label');
    DynamicForm_Behavioral_EvaluationAnalysis_Header.getItem('studentCount').titleStyle = 'evaluation-code-title';
    DynamicForm_Behavioral_EvaluationAnalysis_Header.getItem('classPassedTime').setCellStyle('evaluation-code-label');
    DynamicForm_Behavioral_EvaluationAnalysis_Header.getItem('classPassedTime').titleStyle = 'evaluation-code-title';
    DynamicForm_Behavioral_EvaluationAnalysis_Header.getItem('numberOfFilledFormsBySuperviosers').setCellStyle('evaluation-code-label');
    DynamicForm_Behavioral_EvaluationAnalysis_Header.getItem('numberOfFilledFormsBySuperviosers').titleStyle = 'evaluation-code-title';
    DynamicForm_Behavioral_EvaluationAnalysis_Header.getItem('numberOfFilledFormsByStudents').setCellStyle('evaluation-code-label');
    DynamicForm_Behavioral_EvaluationAnalysis_Header.getItem('numberOfFilledFormsByStudents').titleStyle = 'evaluation-code-title';

    DynamicForm_Behavioral_EvaluationAnalysis_Footer.getItem('studentsMeanGrade').setCellStyle('evaluation-code-label');
    DynamicForm_Behavioral_EvaluationAnalysis_Footer.getItem('studentsMeanGrade').titleStyle = 'evaluation-code-title';
    DynamicForm_Behavioral_EvaluationAnalysis_Footer.getItem('supervisorsMeanGrade').setCellStyle('evaluation-code-label');
    DynamicForm_Behavioral_EvaluationAnalysis_Footer.getItem('supervisorsMeanGrade').titleStyle = 'evaluation-code-title';
    DynamicForm_Behavioral_EvaluationAnalysis_Footer.getItem('FEBGrade').setCellStyle('evaluation-code-label');
    DynamicForm_Behavioral_EvaluationAnalysis_Footer.getItem('FEBGrade').titleStyle = 'evaluation-code-title';
    DynamicForm_Behavioral_EvaluationAnalysis_Footer.getItem('FEBPass').setCellStyle('evaluation-code-label');
    DynamicForm_Behavioral_EvaluationAnalysis_Footer.getItem('FEBPass').titleStyle = 'evaluation-code-title';
    DynamicForm_Behavioral_EvaluationAnalysis_Footer.getItem('FECBGrade').setCellStyle('evaluation-code-label');
    DynamicForm_Behavioral_EvaluationAnalysis_Footer.getItem('FECBGrade').titleStyle = 'evaluation-code-title';
    DynamicForm_Behavioral_EvaluationAnalysis_Footer.getItem('FECBPass').setCellStyle('evaluation-code-label');
    DynamicForm_Behavioral_EvaluationAnalysis_Footer.getItem('FECBPass').titleStyle = 'evaluation-code-title';

    var IButton_Print_BehavioralEvaluation_Evaluation_Analysis = isc.IButton.create({
        top: 260,
        width: "300",
        height: "25",
        title: "<spring:message code='print.behavioral.evaluation.analysis'/>",
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
                height: 20,
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
        stacked: false,
        allowedChartTypes: [],
        facets: [{
            id: "student",
            title:  "<spring:message code='evaluated.student'/>"
        },{
            id: "evaluator",
            title: "<spring:message code='evaluator'/>"
        }],
        data: behavioral_chartData,
        valueProperty: "grade",
        valueTitle: "تفاوت نمره ی فراگیر به خودش و نمره ی سرپرست به فراگیر",
        title: "<spring:message code='class.behavioral.evaluation.analysis'/>",
    });

    var BehavioralEvaluationChartLayout = isc.VLayout.create({
        defaultLayoutAlign: "center",
        width: "50%",
        height: "100%",
        members: [BehavioralEvaluationChart]
    });

    var Hlayout_BehavioralEvaluationResult = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [
            VLayout_Body_evaluation_analysis_Behavioral,
            BehavioralEvaluationChartLayout
        ]
    });