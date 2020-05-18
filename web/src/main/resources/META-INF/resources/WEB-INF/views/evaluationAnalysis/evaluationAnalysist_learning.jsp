<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>
    <%
        final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
    %>

    var change_value;
    var arrData = [];
    var minscoreValue;

    RestDataSource_evaluationAnalysist_learning = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {name: "tclass.scoringMethod"},
            {
                name: "student.firstName",filterOperator: "iContains"
            },
            {
                name: "student.lastName",filterOperator: "iContains"
            },
            {
                name: "student.nationalCode",filterOperator: "iContains"
            },

            {
                name: "student.personnelNo",filterOperator: "iContains"
            },
            {name:"preTestScore", filterOperator: "iContains"},
            {name:"score", filterOperator: "iContains"}
        ]
    });
    //----------------------------------------------------Learning Evaluation-------------------------------------------

    var vm_learning_evaluation = isc.ValuesManager.create({});

    DynamicForm_Learning_EvaluationAnalysis_Header = isc.DynamicForm.create({
        width: "60%",
        canSubmit: true,
        border: "3px solid orange",
        titleWidth: 120,
        valuesManager: vm_learning_evaluation,
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
                name: "numberOfFilledLearningEvaluationForms",
                title: "<spring:message code='numberOfFilledReactionEvaluationForms'/>",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {
                name: "numberOfInCompletedLearningEvaluationForms",
                title: "<spring:message code='numberOfInCompletedReactionEvaluationForms'/>",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {
                name: "numberOfEmptyLearningEvaluationForms",
                title:"<spring:message code='numberOfEmptyReactionEvaluationForms'/>",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {
                name: "percenetOfFilledLearningEvaluationForms",
                title: "<spring:message code='percenetOfFilledReactionEvaluationForms'/>",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {
                name: "numberOfExportedLearningEvaluationForms",
                title: "<spring:message code='numberOfExportedReactionEvaluationForms'/>",
                hidden: true
            }
        ]
    });

    DynamicForm_Learning_EvaluationAnalysis_Footer = isc.DynamicForm.create({
        canSubmit: true,
        titleAlign: "right",
        titleWidth: 120,
        width: "54%",
        border: "3px solid orange",
        showInlineErrors: true,
        showErrorText: false,
        valuesManager: vm_learning_evaluation,
        styleName: "teacher-form",
        numCols: 2,
        margin: 2,
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
                title:"<spring:message code='FETGrade'/>",
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

    DynamicForm_Learning_EvaluationAnalysis_Header.getItem('studentCount').setCellStyle('evaluation-code-label');
    DynamicForm_Learning_EvaluationAnalysis_Header.getItem('studentCount').titleStyle = 'evaluation-code-title';
    DynamicForm_Learning_EvaluationAnalysis_Header.getItem('numberOfFilledLearningEvaluationForms').setCellStyle('evaluation-code-label');
    DynamicForm_Learning_EvaluationAnalysis_Header.getItem('numberOfFilledLearningEvaluationForms').titleStyle = 'evaluation-code-title';
    DynamicForm_Learning_EvaluationAnalysis_Header.getItem('numberOfInCompletedLearningEvaluationForms').setCellStyle('evaluation-code-label');
    DynamicForm_Learning_EvaluationAnalysis_Header.getItem('numberOfInCompletedLearningEvaluationForms').titleStyle = 'evaluation-code-title';
    DynamicForm_Learning_EvaluationAnalysis_Header.getItem('numberOfEmptyLearningEvaluationForms').setCellStyle('evaluation-code-label');
    DynamicForm_Learning_EvaluationAnalysis_Header.getItem('numberOfEmptyLearningEvaluationForms').titleStyle = 'evaluation-code-title';
    DynamicForm_Learning_EvaluationAnalysis_Header.getItem('percenetOfFilledLearningEvaluationForms').setCellStyle('evaluation-code-label');
    DynamicForm_Learning_EvaluationAnalysis_Header.getItem('percenetOfFilledLearningEvaluationForms').titleStyle = 'evaluation-code-title';

    DynamicForm_Learning_EvaluationAnalysis_Footer.getItem('FERGrade').setCellStyle('evaluation-code-label');
    DynamicForm_Learning_EvaluationAnalysis_Footer.getItem('FERGrade').titleStyle = 'evaluation-code-title';
    DynamicForm_Learning_EvaluationAnalysis_Footer.getItem('FETGrade').setCellStyle('evaluation-code-label');
    DynamicForm_Learning_EvaluationAnalysis_Footer.getItem('FETGrade').titleStyle = 'evaluation-code-title';
    DynamicForm_Learning_EvaluationAnalysis_Footer.getItem('FECRGrade').setCellStyle('evaluation-code-label');
    DynamicForm_Learning_EvaluationAnalysis_Footer.getItem('FECRGrade').titleStyle = 'evaluation-code-title';
    DynamicForm_Learning_EvaluationAnalysis_Footer.getItem('FECRPass').setCellStyle('evaluation-code-label');
    DynamicForm_Learning_EvaluationAnalysis_Footer.getItem('FECRPass').titleStyle = 'evaluation-code-title';

    var IButton_Print_LearningEvaluation_Evaluation_Analysis = isc.IButton.create({
        top: 260,
        width: "300",
        height: "25",
        margin: 2,
        title: "چاپ خلاصه نتیجه ارزیابی یادگیری",
        click: function () {
            printEvaluationAnalysistLearning(minscoreValue);
        }
    });

    var IButton_Evaluate_LearningEvaluation_Evaluation_Analysis = isc.IButton.create({
        top: 260,
        width: "300",
        height: "25",
        margin: 2,
        title: "تحلیل ارزیابی یادگیری",
        click: function () {
            DynamicForm_Learning_EvaluationAnalysis_Header.show();
            DynamicForm_Learning_EvaluationAnalysis_Footer.show();
            IButton_Print_LearningEvaluation_Evaluation_Analysis.show();
        }
    });

    var VLayout_Body_evaluation_analysis_learning = isc.VLayout.create({
        width: "53%",
        height: "100%",
        defaultLayoutAlign: "center",
        members: [ DynamicForm_Learning_EvaluationAnalysis_Header,
            DynamicForm_Learning_EvaluationAnalysis_Footer,
            IButton_Print_LearningEvaluation_Evaluation_Analysis]
    });

    var ListGrid_evaluationAnalysist_learning = isc.TrLG.create({
        selectionType: "single",
        editOnFocus: true,
        showRowNumbers: false,
        editByCell: true,
        editEvent: "click",
        modalEditing: true,
        autoSaveEdits: false,
        canSelectCells: true,
        canHover:true,
        dataSource: RestDataSource_evaluationAnalysist_learning,
        fields: [
            {
                name: "student.personnelNo",
                title: "<spring:message code="personnel.no"/>",
                filterOperator: "iContains",autoFitWidth:true

            },
            {
                name: "student.nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains",autoFitWidth:true

            },
            {
                name: "student.firstName",
                title: "<spring:message code="firstName"/>",
                filterOperator: "iContains",autoFitWidth:true

            },
            {
                name: "student.lastName",
                title: "<spring:message code="lastName"/>",
                filterOperator: "iContains",autoFitWidth:true

            },
            {
                name: "preTestScore",
                title: "نمره پيش آزمون",
                filterOperator: "iContains",
                canEdit: true,
                validateOnChange: false,
                autoFitWidth:true,
                editEvent: "click",

                change:function(){
                    change_value=true
                },
                editorExit:function(editCompletionEvent, record, newValue)
                {

                    if (newValue != null) {
                        if (validators_evaluarionAnalysist_Learning_ScorePreTest(newValue)) {
                            ListGrid_Cell_evaluationAnalysist_learning(record, newValue);
                        } else {
                            createDialog("info", "<spring:message code="enter.current.score"/>", "<spring:message code="message"/>")

                        }
                    }
                    else if(change_value) {
                        ListGrid_Cell_evaluationAnalysist_learning(record, newValue);
                        change_value=false;
                    }
                    else {return true}
                },
                hoverHTML:function (record, rowNum, colNum, grid) {
                    return"نمره پیش آزمون بین 0 تا 100 می باشد"
                }
            },
            {
                name:"score", title: "نمره پس آزمون",  filterOperator: "iContains",autoFitWidth:true

            }
        ]
    });

    var LearningEvaluationGridLayout =  isc.VLayout.create({
        defaultLayoutAlign: "center",
        width: "37%",
        height: "400",
        members: [ListGrid_evaluationAnalysist_learning,IButton_Evaluate_LearningEvaluation_Evaluation_Analysis]
    });

    var Hlayout_LearningEvaluationResult = isc.HLayout.create({
        width: "100%",
        height: "100%",
        overflow: "scroll",
        members: [
            LearningEvaluationGridLayout,
            VLayout_Body_evaluation_analysis_learning
        ]
    });

    DynamicForm_Learning_EvaluationAnalysis_Header.hide();
    DynamicForm_Learning_EvaluationAnalysis_Footer.hide();
    IButton_Print_LearningEvaluation_Evaluation_Analysis.hide();


    function ListGrid_Cell_evaluationAnalysist_learning(record,newValue)
    {
        record.preTestScore=newValue;
        isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/score-pre-test"+"/" + record.id, "PUT", JSON.stringify(record), "callback: Edit_Cell_score_Update(rpcResponse)"));
    }

    function validators_evaluarionAnalysist_Learning_ScorePreTest(value) {
        if (value.match(/^(100|[1-9]?\d)$/)) {
            return true;
        } else {
            return false;
        }
    }

    function evaluationAnalysist_learning() {
        var Record = ListGrid_evaluationAnalysis_class.getSelectedRecord();
        if (!(Record === undefined || Record == null)) {
            isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/iscList/FEL", "GET", null, "callback:results(rpcResponse)"));
            RestDataSource_evaluationAnalysist_learning.fetchDataURL = tclassStudentUrl + "/evaluationAnalysistLearning/" + Record.id;
            ListGrid_evaluationAnalysist_learning.invalidateCache();
            ListGrid_evaluationAnalysist_learning.fetchData();
            // if (Record.scoringMethod == "1") {
            //     ListGrid_evaluationAnalysist_learning.hideField('score');
            // } else if (Record.scoringMethod == "2") {
            //     ListGrid_evaluationAnalysist_learning.showField('score');
            // }
            // else if (Record.scoringMethod == "3") {
            //     ListGrid_evaluationAnalysist_learning.showField('score');
            // }
            // else if (Record.scoringMethod == "4") {
            //     ListGrid_evaluationAnalysist_learning.hideField('score');
            // }
        }
    }

    function printEvaluationAnalysistLearning(a) {

        var Record = ListGrid_evaluationAnalysis_class.getSelectedRecord();
        var criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/evaluationAnalysist-learning/evaluaationAnalysist-learningReport"/>",
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "recordId", type: "hidden"},
                    {name: "token", type: "hidden"},
                    {name: "record", type: "hidden"},
                    {name: "minScore", type: "hidden"},

                ]

        });
        criteriaForm.setValue("recordId", JSON.stringify(Record.id));
        criteriaForm.setValue("record", JSON.stringify(Record));
        criteriaForm.setValue("minScore",a);
        criteriaForm.setValue("token", "<%= accessToken %>");
        criteriaForm.show();
        criteriaForm.submitForm();
    };


    function results(resp)
    {

        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            arrData = (JSON.parse(resp.data)).response.data;
            minscoreValue=arrData.filter(function(x){return x.code=="minScoreEL"})[0].value
        } else {

        }

    }