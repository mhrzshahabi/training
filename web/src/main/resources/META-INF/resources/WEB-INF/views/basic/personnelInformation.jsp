<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>
var url = '';
    // <<-------------------------------------- Create - ToolStripButton --------------------------------------
    {
//*****toolStrip*****
        var ToolStripButton_Refresh_PI = isc.ToolStripButtonRefresh.create({
            title: "<spring:message code="refresh"/>",
            click: function () {
                PersonnelInfoListGrid_PersonnelList.invalidateCache();
                set_PersonnelInfo_Details();
            }
        });

        var ToolStrip_Personnel_Info = isc.ToolStrip.create({
            width: "100%",
            membersMargin: 5,
            members: [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_PI
                    ]
                })
            ]
        });


        var ToolStrip_Personnel_Info_Training_Action = isc.ToolStrip.create({
            width: "100%",
            membersMargin: 5,
            members: [
                isc.ToolStripButtonExcel.create({
                    click: function () {
                        ExportToFile.DownloadExcelFormClient(ListGrid_PersonnelTraining, PersonnelInfoListGrid_PersonnelList, '', "اطلاعات پرسنل - آموزش ها");
                    }
                })/*,
isc.ToolStripButtonExcel.create({
click: function () {
let nationalCode = PersonnelInfoListGrid_PersonnelList.getSelectedRecord().nationalCode;
let size = ListGrid_PersonnelTraining.data.size();

isc.Window.create({
ID: "exportExcelWindow",
title: "خروجی اکسل",
autoSize: true,
width: 400,
items: [
isc.DynamicForm.create({
ID: "exportExcelForm",
numCols: 1,
padding: 10,
fields: [
{
name: "maxRow",
width: "100%",
titleOrientation: "top",
title: "لطفا حداکثر تعداد سطرهای موجود در اکسل را وارد نمایید:",
value: size,
suppressBrowserClearIcon: true,
icons: [{
name: "clear",
src: "[SKIN]actions/close.png",
width: 10,
height: 10,
inline: true,
prompt: "پاک کردن",
click: function (form, item, icon) {
item.clearValue();
item.focusInItem();
}
}],
iconWidth: 16,
iconHeight: 16
}
]
}),
isc.TrHLayoutButtons.create({
members: [
isc.IButton.create({
title: "تایید",
click: function () {
if (trTrim(exportExcelForm.getValue("maxRow")) != "") {
ExportToFile.DownloadExcelFormServer(ListGrid_PersonnelTraining, 'tclass-personnel-training', exportExcelForm.getValue("maxRow"), PersonnelInfoListGrid_PersonnelList, '', "اطلاعات پرسنل - آموزش ها", JSON.stringify({ "value": nationalCode }));
}
}
}),
isc.IButton.create({
title: "لغو",
click: function () {
exportExcelWindow.close();
}
}),
]
})
]
});
exportExcelWindow.show();
}
})
*/
            ]
        });

    }
    // ---------------------------------------- Create - ToolStripButton ------------------------------------>>

    // <<-------------------------------------- Create - RestDataSource & ListGrid ----------------------------
    {
        var PersonnelInfoDS_PersonnelList = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {
                    name: "firstName",
                    title: "<spring:message code="firstName"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "lastName",
                    title: "<spring:message code="lastName"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "nationalCode",
                    title: "<spring:message code="national.code"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "companyName",
                    title: "<spring:message code="company.name"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "personnelNo",
                    title: "<spring:message code="personnel.no"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "personnelNo2",
                    title: "<spring:message code="personnel.no.6.digits"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "postTitle",
                    title: "<spring:message code="post"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "postCode",
                    title: "<spring:message code="post.code"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "ccpArea",
                    title: "<spring:message code="reward.cost.center.area"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "ccpAssistant",
                    title: "<spring:message code="reward.cost.center.assistant"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "ccpAffairs",
                    title: "<spring:message code="reward.cost.center.affairs"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "ccpSection",
                    title: "<spring:message code="reward.cost.center.section"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "ccpUnit",
                    title: "<spring:message code="reward.cost.center.unit"/>",
                    filterOperator: "iContains"
                }
            ],
            fetchDataURL: personnelUrl + "/iscList"
        });

        var PersonnelInfoListGrid_PersonnelList = isc.TrLG.create({
            dataSource: PersonnelInfoDS_PersonnelList,
            selectionType: "single",
            autoFetchData: true,
            fields: [
                {name: "id", hidden: true},
                {name: "firstName"},
                {name: "lastName"},
                {
                    name: "nationalCode",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {name: "companyName"},
                {
                    name: "personnelNo",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {
                    name: "personnelNo2",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {name: "postTitle"},
                {
                    name: "postCode",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {name: "ccpArea"},
                {name: "ccpAssistant"},
                {name: "ccpAffairs"},
                {name: "ccpSection"},
                {name: "ccpUnit"}
            ],
            recordClick: function () {
                set_PersonnelInfo_Details();
            }
        });

        var RestDataSource_PersonnelTraining = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true},
                {name: "courseId"},
                {name: "courseTitle"},
                {name: "code"},
                {name: "titleClass"},
                {name: "hduration"},
                {name: "startDate"},
                {name: "endDate"},
                {name: "classStatusId"},
                {name: "classStatus"},
                {name: "scoreStateId"},
                {name: "scoreState"},
                {name: "erunType"}
            ]
        });

        var ListGrid_PersonnelTraining = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_PersonnelTraining,
            selectionType: "single",
            autoFetchData: false,
            showGridSummary: true,
            fields: [
                {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
                {
                    name: "code",
                    title: "<spring:message code="class.code"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalPlanning(records)"
                },
                {
                    name: "courseId",
                    title: "courseId",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "courseTitle",
                    title: "<spring:message code="course.title"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalPassed(records)"
                },
                {
                    name: "titleClass",
                    title: "<spring:message code='class.title'/>",
                    align: "center",
                    filterOperator: "iContains",
                    hidden: true
                },
                {
                    name: "hduration",
                    title: "<spring:message code="class.duration"/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    filterEditorProperties: {
                        keyPressFilter: "[0-9]"
                    }
                },
                {
                    name: "startDate",
                    title: "<spring:message code='start.date'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    filterEditorProperties: {
                        keyPressFilter: "[0-9/]"
                    }
                },
                {
                    name: "endDate",
                    title: "<spring:message code='end.date'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    filterEditorProperties: {
                        keyPressFilter: "[0-9/]"
                    }
                },
                {
                    name: "classStatusId",
                    title: "classStatusId",
                    align: "center",
                    filterOperator: "equals",
                    autoFitWidth: true,
                    hidden: true
                },
                {
                    name: "classStatus",
                    title: "<spring:message code="class.status"/>",
                    align: "center",
                    filterOperator: "equals",
                    summaryFunction: "totalRejected(records)"
                },
                {
                    name: "scoreStateId",
                    title: "scoreStateId",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    hidden: true
                },
                {
                    name: "scoreState",
                    title: "<spring:message code="score.state"/>",
                    align: "center",
                    filterOperator: "iContains",
                    summaryFunction: "totalAll(records)"
                },
                {
                    name: "erunType",
                    title: "<spring:message code="course_eruntype"/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true
                }

            ],
             gridComponents: [ToolStrip_Personnel_Info_Training_Action, "filterEditor", "header", "body", "summaryRow"],
            cellClick: function (record, rowNum, colNum) {
                show_ClassInformation(record, rowNum, colNum);
            }
        });

        var RestDataSource_PersonnelInfo_class = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true},
                {name: "titleClass"},
                {name: "startDate"},
                {name: "endDate"},
                {name: "code"},
                {name: "term.titleFa"},
                {name: "course.titleFa"},
                {name: "course.id"},
                {name: "course.code"},
                {name: "course.evaluation"},
                {name: "institute.titleFa"},
                {name: "studentCount"},
                {name: "numberOfStudentEvaluation"},
                {name: "classStatus"},
                {name: "trainingPlaceIds"},
                {name: "instituteId"},
                {name: "workflowEndingStatusCode"},
                {name: "workflowEndingStatus"}
            ]
        });

        var ListGrid_PersonnelInfo_class = isc.TrLG.create({
            width: "100%",
            height: "100%",
            dataSource: RestDataSource_PersonnelInfo_class,
            canAddFormulaFields: false,
            autoFetchData: false,
            showFilterEditor: true,
            allowAdvancedCriteria: true,
            allowFilterExpressions: true,
            filterOnKeypress: true,
            sortField: 0,
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
                    autoFitWidth: true,
                    hidden: true
                },
                {
                    name: "course.titleFa",
                    title: "<spring:message code='course.title'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true,
                    sortNormalizer: function (record) {
                        return record.course.titleFa;
                    }
                },
                {
                    name: "startDate",
                    title: "<spring:message code='start.date'/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "endDate",
                    title: "<spring:message code='end.date'/>",
                    align: "center",
                    filterOperator: "iContains"
                },
                {
                    name: "studentCount",
                    title: "<spring:message code='student.count'/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "institute.titleFa",
                    title: "<spring:message code='presenter'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "classStatus", title: "<spring:message code='class.status'/>", align: "center",
                    valueMap: {
                        "1": "برنامه ریزی",
                        "2": "در حال اجرا",
                        "3": "پایان یافته"
                    }
                },
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
                    filterOperator: "iContains"
                }
            ]
        });

    }
    // ---------------------------------------- Create - RestDataSource & ListGrid -------------------------->>

    // <<-------------------------------------- Create - DynamicForm & Window ---------------------------------
    {
        var DynamicForm_PersonnelInfo = isc.DynamicForm.create({
            numCols: 6,
            colWidths: ["1%", "3%", "1%", "3%", "1%", "3%"],
            cellPadding: 3,
            fields:
                [
                    {
                        name: "header_PersonnelInfo",
                        type: "HeaderItem",
                        defaultValue: "<spring:message code="personal.information"/>",
                        startRow: true,
                        colSpan: 6,
                        cellStyle: "lineField"
                    },
                    {
                        name: "fullName",
                        title: "<spring:message code="full.name"/> : ",
                        canEdit: false
                    },
                    {
                        name: "personnelNo",
                        title: "<spring:message code="personnel.code"/> : ",
                        canEdit: false
                    },
                    {
                        name: "fatherName",
                        title: "<spring:message code="father.name"/> : ",
                        canEdit: false
                    },
                    {
                        name: "birth",
                        title: "<spring:message code="birth"/> : ",
                        canEdit: false
                    },
                    {
                        name: "nationalCode",
                        title: "<spring:message code="national.code"/> : ",
                        canEdit: false
                    },
                    {
                        name: "birthCertificateNo",
                        title: "<spring:message code="birth.certificate.no"/> : ",
                        canEdit: false
                    },
                    {
                        name: "educationLevelTitle",
                        title: "<spring:message code="education"/> : ",
                        canEdit: false
                    },
                    {
                        name: "gender",
                        title: "<spring:message code="gender"/> : ",
                        canEdit: false
                    },
                    {
                        name: "workYears",
                        title: "<spring:message code="current.education"/> : ",
                        canEdit: false
                    },
                    {
                        name: "header_CompanyInfo",
                        type: "HeaderItem",
                        defaultValue: "<spring:message code="company.profile"/>",
                        startRow: true,
                        colSpan: 6,
                        cellStyle: "lineField"
                    },
                    {
                        name: "notExists",
                        title: "<spring:message code="boss"/> : ",
                        canEdit: false
                    },
                    {
                        name: "notExists",
                        title: "<spring:message code="connective"/> : ",
                        canEdit: false
                    },
                    {
                        name: "employmentStatus",
                        title: "<spring:message code="employment.status"/> : ",
                        canEdit: false
                    },
                    {
                        name: "ccpAssistant",
                        title: "<spring:message code="area"/> : ",
                        canEdit: false
                    },
                    {
                        name: "ccpAffairs",
                        title: "<spring:message code="unit"/> : ",
                        canEdit: false
                    },
                    {
                        name: "ccpSection",
                        title: "<spring:message code="section"/> : ",
                        canEdit: false
                    },
                    {
                        name: "companyName",
                        title: "<spring:message code="branch"/> : ",
                        canEdit: false
                    },
                    {
                        name: "postTitle",
                        title: "<spring:message code="job"/> : ",
                        canEdit: false
                    },
                    {
                        name: "jobTitle",
                        title: "<spring:message code="post"/> : ",
                        canEdit: false
                    },
                    {
                        name: "postGradeTitle",
                        title: "<spring:message code="post.grade"/> : ",
                        canEdit: false
                    },
                    {
                        name: "notExists",
                        title: "<spring:message code="job.group"/> : ",
                        canEdit: false
                    },
                    {
                        name: "notExists",
                        title: "<spring:message code="business.class"/> : ",
                        canEdit: false
                    },
                    {
                        name: "personnelNo2",
                        title: "<spring:message code="personnel.code.six.digit"/> : ",
                        canEdit: false
                    },
                    {
                        name: "notExists",
                        title: "<spring:message code="post.group"/> : ",
                        canEdit: false
                    },
                    {
                        name: "notExists",
                        title: "<spring:message code="person.basic"/> : ",
                        canEdit: false
                    },
                    {
                        name: "employmentTypeTitle",
                        title: "<spring:message code="employment.type"/> : ",
                        canEdit: false
                    },
                    {
                        name: "employmentDate",
                        title: "<spring:message code="employment.date"/> : ",
                        canEdit: false
                    },
                    {
                        name: "workPlaceTitle",
                        title: "<spring:message code="geographical.location.of.service"/> : ",
                        canEdit: false
                    },
                    {
                        name: "notExists",
                        title: "<spring:message code="agents"/> : ",
                        canEdit: false
                    },
                    {
                        name: "workTurnTitle",
                        title: "<spring:message code="division.of.staff"/> : ",
                        canEdit: false
                    },
                    {
                        name: "notExists",
                        title: "<spring:message code="military"/> : ",
                        canEdit: false
                    },
                    {
                        name: "header_ContactInfo",
                        type: "HeaderItem",
                        defaultValue: "<spring:message code="contact.information"/>",
                        colSpan: 6,
                        startRow: true,
                        cellStyle: "lineField"
                    },
                    {
                        name: "phone",
                        title: "<spring:message code="telephone"/> : ",
                        canEdit: false
                    },
                    {
                        name: "mobile",
                        title: "<spring:message code="cellPhone"/> : ",
                        canEdit: false
                    },
                    {
                        name: "email",
                        title: "<spring:message code="email"/> : ",
                        canEdit: false
                    },
                    {
                        name: "address",
                        title: "<spring:message code="address"/> : ",
                        canEdit: false
                    }
                ]
        });

        var DynamicForm_PersonnelInfo_CourseInfo = isc.DynamicForm.create({
            numCols: 6,
            colWidths: ["1%", "1%", "1%", "1%", "1%", "1%"],
            cellPadding: 3,
            fields:
                [
                    {
                        name: "header_BasicInfo",
                        type: "HeaderItem",
                        defaultValue: "<spring:message code="basic.information"/>",
                        startRow: true,
                        colSpan: 6,
                        cellStyle: "lineField"
                    },
                    {
                        name: "titleFa",
                        title: "<spring:message code="course.title"/> : ",
                        canEdit: false
                    },
                    {
                        name: "code",
                        title: "<spring:message code="course.code"/> : ",
                        canEdit: false
                    },
                    {
                        name: "theoryDuration",
                        title: "<spring:message code="course_theoryDuration"/> : ",
                        canEdit: false
                    },
                    {
                        name: "category.titleFa",
                        title: "<spring:message code="group"/> : ",
                        canEdit: false
                    },
                    {
                        name: "subCategory.titleFa",
                        title: "<spring:message code="subcategory"/> : ",
                        canEdit: false
                    },
                    {
                        name: "erunType.titleFa",
                        title: "<spring:message code="course_eruntype"/> : ",
                        canEdit: false
                    },
                    {
                        name: "elevelType.titleFa",
                        title: "<spring:message code="cousre_elevelType"/> : ",
                        canEdit: false
                    },
                    {
                        name: "etheoType.titleFa",
                        title: "<spring:message code="course_etheoType"/> : ",
                        canEdit: false
                    },
                    {
                        name: "etechnicalType.titleFa",
                        title: "<spring:message code="course_etechnicalType"/> : ",
                        canEdit: false
                    },
                    {
                        name: "evaluation",
                        title: "<spring:message code="evaluation.level"/> : ",
                        valueMap: {
                            "1": "واکنش",
                            "2": "یادگیری",
                            "3": "رفتاری",
                            "4": "نتایج"
                        },
                        canEdit: false
                    },
                    {
                        name: "behavioralLevel",
                        title: "<spring:message code="behavioral.Level"/> : ",
                        valueMap: {
                            "1": "مشاهده",
                            "2": "مصاحبه",
                            "3": "کار پروژه ای"
                        },
                        canEdit: false
                    },
                    {
                        name: "scoringMethod",
                        title: "<spring:message code="scoring.Method"/> : ",
                        valueMap: {
                            "1": "ارزشی",
                            "2": "نمره از صد",
                            "3": "نمره از بیست",
                            "4": "بدون نمره"
                        },
                        canEdit: false
                    },
                    {
                        name: "minTeacherDegree",
                        title: "<spring:message code="course_minTeacherDegree"/> : ",
                        canEdit: false
                    },
                    {
                        name: "minTeacherExpYears",
                        title: "<spring:message code="course_minTeacherExpYears"/> : ",
                        canEdit: false
                    },
                    {
                        name: "minTeacherEvalScore",
                        title: "<spring:message code="course_minTeacherEvalScore"/> : ",
                        canEdit: false
                    },
                    {
                        name: "header_MainObjective",
                        type: "HeaderItem",
                        defaultValue: "<spring:message code="course_mainObjective"/>",
                        startRow: true,
                        colSpan: 6,
                        cellStyle: "lineField"
                    },
                    {
                        name: "mainObjective",
                        title: "",
                        type: "TextAreaItem",
                        startRow: true,
                        colSpan: 5,
                        rowSpan: 4,
                        height: "*",
                        width: "100%",
                        length: 5000,
                        canEdit: false
                    },
                    {
                        name: "header_goals",
                        type: "HeaderItem",
                        defaultValue: "<spring:message code="course.goals"/>",
                        colSpan: 6,
                        startRow: true,
                        cellStyle: "lineField"
                    },
                    {
                        name: "goals",
                        title: "",
                        type: "TextAreaItem",
                        startRow: true,
                        colSpan: 5,
                        rowSpan: 4,
                        height: "*",
                        width: "100%",
                        length: 5000,
                        canEdit: false
                    },
                    {
                        name: "header_perCourses",
                        type: "HeaderItem",
                        defaultValue: "<spring:message code="prerequisites"/>",
                        colSpan: 6,
                        startRow: true,
                        cellStyle: "lineField"
                    },
                    {
                        name: "perCourses",
                        title: "",
                        type: "TextAreaItem",
                        startRow: true,
                        colSpan: 5,
                        rowSpan: 4,
                        height: "*",
                        width: "100%",
                        length: 5000,
                        canEdit: false
                    }
                ]
        });

        var DynamicForm_PersonnelInfo_ClassInfo = isc.DynamicForm.create({
            numCols: 6,
            colWidths: ["1%", "1%", "1%", "1%", "1%", "1%"],
            cellPadding: 3,
            fields:
                [
                    {
                        name: "header_BasicInfo",
                        type: "HeaderItem",
                        defaultValue: "<spring:message code="basic.information"/>",
                        startRow: true,
                        colSpan: 6,
                        cellStyle: "lineField"
                    },
                    {
                        name: "titleClass",
                        title: "<spring:message code="class.title"/> : ",
                        canEdit: false
                    },
                    {
                        name: "code",
                        title: "<spring:message code="class.code"/> : ",
                        canEdit: false
                    },
                    {
                        name: "hduration",
                        title: "<spring:message code="duration"/> : ",
                        canEdit: false,
                        mapValueToDisplay: function (value) {
                            if (isNaN(value)) {
                                return "";
                            }
                            return value + " ساعت ";
                        }
                    },
                    {
                        name: "minCapacity",
                        title: "<spring:message code="minCapacity"/> : ",
                        canEdit: false
                    },
                    {
                        name: "maxCapacity",
                        title: "<spring:message code="maxCapacity"/> : ",
                        canEdit: false
                    },
                    {
                        name: "teacher",
                        title: "<spring:message code="teacher"/> : ",
                        canEdit: false
                    },
                    {
                        name: "supervisor",
                        title: "<spring:message code="supervisor"/> : ",
                        valueMap: {
                            1: "آقای دکتر سعیدی",
                            2: "خانم شاکری",
                            3: "خانم اسماعیلی",
                            4: "خانم احمدی",
                        },
                        canEdit: false
                    },
                    {
                        name: "institute.titleFa",
                        title: "<spring:message code="institute"/> : ",
                        canEdit: false
                    },
                    {
                        name: "classStatus",
                        title: "<spring:message code="class.status"/> : ",
                        valueMap: {
                            "1": "برنامه ریزی",
                            "2": "در حال اجرا",
                            "3": "پایان یافته",
                        },
                        canEdit: false
                    },
                    {
                        name: "teachingType",
                        title: "<spring:message code="teaching.type"/> : ",
                        valueMap: [
                            "حضوری",
                            "غیر حضوری",
                            "مجازی",
                            "عملی و کارگاهی"
                        ],
                        canEdit: false
                    },
                    {
                        name: "topology",
                        title: "<spring:message code="place.shape"/> : ",
                        valueMap: {
                            "1": "U شکل",
                            "2": "عادی",
                            "3": "مدور",
                            "4": "سالن"
                        },
                        canEdit: false
                    },
                    {
                        name: "scoringMethod",
                        title: "<spring:message code="scoring.Method"/> : ",
                        valueMap: {
                            "1": "ارزشی",
                            "2": "نمره از صد",
                            "3": "نمره از بیست",
                            "4": "بدون نمره"
                        },
                        canEdit: false
                    },
                    {
                        name: "header_Time",
                        type: "HeaderItem",
                        defaultValue: "<spring:message code="class.meeting.time"/>",
                        startRow: true,
                        colSpan: 6,
                        cellStyle: "lineField"
                    },
                    {
                        name: "term.titleFa",
                        title: "<spring:message code="term"/> : ",
                        canEdit: false
                    },
                    {
                        name: "startDate",
                        title: "<spring:message code="start.date"/> : ",
                        canEdit: false
                    },
                    {
                        name: "endDate",
                        title: "<spring:message code="end.date"/> : ",
                        canEdit: false
                    },
                    {
                        name: "teachingBrand",
                        title: "<spring:message code="teaching.method"/> : ",
                        valueMap: {
                            1: "تمام وقت",
                            2: "نیمه وقت",
                            3: "پاره وقت"
                        },
                        canEdit: false
                    },
                    {
                        name: "classSessionTimes",
                        title: "<spring:message code="sessions.time"/> : ",
                        startRow: true,
                        colSpan: 3,
                        canEdit: false
                    },
                    {
                        name: "classDays",
                        title: "<spring:message code="week.days"/> : ",
                        startRow: true,
                        colSpan: 3,
                        canEdit: false
                    }
                ]
        });
    }
    // ---------------------------------------- Create - DynamicForm $ Window ------------------------------->>

    // <<-------------------------------------- Create - TabSet & Tab -----------------------------------------
    {
        var VLayout_PersonnelInfo_Detail = isc.VLayout.create({
            width: "100%",
            height: "100%",
            membersMargin: 5,
            members: [DynamicForm_PersonnelInfo]
        });

        var PersonnelInfo_Tab = isc.TabSet.create({
            ID: "PersonnelInfo_Tab",
            tabBarPosition: "top",
            tabs: [
                {
                    id: "PersonnelInfo_Tab_Info",
                    title: "<spring:message code="personnelReg.baseInfo"/>",
                    pane: VLayout_PersonnelInfo_Detail

                },
                {
                    id: "PersonnelInfo_Tab_Training",
                    title: "<spring:message code="trainings"/>",
                    pane: ListGrid_PersonnelTraining
                },
                {
                    id: "PersonnelInfo_Tab_NeedAssessment",
                    title: "<spring:message code="competence"/>",
                    pane: isc.ViewLoader.create({autoDraw: true, viewURL: "web/needsAssessment-reports"})
                }

            ],
            tabSelected: function () {
                set_PersonnelInfo_Details();
            }
        });

        var PersonnelInfo_ClassInfo_Tab = isc.TabSet.create({
            ID: "PersonnelInfo_ClassInfo_Tab",
            width: "100%",
            height: 500,
            tabBarPosition: "top",
            tabs: [
                {
                    id: "ClassInfo_Tab_Course",
                    title: "<spring:message code="course"/>",
                    pane: DynamicForm_PersonnelInfo_CourseInfo
                },
                {
                    id: "ClassInfo_Tab_Class",
                    title: "<spring:message code="class"/>",
                    pane: DynamicForm_PersonnelInfo_ClassInfo
                },
                {
                    id: "ClassInfo_Tab_Records",
                    title: "<spring:message code="course.records"/>",
                    pane: ListGrid_PersonnelInfo_class
                }
            ],
            tabSelected: function () {
                set_PersonnelInfo_CourseInfo();
            }
        });

        var window_class_Information = isc.Window.create({
            title: "",
            width: "70%",
            minWidth: 500,
            height: 500,
            visibility: "hidden",
            items: [PersonnelInfo_ClassInfo_Tab]
        });
    }
    // ---------------------------------------- Create - TabSet & Tab --------------------------------------->>

    // <<------------------------------------------- Create - Layout ------------------------------------------
    {
//*****class HLayout & VLayout*****
    TabSet_GroupInsert_JspPersonnelInformation=isc.TabSet.create({
        ID:"leftTabSet_JspPersonnelInformation",
        autoDraw:false,
        tabBarPosition: "top",
        width: "100%",
        height: 105,
        tabs: [
            { title: "ورود  مستقیم",
                pane: isc.DynamicForm.create({
                    height: "6%",
                    width:"100%",
                    left:0,
                    align:"left",
                    numCols: 5,
                    colWidths: ["0%","50%","10%","30%"],
                    fields: [
                        {
                            ID:"DynamicForm_GroupInsert_Textbox_JspPersonnelInformation",
                            title:""

                        },
                        {
                            type: "button",
                            title: "اضافه کردن به لیست",
                            startRow: false,
                            click:function () {
                                let value=DynamicForm_GroupInsert_Textbox_JspPersonnelInformation.getValue();
                                if(value != null&& value != "" && typeof(value) != "undefined")
                                {
                                    let personnels=value.split(',');
                                    let len=personnels.size();

                                    for (let i=0;i<len;i++){
                                        if(isNaN(personnels[i])){
                                            continue;
                                        }
                                        else if(GroupSelectedPersonnelsLG_JspPersonnelInformation.data.filter(
                                            function (item) {
                                                return item.personnelNo==personnels[i];
                                        }
                                        ).length==0){
                                            let current={personnelNo:personnels[i]};
                                            GroupSelectedPersonnelsLG_JspPersonnelInformation.setData(GroupSelectedPersonnelsLG_JspPersonnelInformation.data.concat([current]));
                                            GroupSelectedPersonnelsLG_JspPersonnelInformation.invalidateCache();
                                            GroupSelectedPersonnelsLG_JspPersonnelInformation.fetchData();
                                            continue;
                                        }
                                        else{
                                            continue;
                                        }
                                    }

                                    DynamicForm_GroupInsert_Textbox_JspPersonnelInformation.setValue('');
                                    createDialog("info", "کدهای پرسنلی به لیست اضافه شدند.");
                                }
                            }
                        }
                    ]
                })
            },
            {title: "فایل اکسل", width:200, overflow:"hidden",
                pane: isc.DynamicForm.create({
                    height: "100%",
                    width:"100%",
                    left:0,
                    align:"left",
                    numCols: 5,
                    colWidths: ["0%","50%","10%","30%"],
                    fields: [

                        {
                            ID:"DynamicForm_GroupInsert_FileUploader_JspPersonnelInformation",
                            name:"DynamicForm_GroupInsert_FileUploader_JspPersonnelInformation",
                            type:"imageFile",
                            title:""
                        },
                        {
                            type: "button",
                            title: "آپلود فايل",
                            startRow: false,
                            click:function () {
                                let address=DynamicForm_GroupInsert_FileUploader_JspPersonnelInformation.getValue();

                                if(address==null){
                                    createDialog("info", "فايل خود را انتخاب نماييد.");
                                }else{
                                    var ExcelToJSON = function() {

                                        this.parseExcel = function(file) {
                                            var reader = new FileReader();
                                            var records = [];

                                            reader.onload = function(e) {
                                                var data = e.target.result;
                                                var workbook = XLSX.read(data, {
                                                    type: 'binary'
                                                });

                                                workbook.SheetNames.forEach(function(sheetName) {
                                                    var XL_row_object = XLSX.utils.sheet_to_row_object_array(workbook.Sheets[sheetName]);
                                                    for(let i=0;i<XL_row_object.length;i++){
                                                        if(isNaN(Object.values(XL_row_object[i])[0])){
                                                            continue;
                                                        }
                                                        else if(GroupSelectedPersonnelsLG_JspPersonnelInformation.data.filter(function (item) {
                                                            return item.personnelNo==Object.values(XL_row_object[i])[0];
                                                        }).length==0){
                                                            let current={personnelNo:Object.values(XL_row_object[i])[0]};
                                                            records.add(current);

                                                            continue;
                                                        }
                                                        else{
                                                            continue;
                                                        }
                                                    }

                                                    DynamicForm_GroupInsert_FileUploader_JspPersonnelInformation.setValue('');
                                                    createDialog("info", "فایل به لیست اضافه شد.");

                                                });

                                                if(records.length > 0){
                                                    GroupSelectedPersonnelsLG_JspPersonnelInformation.setData(records);
                                                    GroupSelectedPersonnelsLG_JspPersonnelInformation.invalidateCache();
                                                    GroupSelectedPersonnelsLG_JspPersonnelInformation.fetchData();
                                                }else{
                                                    createDialog("info", "خطا در محتویات فایل");
                                                }

                                            };

                                            reader.onerror = function(ex) {
                                                createDialog("info", "خطا در باز کردن فایل");
                                            };

                                            reader.readAsBinaryString(file);
                                        };
                                    };
                                    let split=$('[name="DynamicForm_GroupInsert_FileUploader_JspPersonnelInformation"]')[0].files[0].name.split('.');

                                    if(split[split.length-1]=='xls'||split[split.length-1]=='csv'||split[split.length-1]=='xlsx'){
                                        var xl2json = new ExcelToJSON();
                                        xl2json.parseExcel($('[name="DynamicForm_GroupInsert_FileUploader_JspPersonnelInformation"]')[0].files[0]);
                                    }else{
                                        createDialog("info", "فایل انتخابی نادرست است. پسوندهای فایل مورد تایید xlsx,xls,csv هستند.");
                                    }

                                }
                            }
                        }
                    ]
                })



            }
        ]
    });

        ClassStudentWin_GroupInsert_JspPersonnelInformation = isc.Window.create({
            width: 900,
            height: 750,
            minWidth: 700,
            minHeight: 500,
            autoSize: false,
            title:"فیلتر گروهی",
            items: [isc.HLayout.create({
                width: "100%",
                height: "88%",
                autoDraw: false,
                align: "center",
                members: [
                    isc.TrLG.create({
                        ID: "GroupSelectedPersonnelsLG_JspPersonnelInformation",
                        showFilterEditor: false,
                        editEvent: "click",
                        listEndEditAction: "next",
                        enterKeyEditAction: "nextRowStart",
                        canSort:false,
                        canEdit:true,
                        filterOnKeypress: true,
                        selectionType: "single",
                        fields: [
                            {name: "remove", tile: "<spring:message code="remove"/>", isRemoveField: true,width:"10%"},
                            {
                                name: "personnelNo",
                                title: "<spring:message code="personnel.no"/>",
                                width:"40%",
                                editorExit:function(editCompletionEvent, record, newValue, rowNum, colNum)
                                {
                                    isEditing=false;
                                    if(editCompletionEvent=='escape'){
                                        return true;
                                    }else if(editCompletionEvent=='enter'){
                                        if (newValue != null) {
                                            if(GroupSelectedPersonnelsLG_JspPersonnelInformation.data.filter(function (item) {
                                                return item.personnelNo==newValue;
                                            }).length==0){
                                                return true;
                                            }
                                            else{
                                                createDialog("info", "<spring:message code="msg.record.duplicate" />", "<spring:message code="error"/>");
                                                return false;
                                            }
                                        }
                                        else {return true}
                                    }else if(editCompletionEvent=='programmatic') {
                                        if(newValue!=''||newValue!=null||typeof(newValue)=='undefined'){
                                            isEditing=true;
                                            return false;
                                        }
                                    }
                                },
                                change:function (form,item,value) {
                                    if(!value.match(/^\d{0,10}$/)){
                                        item.setValue(value.substring(0,value.length-1));
                                    }
                                }
                            },
                            {name: "description", title: "توضیحات", canEdit: false ,width:"45%"},
                            {name: "error", canEdit: false ,hidden:true,width:"5%"},
                            {name: "hasWarning", title: " ", width: 40, type: "image", imageURLPrefix: "", imageURLSuffix: ".png", canEdit: false}
                        ],
                        gridComponents: [TabSet_GroupInsert_JspPersonnelInformation, "header", "body"],
                        canRemoveRecords: true,
                        deferRemoval:true,
                        removeRecordClick:function (rowNum){
                            if(GroupSelectedPersonnelsLG_JspPersonnelInformation.getAllEditRows()[0]==GroupSelectedPersonnelsLG_JspPersonnelInformation.data.length){
                                GroupSelectedPersonnelsLG_JspPersonnelInformation.discardEdits(GroupSelectedPersonnelsLG_JspPersonnelInformation.getAllEditRows()[0]);
                            }
                            GroupSelectedPersonnelsLG_JspPersonnelInformation.data.removeAt(rowNum);
                            if(GroupSelectedPersonnelsLG_JspPersonnelInformation.data.length==0&&!isEditing){
                                GroupSelectedPersonnelsLG_JspPersonnelInformation.addData({
                                    nationalCode: ""
                                });
                            }
                        }
                    })
                ]
            }),
                isc.TrHLayoutButtons.create({
                    members: [
                        isc.IButtonSave.create({
                            top: 260,
                            title: "<spring:message code='ok'/>",
                            align: "center",
                            click: function () {

                                let getEditCells=GroupSelectedPersonnelsLG_JspPersonnelInformation.getAllEditCells();

                                if(getEditCells.size()!=0){
                                    let value=GroupSelectedPersonnelsLG_JspPersonnelInformation.getEditValue(getEditCells[0][0],getEditCells[0][1]);

                                    if(value == "" || value == null || typeof(value) == "undefined"){
                                        GroupSelectedPersonnelsLG_JspPersonnelInformation.cancelEditing(getEditCells[0][0]);
                                    }else{
                                        if(GroupSelectedPersonnelsLG_JspPersonnelInformation.data.filter(function (item) {
                                            return item.personnelNo==value;
                                        }).length==0){
                                            GroupSelectedPersonnelsLG_JspPersonnelInformation.saveAndEditNextRow();
                                        }
                                        else{
                                            GroupSelectedPersonnelsLG_JspPersonnelInformation.cancelEditing(getEditCells[0][0]);
                                        }
                                    }
                                }

                                let len=GroupSelectedPersonnelsLG_JspPersonnelInformation.data.length;
                                let list=GroupSelectedPersonnelsLG_JspPersonnelInformation.data;
                                let result=[];

                                for (let index = 0; index < len; index++) {
                                    if(list[index].personnelNo != "" && list[index].personnelNo != null && typeof(list[index].personnelNo) != "undefined")
                                    {
                                        result.push(list[index].personnelNo)
                                    }
                                }

                                advancedCriteriaPersonnelInformation= {
                                    _constructor: "AdvancedCriteria",
                                    operator: "and",
                                    criteria: [
                                        {fieldName: "personnelNo", operator: "inSet", value: result}
                                    ]
                                };
                                PersonnelInfoListGrid_PersonnelList.fetchData(advancedCriteriaPersonnelInformation);
                                ClassStudentWin_GroupInsert_JspPersonnelInformation.close();
                            }
                        }), isc.IButtonCancel.create({
                            top: 260,
                            title: "<spring:message code='cancel'/>",
                            align: "center",
                            icon: "[SKIN]/actions/cancel.png",
                            click: function () {
                                ClassStudentWin_GroupInsert_JspPersonnelInformation.close();
                            }
                        })
                    ]
                })
            ]
        });

        var HLayout_Actions_PI = isc.HLayout.create({
            width: "100%",
            height: "1%",
            membersMargin: 5,
            members: [
                isc.ToolStripButtonAdd.create({
                    title: 'فیلتر گروهي',
                    click: function () {
                        GroupSelectedPersonnelsLG_JspPersonnelInformation.discardAllEdits();
                        GroupSelectedPersonnelsLG_JspPersonnelInformation.data.clearAll();
                        GroupSelectedPersonnelsLG_JspPersonnelInformation.addData({
                            nationalCode: ""
                        });
                        url=personnelRegUrl;
                        TabSet_GroupInsert_JspPersonnelInformation.selectTab(0);
                        ClassStudentWin_GroupInsert_JspPersonnelInformation.show();
                    }
                }),
                isc.ToolStripButtonExcel.create({
                    title: 'ارسال لیست فیلتر شده به اکسل',
                    click: function () {
                        let grid=PersonnelInfoListGrid_PersonnelList;
                        let size = grid.data.size();
                        isc.Window.create({
                            ID: "exportExcelWindow_JspPersonnelInformation",
                            title: "خروجی اکسل",
                            autoSize: true,
                            width: 400,
                            items: [
                                isc.DynamicForm.create({
                                    ID: "exportExcelForm_JspPersonnelInformation",
                                    numCols: 1,
                                    padding: 10,
                                    fields: [
                                        {
                                            name: "maxRow",
                                            width: "100%",
                                            titleOrientation: "top",
                                            title: "لطفا حداکثر تعداد سطرهای موجود در اکسل را وارد نمایید:",
                                            value: size,
                                            suppressBrowserClearIcon: true,
                                            icons: [{
                                                name: "clear",
                                                src: "[SKIN]actions/close.png",
                                                width: 10,
                                                height: 10,
                                                inline: true,
                                                prompt: "پاک کردن",
                                                click: function (form, item, icon) {
                                                    item.clearValue();
                                                    item.focusInItem();
                                                }
                                            }],
                                            iconWidth: 16,
                                            iconHeight: 16
                                        }
                                    ]
                                }),
                                isc.TrHLayoutButtons.create({
                                    members: [
                                        isc.IButton.create({
                                            title: "تایید",
                                            click: function () {
                                                if (trTrim(exportExcelForm_JspPersonnelInformation.getValue("maxRow")) != "") {
                                                    ExportToFile.DownloadExcelFormServer(grid, 'trainingFile',
                                                        exportExcelForm_JspPersonnelInformation.getValue("maxRow"), null, '', "گزارش پرسنل",
                                                        JSON.stringify(grid.data.criteria));
                                                }
                                                exportExcelWindow_JspPersonnelInformation.close();
                                            }
                                        }),
                                        isc.IButton.create({
                                            title: "لغو",
                                            click: function () {
                                                exportExcelWindow_JspPersonnelInformation.close();
                                            }
                                        }),
                                    ]
                                })
                            ]
                        });
                        exportExcelWindow_JspPersonnelInformation.show();
                       }
                }),
                ToolStrip_Personnel_Info]
        });

        var Hlayout_Grid_PI = isc.HLayout.create({
            width: "100%",
            height: "99%",
            members: [PersonnelInfoListGrid_PersonnelList]
        });

        var VLayout_PersonnelInfo_List = isc.VLayout.create({
            width: "100%",
            height: "50%",
            showResizeBar: true,
            members: [HLayout_Actions_PI, Hlayout_Grid_PI]
        });

        var HLayout_PersonnelInfo_Details = isc.HLayout.create({
            width: "100%",
            height: "50%",
            members: [PersonnelInfo_Tab]
        });

        var VLayout_PersonnelInfo_Data = isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [VLayout_PersonnelInfo_List, HLayout_PersonnelInfo_Details]
        });
    }
    // ---------------------------------------------- Create - Layout ---------------------------------------->>

    // <<----------------------------------------------- Functions --------------------------------------------
    {
        var nationalCode_Info, nationalCode_Training, nationalCode_Need;

        function set_PersonnelInfo_Details() {

            if (PersonnelInfoListGrid_PersonnelList.getSelectedRecord() !== null) {

                let personnelNo = PersonnelInfoListGrid_PersonnelList.getSelectedRecord().personnelNo;
                let nationalCode = PersonnelInfoListGrid_PersonnelList.getSelectedRecord().nationalCode;

                if (PersonnelInfo_Tab.getSelectedTab().id === "PersonnelInfo_Tab_Info") {
                    if (personnelNo !== null && nationalCode_Info !== nationalCode) {
                        DynamicForm_PersonnelInfo.clearValues();
                        nationalCode_Info = nationalCode;
                        isc.RPCManager.sendRequest(TrDSRequest(personnelUrl + "/byPersonnelNo/" + personnelNo, "GET", null, function (resp) {

                            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                                let currentPersonnel = JSON.parse(resp.data);

                                currentPersonnel.fullName =
                                    (currentPersonnel.firstName !== undefined ? currentPersonnel.firstName : "")
                                    + " " +
                                    (currentPersonnel.lastName !== undefined ? currentPersonnel.lastName : "");

                                currentPersonnel.birth =
                                    (currentPersonnel.birthDate !== undefined ? currentPersonnel.birthDate : "")
                                    + " - " +
                                    (currentPersonnel.birthPlace !== undefined ? currentPersonnel.birthPlace : "");

                                currentPersonnel.educationLevelTitle =
                                    (currentPersonnel.educationLevelTitle !== undefined ? currentPersonnel.educationLevelTitle : "")
                                    + " / " +
                                    (currentPersonnel.educationMajorTitle !== undefined ? currentPersonnel.educationMajorTitle : "");

                                currentPersonnel.gender =
                                    (currentPersonnel.gender !== undefined ? currentPersonnel.gender : "")
                                    + " - " +
                                    (currentPersonnel.maritalStatusTitle !== undefined ? currentPersonnel.maritalStatusTitle : "");

                                DynamicForm_PersonnelInfo.editRecord(currentPersonnel);
                            }

                        }));
                    }
                } else if (PersonnelInfo_Tab.getSelectedTab().id === "PersonnelInfo_Tab_Training") {
                    if (nationalCode !== null && nationalCode_Training !== nationalCode) {
                        nationalCode_Training = nationalCode;
                        RestDataSource_PersonnelTraining.fetchDataURL = classUrl + "personnel-training/" + nationalCode;
                        ListGrid_PersonnelTraining.invalidateCache();
                        ListGrid_PersonnelTraining.fetchData();
                    }
                } else if (PersonnelInfo_Tab.getSelectedTab().id === "PersonnelInfo_Tab_NeedAssessment") {
                    if (nationalCode_Need !== nationalCode) {
                        nationalCode_Need = nationalCode;
                        call_needsAssessmentReports("0", true, PersonnelInfoListGrid_PersonnelList.getSelectedRecord());
                    }
                }
            } else {
                DynamicForm_PersonnelInfo.clearValues();
                ListGrid_PersonnelTraining.setData([]);
                nationalCode_Info = -1;
                nationalCode_Training = -1;
                nationalCode_Need = -1;
            }
        }

