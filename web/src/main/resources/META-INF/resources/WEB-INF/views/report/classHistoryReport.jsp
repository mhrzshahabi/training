<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>

// <script>

    //----------------------------------------------------Variables-----------------------------------------------------
    var isCriteriaCategoriesChanged_Comment_REFR = false;
    let reportCriteria_Comment_REFR = null;
    let excelData = [];
    let record = ListGrid_Class_JspClass.getSelectedRecord();

    //----------------------------------------------------Default Rest--------------------------------------------------

    //----------------------------------------------------Rest DataSource-----------------------------------------------
     RestDataSource_Comment_REFR = isc.TrDS.create({
         fields: [
             {name: "id", primaryKey: true},
             {name: "group"},
             {name: "classCancelReasonId"},
// {name: "lastModifiedDate",hidden:true},
// {name: "createdBy",hidden:true},
// {name: "createdDate",hidden:true,type:d},
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
        fetchDataURL:classAuditUrl+"/"+record.id ,

    });

    //----------------------------------------------------Criteria Form------------------------------------------------




    //----------------------------------- layOut -----------------------------------------------------------------------
    var ListGrid_Comment_REFR = isc.TrLG.create({
        height: "70%",
        dataPageSize: 15,
        filterOnKeypress: false,
        showFilterEditor: true,
        gridComponents: ["filterEditor", "header", "body"],
        dataSource: RestDataSource_Comment_REFR,
        autoFetchData: false,
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
            {name: "sendClassToOnlineBtn", canFilter: false, title: "ارسال به آزمون آنلاین", width: "145"},
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
        ]
    });
    var VLayout_Body_Comment_REFR = isc.TrVLayout.create({
        border: "2px solid blue",
        padding: 20,
        members: [
            ListGrid_Comment_REFR
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------
    //
     // </script>