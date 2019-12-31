<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

var  BehavioralGoal_method ="POST";
//======================RestDataSource==============================
  RestDataSource_All_Goal_Course = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {name: "goal.titleFa", title: "<spring:message code="title"/>", align: "center",  filterOperator: "iContains",},
        ],
        autoFetchData:false
    });

    RestDataSource_BehavioralGoal=isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
                {name: "goalId", hidden: true},
                {name: "titleFa",title: "<spring:message code="title"/>",type: 'text',required: true,height: 35,width: "*",},
                {name: "kind", title: "نوع", type: 'text', height: 35, width: "*"},
        ],
        autoFetchData:false
    });

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
        show_BehavioralGoal_Add()
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
  //============================================ListGrid========================
        var ListGrid_BehavioralGoal = isc.TrLG.create({
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        filterOnKeypress: false,
        showFilterEditor: true,
        autoFetchData: true,
        dataSource: RestDataSource_BehavioralGoal,
      //  contextMenu: Menu_ListGrid_CheckList,
        fields: [


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
       dataSource: RestDataSource_All_Goal_Course,
      //  contextMenu: Menu_ListGrid_CheckList,
        fields: [
        ],
        recordDoubleClick: function () {
        },
        recordClick: function () {
        },

         selectionUpdated: function () {

            var record = ListGrid_All_Goal_Course.getSelectedRecord();
            RestDataSource_BehavioralGoal.fetchDataURL = BehavioralGoalUrl + record.id + "/getBehavioralGoal";
                ListGrid_BehavioralGoal.fetchData();
            ListGrid_BehavioralGoal.invalidateCache();
        },
    });
  //==============================================DynamicForm=========================
      var DynamicForm_BehavioralGoal_Add = isc.DynamicForm.create({
        ID: "DynamicForm_BehavioralGoal_Add",
        titleAlign: "center",
        wrapTitle: true,

        fields:
            [
                {name: "id", hidden: true},
                {name: "goalId", hidden: true},
                {name: "titleFa",title: "<spring:message code="title"/>",type: 'text',required: true,height: 35,width: "*",},
                {name: "kind", title: "نوع", type: 'text', height: 35, width: "*"},
            ]
    });
  //=================================================Windows=================================
   var Window_BehavioralGoal_Add = isc.Window.create({
        width: 500,
        items: [DynamicForm_BehavioralGoal_Add, isc.MyHLayoutButtons.create({
            members: [isc.IButtonSave.create({
                title: "<spring:message code="save"/>",

                click: function () {
                    if (BehavioralGoal_method === "POST") {
                       save_BehavioralGoal()
                    } else {

                    }
                }
            }), isc.IButtonCancel.create({
                title: "<spring:message code="cancel"/>",
                click: function () {
                    Window_BehavioralGoal_Add.close();
                }
            })],
        }),]
    });
  //=========================================================================================


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
          members: [ListGrid_All_Goal_Course] //HLayout_Action_ALL_Goal
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


       function show_BehavioralGoal_Add() {
        var SelectedAll_Goal_Course = ListGrid_All_Goal_Course.getSelectedRecord();
        if (SelectedAll_Goal_Course == null || SelectedAll_Goal_Course.id == null) {
            isc.Dialog.create({
                message: "<spring:message code="لطفا هدف مورد نظر را انتخاب کنید"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="warning"/>",
                buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            BehavioralGoal_method = "POST";
           DynamicForm_BehavioralGoal_Add.clearValues();
            DynamicForm_BehavioralGoal_Add.getItem("goalId").setValue(SelectedAll_Goal_Course.id);
            Window_BehavioralGoal_Add.setTitle("<spring:message code="create.item"/>");
            Window_BehavioralGoal_Add.show();
        }
    };

        function   save_BehavioralGoal() {
        if (!DynamicForm_BehavioralGoal_Add.validate()) {
            return;
        }

        var BehavioralGoalItem = DynamicForm_BehavioralGoal_Add.getValues();

        isc.RPCManager.sendRequest(TrDSRequest(BehavioralGoalUrl, BehavioralGoal_method, JSON.stringify(BehavioralGoalItem), "callback:show_CheckListItemActionResult(rpcResponse)"));
    };


        function show_CheckListItemActionResult(resp) {
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            let gridState = "[{id:" + JSON.parse(resp.httpResponseText).id + "}]";
            ListGrid_All_Goal_Course.invalidateCache();
            ListGrid_BehavioralGoal.invalidateCache();

            var OK = isc.Dialog.create({
                message: "<spring:message code="msg.operation.successful"/>",
                icon: "[SKIN]say.png",
                title: "<spring:message code="global.form.command.done"/>"
            });
            setTimeout(function () {
                ListGrid_BehavioralGoal.setSelectedState(gridState);
                OK.close();
            }, 3000);
           Window_BehavioralGoal_Add.close();
        } else {
            var OK = isc.Dialog.create({
                message: "<spring:message code="msg.operation.error"/>",
                icon: "[SKIN]say.png",
                title: "<spring:message code="message"/>"
            });
            // setTimeout(function () {
            //     OK.close();
            // }, 3000);
        }

    };

        function loadPage_behavioralGoal() {
        courseRecord = ListGrid_Course.getSelectedRecord();
        if (!(courseRecord == undefined || courseRecord == null)) {
            RestDataSource_All_Goal_Course.fetchDataURL = syllabusUrl + "course/" + courseRecord.id;
            <%--ListGrid_ClassCheckList.setFieldProperties(1, {title: "&nbsp;<b>" + "<spring:message code='class.checkList.forms'/>" + "&nbsp;<b>" + classRecord.course.titleFa + "&nbsp;<b>" + "<spring:message code='class.code'/>" + "&nbsp;<b>" + classRecord.code});--%>
            ListGrid_All_Goal_Course.fetchData();
            ListGrid_All_Goal_Course.invalidateCache();
        } else {

        }
    }

