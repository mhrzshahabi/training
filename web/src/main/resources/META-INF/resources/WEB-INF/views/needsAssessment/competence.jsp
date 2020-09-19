<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

// <script>

    let competenceMethod_competence;
    let valueMap = {
        0: "ارسال به گردش کار",
        1: "عدم تایید",
        2: "تایید نهایی",
        3: "حذف گردش کار",
        4: "اصلاح شایستگی و ارسال به گردش کار"
    }

    // ------------------------------------------- Menu -------------------------------------------
    isc.Menu.create({
        ID: "CompetenceMenu_competence",
        data: [
            {title: "<spring:message code="refresh"/>", click: function () { refreshLG(CompetenceLG_competence); }},
            {title: "<spring:message code="create"/>", click: function () { createCompetence_competence(); }},
            {title: "<spring:message code="edit"/>", click: function () { editCompetence_competence(); }},
            {title: "<spring:message code="remove"/>", click: function () { removeCompetence_competence(); }},
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    let ToolStrip_Competence_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = CompetenceLG_competence.getCriteria();
                    ExportToFile.downloadExcel(null, CompetenceLG_competence , "Competence", 0, null, '',"لیست شایستگی ها - آموزش"  , criteria, null);
                }
            })
        ]
    });

    isc.ToolStrip.create({
        ID: "CompetenceTS_competence",
        members: [
            // isc.ToolStripButton.create({
            //     title: 'نمايش شایستگی ها از وبسرويس',
            //     click: function () {
            //         CompetenceLG_competence_Webservice.invalidateCache();
            //         CompetenceLG_competence_Webservice.fetchData();
            //         Window_WebService_CompetenceWin_competence.show();
            //     }
            // }),
            isc.ToolStripButtonRefresh.create({click: function () { refreshLG(CompetenceLG_competence); }}),
            isc.ToolStripButtonCreate.create({click: function () { createCompetence_competence(); }}),
            isc.ToolStripButtonEdit.create({click: function () { editCompetence_competence(); }}),
            isc.ToolStripButtonRemove.create({click: function () { removeCompetence_competence(); }}),
            ToolStrip_Competence_Export2EXcel,
            isc.LayoutSpacer.create({width: "*"}),
            isc.Label.create({ID: "CompetenceLGCountLabel_competence"}),
        ]
    });

    isc.ToolStrip.create({
        ID: "CompetenceTS_competence_webservice",
        members: [
            isc.Label.create({ID: "CompetenceLGCountLabel_competence_webservice"}),
        ]
    });

    // ------------------------------------------- DataSource & ListGrid -------------------------------------------

    let RestDataSource_category_JspCompetence = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", type: "text"}
        ],
        fetchDataURL: categoryUrl + "spec-list",
    });
    let RestDataSource_SubCategory_JspCompetence = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true}, {name: "titleFa"}, {name: "code"}
        ],
        fetchDataURL: subCategoryUrl + "spec-list",
    });
    // let RestDataSourceLG_SubCategory_JspCompetence = isc.TrDS.create({
    //     fields: [{name: "id", primaryKey: true}, {name: "titleFa"}, {name: "code"}
    //     ],
    //     fetchDataURL: subCategoryUrl + "spec-list",
    // });

    CompetenceDS_competence = isc.TrDS.create({
        ID: "CompetenceDS_competence",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceTypeId", hidden: true},
            {name: "competenceType.title", title: "<spring:message code="type"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
            {
                name: "categoryId",
                title: "<spring:message code="category"/>",
                align: "center",
                filterOperator: "equals",
                optionDataSource: RestDataSource_category_JspCompetence,
                displayField: "titleFa",
                filterOnKeypress: true,
                valueField: "id",
                // sortNormalizer: function (record) {
                //     return record.category.titleFa;
                // }
                // autoFitWidth: true
            },
            {
                name: "subCategoryId",
                title: "<spring:message code="subcategory"/>",
                align: "center",
                filterOperator: "equals",
                optionDataSource: RestDataSource_SubCategory_JspCompetence,
                displayField: "titleFa",
                filterOnKeypress: true,
                valueField: "id",
                // sortNormalizer: function (record) {
                //     return record.category.titleFa;
                // }
                // autoFitWidth: true
            },
            {name: "code", title: "کد", autoFitWidth: true, filterOperator: "iContains"},
            {name: "workFlowStatusCode", title: "وضعیت گردش کار",
                filterOperator: "equals",
                filterOnKeypress: true,
            },
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: competenceUrl + "/spec-list",
    });

    CompetenceDS_competence_Webservice = isc.TrDS.create({
        ID: "CompetenceDS_competence_Webservice",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceTypeId", hidden: true},
            {name: "competenceType.title", title: "<spring:message code="type"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: masterDataUrl + "/competence/iscList",
    });

    CompetenceLG_competence = isc.TrLG.create({
        ID: "CompetenceLG_competence",
        dataSource: CompetenceDS_competence,
        autoFetchData: true,
        fields: [{name: "title"}, {name: "code"}, {name: "competenceType.title"},{name: "categoryId"},{name:"subCategoryId"}, {name: "workFlowStatusCode", valueMap: valueMap}, {name: "description"}],
        gridComponents: [
            CompetenceTS_competence, , "filterEditor", "header", "body"
        ],
        contextMenu: CompetenceMenu_competence,
        dataChanged: function () { updateCountLabel(this, CompetenceLGCountLabel_competence)},
        recordDoubleClick: function () { editCompetence_competence(); }
    });

    CompetenceLG_competence_Webservice = isc.TrLG.create({
        ID: "CompetenceLG_competence_Webservice",
        dataSource: CompetenceDS_competence_Webservice,
        autoFetchData: true,
        fields: [{name: "title"}, {name: "competenceType.title",canFilter:false,canSort:false}, {name: "description",canFilter:false,canSort:false}],
        gridComponents: [
            CompetenceTS_competence_webservice,"filterEditor", "header", "body"
        ],
        dataChanged: function () { updateCountLabel(this, CompetenceTS_competence_webservice)},
    });

    CompetenceTypeDS_competence = isc.TrDS.create({
        ID: "CompetenceTypeDS_competence",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: parameterValueUrl + "/iscList/100",
    });



    // ------------------------------------------- DynamicForm & Window -------------------------------------------
    let CompetenceDF_competence = isc.DynamicForm.create({
        ID: "CompetenceDF_competence",
        readOnlyDisplay: "readOnly",
        fields: [
            {name: "id", hidden: true},
            {name: "code", title: "کد", canEdit: false, textAlign: "center"},
            {name: "title", title: "<spring:message code="title"/>", required: true, validators: [TrValidators.NotEmpty], textAlign: "center"},
            {
                name: "competenceTypeId", title: "<spring:message code='type'/>", required: true, type: "select", optionDataSource: CompetenceTypeDS_competence,
                textAlign: "center",
                valueField: "id", displayField: "title", filterFields: ["title"], pickListProperties: {showFilterEditor: true,},
                changed(){
                    actionCompetenceType()
                    createCompetenceCode()
                }
            },
            {
                name: "categoryId",
                colSpan: 1,
                title: "<spring:message code="category"/>",
                textAlign: "center",
                hidden: true,
                // autoFetchData: true,
                // required: true,
                // titleOrientation: "top",
                // height: "30",
                width: "*",
                // editorType: "TrComboBoxItem",
                // changeOnKeypress: true,
                // filterOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_category_JspCompetence,
                filterFields: ["titleFa"],
                pickListProperties:{
                    showFilterEditor: false
                },
                sortField: ["id"],
                changed: function (form, item, value) {
                    form.clearValue("subCategoryId");
                    createCompetenceCode()
                },
            },
            {
                name: "subCategoryId",
                colSpan: 1,
                title: "<spring:message code="subcategory"/>",
                prompt: "ابتدا گروه را انتخاب کنید",
                textAlign: "center",
                hidden: true,
                // required: true,
                // autoFetchData: false,
                // titleOrientation: "top",
                // height: "30",
                width: "*",
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: RestDataSource_SubCategory_JspCompetence,
                filterFields: ["titleFa"],
                sortField: ["id"],
                pickListProperties:{
                    showFilterEditor: false,
                },
                click: function (form, item, value) {
                    if(form.getValue("categoryId") === undefined) {
                        RestDataSource_SubCategory_JspCompetence.fetchDataURL = subCategoryUrl + "spec-list?id=-1";
                    }
                    else{
                        RestDataSource_SubCategory_JspCompetence.fetchDataURL = subCategoryUrl + "spec-list?categoryId=" + form.getValue("categoryId");
                    }
                    item.fetchData()
                },
                changed(){
                    createCompetenceCode()
                }
            },
            {name: "description", title: "<spring:message code="description"/>", type: "TextAreaItem"},
        ]
    });

    let CompetenceWin_competence = isc.Window.create({
        ID: "CompetenceWin_competence",
        width: 800,
        items: [CompetenceDF_competence, isc.TrHLayoutButtons.create({
            members: [
                isc.IButtonSave.create({click: function () { saveCompetence_competence(); }}),
                isc.IButtonCancel.create({click: function () { CompetenceWin_competence.close(); }}),
            ],
        }),]
    });

    var Window_WebService_CompetenceWin_competence = isc.Window.create({
        title: "<spring:message code='competence'/>",
        width: "100%",
        height: "100%",
        minWidth: "100%",
        minHeight: "100%",
        autoSize: false,
        items: [
            CompetenceLG_competence_Webservice,
            isc.HLayout.create({
                width: "100%",
                height: "6%",
                autoDraw: false,
                align: "center",
                members: [
                    isc.IButton.create({
                        title: "<spring:message code='close'/>",
                        icon: "[SKIN]/actions/cancel.png",
                        width: "70",
                        align: "center",
                        click: function () {
                            Window_WebService_CompetenceWin_competence.close();
                        }
                    })
                ]
            })

        ],
    });

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrHLayout.create({
        members: [CompetenceLG_competence]
    });

    // ------------------------------------------- Functions -------------------------------------------
    function createCompetence_competence() {
        competenceMethod_competence = "POST";
        CompetenceDF_competence.clearValues();
        CompetenceWin_competence.setTitle("<spring:message code="create"/>&nbsp;" + "<spring:message code="competence"/>");
        CompetenceWin_competence.show();
    }

    function editCompetence_competence() {
        let record = CompetenceLG_competence.getSelectedRecord();
        if (record) { //fix bug
            if (record.workFlowStatusCode === 0 || record.workFlowStatusCode === 4) {
                createDialog("warning", "بدلیل در گردش کار بودن شایستگی امکان ویرایش وجود ندارد")
                return;
            }
            if (checkRecordAsSelected(record, true, "<spring:message code="competence"/>")) {
                competenceMethod_competence = "PUT";
                CompetenceDF_competence.clearValues();
                CompetenceDF_competence.editRecord(record);
                CompetenceWin_competence.setTitle("<spring:message code="edit"/>&nbsp;" + "<spring:message code="competence"/>");
                let inter = setInterval(function () {
                    if (CompetenceDF_competence.getItem("competenceTypeId").getSelectedRecord() !== undefined) {
                        clearInterval(inter)
                        CompetenceWin_competence.show();
                        actionCompetenceType();
                    }
                }, 100)
            }
        }
        else {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        }
    }

    function saveCompetence_competence() {
        if (!CompetenceDF_competence.validate()) {
            return;
        }
        let competenceSaveUrl = competenceUrl;
        let action = '<spring:message code="create"/>';
        if (competenceMethod_competence.localeCompare("PUT") === 0) {
            let record = CompetenceLG_competence.getSelectedRecord();
            competenceSaveUrl += "/" + record.id;
            action = '<spring:message code="edit"/>';
        }
        let data = CompetenceDF_competence.getValues();
        let entityTitle = data.title
        wait.show();
        isc.RPCManager.sendRequest(
            TrDSRequest(competenceSaveUrl, competenceMethod_competence, JSON.stringify(data), (resp)=>{
                wait.close();
                if(resp.httpResponseCode !== 226) {
                    if(competenceMethod_competence === "POST") {
                        if (resp.httpResponseCode === 401) { //bug fix
                            simpleDialog("<spring:message code="message"/>", "<spring:message code='publication.title.duplicate'/>", 3000, "say");
                            return;
                        }

                        sendCompetenceToWorkflow(JSON.parse(resp.data));
                    }//end post

                    else if (resp.httpResponseCode === 401 && competenceMethod_competence === "PUT"){ //bug fix
                        simpleDialog("<spring:message code="message"/>", "<spring:message code='publication.title.duplicate'/>", 3000, "say");
                        return;
                    }

                    else if(JSON.parse(resp.data).workFlowStatusCode === 3 || JSON.parse(resp.data).workFlowStatusCode === 2){
                        sendCompetenceToWorkflow(JSON.parse(resp.data));
                    }
                    studyResponse(resp, "action", '<spring:message code="competence"/>', CompetenceWin_competence, CompetenceLG_competence, "entityTitle");
                }
                else{
                    let list = JSON.parse(resp.data);
                    CompetenceWin_competence.close();
                    createDialog("warning", "شایستگی فوق در " + priorityList[list[0].objectType] + " " + getFormulaMessage(list[0].objectName, ) + " استفاده شده است. و قابل ویرایش نمیباشد.", "اخطار")
                }
            })
        );
    }

    function removeCompetence_competence() {
        let record = CompetenceLG_competence.getSelectedRecord();
        let entityType = '<spring:message code="competence"/>';
        if (checkRecordAsSelected(record, true, entityType)) {
            wait.show()
            isc.RPCManager.sendRequest(TrDSRequest(competenceUrl + "/" + record.id, "GET", null, (resp)=>{
                wait.close();
                if(resp.httpResponseCode !== 226){
                    removeRecord(competenceUrl + "/" + record.id, entityType, record.title, 'CompetenceLG_competence');
                }
                else{
                    createDialog("warning", "بدلیل اینکه شایستگی در نیازسنجی استفاده شده است، این شایستگی قابل حذف نمیباشد.", "اخطار");
                }
            }))
        }
    }

    function actionCompetenceType() {
        let item = CompetenceDF_competence.getItem("competenceTypeId");
        let form = CompetenceDF_competence;
        if(item.getSelectedRecord().title === "تخصصی"){
            form.getItem("categoryId").show();
            form.getItem("subCategoryId").show();
            form.getItem("categoryId").setRequired(true);
            form.getItem("subCategoryId").setRequired(true);
        }
        else{
            form.getItem("categoryId").hide();
            form.getItem("subCategoryId").hide();
            form.clearValue("categoryId");
            form.clearValue("subCategoryId");
            form.getItem("categoryId").setRequired(false);
            form.getItem("subCategoryId").setRequired(false);
        }
    }

    function createCompetenceCode() {
        let form = CompetenceDF_competence;
        let title = (form.getItem("competenceTypeId").getSelectedRecord()) ? (form.getItem("competenceTypeId").getSelectedRecord().title) : "";
        let code = form.getItem("code");
        let cat = (form.getField("categoryId").getSelectedRecord()) ? (form.getField("categoryId").getSelectedRecord().code) : "";
        let subCat = (form.getField("subCategoryId").getSelectedRecord()) ? (form.getField("subCategoryId").getSelectedRecord().code) : "";
        switch (title) {
            case "تخصصی":
                code.setValue("T" + cat + subCat);
                break;
            case "عمومی":
                code.setValue("O00000");
                break;
            case "مدیریتی":
                code.setValue("M00000");
                break;
        }
    }

    function sendCompetenceToWorkflow(record){
        let varParams = [{
            "processKey": "competenceWorkflow",
            "cId": record.id,
            "competenceTitle": "ایجاد شایستگی " + record.title,
            "competenceCreatorId": "${username}",
            "competenceCreator": userFullName,
            "REJECTVAL": "",
            "REJECT": "",
            "target": "/web/competence",
            "targetTitleFa": "شایستگی",
            "workflowStatus": "ثبت اولیه",
            "workflowStatusCode": "0",
            "workFlowName": "Competence",
        }];
        wait.show()
        isc.RPCManager.sendRequest(TrDSRequest(workflowUrl + "/startProcess", "POST", JSON.stringify(varParams), (resp)=>{
            wait.close()
            if (resp.httpResponseCode === 200) {
                simpleDialog("<spring:message code="message"/>", "<spring:message code='course.set.on.workflow.engine'/>", 3000, "say");
            } else if (resp.httpResponseCode === 404) {
                simpleDialog("<spring:message code="message"/>", "<spring:message code='workflow.bpmn.not.uploaded'/>", 3000, "stop");
            } else {
                simpleDialog("<spring:message code="message"/>", "<spring:message code='msg.send.to.workflow.problem'/>", 3000, "stop");
            }
        }));
    }

    //</script>