<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    //----------------------------------------------------Variables-----------------------------------------------------
    // let isCriteriaCategoriesChanged_ecr = false;
    // let reportCriteria_ecr = null;
    // let minScoreER_ecr = null;
    // let minQusER_ecr = null;
    // let stdToContent_ecr = null;
    // let stdToTeacher_ecr = null;
    // let stdToFacility_ecr = null;
    // let teachToClass_ecr = null;
    // let recordsEvalData_ecr = [];

    let startDateCheck_ecr = true;
    let endDateCheck_ecr = true;
    let startDateCheck_Order_ecr = true;
    let endDate1Check_ecr = true;
    let endDate2Check_ecr = true;
    let endDateCheck_Order_ecr = true;

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    let RestDataSource_Category_ecr = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "titleFa"}
        ],
        fetchDataURL: categoryUrl + "spec-list"
    });

    let RestDataSource_ListGrid_effectiveness_courses = isc.TrDS.create({
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
                name: "classStartDate",
                title: "<spring:message code='class.start.date'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "classEndDate",
                title: "<spring:message code='class.end.date'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "classYear",
                title: "<spring:message code='year'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "termTitle",
                title: "<spring:message code='term'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "evaluationType",
                title: "<spring:message code='evaluation.level'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "effectivenessGrade",
                title: "<spring:message code='FECRGrade'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "effectivenessStatus",
                title: "<spring:message code='effectiveness.status'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "description",
                title: "<spring:message code='description'/>",
                align: "center",
                filterOperator: "iContains",
            }
        ],
        fetchDataURL: effectiveCoursesReportUrl + "/iscList"
    });
    let RestDataSource_Term_ecr = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"},
            {name: "code"},
            {name: "classStartDate"},
            {name: "classEndDate"}
        ]
    });
    let RestDataSource_Year_ecr = isc.TrDS.create({
        fields: [
            {name: "year", primaryKey: true}
        ],
        fetchDataURL: termUrl + "yearList"
    });
    let RestDataSource_Teacher_ecr = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "fullNameFa"},
            {name: "personality.firstNameFa"},
            {name: "personality.lastNameFa"},
            {name: "personality.nationalCode"},
            // {name: "grade"},
            // {name: "hasPhone"},
        ],
        fetchDataURL: teacherUrl + "fullName-list"
    });
    let RestDataSource_Student_ecr = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "firstName", filterOperator: "iContains"},
            {name: "lastName", filterOperator: "iContains"},
            {name: "nationalCode", filterOperator: "iContains"},
            {name: "fullName"}
        ],
        fetchDataURL: studentUrl + "spec-list"
    });
    let RestDataSource_Class_ecr = isc.TrDS.create({
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
    let RestDataSource_Select_Class_ecr = isc.TrDS.create({
        ID: "RestDataSource_Select_Class_ecr",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleClass"},
            {name: "code"},
            {name: "course.titleFa"}
        ],
        fetchDataURL: classUrl + "info-tuple-list"
    });
    //----------------------------------------------------Criteria Form------------------------------------------------

    let DynamicForm_SelectClasses_ecr = isc.DynamicForm.create({
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
                optionDataSource: RestDataSource_Select_Class_ecr
            }
        ]
    });

    DynamicForm_SelectClasses_ecr.getField("classCode").comboBox.setHint("کلاسهای مورد نظر را انتخاب کنید");
    DynamicForm_SelectClasses_ecr.getField("classCode").comboBox.pickListFields = [
        {name: "titleClass", title: "نام کلاس", width: "30%", filterOperator: "iContains"},
        {name: "code", title: "کد کلاس", width: "30%", filterOperator: "iContains"},
        {name: "course.titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"}];
    DynamicForm_SelectClasses_ecr.getField("classCode").comboBox.filterFields = ["titleClass", "code", "course.titleFa"];

    let IButton_ConfirmClassesSelections_ecr = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            debugger
            let form = DynamicForm_SelectClasses_ecr;
            let criteriaDisplayValues = "";
            let selectorDisplayValues = form.getItem("classCode").getValue();

            if (form.getField("classCode").getValue() !== undefined && form.getField("classCode").getValue() !== "") {
                criteriaDisplayValues = form.getField("classCode").getValue().join(",");
                let ALength = criteriaDisplayValues.length;
                let lastChar = criteriaDisplayValues.charAt(ALength - 1);
                if (lastChar !== ";")
                    criteriaDisplayValues += ",";

                RestDataSource_Term_ecr.fetchDataURL = termUrl + "listByYear/" + criteriaDisplayValues;
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

            DynamicForm_CriteriaForm_ecr.getField("classCode").setValue(criteriaDisplayValues);
            Window_SelectClasses_ecr.close();
            debugger
        }
    });
    let Window_SelectClasses_ecr = isc.Window.create({
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
                    DynamicForm_SelectClasses_ecr,
                    IButton_ConfirmClassesSelections_ecr
                ]
            })
        ]
    });

    let DynamicForm_CriteriaForm_ecr = isc.DynamicForm.create({
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
                ID: "startDate_ecr",
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
                        displayDatePicker('startDate_ecr', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if (value === undefined || value == null) {
                        form.clearFieldErrors("classEndDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        form.clearFieldErrors("classStartDate", true);
                        startDateCheck_Order_ecr = true;
                        startDateCheck_ecr = true;
                        return;
                    }
                    let dateCheck;
                    let classEndDate = form.getValue("classEndDate");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        startDateCheck_ecr = false;
                        startDateCheck_Order_ecr = true;
                        form.clearFieldErrors("classStartDate", true);
                        form.addFieldErrors("classStartDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (classEndDate < value) {
                        startDateCheck_Order_ecr = false;
                        startDateCheck_ecr = true;
                        form.clearFieldErrors("classStartDate", true);
                        form.addFieldErrors("classStartDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    } else {
                        startDateCheck_ecr = true;
                        startDateCheck_Order_ecr = true;
                        form.clearFieldErrors("classStartDate", true);
                    }
                }
            },
            {
                name: "classEndDate",
                ID: "endDate_ecr",
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
                        displayDatePicker('endDate_ecr', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if (value === undefined || value == null) {
                        form.clearFieldErrors("classStartDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                        form.clearFieldErrors("classEndDate", true);
                        startDateCheck_Order_ecr = true;
                        endDateCheck_ecr = true;
                        return;
                    }
                    let dateCheck;
                    dateCheck = checkDate(value);
                    let classStartDate = form.getValue("classStartDate");
                    if (dateCheck === false) {
                        endDateCheck_ecr = false;
                        startDateCheck_Order_ecr = true;
                        form.clearFieldErrors("classEndDate", true);
                        form.addFieldErrors("classEndDate", "<spring:message code='msg.correct.date'/>", true);
                    } else if (classStartDate !== undefined && value < classStartDate) {
                        form.clearFieldErrors("classEndDate", true);
                        form.addFieldErrors("classEndDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        endDateCheck_ecr = true;
                        startDateCheck_Order_ecr = false;
                    } else {
                        form.clearFieldErrors("classEndDate", true);
                        endDateCheck_ecr = true;
                        startDateCheck_Order_ecr = true;
                    }
                }
            },
            {
                name: "classYear",
                title: "سال کاری",
                filterOperator: "equals",
                type: "SelectItem",
                required: true,
                requiredMessage: "<spring:message code='msg.field.is.required'/>",
                optionDataSource: RestDataSource_Year_ecr,
                valueField: "year",
                displayField: "year",
                filterFields: ["year"],
                filterLocally: true,
                changed: function (form, item, value) {
                    form.getField("termTitle").clearValue();
                    if (value !== null && value !== undefined) {
                        RestDataSource_Term_ecr.fetchDataURL = termUrl + "listByYear/" + value;
                        DynamicForm_CriteriaForm_ecr.getField("termTitle").optionDataSource = RestDataSource_Term_ecr;
                        DynamicForm_CriteriaForm_ecr.getField("termTitle").fetchData();
                        DynamicForm_CriteriaForm_ecr.getField("termTitle").enable();
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
                                        let item = DynamicForm_CriteriaForm_ecr.getField("termTitle"),
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
                                        let item = DynamicForm_CriteriaForm_ecr.getField("termTitle");
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
                        Window_SelectClasses_ecr.show();
                    }
                }],
                keyPressFilter: "[A-Z|0-9|,-]",
                changed: function (form, item, value) {
                    form.getField("classScoringMethodCode").clearValue();
                    if (value !== null && value !== undefined) {
                        RestDataSource_Term_ecr.fetchDataURL = termUrl + "listByYear/" + value;
                        DynamicForm_CriteriaForm_ecr.getField("classScoringMethodCode").optionDataSource = RestDataSource_Term_ecr;
                        DynamicForm_CriteriaForm_ecr.getField("classScoringMethodCode").fetchData();
                        DynamicForm_CriteriaForm_ecr.getField("classScoringMethodCode").enable();
                    } else {
                        form.getField("classScoringMethodCode").disabled = true;
                    }
                }
            },
            {
                name: "effectivenessPass",
                title: "<spring:message code='effectiveness.type'/>:",
                type: "SelectItem",
                multiple: true,
                valueMap: {
                    "1": "اثربخش",
                    "0": "غیر اثربخش"
                },
                pickListProperties: {
                    showFilterEditor: false
                }
            },
            {
                name: "teacherId",
                // colSpan: 5,
                title: "<spring:message code='trainer'/>",
                textAlign: "center",
                type: "ComboBoxItem",
                multiple: false,
                displayField: "fullNameFa",
                valueField: "id",
                autoFetchData: true,
                useClientFiltering: true,
                optionDataSource: RestDataSource_Teacher_ecr,
                pickListFields: [
                    {
                        name: "personality.firstNameFa",
                        title: "<spring:message code="firstName"/>",
                        titleAlign: "center",
                        filterOperator: "iContains"
                    },
                    {
                        name: "personality.lastNameFa",
                        title: "<spring:message code="lastName"/>",
                        titleAlign: "center",
                        filterOperator: "iContains"
                    },
                    {
                        name: "personality.nationalCode",
                        title: "<spring:message code="national.code"/>",
                        titleAlign: "center",
                        filterOperator: "iContains"
                    }
                ],
                filterFields: [
                    "personality.firstNameFa",
                    "personality.lastNameFa",
                    "personality.nationalCode"
                ],
                click: function (form, item) {

                }
            },
            {
                name: "studentId",
                title: "<spring:message code='student'/>:",
                type: "ComboBoxItem",
                filterOperator: "equals",
                autoFetchData: false,
                optionDataSource: RestDataSource_Student_ecr,
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
                name: "courseCategoryId",
                title: "گروه آموزشی",
                type: "SelectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_Category_ecr,
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

    let ListGrid_effectiveness_courses = isc.TrLG.create({
        dataSource: RestDataSource_ListGrid_effectiveness_courses,
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
                name: "classStartDate",
                title: "<spring:message code='class.start.date'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "classEndDate",
                title: "<spring:message code='class.end.date'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "classYear",
                title: "<spring:message code='year'/>",
                align: "center",
                canFilter: false,
                filterOperator: "iContains",
            },
            {
                name: "termTitle",
                title: "<spring:message code='term'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "evaluationType",
                title: "<spring:message code='evaluation.level'/>",
                align: "center",
                valueMap: {
                    "واکنشی": "واکنشی",
                    "یادگیری": "یادگیری",
                    "رفتاری": "رفتاری",
                    "نتایج": "نتایج",
                },
                filterEditorProperties: {
                    pickListProperties: {
                        showFilterEditor: false
                    },
                },
                filterOnKeypress: true,
                filterOperator: "iContains",
            },
            {
                name: "effectivenessGrade",
                title: "<spring:message code='FECRGrade'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "effectivenessStatus",
                title: "<spring:message code='effectiveness.status'/>",
                align: "center",
                valueMap: {
                    "تایید شده": "تایید شده",
                    "عدم تایید": "عدم تایید"
                },
                filterEditorProperties: {
                    pickListProperties: {
                        showFilterEditor: false
                    },
                },
                filterOnKeypress: true,
                filterOperator: "iContains"
            },
            {
                name: "description",
                title: "<spring:message code='description'/>",
                align: "center",
                filterOperator: "iContains",
            }
        ],
        getCellCSSText: function (record, rowNum, colNum) {
            if (this.getFieldName(colNum) === "effectivenessStatus") {
                if (record.effectivenessStatus === "تایید شده")
                    return "color:green;";
                if (record.effectivenessStatus === "عدم تایید")
                    return "color:red;";

            }
            debugger
        }
    });

    let Window_Show_effectiveness_courses_Report = isc.Window.create({
        placement: "center",
        width: "90%",
        height: "80%",
        autoSize: false,
        border: "1px solid gray",
        title: "<spring:message code="evaluation.statical.report"/> ",
        items: [isc.TrVLayout.create({
            align: "center",
            members: [
                ListGrid_effectiveness_courses
            ]
        })]
    });

    let IButton_effectiveness_courses = isc.IButtonSave.create({
        top: 260,
        title: "<spring:message code="evaluation.statical.report"/> ",
        width: 300,
        height: "100%",
        click: function () {
            extractEffectivenessCoursesReport();
        }
    });
    let HLayOut_buttons_ecr = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        // height: "100%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_effectiveness_courses
        ]
    });

    let organSegmentFilter_ecr = init_OrganSegmentFilterDF(true, true, true, true, true, null, "studentComplex", "studentAssistant", "studentAffair", "section", "unit");

    let VLayOut_CriteriaForm_ecr = isc.VLayout.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "100%",
        alignLayout: "center",
        members: [
            organSegmentFilter_ecr,
            DynamicForm_CriteriaForm_ecr,
            HLayOut_buttons_ecr,
        ]
    });

    let VLayout_Body_ecr = isc.TrVLayout.create({
        border: "2px solid blue",
        align: "center",
        padding: 32,
        members: [
            organSegmentFilter_ecr,
            DynamicForm_CriteriaForm_ecr,
            HLayOut_buttons_ecr
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------

    function extractEffectivenessCoursesReport() {
        let departmentCriteria = organSegmentFilter_ecr.getCriteria();
        let data = DynamicForm_CriteriaForm_ecr.getValuesAsAdvancedCriteria();

        if (!organSegmentFilter_ecr.validate() || !DynamicForm_CriteriaForm_ecr.validate()) {
            return;
        }

        if (departmentCriteria !== undefined && departmentCriteria !== null) {
            for (let i = 0; i < departmentCriteria.criteria.length; i++) {
                if (departmentCriteria.criteria[i] !== undefined && departmentCriteria.criteria[i] !== null)
                    data.criteria.add(departmentCriteria.criteria[i]);
            }
        }

        if (DynamicForm_SelectClasses_ecr.getCriteria() !== undefined && DynamicForm_SelectClasses_ecr.getCriteria() !== null) {
            data.criteria.add(DynamicForm_SelectClasses_ecr.getCriteria());
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
            if (data.criteria[i].fieldName === "courseCategoryId") {
                data.criteria[i].operator = "inSet";
            }
            if (data.criteria[i].fieldName === "termTitle") {
                data.criteria[i].operator = "inSet";
            }
            if (data.criteria[i].fieldName === "classCode") {
                data.criteria[i].operator = "inSet";
            }
            if (data.criteria[i].fieldName === "effectivenessPass") {
                data.criteria[i].operator = "inSet";
            }
            finalCriteria.criteria.add(data.criteria[i]);
        }
        ListGrid_effectiveness_courses.invalidateCache();
        ListGrid_effectiveness_courses.fetchData(finalCriteria);
        Window_Show_effectiveness_courses_Report.show();
        debugger
    }

    async function checkFormValidation() {
        DynamicForm_CriteriaForm_ecr.validate();
        if (DynamicForm_CriteriaForm_ecr.hasErrors())
            return false;

        if (!DynamicForm_CriteriaForm_ecr.validate() ||
            startDateCheck_Order_ecr === false ||
            endDateCheck_ecr === false ||
            startDateCheck_ecr === false ||
            endDateCheck_Order_ecr === false ||
            endDate2Check_ecr === false ||
            endDate1Check_ecr === false) {

            if (startDateCheck_Order_ecr === false) {
                DynamicForm_CriteriaForm_ecr.clearFieldErrors("classEndDate", true);
                DynamicForm_CriteriaForm_ecr.addFieldErrors("classEndDate", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
            }
            if (startDateCheck_Order_ecr === false) {
                DynamicForm_CriteriaForm_ecr.clearFieldErrors("classStartDate", true);
                DynamicForm_CriteriaForm_ecr.addFieldErrors("classStartDate", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
            }
            if (endDateCheck_ecr === false) {
                DynamicForm_CriteriaForm_ecr.clearFieldErrors("classEndDate", true);
                DynamicForm_CriteriaForm_ecr.addFieldErrors("classEndDate", "<spring:message code='msg.correct.date'/>", true);
            }
            if (startDateCheck_ecr === false) {
                DynamicForm_CriteriaForm_ecr.clearFieldErrors("classStartDate", true);
                DynamicForm_CriteriaForm_ecr.addFieldErrors("classStartDate", "<spring:message code='msg.correct.date'/>", true);
            }

            if (endDateCheck_Order_ecr === false) {
                DynamicForm_CriteriaForm_ecr.clearFieldErrors("endDate2", true);
                DynamicForm_CriteriaForm_ecr.addFieldErrors("endDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
            }
            if (endDateCheck_Order_ecr === false) {
                DynamicForm_CriteriaForm_ecr.clearFieldErrors("endDate1", true);
                DynamicForm_CriteriaForm_ecr.addFieldErrors("endDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
            }
            if (endDate2Check_ecr === false) {
                DynamicForm_CriteriaForm_ecr.clearFieldErrors("endDate2", true);
                DynamicForm_CriteriaForm_ecr.addFieldErrors("endDate2", "<spring:message code='msg.correct.date'/>", true);
            }
            if (endDate1Check_ecr === false) {
                DynamicForm_CriteriaForm_ecr.clearFieldErrors("endDate1", true);
                DynamicForm_CriteriaForm_ecr.addFieldErrors("endDate1", "<spring:message code='msg.correct.date'/>", true);
            }
        }
        return true;
    }

    // </script>