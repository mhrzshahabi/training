<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>
    var evalWait_JspQuestionEvaluation;

    var RestDataSource_Grid_JspQuestionEvaluation = isc.TrDS.create({
        fields: [
            {name: "evaluationLevel"},
            {name: "questionnarieType"},
            {name: "classCode"},
            {name: "classStartDate"},
            {name: "courseCode"},
            {name: "courseTitle"},
            {name: "teacherName"},
            {name: "hasWarning"},
            {name: "classId"},
            {name: "evaluatorId"},
            {name: "evaluatedId"},
            {name: "evaluatorName"},
            {name: "evaluatedName"},
            {name: "evaluatorTypeId"},
            {name: "evaluatedTypeId"},
            {name: "classEndDate"},
            {name: "classDuration"},
            {name: "classYear"},
            {name: "supervisorName"},
            {name: "plannerName"}
        ]
    });

    var RestData_EvaluationLevel_JspQuestionEvaluation = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "title",
                title: "<spring:message code="title"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "value",
                title: "<spring:message code="value"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            }
        ],
        fetchDataURL: parameterValueUrl + "/iscList/163"
    });

    var RestData_QuestionnarieType_JspQuestionEvaluation = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "title",
                title: "<spring:message code="title"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "value",
                title: "<spring:message code="value"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            }
        ],
        fetchDataURL: parameterValueUrl + "/iscList/143"
    });

    var RestData_EvaluatorType_JspQuestionEvaluation = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "title",
                title: "<spring:message code="title"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "value",
                title: "<spring:message code="value"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            }
        ],
        fetchDataURL: parameterValueUrl + "/iscList/188"
    });

    var ListGrid_Grid_JspQuestionEvaluation = isc.TrLG.create({
        width: "100%",
        height: "100%",
        dataSource: RestDataSource_Grid_JspQuestionEvaluation,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        selectionType: "single",
        autoFetchData: false,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        initialSort: [],
        doubleClick: function () {
            let record = ListGrid_Grid_JspQuestionEvaluation.getSelectedRecord();
            register_Evaluation_Form_JspQuestionEvaluation(record.classId, record.evaluatorId, record.evaluatorTypeId,
                record.evaluatedId, record.evaluatedTypeId, record.questionnarieType, record.evaluationLevel,
                record.teacherName, record.evaluatorName, record.evaluatedName, record.classCode, record.courseTitle, record.classStartDate);
        },
        fields: [
            {
                name: "evaluationLevel",
                title: "?????? ?????? ??????????????",
                type: "IntegerItem",
                editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                autoFitWidth: true,
                optionDataSource: RestData_EvaluationLevel_JspQuestionEvaluation,
                filterEditorProperties: {
                    pickListProperties: {
                        showFilterEditor: false
                    }
                }
            },
            {
                name: "questionnarieType",
                title: "?????? ?????? ??????????????",
                type: "IntegerItem",
                editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                autoFitWidth: true,
                optionDataSource: RestData_QuestionnarieType_JspQuestionEvaluation,
                filterEditorProperties: {
                    pickListProperties: {
                        showFilterEditor: false
                    }
                }
            },
            {name: "evaluatedName", title: "?????????????? ??????????",autoFitWidth: true},
            {
                name: "evaluatorTypeId",
                title: "?????? ??????????",
                type: "IntegerItem",
                editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                autoFitWidth: true,
                optionDataSource: RestData_EvaluatorType_JspQuestionEvaluation,
                filterEditorProperties: {
                    pickListProperties: {
                        showFilterEditor: false
                    }
                }
            },
            {name: "classCode", title: "???? ????????" ,autoFitWidth: true},
            {name: "courseCode", title: "???? ????????" ,autoFitWidth: true},
            {name: "courseTitle", title: "?????????? ????????" ,autoFitWidth: true},
            {name: "teacherName", title: "?????? ??????????", hidden:true},
            {name: "classStartDate", title: "?????????? ????????" ,autoFitWidth: true},
            {name: "classEndDate", title: "?????????? ??????????" ,autoFitWidth: true},
            {name: "classDuration", title: "??????" ,autoFitWidth: true},
            {name: "classYear", title: "??????" ,autoFitWidth: true},
            {name: "supervisorName", title: "?????????? ????????" ,autoFitWidth: true},
            {name: "plannerName", title: "?????????? ???????????? ??????" ,autoFitWidth: true},
            // {name: "hasWarning", title: " ", autoFitWidth: true, type: "image", imageURLPrefix: "", imageURLSuffix: ".gif"},
            {name: "saveResults", title: " ", align: "center", canSort: false, canFilter: false, autoFithWidth: true},
            {name: "classId", hidden: true},
            {name: "evaluatorId", hidden: true},
            {name: "evaluatedId", hidden: true},
            {name: "evaluatorName", hidden: true},
            {name: "evaluatedTypeId", hidden: true},
        ],
        createRecordComponent: function (record, colNum) {
            let fieldName = this.getFieldName(colNum);
            if (fieldName == "saveResults") {
                let button = isc.IButton.create({
                    layoutAlign: "center",
                    title: "?????? ?????????? ??????????????",
                    width: "120",
                    baseStyle: "registerFile",
                    click: function () {
                        register_Evaluation_Form_JspQuestionEvaluation(record.classId, record.evaluatorId, record.evaluatorTypeId,
                            record.evaluatedId, record.evaluatedTypeId, record.questionnarieType, record.evaluationLevel,
                            record.teacherName, record.evaluatorName, record.evaluatedName, record.classCode, record.courseTitle, record.classStartDate);
                    }
                });
                return button;
            }
            else {
                return null;
            }
        }
    });

    function call_questionEvaluation_forPersonnel(selectedPersonnel) {
        RestDataSource_Grid_JspQuestionEvaluation.fetchDataURL = studentPortalUrl + "/evaluation/getStudentEvaluationForms/"
            + selectedPersonnel.nationalCode + "/" + selectedPersonnel.id;
        ListGrid_Grid_JspQuestionEvaluation.fetchData();
        ListGrid_Grid_JspQuestionEvaluation.invalidateCache();
    }

    function call_questionEvaluation_forTeacher(selectedTeacher) {
        RestDataSource_Grid_JspQuestionEvaluation.fetchDataURL = evaluationUrl + "/teacherEvaluationForms/" + selectedTeacher.teacherId;
        ListGrid_Grid_JspQuestionEvaluation.fetchData();
        ListGrid_Grid_JspQuestionEvaluation.invalidateCache();
    }

    function register_Evaluation_Form_JspQuestionEvaluation(classId, evaluatorId, evaluatorTypeId, evaluatedId,
                                                            evaluatedTypeId, questionnaireTypeId, evaluationLevelId,
                                                            teacher, evaluatorName, evaluatedName, classCode, courseTitle, classStartDate)
    {
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

        let valueMapAnswer = {209: "???????? ????????", 208: "????????", 207: "??????????", 206: "??????", 205: "????????"};

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
                let Dialog_ASK_SAVE = createDialog("ask", "???? ???? ?????? ?????? ?????????????? ???????? ?????????? ?????????? ???????? ???????????? ?????????? ?????? ???? ?????????? ?? ?????????????? ?????????? ????????????", "?????????? ??????????");
                Dialog_ASK_SAVE.addProperties({
                    buttonClick: function (button, index) {
                        this.close();
                        if (index === 0) {
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
                            data.classId = classId;
                            data.evaluatorId = evaluatorId;
                            data.evaluatorTypeId = evaluatorTypeId;
                            data.evaluatedId = evaluatedId;
                            data.evaluatedTypeId = evaluatedTypeId;
                            data.questionnaireTypeId = questionnaireTypeId;
                            data.evaluationLevelId = evaluationLevelId;
                            data.status = true;
                            if(evaluationEmpty == false){
                                isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/" + evaluationId, "PUT", JSON.stringify(data), function (resp) {
                                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                        Window_Questions_JspEvaluation.close();
                                        ListGrid_Grid_JspQuestionEvaluation.invalidateCache();
                                        isc.RPCManager.sendRequest(TrDSRequest(evaluationAnalysisUrl + "/updateEvaluationAnalysis" + "/" +
                                        classId,
                                        "GET", null, null));
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
                                createDialog("info", "?????????? ???? ?????? ???? ???????????? ?????? ?????????????? ???????? ???????? ???????? ??????", "<spring:message code="error"/>");
                            }
                        }
                    }
                });
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

        DynamicForm_Questions_Title_JspEvaluation.getItem("code").setValue(classCode);
        DynamicForm_Questions_Title_JspEvaluation.getItem("titleClass").setValue(courseTitle);

        DynamicForm_Questions_Title_JspEvaluation.getItem("startDate").setValue(classStartDate);
        DynamicForm_Questions_Title_JspEvaluation.setValue("evaluator", evaluatorName);
        DynamicForm_Questions_Title_JspEvaluation.setValue("evaluated", evaluatedName);
        if (evaluationLevelId == 154 && questionnaireTypeId == 139) {
            DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationType").setValue("?????????????? ???????????? ???? ????????");
            DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationLevel").setValue("????????????");
        } else if (evaluationLevelId == 154 && questionnaireTypeId == 140) {
            DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationType").setValue("?????????????? ???????? ???? ????????");
            DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationLevel").setValue("????????????");
        } else if (evaluationLevelId == 156 && questionnaireTypeId == 230) {
            DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationType").setValue("?????????????? ?????????? ???? ????????????");
            DynamicForm_Questions_Title_JspEvaluation.getItem("evaluationLevel").setValue("????????????");
        }

        DynamicForm_Questions_Title_JspEvaluation.setValue("user", "<%= SecurityUtil.getFullName()%>");
        DynamicForm_Questions_Title_JspEvaluation.getItem("teacher").setValue(teacher);
        load_evaluation_form_JspQuestionEvaluation();

        Window_Questions_JspEvaluation.show();

        evalWait_JspQuestionEvaluation = createDialog("wait");

        function load_evaluation_form_JspQuestionEvaluation(criteria, criteriaEdit) {

            let data = {};
            data.classId = classId;
            data.evaluatorId = evaluatorId;
            data.evaluatorTypeId = evaluatorTypeId;
            data.evaluatedId = evaluatedId;
            data.evaluatedTypeId = evaluatedTypeId;
            data.questionnaireTypeId = questionnaireTypeId;
            data.evaluationLevelId = evaluationLevelId;

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
                                item.title = "??????????????: " + result[i].question;
                                break;
                            case 138:
                                item.name = "Q" + result[i].id;
                                item.title = "????????: " + result[i].question;
                                break;
                            case 53:
                                item.name = "Q" + result[i].id;
                                item.title = "????????: " + result[i].question;
                                break;
                            case 1:
                                item.name = "Q" + result[i].id;
                                item.title = "????????: " + result[i].question;
                                break;
                            case 183:
                                item.name = "Q" + result[i].id;
                                item.title = "???????????? ????????: " + result[i].question;
                                break;
                            case 659:
                                item.name = "Q" + result[i].id;
                                item.title = "????????????: " + result[i].question;
                                break;
                            default:
                                item.name = "Q" + result[i].id;
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
                                prompt: "?????? ????????",
                                click: function (form, item, icon) {
                                    item.clearValue();
                                    item.focusInItem();
                                }
                            }
                        ];
                        record["Q" + result[i].id] = result[i].answerId;
                    } else if (result[i].questionSourceId == 200) {
                        item.name = "M" + result[i].id;
                        item.title = "?????? ????????: " + result[i].question;
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
                                prompt: "?????? ????????",
                                click: function (form, item, icon) {
                                    item.clearValue();
                                    item.focusInItem();
                                }
                            }
                        ];
                        record["M" + result[i].id] = result[i].answerId;
                    } else if (result[i].questionSourceId == 201) {
                        item.name = "G" + result[i].id;
                        item.title = "??????: " + result[i].question;
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
                                prompt: "?????? ????????",
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
                DynamicForm_Questions_Body_JspEvaluation.setItems(itemList);
                DynamicForm_Description_JspEvaluation.getField("description").setValue(description);
                DynamicForm_Questions_Body_JspEvaluation.setValues(record);
                evalWait_JspQuestionEvaluation.close();
            }));
        }
    }
    //