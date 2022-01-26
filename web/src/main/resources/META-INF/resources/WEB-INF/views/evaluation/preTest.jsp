<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>
    //----------------------------------------- Variables --------------------------------------------------------------
    var questionsSelection=false;
    var classId_preTest;
    var scoringMethod_preTest;
    var questionData;
    let totalScore = 0;
    let sourceExamId = 0;
    let allResultScores;
    var scoreLabel = isc.Label.create({
        contents: "مجموع بارم وارد شده : ",
        border: "0px solid black",
        align: "center",
        width: "100%"
    });
    //----------------------------------------- DataSources ------------------------------------------------------------
    var RestDataSource_PreTest = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "questionBank.question",
                title: "<spring:message code='question.bank.question'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "questionBank.questionType.title",
                title: "<spring:message code='question.bank.question.type'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "questionBank.displayType.title",
                title: "<spring:message code='question.bank.display.type'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true
            }
        ]
    });

    var RestDataSource_Result_PreTest = isc.TrDS.create({
        fields: [
            {name: "surname", title: 'نام'},
            {name: "lastName", title: 'نام خانوادگی'},
            {name: "answers",title: 'asdasd', hidden: true },
            {name: "answers", hidden: true },
        ]
    });

    var RestDataSource_Questions_preTest = isc.TrDS.create({
        fields: [
            {name: "id", hidden:true },
            {name: "question", title: 'سوال'},
            {name: "type", title: 'نوع پاسخ' },
            { name: "options", title: "گزینه ها"},
            { name: "proposedPointValue", title: "<spring:message code="question.bank.proposed.point.value"/>"},
            { name: "score", title: "بارم",canEdit:true, filterOnKeypress: true,keyPressFilter: "[0-9.]",editEvent: "click"}
        ]
    });

    RestDataSource_Class_preTest = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "tclass.code",
                title: "<spring:message code="class.code"/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "tclass.course.titleFa",
                title: "<spring:message code="course"/>",
                filterOperator: "iContains"
            },
            {
                name: "tclass.startDate",
                title: "<spring:message code="class.start.date"/>",
                filterOperator: "iContains", autoFitWidth: true
            },
            {
                name: "tclass.endDate",
                title: "<spring:message code="class.end.date"/>",
                filterOperator: "iContains", autoFitWidth: true
            },
            {
                name: "tclass.teacher",
                title: "<spring:message code="teacher"/>",
                filterOperator: "iContains", autoFitWidth: true
            },
            {
                name: "date",
                title: "<spring:message code="test.question.date"/>",
                filterOperator: "iContains", autoFitWidth: true
            },
            {
                name: "time",
                title: "<spring:message code="test.question.time"/>",
                filterOperator: "iContains", autoFitWidth: true
            },
            {
                name: "duration",
                title: "<spring:message code="test.question.duration"/>",
                filterOperator: "iContains", autoFitWidth: true
            },
            { name: "onlineFinalExamStatus",
                title: "<spring:message code="test.question.status"/>",
                autoFitWidth: true
            },
            { name: "onlineExamDeadLineStatus", hidden: true}
        ],
        fetchDataURL: testQuestionUrl + "/spec-list",
        implicitCriteria: {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [{fieldName: "isPreTestQuestion", operator: "equals", value: true}]
        }
    });

    var RestDataSource_All_PreTest = isc.TrDS.create();

    var RestDataSource_ForThisClass_PreTest = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {
                name: "questionBank.question",
                title: "<spring:message code='question.bank.question'/>",
                align: "center",
                filterOperator: "iContains",
            },
            {
                name: "questionBank.questionType.title",
                title: "<spring:message code='question.bank.question.type'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {
                name: "questionBank.displayType.title",
                title: "<spring:message code='question.bank.display.type'/>",
                align: "center",
                filterOperator: "iContains",
                autoFitWidth: true
            },

        ]
    });

    DisplayTypeDS_PreTest = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        //autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/DisplayType"
    });

    AnswerTypeDS_PreTest = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        //autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/AnswerType"
    });

    var RestDataSource_category_PreTest = isc.TrDS.create({
        ID: "categoryDS",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: categoryUrl + "spec-list",
    });

    var RestDataSourceSubCategory_PreTest = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa"}, {name: "code"}
        ],
        fetchDataURL: subCategoryUrl + "iscList"
    });

    //----------------------------------------- ListGrids --------------------------------------------------------------
    var ListGrid_PreTest = isc.TrLG.create({
        width: "100%",
        height: "100%",
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        dataSource: RestDataSource_PreTest,
        selectionType: "single",
        fields: [
            {name: "id", hidden:true},
            {name: "questionBank.question"},
            {name: "questionBank.questionType.title"},
            {name: "questionBank.displayType.title"},
            {name: "OnDelete", title: " ", align: "center", width:30}
        ],
        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);

            if (fieldName === "OnDelete") {
                var recordCanvas = isc.HLayout.create({
                    height: 20,
                    width: "100%",
                    layoutMargin: 5,
                    membersMargin: 10,
                    align: "center"
                });

                var removeIcon = isc.ImgButton.create({
                    showDown: false,
                    showRollOver: false,
                    layoutAlign: "center",
                    src: "[SKIN]/actions/remove.png",
                    prompt: "حذف کردن",
                    height: 16,
                    width: 16,
                    grid: this,
                    click: function () {
                        var activeId = record.questionBank.id;
                        var activeClass = ListGrid_class_Evaluation.getSelectedRecord();
                        var activeClassId = activeClass.id;
                        isc.RPCManager.sendRequest({
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            actionURL:  questionBankTestQuestionUrl + "/delete-questions/preTest/" + activeClassId + "/" + activeId,
                            httpMethod: "DELETE",
                            serverOutputAsString: false,
                            callback: function (resp) {
                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                    refreshLG(ListGrid_PreTest);

                                } else {
                                    isc.say("خطا در پاسخ سرویس دهنده");
                                }
                            }
                        });
                    }
                });
                recordCanvas.addMember(removeIcon);
                return recordCanvas;
            } else
                return null;
        }
    });

    Lable_AllQuestions_PreTest = isc.LgLabel.create({contents:"لیست سوالات از بانک سوال", customEdges: ["R","L","T", "B"]});
    var ListGrid_AllQuestions_PreTestJSP = isc.TrLG.create({
        height: "45%",
        dataSource: RestDataSource_All_PreTest,
        selectionAppearance: "checkbox",
        selectionType: "simple",
        // sortField: "id",
        canSort:true,
        initialSort: [
            {property: "id", direction: "descending", primarySort: true}
        ],
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        gridComponents: [Lable_AllQuestions_PreTest, "filterEditor", "header", "body"],
        dataArrived:function(){

            let lgIds = ListGrid_ForQuestions_PreTestJSP.data.getAllCachedRows().map(function(item) {
                return item.questionBankId;
            });


            if(lgIds.length==0){
                return;
            }

            for(let i=0;i<lgIds.length;i++)
            {
                let row= ListGrid_AllQuestions_PreTestJSP.getData().localData.filter(p =>p.id===lgIds[i])
                row.setProperty("enabled", false);
                ListGrid_AllQuestions_PreTestJSP.redraw();
            }

            // let findRows=ListGrid_AllQuestions_PreTestJSP.findAll(({ id,questionBank,questionBankId }) =>  lgIds.some(p=>(!questionBank)?p==id:p==questionBankId));
            //
            // if(findRows && findRows.length>0){
            //     ListGrid_AllQuestions_PreTestJSP.setSelectedState(findRows);
            //     findRows.setProperty("enabled", false);
            // }
        },
        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);
            if (fieldName === "OnAdd") {
                var recordCanvas = isc.HLayout.create({
                    height: 20,
                    width: "100%",
                    layoutMargin: 5,
                    membersMargin: 10,
                    align: "center"
                });
                var addIcon = isc.ImgButton.create({
                    showDown: false,
                    showRollOver: false,
                    layoutAlign: "center",
                    src: "[SKIN]/actions/add.png",
                    prompt: "اضافه کردن",
                    height: 16,
                    width: 16,
                    grid: this,
                    click: function () {
                        let current = record;
                        let selected = ListGrid_ForQuestions_PreTestJSP.data.getAllCachedRows().map(function(item) {return item.id;});

                        let ids = [];

                        let questionBankId=0;

                        if(!current.questionBank){
                            questionBankId=current.id;
                        }else{
                            questionBankId=current.questionBank.id;
                        }

                        if ($.inArray(questionBankId, selected) === -1){
                            ids.push(questionBankId);
                        }

                        if(ids.length!==0){
                            let findRows=ListGrid_AllQuestions_PreTestJSP.findAll(({ id }) =>  [current.id].some(p=>p==id));

                            let classRecord = ListGrid_class_Evaluation.getSelectedRecord();
                            let classId = classRecord.id;

                            let JSONObj = {"ids": ids};
                            wait.show();

                            isc.RPCManager.sendRequest({
                                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                useSimpleHttp: true,
                                contentType: "application/json; charset=utf-8",
                                actionURL: questionBankTestQuestionUrl + "/add-questions/preTest/" + classId + "/" + ids,
                                httpMethod: "POST",
                                data: JSON.stringify(JSONObj),
                                serverOutputAsString: false,
                                callback: function (resp) {
                                    wait.close();
                                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                        // ListGrid_AllQuestions_PreTestJSP.selectRecord(findRows);
                                        // findRows.setProperty("enabled", false);
                                        // ListGrid_AllQuestions_PreTestJSP.redraw();
                                        //
                                        // ListGrid_ForQuestions_PreTestJSP.invalidateCache();
                                        // ListGrid_ForQuestions_PreTestJSP.fetchData();

                                        ListGrid_AllQuestions_PreTestJSP.redraw();

                                        ListGrid_AllQuestions_PreTestJSP.invalidateCache();
                                        ListGrid_AllQuestions_PreTestJSP.fetchData();
                                    } else {
                                        isc.say("خطا");
                                    }
                                }
                            });

                        }
                    }
                });
                recordCanvas.addMember(addIcon);
                return recordCanvas;
            } else
                return null;
        }
    });

    Lable_ForQuestions_PreTest = isc.LgLabel.create({contents:"لیست سوالات برای این کلاس", customEdges: ["R","L","T", "B"]});

    var ListGrid_ForQuestions_PreTestJSP = isc.TrLG.create({
        height: "45%",
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        gridComponents: [Lable_ForQuestions_PreTest, "filterEditor", "header", "body"],
        dataSource: RestDataSource_ForThisClass_PreTest,
        sortField: 0,
        selectionAppearance: "checkbox",
        selectionType: "simple",
        fields: [
            {name: "id", hidden:true},
            {name: "questionBank.question"},
            {name: "questionBank.questionType.title"},
            {name: "questionBank.displayType.title"},
            {name: "OnDelete", title: " ", align: "center", width:30}
        ],
        dataArrived:function(){

            if(questionsSelection) {
                ListGrid_AllQuestions_PreTestJSP.invalidateCache();

                /*if(ListGrid_AllQuestions_PreTestJSP.fields.some(p=>p.name=="tclass.course.titleFa")){
                    ListGrid_AllQuestions_PreTestJSP.fetchData({
                        _constructor: "AdvancedCriteria",
                        operator: "and",
                        criteria: [{fieldName: "tclass.course.titleFa", operator: "equals", value: ListGrid_class_Evaluation.getSelectedRecord().courseTitleFa}]
                    });
                }else{*/

                ListGrid_AllQuestions_PreTestJSP.fetchData();
                //}

                questionsSelection=false;
            }
        },
        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);

            if (fieldName === "OnDelete") {
                var recordCanvas = isc.HLayout.create({
                    height: 20,
                    width: "100%",
                    layoutMargin: 5,
                    membersMargin: 10,
                    align: "center"
                });

                var removeIcon = isc.ImgButton.create({
                    showDown: false,
                    showRollOver: false,
                    layoutAlign: "center",
                    src: "[SKIN]/actions/remove.png",
                    prompt: "حذف کردن",
                    height: 16,
                    width: 16,
                    grid: this,
                    click: function () {
                        var activeId = record.questionBank.id;
                        var activeClass = ListGrid_class_Evaluation.getSelectedRecord();
                        var activeClassId = activeClass.id;
                        isc.RPCManager.sendRequest({
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            actionURL:  questionBankTestQuestionUrl + "/delete-questions/preTest/" + activeClassId + "/" + activeId,
                            httpMethod: "DELETE",
                            serverOutputAsString: false,
                            callback: function (resp) {
                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                                    ListGrid_ForQuestions_PreTestJSP.invalidateCache();

                                    let row= ListGrid_AllQuestions_PreTestJSP.getData().localData.filter(p =>p.id===activeId)
                                    row.setProperty("enabled", true);
                                    ListGrid_AllQuestions_PreTestJSP.redraw();

                                    // ListGrid_ForQuestions_PreTestJSP.invalidateCache();
                                    //
                                    // let findRows=ListGrid_AllQuestions_PreTestJSP.findAll(({ id,questionBank,questionBankId }) =>  [activeId].some(p=>(!questionBank)?p==id:p==questionBankId));
                                    //
                                    // if(findRows && findRows.length>0){
                                    //     findRows.setProperty("enabled", true);
                                    //     ListGrid_AllQuestions_PreTestJSP.deselectRecord(findRows[0]);
                                    //     ListGrid_AllQuestions_PreTestJSP.redraw();
                                    // }

                                } else {
                                    isc.say("خطا در پاسخ سرویس دهنده");
                                }
                            }
                        });
                    }
                });
                recordCanvas.addMember(removeIcon);
                return recordCanvas;
            } else
                return null;
        }
    });


    //----------------------------------------- ToolStrips -------------------------------------------------------------

    var ToolStripButton_RefreshIssuance_PreTest = isc.ToolStripButtonRefresh.create({
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_PreTest.invalidateCache();
        }
    });

    var ToolStripButton_InsertQuestionFromQuestionBank_PreTest = isc.ToolStripButtonAdd.create({
        click: function () {
            let record = ListGrid_class_Evaluation.getSelectedRecord();
            if (record == null || record.id == null) {
                isc.Dialog.create({
                    message: "<spring:message code='msg.no.records.selected'/>",
                    icon: "[SKIN]ask.png",
                    title: "<spring:message code='message'/>",
                    buttons: [isc.Button.create({title: "<spring:message code='ok'/>"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });

            } else {
                questionsSelection=true;

                RestDataSource_All_PreTest.fields=[
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "code",},
                    {name: "question",},
                    {name: "questionType.title",},
                    {name: "displayType.title",},
                    {name: "category.titleFa",},
                    {name: "subCategory.titleFa",},
                    {name: "teacher.fullNameFa",},
                    {name: "tclass.course.titleFa",},
                    {name: "tclass.code",},
                    {name: "tclass.startDate",},
                    {name: "tclass.endDate",},
                    {name: "course.titleFa",}
                ];

                RestDataSource_All_PreTest.fetchDataURL=questionBankUrl + "/spec-list";

                ListGrid_AllQuestions_PreTestJSP.dataSource=RestDataSource_All_PreTest;
                ListGrid_AllQuestions_PreTestJSP.setFields([
                    {name: "id", primaryKey: true, hidden: true},
                    {
                        name: "code",
                        title: "<spring:message code="code"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "question",
                        title: "<spring:message code="question.bank.question"/>",
                        filterOperator: "iContains"
                    },
                    {name: "displayType.id",
                        optionDataSource: DisplayTypeDS_PreTest,
                        title: "<spring:message code="question.bank.display.type"/>",
                        filterOperator: "iContains", autoFitWidth: true,
                        editorType: "SelectItem",
                        valueField: "id",
                        displayField: "title",
                        filterOnKeypress: true,
                        filterEditorProperties:{
                            optionDataSource: DisplayTypeDS_PreTest,
                            valueField: "id",
                            displayField: "title",
                            autoFetchData: true,
                            filterFields: ["id","title"],
                            textMatchStyle: "substring",
                            generateExactMatchCriteria: true,
                            pickListProperties: {
                                showFilterEditor: false,
                                autoFitWidthApproach: "both"
                            },
                            pickListFields: [
                                {name: "title"}
                            ]
                        }
                    },
                    {name: "questionType.id",
                        optionDataSource: AnswerTypeDS_PreTest,
                        title: "<spring:message code="question.bank.question.type"/>",
                        filterOperator: "iContains", autoFitWidth: true,
                        editorType: "SelectItem",
                        valueField: "id",
                        displayField: "title",
                        filterOnKeypress: true,
                        filterEditorProperties:{
                            optionDataSource: AnswerTypeDS_PreTest,
                            valueField: "id",
                            displayField: "title",
                            autoFetchData: true,
                            filterFields: ["id","title"],
                            textMatchStyle: "substring",
                            generateExactMatchCriteria: true,
                            pickListProperties: {
                                showFilterEditor: false,
                                autoFitWidthApproach: "both"
                            },
                            pickListFields: [
                                {name: "title"}
                            ]
                        }},
                    {
                        name: "category.id",
                        optionDataSource: RestDataSource_category_PreTest,
                        title: "<spring:message code="category"/>",
                        filterOperator: "iContains", autoFitWidth: true,
                        editorType: "SelectItem",
                        valueField: "id",
                        displayField: "titleFa",
                        filterOnKeypress: true,
                        filterEditorProperties:{
                            optionDataSource: RestDataSource_category_PreTest,
                            valueField: "id",
                            displayField: "titleFa",
                            autoFetchData: true,
                            filterFields: ["id","titleFa"],
                            textMatchStyle: "substring",
                            generateExactMatchCriteria: true,
                            pickListProperties: {
                                showFilterEditor: false,
                                autoFitWidthApproach: "both"
                            },
                            pickListFields: [
                                {name: "titleFa"}
                            ]
                        }
                    },
                    {
                        name: "subCategory.id",
                        optionDataSource: RestDataSourceSubCategory_PreTest,
                        title: "<spring:message code="subcategory"/>",
                        filterOperator: "iContains", autoFitWidth: true,
                        editorType: "SelectItem",
                        valueField: "id",
                        displayField: "titleFa",
                        filterOnKeypress: true,
                        filterEditorProperties:{
                            optionDataSource: RestDataSourceSubCategory_PreTest,
                            valueField: "id",
                            displayField: "titleFa",
                            autoFetchData: true,
                            filterFields: ["id","titleFa"],
                            textMatchStyle: "substring",
                            generateExactMatchCriteria: true,
                            pickListProperties: {
                                showFilterEditor: false,
                                autoFitWidthApproach: "both"
                            },
                            pickListFields: [
                                {name: "titleFa"}
                            ]
                        }
                    },
                    {
                        name: "teacher.fullNameFa",
                        title: "<spring:message code="teacher"/>",
                        filterOperator: "iContains", autoFitWidth: true
                    },
                    {
                        name: "course.titleFa",
                        title: "<spring:message code="course"/>",
                        filterOperator: "iContains", autoFitWidth: true
                    },
                    {
                        name: "tclass.course.titleFa",
                        title: "<spring:message code="class"/>",
                        filterOperator: "iContains", autoFitWidth: true},
                    {
                        name: "tclass.code",
                        title: "<spring:message code='class.code'/>",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "tclass.startDate",
                        title: "<spring:message code='class.start.date'/>",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "tclass.endDate",
                        title: "<spring:message code='class.end.date'/>",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true},
                    {name: "OnAdd", title: " ",canSort:false,canFilter:false, width:30}
                ]);

                RestDataSource_ForThisClass_PreTest.fetchDataURL = questionBankTestQuestionUrl +"/preTest/"+record.id+ "/spec-list";

                ListGrid_ForQuestions_PreTestJSP.invalidateCache();
                ListGrid_ForQuestions_PreTestJSP.fetchData();
                DynamicForm_Header_PreTestJsp.setValue("sgTitle", getFormulaMessage(record.courseTitleFa, "2", "red", "B"));
                Window_QuestionBank_PreTest.show();
            }
        },
        title: "اضافه کردن از بانک سوال"
    });

    var ToolStripButton_InsertQuestionFromLatestQuestions_PreTest = isc.ToolStripButtonAdd.create({
        title:  "اضافه کردن از آخرین سوالات انتخاب شده",
        click: function () {
            let record = ListGrid_class_Evaluation.getSelectedRecord();
            if (record == null || record.id == null) {
                isc.Dialog.create({
                    message: "<spring:message code='msg.no.records.selected'/>",
                    icon: "[SKIN]ask.png",
                    title: "<spring:message code='message'/>",
                    buttons: [isc.Button.create({title: "<spring:message code='ok'/>"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });

            } else {
                questionsSelection=true;

                RestDataSource_All_PreTest.fields=[
                    {name: "id", primaryKey: true, hidden: true},
                    {name: "questionBank.code",},
                    {name: "questionBank.question",},
                    {name: "questionBank.questionType.title",},
                    {name: "questionBank.displayType.title",},
                    {name: "testQuestion.tclass.teacher.fullNameFa",},
                    {name: "testQuestion.tclass.course.titleFa",},
                    {name: "testQuestion.tclass.code",},
                    {name: "testQuestion.tclass.startDate",},
                    {name: "testQuestion.tclass.endDate",},
                    {name: "testQuestion.tclass.course.titleFa",}
                ];

                RestDataSource_All_PreTest.fetchDataURL=questionBankTestQuestionUrl + "/byCourse/preTest/"+record.id+"/spec-list";
                ListGrid_AllQuestions_PreTestJSP.dataSource=RestDataSource_All_PreTest;

                ListGrid_AllQuestions_PreTestJSP.setFields([
                    {name: "id", primaryKey: true, hidden: true},
                    {
                        name: "questionBank.code",
                        title: "<spring:message code="code"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "questionBank.question",
                        title: "<spring:message code="question.bank.question"/>",
                        filterOperator: "iContains"
                    },
                    {name: "questionBank.displayType.id",
                        optionDataSource: DisplayTypeDS_PreTest,
                        title: "<spring:message code="question.bank.display.type"/>",
                        filterOperator: "iContains", autoFitWidth: true,
                        editorType: "SelectItem",
                        valueField: "id",
                        displayField: "title",
                        filterOnKeypress: true,
                        filterEditorProperties:{
                            optionDataSource: DisplayTypeDS_PreTest,
                            valueField: "id",
                            displayField: "title",
                            autoFetchData: true,
                            filterFields: ["id","title"],
                            textMatchStyle: "substring",
                            generateExactMatchCriteria: true,
                            pickListProperties: {
                                showFilterEditor: false,
                                autoFitWidthApproach: "both"
                            },
                            pickListFields: [
                                {name: "title"}
                            ]
                        }
                    },
                    {name: "questionBank.questionType.id",
                        optionDataSource: AnswerTypeDS_PreTest,
                        title: "<spring:message code="question.bank.question.type"/>",
                        filterOperator: "iContains", autoFitWidth: true,
                        editorType: "SelectItem",
                        valueField: "id",
                        displayField: "title",
                        filterOnKeypress: true,
                        filterEditorProperties:{
                            optionDataSource: AnswerTypeDS_PreTest,
                            valueField: "id",
                            displayField: "title",
                            autoFetchData: true,
                            filterFields: ["id","title"],
                            textMatchStyle: "substring",
                            generateExactMatchCriteria: true,
                            pickListProperties: {
                                showFilterEditor: false,
                                autoFitWidthApproach: "both"
                            },
                            pickListFields: [
                                {name: "title"}
                            ]
                        }
                    },
                    {
                        name: "testQuestion.tclass.teacher",
                        title: "<spring:message code="teacher"/>",
                        filterOperator: "iContains", autoFitWidth: true
                    },
                    {
                        name: "testQuestion.tclass.course.titleFa",
                        title: "<spring:message code="class"/>",
                        filterOperator: "iContains", autoFitWidth: true},
                    {
                        name: "testQuestion.tclass.code",
                        title: "<spring:message code='class.code'/>",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "testQuestion.tclass.startDate",
                        title: "<spring:message code='class.start.date'/>",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "testQuestion.tclass.endDate",
                        title: "<spring:message code='class.end.date'/>",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {name: "OnAdd", title: " ", canSort: false, canFilter: false, width: 30}
                ]);


                RestDataSource_ForThisClass_PreTest.fetchDataURL = questionBankTestQuestionUrl + "/preTest/" + record.id + "/spec-list";

                //ListGrid_ForQuestions_PreTestJSP.implicitCriteria=criteria;
                ListGrid_ForQuestions_PreTestJSP.invalidateCache();
                ListGrid_ForQuestions_PreTestJSP.fetchData();
                DynamicForm_Header_PreTestJsp.setValue("sgTitle", getFormulaMessage(record.courseTitleFa, "2", "red", "B"));
                Window_QuestionBank_PreTest.show();
            }
        }
    });

    var ToolStripButton_PrintJasper = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "چاپ pdf سوالات پیش آزمون",
        click: function () {
            let params = {};
            let data = ListGrid_PreTest.getData().localData.get(0).testQuestionId;
            params.teacher = ListGrid_class_Evaluation.getSelectedRecord().teacherFullName;

            printPreTest(data, params, "testForm.jasper");
        }
    });
    var ToolStripButton_PrintJasperWord = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "چاپ word سوالات پیش آزمون",
        click: function () {
            let params = {};
            let data = ListGrid_PreTest.getData().localData.get(0).testQuestionId;
            params.teacher = ListGrid_class_Evaluation.getSelectedRecord().teacherFullName;

            printPreTest(data, params, "testForm.jasper","WORD");
        }
    });

    var Window_registerScorePreTest = null;

    var ToolStripButton_RegisterScorePreTest = isc.ToolStripButton.create({
        title: "ثبت نمرات پیش آزمون",
        click: function () {
            Window_registerScorePreTest = isc.Window.create({
                title: "ثبت نمرات پیش آزمون",
                placement: "fillScreen",
                items: [
                    isc.ViewLoader.create({
                        autoDraw: true, viewURL: "registerScorePreTest/show-form", viewLoaded() {
                            eval('call_registerScorePreTest(classId_preTest,scoringMethod_preTest)');
                        }
                    })
                ]
            });
            Window_registerScorePreTest.show();
        }
    });

    function loadPreExamForScores(record) {

        var ListGrid_Questions_preTest = isc.ListGrid.create({
            width: "100%",
            height: 600,
            dataSource: RestDataSource_Questions_preTest,
            showRecordComponents: true,
            showRecordComponentsByCell: true,
            fields: [
                {name: "id", hidden: true},
                {name: "question", title: 'سوال', width: "40%"},
                {name: "type", title: 'نوع پاسخ', width: "10%"},
                {name: "options", title: "گزینه ها", width: "40%", align: "center"},
                { name: "proposedPointValue",type: "float", title: "<spring:message code="question.bank.proposed.point.value"/>", width: "10%",align:"center"},
                {
                    name: "score", type: "float", title: "بارم", width: "10%", align: "center",
                    change: function (form, item, value, oldValue) {
                        setScoreValue(value, form)
                    },
                    canEdit: true, filterOnKeypress: true, keyPressFilter: "[0-9.]", editEvent: "click"
                }
            ]
        });
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(questionBankTestQuestionUrl + "/preTest/" + record.id + "/spec-list", "GET", null, function (resp) {
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                let result = JSON.parse(resp.httpResponseText).response.data;
                wait.close();
                wait.show();
                let classIdCriteria = {
                    _constructor: "AdvancedCriteria",
                    operator: "and",
                    criteria: [{fieldName: "tclassId", operator: "equals", value: record.id}]
                };
                RestDataSource_Class_preTest.fetchData(classIdCriteria, function (dsResponse, data, dsRequest) {
                    if (data && data.length > 0) {
                        if(!data[0].onlineFinalExamStatus) {
                            var examData = {
                                examItem : data[0],
                                questions: result
                            };
                            isc.RPCManager.sendRequest(TrDSRequest("/training/anonymous/els/preExamQuestions", "POST", JSON.stringify(examData), function (resp) {
                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                    let results = JSON.parse(resp.data).data;
                                    wait.close();
                                    questionData = results;
                                    ListGrid_Questions_preTest.setData(results);

                                    let Window_result_preTest = isc.Window.create({
                                        width: 1024,
                                        title: "ارسال پیش آزمون به آزمون آنلاین",
                                        items: [
                                            isc.VLayout.create({
                                                width: "100%",
                                                height: "100%",
                                                defaultLayoutAlign: "center",
                                                align: "center",
                                                members: [
                                                    isc.Label.create({
                                                        contents: "<br/> <span style='color: #000000; font-weight: bold; font-size: large'>برای ارسال پیش آزمون به سیستم آزمون آنلاین لطفا بارم هر سوال را در مقابل آن بنویسید و در نهایت دکمه ارسال آزمون را بزنید</span> <br/>",
                                                        align: "center",
                                                        height: "10%",
                                                        padding: 5,
                                                    }),
                                                    isc.VLayout.create({
                                                        width: "100%",
                                                        height: "80%",
                                                        members: [
                                                            ListGrid_Questions_preTest,
                                                            scoreLabel
                                                        ]
                                                    }),
                                                    isc.HLayout.create({
                                                        width: "100%",
                                                        height: "10%",
                                                        align: "center",
                                                        membersMargin: 10,
                                                        members: [
                                                            isc.IButtonSave.create({
                                                                layoutAlign: "center",
                                                                title: "ارسال به آزمون آنلاین",
                                                                width: "140",
                                                                click: async function () {

                                                                    questionData.map(item => {
                                                                        if(!item.score)
                                                                            item.score = '0';
                                                                        return item;
                                                                    });
                                                                    let record = data[0];
                                                                    isc.RPCManager.sendRequest(TrDSRequest("/training/anonymous/els/getClassStudent/"+record.tclass.id, "GET",null, function (resp) {
                                                                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                                                                            let result = JSON.parse(resp.httpResponseText);
                                                                            let inValidStudents = [];
                                                                            for (let i = 0; i < result.length; i++) {
                                                                                let studentData = result[i];
                                                                                if (!NCodeAndMobileValidation(studentData.nationalCode, studentData.cellNumber,studentData.gender)) {
                                                                                    inValidStudents.add({
                                                                                        firstName: studentData.surname,
                                                                                        lastName: studentData.lastName
                                                                                    });
                                                                                }
                                                                            }

                                                                            if (inValidStudents.length) {
                                                                                let DynamicForm_InValid_Students = isc.DynamicForm.create({
                                                                                    width: 600,
                                                                                    height: 100,
                                                                                    padding: 6,
                                                                                    titleAlign: "right",
                                                                                    fields: [
                                                                                        {
                                                                                            name: "text",
                                                                                            width: "100%",
                                                                                            colSpan: 2,
                                                                                            value: "<spring:message code='msg.check.student.mobile.ncode'/>"+" "+"<spring:message code='msg.check.student.mobile.ncode.message'/>",
                                                                                            showTitle: false,
                                                                                            editorType: 'staticText'
                                                                                        },
                                                                                        {
                                                                                            type: "RowSpacerItem"
                                                                                        },
                                                                                        {
                                                                                            name: "invalidNames",
                                                                                            width: "100%",
                                                                                            colSpan: 2,
                                                                                            title: "<spring:message code="title"/>",
                                                                                            showTitle: false,
                                                                                            editorType: 'textArea',
                                                                                            canEdit: false
                                                                                        }
                                                                                    ]
                                                                                });
                                                                                let names = "";
                                                                                for (var j = 0; j < inValidStudents.length; j++) {
                                                                                    names = names.concat(inValidStudents[j].firstName + " " + inValidStudents[j].lastName  + "\n");
                                                                                }
                                                                                DynamicForm_InValid_Students.setValue("invalidNames", names);

                                                                                let Window_InValid_Students = isc.Window.create({
                                                                                    width: 600,
                                                                                    height: 150,
                                                                                    numCols: 2,
                                                                                    title: "<spring:message code='invalid.students.window'/>",
                                                                                    items: [
                                                                                        DynamicForm_InValid_Students,
                                                                                        isc.MyHLayoutButtons.create({
                                                                                            members: [
                                                                                                isc.IButtonSave.create({
                                                                                                    title: "<spring:message code="continue"/>",
                                                                                                    click: function () {

                                                                                                        loadPreExamQuestions(record, questionData, Window_result_preTest);
                                                                                                        Window_InValid_Students.close();
                                                                                                    }}),
                                                                                                isc.IButtonCancel.create({
                                                                                                    title: "<spring:message code="cancel"/>",
                                                                                                    click: function () {
                                                                                                        Window_InValid_Students.close();
                                                                                                    }
                                                                                                })
                                                                                            ]
                                                                                        })
                                                                                    ]
                                                                                });
                                                                                Window_InValid_Students.show();
                                                                            } else {
                                                                                loadPreExamQuestions(record, questionData, Window_result_preTest)
                                                                            }

                                                                        }
                                                                    }));
                                                                }
                                                            }),
                                                            isc.IButtonCancel.create({
                                                                click: function () {
                                                                    Window_result_preTest.close();
                                                                }
                                                            })
                                                        ]
                                                    })
                                                ]
                                            })
                                        ]
                                    });
                                    totalScore=0;
                                    scoreLabel.setContents("مجموع بارم وارد شده :");
                                    Window_result_preTest.show();
                                } else {
                                    wait.close();
                                    let errorResponseMessage = resp.httpResponseText;
                                    var ERROR = isc.Dialog.create({
                                        message: errorResponseMessage,
                                        icon: "[SKIN]stop.png",
                                        title: "<spring:message code='message'/>"
                                    });
                                    setTimeout(function () {
                                        ERROR.close();
                                    }, 8000);
                                }
                            }));
                        } else {
                            wait.close();
                            createDialog("info", "پیش آزمون پیش تر برای آزمون آنلاین ارسال شده است", "<spring:message code="error"/>");
                        }
                    } else {
                        wait.close();
                        createDialog("info", "سوالی برای پیش آزمون انتخاب نشده است", "<spring:message code="error"/>");
                    }
                });
            } else {
                wait.close();
                createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
            }
        }));
    }

    function loadPreExamQuestions(record, questionData, dialog) {

        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(questionBankTestQuestionUrl +"/preTest/"+record.tclass.id+ "/spec-list-final-test", "GET",null, function (resp) {
            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                let result = JSON.parse(resp.httpResponseText);
                wait.close();
                var examData = {
                    examItem : record,
                    questions: result,
                    questionData: questionData
                };
                let validationData = checkPreExamValidation(examData);
                if (validationData.isValid) {
                    wait.show();
                    isc.RPCManager.sendRequest(TrDSRequest("/training/anonymous/els/examToEls/preTest", "POST", JSON.stringify(examData), function (resp) {
                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                            // ListGrid_class_Evaluation.invalidateCache();
                            var OK = isc.Dialog.create({
                                message: "<spring:message code="msg.operation.successful"/>",
                                icon: "[SKIN]say.png",
                                title: "<spring:message code='message'/>"
                            });
                            setTimeout(function () {
                                dialog.close();
                                OK.close();
                            }, 2000);
                        } else {

                            if (resp.httpResponseCode === 406)
                                createDialog("info","<spring:message code="msg.check.teacher.mobile.ncode"/>"+" "+"<spring:message code="msg.check.teacher.mobile.ncode.message"/>", "<spring:message code="error"/>");
                            else if (resp.httpResponseCode === 404)
                                createDialog("info", "<spring:message code="msg.check.users.mobile.ncode"/>", "<spring:message code="error"/>");
                            else if (resp.httpResponseCode === 500)
                                createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
                            else
                                createDialog("info",JSON.parse(resp.httpResponseText).message, "<spring:message code="error"/>");

                        }
                        wait.close();
                    }));
                } else {
                    wait.close();
                    createDialog("info", validationData.message, "<spring:message code="error"/>");
                }
            } else {
                wait.close();
                if (resp.httpResponseCode === 405)
                    createDialog("info", "<spring:message code="msg.check.class.multi.choice.question"/>", "<spring:message code="error"/>");
                else if (resp.httpResponseCode === 404)
                    createDialog("info", "<spring:message code="msg.check.class.teacher.info"/>", "<spring:message code="error"/>");
                else
                    createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>", "<spring:message code="error"/>");
            }
        }));
    }

    function checkPreExamScore(examData) {
        if (examData.examItem.tclass.scoringMethod === "3" || examData.examItem.tclass.scoringMethod === "2") {

            let totalScore = 0;
            for(var i = 0; i < examData.questionData.length; i++) {

                let score = examData.questionData[i].score;
                if (Number(score)!==0)
                    totalScore = totalScore + Number(score);
                else
                    return false;
            }
            if (examData.examItem.tclass.scoringMethod === "3") {
                return  totalScore === 20;
            } else {
                return totalScore === 100;
            }
        } else {
            return false;
        }
    }

    function checkPreExamValidation (examData) {

        let validationData = {
            isValid: true,
            message: ""
        };

        if(!examData.questions || examData.questions.length === 0) {

            validationData.isValid = false;
            validationData.message = validationData.message.concat("آزمون سوال ندارد!");
        } else if (!examData.examItem.tclass.teacherId) {

            validationData.isValid = false;
            validationData.message = validationData.message.concat("<spring:message code='msg.check.class.teacher'/>");
        } else if (!checkPreExamScore(examData)) {

            validationData.isValid = false;
            validationData.message = validationData.message.concat("بارم بندی آزمون صحیح نمی باشد");
        }
        return validationData;
    }

    function NCodeAndMobileValidation(nationalCode, mobileNum, gender) {

        let isValid = true;
        if (nationalCode===undefined || nationalCode===null || mobileNum===undefined || mobileNum===null ) {
            isValid = false;
        }
        else {
            if (nationalCode.length !== 10 || !(/^-?\d+$/.test(nationalCode)))
                isValid = false;

            if((mobileNum.length !== 10 && mobileNum.length !== 11) || !(/^-?\d+$/.test(mobileNum)))
                isValid = false;

            if(mobileNum.length === 10 && !mobileNum.startsWith("9"))
                isValid = false;

            if(mobileNum.length === 11 && !mobileNum.startsWith("09"))
                isValid = false;
        }
        return isValid;
    }

    function setScoreValue (value, form) {
        let index = questionData.findIndex(f => f.id === form.values.id);
        questionData[index].score = value;
        totalScore = 0;
        form.grid.data.forEach(q=> {
            if (q.score!== null && q.score !== undefined) {
                totalScore = totalScore + q.score;
            }
        });
        scoreLabel.setContents("مجموع بارم وارد شده : " + totalScore)
    }

    function loadPreExamResult (recordList) {

        let testQId = null;
        let ListGrid_Result_preTest = isc.TrLG.create({
            width: "100%",
            height: 700,
            canHover: true,
            dataSource: RestDataSource_Result_PreTest,
            filterOperator: "iContains",
            filterOnKeypress: false,
            allowAdvancedCriteria: true,
            allowFilterExpressions: true,
            showRecordComponents: true,
            showRecordComponentsByCell: true,
            fields: [
                {name: "cellNumber", title: 'موبایل',align: "center", width: "10%",  hidden: true},
                {name: "surname", title: 'نام',align: "center", width: "10%"},
                {name: "lastName", title: 'نام خانوادگی' ,align: "center", width: "15%"},
                {name: "score", title: 'نمره کسب شده دانشجو' ,align: "center", width: "15%"},
                {name: "testResult", title: 'نمره تستی' ,align: "center", width: "10%"},
                {name: "descriptiveResult", title: 'نمره تشریحی' ,align: "center", width: "10%",
                    change: function(form, item, value, oldValue) {
                        setDescriptiveResultValue2(value, form)
                    },canEdit:true, filterOnKeypress: true,keyPressFilter: "[0-9.]",editEvent: "click",
                },
                {name: "finalResult", title: 'نمره نهایی(با ارفاق)' ,align: "center", width: "15%",
                    change: function(form, item, value, oldValue) {
                        setFinalResultValue2(value, form)
                    },canEdit:true, filterOnKeypress: true,keyPressFilter: "[0-9.]",editEvent: "click",
                },
                {name: "resultStatus", title: 'وضعیت فراگیر' ,align: "center", width: "10%"},
                { name: "iconField", title: "نتایج", width: "10%",align:"center"},
                { name: "iconField2", title: "چاپ گزارش", width: "10%",align:"center"},


            ],
            createRecordComponent: function (record, colNum) {
                var fieldName = this.getFieldName(colNum);
                if (fieldName == "iconField") {
                    let button = isc.IButton.create({
                        layoutAlign: "center",
                        title: "پاسخ ها",
                        width: "120",
                        click: function () {
                            if  (record.resultStatus ==="بدون پاسخ") {
                                createDialog("warning", "دانشجو مورد نظر به سوالی پاسخ نداده است", "اخطار"); }
                            else
                                ListGrid_show_preTest_results(record.answers);
                        }
                    });
                    return button;
                }
                else if(fieldName == "iconField2") {
                    let button2 = isc.IButton.create({
                        layoutAlign: "center",
                        title: "چاپ گزارش",
                        width: "120",
                        click: function () {
                            if  (record.resultStatus ==="بدون پاسخ") {
                                createDialog("warning", "دانشجو مورد نظر به سوالی پاسخ نداده است", "اخطار"); }
                            else
                                printElsPreTest("pdf", testQId, record.nationalCode, "ElsExam.jasper", record.surname, record.lastName);
                        }
                    });
                    return button2;
                }
                else {
                    return null;
                }
            }
        });

        wait.show();
        let classIdCriteria = {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [{fieldName: "tclassId", operator: "equals", value: recordList.id}]
        };
        RestDataSource_Class_preTest.fetchData(classIdCriteria, function (dsResponse, data, dsRequest) {
            if (data && data.length > 0) {

                if (data[0].onlineFinalExamStatus) {

                    testQId = data[0].id;
                    isc.RPCManager.sendRequest(TrDSRequest("/training/anonymous/els/examResult/" + testQId, "GET", null, function (resp) {
                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                            let results = JSON.parse(resp.data).data;
                            allResultScores=results

                            ListGrid_Result_preTest.setData(results);
                            hideFields2(ListGrid_Result_preTest,JSON.parse(resp.data).examType)

                            let Window_result_preTest = isc.Window.create({
                                width: 1324,
                                height: 768,
                                keepInParentRect: true,
                                title: "مشاهده نتایج آزمون",
                                items: [
                                    isc.VLayout.create({
                                        width: "100%",
                                        height: "100%",
                                        defaultLayoutAlign: "center",
                                        align: "center",
                                        members: [
                                            isc.HLayout.create({
                                                width: "100%",
                                                height: "90%",
                                                members: [ListGrid_Result_preTest]
                                            }),
                                            isc.HLayout.create({
                                                width: "100%",
                                                height: "90%",
                                                align: "center",
                                                membersMargin: 10,
                                                members: [
                                                    isc.IButtonCancel.create({
                                                        click: function () {
                                                            Window_result_preTest.close();
                                                        }
                                                    }),
                                                    isc.IButtonSave.create({
                                                        title: "<spring:message code="sendScoreToOnlineExam"/>", width: 300,
                                                        click: function () {
                                                            sendFinalScoreToOnlineExam2(Window_result_preTest);
                                                        }
                                                    })
                                                    ,
                                                    isc.IButtonSave.create({
                                                        title: "<spring:message code="sendScoreToTrainingExam"/>", width: 300,
                                                        click: function () {
                                                            if (ListGrid_Result_preTest.getData().length > 0){
                                                                for (let i = 0; i < ListGrid_Result_preTest.getData().length; i++) {
                                                                    let listData=ListGrid_Result_preTest.getData().get(i);
                                                                    let testResult=    ((listData.testResult === undefined || listData.testResult === null || listData.testResult === "-") ? "0" : listData.testResult);
                                                                    let descriptiveResult=    ((listData.descriptiveResult === undefined || listData.descriptiveResult === null || listData.descriptiveResult === "-") ? "0" : listData.descriptiveResult);
                                                                    let finalScore=parseFloat(testResult)+parseFloat(descriptiveResult);

                                                                    ListGrid_Result_preTest.setEditValue(i, ListGrid_Result_preTest.getField("finalResult").masterIndex, finalScore);

                                                                }
                                                            }
                                                        }
                                                    })

                                                ]
                                            })]
                                    })
                                ]
                            });
                            Window_result_preTest.show();
                        } else {
                            var ERROR = isc.Dialog.create({
                                message: "<spring:message code='exception.un-managed'/>",
                                icon: "[SKIN]stop.png",
                                title: "<spring:message code='message'/>"
                            });
                            setTimeout(function () {
                                ERROR.close();
                            }, 3000);
                        }
                        wait.close();
                    }));
                } else {
                    wait.close();
                    createDialog("info", "پیش آزمون برای آزمون آنلاین ارسال نشده است", "<spring:message code="error"/>");
                }
            } else {
                wait.close();
                createDialog("info", "پیش آزمون برای آزمون آنلاین ارسال نشده است", "<spring:message code="error"/>");
            }
        });
    }
    function hideFields2(form,examType) {
        switch (examType) {
            case "چند گزینه ای":
                form.getField("descriptiveResult").hidden = true;
                form.getField("testResult").hidden = false;

                break;
            case "تشریحی":
                form.getField("descriptiveResult").hidden = false;
                form.getField("testResult").hidden = true;
                break;
            case "تستی-تشریحی":
                form.getField("descriptiveResult").hidden = false;
                form.getField("testResult").hidden = false;
                break;

            default:
                form.getField("descriptiveResult").hidden = false;
                form.getField("testResult").hidden = false;

        }

    }
    function sendFinalScoreToOnlineExam2(form) {
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest("/training/anonymous/els/pre/test/" +sourceExamId, "POST", JSON.stringify(allResultScores), function (resp) {
            let respText = JSON.parse(resp.httpResponseText);
            if (respText.status === 200 || respText.status === 201) {
                form.close();
                createDialog("info", "ثبت نمرات انجام شد");

            } else {
                createDialog("warning", respText.message, "اخطار");

            }
            wait.close();

        }));
    }
    function setDescriptiveResultValue2(value, form) {

        let index = allResultScores.findIndex(f => f.nationalCode === form.values.nationalCode)
        allResultScores[index].descriptiveResult = value;

    }
    function setFinalResultValue2(value, form) {
        let index = allResultScores.findIndex(f => f.nationalCode === form.values.nationalCode)
        allResultScores[index].finalResult = value;
    }
    function ListGrid_show_preTest_results(answers) {

        let dynamicForm_Answers_List = isc.DynamicForm.create({
            padding: 6,
            numCols: 1,
            values: {},
            styleName: "answers-form",
            height:768,
            fields: []
        });
        for(var i=0 ; i<answers.length; i++) {
            let text_FormItem = { title:"Pasted value",cellStyle: 'text-exam-form-item',disabled:false, titleOrientation: "top", name:"textArea", width:"100%",height:100, editorType: "TextAreaItem", value: ''};
            // let text_FormItem = { title:"Pasted value",disabled:false,canEdit: false, titleOrientation: "top", name:"textArea", width:"100%",height:100, editorType: "TextAreaItem", value: ''};
            let radio_FormItem =  { name: "startMode", cellStyle: 'radio-exam-form-item', disabled:true,titleOrientation: "top", title: "Initially show ColorPicker as",
                width: "100%",
                type: "radioGroup",
                valueMap: {}
            };

            let correctAnswer="<span class=\"correctAnswer\"></span>";
            if (answers[i].examinerAnswer!==null && answers[i].examinerAnswer!==undefined)
                correctAnswer = "<div class=\"correctAnswer\" ><span>"+customSplit2(answers[i].examinerAnswer,150)+"</span></div>";
            else
                correctAnswer = "<span class=\"correctAnswer\">جوابی برای این سوال توسط استاد ثبت نشده</span>";

            let mark="<span class=\"mark\"></span>";
            if (answers[i].mark!==null && answers[i].mark!==undefined)
                mark = "<div class=\"mark\" ><span>"+" ( "+answers[i].mark +" نمره ) "+"</span></div>";
            else
                mark = "<span class=\"mark\">( بارم ثبت نشده )</span>";



            let files="<span class=\"files\"></span>";
            let answerFiles="<span class=\"files\"></span>";
            let option1Files="<span class=\"files\"></span>";
            let option2Files="<span class=\"files\"></span>";
            let option3Files="<span class=\"files\"></span>";
            let option4Files="<span class=\"files\"></span>";
            let token="<%=accessToken%>";

            if (answers[i].answerFiles!==null && answers[i].answerFiles!==undefined)
            {
                let answerFilesData=" ";

                for(let key in answers[i].answerFiles)
                {
                    answerFilesData+=" "
                    answerFilesData+="<a href=\""+downloadFiles+answers[i].answerFiles[key] + "/"+ key + "/"+ token + "/\" target=\"_blank\"> فایل جواب - </a>"
                }
                answerFiles=answerFilesData;
            }
            if (answers[i].files!==null && answers[i].files!==undefined)
            {
                let filesData=" ";

                for(let key in answers[i].files)
                {
                    filesData+=" "
                    filesData+="<a href=\""+downloadFiles+answers[i].files[key] + "/"+ key + "/"+ token + "/\" target=\"_blank\"> فایل سوال - </a>"
                }
                files=filesData;
            }


            // show option1
            if (answers[i].option1Files!==null && answers[i].option1Files!==undefined)
            {
                let option1FilesData=" ";

                for(let key in answers[i].option1Files)
                {
                    option1FilesData+=" "
                    option1FilesData+="<a href=\""+downloadFiles+answers[i].option1Files[key] + "/"+ key + "/"+ token + "/\" target=\"_blank\"> فایل گزینه اول - </a>"
                }
                option1Files=option1FilesData;
            }

            ///            // show option2


            if (answers[i].option2Files!==null && answers[i].option2Files!==undefined)
            {
                let option2FilesData=" ";

                for(let key in answers[i].option2Files)
                {
                    option2FilesData+=" "
                    option2FilesData+="<a href=\""+downloadFiles+answers[i].option2Files[key] + "/"+ key + "/"+ token + "/\" target=\"_blank\"> فایل گزینه دوم - </a>"
                }
                option2Files=option2FilesData;
            }

            ///            // show option3


            if (answers[i].option3Files!==null && answers[i].option3Files!==undefined)
            {
                let option3FilesData=" ";

                for(let key in answers[i].option3Files)
                {
                    option3FilesData+=" "
                    option3FilesData+="<a href=\""+downloadFiles+answers[i].option3Files[key] + "/"+ key + "/"+ token + "/\" target=\"_blank\"> فایل گزینه سوم - </a>"
                }
                option3Files=option3FilesData;
            }

            ///            // show option4


            if (answers[i].option4Files!==null && answers[i].option4Files!==undefined)
            {
                let option4FilesData=" ";

                for(let key in answers[i].option4Files)
                {
                    option4FilesData+=" "
                    option4FilesData+="<a href=\""+downloadFiles+answers[i].option4Files[key] + "/"+ key + "/"+ token + "/\" target=\"_blank\"> فایل گزینه چهارم - </a>"
                }
                option4Files=option4FilesData;
            }


            text_FormItem.title = (i+1)+"-"+ customSplit2(answers[i].question, 150)  +"   "+mark+" "+files+ "\n\n"+answerFiles+ "\n\n"+
                " جواب استاد :"+ "\n"+ "  "+correctAnswer+ "\n";

            // correct_FormItem.title = "بارم این سوال : "+answers[i].mark + "  و جواب صحیح طراح سوال:  ";
            text_FormItem.value = answers[i].answer;
            text_FormItem.name = answers[i].answer;

            if(answers[i].type === "چند گزینه ای") {
                radio_FormItem.title = (i+1)+"-"+customSplit2(answers[i].question, 150)+"   "+mark+" "+files+ "\n\n"+answerFiles+ "\n\n"+option1Files+ "\n"+option2Files+ "\n"+option3Files+ "\n"+option4Files+
                    " جواب استاد :"+  "\n"+ "  "+correctAnswer;
                radio_FormItem.name = i+"";
                if(answers[i].options.length > 0) {
                    for(let j = 0; j< answers[i].options.length; j++){
                        let key = answers[i].options[j].title;
                        let value = answers[i].options[j].title;
                        radio_FormItem.valueMap[key] = value;
                    }
                }

                dynamicForm_Answers_List.addField(radio_FormItem)
                if(radio_FormItem.valueMap.hasOwnProperty(answers[i].answer)) {
                    dynamicForm_Answers_List.getField(i).setValue(answers[i].answer);
                }
            } else {
                dynamicForm_Answers_List.addField(text_FormItem)
            }
            // text_FormItem.title = (i+1)+"-"+answers[i].question;
            // text_FormItem.value = answers[i].answer;
            // text_FormItem.name = answers[i].answer;
            // if(answers[i].type == "چند گزینه ای") {
            //     radio_FormItem.title = answers[i].question;
            //     radio_FormItem.name = i+"";
            //     if(answers[i].options.length > 0) {
            //         for(let j = 0; j< answers[i].options.length; j++){
            //             let key = answers[i].options[j].title;
            //             let value = answers[i].options[j].title;
            //             radio_FormItem.valueMap[key] = value;
            //         }
            //     }
            //
            //     dynamicForm_Answers_List.addField(radio_FormItem)
            //     if(radio_FormItem.valueMap.hasOwnProperty(answers[i].answer)) {
            //         dynamicForm_Answers_List.getField(i).setValue(answers[i].answer);
            //     }
            // } else {
            //     dynamicForm_Answers_List.addField(text_FormItem)
            // }
        }
        let Window_result_Answer_preTest = isc.Window.create({
            width: 1024,
            height: 768,
            keepInParentRect: true,
            title: "مشاهده پاسخ ها",
            autoSize: false,
            isModal: true,
            autoDraw: true,
            overflow: "auto",
            items: [
                isc.VLayout.create({
                    width: "100%",
                    height: "100%",
                    defaultLayoutAlign: "center",
                    align: "center",
                    members: [
                        isc.HLayout.create({
                            width: "100%",
                            height: "100%",
                            overflow: "auto",
                            styleName: "hLayout-scrollable",
                            autoDraw: false,
                            members: [
                                dynamicForm_Answers_List
                            ]
                        }),
                        isc.IButtonCancel.create({
                            click: function () {
                                Window_result_Answer_preTest.close();
                            }
                        })
                    ]
                })
            ]
        });
        Window_result_Answer_preTest.show();
    }

    function printElsPreTest(type, id, national, fileName, name, last) {

        var criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "/training/anonymous/els/printPdf/" +id+"/"+national+"/"+name+"/"+last+"/"+"exam",
            target: "_Blank",
            canSubmit: true
        });
        criteriaForm.show();
        criteriaForm.submitForm();
    }

    function showPreTestInvalidUsers (record) {

        isc.RPCManager.sendRequest(TrDSRequest("/training/anonymous/els/getClassStudent/"+record.id, "GET",null, function (resp) {

            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                let result = JSON.parse(resp.httpResponseText);
                let inValidStudents = [];

                for (let i = 0; i < result.length; i++) {
                    let studentData = result[i];
                    if (!NCodeAndMobileValidation(studentData.nationalCode, studentData.cellNumber,studentData.gender)) {
                        inValidStudents.add({
                            firstName: studentData.surname,
                            lastName: studentData.lastName
                        });
                    }
                }

                if (inValidStudents.length) {
                    let DynamicForm_InValid_Students = isc.DynamicForm.create({
                        width: 600,
                        height: 100,
                        padding: 6,
                        titleAlign: "right",
                        fields: [
                            {
                                name: "text",
                                width: "100%",
                                colSpan: 2,
                                value: "<spring:message code='msg.check.student.mobile.ncode'/>"+" "+"<spring:message code='msg.check.student.mobile.ncode.message'/>",
                                showTitle: false,
                                editorType: 'staticText'
                            },
                            {
                                type: "RowSpacerItem"
                            },
                            {
                                name: "invalidNames",
                                width: "100%",
                                colSpan: 2,
                                title: "<spring:message code="title"/>",
                                showTitle: false,
                                editorType: 'textArea',
                                canEdit: false
                            }
                        ]
                    });

                    let names = "";
                    for (var j = 0; j < inValidStudents.length; j++) {

                        names = names.concat(inValidStudents[j].firstName + " " + inValidStudents[j].lastName  + "\n");
                    }
                    DynamicForm_InValid_Students.setValue("invalidNames", names);

                    let Window_InValid_Students = isc.Window.create({
                        width: 600,
                        height: 150,
                        numCols: 2,
                        title: "<spring:message code='invalid.students.window'/>",
                        items: [
                            DynamicForm_InValid_Students,
                            isc.MyHLayoutButtons.create({
                                members: [
                                    isc.IButtonCancel.create({
                                        title: "<spring:message code="cancel"/>",
                                        click: function () {
                                            Window_InValid_Students.close();
                                        }
                                    })]
                            })]
                    });
                    Window_InValid_Students.show();
                } else {
                    createDialog("info", "در این کلاس فراگیر با اطلاعات ناقص وجود ندارد");
                }
            } }));
    }

    var ToolStrip_Actions_PreTest = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            ToolStripButton_InsertQuestionFromQuestionBank_PreTest,
            ToolStripButton_InsertQuestionFromLatestQuestions_PreTest,
            ToolStripButton_PrintJasper,
            ToolStripButton_RegisterScorePreTest,
            ToolStripButton_PrintJasperWord,
            isc.IButton.create({
                // disabled: ListGrid_class_Evaluation.getSelectedRecord().onlineFinalExamStatus,
                title: "بارم بندی و ارسال پیش آزمون",
                width: "170",
                height: "30",
                margin: 3,
                click: function () {
                    loadPreExamForScores(ListGrid_class_Evaluation.getSelectedRecord());
                }
            }),
            isc.IButton.create({
                // disabled: !ListGrid_class_Evaluation.getSelectedRecord().onlineFinalExamStatus,
                title: "نمایش نتایج ",
                width: "170",
                height: "30",
                margin: 3,
                click: function () {
                    sourceExamId=ListGrid_class_Evaluation.getSelectedRecord().id
                    loadPreExamResult(ListGrid_class_Evaluation.getSelectedRecord());
                }
            }),
            isc.IButton.create({
                title: "فراگیران با اطلاعات ناقص",
                width: "170",
                height: "30",
                margin: 3,
                click: function () {
                    showPreTestInvalidUsers(ListGrid_class_Evaluation.getSelectedRecord());
                }
            }),

            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_RefreshIssuance_PreTest
                ]
            })
        ]
    });

    //----------------------------------------- LayOut -----------------------------------------------------------------

    var DynamicForm_Header_PreTestJsp = isc.DynamicForm.create({
        height: "5%",
        align: "center",
        fields: [{name: "sgTitle", type: "staticText", title: "افزودن سوال به کلاس ", wrapTitle: false}]
    });

    var VLayOut_PostGroup_Posts_Jsp = isc.VLayout.create({
        width: "100%",
        height: "100%",
        border: "3px solid gray",
        align: "center",
        layoutLeftMargin: 5,
        layoutRightMargin: 5,
        members: [
            DynamicForm_Header_PreTestJsp,
            ListGrid_AllQuestions_PreTestJSP,
            isc.ToolStripButtonAdd.create({
                width: "100%",
                height: 25,
                title: "اضافه کردن گروهی",
                click: function () {
                    var ids = ListGrid_AllQuestions_PreTestJSP.getSelection().filter(function (x) {
                        return x.enabled !== false
                    }).map(function (item) {
                        return (!item.questionBank) ? item.id : item.questionBank.id;
                    });
                    if (ids && ids.length > 0) {
                        let dialog = createDialog('ask', "<spring:message code="msg.record.adds.ask"/>");
                        dialog.addProperties({
                            buttonClick: function (button, index) {
                                this.close();
                                if (index === 0) {
                                    var activeClass = ListGrid_class_Evaluation.getSelectedRecord();
                                    var activeClassId = activeClass.id;
                                    let JSONObj = {"ids": ids};
                                    wait.show();

                                    isc.RPCManager.sendRequest({
                                        httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                        useSimpleHttp: true,
                                        contentType: "application/json; charset=utf-8",
                                        actionURL: questionBankTestQuestionUrl + "/add-questions/preTest/" + activeClassId + "/" + ids,
                                        httpMethod: "POST",
                                        data: JSON.stringify(JSONObj),
                                        serverOutputAsString: false,
                                        callback: function (resp) {
                                            wait.close();

                                            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                                                ListGrid_ForQuestions_PreTestJSP.invalidateCache();

                                                // let findRows=ListGrid_AllQuestions_FinalTestJSP.findAll(({ id,questionBank,questionBankId }) =>  ids.some(p=>(!questionBank)?p==id:p==questionBankId));
                                                //
                                                // if(findRows && findRows.length>0){
                                                //
                                                //     findRows.setProperty("enabled", false);
                                                //     ListGrid_AllQuestions_FinalTestJSP.redraw();
                                                // }
                                                ListGrid_AllQuestions_PreTestJSP.getSelectedRecords().setProperty("enabled", false);
                                                ListGrid_AllQuestions_PreTestJSP.deselectAllRecords();
                                                ListGrid_AllQuestions_PreTestJSP.redraw();

                                                // ListGrid_ForQuestions_PreTestJSP.invalidateCache();
                                                //
                                                // let findRows=ListGrid_AllQuestions_PreTestJSP.findAll(({ id,questionBank,questionBankId }) =>  ids.some(p=>(!questionBank)?p==id:p==questionBankId));
                                                //
                                                // if(findRows && findRows.length>0){
                                                //     findRows.setProperty("enabled", false);
                                                //     ListGrid_AllQuestions_PreTestJSP.redraw();
                                                // }
                                                isc.say("عملیات با موفقیت انجام شد.");

                                            } else {
                                                isc.say("خطا در پاسخ سرویس دهنده");
                                            }
                                        }
                                    });
                                }
                            }
                        })
                    }else{
                        isc.say("سوالي انتخاب نشده است.");
                    }
                }
            }),
            isc.LayoutSpacer.create({ID: "spacer", height: "5%"}),
            ListGrid_ForQuestions_PreTestJSP,
            isc.ToolStripButtonRemove.create({
                width:"100%",
                height:25,
                title:"حذف گروهی",
                click: function () {
                    var ids = ListGrid_ForQuestions_PreTestJSP.getSelection().map(function(item) {return item.questionBank.id;});

                    if(ids && ids.length>0){
                        let dialog = createDialog('ask', "<spring:message code="msg.record.remove.ask"/>");
                        dialog.addProperties({
                            buttonClick: function (button, index) {
                                this.close();
                                if (index === 0) {

                                    var activeClass = ListGrid_class_Evaluation.getSelectedRecord();
                                    var activeClassId = activeClass.id;
                                    let JSONObj = {"ids": ids};


                                    isc.RPCManager.sendRequest({
                                        httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                        useSimpleHttp: true,
                                        contentType: "application/json; charset=utf-8",
                                        actionURL: questionBankTestQuestionUrl + "/delete-questions/preTest/" + activeClassId + "/" + ids,
                                        httpMethod: "DELETE",
                                        data: JSON.stringify(JSONObj),
                                        serverOutputAsString: false,
                                        callback: function (resp) {
                                            if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {


                                                ListGrid_ForQuestions_PreTestJSP.invalidateCache();
                                                for(let i=0;i<ids.length;i++)
                                                {
                                                    let row= ListGrid_AllQuestions_PreTestJSP.getData().localData.filter(p =>p.id===ids[i])
                                                    row.setProperty("enabled", true);
                                                    ListGrid_AllQuestions_PreTestJSP.redraw();
                                                }



                                                // ListGrid_ForQuestions_PreTestJSP.invalidateCache();
                                                // let findRows=ListGrid_AllQuestions_PreTestJSP.findAll(({ id,questionBank,questionBankId }) =>  ids.some(p=>(!questionBank)?p==id:p==questionBankId));
                                                //
                                                // if(findRows && findRows.length>0){
                                                //     findRows.setProperty("enabled", true);
                                                //     ListGrid_AllQuestions_PreTestJSP.deselectRecord(findRows);
                                                //     ListGrid_AllQuestions_PreTestJSP.redraw();
                                                // }
                                                isc.say("عملیات با موفقیت انجام شد.");
                                            } else {
                                                isc.say("خطا در پاسخ سرویس دهنده");
                                            }
                                        }
                                    });
                                }
                            }
                        })

                    }else{
                        isc.say("سوالي انتخاب نشده است.");
                    }
                }
            })
        ]
    });

    var HLayout_Actions_PreTest = isc.HLayout.create({
        width: "100%",
        height:35,
        members: [
            ToolStrip_Actions_PreTest
        ]
    });

    var Hlayout_Grid_PreTest = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_PreTest]
    });

    //----------------------------------------- DynamicForms -----------------------------------------------------------
    var Window_QuestionBank_PreTest = isc.Window.create({
        title: "بانک سوال",
        align: "center",
        placement: "fillScreen",
        minWidth: 1024,
        closeClick: function () {
            ListGrid_PreTest.invalidateCache();
            this.hide();
        },
        items: [
            VLayOut_PostGroup_Posts_Jsp
        ]
    });

    //----------------------------------- New Funsctions ---------------------------------------------------------------

    var VLayout_Body_PreTest = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [HLayout_Actions_PreTest, Hlayout_Grid_PreTest]
    });

    function printPreTest(TestQuestionId, params, fileName, type = "pdf") {
        var criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="test-question-form/print/"/>" + type,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "fileName", type: "hidden"},
                    {name: "TestQuestionId", type: "hidden"},
                    {name: "params", type: "hidden"}
                ]
        });
        criteriaForm.setValue("TestQuestionId", TestQuestionId);
        criteriaForm.setValue("fileName", fileName);
        criteriaForm.setValue("params", JSON.stringify(params));
        criteriaForm.show();
        criteriaForm.submitForm();
    }
    function customSplit2(str, maxLength){
        if(str.length <= maxLength)
            return str;
        var reg = new RegExp(".{1," + maxLength + "}","g");
        var parts = str.match(reg);
        return parts.join('\n');
    }
    //</script>