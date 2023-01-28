<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN); %>

// <script>

    //----------------------------------------------------Variables-----------------------------------------------------
    let isCriteriaCategoriesChanged_Answered_Questions_Details = false;
    let isCriteriaCategoriesChanged_AQD = false;
    let reportCriteria_Answered_Questions_Details = null;

    let startDateCheck_Order_EAQ = true;
    let startDate1Check_EAQ = true;
    let startDate2Check_EAQ = true;
    let endDateCheck_Order_EAQ = true;
    let endDate1Check_EAQ = true;
    let endDate2Check_EAQ = true;

    //----------------------------------------------------Rest DataSource-----------------------------------------------

    RestDataSource_Answered_Questions_Details = isc.TrDS.create({
        fields: [
            {name: "classCode", title: "<spring:message code="class.code"/>", filterOperator: "iContains"},
            {name: "classTitle", title: "<spring:message code="class.title"/>", filterOperator: "iContains"},
            {name: "classStartDate", title: "<spring:message code="class.start.date"/>", filterOperator: "iContains"},
            {name: "classEndDate", title: "<spring:message code="class.end.date"/>", filterOperator: "iContains"},
            {name: "category", title: "<spring:message code="category"/>", filterOperator: "iContains"},
            {name: "subCategory", title: "<spring:message code="subcategory"/>", filterOperator: "iContains"},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains"},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains"},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains"},
            {name: "complexTitle", title: "<spring:message code="complex"/>", filterOperator: "iContains"},
            {name: "domain", title: "حیطه", filterOperator: "iContains"},
            {name: "questionTitle", title: "<spring:message code="question"/>", filterOperator: "iContains"},
            {name: "answerTitle", title: "<spring:message code="answer"/>", filterOperator: "iContains"},
            {name: "teacherName", title: "<spring:message code="teacher.name"/>", filterOperator: "iContains"},
            {name: "teacherMobileNo", title: "<spring:message code="teacher.mobile"/>", filterOperator: "iContains"},
            {name: "studentMobileNo", title: "<spring:message code="student.mobile"/>", filterOperator: "iContains"},
            {name: "organizer", title: "<spring:message code="organizer"/>", filterOperator: "iContains"}

        ],
        fetchDataURL: evaluationUrl + "/getAnsweredEvalQuestionsDetails",
    });

    let RestDataSource_Class_evalAnsweredQuestions = isc.TrDS.create({
        ID: "RestDataSource_Class_evalAnsweredQuestions",
        fields: [
            {name: "id", primaryKey: true,hidden : true},
            {name: "titleClass",title :"<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code",title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        fetchDataURL: classUrl + "spec-list"
    });

    QuestionnaireDS_Answered_Questions_Details = isc.TrDS.create({
        ID: "QuestionnaireDS_Answered_Questions_Details",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "questionnaireTypeId", hidden: true},
            {
                name: "questionnaireType.title",
                title: "<spring:message code="type"/>",
                required: true,
                filterOperator: "iContains"
            },
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: questionnaireUrl + "/iscList",
    });

    QuestionnaireQuestionDS_Answered_Questions_Details = isc.TrDS.create({
        ID: "QuestionnaireQuestionDS_Answered_Questions_Details",
        fields: [
            {name: "evaluationQuestionId", primaryKey: true, hidden: true},
            {
                name: "evaluationQuestion.domain.title",
                title: "حیطه",
                filterOperator: "iContains"
            },
            {
                name: "evaluationQuestion.question",
                title: "<spring:message code="question"/>",
                filterOperator: "iContains"
            },
            {name: "weight", title: "<spring:message code="weight"/>", filterOperator: "iContains"},
            {name: "order", title: "<spring:message code="order"/>", filterOperator: "iContains"},
        ],
    });

    let RestDataSource_Category_AQD = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}],
        fetchDataURL: categoryUrl + "spec-list"
    });
    let RestDataSource_SubCategory_AQD = isc.TrDS.create({
        fields: [{name: "id"}, {name: "titleFa"}, {name: "category.titleFa"}],
        fetchDataURL: subCategoryUrl + "iscList"
    });

    //---------------------------------------------------- Form------------------------------------------------
    ToolStripButton_Excel_Answered_Questions_Details = isc.ToolStripButtonExcel.create({
        click: function () {
            // let listGridDataArray = ListGrid_Answered_Questions_Details.data;
            // ExportToFile.makeExcelOutputWithFieldsAndData(RestDataSource_Answered_Questions_Details, listGridDataArray, "", "گزارش سوالات ارزیابی", 0, 0);
            makeExcelAnsweredQuestions();
        }
    });

    ToolStripButton_Refresh_Answered_Questions_Details = isc.ToolStripButtonRefresh.create({
        click: function () {
            ListGrid_Answered_Questions_Details.invalidateCache();
        }
    });

    ToolStrip_Actions_Answered_Questions_Details = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_Answered_Questions_Details,
                        ToolStripButton_Excel_Answered_Questions_Details
                    ]
                })
            ]
    });

    DynamicForm_CriteriaForm_Answered_Questions_Details = isc.DynamicForm.create({
        align: "right",
        titleWidth: 0,
        titleAlign: "center",
        showInlineErrors: true,
        showErrorText: false,
        numCols: 6,
        colWidths: ["10%", "25%", "25%", "10%", "25%", "25%"],
        fields: [
            {
                name: "questionnaire",
                title: "<spring:message code="questionnaire"/>",
                type: "SelectItem",
                textAlign: "center",
                colSpan: 2,
                titleColSpan: 1,
                optionDataSource: QuestionnaireDS_Answered_Questions_Details,
                valueField: "id",
                // displayField: "title",
                required: true,
                filterFields: ["title"],
                filterLocally: true,
                pickListFields: [
                    {name: "title"},
                    {name: "questionnaireType.title"}
                ],
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                changed: function (form, item, value) {
                    isCriteriaCategoriesChanged_Answered_Questions_Details = true;
                    let questionField = form.getField("question");
                    questionField.clearValue();
                    if (this.getSelectedRecords() == null) {
                        questionField.clearValue();
                        questionField.disable();
                        return;
                    }
                    questionField.enable();
                    QuestionnaireQuestionDS_Answered_Questions_Details.fetchDataURL = questionnaireQuestionUrl + "/iscList/" + value;

                    QuestionnaireQuestionDS_Answered_Questions_Details.invalidateCache();
                    form.getItem("question").fetchData();


                }
            },
            {
                name: "question",
                title: "<spring:message code="question"/>",
                type: "SelectItem",
                textAlign: "center",
                colSpan: 2,
                titleColSpan: 1,
                autoFetchData: false,
                valueField: "evaluationQuestionId",
                optionDataSource: QuestionnaireQuestionDS_Answered_Questions_Details,
                displayField: "evaluationQuestion.question",
                required: true,
                pickListFields: [
                    {name: "evaluationQuestion.domain.title"},
                    {name: "evaluationQuestion.question"}],
                disabled: true,
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
            },
            {
                name: "class",
                title: "<spring:message code="class"/>",
                required: false,
                textAlign: "center",
                autoFetchData: false,
                colSpan: 2,
                displayField: "titleClass",
                valueField: "id",
                optionDataSource: RestDataSource_Class_evalAnsweredQuestions,
                sortField: ["id"],
                filterFields: ["code"],
                pickListFields: [
                    {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
                    {
                        name: "code",
                        title: "<spring:message code='class.code'/>",
                        align: "center",
                        filterOperator: "iContains"
                    },
                    {
                        name: "titleClass",
                        title: "<spring:message code='class.title'/>",
                        align: "center",
                        filterOperator: "iContains"
                    },
                ],
                pickListProperties: {
                    showFilterEditor: true
                },
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
                endRow: true,
                startRow: false,

                changed: function (form, item, value) {
                    //DynamicForm_course_GroupTab.getItem("code").setValue(courseCode());
                }
            },
            {
                name: "courseCategory",
                title: "گروه کاری",
                type: "SelectItem",
                textAlign: "center",
                optionDataSource: RestDataSource_Category_AQD,
                valueField: "id",
                colSpan: 2,
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                pickListFields: [
                    {
                        name: "id",
                        hidden: true,
                        align: "center"
                    },
                    {
                        name: "titleFa",
                        title: "عنوان گروه",
                        align: "center"
                    }
                ],
                changed: function () {
                    isCriteriaCategoriesChanged_AQD = true;
                    let subCategoryField = DynamicForm_CriteriaForm_Answered_Questions_Details.getField("courseSubCategory");
                    if (this.getSelectedRecords() == null) {
                        subCategoryField.clearValue();
                        subCategoryField.disable();
                        return;
                    }
                    subCategoryField.enable();
                    if (subCategoryField.getValue() === undefined)
                        return;
                    let subCategories = subCategoryField.getSelectedRecords();
                    let categoryIds = this.getValue();
                    let SubCats = [];
                    for (let i = 0; i < subCategories.length; i++) {
                        if (categoryIds.contains(subCategories[i].categoryId))
                            SubCats.add(subCategories[i].id);
                    }
                    subCategoryField.setValue(SubCats);
                    subCategoryField.focus(this.form, subCategoryField);
                }
            },
            {
                name: "courseSubCategory",
                title: "زیرگروه کاری",
                type: "SelectItem",
                textAlign: "center",
                colSpan: 2,
                autoFetchData: false,
                disabled: true,
                optionDataSource: RestDataSource_SubCategory_AQD,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    canSelectAll: true,
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
                pickListFields: [
                    {
                        name: "id",
                        hidden: true,
                        align: "center"
                    },
                    {
                        name: "category.titleFa",
                        title: "عنوان گروه",
                        align: "center",
                        sortNormalizer: function (record) {
                            return record.category.titleFa;
                        }
                    },
                    {
                        name: "titleFa",
                        title: "عنوان زیرگروه",
                        align: "center"
                    }
                ],
                focus: function () {
                    if (isCriteriaCategoriesChanged_AQD) {
                        isCriteriaCategoriesChanged_AQD = false;
                        let ids = DynamicForm_CriteriaForm_Answered_Questions_Details.getField("courseCategory").getValue();
                        if (ids === []) {
                            RestDataSource_SubCategory_AQD.implicitCriteria = null;
                        } else {
                            RestDataSource_SubCategory_AQD.implicitCriteria = {
                                _constructor: "AdvancedCriteria",
                                operator: "and",
                                criteria: [{fieldName: "categoryId", operator: "inSet", value: ids}]
                            };
                        }
                        this.fetchData();
                    }
                }
            },
            {
                name: "startDate1",
                ID: "startDate1_EAQ",
                title: "تاریخ شروع کلاس: از",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                colSpan: 2,
                titleColSpan: 1,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('startDate1_EAQ', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value === undefined || value === null) {
                        form.clearFieldErrors("startDate2","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("startDate1", true);
                        startDateCheck_Order_EAQ = true;
                        startDate1Check_EAQ = true;
                        return;
                    }
                    let dateCheck;
                    let endDate = form.getValue("startDate2");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        startDate1Check_EAQ = false;
                        startDateCheck_Order_EAQ = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        startDateCheck_Order_EAQ = false;
                        startDate1Check_EAQ = true;
                        form.clearFieldErrors("startDate1", true);
                        form.addFieldErrors("startDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    }
                    else {
                        startDate1Check_EAQ = true;
                        startDateCheck_Order_EAQ = true;
                        form.clearFieldErrors("startDate1", true);
                    }
                }
            },
            {
                name: "startDate2",
                ID: "startDate2_EAQ",
                title: "تا",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                colSpan: 2,
                titleColSpan: 1,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('startDate2_EAQ', this, 'ymd', '/', 'right');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value === undefined || value === null){
                        form.clearFieldErrors("startDate1","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("startDate2", true);
                        startDateCheck_Order_EAQ = true;
                        startDate2Check_EAQ = true;
                        return;
                    }
                    let dateCheck;
                    let startDate = form.getValue("startDate1");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        startDate2Check_EAQ = false;
                        startDateCheck_Order_EAQ = true;
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "<spring:message code='msg.correct.date'/>", true);
                    } else if (startDate !== undefined && value < startDate) {
                        form.clearFieldErrors("startDate2", true);
                        form.addFieldErrors("startDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        startDate2Check_EAQ = true;
                        startDateCheck_Order_EAQ = false;
                    } else {
                        form.clearFieldErrors("startDate2", true);
                        startDate2Check_EAQ = true;
                        startDateCheck_Order_EAQ = true;
                    }
                }
            },
            {
                name: "endDate1",
                ID: "endDate1_EAQ",
                title: "تاریخ پایان کلاس: از",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                length: 10,
                colSpan: 2,
                titleColSpan: 1,
                showHintInField: true,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function () {
                        closeCalendarWindow();
                        displayDatePicker('endDate1_EAQ', this, 'ymd', '/');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value === undefined || value === null) {
                        form.clearFieldErrors("endDate2","تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد" ,true);
                        form.clearFieldErrors("endDate1", true);
                        endDateCheck_Order_EAQ = true;
                        endDate1Check_EAQ = true;
                        return;
                    }
                    let dateCheck;
                    let endDate = form.getValue("endDate2");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        endDate1Check_EAQ = false;
                        endDateCheck_Order_EAQ = true;
                        form.clearFieldErrors("endDate1", true);
                        form.addFieldErrors("endDate1", "<spring:message code='msg.correct.date'/>", true);
                    } else if (endDate < value) {
                        endDateCheck_Order_EAQ = false;
                        endDate1Check_EAQ = true;
                        form.clearFieldErrors("endDate1", true);
                        form.addFieldErrors("endDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    } else {
                        endDate1Check_EAQ = true;
                        endDateCheck_Order_EAQ = true;
                        form.clearFieldErrors("endDate1", true);
                    }
                }
            },
            {
                name: "endDate2",
                ID: "endDate2_EAQ",
                title: "تا",
                hint: todayDate,
                keyPressFilter: "[0-9/]",
                showHintInField: true,
                length: 10,
                colSpan: 2,
                titleColSpan: 1,
                icons: [{
                    src: "<spring:url value="calendar.png"/>",
                    click: function (form) {
                        closeCalendarWindow();
                        displayDatePicker('endDate2_EAQ', this, 'ymd', '/', 'right');
                    }
                }],
                editorExit: function (form, item, value) {
                    if(value === undefined || value === null) {
                        form.clearFieldErrors("endDate1","تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد" ,true);
                        form.clearFieldErrors("endDate2", true);
                        endDateCheck_Order_EAQ = true;
                        endDate2Check_EAQ = true;
                        return;
                    }
                    let dateCheck;
                    let startDate = form.getValue("endDate1");
                    dateCheck = checkDate(value);
                    if (dateCheck === false) {
                        endDate2Check_EAQ = false;
                        endDateCheck_Order_EAQ = true;
                        form.clearFieldErrors("endDate2", true);
                        form.addFieldErrors("endDate2", "<spring:message code='msg.correct.date'/>", true);
                    } else if (startDate !== undefined && value < startDate) {
                        form.clearFieldErrors("endDate2", true);
                        form.addFieldErrors("endDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                        endDate2Check_EAQ = true;
                        endDateCheck_Order_EAQ = false;
                    } else {
                        form.clearFieldErrors("endDate2", true);
                        endDate2Check_EAQ = true;
                        endDateCheck_Order_EAQ = true;
                    }
                }
            }
        ]
    });

    IButton_Report_Answered_Questions_Details = isc.IButtonSave.create({
        top: 260,
        title: "نمایش گزارش",
        width: 300,
        click: function () {

            let questionIds = DynamicForm_CriteriaForm_Answered_Questions_Details.getField("question").getValue();
            let data_values = DynamicForm_CriteriaForm_Answered_Questions_Details.getValuesAsAdvancedCriteria();
            reportCriteria_Answered_Questions_Details = data_values;

            if (DynamicForm_CriteriaForm_Answered_Questions_Details.getField("questionnaire").getValue() !== undefined && DynamicForm_CriteriaForm_Answered_Questions_Details.getField("questionnaire").getValue() !== null) {

                if (startDateCheck_Order_EAQ === false ||
                    startDate2Check_EAQ === false ||
                    startDate1Check_EAQ === false ||
                    endDateCheck_Order_EAQ === false ||
                    endDate2Check_EAQ === false ||
                    endDate1Check_EAQ === false) {

                    if (startDateCheck_Order_EAQ === false) {
                        DynamicForm_CriteriaForm_Answered_Questions_Details.clearFieldErrors("startDate2", true);
                        DynamicForm_CriteriaForm_Answered_Questions_Details.addFieldErrors("startDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                    }
                    if (startDateCheck_Order_EAQ === false) {
                        DynamicForm_CriteriaForm_Answered_Questions_Details.clearFieldErrors("startDate1", true);
                        DynamicForm_CriteriaForm_Answered_Questions_Details.addFieldErrors("startDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    }
                    if (startDate2Check_EAQ === false) {
                        DynamicForm_CriteriaForm_Answered_Questions_Details.clearFieldErrors("startDate2", true);
                        DynamicForm_CriteriaForm_Answered_Questions_Details.addFieldErrors("startDate2", "<spring:message code='msg.correct.date'/>", true);
                    }
                    if (startDate1Check_EAQ === false) {
                        DynamicForm_CriteriaForm_Answered_Questions_Details.clearFieldErrors("startDate1", true);
                        DynamicForm_CriteriaForm_Answered_Questions_Details.addFieldErrors("startDate1", "<spring:message code='msg.correct.date'/>", true);
                    }
                    if (endDateCheck_Order_EAQ === false) {
                        DynamicForm_CriteriaForm_Answered_Questions_Details.clearFieldErrors("endDate2", true);
                        DynamicForm_CriteriaForm_Answered_Questions_Details.addFieldErrors("endDate2", "تاریخ انتخاب شده باید مساوی یا بعد از تاریخ شروع باشد", true);
                    }
                    if (endDateCheck_Order_EAQ === false) {
                        DynamicForm_CriteriaForm_Answered_Questions_Details.clearFieldErrors("endDate1", true);
                        DynamicForm_CriteriaForm_Answered_Questions_Details.addFieldErrors("endDate1", "تاریخ انتخاب شده باید قبل یا مساوی تاریخ پایان باشد", true);
                    }
                    if (endDate2Check_EAQ === false) {
                        DynamicForm_CriteriaForm_Answered_Questions_Details.clearFieldErrors("endDate2", true);
                        DynamicForm_CriteriaForm_Answered_Questions_Details.addFieldErrors("endDate2", "<spring:message code='msg.correct.date'/>", true);
                    }
                    if (endDate1Check_EAQ === false) {
                        DynamicForm_CriteriaForm_Answered_Questions_Details.clearFieldErrors("endDate1", true);
                        DynamicForm_CriteriaForm_Answered_Questions_Details.addFieldErrors("endDate1", "<spring:message code='msg.correct.date'/>", true);
                    }
                    return;
                }

            } else {
                createDialog("info", "لطفا پرسشنامه و سوال را انتخاب کنید", "<spring:message code="message"/>")
                return;
            }
            if (questionIds === null || questionIds === undefined || questionIds.length === 0) {
                createDialog("info", "هیچ سوالی انتخاب نشده است", "<spring:message code="message"/>")
                return;
            }

            RestDataSource_Answered_Questions_Details.fetchDataURL = evaluationUrl + "/getAnsweredEvalQuestionsDetails";
            ListGrid_Answered_Questions_Details.invalidateCache();
            ListGrid_Answered_Questions_Details.fetchData(data_values);
        }
    });

    IButton_Clear_Form_Answered_Questions_Details = isc.IButtonSave.create({
        top: 260,
        title: "پاک کردن",
        width: 300,
        click: function () {
            ListGrid_Answered_Questions_Details.setData([]);
            DynamicForm_CriteriaForm_Answered_Questions_Details.clearValues();
            DynamicForm_CriteriaForm_Answered_Questions_Details.clearErrors();
            ListGrid_Answered_Questions_Details.setFilterEditorCriteria(null);
        }
    });

    //----------------------------------- layOut & grid-----------------------------------------------------------------------
    let HLayOut_Confirm_Answered_Questions_Details = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "100%",
        height: "10%",
        alignLayout: "center",
        padding: 10,
        members: [
            IButton_Report_Answered_Questions_Details,
            IButton_Clear_Form_Answered_Questions_Details
        ]
    });

    let ListGrid_Answered_Questions_Details = isc.TrLG.create({
        height: "70%",
        filterOnKeypress: false,
        showFilterEditor: false,
        dataSource: RestDataSource_Answered_Questions_Details,
        fields: [
            {name: "classCode", autoFitWidth: true},
            {name: "classTitle", autoFitWidth: true},
            {name: "classStartDate", autoFitWidth: true},
            {name: "classEndDate", autoFitWidth: true},
            {name: "category", autoFitWidth: true},
            {name: "subCategory", autoFitWidth: true},
            {name: "firstName", autoFitWidth: true},
            {name: "lastName", autoFitWidth: true},
            {name: "nationalCode", autoFitWidth: true},
            {name: "complexTitle", autoFitWidth: true},
            {name: "domain", autoFitWidth: true},
            {name: "questionTitle", autoFitWidth: true},
            {name: "answerTitle", autoFitWidth: true},
            {name: "teacherName", autoFitWidth: true},
            {name: "teacherMobileNo", autoFitWidth: true},
            {name: "studentMobileNo", autoFitWidth: true},
            {name: "organizer", autoFitWidth: true}
        ]
    });

    let VLayout_Body_Answered_Questions_Details = isc.TrVLayout.create({
        border: "2px solid blue",
        padding: 20,
        members: [
            ToolStrip_Actions_Answered_Questions_Details,
            DynamicForm_CriteriaForm_Answered_Questions_Details,
            HLayOut_Confirm_Answered_Questions_Details,
            ListGrid_Answered_Questions_Details
        ]
    });

    //------------------------------------------------- Functions ------------------------------------------------------

    function makeExcelAnsweredQuestions() {
        if (ListGrid_Answered_Questions_Details.getOriginalData().localData.size() === 0)
            createDialog("info", "جدول نتایج خالیست");
        else
            ExportToFile.downloadExcelRestUrl(null, ListGrid_Answered_Questions_Details, evaluationUrl + "/getAnsweredEvalQuestionsDetails", 0, null, '',"گزارش سوالات ارزیابی"  , reportCriteria_Answered_Questions_Details, null);
    }

    // </script>