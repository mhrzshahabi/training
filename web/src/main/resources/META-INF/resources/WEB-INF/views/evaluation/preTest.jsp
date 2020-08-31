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
            },
        ],
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
        sortField: "id",
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

            let findRows=ListGrid_AllQuestions_PreTestJSP.findAll(({ id,questionBank,questionBankId }) =>  lgIds.some(p=>(!questionBank)?p==id:p==questionBankId));

            if(findRows && findRows.length>0){
                ListGrid_AllQuestions_PreTestJSP.setSelectedState(findRows);
                findRows.setProperty("enabled", false);
            }
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
                                        ListGrid_AllQuestions_PreTestJSP.selectRecord(findRows);
                                        findRows.setProperty("enabled", false);
                                        ListGrid_AllQuestions_PreTestJSP.redraw();

                                        ListGrid_ForQuestions_PreTestJSP.invalidateCache();
                                        ListGrid_ForQuestions_PreTestJSP.fetchData();
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

                                    let findRows=ListGrid_AllQuestions_PreTestJSP.findAll(({ id,questionBank,questionBankId }) =>  [activeId].some(p=>(!questionBank)?p==id:p==questionBankId));

                                    if(findRows && findRows.length>0){
                                        findRows.setProperty("enabled", true);
                                        ListGrid_AllQuestions_PreTestJSP.deselectRecord(findRows[0]);
                                        ListGrid_AllQuestions_PreTestJSP.redraw();
                                    }

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
                        title: "<spring:message code='start.date'/>",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "tclass.endDate",
                        title: "<spring:message code='end.date'/>",
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
                        title: "<spring:message code='start.date'/>",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "testQuestion.tclass.endDate",
                        title: "<spring:message code='end.date'/>",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true},
                    {name: "OnAdd", title: " ",canSort:false,canFilter:false, width:30}
                ]);


                RestDataSource_ForThisClass_PreTest.fetchDataURL = questionBankTestQuestionUrl +"/preTest/"+record.id+ "/spec-list";

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
        title: "چاپ سوالات پیش آزمون",
        click: function () {
            let params = {};
            let data = ListGrid_PreTest.getData().localData.get(0).testQuestionId;
            params.teacher = ListGrid_PreTest.getData().localData.get(0).questionBank.teacher.fullNameFa;

            print(data, params, "testForm.jasper");
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
                    isc.ViewLoader.create({autoDraw: true, viewURL: "registerScorePreTest/show-form", viewLoaded() {
                            eval('call_registerScorePreTest(classId_preTest,scoringMethod_preTest)');}})
                ]
            });
            Window_registerScorePreTest.show();
        }
    });

    var ToolStrip_Actions_PreTest = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            ToolStripButton_InsertQuestionFromQuestionBank_PreTest,
            ToolStripButton_InsertQuestionFromLatestQuestions_PreTest,
            ToolStripButton_PrintJasper,
            ToolStripButton_RegisterScorePreTest,
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
        align:"center",
        layoutLeftMargin: 5,
        layoutRightMargin: 5,
        members: [
            DynamicForm_Header_PreTestJsp,
            ListGrid_AllQuestions_PreTestJSP,
            isc.ToolStripButtonAdd.create({
                width:"100%",
                height:25,
                title:"اضافه کردن گروهی",
                click: function () {
                    var ids = ListGrid_AllQuestions_PreTestJSP.getSelection().filter(function(x){return x.enabled!==false}).map(function(item) {return (!item.questionBank)?item.id:item.questionBank.id;});
                    if(ids &&ids.length>0){
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

                                                let findRows=ListGrid_AllQuestions_PreTestJSP.findAll(({ id,questionBank,questionBankId }) =>  ids.some(p=>(!questionBank)?p==id:p==questionBankId));

                                                if(findRows && findRows.length>0){
                                                    findRows.setProperty("enabled", false);
                                                    ListGrid_AllQuestions_PreTestJSP.redraw();
                                                }
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
                                                let findRows=ListGrid_AllQuestions_PreTestJSP.findAll(({ id,questionBank,questionBankId }) =>  ids.some(p=>(!questionBank)?p==id:p==questionBankId));

                                                if(findRows && findRows.length>0){
                                                    findRows.setProperty("enabled", true);
                                                    ListGrid_AllQuestions_PreTestJSP.deselectRecord(findRows);
                                                    ListGrid_AllQuestions_PreTestJSP.redraw();
                                                }
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

    function print(TestQuestionId, params, fileName, type = "pdf") {
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

//</script>