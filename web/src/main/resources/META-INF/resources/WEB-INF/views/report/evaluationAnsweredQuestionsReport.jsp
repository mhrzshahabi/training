<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN); %>


// <script>

    //----------------------------------------------------Variables-----------------------------------------------------
    let excelData = [];
    let ids = "";
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
        fetchDataURL: evaluationUrl + "/getAnsweredEvalQuestionsDetails/"+ids.toString(),
    });

    var RestDataSource_Class_evalAnsweredQuestions = isc.TrDS.create({
        ID: "RestDataSource_Class_evalAnsweredQuestions",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleClass"},
            {name: "code"},
            {name: "course.titleFa"}
        ],
        fetchDataURL: classUrl + "info-tuple-list"
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
            },
            {
                name: "class",
                title: "<spring:message code="class"/>",
                type: "SelectItem",
                textAlign: "center",
                colSpan: 2,
                titleColSpan: 1,
                autoFetchData: false,
                valueField: "evaluationQuestionId",
                optionDataSource: RestDataSource_Class_evalAnsweredQuestions,
                displayField: "titleClass",
                pickListFields: [{name: "code"},{name:"titleClass"}],
                disabled: false,
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
            let classIds = [];
            if (DynamicForm_CriteriaForm_Answered_Questions_Details.getField("questionnaire").getValue() !== undefined && DynamicForm_CriteriaForm_Answered_Questions_Details.getField("questionnaire").getValue() !== null && DynamicForm_CriteriaForm_Answered_Questions_Details.getField("class").getValue() !== null ) {
                questionIds = DynamicForm_CriteriaForm_Answered_Questions_Details.getField("question").getValue();
                classIds = DynamicForm_CriteriaForm_Answered_Questions_Details.getField("class").getValue();
            } else {
                createDialog("info", "لطفا پرسشنامه - سوال و کلاس را انتخاب کنید", "<spring:message code="message"/>")
                return;
            }
            if (questionIds === null || questionIds === undefined || questionIds.length === 0) {
                createDialog("info", "هیچ سوالی انتخاب نشده است", "<spring:message code="message"/>")
                return;
            }
            if (classIds === null || classIds === undefined || classIds.length === 0) {
                createDialog("info", "هیچ کلاسی انتخاب نشده است", "<spring:message code="message"/>")
                return;
            }
            wait.show();
            ids= JSON.stringify(questionIds).toString().replace("]", "").replace("[","");
                isc.RPCManager.sendRequest(TrDSRequest(url+ids,"GET",null, function (resp) {
                wait.close();
                if (resp.httpResponseCode === 200) {

                    ListGrid_Answered_Questions_Details.invalidateCache();
                    let data = (JSON.parse(resp.data)).response.data;

                    ListGrid_Answered_Questions_Details.setData(data);
                } else {
                    wait.close();
                    ListGrid_Answered_Questions_Details.setData([]);
                    createDialog("info", "هیچ رکوردی برای نمایش وجود ندارد", "<spring:message code="message"/>")
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
        // dataPageSize: 1000,
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
        if (ListGrid_Answered_Questions_Details.getOriginalData().length === 0)
            createDialog("info", "جدول نتایج خالیست");
        else
            ExportToFile.downloadExcelRestUrl(null, ListGrid_Answered_Questions_Details, evaluationUrl + "/getAnsweredEvalQuestionsDetails/"+ids, 0, null, '',"گزارش سوالات ارزیابی"  , reportCriteria_Answered_Questions_Details, null);

    }

    // </script>