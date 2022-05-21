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
        var classSelection = false;
        var selectedRecord_addClass_calender = '';
        var checkRefresh = 0;
        var selectedRow = {};
        var listGridType = null;
        let previousSelectedRow = {};
        let previousSelectedRowReg = {};
        var departmentCalenderCriteria = [];
        var yearCalenderCriteria = [];
        var mainTermCalenderCriteria = [];

        // ------------------------------------------- Menu -------------------------------------------
        CalenderMenu_calender = isc.Menu.create({
            data: [


                {
                    title: "<spring:message code="refresh"/>",
                    icon: "<spring:url value="refresh.png"/>",
                    click: function () {

                        refreshCalenderLG_calender();
                    }
                },


                {
                    title: "<spring:message code="add"/>",
                    icon: "<spring:url value="create.png"/>",
                    click: function () {
                        addClass_calender();
                    }
                },


            ]
        });

        // ------------------------------------------- ToolStrip -------------------------------------------
        let btnAdd_calender_class = isc.ToolStripButtonAdd.create({
            click: function () {
                addClass_calender();

            }
        });

        let btnRemove_calender_class = isc.ToolStripButtonRemove.create({
            click: function () {
                remove_educationalCalender_from_class();
            }
        });

        CalenderTS_calender = isc.ToolStrip.create({
            members: [


                btnAdd_calender_class,


                btnRemove_calender_class,


                isc.LayoutSpacer.create({width: "*"}),


                isc.ToolStripButtonRefresh.create({
                    click: function () {
                        refreshCalenderLG_calender();
                    }
                }),

            ]
        });

        // ------------------------------------------- DataSource & ListGrid --------------------------------------
        var calenderDS_class = isc.TrDS.create({
            fields: [
                {name: "id"},
                {name: "termId"},
                {name: "instituteId"},
                {name: "teacherId"},
                {name: "teacherFullName"},
                {name: "teacherLastName"},
                {name: "tclassStudentsCount"},
                {name: "studentOnlineEvalExecutionStatus"},
                {name: "tclassCode"},
                {name: "tclassStartDate"},
                {name: "tclassEndDate"},
                {name: "tclassYear"},
                {name: "courseCode"},
                {name: "courseCategory"},
                {name: "courseSubCategory"},
                {name: "courseTitleFa"},
                {name: "evaluation"},
                {name: "tclassDuration"},
                {name: "tclassOrganizerId"},
                {name: "tclassStatus"},
                {name: "tclassReason"},
                {name: "tclassEndingStatus"},
                {name: "tclassPlanner"},
                {name: "termTitleFa"},
                {name: "instituteTitleFa"},
                {name: "classScoringMethod"},
                {name: "classPreCourseTest"},
                {name: "courseId"},
                {name: "teacherEvalStatus"},
                {name: "trainingEvalStatus"},
                {name: "tclassSupervisor"},
                {name: "tclassTeachingType"},
                {name: "classTeacherOnlineEvalStatus"},
                {name: "teachingMethodTitle"},
                {name: "complexTitle"},
                {name: "complexTitle"},
                {name: "classGroup"},
                {name: "classStudentCost"},
                {name: "classStudentCostCurrency"},
                {name: "classCalenderId"},
                {name: "location"},
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
            ]


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

       var classDS_calender = isc.TrDS.create({
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
                {name: "classStatus", autoFitWidth: true,canFilter: true},
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
                {name: "classToOnlineStatus", type: "boolean"},
                {name: "classToOnlineStatus", type: "boolean"},
                {name: "educationalCalenderId"},
            ],

           fetchDataURL: classUrl + "calender-spec-list",
        });

        calenderLG_class = isc.TrLG.create({
            dataSource: calenderDS_class,
            selectionType: "multiple",
            sortField: 1,
            sortDirection: "descending",
            fields: [
                {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
                {
                    name: "tclassCode",
                    title: "<spring:message code='class.code'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true
                },
                {
                    name: "courseCode",
                    title: "<spring:message code='course.code'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true

                },
                {
                    name: "courseTitleFa",
                    title: "<spring:message code='course.title'/>",
                    align: "center",
                    filterOperator: "iContains",
                    sortNormalizer: function (record) {
                        return record.course.titleFa;
                    }
                },


                {
                    name: "tclassDuration",
                    title: "<spring:message code='duration'/>",
                    align: "center",
                    width: 40,
                    filterOperator: "iContains",

                },
                {
                    name: "complexTitle",
                    title: "<spring:message code="complex"/>",
                    canSort: false,
                    autoFitWidth: true,
                    align: "center",
                },
                {
                    name: "classGroup",
                    title: "<spring:message code='group'/>",
                    align: "center",
                    width: 40,
                    filterOperator: "equals",
                },

                {
                    name: "tclassStartDate",
                    title: "<spring:message code='start.date'/>",
                    align: "center",
                    filterOperator: "iContains",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9/]"
                    },
                },
                {
                    name: "tclassEndDate",
                    title: "<spring:message code='end.date'/>",
                    align: "center",
                    filterOperator: "iContains",
                    filterEditorProperties: {
                        keyPressFilter: "[0-9/]"
                    },
                },
                {
                    name: "classStudentCost",
                    title: "<spring:message code="student.cost"/>",
                    canSort: false,
                    autoFitWidth: true,
                    align: "center",
                },
                {
                    name: "classStudentCostCurrency",
                    title: "<spring:message code="student.cost.currency"/>",
                    canSort: false,
                    autoFitWidth: true,
                    align: "center",
                },

                {
                    name: "teachingMethodTitle",
                    title: "<spring:message code="teaching.method"/>",
                    canSort: false,
                    autoFitWidth: true,
                    align: "center",
                },
                {
                    name: "location",
                    title: "<spring:message code="present.location"/>",
                    canSort: false,
                    autoFitWidth: true,
                    align: "center",
                }



            ],
            getCellCSSText: function (record, rowNum, colNum) {
                let style;
                if (this.isSelected(record)) {
                    style = "background-color:" + "#fe9d2a;";
                }

                return style;
            },
            gridComponents: [CalenderTS_calender, "filterEditor", "header", "body"],
            dataArrived: function () {
                calenderLG_class.data.localData.filter(p => p.warning == 'Ok').forEach(p => p.hasWarning = 'checkBlue');
            },
            cellClick: function (record, rowNum, colNum) {
                // if (this.getFieldName(colNum) == "teacher") {
                //     ListGrid_teacher_edit(record.teacherId, "class")
                // }
            },
            // dataArrived: function () {
            //     wait.close();
            //     selectWorkflowRecord();
            // },


        });

       var classLG_calender = isc.ListGrid.create({
            // ID: "ClassLG_Calender",
            dataSource: classDS_calender,
           showFilterEditor: true,
           // allowAdvancedCriteria: true,
           // allowFilterExpressions: true,
           // filterOnKeypress: true,
            selectionType: "simple",
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
                    name: "course.code",
                    title: "<spring:message code='course.code'/>",
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
                    name: "hduration",
                    title: "<spring:message code='duration'/>",
                    align: "center",
                    width: 40,
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
                    name: "group",
                    title: "<spring:message code='group'/>",
                    align: "center",
                    width: 40,
                    filterOperator: "equals",
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
           alternateRecordStyles: true,
            selectionAppearance: "checkbox",

            selectionUpdated: function (record, recordList) {

                SelectedClassLG_calender.setData(this.getSelection());


            },
            cellClick: function (record, rowNum, colNum) {
                if (colNum === 5) {
                    selectedRecord_addClass_calender = {
                        code: record.code,
                        startDate: record.startDate,
                        endDate: record.endDate,
                        courseCode:record.course.code,
                        title:record.course.titleFa,
                        ccpArea: record.ccpArea,
                        ccpAffairs: record.ccpAffairs,

                    }

                    let window_class_calender_Information = isc.Window.create({
                        title: "<spring:message code="class.information"/>",
                        width: "70%",
                        minWidth: 500,
                        autoSize: false,
                        height: "50%",
                        closeClick: deleteCachedValue,
                        items: [isc.VLayout.create({
                            width: "100%",
                            height: "100%",

                        })]
                    });

                    if (!loadjs.isDefined('personnel-information-details')) {
                        loadjs('<spring:url value='web/personnel-information-details/' />', 'personnel-information-details');
                    }

                    loadjs.ready('personnel-information-details', function () {
                        oPersonnelInformationDetails = new loadPersonnelInformationDetails();
                        window_class_Information.addMember(oPersonnelInformationDetails.PersonnelInfo_Tab);
                    });

                    window_class_calender_Information.show();


                }
            }
        });

      var SelectedClassLG_calender = isc.TrLG.create({
            ID: "SelectedClassLG_calender",
            showFilterEditor: true,
            allowAdvancedCriteria: true,
            allowFilterExpressions: true,
            filterOnKeypress: true,
            selectionType: "single",
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
                    name: "course.code",
                    title: "<spring:message code='course.code'/>",
                    align: "center",
                    filterOperator: "iContains",
                    autoFitWidth: true

                },
                {
                    name: "educationalCalenderId",
                    title: "تقویم آموزشی",
                    align: "center",
                    hidden: true,
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
                    name: "hduration",
                    title: "<spring:message code='duration'/>",
                    align: "center",
                    width: 40,
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
                    name: "group",
                    title: "<spring:message code='group'/>",
                    align: "center",
                    width: 40,
                    filterOperator: "equals",
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

            gridComponents: ["filterEditor", "header", "body"],
            canRemoveRecords: true,

            cellClick: function (record, rowNum, colNum) {
                if (colNum === 4) {

                    selectedRecord_addClass_calende = {
                        code: record.code,
                        startDate: record.startDate,
                        endDate: record.endDate,

                    }

                    let window_class_calender_Information = isc.Window.create({
                        title: "<spring:message code="class.information"/>",
                        width: "70%",
                        minWidth: 500,
                        autoSize: false,
                        height: "50%",
                        closeClick: deleteCachedValue,
                        items: [isc.VLayout.create({
                            width: "100%",
                            height: "100%",

                        })]
                    });


                    window_class_calender_Information.show();


                }
            },
            getCellCSSText: function (record, rowNum, colNum) {
                let result = '';
                if (this.getFieldName(colNum) == "code") {
                    result += "color: #0066cc !important;text-decoration: underline !important;cursor: pointer !important;"
                }
                return result;
            },
            /*dataChanged(){
                if(checkRefresh === 0) {
                    checkRefresh = 1
                    checkExistInNeedsAssessment(ListGrid_Class_JspClass.getSelectedRecord().courseId)
                }
            }*/

            rowClick: function (record, recordNum, fieldNum) {
                selectedRow = record;
                listGridType = "SelectedClassLG_calender";
            },
        });
        //---------------------------------------------------------windows & toolstrip-----------------------------------------------------

        let class_List_VLayout = isc.VLayout.create({
            width: "100%",
            height: "100%",
            autoDraw: false,
            border: "0px solid red", layoutMargin: 5,
            members: [
                isc.SectionStack.create({
                    sections: [{
                        title: "<spring:message code="all.classes"/>",
                        expanded: true,
                        canCollapse: false,
                        align: "center",
                        items: [


                            classLG_calender

                    ]
                    }]
                }),
            ]
        });

        let classTabs = isc.TabSet.create({
            height: "50%",
            width: "100%",
            showTabScroller: false,
            tabs: [
                {
                    title: "<spring:message code='being.planned.classes'/>",
                    pane: class_List_VLayout
                },

            ]
        });

        Window_CalenderClasses = isc.Window.create({

            width: 1000,
            height: 768,
            minWidth: 1000,
            minHeight: 600,
            autoSize: false,
            items: [
                classTabs,
                isc.SectionStack.create({
                    sections: [{
                        title: "<spring:message code="selected.classes"/>",
                        expanded: true,
                        canCollapse: false,
                        align: "center",
                        items: [
                            SelectedClassLG_calender,
                            isc.TrHLayoutButtons.create({
                                members: [
                                    isc.IButtonSave.create({
                                        top: 260,
                                        title: "<spring:message code='save'/>",
                                        align: "center",
                                        icon: "[SKIN]/actions/save.png",
                                        click: function () {

                                       let ids  = SelectedClassLG_calender.getData().filter(function(x){return x.enabled!==false}).map(function(item) {return (!item.tclass)?item.id:item.tclass.id;});
                                             if(ids.length===0){
                                                 createDialog("info", "<spring:message code="msg.not.selected.record"/>", "<spring:message code="error"/>");
                                                 return;
                                             }
                                            save_educationalCalender_to_classes(ids);


                                        }
                                    }),
                                    isc.IButtonCancel.create({
                                        top: 260,
                                        title: "<spring:message code='cancel'/>",
                                        align: "center",
                                        icon: "[SKIN]/actions/cancel.png",
                                        click: function () {

                                            SelectedClassLG_calender.invalidateCache();
                                            Window_CalenderClasses.close();
                                        }
                                    }),
                                ],
                            }),
                        ]
                    }]
                }),
            ]
        });
