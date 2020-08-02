<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>
    var behavioral_chartData = null;

    var BehavioralEvaluationChart = isc.FacetChart.create({
        titleAlign: "center",
        minLabelGap: 5,
        width: "80%",
        height: "90%",
        barMargin: "100",
        stacked: false,
        allowedChartTypes: [],
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
        data: behavioral_chartData,
        valueProperty: "grade",
        valueTitle: "میانگین نمره ارزیابی",
        title: "<spring:message code='class.behavioral.evaluation.analysis'/>",
    });

    var BehavioralEvaluationChartLayout = isc.VLayout.create({
        defaultLayoutAlign: "center",
        width: "50%",
        height: "500",
        members: [BehavioralEvaluationChart]
    });

    var Hlayout_BehavioralEvaluationResult = isc.HLayout.create({
        width: "100%",
        height: "100%",
        overflow: "scroll",
        members: [
            BehavioralEvaluationChartLayout
        ]
    });