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

    var evalWait_JspEvaluationAnalysis;


    //----------------------------------------------------Rest Data Sources---------------------------------------------
    var RestDataSource_evaluationAnalysis_class = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "termId"},
            {name: "instituteId"},
            {name: "teacherId"},
            {name: "tclassStudentsCount"},
            {name: "tclassCode"},
            {name: "tclassStartDate"},
            {name: "tclassEndDate"},
            {name: "tclassYear"},
            {name: "courseCode"},
            {name: "courseCategory"},
            {name: "courseSubCategory"},
            {name: "courseTitleFa"},
            {name: "evaluation"},
            {name: "tclassDuration"},
            {name: "tclassOrganizerId"},
            {name: "tclassStatus"},
            {name: "tclassEndingStatus"},
            {name: "tclassPlanner"},
            {name: "termTitleFa"},
            {name: "instituteTitleFa"},
            {name: "classScoringMethod"},
            {name: "classPreCourseTest"},
            {name: "courseId"},
            {name: "teacherEvalStatus"},
            {name: "trainingEvalStatus"},
            {name: "tclassSupervisor"},
            {name: "teacherFullName"},
            {name: "tclassTeachingType"}
        ],
        fetchDataURL: viewClassDetailUrl + "/iscList",
        implicitCriteria: {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [{fieldName: "tclassStudentsCount", operator: "notEqual", value: 0},
                        {fieldName: "evaluation", operator: "notNull"}]
        },
    });

    //----------------------------------------------------List Grid-----------------------------------------------------

    ListGrid_evaluationAnalysis_class = isc.TrLG.create({
        width: "100%",
        height: "100%",
        <sec:authorize access="hasAuthority('EvaluationAnalysis_R')">
        dataSource: RestDataSource_evaluationAnalysis_class,
        </sec:authorize>
        canAddFormulaFields: false,
        autoFetchData: true,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        initialSort: [
            {property: "tclassStartDate", direction: "descending", primarySort: true}
        ],
        fields: [
            { name: "iconField", title: " ", width: 10 },
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {
                name: "tclassCode",
                title: "<spring:message code='class.code'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "courseCode",
                title: "<spring:message code='course.code'/>",
                align: "center",
                filterOperator: "iContains",
                autoFithWidth: true
            },
            {
                name: "courseTitleFa",
                title: "<spring:message code='course.title'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true,
                sortNormalizer: function (record) {
                    return record.course.titleFa;
                }
            },
            {
                name: "termTitleFa",
                title: "term",
                align: "center",
                filterOperator: "iContains",
                hidden: true
            },
            {
                name: "tclassStartDate",
                title: "<spring:message code='start.date'/>",
                align: "center",
                filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                },
                autoFithWidth: true
            },
            {
                name: "tclassEndDate",
                title: "<spring:message code='end.date'/>",
                align: "center",
                filterOperator: "iContains",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                },
                autoFithWidth: true
            },
            {
                name: "tclassStudentsCount",
                title: "<spring:message code='student.count'/>",
                filterOperator: "equals",
                autoFitWidth: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {
                name: "instituteTitleFa",
                title: "<spring:message code='presenter'/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "evaluation",
                title: "<spring:message code='evaluation.type'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true,
                filterOnKeypress: true,
                filterEditorProperties:{
                    pickListProperties: {
                        showFilterEditor: false
                    },
                    click:function () {
                        setTimeout(()=> {
                            $('.comboBoxItemPickerrtl').eq(4).remove();
                        $('.comboBoxItemPickerrtl').eq(5).remove();
                    },0);
                    }
                },
                valueMap: {
                    "o": "حین دوره",
                    "1": "واکنشی",
                    "2": "یادگیری",
                    "3": "رفتاری",
                    "4": "نتایج"
                },
            },
            {
                name: "tclassStatus", title: "<spring:message code='class.status'/>", align: "center",
                autoFithWidth: true,
                filterEditorProperties:{
                    pickListProperties: {
                        showFilterEditor: false
                    },
                    click:function () {
                        setTimeout(()=> {
                            $('.comboBoxItemPickerrtl').eq(5).remove();
                        $('.comboBoxItemPickerrtl').eq(4).remove();
                    },0);
                    }
                },
                valueMap: {
                    "1": "برنامه ریزی",
                    "2": "در حال اجرا",
                    "3": "پایان یافته",
                    "4": "لغو شده"
                }
            },
            {
                name: "tclassTeachingType",
                title: "روش آموزش",
                filterOperator: "equals",
                filterEditorProperties:{
                    pickListProperties: {
                        showFilterEditor: false,
                        autoFitWidthApproach: "both"
                    }
                  },
                valueMap: [
                    "حضوری",
                    "غیر حضوری",
                    "مجازی",
                    "عملی و کارگاهی",
                    "آموزش حین کار(OJT)"
                ]
            },
            {name: "classScoringMethod", hidden: true},
            {name: "classPreCourseTest", hidden: true},
            {name: "teacherId", hidden: true},
            {name: "teacherFullName", hidden:true}
        ],
        <sec:authorize access="hasAuthority('EvaluationAnalysis_R')">
        rowDoubleClick: function(record, recordNum, fieldNum) {
            Window_Evaluation_Analysis.title = "نتایج ارزیابی کلاس " + record.courseTitleFa;
            Window_Evaluation_Analysis.show();
            evalWait_JspEvaluationAnalysis = createDialog("wait");
            set_evaluation_analysis_tabset_status(record);
            Detail_Tab_Evaluation_Analysis.selectTab(0);
        },
        </sec:authorize>
        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);
            if (fieldName == "iconField") {
                if ((!ListGrid_evaluationAnalysis_class.getFieldByName("evaluation").hidden && record.evaluation))
                    return labelList(record.evaluation);
            } else {
                return null;
            }
        },
        // getCellCSSText: function (record, rowNum, colNum) {
        //     if ((!ListGrid_evaluationAnalysis_class.getFieldByName("evaluation").hidden && record.evaluation === "1"))
        //         return "background-color : #c9fecf";
        //
        //     if ((!ListGrid_evaluationAnalysis_class.getFieldByName("evaluation").hidden && record.evaluation === "2"))
        //         return "background-color : #d3f4fe";
        //
        //     if ((!ListGrid_evaluationAnalysis_class.getFieldByName("evaluation").hidden && record.evaluation === "3"))
        //         return "background-color : #fedee9";
        //
        //     if ((!ListGrid_evaluationAnalysis_class.getFieldByName("evaluation").hidden && record.evaluation === "4"))
        //         return "background-color : #fefad1";
        // },
    });

    //----------------------------------------------------ToolStrips & Page Layout--------------------------------------
    var Detail_Tab_Evaluation_Analysis = isc.TabSet.create({
        ID: "tabSetEvaluationAnalysis",
        tabBarPosition: "top",
        enabled: false,
        showTabScroller: true,
        tabs: [
            {
                ID: "TabPane_Execution_Evaluation_Analysis",
                enabled: false,
                title: "<spring:message code="evaluation.execution"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "evaluationAnalysis/evaluationAnalysis-executionTab/show-form"})
            }
            ,
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
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "evaluationAnalysis/evaluationAnalysis-learningTab"})
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
            ListGrid_evaluationAnalysist_learning.setData([]);
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
    var ToolStripButton_Export2EXcel_Evaluation_Analysis = isc.ToolStripButtonExcel.create({
        click: function () {
            let restUrl = viewClassDetailUrl + "/iscList";

            let implicitCriteria = JSON.parse(JSON.stringify(RestDataSource_evaluationAnalysis_class.implicitCriteria)) ;
            let criteria = ListGrid_evaluationAnalysis_class.getCriteria();

            if(criteria.criteria) {
                for (let i = 0; i < criteria.criteria.length; i++) {
                    implicitCriteria.criteria.push(criteria.criteria[i]);
                }
            }
            ExportToFile.downloadExcelRestUrl(null, ListGrid_evaluationAnalysis_class,  viewClassDetailUrl + "/iscList" , 0, null, '',"تحلیل ارزیابی", implicitCriteria, null);
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
                    <sec:authorize access="hasAuthority('EvaluationAnalysis_R')">
                    ToolStripButton_Refresh_Evaluation_Analysis,
                    </sec:authorize>
                    <sec:authorize access="hasAuthority('EvaluationAnalysis_P')">
                    ToolStripButton_Export2EXcel_Evaluation_Analysis
                    </sec:authorize>
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
        height: "45%",
        showResizeBar: true,
        members: [ListGrid_evaluationAnalysis_class]
    });

    var Hlayout_Tab_Evaluation_Analysis = isc.HLayout.create({
        width: "100%",
        height: "50%",
        members: [
            Detail_Tab_Evaluation_Analysis
        ]
    });

    var Window_Evaluation_Analysis = isc.Window.create({
        title: "پنجره ی نتایج ارزیابی",
        overflow: "auto",
        placement: "fillScreen",
        items: [
            Hlayout_Tab_Evaluation_Analysis
        ]
    });


    var VLayout_Body_Evaluation_Analysis = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [HLayout_Actions_Evaluation_Analysis,
            labelGuide(ListGrid_evaluationAnalysis_class.getFieldByName("evaluation").valueMap),
            Hlayout_Grid_Evaluation_Analysis]
    });

    //----------------------------------------------------Functions-----------------------------------------------------
    function set_evaluation_analysis_tabset_status(record) {

        let evaluationType = record.evaluation;

        Detail_Tab_Evaluation_Analysis.enable();
        if (evaluationType === "1" || evaluationType === "واکنشی") {
            fill_execution_evaluation_result(record);
            fill_reaction_evaluation_result(record);
            Detail_Tab_Evaluation_Analysis.enableTab(0);
            Detail_Tab_Evaluation_Analysis.enableTab(1);
            Detail_Tab_Evaluation_Analysis.disableTab(2);
            Detail_Tab_Evaluation_Analysis.disableTab(3);
            Detail_Tab_Evaluation_Analysis.disableTab(4);
        } else if (evaluationType === "2" || evaluationType === "یادگیری") {
            fill_execution_evaluation_result(record);
            fill_reaction_evaluation_result(record);
            evaluationAnalysist_learning(record);
            Detail_Tab_Evaluation_Analysis.enableTab(0);
            Detail_Tab_Evaluation_Analysis.enableTab(1);
            Detail_Tab_Evaluation_Analysis.enableTab(2);
            Detail_Tab_Evaluation_Analysis.disableTab(3);
            Detail_Tab_Evaluation_Analysis.disableTab(4);

        } else if (evaluationType === "3" || evaluationType === "رفتاری") {
            fill_execution_evaluation_result(record);
            fill_reaction_evaluation_result(record);
            evaluationAnalysist_learning(record);
            fill_behavioral_evaluation_result(record);
            Detail_Tab_Evaluation_Analysis.enableTab(0);
            Detail_Tab_Evaluation_Analysis.enableTab(1);
            Detail_Tab_Evaluation_Analysis.enableTab(2);
            Detail_Tab_Evaluation_Analysis.enableTab(3);
            Detail_Tab_Evaluation_Analysis.disableTab(4);

        } else if (evaluationType === "4" || evaluationType === "نتایج") {
            fill_execution_evaluation_result(record);
            fill_reaction_evaluation_result(record);
            evaluationAnalysist_learning(record);
            fill_behavioral_evaluation_result(record);
            Detail_Tab_Evaluation_Analysis.enableTab(0);
            Detail_Tab_Evaluation_Analysis.enableTab(1);
            Detail_Tab_Evaluation_Analysis.enableTab(2);
            Detail_Tab_Evaluation_Analysis.enableTab(3);
            Detail_Tab_Evaluation_Analysis.enableTab(4);

        };
    }

    function load_reaction_evluation_analysis_data(record) {
        let filledFormsInfo = "";
        let numberOfCompletedReactionEvaluationForms = record.numberOfFilledReactionEvaluationForms - record.numberOfInCompletedReactionEvaluationForms;
        filledFormsInfo += record.numberOfFilledReactionEvaluationForms + " - " +
            record.numberOfInCompletedReactionEvaluationForms+ "ناقص و " + numberOfCompletedReactionEvaluationForms + " کامل ";
        DynamicForm_Reaction_EvaluationAnalysis_Header.getField("studentCount").setValue(record.studentCount);
        DynamicForm_Reaction_EvaluationAnalysis_Header.getField("numberOfFilledReactionEvaluationForms").setValue(record.numberOfFilledReactionEvaluationForms);
        DynamicForm_Reaction_EvaluationAnalysis_Header.getField("numberOfInCompletedReactionEvaluationForms").setValue(record.numberOfInCompletedReactionEvaluationForms);
        DynamicForm_Reaction_EvaluationAnalysis_Header.getField("numberOfEmptyReactionEvaluationForms").setValue(record.numberOfEmptyReactionEvaluationForms);
        DynamicForm_Reaction_EvaluationAnalysis_Header.getField("percenetOfFilledReactionEvaluationForms").setValue(record.percenetOfFilledReactionEvaluationForms);
        DynamicForm_Reaction_EvaluationAnalysis_Header.getField("numberOfExportedReactionEvaluationForms").setValue(record.numberOfExportedReactionEvaluationForms);
        DynamicForm_Reaction_EvaluationAnalysis_Header.getField("filledFormsInfo").setValue(filledFormsInfo);

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
            {region: "نظر مدرس", grade: teacherGradeToClass}
        ];

        ReactionEvaluationChart.setData(reaction_chartData);
        evalWait_JspEvaluationAnalysis.close();
    }
    function load_execution_evaluation_analysis_data(record) {
        let filledFormsInfoExecution = "";
        execution_chartData=new Array();
        let numberOfCompletedExecutionEvaluationForms = record.numberOfFilledExecutionEvaluationForms - record.numberOfInCompletedExecutionEvaluationForms;
        filledFormsInfoExecution += record.numberOfFilledExecutionEvaluationForms + " - " +
            record.numberOfInCompletedExecutionEvaluationForms+ "ناقص و " + numberOfCompletedExecutionEvaluationForms + " کامل ";
        DynamicForm_Execution_EvaluationAnalysis_Header.getField("studentCount").setValue(record.studentCount);
        DynamicForm_Execution_EvaluationAnalysis_Header.getField("numberOfInCompletedExecutionEvaluationForms").setValue(record.numberOfInCompletedExecutionEvaluationForms);
        DynamicForm_Execution_EvaluationAnalysis_Header.getField("numberOfEmptyExecutionEvaluationForms").setValue(record.numberOfEmptyExecutionEvaluationForms);
        DynamicForm_Execution_EvaluationAnalysis_Header.getField("numberOfEmptyExecutionEvaluationForms").setCellStyle('evaluation-code-fail-label');
        DynamicForm_Execution_EvaluationAnalysis_Header.getField("percentOfFilledExecutionEvaluationForms").setValue(record.percentOfFilledExecutionEvaluationForms);
        DynamicForm_Execution_EvaluationAnalysis_Header.getField("numberOfFilledExecutionEvaluationForms").setValue(record.numberOfFilledExecutionEvaluationForms);
        DynamicForm_Execution_EvaluationAnalysis_Header.getField("numberOfExportedExecutionEvaluationForms").setValue(record.numberOfExportedExecutionEvaluationForms);
        DynamicForm_Execution_EvaluationAnalysis_Header.getField("filledFormsInfoExecution").setValue(filledFormsInfoExecution);


        DynamicForm_Execution_EvaluationAnalysis_Footer.getField("executionEvaluationStatus").setValue(record.executionEvaluationStatus);
        DynamicForm_Execution_EvaluationAnalysis_Footer.getField("FEEGrade").setValue(record.feegrade);
        DynamicForm_Execution_EvaluationAnalysis_Footer.getField("FEEPass").setValue(record.feepass);
        DynamicForm_Execution_EvaluationAnalysis_Footer.getField("z9").setValue(record.z9);
        DynamicForm_Execution_EvaluationAnalysis_Footer.getField("differ").setValue(record.differ);



        studentsGradeToTeacher = record.studentsGradeToTeacher;

        if (DynamicForm_Execution_EvaluationAnalysis_Footer.getField("FEEGrade").getValue() >= record.z9) {
            DynamicForm_Execution_EvaluationAnalysis_Footer.getItem('FEEGrade').setCellStyle('evaluation-code-pass-label');
        }
        else if (DynamicForm_Execution_EvaluationAnalysis_Footer.getField("FEEGrade").getValue() < record.z9) {
            DynamicForm_Execution_EvaluationAnalysis_Footer.getItem('FEEGrade').setCellStyle('evaluation-code-fail-label');
        }






            for(let i=0;i<record.questionnaireQuestions.size();i++){
           execution_chartData.add( {question: record.questionnaireQuestions.get(i).questionOrder,
               grade: record.questionnaireQuestions.get(i).aveGradeToQuestion,
               questionTitle: record.questionnaireQuestions.get(i).questionTitle});

          }


        ExecutionEvaluationChart.setData(execution_chartData);
        evalWait_JspEvaluationAnalysis.close();
    }

    function load_behavioral_evluation_analysis_data(record) {
        behavioral_chartData1 = new Array();
        for (let i=0;i<record.studentGrade.size();i++) {
            behavioral_chartData1.add({student: record.classStudentsName.get(i), evaluator :  "فراگیر",  grade: record.studentGrade.get(i) });
            behavioral_chartData1.add({student: record.classStudentsName.get(i), evaluator : "بالادست", grade: record.supervisorGrade.get(i)});
            behavioral_chartData1.add({student: record.classStudentsName.get(i), evaluator : "همکاران", grade: record.coWorkersGrade.get(i)});
            behavioral_chartData1.add({student: record.classStudentsName.get(i), evaluator : "آموزش", grade: record.trainingGrade.get(i)});
        }
        BehavioralEvaluationChart1.setData(behavioral_chartData1);

        behavioral_chartData2 = new Array();
            behavioral_chartData2.add({evaluator :  "فراگیر",  grade: record.studentGradeMean });
            behavioral_chartData2.add({evaluator : "بالادست", grade: record.supervisorGradeMean});
            behavioral_chartData2.add({evaluator : "همکار", grade: record.coWorkersGradeMean});
            behavioral_chartData2.add({evaluator : "مسئول آموزش", grade: record.trainingGradeMean});
        BehavioralEvaluationChart2.setData(behavioral_chartData2);
        evalWait_JspEvaluationAnalysis.close();
    }

    function fill_reaction_evaluation_result(record) {
        DynamicForm_Reaction_EvaluationAnalysis_Header.show();
        DynamicForm_Reaction_EvaluationAnalysis_Footer.show();
        IButton_Print_ReactionEvaluation_Evaluation_Analysis.show();
        chartSelector.show();
        ReactionEvaluationChart.show();
        classRecord_evaluationAnalysist_reaction = record;
        isc.RPCManager.sendRequest(TrDSRequest(classUrl + "reactionEvaluationResult/" + record.id , "GET", null,
            "callback: fill_reaction_evaluation_result_resp(rpcResponse)"));
    }

    function fill_execution_evaluation_result(record) {
        DynamicForm_Execution_EvaluationAnalysis_Header.show();
        DynamicForm_Execution_EvaluationAnalysis_Footer.show();
        IButton_Print_ExecutionEvaluation_Evaluation_Analysis.show();
        ExecutionEvaluationChart.show();
        classRecord_evaluationAnalysist_execution = record;
        isc.RPCManager.sendRequest(TrDSRequest(classUrl + "executionEvaluationResult/" + record.id , "GET", null,
            "callback: fill_execution_evaluation_result_resp(rpcResponse)"));
    }


    function fill_reaction_evaluation_result_resp(resp) {
        load_reaction_evluation_analysis_data(JSON.parse(resp.data));
    }
    function fill_execution_evaluation_result_resp(resp) {
        load_execution_evaluation_analysis_data(JSON.parse(resp.data));
    }

    function fill_behavioral_evaluation_result(record) {
        behavioralEvaluationClassId = record.id;
        RestDataSource_evaluation_behavioral_analysist.fetchDataURL = evaluationUrl + "/getBehavioralInClass/"+behavioralEvaluationClassId;
        ListGrid_evaluation_behavioral_analysist.invalidateCache();
        ListGrid_evaluation_behavioral_analysist.fetchData();
        isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/getBehavioralEvaluationResult/" + record.id , "GET", null,
            "callback: fill_behavioral_evaluation_result_resp(rpcResponse)"));
    }

    function fill_behavioral_evaluation_result_resp(resp) {
        load_behavioral_evluation_analysis_data(JSON.parse(resp.data));
    }

    Window_Evaluation_Analysis.hide();

    // </script>


