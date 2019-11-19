<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    var All_Priorities_ValueMap_NASB = [];
    var Wait_NASB;
    var objectType_NASB = null;
    var objectId_NASB = null;
    var test;

    //////////////////////////////////////////////////////////
    ///////////////////////DataSource/////////////////////////
    /////////////////////////////////////////////////////////

    RestDataSource_All_Skills_NASB_JSP = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true, hidden: true},
                {name: "code", title: "<spring:message code='code'/>", filterOperator: "iContains", autoFitWidth: true},
                {name: "titleFa", title: "<spring:message code='title'/>", filterOperator: "iContains"}
            ],
        fetchDataURL: skillUrl + "spec-list"
    });

    restData_All_Jobs_NASB_JPA = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true, hidden: true},
                {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
                {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            ],
        fetchDataURL: jobUrl + "iscList"
    });

    restData_All_Posts_NASB_JPA = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true, hidden: true},
                {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", autoFitWidth: true},
                {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            ],
        fetchDataURL: postUrl + "iscList"
    });

    restData_All_JobGroups_NASB_JPA = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true, hidden: true},
                {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            ],
        fetchDataURL: jobGroupUrl + "spec-list"
    });

    restData_All_PostGroups_NASB_JPA = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true, hidden: true},
                {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            ],
        fetchDataURL: postGroupUrl + "spec-list"
    });

    restData_For_This_Object_Skills_NASB_JPA = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true, hidden: true},
                {name: "object", hidden: true},
                {name: "objectId", hidden: true},
                {name: "objectType", hidden: true},
                {name: "skill"},
                {name: "eneedAssessmentPriority"},
            ],
        fetchDataURL: needAssessmentSkillBasedUrl + "spec-list",
        // addDataURL: needAssessmentSkillBasedUrl,
        // updateDataURL: needAssessmentSkillBasedUrl + "edit",
        // removeDataURL: needAssessmentSkillBasedUrl,
        // DSDataFormat: "json",
        // operationBindings:[
        //     {operationType:"fetch", dataProtocol:"getParams", requestProperties:{httpMethod:"GET"}},
        //     {operationType:"add", dataProtocol:"postParams", requestProperties:{httpMethod:"POST"}},
        //     {operationType:"remove", dataProtocol:"getParams", requestProperties:{httpMethod:"DELETE"}},
        //     {operationType:"update", dataProtocol:"postParams", requestProperties:{httpMethod:"PUT"}}
        // ],
    });

    restData_Need_Assessment_Priority_NASB_JPA = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true, hidden: true},
                {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            ],
        fetchDataURL: enumUrl + "eNeedAssessmentPriority/spec-list"
    });

    //////////////////////////////////////////////////////////
    ////////////////////////////UI////////////////////////////
    /////////////////////////////////////////////////////////

    ListGrid_For_This_Object_Skills_NASB = isc.TrLG.create({
        dataSource: restData_For_This_Object_Skills_NASB_JPA,

        sortField: 1,

        selectionAppearance:"checkbox",

        showRowNumbers: false,

        showRecordComponents: true,
        showRecordComponentsByCell: true,

        groupByField: "objectType",
        groupStartOpen: "first",

        canDragResize: true,
        canDragRecordsOut: true,
        canAcceptDroppedRecords: true,
        dragTrackerMode: "title",

        canRemoveRecords: true,
        // deferRemoval: true,
        // warnOnRemoval: true,
        // warnOnRemovalMessage: "hamed",

        editByCell: true,
        // saveByCell: true,
        editEvent: "click",
        confirmDiscardEdits: false,
        confirmCancelEditing: false,
        modalEditing: true,
        autoSaveEdits: false,
        // saveEdits: function([editCompletionEvent, callback, rowNum])
        // saveAllEdits: function([rows, saveCallback])
        // getEditValues: function(valuesID)
        // getEditValue: function(rowNum, colNum)
        // getEditedCell: function(record, field)
        // getAllEditRows: function()
        // enterKeyEditAction: "done",
        // escapeKeyEditAction: "cancel",
        // discardEditsSaveButtonTitle: "اوکی",
        // confirmDiscardEditsMessage: "تغییرات ذخیره شود؟",
        // saveLocally: true,
        // editComplete: function(rowNum, colNum, newValues, oldValues, editCompletionEvent, dsResponse)
        // editFailed: function(rowNum, colNum, newValues, oldValues, editCompletionEvent, dsResponse)
        // editorExit: function(editCompletionEvent, record, newValue, rowNum, colNum)
        // endEditing: function()


        fields:
            [
                {name: "id", primaryKey: true, hidden: true},
                {
                    name: "skill.code",
                    title: "<spring:message code="code"/>",
                    filterOperator: "iContains",
                    width: "15%",
                    autoFitWidth: true
                },
                {
                    name: "skill.titleFa",
                    title: "<spring:message code="title"/>",
                    filterOperator: "iContains"
                },
                {
                    name: "object.titleFa",
                    hidden: true,
                },
                {
                    name: "objectType",
                    hidden: true,
                },
                {
                    name: "eneedAssessmentPriority.id",
                    type: "IntegerItem",
                    title: "اولویت",
                    editorType: "SelectItem",
                    displayField: "titleFa",
                    valueField: "id",
                    optionDataSource: restData_Need_Assessment_Priority_NASB_JPA,
                    addUnknownValues: false,
                    // cachePickListResults: false,
                    // sortField: ["id"],
                    pickListProperties: {
                        showFilterEditor: false
                    },
                    filterOperator: "iContains",
                    // canEdit: true,
                    pickListFields: [
                        {name: "titleFa", width: "30%", filterOperator: "iContains"}
                    ],
                    change: function(form, item, value){
                        ListGrid_For_This_Object_Skills_Edit_NASB(this.grid.getRecord(this.rowNum), value);
                    }
                }
            ],
        removeRecordClick: function (rowNum) {
            let deleting = [];
            deleting.add(this.getRecord(rowNum));
            ListGrid_For_This_Object_Skills_Remove_NASB(deleting);
        },
        recordDrop: function (dropRecords) {
            ListGrid_For_This_Object_Skills_Add_NASB(dropRecords);
        },
        canEditCell: function (rowNum, colNum) {
            let record = this.getRecord(rowNum),
                fieldName = this.getFieldName(colNum);
            return fieldName === "eneedAssessmentPriority.id" &&
                record.objectType === objectType_NASB;
        }

    });

    DynamicForm_For_This_Object_NASB_Jsp = isc.DynamicForm.create({
        numCols: 1,

        fields: [
            {
                name: "Left_LG_Title_NASB",
                type: "staticText",
                title: "نیازسنجی",
                titleAlign: "center",
                wrapTitle: false,
            },
        ]
    });

    VLayout_For_This_Object_NASB_JPA = isc.TrVLayout.create({
        members: [DynamicForm_For_This_Object_NASB_Jsp, ListGrid_For_This_Object_Skills_NASB]
    });

    DynamicForm_Buttons_NASB_JPA = isc.DynamicForm.create({
        width: "90%",
        numCols: 1,
        fields: [
            {
                type: "SpacerItem",
            },
            {
                name: "eneedAssessmentPriorityId",
                type: "IntegerItem",
                title: "اولویت پیش فرض",
                titleOrientation: "top",
                align: "center",
                textAlign: "center",
                editorType: "ComboBoxItem",
                defaultToFirstOption: true,
                displayField: "titleFa",
                valueField: "id",
                optionDataSource: restData_Need_Assessment_Priority_NASB_JPA,
                autoFetchData: true,
                addUnknownValues: false,
                cachePickListResults: false,
                sortField: ["id"],
                pickListProperties: {
                    showFilterEditor: false
                },
            },
            {
                type: "SpacerItem",
            },
            {
                name: "removeButton",
                type: "Button",
                title: "<<",
                align: "center",
                click: function(){
                    ListGrid_For_This_Object_Skills_Remove_NASB();
                }
            },
            {
                name: "addButton",
                type: "Button",
                title: ">>",
                align: "center",
                click: function(){
                    if(ListGrid_All_Skills_NASB.getSelectedRecords() === null || ListGrid_All_Skills_NASB.getSelectedRecords().length ===0)
                        return;
                    ListGrid_For_This_Object_Skills_Add_NASB(ListGrid_All_Skills_NASB.getSelectedRecords());
                }
            }
        ]
    });

    VLayout_Buttons_NASB_JPA = isc.TrVLayout.create({
        width: "150px",
        members: [DynamicForm_Buttons_NASB_JPA]
    });

    ListGrid_All_Skills_NASB = isc.TrLG.create({
        canDragResize: true,
        canDragRecordsOut: true,
        canAcceptDroppedRecords: true,
        dragTrackerMode: "title",
        autoFetchData: true,
        dataSource: RestDataSource_All_Skills_NASB_JSP,
        sortField: 1,
        showRowNumbers: false,
        selectionAppearance: "checkbox",
    });

    DynamicForm_All_Skills_NASB_Jsp = isc.DynamicForm.create({
        numCols: 1,
        fields: [
            {
                type: "staticText",
                name: "Right_LG_Title_NASB",
                title: "<spring:message code='skill'/>",
                titleAlign: "center",
                wrapTitle: false,
            },
        ]
    });

    VLayout_All_Skills_NASB_JPA = isc.TrVLayout.create({
        width: "50%",
        members: [DynamicForm_All_Skills_NASB_Jsp, ListGrid_All_Skills_NASB]
    });

    HLayout_Grids_NASB_JPA = isc.TrHLayout.create({
        members: [VLayout_All_Skills_NASB_JPA, VLayout_Buttons_NASB_JPA, VLayout_For_This_Object_NASB_JPA]
    });

    ListGrid_All_Jobs_NASB = isc.TrLG.create({
        autoFetchData: true,
        dataSource: restData_All_Jobs_NASB_JPA,
        sortField: 1,
        selectionType: "single",
        selectionUpdated: function () {
            Set_Left_LG_Title();
        }
    });

    ListGrid_All_Posts_NASB = isc.TrLG.create({
        autoFetchData: true,
        dataSource: restData_All_Posts_NASB_JPA,
        sortField: 1,
        selectionType: "single",
        selectionUpdated: function () {
            Set_Left_LG_Title();
        }
    });

    ListGrid_All_JobGroups_NASB = isc.TrLG.create({
        autoFetchData: true,
        dataSource: restData_All_JobGroups_NASB_JPA,
        selectionType: "single",
        sortField: 1,
        selectionUpdated: function () {
            Set_Left_LG_Title();
        }
    });

    ListGrid_All_PostGroups_NASB = isc.TrLG.create({
        autoFetchData: true,
        dataSource: restData_All_PostGroups_NASB_JPA,
        selectionType: "single",
        sortField: 1,
        selectionUpdated: function () {
            Set_Left_LG_Title();
        }
    });

    Tabset_Object_NASB_JPA = isc.TabSet.create({
        height: "190px",
        tabBarPosition: "right",
        tabBarThickness: 100,
        tabs: [
            {title: "<spring:message code="job"/>", pane: ListGrid_All_Jobs_NASB},
            {title: "<spring:message code="post"/>", pane: ListGrid_All_Posts_NASB},
            {title: "<spring:message code="job.group"/>", pane: ListGrid_All_JobGroups_NASB},
            {title: "<spring:message code="post.group"/>", pane: ListGrid_All_PostGroups_NASB}
        ],
        tabSelected: function (tabNum, tabPane, ID, tab, name) {
            Set_Left_LG_Title();
        }
    });

    ToolStripButton_Refresh_NASB = isc.TrRefreshBtn.create({
        click: function () {
            ListGrid_Top_refresh_NASB();
        }
    });

    ToolStrip_Actions_NASB = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStripButton_Refresh_NASB,
        ]
    });

    isc.TrVLayout.create({
        border: "2px solid blue",
        // membersMargin:10,
        members: [ToolStrip_Actions_NASB, Tabset_Object_NASB_JPA, HLayout_Grids_NASB_JPA],
    });


    ////////////////////////////////////////////////////////////////
    ////////////////////////////functions///////////////////////////
    ///////////////////////////////////////////////////////////////

    function ListGrid_Top_refresh_NASB() {
        let selectedListGrid;
        switch (Tabset_Object_NASB_JPA.getSelectedTabNumber()) {
            case 0:
                selectedListGrid = ListGrid_All_Jobs_NASB;
                break;
            case 1:
                selectedListGrid = ListGrid_All_Posts_NASB;
                break;
            case 2:
                selectedListGrid = ListGrid_All_JobGroups_NASB;
                break;
            case 3:
                selectedListGrid = ListGrid_All_PostGroups_NASB;
                break;
        }
        let record = selectedListGrid.getSelectedRecord();
        if (record != null && record.id != null) {
            selectedListGrid.selectRecord(record);
        }
        selectedListGrid.invalidateCache();
        selectedListGrid.filterByEditor();
        Set_Left_LG_Title();
    }

    function ListGrid_For_This_Object_Skills_Edit_NASB(record, newValue) {
        Wait_NASB = createDialog('wait');
        let Editing_NASB = {
            "skillId": record.skill.id,
            "objectId": objectId_NASB,
            "objectType": objectType_NASB,
            "eneedAssessmentPriorityId": newValue
        };
        isc.RPCManager.sendRequest(TrDSRequest(needAssessmentSkillBasedUrl + record.id,
            "PUT", JSON.stringify(Editing_NASB), "callback: Edit_Result_NASB(rpcResponse)"));
    }

    function Edit_Result_NASB(resp) {
        Wait_NASB.close();
        if(resp.httpResponseCode !== 200 && resp.httpResponseCode !== 201){
            let respText = resp.httpResponseText;
            if (resp.httpResponseCode === 406 && respText === "DuplicateRecord") {
                createDialog("info", "<spring:message code="msg.record.duplicate"/>",
                    "<spring:message code="message"/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>",
                    "<spring:message code="message"/>");
            }
        }
    }

    function ListGrid_For_This_Object_Skills_Remove_NASB(records) {
        if (records == null)
            records = ListGrid_For_This_Object_Skills_NASB.getSelectedRecords();
        if (records == null || records.length === 0) {
            createDialog("info", "<spring:message code='msg.not.selected.record'/>");
        } else {
            var Dialog_remove_NASB = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code='global.warning'/>");
            Dialog_remove_NASB.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        Wait_NASB = createDialog("wait");
                        let Deleting_NASB = [];
                        for (let i = 0; i < records.length; i++) {
                            Deleting_NASB.add(records[i].id);
                        }
                        isc.RPCManager.sendRequest(TrDSRequest(needAssessmentSkillBasedUrl + "list",
                            "DELETE", JSON.stringify(Deleting_NASB), "callback: Remove_Result_NASB(rpcResponse)"));
                    }
                }
            });
        }
    }

    function Remove_Result_NASB(resp) {
        Wait_NASB.close();
        <%--if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {--%>
        <%--    ListGrid_For_This_Object_Skills_NASB.invalidateCache();--%>
        <%--    ListGrid_For_This_Object_Skills_NASB.filterByEditor();--%>
        <%--    var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",--%>
        <%--        "<spring:message code="msg.command.done"/>");--%>
        <%--    setTimeout(function () {--%>
        <%--        OK.close();--%>
        <%--    }, 2000);--%>
        <%--} else {--%>
        <%--    let respText = resp.httpResponseText;--%>
        <%--    if (resp.httpResponseCode === 406 && respText === "NotDeletable") {--%>
        <%--        createDialog("info", "<spring:message code='msg.record.cannot.deleted'/>");--%>
        <%--    } else {--%>
        <%--        createDialog("info", "<spring:message code="msg.operation.error"/>");--%>
        <%--    }--%>
        <%--}--%>
    }

    function ListGrid_For_This_Object_Skills_Add_NASB(Records) {
        if (objectType_NASB === null || objectId_NASB === null) {
            createDialog("info", "رکوردی از جدول بالا انتخاب نشده است.");
            return;
        }
        let Adding_NASB = [];
        Wait_NASB = createDialog("wait");
        for (let i = 0; i < Records.getLength(); i++) {
            Adding_NASB.add({
                "skillId": Records[i].id,
                "objectId": objectId_NASB,
                "objectType": objectType_NASB,
                "eneedAssessmentPriorityId": DynamicForm_Buttons_NASB_JPA.getItem("eneedAssessmentPriorityId").getSelectedRecord().id
            });
        }
        isc.RPCManager.sendRequest(TrDSRequest(needAssessmentSkillBasedUrl + "add-all",
            "POST", JSON.stringify(Adding_NASB), "callback: Add_Result_NASB(rpcResponse)"));
    }

    function Add_Result_NASB(resp) {
        Wait_NASB.close();
        test = resp;
        // console.log(resp.httpResponseText);
        ListGrid_For_This_Object_Skills_NASB.invalidateCache();
        ListGrid_For_This_Object_Skills_NASB.filterByEditor();
        // if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
        //     ListGrid_For_This_Object_Skills_NASB.invalidateCache();
        <%--    let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",--%>
        <%--        "<spring:message code="msg.command.done"/>");--%>
        <%--    ListGrid_For_This_Object_Skills_NASB.setData([]);--%>
        <%--    setTimeout(function () {--%>
        <%--        OK.close();--%>
        <%--    }, 2000);--%>
        <%--} else {--%>
        <%--    let respText = resp.httpResponseText;--%>
        <%--    if (resp.httpResponseCode === 406 && respText === "NotDeletable") {--%>
        <%--        createDialog("info", "<spring:message code='msg.record.cannot.deleted'/>");--%>
        <%--    } else {--%>
        <%--        createDialog("info", "<spring:message code="msg.operation.error"/>");--%>
        <%--    }--%>
        <%--}--%>
    }

    function Set_Left_LG_Title() {
        switch (Tabset_Object_NASB_JPA.getSelectedTabNumber()) {
            case 0:
                objectType_NASB = "Job";
                if (ListGrid_All_Jobs_NASB.getSelectedRecord() === null) {
                    objectId_NASB = null;
                } else {
                    objectId_NASB = ListGrid_All_Jobs_NASB.getSelectedRecord().id;
                    DynamicForm_For_This_Object_NASB_Jsp.getItem("Left_LG_Title_NASB").title = "نیازسنجی شغل " +
                        getFormulaMessage(ListGrid_All_Jobs_NASB.getSelectedRecord().titleFa, 2, "red", "b");
                }
                break;
            case 1:
                objectType_NASB = "Post";
                if (ListGrid_All_Posts_NASB.getSelectedRecord() === null) {
                    objectId_NASB = null;
                } else {
                    objectId_NASB = ListGrid_All_Posts_NASB.getSelectedRecord().id;
                    DynamicForm_For_This_Object_NASB_Jsp.getItem("Left_LG_Title_NASB").title = "نیازسنجی پست " +
                        getFormulaMessage(ListGrid_All_Posts_NASB.getSelectedRecord().titleFa, 2, "red", "b");
                }
                break;
            case 2:
                objectType_NASB = "JobGroup";
                if (ListGrid_All_JobGroups_NASB.getSelectedRecord() === null) {
                    objectId_NASB = null;
                } else {
                    objectId_NASB = ListGrid_All_JobGroups_NASB.getSelectedRecord().id;
                    DynamicForm_For_This_Object_NASB_Jsp.getItem("Left_LG_Title_NASB").title = "نیازسنجی گروه شغلی " +
                        getFormulaMessage(ListGrid_All_JobGroups_NASB.getSelectedRecord().titleFa, 2, "red", "b");
                }
                break;
            case 3:
                objectType_NASB = "PostGroup";
                if (ListGrid_All_PostGroups_NASB.getSelectedRecord() === null) {
                    objectId_NASB = null;
                } else {
                    objectId_NASB = ListGrid_All_PostGroups_NASB.getSelectedRecord().id;
                    DynamicForm_For_This_Object_NASB_Jsp.getItem("Left_LG_Title_NASB").title = "نیازسنجی گروه پستی " +
                        getFormulaMessage(ListGrid_All_PostGroups_NASB.getSelectedRecord().titleFa, 2, "red", "b");
                }
                break;
        }
        ListGrid_For_This_Object_Skills_NASB.setImplicitCriteria({
            "objectType": objectType_NASB
        });
        if (objectId_NASB === null) {
            DynamicForm_For_This_Object_NASB_Jsp.getItem("Left_LG_Title_NASB").title = "نیازسنجی";
            ListGrid_For_This_Object_Skills_NASB.setData([]);
        } else {
            ListGrid_For_This_Object_Skills_NASB.fetchData({
                "objectId": objectId_NASB,
                "objectType": objectType_NASB
            });
        }
        DynamicForm_For_This_Object_NASB_Jsp.getItem("Left_LG_Title_NASB").redraw();
    }

    // </script>