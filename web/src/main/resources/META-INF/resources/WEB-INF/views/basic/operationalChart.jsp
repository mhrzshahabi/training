<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    let batch = true;
    let departmentCriteriaChart = [];

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

    let RestDataSource_OperationalChart_Department_Filter = isc.TrDS.create({
        fields: [{name: "id"}, {name: "code"}, {name: "title"}, {name: "enabled"}],
        cacheAllData: true,
        fetchDataURL: departmentUrl + "/organ-segment-iscList/mojtame"
    });

    let DynamicForm_departmentFilter_Filter = isc.DynamicForm.create({
        width: "600",
        height: 30,
        numCols: 6,
        colWidths: ["2%", "28%", "2%", "68%"],
        fields: [
            {
                name: "departmentFilter",
                title: "<spring:message code='complex'/>",
                width: "300",
                height: 30,
                optionDataSource: RestDataSource_OperationalChart_Department_Filter,
                autoFetchData: false,
                displayField: "title",
                // valueField: "id",
                valueField: "title",
                textAlign: "center",
                icons: [
                    {
                        name: "clear",
                        src: "[SKIN]actions/remove.png",
                        width: 15,
                        height: 15,
                        inline: true,
                        prompt: "پاک کردن",
                        click: function (form, item, icon) {
                            item.clearValue();
                            item.focusInItem();
                        }
                    }
                ],
                pickListFields: [
                    {
                        name: "title",
                        title: "<spring:message code="title"/>",
                        filterOperator: "iContains",
                        autoFitWidth: true
                    }
                ],
                changed: function (form, item, value) {
                    load_chart_by_complex(value);
                    getTreeData(value);
                },
            },
        ]
    });

    let ToolStripButton_Refresh_JspOperationalChart = isc.ToolStripButtonRefresh.create({
        click: function () {
            DynamicForm_departmentFilter_Filter.clearValues();
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
                ListGrid_OperationalChart_Edit(selected_record);
            }
        }
    });
    let ToolStripButton_Add_JspOperationalChart = isc.ToolStripButtonCreate.create({
        click: function () {
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
                DynamicForm_departmentFilter_Filter,
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
                ListGrid_OperationalChart_Add();
            }
        }, {
            title: "<spring:message code='edit'/>", click: function () {
                let record = ListGrid_JspOperationalChart.getSelectedRecord();
                selected_record = record;
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
        transformRequest: function (dsRequest) {
            transformCriteriaForLastModifiedDateNA(dsRequest);
             return this.Super("transformRequest", arguments);
        },
        dataArrived: function (startRow, endRow, data) {
           console.log(data);
        },

        fields:
            [
                {name: "id", primaryKey: true},
                {name: "complex"},
                {name: "userName"},
                {name: "nationalCode"},
                {name: "title"},
                 ],
        fetchDataURL: operationalChartUrl + "/spec-list",
    });

    let ListGrid_JspOperationalChart = isc.TrLG.create({
        dataSource: RestDataSource_JspOperationalChart,
        contextMenu: Menu_JspOperationalChart,
        sortField: 0,
        sortDirection: "descending",
        dataPageSize: 200,
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
                name: "complex",
                title: "مجتمع",
                filterOperator: "iContains"
             },
            {
                name: "userName",
                title: "نام کاربری",
                filterOperator: "iContains"
            },
            {
                name: "nationalCode",
                title: "کد ملی",
                filterOperator: "iContains"
            },

            {
                name: "title",
                title: "عنوان",
                filterOperator: "iContains"
            },

        ],
        rowDoubleClick: function (record) {
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
        saveActionUrlOperationalChart = operationalChartUrl + "/create";
        DynamicForm_JspOperationalChart.clearValues();
        Window_JspOperationalChart.show();
    }

    function ListGrid_OperationalChart_Edit(record) {
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.no.records.selected'/>");
        } else {
             methodOperationalChart = "PUT";
             saveActionUrlOperationalChart = operationalChartUrl + "/update/" + record.id;

            DynamicForm_JspOperationalChart.clearValues();
            DynamicForm_JspOperationalChart.editRecord(record);
            }

            Window_JspOperationalChart.show();
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
                        isc.RPCManager.sendRequest(TrDSRequest(operationalChartUrl + "/delete/" + recordIds,
                            "DELETE",
                            null,
                            OperationalChart_remove_result));
                    }
                }
            });
        }
    }

    function OperationalChart_remove_result(resp) {
        wait_Permission.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            refreshLG(ListGrid_JspOperationalChart);
            let OK = createDialog("info", "<spring:message code="msg.operation.successful"/>");
            setTimeout(function () {
                OK.close();
            }, 3000);
        } else {
            let respText = resp.httpResponseText;
            if (resp.httpResponseCode === 406 && respText === "NotDeletable") {
                createDialog("info", "<spring:message code='msg.record.cannot.deleted'/>");
            } else {
                createDialog("info", "<spring:message code="msg.operation.error"/>");
            }
        }
    }

    let IButton_Save_JspOperationalChart = isc.IButtonSave.create({
        top: 260,
        click: function () {

            if (!DynamicForm_JspOperationalChart.validate())
                return;
            if (!DynamicForm_JspOperationalChart.valuesHaveChanged()) {
                Window_JspOperationalChart.close();
                return;
            }
            wait_Permission = createDialog("wait");

            let complex = DynamicForm_JspOperationalChart.getField( "complexId").getValue();
            let userId= DynamicForm_JspOperationalChart.getField("userIds").getValue();
            let title = DynamicForm_JspOperationalChart.getField("title").getValue();
            let code = DynamicForm_JspOperationalChart.getField("code").getValue();

            let data = {
                "nationalCode": "nationalCode",
                "userName": "userName",

                "operationalCharParentChild": [
                    null
                ],
                "parentId": null ,
                "complex":complex,
                "title": title,
                "code": code,
                "userId" : userId,
                "version": 0
            }

            isc.RPCManager.sendRequest(TrDSRequest(saveActionUrlOperationalChart,
                methodOperationalChart,
                JSON.stringify(data),
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

    let UserDS_JspOperationalChart = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
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
            },
            {name: "version", hidden: true},
        ],
        fetchDataURL: oauthUserUrl + "/spec-list"
    });

    let DynamicForm_JspOperationalChart= isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        titleAlign: "left",
        fields: [
            {name: "id", hidden: true},
            {
                name: "userIds",
                type: "ComboBoxItem",
                title: "نام کاربری",
                optionDataSource: UserDS_JspOperationalChart,
                valueField: "id",
                displayField: "lastName",
                filterOnKeypress: true,
                required: true,
                multiple: false,
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
                                members: [ ]
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
            },
            {
                name: "title",
                title: "<spring:message code="title"/>",
                required: true,
                validateOnExit: true,
                length: 255
            },
            {
                name: "code",
                title: "<spring:message code="code"/>",
                required: true,
                validateOnExit: true,
                length: 255
            },
            {
                name: "complexId",
                editorType: "ComboBoxItem",
                title: "<spring:message code="complex"/>:",
                pickListWidth: 200,
                optionDataSource: RestDataSource_OperationalChart_Department_Filter,
                displayField: "title",
                autoFetchData: true,
                valueField: "title",
                textAlign: "center",
                required: true,
                textMatchStyle: "substring",
                pickListFields: [
                    {name: "title", autoFitWidth: true, autoFitWidthApproach: true},
                ],
                pickListProperties: {
                    sortField: 0,
                    showFilterEditor: true
                },
            },
            {
                name: "roleId",
                title: "نقش",
                required: false,
                validateOnExit: true,
                length: 255
            },
            {
                name: "parentId",
                title: "سطح بالادست",
                required: false,
                validateOnExit: true,
                length: 255
            },

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


    var VLayout_Operational_Chart_Body = isc.VLayout.create({
            members: [VLayout_Body_JspOperationalChart, VLayout_operationalTree]
     });

    var HLayout_Operational_Chart_Body = isc.TrHLayout.create({
        members: [VLayout_Operational_Chart_Body]
    });

    // <<----------------------------------------------- Functions --------------------------------------------

    // $(document).ready(function () {
    //     if(batch)
    //         getTreeData();
    // });

    function getTreeData(complexTitle) {

        if (complexTitle !== undefined) {
            var url = operationalChartUrl + "/list";
            wait.show();
            isc.RPCManager.sendRequest(TrDSRequest(url, "POST",  JSON.stringify(complexTitle), function (resp) {
                wait.close();
                if (resp.httpResponseCode !== 200)
                    return false;
                else {
                    let data = JSON.parse(resp.data);

                    let childs = data.filter(p => p);
                    let chart = data.filter(p => p);
                    chart.forEach(p => p.directReports = childs.filter(c => c.parentId === p.id));
                    let treeData = setTreeData(operationalTree, chart, false);
                    return treeData;
                }
            }));
        }
    }

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
         return treeData;
    }

    function createMainCriteriaInChart() {
        let mainCriteria = {};
        mainCriteria._constructor = "AdvancedCriteria";
        mainCriteria.operator = "and";
        mainCriteria.criteria = [];
        mainCriteria.criteria.add(departmentCriteriaChart);
        return mainCriteria;
    }

    function load_chart_by_complex(value) {
        if (value !== undefined) {
            let criteria = {
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [
                    {
                        fieldName: "complex", operator: "inSet", value: value
                    }
                ]
            };
            RestDataSource_JspOperationalChart.fetchDataURL = operationalChartUrl + "/spec-list";
            departmentCriteriaChart = criteria;
            let mainCriteria = createMainCriteriaInChart();
            ListGrid_JspOperationalChart.invalidateCache();
            ListGrid_JspOperationalChart.fetchData(mainCriteria);

        } else {
            createDialog("info", "<spring:message code="msg.select.complex.ask"/>", "<spring:message code="message"/>")
        }

    }

    // </script>