//*****calculate total summary*****

        function totalPlanning(records) {
            let totalPlanning_ = 0;
            for (let i = 0; i < records.length; i++) {
                if (records[i].classStatusId === 1)
                    totalPlanning_ += records[i].hduration;
            }
            return "<spring:message code='planning.sum'/> : " + totalPlanning_ + " <spring:message code='hour'/> ";
        }

        function totalPassed(records) {
            let totalPassed_ = 0;
            for (let i = 0; i < records.length; i++) {
                if (records[i].classStatusId !== 1)
                    totalPassed_ += records[i].hduration;
            }
            return "<spring:message code='passed.or.running.sum'/> : " + totalPassed_ + " <spring:message code='hour'/> ";
        }

        function totalRejected(records) {
            let totalRejected_ = 0;
            for (let i = 0; i < records.length; i++) {
                if (records[i].scoreStateId === 0)
                    totalRejected_ += records[i].hduration;
            }
            return "<spring:message code='missing.or.absent.sum'/> : " + totalRejected_ + " <spring:message code='hour'/> ";
        }

        function totalAll(records) {
            let totalAll_ = 0;
            for (let i = 0; i < records.length; i++) {
                totalAll_ += records[i].hduration;
            }
            return "<spring:message code='total.sum'/> : " + totalAll_ + " <spring:message code='hour'/> ";
        }

