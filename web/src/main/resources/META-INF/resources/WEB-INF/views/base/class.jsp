<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@include file="../messenger/MLanding.jsp" %>
<%@include file="teacher.jsp" %>

// <script>
    wait.show();
    var etcTargetSociety = [];
    var singleTargetScoiety = [];
    var classMethod = "POST";
    var autoValid = false;
    var startDateCheck = true;
    var endDateCheck = true;
    var isReadOnlyClass = true;
    var societies = [];
    let termId = null;
    let termStart = null;
    let termEnd = null;
    let firstLoad = true;
    let oLoadAttachments_class = null;
    let OJT = false;
    let lastDate = null;
    let departmentCriteria = [];let yearCriteria = [];let mainTermCriteria = [];

    //--------------------------------------------------------------------------------------------------------------------//
    /*Rest Data Sources*/
    //--------------------------------------------------------------------------------------------------------------------//

    var RestDataSource_Teacher_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "fullNameFa"},
            {name: "personality.firstNameFa"},
            {name: "personality.lastNameFa"},
            {name: "personality.nationalCode"},
            {name: "grade"}
        ],
        fetchDataURL: teacherUrl + "fullName-list"
    });

    var RestDataSource_category_JspCourse = isc.TrDS.create({
        ID: "categoryDS",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: categoryUrl + "spec-list",
    });

    var DataSource_TargetSociety_List = isc.DataSource.create({
        clientOnly: true,
        testData: societies,
        fields: [
            {name: "societyId", primaryKey: true},
            {name: "title", type: "text"}
        ],
    });

    var RestDataSource_subCategory_JspCourse = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: subCategoryUrl + "spec-list",
    });

    var RestDataSource_Class_JspClass = isc.TrDS.create({
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
        ]
    });

    var RestDataSource_StudentGradeToTeacher_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleClass"},
            {name: "startDate"},
            {name: "endDate"},
            {name: "code"},
            {name: "term"},
            {name: "grade"}
        ],
        fetchDataURL: teacherUrl + "all-students-grade-to-teacher"
    });

    var RestDataSource_Course_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "scoringMethod"},
            {name: "acceptancelimit"},
            {name: "startEvaluation"},
            {
                name: "code",
                title: "<spring:message code="course.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "titleFa", title: "<spring:message code="course.title"/>", filterOperator: "iContains"},
            {name: "createdBy", title: "<spring:message code="created.by.user"/>", filterOperator: "iContains"},
            {name: "theoryDuration"},
            {name: "categoryId"},
            {name: "subCategoryId"},
        ],
        fetchDataURL: courseUrl + "spec-list?type=combo"
    });

    var RestDataSource_Term_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
        ],
        fetchDataURL: termUrl + "spec-list"
    });

    var RestDataSource_Institute_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", title: "نام موسسه"},
            {name: "manager.firstNameFa", title: "نام مدیر"},
            {name: "manager.lastNameFa", title: "نام خانوادگی مدیر"},
            {name: "mobile", title: "موبایل"},
            {name: "restAddress", title: "آدرس"},
            {name: "phone", title: "تلفن"}
        ],
        fetchDataURL: instituteUrl + "spec-list",
        allowAdvancedCriteria: true,
    });


    var RestDataSource_Holding_Class_Type_List = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>"},
            {name: "code", title: "<spring:message code="code"/>"}
        ],
        fetchDataURL: parameterValueUrl + "/listByCode/HoldingClassType"
    });
    var RestDataSource_class_complex_List = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>"},
            {name: "code", title: "<spring:message code="code"/>"}
        ],
        fetchDataURL: departmentUrl + "/organ-segment-iscList/mojtame"
    });
    var RestDataSource_class_assistant_List = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>"},
            {name: "code", title: "<spring:message code="code"/>"}
        ],
        fetchDataURL: departmentUrl + "/organ-segment-iscList/moavenat"
    });

    var RestDataSource_class_affairs_List = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>"},
            {name: "code", title: "<spring:message code="code"/>"}
        ],
        fetchDataURL: departmentUrl + "/organ-segment-iscList/omor"
    });

    var RestDataSource_intraOrganizational_Holding_Class_Type_List = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>"},
            {name: "code", title: "<spring:message code="code"/>"}
        ],
        fetchDataURL: parameterValueUrl + "/listByCode/intraOrganizationalHoldingClassType"
    });

    var RestDataSource_InTheCountryExtraOrganizational_Holding_Class_Type_List = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>"},
            {name: "code", title: "<spring:message code="code"/>"}
        ],
        fetchDataURL: parameterValueUrl + "/listByCode/InTheCountryExtraOrganizationalHoldingClassType"
    });

    var RestDataSource_AbroadExtraOrganizational_Holding_Class_Type_List = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>"},
            {name: "code", title: "<spring:message code="code"/>"}
        ],
        fetchDataURL: parameterValueUrl + "/listByCode/AbroadExtraOrganizationalHoldingClassType"
    });

    var RestDataSource_Target_Population_List = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>"},
            {name: "code", title: "<spring:message code="code"/>"}
        ],
        fetchDataURL: parameterValueUrl + "/listByCode/TargetPopulation"
    });

    var RestDataSource_TrainingPlace_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "instituteId"},
            {name: "instituteTitleFa", title: "نام موسسه"},
            {name: "titleFa", title: "نام مکان"},
            {name: "capacity", title: "ظرفیت"}
        ],
    });

    var RestDataSource_ClassCancel_JSPClass = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        fetchDataURL: parameterValueUrl + "/listByCode/RCC"
    });

    let SupervisorDS_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", filterOperator: "equals", primaryKey: true, hidden: true},
            {name: "fullName", title: "نام و نام خانوادگی", filterOperator: "iContains"},
            {
                name: "nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                autoFitWidthApproach: "both"
            },
            {
                name: "personnelNo",
                title: "<spring:message code="personnel.no"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                autoFitWidthApproach: "both"
            },
            {
                name: "personnelNo2",
                title: "<spring:message code="personnel.no.6.digits"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                autoFitWidthApproach: "both"
            },
        ],
        fetchDataURL: viewActivePersonnelUrl + "/iscList",
    });

    let PlannerDS_JspClass = isc.TrDS.create({
        fields: [
            {name: "id", filterOperator: "equals", primaryKey: true, hidden: true},
            {name: "fullName", title: "نام و نام خانوادگی", filterOperator: "iContains"},
            {
                name: "nationalCode",
                title: "<spring:message code="national.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                autoFitWidthApproach: "both"
            },
            {
                name: "personnelNo",
                title: "<spring:message code="personnel.no"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                autoFitWidthApproach: "both"
            },
            {
                name: "personnelNo2",
                title: "<spring:message code="personnel.no.6.digits"/>",
                filterOperator: "iContains",
                autoFitWidth: true,
                autoFitWidthApproach: "both"
            },
        ],
        fetchDataURL: viewActivePersonnelUrl + "/iscList",
    });

    let RestDataSource_Department_Filter = isc.TrDS.create({
        fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/organ-segment-iscList/mojtame"
    });
    //--------------------------------------------------------------------------------------------------------------------//
    /*Menu*/
    //--------------------------------------------------------------------------------------------------------------------//
    var Menu_ListGrid_Class_JspClass = isc.Menu.create({
        data: [
            <sec:authorize access="hasAuthority('Tclass_R')">
            {
                title: "<spring:message code='refresh'/>",
                click: function () {
                    ListGrid_Class_refresh();
                }
            },
            </sec:authorize>

            <sec:authorize access="hasAuthority('Tclass_C')">
            {
                title: "<spring:message code='create'/>",
                click: function () {
                    IButton_Class_Save_JspClass.show();
                    ListGrid_Class_add();
                }
            },
            </sec:authorize>

            <sec:authorize access="hasAuthority('Tclass_U')">
            {
                title: "<spring:message code='edit'/>",
                click: function () {
                    ListGrid_class_edit();
                }
            },
            </sec:authorize>
            {
                title: "لغو کلاس",
                click: function () {
                    cancelClass_JspClass(ListGrid_Class_JspClass.getSelectedRecord())
                }
            },
            {
                title: "جایگزین کلاس های",
                click: function () {
                    alternativeClass_JspClass(ListGrid_Class_JspClass.getSelectedRecord())
                }
            },

            <sec:authorize access="hasAuthority('Tclass_D')">
            {
                title: "<spring:message code='remove'/>",
                click: function () {
                    ListGrid_class_remove();
                }
            },
            </sec:authorize>
            <sec:authorize access="hasAnyAuthority('Tclass_C','Tclass_R','Tclass_U','Tclass_D')">
            {isSeparator: true},
            </sec:authorize>

            <sec:authorize access="hasAuthority('Tclass_P')">
            {
                title: "<spring:message code='print.pdf'/>",
                click: function () {
                    ListGrid_class_print("pdf");
                }
            }, {
                title: "<spring:message code='print.excel'/>",
                click: function () {
                    ListGrid_class_print("excel");
                }
            }, {
                title: "<spring:message code='print.html'/>",
                click: function () {
                    ListGrid_class_print("html");
                }
            },
            </sec:authorize>
            {isSeparator: true},
            {
                title: "<spring:message code='class.history'/>",
                click: function () {
                    let record = JSON.parse(JSON.stringify(ListGrid_Class_JspClass.getSelectedRecord()));
                    if (record == null || record.id == null) {
                        createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                    } else {
                         if (mainTabSet.getTab("تغییرات کلاس") != null)
                             mainTabSet.removeTab("تغییرات کلاس")
                             createTab(this.title, "<spring:url value="web/classHistoryReport"/>");}

                }
            }
        ]
    });
    //--------------------------------------------------------------------------------------------------------------------//
    /*ListGrid*/
    //--------------------------------------------------------------------------------------------------------------------//
    var ListGrid_Class_JspClass = isc.TrLG.create({
        width: "100%",
        height: "100%",
        <sec:authorize access="hasAuthority('Tclass_R')">
        dataSource: RestDataSource_Class_JspClass,
        </sec:authorize>
        contextMenu: Menu_ListGrid_Class_JspClass,
        dataPageSize: 15,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        showRollOver:false,
        selectionType: "single",
        autoFetchData: false,
        initialSort: [
            {property: "startDate", direction: "descending", primarySort: true}
        ],
        selectionUpdated: function (record) {

            ToolStrip_SendForms_JspClass.getField("sendButtonTraining").showIcon("ok");
            ToolStrip_SendForms_JspClass.getField("registerButtonTraining").showIcon("ok");
            if(record) {
                if (record.evaluationStatusReactionTraining === "0" || record.evaluationStatusReactionTraining === 0 || record.evaluationStatusReactionTraining == null) {
                    ToolStrip_SendForms_JspClass.getField("sendButtonTraining").hideIcon("ok");
                    ToolStrip_SendForms_JspClass.getField("registerButtonTraining").hideIcon("ok");
                } else {
                    if (record.evaluationStatusReactionTraining === "2" || record.evaluationStatusReactionTraining === 2 ||
                        record.evaluationStatusReactionTraining === "3" || record.evaluationStatusReactionTraining === 3) {
                        ToolStrip_SendForms_JspClass.getField("sendButtonTraining").showIcon("ok");
                        ToolStrip_SendForms_JspClass.getField("registerButtonTraining").showIcon("ok");
                    }
                    else {
                        ToolStrip_SendForms_JspClass.getField("sendButtonTraining").showIcon("ok");
                        ToolStrip_SendForms_JspClass.getField("registerButtonTraining").hideIcon("ok");
                    }
                }
            }
            refreshSelectedTab_class(tabSetClass.getSelectedTab());
        },
        <sec:authorize access="hasAuthority('Tclass_U')">
        doubleClick: function () {
            ListGrid_class_edit();
        },
        </sec:authorize>
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
        ],
        getCellCSSText: function (record, rowNum, colNum) {
            let style;
            if (this.isSelected(record)) {
                style =  "background-color:" + "#fe9d2a;";
            } else if (record.workflowEndingStatusCode === 2) {
                style =  "background-color:" + "#bef5b8;";
            } else {
                if (record.classStatus === "1")
                    style =  "background-color:" + "#ffffff;";
                else if (record.classStatus === "2")
                    style =  "background-color:" + "#fff9c4;";
                else if (record.classStatus === "3")
                    style =  "background-color:" + "#cdedf5;";
                else if (record.classStatus === "4")
                    style =  "color:" + "#d6d6d7;";
            }
            if (this.getFieldName(colNum) == "teacher") {
                style +=  "color: #0066cc;text-decoration: underline !important;cursor: pointer !important;}"
            }
            return style;
        },
        cellClick: function (record, rowNum, colNum) {
            if (this.getFieldName(colNum) == "teacher") {
                ListGrid_teacher_edit(record.teacherId,"class")
            }
        },
        dataArrived: function () {
            wait.close();
            selectWorkflowRecord();
        },
        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);
            if (fieldName == "sendClassToOnlineBtn") {
                let sendBtn = isc.IButton.create({
                    layoutAlign: "center",
                    disabled: (record.classToOnlineStatus == true) || (record.classStatus === "1"),
                    title: "ارسال به آزمون آنلاین",
                    width: "145",
                    margin: 3,
                    click: function () {
                        sendClassToOnline(record.id)
                    }
                });
                return sendBtn;
            } else {
                return null;
            }
        }
    });
    var VM_JspClass = isc.ValuesManager.create({
        validate: function () {
            let place = DynamicForm_Class_JspClass.getField("trainingPlaceIds").validate();
            let targets = DynamicForm_Class_JspClass.getField("targetSocieties").validate();
            if (place && targets)
                return this.Super("validate", arguments);
            return false;
        }
    });
    //--------------------------------------------------------------------------------------------------------------------//
    /*DynamicForm Add Or Edit*/
    //--------------------------------------------------------------------------------------------------------------------//
    var DynamicForm_Class_JspClass = isc.DynamicForm.create({
        validateOnExit: true,
        height: "100%",
        readOnlyDisplay: "readOnly",
        wrapItemTitles: true,
        isGroup: true,
        groupTitle: "اطلاعات پایه کلاس",
        groupBorderCSS: "1px solid lightBlue",
        borderRadius: "6px",
        titleAlign: "left",
        numCols: 10,
        itemHoverWidth: "20%",
        styleName: "teacher-form",
        colWidths: ["5%", "18%", "5%", "11%", "5%", "5%", "6%", "8%", "7%", "8%"],
        padding: 10,
        valuesManager: "VM_JspClass",
        fields: [
            {name: "id", hidden: true},
            {name: "course.theoryDuration", hidden: true},
            {
                name: "course.id", editorType: "ComboBoxItem", title: "<spring:message code='course'/>:",
                textAlign: "center",
                pickListWidth: "600",
                validateOnChange: true,
                validateOnExit: true,
                optionDataSource: RestDataSource_Course_JspClass,
                canEdit: false,
                autoFetchData: false,
                displayField: "titleFa", valueField: "id",
                filterFields: ["titleFa", "code", "createdBy"],
                required: true,
                pickListFields: [
                    {name: "code", autoFitWidth: true},
                    {name: "titleFa", autoFitWidth: true},
                    {name: "createdBy"}
                ],
                changed: function (form, item) {
                    form.getItem("startEvaluation").setDisabled(false);
                    form.setValue("titleClass", item.getSelectedRecord().titleFa);
                    form.setValue("scoringMethod", item.getSelectedRecord().scoringMethod);

                    if (item.getSelectedRecord().evaluation != null) {
                        form.setValue("evaluation", item.getSelectedRecord().evaluation);
                        if (item.getSelectedRecord().evaluation === "3") {
                            DynamicForm_Class_JspClass.getItem("startEvaluation").required = true;
                            DynamicForm_Class_JspClass.getItem("behavioralLevel").setDisabled(false);
                            DynamicForm_Class_JspClass.getItem("startEvaluation").setDisabled(false);
                            DynamicForm_Class_JspClass.getItem("startEvaluation").enable();
                            if (item.getSelectedRecord().startEvaluation != null) {
                                form.setValue("startEvaluation", item.getSelectedRecord().startEvaluation)
                            } else {
                                form.getItem("startEvaluation").setValue()
                            }
                            if (item.getSelectedRecord().behavioralLevel != null) {
                                form.setValue("behavioralLevel", item.getSelectedRecord().behavioralLevel)
                            } else {
                                form.getItem("behavioralLevel").setValue()
                            }
                        } else {
                            DynamicForm_Class_JspClass.getItem("startEvaluation").required = false;
                            DynamicForm_Class_JspClass.getItem("behavioralLevel").setDisabled(true);
                            DynamicForm_Class_JspClass.getItem("startEvaluation").setDisabled(true);
                            DynamicForm_Class_JspClass.getItem("startEvaluation").setValue();
                            DynamicForm_Class_JspClass.getItem("behavioralLevel").setValue();
                        }
                    } else {
                        form.getItem("evaluation").setValue()
                    }
                    //==============
                    DynamicForm_Class_JspClass.getItem("scoringMethod").change(DynamicForm_Class_JspClass, DynamicForm_Class_JspClass.getItem("scoringMethod"), DynamicForm_Class_JspClass.getValue("scoringMethod"));
                    if (item.getSelectedRecord().scoringMethod == "1") {
                        form.setValue("acceptancelimit_a", item.getSelectedRecord().acceptancelimit);
                    } else {
                        form.setValue("acceptancelimit", item.getSelectedRecord().acceptancelimit);
                    }
                    //==================
                    form.clearValue("teacherId");
                    evalGroup();
                    if (VM_JspClass.getField("course.id").getSelectedRecord().categoryId != undefined) {
                        RestDataSource_Teacher_JspClass.fetchDataURL = teacherUrl + "fullName-list/" + VM_JspClass.getField("course.id").getSelectedRecord().categoryId;
                        RestDataSource_Teacher_JspClass.invalidateCache();
                        form.getItem("teacherId").fetchData();
                    }
                    form.setValue("hduration", item.getSelectedRecord().theoryDuration);
                    form.setValue("course.theoryDuration", item.getSelectedRecord().theoryDuration);
                    form.clearFieldErrors("hduration", true);
                    if (item.getSelectedRecord().evaluation === "1") {
                        form.setValue("preCourseTest", false);
                        form.getItem("preCourseTest").hide();
                    } else
                        form.getItem("preCourseTest").show();
                },
                click: function (form) {
                    Window_AddCourse_JspClass.show();
                }
            },
            {
                name: "holdingClassTypeId",
                editorType: "ComboBoxItem",
                title: "<spring:message code="course_eruntype"/>:",
                pickListWidth: 200,
                optionDataSource: RestDataSource_Holding_Class_Type_List,
                displayField: "title",
                autoFetchData: true,
                valueField: "id",
                textAlign: "center",
                required: true,
                textMatchStyle: "substring",
                pickListFields: [
                    {name: "title", autoFitWidth: true, autoFitWidthApproach: true},
                ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                },
                changed: function (form, item, value) {
                    DynamicForm_Class_JspClass.getItem("teachingMethodId").setOptionDataSource(null);
                    DynamicForm_Class_JspClass.getItem("teachingMethodId").setValue(null);
                    DynamicForm_Class_JspClass.getItem("teachingMethodId").enable();
                    switch (item.getSelectedRecord().code) {
                        case "intraOrganizational":
                            DynamicForm_Class_JspClass.getItem("teachingMethodId").setOptionDataSource(RestDataSource_intraOrganizational_Holding_Class_Type_List);
                            break;
                        case "InTheCountryExtraOrganizational":
                            DynamicForm_Class_JspClass.getItem("teachingMethodId").setOptionDataSource(RestDataSource_InTheCountryExtraOrganizational_Holding_Class_Type_List);
                            break;
                        case "AbroadExtraOrganizational":
                            DynamicForm_Class_JspClass.getItem("teachingMethodId").setOptionDataSource(RestDataSource_AbroadExtraOrganizational_Holding_Class_Type_List);
                            break;
                    }
                },
            },
            {
                name: "minCapacity",
                title: "<spring:message code='capacity'/>:",
                textAlign: "center",
                hint: "حداقل نفر",
                showHintInField: true,
                keyPressFilter: "[0-9]",
                blur(form, item) {
                    if (form.getValue("maxCapacity") !== null && parseInt(form.getValue(item)) > parseInt(form.getValue("maxCapacity"))) {
                        createDialog("info", "مقدار فیلد حداقل ظرفیت باید کوچکتر یا مساوی مقدار فیلد حداکثر ظرفیت باشد")
                        item.setValue("");
                    }
                }
            },
            {
                name: "maxCapacity",
                colSpan: 1,
                showTitle: false,
                hint: "حداکثر نفر",
                textAlign: "center",
                showHintInField: true,
                keyPressFilter: "[0-9]",
                blur(form, item) {
                    if (form.getValue("minCapacity") !== null && parseInt(form.getValue(item)) < parseInt(form.getValue("minCapacity"))) {
                        createDialog("info", "مقدار فیلد حداقل ظرفیت باید کوچکتر یا مساوی مقدار فیلد حداکثر ظرفیت باشد")
                        item.setValue("");
                    }
                }
            },
            {
                name: "code",
                title: "<spring:message code='class.code'/>:",
                colSpan: 2,
                textAlign: "center",
                readOnlyHover: "به منظور تولید اتوماتیک کد کلاس، باید حتماً اطلاعات فیلدهای دوره و ترم تکمیل شده باشند.",
                canEdit: false,
            },
            {
                name: "titleClass",
                textAlign: "center",
                required: true,
                title: "<spring:message code='class.title'/>:",
                wrapTitle: true,
                changed: function (_1, _2, _3) {
                    convertEn2Fa(_1, _2, _3, ["+", "*", "/"]);
                }
            },
            {
                name: "teachingMethodId",
                editorType: "ComboBoxItem",
                title: "<spring:message code='teaching.type'/>:",
                colSpan: 1,
                rowSpan: 3,
                pickListWidth: 200,
                displayField: "title",
                autoFetchData: true,
                valueField: "id",
                textAlign: "center",
                required: true,
                textMatchStyle: "substring",
                pickListFields: [
                    {name: "title", autoFitWidth: true, autoFitWidthApproach: true}
                ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                }
            },
            {
                name: "topology",
                colSpan: 1,
                rowSpan: 3,
                title: "<spring:message code='place.shape'/>:",
                type: "radioGroup",
                fillHorizontalSpace: true,
                defaultValue: "2",
                valueMap: {
                    "1": "U شکل",
                    "2": "عادی",
                    "3": "مدور",
                    "4": "سالن"
                }
            },
            {
                name: "targetPopulationTypeId",
                editorType: "ComboBoxItem",
                <%--title: "<spring:message code="executer"/>:",--%>
                title: "دوره ویژه ی:",
                colSpan: 1,
                pickListWidth: 200,
                optionDataSource: RestDataSource_Target_Population_List,
                displayField: "title",
                autoFetchData: false,
                valueField: "id",
                textAlign: "center",
                required: true,
                textMatchStyle: "substring",
                pickListFields: [
                    {name: "title", autoFitWidth: true, autoFitWidthApproach: true}
                    ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                }
            },
            {
                name: "hduration",
                colSpan: 1,
                formatOnBlur: true,
                title: "<spring:message code='duration'/>:",
                textAlign: "Right",
                type: "StaticTextItem",
                required: true,
                keyPressFilter: "[0-9.]",
                mapValueToDisplay: function (value) {
                    if (!isNaN(value)) {
                        return value + " ساعت ";
                    } else
                        return "";
                },
                click: function (form, item) {
                    if (form.getValue("course.id")) {
                        return true;
                    } else {
                        dialogDuration = isc.MyOkDialog.create({
                            message: "ابتدا دوره را انتخاب کنید",
                        });
                        dialogDuration.addProperties({
                            buttonClick: function () {
                                this.close();
                            }
                        });
                    }
                },
                editorExit: function (form, item, value) {
                    var courseDuration = 0;
                    var valueDuration = 0;
                    if (value != undefined && form.getValue("course.theoryDuration") != undefined) {
                        courseDuration = parseInt(form.getValue("course.theoryDuration"));
                        valueDuration = parseInt(value);
                        if (courseDuration >= valueDuration) {
                            form.clearFieldErrors("hduration", true);
                        } else {
                            form.addFieldErrors("hduration", "<spring:message code='msg.class.greater.duration'/>", true);
                        }
                    }
                }
            },
            {
                name: "teacherId",
                title: "<spring:message code='trainer'/>:",
                textAlign: "center",
                type: "ComboBoxItem",
                multiple: false,
                pickListWidth: 450,
                displayField: "fullNameFa",
                valueField: "id",
                autoFetchData: false,
                required: true,
                useClientFiltering: true,
                optionDataSource: RestDataSource_Teacher_JspClass,
                pickListFields: [
                    {
                        name: "personality.lastNameFa",
                        title: "<spring:message code='lastName'/>",
                        titleAlign: "center",
                        filterOperator: "iContains",
                    },
                    {
                        name: "personality.firstNameFa",
                        title: "<spring:message code='firstName'/>",
                        titleAlign: "center", filterOperator: "iContains"
                    },
                    {
                        name: "personality.nationalCode",
                        title: "<spring:message code='national.code'/>",
                        titleAlign: "center",
                        autoFitWidth: true,
                        filterOperator: "iContains"
                    },
                    {
                        name: "grade",
                        title: "<spring:message code='students.to.teacher.grade'/>",
                        titleAlign: "center",
                        filterOperator: "iContains",
                    },
                ],
                icons: [{
                    src: "<spring:url value="history.png"/>",
                    prompt: "سوابق تدریس در شرکت مس",
                    click() {
                        if (DynamicForm_Class_JspClass.getValue("teacherId") == undefined) {
                            return;
                        }
                        RestDataSource_StudentGradeToTeacher_JspClass.fetchDataURL = teacherUrl + "all-students-grade-to-teacher?teacherId=" + DynamicForm_Class_JspClass.getValue("teacherId") + "&courseId=" + DynamicForm_Class_JspClass.getValue("course.id");
                        Window_MoreInformation_JspClass.show();
                        ListGrid_AllStudentsGradeToTeacher_JspClass.invalidateCache();
                        ListGrid_AllStudentsGradeToTeacher_JspClass.fetchData();
                    }
                }],
                iconWidth: 50,
                iconHeight: 24,

                filterFields: [
                    "personality.lastNameFa",
                    "personality.firstNameFa",
                    "personality.nationalCode"
                ],
                sortField: ["personality.firstNameFa"],
                sortDirection: "ascending",
                click: function (form, item) {
                    if (form.getValue("course.id")) {
                        RestDataSource_Teacher_JspClass.fetchDataURL = courseUrl + "get_teachers/" + form.getValue("course.id") + "/0";
                        RestDataSource_Teacher_JspClass.invalidateCache();
                        item.fetchData();
                    } else {
                        RestDataSource_Teacher_JspClass.fetchDataURL = courseUrl + "get_teachers/0/0";
                        RestDataSource_Teacher_JspClass.invalidateCache();
                        item.fetchData();
                        dialogTeacher = isc.MyOkDialog.create({
                            message: "ابتدا دوره را انتخاب کنید",
                        });
                        dialogTeacher.addProperties({
                            buttonClick: function () {
                                this.close();
                                form.getItem("course.id").selectValue();
                            }
                        });
                    }
                }
            },
            {
                name: "supervisorId",
                colSpan: 3,
                required: true,
                title: "<spring:message code="supervisor"/>:",
                type: "SelectItem",
                textAlign: "center",
                optionDataSource: SupervisorDS_JspClass,
                autoFetchData: false,
                valueField: "id",
                pickListWidth: 500,
                pickListFields: [{name: "personnelNo2"}, {name: "fullName"}, {name: "nationalCode"}, {name: "personnelNo"}],
                pickListProperties: {sortField: "personnelNo2", showFilterEditor: true},
                formatValue: function (value, record, form, item) {
                    let selectedRecord = item.getSelectedRecord();
                    if (selectedRecord != null) {
                        return selectedRecord.firstName + " " + selectedRecord.lastName;
                    } else {
                        return value;
                    }
                }
            },
            {
                name: "plannerId",
                colSpan: 1,
                required: true,
                wrapTitle: false,
                title: "<spring:message code="planner"/>:",
                type: "SelectItem",
                textAlign: "center",
                optionDataSource: PlannerDS_JspClass,
                autoFetchData: false,
                valueField: "id",
                pickListWidth: 500,
                pickListFields: [{name: "personnelNo2"}, {name: "fullName"}, {name: "nationalCode"}, {name: "personnelNo"}],
                pickListProperties: {sortField: "personnelNo2", showFilterEditor: true},
                formatValue: function (value, record, form, item) {
                    let selectedRecord = item.getSelectedRecord();
                    if (selectedRecord != null) {
                        return selectedRecord.firstName + " " + selectedRecord.lastName;
                    } else {
                        return value;
                    }
                }
            },
            {
                name: "reason",
                colSpan: 1,
                textAlign: "center",
                wrapTitle: true,
                title: "<spring:message code="training.request"/>:",
                type: "ComboBoxItem",
                valueMap: {
                    "1": "نیازسنجی",
                    "2": "درخواست واحد",
                    "3": "نیاز موردی",
                },
                pickListProperties: {
                    showFilterEditor: false
                },
                sortField: 0,
                textMatchStyle: "substring",
            },
            {
                name: "group",
                title: "<spring:message code="group"/>:",
                colSpan: 1,
                readOnlyHover: "به منظور تولید اتوماتیک گروه باید حتماً اطلاعات فیلدهای دوره و ترم تکمیل شده باشند.",
                canEdit: false,
                textAlign: "center",
            },
            {
                name: "organizerId", editorType: "TrComboAutoRefresh", title: "<spring:message code="executer"/>:",
                colSpan: 1,
                pickListWidth: 500,
                optionDataSource: RestDataSource_Institute_JspClass,
                displayField: "titleFa", valueField: "id",
                textAlign: "center",
                filterFields: ["titleFa", "titleFa"],
                required: true,
                textMatchStyle: "substring",
                pickListFields: [
                    {name: "titleFa", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: true},
                    {name: "manager.firstNameFa", filterOperator: "iContains"},
                    {name: "manager.lastNameFa", filterOperator: "iContains"}
                ],
                changed: function (form, item, value) {
                    if (form.getValue("instituteId") == null) {
                        form.setValue("instituteId", value);
                    }
                },
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                }
            },
            {
                name: "instituteId",
                editorType: "TrComboAutoRefresh",
                title: "<spring:message code="training.place"/>:",
                colSpan: 1,
                optionDataSource: RestDataSource_Institute_JspClass,
                displayField: "titleFa",
                valueField: "id",
                textAlign: "center",
                filterFields: ["titleFa", "titleFa"],
                required: true,
                showHintInField: true,
                hint: "موسسه",
                pickListWidth: 500,
                textMatchStyle: "substring",
                pickListFields: [
                    {name: "titleFa", filterOperator: "iContains"},
                    {name: "manager.firstNameFa", filterOperator: "iContains"},
                    {name: "manager.lastNameFa", filterOperator: "iContains"}
                ],
                changed: function (form, item) {
                    form.clearValue("trainingPlaceIds");
                },
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                }
            },
            {
                name: "trainingPlaceIds",
                editorType: "SelectItem",
                title: "<spring:message code="training.place"/>:",
                required: true,
                showHintInField: true,
                hint: "مکان",
                autoFetchData: false,
                multiple: true,
                pickListWidth: 250,
                colSpan: 2,
                showTitle: false,
                optionDataSource: RestDataSource_TrainingPlace_JspClass,
                displayField: "titleFa",
                valueField: "id",
                filterFields: ["titleFa", "capacity"],
                textMatchStyle: "substring",
                textAlign: "center",
                pickListFields: [
                    {name: "titleFa"},
                    {name: "capacity", width: "62"}
                ],
                pickListProperties: {
                    sortField: 1, showFilterEditor: true
                },
                click: function (form, item) {
                    if (form.getValue("instituteId")) {
                        RestDataSource_TrainingPlace_JspClass.fetchDataURL = instituteUrl + form.getValue("instituteId") + "/trainingPlaces";
                        item.fetchData();
                    } else {
                        RestDataSource_TrainingPlace_JspClass.fetchDataURL = instituteUrl + "0/trainingPlaces";
                        item.fetchData();
                        isc.MyOkDialog.create({
                            message: "ابتدا برگزار کننده را انتخاب کنید",
                        });
                        form.getItem("instituteId").selectValue();
                    }
                },
            },
            {
                name: "scoringMethod",
                colSpan: 1,
                required: true,
                title: "روش نمره دهی",
                textAlign: "center",
                valueMap: {
                    "1": "ارزشی",
                    "2": "نمره از صد",
                    "3": "نمره از بیست",
                    "4": "بدون نمره",
                },
                type: "ComboBoxItem",
                pickListProperties: {
                    showFilterEditor: false
                },
                sortField: 0,
                textMatchStyle: "substring",
                changed: function () {
                },
                change: function (form, item, value) {
                    if (value == "1") {
                        form.getItem("acceptancelimit").validators = [{}];
                        form.getItem("acceptancelimit").hide();
                        form.getItem("acceptancelimit").setValue();
                        form.getItem("acceptancelimit_a").show();
                        form.getItem("acceptancelimit_a").enable();
                        form.getItem("acceptancelimit_a").setRequired(true);
                        form.getItem("acceptancelimit_a").setDisabled(false);
                    } else if (value == "2") {
                        form.getItem("acceptancelimit").validators = [{
                            type: "integerRange", min: 0, max: 100,
                            errorMessage: "لطفا یک عدد بین 0 تا 100 وارد کنید",
                        }, {
                            type: "required", errorMessage: "نمره را وارد کنید",
                        }]
                        form.getItem("acceptancelimit").show();
                        form.getItem("acceptancelimit").enable();
                        form.getItem("acceptancelimit").setRequired(true);
                        form.getItem("acceptancelimit_a").hide();
                        form.getItem("acceptancelimit_a").setValue();
                        form.getItem("acceptancelimit_a").setRequired(false);
                        form.getItem("acceptancelimit").setDisabled(false);
                    } else if (value == "3") {
                        form.getItem("acceptancelimit").validators = [{
                            type: "regexp",
                            errorMessage: "<spring:message code="msg.validate.score"/>",
                            expression: /^((([0-9]|1[0-9])([.][0-9][0-9]?)?)[20]?)$/,
                        }, {type: "required"}];
                        form.getItem("acceptancelimit").show();
                        form.getItem("acceptancelimit").enable();
                        form.getItem("acceptancelimit").setRequired(true);
                        form.getItem("acceptancelimit_a").hide();
                        form.getItem("acceptancelimit_a").setValue();
                        form.getItem("acceptancelimit_a").setRequired(false);
                        form.getItem("acceptancelimit").setDisabled(false);

                    } else if (value == "4") {
                        form.getItem("acceptancelimit").show();
                        form.getItem("acceptancelimit").setValue();
                        form.getItem("acceptancelimit").setRequired(false);
                        form.getItem("acceptancelimit").setDisabled(true);
                        form.getItem("acceptancelimit_a").hide();
                        form.getItem("acceptancelimit_a").setValue();
                        form.getItem("acceptancelimit_a").setRequired(false);
                    }
                    if (classMethod === "PUT") {
                        let record = ListGrid_Class_JspClass.getSelectedRecord();
                        isc.RPCManager.sendRequest(TrDSRequest(tclassStudentUrl + "/getScoreState/" + record.id, "GET", null, "callback: GetScoreState(rpcResponse)"));
                    }
                },
            },
            {
                name: "acceptancelimit",
                title: "حد نمره قبولی",
                textAlign: "center",
                required: true,
            },
            {
                name: "acceptancelimit_a",
                colSpan: 1,
                required: true,
                hidden: true,
                textAlign: "center",
                title: "حد نمره قبولی",
                valueMap: {
                    "1001": "ضعیف",
                    "1002": "متوسط",
                    "1003": "خوب",
                    "1004": "خيلي خوب",
                }
            },
            {
                ID: "targetSocietyTypeId",
                name: "targetSocietyTypeId",
                colSpan: 1,
                rowSpan: 1,
                title: "نوع جامعه هدف :",
                wrapTitle: false,
                type: "radioGroup",
                vertical: false,
                fillHorizontalSpace: true,
                defaultValue: "372",
                valueMap: {
                    "371": "واحد",
                    "372": "سایر",
                },
                change: function (form, item, value, oldValue) {
                    if (value === "371") {
                        var selectedSocieties = [];
                        DataSource_TargetSociety_List.testData.forEach(function (currentValue, index, arr) {
                            DataSource_TargetSociety_List.removeData(currentValue)
                        });
                        form.getItem("targetSocieties").valueField = "societyId";
                        form.getItem("targetSocieties").clearValue();
                        singleTargetScoiety.forEach(function (currentValue, index, arr) {
                            DataSource_TargetSociety_List.addData({societyId: currentValue.societyId, title: currentValue.title});
                            selectedSocieties.add(currentValue.societyId);
                        });
                        DynamicForm_Class_JspClass.getItem("targetSocieties").setValue(selectedSocieties);
                    } else if (value === "372") {
                        DataSource_TargetSociety_List.testData.forEach(function (currentValue, index, arr) {
                            DataSource_TargetSociety_List.removeData(currentValue)
                        });
                        form.getItem("targetSocieties").valueField = "title";
                        form.getItem("targetSocieties").clearValue();
                        etcTargetSociety.forEach(function (currentValue, index, arr) {
                            DataSource_TargetSociety_List.addData({societyId: index, title: currentValue});
                        });
                        DynamicForm_Class_JspClass.getItem("targetSocieties").setValue(etcTargetSociety);
                    } else
                        return false;
                }
            },
            {
                name: "targetSocieties",
                colSpan: 2,
                rowSpan: 1,
                required: true,
                type: "SelectItem",
                pickListProperties: {
                    showFilterEditor: false
                },
                multiple: true,
                hidden: false,
                textAlign: "center",
                title: "انتخاب جامعه هدف:",
                wrapTitle: false,
                optionDataSource: DataSource_TargetSociety_List,
                displayField: "title",
                valueField: "societyId",
                defaultValue: "سایر",
            },
            {
                name: "addtargetSociety",
                title: "افزودن",
                type: "button",
                colSpan: 1,
                hidden: false,//true
                endRow: false, startRow: false,
                i: 0,
                click: function () {
                    if (DynamicForm_Class_JspClass.getItem("targetSocietyTypeId").getValue() === "372") {
                        isc.askForValue("لطفا جامعه هدف مورد نظر را وارد کنید",
                            function (value) {
                                if (value !== "" && value !== null && value !== undefined) {
                                    const found = etcTargetSociety.some(st => st === value);
                                    if(!found){
                                    DataSource_TargetSociety_List.addData({societyId: i, title: value});
                                    etcTargetSociety.add(value);
                                    DynamicForm_Class_JspClass.getItem("targetSocieties").setValue(etcTargetSociety);
                                    i += 1;
                                    }
                                }
                            });
                    } else if (DynamicForm_Class_JspClass.getItem("targetSocietyTypeId").getValue() === "371") {
                        showOrganizationalChart(setSocieties);
                    }
                }
            },
            {
                ID: "classTypeStatus",
                name: "classStatus",
                colSpan: 1,
                rowSpan: 1,
                title: "<spring:message code="class.status"/>:",
                wrapTitle: true,
                type: "radioGroup",
                vertical: true,
                fillHorizontalSpace: true,
                defaultValue: "1",
                valueMap: {
                    "1": "برنامه ریزی",
                    "2": "در حال اجرا",
                    "3": "پایان یافته",
                    "5": "اختتام",
                },
                change: function (form, item, value, oldValue) {
                    highlightClassStauts(value, 10);
                    if (classMethod.localeCompare("PUT") === 0 && value === "3")
                        checkEndingClass(oldValue);
                    else if (classMethod.localeCompare("PUT") === 0 && value === "2")
                        hasClassStarted(oldValue);
                    else if (classMethod.localeCompare("POST") === 0 && (value === "3" || value === "2"))
                        return false;
                }
            },
            {
                name: "preCourseTest",
                colSpan: 1,
                type: "boolean",
                title: "<spring:message code='class.preCourseTest'/>",
                hidden: true,
            },
            //------------------------ DONE BY ROYA---------------------------------------------------------------------
            {
                name: "evaluation",
                required: true,
                title: "<spring:message code="evaluation.level"/>:",
                textAlign: "center",
                startRow: true,
                defaultValue: 1,
                width: 100,
                colSpan: 1,
                valueMap: {
                    "1": "واکنشی",
                    "2": "یادگیری",
                    "3": "رفتاری",
                    "4": "نتایج",
                },
                pickListProperties: {
                    showFilterEditor: false
                },
                change: function (form, item, value, oldValue) {
                    if (value === "2") {

                        DynamicForm_Class_JspClass.getItem("startEvaluation").required = false;
                        DynamicForm_Class_JspClass.getItem("hasTest").setDisabled(false);
                        DynamicForm_Class_JspClass.getItem("behavioralLevel").setDisabled(true);
                        DynamicForm_Class_JspClass.getItem("startEvaluation").setDisabled(true);
                        DynamicForm_Class_JspClass.getItem("startEvaluation").setValue();
                        DynamicForm_Class_JspClass.getItem("behavioralLevel").setValue();
                    } else if (value === "3") {

                        DynamicForm_Class_JspClass.getItem("startEvaluation").required = true;
                        DynamicForm_Class_JspClass.getItem("hasTest").setDisabled(true);
                        DynamicForm_Class_JspClass.getItem("hasTest").setValue(false);
                        DynamicForm_Class_JspClass.getItem("behavioralLevel").setDisabled(false);
                        DynamicForm_Class_JspClass.getItem("startEvaluation").setDisabled(false);
                        DynamicForm_Class_JspClass.getItem("startEvaluation").enable();
                        DynamicForm_Class_JspClass.getItem("startEvaluation").setValue("3");
                    } else {

                        DynamicForm_Class_JspClass.getItem("startEvaluation").required = false;
                        DynamicForm_Class_JspClass.getItem("hasTest").setDisabled(true);
                        DynamicForm_Class_JspClass.getItem("hasTest").setValue(false);
                        DynamicForm_Class_JspClass.getItem("behavioralLevel").setDisabled(true);
                        DynamicForm_Class_JspClass.getItem("startEvaluation").setDisabled(true);
                        DynamicForm_Class_JspClass.getItem("startEvaluation").setValue();
                        DynamicForm_Class_JspClass.getItem("behavioralLevel").setValue();
                    }
                }
            },
            {
                name: "hasTest",
                title: "آزمون دارد",
                required: false,
                colSpan: 1,
                type: "boolean",
                // titleOrientation: "top",
                labelAsTitle: true,
            },
            {
                name: "startEvaluation",
                title: "<spring:message code="start.evaluation"/>:",
                required: false,
                defaultValue: "",
                textAlign: "center",
                width: 60,
                colSpan: 1,
                hint: "&nbsp;ماه",
                pickListProperties: {
                    showFilterEditor: false
                },
                valueMap: {
                    1: "1",
                    2: "2",
                    3: "3",
                    4: "4",
                    5: "5",
                    6: "6",
                    7: "7",
                    8: "8",
                    9: "9",
                    10: "10",
                    11: "11",
                    12: "12"
                }
            },
            {
                name: "behavioralLevel",
                title: "<spring:message code="behavioral.Level"/>:",
                colSpan: 1,
                type: "radioGroup",
                vertical: false,
                fillHorizontalSpace: true,
                valueMap: {
                    "1": "مشاهده",
                    "2": "مصاحبه",
                    "3": "کار پروژه ای"
                }
            },
            {name: "evaluationScore",
                canEdit:false,
                title:"نمره ارزیابی مدرس کلاس: ",
                calSpan: 1,
                defaultValue: " _ ",
                type: "StaticTextItem",
            },
            {
                name: "complexId",
                editorType: "ComboBoxItem",
                title: "<spring:message code="reports.need.assessment.select.complex"/>:",
                pickListWidth: 200,
                optionDataSource: RestDataSource_class_complex_List,
                displayField: "title",
                autoFetchData: true,
                valueField: "id",
                textAlign: "center",
                required: true,
                textMatchStyle: "substring",
                pickListFields: [
                    {name: "title", autoFitWidth: true, autoFitWidthApproach: true},
                ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                },
                changed: function (form, item, value) {
                    DynamicForm_Class_JspClass.getItem("assistantId").setValue(null);
                    DynamicForm_Class_JspClass.getItem("affairsId").setValue(null);
                    DynamicForm_Class_JspClass.getItem("assistantId").enable();
                    DynamicForm_Class_JspClass.getItem("affairsId").disable();
                    let myCriteria='{"fieldName":"mojtameTitle","operator":"inSet","value":"' + form.getItem("complexId").getSelectedRecord().title + '"}';
                    RestDataSource_class_assistant_List.fetchDataURL = departmentUrl + "/organ-segment-iscList/moavenat" + "?operator=and&_constructor=AdvancedCriteria&criteria=" + myCriteria;
                    form.getItem("assistantId").fetchData();
                },
            },
            {
                name: "assistantId",
                editorType: "ComboBoxItem",
                title: "<spring:message code="reports.need.assessment.select.assistant"/>:",
                pickListWidth: 200,
                optionDataSource: RestDataSource_class_assistant_List,
                displayField: "title",
                autoFetchData: false,
                valueField: "id",
                textAlign: "center",
                required: true,
                textMatchStyle: "substring",
                pickListFields: [
                    {name: "title", autoFitWidth: true, autoFitWidthApproach: true},
                ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                },
                changed: function (form, item, value) {
                    DynamicForm_Class_JspClass.getItem("affairsId").setValue(null);
                    DynamicForm_Class_JspClass.getItem("affairsId").enable();
                    let myCriteria='{"fieldName":"moavenatTitle","operator":"inSet","value":"' + form.getItem("assistantId").getSelectedRecord().title + '"}';
                    RestDataSource_class_affairs_List.fetchDataURL = departmentUrl + "/organ-segment-iscList/omor" + "?operator=and&_constructor=AdvancedCriteria&criteria=" + myCriteria;
                    form.getItem("affairsId").fetchData();
                },
            },
            {
                name: "affairsId",
                editorType: "ComboBoxItem",
                title: "<spring:message code="reports.need.assessment.select.affairs"/>:",
                pickListWidth: 200,
                optionDataSource: RestDataSource_class_affairs_List,
                displayField: "title",
                autoFetchData: false,
                valueField: "id",
                textAlign: "center",
                required: true,
                colSpan: 2,
                rowSpan: 1,
                textMatchStyle: "substring",
                pickListFields: [
                    {name: "title", autoFitWidth: true, autoFitWidthApproach: true},
                ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                },
                // changed: function (form, item, value) {
                //
                // },
            }
            //------------------------ DONE BY ROYA---------------------------------------------------------------------
        ],
        itemChanged: function () {
            if (DynamicForm_Class_JspClass.getItem("teachingMethodId") !== null && DynamicForm_Class_JspClass.getItem("teachingMethodId") !== undefined
                    && DynamicForm_Class_JspClass.getItem("teachingMethodId").getSelectedRecord() !== null && DynamicForm_Class_JspClass.getItem("teachingMethodId").getSelectedRecord() !== undefined ){
                if (DynamicForm_Class_JspClass.getItem("teachingMethodId").getSelectedRecord().title === "غیر حضوری" ||
                    DynamicForm_Class_JspClass.getItem("teachingMethodId").getSelectedRecord().title === "مجازی") {
                    DynamicForm_Class_JspClass.getField('instituteId').setDisabled(true);
                    DynamicForm_Class_JspClass.getField('trainingPlaceIds').setDisabled(true);
                } else {
                    DynamicForm_Class_JspClass.getField('instituteId').setDisabled(false);
                    DynamicForm_Class_JspClass.getField('trainingPlaceIds').setDisabled(false);
                }
                if (DynamicForm_Class_JspClass.getItem("teachingMethodId").getSelectedRecord().title === "اعزام") {
                    DynamicForm_Class_JspClass.getItem("teacherId").setRequired(false);
                } else {
                    DynamicForm_Class_JspClass.getItem("teacherId").setRequired(true);
                }
            }
        }
    });
    var DynamicForm1_Class_JspClass = isc.DynamicForm.create({
        height: "100%",
        validateOnExit: true,
        isGroup: true,
        titleAlign: "left",
        wrapItemTitles: true,
        styleName: "teacher-form",
        groupTitle: "<spring:message code="class.meeting.time"/>",
        groupBorderCSS: "1px solid lightBlue",
        borderRadius: "6px",
        numCols: 6,
        colWidths: ["6%", "6%", "6%", "6%", "6%", "6%"],
        padding: 10,
        valuesManager: "VM_JspClass",
        fields: [
            {
                name: "termId",
                title: "<spring:message code='term'/>",
                textAlign: "center",
                required: true,
                editorType: "ComboBoxItem",
                displayField: "code",
                valueField: "id",
                optionDataSource: RestDataSource_Term_JspClass,
                filterFields: ["code"],
                sortField: ["code"],
                sortDirection: "descending",
                colSpan: 2,
                type:'number',
	            pickListFields: [
                    {
                        name: "code",
                        title: "<spring:message code='term.code'/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "startDate",
                        title: "<spring:message code='start.date'/>",
                        filterOperator: "iContains"
                    },
                    {
                        name: "endDate",
                        title: "<spring:message code='end.date'/>",
                        filterOperator: "iContains"
                    }
                ],
                click: function (form, item) {
                    item.fetchData();
                },
                changed: function (form, item, value) {
                    var termStart = form.getItem("termId").getSelectedRecord().startDate;
                    var termEnd = form.getItem("termId").getSelectedRecord().endDate;
                    form.getItem("startDate").setValue(termStart);
                    form.getItem("endDate").setValue(termEnd);
                    evalGroup();
                }
            },
            {
                type: "BlurbItem",
                value: " ",
                colSpan: 2,
            },
            {
                name: "startDate",
                titleColSpan: 1,
                title: "<spring:message code='start.date'/>",
                ID: "startDate_jspClass",
                required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        if (!(form.getValue("termId"))) {
                            dialogTeacher = isc.MyOkDialog.create({
                                message: "ابتدا ترم را انتخاب کنید",
                            });
                            dialogTeacher.addProperties({
                                buttonClick: function () {
                                    this.close();
                                    form.getItem("termId").selectValue();
                                }
                            });
                        } else {
                            closeCalendarWindow();
                            displayDatePicker('startDate_jspClass', this, 'ymd', '/');
                        }
                    }
                }],
                textAlign: "center",
                colSpan: 2,
                click: function (form) {
                    if (!(form.getValue("termId"))) {
                        dialogTeacher = isc.MyOkDialog.create({
                            message: "ابتدا ترم را انتخاب کنید",
                        });
                        dialogTeacher.addProperties({
                            buttonClick: function () {
                                this.close();
                                form.getItem("termId").selectValue();
                            }
                        });
                    }
                },
                changed: function (form, item, value) {
                    var termStart = form.getItem("termId").getSelectedRecord().startDate;
                    var termEnd = form.getItem("termId").getSelectedRecord().endDate;
                    var dateCheck;
                    var endDate = form.getValue("endDate");
                    dateCheck = checkDate(value);
                    startDateCheck = dateCheck;
                    if (dateCheck === false) {
                        form.addFieldErrors("startDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (value < termStart) {
                        form.addFieldErrors("startDate", "تاریخ انتخاب شده باید بعد از تاریخ شروع ترم باشد", true);
                    } else if (endDate < value) {
                        form.addFieldErrors("startDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    } else if (termEnd < value) {
                        form.addFieldErrors("startDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان ترم باشد", true)
                    } else {
                        form.clearFieldErrors("startDate", true);
                    }
                }
            },
            {
                name: "teachingBrand",
                title: "نحوه آموزش:",
                type: "radioGroup",
                rowSpan: 2,
                colSpan: 1,
                defaultValue: 1,
                endRow: true,
                valueMap: {
                    1: "تمام وقت",
                    2: "نیمه وقت",
                    3: "پاره وقت"
                }
            },
            {
                name: "endDate",
                titleColSpan: 1,
                title: "<spring:message code='end.date'/>",
                ID: "endDate_jspClass",
                type: 'text', required: true,
                hint: "--/--/----",
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        if (!(form.getValue("startDate"))) {
                            dialogTeacher = isc.MyOkDialog.create({
                                message: "ابتدا تاریخ شروع را انتخاب کنید",
                            });
                            dialogTeacher.addProperties({
                                buttonClick: function () {
                                    this.close();
                                    form.getItem("startDate").selectValue();
                                }
                            });
                        } else {
                            closeCalendarWindow();
                            displayDatePicker('endDate_jspClass', this, 'ymd', '/');
                        }
                    }
                }],
                textAlign: "center",
                colSpan: 2,
                click: function (form) {
                    if (!(form.getValue("startDate"))) {
                        dialogTeacher = isc.MyOkDialog.create({
                            message: "ابتدا تاریخ شروع را انتخاب کنید",
                        });
                        dialogTeacher.addProperties({
                            buttonClick: function () {
                                this.close();
                                form.getItem("startDate").selectValue();
                            }
                        });
                    }
                },
                changed: function (form, item, value) {
                    let termStart = form.getItem("termId").getSelectedRecord().startDate;
                    let dateCheck;
                    dateCheck = checkDate(value);
                    let startDate = form.getValue("startDate");
                    if (dateCheck === false) {
                        form.clearFieldErrors("endDate", true);
                        form.addFieldErrors("endDate", "<spring:message code='msg.correct.date'/>", true);
                        endDateCheck = false;
                    } else if (value < termStart) {
                        form.addFieldErrors("endDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع ترم باشد", true);
                    } else if (value < startDate) {
                        form.addFieldErrors("endDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                    } else {
                        form.clearFieldErrors("endDate", true);
                    }
                }
            },
            {
                name: "autoValid",
                type: "boolean",
                defaultValue: false,
                enabled: false,
                title: "<spring:message code='auto.session.made'/>" + " : ",
                endRow: true,
                titleOrientation: "top",
                align: "right",
                labelAsTitle: true,
                colSpan: 2,
                changed: function () {
                    weekDateActivation(this._value);
                }
            },
            {
                type: "BlurbItem",
                value: "ساعت جلسات:",
            },
            {
                name: "first",
                type: "checkbox",
                title: "8-10",
                titleOrientation: "top",
                labelAsTitle: true,
            },
            {
                name: "second",
                type: "checkbox",
                title: "10-12",
                titleOrientation: "top",
                labelAsTitle: true,
            },
            {
                name: "third",
                type: "checkbox",
                title: "14-16",
                titleOrientation: "top",
                labelAsTitle: true,
            },
            {
                name: "fourth",
                type: "checkbox",
                title: "12-14",
                titleOrientation: "top",
                labelAsTitle: true,
                changed: function (form, item, value) {
                    if (value) {
                        let dialog_Accept = createDialog("ask", "آیا از انتخاب این گزینه مطمئن هستید؟",
                            "اخطار");
                        dialog_Accept.addProperties({
                            buttonClick: function (button, index) {
                                this.close();
                                if (index === 1) {
                                    item.setValue(false);
                                }
                            }
                        });
                    }
                }
            },
            {
                name: "fifth",
                type: "checkbox",
                title: "16-18",
                titleOrientation: "top",
                labelAsTitle: true,
                changed: function (form, item, value) {
                    if (value) {
                        let dialog_Accept = createDialog("ask", "آیا از انتخاب این گزینه مطمئن هستید؟",
                            "اخطار");
                        dialog_Accept.addProperties({
                            buttonClick: function (button, index) {
                                this.close();
                                if (index === 1) {
                                    item.setValue(false);
                                }
                            }
                        });
                    }
                }
            },
            {
                type: "BlurbItem",
                value: "روزهای هفته:",
            },
            {
                name: "saturday",
                type: "checkbox",
                title: "شنبه",
                titleOrientation: "top",
                labelAsTitle: true,
            },
            {
                name: "sunday",
                type: "checkbox",
                title: "یکشنبه",
                titleOrientation: "top",
                labelAsTitle: true,
            },
            {
                name: "monday",
                type: "checkbox",
                title: "دوشنبه",
                titleOrientation: "top",
                labelAsTitle: true,
            },
            {
                name: "tuesday",
                type: "checkbox",
                title: "سه&#8202شنبه",
                titleOrientation: "top",
                labelAsTitle: true,
                endRow: true,
            },
            {
                name: "wednesday",
                type: "checkbox",
                title: "چهارشنبه",
                titleOrientation: "top",
                labelAsTitle: true,
            },
            {name: "thursday", type: "checkbox", title: "پنجشنبه", titleOrientation: "top", labelAsTitle: true},
            {name: "friday", type: "checkbox", title: "جمعه", titleOrientation: "top", labelAsTitle: true},
        ],
    });

    var IButton_Class_Exit_JspClass = isc.IButtonCancel.create({
        align: "center",
        click: function () {
            Window_Class_JspClass.close();
            DynamicForm_Class_JspClass.getItem("targetPopulationTypeId").enable();
            DynamicForm_Class_JspClass.getItem("holdingClassTypeId").enable();
        }
    });
    var IButton_Class_Save_JspClass = isc.IButtonSave.create({
        align: "center",
        click: async function () {

            if (DynamicForm_Class_JspClass.getItem("teachingMethodId") !== null && DynamicForm_Class_JspClass.getItem("teachingMethodId") !== undefined
                    && DynamicForm_Class_JspClass.getItem("teachingMethodId").getSelectedRecord() !== null && DynamicForm_Class_JspClass.getItem("teachingMethodId").getSelectedRecord() !== undefined ) {
                if (DynamicForm_Class_JspClass.getItem("teachingMethodId").getSelectedRecord().title === "غیر حضوری" ||
                    DynamicForm_Class_JspClass.getItem("teachingMethodId").getSelectedRecord().title === "مجازی") {
                    DynamicForm_Class_JspClass.getItem("instituteId").setRequired(false);
                    DynamicForm_Class_JspClass.getItem("trainingPlaceIds").setRequired(false);
                    DynamicForm_Class_JspClass.clearValue("instituteId");
                    DynamicForm_Class_JspClass.clearValue("trainingPlaceIds");
                } else {
                    DynamicForm_Class_JspClass.getItem("instituteId").setRequired(true);
                    DynamicForm_Class_JspClass.getItem("trainingPlaceIds").setRequired(true);
                }
                if (DynamicForm_Class_JspClass.getItem("teachingMethodId").getSelectedRecord().title === "اعزام") {
                    DynamicForm_Class_JspClass.getItem("teacherId").setRequired(false);
                } else {
                    DynamicForm_Class_JspClass.getItem("teacherId").setRequired(true);
                }
            }
            if (DynamicForm1_Class_JspClass.getItem("termId").getSelectedRecord() != undefined) {
                if (!checkValidDate(DynamicForm1_Class_JspClass.getItem("termId").getSelectedRecord().startDate, DynamicForm1_Class_JspClass.getItem("termId").getSelectedRecord().endDate, DynamicForm1_Class_JspClass.getValue("startDate"), DynamicForm1_Class_JspClass.getValue("endDate"))) {
                    return;
                }
            }
            autoValid = DynamicForm1_Class_JspClass.getValue("autoValid");
            if (DynamicForm1_Class_JspClass.getValue("autoValid")) {
                if (!(DynamicForm1_Class_JspClass.getValue("first") || DynamicForm1_Class_JspClass.getValue("second") || DynamicForm1_Class_JspClass.getValue("third") || DynamicForm1_Class_JspClass.getValue("fourth") || DynamicForm1_Class_JspClass.getValue("fifth"))) {
                    isc.MyOkDialog.create({
                        message: "به منظور تولید اتوماتیک جلسات حداقل یک ساعت جلسه، باید انتخاب شود.",
                    });
                    return;
                } else if (!(DynamicForm1_Class_JspClass.getValue("saturday") || DynamicForm1_Class_JspClass.getValue("sunday") || DynamicForm1_Class_JspClass.getValue("monday") ||
                    DynamicForm1_Class_JspClass.getValue("tuesday") || DynamicForm1_Class_JspClass.getValue("wednesday") || DynamicForm1_Class_JspClass.getValue("thursday") || DynamicForm1_Class_JspClass.getValue("friday"))) {
                    isc.MyOkDialog.create({
                        message: "به منظور تولید اتوماتیک جلسات باید حداقل یکی از روزهای هفته را انتخاب کنید.",
                    });
                    return;
                }
            }
            if (DynamicForm_Class_JspClass.getItem("teachingMethodId") !== null && DynamicForm_Class_JspClass.getItem("teachingMethodId") !== undefined
                && DynamicForm_Class_JspClass.getItem("teachingMethodId").getSelectedRecord() !== null && DynamicForm_Class_JspClass.getItem("teachingMethodId").getSelectedRecord() !== undefined
                && !OJT && DynamicForm_Class_JspClass.getItem("teachingMethodId").getSelectedRecord().title === "آموزش حین کار" && DynamicForm_Class_JspClass.getValue("erunType").id === 5) { // id = 5 -> "حین کار"
                let dialog_Accept = createDialog("ask", 'نوع اجرا دوره کلاس از "حین کار" می باشد، آیا مایلید که روش آموزش را نیز از نوع "آموزش حین کار " انتخاب کنید', "توجه");
                dialog_Accept.addProperties({
                    buttonClick: function (button, index) {
                        this.close();
                        if (index === 0)
                            OJT = true;
                        else
                            OJT = false;
                    }
                });
                return;
            }
            var classRecord = ListGrid_Class_JspClass.getSelectedRecord();
            VM_JspClass.validate();
            if (VM_JspClass.hasErrors()) {
                return;
            }
            if (classMethod.localeCompare("PUT") === 0) {
                let haserror = await
	                classDateHasConflictWithSession(classRecord.id, DynamicForm1_Class_JspClass.getValue("endDate"));
                if(haserror)
                    return;
            }
            let data = VM_JspClass.getValues();
            data.courseId = data.course.id;
            delete data.course;
            delete data.term;
            if (data.scoringMethod === "1") {
                data.acceptancelimit = data.acceptancelimit_a
            }
            let classSaveUrl = classUrl;
            if (classMethod.localeCompare("PUT") === 0) {
                classSaveUrl += "update/" + classRecord.id;
            } else if (classMethod.localeCompare("POST") === 0) {
                classSaveUrl += "safeCreate";
            }
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(classSaveUrl, classMethod, JSON.stringify(data), (resp) => {
                wait.close();
                let response = JSON.parse(resp.httpResponseText);
                if (response.status === 200 || response.status === 201) {
                    if (classMethod.localeCompare("POST") === 0) {
                        Training_Reaction_Form_Inssurance_JspClass(response.record);
                    }
                    if (classMethod.localeCompare("PUT") === 0) {
                        sendEndingClassToWorkflow();
                        sendToWorkflowAfterUpdate(response.record);
                    }
                    ListGrid_Class_refresh();
                    let responseID = response.record.id;
                    let gridState = "[{id:" + responseID + "}]";
                    simpleDialog("<spring:message code="message"/>", response.message, 3000, "say");
                    setTimeout(function () {
                        ListGrid_Class_JspClass.setSelectedState(gridState);
                        ListGrid_Class_JspClass.scrollToRow(ListGrid_Class_JspClass.getRecordIndex(ListGrid_Class_JspClass.getSelectedRecord()), 0);
                    }, 3000);
                    Window_Class_JspClass.close();

                    //**********generate class sessions**********
                    if (!VM_JspClass.hasErrors() && ((classMethod.localeCompare("POST") === 0) || (classMethod.localeCompare("PUT") === 0 && ListGrid_session.getData().localData.length > 0 ? false : true && VM_JspClass.getValues().autoValid))) {
                        if (autoValid) {
                            let ClassID = response.record.id;
                            wait.show();
                            isc.RPCManager.sendRequest(TrDSRequest(sessionServiceUrl + "generateSessions" + "/" + ClassID, "POST", JSON.stringify(data), (resp) => {
                                wait.close();
                                class_get_sessions_result(resp);
                            }));
                        }
                    }
                    //**********generate class sessions**********

                } else {
                    simpleDialog("<spring:message code="message"/>", response.message, "0", "error");
                }
            }));
            DynamicForm_Class_JspClass.getItem("targetPopulationTypeId").enable();
            DynamicForm_Class_JspClass.getItem("holdingClassTypeId").enable();
        }
    });
    //*****generate sessions callback*****
    function class_get_sessions_result(resp) {
        refreshSelectedTab_class(tabSetClass.getSelectedTab());
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            DynamicForm_Class_JspClass.setValue("group",JSON.parse(resp.data));
            classCode();
        } else if (resp.httpResponseCode === 407) {
            let respText = JSON.parse(resp.httpResponseText);
            let MyOkDialog_classSession = isc.MyOkDialog.create({
                title: "<spring:message code='message'/>",
                message: respText.message
            });
            setTimeout(function () {
                MyOkDialog_classSession.close();
            }, 3000);
        }
    }
    var HLayOut_ClassSaveOrExit_JspClass = isc.TrHLayoutButtons.create({
        members: [IButton_Class_Save_JspClass, IButton_Class_Exit_JspClass]
    });

    var VLayOut_FormClass_JspClass = isc.TrVLayout.create({
        margin: 10,
        members: [DynamicForm_Class_JspClass, DynamicForm1_Class_JspClass]
    });

    var Window_Class_JspClass = isc.Window.create({
        title: "<spring:message code='class'/>",
        bodyColor: "#cbeaff",
        autoCenter: false,
        showMaximizeButton: false,
        autoSize: false,
        minWidth: 1024,
        isModal: false,
        keepInParentRect: true,
        placement: "fillPanel",
        closeClick: function () {
            this.Super("closeClick", arguments);
            DynamicForm_Class_JspClass.getItem("targetPopulationTypeId").enable();
            DynamicForm_Class_JspClass.getItem("holdingClassTypeId").enable();

        },
        items: [
            isc.TrVLayout.create({
                members: [VLayOut_FormClass_JspClass, HLayOut_ClassSaveOrExit_JspClass]
            })
        ]
    });

    var Window_AddCourse_JspClass = isc.Window.create({
        title: "<spring:message code="course.plural.list"/>",
        placement: "fillScreen",
        minWidth: 1024,
        keepInParentRect: true,
        autoSize: false,
        show() {
            ListGrid_Course_JspClass.invalidateCache();
            ListGrid_Course_JspClass.fetchData();
            this.Super("show", arguments);
        },
        items: [
            isc.TrHLayout.create({
                members: [
                    isc.TrLG.create({
                        ID: "ListGrid_Course_JspClass",
                        dataSource: RestDataSource_Course_JspClass,
                        selectionType: "single",
                        filterOnKeypress: false,
                        fields: [
                            {
                                name: "code",
                                title: "<spring:message code="course.code"/>",
                                filterOperator: "iContains",
                                autoFitWidth: true
                            },
                            {
                                name: "titleFa",
                                title: "<spring:message code="course.title"/>",
                                filterOperator: "iContains",
                                autoFitWidth: true
                            },
                            {
                                name: "createdBy",
                                title: "<spring:message code="created.by.user"/>",
                                filterOperator: "iContains"
                            },
                            {
                                name: "theoryDuration",
                                title: "<spring:message code="course_Running_time"/>",
                                filterOperator: "equals",
                            },
                            {
                                name: "categoryId",
                                title: "<spring:message code="category"/> ",
                                optionDataSource: RestDataSource_category_JspCourse,
                                filterOnKeypress: true,
                                valueField: "id",
                                displayField: "titleFa",
                                filterOperator: "equals",
                            },
                            {
                                name: "subCategoryId",
                                title: "<spring:message code="subcategory"/> ",
                                optionDataSource: RestDataSource_subCategory_JspCourse,
                                filterOnKeypress: true,
                                valueField: "id",
                                displayField: "titleFa",
                                filterOperator: "equals",
                            },
                        ],
                        gridComponents: ["filterEditor", "header", "body"],
                        recordDoubleClick: function (viewer, record, recordNum, field, fieldNum, value, rawValue) {
                            DynamicForm_Class_JspClass.setValue("erunType", record.erunType);
                            DynamicForm_Class_JspClass.setValue("course.id", record.id);
                            setTimeout(function () {
                                DynamicForm_Class_JspClass.getItem("course.id").changed(DynamicForm_Class_JspClass, DynamicForm_Class_JspClass.getItem("course.id"));
                                Window_AddCourse_JspClass.close();
                            }, 1000);
                        }
                    }),
                ]
            })]
    });

    var Window_MoreInformation_JspClass = isc.Window.create({
        title: "سوابق استاد",
        width: "80%",
        height: "60%",
        keepInParentRect: true,
        autoSize: false,
        items: [
            isc.TrHLayout.create({
                members: [
                    isc.TrLG.create({
                        ID: "ListGrid_AllStudentsGradeToTeacher_JspClass",
                        dataSource: RestDataSource_StudentGradeToTeacher_JspClass,
                        selectionType: "single",
                        filterOnKeypress: true,
                        autoFetchData: true,
                        fields: [
                            {name: "titleClass", title: "<spring:message code="class.title"/>"},
                            {name: "startDate", title: "<spring:message code="start.date"/>"},
                            {name: "endDate", title: "<spring:message code="end.date"/>"},
                            {name: "code", title: "<spring:message code="class.code"/>"},
                            {name: "term", title: "<spring:message code="term"/>"},
                            {name: "grade", title: "<spring:message code="students.to.teacher.grade"/>",
                                formatCellValue(value){
                                    return value == "null" ? "-" : value;
                                }
                            }
                        ],
                        gridComponents: ["filterEditor", "header", "body"],
                    }),
                ]
            })
        ]
    });
    //--------------------------------------------------------------------------------------------------------------------//
    /*ToolStrips and Layout*/
    //--------------------------------------------------------------------------------------------------------------------//
    <sec:authorize access="hasAuthority('Tclass_R')">
    var ToolStripButton_Refresh_JspClass = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Class_refresh();
        }
    });
    </sec:authorize>

    <sec:authorize access="hasAuthority('Tclass_U')">
    var ToolStripButton_Edit_JspClass = isc.ToolStripButtonEdit.create({
        click: function () {
            ListGrid_class_edit();
        }
    });
    </sec:authorize>

    <sec:authorize access="hasAuthority('Tclass_C')">
    var ToolStripButton_Add_JspClass = isc.ToolStripButtonCreate.create({
        click: function () {
            IButton_Class_Save_JspClass.show();
            ListGrid_Class_add();
        }
    });
    </sec:authorize>

    <sec:authorize access="hasAuthority('Tclass_D')">
    var ToolStripButton_Remove_JspClass = isc.ToolStripButtonRemove.create({
        click: function () {
            ListGrid_class_remove();
        }
    });
    </sec:authorize>

    <sec:authorize access="hasAuthority('Tclass_P')">
    var ToolStripButton_Print_JspClass = isc.ToolStripButtonPrint.create({
        title: "<spring:message code='print'/>",
        click: function () {
            ListGrid_class_print("pdf");
        }
    });
    </sec:authorize>

    <sec:authorize access="hasAuthority('Tclass_C')">
    var ToolStripButton_copy_of_class = isc.ToolStripButton.create({
        title: "<spring:message code='copy.of.class'/>",
        click: function () {
            ListGrid_class_edit(1);
        }
    });
    </sec:authorize>


    var ToolStripButton_teacherEvaluation_JspClass = isc.ToolStripButton.create({
        title: "ثبت نتایج ارزیابی مسئول آموزش از مدرس کلاس",
        click: function () {
            let record = ListGrid_Class_JspClass.getSelectedRecord();
            if (record == null || record.id == null) {
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            } else {
                if (record.classStatus == null || record.classStatus == 1)
                    createDialog("info", "این کلاس در وضعیت برنامه ریزی می باشد و قابل ارزیابی نمی باشد");
                else {
                    if (record.evaluationStatusReactionTraining == null || record.evaluationStatusReactionTraining == 0)
                        createDialog("info", "برای مسئول آموزش این کلاس فرمی صادر نشده است");
                    else {
                        if (record.supervisor == undefined || record.teacherId == undefined)
                            createDialog("info", "اطلاعات کلاس ناقص است!");
                        else
                            register_Training_Reaction_Form_JspClass(record);

                    }
                }

            }
        }
    });

    var RestDataSource_Year_Filter = isc.TrDS.create({
        fields: [
            {name: "year"}
        ],
        fetchDataURL: termUrl + "years",
        autoFetchData: true
    });

    var RestDataSource_Term_Filter = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
        ]
    });
    function clearClassTabValue() {
        TabSet_Class.selectTab(0);
        ListGrid_Class_JspClass.deselectAllRecords();
        loadPage_student();
        TabSet_Class.setDisabled(true);
    }
    var DynamicForm_Term_Filter = isc.DynamicForm.create({
        width: "600",
        height: 30,
        numCols: 6,
        colWidths: ["2%", "28%", "2%", "68%"],
        fields: [
            {
                name: "yearFilter",
                title: "<spring:message code='year'/>",
                width: "100",
                height: 30,
                textAlign: "center",
                editorType: "ComboBoxItem",
                displayField: "year",
                valueField: "year",
                optionDataSource: RestDataSource_Year_Filter,
                filterFields: ["year"],
                sortField: ["year"],
                sortDirection: "descending",
                useClientFiltering: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                },
                pickListFields: [
                    {
                        name: "year",
                        title: "<spring:message code='year'/>",
                        filterOperator: "iContains",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9]"
                        }
                    }
                ],
                changed: function (form, item, value) {
                    clearClassTabValue();
                    load_term_by_year(value);
                },
                dataArrived: function (startRow, endRow, data) {
                    if (data.allRows[0].year !== undefined) {
                        load_term_by_year(data.allRows[0].year);
                    }
                }
            },
            {
                name: "termFilter",
                title: "<spring:message code='term'/>",
                width: "300",
                height: 30,
                textAlign: "center",
                type: "SelectItem",
                multiple: true,
                filterLocally: true,
                displayField: "code",
                valueField: "id",
                optionDataSource: RestDataSource_Term_Filter,
                filterFields: ["code"],
                sortField: ["code"],
                sortDirection: "descending",
                useClientFiltering: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]",
                },
                pickListFields: [
                    {
                        name: "code",
                        title: "<spring:message code='term.code'/>",
                        filterOperator: "iContains",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9]"
                        }
                    },
                    {
                        name: "startDate",
                        title: "<spring:message code='start.date'/>",
                        filterOperator: "iContains",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9/]"
                        }
                    },
                    {
                        name: "endDate",
                        title: "<spring:message code='end.date'/>",
                        filterOperator: "iContains",
                        filterEditorProperties: {
                            keyPressFilter: "[0-9/]"
                        }
                    }
                ],
                pickListProperties: {
                    gridComponents: [
                        isc.ToolStrip.create({
                            autoDraw: false,
                            height: 30,
                            width: "100%",
                            members: [
                                isc.ToolStripButton.create({
                                    width: "50%",
                                    icon: "[SKIN]/actions/approve.png",
                                    title: "انتخاب همه",
                                    click: function () {
                                        var item = DynamicForm_Term_Filter.getField("termFilter"),
                                            fullData = item.pickList.data,
                                            cache = fullData.localData,
                                            values = [];

                                        for (var i = 0; i < cache.length; i++) {
                                            values[i] = cache[i].id;
                                        }
                                        item.setValue(values);
                                        item.pickList.hide();
                                        load_classes_by_term(values);
                                    }
                                }),
                                isc.ToolStripButton.create({
                                    width: "50%",
                                    icon: "[SKIN]/actions/close.png",
                                    title: "حذف همه",
                                    click: function () {
                                        var item = DynamicForm_Term_Filter.getField("termFilter");
                                        item.setValue([]);
                                        item.pickList.hide();
                                        load_classes_by_term([]);
                                    }
                                })
                            ]
                        }),
                        "header", "body"
                    ]
                },
                changed: function (form, item, value) {
                    clearClassTabValue();
                    load_classes_by_term(value);
                },
                dataArrived: function (startRow, endRow, data) {

                    if(firstLoad) {
                        let year = DynamicForm_Term_Filter.getValue("yearFilter");
                        isc.RPCManager.sendRequest(TrDSRequest(classUrl + "defaultTerm/" + year, "GET", null,
                            function (resp) {
                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                    let term = JSON.parse(resp.httpResponseText);
                                    DynamicForm_Term_Filter.getField("termFilter").setValue(term);
                                    termId = term;
                                    termStart = DynamicForm_Term_Filter.getField("termFilter").getSelectedRecord().startDate;
                                    termEnd = DynamicForm_Term_Filter.getField("termFilter").getSelectedRecord().endDate;
                                    load_classes_by_term(term);
                                    clearClassTabValue();
                                    firstLoad = false;
                                } else
                                    getCurrentTermByYear();
                            }
                        ));
                    } else
                        getCurrentTermByYear();
                }
            },
            {
                name: "departmentFilter",
                title: "<spring:message code='complex'/>",
                width: "300",
                height: 30,
                optionDataSource: RestDataSource_Department_Filter,
                autoFetchData: false,
                displayField: "title",
                valueField: "id",
                textAlign: "center",
                pickListFields: [
                    {
                        name: "title",
                        title: "<spring:message code="title"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    }
                ],
                changed: function (form, item, value) {
                    load_classes_by_department(value);
                },
                // icons: [
                //     {
                //         name: "clear",
                //         src: "[SKIN]actions/remove.png",
                //         width: 15,
                //         height: 15,
                //         inline: true,
                //         prompt: "پاک کردن",
                //         click: function (form, item) {
                //             item.clearValue();
                //             item.focusInItem();
                //             departmentCriteria = [];
                //             let mainCriteria = createMainCriteria();
                //             ListGrid_Class_JspClass.invalidateCache();
                //             ListGrid_Class_JspClass.fetchData(mainCriteria);
                //         }
                //     }
                // ],
           },
        ]
    });

    isc.RPCManager.sendRequest(TrDSRequest(classUrl + "defaultYear", "GET", null,
        function (resp) {
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                let year = resp.httpResponseText;
                DynamicForm_Term_Filter.getField("yearFilter").setValue(year);
                load_term_by_year(year);
            } else {
                DynamicForm_Term_Filter.getField("yearFilter").setValue(todayDate.substring(0, 4));
                load_term_by_year(todayDate.substring(0, 4));
            }
        }
    ));

    function getCurrentTermByYear() {
        isc.RPCManager.sendRequest({
            actionURL: termUrl + "getCurrentTerm/" + DynamicForm_Term_Filter.getField("yearFilter").getValue(),
            httpMethod: "GET",
            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
            useSimpleHttp: true,
            contentType: "application/json; charset=utf-8",
            showPrompt: false,
            serverOutputAsString: false,
            callback: function (resp) {
                let term = JSON.parse(resp.httpResponseText);
                DynamicForm_Term_Filter.getItem("termFilter").clearValue();
                DynamicForm_Term_Filter.getField("termFilter").setValue(term);
                termId = term;
                termStart = DynamicForm_Term_Filter.getField("termFilter").getSelectedRecord().startDate;
                termEnd = DynamicForm_Term_Filter.getField("termFilter").getSelectedRecord().endDate;
                load_classes_by_term(resp.httpResponseText);
                clearClassTabValue();
            }
        });
    }

    var ToolStrip_Excel_JspClass = isc.ToolStripButtonExcel.create({
        click: function () {
            let criteria = ListGrid_Class_JspClass.getCriteria();
            if (typeof (criteria._constructor) != 'undefined') {
                if (criteria.criteria == null) {
                    criteria.criteria = [];
                }
                if (ListGrid_Class_JspClass.implicitCriteria)
                    criteria.criteria.add({...ListGrid_Class_JspClass.implicitCriteria.criteria.filter(p => p.fieldName == "term.id")[0]});
            } else {
                if (ListGrid_Class_JspClass.implicitCriteria)
                    criteria = {
                    _constructor: "AdvancedCriteria",
                    criteria:
                        [
                            {...ListGrid_Class_JspClass.implicitCriteria.criteria.filter(p => p.fieldName == "term.id")[0]}
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
            for (let i = 0; i < criteria.criteria.length; i++)
            {
                if (criteria.criteria[i].fieldName!==undefined)
                    newCriteria.criteria.add(criteria.criteria[i])
            }
            ExportToFile.downloadExcelRestUrl(null, ListGrid_Class_JspClass, classUrl + "spec-list", 0, null, '', "اجرا - کلاس", newCriteria, null);
        }
    });

    var HLayout_Training_Actions = isc.HLayout.create({
        width:"50%",
        membersMargin: 5,
        layoutAlign: "center",
        defaultLayoutAlign: "center",
        members: [
            isc.DynamicForm.create({
                height: "100%",
                numCols: 8,
                defaultLayoutAlign: "center",
                ID: "ToolStrip_SendForms_JspClass",
                fields: [
                    {
                        name: "sendButtonTraining",
                        title: "صدور فرم ارزیابی آموزش از مدرس",
                        width: 170,
                        type: "button",
                        startRow: false,
                        endRow: false,
                        baseStyle: "sendFile",
                        click: function () {
                            let record = ListGrid_Class_JspClass.getSelectedRecord();
                            if (record == null || record.id == null) {
                                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                            } else {
                                if (record.evaluationStatusReactionTraining != "0" && record.evaluationStatusReactionTraining != null)
                                    createDialog("info", "قبلا فرم ارزیابی واکنشی برای مسئول آموزش صادر شده است");
                                else {
                                    if (record.supervisorId == undefined || record.teacherId == undefined)
                                        createDialog("info", "اطلاعات کلاس ناقص است!");
                                    else
                                        Training_Reaction_Form_JspClass(record);
                                }
                            }
                        },
                        icons: [
                            {
                                name: "ok",
                                src: "[SKIN]actions/ok.png",
                                width: 15,
                                height: 15,
                                inline: true,
                                // showIf: false,
                                prompt: "تائید صدور",
                                click: function (form, item, icon) {
                                }
                            }
                        ]
                    },
                    {
                        name: "registerButtonTraining",
                        title: "ثبت نتایج ارزیابی آموزش از مدرس",
                        width: 170,
                        type: "button",
                        startRow: false,
                        endRow: false,
                        baseStyle: "registerFile",
                        click: function () {
                            let record = ListGrid_Class_JspClass.getSelectedRecord();
                            if (record == null || record.id == null) {
                                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                            } else {
                                if (record.classStatus == null || record.classStatus == 1)
                                    createDialog("info", "این کلاس در وضعیت برنامه ریزی می باشد و قابل ارزیابی نمی باشد");
                                else {
                                    if (record.evaluationStatusReactionTraining == null || record.evaluationStatusReactionTraining == 0)
                                        createDialog("info", "برای مسئول آموزش این کلاس فرمی صادر نشده است");
                                    else {
                                        if (record.supervisor == undefined || record.teacherId == undefined)
                                            createDialog("info", "اطلاعات کلاس ناقص است!");
                                        else
                                            register_Training_Reaction_Form_JspClass(record);
                                    }
                                }
                            }
                        },
                        icons: [
                            {
                                name: "ok",
                                src: "[SKIN]actions/ok.png",
                                width: 15,
                                height: 15,
                                inline: true,
                                // showIf: false,
                                prompt: "تائید ثبت",
                                click: function (form, item, icon) {
                                }
                            },
                            {
                                name: "clear",
                                src: "[SKIN]actions/remove.png",
                                width: 15,
                                height: 15,
                                inline: true,
                                prompt: "حذف فرم",
                                click: function (form, item, icon) {

                                    let record = ListGrid_Class_JspClass.getSelectedRecord();
                                    if (record == null || record.id == null) {
                                        createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                                    } else {
                                        if (record.evaluationStatusReactionTraining == "0" || record.evaluationStatusReactionTraining == null)
                                            createDialog("info", "فرم ارزیابی واکنشی برای مسئول آموزش صادر نشده است");
                                        else {
                                            let Dialog_remove = createDialog("ask", "آیا از حذف فرم مطمئن هستید؟",
                                                "<spring:message code="verify.delete"/>");
                                            Dialog_remove.addProperties({
                                                buttonClick: function (button, index) {
                                                    this.close();
                                                    if (index === 0) {
                                                        let data = {};
                                                        data.classId = record.id;
                                                        data.evaluatorId = record.supervisorId;
                                                        data.evaluatorTypeId = 454;
                                                        data.evaluatedId = record.teacherId;
                                                        data.evaluatedTypeId = 187;
                                                        data.questionnaireTypeId = 141;
                                                        data.evaluationLevelId = 154;
                                                        wait.show();
                                                        isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/deleteEvaluation", "POST", JSON.stringify(data), function (resp) {
                                                            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                                                                wait.close();
                                                                const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                                                                setTimeout(() => {
                                                                    msg.close();
                                                            }, 3000);
                                                                isc.RPCManager.sendRequest(TrDSRequest(evaluationAnalysisUrl + "/updateEvaluationAnalysis" + "/" +
                                                                    record.id,"GET", null, null));
                                                                record.evaluationStatusReactionTraining = 0;
                                                                ToolStrip_SendForms_JspClass.getField("sendButtonTraining").hideIcon("ok");
                                                                ToolStrip_SendForms_JspClass.getField("registerButtonTraining").hideIcon("ok");
                                                                ToolStrip_SendForms_JspClass.redraw();
                                                            } else {

                                                                wait.close();
                                                                createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                                                            }
                                                        }))
                                                    }
                                                }
                                            });
                                        }
                                    }
                                }
                            },
                            {
                                name: "print",
                                src: "[SKIN]actions/print.png",
                                width: 15,
                                height: 15,
                                inline: true,
                                prompt: "چاپ فرم",
                                click: function (form, item, icon) {
                                    let record = ListGrid_Class_JspClass.getSelectedRecord();
                                    if (record == null || record.id == null)
                                        createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                                    else {
                                        if (record.evaluationStatusReactionTraining == "0" || record.evaluationStatusReactionTraining == null)
                                            createDialog("info", "فرم ارزیابی واکنشی برای مسئول آموزش صادر نشده است");
                                        else
                                            print_Training_Reaction_Form_JspClass(record);
                                    }
                                }
                            }
                        ]
                    }
                ]
            }),
        ]
    });

    var ToolStrip_Actions_JspClass = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            <sec:authorize access="hasAuthority('Tclass_C')">
            ToolStripButton_Add_JspClass,
            </sec:authorize>

            <sec:authorize access="hasAuthority('Tclass_U')">
            ToolStripButton_Edit_JspClass,
            </sec:authorize>

            <sec:authorize access="hasAuthority('Tclass_D')">
            ToolStripButton_Remove_JspClass,
            </sec:authorize>

            <sec:authorize access="hasAuthority('Tclass_P')">
            ToolStripButton_Print_JspClass,
            </sec:authorize>
