<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

let RestDataSource_ClassesWillBeHeldInNextTwoDaysReport = isc.TrDS.create({
fields: [
{name: "id", primaryKey: true},
{name: "group"},
{name: "hduration",canFilter: false},
{name: "classCancelReasonId"},
{name: "titleClass", autoFitWidth: true},
{name: "startDate", autoFitWidth: true},
{name: "endDate", autoFitWidth: true},
{name: "studentCount", canFilter: false, canSort: false, autoFitWidth: true},
{name: "code", autoFitWidth: true},
{name: "term.titleFa", autoFitWidth: true},
{name: "courseId", autoFitWidth: true},
{name: "course.titleFa", autoFitWidth: true},
{name: "course.id", autoFitWidth: true},
{name: "teacherId", autoFitWidth: true},
{
name: "teacher",
autoFitWidth: true
},
{
name: "teacher.personality.lastNameFa",
autoFitWidth: true
},
{name: "reason" , autoFitWidth: true},
{name: "classStatus" , autoFitWidth: true},
{name: "topology"},
{name: "targetPopulationTypeId"},
{name: "holdingClassTypeId"},
{name: "teachingMethodId"},
{name: "trainingPlaceIds"},
{name: "instituteId"},
{name: "workflowEndingStatusCode"},
{name: "workflowEndingStatus"},
{name: "preCourseTest", type: "boolean"},
{name: "course.code"},
{name: "course.theoryDuration"},
{name: "scoringMethod"},
{name: "evaluationStatusReactionTraining"},
{name: "supervisor"},
{name: "plannerFullName"},
{name: "supervisorFullName"},
{name: "organizerName"},
{name: "evaluation"},
{name: "startEvaluation"},
{name: "behavioralLevel"},
{name: "studentCost"},
{name: "studentCostCurrency"},
{name: "planner"},
{name: "organizer"},
{name: "hasTest", type: "boolean"},
{name: "classToOnlineStatus", type: "boolean"}
],
autoFetchData: false,
fetchDataURL : classUrl + "add-permission/spec-list"
});