// ------------------------------------------- Page UI -------------------------------------------
        isc.TrVLayout.create({
            members: [
                calenderLG_class
            ],
        });

        //------------------------------------------------------functions---------------------------------------------------
        function refreshCalenderLG_calender() {
            calenderLG_class.invalidateCache();
        }
        function refreshClassLG_calender(){
            classLG_calender.invalidateCache();
        }

        function createMainCalenderCriteria() {
            let mainCriteria = {};
            mainCriteria._constructor = "AdvancedCriteria";
            mainCriteria.operator = "and";
            mainCriteria.criteria = [];

            mainCriteria.criteria.add(departmentCalenderCriteria);

            return mainCriteria;
        }

        function loadPage_CalenderClasses(id) {

                calenderDS_class.fetchDataURL =  viewClassDetailUrl + "/iscList";
                departmentCalenderCriteria = {fieldName: "classCalendarId", operator: "equals", value: id};

                let mainCriteria = createMainCalenderCriteria();
                calenderLG_class.invalidateCache();
                calenderLG_class.fetchData(mainCriteria);


                refreshCalenderLG_calender();

        }

        function addClass_calender() {
            let classRecord = ListGrid_Educational_Calender.getSelectedRecord();
            if (classRecord == null || classRecord.id == null) {
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            Window_CalenderClasses.setTitle("<spring:message code="add.class.to.calender"/> \'" + classRecord.titleFa + "\'");


            let cr = {
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [{fieldName: "classStatus", operator: "equals", value: "1"}

                ]
            };
            classLG_calender.invalidateCache();
            classDS_calender.fetchDataURL = classUrl + "calender-spec-list";
            classLG_calender.setImplicitCriteria(cr);
            classLG_calender.fetchData();
            SelectedClassLG_calender.setData([]);
            Window_CalenderClasses.show();

        }

        function codeExists(code) {
            return SelectedClassLG_calender.data.localData.some(function (el) {
                return el.code === code;
            });
        }
        function rowStyleCalender(record, rowNum, colNum) {
            let result = '';
            if (this.getFieldName(colNum) == "code") {
                result += "color: #0066cc !important;text-decoration: underline !important;cursor: pointer !important;";
            }

            if (record.isChecked) {
                result += " background-color:#ededed; color:#b8b8b8 !important";
            } else if (record.isClicked) {
                result += " background-color:#929292;";
            } else if (!record.isClicked || !record.isChecked) {
                result += " background-color:white;";
            }
            return result;
        }
        function save_educationalCalender_to_classes(ids){

            let eCalenderId=ListGrid_Educational_Calender.getSelectedRecord().id;

            wait.show();

            isc.RPCManager.sendRequest(TrDSRequest(classUrl + "add-classes-educationalCalender/"+ eCalenderId + "/"+ ids, "POST", null, function (resp) {
                wait.close();

                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    createDialog("info", "<spring:message code="global.form.request.successful"/>");
                    DynamicForm_EducationalCalender.clearValues();

                    refreshCalenderLG_calender();
                    Window_CalenderClasses.close();
                } else {
                    createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                }

            }));

        }
        function remove_educationalCalender_from_class(){

            let record =calenderLG_class.getSelectedRecord();
            if (record == null || record.id == null) {
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            } else {
                let Dialog_Remove_Calender = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                    "<spring:message code='verify.delete'/>");
                Dialog_Remove_Calender.addProperties({
                    buttonClick: function (button, index) {
                        this.close();
                        if (index === 0) {

                            isc.RPCManager.sendRequest(TrDSRequest(classUrl +"deleteEducationalCalFromClass/"+ record.id, "GET", null, function (resp){


                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                    createDialog("info", "<spring:message code="global.form.request.successful"/>");

                                    calenderLG_class.invalidateCache();
                                } else {
                                    createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                                }
                            }));
                        }
                    }
                });
            }


        }


    }


    // </script>
