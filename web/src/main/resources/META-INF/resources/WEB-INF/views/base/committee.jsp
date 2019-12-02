<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
//<script>

    var committee_method = "POST";
    var committeeId;

    //************************************************************************************
    // RestDataSource & ListGrid
    //************************************************************************************
    var RestDataSource_committee = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "عنوان ", filterOperator: "iContains"},
            {name: "subCategoryId", hidden: true},
            {name: "categoryId", hidden: true},
            {name: "category.titleFa", title: "گروه", filterOperator: "iContains"},
            {name: "subCategory.titleFa", title: "زیر گروه", filterOperator: "iContains"},
            {name: "tasks", title: "وظایف", filterOperator: "iContains"},
            {name: "description", title: "توضیحات", filterOperator: "iContains"},
        ],
        fetchDataURL: committeeUrl + "spec-list",
    });

    var RestDataSource_All_Person = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true, hidden: true},
            {name: "firstNameFa", width: "35%", title: "نام", align: "center"},
            {name: "lastNameFa", width: "35%", align: "center", title: "نام خانوادگی"},
            {name: "nationalCode", align: "center", width: "30%", title: "کد ملی"}
        ],
        fetchDataURL: personalInfoUrl + "spec-list",
    });

    var RestDataSource_ThisCommittee_Person = isc.TrDS.create({

        fields: [{name: "id", primaryKey: true, hidden: true},
            {name: "firstNameFa", width: "35%", title: "نام", align: "center"},
            {name: "lastNameFa", width: "35%", align: "center", title: "نام خانوادگی"},
            {name: "nationalCode", align: "center", width: "30%", title: "کد ملی"}
        ],

    });


    var Ds_Member_Attached_Committee = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true, hidden: true},
            {name: "firstNameFa", width: "35%", title: "نام", align: "center"},
            {name: "lastNameFa", width: "35%", align: "center", title: "نام خانوادگی"},
            {name: "nationalCode", align: "center", width: "30%", title: "کد ملی"}
        ],
        autoFetchData: false,
    });

    var DsCategory_committee = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"}
        ],
        fetchDataURL: categoryUrl + "spec-list?_startRow=0&_endRow=55",
    });

    var DsSubCategory_committee = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa"}
        ],
    });

    Menu_ListGrid_committee = isc.Menu.create({
        data: [
            {
                title: "بازخوانی اطلاعات", icon: "<spring:url value="refresh.png"/>", click: function () {
                    ListGrid_Committee.invalidateCache();
                }
            }, {
                title: "ایجاد", icon: "<spring:url value="create.png"/>", click: function () {
                    show_CommitteeNewForm();
                }
            }, {
                title: "ویرایش", icon: "<spring:url value="edit.png"/>", click: function () {
                    show_CommitteEditForm();
                }
            }, {
                title: "حذف", icon: "<spring:url value="remove.png"/>", click: function () {
                    show_CommitteeRemoveForm();
                }
            }, {isSeparator: true}, {
                title: "ارسال به Pdf", icon: "<spring:url value="pdf.png"/>", click: function () {
                    print_CommitteeListGrid("pdf")
                }
            }, {
                title: "ارسال به Excel", icon: "<spring:url value="excel.png"/>", click: function () {
                    print_CommitteeListGrid("excel")
                }
            }, {
                title: "ارسال به Html", icon: "<spring:url value="html.png"/>", click: function () {
                    print_CommitteeListGrid("html")
                }
            }
            , {isSeparator: true}, {
                title: "لیست اعضاء", icon: "<spring:url value="CommitteeMembers.png"/>", click: function () {
                    ToolStripButton_Member.click();

                }

            }]
    });

    var ListGrid_Committee = isc.TrLG.create({
        dataSource: RestDataSource_committee,
        contextMenu: Menu_ListGrid_committee,
        autoFetchData: true,
        doubleClick: function () {
         show_CommitteEditForm();
        },

        selectionChanged: function (record, state) {
            committeeId = record;


        },
        click: function () {
            var record1 = ListGrid_Committee.getSelectedRecord();
            Ds_Member_Attached_Committee.fetchDataURL = committeeUrl + record1.id + "/getMembers";
            ListGrid_Member_Attached_Committee.invalidateCache();
            ListGrid_Member_Attached_Committee.fetchData();

        },

        dataArrived: function (startRow, endRow) {
        },
        sortField: 1,
    });

    var ListGrid_Member_Attached_Committee = isc.TrLG.create({
        dataSource: Ds_Member_Attached_Committee,
        selectionType: "none",
        sortField: 1

    });

    var ListGrid_All_Person = isc.TrLG.create({
        width: "100%",
        height: "100%", canDragResize: true,
        canDragRecordsOut: true,
        canAcceptDroppedRecords: true,
        autoFetchData: true,
        dataSource: RestDataSource_All_Person,
        selectionType: "multiple",
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 22,
        showFilterEditor: true,
        filterOnKeypress: true,
        dragTrackerMode: "title",
        canDrag: true,
        recordDrop: function (dropRecords, targetRecord, index, sourceWidget) {


            var activeCommittee = ListGrid_Committee.getSelectedRecord();

            var memberIds = new Array();
            for (i = 0; i < dropRecords.getLength(); i++) {
                memberIds.add(dropRecords[i].id);
            }
            ;

            var JSONObj = {"ids": memberIds};
            isc.RPCManager.sendRequest({

                // isc.RPCManager.sendRequest(TrDSRequest(committeeSaveUrl, committee_method, JSON.stringify(committeeData), "callback: show_CommitteeActionResult(rpcResponse)"));
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: committeeUrl + "removeMembers/" + activeCommittee.id + "/" + memberIds,
                httpMethod: "DELETE",
                data: JSON.stringify(JSONObj),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

                        ListGrid_All_Person.invalidateCache();
                        ListGrid_ThisCommittee_Person.invalidateCache();


                    } else {
                        isc.say("خطا");
                    }
                }
            });
        }

    });


    var ListGrid_ThisCommittee_Person = isc.TrLG.create({
        width: "100%",
        height: "100%", canDragResize: true,
        selectionType: "multiple",
        canDragRecordsOut: true,
        canAcceptDroppedRecords: true,
        autoFetchData: false,
        dataSource: RestDataSource_ThisCommittee_Person,

        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 22,
        showFilterEditor: true,
        filterOnKeypress: true,
        dragTrackerMode: "title",
        canDrag: true,
        recordDrop: function (dropRecords, targetRecord, index, sourceWidget) {
            var activeCommittee = ListGrid_Committee.getSelectedRecord();
            var personIds = new Array();
            for (i = 0; i < dropRecords.getLength(); i++) {
                personIds.add(dropRecords[i].id);
            }
            ;
            var JSONObj = {"ids": personIds};
            isc.RPCManager.sendRequest({
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: committeeUrl + "addmembers/" + personIds + "/" + activeCommittee.id,     //localhost:8080/training/api/committee/addmember/141/104
                httpMethod: "POST",
                data: JSON.stringify(JSONObj),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

                        ListGrid_ThisCommittee_Person.invalidateCache();
                        ListGrid_All_Person.invalidateCache();

                    } else {

                        isc.say("خطا");
                    }
                }
            });
        }

    });


    //*************************************************************************************
    //DynamicForm & Window
    //*************************************************************************************
    var DynamicForm_Committee = isc.DynamicForm.create({


        fields: [
            {name: "id", hidden: true},
            {
                name: "titleFa",
                title: "<spring:message code="title"/>",
                required: true,
                length: "250",
                width: "*",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber]
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
               //    DsSubCategory_committee.fetchDataURL = categoryUrl + value;
                    DynamicForm_Committee.getItem("subCategoryId").optionDataSource = DsSubCategory_committee;
                    DynamicForm_Committee.getItem("subCategoryId").fetchData();
                },
            },
            {
                name: "subCategoryId",
                title: "<spring:message code="course_subcategory"/>",
                prompt: "ابتدا گروه را انتخاب کنید",
                textAlign: "center",
                destroyed: true,
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
    var Window_Committee = isc.Window.create({
        width: 600,
        items: [
            DynamicForm_Committee,
            isc.MyHLayoutButtons.create({
                members: [isc.Button.create({
                    title: "<spring:message code="save"/>",
                    icon: "pieces/16/save.png",
                    click: function () {
                     if (committee_method == "PUT") {
                       edit_Committee();
                    } else {
                        save_Committee();
                    }


                    }
                }), isc.Button.create({
                    title: "<spring:message code="cancel"/>",
                    icon: "<spring:url value="remove.png"/>",
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
        icon: "<spring:url value="refresh.png"/>",
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
        title: "<spring:message code="print"/>",
        click: function () {
          print_CommitteeListGrid("pdf");
       //  "<spring:url value="/committee/printCommitteeWithMember/pdf" var="printUrl"/>"
           //     window.open('${printUrl}');

        }

    });
    var DynamicForm_thisCommitteeHeader_Jsp = isc.DynamicForm.create({
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
                title: "لیست اعضاء",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_All_Person
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
                    ListGrid_ThisCommittee_Person
                ]
            }
        ]
    });

    var HStack_Committee_AddUsers_Jsp = isc.HStack.create({
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

    var VLayOut_User_Committee_Jsp = isc.VLayout.create({
        width: "100%",
        height: "300",
        autoDraw: false,
        border: "3px solid gray", layoutMargin: 5,
        members: [HLayOut_thisCommittee_AddUsers_Jsp,
            HStack_Committee_AddUsers_Jsp,
        ]
    });

    var Window_Add_User_TO_Committee = isc.Window.create({
        title: "لیست اعضاء",
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
        icon: "<spring:url value="CommitteeMembers.png"/>",
        title: "لیست اعضاء",
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

                RestDataSource_All_Person.fetchDataURL = committeeUrl + record.id + "/unAttachMember";
                ListGrid_All_Person.invalidateCache();
                ListGrid_All_Person.fetchData();

                RestDataSource_ThisCommittee_Person.fetchDataURL = committeeUrl + record.id + "/getMembers";
                ListGrid_ThisCommittee_Person.invalidateCache();
                ListGrid_ThisCommittee_Person.fetchData();
                DynamicForm_thisCommitteeHeader_Jsp.setValue("sgTitle", getFormulaMessage(record.titleFa, "2", "red", "B"));
                SectionStack_Current_Skill_JspClass.setSectionTitle("sTitle", "لیست اعضای کمیته :" + " " + getFormulaMessage(record.titleFa, "2", "red", "B"));
                Window_Add_User_TO_Committee.show();


            }

        }
    });


    var ToolStrip_Actions = isc.ToolStrip.create({
        width: "100%",
        members: [ToolStripButton_Refresh, ToolStripButton_Add, ToolStripButton_Edit, ToolStripButton_Remove, ToolStripButton_Print, ToolStripButton_Member]
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
        members: [HLayout_Actions_Group
            , HLayout_Grid_Committee
        ]
    });

    var HLayout_Committee_Member_Grid = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [
            ListGrid_Member_Attached_Committee
        ]
    });

    var HLayout_Tab_Committee_Member = isc.HLayout.create({
        width: "100%",
        height: "100%",

        members: [
            HLayout_Committee_Member_Grid
        ]
    });
    var Detail_Tab_Committee = isc.TabSet.create({
        tabBarPosition: "top",
        width: "100%",
        height: "100%",
        tabs: [
            {
                id: "TabPane_Committee_Member",
                title: "لیست عضوها",
                pane: HLayout_Tab_Committee_Member
            }
        ]
    });

    var VLayout_Tab_Committee = isc.VLayout.create({
        width: "100%",
        height: "50%",
        <%--border: "2px solid blue",--%>
        members: [Detail_Tab_Committee]
    });


    var VLayout_Committee_Body_All = isc.VLayout.create({
        width: "100%",
        height: "100%",

        members: [VLayout_Body_Group, VLayout_Tab_Committee]
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
        var cate = DynamicForm_Committee.getValue("categoryId");
        var subCate = DynamicForm_Committee.getValue("subCategoryId");
        isc.RPCManager.sendRequest(TrDSRequest(committeeUrl + "findConflictCommittee/" + cate + "/" + subCate, "GET", null, "callback: show_ConflictCommittee(rpcResponse)"));
    };


    function show_CommitteEditForm() {
        var record = ListGrid_Committee.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "<spring:message code="msg.no.records.selected"/>",
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
        committee_method = "DELETE";
        var record = ListGrid_Committee.getSelectedRecord();
        if (record == null || record.id == null) {

            <%--// simpleDialog("<spring:message code="message"/>", "<spring:message code="msg.record.not.selected"/>", 2000, "say");--%>
            isc.Dialog.create({
                message: "<spring:message code="msg.no.records.selected"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="course_Warning"/>",
                buttons: [isc.Button.create({title: "<spring:message code="ok"/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            isc.MyYesNoDialog.create({
                message: "<spring:message    code="committee_delete"/>" + " " + getFormulaMessage(record.titleFa, 3, "red", "I") + " " + "<spring:message code="committee_delete1"/>",
                buttonClick: function (button, index) {
                    this.close();
                    if (index == 0) {

                        isc.RPCManager.sendRequest(TrDSRequest(committeeUrl + record.id, "DELETE", null, "callback: show_CommitteeActionResult(rpcResponse)"));

                    }
                }
            });
        }

    };
            function edit_Committee() {
             var committeeEditRecord = ListGrid_Committee.getSelectedRecord();
             var cateEdit = DynamicForm_Committee.getValue("categoryId");
             var subCateEdit = DynamicForm_Committee.getValue("subCategoryId");
             isc.RPCManager.sendRequest(TrDSRequest(committeeUrl + "findConflictWhenEdit/" + cateEdit + "/" + subCateEdit + "/" +committeeEditRecord.id,"GET", null, "callback: findConflictWhenEdit(rpcResponse)"));

            };

             function  findConflictWhenEdit(resp)
            {
              if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            if (resp.data.length > 0) {                            //اگر در زمان ویرایش با خودش ویرایش شود
                  var committeeDataEdit = DynamicForm_Committee.getValues();
                 var committeeSaveUrlEdit = committeeUrl;
                 var committeeEditRecord1 = ListGrid_Committee.getSelectedRecord();
                 committeeSaveUrlEdit += committeeEditRecord1.id;
              isc.RPCManager.sendRequest(TrDSRequest(committeeSaveUrlEdit,"PUT", JSON.stringify(committeeDataEdit), "callback: show_CommitteeActionResult(rpcResponse)"));

            } else {
            //اگر با کمیته دیگری تداخل داشته باشد

             var cate2 = DynamicForm_Committee.getValue("categoryId");
             var subCate2 = DynamicForm_Committee.getValue("subCategoryId");
             var sc = DynamicForm_Committee.getItem("subCategoryId").getSelectedRecord().titleFa
              var cate3 = DynamicForm_Committee.getItem("categoryId").getSelectedRecord().titleFa

             isc.RPCManager.sendRequest(TrDSRequest(committeeUrl + "findConflictCommittee/" + cate2 + "/" + subCate2, "GET", null, "callback: show_ConflictCommittee(rpcResponse,'"+ cate3+"','"+ sc+ "')"));

            }
        } else {
            var OK = isc.Dialog.create({
                message: "پاسخی از سمت سرور دریافت نشد",
                icon: "[SKIN]say.png",
                title: "انجام فرمان"
            });
            setTimeout(function () {
                OK.close();
            }, 3000);
        }
            };




 function show_ConflictCommittee(resp,cat,subcat) {
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            if (resp.data.length > 0) {
                var OK = isc.Dialog.create({
                    message: "گروه "+  cat+  " و زیر گروه " + subcat+  " وارد شده با کمیته تخصصی " + getFormulaMessage(resp.data, 2, "red", "I") + " تداخل دارد",
                    icon: "[SKIN]say.png",
                    title: "هشدار"
                });
                setTimeout(function () {
                    OK.close();
                }, 3000);
            } else {

               var committeeDataEditCreate = DynamicForm_Committee.getValues();
               var committeeSaveUrlEditCreate = committeeUrl;
               var committeeEditRecord1 = ListGrid_Committee.getSelectedRecord();
               committeeSaveUrlEditCreate += committeeEditRecord1.id;
               isc.RPCManager.sendRequest(TrDSRequest(committeeSaveUrlEditCreate, "PUT", JSON.stringify(committeeDataEditCreate), "callback: show_CommitteeActionResult(rpcResponse)"));
            }
        } else {
            var OK = isc.Dialog.create({
                message: "پاسخی از سمت سرور دریافت نشد",
                icon: "[SKIN]say.png",
                title: "انجام فرمان"
            });
            setTimeout(function () {
                OK.close();
            }, 3000);
        }
    }

 function show_CommitteeActionResult(resp) {
        var respCode = resp.httpResponseCode;

        if (respCode == 200 || respCode == 201) {

            if ((committee_method == "POST" || committee_method == "PUT") || (committee_method == "DELETE" && resp.data == "true")) {
                ListGrid_Committee.invalidateCache();
                var MyOkDialog_committee = isc.MyOkDialog.create({
                    message: "عمليات با موفقيت اجرا شد.",

                });

                setTimeout(function () {
                    MyOkDialog_committee.close();
                }, 3000);

                Window_Committee.close();
            } else {
                var MyOkDialog_committee = isc.MyOkDialog.create({
                    message: "کمیته مورد نظر دارای عضو می باشد. قابل حذف نیست",

                });

                setTimeout(function () {
                    MyOkDialog_committee.close();
                }, 3000);
            }
        } else {
            var MyOkDialog_committee = isc.MyOkDialog.create({
                message: "خطا در اجراي عمليات! کد خطا: ",
            });

            setTimeout(function () {
                MyOkDialog_committee.close();
            }, 3000);
        }
    };

    function print_CommitteeListGrid(type) {
         var advancedCriteria = ListGrid_Committee.getCriteria();
        var criteriaForm = isc.DynamicForm.create({
            method: "GET",
            action: "<spring:url value="/committee/printCommitteeWithMember/"/>" + type,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "CriteriaStr", type: "hidden"},
                    {name:"token",type:"hidden"}
                ]

        })
         criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
         criteriaForm.setValue("token","<%= accessToken %>")
         criteriaForm.show();
         criteriaForm.submitForm();
    }

