<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>
    var behavioral_chartData1 = null;
    var behavioralEvaluationClassId = null;

    var BehavioralEvaluationChart1 = isc.FacetChart.create({
        height: "75%",
        titleAlign: "center",
        allowedChartTypes: [],
        axisStartValue: 0,
        axisEndValue: 100,
        showDataValues:true,
        brightenAllOnHover:true,
        hoverLabelPadding: -7,
        valueTitle: "میانگین نمره ارزیابی",
        facets: [
            {
                id: "student",
                title:  "فراگیران"
            },
            {
                id: "evaluator",
                title: "ارزیابی کننده"
            }
        ],
        data: behavioral_chartData1,
        valueProperty: "grade",
        stacked: false,
        chartType: "Column",
        title: "تحلیل ارزیابی رفتاری کلاس بر اساس فراگیران"
    });

    var behavioral_chartData2 = null;

    var BehavioralEvaluationChart2 = isc.FacetChart.create({
        height: "75%",
        verticalAlign: "top",
        titleAlign: "center",
        minLabelGap: 5,
        barMargin: "100",
        stacked: false,
        chartType: "Column",
        allowedChartTypes: [],
        axisStartValue: 0,
        axisEndValue: 100,
        showDataValues:true,
        brightenAllOnHover:true,
        hoverLabelPadding: -7,
        facets: [
            {
                id: "evaluator",
                title: "ارزیابی کننده"
            }
        ],
        data: behavioral_chartData2,
        valueProperty: "grade",
        valueTitle: "میانگین نمره ارزیابی",
        title: "تحلیل ارزیابی رفتاری کلاس براساس نوع ارزیابی کننده",
    });

    var RestDataSource_evaluation_behavioral_analysist = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "evaluatorName"},
            {name: "evaluatedName"},
            {name: "evaluatedId"},
            {name: "nationalCode"},
            {name: "evaluatorTypeTitle"},
            {name: "behavioralToOnlineStatus"},
            {name: "status",
                valueMap:{
                    "true": "ثبت شده",
                    "false" : "ثبت نشده"
                }},

        ],
        fetchDataURL: evaluationUrl + "/getBehavioralInClass/"+behavioralEvaluationClassId,
    });

    var ListGrid_evaluation_behavioral_analysist = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_evaluation_behavioral_analysist,
        canAddFormulaFields: false,
        autoFetchData: false,
        showFilterEditor: true,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        initialSort: [
            {property: "evaluatedId", direction: "descending", primarySort: true}
        ],
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "evaluatedId", title: "evaluatedId",  canEdit: false, hidden: true},
            {
                name: "evaluatedName",
                title: "ارزیابی شونده",
                align: "center",
                canFilter: false,
            },
            {
                name: "evaluatorName",
                title: "ارزیابی کننده",
                align: "center",
                canFilter: false,
            },{
                name: "nationalCode",
                title: "کد ملی ارزیابی کننده",
                align: "center",
                canFilter: false,
            },{
                name: "evaluatorTypeTitle",
                title: "نوع ارزیابی کننده",
                align: "center",
                canFilter: false,
            },{
                name: "status",
                title: "وضعیت ارزیابی",
                align: "center",canFilter: false,
            },

        ],
    });

    var IButton_Print_LearningBehavioral_Evaluation_Analysis = isc.IButton.create({
        align: "center",
        width: "300",
        height: "30",
        margin: 2,
        title: "چاپ گزارش تغییر رفتار",
        click: function () {
            let Window_Report_Evaluation_Analysis  = isc.Window.create({
                title: "گزارش تغییر رفتار",
                width: 500,
                items: [
                        isc.DynamicForm.create({
                            ID: "DF_Report_Evaluation_Analysis",
                            fields: [
                                {name: "suggestions", title: "پیشنهادات و انتقادات مطرح شده"},
                                {name: "opinion", title: "نظر کارشناس ارزیابی"}
                            ]
                        }),
                    isc.TrHLayoutButtons.create({
                        members: [
                        isc.IButton.create({
                        title: "گزارش گیری",
                        click: function () {
                            print_BehavioralEvaluationResult(behavioralEvaluationClassId, {}, "behavioralReport.jasper",
                                DF_Report_Evaluation_Analysis.getValue("suggestions"),
                                DF_Report_Evaluation_Analysis.getValue("opinion"));
                            Window_Report_Evaluation_Analysis.close();
                        }
                    })
                    ],
                })
                ]
            });
            Window_Report_Evaluation_Analysis.show();
        }
    });
    var IButton_show_ListGrid = isc.IButton.create({
        align: "center",
        width: "300",
        height: "30",
        margin: 2,
        title: "نمایش  تحلیل  رفتاری کلاس",
        click: function () {
            RestDataSource_evaluation_behavioral_analysist.fetchDataURL = evaluationUrl + "/getBehavioralInClass/"+behavioralEvaluationClassId;
            ListGrid_evaluation_behavioral_analysist.invalidateCache();
            ListGrid_evaluation_behavioral_analysist.fetchData();
        }
    });

    var BehavioralEvaluationChartLayout = isc.HLayout.create({
        defaultLayoutAlign: "top",
        width: "100%",
        height: "75%",
        membersMargin: 10,
        members: [BehavioralEvaluationChart1,BehavioralEvaluationChart2]
    });

    var Hlayout_BehavioralEvaluationResult = isc.VLayout.create({
        width: "100%",
        height: "100%",
        defaultLayoutAlign : "center",
        vAlign: "top",
        overflow: "scroll",
        members: [
            // BehavioralEvaluationChartLayout,
            ListGrid_evaluation_behavioral_analysist,
            IButton_Print_LearningBehavioral_Evaluation_Analysis,
            IButton_show_ListGrid,
        ]
    });

    function print_BehavioralEvaluationResult(ClassId, params, fileName,suggestions,opinion, type = "pdf") {
        var criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="evaluationAnalysis/printBehavioralReport/"/>" + type,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "fileName", type: "hidden"},
                    {name: "ClassId", type: "hidden"},
                    {name: "params", type: "hidden"},
                    {name: "suggestions", type: "hidden"},
                    {name: "opinion", type: "hidden"}
                ]
        });
        criteriaForm.setValue("ClassId", ClassId);
        criteriaForm.setValue("fileName", fileName);
        criteriaForm.setValue("params", JSON.stringify(params));
        criteriaForm.setValue("suggestions", suggestions);
        criteriaForm.setValue("opinion", opinion);
        criteriaForm.show();
        criteriaForm.submitForm();
    }

