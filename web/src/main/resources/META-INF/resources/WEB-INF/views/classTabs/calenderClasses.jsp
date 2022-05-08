<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>
    {
        var studentRemoveWait;
        var studentDefaultPresenceId = 103;
        var evalData;
        var isEditing = false;
        var url = '';
        var studentSelection = false;
        var selectedRecord_addStudent_class = '';
        var checkRefresh = 0;
        var selectedRow = {};
        var listGridType = null;
        let previousSelectedRow = {};
        let previousSelectedRowReg = {};

        // ------------------------------------------- Menu -------------------------------------------
        let ClassMenu_calender = isc.Menu.create({
            data: [


                {
                    title: "<spring:message code="refresh"/>",
                    icon: "<spring:url value="refresh.png"/>",
                    click: function () {

                        // refreshStudentsLG_student();
                    }
                },


                {
                    title: "<spring:message code="add"/>",
                    icon: "<spring:url value="create.png"/>",
                    click: function () {
                        // addStudent_student();
                    }
                },


                {
                    title: "<spring:message code="remove"/>",
                    icon: "<spring:url value="remove.png"/>",
                    click: function () {
                        // removeStudent_student();
                    }
                },


            ]
        });

        // ------------------------------------------- ToolStrip -------------------------------------------
        let btnAdd_calender_class = isc.ToolStripButtonAdd.create({
            click: function () {
                // addStudent_student();
            }
        });

        let btnRemove_calender_class = isc.ToolStripButtonRemove.create({
            click: function () {
                // removeStudent_student();
            }
        });

        let calenderTS_class = isc.ToolStrip.create({
            members: [


                btnAdd_calender_class,


                btnRemove_calender_class,


                isc.ToolStripButtonRefresh.create({
                    click: function () {
                        // refreshStudentsLG_student();
                    }
                }),

            ]
        });

        let PersonnelsTS_student = isc.ToolStrip.create({
            members: [
                isc.LayoutSpacer.create({width: "*"}),
                isc.Label.create({ID: "PersonnelsCount_student"}),
            ]
        });

        let SynonymPersonnelsTS_student = isc.ToolStrip.create({
            members: [
                isc.LayoutSpacer.create({width: "*"}),
                isc.Label.create({ID: "SynonymPersonnelsCount_student"}),
            ]
        });

        let RegisteredTS_student = isc.ToolStrip.create({
            members: [
                isc.LayoutSpacer.create({width: "*"}),
                isc.Label.create({ID: "RegisteredCount_student"}),
            ]
        });

        // ------------------------------------------- DataSource & ListGrid --------------------------------------
        //
        <%--var RestDataSource_Messages_student = isc.TrDS.create({--%>
        <%--    fields: [--%>
        <%--        {name: "code", title: "<spring:message code='course.code'/>", filterOperator: "equals"},--%>
        <%--        {name: "title", title: "<spring:message code='group.code'/>", filterOperator: "iContains"},--%>
        <%--        {name: "description", title: "<spring:message code='course.title'/>", filterOperator: "iContains"},--%>
        <%--    ]--%>
        <%--});--%>
        <%--let RestDataSource_company_Student = isc.TrDS.create({--%>
        <%--    fields: [--%>
        <%--        {name: "id", primaryKey: true, hidden: true},--%>
        <%--        {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},--%>
        <%--        {name: "workDomain", title: "<spring:message code="workDomain"/>", filterOperator: "iContains"},--%>
        <%--        {name: "email", title: "<spring:message code="email"/>", filterOperator: "iContains"},--%>
        <%--    ],--%>
        <%--    canAddFormulaFields: false,--%>
        <%--    filterOnKeypress: true,--%>
        <%--    sortField: 1,--%>
        <%--    sortDirection: "descending",--%>
        <%--    dataPageSize: 50,--%>
        <%--    autoFetchData: true,--%>
        <%--    showFilterEditor: true,--%>
        <%--    allowAdvancedCriteria: true,--%>
        <%--    allowFilterExpressions: true,--%>
        <%--    // filterOnKeypress: false,--%>
        <%--    sortFieldAscendingText: "<spring:message code='sort.ascending'/>",--%>
        <%--    sortFieldDescendingText: "<spring:message code='sort.descending'/>",--%>
        <%--    configureSortText: "<spring:message code='configureSortText'/>",--%>
        <%--    autoFitAllText: "<spring:message code='autoFitAllText'/>",--%>
        <%--    autoFitFieldText: "<spring:message code='autoFitFieldText'/>",--%>
        <%--    filterUsingText: "<spring:message code='filterUsingText'/>",--%>
        <%--    groupByText: "<spring:message code='groupByText'/>",--%>
        <%--    freezeFieldText: "<spring:message code='freezeFieldText'/>",--%>
        <%--    fetchDataURL: companyUrl + "spec-list"--%>
        <%--});--%>

        let calenderDS_class = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true},
                {name: "group"},
                {name: "hduration", canFilter: false},
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
                {name: "teacher", utoFitWidth: true},
                {name: "teacher.personality.lastNameFa", autoFitWidth: true},
                {name: "reason", autoFitWidth: true},
                {name: "classStatus", autoFitWidth: true},
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
        let StudentsDS_student2 = isc.TrDS.create({
            <%--transformRequest: function (dsRequest) {--%>
            <%--    dsRequest.httpHeaders = {--%>
            <%--        "Authorization": "Bearer <%= accessToken1 %>"--%>
            <%--    };--%>
            <%--    return this.Super("transformRequest", arguments);--%>
            <%--},--%>
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {name: "student.id", hidden: true},
                {
                    name: "student.firstName",
                    title: "<spring:message code="firstName"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "student.lastName",
                    title: "<spring:message code="lastName"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "student.nationalCode",
                    title: "<spring:message code="national.code"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "applicantCompanyName",
                    title: "<spring:message code="company.applicant"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "presenceTypeId",
                    title: "<spring:message code="class.presence.type"/>",
                    filterOperator: "equals",
                    autoFitWidth: true
                },
                {
                    name: "student.companyName",
                    title: "<spring:message code="company.name"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "student.personnelNo",
                    title: "<spring:message code="personnel.no"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "student.personnelNo2",
                    title: "<spring:message code="personnel.no.6.digits"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "student.postTitle",
                    title: "<spring:message code="post"/>",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "student.ccpArea",
                    title: "<spring:message code="reward.cost.center.area"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "student.ccpAssistant",
                    title: "<spring:message code="reward.cost.center.assistant"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "student.ccpAffairs",
                    title: "<spring:message code="reward.cost.center.affairs"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "student.ccpSection",
                    title: "<spring:message code="reward.cost.center.section"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "student.ccpUnit",
                    title: "<spring:message code="reward.cost.center.unit"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "student.fatherName",
                    title: "<spring:message code="father.name"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "student.contactInfo.smSMobileNumber",
                    title: "<spring:message code="mobile"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "student.birthCertificateNo",
                    title: "<spring:message code="birth.certificate.no"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "hasWarning",
                    title: " ",
                    width: 40,
                    type: "image",
                    imageURLPrefix: "",
                    imageURLSuffix: ".png",
                    canEdit: false
                },
                {name: "warning", autoFitWidth: true}

            ],

            fetchDataURL: tclassStudentUrl + "/students-iscList/"
        });

        let StudentsDS_PresenceType = isc.TrDS.create({
            fields: [
                {name: "id", primaryKey: true, hidden: true},
                {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
                {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
            ],
            fetchDataURL: parameterValueUrl + "/iscList/98"
        });

        let calenderLG_class = isc.TrLG.create({
            dataSource: calenderDS_class,
            selectionType: "multiple",
            sortField: 1,
            sortDirection: "descending",
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
                    name: "course.code",
                    title: "<spring:message code='course.code'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true

                },
                {
                    name: "course.theoryDuration",
                    title: "<spring:message code='duration'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true

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
                    name: "sendClassToOnlineBtn",
                    canFilter: false,
                    title: "ارسال به آزمون آنلاین",
                    width: "145",
                    hidden: true
                },
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
                    width: 40
                },
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
                    style = "background-color:" + "#fe9d2a;";
                } else if (record.workflowEndingStatusCode === 2) {
                    style = "background-color:" + "#bef5b8;";
                } else {
                    if (record.classStatus === "1")
                        style = "background-color:" + "#ffffff;";
                    else if (record.classStatus === "2")
                        style = "background-color:" + "#fff9c4;";
                    else if (record.classStatus === "3")
                        style = "background-color:" + "#cdedf5;";
                    else if (record.classStatus === "4")
                        style = "color:" + "#d6d6d7;";
                }
                if (this.getFieldName(colNum) == "teacher") {
                    style += "color: #0066cc;text-decoration: underline !important;cursor: pointer !important;}"
                }
                return style;
            },
            cellClick: function (record, rowNum, colNum) {
                if (this.getFieldName(colNum) == "teacher") {
                    ListGrid_teacher_edit(record.teacherId, "class")
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
    }


    // </script>
