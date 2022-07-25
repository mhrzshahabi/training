<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    let batch = true;

    // <<----------------------------------------- Create - TreeGrid --------------------------------------------

    var operationalSearchTree = isc.TreeGrid.create({
        ID: "operationalSearchTree",
        data:[],
        fields: [
            {name: "title", title: "موارد جستجو شده", width:"75%"},
            {name: "code", title: "کد", width:"25%"},
        ],
        canDragRecordsOut: true,
        width: "100%",
        height: "30%",
        autoDraw: false,
        showOpenIcons:false,
        showDropIcons:false,
        showSelectedIcons:false,
        showConnectors: true,
        dataProperties:{
            dataArrived:function (parentNode) {
                this.openAll();
            }
        },
        rowClick: function (record, recordNum, fieldNum) {
        },
        rowDoubleClick: function(record, recordNum, fieldNum) {
        }
    });

    var operationalTree = isc.TreeGrid.create({
        ID: "operationalTree",
        data:[],
        fields: [
            {name: "title", title: "درخت کامل", width:"75%", },
            {name: "code", title: "کد", width:"25%"},
        ],
        canDragRecordsOut: true,
        width: "100%",
        height: "70%",
        autoDraw: false,
        showOpenIcons:false,
        showDropIcons:false,
        showSelectedIcons:false,
        showConnectors: true,
        dataProperties:{
            dataArrived:function (parentNode) {
                this.openAll();
            }
        },
        rowDoubleClick: function(record, recordNum, fieldNum) {
        },
        openFolder:function () {
            openDepFolder(this);
            this.Super("openFolder",arguments);
        }
    });

    // <<-------------------------------------- Create - DynamicForm & Window ---------------------------------

    var search_bar = isc.DynamicForm.create({
        autoDraw: false,
        numCols: 3,
        items: [
            {
                name: "search",
                title: "جستجو در عناوین",
                width: 400,
                suppressBrowserClearIcon: true,
                icons: [
                    {
                        name: "view",
                        src: "[SKINIMG]actions/view.png",
                        hspace: 5,
                        inline: true,
                        baseStyle: "roundedTextItemIcon",
                        showRTL: true,
                        tabIndex: -1,
                        click: function () {
                            getSearchData(search_bar.getValues().search);
                        }
                    }, {
                        name: "clear",
                        src: "[SKINIMG]actions/close.png",
                        width: 10,
                        height: 10,
                        inline: true,
                        prompt: "Clear this field",

                        click: function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();
                        }
                    }],
                iconWidth: 16,
                iconHeight: 16
            },
            {
                type: "Button",
                title: "<spring:message code="refresh"/>",
                startRow: false,
                align:"left",
                click: function () {
                    search_bar.getField("search").getIcon("clear").click(search_bar,search_bar.getField("search"));
                    operationalSearchTree.setData([]);
                    operationalTree.setData([]);
                    getTreeData();
                }
            }
        ],
        itemKeyPress: function (item, keyName) {
            if (keyName === "Enter") {
                getSearchData(search_bar.getValues().search);
            }
        }
    });

    // <<------------------------------------------- Create - Layout ------------------------------------------

    var VLayout_operationalTree = isc.VLayout.create({
        height: "50%",
        showResizeBar: false,
        members: [operationalTree]
    });

    var VLayout_operationalSearchTree = isc.VLayout.create({
        showResizeBar: true,
        members: [operationalSearchTree]
    });

    /////////////////////////////////////
    ////////////////////////////////////
    let ToolStripButton_Refresh_JspOperationalChart = isc.ToolStripButtonRefresh.create({
        click: function () {
            refreshLG(ListGrid_JspOperationalChart);
        }
    });

    let ToolStripButton_Edit_JspOperationalChart = isc.ToolStripButtonEdit.create({
        click: function () {
            let record = ListGrid_JspOperationalChart.getSelectedRecord();
            selected_record = record;
            if (record == null || record.id == null) {
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
            } else {
                // PostDS_OperationalRole.fetchDataURL = viewTrainingPostUrl + "/rolePostList/" + record.id;
                ListGrid_OperationalChart_Edit(selected_record);
            }
        }
    });
    let ToolStripButton_Add_JspOperationalChart = isc.ToolStripButtonCreate.create({
        click: function () {
            // PostDS_OperationalRole.fetchDataURL = viewTrainingPostUrl + "/rolePostList/" + 0;
            ListGrid_OperationalChart_Add();
        }
    });
    let ToolStripButton_Remove_JspOperationalChart = isc.ToolStripButtonRemove.create({
        click: function () {
            ListGrid_OperationalChart_Remove();
        }
    });

    let ToolStrip_Actions_JspOperationalChart = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members:
            [
                ToolStripButton_Add_JspOperationalChart,
                ToolStripButton_Edit_JspOperationalChart,
                ToolStripButton_Remove_JspOperationalChart,
                // DynamicForm_departmentFilter_Filter,
                isc.ToolStrip.create({
                    width: "100%",
                    align: "left",
                    border: '0px',
                    members: [
                        ToolStripButton_Refresh_JspOperationalChart
                    ]
                })
            ]
    });

    let Menu_JspOperationalChart = isc.Menu.create({
        data: [{
            title: "<spring:message code='refresh'/>", click: function () {
                refreshLG(ListGrid_JspOperationalChart);
            }
        }, {
            title: "<spring:message code='create'/>", click: function () {
                // PostDS_OperationalChart.fetchDataURL = viewPostUrl+"/rolePostList/0";
                // PostDS_OperationalRole.fetchDataURL = viewTrainingPostUrl + "/rolePostList/" + 0;
                ListGrid_OperationalChart_Add();
            }
        }, {
            title: "<spring:message code='edit'/>", click: function () {
                let record = ListGrid_JspOperationalChart.getSelectedRecord();
                selected_record = record;
                // PostDS_OperationalRole.fetchDataURL = viewPostUrl + "/rolePostList/" + record.id;
                // PostDS_OperationalRole.fetchDataURL = viewTrainingPostUrl + "/rolePostList/" + record.id;
                ListGrid_OperationalChart_Edit(selected_record);
            }
        }, {
            title: "<spring:message code='remove'/>", click: function () {
                ListGrid_OperationalChart_Remove();
            }
        },
        ]
    });

    let RestDataSource_JspOperationalChart = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true},
                {name: "code"},
                {name: "title"},
                {name: "description"},
                {name: "operationalUnit.operationalUnit"},
                {name: "userIds", title: "<spring:message code="post"/>", filterOperator: "inSet"},
                {name: "postIds", title: "<spring:message code="users"/>", filterOperator: "inSet"},
                {name: "complexId"}
            ],
    });

    let ListGrid_JspOperationalChart = isc.TrLG.create({
        dataSource: RestDataSource_JspOperationalChart,
        contextMenu: Menu_JspOperationalChart,
        sortField: 0,
        sortDirection: "descending",
        dataPageSize: 50,
        autoFetchData: false,
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        filterUsingText: "<spring:message code='filterUsingText'/>",
        groupByText: "<spring:message code='groupByText'/>",
        freezeFieldText: "<spring:message code='freezeFieldText'/>",
        align: "center",
        fields: [
            {
                name: "title",
                title: "<spring:message code="title"/>",
                filterOperator: "iContains"
            },
            {
                name: "code",
                title: "<spring:message code="code"/>",
                filterOperator: "iContains"
            },
            {
                name: "operationalUnit.operationalUnit",
                title: "<spring:message code="unitName"/>",
                filterOperator: "iContains"
            },
            {
                name: "description",
                title: "<spring:message code="description"/>",
                filterOperator: "iContains"
            },
            {
                name: "userIds",
                type: "selectItem",
                title: "<spring:message code="users"/>",
                filterOperator: "inSet",
                // optionDataSource: UserDS_JspOperationalRole,
                valueField: "id",
                displayField: "lastName",
                filterField: "lastName",
                filterOnKeypress: true,
                multiple: true,
                canSort: false,
                pickListProperties: {
                    showFilterEditor: true
                },
                pickListFields: [
                    {
                        name: "firstName",
                        title: "<spring:message code="firstName"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "lastName",
                        title: "<spring:message code="lastName"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "username",
                        title: "<spring:message code="username"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    },
                    {
                        name: "nationalCode",
                        title: "<spring:message code="national.code"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    }
                ]
            }
        ],
        rowDoubleClick: function (record) {
            // PostDS_OperationalRole.fetchDataURL = viewTrainingPostUrl + "/rolePostList/" + record.id;
            selected_record = record;
            ListGrid_OperationalChart_Edit(selected_record);
        },
        filterEditorSubmit: function () {
            ListGrid_JspOperationalChart.invalidateCache();
        }
    });

    let VLayout_Body_JspOperationalChart = isc.TrVLayout.create({
        height: "50%",
        showResizeBar: true,
        members: [
            ToolStrip_Actions_JspOperationalChart,
            ListGrid_JspOperationalChart,
        ]
    });


    function ListGrid_OperationalChart_Add() {
        methodOperationalChart = "POST";
        // ListGrid_Post_OperationalRole.invalidateCache();
        // PostDS_OperationalRole.fetchDataURL = viewPostUrl + "/rolePostList/";
        saveActionUrlOperationalChart = operationalChartUrl;
        DynamicForm_JspOperationalChart.clearValues();
        Window_JspOperationalChart.show();
    }

    function ListGrid_OperationalChart_Edit(record) {
        // ListGrid_Post_OperationalRole.invalidateCache();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            // PostDS_just_Show_OperationalRole.fetchDataURL = viewTrainingPostUrl + "/roleUsedPostList/" + record.id;
            methodOperationalChart = "PUT";
            // PostDS_OperationalRole.fetchDataURL = viewPostUrl + "/iscList";
            saveActionUrlOperationalChart = operationalChartUrl + "/" + record.id;
            DynamicForm_JspOperationalChart.clearValues();
            DynamicForm_JspOperationalChart.editRecord(record);
            var categoryIds = selected_record.categories;
            var subCategoryIds = selected_record.subCategories;
            if (categoryIds === null || categoryIds.length === 0)
                DynamicForm_JspOperationalChart.getField("subCategories").disable();
            else {
                DynamicForm_JspOperationalChart.getField("subCategories").enable();
                var catIds = [];
                for (let i = 0; i < categoryIds.length; i++)
                    catIds.add(categoryIds[i].id);
                DynamicForm_JspOperationalChart.getField("categories").setValue(catIds);
                hasChartCategoriesChanged = true;
                DynamicForm_JspOperationalChart.getField("subCategories").focus(null, null);
            }
            if (subCategoryIds != null && subCategoryIds.length > 0) {
                var subCatIds = [];
                for (let i = 0; i < subCategoryIds.length; i++)
                    subCatIds.add(subCategoryIds[i].id);
                DynamicForm_JspOperationalChart.getField("subCategories").setValue(subCatIds);
            }
            Window_JspOperationalChart.show();
        }
    }

    function OperationalChart_save_result(resp) {
        wait_Permission.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
            refreshLG(ListGrid_JspOperationalChart);
            Window_JspOperationalChart.close();
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            if (resp.httpResponseCode === 406 && resp.httpResponseText === "DuplicateRecord") {
                createDialog("info", "<spring:message code="msg.record.duplicate"/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>");
            }
        }
    }

    function ListGrid_OperationalChart_Remove() {
        let recordIds = ListGrid_JspOperationalChart.getSelectedRecords().map(r => r.id);
        if (recordIds == null || recordIds.length === 0) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
            let Dialog_Delete = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code='verify.delete'/>");
            Dialog_Delete.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        wait_Permission = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(operationalChartUrl + "/" + recordIds,
                            "DELETE",
                            null,
                            OperationalChart_remove_result));
                    }
                }
            });
        }
    }

    let RestDataSource_JspOperationalUnit = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true},
                {name: "unitCode"},
                {name: "operationalUnit"}
            ],
        fetchDataURL: operationalUnitUrl + "spec-list"
    });

    var IButton_Save_JspOperationalChart = isc.IButtonSave.create({
        top: 260,
        click: function () {
            if (!DynamicForm_JspOperationalChart.validate())
                return;
            if (!DynamicForm_JspOperationalChart.valuesHaveChanged()) {
                Window_JspOperationalChart.close();
                return;
            }
            wait_Permission = createDialog("wait");
            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlOperationalChart,
                methodOperationalChart,
                JSON.stringify(DynamicForm_JspOperationalChart.getValues()),
                OperationalChart_save_result));
        }
    });

    let IButton_Cancel_JspOperationalChart = isc.IButtonCancel.create({
        click: function () {
            DynamicForm_JspOperationalChart.clearValues();
            Window_JspOperationalChart.close();
        }
    });

    let HLayout_SaveOrExit_JspOperationalChart = isc.TrHLayoutButtons.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        padding: 10,
        members: [IButton_Save_JspOperationalChart, IButton_Cancel_JspOperationalChart]
    });

    let DynamicForm_JspOperationalChart = isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        titleAlign: "left",
        fields: [
            {name: "id", hidden: true},
            {
                name: "title",
                title: "<spring:message code="title"/>",
                required: true,
                validateOnExit: true,
                length: 255
            },
            {
                name: "complexId",
                editorType: "ComboBoxItem",
                title: "<spring:message code="complex"/>:",
                pickListWidth: 200,
                // optionDataSource: RestDataSource_OperationalRole_Department_Filter,
                displayField: "title",
                autoFetchData: true,
                valueField: "id",
                textAlign: "center",
                required: true,
                textMatchStyle: "substring",
                pickListFields: [
                    {name: "title", autoFitWidth: true, autoFitWidthApproach: true},
                ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: false
                },
            },
            {
                name: "operationalUnitId",
                title: "<spring:message code="unitName"/>",
                optionDataSource: RestDataSource_JspOperationalUnit,
                valueField: "id",
                displayField: "operationalUnit",
                required: true,
                validateOnExit: true,
                length: 255,
                canSort: false,
            },
            {
                name: "categories",
                title: "<spring:message code='educational.category'/>",
                // editorType: "MultiComboBoxItem",
                length: 255,
                type: "SelectItem",

                pickListWidth: 200,
                multiple: true,
                textAlign: "center",
                autoFetchData: false,
                // optionDataSource: RestDataSource_Categories_OperationalRole,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                operator: "inSet",
                // filterOnKeypress: true,
                autoFitButtons: true,
                titleVAlign: "top",
                pickListProperties: {
                    showFilterEditor: false
                },
                changed: function () {
                    hasChartCategoriesChanged = true;
                    var subCategoryField = DynamicForm_JspOperationalChart.getField("subCategories");
                    subCategoryField.clearValue();
                    if (this.value === null || this.getValue() === null || this.getValue() === undefined || this.getValue() === "") {
                        hasChartCategoriesChanged = false;
                        subCategoryField.clearValue();
                        DynamicForm_JspOperationalChart.getField("subCategories").disable();
                        return;
                    }

                    subCategoryField.enable();
                    if (subCategoryField.getValue() === undefined)
                        return;
                    var subCategories = subCategoryField.getSelectedRecords();
                    let categoryIds = this.getValue();
                    var SubCats = [];
                    for (var i = 0; i < subCategories.length; i++) {
                        if (categoryIds.contains(subCategories[i].categoryId))
                            SubCats.add(subCategories[i].id);
                    }
                    subCategoryField.setValue(SubCats);
                    subCategoryField.focus(this.form, subCategoryField);
                }
            },
            {
                name: "subCategories",
                title: "<spring:message code='educational.sub.category'/>",
                // editorType: "MultiComboBoxItem",
                length: 255,
                type: "SelectItem",

                operator: "inSet",
                filterOnKeypress: true,
                autoFitButtons: true,
                titleVAlign: "top",

                pickListWidth: 200,
                multiple: true, textAlign: "center",
                autoFetchData: true,
                disabled: true,
                // optionDataSource: RestDataSource_SubCategories_OperationalRole,
                valueField: "id",
                displayField: "titleFa",
                filterFields: ["titleFa"],
                pickListProperties: {
                    showFilterEditor: false
                },
                focus: function () {
                    if (hasChartCategoriesChanged) {
                        console.log("hasRoleCategoriesChanged", hasRoleCategoriesChanged);
                        hasRoleCategoriesChanged = false;
                        var ids = DynamicForm_JspOperationalChart.getField("categories").getValue();
                        if (ids === []) {
                            // RestDataSource_SubCategories_OperationalRole.implicitCriteria = null;
                        } else {
                            console.log("ids in subCategories :", ids);
                            // RestDataSource_SubCategories_OperationalRole.implicitCriteria = {
                            //     _constructor: "AdvancedCriteria",
                            //     operator: "and",
                            //     criteria: [{fieldName: "categoryId", operator: "inSet", value: ids}]
                            // };
                        }
                        this.fetchData();
                    }
                }
            },
            {
                name: "postIds",
                hidden: true,
                // type: "MultiComboBoxItem",
                title: "<spring:message code="post"/>",
                // optionDataSource: PostDS_OperationalRole,
                valueField: "id",
                displayField: "titleFa",
                filterOnKeypress: true,
                multiple: true,
                comboBoxProperties: {
                    hint: "",
                    filterFields: ["code", "titleFa", "jobTitleFa", "postGradeTitleFa"],
                    textMatchStyle: "substring",
                    pickListWidth: 450,
                    pickListProperties: {
                        autoFitWidthApproach: "both",
                    },
                    pickListFields: [
                        {
                            name: "code",
                            filterOperator: "iContains",
                            autoFitWidth: true
                        },
                        {name: "titleFa",  filterOperator: "iContains"},
                        {
                            name: "jobTitleFa",
                            filterOperator: "iContains",
                            autoFitWidth: true
                        },
                        {
                            name: "postGradeTitleFa",
                            filterOperator: "iContains",
                            autoFitWidth: true
                        }
                    ],
                }
            },
            {
                name: "description",
                title: "<spring:message code="description"/>",
                length: 255
            },
            {
                name: "userIds",
                type: "MultiComboBoxItem",
                title: "<spring:message code="users"/>",
                // optionDataSource: UserDS_JspOperationalRole,
                valueField: "id",
                displayField: "lastName",
                filterOnKeypress: true,
                multiple: true,
                comboBoxProperties: {
                    hint: "",
                    filterFields: ["firstName", "lastName", "username", "nationalCode"],
                    textMatchStyle: "substring",
                    pickListWidth: 335,
                    pickListProperties: {
                        autoFitWidthApproach: "both",
                        gridComponents: [
                            isc.ToolStrip.create({
                                autoDraw: false,
                                height: 30,
                                width: "100%",
                                members: [
                                    isc.ToolStripButton.create({
                                        width: "50%",
                                        icon: "[SKIN]/actions/approve.png",
                                        title: "<spring:message code='select.all'/>",
                                        click: function () {
                                            let fItem = DynamicForm_JspOperationalChart.getField("userIds");
                                            fItem.setValue(fItem.comboBox.pickList.data.localData.map(user => user.id));
                                            fItem.comboBox.pickList.hide();
                                        }
                                    }),
                                    isc.ToolStripButton.create({
                                        width: "50%",
                                        icon: "[SKIN]/actions/close.png",
                                        title: "<spring:message code='deselect.all'/>",
                                        click: function () {
                                            let fItem = DynamicForm_JspOperationalChart.getField("userIds");
                                            fItem.setValue([]);
                                            fItem.comboBox.pickList.hide();
                                        }
                                    })
                                ]
                            }),
                            "header", "body"
                        ]
                    },
                    pickListFields: [
                        {
                            name: "firstName",
                            title: "<spring:message code="firstName"/>",
                            filterOperator: "iContains",
                            autoFitWidth: true
                        },
                        {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains"},
                        {
                            name: "username",
                            title: "<spring:message code="username"/>",
                            filterOperator: "iContains",
                            autoFitWidth: true
                        },
                        {
                            name: "nationalCode",
                            title: "<spring:message code="national.code"/>",
                            filterOperator: "iContains",
                            autoFitWidth: true
                        }
                    ],
                }
            }
        ]
    });

    let Window_JspOperationalChart = isc.Window.create({
        width: "550",
        minWidth: "550",
        align: "center",
        border: "1px solid gray",
        title: "<spring:message code="operational.chart"/>",
        items: [isc.TrVLayout.create({
            members: [DynamicForm_JspOperationalChart,
                HLayout_SaveOrExit_JspOperationalChart
            ]
        })]
    });


    ////////////////////////////////////////
    ////////////////////////////////////////

    var VLayout_Operational_Chart_Body = isc.VLayout.create({
        // members: [search_bar, VLayout_operationalSearchTree, VLayout_operationalTree]
        members: [
            // Menu_JspOperationalRole,
            VLayout_Body_JspOperationalChart, VLayout_operationalTree]
    });

    var HLayout_Operational_Chart_Body = isc.TrHLayout.create({
        members: [VLayout_Operational_Chart_Body]
    });

    // <<----------------------------------------------- Functions --------------------------------------------

    $(document).ready(function () {
        if(batch)
            getTreeData();
    });

    function getDepChildren(childeren, category, parentTitle) {

        let url = operationalChartUrl + "/getDepChartChildren/" + category + "/" + parentTitle ;
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(url, "POST", JSON.stringify(childeren),function(resp) {
            wait.close();
            if (resp.httpResponseCode !== 200) {
                return;
            } else {
                let data = operationalTree.data.concat(JSON.parse(resp.data));
                setTreeData(operationalTree, data, false);
            }
        }))
    }

    function getTreeData() {

        var url = operationalChartUrl + "/list";
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(url, "GET", null, function (resp) {
            wait.close();
            if (resp.httpResponseCode !== 200)
                return false;
            else {
                let data = JSON.parse(resp.data);
/*
                let complexes = data.filter(q => q.category === "complex");
                let assistants = data.filter(q => q.category === "assistant");
                let affairs = data.filter(q => q.category === "affair");
                let sections = data.filter(q => q.category === "section");
                let units = data.filter(q => q.category === "unit");

                sections.forEach(s => s.directReports = units.filter(u => u.parentTitle === s.title));
                affairs.forEach(a => a.directReports = sections.filter(s => s.parentTitle === a.title));
                assistants.forEach(a => a.directReports = affairs.filter(af => af.parentTitle === a.title));
                complexes.forEach(c => c.directReports = assistants.filter(a => a.parentTitle === c.title));
*/

                let childs = data.filter(p=> p);
                let chart = data.filter(p=> p);
                chart.forEach(p=> p.directReports = childs.filter(c => c.parentId === p.id));
debugger
                let treeData = setTreeData(operationalTree, chart, false);
                return treeData;
            }
        }));
    }

    function getSearchData(value) {

        var url = operationalChartUrl + "/getSearchDepChartData/" + value;
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(url, "GET", null, function (resp) {
            wait.close();
            if (resp.httpResponseCode !== 200)
                return false;
            else {
                let data = JSON.parse(resp.data);

                let complexes = data.filter(q => q.category === "complex");
                let assistants = data.filter(q => q.category === "assistant");
                let affairs = data.filter(q => q.category === "affair");
                let sections = data.filter(q => q.category === "section");
                let units = data.filter(q => q.category === "unit");

                sections.forEach(s => s.directReports = units.filter(u => u.parentTitle === s.title));
                affairs.forEach(a => a.directReports = sections.filter(s => s.parentTitle === a.title));
                assistants.forEach(a => a.directReports = affairs.filter(af => af.parentTitle === a.title));
                complexes.forEach(c => c.directReports = assistants.filter(a => a.parentTitle === c.title));
                let treeData = setTreeData(operationalSearchTree, complexes, false);
                return treeData;
            }
        }));
    }

    // function rowClick(record) {
    //
    //     if(batch) {
    //         if(record.isFolder === true || record.isFolder === false){
    //             record.isOpen = true;
    //             let childeren = [];
    //             record.directReports.forEach(function (currentValue, index, arr) {
    //                 if(currentValue.isFolder === undefined  && (currentValue.isFetched === undefined || currentValue.isFetched === false)){
    //                     childeren.add(currentValue.id);
    //                     currentValue.isFetched = true;
    //                     }
    //             });
    //             // getchilderen(childeren);
    //         }
    //     }
    // }

    function openDepFolder(tree) {

        if(batch) {
            let childeren = [];
            let parent = tree.getDropFolder();
            parent.directReports.forEach(function (currentValue, index, arr) {
                if(currentValue.isFolder === undefined  && (currentValue.isFetched === undefined || currentValue.isFetched === false)){
                    childeren.add(currentValue.id);
                    currentValue.isFetched = true;
                }
            });
            // getDepChildren(childeren, parent.category, parent.title);
        }
    }

    function setTreeData(tree, data, open = false,) {

        var treeData = isc.Tree.create({
            modelType: "children",
            nameProperty: "title",
            openProperty: "isOpen",
            canReturnOpenFolders: true,
            childrenProperty: "directReports",
            root: {parentTitle: "-", directReports: data}
        });
        tree.setData(treeData);
        debugger
        return treeData;
    }

    // </script>