<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>

// <script>

    var committee_method = "POST";
    var committeeId;

    //************************************************************************************
    // RestDataSource & ListGrid
    //************************************************************************************
    var RestDataSource_committee = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "نام ", filterOperator: "contains"},
            {name: "subCategoryId", hidden: true},
            {name: "categoryId", hidden: true},
            {name: "category.titleFa", title: "گروه", filterOperator: "contains"},
            {name: "subCategory.titleFa", title: "زیر گروه", filterOperator: "contains"},
            {name: "tasks", title: "وظایف", filterOperator: "contains"},
            {name: "description", title: "توضیحات", filterOperator: "contains"},
        ],
        fetchDataURL: committeeUrl + "spec-list",
    });

    var DsCategory_committee = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"}
        ],
        fetchDataURL: categoryUrl + "spec-list?_startRow=0&_endRow=55",
       });

    var DsSubCategory_committee = isc.MyRestDataSource.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"}
        ],
    });

    var ListGrid_Committee = isc.MyListGrid.create({
        dataSource: RestDataSource_committee,
        autoFetchData: true,
        doubleClick: function () {

        },
         selectionChanged: function (record, state)
         {
             committeeId=record;
         },
        sortField: 1,
    });

    //*************************************************************************************
    //DynamicForm & Window
    //*************************************************************************************
    var DynamicForm_Committee = isc.MyDynamicForm.create({

        // ID: "DynamicForm_Committee",
        fields: [
            {name: "id", hidden: true},
            {
                name: "titleFa",
                title: "<spring:message code="title"/>",
                required: true,
                //  keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F ]",
                length: "250",
                width: "*",
                validators: [MyValidators.NotEmpty, MyValidators.NotStartWithSpecialChar, MyValidators.NotStartWithNumber]
            },
            {
                name: "categoryId",
                title: "<spring:message code="course_category"/>",
                textAlign: "center",
                optionDataSource: DsCategory_committee,
                required: true,
                width: "*",
                changeOnKeypress: true,
                filterOnKeypress: true,
                displayField: "titleFa",
                valueField: "id",
                filterFields: ["titleFa"],
                changed: function (form, item, value) {
                    DynamicForm_Committee.getItem("subCategoryId").clearValue();
                    DynamicForm_Committee.getItem("subCategoryId").setValue();
                    DsSubCategory_committee.fetchDataURL = categoryUrl + value + "/sub-categories?_startRow=0&_endRow=55";
                    DynamicForm_Committee.getItem("subCategoryId").optionDataSource = DsSubCategory_committee;
                    DynamicForm_Committee.getItem("subCategoryId").fetchData();
                },
            },
            {
                name: "subCategoryId",
                title: "<spring:message code="course_subcategory"/>",
                prompt: "ابتدا گروه را انتخاب کنید",
                textAlign: "center",
                destroyed:true,
                required: true,
                width: "*",
                displayField: "titleFa",
                valueField: "id",
                filterFields: ["titleFa"],
            },
            {
                name: "tasks",
                title: "وظایف",
                type: "textArea",
                height: "40",
                length: "350", width: "*",
            },
            {
                name: "description",
                title: "توضیحات",
                type: "textArea",
                height: "40",
                length: "350", width: "*",
            }
        ]
    });
    var Window_Committee = isc.MyWindow.create({
        width: 600,
        items: [
            DynamicForm_Committee,
            isc.MyHLayoutButtons.create({
                members: [isc.MyButton.create({
                    title: "<spring:message code="save"/>",
                    icon: "pieces/16/save.png",
                    click: function () {
                        save_Committee();

                    }
                }), isc.MyButton.create({
                    title: "<spring:message code="cancel"/>",
                    icon: "pieces/16/icon_delete.png",
                    click: function () {
                        Window_Committee.close();
                    }
                })],
            }),]
    });


    //**********************************************************************************
    //ToolStripButton
    //**********************************************************************************
    var ToolStripButton_Refresh = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/refresh.png",
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_Committee.invalidateCache();
        }
    });
    var ToolStripButton_Edit = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/edit.png",
        title: "<spring:message code="edit"/>",
        click: function () {
            show_CommitteEditForm();
        }
    });
    var ToolStripButton_Add = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/add.png",
        title: "<spring:message code="create"/>",
        click: function () {
            committee_method = "POST";
            DynamicForm_Committee.getItem("subCategoryId").setOptionDataSource(null);
           show_CommitteeNewForm();

        }
    });
    var ToolStripButton_Remove = isc.ToolStripButton.create({
        icon: "[SKIN]/actions/remove.png",
        title: "<spring:message code="remove"/>",
        click: function () {
            show_CommitteeRemoveForm();
        }
    });
    var ToolStripButton_Print = isc.ToolStripButton.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title:"<spring:message code="print"/>",
        click: function () {
            //    print_TermListGrid("pdf");
        }

    });
              var  DynamicForm_thisCommitteeHeader_Jsp = isc.DynamicForm.create({
        titleWidth: "400",
        width: "700",
        align: "right",
        autoDraw: false,


        fields: [

            {
                name: "sgTitle",
                type: "staticText",
                title: "افزودن اعضا به کمیته",
                wrapTitle: false,
                width: 250
            }
        ]
    });

             var SectionStack_All_Skills_Jsp = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "50%",
        sections: [
            {
                title: "لیست اعضا",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                  //  ListGrid_AllSkills
                ]
            }
        ]
    });

    var SectionStack_Current_Skill_JspClass = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "50%",
        sections: [
            {
                name: "sTitle",
              //  title: "لیست اعضای کمیته مورد نظر",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                 //   ListGrid_ForThisSkillGroup_GetSkills
                ]
            }
        ]
    });

         var  HStack_Committee_AddUsers_Jsp= isc.HStack.create({
        membersMargin: 10,
        height: 500,
        members: [
            SectionStack_All_Skills_Jsp,
            SectionStack_Current_Skill_JspClass
        ]
    });


        var HLayOut_thisCommittee_AddUsers_Jsp = isc.HLayout.create({
        width: 700,
        height: 30,
        border: "0px solid yellow",
        layoutMargin: 5,
        align: "center",
        onCreate: function () {
            alert("man toye hlayout hastam");

        },
        members: [
            DynamicForm_thisCommitteeHeader_Jsp
        ]
    });

        var   VLayOut_User_Committee_Jsp = isc.VLayout.create({
        width: "100%",
        height: "300",
        autoDraw: false,
        border: "3px solid gray", layoutMargin: 5,
        members: [ HLayOut_thisCommittee_AddUsers_Jsp,
            HStack_Committee_AddUsers_Jsp,
          ]
    });

    var Window_Add_User_TO_Committee = isc.Window.create({
        title: "لیست اعضا",
        width: "900",
        height: "400",
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: true,

        closeClick: function () {


           // ListGrid_Skill_Group_Competence.invalidateCache();
           // ListGrid_Skill_Group_Skills.invalidateCache();
            this.hide();
        },
        items: [
         VLayOut_User_Committee_Jsp
        ]
    });


    var ToolStripButton_Member = isc.ToolStripButton.create({
        icon: "pieces/512/skill-standard.png",
        title: "لیست اعضا",
        click: function () {
            var record = ListGrid_Committee.getSelectedRecord();
               if (record == null || record.id == null) {
               isc.Dialog.create({
                    message: "کمیته ای انتخاب نشده است",
                    icon: "[SKIN]ask.png",
                    title: "پیام",
                    buttons: [isc.Button.create({title: "تائید"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });

            } else {

              DynamicForm_thisCommitteeHeader_Jsp.setValue("sgTitle",getFormulaMessage(record.titleFa, "2", "red", "B"));
              SectionStack_Current_Skill_JspClass.setSectionTitle("sTitle","لیست اعضای کمیته :"+" "+ getFormulaMessage(record.titleFa, "2", "red", "B"));
              Window_Add_User_TO_Committee.show();


            }
        }
    });


    var ToolStrip_Actions = isc.ToolStrip.create({
        width: "100%",
        members: [ToolStripButton_Refresh, ToolStripButton_Add, ToolStripButton_Edit, ToolStripButton_Remove, ToolStripButton_Print,ToolStripButton_Member]
    });

    //***********************************************************************************
    //HLayout
    //***********************************************************************************
    var HLayout_Actions_Group = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions]
    });

    var HLayout_Grid_Committee = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_Committee]
    });

    var VLayout_Body_Group = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [ HLayout_Actions_Group
            , HLayout_Grid_Committee
        ]
    });


    //************************************************************************************
    //function
    //************************************************************************************

    function show_CommitteeNewForm() {
        committee_method = "POST";
        Window_Committee.setTitle("ایجاد"),
        DynamicForm_Committee.clearValues();
        Window_Committee.show();
        DynamicForm_Committee.clearValues();
    };

    function save_Committee() {
        if (!DynamicForm_Committee.validate()) {
            return;
        }
        var committeeData = DynamicForm_Committee.getValues();
        var committeeSaveUrl = committeeUrl;
        if (committee_method.localeCompare("PUT") == 0) {
            var committeeRecord = ListGrid_Committee.getSelectedRecord();
            committeeSaveUrl += committeeRecord.id;
        }
        isc.RPCManager.sendRequest(MyDsRequest(committeeSaveUrl, committee_method, JSON.stringify(committeeData), "callback: show_CommitteeActionResult(rpcResponse)"));

    };

    function show_CommitteEditForm() {
        var record = ListGrid_Committee.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "<spring:message code="msg.record.not.selected"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="course_Warning"/>",
                buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            committee_method = "PUT";
            Window_Committee.setTitle("ویرایش");
            Window_Committee.show();
            DynamicForm_Committee.clearValues();
            DsSubCategory_committee.fetchDataURL = categoryUrl + record.categoryId + "/sub-categories?_startRow=0&_endRow=55";
            DynamicForm_Committee.getItem("subCategoryId").optionDataSource = DsSubCategory_committee;
            DynamicForm_Committee.getItem("subCategoryId").fetchData();
            DynamicForm_Committee.editRecord(record);

        }
    };

    function show_CommitteeRemoveForm() {
        var record = ListGrid_Committee.getSelectedRecord();
        if (record == null || record.id == null) {

            <%--// simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.record.not.selected"/>", 2000, "say");--%>
            isc.Dialog.create({
                message: "<spring:message code="msg.record.not.selected"/>",
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
                        isc.RPCManager.sendRequest(MyDsRequest(committeeUrl + record.id, "DELETE", null, "callback: show_CommitteeActionResult(rpcResponse)"));
                    }
                }
            });
        }

    };

    function show_CommitteeActionResult(resp) {
        var respCode = resp.httpResponseCode;
        if (respCode == 200 || respCode == 201) {
            ListGrid_Committee.invalidateCache();
            var MyOkDialog_job = isc.MyOkDialog.create({
                message: "عمليات با موفقيت اجرا شد.",

            });

            setTimeout(function () {
                MyOkDialog_job.close();
            }, 3000);

            Window_Committee.close();
        } else {
            var MyOkDialog_job = isc.MyOkDialog.create({
                message: "خطا در اجراي عمليات! کد خطا: " + resp.httpResponseCode,
            });

            setTimeout(function () {
                MyOkDialog_job.close();
            }, 3000);
        }
    };