//***********************************

        function show_ClassInformation(record, rowNum, colNum) {
            if (colNum === 1) {
                window_class_Information.setTitle(record.courseTitle);
                window_class_Information.show();

                set_PersonnelInfo_CourseInfo();
            }
        }

//***********************************

//*****get selected course information*****
        var courseId_Tab_Course, courseId_Tab_Records, classId_Tab_Class;

        function set_PersonnelInfo_CourseInfo() {

            if (ListGrid_PersonnelTraining.getSelectedRecord() !== null) {
                let courseId = ListGrid_PersonnelTraining.getSelectedRecord().courseId;
                let classId = ListGrid_PersonnelTraining.getSelectedRecord().id;

                if (PersonnelInfo_ClassInfo_Tab.getSelectedTab().id === "ClassInfo_Tab_Course") {
                    if (courseId !== null && courseId_Tab_Course !== courseId) {
                        courseId_Tab_Course = courseId;
                        DynamicForm_PersonnelInfo_CourseInfo.clearValues();
                        isc.RPCManager.sendRequest(TrDSRequest(personnelInformationUrl + "/findCourseByCourseId/" + courseId, "GET", null, function (resp) {
                            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                                let currentCourse = JSON.parse(resp.data);
                                DynamicForm_PersonnelInfo_CourseInfo.editRecord(currentCourse);
                            }
                        }));
                    }
                } else if (PersonnelInfo_ClassInfo_Tab.getSelectedTab().id === "ClassInfo_Tab_Class") {
                    if (classId !== null && classId_Tab_Class !== classId) {
                        classId_Tab_Class = classId;
                        DynamicForm_PersonnelInfo_ClassInfo.clearValues();
                        isc.RPCManager.sendRequest(TrDSRequest(personnelInformationUrl + "/findClassByClassId/" + classId, "GET", null, function (resp) {
                            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                let currentClass = JSON.parse(resp.data);
                                DynamicForm_PersonnelInfo_ClassInfo.editRecord(currentClass);
                            }
                        }));
                    }
                } else if (PersonnelInfo_ClassInfo_Tab.getSelectedTab().id === "ClassInfo_Tab_Records") {
                    if (courseId !== null && courseId_Tab_Records !== courseId) {
                        courseId_Tab_Records = courseId;
                        RestDataSource_PersonnelInfo_class.fetchDataURL = personnelInformationUrl + "/findClassByCourseId/" + courseId;
                        ListGrid_PersonnelInfo_class.invalidateCache();
                        ListGrid_PersonnelInfo_class.fetchData();
                    }
                }
            }
        }
    }
    // ------------------------------------------------- Functions ------------------------------------------>>

    // </script>