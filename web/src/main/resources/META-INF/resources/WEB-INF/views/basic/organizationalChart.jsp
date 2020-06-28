<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    var searchTree = isc.TreeGrid.create({
        ID: "searchTree",
        data:[],
        fields: [
            {name: "title", title: " ", width:"10%"},
        ],
        width: "100%",
        height: "30%",
        autoDraw: false,
        showOpenIcons:false,
        showDropIcons:false,
        showSelectedIcons:false,
        showConnectors: true,
        // baseStyle: "noBorderCell",
        dataProperties:{
            dataArrived:function (parentNode) {
                this.openAll();
            },
        },
        rowClick: function (_1,_2,_3) {
            console.log(_1);
        },
    });

    var organizationalTree = isc.TreeGrid.create({
        ID: "organizationalTree",
        data:[],
        fields: [
            {name: "title", title: " ", width:"10%", },
        ],
        width: "100%",
        height: "70%",
        autoDraw: false,
        showOpenIcons:false,
        showDropIcons:false,
        showSelectedIcons:false,
        showConnectors: true,
        // baseStyle: "noBorderCell",
        dataProperties:{
            dataArrived:function (parentNode) {
                this.openAll();
            },
        },
        rowClick: function (_1,_2,_3) {
            if(_1.isFolder === undefined){
                console.log(_1);
                }
            if(_1.isFolder === true || _1.isFolder === false){
                _1.isOpen = true;
                let childeren = [];
                _1.children.forEach(function (currentValue, index, arr) {
                    if(currentValue.isFolder == undefined)
                        childeren.add(currentValue.id);
                });
                getchilderen(childeren);
            }
        },
        openFolder:function () {}
    });

    // <<-------------------------------------- Create - ToolStripButton --------------------------------------

    var ToolStripButton_Refresh = isc.ToolStripButtonRefresh.create({
        title: "<spring:message code="refresh"/>",
        click: function () {
            // getRootTreeData();
        }
    });

    var ToolStrip_Tree = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            ToolStripButton_Refresh,
            // isc.ToolStrip.create({
            //     width: "100%",
            //     align: "left",
            //     border: '0px',
            //     members: [
            //         ToolStripButton_Refresh,
            //     ]
            // })
        ]
    });

    // ---------------------------------------- Create - ToolStripButton ------------------------------------>>

    // <<-------------------------------------- Create - RestDataSource & ListGrid ----------------------------

    // ---------------------------------------- Create - RestDataSource & ListGrid -------------------------->>

    // <<-------------------------------------- Create - DynamicForm & Window ---------------------------------

    var search_bar = isc.DynamicForm.create({
        autoDraw: false,
        numCols: 3,
        items: [{
            name: "search",
            title: "<spring:message code="search"/>",
            width: 400,
            suppressBrowserClearIcon: true,
            icons: [{
                name: "view",
                src: "[SKINIMG]actions/view.png",
                hspace: 5,
                inline: true,
                baseStyle: "roundedTextItemIcon",
                showRTL: true,
                tabIndex: -1,
                click: function () {
                    let AdvanceCriteria = '{"fieldName":"title","operator":"iContains","value":"' + search_bar.getValues().search + '"}';
                    getSearchData(AdvanceCriteria);
                },
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
        }, {
            type: "Button",
            title: "<spring:message code="refresh"/>",
            startRow: false,
            align:"left",
            click: function () {
                search_bar.getField("search").getIcon("clear").click(search_bar,search_bar.getField("search"));
                searchTree.setData([]);
                organizationalTree.setData([]);
                getRootTreeData();
            }
        },
        ],
        itemKeyPress: function (item, keyName) {
            if (keyName == "Enter") {
                let AdvanceCriteria = '{"fieldName":"title","operator":"iContains","value":"' + search_bar.getValues().search + '"}';
                getSearchData(AdvanceCriteria);
            }
        },
    });

    // ---------------------------------------- Create - DynamicForm $ Window ------------------------------->>

    // <<-------------------------------------- Create - TabSet & Tab -----------------------------------------

    // ---------------------------------------- Create - TabSet & Tab --------------------------------------->>

    // <<------------------------------------------- Create - Layout ------------------------------------------
    var HLayout_Tree_Data = isc.TrHLayout.create({
        ID: "HLayoutCenter_JspEditNeedsAssessment",
        height: "70%",
        showResizeBar: true,
        members: [
            ToolStripButton_Refresh,
            search_bar,
        ]
    })

    var VLayout_Tree_Data = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [search_bar, searchTree, organizationalTree]
    });

    // ---------------------------------------------- Create - Layout ---------------------------------------->>

    // <<----------------------------------------------- Functions --------------------------------------------
    $(document).ready(function () {
        getRootTreeData();
    });

    function getchilderen(data) {
        isc.RPCManager.sendRequest(TrDSRequest(masterDataUrl + "/department/getDepartmentsChilderen", "POST", JSON.stringify(data),function(resp){
            if (resp.httpResponseCode != 200){
                return;
            } else {
                let data = organizationalTree.getData().data.concat(JSON.parse(resp.data));
                var Treedata = isc.Tree.create({
                    modelType: "parent",
                    nameProperty: "title",
                    idField: "id",
                    parentIdField: "parentId",
                    data: data,
                    openProperty: "isOpen",
                });
                organizationalTree.setData(Treedata);
                //organizationalTree.getData().openAll();
            }
        }))
    }

    function getTreeData(parentId) {
        var url = masterDataUrl + "/department/getDepartmentsByParentId/" + parentId;
        isc.RPCManager.sendRequest(TrDSRequest(url, "GET", null, function (resp) {
            if (resp.httpResponseCode != 200) {
                return false;
            } else {
                let data = organizationalTree.getData().data.concat(JSON.parse(resp.data));
                var Treedata = isc.Tree.create({
                    modelType: "parent",
                    nameProperty: "title",
                    idField: "id",
                    parentIdField: "parentId",
                    data: data,
                    openProperty: "isOpen",
                });
                organizationalTree.setData(Treedata);
                //organizationalTree.getData().openAll();
            }
        }));
    }

    function getRootTreeData() {
        var url = masterDataUrl + "/department/getDepartmentsRoot";
        isc.RPCManager.sendRequest(TrDSRequest(url, "GET", null, function (resp) {
            if (resp.httpResponseCode != 200) {
                return false;
            } else {
                let data = JSON.parse(resp.data);
                var Treedata = isc.Tree.create({
                    modelType: "parent",
                    nameProperty: "title",
                    idField: "id",
                    parentIdField: "parentId",
                    data: JSON.parse(resp.data)
                });
                organizationalTree.setData(Treedata);
                Treedata.data[0]["isOpen"] = false;
                getTreeData(Treedata.data[0].id);
                //organizationalTree.getData().openAll();
            }
        }));
    }

    function getSearchData(criteria) {
        var url = masterDataUrl + "/department/getDepartmentsChilderenAndParents" + "?operator=or&_constructor=AdvancedCriteria&criteria="+ criteria;
        isc.RPCManager.sendRequest(TrDSRequest(url, "GET", null, function (resp) {
            if (resp.httpResponseCode != 200) {
                return false;
            } else {
                let data = JSON.parse(resp.data);
                var Treedata = isc.Tree.create({
                    modelType: "parent",
                    nameProperty: "title",
                    idField: "id",
                    parentIdField: "parentId",
                    data: data,
                    openProperty: "isOpen",
                });
                searchTree.setData(Treedata);
                searchTree.getData().openAll();
            }
        }));
    }
    // ------------------------------------------------- Functions ------------------------------------------>>

    // </script>