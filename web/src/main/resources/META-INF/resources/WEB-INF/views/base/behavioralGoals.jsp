<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>




//=====================ToolStrip_ALL_Goal===========================
 var ToolStripButton_ALL_Goal_Edit = isc.ToolStripButtonEdit.create({

        title: "<spring:message code="edit"/>",
        click: function () {

        }
    });
    var ToolStripButton_ALL_Goal_Add = isc.ToolStripButtonAdd.create({

        title: "<spring:message code="create"/>",
        click: function () {

        }
    });
    var ToolStripButton_ALL_Goal_Remove = isc.ToolStripButtonRemove.create({

        title: "<spring:message code="remove"/>",
        click: function () {

        }
    });

       var   ToolStripButton_ALL_Goal_Refresh = isc.ToolStripButtonRefresh.create({
        //icon: "<spring:url value="refresh.png"/>",
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_BehavioralGoal.invalidateCache();
            // ListGrid_CheckListItem_DetailViewer.setData([]);
        }
    });
    var ToolStrip_Actions_ALL_Goal = isc.ToolStrip.create({
        width: "40%",
        membersMargin: 5,
        members: [
            ToolStripButton_ALL_Goal_Add,
            ToolStripButton_ALL_Goal_Edit,
            ToolStripButton_ALL_Goal_Remove,
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_ALL_Goal_Refresh,
                ]
            }),
        ]
    });

//=================================ToolStrip_BehavioralGoal===================

     var ToolStripButton_BehavioralGoal_Edit = isc.ToolStripButtonEdit.create({

        title: "<spring:message code="edit"/>",
        click: function () {

        }
    });
    var ToolStripButton_BehavioralGoal_Add = isc.ToolStripButtonAdd.create({

        title: "<spring:message code="create"/>",
        click: function () {

        }
    });
    var ToolStripButton_BehavioralGoal_Remove = isc.ToolStripButtonRemove.create({

        title: "<spring:message code="remove"/>",
        click: function () {

        }
    });

       var   ToolStripButton_BehavioralGoal_Refresh = isc.ToolStripButtonRefresh.create({
        //icon: "<spring:url value="refresh.png"/>",
        title: "<spring:message code="refresh"/>",
        click: function () {
            // ListGrid_CheckListItem.invalidateCache();
            // ListGrid_CheckListItem_DetailViewer.setData([]);
        }
    });

         var ToolStrip_Actions_BehavioralGoal = isc.ToolStrip.create({
        width: "40%",
        membersMargin: 5,
        members: [
           ToolStripButton_BehavioralGoal_Add,
           ToolStripButton_BehavioralGoal_Edit,
           ToolStripButton_BehavioralGoal_Remove,
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                   ToolStripButton_BehavioralGoal_Refresh,
                ]
            }),
        ]
    });
  //============================================
        var ListGrid_BehavioralGoal = isc.TrLG.create({
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        showFilterEditor: true,
        autoFetchData: true,
     //   dataSource: RestDataSource_CheckList,
      //  contextMenu: Menu_ListGrid_CheckList,
        fields: [

            {name: "titleFa", title: "<spring:message code="title"/>", align: "center",  filterOperator: "iContains",},
        ],
        recordDoubleClick: function () {

        },
        recordClick: function () {

        },
        selectionUpdated: function () {

        },

    });


     var ListGrid_All_Goal_Course = isc.TrLG.create({
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        showFilterEditor: true,
        autoFetchData: true,
     //   dataSource: RestDataSource_CheckList,
      //  contextMenu: Menu_ListGrid_CheckList,
        fields: [

            {name: "titleFa", title: "<spring:message code="title"/>", align: "center",  filterOperator: "iContains",},
        ],
        recordDoubleClick: function () {

        },
        recordClick: function () {

        },
        selectionUpdated: function () {

        },

    });
  //==============================================


  var HLayout_Action_ALL_Goal = isc.HLayout.create({
        height: "3%",
        members: [ToolStrip_Actions_ALL_Goal]
    });

    var HLayout_Action_BehavioralGoal=isc.HLayout.create({
        height: "3%",
        members: [ToolStrip_Actions_BehavioralGoal]
    });

  var VLayout_ALL_Goal = isc.VLayout.create({
       width: "35%",
        height: "100%",
          members: [HLayout_Action_ALL_Goal,ListGrid_All_Goal_Course]
    });


    var VLayout_ListGrid_All_Goal=isc.VLayout.create({
    members:[HLayout_Action_BehavioralGoal,ListGrid_BehavioralGoal]

    });

 var HLayout_Body_Goal = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [VLayout_ALL_Goal,VLayout_ListGrid_All_Goal],
    });

 var BehavioralGoals_Body = isc.VLayout.create({
        width: "100%",
        showEdges: true,
        members: [HLayout_Body_Goal]
    });

        function loadPage_behavioralGoal() {
        courseRecord = ListGrid_Course.getSelectedRecord();
        if (!(courseRecord == undefined || courseRecord == null)) {
            RestDataSource_ClassCheckList.fetchDataURL = checklistUrl + "getchecklist" + "/" + classRecord.id;
            <%--ListGrid_ClassCheckList.setFieldProperties(1, {title: "&nbsp;<b>" + "<spring:message code='class.checkList.forms'/>" + "&nbsp;<b>" + classRecord.course.titleFa + "&nbsp;<b>" + "<spring:message code='class.code'/>" + "&nbsp;<b>" + classRecord.code});--%>
            ListGrid_BehavioralGoal.fetchData();
            ListGrid_BehavioralGoal.invalidateCache();
        } else {
           // ListGrid_ClassCheckList.setFieldProperties(1, {title: " "});
           // ListGrid_ClassCheckList.setData([]);
        }
    }

