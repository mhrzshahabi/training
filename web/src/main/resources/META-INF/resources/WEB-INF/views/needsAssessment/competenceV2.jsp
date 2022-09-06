<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

// <script>

    let competenceMethod_competence;
    let valueMap = {
        0: "ارسال به گردش کار",
        1: "عدم تایید",
        2: "تایید نهایی",
        3: "حذف گردش کار",
        4: "اصلاح شایستگی و ارسال به گردش کار"
    };

    // ------------------------------------------- Menu -------------------------------------------
    isc.Menu.create({
        ID: "CompetenceMenu_competenceV2",
        data: [
            <sec:authorize access="hasAuthority('Competence_R')">
            {title: "<spring:message code="refresh"/>", click: function () { refreshLG(CompetenceLG_competenceV2); }},
            </sec:authorize>
            <sec:authorize access="hasAuthority('Competence_C')">
            {title: "<spring:message code="create"/>", click: function () { createCompetence_competenceV2(); }},
            </sec:authorize>
            <sec:authorize access="hasAuthority('Competence_U')">
            {title: "<spring:message code="edit"/>", click: function () { editCompetence_competenceV2(); }},
            </sec:authorize>
            <sec:authorize access="hasAuthority('Competence_D')">
            {title: "<spring:message code="remove"/>", click: function () { removeCompetence_competenceV2(); }},
            </sec:authorize>
        ]
    });

    // ------------------------------------------- ToolStrip -------------------------------------------
    let ToolStrip_Competence_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = CompetenceLG_competenceV2.getCriteria();
                    ExportToFile.downloadExcel(null, CompetenceLG_competenceV2 , "Competence", 0, null, '',"لیست شایستگی ها - آموزش"  , criteria, null);
                }
            })
        ]
    });

    isc.ToolStrip.create({
        ID: "CompetenceTS_competenceV2",
        members: [
            <sec:authorize access="hasAuthority('Competence_C')">
            isc.ToolStripButtonCreate.create({click: function () { createCompetence_competenceV2(); }}),
            </sec:authorize>
            <sec:authorize access="hasAuthority('Competence_U')">
            isc.ToolStripButtonEdit.create({click: function () { editCompetence_competenceV2(); }}),
            </sec:authorize>
            <sec:authorize access="hasAuthority('Competence_D')">
            isc.ToolStripButtonRemove.create({click: function () { removeCompetence_competenceV2(); }}),
            </sec:authorize>
            <sec:authorize access="hasAuthority('Competence_P')">
            ToolStrip_Competence_Export2EXcel,
            </sec:authorize>
            isc.LayoutSpacer.create({width: "*"}),
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: "0px",
                members: [
                    isc.Label.create({ID: "CompetenceLGCountLabel_competence"}),
                    <sec:authorize access="hasAuthority('Competence_R')">
                    isc.ToolStripButtonRefresh.create({click: function () { refreshLG(CompetenceLG_competenceV2); }}),
                    </sec:authorize>
                ]
            })
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

    CompetenceDS_competenceV2 = isc.TrDS.create({
        ID: "CompetenceDS_competenceV2",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "processInstanceId", hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceTypeId", hidden: true},
            {name: "competenceLevelId"},
            {name: "competencePriorityId"},
            {name: "complex"},
            {name: "isUsed", hidden: true},
            {name: "active"},
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
            },
            {name: "code", title: "کد", autoFitWidth: true, filterOperator: "iContains"},
            {name: "workFlowStatusCode", title: "وضعیت گردش کار",
                filterOperator: "equals",
                filterOnKeypress: true,
            },
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
            {name: "returnDetail", title: "دلیل عودت", filterOperator: "iContains"},
        ],
        fetchDataURL: competenceUrl + "/spec-list",
    });

    <%--CompetenceDS_competence_Webservice = isc.TrDS.create({--%>
    <%--    ID: "CompetenceDS_competence_Webservice",--%>
    <%--    fields: [--%>
    <%--        {name: "id", primaryKey: true, hidden: true},--%>
    <%--        {name: "title", title: "<spring:message code="title"/>", required: true, filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "competenceTypeId", hidden: true},--%>
    <%--        {name: "competenceType.title", title: "<spring:message code="type"/>", required: true, filterOperator: "iContains", autoFitWidth: true},--%>
    <%--        {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},--%>
    <%--    ],--%>
    <%--    fetchDataURL: masterDataUrl + "/competence/iscList",--%>
    <%--});--%>

    CompetenceLG_competenceV2 = isc.TrLG.create({
        ID: "CompetenceLG_competenceV2",
        <sec:authorize access="hasAuthority('Competence_R')">
        dataSource: CompetenceDS_competenceV2,
        </sec:authorize>
        autoFetchData: true,
        fields: [
            {name: "title"},
            {name: "code"},
            {name: "competenceType.title"},
            {name: "categoryId"},
            {name:"subCategoryId"},
            {name: "workFlowStatusCode", valueMap: valueMap},
            {name: "description"},
            {name: "returnDetail"}
        ],
        getCellCSSText: function (record, rowNum, colNum) {
            if ((record.isUsed === false)){
                return "background-color : #fa5f71";
            }

        },
        gridComponents: [
            CompetenceTS_competenceV2, "filterEditor", "header", "body"
        ],
        contextMenu: CompetenceMenu_competenceV2,
        dataChanged: function () { updateCountLabel(this, CompetenceLGCountLabel_competence)},
        recordDoubleClick: function () { editCompetence_competenceV2(); }
    });

    <%--CompetenceLG_competence_Webservice = isc.TrLG.create({--%>
    <%--    ID: "CompetenceLG_competence_Webservice",--%>
    <%--    dataSource: CompetenceDS_competence_Webservice,--%>
    <%--    autoFetchData: true,--%>
    <%--    fields: [{name: "title"}, {name: "competenceType.title",canFilter:false,canSort:false}, {name: "description",canFilter:false,canSort:false}],--%>
    <%--    gridComponents: [--%>
    <%--        CompetenceTS_competence_webservice,"filterEditor", "header", "body"--%>
    <%--    ],--%>
    <%--    dataChanged: function () { updateCountLabel(this, CompetenceTS_competence_webservice)},--%>
    <%--});--%>

    CompetenceTypeDS_competenceV2 = isc.TrDS.create({
        ID: "CompetenceTypeDS_competenceV2",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: parameterValueUrl + "/listByCode/gapCompetenceType",
    });

    CompetenceLevelDS_competenceV2 = isc.TrDS.create({
        ID: "CompetenceLevelDS_competenceV2",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: parameterValueUrl + "/listByCode/NeedsAssessmentDomain",
    });

    CompetencePriorityDS_competenceV2 = isc.TrDS.create({
        ID: "CompetencePriorityDS_competenceV2",
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", required: true, filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: parameterValueUrl + "/listByCode/NeedsAssessmentPriority",
    });

    let RestDataSource_competence_Department_Filter = isc.TrDS.create({
        fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/organ-segment-iscList/mojtame"
    });
    let CompetenceDS_postTocompetenceV2 = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code"}, {name: "title"}, {name: "type"}, {name: "skill"}],
    });
    let CompetenceDS_postTocompetenceV3 = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code"}, {name: "title"}, {name: "type"}, {name: "skill"}],
    });

    // ------------------------------------------- DynamicForm & Window -------------------------------------------
    let CompetenceDF_competenceV2 = isc.DynamicForm.create({
        ID: "CompetenceDF_competenceV2",
        readOnlyDisplay: "readOnly",
        fields: [
            {name: "id", hidden: true},
            {name: "code", title: "کد", canEdit: false, textAlign: "center"},
            {name: "title", title: "<spring:message code="title"/>", required: true, validators: [TrValidators.NotEmpty], textAlign: "center"},
            {
                name: "competenceTypeId", title: "نوع شایستگی", required: true, type: "select", optionDataSource: CompetenceTypeDS_competenceV2,
                textAlign: "center",
                valueField: "id", displayField: "title", filterFields: ["title"], pickListProperties: {showFilterEditor: true,},
                changed(){
                    // actionCompetenceTypeV2()
                    createCompetenceCodeV2()
                }
            },
            {
                name: "competenceLevelId", title: "سطح شایستگی", required: true, type: "select", optionDataSource: CompetenceLevelDS_competenceV2,
                textAlign: "center",
                valueField: "id", displayField: "title", filterFields: ["title"], pickListProperties: {showFilterEditor: true,},

            },
            {
                name: "competencePriorityId", title: "اولویت شایستگی", required: true, type: "select", optionDataSource: CompetencePriorityDS_competenceV2,
                textAlign: "center",
                valueField: "id", displayField: "title", filterFields: ["title"], pickListProperties: {showFilterEditor: true,},

            },
            {
                name: "complex",
                title: "مجتمع",
                required: true,
                optionDataSource: RestDataSource_competence_Department_Filter,
                autoFetchData: false,
                textAlign: "center",
                displayField: "title",
                valueField: "title",
                pickListFields: [
                    {
                        name: "title",
                        title: "<spring:message code="title"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    }
                ],
            },
            {
                name: "categoryId",
                colSpan: 1,
                title: "<spring:message code="category"/>",
                textAlign: "center",
                hidden: false,
                width: "*",
                required: true,
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
                    createCompetenceCodeV2()
                },
            },
            {
                name: "subCategoryId",
                colSpan: 1,
                title: "<spring:message code="subcategory"/>",
                prompt: "ابتدا گروه را انتخاب کنید",
                textAlign: "center",
                hidden: false,
                required: true,
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
                    createCompetenceCodeV2()
                }
            },
            {name: "description", title: "<spring:message code="description"/>", type: "TextAreaItem"},
            {
                name: "active",
                title: "فعال",
                type: "checkbox",
                width: "2",
                defaultValue: true,

                changed: function (form, item, value) {

                }
            },
        ]
    });

    let CompetenceWin_competenceV2 = isc.Window.create({
        ID: "CompetenceWin_competenceV2",
        width: 800,
        items: [CompetenceDF_competenceV2, isc.TrHLayoutButtons.create({
            members: [
                isc.IButtonSave.create({click: function () { saveCompetence_competenceV2(); }}),
                isc.IButtonCancel.create({click: function () { CompetenceWin_competenceV2.close(); }}),
            ],
        }),]
    });


    LG_postTocompetenceV2 = isc.ListGrid.create({
        ID: "LG_postTocompetenceV2",
        canAutoFitFields: true,
        width: "100%",
        height: "100%",
        minHeight: 500,
        dataPageSize: 50,
         dataSource: CompetenceDS_postTocompetenceV2,
         autoFetchData: true,
        fields: [
            {name: "title",title:"عنوان"},
            {name: "code",title:"کد پست"},
            {name: "type",title:"نوع پست"},
            {name: "skill",title:"عنوان مهارت"},

        ],


       });

    LG_postTocompetenceV3 = isc.ListGrid.create({
        ID: "LG_postTocompetenceV3",
        canAutoFitFields: true,
        width: "100%",
        height: "100%",
        minHeight: 500,
        dataPageSize: 75,
        dataSource: CompetenceDS_postTocompetenceV3,
        autoFetchData: true,
        fields: [
            {name: "title",title:"عنوان"},
            {name: "code",title:"کد پست"},
            {name: "type",title:"نوع پست"},
            {name: "skill",title:"عنوان مهارت"},

        ],


    });


    let CompetenceWin_postToCompetence2 = isc.Window.create({
        title:"مشاهده پست های متصل به نیازسنجی",
        ID: "CompetenceWin_postToCompetence2",
        width: 800,
        height: 600,
        items: [
            LG_postTocompetenceV2,
            isc.IButtonCancel.create({
                layoutAlign: "center",

                click: function () { CompetenceWin_postToCompetence2.close(); }})

        ]
    });

    let CompetenceWin_postToCompetence3 = isc.Window.create({
        title:"مشاهده پست های متصل به نیازسنجی",
        ID: "CompetenceWin_postToCompetence3",
        width: 800,
        height: 600,
        items: [
            LG_postTocompetenceV3,
            isc.IButtonCancel.create({
                layoutAlign: "center",

                click: function () { CompetenceWin_postToCompetence3.close(); }})

        ]
    });

    let CompetenceWin_delete = isc.Window.create({
        title:"مشاهده پست های متصل به نیازسنجی",
        ID: "CompetenceWin_delete",
        width: 800,
        items: [
            isc.Label.create({
                ID: "deleteCompetenceLabel",
                dynamicContents: true,
                align: "center",
                padding: 5
            }),
            isc.TrHLayoutButtons.create({
            members: [
                 isc.IButton.create({
                     width: 200,
                     title: "پست های نیاز سنجی شده",
                     click: function () {
                         LG_postTocompetenceV2.invalidateCache()
                          CompetenceWin_postToCompetence2.show()
                     }}),
                isc.IButton.create({
                    width: 200,

                    title: "پست های در حال نیاز سنجی ",
                    click: function () {
                        LG_postTocompetenceV3.invalidateCache()
                        CompetenceWin_postToCompetence3.show()
                    }}),
                 isc.IButtonCancel.create({
                     title: "حذف نیازسنجی",
                     click: function () {
                         let record = CompetenceLG_competenceV2.getSelectedRecord();
                         let entityType = '<spring:message code="competence"/>';
                         CompetenceWin_delete.close();

                         removeCompetenceToWorkflowV2(record,entityType)


                     }}),
                 isc.IButtonCancel.create({click: function () { CompetenceWin_delete.close(); }}),
            ],
        }),]
    });

    <%--var Window_WebService_CompetenceWin_competenceV2 = isc.Window.create({--%>
    <%--    title: "<spring:message code='competence'/>",--%>
    <%--    width: "100%",--%>
    <%--    height: "100%",--%>
    <%--    minWidth: "100%",--%>
    <%--    minHeight: "100%",--%>
    <%--    autoSize: false,--%>
    <%--    items: [--%>
    <%--        CompetenceLG_competence_Webservice,--%>
    <%--        isc.HLayout.create({--%>
    <%--            width: "100%",--%>
    <%--            height: "6%",--%>
    <%--            autoDraw: false,--%>
    <%--            align: "center",--%>
    <%--            members: [--%>
    <%--                isc.IButton.create({--%>
    <%--                    title: "<spring:message code='close'/>",--%>
    <%--                    icon: "[SKIN]/actions/cancel.png",--%>
    <%--                    width: "70",--%>
    <%--                    align: "center",--%>
    <%--                    click: function () {--%>
    <%--                        Window_WebService_CompetenceWin_competenceV2.close();--%>
    <%--                    }--%>
    <%--                })--%>
    <%--            ]--%>
    <%--        })--%>

    <%--    ],--%>
    <%--});--%>

    // ------------------------------------------- Page UI -------------------------------------------
    isc.TrHLayout.create({
        members: [CompetenceLG_competenceV2]
    });

    // ------------------------------------------- Functions -------------------------------------------
    function createCompetence_competenceV2() {
        competenceMethod_competence = "POST";
        CompetenceDF_competenceV2.clearValues();
        CompetenceWin_competenceV2.setTitle("<spring:message code="create"/>&nbsp;" + "<spring:message code="competence"/>");
        CompetenceWin_competenceV2.show();
    }

    function editCompetence_competenceV2() {
        let record = CompetenceLG_competenceV2.getSelectedRecord();
        if (record) {
            if (record.workFlowStatusCode === 0 || record.workFlowStatusCode === 4) {
                createDialog("warning", "بدلیل در گردش کار بودن شایستگی امکان ویرایش وجود ندارد")
                return;
            }
            if (checkRecordAsSelected(record, true, "<spring:message code="competence"/>")) {
                competenceMethod_competence = "PUT";
                CompetenceDF_competenceV2.clearValues();
                CompetenceDF_competenceV2.editRecord(record);
                CompetenceDF_competenceV2.setValue("active", record.active);
                CompetenceWin_competenceV2.setTitle("<spring:message code="edit"/>&nbsp;" + "<spring:message code="competence"/>");
                let inter = setInterval(function () {
                    if (CompetenceDF_competenceV2.getItem("competenceTypeId").getSelectedRecord() !== undefined) {
                        clearInterval(inter)
                        CompetenceWin_competenceV2.show();
                        // actionCompetenceTypeV2();
                    }
                }, 100)
            }
        }
        else {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        }
    }

    function saveCompetence_competenceV2() {
        if (!CompetenceDF_competenceV2.validate()) {
            return;
        }
        let competenceSaveUrl = competenceUrl;
        let action = '<spring:message code="create"/>';
        if (competenceMethod_competence.localeCompare("PUT") === 0) {
            let record = CompetenceLG_competenceV2.getSelectedRecord();
            competenceSaveUrl += "/" + record.id;
            action = '<spring:message code="edit"/>';
        }
        let data = CompetenceDF_competenceV2.getValues();
        let entityTitle = data.title
            sendCompetenceToWorkflowV2(data,competenceMethod_competence);
        <%--isc.RPCManager.sendRequest(--%>
        <%--    TrDSRequest(competenceSaveUrl, competenceMethod_competence, JSON.stringify(data), (resp)=>{--%>
        <%--        wait.close();--%>
        <%--        if(resp.httpResponseCode !== 226) {--%>
        <%--            if(competenceMethod_competence === "POST") {--%>
        <%--                if (resp.httpResponseCode === 401) { //bug fix--%>
        <%--                    simpleDialog("<spring:message code="message"/>", "<spring:message code='publication.title.duplicate'/>", 3000, "say");--%>
        <%--                    return;--%>
        <%--                }--%>

        <%--                sendCompetenceToWorkflowV2(JSON.parse(resp.data));--%>
        <%--            }//end post--%>

        <%--            else if (resp.httpResponseCode === 401 && competenceMethod_competence === "PUT"){ //bug fix--%>
        <%--                simpleDialog("<spring:message code="message"/>", "<spring:message code='publication.title.duplicate'/>", 3000, "say");--%>
        <%--                return;--%>
        <%--            }--%>

        <%--            // else if(JSON.parse(resp.data).workFlowStatusCode === 3 || JSON.parse(resp.data).workFlowStatusCode === 2){--%>
        <%--            //     sendCompetenceToWorkflow(JSON.parse(resp.data));--%>
        <%--            // }--%>
        <%--            studyResponse(resp, "action", '<spring:message code="competence"/>', CompetenceWin_competenceV2, CompetenceLG_competenceV2, "entityTitle");--%>
        <%--        }--%>
        <%--        else{--%>
        <%--            let list = JSON.parse(resp.data);--%>
        <%--            CompetenceWin_competenceV2.close();--%>
        <%--            createDialog("warning", "شایستگی فوق در " + priorityList[list[0].objectType] + " " + getFormulaMessage(list[0].objectName, ) + " استفاده شده است. و قابل ویرایش نمیباشد.", "اخطار")--%>
        <%--        }--%>
        <%--    })--%>
        <%--);--%>
    }

    function removeCompetence_competenceV2() {
        let record = CompetenceLG_competenceV2.getSelectedRecord();
        let entityType = '<spring:message code="competence"/>';

        CompetenceDS_postTocompetenceV2.fetchDataURL = competenceUrl + "/show-posts/spec-list" + "?id="+record.id;
        CompetenceDS_postTocompetenceV3.fetchDataURL = competenceUrl + "/show-posts-temp/spec-list" + "?id="+record.id;

        function showRemoveDialog() {
            deleteCompetenceLabel.setContents(" شایستگی مورد نظر در نیازسنجی  های مختلف استفاده شده است، جهت مشاهده دکمه ی مشاهده را کلیک نمایید.با حذف شایستگی , شایستگی مورد نظر از همه ی پست ها مربوطه نیز حذف خواهد شد");
            CompetenceWin_delete.show()

        }

        if (checkRecordAsSelected(record, true, entityType)) {
            wait.show()
            isc.RPCManager.sendRequest(TrDSRequest(competenceUrl + "/" + record.id, "GET", null, (resp)=>{
                wait.close();
                if(resp.httpResponseCode !== 226){
                    if (resp.httpResponseCode === 406){
                        createDialog("warning", "بدلیل اینکه شایستگی در کارتابل وجود دارد، این شایستگی قابل حذف نمیباشد.", "اخطار");

                    }else {
                        removeCompetenceToWorkflowV2(record,entityType)
                    }
                }
                else{
                    showRemoveDialog()
                }
            }))
        }
    }

    // function actionCompetenceTypeV2() {
    //     let item = CompetenceDF_competenceV2.getItem("competenceTypeId");
    //     let form = CompetenceDF_competenceV2;
    //     if(item.getSelectedRecord().title === "تخصصی"){
    //         form.getItem("categoryId").show();
    //         form.getItem("subCategoryId").show();
    //         form.getItem("categoryId").setRequired(true);
    //         form.getItem("subCategoryId").setRequired(true);
    //     }
    //     else{
    //         form.getItem("categoryId").hide();
    //         form.getItem("subCategoryId").hide();
    //         form.clearValue("categoryId");
    //         form.clearValue("subCategoryId");
    //         form.getItem("categoryId").setRequired(false);
    //         form.getItem("subCategoryId").setRequired(false);
    //     }
    // }

    function createCompetenceCodeV2() {
        let form = CompetenceDF_competenceV2;
        let title = (form.getItem("competenceTypeId").getSelectedRecord()) ? (form.getItem("competenceTypeId").getSelectedRecord().title) : "";
        let code = form.getItem("code");
        let cat = (form.getField("categoryId").getSelectedRecord()) ? (form.getField("categoryId").getSelectedRecord().code) : "";
        let subCat = (form.getField("subCategoryId").getSelectedRecord()) ? (form.getField("subCategoryId").getSelectedRecord().code) : "";
        switch (title) {
            case "تيمی , گروهی (سازمانی)":
                code.setValue("G" + cat + subCat);
                break;
            case "فردی (پستی)":
                code.setValue("P" + cat + subCat);
                break;
            // case "مدیریتی":
            //     code.setValue("M00000");
            //     break;
        }
    }

    function sendCompetenceToWorkflowV2(record,method){
        let param={}
        param.data={
            "processDefinitionKey": "تعریف شایستگی",
            "title": record.title + " شایستگی "
        }
        param.rq= {
            "id": method !== "POST" ? record.id : 0,
            "title": record.title,
            "competenceTypeId": record.competenceTypeId,
            "competenceLevelId": record.competenceLevelId,
            "competencePriorityId": record.competencePriorityId,
            "complex": record.complex,
            "active": record.active,
            "code": record.code,
            "categoryId": record.categoryId,
            "subCategoryId": record.subCategoryId,
            "description": record.description,
            "workFlowStatusCode": method !== "POST" ? 4 : 0,
        };
        wait.show()
        isc.RPCManager.sendRequest(TrDSRequest(bpmsWorkflowUrl + "/processes/start-data-validation", method, JSON.stringify(param), (resp)=>{
            wait.close()
            if (resp.httpResponseCode === 200) {
                CompetenceWin_competenceV2.close();
                refreshLG(CompetenceLG_competenceV2);
                simpleDialog("<spring:message code="message"/>", "<spring:message code='course.set.on.workflow.engine'/>", 3000, "say");
            } else if (resp.httpResponseCode === 404 || resp.httpResponseCode === 405 || resp.httpResponseCode === 406) {
                simpleDialog("<spring:message code="message"/>", JSON.parse(resp.httpResponseText).message, 3000, "stop");
            } else {
                simpleDialog("<spring:message code="message"/>", "<spring:message code='msg.send.to.workflow.problem'/>", 3000, "stop");
            }
        }));
    }
    function removeCompetenceToWorkflowV2(record,entityType){
                removeRecord(competenceUrl + "/" + record.id, entityType, record.title, 'CompetenceLG_competenceV2');
    }

    //</script>