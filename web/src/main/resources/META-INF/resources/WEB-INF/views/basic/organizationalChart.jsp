<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    let batch = true;

    var searchTree = isc.TreeGrid.create({
        ID: "searchTree",
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
            },
        },
        rowClick: function (_1,_2,_3) {
        },
        rowDoubleClick: function(_1){
            rowDClick(_1);
        },
    });

    var organizationalTree = isc.TreeGrid.create({
        ID: "organizationalTree",
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
            },
        },
        rowClick: function (_1,_2,_3) {
            rowClick(_1);
        },
        rowDoubleClick: function(_1){
            rowDClick(_1);
        },
        openFolder:function () {
            openFolder(this);
            this.Super("openFolder",arguments);
        },
    });

    // <<-------------------------------------- Create - ToolStripButton --------------------------------------

    var ToolStripButton_Refresh = isc.ToolStripButtonRefresh.create({
        title: "<spring:message code="refresh"/>",
        click: function () {
            // search_bar.getField("search").getIcon("clear").click(search_bar,search_bar.getField("search"));
            // searchTree.setData([]);
            // organizationalTree.setData([]);
            // getRootTreeData();
        }
    });

    var confirm_Deparments =  isc.IButton.create({
        top:250,
        width: "33%",
        title:"<spring:message code="verify"/>",
        align: "center",
        click: function () {
            Window_OrganizationalChart.close();
        }
    });

    var ToolStrip_Tree = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            ToolStripButton_Refresh,
        ]
    });

    // ---------------------------------------- Create - ToolStripButton ------------------------------------>>

    // <<-------------------------------------- Create - RestDataSource & ListGrid ----------------------------

    var chosenDepartments_JspOC = isc.TrLG.create({
        autoFetchData: true,
        selectionType:"none",
        showFilterEditor:false,
        showHeaderContextMenu: false,
        sortField: 0,
        canAcceptDroppedRecords: true,
        canRemoveRecords:true,
        gridComponents: [
            "filterEditor", "header", "body",
            // confirm_Deparments
        ],
        align: "center",
        fields:[
            {name: "id", primaryKey: true, hidden:true},
            {name: "title", title: "موارد انتخاب شده"},
        ],
        removeRecordClick: function(rowNum){
            this.removeData(this.getRecord(rowNum));
        },
        recordDrop (dropRecords, targetRecord, index, sourceWidget){
            dropRecords.forEach(function (currentValue,index,array) {
                rowDClick(currentValue);
            })
        }
    });

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
                    // let AdvanceCriteria = '{"fieldName":"title","operator":"iContains","value":"' + search_bar.getValues().search + '"}';
                    // getSearchData(AdvanceCriteria);
                    searchWithCriteria(search_bar.getValues().search);
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
                // let AdvanceCriteria = '['+
                //     '{"fieldName":"title","operator":"iContains","value":"' + search_bar.getValues().search + '"}, '+
                //     '{"fieldName":"code","operator":"iContains","value":"' + search_bar.getValues().search + '"}'+
                // ']';
                // getSearchData(AdvanceCriteria);
                searchWithCriteria(search_bar.getValues().search);
            }
        },
    });

    // ---------------------------------------- Create - DynamicForm $ Window ------------------------------->>

    // <<-------------------------------------- Create - TabSet & Tab -----------------------------------------

    // ---------------------------------------- Create - TabSet & Tab --------------------------------------->>

    // <<------------------------------------------- Create - Layout ------------------------------------------
    var HLayout_Tree_Data = isc.TrHLayout.create({
        height: "70%",
        members: [
            ToolStripButton_Refresh,
            search_bar,
        ]
    });
    var VLayout_organizationalTree = isc.VLayout.create({
        showResizeBar: true,
        members: [organizationalTree]
    });
    var VLayout_searchTree = isc.VLayout.create({
        showResizeBar: true,
        members: [searchTree]
    });

    var VLayout_Tree_Data = isc.VLayout.create({
        members: [search_bar, VLayout_searchTree, VLayout_organizationalTree]
    });

    var HLayout_Confirm_Deparments = isc.TrHLayout.create({
        height: "4%",
        width: "40%",
        align: "center",
        defaultLayoutAlign : "center",
        members: [confirm_Deparments]
    });

    var VLayout_chosen_Departments = isc.VLayout.create({
        defaultLayoutAlign : "center",
        showResizeBar: true,
        members: [chosenDepartments_JspOC, HLayout_Confirm_Deparments]
    });
    VLayout_chosen_Departments.hide();

    var HLayout_Tree_Grid = isc.TrHLayout.create({
        members: [VLayout_Tree_Data, VLayout_chosen_Departments]
    });

    // ---------------------------------------------- Create - Layout ---------------------------------------->>

    // <<----------------------------------------------- Functions --------------------------------------------
    $(document).ready(function () {
        if(batch)
            getRootTreeData();
        // else
        //     getAllTreeData();
    });
    //
    // function getAllTreeData() {
    //     var url = masterDataUrl + "/department/touple-iscList";
    //     wait.show();
    //     isc.RPCManager.sendRequest(TrDSRequest(url, "GET", null, function (resp) {
    //         wait.close();
    //         if (resp.httpResponseCode != 200) {
    //             return false;
    //         } else {
    //             let data = JSON.parse(resp.data);
    //             setTreeData(organizationalTree, data, false);
    //         }
    //     }));
    // }

    function getchilderen(childeren) {
        let url = departmentUrl + "/getDepartmentsChilderen";
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(url, "POST", JSON.stringify(childeren),function(resp){
            wait.close();
            if (resp.httpResponseCode != 200){
                return;
            } else {
                let data = organizationalTree.getData().data.concat(JSON.parse(resp.data));
                setTreeData(organizationalTree, data, false);
            }
        }))
    }

    function getTreeData(parentId) {
        var url = departmentUrl + "/getDepartmentsByParentId/" + parentId;
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(url, "GET", null, function (resp) {
            wait.close();
            if (resp.httpResponseCode != 200) {
                return false;
            } else {
                let data = organizationalTree.getData().data.concat(JSON.parse(resp.data));
                setTreeData(organizationalTree, data, false);
            }
        }));
    }

    function getRootTreeData() {
        var url = departmentUrl + "/getDepartmentsRoot";
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(url, "GET", null, function (resp) {
            wait.close();
            if (resp.httpResponseCode != 200) {
                return false;
            } else {
                let data = JSON.parse(resp.data);
                let Treedata = setTreeData(organizationalTree, data, false);
                Treedata.data[0]["isOpen"] = false;
                getTreeData(Treedata.data[0].id);

            }
        }));
    }

    function getSearchData(criteria) {
        var url = departmentUrl + "/searchSocieties" + "?operator=and&_constructor=AdvancedCriteria&criteria="+ JSON.stringify(criteria);
        wait.show();
        isc.RPCManager.sendRequest(TrDSRequest(url, "GET", null, function (resp) {
            wait.close();
            if (resp.httpResponseCode != 200) {
                return false;
            } else {
                let data = JSON.parse(resp.data);

                // let difference = data.filter(x => !organizationalTree.data.data.find(y => x.id == y.id));
                //
                // let difference2 = organizationalTree.data.data.filter(x => (x.isFolder === undefined  && (x.isFetched === undefined || x.isFetched === false)));
                //
                // let result = difference.concat(difference2);
                //
                // let childs = [];
                // result.forEach(function (currentValue, index, array) {
                //     if (currentValue.isFolder === undefined  && (currentValue.isFetched === undefined || currentValue.isFetched === false))
                //         childs.add(currentValue.id);
                // });
                // getchilderen(childs);

                setTreeData(searchTree, data, true);
            }
        }));
    }

    function rowClick(_1){
        if(batch){
            if(_1.isFolder === true || _1.isFolder === false){
                _1.isOpen = true;
                let childeren = [];
                _1.children.forEach(function (currentValue, index, arr) {
                    if(currentValue.isFolder === undefined  && (currentValue.isFetched === undefined || currentValue.isFetched === false)){
                        childeren.add(currentValue.id);
                        currentValue.isFetched = true;
                        }
                });
                getchilderen(childeren);
            }
        }
    }

    function rowDClick(_1) {
        if(_1.isFolder === undefined){
            var item = chosenDepartments_JspOC.data.filter(function (i) {
                return i.id === _1.id;
            });
            if(item.length < 1)
                chosenDepartments_JspOC.addData({"id":_1.id,"title":_1.title});
        }
    }

    function openFolder(tree) {
        if(batch){
            let childeren = [];
            tree.getDropFolder().children.forEach(function (currentValue, index, arr) {
                if(currentValue.isFolder === undefined  && (currentValue.isFetched === undefined || currentValue.isFetched === false)){
                    childeren.add(currentValue.id);
                    currentValue.isFetched = true;
                }
            });
            getchilderen(childeren);
        }
    }

    function setTreeData(tree, data, open = false,) {
        var Treedata = isc.Tree.create({
            modelType: "parent",
            nameProperty: "title",
            idField: "id",
            parentIdField: "parentId",
            data: data,
            openProperty: "isOpen",
        });
        tree.setData(Treedata);
        if(open)
            searchTree.getData().openAll();
        return Treedata;
    }

    function searchWithCriteria(value) {

        let  criteria = {};
        criteria.operator = "or";
        criteria.criteria = [];
        criteria.criteria.push({fieldName: "title", operator: "iContains", value: value});
        criteria.criteria.push({fieldName: "code", operator: "iContains", value: value});

        let  AdvanceCriteria = {};
        AdvanceCriteria.operator = "and";
        AdvanceCriteria._constructor = "AdvancedCriteria";
        AdvanceCriteria.criteria = [];
        AdvanceCriteria.criteria.push({fieldName: "enabled", operator: "isNull"});
        AdvanceCriteria.criteria.push(criteria);

        getSearchData(AdvanceCriteria);
    }
    // ------------------------------------------------- Functions ------------------------------------------>>

    // </script>