<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

// <script>

    var organizationalTree = isc.TreeGrid.create({
        ID: "organizationalTree",
        data:[],
        fields: [
            {name: "title", title: "<spring:message code="title"/>"},
        ],
        width: "100%",
        height: "80%",
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
                // _1["isOpen"] = true;
                // getTreeData(_1.id);
                console.log(_1);
                }
            if(_1.isFolder === true){
                _1.isOpen = true;
                let childeren = [];
                _1.children.forEach(function (currentValue, index, arr) {
                    // getTreeData(currentValue.id);
                    if(currentValue.isFolder == undefined)
                        childeren.add(currentValue.id);
                });
                getchilderen(childeren);
            }
        },
    });

    // <<-------------------------------------- Create - ToolStripButton --------------------------------------

    var ToolStripButton_Refresh = isc.ToolStripButtonRefresh.create({
        title: "<spring:message code="refresh"/>",
        click: function () {
            getRootTreeData();
            // getTreeData();
        }
    });

    var ToolStrip_Info = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh
                ]
            })
        ]
    });

    // ---------------------------------------- Create - ToolStripButton ------------------------------------>>

    // <<-------------------------------------- Create - RestDataSource & ListGrid ----------------------------

    // ---------------------------------------- Create - RestDataSource & ListGrid -------------------------->>

    // <<-------------------------------------- Create - DynamicForm & Window ---------------------------------

    // ---------------------------------------- Create - DynamicForm $ Window ------------------------------->>

    // <<-------------------------------------- Create - TabSet & Tab -----------------------------------------

    // ---------------------------------------- Create - TabSet & Tab --------------------------------------->>

    // <<------------------------------------------- Create - Layout ------------------------------------------

    var VLayout_PersonnelInfo_Data = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [ToolStripButton_Refresh, organizationalTree]
    });

    // ---------------------------------------------- Create - Layout ---------------------------------------->>

    // <<----------------------------------------------- Functions --------------------------------------------
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
    // ------------------------------------------------- Functions ------------------------------------------>>

    // </script>