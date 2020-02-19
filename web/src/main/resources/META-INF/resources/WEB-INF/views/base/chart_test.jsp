<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
// <script>
/////////////////////////////
var vm_reaction_evaluation = isc.ValuesManager.create({});

DynamicForm_Reaction_EvaluationAnalysis = isc.DynamicForm.create({
    align: "right",
    canSubmit: true,
    titleWidth: 120,
    valuesManager: vm_reaction_evaluation,
    titleAlign: "left",
    showInlineErrors: true,
    showErrorText: false,
    styleName: "teacher-form",
    numCols: 4,
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
        },
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


DynamicForm_Reaction_EvaluationAnalysis.getItem('studentCount').setCellStyle('teacher-code-label');
DynamicForm_Reaction_EvaluationAnalysis.getItem('studentCount').titleStyle = 'teacher-code-title';
DynamicForm_Reaction_EvaluationAnalysis.getItem('numberOfFilledReactionEvaluationForms').setCellStyle('teacher-code-label');
DynamicForm_Reaction_EvaluationAnalysis.getItem('numberOfFilledReactionEvaluationForms').titleStyle = 'teacher-code-title';
DynamicForm_Reaction_EvaluationAnalysis.getItem('numberOfInCompletedReactionEvaluationForms').setCellStyle('teacher-code-label');
DynamicForm_Reaction_EvaluationAnalysis.getItem('numberOfInCompletedReactionEvaluationForms').titleStyle = 'teacher-code-title';
DynamicForm_Reaction_EvaluationAnalysis.getItem('numberOfEmptyReactionEvaluationForms').setCellStyle('teacher-code-label');
DynamicForm_Reaction_EvaluationAnalysis.getItem('numberOfEmptyReactionEvaluationForms').titleStyle = 'teacher-code-title';
DynamicForm_Reaction_EvaluationAnalysis.getItem('percenetOfFilledReactionEvaluationForms').setCellStyle('teacher-code-label');
DynamicForm_Reaction_EvaluationAnalysis.getItem('percenetOfFilledReactionEvaluationForms').titleStyle = 'teacher-code-title';

DynamicForm_Reaction_EvaluationAnalysis.getItem('FERGrade').setCellStyle('teacher-code-label');
DynamicForm_Reaction_EvaluationAnalysis.getItem('FERGrade').titleStyle = 'teacher-code-title';
DynamicForm_Reaction_EvaluationAnalysis.getItem('FETGrade').setCellStyle('teacher-code-label');
DynamicForm_Reaction_EvaluationAnalysis.getItem('FETGrade').titleStyle = 'teacher-code-title';
DynamicForm_Reaction_EvaluationAnalysis.getItem('FECRGrade').setCellStyle('teacher-code-label');
DynamicForm_Reaction_EvaluationAnalysis.getItem('FECRGrade').titleStyle = 'teacher-code-title';
DynamicForm_Reaction_EvaluationAnalysis.getItem('FECRPass').setCellStyle('teacher-code-label');
DynamicForm_Reaction_EvaluationAnalysis.getItem('FECRPass').titleStyle = 'teacher-code-title';


var IButton_Print_ReactionEvaluation_Evaluation_Analysis = isc.IButton.create({
    top: 260,
    width: "300",
    height: "25",
    title: "چاپ خلاصه نتیجه ارزیابی واکنشی",
    click: function () {
    }
});

var Hlayout_Tab_ReactionEvaluation_Evaluation_Analysis_Print = isc.HLayout.create({
    align: "center",
    members: [
        IButton_Print_ReactionEvaluation_Evaluation_Analysis
    ]
});

var VLayout_Body_evaluation_analysis_reaction = isc.VLayout.create({
    width: "50%",
    height: "100%",
    members: [DynamicForm_Reaction_EvaluationAnalysis,
        Hlayout_Tab_ReactionEvaluation_Evaluation_Analysis_Print]
});
////////////////////////////

    var chartData  = [
        {region: "محتوی", grade: 50},
        {region: "مدرس", grade: 40},
        {region: "امکانات", grade: 30},
        {region: "نظر استاد", grade: 60}
    ];

    isc.FacetChart.create({
        ID: "ReactionEvaluationChart",
        titleAlign: "center",
        minLabelGap: 5,
        barMargin: "100",
        allowedChartTypes: [],
        facets: [
            {id: "region", title: "حیطه"}],
        data: chartData,
        valueProperty: "grade",
        valueTitle: "نمره ارزیابی از صد",
        // chartType: "Column",
        title: "تحلیل ارزیابی واکنشی کلاس",
    });


    isc.DynamicForm.create({
        ID: "chartSelector",
        items: [{
            name: "chartType",
            title: "انتخاب نوع نمودار",
            type: "select",
            valueMap: ["ستونی", "راداری"],
            defaultValue: "ستونی",
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
        width: "50%",
        height: "100%",
        align: "center",
        overflow: "scroll",
        membersMargin: 20,
        members: [chartSelector, ReactionEvaluationChart]
    });

    var Hlayout_Mine = isc.HLayout.create({
        width: "100%",
        height: "100%",
        align: "center",
        members: [
            VLayout_Body_evaluation_analysis_reaction,
            ReactionEvaluationChartLayout
        ]
    });

    ReactionEvaluationChart.setChartType("Column");



