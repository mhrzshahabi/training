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
                name: "student.personnelNo",filterOperator: "iContains"
            },
            {name:"preTestScore", filterOperator: "iContains"},
            {name:"score", filterOperator: "iContains"},
            {name:"valence", filterOperator: "iContains"}
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
                title: "تعداد شرکت کننده",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {
                name: "preTestMeanScore",
                title: "میانگین نمرات پیش آزمون",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {
                name: "postTestMeanScore",
                title: "میانگین نمرات پس آزمون",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {
                name: "havePreTest",
                title:"پیش آزمون",
                baseStyle: "evaluation-code",
                canEdit: false,
                valueMap: {
                    "true": "داشتیم",
                    "false": "نداشتیم"
                }
            },
            {
                name: "havePostTest",
                title: "پس آزمون",
                baseStyle: "evaluation-code",
                canEdit: false,
                valueMap: {
                    "true": "داشتیم",
                    "false": "نداشتیم"
                }
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
                name: "FELGrade",
                title: "نمره ارزیابی یادگیری",
                baseStyle: "evaluation-code",
                fillHorizontalSpace: true,
                canEdit: false
            },
            {
                name: "Limit",
                title:"حد قابل قبول",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {
                name: "FELPass",
                title: "نتیجه ارزیابی یادگیری",
                baseStyle: "evaluation-code",
                canEdit: false,
                valueMap: {
                    "true": "تائید",
                    "false": "عدم تائید"
                }
            },
            {
                name: "FECLGrade",
                title:"نمره اثربخشی",
                baseStyle: "evaluation-code",
                canEdit: false
            },
            {
                name: "FECLPass",
                title: "نتیجه ی اثربخشی",
                baseStyle: "evaluation-code",
                canEdit: false,
                valueMap: {
                    "true": "تائید",
                    "false": "عدم تائید"
                }
            },
            {
                name: "tstudent",
                title: "",
                baseStyle: "evaluation-code",
                canEdit: false
            }
        ]
    });

    DynamicForm_Learning_EvaluationAnalysis_Header.getItem('studentCount').setCellStyle('evaluation-code-label');
    DynamicForm_Learning_EvaluationAnalysis_Header.getItem('studentCount').titleStyle = 'evaluation-code-title';
    DynamicForm_Learning_EvaluationAnalysis_Header.getItem('preTestMeanScore').setCellStyle('evaluation-code-label');
    DynamicForm_Learning_EvaluationAnalysis_Header.getItem('preTestMeanScore').titleStyle = 'evaluation-code-title';
    DynamicForm_Learning_EvaluationAnalysis_Header.getItem('postTestMeanScore').setCellStyle('evaluation-code-label');
    DynamicForm_Learning_EvaluationAnalysis_Header.getItem('postTestMeanScore').titleStyle = 'evaluation-code-title';
    DynamicForm_Learning_EvaluationAnalysis_Header.getItem('havePreTest').setCellStyle('evaluation-code-label');
    DynamicForm_Learning_EvaluationAnalysis_Header.getItem('havePreTest').titleStyle = 'evaluation-code-title';
    DynamicForm_Learning_EvaluationAnalysis_Header.getItem('havePostTest').setCellStyle('evaluation-code-label');
    DynamicForm_Learning_EvaluationAnalysis_Header.getItem('havePostTest').titleStyle = 'evaluation-code-title';

    DynamicForm_Learning_EvaluationAnalysis_Footer.getItem('FELGrade').setCellStyle('evaluation-code-label');
    DynamicForm_Learning_EvaluationAnalysis_Footer.getItem('FELGrade').titleStyle = 'evaluation-code-title';
    DynamicForm_Learning_EvaluationAnalysis_Footer.getItem('Limit').setCellStyle('evaluation-code-label');
    DynamicForm_Learning_EvaluationAnalysis_Footer.getItem('Limit').titleStyle = 'evaluation-code-title';
    DynamicForm_Learning_EvaluationAnalysis_Footer.getItem('FELPass').setCellStyle('evaluation-code-label');
    DynamicForm_Learning_EvaluationAnalysis_Footer.getItem('FELPass').titleStyle = 'evaluation-code-title';
    DynamicForm_Learning_EvaluationAnalysis_Footer.getItem('FECLGrade').setCellStyle('evaluation-code-label');
    DynamicForm_Learning_EvaluationAnalysis_Footer.getItem('FECLGrade').titleStyle = 'evaluation-code-title';
    DynamicForm_Learning_EvaluationAnalysis_Footer.getItem('FECLPass').setCellStyle('evaluation-code-label');
    DynamicForm_Learning_EvaluationAnalysis_Footer.getItem('FECLPass').titleStyle = 'evaluation-code-title';

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

    function fill_learning_evaluation_result_resp(resp) {
        load_learning_evluation_analysis_data(JSON.parse(resp.data));
    }

    function load_learning_evluation_analysis_data(record) {
        var gridClassList = ListGrid_evaluationAnalysis_class.getSelectedRecord();
        DynamicForm_Learning_EvaluationAnalysis_Header.getField("studentCount").setValue(record.studentCount);
        DynamicForm_Learning_EvaluationAnalysis_Header.getField("preTestMeanScore").setValue(record.preTestMeanScore);
        DynamicForm_Learning_EvaluationAnalysis_Header.getField("postTestMeanScore").setValue(record.postTestMeanScore);
        DynamicForm_Learning_EvaluationAnalysis_Header.getField("havePreTest").setValue(record.havePreTest);
        DynamicForm_Learning_EvaluationAnalysis_Header.getField("havePostTest").setValue(record.havePostTest);

        DynamicForm_Learning_EvaluationAnalysis_Footer.getField("FELGrade").setValue(record.felgrade);
        DynamicForm_Learning_EvaluationAnalysis_Footer.getField("Limit").setValue(record.limit);
        DynamicForm_Learning_EvaluationAnalysis_Footer.getField("FELPass").setValue(record.felpass);
        DynamicForm_Learning_EvaluationAnalysis_Footer.getField("FECLGrade").setValue(record.feclgrade);
        DynamicForm_Learning_EvaluationAnalysis_Footer.getField("FECLPass").setValue(record.feclpass);
        DynamicForm_Learning_EvaluationAnalysis_Footer.getField("tstudent").setValue(record.tstudent);
    }

    var VLayout_Body_evaluation_analysis_learning = isc.VLayout.create({
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
                filterOperator: "iContains",autoFitWidth:true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
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
                // canEdit: true,
                validateOnChange: false,
                autoFitWidth:true,
                editEvent: "click",
                filterEditorProperties: {
                    keyPressFilter: "[0-9|.]"
                },
                change:function(form,item,value,oldValue){

                    if(value!=null && value!='' && typeof (value) != 'undefined'&& !value.match(/^(([1-9]\d{0,1})|100|0)$/)){
                        item.setValue(value.substring(0,value.length-1));
                    }else{
                        item.setValue(value);
                    }

                    if(value==null || typeof (value) == 'undefined'){
                        item.setValue('');
                    }


                    if(oldValue==null || typeof (oldValue) == 'undefined'){
                        oldValue='';
                    }


                    if(item.getValue() != oldValue)
                    {
                        change_value=true;
                    }
                },
                editorExit:function(editCompletionEvent, record, newValue) {

                    if( change_value){
                        if (newValue != null && newValue != '' && typeof (newValue) != 'undefined') {

                            ListGrid_Cell_evaluationAnalysist_learning(record, newValue);

                        } else {
                            ListGrid_Cell_evaluationAnalysist_learning(record, null);
                        }
                    }
                    change_value=false;
                },
                // hoverHTML:function (record, rowNum, colNum, grid) {
                //     return"نمره پیش آزمون بین 0 تا 100 می باشد"
                // }
            },
            {
                name:"score", title: "نمره پس آزمون",  filterOperator: "iContains",autoFitWidth:true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9|.]"
                }
            },
            {
                name:"valence",title: "نمره پس آزمون",  filterOperator: "iContains",autoFitWidth:true,
                valueMap: {"1001": "40", "1002": "60", "1003": "80", "1004": "100"},
                filterEditorProperties: {
                    keyPressFilter: "[0-9|.]"
                }
            }
        ]
    });

    var LearningEvaluationGridLayout =  isc.VLayout.create({
        defaultLayoutAlign: "center",
        height: "400",
        members: [ListGrid_evaluationAnalysist_learning]
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
        DynamicForm_Learning_EvaluationAnalysis_Footer.clearValues();
        DynamicForm_Learning_EvaluationAnalysis_Header.clearValues();
        var Record = ListGrid_evaluationAnalysis_class.getSelectedRecord();
        if (!(Record === undefined || Record == null)) {
            isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/iscList/FEL", "GET", null, "callback:results(rpcResponse)"));
            RestDataSource_evaluationAnalysist_learning.fetchDataURL = tclassStudentUrl + "/evaluationAnalysistLearning/" + Record.id;
            ListGrid_evaluationAnalysist_learning.invalidateCache();
            ListGrid_evaluationAnalysist_learning.fetchData();
            if (Record.classScoringMethod == "1") {
                ListGrid_evaluationAnalysist_learning.hideField('score');
                ListGrid_evaluationAnalysist_learning.showField('valence');
            } else if (Record.classScoringMethod == "2") {
                ListGrid_evaluationAnalysist_learning.showField('score');
                ListGrid_evaluationAnalysist_learning.hideField('valence');
            }
            else if (Record.classScoringMethod == "3") {
                ListGrid_evaluationAnalysist_learning.showField('score');
                ListGrid_evaluationAnalysist_learning.hideField('valence');
            }
            else if (Record.classScoringMethod == "4") {
                ListGrid_evaluationAnalysist_learning.hideField('valence');
                ListGrid_evaluationAnalysist_learning.hideField('score');
            }
        }
        isc.RPCManager.sendRequest(TrDSRequest(evaluationAnalysisUrl + "/evaluationAnalysistLearningResult/"
            + ListGrid_evaluationAnalysis_class.getSelectedRecord().id + "/" + ListGrid_evaluationAnalysis_class.getSelectedRecord().classScoringMethod ,
            "GET", null, "callback: fill_learning_evaluation_result_resp(rpcResponse)"));
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
                    {name: "minScore", type: "hidden"}

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