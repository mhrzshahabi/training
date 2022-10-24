<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

//<script>

    function addDays(days) {
        let result = new Date();
        result.setDate(result.getDate() + days);
        result.toLocaleDateString('fa-IR');
        let finalResult= new Intl.DateTimeFormat('fa-IR',{
        year:'numeric',
        month:'2-digit',
        day:'2-digit',
        }).format(result);

       finalResult=finalResult.toEnglishDigit();
        return finalResult ;
    }

    let nextTwoDays = addDays(2);

    var RestDataSource_ClassesWillBeHeldInNextTwoDaysReport = isc.TrDS.create({
        autoFitWidth: true,
        fields: [
            {name: "id",},
            {name: "group"},
            {name: "hduration",},
            {name: "classCancelReasonId"},
            {name: "titleClass",},
            {name: "startDate",},
            {name: "endDate",},
            {name: "studentCount", canFilter: false, canSort: false,},
            {name: "code",},
            {name: "term.titleFa",},
            {name: "courseId",},
            {name: "course.titleFa",},
            {name: "course.id",},
            {name: "teacherId",},
            {
                name: "teacher",
                autoFitWidth: true
            },
            {
                name: "teacher.personality.lastNameFa",
                autoFitWidth: true
            },
            {name: "reason",},
            {name: "classStatus",},
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
        fetchDataURL: classUrl + "add-permission/spec-list"
    });

    var ListGrid_ClassesWillBeHeldInNextTwoDaysReport = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_ClassesWillBeHeldInNextTwoDaysReport,
        autoFetchData: false,
        showFilterEditor: true,
        filterOnKeypress: false,
        sortDirection: "descending",
        initialSort: [
            {property: "id", direction: "descending"}
        ],
        dataArrived: function () {

            let filteredDataSource = ListGrid_ClassesWillBeHeldInNextTwoDaysReport.data.localData.reduce((filteredList, one) => {
                if (one.startDate.contains(nextTwoDays)) {
                    filteredList.push(one);
                }
                return filteredList
            }, []);

            ListGrid_ClassesWillBeHeldInNextTwoDaysReport.setData(filteredDataSource);
            ListGrid_ClassesWillBeHeldInNextTwoDaysReport.data.localData = filteredDataSource;
        },
        fields: [
            {
                name: "id",
                hidden: true,
                primaryKey: true,
                canEdit: false,
                align: "center"
            },
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
            {
                name: "workflowEndingStatusCode",
                title: "workflowCode",
                align: "center",
                filterOperator: "iContains",
                hidden: true
            },
            {name: "hasWarning", title: " ", width: 40, type: "image", imageURLPrefix: "", imageURLSuffix: ".gif"},
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

    });

    let IButton_ClassesWillBeHeldInNextTwoDaysReport = isc.IButtonSave.create({
        top: 260,
        title: "چاپ گزارش",
        width: "150",
        click: function () {

            ListGrid_ClassesWillBeHeldInNextTwoDaysReport.invalidateCache();
            ListGrid_ClassesWillBeHeldInNextTwoDaysReport.fetchData();
        }

    });

    let IButton_Clear_ClassesWillBeHeldInNextTwoDaysReport = isc.IButtonSave.create({
        top: 260,
        title: "پاک کردن",
        width: "150",
        click: function () {

            ListGrid_ClassesWillBeHeldInNextTwoDaysReport.clearFilterValues();
            ListGrid_ClassesWillBeHeldInNextTwoDaysReport.setData([]);
        }
    });

    let ToolStripButton_Excel_ClassesWillBeHeldInNextTwoDaysReport = isc.ToolStripButtonExcel.create({

        click: function () {
            makeExcelOutput();
        }
    });

    let ToolStripButton_Refresh_ClassesWillBeHeldInNextTwoDaysReport = isc.ToolStripButtonRefresh.create({
        click: function () {

                ListGrid_ClassesWillBeHeldInNextTwoDaysReport.clearFilterValues();
                ListGrid_ClassesWillBeHeldInNextTwoDaysReport.setData([]);
        }
    });

    let ToolStrip_Actions_ClassesWillBeHeldInNextTwoDaysReport = isc.ToolStrip.create({
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

//--------------------------------------------functions ------------------------------

    function makeExcelOutput() {
        if (ListGrid_ClassesWillBeHeldInNextTwoDaysReport.getOriginalData().localData === undefined)
        {
             createDialog("info", "ابتدا چاپ گزارش را انتخاب کنید");
        }else{
             ExportToFile.downloadExcelRestUrl(null, ListGrid_ClassesWillBeHeldInNextTwoDaysReport,null, 0, null, '',"گزارش کلاسهایی که دو روز آینده برگزار می شوند" , null, null,0,true);
        }
    }

    //</script>