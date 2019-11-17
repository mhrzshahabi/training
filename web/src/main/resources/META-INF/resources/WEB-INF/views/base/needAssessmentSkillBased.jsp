<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    var All_Priorities;

    //////////////////////////////////////////////////////////
    ///////////////////////DataSource/////////////////////////
    /////////////////////////////////////////////////////////

    RestDataSource_All_Skills_NASB_JSP = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true, hidden: true},
                {name: "code", title: "<spring:message code='code'/>", filterOperator: "iContains"},
                {name: "titleFa", title: "<spring:message code='title'/>", filterOperator: "iContains"}
            ],
        fetchDataURL: skillUrl + "spec-list"
    });

    restData_All_Jobs_NASB_JPA = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true, hidden: true},
                {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", width: "15%"},
                {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            ],
        fetchDataURL: jobUrl + "iscList"
    });

    restData_All_Posts_NASB_JPA = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true, hidden: true},
                {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains", width: "15%"},
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
                // {name: "object", hidden: true},
                {name: "objectId", hidden: true},
                {name: "objectType", hidden: true},
                {name: "skill.titleFa"},
                {name: "skill.code"},
                {name: "eneedAssessmentPriority.titleFa"},
            ],
        fetchDataURL: needAssessmentSkillBasedUrl + "iscList"
    });

    isc.RPCManager.sendRequest(TrDSRequest(enumUrl + "eNeedAssessmentPriority/spec-list", "GET", null,
        "callback: All_Priority_Result_NASB_JPA(rpcResponse)"));

    function All_Priority_Result_NASB_JPA(resp){
        All_Priorities = (JSON.parse(resp.data)).response.data;
        for (let i = 0; i < All_Priorities.length; i++) {
            delete(All_Priorities[i].id);
            delete(All_Priorities[i].literal);
        }
    }

    //////////////////////////////////////////////////////////
    ////////////////////////////UI////////////////////////////
    /////////////////////////////////////////////////////////

    ListGrid_For_This_Object_Skills_NASB = isc.TrLG.create({
        dataSource: restData_For_This_Object_Skills_NASB_JPA,
        sortField: 1,
        showRowNumbers: false,
        canDragRecordsOut: true,
        canAcceptDroppedRecords: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
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
                {name: "skill.titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
                {name: "eneedAssessmentPriority.titleFa", title: "اولویت", type: "SelectItem", filterOperator: "iContains", canEdit: true, valueMap: ["عملکردی ضروری", "11111" , "222222"]},
                {
                    name: "OnDelete",
                    title: "<spring:message code='global.form.remove'/>",
                    align: "center",
                    canFilter: false,
                    autoFitWidth: true
                }
            ],

        createRecordComponent: function (record, colNum) {
            let fieldName = this.getFieldName(colNum);
            if (fieldName === "OnDelete") {
                let recordCanvas = isc.HLayout.create({
                    height: 20,
                    width: "100%",
                    layoutMargin: 5,
                    membersMargin: 10,
                    align: "center"
                });
                let removeIcon = isc.ImgButton.create({
                    showDown: false,
                    showRollOver: false,
                    layoutAlign: "center",
                    src: "<spring:url value='remove.png'/>",
                    height: 16,
                    width: 16,
                    grid: this,
                    // click: function () {
                    //     var activePostGradeGroup = ListGrid_Post_Grade_Group_Jsp.getSelectedRecord();
                    //     isc.RPCManager.sendRequest(TrDSRequest(postGradeGroupUrl + "removePostGrades/" + activePostGradeGroup.id + "/" + [record.id],
                    //         "DELETE", null, "callback: postGrade_remove_result(rpcResponse)"));
                    // }
                });
                recordCanvas.addMember(removeIcon);
                return recordCanvas;
            } else
                return null;
        },
    });

    DynamicForm_For_This_Object_NASB_Jsp = isc.DynamicForm.create({
        numCols: 3,
        fields: [
            {
                type: "SpacerItem",
            },
            {
                name: "Left_LG_Title_NASB",
                type: "staticText",
                wrapTitle: false,
            },
        ]
    });

    VLayout_For_This_Object_NASB_JPA = isc.TrVLayout.create({
        members: [DynamicForm_For_This_Object_NASB_Jsp, ListGrid_For_This_Object_Skills_NASB]
    });

    ListGrid_All_Skills_NASB = isc.TrLG.create({
        autoFetchData: true,
        dataSource: RestDataSource_All_Skills_NASB_JSP,
        sortField: 1,
        showRowNumbers: false,
    });

    DynamicForm_All_Skills_NASB_Jsp = isc.DynamicForm.create({
        numCols: 3,
        fields: [
            {
                type: "SpacerItem",
            },
            {
                // name: "Right_LG_Title_NASB",
                type: "staticText",
                title: "<spring:message code='skill'/>",
                wrapTitle: false,
            },
        ]
    });

    VLayout_All_Skills_NASB_JPA = isc.TrVLayout.create({
        members: [DynamicForm_All_Skills_NASB_Jsp, ListGrid_All_Skills_NASB]
    });

    HLayout_Grids_NASB_JPA = isc.TrHLayout.create({
        members: [VLayout_All_Skills_NASB_JPA, VLayout_For_This_Object_NASB_JPA]
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

    function Set_Left_LG_Title() {
        switch (Tabset_Object_NASB_JPA.getSelectedTabNumber()) {
            case 0:
                ListGrid_For_This_Object_Skills_NASB.setImplicitCriteria({
                    "objectType": "Job"
                });
                if (ListGrid_All_Jobs_NASB.getSelectedRecord() === null) {
                    DynamicForm_For_This_Object_NASB_Jsp.getItem("Left_LG_Title_NASB").title = "";
                    ListGrid_For_This_Object_Skills_NASB.setData([]);
                } else {
                    DynamicForm_For_This_Object_NASB_Jsp.getItem("Left_LG_Title_NASB").title = "نیازسنجی شغل " + getFormulaMessage(ListGrid_All_Jobs_NASB.getSelectedRecord().titleFa, 2, "red", "b");
                    ListGrid_For_This_Object_Skills_NASB.fetchData({
                        "objectId": ListGrid_All_Jobs_NASB.getSelectedRecord().id,
                        "objectType": "Job"
                    });
                }
                break;
            case 1:
                ListGrid_For_This_Object_Skills_NASB.setImplicitCriteria({
                    "objectType": "Post"
                });
                if (ListGrid_All_Posts_NASB.getSelectedRecord() === null) {
                    DynamicForm_For_This_Object_NASB_Jsp.getItem("Left_LG_Title_NASB").title = "";
                    ListGrid_For_This_Object_Skills_NASB.setData([]);
                } else {
                    DynamicForm_For_This_Object_NASB_Jsp.getItem("Left_LG_Title_NASB").title = "نیازسنجی پست " + getFormulaMessage(ListGrid_All_Posts_NASB.getSelectedRecord().titleFa, 2, "red", "b");
                    ListGrid_For_This_Object_Skills_NASB.fetchData({
                        "objectId": ListGrid_All_Posts_NASB.getSelectedRecord().id,
                        "objectType": "Post"
                    });
                }
                break;
            case 2:
                ListGrid_For_This_Object_Skills_NASB.setImplicitCriteria({
                    "objectType": "JobGroup"
                });
                if (ListGrid_All_JobGroups_NASB.getSelectedRecord() === null) {
                    DynamicForm_For_This_Object_NASB_Jsp.getItem("Left_LG_Title_NASB").title = "";
                    ListGrid_For_This_Object_Skills_NASB.setData([]);
                } else {
                    DynamicForm_For_This_Object_NASB_Jsp.getItem("Left_LG_Title_NASB").title = "نیازسنجی گروه شغلی " + getFormulaMessage(ListGrid_All_JobGroups_NASB.getSelectedRecord().titleFa, 2, "red", "b");
                    ListGrid_For_This_Object_Skills_NASB.fetchData({
                        "objectId": ListGrid_All_JobGroups_NASB.getSelectedRecord().id,
                        "objectType": "JobGroup"
                    });
                }
                break;
            case 3:
                ListGrid_For_This_Object_Skills_NASB.setImplicitCriteria({
                    "objectType": "PostGroup"
                });
                if (ListGrid_All_PostGroups_NASB.getSelectedRecord() === null) {
                    DynamicForm_For_This_Object_NASB_Jsp.getItem("Left_LG_Title_NASB").title = "";
                    ListGrid_For_This_Object_Skills_NASB.setData([]);
                } else {
                    DynamicForm_For_This_Object_NASB_Jsp.getItem("Left_LG_Title_NASB").title = "نیازسنجی گروه پستی " + getFormulaMessage(ListGrid_All_PostGroups_NASB.getSelectedRecord().titleFa, 2, "red", "b");
                    ListGrid_For_This_Object_Skills_NASB.fetchData({
                        "objectId": ListGrid_All_PostGroups_NASB.getSelectedRecord().id,
                        "objectType": "PostGroup"
                    });
                }
                break;
        }
        DynamicForm_For_This_Object_NASB_Jsp.getItem("Left_LG_Title_NASB").redraw();
    }

    // </script>


<%--NeedAssessmentDF_First = isc.DynamicForm.create({--%>
<%--    numCols: 8,--%>
<%--    margin: 20,--%>
<%--    border: "2px solid blue",--%>
<%--    fields: [--%>
<%--        {--%>
<%--            type: "SpacerItem",--%>
<%--            colSpan: 2--%>
<%--        },--%>
<%--        {--%>
<%--            name: "objectType",--%>
<%--            type: "radioGroup",--%>
<%--            showTitle: false,--%>
<%--            valueMap: ["شغل", "گروه شغلی", "پست", "گروه پستی"],--%>
<%--            defaultValue: "شغل",--%>
<%--            change: function (form, item, value) {--%>
<%--                if (value === "شغل") {--%>
<%--                    // form.getField("GroupObjectCombo").setValue("");--%>
<%--                    form.getField("GroupObjectCombo").clearValue();--%>
<%--                    form.getField("GroupObjectCombo").hide();--%>
<%--                    form.getField("objectCombo").show();--%>
<%--                    restData_Object_NASB_JPA.fetchDataURL = jobUrl + "iscList";--%>
<%--                    form.getField("objectCombo").fetchData();--%>
<%--                } else if (value === "پست") {--%>
<%--                    // form.getField("GroupObjectCombo").setValue("");--%>
<%--                    form.getField("GroupObjectCombo").clearValue();--%>
<%--                    form.getField("GroupObjectCombo").hide();--%>
<%--                    form.getField("objectCombo").show();--%>
<%--                    restData_Object_NASB_JPA.fetchDataURL = postUrl + "iscList";--%>
<%--                    form.getField("objectCombo").fetchData();--%>
<%--                } else if (value === "گروه شغلی") {--%>
<%--                    // form.getField("objectCombo").setValue("");--%>
<%--                    form.getField("objectCombo").clearValue();--%>
<%--                    form.getField("objectCombo").hide();--%>
<%--                    form.getField("GroupObjectCombo").show();--%>
<%--                    restData_ObjectGroup_NASB_JPA.fetchDataURL = jobGroupUrl + "spec-list";--%>
<%--                    form.getField("GroupObjectCombo").fetchData();--%>
<%--                } else if (value === "گروه پستی") {--%>
<%--                    // form.getField("objectCombo").setValue("");--%>
<%--                    form.getField("objectCombo").clearValue();--%>
<%--                    form.getField("objectCombo").hide();--%>
<%--                    form.getField("GroupObjectCombo").show();--%>
<%--                    restData_ObjectGroup_NASB_JPA.fetchDataURL = postGroupUrl + "spec-list";--%>
<%--                    form.getField("GroupObjectCombo").fetchData();--%>
<%--                }--%>
<%--            },--%>
<%--            align: "center",--%>
<%--        },--%>
<%--        {--%>
<%--            name: "GroupObjectCombo",--%>
<%--            type: "TrComboAutoRefresh",--%>
<%--            hidden: true,--%>
<%--            showTitle: false,--%>
<%--            align: "center",--%>
<%--            optionDataSource: restData_ObjectGroup_NASB_JPA,--%>
<%--            autoFetchData: false,--%>
<%--            addUnknownValues: false,--%>
<%--            displayField: "titleFa",--%>
<%--            valueField: "id",--%>
<%--            // filterFields: ["titleFa", "id"],--%>
<%--            colSpan: 3,--%>
<%--            &lt;%&ndash;pickListFields: [&ndash;%&gt;--%>
<%--            &lt;%&ndash;    {name: "titleFa", title: "<spring:message code="title"/>"}&ndash;%&gt;--%>
<%--            &lt;%&ndash;]&ndash;%&gt;--%>
<%--        },--%>
<%--        {--%>
<%--            name: "objectCombo",--%>
<%--            type: "TrComboAutoRefresh",--%>
<%--            showTitle: false,--%>
<%--            align: "center",--%>
<%--            optionDataSource: restData_Object_NASB_JPA,--%>
<%--            autoFetchData: false,--%>
<%--            addUnknownValues: false,--%>
<%--            displayField: "titleFa",--%>
<%--            valueField: "id",--%>
<%--            filterFields: ["titleFa", "code"],--%>
<%--            colSpan: 3,--%>
<%--            pickListFields: [--%>
<%--                {name: "titleFa"},--%>
<%--                {name: "code"}--%>
<%--            ]--%>

<%--        },--%>
<%--    ]--%>
<%--});--%>