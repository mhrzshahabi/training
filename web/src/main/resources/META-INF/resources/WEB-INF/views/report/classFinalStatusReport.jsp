<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
// <script>

    //----------------------------------------------------Variables-----------------------------------------------------
    let isCriteriaCategoriesChanged_csfr = false;
    let reportCriteria_csfr = null;
    let minScoreER_csfr = null;
    let minQusER_csfr = null;
    let stdToContent_csfr = null;
    let stdToTeacher_csfr = null;
    let stdToFacility_csfr = null;
    let teachToClass_csfr = null;
    let recordsEvalData_csfr = [];

    let startDate1Check_csfr = true;
    let startDate2Check_csfr = true;
    let startDateCheck_Order_csfr = true;
    let endDate1Check_csfr = true;
    let endDate2Check_csfr = true;
    let endDateCheck_Order_csfr = true;

    //----------------------------------------------------Default Rest--------------------------------------------------
    isc.RPCManager.sendRequest(TrDSRequest(parameterUrl + "/iscList/FER", "GET", null, function (resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

            let result = (JSON.parse(resp.data)).response.data;
            minScoreER_csfr = Number(result.filter(q => q.code === "minScoreER").first().value);
            minQusER_csfr = Number(result.filter(q => q.code === "minQusER").first().value);
            stdToContent_csfr = Number(result.filter(q => q.code === "z3").first().value);
            stdToTeacher_csfr = Number(result.filter(q => q.code === "z4").first().value);
            stdToFacility_csfr = Number(result.filter(q => q.code === "z6").first().value);
            teachToClass_csfr = Number(result.filter(q => q.code === "z5").first().value);

        }
    }));

    //----------------------------------------------------Rest DataSource-----------------------------------------------
    let RestDataSource_Category_csfr = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "spec-list"
    });
    let RestDataSource_SubCategory_csfr = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"},],
        fetchDataURL: subCategoryUrl + "iscList"
    });
    let RestDataSource_ListGrid_Student_csfr = isc.TrDS.create({
        // ID: "RestDataSource_ListGrid_Student_csfr",
        fields: [
            {name: "id", primaryKey: true},
            {name: "class.code"},
            {name: "course.code"},
            {name: "class.title"},
            {name: "teacher"},
            {name: "student.national.code"},
            {name: "student.full.name"},
            {name: "student.complex"},
            {name: "student.assistant"},
            {name: "student.affair"},
            {name: "acceptanceState"},
            {name: "score"},
            {name: "acceptance.limit"},
            {name: "executor"}
        ],

    });
    let RestDataSource_ListGrid_Course_csfr = isc.TrDS.create({
        // ID: "RestDataSource_ListGrid_Course_csfr",
        fields: [
            {name: "id", primaryKey: true},
            {name: "class.code"},
            {name: "course.code"},
            {name: "class.title"},
            {name: "teacher"},
            {name: "classStatus"},
            {name: "score.state"},
            {name: "acceptancePercent"},
            {name: "executor"},
        ]
    });
    let RestDataSource_Term_csfr = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"},
            {name: "code"},
            {name: "startDate"},
            {name: "endDate"}
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
            {name: "hduration",canFilter: false},
            {name: "classCancelReasonId"},
            {name: "titleClass", },
            {name: "startDate", },
            {name: "endDate", },
            {name: "studentCount", canFilter: false, canSort: false},
            {name: "code", },
            {name: "term.titleFa", },
            {name: "courseId", },
            {name: "course.titleFa", },
            {name: "course.id", },
            {name: "teacherId", },
            {
                name: "teacher",

            },
            {
                name: "teacher.personality.lastNameFa",

            },
            {name: "reason" , },
            {name: "classStatus" , },
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
                name: "class.code",
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
    DynamicForm_SelectClasses_csfr.getField("class.code").comboBox.setHint("کلاسهای مورد نظر را انتخاب کنید");
    DynamicForm_SelectClasses_csfr.getField("class.code").comboBox.pickListFields = [
        {name: "titleClass", title: "نام کلاس", width: "30%", filterOperator: "iContains"},
        {name: "code", title: "کد کلاس", width: "30%", filterOperator: "iContains"},
        {name: "course.titleFa", title: "نام دوره", width: "30%", filterOperator: "iContains"}];
    DynamicForm_SelectClasses_csfr.getField("class.code").comboBox.filterFields = ["titleClass", "code", "course.titleFa"];
    let IButton_ConfirmClassesSelections_csfr = isc.IButtonSave.create({
        top: 260,
        title: "تائید",
        width: 300,
        click: function () {
            let form = DynamicForm_SelectClasses_csfr;
            let criteriaDisplayValues = "";
            let selectorDisplayValues = form.getItem("class.code").getValue();

            if (form.getField("class.code").getValue() !== undefined && form.getField("class.code").getValue() !== "") {
                criteriaDisplayValues = form.getField("class.code").getValue().join(",");
                let ALength = criteriaDisplayValues.length;
                let lastChar = criteriaDisplayValues.charAt(ALength - 1);
                if (lastChar !== ";")
                    criteriaDisplayValues += ",";

                RestDataSource_Term_csfr.fetchDataURL = termUrl + "listByYear/" + criteriaDisplayValues;
                DynamicForm_CriteriaForm_csfr.getField("classScore").optionDataSource = RestDataSource_Term_csfr;
                DynamicForm_CriteriaForm_csfr.getField("classScore").fetchData();
                DynamicForm_CriteriaForm_csfr.getField("classScore").enable();
            } else {
                DynamicForm_CriteriaForm_csfr.getField("classScore").disable();
            }
            if (selectorDisplayValues !== undefined) {
                for (let i = 0; i < selectorDisplayValues.size() - 1; i++) {
                    criteriaDisplayValues += selectorDisplayValues [i] + ",";
                }
                criteriaDisplayValues += selectorDisplayValues [selectorDisplayValues.size() - 1];
            }

            if (typeof criteriaDisplayValues != "undefined") {
                let uniqueNames = [];

                $.each(criteriaDisplayValues.split(","), function (i, el) {
                    if ($.inArray(el, uniqueNames) === -1) uniqueNames.push(el);
                });
                criteriaDisplayValues = uniqueNames.join(",");
            }

            criteriaDisplayValues = criteriaDisplayValues == "undefined" ? "" : criteriaDisplayValues;

            DynamicForm_CriteriaForm_csfr.getField("tclassCode").setValue(criteriaDisplayValues);
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
                name: "startDate1",
                ID: "startDate1_cfsr",
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
                        displayDatePicker('startDate1_cfsr', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("startDate2","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("startDate1", true);
                        startDateCheck_Order_csfr = true;
                        startDate1Check_csfr = true;
                        return;
                    }
                    var dateCheck;
                    var endDate = form.getValue("startDate2");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        startDate1Check_csfr = false;
                        startDateCheck_Order_csfr = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        startDateCheck_Order_csfr = false;
                        startDate1Check_csfr = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    }
                    else {
                        startDate1Check_csfr = true;
                        startDateCheck_Order_csfr = true;
                        form.clearFieldErrors("startDate1", true);
                    }
                }
            },
            {
                name: "startDate2",
                ID: "startDate2_cfsr",
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
                        displayDatePicker('startDate2_cfsr', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value == undefined || value ==null){
                        form.clearFieldErrors("startDate1","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("startDate2", true);
                        startDateCheck_Order_csfr = true;
                        startDate2Check_csfr = true;
                        return;
                    }
                    var dateCheck;
                    dateCheck = checkDate(value);
                    var startDate = form.getValue("startDate1");
                    if (dateCheck === false) {
                        startDate2Check_csfr = false;
                        startDateCheck_Order_csfr = true;
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "<spring:message code='msg.correct.date'/>", true);
                    } else if (startDate != undefined && value < startDate) {
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        startDate2Check_csfr = true;
                        startDateCheck_Order_csfr = false;
                    } else {
                        form.clearFieldErrors("startDate2", true);
                        startDate2Check_csfr = true;
                        startDateCheck_Order_csfr = true;
                    }
                }
            },
            {
                name: "tclassYear",
                title: "سال کاری",
                type: "SelectItem",
                required: true,
                optionDataSource: RestDataSource_Year_csfr,
                valueField: "year",
                displayField: "year",
                filterFields: ["year"],
                filterLocally: true,
                changed: function (form, item, value) {

                    form.getField("termId").clearValue();
                    if (value !== null && value !== undefined) {
                        RestDataSource_Term_csfr.fetchDataURL = termUrl + "listByYear/" + value;
                        DynamicForm_CriteriaForm_csfr.getField("termId").optionDataSource = RestDataSource_Term_csfr;
                        DynamicForm_CriteriaForm_csfr.getField("termId").fetchData();
                        DynamicForm_CriteriaForm_csfr.getField("termId").enable();
                    } else {
                        form.getField("termId").disabled = true;
                    }
                }
            },
            {
                name: "termId",
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
                                        debugger
                                        let item = DynamicForm_CriteriaForm_csfr.getField("termId"),
                                            fullData = item.pickList.data,
                                            cache = fullData.localData,
                                            values = [];

                                        for (let i = 0; i < cache.length; i++) {
                                            values[i] = cache[i].id;
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
                                        let item = DynamicForm_CriteriaForm_csfr.getField("termId");
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
                name: "tclassCode",
                title: "کد کلاس",
                hint: "کد کلاس را انتخاب نمائيد",
                showHintInField: true,
                icons: [{
                    src: "[SKIN]/pickers/search_picker.png",
                    click: function () {
                        Window_SelectClasses_csfr.show();
                    }}],
                keyPressFilter: "[A-Z|0-9|,-]",
                changed: function (form, item, value) {
                    form.getField("classScore").clearValue();
                    if (value !== null && value !== undefined) {
                        // RestDataSource_Term_csfr.fetchDataURL = termUrl + "listByYear/" + value;
                        // DynamicForm_CriteriaForm_csfr.getField("classScore").optionDataSource = RestDataSource_Term_csfr;
                        // DynamicForm_CriteriaForm_csfr.getField("classScore").fetchData();
                        DynamicForm_CriteriaForm_csfr.getField("classScore").enable();
                    } else {
                        form.getField("classScore").disabled = true;
                    }
                }
            },
            {
                name: "classScore",
                title: "<spring:message code='score.state'/>:",
                type: "SelectItem",
                multiple: true,
                // filterOperator: "equals",
                disabled: true,
                valueField: "id",
                displayField: "titleFa",
                // filterLocally: true,
                valueMap: {
                    "WITH_SCORE": "با نمره",
                    "WITHOUT_SCORE": "بدون نمره",
                },
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
                                        debugger
                                        let item = DynamicForm_CriteriaForm_csfr.getField("classScore"),
                                            fullData = item.pickList.data,
                                            cache = fullData.localData,
                                            values = [];

                                        for (let i = 0; i < cache.length; i++) {
                                            values[i] = cache[i].id;
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
                                        let item = DynamicForm_CriteriaForm_csfr.getField("classScore");
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
                name: "studentId",
                title: "<spring:message code='student'/>:",
                type: "ComboBoxItem",
                autoFetchData: false,
                optionDataSource: RestDataSource_Student_csfr,
                // dataPageSize: 50,
                valueField: "id",
                displayField: "fullName",
                filterFields: ["personality.firstNameFa", "personality.lastNameFa", "personality.nationalCode"],
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

    let IButton_student_csfr = isc.IButtonSave.create({
        top: 260,
        title: "استخراج بر اساس فراگیر",
        width: 300,
        height: "100%",
        click: function () {

        }
    });
    let IButton_course_csfr = isc.IButtonSave.create({
        top: 260,
        title: "استخراج بر اساس دوره",
        width: 300,
        height: "100%",
        click: function () {

        }
    });


    //----------------------------------- layOut -----------------------------------------------------------------------
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

    let ListGrid_CSFR_Student = isc.TrLG.create({
        width: "100%",
        height: "100%",
        // dataSource: RestDataSource_Class_cfsr,
        dataPageSize: 50,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        showRollOver:false,
        selectionType: "single",
        autoFetchData: false,
        autoFitWidth: true,
        initialSort: [
            {property: "startDate", direction: "descending", primarySort: true}
        ],
        // selectionUpdated: function (record) {
        //
        //     ToolStrip_SendForms_JspClass.getField("sendButtonTraining").showIcon("ok");
        //     ToolStrip_SendForms_JspClass.getField("registerButtonTraining").showIcon("ok");
        //     if(record) {
        //         if (record.evaluationStatusReactionTraining === "0" || record.evaluationStatusReactionTraining === 0 || record.evaluationStatusReactionTraining == null) {
        //             ToolStrip_SendForms_JspClass.getField("sendButtonTraining").hideIcon("ok");
        //             ToolStrip_SendForms_JspClass.getField("registerButtonTraining").hideIcon("ok");
        //         } else {
        //             if (record.evaluationStatusReactionTraining === "2" || record.evaluationStatusReactionTraining === 2 ||
        //                 record.evaluationStatusReactionTraining === "3" || record.evaluationStatusReactionTraining === 3) {
        //                 ToolStrip_SendForms_JspClass.getField("sendButtonTraining").showIcon("ok");
        //                 ToolStrip_SendForms_JspClass.getField("registerButtonTraining").showIcon("ok");
        //             }
        //             else {
        //                 ToolStrip_SendForms_JspClass.getField("sendButtonTraining").showIcon("ok");
        //                 ToolStrip_SendForms_JspClass.getField("registerButtonTraining").hideIcon("ok");
        //             }
        //         }
        //     }
        //     refreshSelectedTab_class(tabSetClass.getSelectedTab());
        // },
        // doubleClick: function () {
        //     ListGrid_class_edit();
        // },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {
                name: "class.code",
                title: "<spring:message code='class.code'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "course.code",
                title: "<spring:message code='course.code'/>",
                align: "center",
                filterOperator: "iContains",
                sortNormalizer: function (record) {
                    return record.course.titleFa;
                }
            },
            {
                name: "class.title",
                title: "<spring:message code="class.title"/>",
                align: "center",
                filterOperator: "iContains",
                hidden: false
            },
            {
                name: "teacher",
                title: "<spring:message code='trainer'/>",
                displayField: "teacher.personality.lastNameFa",
                type: "TextItem",
                sortNormalizer(record) {
                    return record.teacher.personality.lastNameFa;
                },
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "student.national.code",
                title: "<spring:message code='student.national.code'/>",
                displayField: "teacher.personality.lastNameFa",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "student.full.name",
                title: "<spring:message code='student.full.name'/>",
                displayField: "teacher.personality.lastNameFa",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "student.complex",
                title: "<spring:message code="student.complex"/>",
                canSort: false,
                align: "center",
            },
            {
                name: "student.assistant",
                title: "<spring:message code="student.assistant"/>",
                canSort: false,
                align: "center",
            },
            {
                name: "student.affair",
                title: "<spring:message code="student.affair"/>",
                canSort: false,
                align: "center",
            },
            {name: "acceptanceState", title: "<spring:message code="pass.mode"/>", filterOperator: "iContains"},
            {name: "score", title: "<spring:message code="score"/>", filterOperator: "iContains"},
            {name: "acceptance.limit", title: "<spring:message code="acceptance.limit"/>", filterOperator: "iContains"},
            {name: "executor", title: "<spring:message code="executer"/>", filterOperator: "iContains"},
        ],
        // getCellCSSText: function (record, rowNum, colNum) {
        //     let style;
        //     if (this.isSelected(record)) {
        //         style =  "background-color:" + "#fe9d2a;";
        //     } else if (record.workflowEndingStatusCode === 2) {
        //         style =  "background-color:" + "#bef5b8;";
        //     } else {
        //         if (record.classStatus === "1")
        //             style =  "background-color:" + "#ffffff;";
        //         else if (record.classStatus === "2")
        //             style =  "background-color:" + "#fff9c4;";
        //         else if (record.classStatus === "3")
        //             style =  "background-color:" + "#cdedf5;";
        //         else if (record.classStatus === "4")
        //             style =  "color:" + "#d6d6d7;";
        //     }
        //     if (this.getFieldName(colNum) == "teacher") {
        //         style +=  "color: #0066cc;text-decoration: underline !important;cursor: pointer !important;}"
        //     }
        //     return style;
        // },
        // cellClick: function (record, rowNum, colNum) {
        //     if (this.getFieldName(colNum) == "teacher") {
        //         ListGrid_teacher_edit(record.teacherId,"class")
        //     }
        // },
        // dataArrived: function () {
        //     wait.close();
        //     selectWorkflowRecord();
        // },
        // createRecordComponent: function (record, colNum) {
        //     var fieldName = this.getFieldName(colNum);
        //     if (fieldName == "sendClassToOnlineBtn") {
        //         let sendBtn = isc.IButton.create({
        //             layoutAlign: "center",
        //             disabled: (record.classToOnlineStatus == true) || (record.classStatus === "1"),
        //             title: "ارسال به آزمون آنلاین",
        //             width: "145",
        //             margin: 3,
        //             click: function () {
        //                 sendClassToOnline(record.id)
        //             }
        //         });
        //         return sendBtn;
        //     } else {
        //         return null;
        //     }
        // }
    });
    let ListGrid_CSFR_Course = isc.TrLG.create({
        width: "100%",
        height: "100%",
        // dataSource: RestDataSource_Class_cfsr,
        dataPageSize: 50,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        showRollOver:false,
        selectionType: "single",
        autoFetchData: false,
        autoFitWidth: true,
        initialSort: [
            {property: "startDate", direction: "descending", primarySort: true}
        ],
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {
                name: "class.code",
                title: "<spring:message code='class.code'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "course.code",
                title: "<spring:message code='course.code'/>",
                align: "center",
                filterOperator: "iContains",
                sortNormalizer: function (record) {
                    return record.course.titleFa;
                }
            },
            {
                name: "class.title",
                title: "<spring:message code="class.title"/>",
                align: "center",
                filterOperator: "iContains",
                hidden: false
            },
            {
                name: "teacher",
                title: "<spring:message code='trainer'/>",
                displayField: "teacher.personality.lastNameFa",
                type: "TextItem",
                sortNormalizer(record) {
                    return record.teacher.personality.lastNameFa;
                },
                align: "center",
                filterOperator: "iContains",
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
            {name: "score.state", title: "<spring:message code="score.state"/>", filterOperator: "iContains"},
            {name: "acceptancePercent", title: "<spring:message code="acceptance.percent"/>", filterOperator: "iContains"},
            {name: "executor", title: "<spring:message code="executor.complex"/>", filterOperator: "iContains"},
        ]
    });

    let VLayout_ListGrid_CSFR_Result = isc.VLayout.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "65%",
        alignLayout: "center",
        layoutTopMargin: 5,
        members: [ListGrid_CSFR_Course]
    });

    let organSegmentFilter_cfsr = init_OrganSegmentFilterDF(true,true, true , null, "complexTitle","assistant","affairs", "section", "unit");

    let VLayOut_CriteriaForm_csfr = isc.VLayout.create({
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "35%",
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
        padding: 10,
        members: [
            VLayOut_CriteriaForm_csfr, VLayout_ListGrid_CSFR_Result
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------

    async function checkFormValidation() {
        DynamicForm_CriteriaForm_csfr.validate();
        if (DynamicForm_CriteriaForm_csfr.hasErrors())
            return false;

        if (!DynamicForm_CriteriaForm_csfr.validate() ||
            startDateCheck_Order_csfr === false ||
            startDate2Check_csfr === false ||
            startDate1Check_csfr === false ||
            endDateCheck_Order_csfr === false ||
            endDate2Check_csfr === false ||
            endDate1Check_csfr === false) {

            if (startDateCheck_Order_csfr === false) {
                DynamicForm_CriteriaForm_csfr.clearFieldErrors("startDate2", true);
                DynamicForm_CriteriaForm_csfr.addFieldErrors("startDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
            }
            if (startDateCheck_Order_csfr === false) {
                DynamicForm_CriteriaForm_csfr.clearFieldErrors("startDate1", true);
                DynamicForm_CriteriaForm_csfr.addFieldErrors("startDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
            }
            if (startDate2Check_csfr === false) {
                DynamicForm_CriteriaForm_csfr.clearFieldErrors("startDate2", true);
                DynamicForm_CriteriaForm_csfr.addFieldErrors("startDate2", "<spring:message code='msg.correct.date'/>", true);
            }
            if (startDate1Check_csfr === false) {
                DynamicForm_CriteriaForm_csfr.clearFieldErrors("startDate1", true);
                DynamicForm_CriteriaForm_csfr.addFieldErrors("startDate1", "<spring:message code='msg.correct.date'/>", true);
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