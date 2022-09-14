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
            {name: "evaluatedPersonnelNo", title: "شماره پرسنلی", filterOperator: "iContains"},
            {name: "evaluatedNationalCode", title: "کد ملی", filterOperator: "iContains"},
            {name: "evaluatedFullName", title: "نام", filterOperator: "iContains"},
            {name: "evaluatedMobile", title: "موبایل", filterOperator: "iContains"},
            {name: "studentGrade", title: "نمره ارزیابی فراگیر به خودش", filterOperator: "iContains"},
            {name: "supervisorGrade", title: "نمره ارزیابی سرپرست به فراگیر", filterOperator: "iContains"},
            {name: "servitorGrade", title: "نمره ارزیابی زیردست به فراگیر", filterOperator: "iContains"},
            {name: "coWorkerGrade", title: "نمره ارزیابی همکار به فراگیر", filterOperator: "iContains"},
            {name: "trainingGrade", title: "نمره ارزیابی مسئول آموزش به فراگیر", filterOperator: "iContains"}
        ],
        fetchDataURL: evaluationUrl + "/getBehavioralInClass/" + behavioralEvaluationClassId,
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
            {property: "evaluatedPersonnelNo", direction: "descending", primarySort: true}
        ],
        fields: [
            {name: "evaluatedPersonnelNo"},
            {name: "evaluatedNationalCode"},
            {name: "evaluatedFullName"},
            {name: "evaluatedMobile"},
            {name: "studentGrade"},
            {name: "supervisorGrade"},
            {name: "servitorGrade"},
            {name: "coWorkerGrade"},
            {name: "trainingGrade"},
            {
                name: "btnResults",
                canFilter: false,
                title: "گزارش تغییر رفتار ",
                width: "130"
            },

        ],
        createRecordComponent: function (record, colNum) {
            let fieldName = this.getFieldName(colNum);
            if (fieldName === "btnResults") {
                return isc.IButton.create({
                    layoutAlign: "center",
                    // disabled: !record.onlineFinalExamStatus,
                    title: "چاپ گزارش",
                    margin: 3,
                    click: function () {
                        printBehaviorChangeReport(record, "record");
                    }
                });
            } else {
                return null;
            }
        },
    });

    var IButton_Print_LearningBehavioral_Evaluation_Analysis = isc.IButton.create({
        align: "center",
        width: "300",
        height: "30",
        margin: 2,
        title: "چاپ گزارش تغییر رفتار",
        click: function () {
            let allRecords = ListGrid_evaluation_behavioral_analysist.getData();
            printBehaviorChangeReport(allRecords, "all");
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

    function printBehaviorChangeReport(record, reportType) {
        let Window_Report_Evaluation_Analysis = isc.Window.create({
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
                                let params = {};

                                if (reportType === "record") {
                                    // single row selected
                                    params.evaluatedPersonnelNo = record.evaluatedPersonnelNo;
                                    params.evaluatedNationalCode = record.evaluatedNationalCode;
                                    params.evaluatedFullName = record.evaluatedFullName;
                                    params.evaluatedMobile = record.evaluatedMobile;
                                    params.studentGrade = record.studentGrade;
                                    params.supervisorGrade = record.supervisorGrade;
                                    params.servitorGrade = record.servitorGrade;
                                    params.coWorkerGrade = record.coWorkerGrade;
                                    params.trainingGrade = record.trainingGrade;
                                }

                                let fileName = null;
                                let actionUrl = null;

                                if (reportType === "record") {
                                    fileName = "behavioralEvaluationAnalysisReport.jasper";
                                    actionUrl = "<spring:url value="evaluationAnalysis/printBehavioralChangeReport/"/>";
                                } else if (reportType === "all") {
                                    fileName = "behavioralReport.jasper";
                                    actionUrl = "<spring:url value="evaluationAnalysis/printBehavioralReport/"/>" + "pdf";
                                }

                                if (fileName !== null && actionUrl !== null) {
                                    print_BehavioralEvaluationResult(
                                        actionUrl,
                                        behavioralEvaluationClassId,
                                        params,
                                        fileName,
                                        DF_Report_Evaluation_Analysis.getValue("suggestions"),
                                        DF_Report_Evaluation_Analysis.getValue("opinion")
                                    );
                                }

                                Window_Report_Evaluation_Analysis.close();
                            }
                        })
                    ],
                })
            ]
        });
        Window_Report_Evaluation_Analysis.show();
    }

    function print_BehavioralEvaluationResult(actionUrl, ClassId, params, fileName,suggestions,opinion) {
        let criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: actionUrl,
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


    // </script>