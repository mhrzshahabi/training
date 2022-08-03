<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    //----------------------------------------------------Variables-----------------------------------------------------
    // let isCriteriaCategoriesChanged_csfr = false;
    // let reportCriteria_csfr = null;
    // let minScoreER_csfr = null;
    // let minQusER_csfr = null;
    // let stdToContent_csfr = null;
    // let stdToTeacher_csfr = null;
    // let stdToFacility_csfr = null;
    // let teachToClass_csfr = null;
    // let recordsEvalData_csfr = [];

    let startDateCheck_csfr = true;
    let endDateCheck_csfr = true;
    let startDateCheck_Order_csfr = true;
    let endDate1Check_csfr = true;
    let endDate2Check_csfr = true;
    let endDateCheck_Order_csfr = true;

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    let RestDataSource_Category_csfr = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "titleFa"}
        ],
        fetchDataURL: categoryUrl + "spec-list"
    });

    let RestDataSource_ListGrid_Student_csfr = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {
                name: "classCode",
                title: "<spring:message code='class.code'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "courseCode",
                title: "<spring:message code='course.code'/>",
                align: "center",
                filterOperator: "iContains",
                sortNormalizer: function (record) {
                    return record.course.titleFa;
                }
            },
            {
                name: "classTitle",
                title: "<spring:message code="class.title"/>",
                align: "center",
                filterOperator: "iContains",
                hidden: false
            },
            {
                name: "teacherFullName",
                title: "<spring:message code='trainer'/>",
                // displayField: "teacher.personality.lastNameFa",
                // type: "TextItem",
                // sortNormalizer(record) {
                //     return record.teacherFullName;
                // },
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "studentNationalCode",
                title: "<spring:message code='student.national.code'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "studentFullName",
                title: "<spring:message code='student.full.name'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "studentComplex",
                title: "<spring:message code='student.complex'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "studentAssistant",
                title: "<spring:message code='student.assistant'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "studentAffair",
                title: "<spring:message code='student.affair'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "acceptanceStatus",
                title: "<spring:message code='acceptanceState.state'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "studentScore",
                title: "<spring:message code='score'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "acceptanceLimit",
                title: "<spring:message code='acceptance.limit'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "instituteTitle",
                title: "<spring:message code="executor.complex"/>",
                filterOperator: "iContains"
            }
        ],
        fetchDataURL: classStudentFinalStatusReport + "/iscList"
    });
    let RestDataSource_ListGrid_Course_csfr = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {
                name: "classCode",
                title: "<spring:message code='class.code'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "courseCode",
                title: "<spring:message code='course.code'/>",
                align: "center",
                filterOperator: "iContains",
                sortNormalizer: function (record) {
                    return record.course.titleFa;
                }
            },
            {
                name: "classTitle",
                title: "<spring:message code="class.title"/>",
                align: "center",
                filterOperator: "iContains",
                hidden: false
            },
            {
                name: "teacherFullName",
                title: "<spring:message code='trainer'/>",
                // displayField: "teacher.personality.lastNameFa",
                // type: "TextItem",
                // sortNormalizer(record) {
                //     return record.teacherFullName;
                // },
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "classStatus", title: "<spring:message code='class.status'/>", align: "center",
            },
            {
                name: "classScoringStatus",
                title: "<spring:message code="score.state"/>"
            },
            {
                name: "studentsclassScoringStatus",
                title: "<spring:message code="acceptance.percent"/>",
                filterOperator: "iContains"
            },
            {
                name: "instituteTitle",
                title: "<spring:message code="executor.complex"/>",
                filterOperator: "iContains"
            }
        ],
        fetchDataURL: classCourseFinalStatusReport + "/iscList"
    });
    let RestDataSource_Term_csfr = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"},
            {name: "code"},
            {name: "classStartDate"},
            {name: "classEndDate"}
        ]
    });
    let RestDataSource_Year_csfr = isc.TrDS.create({
        fields: [
            {name: "year", primaryKey: true}
        ],
        fetchDataURL: termUrl + "yearList"
    });
    let RestDataSource_Student_csfr = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "firstName", filterOperator: "iContains"},
            {name: "lastName", filterOperator: "iContains"},
            {name: "nationalCode", filterOperator: "iContains"},
            {name: "fullName"}
        ],
        fetchDataURL: studentUrl + "spec-list"
    });
    let RestDataSource_Class_cfsr = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "group"},
            {name: "hduration", canFilter: false},
            {name: "classCancelReasonId"},
            {name: "titleClass"},
            {name: "classStartDate"},
            {name: "classEndDate"},
            {name: "studentCount", canFilter: false, canSort: false},
            {name: "code"},
            {name: "term.titleFa"},
            {name: "courseId"},
            {name: "course.titleFa"},
            {name: "course.id"},
            {name: "teacherId"},
            {name: "teacher"},
            {name: "teacher.personality.lastNameFa"},
            {name: "reason"},
            {name: "classStatus"},
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
    let RestDataSource_Select_Class_csfr = isc.TrDS.create({
        ID: "RestDataSource_Select_Class_csfr",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleClass"},
            {name: "code"},
            {name: "course.titleFa"}
        ],
        fetchDataURL: classUrl + "info-tuple-list"
    });
    //----------------------------------------------------Criteria Form------------------------------------------------

    let DynamicForm_SelectClasses_csfr = isc.DynamicForm.create({
        align: "center",
        titleWidth: 0,
        titleAlign: "center",
        width: 500,
        height: 300,
        fields: [
            {
                name: "classCode",
                align: "center",
                title: "",
                editorType: "MultiComboBoxItem",
                multiple: true,
                defaultValue: null,
                changeOnKeypress: true,
                showHintInField: true,
                displayField: "code",
                comboBoxWidth: 500,
                valueField: "code",
                layoutStyle: "vertical",
                optionDataSource: RestDataSource_Select_Class_csfr
            }
        ]
    });

    DynamicForm_SelectClasses_csfr.getField("classCode").comboBox.setHint("کلاسهای مورد نظر را انتخاب کنید");
    DynamicForm_SelectClasses_csfr.getField("classCode").comboBox.pickListFields = [
        {name: "titleClass", title: "نام کلاس", width: "30%", filterOperator: "iContains"},
        {name: "code", title: "کد کلاس", width: "30%", filterOperator: "iContains"},
        {name: "course.titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"}];
    DynamicForm_SelectClasses_csfr.getField("classCode").comboBox.filterFields = ["titleClass", "code", "course.titleFa"];

    let IButton_ConfirmClassesSelections_csfr = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            let form = DynamicForm_SelectClasses_csfr;
            let criteriaDisplayValues = "";
            let selectorDisplayValues = form.getItem("classCode").getValue();

            if (form.getField("classCode").getValue() !== undefined && form.getField("classCode").getValue() !== "") {
                criteriaDisplayValues = form.getField("classCode").getValue().join(",");
                let ALength = criteriaDisplayValues.length;
                let lastChar = criteriaDisplayValues.charAt(ALength - 1);
                if (lastChar !== ";")
                    criteriaDisplayValues += ",";

                RestDataSource_Term_csfr.fetchDataURL = termUrl + "listByYear/" + criteriaDisplayValues;
                // DynamicForm_CriteriaForm_csfr.getField("classScoringMethodCode").optionDataSource = RestDataSource_Term_csfr;
                DynamicForm_CriteriaForm_csfr.getField("classScoringMethodCode").fetchData();
                DynamicForm_CriteriaForm_csfr.getField("classScoringMethodCode").enable();
            } else {
                DynamicForm_CriteriaForm_csfr.getField("classScoringMethodCode").disable();
            }
            if (selectorDisplayValues !== undefined) {
                for (let i = 0; i < selectorDisplayValues.size() - 1; i++) {
                    criteriaDisplayValues += selectorDisplayValues [i] + ",";
                }
                criteriaDisplayValues += selectorDisplayValues [selectorDisplayValues.size() - 1];
            }

            if (typeof criteriaDisplayValues !== undefined) {
                let uniqueNames = [];

                $.each(criteriaDisplayValues.split(","), function (i, el) {
                    if ($.inArray(el, uniqueNames) === -1) uniqueNames.push(el);
                });
                criteriaDisplayValues = uniqueNames.join(",");
            }

            criteriaDisplayValues = criteriaDisplayValues === undefined ? "" : criteriaDisplayValues;

            DynamicForm_CriteriaForm_csfr.getField("classCode").setValue(criteriaDisplayValues);
            Window_SelectClasses_csfr.close();
        }
    });
    let Window_SelectClasses_csfr = isc.Window.create({
        placement: "center",
        title: "انتخاب کلاس ها",
        canDragReposition: true,
        align: "center",
        autoDraw: false,
        border: "2px solid gray",
        width: 500,
        height: 300,
        items: [
            isc.TrVLayout.create({
                members: [
                    DynamicForm_SelectClasses_csfr,
                    IButton_ConfirmClassesSelections_csfr
                ]
            })
        ]
    });

    let DynamicForm_CriteriaForm_csfr = isc.DynamicForm.create({
        align: "center",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 4,
        colWidths: ["7%", "43%", "7%", "43%"],
        width: "100%",
        height: "100%",
        fields: [
            {
                name: "classStartDate",
                ID: "startDate_cfsr",
                title: "تاریخ شروع کلاس: از",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                showHintInField: true,
                required: false,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate_cfsr', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if (value === undefined || value == null) {
                        form.clearFieldErrors("classEndDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        form.clearFieldErrors("classStartDate", true);
                        startDateCheck_Order_csfr = true;
                        startDateCheck_csfr = true;
                        return;
                    }
                    let dateCheck;
                    let classEndDate = form.getValue("classEndDate");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        startDateCheck_csfr = false;
                        startDateCheck_Order_csfr = true;
                        form.clearFieldErrors("classStartDate", true);
                        form.addFieldErrors("classStartDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (classEndDate < value) {
                        startDateCheck_Order_csfr = false;
                        startDateCheck_csfr = true;
                        form.clearFieldErrors("classStartDate", true);
                        form.addFieldErrors("classStartDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    } else {
                        startDateCheck_csfr = true;
                        startDateCheck_Order_csfr = true;
                        form.clearFieldErrors("classStartDate", true);
                    }
                }
            },
            {
                name: "classEndDate",
                ID: "endDate_cfsr",
                title: "تا",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                required: false,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate_cfsr', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if (value === undefined || value == null) {
                        form.clearFieldErrors("classStartDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                        form.clearFieldErrors("classEndDate", true);
                        startDateCheck_Order_csfr = true;
                        endDateCheck_csfr = true;
                        return;
                    }
                    let dateCheck;
                    dateCheck = checkDate(value);
                    let classStartDate = form.getValue("classStartDate");
                    if (dateCheck === false) {
                        endDateCheck_csfr = false;
                        startDateCheck_Order_csfr = true;
                        form.clearFieldErrors("classEndDate", true);
                        form.addFieldErrors("classEndDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (classStartDate !== undefined && value < classStartDate) {
                        form.clearFieldErrors("classEndDate", true);
                        form.addFieldErrors("classEndDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        endDateCheck_csfr = true;
                        startDateCheck_Order_csfr = false;
                    } else {
                        form.clearFieldErrors("classEndDate", true);
                        endDateCheck_csfr = true;
                        startDateCheck_Order_csfr = true;
                    }
                }
            },
            {
                name: "tclassYear",
                title: "سال کاری",
                filterOperator: "equals",
                type: "SelectItem",
                required: true,
                optionDataSource: RestDataSource_Year_csfr,
                valueField: "year",
                displayField: "year",
                filterFields: ["year"],
                filterLocally: true,
                changed: function (form, item, value) {

                    form.getField("termTitle").clearValue();
                    if (value !== null && value !== undefined) {
                        RestDataSource_Term_csfr.fetchDataURL = termUrl + "listByYear/" + value;
                        DynamicForm_CriteriaForm_csfr.getField("termTitle").optionDataSource = RestDataSource_Term_csfr;
                        DynamicForm_CriteriaForm_csfr.getField("termTitle").fetchData();
                        DynamicForm_CriteriaForm_csfr.getField("termTitle").enable();
                    } else {
                        form.getField("termTitle").disabled = true;
                    }
                }
            },
            {
                name: "termTitle",
                title: "ترم",
                type: "SelectItem",
                multiple: true,
                filterOperator: "equals",
                disabled: true,
                valueField: "id",
                displayField: "titleFa",
                filterLocally: true,
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
                                        let item = DynamicForm_CriteriaForm_csfr.getField("termTitle"),
                                            fullData = item.pickList.data,
                                            cache = fullData.localData,
                                            values = [];

                                        for (let i = 0; i < cache.length; i++) {
                                            values[i] = cache[i].titleFa;
                                        }
                                        item.setValue(values);
                                        item.pickList.hide();
                                        debugger
                                    }
                                }),
                                isc.ToolStripButton.create({
                                    width: "50%",
                                    icon: "[SKIN]/actions/close.png",
                                    title: "حذف همه",
                                    click: function () {
                                        let item = DynamicForm_CriteriaForm_csfr.getField("termTitle");
                                        item.setValue([]);
                                        item.pickList.hide();
                                    }
                                })
                            ]
                        }),
                        "header", "body"
                    ]
                }
            },
            {
                name: "classCode",
                title: "کد کلاس",
                filterOperator: "equals",
                hint: "کد کلاس را انتخاب نمائيد",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                        Window_SelectClasses_csfr.show();
                    }
                }],
                keyPressFilter: "[A-Z|0-9|,-]",
                changed: function (form, item, value) {
                    form.getField("classScoringMethodCode").clearValue();
                    if (value !== null && value !== undefined) {
                        RestDataSource_Term_csfr.fetchDataURL = termUrl + "listByYear/" + value;
                        DynamicForm_CriteriaForm_csfr.getField("classScoringMethodCode").optionDataSource = RestDataSource_Term_csfr;
                        DynamicForm_CriteriaForm_csfr.getField("classScoringMethodCode").fetchData();
                        DynamicForm_CriteriaForm_csfr.getField("classScoringMethodCode").enable();
                    } else {
                        form.getField("classScoringMethodCode").disabled = true;
                    }
                }
            },
            {
                name: "classScoringMethodCode",
                title: "<spring:message code='score.state'/>:",
                type: "SelectItem",
                multiple: true,
                valueMap: {
                    "1": "با نمره",
                    "2": "بدون نمره"
                },
                pickListProperties: {
                    showFilterEditor: false
                }
            },
            {
                name: "studentId",
                title: "<spring:message code='student'/>:",
                type: "ComboBoxItem",
                filterOperator: "equals",
                autoFetchData: false,
                optionDataSource: RestDataSource_Student_csfr,
                // dataPageSize: 50,
                valueField: "id",
                displayField: "fullName",
                filterFields: ["firstName", "lastName", "nationalCode"],
                pickListFields: [
                    {name: "firstName", title: "نام"},
                    {name: "lastName", title: "نام خانوادگی"},
                    {name: "nationalCode", title: "کد ملی"}],
                pickListProperties: {
                    showFilterEditor: true
                }
            },
            {
                name: "courseCategory",
                title: "گروه آموزشی",
                type: "SelectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_Category_csfr,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                }
            },
        ]
    });

    //----------------------------------- layOut -----------------------------------------------------------------------

    let ListGrid_CFSR_Student = isc.TrLG.create({
        dataSource: RestDataSource_ListGrid_Student_csfr,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        showRollOver:false,
        autoFitWidth: true,
        autoSize: true,
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {
                name: "classCode",
                title: "<spring:message code='class.code'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "courseCode",
                title: "<spring:message code='course.code'/>",
                align: "center",
                filterOperator: "iContains",
                sortNormalizer: function (record) {
                    return record.course.titleFa;
                }
            },
            {
                name: "classTitle",
                title: "<spring:message code="class.title"/>",
                align: "center",
                filterOperator: "iContains",
                hidden: false
            },
            {
                name: "teacherFullName",
                title: "<spring:message code='trainer'/>",
                // displayField: "teacher.personality.lastNameFa",
                // type: "TextItem",
                // sortNormalizer(record) {
                //     return record.teacherFullName;
                // },
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "studentNationalCode",
                title: "<spring:message code='student.national.code'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "studentFullName",
                title: "<spring:message code='student.full.name'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "studentComplex",
                title: "<spring:message code='student.complex'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "studentAssistant",
                title: "<spring:message code='student.assistant'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "studentAffair",
                title: "<spring:message code='student.affair'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "acceptanceStatus",
                title: "<spring:message code='acceptanceState.state'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "studentScore",
                title: "<spring:message code='score'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "acceptanceLimit",
                title: "<spring:message code='acceptance.limit'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "instituteTitle",
                title: "<spring:message code="executor.complex"/>",
                filterOperator: "iContains"
            }
        ]
    });

    let ListGrid_CFSR_Course = isc.TrLG.create({
        dataSource: RestDataSource_ListGrid_Course_csfr,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        showRollOver:false,
        selectionType: "single",
        autoFetchData: false,
        autoFitWidth: true,
        autoSize: true,
        // initialSort: [
        //     {property: "startDate", direction: "descending", primarySort: true}
        // ],
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {
                name: "classCode",
                title: "<spring:message code='class.code'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "courseCode",
                title: "<spring:message code='course.code'/>",
                align: "center",
                filterOperator: "iContains",
                sortNormalizer: function (record) {
                    return record.course.titleFa;
                }
            },
            {
                name: "classTitle",
                title: "<spring:message code="class.title"/>",
                align: "center",
                filterOperator: "iContains",
                hidden: false
            },
            {
                name: "teacherFullName",
                title: "<spring:message code='trainer'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "classStatus", title: "<spring:message code='class.status'/>", align: "center",
                valueMap: {
                    "برنامه ریزی": "برنامه ریزی",
                    "در حال اجرا": "در حال اجرا",
                    "پایان یافته": "پایان یافته",
                    "لغو شده": "لغو شده",
                    "اختتام": "اختتام"
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
                name: "classScoringStatus",
                title: "<spring:message code="score.state"/>",
                filterOperator: "iContains",
                valueMap: {
                    "با نمره":"با نمره",
                    "بدون نمره":"بدون نمره"
                },
                filterEditorProperties: {
                    pickListProperties: {
                        showFilterEditor: false
                    },
                },
                filterOnKeypress: true,

            },
            {
                name: "acceptancePercentage",
                title: "<spring:message code="acceptance.percent"/>",
                filterOperator: "equals"
            },
            {
                name: "instituteTitle",
                title: "<spring:message code="executor.complex"/>",
                filterOperator: "iContains"
            },
        ]
    });

    let Window_Show_Student_Report = isc.Window.create({
        placement: "center",
        width: "90%",
        height: "80%",
        autoSize: false,
        border: "1px solid gray",
        title: "وضعیت نهایی کلاس بر اساس فراگیر",
        items: [isc.TrVLayout.create({
            align: "center",
            members: [
                ListGrid_CFSR_Student
            ]
        })]
    });
    let Window_Show_Course_Report = isc.Window.create({
        placement: "center",
        width: "90%",
        height: "80%",
        autoSize: false,
        border: "1px solid gray",
        title: "وضعیت نهایی کلاس بر اساس دوره",
        items: [isc.TrVLayout.create({
            align: "center",
            members: [
                ListGrid_CFSR_Course
            ]
        })],
    });

    let IButton_student_csfr = isc.IButtonSave.create({
        top: 260,
        title: "استخراج بر اساس فراگیر",
        width: 300,
        height: "100%",
        click: function () {
            extractFinalStatusReport("student");
        }
    });
    let IButton_course_csfr = isc.IButtonSave.create({
        top: 260,
        title: "استخراج بر اساس دوره",
        width: 300,
        height: "100%",
        click: function () {
            extractFinalStatusReport("course");
        }
    });
    let HLayOut_buttons_csfr = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        // height: "100%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_student_csfr, IButton_course_csfr
        ]
    });

    let organSegmentFilter_cfsr = init_OrganSegmentFilterDF(true, true, true, true, true, null, "complexTitle","assistantTitle","affairTitle", "section", "unit");

    let VLayOut_CriteriaForm_csfr = isc.VLayout.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "100%",
        alignLayout: "center",
        members: [
            organSegmentFilter_cfsr,
            DynamicForm_CriteriaForm_csfr,
            HLayOut_buttons_csfr,
        ]
    });

    let VLayout_Body_csfr = isc.TrVLayout.create({
        border: "2px solid blue",
        align: "center",
        padding: 32,
        members: [
            organSegmentFilter_cfsr,
            DynamicForm_CriteriaForm_csfr,
            HLayOut_buttons_csfr
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------

    function extractFinalStatusReport(target) {
        debugger
        let departmentCriteria = organSegmentFilter_cfsr.getCriteria();
        let data = DynamicForm_CriteriaForm_csfr.getValuesAsAdvancedCriteria();

        if (!organSegmentFilter_cfsr.validate() || !DynamicForm_CriteriaForm_csfr.validate()) {
            return;
        }

        if (departmentCriteria !== undefined && departmentCriteria !== null) {
            for (let i = 0; i < departmentCriteria.criteria.length; i++) {
                if (departmentCriteria.criteria[i] !== undefined && departmentCriteria.criteria[i] !== null)
                    data.criteria.add(departmentCriteria.criteria[i]);
            }
        }

        if (DynamicForm_SelectClasses_csfr.getCriteria() !== undefined && DynamicForm_SelectClasses_csfr.getCriteria() !== null) {
            data.criteria.add(DynamicForm_SelectClasses_csfr.getCriteria());
        }

        let finalCriteria = {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: []
        };

        for (let i = 0; i < data.criteria.length; i++) {
            if (data.criteria[i].fieldName === "classStartDate") {
                data.criteria[i].operator = "greaterOrEqual";
            }
            if (data.criteria[i].fieldName === "classEndDate") {
                data.criteria[i].operator = "lessOrEqual";
            }
            if (data.criteria[i].fieldName === "courseCategory") {
                data.criteria[i].operator = "inSet";
            }
            finalCriteria.criteria.add(data.criteria[i]);
        }
        if (target === "course") {
            ListGrid_CFSR_Course.invalidateCache();
            ListGrid_CFSR_Course.fetchData(finalCriteria);
            Window_Show_Course_Report.show();
        } else if (target === "student") {
            ListGrid_CFSR_Student.invalidateCache();
            ListGrid_CFSR_Student.fetchData(finalCriteria);
            Window_Show_Student_Report.show();
        }
    }

    async function checkFormValidation() {
        DynamicForm_CriteriaForm_csfr.validate();
        if (DynamicForm_CriteriaForm_csfr.hasErrors())
            return false;

        if (!DynamicForm_CriteriaForm_csfr.validate() ||
            startDateCheck_Order_csfr === false ||
            endDateCheck_csfr === false ||
            startDateCheck_csfr === false ||
            endDateCheck_Order_csfr === false ||
            endDate2Check_csfr === false ||
            endDate1Check_csfr === false) {

            if (startDateCheck_Order_csfr === false) {
                DynamicForm_CriteriaForm_csfr.clearFieldErrors("classEndDate", true);
                DynamicForm_CriteriaForm_csfr.addFieldErrors("classEndDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
            }
            if (startDateCheck_Order_csfr === false) {
                DynamicForm_CriteriaForm_csfr.clearFieldErrors("classStartDate", true);
                DynamicForm_CriteriaForm_csfr.addFieldErrors("classStartDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
            }
            if (endDateCheck_csfr === false) {
                DynamicForm_CriteriaForm_csfr.clearFieldErrors("classEndDate", true);
                DynamicForm_CriteriaForm_csfr.addFieldErrors("classEndDate", "<spring:message code='msg.correct.date'/>", true);
            }
            if (startDateCheck_csfr === false) {
                DynamicForm_CriteriaForm_csfr.clearFieldErrors("classStartDate", true);
                DynamicForm_CriteriaForm_csfr.addFieldErrors("classStartDate", "<spring:message code='msg.correct.date'/>", true);
            }

            if (endDateCheck_Order_csfr === false) {
                DynamicForm_CriteriaForm_csfr.clearFieldErrors("endDate2", true);
                DynamicForm_CriteriaForm_csfr.addFieldErrors("endDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
            }
            if (endDateCheck_Order_csfr === false) {
                DynamicForm_CriteriaForm_csfr.clearFieldErrors("endDate1", true);
                DynamicForm_CriteriaForm_csfr.addFieldErrors("endDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
            }
            if (endDate2Check_csfr === false) {
                DynamicForm_CriteriaForm_csfr.clearFieldErrors("endDate2", true);
                DynamicForm_CriteriaForm_csfr.addFieldErrors("endDate2", "<spring:message code='msg.correct.date'/>", true);
            }
            if (endDate1Check_csfr === false) {
                DynamicForm_CriteriaForm_csfr.clearFieldErrors("endDate1", true);
                DynamicForm_CriteriaForm_csfr.addFieldErrors("endDate1", "<spring:message code='msg.correct.date'/>", true);
            }
        }
        return true;
    }

     // </script>