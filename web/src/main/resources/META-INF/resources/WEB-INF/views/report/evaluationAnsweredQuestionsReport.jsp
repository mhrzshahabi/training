<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


// <script>

    //----------------------------------------------------Variables-----------------------------------------------------
    let excelData = [];
    var isCriteriaCategoriesChanged_Answered_Questions_Details = false;
    let reportCriteria_Answered_Questions_Details = null;

    //----------------------------------------------------Rest DataSource-----------------------------------------------

    RestDataSource_Answered_Questions_Details = isc.TrDS.create({
        fields: [
            {name: "classCode", title: "<spring:message code="class.code"/>", filterOperator: "iContains"},
            {name: "classTitle", title: "<spring:message code="class.title"/>", filterOperator: "iContains"},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains"},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains"},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains"},
            {name: "complexTitle", title: "<spring:message code="complex"/>", filterOperator: "iContains"},
            {name: "questionTitle", title: "<spring:message code="question"/>", filterOperator: "iContains"},
            {name: "answerTitle", title: "<spring:message code="answer"/>", filterOperator: "iContains"},

        ],
        fetchDataURL: evaluationUrl + "/getAnsweredEvalQuestionsDetails/",
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
                name: "evaluationQuestion.question",
                title: "<spring:message code="question"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "weight", title: "<spring:message code="weight"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "order", title: "<spring:message code="order"/>", filterOperator: "iContains"},
        ],
    });

    //---------------------------------------------------- Form------------------------------------------------
    ToolStripButton_Excel_Answered_Questions_Details = isc.ToolStripButtonExcel.create({
        click: function () {
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
                pickListFields: [{name: "evaluationQuestion.question"}],
                disabled: true,
                multiple: true,
                filterLocally: true,
                pickListProperties: {
                    showFilterEditor: true,
                    filterOperator: "iContains"
                },
            }
        ]
    });


    IButton_Report_Answered_Questions_Details = isc.IButtonSave.create({
        top: 260,
        title: "نمایش گزارش",
        width: 300,
        click: function () {
            data_values = DynamicForm_CriteriaForm_Answered_Questions_Details.getValuesAsAdvancedCriteria();
            reportCriteria_Answered_Questions_Details = data_values;
            RestDataSource_Answered_Questions_Details.fetchDataURL = evaluationUrl + "/getAnsweredEvalQuestionsDetails/";


            let url = evaluationUrl + "/getAnsweredEvalQuestionsDetails/";
            let questionIds = [];
            if (DynamicForm_CriteriaForm_Answered_Questions_Details.getField("questionnaire").getValue() !== undefined && DynamicForm_CriteriaForm_Answered_Questions_Details.getField("questionnaire").getValue() !== null) {
                questionIds = DynamicForm_CriteriaForm_Answered_Questions_Details.getField("question").getValue();
            } else {
                createDialog("info", "لطفا پرسشنامه و سوال را انتخاب کنید", "<spring:message code="message"/>")
                return;
            }
            if (questionIds === null || questionIds === undefined || questionIds.length === 0) {
                createDialog("info", "هیچ سوالی انتخاب نشده است", "<spring:message code="message"/>")
                return;
            }
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(url, "POST", JSON.stringify(questionIds), function (resp) {
                wait.close();
                if (resp.httpResponseCode === 200) {
                    ListGrid_Answered_Questions_Details.invalidateCache();
                    let data = JSON.parse(resp.data);
                    ListGrid_Answered_Questions_Details.setData(data);
                } else {
                    wait.close();
                    createDialog("info", "هیچ رکوردی برای نمایش وحود ندارد", "<spring:message code="message"/>")
                }
            }));
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
    var HLayOut_Confirm_Answered_Questions_Details = isc.TrHLayoutButtons.create({
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

    var ListGrid_Answered_Questions_Details = isc.TrLG.create({
        height: "70%",
        dataPageSize: 1000,
        filterOnKeypress: false,
        showFilterEditor: false,
        dataSource: RestDataSource_Answered_Questions_Details,
        fields: [
            {name: "classCode"},
            {name: "classTitle"},
            {name: "firstName"},
            {name: "lastName"},
            {name: "nationalCode"},
            {name: "complexTitle"},
            {name: "questionTitle"},
            {name: "answerTitle"}

        ]
    });

    var VLayout_Body_Answered_Questions_Details = isc.TrVLayout.create({
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
        if (ListGrid_Answered_Questions_Details.getOriginalData().length === 0) {
            createDialog("info", "جدول نتایج خالیست.");
        } else {
            let records = ListGrid_Answered_Questions_Details.data.toArray();
            excelData = [];
            excelData.add({
                classCode: "کد کلاس",
                classTitle: "عنوان کلاس",
                firstName: "نام ",
                lastName: "نام خانوادگی ",
                nationalCode: "کد ملی",
                complexTitle: "مجتمع",
                questionTitle: "سوال",
                answerTitle: "پاسخ"

            });

            if (records) {
                for (let j = 0; j < records.length; j++) {
                    excelData.add({
                        rowNum: j + 1,
                        classCode: records[j].classCode,
                        classTitle: records[j].classTitle,
                        firstName: records[j].firstName,
                        lastName: records[j].lastName,
                        nationalCode: records[j].nationalCode,
                        complexTitle: records[j].complexTitle,
                        questionTitle: records[j].questionTitle,
                        answerTitle: records[j].answerTitle

                    });

                }
            }
            let fields = [
                {name: "rowNum"},
                {name: "classCode"},
                {name: "classTitle"},
                {name: "firstName"},
                {name: "lastName"},
                {name: "nationalCode"},
                {name: "complexTitle"},
                {name: "questionTitle"},
                {name: "answerTitle"},
            ];
            ExportToFile.exportToExcelFromClient(fields, excelData, "", "گزارش سوالات ارزیابی ", null);
        }
    }

    // </script>