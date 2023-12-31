<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>
// <script>

    var committee_method = "POST";
    var committeeId;

    //************************************************************************************
    // RestDataSource & ListGrid
    //************************************************************************************
    var RestDataSource_committee = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "titleFa", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "subCategoryId", hidden: true},
            {name: "categoryId", hidden: true},
            {name: "category.titleFa", title: "<spring:message code="category"/>", filterOperator: "iContains"},
            {name: "subCategory.titleFa", title: "<spring:message code="subcategory"/>", filterOperator: "iContains"},
            {name: "tasks", title: "<spring:message code="tasks"/>", filterOperator: "iContains"},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains"},
        ],
        fetchDataURL: committeeUrl + "spec-list",
    });

    var RestDataSource_All_Person = isc.TrDS.create({
        fields: [
            {name: "id", hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "personnelNo", title: "<spring:message code="personnel.no"/>", filterOperator: "iContains", autoFitWidth: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "personnelNo2", title: "<spring:message code="personnel.no.6.digits"/>", filterOperator: "iContains", autoFitWidth: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true, width: "*"},
            {name: "employmentStatus", title: "<spring:message code="employment.status"/>", filterOperator: "iContains", autoFitWidth: true, detail: true},
            {name: "complexTitle", title: "<spring:message code="complex"/>", filterOperator: "iContains", autoFitWidth: true, detail: true},
            {name: "workPlaceTitle", title: "<spring:message code="work.place"/>", filterOperator: "iContains", autoFitWidth: true, detail: true},
            {name: "workTurnTitle", title: "<spring:message code="work.turn"/>", filterOperator: "iContains", detail: true, autoFitWidth: true},
        ],
        fetchDataURL: personnelUrl + "/iscList",
    });

    var RestDataSource_ThisCommittee_Person = isc.TrDS.create({

        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "firstName", width: "35%",  title: "<spring:message code="firstName"/>", align: "center"},
            {name: "lastName", width: "35%", align: "center", title: "<spring:message code="lastName"/>"},
            {name: "nationalCode", align: "center", width: "30%",  title: "<spring:message code="national.code"/>",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            }
        ],

    });


    var Ds_Member_Attached_Committee = isc.TrDS.create({
        fields: [{name: "id", primaryKey: true, hidden: true},
            {name: "firstName", width: "35%",title: "<spring:message code="firstName"/>", align: "center"},
            {name: "lastName", width: "35%", align: "center", title: "<spring:message code="lastName"/>"},
            {name: "nationalCode", align: "center", width: "30%", title: "<spring:message code="national.code"/>",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            }
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

    var Menu_ListGrid_committee = isc.Menu.create({
        data: [
            {
                   title: "<spring:message code="refresh"/>", click: function () {
                    ListGrid_Committee.invalidateCache();
                }
            }, {
                title: "<spring:message code="create"/>", click: function () {
                    show_CommitteeNewForm();
                }
            }, {
                title: "<spring:message code="edit"/>", click: function () {
                    show_CommitteEditForm();
                }
            }, {
                title: "<spring:message code="remove"/>", click: function () {
                    show_CommitteeRemoveForm();
                }
            }, {isSeparator: true}, {
                title: "<spring:message code="print.pdf"/>", click: function () {
                    print_CommitteeListGrid("pdf")
                }
            }, {
                title: "<spring:message code="print.excel"/>", click: function () {
                    print_CommitteeListGrid("excel")
                }
            }, {
                 title: "<spring:message code="print.html"/>", click: function () {
                    print_CommitteeListGrid("html")
                }
            }
            , {isSeparator: true}, {
                title: "<spring:message code="memberList"/>", click: function () {
                    ToolStripButton_Member.click();

                }

            }]
    });

    var ListGrid_Committee = isc.TrLG.create({
        dataSource: RestDataSource_committee,
        contextMenu: Menu_ListGrid_committee,
        autoFetchData: true,
        sortField: 1,
     // selectionChanged: function (record, state) {
     //
     //        // committeeId = record;
     //
     //
     // },

           recordDoubleClick: function () {
             show_CommitteEditForm();
        },

      selectionUpdated: function () {
            var record1 = ListGrid_Committee.getSelectedRecord();
            Ds_Member_Attached_Committee.fetchDataURL = committeeUrl + record1.id + "/getMembers";
            ListGrid_Member_Attached_Committee.invalidateCache();
            ListGrid_Member_Attached_Committee.fetchData();
        },

        dataArrived: function (startRow, endRow) {
        },

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
            for (let i = 0; i < dropRecords.getLength(); i++) {
                memberIds.add(dropRecords[i].personnelNo);
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
                       var OK = isc.Dialog.create({
                        message: "<spring:message code="msg.operation.error"/>",
                        icon: "[SKIN]say.png",
                        title: "<spring:message code="message"/>"
                     });
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
            for (let i = 0; i < dropRecords.getLength(); i++) {
                personIds.add(dropRecords[i].personnelNo);
            }
            ;
            var JSONObj = {"ids": personIds};
            isc.RPCManager.sendRequest({
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: committeeUrl + "addmembers/" + personIds + "/" + activeCommittee.id, //localhost:8080/training/api/committee/addmember/141/104
                httpMethod: "POST",
                data: JSON.stringify(JSONObj),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

                        ListGrid_ThisCommittee_Person.invalidateCache();
                        ListGrid_All_Person.invalidateCache();

                    } else {

                        var OK = isc.Dialog.create({
                        message: "<spring:message code="msg.operation.error"/>",
                        icon: "[SKIN]say.png",
                        title: "<spring:message code="message"/>"
                     });
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
// DsSubCategory_committee.fetchDataURL = categoryUrl + value;
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
                members: [isc.IButtonSave.create({
                    title: "<spring:message code="save"/>",
// icon: "pieces/16/save.png",
                    click: function () {
                        if (committee_method == "PUT") {
                            edit_Committee();
                        } else {
                            save_Committee();
                        }


                    }
                }), isc.IButtonCancel.create({
                    title: "<spring:message code="cancel"/>",
//icon: "<spring:url value="remove.png"/>",
                    click: function () {
                        Window_Committee.close();
                    }
                })],
            }),]
    });


    //**********************************************************************************
    //ToolStripButton
    //**********************************************************************************
    var ToolStripButton_Refresh = isc.ToolStripButtonRefresh.create({
//icon: "<spring:url value="refresh.png"/>",
        title: "<spring:message code="refresh"/>",
        click: function () {
            ListGrid_Committee.invalidateCache();
        }
    });
    var ToolStripButton_Edit = isc.ToolStripButtonEdit.create({
//icon: "[SKIN]/actions/edit.png",
        title: "<spring:message code="edit"/>",
        click: function () {
            show_CommitteEditForm();
        }
    });
    var ToolStripButton_Add = isc.ToolStripButtonAdd.create({

        title: "<spring:message code="create"/>",
        click: function () {
            committee_method = "POST";
            DynamicForm_Committee.getItem("subCategoryId").setOptionDataSource(null);
            show_CommitteeNewForm();

        }
    });
    var ToolStripButton_Remove = isc.ToolStripButtonRemove.create({
//icon: "[SKIN]/actions/remove.png",
        title: "<spring:message code="remove"/>",
        click: function () {
            show_CommitteeRemoveForm();
        }
    });
    var ToolStripButton_Print = isc.ToolStripButtonPrint.create({
        icon: "[SKIN]/RichTextEditor/print.png",
        title: "<spring:message code="print"/>",
        click: function () {
            print_CommitteeListGrid("pdf");
// "<spring:url value="/committee/printCommitteeWithMember/pdf" var="printUrl"/>"
// window.open('${printUrl}');

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
                title: "<spring:message code="add.member.committee"/>",
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
                title: "<spring:message code="memberList"/>",
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
// title: "لیست اعضای کمیته مورد نظر",
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
        title: "<spring:message code="memberList"/>",
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

        title: "<spring:message code="memberList"/>",
        click: function () {
            var record = ListGrid_Committee.getSelectedRecord();
            if (record == null || record.id == null) {
                isc.Dialog.create({
                    message: "<spring:message code="global.grid.record.not.selected"/>",
                    icon: "[SKIN]ask.png",
                    title: "<spring:message code="message"/>",
                    buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
                    buttonClick: function (button, index) {
                        this.close();
                    }
                });

            } else {

                // RestDataSource_All_Person.fetchDataURL = committeeUrl + record.id + "/unAttachMember";
                ListGrid_All_Person.invalidateCache();
                ListGrid_All_Person.fetchData();

                RestDataSource_ThisCommittee_Person.fetchDataURL = committeeUrl + record.id + "/getMembers";
                ListGrid_ThisCommittee_Person.invalidateCache();
                ListGrid_ThisCommittee_Person.fetchData();
                DynamicForm_thisCommitteeHeader_Jsp.setValue("sgTitle", getFormulaMessage(record.titleFa, "2", "red", "B"));
                SectionStack_Current_Skill_JspClass.setSectionTitle("sTitle", "<spring:message code="list.member.committee"/>" + " " + getFormulaMessage(record.titleFa, "2", "red", "B"));
                Window_Add_User_TO_Committee.show();


            }

        }
    });


    var ToolStrip_Actions = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            ToolStripButton_Add,
            ToolStripButton_Edit,
            ToolStripButton_Remove,
            ToolStripButton_Print,
            ToolStripButton_Member,
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh
                ]
            }),

        ]
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
                title: "<spring:message code="member.list"/>",
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
        Window_Committee.setTitle("<spring:message code="create"/>"),
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
        var sc = DynamicForm_Committee.getItem("subCategoryId").getSelectedRecord().titleFa
        var cate3 = DynamicForm_Committee.getItem("categoryId").getSelectedRecord().titleFa
        isc.RPCManager.sendRequest(TrDSRequest(committeeUrl + "findConflictCommittee/" + cate + "/" + subCate, "GET", null,"callback: show_ConflictCommittee(rpcResponse,'" + cate3 + "','" + sc + "')"));
    };


    function show_CommitteEditForm() {
        var record = ListGrid_Committee.getSelectedRecord();
        if (record == null || record.id == null) {
            isc.Dialog.create({
                message: "<spring:message code="msg.no.records.selected"/>",
                icon: "[SKIN]ask.png",
                title: "<spring:message code="course_Warning"/>",
                buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            committee_method = "PUT";
            Window_Committee.setTitle("<spring:message code="edit"/>");
            DynamicForm_Committee.clearValues();
            DsSubCategory_committee.fetchDataURL = categoryUrl + record.categoryId + "/sub-categories?_startRow=0&_endRow=55";
            DynamicForm_Committee.getItem("subCategoryId").optionDataSource = DsSubCategory_committee;
            DynamicForm_Committee.getItem("subCategoryId").fetchData();
            DynamicForm_Committee.editRecord(record);
            Window_Committee.show();

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
                buttons: [isc.IButtonSave.create({title: "<spring:message code="ok"/>"})],
                buttonClick: function (button, index) {
                    this.close();
                }
            });
        } else {
            isc.MyYesNoDialog.create({
                message: "<spring:message code="committee_delete"/>" + " " + getFormulaMessage(record.titleFa, 3, "red", "I") + " " + "<spring:message code="committee_delete1"/>",
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
        isc.RPCManager.sendRequest(TrDSRequest(committeeUrl + "findConflictWhenEdit/" + cateEdit + "/" + subCateEdit + "/" + committeeEditRecord.id, "GET", null, "callback: findConflictWhenEdit(rpcResponse)"));

    };

    function findConflictWhenEdit(resp) {
         setTimeout(function () {
             },900);
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            if (resp.data.length > 0) { //اگر در زمان ویرایش با خودش ویرایش شود
                var committeeDataEdit = DynamicForm_Committee.getValues();
                var committeeSaveUrlEdit = committeeUrl;
                var committeeEditRecord1 = ListGrid_Committee.getSelectedRecord();
                committeeSaveUrlEdit += committeeEditRecord1.id;

                isc.RPCManager.sendRequest(TrDSRequest(committeeSaveUrlEdit, "PUT", JSON.stringify(committeeDataEdit), "callback: show_CommitteeActionResult(rpcResponse)"));

            } else {
//اگر با کمیته دیگری تداخل داشته باشد

                var cate2 = DynamicForm_Committee.getValue("categoryId");
                var subCate2 = DynamicForm_Committee.getValue("subCategoryId");
                var sc = DynamicForm_Committee.getItem("subCategoryId").getSelectedRecord().titleFa
                var cate3 = DynamicForm_Committee.getItem("categoryId").getSelectedRecord().titleFa

                isc.RPCManager.sendRequest(TrDSRequest(committeeUrl + "findConflictCommittee/" + cate2 + "/" + subCate2, "GET", null, "callback: show_ConflictCommittee(rpcResponse,'" + cate3 + "','" + sc + "')"));

            }
        } else {
            var OK = isc.Dialog.create({
                message: "<spring:message code="msg.error.connecting.to.server"/>",
                icon: "[SKIN]say.png",
                title: "<spring:message code="message"/>"
            });
            setTimeout(function () {
                OK.close();
            }, 3000);
        }
    };


    function show_ConflictCommittee(resp, cat, subcat) {
        if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
            if (resp.data.length > 0) {
                var OK = isc.Dialog.create({
                    message: "گروه " + cat + " و زیر گروه " + subcat + " وارد شده با کمیته تخصصی " + getFormulaMessage(resp.data, 2, "red", "I") + " تداخل دارد",
                    icon: "[SKIN]say.png",
                    title: "<spring:message code="warning"/>"
                });
                setTimeout(function () {
                    OK.close();
                }, 3000);
            } else {
                let committeeDataEditCreate = DynamicForm_Committee.getValues();
                let committeeEditRecord = ListGrid_Committee.getSelectedRecord();
                let committeeSaveUrlEditCreate = committeeUrl;
                committeeSaveUrlEditCreate += committeeEditRecord.id;
                isc.RPCManager.sendRequest(TrDSRequest(committeeSaveUrlEditCreate, "PUT", JSON.stringify(committeeDataEditCreate), "callback: show_CommitteeActionResult(rpcResponse)"));
            }
        } else {
            var OK = isc.Dialog.create({
                message:  "<spring:message code="msg.error.connecting.to.server"/>",
                icon: "[SKIN]say.png",
                title: "<spring:message code="message"/>"
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
                    message: "<spring:message code="msg.operation.successful"/>",

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
                message: "<spring:message code="msg.operation.error"/>",
            });

            setTimeout(function () {
                MyOkDialog_committee.close();
            }, 3000);
        }
    };

    function print_CommitteeListGrid(type) {
        var advancedCriteria = ListGrid_Committee.getCriteria();
        var criteriaForm = isc.DynamicForm.create({
            method: "POST",
            action: "<spring:url value="/committee/printCommitteeWithMember/"/>" + type,
            target: "_Blank",
            canSubmit: true,
            fields:
                [
                    {name: "CriteriaStr", type: "hidden"},
                    {name: "token", type: "hidden"}
                ]

        })
        criteriaForm.setValue("CriteriaStr", JSON.stringify(advancedCriteria));
        criteriaForm.setValue("token", "<%= accessToken %>")
        criteriaForm.show();
        criteriaForm.submitForm();
    }