<%--            <sec:authorize access="hasAuthority('Tclass_P')">--%>
<%--            ToolStripButton_finish,--%>
<%--            </sec:authorize>--%>

            <sec:authorize access="hasAuthority('Tclass_C')">
            ToolStripButton_copy_of_class,
            </sec:authorize>
            <sec:authorize access="hasAuthority('Tclass_P')">
            ToolStrip_Excel_JspClass,
            </sec:authorize>

            HLayout_Training_Actions,

            <sec:authorize access="hasAuthority('Tclass_R')">
            DynamicForm_Term_Filter,
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh_JspClass,
                ]
            })
            </sec:authorize>
        ]
    });
    var HLayout_Actions_Class_JspClass = isc.HLayout.create({
        width: "100%",
        height: "1%",
        members: [ToolStrip_Actions_JspClass]
    });

    var HLayout_Grid_Class_JspClass = isc.TrHLayout.create({
        showResizeBar: true,
        minWidth: "100%",
        width: "100%",
        height: "60%",
        members: [ListGrid_Class_JspClass]
    });

    var TabSet_Class = isc.TabSet.create({
        ID: "tabSetClass",
        enabled: false,
        tabBarPosition: "top",
        tabs: [

            <sec:authorize access="hasAuthority('TclassStudentsTab')">
            {
                ID: "classStudentsTab",
                title: "<spring:message code="student.plural"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/student"})
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('TclassSessionsTab')">
            {
                ID: "classSessionsTab",
                title: "<spring:message code="sessions"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/sessions-tab"})
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('TclassAttendanceTab')">
            {
                ID: "classAttendanceTab",
                title: "<spring:message code="attendance"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/attendance-tab"})
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('TclassScoresTab')">
            {
                ID: "classScoresTab",
                name: "scores",
                title: "<spring:message code="register.scores"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/scores-tab"})
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('TclassCheckListTab')">
            {
                ID: "classCheckListTab",
                name: "checkList",
                title: "<spring:message code="checkList"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/checkList-tab"})
            },
            </sec:authorize>
            {
                ID: "classDocumentsTab",
                title: "مستندات کلاس",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/classDocuments-tab"})
            },
            <sec:authorize access="hasAuthority('TclassAlarmsTab')">
            {
                ID: "classAlarmsTab",
                title: "<spring:message code="alarms"/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/alarms-tab"})
            },
            </sec:authorize>
            <sec:authorize access="hasAuthority('TclassteacherInformationTab')">
            {
                ID: "teacherInformationTab",
                title: "<spring:message code='teacher.information'/>",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/teacher-information-tab"})
            },
            </sec:authorize>

            <sec:authorize access="hasAuthority('TclassAttachmentsTab')">
            {
                ID: "classAttachmentsTab",
                title: "<spring:message code="attachments"/>",
                // pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/attachments-tab"})
            },
            </sec:authorize>
            {
                ID: "classEvaluationInfo",
                title: "مشاهده وضعیت ارزیابی کلاس",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/evaluation-info-tab"})
            },
            {
                ID: "classCosts",
                title: "ثبت هزینه کلاس",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/class-costs-tab"})
            },   {
                ID: "classFinish",
                title: "اختتام کلاس",
                pane: isc.ViewLoader.create({autoDraw: true, viewURL: "tclass/class-finish-tab"})
            },
        ],
        tabSelected: function (tabNum, tabPane, ID, tab, name) {
            if (isc.Page.isLoaded())
                refreshSelectedTab_class(tab);
        }
    });

    <sec:authorize access="hasAuthority('TclassAttachmentsTab')">
    if (!loadjs.isDefined('load_Attachments')) {
        loadjs('<spring:url value='tclass/attachments-tab' />', 'load_Attachments');
    }
    loadjs.ready('load_Attachments', function () {
        oLoadAttachments_class = new loadAttachments();
        setTimeout(()=> {
            TabSet_Class.updateTab(classAttachmentsTab, oLoadAttachments_class.VLayout_Body_JspAttachment);
        },0);
    });
    </sec:authorize>
    let HLayout_Tab_Class = isc.HLayout.create({
        minWidth: "100%",
        width: "100%",
        height: "39%",
        members: [TabSet_Class]
    });

    var VLayout_Body_Class_JspClass = isc.TrVLayout.create({
        width: "100%",
        height: "100%",
        overflow: "scroll",
        members: [
            HLayout_Actions_Class_JspClass,
            HLayout_Grid_Class_JspClass,
            HLayout_Tab_Class
        ]
    });
    //--------------------------------------------------------------------------------------------------------------------//
    function ListGrid_class_remove() {

        let record = ListGrid_Class_JspClass.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {

            let DynamicForm_Remove_Class_Warn = isc.DynamicForm.create({
                width: 600,
                height: 50,
                padding: 6,
                titleAlign: "right",
                fields: [
                    {
                        name: "warnMessage",
                        width: "100%",
                        colSpan: 2,
                        title: "<spring:message code="title"/>",
                        showTitle: false,
                        editorType: 'textArea',
                        canEdit: false
                    },
                    {
                        name: "confirm",
                        width: "100%",
                        colSpan: 2,
                        title: "<spring:message code="title"/>",
                        showTitle: false,
                        editorType: 'textArea',
                        canEdit: false
                    }
                ]
            });

            DynamicForm_Remove_Class_Warn.setValue("warnMessage", "<spring:message code='remove.class.dependency'/>");
            DynamicForm_Remove_Class_Warn.setValue("confirm", "<spring:message code='confirm.remove.class'/>");

            let Window_Remove_Class_Warn = isc.Window.create({
                width: 600,
                height: 150,
                numCols: 2,
                title: "<spring:message code='warning'/>",
                items: [
                    DynamicForm_Remove_Class_Warn,
                    isc.MyHLayoutButtons.create({
                        members: [
                            isc.IButtonSave.create({
                                title: "<spring:message code="continue"/>",
                                click: function () {
                                    wait.show();
                                    isc.RPCManager.sendRequest(TrDSRequest(classUrl + record.id, "DELETE", null, (resp) => {
                                        Window_Remove_Class_Warn.close();
                                        wait.close();
                                        class_delete_result(resp);
                                    }));
                                }}),
                            isc.IButtonCancel.create({
                                title: "<spring:message code="cancel"/>",
                                click: function () {
                                    Window_Remove_Class_Warn.close();
                                }
                            })]
                    })]
            });
            Window_Remove_Class_Warn.show();
        }
    }
    function ListGrid_class_finish() {
        let record = ListGrid_Class_JspClass.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            let Dialog_Class_finish = createDialog("ask", "<spring:message code='msg.record.finish.ask'/>",
                "<spring:message code="verify.finish"/>");
            Dialog_Class_finish.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        wait.show()
                        isc.RPCManager.sendRequest(TrDSRequest(classFinishUrl + record.id, "GET", null, (resp) => {
                            wait.close()
                            class_finish_result(resp);
                        }));
                    }
                }
            });
        }
    }

    function ListGrid_class_edit(a = 0) {
        let record = JSON.parse(JSON.stringify(ListGrid_Class_JspClass.getSelectedRecord()));
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            if ((a===0)&&(record.classStatus === "4")) {
                createDialog("info", "کلاس انتخاب شده لغو شده است و امکان ویرایش آن وجود ندارد.", "هشدار");
            } else {
                startEdit(record);
            }

            function startEdit(record) {
                VM_JspClass.clearErrors();
                VM_JspClass.clearValues();
                DynamicForm_Class_JspClass.getItem("targetPopulationTypeId").disable();
                delete RestDataSource_Term_JspClass.implicitCriteria;
                DynamicForm_Class_JspClass.setValue("erunType", record.course.erunType);
                wait.show();
                isc.RPCManager.sendRequest(TrDSRequest(classUrl + "hasSessions/" + record.id, "GET", null, (resp) => {
                    wait.close();
                    if (resp.httpResponseCode !== 200) {
                        createDialog("warning", "خطا در ارتباط با سرور", "اخطار");
                        return;
                    }
                    DynamicForm1_Class_JspClass.getItem("termId").enable();
                    DynamicForm1_Class_JspClass.getItem("startDate").enable();
                    DynamicForm1_Class_JspClass.getItem("endDate").enable();
                    if (resp.data === "true" && a === 0) {
                        DynamicForm1_Class_JspClass.getItem("termId").disable();
                        DynamicForm1_Class_JspClass.getItem("startDate").disable();
                    }
                    singleTargetScoiety = [];
                    etcTargetSociety = [];
                    getTargetSocieties(record.id);
                    RestDataSource_Teacher_JspClass.fetchDataURL = teacherUrl + "fullName-list";
                    RestDataSource_Teacher_JspClass.invalidateCache();
                    RestDataSource_TrainingPlace_JspClass.fetchDataURL = instituteUrl + record.instituteId + "/trainingPlaces";
                    VM_JspClass.clearErrors(true);
                    VM_JspClass.clearValues();
                    OJT = false;
                    if (a === 0) {
                        DynamicForm_Class_JspClass.getItem("targetPopulationTypeId").disable();
                        DynamicForm_Class_JspClass.getItem("teachingMethodId").disable();
                        DynamicForm_Class_JspClass.getItem("assistantId").disable();
                        DynamicForm_Class_JspClass.getItem("affairsId").disable();
                        DynamicForm_Class_JspClass.getItem("holdingClassTypeId").disable();
                        DynamicForm_Class_JspClass.getItem("teachingMethodId").setOptionDataSource(null);
                        DynamicForm_Class_JspClass.getItem("teachingMethodId").setValueMap(null);
                        DynamicForm_Class_JspClass.getItem("teachingMethodId").clearErrors();
                        switch (record.holdingClassType.code) {
                            case "intraOrganizational":
                                DynamicForm_Class_JspClass.getItem("teachingMethodId").setOptionDataSource(RestDataSource_intraOrganizational_Holding_Class_Type_List);
                                break;
                            case "InTheCountryExtraOrganizational":
                                DynamicForm_Class_JspClass.getItem("teachingMethodId").setOptionDataSource(RestDataSource_InTheCountryExtraOrganizational_Holding_Class_Type_List);
                                break;
                            case "AbroadExtraOrganizational":
                                DynamicForm_Class_JspClass.getItem("teachingMethodId").setOptionDataSource(RestDataSource_AbroadExtraOrganizational_Holding_Class_Type_List);
                                break;
                        }
                        VM_JspClass.editRecord(record);
                        saveButtonStatus();
                        classMethod = "PUT";
                        url = classUrl + record.id;
                        Window_Class_JspClass.setTitle("<spring:message code="edit"/>" + " " + "<spring:message code="class"/>");
                        if(record.evaluation !== undefined && record.evaluation === "3") {
                            DynamicForm_Class_JspClass.getItem("startEvaluation").required = true;
                            DynamicForm_Class_JspClass.getItem("hasTest").setDisabled(true);
                            DynamicForm_Class_JspClass.getItem("hasTest").setValue(false);
                            DynamicForm_Class_JspClass.getItem("behavioralLevel").setDisabled(false);
                            DynamicForm_Class_JspClass.getItem("startEvaluation").setDisabled(false);
                            DynamicForm_Class_JspClass.getItem("startEvaluation").enable();
                            DynamicForm_Class_JspClass.getItem("startEvaluation").setValue("3");
                        } else if (record.evaluation !== undefined && record.evaluation === "2") {
                            DynamicForm_Class_JspClass.getItem("startEvaluation").required = false;
                            DynamicForm_Class_JspClass.getItem("hasTest").setDisabled(false);
                            DynamicForm_Class_JspClass.getItem("behavioralLevel").setDisabled(true);
                            DynamicForm_Class_JspClass.getItem("startEvaluation").setDisabled(true);
                            DynamicForm_Class_JspClass.getItem("startEvaluation").setValue();
                        } else {
                            DynamicForm_Class_JspClass.getItem("startEvaluation").required = false;
                            DynamicForm_Class_JspClass.getItem("hasTest").setDisabled(true);
                            DynamicForm_Class_JspClass.getItem("hasTest").setValue(false);
                            DynamicForm_Class_JspClass.getItem("behavioralLevel").setDisabled(true);
                            DynamicForm_Class_JspClass.getItem("startEvaluation").setDisabled(true);
                            DynamicForm_Class_JspClass.getItem("startEvaluation").setValue();
                        }
                        Window_Class_JspClass.show();
                        //=========================
                        DynamicForm_Class_JspClass.getField("classStatus").getItem(1).enable();
                        DynamicForm_Class_JspClass.getField("classStatus").getItem(2).enable();
                        DynamicForm_Class_JspClass.getItem("scoringMethod").change(DynamicForm_Class_JspClass, DynamicForm_Class_JspClass.getItem("scoringMethod"), DynamicForm_Class_JspClass.getValue("scoringMethod"));
                        DynamicForm_Class_JspClass.itemChanged();
                        if (ListGrid_Class_JspClass.getSelectedRecord().scoringMethod === "1") {
                            DynamicForm_Class_JspClass.setValue("acceptancelimit_a", ListGrid_Class_JspClass.getSelectedRecord().acceptancelimit);
                        }
                        else {
                            DynamicForm_Class_JspClass.setValue("acceptancelimit", ListGrid_Class_JspClass.getSelectedRecord().acceptancelimit);
                        }
                        //================
                        DynamicForm1_Class_JspClass.setValue("autoValid", false);
                        if (record.evaluation === "1") {
                            DynamicForm_Class_JspClass.setValue("preCourseTest", false);
                            DynamicForm_Class_JspClass.getItem("preCourseTest").hide();
                        } else
                            DynamicForm_Class_JspClass.getItem("preCourseTest").show();
                        wait.show();
                        isc.RPCManager.sendRequest(TrDSRequest(sessionServiceUrl + "classHasAnySession/" + record.id, "GET", null, (resp) => {
                            let result = resp.httpResponseText == Boolean(true).toString() ? true : false;
                            autoTimeActivation(result ? false : true);
                            let cr = {fieldName: "tclassId", operator: "equals", value: record.id};
                            isc.RPCManager.sendRequest(TrDSRequest(
                                viewEvaluationStaticalReportUrl + "/iscList?operator=or&_constructor=AdvancedCriteria&criteria=" + JSON.stringify(cr),
                                "GET",
                                null,
                                (resp) => {
                                    wait.close();
                                    lastDate= DynamicForm1_Class_JspClass.getValue("endDate")
                                    let record = JSON.parse(resp.data).response.data[0];
                                    if(record.evaluationTeacherGrade !== undefined) {
                                        DynamicForm_Class_JspClass.setValue(
                                            "evaluationScore",
                                            getFormulaMessage(record.evaluationTeacherGrade, "2", "red", "b")
                                        )
                                    }
                            }));
                        }));

                        if (DynamicForm_Class_JspClass.getValue("classStatus")==="3")
                        {
                            DynamicForm1_Class_JspClass.getItem("endDate").disable();
                        }
                        else
                        {
                            DynamicForm1_Class_JspClass.getItem("endDate").enable();
                        }
                        highlightClassStauts(DynamicForm_Class_JspClass.getField("classStatus").getValue(), 1200);
                    } else {
                        classMethod = "POST";
                        DynamicForm_Class_JspClass.getItem("targetPopulationTypeId").enable();
                        DynamicForm_Class_JspClass.getItem("holdingClassTypeId").enable();

                        DynamicForm_Class_JspClass.getItem("teachingMethodId").disable();

                        DynamicForm_Class_JspClass.getItem("complexId").enable();
                        DynamicForm_Class_JspClass.getItem("assistantId").disable();
                        DynamicForm_Class_JspClass.getItem("affairsId").disable();
                        url = classUrl;
                        DynamicForm_Class_JspClass.setValue("course.id", record.course.id);
                        DynamicForm_Class_JspClass.setValue("course.theoryDuration", record.course.theoryDuration);
                        DynamicForm_Class_JspClass.setValue("minCapacity", record.minCapacity);
                        DynamicForm_Class_JspClass.setValue("maxCapacity", record.maxCapacity);
                        DynamicForm_Class_JspClass.setValue("titleClass", record.titleClass);
                        // DynamicForm_Class_JspClass.setValue("teachingType", record.teachingType);
                        DynamicForm_Class_JspClass.setValue("topology", record.topology);
                        DynamicForm_Class_JspClass.setValue("hduration", record.hduration);
                        DynamicForm_Class_JspClass.setValue("reason", record.reason);
                        DynamicForm_Class_JspClass.setValue("organizerId", record.organizerId);
                        DynamicForm_Class_JspClass.setValue("instituteId", record.instituteId);
                        DynamicForm_Class_JspClass.setValue("trainingPlaceIds", record.trainingPlaceIds);
                        DynamicForm_Class_JspClass.setValue("scoringMethod", record.scoringMethod);
                        DynamicForm_Class_JspClass.setValue("preCourseTest", record.preCourseTest);
                        DynamicForm_Class_JspClass.setValue("evaluation", record.evaluation);
                        DynamicForm_Class_JspClass.setValue("startEvaluation", record.startEvaluation);
                        DynamicForm_Class_JspClass.setValue("behavioralLevel", record.behavioralLevel);
                        DynamicForm_Class_JspClass.setValue("targetPopulationTypeId", null);
                        DynamicForm_Class_JspClass.setValue("holdingClassTypeId",null);
                        DynamicForm_Class_JspClass.setValue("teachingMethodId", null);

                        if (userPersonInfo != null) {
                            DynamicForm_Class_JspClass.setValue("supervisor", userPersonInfo.id);
                            DynamicForm_Class_JspClass.setValue("planner", userPersonInfo.id);
                        }

                        Window_Class_JspClass.setTitle("<spring:message code="create"/>" + " " + "<spring:message code="class"/>");
                        if(record.evaluation !== undefined && record.evaluation === "3") {
                            DynamicForm_Class_JspClass.getItem("startEvaluation").required = true;
                            DynamicForm_Class_JspClass.getItem("hasTest").setDisabled(true);
                            DynamicForm_Class_JspClass.getItem("hasTest").setValue(false);
                            DynamicForm_Class_JspClass.getItem("behavioralLevel").setDisabled(false);
                            DynamicForm_Class_JspClass.getItem("startEvaluation").setDisabled(false);
                            DynamicForm_Class_JspClass.getItem("startEvaluation").enable();
                            DynamicForm_Class_JspClass.getItem("startEvaluation").setValue("3");
                        } else if (record.evaluation !== undefined && record.evaluation === "2") {
                            DynamicForm_Class_JspClass.getItem("startEvaluation").required = false;
                            DynamicForm_Class_JspClass.getItem("hasTest").setDisabled(false);
                            DynamicForm_Class_JspClass.getItem("behavioralLevel").setDisabled(true);
                            DynamicForm_Class_JspClass.getItem("startEvaluation").setDisabled(true);
                            DynamicForm_Class_JspClass.getItem("startEvaluation").setValue();
                        } else {
                            DynamicForm_Class_JspClass.getItem("startEvaluation").required = false;
                            DynamicForm_Class_JspClass.getItem("hasTest").setDisabled(true);
                            DynamicForm_Class_JspClass.getItem("hasTest").setValue(false);
                            DynamicForm_Class_JspClass.getItem("behavioralLevel").setDisabled(true);
                            DynamicForm_Class_JspClass.getItem("startEvaluation").setDisabled(true);
                            DynamicForm_Class_JspClass.getItem("startEvaluation").setValue();
                        }
                        Window_Class_JspClass.show();
                        DynamicForm_Class_JspClass.getItem("scoringMethod").change(DynamicForm_Class_JspClass, DynamicForm_Class_JspClass.getItem("scoringMethod"), DynamicForm_Class_JspClass.getValue("scoringMethod"));
                        DynamicForm_Class_JspClass.itemChanged();
                        if (ListGrid_Class_JspClass.getSelectedRecord().scoringMethod === "1") {
                            DynamicForm_Class_JspClass.setValue("acceptancelimit_a", ListGrid_Class_JspClass.getSelectedRecord().acceptancelimit);
                        }
                        else {
                            DynamicForm_Class_JspClass.setValue("acceptancelimit", ListGrid_Class_JspClass.getSelectedRecord().acceptancelimit);
                        }

                        if (record.evaluation === "1") {
                            DynamicForm_Class_JspClass.setValue("preCourseTest", false);
                            DynamicForm_Class_JspClass.getItem("preCourseTest").hide();
                        } else
                            DynamicForm_Class_JspClass.getItem("preCourseTest").show();
                        DynamicForm_Class_JspClass.getField("classStatus").getItem(1).disable();
                        DynamicForm_Class_JspClass.getField("classStatus").getItem(2).disable();

                        ["first", "second", "third", "fourth", "fifth", "saturday", "sunday", "monday", "tuesday", "wednesday", "thursday", "friday"].forEach(item =>
                        {
                            DynamicForm1_Class_JspClass.getField(item).disable();
                            DynamicForm1_Class_JspClass.setValue(item,false);
                        });
                        DynamicForm_Class_JspClass.getItem("acceptancelimit").setDisabled(false);
                        DynamicForm_Class_JspClass.getItem("scoringMethod").setDisabled(false);
                        autoTimeActivation();
                    }
                }));

            }
        }
    }
    /*Functions*/
    //--------------------------------------------------------------------------------------------------------------------//
    function ListGrid_Class_refresh() {
        let gridState;
        if (ListGrid_Class_JspClass.getSelectedRecord()) {
            gridState = "[{id:" + ListGrid_Class_JspClass.getSelectedRecord().id + "}]";
        }
        ListGrid_Class_JspClass.invalidateCache();
        setTimeout(function () {
            ListGrid_Class_JspClass.setSelectedState(gridState);
        }, 3000);
        refreshSelectedTab_class(tabSetClass.getSelectedTab());
    }
    function ListGrid_Class_add() {
        DynamicForm_Class_JspClass.getItem("targetPopulationTypeId").enable();
        DynamicForm_Class_JspClass.getItem("holdingClassTypeId").enable();
        DynamicForm_Class_JspClass.getItem("teachingMethodId").disable();
        DynamicForm_Class_JspClass.getItem("complexId").enable();
        DynamicForm_Class_JspClass.getItem("assistantId").disable();
        DynamicForm_Class_JspClass.getItem("affairsId").disable();

        classMethod = "POST";
        url = classUrl;
        VM_JspClass.clearErrors();
        VM_JspClass.clearValues();
        Window_Class_JspClass.setTitle("<spring:message code="create"/>" + " " + "<spring:message code="class"/>");
        DynamicForm_Class_JspClass.getItem("startEvaluation").required = false;
        DynamicForm_Class_JspClass.getItem("hasTest").setDisabled(true);
        DynamicForm_Class_JspClass.getItem("behavioralLevel").setDisabled(true);
        DynamicForm_Class_JspClass.getItem("startEvaluation").setDisabled(true);
        Window_Class_JspClass.show();
        DynamicForm_Class_JspClass.getItem("preCourseTest").hide();
        if (userPersonInfo != null) {
            DynamicForm_Class_JspClass.setValue("supervisor", userPersonInfo.id);
            DynamicForm_Class_JspClass.setValue("planner", userPersonInfo.id);
        }
        autoTimeActivation(true);
        DataSource_TargetSociety_List.testData.forEach(function (currentValue, index, arr) {
            DataSource_TargetSociety_List.removeData(currentValue)
        });
        DynamicForm_Class_JspClass.getItem("targetSocieties").clearValue();
        singleTargetScoiety = [];
        etcTargetSociety = [];
        getOrganizers();
        DynamicForm1_Class_JspClass.getItem("termId").enable();
        DynamicForm1_Class_JspClass.getItem("startDate").enable();
        DynamicForm1_Class_JspClass.getItem("endDate").enable();
        OJT = false;
        DynamicForm_Class_JspClass.getField("classStatus").getItem(1).disable();
        DynamicForm_Class_JspClass.getField("classStatus").getItem(2).disable();
        DynamicForm_Class_JspClass.getItem("acceptancelimit").setDisabled(false);
        DynamicForm_Class_JspClass.getItem("scoringMethod").setDisabled(false);
        DynamicForm_Class_JspClass.getItem("instituteId").setDisabled(false);
        DynamicForm_Class_JspClass.getItem("trainingPlaceIds").setDisabled(false);
        setDefaultTerm();
    }

    function ListGrid_class_print(type) {
        let direction = "";
        if (ListGrid_Class_JspClass.getSort()[0]["direction"] === "descending") {
            direction = "-";
        }
        let cr = {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: []
        }
        if (ListGrid_Class_JspClass.getCriteria().criteria !== undefined) {
            cr = ListGrid_Class_JspClass.getCriteria();
        }
        if (DynamicForm_Term_Filter.getItem("termFilter").getSelectedRecord() === undefined) {
            cr.criteria.add({
                fieldName: "term.code",
                operator: "inSet",
                value: DynamicForm_Term_Filter.getValue("termFilter")
            });
        } else {
            cr.criteria.add({
                fieldName: "term.id",
                operator: "inSet",
                value: DynamicForm_Term_Filter.getValue("termFilter")
            });
        }

        let   newCriteria = {
            _constructor: "AdvancedCriteria",
            criteria:
                [],
            operator: "and"
        };
        for (let i = 0; i < cr.criteria.length; i++)
        {
            if (cr.criteria[i].fieldName!==undefined)
                newCriteria.criteria.add(cr.criteria[i])
        }
        printWithCriteria(newCriteria, {}, "ClassByCriteria.jasper", type, direction + ListGrid_Class_JspClass.getSort()[0]["property"]);
    }

    function cancelClass_JspClass(record) {
        if (record.classStatus === "4" ) {
            simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.record.selected.class.is.canceled"/>", 3000, "say");
        } else {
            let WindowCancelClass = isc.Window.create({
                title: "پنجره تایید لغو کلاس",
                items: [isc.VLayout.create({
                    width: "100%",
                    height: "100%",
                    members: [
                        isc.DynamicForm.create({
                            ID: "DynamicFormPostponeClass",
                            numCols: 4,
                            validateOnChange: true,
                            readOnlyDisplay: "readOnly",
                            fields: [
                                {
                                    name: "classCancelReasonId",
                                    colSpan: 4,
                                    textAlign: "center",
                                    title: "علت لغو کلاس: ",
                                    optionDataSource: RestDataSource_ClassCancel_JSPClass,
                                    valueField: "id",
                                    required: true,
                                    sortField: "id",
                                    displayField: "title",
                                    autoFitWidth: true,
                                    showFilterEditor: false
                                },
                                {
                                    name: "postpone",
                                    type: "checkbox",
                                    colSpan: 4,
                                    title: "در تاریخ دیگری اجرا میشود.",
                                    endRow: false,
                                    changed(form, item, value) {
                                        if (value) {
                                            form.getItem("postponeStartDate").show();
                                            form.getItem("alternativeClassId").show();
                                            form.getItem("postponeStartDate").required = true;
                                        } else {
                                            form.clearValue("postponeStartDate");
                                            form.clearValue("alternativeClassId");
                                            form.getItem("postponeStartDate").hide();
                                            form.getItem("alternativeClassId").hide();
                                            form.getItem("postponeStartDate").required = false;
                                        }
                                    }
                                },
                                {
                                    name: "postponeStartDate",
                                    colSpan: 4,
                                    ID: "startDate_CancelClass_jspClass",
                                    title: "<spring:message code='start.date'/>:",
                                    hint: "--/--/----",
                                    hidden: true,
                                    keyPressFilter: "[0-9/]",
                                    showHintInField: true,
                                    icons: [{
                                        src: "<spring:url value="calendar.png"/>",
                                        click: function (form) {
                                            closeCalendarWindow();
                                            displayDatePicker('startDate_CancelClass_jspClass', this, 'ymd', '/');
                                        }
                                    }],
                                    textAlign: "center",
                                    changed: function (form, item, value) {
                                        let dateCheck = checkDate(value);
                                        if (dateCheck === false) {
                                            form.addFieldErrors("postponeStartDate", "<spring:message code='msg.correct.date'/>", true);
                                        }
                                    }
                                },
                                {
                                    name: "alternativeClassId",
                                    title: "کلاس جایگزین: ",
                                    textAlign: "center",
                                    icons: [
                                        {
                                            name: "clear",
                                            src: "[SKIN]actions/remove.png",
                                            width: 15,
                                            height: 15,
                                            inline: true,
                                            prompt: "پاک کردن",
                                            click: function (form, item, icon) {
                                                item.clearValue();
                                                item.focusInItem();
                                            }
                                        }
                                    ],
                                    hidden: true,
                                    width: "280",
                                    editorType: "ComboBoxItem",
                                    pickListWidth: 700,
                                    optionDataSource: RestDataSource_Class_JspClass,
                                    displayField: "titleClass",
                                    valueField: "id",
                                    filterFields: ["titleClass", "code"],
                                    pickListFields: [
                                        {name: "code", title: "کد کلاس", autoFitWidth: true},
                                        {name: "titleClass", title: "نام کلاس", autoFitWidth: true},
                                        {name: "teacher", title: "استاد", autoFitWidth: true},
                                        {name: "startDate", title: "تاریخ شروع", autoFitWidth: true},
                                        {name: "endDate", title: "تاریخ پایان", autoFitWidth: true},
                                    ],
                                    pickListProperties: {
                                        showFilterEditor: false,
                                        autoFitWidthApproach: "both",
                                    },
                                    click(form, item) {
                                        let criteria = {
                                            _constructor: "AdvancedCriteria",
                                            operator: "and",
                                            criteria: [
                                                {fieldName: "courseId", operator: "equals", value: record.courseId},
                                                {
                                                    fieldName: "startDate",
                                                    operator: "greaterOrEqual",
                                                    value: record.startDate
                                                },
                                                {fieldName: "id", operator: "notEqual", value: record.id},
                                                {fieldName: "classStatus", operator: "notEqual", value: "4"},
                                            ]
                                        };
                                        item.pickListCriteria = criteria;
                                        item.fetchData();
                                    }
                                }
                            ]
                        }),
                        isc.TrHLayoutButtons.create({
                            members: [
                                isc.IButtonSave.create({
                                    title: "تایید",
                                    click: function () {
                                        DynamicFormPostponeClass.validate();
                                        if (DynamicFormPostponeClass.getItem("postponeStartDate").required && DynamicFormPostponeClass.getValue("postponeStartDate") === undefined) {
                                            DynamicFormPostponeClass.getItem("postponeStartDate").setError("فیلد اجباری است");
                                            DynamicFormPostponeClass.redraw()
                                        }
                                        if (DynamicFormPostponeClass.hasErrors()) {
                                            return;
                                        }
                                        if (!DynamicFormPostponeClass.valuesHaveChanged()) {
                                            WindowCancelClass.close()
                                            return;
                                        }
                                        record.classCancelReasonId = DynamicFormPostponeClass.getValue("classCancelReasonId");
                                        record.alternativeClassId = DynamicFormPostponeClass.getValue("alternativeClassId");
                                        record.postponeStartDate = DynamicFormPostponeClass.getValue("postponeStartDate");
                                        record.classStatus = "4";
                                        wait.show();
                                        isc.RPCManager.sendRequest(TrDSRequest(classUrl + "update/" + record.id, "PUT", JSON.stringify(record), (resp) => {
                                            wait.close();
                                            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                                ListGrid_Class_refresh();
                                                let responseID = JSON.parse(resp.data).id;
                                                let gridState = "[{id:" + responseID + "}]";
                                                simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.successful"/>", 3000, "say");
                                                setTimeout(function () {
                                                    ListGrid_Class_JspClass.setSelectedState(gridState);
                                                    ListGrid_Class_JspClass.scrollToRow(ListGrid_Class_JspClass.getRecordIndex(ListGrid_Class_JspClass.getSelectedRecord()), 0);
                                                }, 3000);
                                                WindowCancelClass.close()
                                            } else {
                                                simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.error"/>", "3000", "error");
                                            }
                                        }));
                                    }
                                }),
                                isc.IButtonCancel.create({
                                    click: function () {
                                        WindowCancelClass.close()
                                    }
                                }),
                            ]
                        })
                    ]
                })],
                width: "400",
                height: "150",
            });
            WindowCancelClass.show();
            DynamicFormPostponeClass.setValues(record);
            if (record.postponeStartDate !== undefined) {
                DynamicFormPostponeClass.getItem("postpone").changed(DynamicFormPostponeClass, DynamicFormPostponeClass.getItem("postpone"), true);
                DynamicFormPostponeClass.setValue("postpone", true)
            }
        }
    }

    function alternativeClass_JspClass(record) {
        let WindowAlternativeClass = isc.Window.create({
            title: "جایگزین کلاس های لغو شده",
            items: [isc.VLayout.create({
                width: "100%",
                height: "100%",
                members: [
                    isc.DynamicForm.create({
                        ID: "DynamicFormAlternativeClass",
                        numCols: 4,
                        validateOnChange: true,
                        // colWidths: [120, 20, 50, 100],
                        readOnlyDisplay: "readOnly",
                        // cellBorder:1,
                        fields: [
                            {
                                name: "canceledClasses",
                                title: "کلاسهای لغو شده: ",
                                multiple: true,
                                required: true,
                                textAlign: "center",
                                width: "280",
                                // editorType: "MultiSelectItem",
                                pickListWidth: 700,
                                optionDataSource: RestDataSource_Class_JspClass,
                                displayField: "titleClass",
                                valueField: "id",
                                filterFields: ["titleClass", "code"],
                                pickListFields: [
                                    {name: "code", title: "کد کلاس", autoFitWidth: true},
                                    {name: "titleClass", title: "نام کلاس", autoFitWidth: true},
                                    {name: "teacher", title: "استاد", autoFitWidth: true},
                                    {name: "startDate", title: "تاریخ شروع", autoFitWidth: true},
                                    {name: "endDate", title: "تاریخ پایان", autoFitWidth: true},
                                ],
                                pickListProperties: {
                                    showFilterEditor: false,
                                    // alternateRecordStyles: true,
                                    autoFitWidthApproach: "both",
                                },
                                click(form, item) {
                                    let criteria = {
                                        _constructor: "AdvancedCriteria",
                                        operator: "and",
                                        criteria: [
                                            {fieldName: "courseId", operator: "equals", value: record.courseId},
                                            {
                                                fieldName: "startDate",
                                                operator: "lessOrEqual",
                                                value: record.startDate
                                            },
                                            {fieldName: "id", operator: "notEqual", value: record.id},
                                            {fieldName: "classStatus", operator: "equals", value: "4"},
                                            {operator: "or", criteria: [
                                                    {fieldName: "alternativeClassId", operator: "isNull"},
                                                    {fieldName: "alternativeClassId", operator: "equals", value: record.id},
                                                ]}
                                        ]
                                    };
                                    item.pickListCriteria = criteria;
                                    item.fetchData();
                                }
                            }
                        ]
                    }),
                    isc.TrHLayoutButtons.create({
                        members: [
                            isc.IButtonSave.create({
                                title: "تایید",
                                click: function () {
                                    DynamicFormAlternativeClass.validate();
                                    if (DynamicFormAlternativeClass.hasErrors()) {
                                        return;
                                    }
                                    let rec = DynamicFormAlternativeClass.getValue("canceledClasses")
                                    wait.show();
                                    isc.RPCManager.sendRequest(TrDSRequest(classUrl + "update/" + record.id + "?cancelClassesIds=" + rec.toString() , "PUT", JSON.stringify(record), (resp) => {
                                        wait.close();
                                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                            WindowAlternativeClass.close()
                                            ListGrid_Class_refresh();
                                            let responseID = JSON.parse(resp.data).id;
                                            let gridState = "[{id:" + responseID + "}]";
                                            simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.successful"/>", 3000, "say");
                                            setTimeout(function () {
                                                ListGrid_Class_JspClass.setSelectedState(gridState);
                                                ListGrid_Class_JspClass.scrollToRow(ListGrid_Class_JspClass.getRecordIndex(ListGrid_Class_JspClass.getSelectedRecord()), 0);
                                            }, 3000);
                                            WindowCancelClass.close()
                                        } else {
                                            simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.operation.error"/>", "3000", "error");
                                        }
                                    }));
                                }
                            }),
                            isc.IButtonCancel.create({
                                click: function () {
                                    WindowAlternativeClass.close()
                                }
                            }),
                        ]
                    })
                ]
            })],
            width: "400",
            height: "150",
        });
        WindowAlternativeClass.show();
        DynamicFormAlternativeClass.setValue("canceledClasses", record.canceledClasses.map(x => x.id))

    }

    function classCode() {
        if (DynamicForm_Class_JspClass.getItem("course.id").getSelectedRecord()!== undefined) //bug fix
            DynamicForm_Class_JspClass.setValue("code", DynamicForm_Class_JspClass.getItem("course.id").getSelectedRecord().code + "-" + DynamicForm1_Class_JspClass.getItem("termId").getSelectedRecord().code + "-" + DynamicForm_Class_JspClass.getValue("group"));
    }

    function evalGroup() {
        setTimeout(()=>{
            let tid = DynamicForm1_Class_JspClass.getValue("termId");
            let cid = DynamicForm_Class_JspClass.getValue("course.id");
            if (tid && cid) {
                wait.show();
                isc.RPCManager.sendRequest(TrDSRequest(classUrl + "end_group/" + cid + "/" + tid, "GET", null, resp => {
                    wait.close();
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        DynamicForm_Class_JspClass.setValue("group", JSON.parse(resp.data));
                        classCode();
                    }
                }));
            }
        },500)
    }

    function class_action_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            var courseId = JSON.parse(resp.data).courseId;
            var VarParams = [{
                "processKey": "ClassWorkFlow",
                "cId": JSON.parse(resp.data).id,
                "code": JSON.parse(resp.data).code,
                "course": DynamicForm_Class_JspClass.getItem("courseId").getSelectedRecord().code,
                "coursetitleFa": DynamicForm_Class_JspClass.getItem("course.titleFa").getValue(),
                "startDate": JSON.parse(resp.data).startDate,
                "endDate": JSON.parse(resp.data).endDate,
                // "classCreator": "classCreator",
                "classCreatorId": "${username}",
                "classCreator": userFullName,
                "REJECT": "",
                "REJECTVAL": "",
                "target": "/tclass/show-form",
                "targetTitleFa": "کلاس"
            }]
            if (classMethod.localeCompare("POST") === 0) {
                wait.show()
                ///// //disable until set permission to ending class//  isc.RPCManager.sendRequest(TrDSRequest(workflowUrl + "/startProcess", "POST", JSON.stringify(VarParams), "callback:startProcess(rpcResponse)"));
            }
            var OK = createDialog("info", "<spring:message code='msg.operation.successful'/>",
                "<spring:message code="message"/>");
            setTimeout(function () {
                let responseID = JSON.parse(resp.data).id;
                let gridState = "[{id:" + responseID + "}]";
                ListGrid_Class_JspClass.setSelectedState(gridState);
                OK.close();

            }, 1000);
            ListGrid_Class_refresh();
            Window_Class_JspClass.close();
        } else {
            createDialog("info", "<spring:message code='error'/>");
        }
    }

    function startProcess(resp) {
        wait.close()
        if (resp.httpResponseCode === 200) {
            isc.say("<spring:message code="course.set.on.workflow.engine"/>");
        } else if (resp.httpResponseCode === 404) {
            isc.say("<spring:message code='workflow.bpmn.not.uploaded'/>");
        } else {
            isc.say("<spring:message code='msg.send.to.workflow.problem'/>");
        }
    }

    function class_delete_result(resp) {
        wait.close();
        if (resp.httpResponseCode === 200) {
            ListGrid_Class_JspClass.invalidateCache();
            var OK = createDialog("info", "<spring:message code='msg.operation.successful'/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
            refreshSelectedTab_class(tabSetClass.getSelectedTab());
        } else if (resp.httpResponseCode === 406 && resp.httpResponseText === "NotDeletable") {
            createDialog("info", "<spring:message code='global.grid.record.cannot.deleted'/>");
        } else {
            createDialog("warning", (JSON.parse(resp.httpResponseText).message === undefined ? "خطا" : JSON.parse(resp.httpResponseText).message));
        }
    }
    function class_finish_result(resp) {
        wait.close();
    }

    function GetScoreState(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            DynamicForm_Class_JspClass.getItem('scoringMethod').setDisabled(false)
        } else if (resp.httpResponseCode === 406) {
            DynamicForm_Class_JspClass.getItem('scoringMethod').setDisabled(true);
            DynamicForm_Class_JspClass.getItem("acceptancelimit").setDisabled(true);
            DynamicForm_Class_JspClass.getItem("acceptancelimit_a").setDisabled(true);
        }
    }

    function refreshSelectedTab_class(tab) {
        let classRecord = ListGrid_Class_JspClass.getSelectedRecord();
        tabSet_class_status(classRecord);
        if (!(classRecord == undefined || classRecord == null)) {
            switch (tab.ID) {
                case "classStudentsTab": {
                    if (typeof loadPage_student !== "undefined")
                        loadPage_student();
                    break;
                }
                case "classSessionsTab": {
                    if (typeof loadPage_session !== "undefined")
                        loadPage_session();
                    break;
                }
                case "classCheckListTab": {
                    if (typeof loadPage_checkList !== "undefined")

                        loadPage_checkList();
                    break;
                }
                case "classAttachmentsTab": {
                    if (typeof oLoadAttachments_class.loadPage_attachment !== "undefined")
                        oLoadAttachments_class.loadPage_attachment("Tclass", classRecord.id, "<spring:message code="attachment"/>", {
                            1: "جزوه",
                            2: "لیست نمرات",
                            3: "لیست حضور و غیاب",
                            4: "نامه غیبت موجه"
                        }, false);
                    break;
                }
                case "classScoresTab": {

                    if (typeof loadPage_Scores !== "undefined") {
                        loadPage_Scores();
                    }
                    break;
                }
                case "costClassTab": {

                    if (typeof loadPage_costClass !== "undefined") {
                        loadPage_costClass();
                    }
                    break;
                }

                case "classAttendanceTab": {
                    if (typeof loadPage_Attendance !== "undefined")
                        loadPage_Attendance();
                    break;
                }
                case "classAlarmsTab": {
                    if (typeof loadPage_alarm !== "undefined")
                        loadPage_alarm();
                    break;
                }
                case "teacherInformationTab": {
                    if (typeof loadPage_teacherInformation !== "undefined")
                        loadPage_teacherInformation();
                    break;
                }
                case "classPreCourseTestQuestionsTab": {
                    if (typeof loadPage_preCourseTestQuestions !== "undefined")
                        loadPage_preCourseTestQuestions(ListGrid_Class_JspClass.getSelectedRecord().id, isReadOnlyClass);
                    break;
                }
                case "classDocumentsTab": {
                    if (typeof loadPage_classDocuments !== "undefined")
                        loadPage_classDocuments(ListGrid_Class_JspClass.getSelectedRecord().id);
                    break;
                }
                case "classEvaluationInfo": {
                    if (typeof loadPage_classEvaluationInfo !== "undefined")
                        loadPage_classEvaluationInfo(ListGrid_Class_JspClass.getSelectedRecord().id,
                                                    ListGrid_Class_JspClass.getSelectedRecord().studentCount,
                                                    ListGrid_Class_JspClass.getSelectedRecord().evaluation);
                    break;
                }
                case "classCosts": {
                    if (typeof loadPage_classCosts !== "undefined")
                        loadPage_classCosts(ListGrid_Class_JspClass.getSelectedRecord().studentCost,
                            ListGrid_Class_JspClass.getSelectedRecord().studentCostCurrency,
                            ListGrid_Class_JspClass.getSelectedRecord().id);
                    break;
                }
                case "classFinish": {
                    if (typeof loadPage_classCosts !== "undefined")
                        loadPage_classFinish(ListGrid_Class_JspClass.getSelectedRecord().id);
                    break;
                }
            }
        }
    }

    function checkValidDate(termStart, termEnd, classStart, classEnd) {
        if (termStart != null && termEnd != null && classStart != null && classEnd != null) {
            if (!checkDate(classStart.trim())) {
                createDialog("info", "فرمت تاریخ شروع صحیح نیست.", "<spring:message code='message'/>");
                return false;
            }
            if (!checkDate(classEnd.trim())) {
                createDialog("info", "فرمت تاریخ پایان صحیح نیست.", "<spring:message code='message'/>");
                return false;
            }
            if (classEnd.trim() < classStart.trim()) {
                createDialog("info", "تاریخ پایان کلاس قبل از تاریخ شروع کلاس نمی تواند باشد.", "<spring:message code='message'/>");
                return false;
            }
            if (termEnd.trim() < classStart.trim()) {
                createDialog("info", "تاریخ شروع کلاس بعد از تاریخ پایان ترم نمی تواند باشد.", "<spring:message code='message'/>");
                return false;
            }
            if (termStart.trim() > classStart.trim()) {
                createDialog("info", "تاریخ شروع کلاس قبل از تاریخ شروع ترم نمی تواند باشد.", "<spring:message code='message'/>");
                return false;
            }
            return true;
        }
        return false;
    }

    async function classDateHasConflictWithSession(classId , endDate) {
        let resp = await fetch(sessionServiceUrl + "sessions/" + classId, {headers: {"Authorization": "Bearer <%= (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN) %>"}});
        const resData = await resp.json();
        if(!resData || resData.length == 0)
            return false;
        let lastSession = resData.sortByProperty("sessionDate")[0];
        //let firstSession = resData.sortByProperty("sessionDate")[resData.length-1]; check with start date !!!
        if(endDate < lastSession.sessionDate){
            simpleDialog("<spring:message code="message"/>",'<spring:message code="session.date.after.class.end.date"/>' , "0", "error");
            return true;
        }
    }
    
    function getDaysOfClass(classId) {
        wait.show();
        isc.RPCManager.sendRequest({
            actionURL: attendanceUrl + "/session-date?classId=" + classId,
            httpMethod: "GET",
            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
            useSimpleHttp: true,
            contentType: "application/json; charset=utf-8",
            showPrompt: false,
            serverOutputAsString: false,
            callback: function (resp) {
                wait.close()
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    let result = JSON.parse(resp.data).response.data;
                    DynamicForm_Class_JspClass.setValue("dDuration", result.length);
                }
            }
        });
    }

    function tabSet_class_status(classRecord) {
        if ((ListGrid_Class_JspClass.getSelectedRecord() === null) || (ListGrid_Class_JspClass.getSelectedRecord().classStatus === "4")) {
            TabSet_Class.disable();
            isReadOnlyClass = true;
            return;
        }
        isReadOnlyClass = ListGrid_Class_JspClass.getSelectedRecord().workflowEndingStatusCode === 2;
        TabSet_Class.enable();
        <sec:authorize access="hasAuthority('TclassPreCourseTestQuestionsTab')">
        if (classRecord.preCourseTest && classRecord.evaluation !== "1") {
            //  TabSet_Class.getTab("classPreCourseTestQuestionsTab").show();
        } else {
            if (TabSet_Class.getSelectedTab().ID === "classPreCourseTestQuestionsTab") {
                TabSet_Class.selectTab(0);
            }
            //  TabSet_Class.getTab("classPreCourseTestQuestionsTab").hide();
        }
        </sec:authorize>
    }

    //*****check class is ready to end or no*****
    function checkEndingClass(oldValue) {
        let record = ListGrid_Class_JspClass.getSelectedRecord();
        if (record !== null) {

            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(attendanceUrl + "/attendance-completion?classId=" + record.id, "GET", null, function (resp) {
                wait.close();
                if(resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    let result = JSON.parse(resp.httpResponseText);
                    if (result == true) {
                        TabSet_Class.selectTab("classAlarmsTab");
                        isc.Dialog.create({
                            message: "حضور غیاب تکمیل نشده است",
                            icon: "[SKIN]ask.png",
                            title: "<spring:message code="message"/>",
                            buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                            buttonClick: function (button, index) {
                                this.close();
                            }
                        });
                        classTypeStatus.setValue(oldValue);
                        highlightClassStauts(oldValue, 10);
                    } else {
                        isc.RPCManager.sendRequest(TrDSRequest(classUrl + "checkEndingClass/" + record.id + "/" + record.endDate.replaceAll("/", "-"), "GET", null, function (resp) {
                            wait.close();
                            if (resp.data !== "") {
                                TabSet_Class.selectTab("classAlarmsTab");
                                isc.Dialog.create({
                                    message: resp.data,
                                    icon: "[SKIN]ask.png",
                                    title: "<spring:message code="message"/>",
                                    buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                                    buttonClick: function (button, index) {
                                        this.close();
                                    }
                                });
                                classTypeStatus.setValue(oldValue);
                                highlightClassStauts(oldValue, 10);
                            }
                        }));
                    }
                } else {
                    createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                }
            }));
        }
    }

    function hasClassStarted(oldValue) {
        let record = ListGrid_Class_JspClass.getSelectedRecord();
        if (record !== null) {
            wait.show()
            isc.RPCManager.sendRequest(TrDSRequest(classUrl + "hasClassStarted/" + record.id, "GET", null, function (resp) {
                wait.close()
                if (resp.data !== "") {
                    if (resp.data == "false") {
                        classTypeStatus.setValue(oldValue);
                        highlightClassStauts(oldValue, 10);
                        isc.Dialog.create({
                            message: "تاریخ شروع کلاس " + ListGrid_Class_JspClass.getSelectedRecord().startDate + " می باشد",
                            icon: "[SKIN]ask.png",
                            title: "<spring:message code="message"/>",
                            buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                            buttonClick: function (button, index) {
                                this.close();
                            }
                        });
                    }
                }
            }));
        }
    }

    function getOrganizers() {
        if (userPersonInfo !== null && userPersonInfo !== undefined) {
            wait.show()
            isc.RPCManager.sendRequest(TrDSRequest(classUrl + "defaultExecutor/DefaultClassOrganizer/" + userPersonInfo.complexTitle, "GET", null,
                function (resp) {
                    wait.close()
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201)
                        setOrganize(JSON.parse(resp.data));
                }
            ));
        }
    }

    function setOrganize(institute) {
        DynamicForm_Class_JspClass.setValue("organizerId", institute.id)
    }

    function sendClassToOnline(classId) {
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest("/training/anonymous/els/classToEls/" + classId, "GET", null, function (resp) {
            if (resp.httpResponseCode === 200) {
                wait.close();
                createDialog("info", "ارسال اطلاعات کلاس به سیستم آزمون آنلاین با موفقیت انجام شد(سیستم در حال توسعه می باشد)", "<spring:message code="message"/>")
                ListGrid_Class_JspClass.invalidateCache();
            } else {
                wait.close();
                createDialog("info", "اطلاعات کلاس به سیستم آزمون آنلاین ارسال نشد", "<spring:message code="message"/>")
            }
        }));
    }
    // <<---------------------------------------- Send To Workflow ----------------------------------------
    function sendEndingClassToWorkflow() {
        let sRecord = VM_JspClass.getValues();
        wait.show()
        isc.RPCManager.sendRequest(TrDSRequest(classUrl + "getWorkflowEndingStatusCode/" + sRecord.id, "GET", null, function (resp) {
            wait.close()
            let workflowStatusCode = resp.data;
            if (classMethod.localeCompare("PUT") === 0 && sRecord.classStatus === "3" && (workflowStatusCode === "" || workflowStatusCode === "-3")) {
                let varParams = [{
                    "processKey": "endingClassWorkflow",
                    "cId": parseInt(sRecord.id),
                    "classCode": sRecord.code,
                    "titleClass": sRecord.titleClass,
                    "teacher": sRecord.teacher,
                    "term": sRecord.term.titleFa,
                    "classCreatorId": "${username}",
                    "classCreator": userFullName,
                    "REJECTVAL": "",
                    "REJECT": "",
                    "target": "/tclass/show-form",
                    "targetTitleFa": "کلاس",
                    "workflowStatus": "درخواست پایان کلاس",
                    "workflowStatusCode": "0"
                }];
                wait.show()
                ///// //disable until set permission to ending class// isc.RPCManager.sendRequest(TrDSRequest(workflowUrl + "/startProcess", "POST", JSON.stringify(varParams), startProcess_callback));
            }
        }));
    }

    function startProcess_callback(resp) {
        wait.close()
        if (resp.httpResponseCode === 200) {
            isc.say("<spring:message code='course.set.on.workflow.engine'/>");
            ListGrid_Class_refresh();
        } else if (resp.httpResponseCode === 404) {
            isc.say("<spring:message code='workflow.bpmn.not.uploaded'/>");
        } else {
            isc.say("<spring:message code='msg.send.to.workflow.problem'/>");
        }
    }

    var class_workflowParameters = null;

    function selectWorkflowRecord() {
        if (workflowRecordId !== null) {
            class_workflowParameters = workflowParameters;
            let gridState = "[{id:" + workflowRecordId + "}]";
            ListGrid_Class_JspClass.setSelectedState(gridState);
            ListGrid_Class_JspClass.scrollToRow(ListGrid_Class_JspClass.getRecordIndex(ListGrid_Class_JspClass.getSelectedRecord()), 0);
            workflowRecordId = null;
            workflowParameters = null;
            ListGrid_class_edit();
            taskConfirmationWindow.maximize();
        }
    }

    function sendToWorkflowAfterUpdate(selectedRecord) {
        let sRecord = selectedRecord;
        if (sRecord !== null && sRecord.id !== null && class_workflowParameters !== null) {
            if (sRecord.workflowEndingStatusCode === -1 || sRecord.workflowEndingStatusCode === -2) {
                class_workflowParameters.workflowdata["REJECT"] = "N";
                class_workflowParameters.workflowdata["REJECTVAL"] = " ";
                class_workflowParameters.workflowdata["classCode"] = sRecord.code;
                class_workflowParameters.workflowdata["titleClass"] = sRecord.titleClass;
                class_workflowParameters.workflowdata["teacher"] = sRecord.teacher;
                class_workflowParameters.workflowdata["term"] = sRecord.term.titleFa;
                class_workflowParameters.workflowdata["classCreatorId"] = "${username}";
                class_workflowParameters.workflowdata["classCreator"] = userFullName;
                class_workflowParameters.workflowdata["workflowStatus"] = "اصلاح پایان کلاس";
                class_workflowParameters.workflowdata["workflowEndingStatusCode"] = "20";
                let ndat = class_workflowParameters.workflowdata;
                wait.show();
                isc.RPCManager.sendRequest({
                    actionURL: workflowUrl + "/doUserTask",
                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                    httpMethod: "POST",
                    useSimpleHttp: true,
                    contentType: "application/json; charset=utf-8",
                    showPrompt: false,
                    data: JSON.stringify(ndat),
                    params: {"taskId": class_workflowParameters.taskId, "usr": class_workflowParameters.usr},
                    serverOutputAsString: false,
                    callback: function (RpcResponse_o) {
                        wait.close();
                        if (RpcResponse_o.data === 'success') {
                            ListGrid_Class_refresh();
                            let responseID = sRecord.id;
                            let gridState = "[{id:" + responseID + "}]";
                            ListGrid_Class_JspClass.setSelectedState(gridState);
                            ListGrid_Class_JspClass.scrollToRow(ListGrid_Class_JspClass.getRecordIndex(ListGrid_Class_JspClass.getSelectedRecord()), 0);
                            isc.say("پایان کلاس ویرایش و به گردش کار ارسال شد");
                            taskConfirmationWindow.hide();
                            taskConfirmationWindow.maximize();
                            ListGrid_UserTaskList.invalidateCache();
                        }
                    }
                });
            }
        }
    }

    function getTargetSocieties(id) {
        DataSource_TargetSociety_List.testData.forEach(function (currentValue, index, arr) {
            DataSource_TargetSociety_List.removeData(currentValue)
        });
        wait.show();
        isc.RPCManager.sendRequest(
            TrDSRequest(targetSocietyUrl + "getListById/" + id, "GET", null, function (resp) {
                wait.close();
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    var societies = [];
                    var item = 0;
                    DataSource_TargetSociety_List.testData.forEach(function (currentValue, index, arr) {
                        DataSource_TargetSociety_List.removeData(currentValue)
                    });
                    DynamicForm_Class_JspClass.getItem("targetSocietyTypeId").setValue("371");
                    DynamicForm_Class_JspClass.getItem("targetSocieties")._value = undefined;
                    JSON.parse(resp.data).forEach(currentValue =>
                        {
                            if (currentValue.targetSocietyTypeId === 371) {
                                societies.add(currentValue.societyId);
                                DynamicForm_Class_JspClass.getItem("targetSocieties").valueField = "societyId";
                                DynamicForm_Class_JspClass.getItem("targetSocietyTypeId").setValue(currentValue.targetSocietyTypeId.toString());
                                DataSource_TargetSociety_List.addData(currentValue);
                                singleTargetScoiety.add(currentValue);
                            } else if (currentValue.targetSocietyTypeId === 372) {
                                societies.add(currentValue.title);
                                DynamicForm_Class_JspClass.getItem("targetSocieties").valueField = "title";
                                DataSource_TargetSociety_List.addData({societyId: item, title: currentValue.title});
                                etcTargetSociety.add(currentValue.title);
                                item -= 1;
                                DynamicForm_Class_JspClass.getItem("targetSocietyTypeId").setValue(currentValue.targetSocietyTypeId.toString());
                            }
                        }
                    );
                    DynamicForm_Class_JspClass.getItem("targetSocieties").setValue(societies);
                }
            })
        );
    }

    function setSocieties() {
        var selectedSocieties = [];
        selectedSocieties.addAll(DynamicForm_Class_JspClass.getItem("targetSocieties").getValue());
        chosenDepartments_JspOC.data.forEach(function (currentValue, index, arr) {
            const found = singleTargetScoiety.some(st => st.id === currentValue.id);
            if (!found){
                DataSource_TargetSociety_List.addData({societyId: currentValue.id, title: currentValue.title});
                singleTargetScoiety.add({societyId: currentValue.id, title: currentValue.title});
                selectedSocieties.add(currentValue.id);
                DynamicForm_Class_JspClass.getItem("targetSocieties").setValue(selectedSocieties);
            }
        });
    }

    function autoTimeActivation(active = true) {
        if (active) {
            DynamicForm1_Class_JspClass.getField("autoValid").enable();
        } else if (!active) {
            DynamicForm1_Class_JspClass.getField("autoValid").disable();
        }
        weekDateActivation(active);
    }

    function weekDateActivation(active = true) {
        let times = [
            "first", "second", "third", "fourth", "fifth",
            "saturday", "sunday", "monday", "tuesday", "wednesday", "thursday", "friday"];

        if (active && DynamicForm1_Class_JspClass.getField("autoValid")._value) {
            times.forEach(
                function (currentValue, index, arr) {
                    DynamicForm1_Class_JspClass.getField(currentValue).enable();
                });
        } else if (!active || !DynamicForm1_Class_JspClass.getField("autoValid")._value) {
            times.forEach(
                function (currentValue, index, arr) {
                    DynamicForm1_Class_JspClass.getField(currentValue).disable();
                });
        }
    }

    // ---------------------------------------- Send To Workflow ---------------------------------------->>
    //*****set save button status*****


    function saveButtonStatus() {
        let sRecord = VM_JspClass.getValues();
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(classUrl + "getWorkflowEndingStatusCode/" + sRecord.id, "GET", null, function (resp) {
            wait.close();
            let workflowStatusCode = resp.data;

            if (sRecord.classStatus === "3") {
                if (workflowStatusCode === "-1" || workflowStatusCode === "-2" || workflowStatusCode === "-3" || workflowStatusCode === "") {
                    IButton_Class_Save_JspClass.enable();
                    IButton_Class_Save_JspClass.setOpacity(100);
                } else {
                    IButton_Class_Save_JspClass.disable();
                    IButton_Class_Save_JspClass.setOpacity(30);
                    createDialog("info", "بدلیل پایان کلاس امکان ویرایش وجود ندارد", "<spring:message code="message"/>")
                }
            } else if (sRecord.classStatus === "4") {
                createDialog("info", "کلاس انتخاب شده لغو شده است و امکان ویرایش آن وجود ندارد.", "هشدار");
            }else {
                IButton_Class_Save_JspClass.enable();
                IButton_Class_Save_JspClass.setOpacity(100);
            }

        }));
    }

    ////*****load term by year*****
    function load_term_by_year(value) {
        let criteria = '{"fieldName":"startDate","operator":"iStartsWith","value":"' + value + '"}';
        if (ListGrid_Class_JspClass.implicitCriteria) {
            let plannerCriteria = ListGrid_Class_JspClass.implicitCriteria.criteria.filter(c => c.fieldName
                == "plannerId");
            if (plannerCriteria.size() > 0) {
                criteria.concat(plannerCriteria[0]);
            }
        }
        RestDataSource_Term_Filter.fetchDataURL = termUrl + "spec-list?operator=or&_constructor=AdvancedCriteria&criteria=" + criteria;
        DynamicForm_Term_Filter.getItem("termFilter").fetchData();
    }

    ////*****load classes by term*****
    function load_classes_by_term(value) {
        //id -> 61 = id lock in work group table
        //id -> 81 = id unLock in work group table
        isc.RPCManager.sendRequest(TrDSRequest(hasAccessToChangeClassStatus+"61,81", "GET",null, function (resp) {
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                if (resp.data === "false" )
                    TabSet_Class.disableTab(TabSet_Class.getTab("classFinish"));
                else
                    TabSet_Class.enableTab(TabSet_Class.getTab("classFinish"));

            } else {
                TabSet_Class.disableTab(TabSet_Class.getTab("classFinish"));
            }
        }));
        if (value !== undefined) {
            let criteria = {
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [
                    {fieldName: "term.id", operator: "inSet", value: value}
                ]
            };
            if (ListGrid_Class_JspClass.implicitCriteria) {
                let plannerCriteria = ListGrid_Class_JspClass.implicitCriteria.criteria.filter(c => c.fieldName
                    == "plannerId");
                if (plannerCriteria.size() > 0) {
                    criteria.criteria.push(plannerCriteria[0]);
                }
            }
            RestDataSource_Class_JspClass.fetchDataURL = classUrl + "spec-list";
            mainTermCriteria = criteria;
            let mainCriteria = createMainCriteria();
            ListGrid_Class_JspClass.invalidateCache();
            if(departmentCriteria.criteria===undefined)
                wait.close();
            else
            ListGrid_Class_JspClass.fetchData(mainCriteria);
        } else {
            createDialog("info", "<spring:message code="msg.select.term.ask"/>", "<spring:message code="message"/>")
        }
    }

    ////*****load classes by department*****
    function load_classes_by_department(value) {
                if (value !== undefined) {
                    let criteria = {
                        _constructor: "AdvancedCriteria",
                        operator: "and",
                        criteria: [
                            {
                                fieldName: "complexId", operator: "inSet", value: value
                            }
                        ]
                    };
                    if (ListGrid_Class_JspClass.implicitCriteria) {
                        let termCriteria = ListGrid_Class_JspClass.implicitCriteria.criteria.filter(c => c.fieldName
                            == "term.id");
                        if (termCriteria.size() > 0) {
                            criteria.criteria.push(termCriteria[0]);
                        }
                    }
                    RestDataSource_Class_JspClass.fetchDataURL = classUrl + "spec-list";
                    departmentCriteria = criteria;
                    let mainCriteria = createMainCriteria();
                    ListGrid_Class_JspClass.invalidateCache();
                    ListGrid_Class_JspClass.fetchData(mainCriteria);
                } else {
                    createDialog("info", "<spring:message code="msg.select.term.ask"/>", "<spring:message code="message"/>")
                }

    }
    ////******************************

    function setDefaultTerm() {
        isc.RPCManager.sendRequest(TrDSRequest(classUrl + "termScope", "GET", null,
            function (resp) {
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    let termScope = JSON.parse(resp.httpResponseText);
                    RestDataSource_Term_JspClass.implicitCriteria = {
                        _constructor: "AdvancedCriteria",
                        operator: "and",
                        criteria: [
                            {
                                fieldName: "code",
                                operator: "greaterOrEqual",
                                value: termScope[0]
                            },
                            {
                                fieldName: "code",
                                operator: "lessOrEqual",
                                value: termScope[1]
                            }
                        ]
                    };
                    fetchTermData();
                } else {
                    let persianDateArray = getTodayPersian();
                    let todayPersianDate = persianDateArray[0].toString().padStart(2,0) + "/" + persianDateArray[1].toString().padStart(2,0) + "/" +
                        persianDateArray[2].toString().padStart(2,0);
                    RestDataSource_Term_JspClass.implicitCriteria = {
                        _constructor: "AdvancedCriteria",
                        operator: "and",
                        criteria: [
                            {
                                fieldName: "endDate",
                                operator: "greaterOrEqual",
                                value: todayPersianDate
                            }
                        ]
                    };
                    fetchTermData();
                }
            }
        ));
    }

    function fetchTermData() {
        RestDataSource_Term_JspClass.fetchData(null, function (dsResponse, data, dsRequest) {
            if (data && data.length > 0) {

                let termIds = data.map(q => q.id);
                if (termIds.contains(termId)) {
                    DynamicForm1_Class_JspClass.setValue("termId", termId);
                    DynamicForm1_Class_JspClass.getItem("startDate").setValue(termStart);
                    DynamicForm1_Class_JspClass.getItem("endDate").setValue(termEnd);

                } else {
                    DynamicForm1_Class_JspClass.setValue("termId", Number.parseInt(data[0].id));
                    DynamicForm1_Class_JspClass.setValue("startDate", data[0].startDate);
                    DynamicForm1_Class_JspClass.setValue("endDate", data[0].endDate);
                }
            }
        });
    }
    //------------------------------------Evaluation------------------------------------------------------>>
    function Training_Reaction_Form_JspClass(classRecord) {

        let IButtonSave_SelectQuestionnarie_RE = isc.IButtonSave.create({
            title: "صدور/ارسال به کارتابل",
            width: 150,
            click: function () {
                if (ListGrid_SelectQuestionnarie_RE.getSelectedRecord() == null || ListGrid_SelectQuestionnarie_RE.getSelectedRecord() == undefined) {
                    createDialog("info", "پرسشنامه ای انتخاب نشده است.");
                } else {
                    Window_SelectQuestionnarie_RE.close();
                    create_evaluation_form_for_JspClass(null, ListGrid_SelectQuestionnarie_RE.getSelectedRecord().id, classRecord.supervisorId, 454, classRecord.teacherId, 187, 141, 154, classRecord.id, classRecord);
                }
            }
        });
        let RestDataSource_Questionnarie_RE = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {
                    name: "title",
                    title: "<spring:message code="title"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {name: "questionnaireTypeId", hidden: true},
                {
                    name: "questionnaireType.title",
                    title: "<spring:message code="type"/>",
                    required: true,
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
            ],
            fetchDataURL: questionnaireUrl + "/iscList/validQestionnaries/" + classRecord.id
        });
        let ListGrid_SelectQuestionnarie_RE = isc.TrLG.create({
            width: "100%",
            dataSource: RestDataSource_Questionnarie_RE,
            selectionType: "single",
            selectionAppearance: "checkbox",
            fields: [{name: "title"}, {name: "questionnaireType.title"}, {name: "description"}, {
                name: "id",
                hidden: true
            }]
        });
        let Window_SelectQuestionnarie_RE = isc.Window.create({
            width: 1024,
            placement: "fillScreen",
            keepInParentRect: true,
            title: "انتخاب پرسشنامه",
            items: [
                isc.HLayout.create({
                    width: "100%",
                    height: "90%",
                    members: [ListGrid_SelectQuestionnarie_RE]
                }),
                isc.TrHLayoutButtons.create({
                    width: "100%",
                    height: "5%",
                    members: [
                        IButtonSave_SelectQuestionnarie_RE,
                        isc.IButtonCancel.create({
                            click: function () {
                                Window_SelectQuestionnarie_RE.close();
                            }
                        })
                    ]
                })
            ],
            minWidth: 1024
        });
        let criteria = {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [
                {fieldName: "enabled", operator: "isNull"},
                {fieldName: "questionnaireTypeId", operator: "equals", value: 141}
            ]
        };
        ListGrid_SelectQuestionnarie_RE.fetchData(criteria);
        ListGrid_SelectQuestionnarie_RE.invalidateCache();
        Window_SelectQuestionnarie_RE.show();
    }

    function create_evaluation_form_for_JspClass(id, questionnarieId, evaluatorId,
                                             evaluatorTypeId, evaluatedId, evaluatedTypeId, questionnarieTypeId,
                                             evaluationLevel, classId, classRecord, check) {

            let data = {};
            data.classId = classRecord.id;
            data.status = false;
            // if (ReturnDate_RE._value != undefined)
            //     data.returnDate = ReturnDate_RE._value;
            data.sendDate = todayDate;
            data.evaluatorId = evaluatorId;
            data.evaluatorTypeId = evaluatorTypeId;
            data.evaluatedId = evaluatedId;
            data.evaluatedTypeId = evaluatedTypeId;
            data.questionnaireId = questionnarieId;
            data.questionnaireTypeId = questionnarieTypeId;
            data.evaluationLevelId = evaluationLevel;
            data.evaluationFull = false;
            data.description = null;
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl, "POST", JSON.stringify(data), function (resp) {
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    wait.close();
                    if(check == true) {}
                    else{
                        const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                        msg.show();
                    }
                    classRecord.evaluationStatusReactionTraining = 1;
                    ToolStrip_SendForms_JspClass.getField("sendButtonTraining").showIcon("ok");
                    ToolStrip_SendForms_JspClass.redraw();
                } else {
                    wait.close();
                    createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                }
            }));
    }

    function print_Training_Reaction_Form_JspClass(classRecord) {
        let myObj = {
            classId: classRecord.id,
            evaluationLevelId: 154,
            questionnarieTypeId: 141,
            evaluatorId: classRecord.supervisorId,
            evaluatorTypeId: 454,
            evaluatedId: classRecord.teacherId,
            evaluatedTypeId: 187
        };
        trPrintWithCriteria("<spring:url value="/evaluation/printEvaluationForm"/>", null, JSON.stringify(myObj));
    }

    function register_Training_Reaction_Form_JspClass(classRecord) {
        let evaluationResult_DS = isc.TrDS.create({
            fields:
                [
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "title", title: "<spring:message code="title"/>"},
                    {name: "code", title: "<spring:message code="code"/>"}
                ],
            autoFetchData: false,
            autoCacheAllData: true,
            fetchDataURL: parameterUrl + "/iscList/EvaluationResult"
        });
        let evaluationId;
        let valueMapAnswer = {209: "خیلی ضعیف", 208: "ضعیف", 207: "متوسط", 206: "خوب", 205: "عالی"};

        let DynamicForm_Questions_Title_JspEvaluation = isc.DynamicForm.create({
            numCols: 6,
            width: "100%",
            borderRadius: "10px 10px 0px 0px",
            border: "2px solid black",
            titleAlign: "left",
            margin: 10,
            padding: 10,
            fields: [
                {name: "code", title: "<spring:message code="class.code"/>:", canEdit: false},
                {name: "titleClass", title: "<spring:message code='class.title'/>:", canEdit: false},
                {name: "startDate", title: "<spring:message code='start.date'/>:", canEdit: false},
                {name: "teacher", title: "<spring:message code='teacher'/>:", canEdit: false},
                {name: "user", title: "<spring:message code='user'/>:", canEdit: false},
                {name: "evaluationLevel", title: "<spring:message code="evaluation.level"/>:", canEdit: false},
                {
                    name: "evaluationType",
                    title: "<spring:message code="evaluation.type"/>:",
                    canEdit: false,
                    endRow: true
                },
                {name: "evaluator", title: "<spring:message code="evaluator"/>:", canEdit: false,},
                {name: "evaluated", title: "<spring:message code="evaluation.evaluated"/>:", canEdit: false}
            ]
        });

        let DynamicForm_Questions_Body_JspEvaluation = isc.DynamicForm.create({
            validateOnExit: true,
            colWidths: ["45%", "50%"],
            cellBorder: 1,
            width: "100%",
            padding: 10,
            styleName: "teacher-form",
            fields: []
        });

        let DynamicForm_Description_JspEvaluation = isc.DynamicForm.create({
            width: "100%",
            fields: [
                {
                    name: "description",
                    title: "<spring:message code='description'/>",
                    type: 'textArea',
                    height: 100,
                    length: "600",
                    enforceLength : true
                }
            ]
        });

        let IButton_Questions_Save = isc.IButtonSave.create({
            click: function () {
                let evaluationAnswerList = [];
                let data = {};
                let evaluationFull = true;
                let evaluationEmpty = true;
                let questions = DynamicForm_Questions_Body_JspEvaluation.getFields();
                for (let i = 0; i < questions.length; i++) {
                    if (DynamicForm_Questions_Body_JspEvaluation.getValue(questions[i].name) === undefined) {
                        evaluationFull = false;
                    }
                    else{
                        evaluationEmpty = false;
                    }
                    let evaluationAnswer = {};
                    evaluationAnswer.answerID = DynamicForm_Questions_Body_JspEvaluation.getValue(questions[i].name);
                    evaluationAnswer.id = questions[i].name.substring(1);
                    evaluationAnswerList.push(evaluationAnswer);
                }
                data.evaluationAnswerList = evaluationAnswerList;
                data.evaluationFull = evaluationFull;
                data.description = DynamicForm_Description_JspEvaluation.getField("description").getValue();
                data.classId = classRecord.id;
                data.evaluatorId = classRecord.supervisor.id;
                data.evaluatorTypeId = 454;
                data.evaluatedId = classRecord.teacherId;
                data.evaluatedTypeId = 187;
                data.questionnaireTypeId = 141;
                data.evaluationLevelId = 154;
                if(evaluationEmpty == false){
                    isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/" + evaluationId, "PUT", JSON.stringify(data), function (resp) {
                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                            Window_Questions_JspEvaluation.close();
                            isc.RPCManager.sendRequest(TrDSRequest(evaluationAnalysisUrl + "/updateEvaluationAnalysis" + "/" +
                                classRecord.id, "GET", null, null));
                            const msg = createDialog("info", "<spring:message code="global.form.request.successful"/>");
                            setTimeout(() => {
                                msg.close();
                            }, 3000);
                        } else {
                            createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                        }
                    }))
                }
                else{
                    createDialog("info", "حداقل به یکی از سوالات فرم ارزیابی باید جواب داده شود", "<spring:message code="error"/>");
                }
            }
        });
        let Window_Questions_JspEvaluation = isc.Window.create({
            width: 1024,
            height: 768,
            keepInParentRect: true,
            title: "<spring:message code="record.evaluation.results"/>",
            items: [
                DynamicForm_Questions_Title_JspEvaluation,
                DynamicForm_Questions_Body_JspEvaluation,
                DynamicForm_Description_JspEvaluation,
                isc.TrHLayoutButtons.create({
                    members: [
                        IButton_Questions_Save,
                        isc.IButtonCancel.create({
                            click: function () {
                                Window_Questions_JspEvaluation.close();
                            }
                        })]
                })
            ],
            minWidth: 1024
        });
        let itemList = [];

        DynamicForm_Questions_Title_JspEvaluation.clearValues();
        DynamicForm_Description_JspEvaluation.clearValues();
        DynamicForm_Questions_Body_JspEvaluation.clearValue();
        DynamicForm_Questions_Title_JspEvaluation.getItem("code").setValue(classRecord.code);
        DynamicForm_Questions_Title_JspEvaluation.getItem("titleClass").setValue(classRecord.course.titleFa);
        DynamicForm_Questions_Title_JspEvaluation.getItem("startDate").setValue(classRecord.startDate);
        DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationType").setValue("ارزیابی مسئول آموزش از مدرس");
        DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationLevel").setValue("واکنشی");
        DynamicForm_Questions_Title_JspEvaluation.setValue("user", "<%= SecurityUtil.getFullName()%>");
        isc.RPCManager.sendRequest(TrDSRequest(teacherUrl + "teacherFullName/" + classRecord.teacherId, "GET", null, function (resp1) {
            DynamicForm_Questions_Title_JspEvaluation.getItem("teacher").setValue(resp1.httpResponseText);
            DynamicForm_Questions_Title_JspEvaluation.setValue("evaluated", resp1.httpResponseText);
            isc.RPCManager.sendRequest(TrDSRequest(personnelUrl + "/personnelFullName/" + classRecord.supervisor.id, "GET", null, function (resp2) {
                DynamicForm_Questions_Title_JspEvaluation.setValue("evaluator", resp2.httpResponseText);
                load_evaluation_form_RTr2();
            }));
        }));
        Window_Questions_JspEvaluation.show();
        evalWait_RE = createDialog("wait");
        function load_evaluation_form_RTr2(criteria, criteriaEdit) {
            let data = {};
            data.classId = classRecord.id;
            data.evaluatorId = classRecord.supervisor.id;
            data.evaluatorTypeId = 454;
            data.evaluatedId = classRecord.teacherId;
            data.evaluatedTypeId = 187;
            data.questionnaireTypeId = 141;
            data.evaluationLevelId = 154;
            let itemList = [];
            let description;
            let record = {};

            isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/getEvaluationForm", "POST", JSON.stringify(data), function (resp) {
                let result = JSON.parse(resp.httpResponseText).response.data;
                description = result[0].description;
                evaluationId = result[0].evaluationId;
                for (let i = 0; i < result.size(); i++) {
                    let item = {};
                    if (result[i].questionSourceId == 199) {
                        switch (result[i].domainId) {
                            case 54:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
                                item.title = "امکانات: " + result[i].question;
                                break;
                            case 138:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
                                item.title = "کلاس: " + result[i].question;
                                break;
                            case 53:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
                                item.title = "مدرس: " + result[i].question;
                                break;
                            case 1:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
                                item.title = "مدرس: " + result[i].question;
                                break;
                            case 183:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
                                item.title = "محتواي کلاس: " + result[i].question;
                                break;
                            default:
                                item.name = "Q" + result[i].id;
                                item.domainId = result[i].domainId;
                                item.title = result[i].question;
                        }
                        item.type = "radioGroup";
                        item.vertical = false;
                        item.fillHorizontalSpace = true;
                        item.valueMap = valueMapAnswer;
                        item.icons = [
                            {
                                name: "clear",
                                src: "[SKIN]actions/remove.png",
                                width: 15,
                                height: 15,
                                inline: true,
                                prompt: "پاک کردن",
                                click: function (form, item, icon) {
                                    item.clearValue();
                                    item.focusInItem();
                                }
                            }
                        ];
                        record["Q" + result[i].id] = result[i].answerId;
                    } else if (result[i].questionSourceId == 200) {
                        item.name = "M" + result[i].id;
                        item.title = "هدف اصلی: " + result[i].question;
                        item.type = "radioGroup";
                        item.vertical = false;
                        item.fillHorizontalSpace = true;
                        item.valueMap = valueMapAnswer;
                        item.icons = [
                            {
                                name: "clear",
                                src: "[SKIN]actions/remove.png",
                                width: 15,
                                height: 15,
                                inline: true,
                                prompt: "پاک کردن",
                                click: function (form, item, icon) {
                                    item.clearValue();
                                    item.focusInItem();
                                }
                            }
                        ];
                        record["M" + result[i].id] = result[i].answerId;
                    } else if (result[i].questionSourceId == 201) {
                        item.name = "G" + result[i].id;
                        item.title = "هدف: " + result[i].question;
                        item.type = "radioGroup";
                        item.vertical = false;
                        item.fillHorizontalSpace = true;
                        item.valueMap = valueMapAnswer;
                        item.icons = [
                            {
                                name: "clear",
                                src: "[SKIN]actions/remove.png",
                                width: 15,
                                height: 15,
                                inline: true,
                                prompt: "پاک کردن",
                                click: function (form, item, icon) {
                                    item.clearValue();
                                    item.focusInItem();
                                }
                            }
                        ];
                        record["G" + result[i].id] = result[i].answerId;
                    }
                    itemList.add(item);
                }
                itemList.sortByProperty("domainId", true);
                DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                DynamicForm_Description_JspEvaluation.getField("description").setValue(description);
                DynamicForm_Questions_Body_JspEvaluation.setValues(record);
                evalWait_RE.close();
            }));
        }
    }

    function Training_Reaction_Form_Inssurance_JspClass(classRecord) {
        let QId = null;
        let criteria = {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [
                {fieldName: "enabled", operator: "isNull"},
                {fieldName: "questionnaireTypeId", operator: "equals", value: 141}
            ]
        };

        isc.RPCManager.sendRequest(TrDSRequest(questionnaireUrl + "/getLastQuestionnarieId?criteria=" + JSON.stringify(criteria), "GET", null, function (resp) {
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                QId = resp.httpResponseText;
                if (QId != null && QId != undefined && classRecord.supervisorId != undefined && classRecord.teacherId != undefined)
                    create_evaluation_form_JspClass(null, QId, classRecord.supervisorId, 454, classRecord.teacherId, 187, 141, 154, classRecord.id);
            }
        }));
    }

    function create_evaluation_form_JspClass(id, questionnarieId, evaluatorId,
                                             evaluatorTypeId, evaluatedId, evaluatedTypeId, questionnarieTypeId,
                                             evaluationLevel, classId) {
        let data = {};
        data.classId = classId;
        data.status = false;
        data.sendDate = todayDate;
        data.evaluatorId = evaluatorId;
        data.evaluatorTypeId = evaluatorTypeId;
        data.evaluatedId = evaluatedId;
        data.evaluatedTypeId = evaluatedTypeId;
        data.questionnaireId = questionnarieId;
        data.questionnaireTypeId = questionnarieTypeId;
        data.evaluationLevelId = evaluationLevel;
        data.evaluationFull = false;
        data.description = null;
        isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl, "POST", JSON.stringify(data), function (resp) {
        }));
    }

    //Amin HK
    //Highlight a selected item in a radio group
    function highlightClassStauts(value, time) {
        IButton_Class_Save_JspClass.show();
            if ("5" === value)
            {
                DynamicForm_Class_JspClass.getField("classStatus").getItem(0).disable();
                DynamicForm_Class_JspClass.getField("classStatus").getItem(1).disable();
                DynamicForm_Class_JspClass.getField("classStatus").getItem(2).disable();
                IButton_Class_Save_JspClass.hide();
                IButton_Class_Save_JspClass.setOpacity(30);
                createDialog("info", "بدلیل اختتام کلاس امکان ویرایش وجود ندارد", "<spring:message code="message"/>")
            }
            else
            {
                IButton_Class_Save_JspClass.show();
                IButton_Class_Save_JspClass.setOpacity(100);
                DynamicForm_Class_JspClass.getField("classStatus").getItem(3).disable();
            }

        setTimeout(() => {
            let mapDictionary = {1: "برنامه ریزی", 2: "در حال اجرا", 3: "پایان یافته",5: "اختتام"};
            let result = $('input[type="radio"][name="classStatus"]').parent().next();
            Object.keys(result).forEach(x => {
                if (x != "length" && x != "prevObject") {
                    result[x].setAttribute("style", "font-weight:normal");

                    if (result[x].innerText === mapDictionary[value]) {
                        result[x].setAttribute("style", "font-weight:bold");
                    }
                }
            });
        }, time);
    }

    function createMainCriteria() {
        let mainCriteria = {};
        mainCriteria._constructor = "AdvancedCriteria";
        mainCriteria.operator = "and";
        mainCriteria.criteria = [];
        mainCriteria.criteria.add(departmentCriteria);
        mainCriteria.criteria.add(yearCriteria);
        mainCriteria.criteria.add(mainTermCriteria);
        return mainCriteria;
    }