<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>

    let questionnaireMethod_questionnaire;
    let questionnaireQuestionMethod_questionnaire;
    let waitQuestionnaire;
    var isDelete_questionnaire=false;
    let selectedRecord;

    // ------------------------------------------- Menu -------------------------------------------
    isc.Menu.create({
        ID: "QuestionnaireMenu_questionnaire",
        data: [
            <sec:authorize access="hasAuthority('Questionnaire_R')">
            {title: "<spring:message code="refresh"/>", click: function () { refreshLG(QuestionnaireLG_questionnaire, cleanLG(QuestionnaireQuestionLG_questionnaire)); }},
            </sec:authorize>

            <sec:authorize access="hasAuthority('Questionnaire_C')">
            {title: "<spring:message code="create"/>", click: function () { createQuestionnaire_questionnaire(); }},
            </sec:authorize>

            <sec:authorize access="hasAuthority('Questionnaire_U')">
            {title: "<spring:message code="edit"/>", click: function () { editQuestionnaire_questionnaire(); }},
            </sec:authorize>

            <sec:authorize access="hasAuthority('Questionnaire_D')">
            {title: "<spring:message code="remove"/>", click: function () { removeQuestionnaire_questionnaire(); }},
            </sec:authorize>
        ]
    });

    isc.Menu.create({
        ID: "QuestionnaireQuestionMenu_questionnaire",
        data: [
            <sec:authorize access="hasAuthority('QuestionnaireQuestion_R')">
            {title: "<spring:message code="refresh"/>", click: function () { refreshQuestionnaireQuestionLG_questionnaire(); }},
            </sec:authorize>

            <sec:authorize access="hasAuthority('QuestionnaireQuestion_C')">
            {title: "<spring:message code="create"/>", click: function () { createQuestionnaireQuestion_questionnaire(); }},
            </sec:authorize>

            <sec:authorize access="hasAuthority('QuestionnaireQuestion_U')">
            {title: "<spring:message code="edit"/>", click: function () { editQuestionnaireQuestion_questionnaire(); }},
            </sec:authorize>

            <sec:authorize access="hasAuthority('QuestionnaireQuestion_D')">
            {title: "<spring:message code="remove"/>", click: function () { removeQuestionnaireQuestion_questionnaire(); }},
            </sec:authorize>
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    var Button2 = isc.IButton.create({
        title: "فعال/غیرفعال کردن پرسشنامه",
        width: "200",
        click: function () {

            let record = QuestionnaireLG_questionnaire.getSelectedRecord();
            if (record == null)
            {
               createDialog("info",'<spring:message code="global.grid.record.not.selected"/>' );

            }
            else {

                let questionnaireSaveUrl = questionnaireUrl;
                waitQuestionnaire = createDialog("wait");
                //
                // isc.RPCManager.sendRequest(TrDSRequest(questionnaireUrl +
                //     "/isLocked/" +
                //     record.id,
                //     "GET",
                //     null,
                //     function(resp){
                //         if(resp.data=="true"){
                //             createDialog("info", "پرسشنامه مورد نظر در ارزیابی استفاده شده است. بنابراین قابل تغییر نیست.");
                //             waitQuestionnaire.close();
                //
                //             return ;
                //         }

                        isc.RPCManager.sendRequest( TrDSRequest(questionnaireSaveUrl+"/enable/"+record.id ,"PUT",null, "callback: EnabledResponse(rpcResponse)"));

                        //isc.RPCManager.sendRequest( TrDSRequest(questionnaireSaveUrl +"/list","GET",null, "callback: ListResponse(rpcResponse,'"+JSON.stringify(record)+"')"));

                //     })
                // );
            }

        }

    });
    isc.ToolStrip.create({
        ID: "QuestionnaireTS_questionnaire",
        members: [
            <sec:authorize access="hasAuthority('Questionnaire_R')">
            isc.ToolStripButtonRefresh.create({click: function () { refreshLG(QuestionnaireLG_questionnaire, cleanLG(QuestionnaireQuestionLG_questionnaire)); }}),
            </sec:authorize>

            <sec:authorize access="hasAuthority('Questionnaire_C')">
            isc.ToolStripButtonCreate.create({click: function () { createQuestionnaire_questionnaire(); }}),
            </sec:authorize>

            <sec:authorize access="hasAuthority('Questionnaire_U')">
            isc.ToolStripButtonEdit.create({click: function () { editQuestionnaire_questionnaire(); }}),
            </sec:authorize>

            <sec:authorize access="hasAuthority('Questionnaire_D')">
            isc.ToolStripButtonRemove.create({click: function () { removeQuestionnaire_questionnaire(); }}),
            </sec:authorize>

            <sec:authorize access="hasAuthority('Questionnaire_C')">
            Button2,
            </sec:authorize>

            <sec:authorize access="hasAuthority('Questionnaire_P')">
            isc.ToolStripButtonExcel.create({
                click: function () {
                    if (QuestionnaireLG_questionnaire.data.size()<1)
                        return;

                    ExportToFile.downloadExcelRestUrl(null, QuestionnaireLG_questionnaire, questionnaireUrl + "/iscList", 0, null, '', "ارزیابی - پرسشنامه", QuestionnaireLG_questionnaire.getCriteria(), null);
                }
            }),
            </sec:authorize>

            isc.LayoutSpacer.create({width: "*"}),
            <sec:authorize access="hasAuthority('Questionnaire_R')">
            isc.Label.create({ID: "QuestionnaireLGCountLabel_questionnaire"}),
            </sec:authorize>
        ]
    });

    isc.ToolStrip.create({
        ID: "QuestionnaireQuestionTS_questionnaire",
        members: [
            <sec:authorize access="hasAuthority('QuestionnaireQuestion_R')">
            isc.ToolStripButtonRefresh.create({click: function () { refreshQuestionnaireQuestionLG_questionnaire(); }}),
            </sec:authorize>

            <sec:authorize access="hasAuthority('QuestionnaireQuestion_C')">
            isc.ToolStripButtonAdd.create({click: function () { createQuestionnaireQuestion_questionnaire(); }}),
            </sec:authorize>

            <sec:authorize access="hasAuthority('QuestionnaireQuestion_U')">
            isc.ToolStripButtonEdit.create({click: function () { editQuestionnaireQuestion_questionnaire(); }}),
            </sec:authorize>

            <sec:authorize access="hasAuthority('QuestionnaireQuestion_D')">
            isc.ToolStripButtonRemove.create({click: function () {removeQuestionnaireQuestion_questionnaire(); }}),
            </sec:authorize>

            <sec:authorize access="hasAuthority('QuestionnaireQuestion_P')">
            isc.ToolStripButtonExcel.create({
                click: function () {
                    if (QuestionnaireQuestionLG_questionnaire.data.size()<1)
                        return;

                    ExportToFile.downloadExcelRestUrl(null, QuestionnaireQuestionLG_questionnaire, questionnaireQuestionUrl + "/iscList/" + selectedRecord, 0, null, '', "ارزیابی - پرسشنامه - سوالات", QuestionnaireLG_questionnaire.getCriteria(), null);
                }
            }),
            </sec:authorize>

            isc.LayoutSpacer.create({width: "*"}),

            <sec:authorize access="hasAuthority('QuestionnaireQuestion_R')">
            isc.Label.create({ID: "QuestionnaireQuestionLGCount_questionnaire"}),
            </sec:authorize>
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------
    QuestionnaireDS_questionnaire = isc.TrDS.create({
        ID: "QuestionnaireDS_questionnaire",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name:"questionnaireTypeId",hidden:true},
            {name:"questionnaireType.title",title:"<spring:message code="type"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: questionnaireUrl + "/iscList",
    });

    QuestionnaireTypeDS_Questionnaire=isc.TrDS.create({
    ID:"QuestionnaireTypeDS_Questionnaire",
    fields:[
        {name:"id",primaryKey:true,hidden:true},
        {name:"title",title:"<spring:message code="title"/>",required:true,filterOperator:"iContains",autoFitWidth: true}
    ],
        cacheAllData: true,
        fetchDataURL: parameterValueUrl + "/iscList/143",
        // implicitCriteria: {
        //     _constructor:"AdvancedCriteria",
        //     operator:"and",
        //     criteria:[{ fieldName: "id", operator: "inSet", value: ["140","139","141"]}]
        // }
    });

    QuestionnaireLG_questionnaire = isc.TrLG.create({
        ID: "QuestionnaireLG_questionnaire",
        <sec:authorize access="hasAuthority('Questionnaire_R')">
        dataSource: QuestionnaireDS_questionnaire,
        </sec:authorize>
        autoFetchData: true,
        fields: [{name: "title"},{name:"questionnaireType.title"},{name: "description"}],
        gridComponents: [
            isc.LgLabel.create({contents: "<span><b>" + "<spring:message code="questionnaire"/>" + "</b></span>",}),
            QuestionnaireTS_questionnaire, "filterEditor", "header", "body"
        ],
        contextMenu: QuestionnaireMenu_questionnaire,
        dataChanged: function () { updateCountLabel(this, QuestionnaireLGCountLabel_questionnaire)},
        <sec:authorize access="hasAuthority('Questionnaire_U')">
        recordDoubleClick: function () { editQuestionnaire_questionnaire(); },
        </sec:authorize>
        <sec:authorize access="hasAuthority('QuestionnaireQuestion_R')">
        selectionUpdated: function (record) {refreshQuestionnaireQuestionLG_questionnaire(); },
        </sec:authorize>
        getCellCSSText: function (record) {
            if (record.enabled === 74)
                return "color:gray; font-size: 13px;";
            else
                return "color:#153560; font-size: 13px;";
        },
        dataArrived:function (startRow, endRow, data) {

            if (isDelete_questionnaire){
                QuestionnaireQuestionLG_questionnaire.setData([]);
                isDelete_questionnaire=false;
            }
        }
    });

    QuestionnaireQuestionDS_questionnaire = isc.TrDS.create({
        ID: "QuestionnaireQuestionDS_questionnaire",
        fields: [
            {name: "evaluationQuestion.question", title: "<spring:message code="question"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "weight", title: "<spring:message code="weight"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "order", title: "<spring:message code="order"/>", filterOperator: "iContains"},
        ],
    });

    QuestionnaireQuestionLG_questionnaire = isc.TrLG.create({
        ID: "QuestionnaireQuestionLG_questionnaire",
        <sec:authorize access="hasAuthority('QuestionnaireQuestion_R')">
        dataSource: QuestionnaireQuestionDS_questionnaire,
        </sec:authorize>
        dataFetchMode: "local",
        fields: [{name: "evaluationQuestion.question"}, {name: "weight"}, {name: "order"}],
        gridComponents: [
            isc.LgLabel.create({
                contents: "<span><b>" + "<spring:message code="questions"/>" + "</b></span>"
            }),
            QuestionnaireQuestionTS_questionnaire, "filterEditor", "header", "body"
        ],
        contextMenu: QuestionnaireQuestionMenu_questionnaire,
        dataChanged: function () { updateCountLabel(this, QuestionnaireQuestionLGCount_questionnaire)},
        <sec:authorize access="hasAuthority('QuestionnaireQuestion_U')">
        recordDoubleClick: function () { editQuestionnaireQuestion_questionnaire(); },
        </sec:authorize>
    });

    EvaluationQuestionDS_questionnaire = isc.TrDS.create({
        ID: "EvaluationQuestionDS_questionnaire",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "question", title: "<spring:message code="question"/>", filterOperator: "iContains"},
            {name: "domain.id", title: "<spring:message code="question.domain"/>", filterOperator: "equals", hidden: true},
            {name: "domain.title", title: "<spring:message code="question.domain"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: configQuestionnaireUrl + "/pickList",
    });

    // ------------------------------------------- DynamicForm & Window -------------------------------------------
    QuestionnaireDF_questionnaire = isc.DynamicForm.create({
        ID: "QuestionnaireDF_questionnaire",
        fields: [
            {name: "id", hidden: true},
             {name: "title", title: "<spring:message code="title"/>", required: true, validators: [TrValidators.NotEmpty],},
            {name:"questionnaireTypeId",title:"<spring:message code="type"/>",required:true, type: "select", optionDataSource: QuestionnaireTypeDS_Questionnaire,
                valueField: "id", displayField: "title", filterFields: ["title"], pickListProperties: {showFilterEditor: true,}},
            {name: "description", title: "<spring:message code="description"/>", type: "TextAreaItem",},
        ]
    });

    QuestionnaireWin_questionnaire = isc.Window.create({
        ID: "QuestionnaireWin_questionnaire",
        width: 800,
        items: [QuestionnaireDF_questionnaire, isc.TrHLayoutButtons.create({
            members: [
                isc.IButtonSave.create({click: function () { saveQuestionnaire_questionnaire(); }}),
                isc.IButtonCancel.create({click: function () { QuestionnaireWin_questionnaire.close(); }}),
            ],
        }),]
    });

    QuestionnaireQuestionDF_questionnaire = isc.DynamicForm.create({
        ID: "QuestionnaireQuestionDF_questionnaire",
        fields: [
            {name: "id", hidden: true},
            {name: "questionnaire.id", dataPath: "questionnaireId", hidden: true,},
            {name: "questionnaire.title", title: "<spring:message code="questionnaire"/>", canEdit: false},
            {
                name: "evaluationQuestionId",
                title: "<spring:message code='question'/>",
                required: true,
                type: "select",
                optionDataSource: EvaluationQuestionDS_questionnaire,
                valueField: "id",
                displayField: "question",
                filterFields: ["question"],
                pickListProperties: {
                    showFilterEditor: true,
                },
                pickListFields: [
                    {name: "question"},
                    {name: "domain.title"},
                ],
                pickListWidth: 800,
                sortField: ["domain.id"],
                sortDirection: "descending",
            },
            {name: "weight", title: "<spring:message code="weight"/>", type: "Integer", keyPressFilter: "[0-9]", required: true, editorType: "SpinnerItem", defaultValue: 1, min: 1},
            {name: "order", title: "<spring:message code="order"/>", type: "Integer", keyPressFilter: "[0-9]", required: true, editorType: "SpinnerItem", defaultValue: 1, min: 1},
        ]
    });

    QuestionnaireQuestionWin_questionnaire = isc.Window.create({
        ID: "QuestionnaireQuestionWin_questionnaire",
        width: 800,
        items: [QuestionnaireQuestionDF_questionnaire, isc.TrHLayoutButtons.create({
            members: [
                isc.IButtonSave.create({click: function () { saveQuestionnaireQuestion_questionnaire(); }}),
                isc.IButtonCancel.create({click: function () { QuestionnaireQuestionWin_questionnaire.close(); }}),
            ],
        }),]
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrHLayout.create({
        members: [QuestionnaireLG_questionnaire, QuestionnaireQuestionLG_questionnaire]
    });

    // ------------------------------------------- Functions -------------------------------------------
    function createQuestionnaire_questionnaire() {
        questionnaireMethod_questionnaire = "POST";
        QuestionnaireDF_questionnaire.clearValues();
        QuestionnaireWin_questionnaire.setTitle("<spring:message code="create"/>&nbsp;" + "<spring:message code="questionnaire"/>");
        QuestionnaireWin_questionnaire.show();
    }

    function editQuestionnaire_questionnaire() {
        let record = QuestionnaireLG_questionnaire.getSelectedRecord();
        if (checkRecordAsSelected(record, true, "<spring:message code="questionnaire"/>")) {
            isc.RPCManager.sendRequest(TrDSRequest(questionnaireUrl +
                "/isLocked/" +
                record.id,
                "GET",
                null,
                function(resp){
                    if(resp.data=="true"){
                        createDialog("info", "پرسشنامه مورد نظر در ارزیابی استفاده شده است. بنابراین قابل تغییر نیست.");
                        return ;
                    }

                    questionnaireMethod_questionnaire = "PUT";
                    QuestionnaireDF_questionnaire.clearValues();
                    QuestionnaireDF_questionnaire.editRecord(record);
                    QuestionnaireWin_questionnaire.setTitle("<spring:message code="edit"/>&nbsp;" + "<spring:message code="questionnaire"/>");
                    QuestionnaireWin_questionnaire.show();
                })
            );
        }
    }

    function saveQuestionnaire_questionnaire() {
        if (!QuestionnaireDF_questionnaire.validate()) {
            return;
        }
        let questionnaireSaveUrl = questionnaireUrl;
        action = '<spring:message code="create"/>';
        if (questionnaireMethod_questionnaire.localeCompare("PUT") == 0) {
            let record = QuestionnaireLG_questionnaire.getSelectedRecord();
            questionnaireSaveUrl += "/" + record.id;
            action = '<spring:message code="edit"/>';
        }
        let data = QuestionnaireDF_questionnaire.getValues();
        isc.RPCManager.sendRequest(
            TrDSRequest(questionnaireSaveUrl, questionnaireMethod_questionnaire, JSON.stringify(data), "callback: studyResponse(rpcResponse, '" + action + "','<spring:message code="questionnaire"/>', QuestionnaireWin_questionnaire, QuestionnaireLG_questionnaire)")
        );
    }

    function removeQuestionnaire_questionnaire() {
        let record = QuestionnaireLG_questionnaire.getSelectedRecord();
        var entityType = '<spring:message code="questionnaire"/>';
        if (checkRecordAsSelected(record, true, entityType)) {

            isc.RPCManager.sendRequest(TrDSRequest(questionnaireUrl +
                "/isLocked/" +
                record.id,
                "GET",
                null,
                function(resp){
                    if(resp.data=="true"){
                        createDialog("info", "پرسشنامه مورد نظر در ارزیابی استفاده شده است. بنابراین قابل تغییر نیست.");
                        return ;
                    }

                    removeRecord(questionnaireUrl + "/" + record.id, entityType, record.title, 'QuestionnaireLG_questionnaire');


                })
            );

        }
    }

    // ---------------------------------------------------------------------------------------------------

    function refreshQuestionnaireQuestionLG_questionnaire() {
        var record = QuestionnaireLG_questionnaire.getSelectedRecord();
        if (checkRecordAsSelected(record, false)) {
            selectedRecord=record.id;
            refreshLgDs(QuestionnaireQuestionLG_questionnaire, QuestionnaireQuestionDS_questionnaire, questionnaireQuestionUrl + "/iscList/" + record.id)
        }
    }

    function createQuestionnaireQuestion_questionnaire() {
        let record = QuestionnaireLG_questionnaire.getSelectedRecord();
        if (checkRecordAsSelected(record, true, "<spring:message code="questionnaire"/>")) {
            isc.RPCManager.sendRequest(TrDSRequest(questionnaireUrl +
                "/isLocked/" +
                record.id,
                "GET",
                null,
                function(resp){
                    if(resp.data=="true"){
                        createDialog("info", "پرسشنامه مورد نظر در ارزیابی استفاده شده است. بنابراین قابل تغییر نیست.");
                        return ;
                    }
                    QuestionnaireQuestionDF_questionnaire.clearValues();
                    if(QuestionnaireQuestionDF_questionnaire.getItem('evaluationQuestionId').pickList)
                        QuestionnaireQuestionDF_questionnaire.getItem('evaluationQuestionId').pickList.setData([]);
                    questionnaireQuestionMethod_questionnaire = "POST";
                    QuestionnaireQuestionDF_questionnaire.getItem("questionnaire.id").setValue(record.id);
                    QuestionnaireQuestionDF_questionnaire.getItem("questionnaire.title").setValue(record.title);
                    QuestionnaireQuestionWin_questionnaire.setTitle("<spring:message code="add"/>&nbsp;" + "<spring:message code="question"/>");
                    QuestionnaireQuestionWin_questionnaire.show();
                })
            );

        }
    }

    function editQuestionnaireQuestion_questionnaire() {
        let questionnaireRecord = QuestionnaireLG_questionnaire.getSelectedRecord();
        let record = QuestionnaireQuestionLG_questionnaire.getSelectedRecord();
        if (checkRecordAsSelected(record, true, "<spring:message code="questions"/>")) {
            isc.RPCManager.sendRequest(TrDSRequest(questionnaireUrl +
                "/isLocked/" +
                record.questionnaireId,
                "GET",
                null,
                function(resp){
                    if(resp.data=="true"){
                        createDialog("info", "پرسشنامه مورد نظر در ارزیابی استفاده شده است. بنابراین قابل تغییر نیست.");
                        return ;
                    }

                    questionnaireQuestionMethod_questionnaire = "PUT";
                    QuestionnaireQuestionDF_questionnaire.clearValues();
                    QuestionnaireQuestionDF_questionnaire.editRecord(record);
                    QuestionnaireQuestionDF_questionnaire.getItem("questionnaire.id").setValue(questionnaireRecord.id);
                    QuestionnaireQuestionDF_questionnaire.getItem("questionnaire.title").setValue(questionnaireRecord.title);
                    QuestionnaireQuestionWin_questionnaire.setTitle("<spring:message code="edit"/>&nbsp;" + "<spring:message code="question"/>");
                    QuestionnaireQuestionWin_questionnaire.show();
                })
            );

        }
    }

    function saveQuestionnaireQuestion_questionnaire() {
        if (!QuestionnaireQuestionDF_questionnaire.validate()) {
            return;
        }
        for (let i = 0; i < QuestionnaireQuestionLG_questionnaire.data.allRows.length; i++) {
            if (QuestionnaireQuestionLG_questionnaire.data.allRows[i].evaluationQuestionId === QuestionnaireQuestionDF_questionnaire.getValue("evaluationQuestionId") && QuestionnaireQuestionLG_questionnaire.data.allRows[i].id != QuestionnaireQuestionDF_questionnaire.getValue("id")){
                createDialog("info", "<spring:message code='msg.record.duplicate'/>");
                return;
            }
        }
        let questionnaireQuestionSaveUrl = questionnaireQuestionUrl;
        let action = '<spring:message code="create"/>';
        if (questionnaireQuestionMethod_questionnaire.localeCompare("PUT") === 0) {
            let record = QuestionnaireQuestionLG_questionnaire.getSelectedRecord();
            questionnaireQuestionSaveUrl += "/" + record.id;
            action = '<spring:message code="edit"/>';
        }
        let data = QuestionnaireQuestionDF_questionnaire.getValues();
        isc.RPCManager.sendRequest(
            TrDSRequest(questionnaireQuestionSaveUrl, questionnaireQuestionMethod_questionnaire, JSON.stringify(data), "callback: answerResponce(rpcResponse, '" + action + "','" + "<spring:message code="question"/>" + " " + QuestionnaireQuestionDF_questionnaire.getItem('evaluationQuestionId').getSelectedRecord().question +
        "', QuestionnaireQuestionWin_questionnaire, QuestionnaireQuestionLG_questionnaire)")
        );
    }


    function answerResponce(resp, action, entityType, winToClose, gridToRefresh, entityTitle) {
        let msg;
        let selectedState;
        if (resp == null) {
            createDialog("info", "<spring:message code="msg.error.connecting.to.server"/>");
        } else {
            let respCode = resp.httpResponseCode;
            if (respCode === 200 || respCode === 201) {
                selectedState = "[{id:" + JSON.parse(resp.data).id + "}]";
                let entityTitle = JSON.parse(resp.httpResponseText).title;
                msg = action + '&nbsp;' + entityType + '&nbsp;\'<b>' + '</b>\' &nbsp;' + "<spring:message code="msg.successfully.done"/>";

                if (gridToRefresh !== undefined) {
                    QuestionnaireQuestionLG_questionnaire.invalidateCache()
                }

                let dialog = createDialog("info", msg);
                Timer.setTimeout(function () {
                    dialog.close();
                }, dialogShowTime);
            } else {
                if (respCode === 409) {
                    msg = action + '&nbsp;' + entityType + '&nbsp;\'<b>' + '</b>\' &nbsp;' + "<spring:message code="msg.is.not.possible"/>";
                } else if (respCode === 401) {
                    msg = action + '&nbsp;' + entityType + '&nbsp;\'<b>' + '</b>\' &nbsp;' + JSON.parse(resp.httpResponseText).message;
                } else {
                    msg = "<spring:message code='msg.operation.error'/>";
                }
                createDialog("info", msg);
            }
            if (winToClose !== undefined) {
                QuestionnaireQuestionWin_questionnaire.close();
            }
        }
    }

    /*function ListResponse(resp,record) {
        console.log(0);
        waitQuestionnaire.close();
        let respCode = resp.httpResponseCode;
        if (respCode === 200 || respCode === 201) {
           let rec=JSON.parse(record);
           let questionnaireTypeId =rec.questionnaireTypeId;
           let arr=JSON.parse(resp.data);
           let newArray=new Array();
            arr.forEach(x=>{const{id,eenabled,questionnaireTypeId}=x; newArray.push({id,eenabled,questionnaireTypeId})});
            let thisRecord=newArray.filter(function (el) {return el.id == rec.id});
           if(thisRecord[0].eenabled == 494)
           {
               //غیر فعال شود
               let questionnaireSaveUrl = questionnaireUrl;
               rec.eEnabled=74;
               questionnaireSaveUrl+="/"+rec.id;
               isc.RPCManager.sendRequest( TrDSRequest(questionnaireSaveUrl ,"PUT",JSON.stringify(rec), "callback: EnabledResponse(rpcResponse)"))
           }
           else {
               let removethiseRecord =newArray.map(function(item) {return item.id}).indexOf(rec.id);
               newArray.removeItem(removethiseRecord);
               // let  enabledArray=newArray.filter(function (el) {return el.questionnaireTypeId == questionnaireTypeId && el.eenabled ==494});
               //  if(enabledArray.length >0)
               //  {
               //      createDialog("info", "کاربر گرامی فقط یک رکورد از هر  نوع می تواند فعال باشد", "پیغام");
               //  }
               //  else{
                    //رکورد فعال شود
                    let questionnaireSaveUrl = questionnaireUrl;
                    rec.eEnabled=494;
                    questionnaireSaveUrl+="/"+rec.id;
                    isc.RPCManager.sendRequest( TrDSRequest(questionnaireSaveUrl ,"PUT",JSON.stringify(rec), "callback: EnabledResponse(rpcResponse)"))
                // }
           }
        }
    }*/

    function EnabledResponse(resp) {
        waitQuestionnaire.close();
        let respCode = resp.httpResponseCode;
        if (respCode === 200 || respCode === 201) {
            QuestionnaireLG_questionnaire.invalidateCache()
        }
    }

    function removeQuestionnaireQuestion_questionnaire() {
        let record = QuestionnaireQuestionLG_questionnaire.getSelectedRecord();

        var entityType = '<spring:message code="questions"/>';
        if (checkRecordAsSelected(record, true, entityType)) {
            isc.RPCManager.sendRequest(TrDSRequest(questionnaireUrl +
                "/isLocked/" +
                record.questionnaireId,
                "GET",
                null,
                function(resp){

                    if(resp.data=="true"){
                        createDialog("info", "پرسشنامه مورد نظر در ارزیابی استفاده شده است. بنابراین قابل تغییر نیست.");
                        return ;
                    }

                    let Dialog_Delete = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                        "<spring:message code='verify.delete'/>");
                    Dialog_Delete.addProperties({
                        buttonClick: function (button, index) {
                            this.close();
                            if (index === 0) {
                                //removeRecord(questionnaireQuestionUrl + "/" + record.id, entityType, record.title, 'QuestionnaireQuestionLG_questionnaire');
                                isc.RPCManager.sendRequest( TrDSRequest(questionnaireQuestionUrl + "/" + record.id, "DELETE",null, "callback: removeResponse(rpcResponse)"))
                            }
                        }
                    });
                })
            );
        }
    }

    function  removeResponse(resp) {
        let respCode = resp.httpResponseCode;
        if (respCode === 200 || respCode === 201) {
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                OK.close();
            }, 2000);
            QuestionnaireQuestionLG_questionnaire.invalidateCache()
        }
    }

// </script>
