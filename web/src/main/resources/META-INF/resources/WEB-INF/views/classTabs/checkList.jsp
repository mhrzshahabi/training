<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>


// <script>

    var CheckList_method = "POST";
    var  CheckListItem_method="POST";
    var changed_field;
    var RestDataSource_CheckList = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"},

        ],

        fetchDataURL: checklistUrl + "spec-list"
    });

    var RestDataSource_Class_Item= isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
           // {name: "checkListItem.titleFa",title: "نام فارسی", align: "center"},
             {name: "description",title: "توضیحات", align: "center"},

             {name: "enableStatus",title: "وضعیت", align: "center"},
        ],
      fetchDataURL: classCheckListUrl+"spec-list",
       updateDataURL:classCheckListUrl + "edit",
    });


    var RestDataSource_SelectCheckList = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"}
        ],
        fetchDataURL:checklistUrl + "spec-list?_startRow=0&_endRow=55",
    });

    var RestDataSource_CheckListItem = isc.TrDS.create({
        fields: [
           {name: "id", hidden: true},
          {name:"checkListId",hidden:true},
           {name: "titleFa", title: "نام فارسی", align: "center"},
           {name: "group", title: "گروه",align: "center"},
               ],
         // updateDataURL:classCheckListUrl + "edit",
    });


    var ToolStripButton_CheckList_Refresh = isc.ToolStripButton.create({
        icon: "<spring:url value="refresh.png"/>",
        title: "بازخوانی اطلاعات",
        click: function () {
            ListGrid_CheckList.invalidateCache();
        }
    });
    var ToolStripButton_CheckList_Edit = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "ویرایش",
        click: function () {
            show_CheckListEditForm();
        }
    });
    var ToolStripButton_CheckList_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "ایجاد",
        click: function () {
            show_CheckListAddForm();
        }
    });
    var ToolStripButton_CheckList_Remove = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "حذف",
        click: function () {
            show_CheckListDeleteForm();
        }
    });
    //---------------------------------------------------------------------------
    var ToolStripButton_CheckListItem_Refresh = isc.ToolStripButton.create({
        icon: "<spring:url value="refresh.png"/>",
        title: "بازخوانی اطلاعات",
        click: function () {
            ListGrid_CheckListItem.invalidateCache();
            ListGrid_CheckListItem_DetailViewer.setData([]);
        }
    });
    var ToolStripButton_CheckListItem_Edit = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "ویرایش",
        click: function () {

        }
    });
    var ToolStripButton_CheckListItem_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "ایجاد",
        click: function () {
         show_CheckListItemAddForm();
        }
    });
    var ToolStripButton_CheckListItem_Remove = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "حذف",
        click: function () {

        }
    });

    //============================================================================

    isc.ToolStrip.create({
        ID: "gridEditControls",
        width: "100%", height: 24,
        members: [
            isc.Label.create({
                padding: 5,
                ID: "totalsLabel"
            }),
            isc.LayoutSpacer.create({width: "*"}),
            isc.ToolStripButton.create({
                icon: "[SKIN]/actions/edit.png",
                prompt: "Edit selected record",
                click: function () {
                    var record = ListGrid_CheckList.getSelectedRecord();
                    if (record == null) return;
                    ListGrid_CheckList.startEditing(ListGrid_CheckList.data.indexOf(record));
                }
            }),
            isc.ToolStripButton.create({
                icon: "[SKIN]/actions/remove.png",
                prompt: "Remove selected record",
                click: function () {
                    var record = ListGrid_CheckList.getSelectedRecord();
                    if (record == null) return;
                    // ListGrid_CheckList.startEditing(ListGrid_CheckList.data.indexOf(record));
                    //  data=DynamicForm_CheckList.getValues();
                    // var CheckList_Save_Url = checklist;
                    ;
                }
            })
        ]
    });

    var ListGrid_CheckListItem = isc.ListGrid.create({
        //ID: "ListGrid_CheckListItem",
       // alternateRecordStyles: true,
       // showFilterEditor: true,
       // editEvent: "click",
        // autoFetchData:true,
      //  editByCell: true,
      //  modalEditing: true,
        dataSource: RestDataSource_CheckListItem,
        //     fields: [
        //     {name: "id", hidden: true},
        //     {name: "titleFa", title: "نام فارسی", align: "center"},
        //     {name: "group", title: "گروه",align: "center"},
        // ],
    })

     var ListGrid_CheckList = isc.ListGrid.create({
        alternateRecordStyles: true,
        dataSource: RestDataSource_CheckList,
        fields: [
            {name: "id", hidden: true},
            {name: "titleFa", title: "نام فارسی", align: "center"},
        ],
         click: function () {
         var record=ListGrid_CheckList.getSelectedRecord();
         RestDataSource_CheckListItem.fetchDataURL=checklistUrl + record.id +"/getCheckListItem";
        ListGrid_CheckListItem.fetchData();
         ListGrid_CheckListItem.invalidateCache();
         },
        autoFetchData: true,
        showFilterEditor: true,
    })


    var ListGrid_CheckListItem_DetailViewer = isc.DetailViewer.create({
    autoFetchData:true,
        ID: "ListGrid_CheckListItem_DetailViewer",
        width: "100%",
        fields: [
            {name: "titleFa", title: "نام فارسی"},
            {name: "description", title: "توضیحات",
             formatCellValue:function (value, record, rowNum, colNum, grid) {
              if(typeof value ==="undefined")
               return "ندارد" ; else return value} , length: "250"},

            {name: "enableStatus", title: "وضعیت",
            formatCellValue:function (value, record, rowNum, colNum, grid) {
              if(value ===false ) return "غیر فعال";
              if(value=== true)  return "فعال"}

               },
        ],
        emptyMessage: "click a row in the grid"
    })


    //============================================================================
    var ToolStrip_Actions_CheckList = isc.ToolStrip.create({
        width: "100%",
        members: [ToolStripButton_CheckList_Refresh, ToolStripButton_CheckList_Add, ToolStripButton_CheckList_Edit, ToolStripButton_CheckList_Remove]
    });

    var ToolStrip_Actions_CheckListItem = isc.ToolStrip.create({
        width: "100%",
        members: [ToolStripButton_CheckListItem_Refresh, ToolStripButton_CheckListItem_Add, ToolStripButton_CheckListItem_Edit, ToolStripButton_CheckListItem_Remove]
    });


    HLayout_Action_CheckListItem = isc.HLayout.create({
        width: "100%",
        height: "3%",
        <%--border: "2px solid blue",--%>
        members: [ToolStrip_Actions_CheckListItem]
    });


    var HLayout_Action_CheckList = isc.HLayout.create({
        width: "100%",
        height: "3%",
        <%--border: "2px solid blue",--%>
        members: [ToolStrip_Actions_CheckList]
    });
    //========================DynamicForm==============================

    var DynamicForm_CheckList = isc.DynamicForm.create({
        ID: "DynamicForm_CheckList_Add",
        fields: [{name: "id", hidden: true},
            {
                name: "titleFa",
                title: "نام فارسی",
                required: true,
                type: 'text',
                height: 35,
                requiredMessage: "در نام فارسی می توانید از عدد و حروف انگلیسی هم استفاده کنید",
                width: "*",
               // validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber]
            },
        ]
    });

    var DynamicForm_CheckListItem_Add = isc.DynamicForm.create({
        ID: "DynamicForm_CheckListItem_Add",
        fields:
        [
        {name: "id", hidden: true},
        {name: "checkListId", hidden: true,},
        {name: "titleFa",title: "نام فارسی",type: 'text',required: true,height: 35,requiredMessage: "در نام فارسی می توانید از عدد و حروف انگلیسی هم استفاده کنید",width: "*",},
        {name: "group",title: "گروه",type: 'text',required: true,height: 35,width: "*"},
        ]
    });

    //=================================================================


    var VLayout_Body_CheckListItem = isc.VLayout.create({
        width: "100%",
        height: "100%",

        members: [HLayout_Action_CheckListItem, ListGrid_CheckListItem, ListGrid_CheckListItem_DetailViewer],
    });


    var VLayout_Body_CheckList = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [HLayout_Action_CheckList, ListGrid_CheckList],
    });

    //=================================================================
    var HLayout_Body = isc.HLayout.create({
        width: "100%",
        showEdges: true,
        members: [VLayout_Body_CheckList, VLayout_Body_CheckListItem]
    });

    //==========================================Window========================
    var Window_CheckList_Design = isc.Window.create({
        title: "طراحی چک لیست",
        autoSize: false,
        width: 900,
        height: 500,
        closeClick: function () {
            this.hide();
        },
        show: function () {
            this.Super("show", arguments);
            ListGrid_CheckList.fetchData();
            ListGrid_CheckList.refreshCells();

           // ListGrid_CheckListItem.fetchData();
           // ListGrid_CheckListItem.refreshCells();
        },
        items: [isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [HLayout_Body,

            ]
        })],
    });


    var Window_CheckList_Add = isc.Window.create({
        //  title: "ایجاد فرم",
        width: 300,
        items: [DynamicForm_CheckList, isc.MyHLayoutButtons.create({
            members: [isc.Button.create({
                title: "ذخیره",
                // icon: "pieces/16/save.png",
                click: function () {
                    if (CheckList_method === "POST") {
                        save_CheckList()
                    } else {
                        edit_CheckList();

                    }
                }


            }), isc.Button.create({
                title: "لغو",
                click: function () {
                    Window_CheckList_Add.close();
                }
            })],
        }),]
    });

    var  Window_CheckListItem_Add = isc.Window.create({

        width: 300,
        items: [DynamicForm_CheckListItem_Add, isc.MyHLayoutButtons.create({
            members: [isc.Button.create({
                title: "ذخیره",
                // icon: "pieces/16/save.png",
                click: function () {
                    if (CheckListItem_method === "POST") {
                        save_CheckListItem()
                    }
                }


            }), isc.Button.create({
                title: "لغو",
                click: function () {
                    Window_CheckListItem_Add.close();
                }
            })],
        }),]
    });

    //================================= تکمیل چک لیست===============================================تکمیل چک لیست=========================================تکمیل چک لیست======================================تکمیل چک لیست=====================
    var ListGrid_Class_Item = isc.ListGrid.create({
                showRowNumbers: false,

       height:500,
        editEvent: "click",
        editByCell: true,
        modalEditing: true,
       showGroupSummary: true,
       showGroupSummaryInHeader: true,
       groupStartOpen: "all",
       groupByField: ['checkListItem.group'],
       nullGroupTitle:"",
       dataSource: RestDataSource_Class_Item,
        fields: [
             {name:"checkListItem.group",title:"گروه",align:"center",hidden:true},
             {name: "id", primaryKey: true,hidden:true},
             {name: "checkListItem.titleFa",title: "نام فارسی", align: "center"},

             {name: "description",title: "توضیحات",canEdit:true, align: "center",

             //  changed: function (form, item, value) {
             //       changed_field = item.getGridColNum()}
             },
             {name: "enableStatus",title: "وضعیت",canEdit:true,type:"boolean", align: "center"},

        ],

            // editorExit: function (editCompletionEvent, record, newValue, rowNum, colNum) {
            // if (changed_field === colNum && editCompletionEvent==="enter") {
            //     record.description = newValue;
            //     var x = classCheckListUrl + "edit/" + record.id;
            //     var xx=JSON.stringify(record);
            //     isc.RPCManager.sendRequest(TrDSRequest(x, "POST", xx, "callback:editdescription(rpcResponse)"));
            // }
        // }


    });


    var HLayOut_thisCommittee_AddUsers_Jsp = isc.HLayout.create({
        width: 700,
        height: 30,
        border: "0px solid yellow",
        // layoutMargin: 2,
        align: "center",
              members: [ListGrid_Class_Item]
    });
    var VLayOut_User_Committee_Jsp = isc.VLayout.create({
        width: "*",
        // height: "350",
        autoDraw: false,
        border: "3px solid gray", layoutMargin: 5,
        members: [HLayOut_thisCommittee_AddUsers_Jsp]
    });

    var Window_Add_User_TO_Committee = isc.Window.create({
        title: "تکمیل چک لیست",
        width: 500,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,

        closeClick: function () {
            this.hide();
        },
        items: [
            VLayOut_User_Committee_Jsp
        ]
    });

    //==================================   تب چک لیست  =====================================
    isc.DynamicForm.create({
        width: "100%",
        height: "100%",
        align: "center",
        canSubmit: true,
        isGroup: true,
        titleWidth: 80,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: false,
        errorOrientation: "right",
        numCols: 8,
        items: [

             {
                name: "checkList",
                ID:"checkListDynamicFormField",
                title: "انتخاب فرم مورد نظر",
                textAlign: "center",
                optionDataSource: RestDataSource_SelectCheckList,
                 width: "150",
                changeOnKeypress: true,
                filterOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                filterFields: ["titleFa"],
                changed: function (form, item, value) {

                },
            },
            {
                type: "button",
                title: "تکمیل چک لیست",
                width: 150,
                showTitle: false,
                startRow: false,
                click: function () {
               if(!checkselected()){return;};
                var a2 =ListGrid_Class_JspClass.getSelectedRecord().id;
                isc.RPCManager.sendRequest(TrDSRequest(classCheckListUrl + "fill-Table/"+a2.toString(),"GET", null, "callback:fill(rpcResponse)"));

                }
            },
            isc.LayoutSpacer.create({
                width: "*"
            }),
            {
                type: "button",
                title: "طراحی چک لیست",
                width: 150,
                showTitle: false,
                startRow: false,
                click: function () {

                    Window_CheckList_Design.show();

                }
            }
        ]
    })

    //========================================FUNCTION=======================================

   function fill(resp) {
   checkselected();
    var a1 = checkListDynamicFormField.getValue();
    var a2 =ListGrid_Class_JspClass.getSelectedRecord().id;

        ListGrid_Class_Item.fetchData(
            {
                operator: "and", criteria: [
                    {fieldName: "tclassId", operator: "equals", value: a2},
                    {fieldName: "checkListItem.checkListId", operator: "equals", value: a1},
                ]
            }
        );
    Window_Add_User_TO_Committee.show();

    //     if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
    //         // }


    }
    ;
     function checkselected(){
    if(ListGrid_Class_JspClass.getSelectedRecord() == null)
    {
    {
                     var OK = isc.Dialog.create({
                    message: "لطفا  کلاس مورد نظر را انتخاب کنید",
                    icon: "[SKIN]say.png",
                    title: "انجام فرمان"
                        });
                        setTimeout(function () {
                            OK.close();
                        }, 3000);
                        return false;
     }

    }

   if ( typeof (checkListDynamicFormField.getValue()) === "undefined")

    {
        var OK = isc.Dialog.create({
            message: "لطفا فرم مورد نظر را انتخاب کنید",
            icon: "[SKIN]say.png",
            title: "انجام فرمان"
        });
        setTimeout(function () {
            OK.close();
        }, 3000);
        return false;
    }
      return  true;
    };

    function save_CheckList() {
        if (!DynamicForm_CheckList.validate()) {
            return;
        }
        var CheckList = DynamicForm_CheckList.getValues();
        var CheckList_Save_Url = checklistUrl;
        if (CheckList_method.localeCompare("PUT") == 0) {
            var Record = DynamicForm_CheckList.getSelectedRecord();
            CheckList_Save_Url += Record.id;
        }
        isc.RPCManager.sendRequest(TrDSRequest(CheckList_Save_Url, CheckList_method, JSON.stringify(CheckList), "callback:show_CheckListActionResult(rpcResponse)"));
    };

    function save_CheckListItem() {

          if (!DynamicForm_CheckListItem_Add.validate()) {
            return;
           }

           var CheckListItem = DynamicForm_CheckListItem_Add.getValues();
          // CheckListItem.checkListId=ListGrid_CheckList.getSelectedRecord().id;
          var checklistItem_Save_Url = checklistItemUrl;
        isc.RPCManager.sendRequest(TrDSRequest(checklistItem_Save_Url, CheckListItem_method, JSON.stringify(CheckListItem), "callback:show_CheckListItemActionResult(rpcResponse)"));
    };


    function edit_CheckList() {
        if (!DynamicForm_CheckList.validate()) {
            return;
        }
        var record = ListGrid_CheckList.getSelectedRecord();
        data = DynamicForm_CheckList.getValues();
        var CheckList_Save_Url = checklistUrl;
        isc.RPCManager.sendRequest(TrDSRequest(CheckList_Save_Url + record.id, CheckList_method, JSON.stringify(data), "callback:show_CheckListActionResult(rpcResponse)"));
    }


    function show_CheckListAddForm() {
        CheckList_method = "POST";
        DynamicForm_CheckList.clearValues();
        Window_CheckList_Add.setTitle("<spring:message code="create"/>");
        Window_CheckList_Add.show();


    };
    function show_CheckListItemAddForm() {
        var SelectedCheckList = ListGrid_CheckList.getSelectedRecord();
        if (SelectedCheckList == null || SelectedCheckList.id == null) {
            isc.Dialog.create({
                message: "فرمی انتخاب نشده است.",
                icon: "[SKIN]ask.png",
                title: "توجه",
                buttons: [isc.Button.create({title: "تائید"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        }
        else {
        CheckListItem_method = "POST";
        DynamicForm_CheckListItem_Add.clearValues();
        DynamicForm_CheckListItem_Add.getItem("checkListId").setValue(SelectedCheckList.id);
        Window_CheckListItem_Add.setTitle("<spring:message code="create"/>");
        Window_CheckListItem_Add.show();
        }
    };


    function show_CheckListDeleteForm() {
        var record = ListGrid_CheckList.getSelectedRecord();
        if (record == null || record.id == null) {

            isc.Dialog.create({
                message: "<spring:message code="msg.not.selected.record"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="course_Warning"/>",
                buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            isc.MyYesNoDialog.create({
                message: "آیا رکورد انتخاب شده حذف گردد؟",
                buttonClick: function (button, index) {
                    this.close();
                    if (index == 0) {
                        var CheckList_Save_Url = checklistUrl;
                        isc.RPCManager.sendRequest(TrDSRequest(CheckList_Save_Url + record.id, "DELETE", null, "callback:show_CheckListActionResult(rpcResponse)"));
                    }
                }
            });
        }

    };

    function show_CheckListEditForm() {

        var record = ListGrid_CheckList.getSelectedRecord();

        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "<spring:message code="msg.not.selected.record"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="course_Warning"/>",
                buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {

            CheckList_method = "PUT";
            DynamicForm_CheckList.clearValues();
            DynamicForm_CheckList.editRecord(record);
            Window_CheckList_Add.setTitle("<spring:message code="edit"/>");
            Window_CheckList_Add.show();

        }
    };

    function show_CheckListActionResult(resp) {
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            ListGrid_CheckList.invalidateCache();
            // if (resp.data.length > 0) {
            var OK = isc.Dialog.create({
                message: "عملیات با موفقیت انجام شد",
                icon: "[SKIN]say.png",
                title: "انجام فرمان"
            });
            setTimeout(function () {
                OK.close();
            }, 3000);
            Window_CheckList_Add.close();
            // } else {
            //
            //     }

        } else {
            var OK = isc.Dialog.create({
                message: "ارتباط با سرور قطع می باشد",
                icon: "[SKIN]say.png",
                title: "انجام فرمان"
            });
            setTimeout(function () {
                OK.close();
            }, 3000);
        }

    };


     function show_CheckListItemActionResult(resp) {
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            ListGrid_CheckListItem.invalidateCache();
            // if (resp.data.length > 0) {
            var OK = isc.Dialog.create({
                message: "عملیات با موفقیت انجام شد",
                icon: "[SKIN]say.png",
                title: "انجام فرمان"
            });
            setTimeout(function () {
                OK.close();
            }, 3000);
            Window_CheckListItem_Add.close();
            // } else {
            //
            //     }

        } else {
            var OK = isc.Dialog.create({
                message: "ارتباط با سرور قطع می باشد",
                icon: "[SKIN]say.png",
                title: "انجام فرمان"
            });
            setTimeout(function () {
                OK.close();
            }, 3000);
        }

    };