let ListGrid_ClassesWillBeHeldInNextTwoDaysReport = isc.TrLG.create({
width: "100%",
height: "100%",
<%--<sec:authorize access="hasAuthority('Tclass_R')">--%>
    dataSource: RestDataSource_ClassesWillBeHeldInNextTwoDaysReport,
<%--</sec:authorize>--%>
// contextMenu: Menu_ListGrid_ClassesWillBeHeldInNextTwoDaysReport,
dataPageSize: 15,
allowAdvancedCriteria: true,
allowFilterExpressions: true,
<%--<sec:authorize access="hasAuthority('Tclass_U')">--%>
<%--    showRecordComponents: true,--%>
<%--    showRecordComponentsByCell: true,--%>
<%--</sec:authorize>--%>
showRollOver:false,
selectionType: "single",
autoFetchData: false,
initialSort: [
{property: "startDate", direction: "descending", primarySort: true}
],
// selectionUpdated: function (record) {
//
// ToolStrip_SendForms_JspClass.getField("sendButtonTraining").showIcon("ok");
// ToolStrip_SendForms_JspClass.getField("registerButtonTraining").showIcon("ok");
// if(record) {
// if (record.evaluationStatusReactionTraining === "0" || record.evaluationStatusReactionTraining === 0 || record.evaluationStatusReactionTraining == null) {
// ToolStrip_SendForms_JspClass.getField("sendButtonTraining").hideIcon("ok");
// ToolStrip_SendForms_JspClass.getField("registerButtonTraining").hideIcon("ok");
// } else {
// if (record.evaluationStatusReactionTraining === "2" || record.evaluationStatusReactionTraining === 2 ||
// record.evaluationStatusReactionTraining === "3" || record.evaluationStatusReactionTraining === 3) {
// ToolStrip_SendForms_JspClass.getField("sendButtonTraining").showIcon("ok");
// ToolStrip_SendForms_JspClass.getField("registerButtonTraining").showIcon("ok");
// }
// else {
// ToolStrip_SendForms_JspClass.getField("sendButtonTraining").showIcon("ok");
// ToolStrip_SendForms_JspClass.getField("registerButtonTraining").hideIcon("ok");
// }
// }
// }
// refreshSelectedTab_class(tabSetClass.getSelectedTab());
// },
<%--<sec:authorize access="hasAuthority('Tclass_U')">--%>
<%--    doubleClick: function () {--%>
<%--    ListGrid_class_edit();--%>
<%--    },--%>
<%--</sec:authorize>--%>
fields: [
{name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
{
name: "code",
title: "<spring:message code='class.code'/>",
align: "center",
filterOperator: "iContains",
autoFitWidth: true
},
{
name: "titleClass",
title: "titleClass",
align: "center",
filterOperator: "iContains",
hidden: true
},
{
name: "course.titleFa",
title: "<spring:message code='course.title'/>",
align: "center",
filterOperator: "iContains",
sortNormalizer: function (record) {
return record.course.titleFa;
}
},
{
name: "term.titleFa",
title: "term",
align: "center",
filterOperator: "iContains",
hidden: true
},
{
name: "startDate",
title: "<spring:message code='start.date'/>",
align: "center",
filterOperator: "iContains",
filterEditorProperties: {
keyPressFilter: "[0-9/]"
},
},
{
name: "endDate",
title: "<spring:message code='end.date'/>",
align: "center",
filterOperator: "iContains",
filterEditorProperties: {
keyPressFilter: "[0-9/]"
},
},
{
name: "studentCount",
title: "<spring:message code='student.count'/>",
filterOperator: "iContains",
},
{
name: "hduration",
title: "<spring:message code='duration'/>",
align: "center",
width: 40,
filterOperator: "iContains",

},
{
name: "group",
title: "<spring:message code='group'/>",
align: "center",
width: 40,
filterOperator: "equals",
},
{
name: "teacher",
title: "<spring:message code='teacher'/>",
displayField: "teacher.personality.lastNameFa",
type: "TextItem",
sortNormalizer(record) {
return record.teacher.personality.lastNameFa;
},
align: "center",
filterOperator: "iContains",
},
{
name: "planner.lastName",
title: "<spring:message code="planner"/>",
canSort: false,
autoFitWidth: true,
align: "center",
filterOperator: "iContains",
},
{
name: "supervisor.lastName",
title: "<spring:message code="supervisor"/>",
canSort: false,
align: "center",
autoFitWidth: true,
filterOperator: "iContains",
},
{
name: "organizer.titleFa",
title: "<spring:message code="executer"/>",
canSort: false,
autoFitWidth: true,
align: "center",
},
{
name: "reason", title: "<spring:message code='training.request'/>", align: "center",
valueMap: {
"1": "نیازسنجی",
"2": "درخواست واحد",
"3": "نیاز موردی",
},
filterEditorProperties: {
pickListProperties: {
showFilterEditor: false
},
},
filterOnKeypress: true,
},
{
name: "classStatus", title: "<spring:message code='class.status'/>", align: "center",
valueMap: {
"1": "برنامه ریزی",
"2": "در حال اجرا",
"3": "پایان یافته",
"4": "لغو شده",
"5": "اختتام",
},
filterEditorProperties: {
pickListProperties: {
showFilterEditor: false
},
},
filterOnKeypress: true,
width: 100,
showHover: true,
hoverWidth: 150,
hoverHTML(record) {
return "<b>علت لغو: </b>" + record.classCancelReason.title;
}
},
{
name: "topology", title: "<spring:message code='place.shape'/>", align: "center", valueMap: {
"1": "U شکل",
"2": "عادی",
"3": "مدور",
"4": "سالن"
},
filterEditorProperties: {
pickListProperties: {
showFilterEditor: false
},
},
filterOnKeypress: true,
hidden: true
},
{name: "sendClassToOnlineBtn", canFilter: false, title: "ارسال به آزمون آنلاین", width: "145",hidden: true},
{name: "targetPopulationTypeId", hidden: true},
{name: "holdingClassTypeId", hidden: true},
{name: "teachingMethodId", hidden: true},
{name: "createdBy", hidden: true},
{name: "createdDate", hidden: true},
{
name: "workflowEndingStatusCode",
title: "workflowCode",
align: "center",
filterOperator: "iContains",
hidden: true
},
{
name: "workflowEndingStatus",
title: "<spring:message code="ending.class.status"/>",
align: "center",
filterOperator: "iContains",
width: 40            },
{name: "hasWarning", title: " ", width: 40, type: "image", imageURLPrefix: "", imageURLSuffix: ".gif"},
{
name: "isSentMessage",
title: "ارسال پيام قبل از شروع کلاس",
width: 40,
// hidden: true,
type: "image",
imageURLPrefix: "",
imageURLSuffix: ".gif",
canEdit: false,
canSort: false,
canFilter: false
},
{name: "course.code", title: "", hidden: true},
{name: "course.theoryDuration", title: "", hidden: true},
{name: "scoringMethod", hidden: true},
{name: "evaluationStatusReactionTraining", hidden: true},
{name: "supervisor", hidden: true},
{name: "teacherId", hidden: true},
{name: "evaluation", hidden: true},
{name: "startEvaluation", hidden: true},
{name: "behavioralLevel", hidden: true},
{name: "studentCost", hidden: true},
{name: "studentCostCurrency", hidden: true},
{name: "hasTest", hidden: true},
{name: "classToOnlineStatus", hidden: true}
],
// getCellCSSText: function (record, rowNum, colNum) {
// let style;
// if (this.isSelected(record)) {
// style =  "background-color:" + "#fe9d2a;";
// } else if (record.workflowEndingStatusCode === 2) {
// style =  "background-color:" + "#bef5b8;";
// } else {
// if (record.classStatus === "1")
// style =  "background-color:" + "#ffffff;";
// else if (record.classStatus === "2")
// style =  "background-color:" + "#fff9c4;";
// else if (record.classStatus === "3")
// style =  "background-color:" + "#cdedf5;";
// else if (record.classStatus === "4")
// style =  "color:" + "#d6d6d7;";
// }
// if (this.getFieldName(colNum) == "teacher") {
// style +=  "color: #0066cc;text-decoration: underline !important;cursor: pointer !important;}"
// }
// return style;
// },
// cellClick: function (record, rowNum, colNum) {
// if (this.getFieldName(colNum) == "teacher") {
// ListGrid_teacher_edit(record.teacherId,"class")
// }
// },
// dataArrived: function () {
// wait.close();
// selectWorkflowRecord();
// },
// createRecordComponent: function (record, colNum) {
// var fieldName = this.getFieldName(colNum);
// if (fieldName == "sendClassToOnlineBtn") {
// let sendBtn = isc.IButton.create({
// layoutAlign: "center",
// disabled: (record.classToOnlineStatus == true) || (record.classStatus === "1"),
// title: "ارسال به آزمون آنلاین",
// width: "145",
// margin: 3,
// click: function () {
// sendClassToOnline(record.id)
// }
// });
// return sendBtn;
// } else {
// return null;
// }
// }
});

let ToolStrip_Excel_ClassesWillBeHeldInNextTwoDaysReport = isc.ToolStripButtonExcel.create({
    click: function () {
        let criteria = ListGrid_ClassesWillBeHeldInNextTwoDaysReport.getCriteria();
        if (typeof (criteria._constructor) != 'undefined') {
            if (criteria.criteria == null) {
                criteria.criteria = [];
            }
            if (ListGrid_ClassesWillBeHeldInNextTwoDaysReport.implicitCriteria)
                criteria.criteria.add({...ListGrid_ClassesWillBeHeldInNextTwoDaysReport.implicitCriteria.criteria.filter(p => p.fieldName == "term.id")[0]});
        } else {
            if (ListGrid_ClassesWillBeHeldInNextTwoDaysReport.implicitCriteria)
                criteria = {
                    _constructor: "AdvancedCriteria",
                    criteria:
                        [
                            {...ListGrid_ClassesWillBeHeldInNextTwoDaysReport.implicitCriteria.criteria.filter(p => p.fieldName == "term.id")[0]}
                        ],
                    operator: "and"
                };
        }

        let   newCriteria = {
            _constructor: "AdvancedCriteria",
            criteria:
                [],
            operator: "and"
        };
        if (criteria.criteria!==undefined){
            for (let i = 0; i < criteria.criteria.length; i++)
            {
                if (criteria.criteria[i].fieldName!==undefined)
                    newCriteria.criteria.add(criteria.criteria[i])
            }
        }
        ExportToFile.downloadExcelRestUrl(null, ListGrid_ClassesWillBeHeldInNextTwoDaysReport, classUrl + "add-permission/spec-list", 0, null, '', "اجرا - کلاس", newCriteria, null);
    }
});

IButton_ClassesWillBeHeldInNextTwoDaysReport = isc.IButtonSave.create({
    top: 260,
    title: "چاپ گزارش",
    width: "150",
    click: function () {

        ListGrid_ClassesWillBeHeldInNextTwoDaysReport.invalidateCache();
        ListGrid_ClassesWillBeHeldInNextTwoDaysReport.fetchData();
        }

});

IButton_Clear_ClassesWillBeHeldInNextTwoDaysReport = isc.IButtonSave.create({
    top: 260,
    title: "پاک کردن",
    width:"150",
    click: function () {

        ListGrid_ClassesWillBeHeldInNextTwoDaysReport.clearFilterValues();
        ListGrid_ClassesWillBeHeldInNextTwoDaysReport.setData([]);
    }
});

ToolStripButton_Excel_ClassesWillBeHeldInNextTwoDaysReport = isc.ToolStripButtonExcel.create({

    click: function () {
        makeExcelOutput();
    }
});

ToolStripButton_Refresh_ClassesWillBeHeldInNextTwoDaysReport = isc.ToolStripButtonRefresh.create({
    click: function () {
        ListGrid_ClassesWillBeHeldInNextTwoDaysReport.invalidateCache();
    }
});

ToolStrip_Actions_ClassesWillBeHeldInNextTwoDaysReport = isc.ToolStrip.create({
    width: "100%",
    membersMargin: 5,
    members:
        [
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh_ClassesWillBeHeldInNextTwoDaysReport,
                    ToolStripButton_Excel_ClassesWillBeHeldInNextTwoDaysReport
                ]
            })
        ]
});

let HLayOut_Confirm_ClassesWillBeHeldInNextTwoDaysReport = isc.TrHLayoutButtons.create({
    layoutMargin: 5,
    showEdges: false,
    edgeImage: "",
    width: "100%",
    height: "10%",
    alignLayout: "center",
    padding: 10,
    members: [
        IButton_ClassesWillBeHeldInNextTwoDaysReport,
        IButton_Clear_ClassesWillBeHeldInNextTwoDaysReport
    ]
});

let VLayout_Body_ClassesWillBeHeldInNextTwoDaysReport = isc.VLayout.create({
    border: "2px solid blue",
    width: "100%",
    height: "100%",
    members: [
        ToolStrip_Actions_ClassesWillBeHeldInNextTwoDaysReport,
        HLayOut_Confirm_ClassesWillBeHeldInNextTwoDaysReport,
        ListGrid_ClassesWillBeHeldInNextTwoDaysReport
    ]

});

//</script>