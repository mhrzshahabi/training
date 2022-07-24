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
        showResizeBar: true,
        members: [operationalTree]
    });

    var VLayout_operationalSearchTree = isc.VLayout.create({
        showResizeBar: true,
        members: [operationalSearchTree]
    });

    var VLayout_Operational_Chart_Body = isc.VLayout.create({
        members: [search_bar, VLayout_operationalSearchTree, VLayout_operationalTree]
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

        let url = operationalUrl + "/getDepChartChildren/" + category + "/" + parentTitle ;
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

        var url = operationalUrl + "/list";
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

        var url = operationalUrl + "/getSearchDepChartData/" + value;
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