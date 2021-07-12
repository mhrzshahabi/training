<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<%--
  ~ Author: Mehran Golrokhi
  --%>

<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>
    //----------------------------------------- Variables --------------------------------------------------------------
    var questionsSelection=false;
    //----------------------------------------- DataSources ------------------------------------------------------------
    var RestDataSource_FinalTest = isc.TrDS.create({
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

    var RestDataSource_All_FinalTest = isc.TrDS.create();

    var RestDataSource_ForThisClass_FinalTest = isc.TrDS.create({
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

    DisplayTypeDS_FinalTest = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        //autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/DisplayType"
    });

    AnswerTypeDS_FinalTest = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        //autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/AnswerType"
    });

    var RestDataSource_category_FinalTest = isc.TrDS.create({
        ID: "categoryDS",
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: categoryUrl + "spec-list",
    });

    var RestDataSourceSubCategory_FinalTest = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa"}, {name: "code"}
        ],
        fetchDataURL: subCategoryUrl + "iscList"
    });

    //----------------------------------------- ListGrids --------------------------------------------------------------
    var ListGrid_FinalTest = isc.TrLG.create({
        width: "100%",
        height: "100%",
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        dataSource: RestDataSource_FinalTest,
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
                        var activeClass = FinalTestLG_finalTest.getSelectedRecord();
                        var activeClassId = activeClass.tclass.id;
                        isc.RPCManager.sendRequest({
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            actionURL:  questionBankTestQuestionUrl + "/delete-questions/test/" + activeClassId + "/" + activeId,
                            httpMethod: "DELETE",
                            serverOutputAsString: false,
                            callback: function (resp) {
                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                    refreshLG(ListGrid_FinalTest);

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

    Lable_AllQuestions_FinalTest = isc.LgLabel.create({contents:"لیست سوالات از بانک سوال", customEdges: ["R","L","T", "B"]});
    var ListGrid_AllQuestions_FinalTestJSP = isc.TrLG.create({
        height: "45%",
        dataSource: RestDataSource_All_FinalTest,
        selectionAppearance: "checkbox",
        selectionType: "simple",
        sortField: "id",
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        filterOnKeypress: false,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        gridComponents: [Lable_AllQuestions_FinalTest, "filterEditor", "header", "body"],
        dataArrived:function(){
            let lgIds = ListGrid_ForQuestions_FinalTestJSP.data.getAllCachedRows().map(function(item) {
                console.log("injam hamintorrrrrrrrrrrrrrrr", item.questionBankId);
                return item.questionBankId;
            });

            if(lgIds.length==0){
                console.log("umadaaaaaaaaaaaaaaa");
                return;
            }

            // let findRows=ListGrid_AllQuestions_FinalTestJSP.findAll(({ id,questionBank,questionBankId }) =>  lgIds.some(p=>(!questionBank)?p==id:p==questionBankId));
            // if(findRows && findRows.length>0) {
            //     ListGrid_AllQuestions_FinalTestJSP.setSelectedState(findRows);
            //     findRows.setProperty("enabled", false);
            // }
        },
        filterEditorSubmit: function () {
            ListGrid_AllQuestions_FinalTestJSP.invalidateCache();
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
                        let selected = ListGrid_ForQuestions_FinalTestJSP.data.getAllCachedRows().map(function(item) {return item.questionBankId;});

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
                            // let findRows=ListGrid_AllQuestions_FinalTestJSP.findAll(({ id }) =>  [current.id].some(p=>p==id));

                            let classRecord = FinalTestLG_finalTest.getSelectedRecord();
                            let classId = classRecord.tclass.id;

                            let JSONObj = {"ids": ids};
                            wait.show();

                            isc.RPCManager.sendRequest({
                                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                useSimpleHttp: true,
                                contentType: "application/json; charset=utf-8",
                                actionURL: questionBankTestQuestionUrl + "/add-questions/test/" + classId + "/" + ids,
                                httpMethod: "POST",
                                data: JSON.stringify(JSONObj),
                                serverOutputAsString: false,
                                callback: function (resp) {
                                    wait.close();
                                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                        // if (findRows !== null && findRows > 0 ) {
                                        //     ListGrid_AllQuestions_FinalTestJSP.selectRecord(findRows);
                                        //     findRows.setProperty("enabled", false);
                                        // }
                                        ListGrid_AllQuestions_FinalTestJSP.redraw();

                                        ListGrid_ForQuestions_FinalTestJSP.invalidateCache();
                                        ListGrid_ForQuestions_FinalTestJSP.fetchData();
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

    Lable_ForQuestions_FinalTest = isc.LgLabel.create({contents:"لیست سوالات برای این کلاس", customEdges: ["R","L","T", "B"]});

    var ListGrid_ForQuestions_FinalTestJSP = isc.TrLG.create({
        height: "45%",
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        gridComponents: [Lable_ForQuestions_FinalTest, "filterEditor", "header", "body"],
        dataSource: RestDataSource_ForThisClass_FinalTest,
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
                ListGrid_AllQuestions_FinalTestJSP.invalidateCache();

                /*if(ListGrid_AllQuestions_FinalTestJSP.fields.some(p=>p.name=="tclass.course.titleFa")){
                    ListGrid_AllQuestions_FinalTestJSP.fetchData({
                        _constructor: "AdvancedCriteria",
                        operator: "and",
                        criteria: [{fieldName: "tclass.course.titleFa", operator: "equals", value: FinalTestLG_finalTest.getSelectedRecord().courseTitleFa}]
                    });
                }else{*/
                ListGrid_AllQuestions_FinalTestJSP.fetchData();
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
                        var activeClass = FinalTestLG_finalTest.getSelectedRecord();
                        var activeClassId = activeClass.tclass.id;
                        isc.RPCManager.sendRequest({
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            actionURL:  questionBankTestQuestionUrl + "/delete-questions/test/" + activeClassId + "/" + activeId,
                            httpMethod: "DELETE",
                            serverOutputAsString: false,
                            callback: function (resp) {
                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                                    ListGrid_ForQuestions_FinalTestJSP.invalidateCache();
                                    // let findRows=ListGrid_AllQuestions_FinalTestJSP.findAll(({ id,questionBank,questionBankId }) =>  [activeId].some(p=>(!questionBank)?p==id:p==questionBankId));
                                    //
                                    // if(findRows !== null && findRows.length>0){
                                    //     findRows.setProperty("enabled", true);
                                    //     ListGrid_AllQuestions_FinalTestJSP.deselectRecord(findRows[0]);
                                    //     ListGrid_AllQuestions_FinalTestJSP.redraw();
                                    // }
                                    ListGrid_AllQuestions_FinalTestJSP.deselectAllRecords();
                                    ListGrid_AllQuestions_FinalTestJSP.redraw();

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

    var ToolStripButton_RefreshIssuance_FinalTest = isc.ToolStripButtonRefresh.create({
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_FinalTest.invalidateCache();
        }
    });

    var ToolStripButton_InsertQuestionFromQuestionBank_FinalTest = isc.ToolStripButtonAdd.create({
        click: function () {
            let record = FinalTestLG_finalTest.getSelectedRecord();
            if (record == null || record.tclass.id == null) {
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

                RestDataSource_All_FinalTest.fields=[
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

                RestDataSource_All_FinalTest.fetchDataURL=questionBankUrl + "/spec-list";

                ListGrid_AllQuestions_FinalTestJSP.dataSource=RestDataSource_All_FinalTest;
                ListGrid_AllQuestions_FinalTestJSP.setFields([
                    {
                        name: "code",
                        title: "<spring:message code="code"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true,
                        sortNormalizer: function (record) {
                            return parseInt(record.code);
                        }
                    },
                    {
                        name: "question",
                        title: "<spring:message code="question.bank.question"/>",
                        autoFitWidth: true,
                        filterOperator: "iContains"
                    },
                    {name: "displayType.id",
                        optionDataSource: DisplayTypeDS_FinalTest,
                        title: "<spring:message code="question.bank.display.type"/>",
                        filterOperator: "equals",
                        autoFitWidth: true,
                        editorType: "SelectItem",
                        valueField: "id",
                        displayField: "title",
                        filterOnKeypress: true,
                        filterEditorProperties:{
                            optionDataSource: DisplayTypeDS_FinalTest,
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
                        },
                        sortNormalizer: function (record) {
                            return record.displayType?.title;
                        }
                    },
                    {name: "questionType.id",
                        optionDataSource: AnswerTypeDS_FinalTest,
                        title: "<spring:message code="question.bank.question.type"/>",
                        filterOperator: "equals",
                        autoFitWidth: true,
                        editorType: "SelectItem",
                        valueField: "id",
                        displayField: "title",
                        filterOnKeypress: true,
                        filterEditorProperties:{
                            optionDataSource: AnswerTypeDS_FinalTest,
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
                        },
                        sortNormalizer: function (record) {
                            return record.questionType?.title;
                        }},
                    {
                        name: "category.id",
                        optionDataSource: RestDataSource_category_FinalTest,
                        title: "<spring:message code="category"/>",
                        filterOperator: "equals",
                        autoFitWidth: true,
                        editorType: "SelectItem",
                        valueField: "id",
                        displayField: "titleFa",
                        filterOnKeypress: true,
                        filterEditorProperties:{
                            optionDataSource: RestDataSource_category_FinalTest,
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
                        },
                        sortNormalizer: function (record) {
                            return record.category?.titleFa;
                        }
                    },
                    {
                        name: "subCategory.id",
                        optionDataSource: RestDataSourceSubCategory_FinalTest,
                        title: "<spring:message code="subcategory"/>",
                        filterOperator: "equals",
                        autoFitWidth: true,
                        editorType: "SelectItem",
                        valueField: "id",
                        displayField: "titleFa",
                        filterOnKeypress: true,
                        filterEditorProperties:{
                            optionDataSource: RestDataSourceSubCategory_FinalTest,
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
                        },
                        sortNormalizer: function (record) {
                            return record.subCategory?.titleFa;
                        }
                    },
                    {
                        name: "teacher.fullNameFa",
                        title: "<spring:message code="teacher"/>",
                        canFilter:false,
                        canSort: false,
                        autoFitWidth: true
                    },
                    {
                        name: "course.titleFa",
                        title: "<spring:message code="course"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true,
                        sortNormalizer: function (record) {let tmp=record.course?.titleFa; tmp=(typeof(tmp)=="undefined")?"":tmp; return tmp; }
                    },
                    {
                        name: "tclass.course.titleFa",
                        title: "<spring:message code="class"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true,
                        sortNormalizer: function (record) {let tmp=record.tclass?.course?.titleFa; tmp=(typeof(tmp)=="undefined")?"":tmp; return tmp; }
                    },
                    {
                        name: "tclass.code",
                        title: "<spring:message code='class.code'/>",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true,
                        sortNormalizer: function (record) { return record.tclass?.code; }
                    },
                    {
                        name: "tclass.startDate",
                        title: "<spring:message code='start.date'/>",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true,
                        sortNormalizer: function (record) { return record.tclass?.startDate; }
                    },
                    {
                        name: "tclass.endDate",
                        title: "<spring:message code='end.date'/>",
                        align: "center",
                        filterOperator: "iContains",
                        autoFitWidth: true,
                        sortNormalizer: function (record) { return record.tclass?.endDate; }
                    },
                    {name: "OnAdd", title: " ",canSort:false,canFilter:false, width:30}
                ]);

                RestDataSource_ForThisClass_FinalTest.fetchDataURL = questionBankTestQuestionUrl +"/test/"+record.tclass.id+ "/spec-list";

                ListGrid_ForQuestions_FinalTestJSP.invalidateCache();
                ListGrid_ForQuestions_FinalTestJSP.fetchData();
                DynamicForm_Header_FinalTestJsp.setValue("sgTitle", getFormulaMessage(record.tclass.course.titleFa, "2", "red", "B"));
                Window_QuestionBank_FinalTest.show();
            }
        },
        title: "اضافه کردن از بانک سوال"
    });

    var ToolStripButton_InsertQuestionFromLatestQuestions_FinalTest = isc.ToolStripButtonAdd.create({
        title:  "اضافه کردن از آخرین سوالات انتخاب شده",
        click: function () {
            let record = FinalTestLG_finalTest.getSelectedRecord();
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

                RestDataSource_All_FinalTest.fields=[
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

                RestDataSource_All_FinalTest.fetchDataURL=questionBankTestQuestionUrl + "/byCourse/test/"+record.tclass.id+"/spec-list";
                ListGrid_AllQuestions_FinalTestJSP.dataSource=RestDataSource_All_FinalTest;

                ListGrid_AllQuestions_FinalTestJSP.setFields([
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
                        optionDataSource: DisplayTypeDS_FinalTest,
                        title: "<spring:message code="question.bank.display.type"/>",
                        filterOperator: "iContains", autoFitWidth: true,
                        editorType: "SelectItem",
                        valueField: "id",
                        displayField: "title",
                        filterOnKeypress: true,
                        filterEditorProperties:{
                            optionDataSource: DisplayTypeDS_FinalTest,
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
                        optionDataSource: AnswerTypeDS_FinalTest,
                        title: "<spring:message code="question.bank.question.type"/>",
                        filterOperator: "iContains", autoFitWidth: true,
                        editorType: "SelectItem",
                        valueField: "id",
                        displayField: "title",
                        filterOnKeypress: true,
                        filterEditorProperties:{
                            optionDataSource: AnswerTypeDS_FinalTest,
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


                RestDataSource_ForThisClass_FinalTest.fetchDataURL = questionBankTestQuestionUrl +"/test/"+record.tclass.id+ "/spec-list";

                //ListGrid_ForQuestions_FinalTestJSP.implicitCriteria=criteria;
                ListGrid_ForQuestions_FinalTestJSP.invalidateCache();
                ListGrid_ForQuestions_FinalTestJSP.fetchData();
                DynamicForm_Header_FinalTestJsp.setValue("sgTitle", getFormulaMessage(record.tclass.course.titleFa, "2", "red", "B"));
                Window_QuestionBank_FinalTest.show();
            }
        }
    });

   /* var ToolStripButton_PrintJasper = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "<spring:message code='print'/>",
        click: function () {
            let params = {};
            let data = ListGrid_FinalTest.getData().localData.get(0).testQuestionId;
            params.teacher = ListGrid_FinalTest.getData().localData.get(0).questionBank.teacher.fullNameFa;
            // ListGrid_FinalTest.getData().localData.forEach(function (value, index, array) {
            //     let q = {
            //         category: value.questionBank.category,
            //         subCategory: value.questionBank.subCategory,
            //         course: value.questionBank.course,
            //         displayType: value.questionBank.displayType,
            //         questionType: value.questionBank.questionType,
            //         question: value.questionBank.question,
            //         teacher: value.questionBank.teacher
            //     };
            //     data.add(q);
            // });
            console.log(params);
            print(data, params, "testForm.jasper");
        }
    });
*/

    var ToolStripButton_PrintJasper = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "چاپ سوالات آزمون نهایی",
        click: function () {
            let params = {};
            let data = ListGrid_FinalTest.getData().localData.get(0).testQuestionId;
            params.teacher = FinalTestLG_finalTest.getSelectedRecord().tclass.teacher;//ListGrid_FinalTest.getData().localData.get(0).questionBank.teacher.fullNameFa;

            print(data, params, "testForm.jasper");
        }
    });
    var ToolStripButton_Export2EXcel = isc.ToolStripButtonExcel.create({
        click: function () {
            let record = FinalTestLG_finalTest.getSelectedRecord();
            let restUrl = questionBankTestQuestionUrl +"/test/"+record.tclass.id+ "/spec-list";
            let pageName = "آزمون پایانی- لیست سوالات(کلاس با کد "+ record.tclass.code+")";
            ExportToFile.downloadExcelRestUrl(null, ListGrid_FinalTest, restUrl , 0,FinalTestLG_finalTest , '',pageName, ListGrid_FinalTest.getCriteria(), null);
        }
    });
    var ToolStrip_Actions_FinalTest = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            ToolStripButton_InsertQuestionFromQuestionBank_FinalTest,
            ToolStripButton_InsertQuestionFromLatestQuestions_FinalTest,
            ToolStripButton_PrintJasper,
            ToolStripButton_Export2EXcel,
            //ToolStripButton_PrintJasper,
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_RefreshIssuance_FinalTest
                ]
            })
        ]
    });

    //----------------------------------------- LayOut -----------------------------------------------------------------

    var DynamicForm_Header_FinalTestJsp = isc.DynamicForm.create({
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
            DynamicForm_Header_FinalTestJsp,
            ListGrid_AllQuestions_FinalTestJSP,
            isc.ToolStripButtonAdd.create({
                width:"100%",
                height:25,
                title:"اضافه کردن گروهی",
                click: function () {
                    var ids = ListGrid_AllQuestions_FinalTestJSP.getSelection().filter(function(x){return x.enabled!==false}).map(function(item) {return (!item.questionBank)?item.id:item.questionBank.id;});
                    if(ids &&ids.length>0){
                    let dialog = createDialog('ask', "<spring:message code="msg.record.adds.ask"/>");
                    dialog.addProperties({
                        buttonClick: function (button, index) {
                            this.close();
                            if (index === 0) {
                                var activeClass = FinalTestLG_finalTest.getSelectedRecord();
                                var activeClassId = activeClass.tclass.id;
                                let JSONObj = {"ids": ids};
                                wait.show();

                                isc.RPCManager.sendRequest({
                                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                    useSimpleHttp: true,
                                    contentType: "application/json; charset=utf-8",
                                    actionURL: questionBankTestQuestionUrl + "/add-questions/test/" + activeClassId + "/" + ids,
                                    httpMethod: "POST",
                                    data: JSON.stringify(JSONObj),
                                    serverOutputAsString: false,
                                    callback: function (resp) {
                                        wait.close();

                                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                            ListGrid_ForQuestions_FinalTestJSP.invalidateCache();

                                            // let findRows=ListGrid_AllQuestions_FinalTestJSP.findAll(({ id,questionBank,questionBankId }) =>  ids.some(p=>(!questionBank)?p==id:p==questionBankId));
                                            //
                                            // if(findRows && findRows.length>0){
                                            //
                                            //     findRows.setProperty("enabled", false);
                                            //     ListGrid_AllQuestions_FinalTestJSP.redraw();
                                            // }
                                            ListGrid_AllQuestions_FinalTestJSP.getSelectedRecords().setProperty("enabled", false);
                                            ListGrid_AllQuestions_FinalTestJSP.deselectAllRecords();
                                            ListGrid_AllQuestions_FinalTestJSP.redraw();
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
            ListGrid_ForQuestions_FinalTestJSP,
            isc.ToolStripButtonRemove.create({
                width:"100%",
                height:25,
                title:"حذف گروهی",
                click: function () {
                    var ids = ListGrid_ForQuestions_FinalTestJSP.getSelection().map(function(item) {return item.questionBank.id;});

                    if(ids && ids.length>0){
                    let dialog = createDialog('ask', "<spring:message code="msg.record.remove.ask"/>");
                    dialog.addProperties({
                        buttonClick: function (button, index) {
                            this.close();
                            if (index === 0) {

                                var activeClass = FinalTestLG_finalTest.getSelectedRecord();
                                var activeClassId = activeClass.tclass.id;
                                let JSONObj = {"ids": ids};
                                isc.RPCManager.sendRequest({
                                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                    useSimpleHttp: true,
                                    contentType: "application/json; charset=utf-8",
                                    actionURL: questionBankTestQuestionUrl + "/delete-questions/test/" + activeClassId + "/" + ids,
                                    httpMethod: "DELETE",
                                    data: JSON.stringify(JSONObj),
                                    serverOutputAsString: false,
                                    callback: function (resp) {
                                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                                            ListGrid_ForQuestions_FinalTestJSP.invalidateCache();
                                            // let findRows=ListGrid_AllQuestions_FinalTestJSP.findAll(({ id,questionBank,questionBankId }) =>  ids.some(p=>(!questionBank)?p==id:p==questionBankId));
                                            // if(findRows && findRows.length>0){
                                            //     findRows.setProperty("enabled", true);
                                            //     ListGrid_AllQuestions_FinalTestJSP.deselectRecord(findRows);
                                            //     ListGrid_AllQuestions_FinalTestJSP.redraw();
                                            // }
                                            ListGrid_AllQuestions_FinalTestJSP.deselectAllRecords();
                                            ListGrid_AllQuestions_FinalTestJSP.redraw();
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

    var HLayout_Actions_FinalTest = isc.HLayout.create({
        width: "100%",
        height:35,
        members: [
            ToolStrip_Actions_FinalTest
        ]
    });

    var Hlayout_Grid_FinalTest = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_FinalTest]
    });

    //----------------------------------------- DynamicForms -----------------------------------------------------------
    var Window_QuestionBank_FinalTest = isc.Window.create({
        title: "بانک سوال",
        align: "center",
        placement: "fillScreen",
        minWidth: 1024,
        closeClick: function () {
            ListGrid_FinalTest.invalidateCache();
            this.hide();
        },
        items: [
            VLayOut_PostGroup_Posts_Jsp
        ]
    });

    //----------------------------------- New Funsctions ---------------------------------------------------------------

    var VLayout_Body_FinalTest = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [HLayout_Actions_FinalTest, Hlayout_Grid_FinalTest]
    });

    /*function print(TestQuestionId, params, fileName, type = "pdf") {
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
*/

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


    function printEls(type,id,national,fileName,name,last) {
        var criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "/training/anonymous/els/printPdf/" +id+"/"+national+"/"+name+"/"+last+"/"+"exam",
            target: "_Blank",
            canSubmit: true
        });
        criteriaForm.show();
        criteriaForm.submitForm();
    }
    //</script>