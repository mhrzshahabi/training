<%@ page import="com.nicico.copper.core.SecurityUtil" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>
    var studentId_JspQuestionEvaluation;
    var localQuestions;
    /// var teacherId_JspQuestionEvaluation = ListGrid_evaluation_class.getSelectedRecord().teacherId;
    var evaluationLevelId;
    var saveMethod;
    var saveUrl = evaluationUrl;
    var valueMapAnswer = {209: "خیلی ضعیف", 208: "ضعیف", 207: "متوسط", 206: "خوب", 205: "عالی"};
    var showStudentWindow_JspQuestionEvaluation = true;
    var wait_JspQuestionEvaluation;
    var criteriaEdit_JspQuestionEvaluation = null;

    var RestData_EvaluationType_JspQuestionEvaluation = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "type", title: "<spring:message code="type"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "value", title: "<spring:message code="value"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: parameterValueUrl + "/iscList/143",
        autoFetchData: false
    });

    var RestData_StudentPresenceType_JspQuestionEvaluation = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        fetchDataURL: parameterValueUrl + "/iscList/98"
    });

    var RestData_Students_JspQuestionEvaluation = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "student.id", hidden: true},
            {name: "student.firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "student.lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "student.nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "applicantCompanyName", title: "<spring:message code="company.applicant"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "presenceTypeId", title: "<spring:message code="class.presence.type"/>", filterOperator: "equals", autoFitWidth: true},
            {name: "student.companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "student.personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "student.personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains"},
            {name: "student.postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "student.ccpArea", title: "<spring:message code="reward.cost.center.area"/>", filterOperator: "iContains"},
            {name: "student.ccpAssistant", title: "<spring:message code="reward.cost.center.assistant"/>", filterOperator: "iContains"},
            {name: "student.ccpAffairs", title: "<spring:message code="reward.cost.center.affairs"/>", filterOperator: "iContains"},
            {name: "student.ccpSection", title: "<spring:message code="reward.cost.center.section"/>", filterOperator: "iContains"},
            {name: "student.ccpUnit", title: "<spring:message code="reward.cost.center.unit"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: tclassStudentUrl + "/students-iscList/"
    });

    var RestData_EvaluationLevel_JspQuestionEvaluation = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "type", title: "<spring:message code="type"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "value", title: "<spring:message code="value"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: parameterValueUrl + "/iscList/163",
    });
    var RestDataSource_evaluation_class = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleClass"},
            {name: "code"},
            {name: "courseId"},
        ],
        fetchDataURL: classUrl + "tuple-list"
    });
    // var vm_JspQuestionEvaluation = isc.ValuesManager.create({});
    var DynamicForm_Questions_Title_JspQuestionEvaluation = isc.DynamicForm.create({
        ID: "DynamicForm_Questions_Title_JspQuestionEvaluation",
        validateOnExit: true,
        numCols: 6,
        // valuesManager: vm_JspQuestionEvaluation,
        width: "100%",
        borderRadius: "10px 10px 0px 0px",
        border: "2px solid black",
        titleAlign: "left",
        margin: 10,
        padding: 10,
        fields: [
            {
                name: "course",
                // titleColSpan: 1,
                title: "کلاس",
                textAlign: "center",
                required: true,
                type: "ComboBoxItem",
                displayField: "titleClass",
                valueField: "id",
                optionDataSource: RestDataSource_evaluation_class,
                // autoFetchData: true,
                // cachePickListResults: true,
                // useClientFiltering: true,
                filterFields: ["titleClass", "code"],
                sortField: ["titleClass"],
                sortDirection: "descending",
                // textMatchStyle: "startsWith",
                // generateExactMatchCriteria: true,
                colSpan: 2,
                // endRow:true,
                pickListFields: [
                    {
                        name: "code",
                        title: "کد کلاس",
                        filterOperator: "iContains"
                    },
                    {
                        name: "titleClass",
                        title: "نام کلاس",
                        filterOperator: "iContains"
                    },

                ],

                changed: function (form, item, value) {
                    form.getItem("evaluationType").setDisabled(false);
                    form.clearValue("evaluationLevel");
                    if (DynamicForm_Questions_Title_JspQuestionEvaluation.getItem("evaluationType").isDrawn()) {
                        DynamicForm_Questions_Title_JspQuestionEvaluation.getItem("evaluationLevel").disable();
                        form.clearValue("evaluationType");
                    } else {
                        DynamicForm_Questions_Title_JspQuestionEvaluation.getItem("evaluationLevel").enable();
                    }
                    DynamicForm_Questions_Body_JspQuestionEvaluation.clearValues();
                    DynamicForm_Questions_Body_JspQuestionEvaluation.setFields([]);
                }

            },
            {
                name: "evaluationType",
                title: "<spring:message code="evaluation.type"/>",
                type: "SelectItem",
                disabled: true,
                optionDataSource: RestData_EvaluationType_JspQuestionEvaluation,
                valueField: "code",
                displayField: "title",
                focus: function () {
                    RestData_EvaluationType_JspQuestionEvaluation.implicitCriteria = {
                        _constructor: "AdvancedCriteria",
                        operator: "and",
                        criteria: [{fieldName: "code", operator: "equals", value: "SEFC"}]
                    };
                    this.fetchData()
                },
                changed: function (form, item, value) {
                    form.getItem("evaluationLevel").setDisabled(false);
                    DynamicForm_Questions_Body_JspQuestionEvaluation.clearValues();
                    form.clearValue("evaluationLevel");
                    var criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":""}';
                    DynamicForm_Questions_Body_JspQuestionEvaluation.setFields([]);
                    // form.getItem("evaluationLevel").disable();
                    var criteriaEdit =
                        '{"fieldName":"classId","operator":"equals","value":' + form.getItem('course').getSelectedRecord().id + '},';
                    switch (value) {
                        case "SEFC":
                            // criteria= '{"fieldName":"domain.code","operator":"equals","value":"SAT"}';
                            RestData_Students_JspQuestionEvaluation.fetchDataURL = tclassStudentUrl + "/students-iscList/" + form.getItem('course').getSelectedRecord().id;
                            if (showStudentWindow_JspQuestionEvaluation)
                                Window_AddStudent_JspQuestionEvaluation.show();
                            else
                                DynamicForm_Questions_Title_JspQuestionEvaluation.getItem("evaluationLevel").enable();
                            return;
                    }
                    requestEvaluationQuestions(criteria, criteriaEdit)
                }
            },
            {
                name: "evaluationLevel",
                title: "<spring:message code="evaluation.level"/>",
                type: "SelectItem",
                optionDataSource: RestData_EvaluationLevel_JspQuestionEvaluation,
                valueField: "code",
                displayField: "title",
                disabled: true,
                endRow: true,
                changed: function (form, item, value) {
                    DynamicForm_Questions_Body_JspQuestionEvaluation.clearValues();
                    var criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":""}';
                    var criteriaEdit =
                        '{"fieldName":"classId","operator":"equals","value":' + form.getItem('course').getSelectedRecord().id + '},' +
                        '{"fieldName":"questionnaireTypeId","operator":"equals","value":139},' +
                        '{"fieldName":"evaluatorId","operator":"equals","value":' + studentId_JspQuestionEvaluation + '},' +
                        '{"fieldName":"evaluatorTypeId","operator":"equals","value":188},';
                    DynamicForm_Questions_Body_JspQuestionEvaluation.setFields([]);

                    switch (value) {
                        case "Behavioral":
                            criteriaEdit += '{"fieldName":"evaluationLevelId","operator":"equals","value":156}';
                            evaluationLevelId = 156;
                            requestEvaluationQuestions(criteria, criteriaEdit, 1);
                            break;
                        case "Results":
                            criteriaEdit += '{"fieldName":"evaluationLevelId","operator":"equals","value":157}';
                            evaluationLevelId = 157;
                            requestEvaluationQuestions(criteria, criteriaEdit, 1);
                            break;
                        case "Reactive":
                            evaluationLevelId = 154;
                            criteria = '{"fieldName":"questionnaireType.code","operator":"equals","value":"SEFC"}';
                            criteriaEdit += '{"fieldName":"evaluationLevelId","operator":"equals","value":154}';
                            requestEvaluationQuestions(criteria, criteriaEdit, 1);
                            break;
                        case "Learning":
                            evaluationLevelId = 155;
                            criteriaEdit += '{"fieldName":"evaluationLevelId","operator":"equals","value":155}';
                            requestEvaluationQuestions(criteria, criteriaEdit, 1);
                            break;
                        default:
                            break;
                    }
                }
            },

        ]
    });
    var DynamicForm_Questions_Body_JspQuestionEvaluation = isc.DynamicForm.create({
        ID: "DynamicForm_Questions_Body_JspQuestionEvaluation",
        validateOnExit: true,
        // height: "*",
        // valuesManager: vm_JspQuestionEvaluation,
        colWidths: ["45%", "50%"],
        cellBorder: 1,
        width: "100%",
        // borderRadius: "10px 0px",
        // borderBottom:"2px solid red",
        // titleAlign:"left",
        padding: 10,
        fields: []
    });

    var Window_AddStudent_JspQuestionEvaluation = isc.Window.create({
        title: "<spring:message code="students.list"/>",
        width: "50%",
        height: "50%",
        keepInParentRect: true,
        autoSize: false,
        items: [
            isc.TrHLayout.create({
                members: [
                    isc.TrLG.create({
                        ID: "ListGrid_Students_JspQuestionEvaluation",
                        dataSource: RestData_Students_JspQuestionEvaluation,
                        selectionType: "single",
                        filterOnKeypress: true,
                        autoFetchData: true,
                        fields: [
                            {name: "student.firstName", title: "<spring:message code="firstName"/>"},
                            {name: "student.lastName", title: "<spring:message code="lastName"/>"},
                            {name: "student.nationalCode", title: "<spring:message code="national.code"/>"},
                            {name: "student.personnelNo"},
                            {name: "student.personnelNo2"},
                            {name: "student.postTitle"},
                            {
                                name: "presenceTypeId",
                                type: "selectItem",
                                valueField: "id",
                                displayField: "title",
                                optionDataSource: RestData_StudentPresenceType_JspQuestionEvaluation,
                            }
                        ],
                        gridComponents: ["filterEditor", "header", "body"],
                        recordDoubleClick: function (viewer, record, recordNum, field, fieldNum, value, rawValue) {
                            studentId_JspQuestionEvaluation = record.id;
                            Window_AddStudent_JspQuestionEvaluation.close();
                            DynamicForm_Questions_Title_JspQuestionEvaluation.getItem("evaluationLevel").enable();
                        }
                    })
                ]
            })]
    });

    function qustionSourceConvert(s) {
        switch (s.charAt(0)) {
            case "G":
                return 201;
            case "M":
                return 200;
            case "Q":
                return 199;
        }
    }

    var IButton_Questions_Save = isc.IButtonSave.create({
        title:"دخیره و بستن",
        click: function () {

            if (DynamicForm_Questions_Body_JspQuestionEvaluation.getFields().length === 0)
            {
                 trainingTabSet.removeTabs(trainingTabSet.tabs);
                 return;
            }
            let evaluationAnswerList = [];
            let data = {};
            let evaluationFull = true;
            let questions = DynamicForm_Questions_Body_JspQuestionEvaluation.getFields();
            for (let i = 0; i < questions.length; i++) {
                if (DynamicForm_Questions_Body_JspQuestionEvaluation.getValue(questions[i].name) === undefined) {
                    evaluationFull = false;
                 //   createDialog("info", "به همه سوالات پاسخ داده نشده است!!");
                    trainingTabSet.removeTabs(trainingTabSet.tabs);
                    // break;

                    return;
                }

                let evaluationAnswer = {};
                evaluationAnswer.answerID = DynamicForm_Questions_Body_JspQuestionEvaluation.getValue(questions[i].name);
                evaluationAnswer.evaluationQuestionId = questions[i].name.substring(1);
                evaluationAnswer.questionSourceId = qustionSourceConvert(questions[i].name);
                evaluationAnswerList.push(evaluationAnswer);
            }

            data.evaluationAnswerList = evaluationAnswerList;
            data.evaluationFull = evaluationFull;

            switch (DynamicForm_Questions_Title_JspQuestionEvaluation.getValue("evaluationType")) {
                case "SEFT":
                    data.evaluatorId = "<%= SecurityUtil.getUserId()%>";
                    data.evaluatedId = ListGrid_evaluation_class.getSelectedRecord().teacherId;
                    data.evaluatorTypeId = 189;
                    data.evaluatedTypeId = 187;
                    data.questionnaireTypeId = 141;
                    break;
                case "TEFC":
                    data.evaluatorId = ListGrid_evaluation_class.getSelectedRecord().teacherId;
                    data.evaluatedId = null;
                    data.evaluatorTypeId = 187;
                    data.evaluatedTypeId = null;
                    data.questionnaireTypeId = 140;
                    break;
                case "SEFC":
                    data.evaluatorId = studentId_JspQuestionEvaluation;
                    data.evaluatedId = null;
                    data.evaluatorTypeId = 188;
                    data.evaluatedTypeId = null;
                    data.evaluationLevelId = evaluationLevelId;
                    data.questionnaireTypeId = 139;
                    break;
                case "OEFS":
                    data.questionnaireTypeId = 230;
                    break;
            }

            data.classId = DynamicForm_Questions_Title_JspQuestionEvaluation.getItem('course').getSelectedRecord().id;
            let wait = createDialog("wait");

            isc.RPCManager.sendRequest(TrDSRequest(saveUrl, saveMethod, JSON.stringify(data), function (resp) {
                wait.close();
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    createDialog("info", "<spring:message code="msg.operation.successful"/>");
                    trainingTabSet.removeTabs(trainingTabSet.tabs);
                }
            }))
            trainingTabSet.removeTabs(trainingTabSet.tabs);


        }

    });


    var Window_Questions_JspQuestionEvaluation = isc.Window.create({
        placement: "fillScreen",
        showCloseButton: false,
        showMaximizeButton: false,
        canDragReposition: false,
        showMinimizeButton: false,
        canDragResize: false,
        closeClick: false,
        minimize: false,
        keepInParentRect: true,
        title: "<spring:message code="record.evaluation.results"/>",
        items: [
            DynamicForm_Questions_Title_JspQuestionEvaluation,
            DynamicForm_Questions_Body_JspQuestionEvaluation,
            isc.TrHLayoutButtons.create({
                members: [
                    IButton_Questions_Save,
                    isc.IButtonCancel.create({
                        click: function () {
                            DynamicForm_Questions_Body_JspQuestionEvaluation.clearValues();
                            DynamicForm_Questions_Body_JspQuestionEvaluation.setFields([]);
                            trainingTabSet.removeTabs(trainingTabSet.tabs);

                        }
                    })
                ]
            })
        ],
        minWidth: 1024
    });
    let itemList = [];

    function requestEvaluationQuestions(criteria, criteriaEdit, type = 0) {
        wait_JspQuestionEvaluation = createDialog("wait");
        isc.RPCManager.sendRequest(TrDSRequest(questionnaireUrl + "/iscList?operator=or&_constructor=AdvancedCriteria&criteria=" + criteria, "GET", null, function (resp) {
            if (JSON.parse(resp.data).response.data.length > 0) {
                let criteria = '{"fieldName":"questionnaireId","operator":"equals","value":' + JSON.parse(resp.data).response.data[0].id + '}';
                isc.RPCManager.sendRequest(TrDSRequest(questionnaireQuestionUrl + "/iscList?operator=or&_constructor=AdvancedCriteria&criteria=" + criteria, "GET", null, function (resp) {
                    localQuestions = JSON.parse(resp.data).response.data;
                    for (let i = 0; i < localQuestions.length; i++) {
                        let item = {};
                        switch (localQuestions[i].evaluationQuestion.domain.code) {
                            case "EQP":
                                item.name = "Q" + localQuestions[i].id;
                                item.title = "امکانات: " + localQuestions[i].evaluationQuestion.question;
                                break;
                            case "CLASS":
                                item.name = "Q" + localQuestions[i].id;
                                item.title = "کلاس: " + localQuestions[i].evaluationQuestion.question;
                                break;
                            case "SAT":
                                item.name = "Q" + localQuestions[i].id;
                                item.title = "مدرس: " + localQuestions[i].evaluationQuestion.question;
                                break;
                            case "TRAINING":
                                item.name = "Q" + localQuestions[i].id;
                                item.title = "مدرس: " + localQuestions[i].evaluationQuestion.question;
                                break;
                            case "Content":
                                item.name = "Q" + localQuestions[i].id;
                                item.title = "محتواي کلاس: " + localQuestions[i].evaluationQuestion.question;
                                break;
                            default:
                                item.name = "Q" + localQuestions[i].id;
                                item.title = localQuestions[i].evaluationQuestion.question;
                        }
                        item.type = "radioGroup";
                        item.vertical = false;
                        // item.required = true;
                        item.fillHorizontalSpace = true;
                        item.valueMap = valueMapAnswer;
                        // item.colSpan = ,
                        itemList.add(item);
                    }
                    if (type !== 0) {
                        isc.RPCManager.sendRequest(TrDSRequest(courseUrl + "goal-mainObjective/" + DynamicForm_Questions_Title_JspQuestionEvaluation.getItem('course').getSelectedRecord().courseId, "GET", null, function (resp) {
                            localQuestions = JSON.parse(resp.data);
                            for (let i = 0; i < localQuestions.length; i++) {
                                let item = {};
                                switch (localQuestions[i].type) {
                                    case "goal":
                                        item.name = "G" + localQuestions[i].id;
                                        item.title = "هدف: " + localQuestions[i].title;
                                        break;
                                    case "skill":
                                        item.name = "M" + localQuestions[i].id;
                                        item.title = "هدف اصلي: " + localQuestions[i].title;
                                        break;
                                    // default:
                                    //     return;
                                }
                                item.type = "radioGroup";
                                item.vertical = false;
                                // item.required = true;
                                item.fillHorizontalSpace = true;
                                item.valueMap = valueMapAnswer;
                                // item.colSpan = ,
                                itemList.add(item);
                            }
                            DynamicForm_Questions_Body_JspQuestionEvaluation.setItems(itemList);
                            requestEvaluationQuestionsEdit(criteriaEdit);
                        }));
                    } else {
                        DynamicForm_Questions_Body_JspQuestionEvaluation.setItems(itemList);
                        requestEvaluationQuestionsEdit(criteriaEdit);
                    }
                }));
            } else {
                if (type !== 0) {
                    isc.RPCManager.sendRequest(TrDSRequest(courseUrl + "goal-mainObjective/" + DynamicForm_Questions_Title_JspQuestionEvaluation.getItem('course').getSelectedRecord().courseId, "GET", null, function (resp) {
                        localQuestions = JSON.parse(resp.data);
                        for (let i = 0; i < localQuestions.length; i++) {
                            let item = {};
                            switch (localQuestions[i].type) {
                                case "goal":
                                    item.name = "G" + localQuestions[i].id;
                                    item.title = "هدف: " + (i + 1).toString() + "- " + localQuestions[i].title;
                                    break;
                                case "skill":
                                    item.name = "M" + localQuestions[i].id;
                                    item.title = "هدف اصلي: " + (i + 1).toString() + "- " + localQuestions[i].title;
                                    break;
                                // default:
                                //     return;
                            }
                            item.type = "radioGroup";
                            item.vertical = false;
                            // item.required = true;
                            item.fillHorizontalSpace = true;
                            item.valueMap = valueMapAnswer;
                            // item.colSpan = ,
                            itemList.add(item);
                        }
                        DynamicForm_Questions_Body_JspQuestionEvaluation.setItems(itemList);
                        requestEvaluationQuestionsEdit(criteriaEdit);
                    }));
                } else {
                    DynamicForm_Questions_Body_JspQuestionEvaluation.setItems(itemList);
                    requestEvaluationQuestionsEdit(criteriaEdit);
                }
            }

        }));
    }

    function requestEvaluationQuestionsEdit(criteria) {
        criteriaEdit_JspQuestionEvaluation = criteria;
        isc.RPCManager.sendRequest(TrDSRequest(evaluationUrl + "/spec-list?operator=and&_constructor=AdvancedCriteria&criteria=" + criteria, "GET", null, function (resp) {
            wait_JspQuestionEvaluation.close();
            if (resp.httpResponseCode === 201 || resp.httpResponseCode === 200) {
                let data = JSON.parse(resp.data).response.data;
                let record = {};
                if (!data.isEmpty()) {
                    let answer = data[0].evaluationAnswerList;
                    for (let i = 0; i < answer.length; i++) {
                        switch (answer[i].questionSourceId) {
                            case 199:
                                record["Q" + answer[i].evaluationQuestionId] = answer[i].answerId;
                                break;
                            case 200:
                                record["M" + answer[i].evaluationQuestionId] = answer[i].answerId;
                                break;
                            case 201:
                                record["G" + answer[i].evaluationQuestionId] = answer[i].answerId;
                                break;
                        }
                    }
                    DynamicForm_Questions_Body_JspQuestionEvaluation.setValues(record);
                    saveMethod = "PUT";
                    saveUrl = evaluationUrl + "/" + data[0].id;
                    return;
                }
                saveMethod = "POST";
                saveUrl = evaluationUrl;
            }
        }))
    }

    function call_questionEvaluation(selectedStudent) {
        DynamicForm_Questions_Title_JspQuestionEvaluation.getField("course").sortField = ["tclass.titleClass"];
        RestDataSource_evaluation_class.fetchDataURL = studentPortalUrl + "/class-student/class-list-of-student/" + selectedStudent.nationalCode;
        DynamicForm_Questions_Title_JspQuestionEvaluation.getItem("evaluationType").setValue("SEFC");
        DynamicForm_Questions_Title_JspQuestionEvaluation.getItem("evaluationType").hide();
        showStudentWindow_JspQuestionEvaluation = false;
        studentId_JspQuestionEvaluation = selectedStudent.id;
    }

    // </script>