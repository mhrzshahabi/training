<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>
    var behavioral_chartData1 = null;

    var BehavioralEvaluationChart1 = isc.FacetChart.create({
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
        valueTitle: "میانگین نمره ارزیابی",
        title: "تحلیل ارزیابی رفتاری کلاس بر اساس فراگیران",
    });

    var behavioral_chartData2 = null;

    var BehavioralEvaluationChart2 = isc.FacetChart.create({
        titleAlign: "center",
        minLabelGap: 5,
        barMargin: "100",
        stacked: false,
        chartType: "Column",
        allowedChartTypes: [],
        axisStartValue: 0,
        axisEndValue: 100,
        // brightenAllOnHover:true,
        // showValueOnHover:true,
        // hoverLabelPadding: -5,
        showDataValues:true,
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

    var BehavioralEvaluationChartLayout = isc.HLayout.create({
        defaultLayoutAlign: "center",
        width: "50%",
        height: "80%",
        membersMargin: 10,
        members: [BehavioralEvaluationChart1,BehavioralEvaluationChart2]
    });

    var Hlayout_BehavioralEvaluationResult = isc.HLayout.create({
        width: "100%",
        height: "100%",
        overflow: "scroll",
        members: [
            BehavioralEvaluationChartLayout
        ]
    });

