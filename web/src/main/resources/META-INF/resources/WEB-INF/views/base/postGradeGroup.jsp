<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>

// <script>

    var method = "POST";
    var url;
    var wait;

    //////////////////////////////////////////////////////////////////////////////////////////////

    var RestDataSource_Post_Grade_Group_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {
                name: "titleFa",
                title: "<spring:message code='post.grade.group.titleFa'/>",
                filterOperator: "iContains"
            },
            {
                name: "titleEn",
                title: "<spring:message code='post.grade.group.titleEn'/>",
                filterOperator: "iContains"
            },
            {name: "description", title: "<spring:message code='description'/>"}
        ],
        fetchDataURL: postGradeGroupUrl + "spec-list"
    });

    var RestDataSource_Post_Grade_Group_PostGrades_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code"},
            {name: "titleFa"}
        ]
    });
    var RestDataSource_All_PostGrades = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleFa"}
        ],
        fetchDataURL: postGradeUrl + "iscList"
    });
    var RestDataSource_ForThisPostGroup_GetPosts = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code"},
            {name: "titleFa"}
        ]
    });

    ////////////////////////////////////////////////////////////////////////////////////////////////////////


    var ListGrid_Post_Grade_Group_Jsp = isc.TrLG.create({
        selectionType: "multiple",
        autoFetchData: true,
        sortField: 1,
        dataSource: RestDataSource_Post_Grade_Group_Jsp,
        // contextMenu: Menu_ListGrid_Post_Grade_Group_Jsp,
        selectionChange: function (record) {
            record = ListGrid_Post_Grade_Group_Jsp.getSelectedRecord();
            if (record !== null) {
                RestDataSource_Post_Grade_Group_PostGrades_Jsp.fetchDataURL = postGradeGroupUrl + record.id + "/getPostGrades";
                ListGrid_Grades_Post_Grade_Group_Jsp.fetchData();
                ListGrid_Grades_Post_Grade_Group_Jsp.invalidateCache();
            }
        },
        doubleClick: function () {
            ListGrid_Post_Grade_Group_edit();
        }
    });

    var DynamicForm_thisPostGradeGroupHeader_Jsp = isc.DynamicForm.create({
        titleWidth: "400",
        width: "700",
        align: "right",
        fields: [
            {
                name: "sgTitle",
                type: "staticText",
                title: "<spring:message code='post.grade.group.add.title'/>",
                wrapTitle: false,
                width: 250
            }
        ]
    });

    var ListGrid_AllPostGrades = isc.TrLG.create({
        width: "100%",
        height: "100%",
        canDragResize: true,
        canDragRecordsOut: true,
        canAcceptDroppedRecords: true,
        autoFetchData: false,
        showRowNumbers: false,
        dataSource: RestDataSource_All_PostGrades,
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code='post.grade.code'/>", align: "center", width: "20%"},
            {name: "titleFa", title: "<spring:message code='post.grade.title'/>", align: "center", width: "60%"}
        ],
        sortField: 1,
        sortDirection: "descending",
        dragTrackerMode: "title",
        canDrag: true,

        recordDrop: function (dropRecords) {
            var postGradeGroupId = ListGrid_Post_Grade_Group_Jsp.getSelectedRecord().id;
            var postGradeIds = [];
            for (var i = 0; i < dropRecords.getLength(); i++) {
                postGradeIds.add(dropRecords[i].id);
            }
            isc.RPCManager.sendRequest(TrDSRequest(postGradeGroupUrl + "removePostGrades/" + postGradeGroupId + "/" + postGradeIds,
                "DELETE", null, "callback: allPostGrade_remove_result(rpcResponse)"));
        }
    });

    var ListGrid_ForThisPostGradeGroup_GetPostGrades_Jpa = isc.TrLG.create({
        width: "100%",
        height: "100%",
        canDragRecordsOut: true,
        canAcceptDroppedRecords: true,
        showRowNumbers: false,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        autoFetchData: false,
        dataSource: RestDataSource_ForThisPostGroup_GetPosts,
        fields: [
            {name: "id", title: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code='post.grade.code'/>", align: "center", width: "20%"},
            {name: "titleFa", title: "<spring:message code='post.grade.title'/>", align: "center", width: "70%"},
            {name: "OnDelete", title: "حذف", align: "center"}
        ],

        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);
            if (fieldName === "OnDelete") {
                var recordCanvas = isc.HLayout.create({
                    height: 20,
                    width: "100%",
                    layoutMargin: 5,
                    membersMargin: 10,
                    align: "center"
                });
                var removeIcon = isc.ImgButton.create({
                    showDown: false,
                    showRollOver: false,
                    layoutAlign: "center",
                    src: "<spring:url value='remove.png'/>",
                    height: 16,
                    width: 16,
                    grid: this,
                    click: function () {
                        var activePostGradeGroup = ListGrid_Post_Grade_Group_Jsp.getSelectedRecord();
                        var postGradeIds = [record.id];
                        // postGradeIds.add(record.id);
                        isc.RPCManager.sendRequest(TrDSRequest(postGradeGroupUrl + "removePostGrades/" + activePostGradeGroup.id + "/" + postGradeIds,
                            "DELETE", null, "callback: postGrade_remove_result(rpcResponse)"));
                    }
                });
                recordCanvas.addMember(removeIcon);
                return recordCanvas;
            } else
                return null;
        },

        recordDrop: function (dropRecords) {
            var postGradeGroupId = ListGrid_Post_Grade_Group_Jsp.getSelectedRecord().id;
            var postGradeIds = [];
            for (var i = 0; i < dropRecords.getLength(); i++) {
                postGradeIds.add(dropRecords[i].id);
            }
            // var JSONObj = {"ids": postGradeIds};
            isc.RPCManager.sendRequest(TrDSRequest(postGradeGroupUrl + "addPostGrades/" + postGradeGroupId + "/" + postGradeIds,
                "POST", null, "callback: postGrade_add_result(rpcResponse)"));
        }
    });

    var SectionStack_All_Posts_Jsp = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "50%",
        sections: [
            {
                title: "<spring:message code="post.grade.list"/>",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_AllPostGrades
                ]
            }
        ]
    });

    var SectionStack_Current_Post_Grade_Jsp = isc.SectionStack.create({
        visibilityMode: "multiple",
        width: "50%",
        sections: [
            {
                title: "<spring:message code="post.grade.list"/>",
                expanded: true,
                canCollapse: false,
                align: "center",
                items: [
                    ListGrid_ForThisPostGradeGroup_GetPostGrades_Jpa
                ]
            }
        ]
    });

    var HStack_thisPostGradeGroup_AddPostGrade_Jsp = isc.HStack.create({
        membersMargin: 10,
        height: 500,
        members: [
            SectionStack_All_Posts_Jsp,
            SectionStack_Current_Post_Grade_Jsp
        ]
    });


    var HLayOut_thisPostGradeGroup_AddPostGrade_Jsp = isc.TrHLayout.create({
        height: "10%",
        border: "0px solid yellow",
        layoutMargin: 5,
        align: "center",

        members: [
            DynamicForm_thisPostGradeGroupHeader_Jsp
        ]
    });


    var VLayOut_PostGradeGroup_PostGrades_Jsp = isc.TrVLayout.create({
        border: "3px solid gray",
        layoutMargin: 5,
        members: [
            HLayOut_thisPostGradeGroup_AddPostGrade_Jsp,
            HStack_thisPostGradeGroup_AddPostGrade_Jsp
        ]
    });

    var Window_Add_PostGrade_to_PostGradeGroup_Jsp = isc.Window.create({
        title: "<spring:message code="post.grade.list"/>",
        width: "900",
        height: "400",
        align: "center",
        closeClick: function () {
            ListGrid_Grades_Post_Grade_Group_Jsp.invalidateCache();
            this.hide();
        },
        items: [
            VLayOut_PostGradeGroup_PostGrades_Jsp
        ]
    });

    var ListGrid_Grades_Post_Grade_Group_Jsp = isc.TrLG.create({
        dataSource: RestDataSource_Post_Grade_Group_PostGrades_Jsp,
        autoFetchData: false,
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {
                name: "code",
                title: "<spring:message code='post.grade.code'/>",
                filterOperator: "iContains",
                autoFitWidth: true
            },
            {name: "titleFa", title: "<spring:message code='post.grade.title'/>", filterOperator: "iContains"}
        ]
    });

    var DynamicForm_Post_Grade_Group_Jsp = isc.DynamicForm.create({
        width: "750",
        height: "150",
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
        showErrorText: false,
        titleAlign: "right",
        validateOnExit: true,
        numCols: 2,
        wrapTitle: false,
        colWidths: [140, "*"],
        margin: 10,
        padding: 5,
        fields: [
            {name: "id", hidden: true},
            {
                name: "titleFa",
                title: "<spring:message code='global.titleFa'/>",
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9 ]",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber]
            },
            {
                name: "titleEn",
                title: "<spring:message code='global.titleEn'/>",
                keyPressFilter: "[a-z|A-Z|0-9 |]",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber]
            },
            {
                name: "description",
                title: "<spring:message code='description'/>",
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9 ]",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber]
            }
        ]
    });


    var IButton_Post_Grade_Group_Exit_Jsp = isc.TrCancelBtn.create({
        icon: "<spring:url value="remove.png"/>",
        click: function () {
            Window_Post_Grade_Group_Jsp.close();
        }
    });

    var IButton_Post_Grade_Group_Save_Jsp = isc.TrSaveBtn.create({
        click: function () {
            DynamicForm_Post_Grade_Group_Jsp.validate();
            if (DynamicForm_Post_Grade_Group_Jsp.hasErrors()) {
                return;
            }
            var data = DynamicForm_Post_Grade_Group_Jsp.getValues();
            isc.RPCManager.sendRequest(TrDSRequest(url, method, JSON.stringify(data),
                "callback: post_grade_group_save_result(rpcResponse)"));
        }
    });

    var HLayOut_Post_Grade_GroupSaveOrExit_Jsp = isc.TrHLayoutButtons.create({
        members: [IButton_Post_Grade_Group_Save_Jsp, IButton_Post_Grade_Group_Exit_Jsp]
    });

    var Window_Post_Grade_Group_Jsp = isc.Window.create({
        title: "<spring:message code='post.grade.group'/>",
        width: 700,
        height: 200,
        align: "center",
        border: "1px solid gray",
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items: [isc.TrVLayout.create({
            members: [DynamicForm_Post_Grade_Group_Jsp, HLayOut_Post_Grade_GroupSaveOrExit_Jsp]
        })]
    });

    var ToolStripButton_Refresh_Post_Grade_Group_Jsp = isc.TrRefreshBtn.create({
        click: function () {
            ListGrid_Post_Grade_Group_refresh();
        }
    });
    var ToolStripButton_Edit_Post_Grade_Group_Jsp = isc.TrEditBtn.create({
        click: function () {
            ListGrid_Post_Grade_Group_edit();
        }
    });
    var ToolStripButton_Add_Post_Grade_Group_Jsp = isc.TrCreateBtn.create({
        click: function () {
            ListGrid_Post_Grade_Group_add();
        }
    });
    var ToolStripButton_Remove_Post_Grade_Group_Jsp = isc.TrRemoveBtn.create({
        click: function () {
            ListGrid_Post_Grade_Group_remove();
        }
    });

    var ToolStripButton_Add_Post_Grade_Group_AddPostGrade_Jsp = isc.ToolStripButton.create({
        icon: "<spring:url value="post.png"/>",
        title: "<spring:message code="post.grade.list"/>",
        click: function () {
            var record = ListGrid_Post_Grade_Group_Jsp.getSelectedRecord();
            if (record == null || record.id == null) {
                createDialog("info", "<spring:message code='msg.not.selected.record'/>");
            } else {
                ListGrid_AllPostGrades.fetchData();
                ListGrid_AllPostGrades.invalidateCache();
                RestDataSource_ForThisPostGroup_GetPosts.fetchDataURL = postGradeGroupUrl + record.id + "/getPostGrades";
                ListGrid_ForThisPostGradeGroup_GetPostGrades_Jpa.invalidateCache();
                ListGrid_ForThisPostGradeGroup_GetPostGrades_Jpa.fetchData();
                DynamicForm_thisPostGradeGroupHeader_Jsp.setValue("sgTitle", getFormulaMessage(record.titleFa, "2", "red", "B"));
                Window_Add_PostGrade_to_PostGradeGroup_Jsp.show();
            }
        }
    });

    /////////////////////////////////////////////////////////////////////////////////////////////

    var ToolStrip_Actions_Post_Grade_Group_Jsp = isc.ToolStrip.create({
        width: "100%",
        members: [ToolStripButton_Refresh_Post_Grade_Group_Jsp,
            ToolStripButton_Add_Post_Grade_Group_Jsp,
            ToolStripButton_Edit_Post_Grade_Group_Jsp,
            ToolStripButton_Remove_Post_Grade_Group_Jsp,
            ToolStripButton_Add_Post_Grade_Group_AddPostGrade_Jsp]
    });


    var HLayout_Actions_Post_Grade_Group_Jsp = isc.HLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_Post_Grade_Group_Jsp]
    });

    var Detail_Tab_Post_Grade_Group = isc.TabSet.create({
        tabBarPosition: "top",
        tabs: [
            {
                id: "TabPane_Post_Grade_Group_Post",
                title: "<spring:message code='post.grade.list'/>",
                pane: ListGrid_Grades_Post_Grade_Group_Jsp

            }
        ]
    });

    var HLayout_Tab_Post_Grade_Group = isc.TrHLayout.create({
        members: [Detail_Tab_Post_Grade_Group]
    });

    var HLayout_Grid_Post_Grade_Group_Jsp = isc.TrHLayout.create({
        members: [ListGrid_Post_Grade_Group_Jsp]
    });

    var VLayout_Body_Post_Grade_Group_Jsp = isc.TrVLayout.create({
        members: [
            HLayout_Actions_Post_Grade_Group_Jsp
            , HLayout_Grid_Post_Grade_Group_Jsp
            , HLayout_Tab_Post_Grade_Group
        ]

    });


    ///////////////////////////////////////////////functions/////////////////////////////////////////////////////

    function deletePostFromPostGroup(postId, postGroupId) {
        isc.RPCManager.sendRequest(TrDSRequest(postGroupUrl + "removePost/" + postGroupId + "/" + postId,
            "DELETE", null, "callback: delete_post_grade_result(rpcResponse)"));
    }

    function delete_post_grade_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_Grades_Post_Grade_Group_Jsp.invalidateCache();

        } else {
            createDialog("info", "<spring:message code="msg.operation.error"/>",
                "<spring:message code="message"/>");
        }
    }

    function post_grade_group_save_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            var responseID = JSON.parse(resp.data).id;
            var gridState = "[{id:" + responseID + "}]";

            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            setTimeout(function () {
                OK.close();
            }, 2000);
            ListGrid_Post_Grade_Group_refresh();
            setTimeout(function () {
                ListGrid_Post_Grade_Group_Jsp.setSelectedState(gridState);
            }, 1000);
            Window_Post_Grade_Group_Jsp.close();
        } else {
            createDialog("info", "<spring:message code="msg.operation.error"/>",
                "<spring:message code="message"/>");
        }
    }

    function postGrade_remove_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_AllPostGrades.invalidateCache();
            ListGrid_ForThisPostGradeGroup_GetPostGrades_Jpa.invalidateCache();
        } else {
            createDialog("info", "<spring:message code="msg.operation.error"/>",
                "<spring:message code="message"/>");
        }
    }

    function postGrade_add_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_ForThisPostGradeGroup_GetPostGrades_Jpa.invalidateCache();
            ListGrid_AllPostGrades.invalidateCache();
        } else {
            createDialog("info", "<spring:message code="msg.operation.error"/>",
                "<spring:message code="message"/>");
        }
    }

    function allPostGrade_remove_result(resp) {
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_ForThisPostGradeGroup_GetPostGrades_Jpa.invalidateCache();
            ListGrid_AllPostGrades.invalidateCache();
        } else {
            createDialog("info", "<spring:message code="msg.operation.error"/>",
                "<spring:message code="message"/>");
        }
    }

    function ListGrid_Post_Grade_Group_edit() {
        var record = ListGrid_Post_Grade_Group_Jsp.getSelectedRecord();
        if (record == null || record.id == null) {
            createDialog("info", "<spring:message code='msg.not.selected.record'/>");
        } else {
            DynamicForm_Post_Grade_Group_Jsp.clearValues();
            method = "PUT";
            url = postGradeGroupUrl + record.id;
            DynamicForm_Post_Grade_Group_Jsp.editRecord(record);
            Window_Post_Grade_Group_Jsp.show();
        }
    }

    function ListGrid_Post_Grade_Group_remove() {
        var record = ListGrid_Post_Grade_Group_Jsp.getSelectedRecord();
        if (record == null) {
            createDialog("info", "<spring:message code='msg.not.selected.record'/>");
        } else {
            var Dialog_Post_Grade_Group_remove = createDialog("ask", "<spring:message code='msg.record.remove.ask'/>",
                "<spring:message code='global.warning'/>");
            Dialog_Post_Grade_Group_remove.addProperties({
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
                        wait = createDialog("wait");
                        isc.RPCManager.sendRequest(TrDSRequest(postGradeGroupUrl + record.id, "DELETE", null,
                            "callback: Post_Grade_Group_remove_result(rpcResponse)"));
                    }
                }
            });
        }
    }

    function Post_Grade_Group_remove_result(resp) {
        wait.close();
        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
            ListGrid_Post_Grade_Group_Jsp.invalidateCache();
            var OK = createDialog("info", "<spring:message code="msg.operation.successful"/>",
                "<spring:message code="msg.command.done"/>");
            ListGrid_Grades_Post_Grade_Group_Jsp.setData([]);
            setTimeout(function () {
                OK.close();
            }, 2000);
        } else {
            createDialog("info", "<spring:message code="msg.operation.error"/>");
        }
    }

    function ListGrid_Post_Grade_Group_refresh() {
        ListGrid_Post_Grade_Group_Jsp.invalidateCache();
        ListGrid_Post_Grade_Group_Jsp.filterByEditor();
        ListGrid_Post_Grade_Group_Posts_refresh();
    }

    function ListGrid_Post_Grade_Group_add() {
        method = "POST";
        url = postGradeGroupUrl;
        DynamicForm_Post_Grade_Group_Jsp.clearValues();
        Window_Post_Grade_Group_Jsp.show();
    }

    function ListGrid_Post_Grade_Group_Posts_refresh() {
        if (ListGrid_Post_Grade_Group_Jsp.getSelectedRecord() == null)
            ListGrid_Grades_Post_Grade_Group_Jsp.setData([]);
        else {
            ListGrid_Grades_Post_Grade_Group_Jsp.invalidateCache();
            ListGrid_Grades_Post_Grade_Group_Jsp.filterByEditor();
        }
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////

    // </script>


<%--var Menu_ListGrid_Post_Grade_Group_Jsp = isc.Menu.create({--%>
<%--    width: 150,--%>
<%--    data: [{--%>
<%--        title: "بازخوانی اطلاعات", icon: "<spring:url value="refresh.png"/>", click: function () {--%>
<%--            ListGrid_Post_Grade_Group_refresh();--%>
<%--        }--%>
<%--    }, {--%>
<%--        title: " ایجاد", icon: "<spring:url value="create.png"/>", click: function () {--%>
<%--            ListGrid_Post_Grade_Group_add();--%>
<%--        }--%>
<%--    }, {--%>
<%--        title: "ویرایش", icon: "<spring:url value="edit.png"/>", click: function () {--%>
<%--            ListGrid_Post_Grade_Group_edit();--%>
<%--        }--%>
<%--    }, {--%>
<%--        title: "حذف", icon: "<spring:url value="remove.png"/>", click: function () {--%>
<%--            ListGrid_Post_Grade_Group_remove();--%>
<%--            &lt;%&ndash;var postGrouprecord = ListGrid_Post_Grade_Group_Jsp.getSelectedRecord();&ndash;%&gt;--%>
<%--            &lt;%&ndash;if (postGrouprecord == null || postGrouprecord.id == null) {&ndash;%&gt;--%>

<%--            &lt;%&ndash;simpleDialog("پیغام", "گروه پستی انتخاب نشده است.", 0, "stop");&ndash;%&gt;--%>

<%--            &lt;%&ndash;} else {&ndash;%&gt;--%>
<%--            &lt;%&ndash;isc.RPCManager.sendRequest({&ndash;%&gt;--%>
<%--            &lt;%&ndash;actionURL: postGroupUrl + postGrouprecord.id + "/canDelete",&ndash;%&gt;--%>
<%--            &lt;%&ndash;httpMethod: "GET",&ndash;%&gt;--%>
<%--            &lt;%&ndash;httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},&ndash;%&gt;--%>
<%--            &lt;%&ndash;useSimpleHttp: true,&ndash;%&gt;--%>
<%--            &lt;%&ndash;contentType: "application/json; charset=utf-8",&ndash;%&gt;--%>
<%--            &lt;%&ndash;showPrompt: false,&ndash;%&gt;--%>
<%--            &lt;%&ndash;// data: JSON.stringify(data1),&ndash;%&gt;--%>
<%--            &lt;%&ndash;serverOutputAsString: false,&ndash;%&gt;--%>
<%--            &lt;%&ndash;callback: function (resp) {&ndash;%&gt;--%>

<%--            &lt;%&ndash;if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {&ndash;%&gt;--%>

<%--            &lt;%&ndash;if (resp.data == "true") {&ndash;%&gt;--%>

<%--            &lt;%&ndash;ListGrid_Post_Grade_Group_remove();&ndash;%&gt;--%>

<%--            &lt;%&ndash;} else {&ndash;%&gt;--%>
<%--            &lt;%&ndash;msg = " گروه پست " + getFormulaMessage(postGrouprecord.titleFa, "2", "red", "B") + " بدلیل مرتبط بودن با شایستگی قابل حذف نمی باشد ";&ndash;%&gt;--%>
<%--            &lt;%&ndash;simpleDialog("خطا در حذف", msg, 0, "stop");&ndash;%&gt;--%>
<%--            &lt;%&ndash;}&ndash;%&gt;--%>
<%--            &lt;%&ndash;}&ndash;%&gt;--%>

<%--            &lt;%&ndash;}&ndash;%&gt;--%>
<%--            &lt;%&ndash;});&ndash;%&gt;--%>
<%--            &lt;%&ndash;}&ndash;%&gt;--%>
<%--        }--%>
<%--    }, {isSeparator: true},--%>
<%--        {--%>
<%--            title: "<spring:message code="print.SelectedRecords"/>",--%>
<%--            icon: "<spring:url value="print.png"/>",--%>
<%--            submenu: [--%>
<%--                {--%>
<%--                    title: "<spring:message code="format.pdf"/>", icon: "<spring:url value="pdf.png"/>",--%>
<%--                    click: function () {--%>
<%--                        var strPostrecords = "";--%>
<%--                        var selectedPostGroup = new Array();--%>
<%--                        var selectedPostGroup = ListGrid_Post_Grade_Group_Jsp.getSelectedRecords();--%>
<%--                        for (i = 0; i < selectedPostGroup.length; i++)--%>
<%--                            if (i == 0)--%>
<%--                                strPostrecords += selectedPostGroup[i].id;--%>
<%--                            else--%>
<%--                                strPostrecords += "," + selectedPostGroup[i].id--%>

<%--                        if (strPostrecords == "") {--%>
<%--                            isc.Dialog.create({--%>

<%--                                message: "<spring:message code="msg.postGroup.notFound"/>",--%>
<%--                                icon: "[SKIN]ask.png",--%>
<%--                                title: "پیام",--%>
<%--                                buttons: [isc.Button.create({title: "تائید"})],--%>
<%--                                buttonClick: function (button, index) {--%>
<%--                                    this.close();--%>
<%--                                }--%>
<%--                            });--%>

<%--                        } else {--%>


<%--                            "<spring:url value="/post-group/printSelected/pdf/" var="printUrl"/>"--%>
<%--                            window.open('${printUrl}' + strPostrecords);--%>
<%--                        }--%>

<%--                    }--%>
<%--                },--%>
<%--                {--%>
<%--                    title: "<spring:message code="format.excel"/>", icon: "<spring:url value="excel.png"/>",--%>
<%--                    click: function () {--%>
<%--                        var strPostrecords = "";--%>
<%--                        var selectedPostGroup = new Array();--%>
<%--                        var selectedPostGroup = ListGrid_Post_Grade_Group_Jsp.getSelectedRecords();--%>
<%--                        for (i = 0; i < selectedPostGroup.length; i++)--%>
<%--                            if (i == 0)--%>
<%--                                strPostrecords += selectedPostGroup[i].id;--%>
<%--                            else--%>
<%--                                strPostrecords += "," + selectedPostGroup[i].id--%>

<%--                        if (strPostrecords == "") {--%>
<%--                            isc.Dialog.create({--%>

<%--                                message: "<spring:message code="msg.postGroup.notFound"/>",--%>
<%--                                icon: "[SKIN]ask.png",--%>
<%--                                title: "پیام",--%>
<%--                                buttons: [isc.Button.create({title: "تائید"})],--%>
<%--                                buttonClick: function (button, index) {--%>
<%--                                    this.close();--%>
<%--                                }--%>
<%--                            });--%>

<%--                        } else {--%>


<%--                            "<spring:url value="/post-group/printSelected/excel/" var="printUrl"/>"--%>
<%--                            window.open('${printUrl}' + strPostrecords);--%>
<%--                        }--%>

<%--                    }--%>
<%--                },--%>
<%--                {--%>
<%--                    title: "<spring:message code="format.html"/>", icon: "<spring:url value="html.png"/>",--%>
<%--                    click: function () {--%>
<%--                        var strPostrecords = "";--%>
<%--                        var selectedPostGroup = new Array();--%>
<%--                        var selectedPostGroup = ListGrid_Post_Grade_Group_Jsp.getSelectedRecords();--%>
<%--                        for (i = 0; i < selectedPostGroup.length; i++)--%>
<%--                            if (i == 0)--%>
<%--                                strPostrecords += selectedPostGroup[i].id;--%>
<%--                            else--%>
<%--                                strPostrecords += "," + selectedPostGroup[i].id--%>

<%--                        if (strPostrecords == "") {--%>
<%--                            isc.Dialog.create({--%>

<%--                                message: "<spring:message code="msg.postGroup.notFound"/>",--%>
<%--                                icon: "[SKIN]ask.png",--%>
<%--                                title: "پیام",--%>
<%--                                buttons: [isc.Button.create({title: "تائید"})],--%>
<%--                                buttonClick: function (button, index) {--%>
<%--                                    this.close();--%>
<%--                                }--%>
<%--                            });--%>

<%--                        } else {--%>


<%--                            "<spring:url value="/post-group/printSelected/html/" var="printUrl"/>"--%>
<%--                            window.open('${printUrl}' + strPostrecords);--%>
<%--                        }--%>

<%--                    }--%>
<%--                }--%>
<%--            ]--%>
<%--        }, {--%>
<%--            title: "چاپ همه گروه پست ها", icon: "<spring:url value="pdf.png"/>", click: function () {--%>
<%--                "<spring:url value="/post-group/print/pdf" var="printUrl"/>"--%>
<%--                window.open('${printUrl}');--%>
<%--            }--%>
<%--        }, {--%>
<%--            title: "چاپ همه با جزئیات", icon: "<spring:url value="pdf.png"/>", click: function () {--%>
<%--                "<spring:url value="/post-group/printAll/pdf" var="printUrl"/>"--%>
<%--                window.open('${printUrl}');--%>
<%--            }--%>
<%--        }, {isSeparator: true}, {--%>
<%--            title: "حذف گروه پست از تمام شایستگی ها", icon: "<spring:url value="remove.png"/>", click: function () {--%>
<%--                var record = ListGrid_Post_Grade_Group_Jsp.getSelectedRecord();--%>


<%--                if (record == null || record.id == null) {--%>

<%--                    isc.Dialog.create({--%>

<%--                        message: "<spring:message code="msg.postGroup.notFound"/>",--%>
<%--                        icon: "[SKIN]ask.png",--%>
<%--                        title: "پیام",--%>
<%--                        buttons: [isc.Button.create({title: "تائید"})],--%>
<%--                        buttonClick: function (button, index) {--%>
<%--                            this.close();--%>
<%--                        }--%>
<%--                    });--%>
<%--                } else {--%>


<%--                    var Dialog_Delete = isc.Dialog.create({--%>
<%--                        message: getFormulaMessage("آیا از حذف  گروه پست:' ", "2", "black", "c") + getFormulaMessage(record.titleFa, "3", "red", "U") + getFormulaMessage(" از  کلیه شایستگی هایش ", "2", "black", "c") + getFormulaMessage("  مطمئن هستید؟", "2", "black", "c"),//"<font size='2' color='red'>"+"آیا از حذف گروه پست:' " +record.titleFa+ " ' مطمئن هستید؟" +"</font>",--%>
<%--                        icon: "[SKIN]ask.png",--%>
<%--                        title: "تائید حذف",--%>
<%--                        buttons: [isc.Button.create({title: "بله"}), isc.Button.create({--%>
<%--                            title: "خیر"--%>
<%--                        })],--%>
<%--                        buttonClick: function (button, index) {--%>
<%--                            this.close();--%>

<%--                            if (index == 0) {--%>
<%--                                deletePostGroupFromAllCompetence(record.id);--%>
<%--                                simpleDialog("پیغام", "حذف با موفقیت انجام گردید.", 0, "confirm");--%>
<%--                            }--%>
<%--                        }--%>
<%--                    });--%>

<%--                }--%>
<%--            }--%>
<%--        },--%>
<%--        {isSeparator: true}, {--%>
<%--            title: "لیست پست ها", icon: "<spring:url value="post.png"/>", click: function () {--%>
<%--                var record = ListGrid_Post_Grade_Group_Jsp.getSelectedRecord();--%>


<%--                if (record == null || record.id == null) {--%>

<%--                    isc.Dialog.create({--%>

<%--                        message: "<spring:message code="msg.postGroup.notFound"/>",--%>
<%--                        icon: "[SKIN]ask.png",--%>
<%--                        title: "پیام",--%>
<%--                        buttons: [isc.Button.create({title: "تائید"})],--%>
<%--                        buttonClick: function (button, index) {--%>
<%--                            this.close();--%>
<%--                        }--%>
<%--                    });--%>
<%--                } else {--%>

<%--                    // alert(record.id);--%>
<%--                    // RestDataSource_All_Posts.fetchDataURL = postGroupUrl + record.id + "/unAttachPosts";--%>
<%--                    // RestDataSource_All_Posts.invalidateCache();--%>
<%--                    // RestDataSource_All_Posts.fetchData();--%>
<%--                    ListGrid_AllPostGrades.fetchData();--%>
<%--                    ListGrid_AllPostGrades.invalidateCache();--%>


<%--                    RestDataSource_ForThisPostGroup_GetPosts.fetchDataURL = postGroupUrl + record.id + "/getPosts"--%>
<%--                    // RestDataSource_ForThisPostGroup_GetPosts.invalidateCache();--%>
<%--                    // RestDataSource_ForThisPostGroup_GetPosts.fetchData();--%>
<%--                    ListGrid_ForThisPostGradeGroup_GetPostGrades_Jpa.invalidateCache();--%>
<%--                    ListGrid_ForThisPostGradeGroup_GetPostGrades_Jpa.fetchData();--%>
<%--                    DynamicForm_thisPostGradeGroupHeader_Jsp.setValue("sgTitle", getFormulaMessage(record.titleFa, "2", "red", "B"));--%>
<%--                    Window_Add_PostGrade_to_PostGradeGroup_Jsp.show();--%>
<%--                }--%>
<%--            }--%>
<%--        }--%>
<%--    ]--%>
<%--});--%>


<%--var Menu_ListGrid_Post_Grade_Group_Posts = isc.Menu.create({--%>
<%--    width: 150,--%>
<%--    data: [{--%>
<%--        title: "بازخوانی اطلاعات", icon: "<spring:url value="refresh.png"/>", click: function () {--%>
<%--            ListGrid_Post_Grade_Group_Posts_refresh();--%>
<%--        }--%>
<%--    }, {--%>
<%--        title: " حذف پست از گروه پست مربوطه", icon: "<spring:url value="remove.png"/>", click: function () {--%>
<%--            activePostGroup = ListGrid_Post_Grade_Group_Jsp.getSelectedRecord();--%>
<%--            activePost = ListGrid_Grades_Post_Grade_Group_Jsp.getSelectedRecord();--%>
<%--            if (activePostGroup == null || activePost == null) {--%>
<%--                simpleDialog("پیام", "پست یا گروه پست انتخاب نشده است.", 0, "confirm");--%>

<%--            } else {--%>
<%--                var Dialog_Delete = isc.Dialog.create({--%>
<%--                    message: getFormulaMessage("آیا از حذف  پست:' ", "2", "black", "c") + getFormulaMessage(activePost.titleFa, "3", "red", "U") + getFormulaMessage(" از گروه پست:' ", "2", "black", "c") + getFormulaMessage(activePostGroup.titleFa, "3", "red", "U") + getFormulaMessage(" ' مطمئن هستید؟", "2", "black", "c"),//"<font size='2' color='red'>"+"آیا از حذف گروه پست:' " +record.titleFa+ " ' مطمئن هستید؟" +"</font>",--%>
<%--                    icon: "[SKIN]ask.png",--%>
<%--                    title: "تائید حذف",--%>
<%--                    buttons: [isc.Button.create({title: "بله"}), isc.Button.create({--%>
<%--                        title: "خیر"--%>
<%--                    })],--%>
<%--                    buttonClick: function (button, index) {--%>
<%--                        this.close();--%>

<%--                        if (index == 0) {--%>
<%--                            deletePostFromPostGroup(activePost.id, activePostGroup.id);--%>
<%--                        }--%>
<%--                    }--%>
<%--                });--%>

<%--            }--%>
<%--        }--%>
<%--    },--%>

<%--    ]--%>
<%--});--%>


///////////////////////////////////////////////print///////////////////////////////////////////////

<%--var ToolStripButton_PrintAll_Post_Grade_Group_Jsp = isc.ToolStripButton.create({--%>
<%--    icon: "[SKIN]/RichTextEditor/print.png",--%>
<%--    title: "چاپ با جزییات",--%>
<%--    click: function () {--%>
<%--        "<spring:url value="/post-group/printAll/pdf" var="printUrl"/>"--%>
<%--        window.open('${printUrl}');--%>

<%--    }--%>
<%--});--%>


<%--var ToolStripButton_Print_selected_Post_Grade_Group = isc.ToolStripButton.create({--%>
<%--    icon: "[SKIN]/RichTextEditor/print.png",--%>
<%--    title: "چاپ گروه پست انتخاب شده",--%>
<%--    click: function () {--%>


<%--        var strPostrecords="";--%>
<%--        var selectedPostGroup=new Array();--%>
<%--        var selectedPostGroup=ListGrid_Post_Grade_Group_Jsp.getSelectedRecords();--%>
<%--        for(i=0;i<selectedPostGroup.length;i++)--%>
<%--            if(i==0)--%>
<%--            strPostrecords+=selectedPostGroup[i].id;--%>
<%--        else--%>
<%--                strPostrecords+=","+selectedPostGroup[i].id--%>

<%--        if(strPostrecords==""){--%>
<%--            isc.Dialog.create({--%>

<%--                message: "گروه پستی انتخاب نشده است",--%>
<%--                icon: "[SKIN]ask.png",--%>
<%--                title: "پیام",--%>
<%--                buttons: [isc.Button.create({title: "تائید"})],--%>
<%--                buttonClick: function (button, index) {--%>
<%--                    this.close();--%>
<%--                }--%>
<%--            });--%>

<%--        }--%>
<%--        else{--%>


<%--        "<spring:url value="/post-group/printSelected/pdf/" var="printUrl"/>"--%>
<%--        window.open('${printUrl}'+strPostrecords);--%>
<%--        }--%>

<%--    }--%>
<%--});--%>

<%--var ToolStripButton_Print_Post_Grade_Group_Jsp = isc.TrPrintBtn.create({--%>
<%--    // icon: "[SKIN]/RichTextEditor/print.png",--%>
<%--    // title: "چاپ",--%>


<%--    &lt;%&ndash;click: function () {&ndash;%&gt;--%>
<%--    &lt;%&ndash;    "<spring:url value="/post-group/print/pdf" var="printUrl"/>"&ndash;%&gt;--%>
<%--    &lt;%&ndash;    window.open('${printUrl}');&ndash;%&gt;--%>

<%--    &lt;%&ndash;}&ndash;%&gt;--%>


<%--    menu: isc.Menu.create({--%>
<%--        data: [--%>
<%--            {--%>
<%--                title: "<spring:message code="print"/>", icon: "<spring:url value="print.png"/>", submenu: [--%>
<%--                    {--%>
<%--                        title: "<spring:message code="format.pdf"/>",--%>
<%--                        icon: "<spring:url value="pdf.png"/>",--%>
<%--                        click: function () {--%>
<%--                            "<spring:url value="/post-group/print/pdf" var="printUrl"/>"--%>
<%--                            window.open('${printUrl}');--%>

<%--                        }--%>
<%--                    },--%>
<%--                    {--%>
<%--                        title: "<spring:message code="format.excel"/>",--%>
<%--                        icon: "<spring:url value="excel.png"/>",--%>
<%--                        click: function () {--%>
<%--                            "<spring:url value="/post-group/print/excel" var="printUrl"/>"--%>
<%--                            window.open('${printUrl}');--%>

<%--                        }--%>
<%--                    },--%>
<%--                    {--%>
<%--                        title: "<spring:message code="format.html"/>",--%>
<%--                        icon: "<spring:url value="html.png"/>",--%>
<%--                        click: function () {--%>
<%--                            "<spring:url value="/post-group/print/html" var="printUrl"/>"--%>
<%--                            window.open('${printUrl}');--%>

<%--                        }--%>
<%--                    }--%>

<%--                ]--%>
<%--            },--%>
<%--            {--%>
<%--                title: "<spring:message code="print.Detail"/>", icon: "<spring:url value="print.png"/>", submenu: [--%>
<%--                    {--%>
<%--                        title: "<spring:message code="format.pdf"/>",--%>
<%--                        icon: "<spring:url value="pdf.png"/>",--%>
<%--                        click: function () {--%>
<%--                            "<spring:url value="/post-group/printAll/pdf" var="printUrl"/>"--%>
<%--                            window.open('${printUrl}');--%>

<%--                        }--%>
<%--                    },--%>
<%--                    {--%>
<%--                        title: "<spring:message code="format.excel"/>",--%>
<%--                        icon: "<spring:url value="excel.png"/>",--%>
<%--                        click: function () {--%>
<%--                            "<spring:url value="/post-group/printAll/excel" var="printUrl"/>"--%>
<%--                            window.open('${printUrl}');--%>

<%--                        }--%>
<%--                    },--%>
<%--                    {--%>
<%--                        title: "<spring:message code="format.html"/>",--%>
<%--                        icon: "<spring:url value="html.png"/>",--%>
<%--                        click: function () {--%>
<%--                            "<spring:url value="/post-group/printAll/html" var="printUrl"/>"--%>
<%--                            window.open('${printUrl}');--%>

<%--                        }--%>
<%--                    }--%>
<%--                ]--%>
<%--            },--%>
<%--            {--%>
<%--                title: "<spring:message code="print.SelectedRecords"/>",--%>
<%--                icon: "<spring:url value="print.png"/>",--%>
<%--                submenu: [--%>
<%--                    {--%>
<%--                        title: "<spring:message code="format.pdf"/>", icon: "<spring:url value="pdf.png"/>",--%>
<%--                        click: function () {--%>
<%--                            var strPostrecords = "";--%>
<%--                            var selectedPostGroup = new Array();--%>
<%--                            var selectedPostGroup = ListGrid_Post_Grade_Group_Jsp.getSelectedRecords();--%>
<%--                            for (i = 0; i < selectedPostGroup.length; i++)--%>
<%--                                if (i == 0)--%>
<%--                                    strPostrecords += selectedPostGroup[i].id;--%>
<%--                                else--%>
<%--                                    strPostrecords += "," + selectedPostGroup[i].id--%>

<%--                            if (strPostrecords == "") {--%>
<%--                                isc.Dialog.create({--%>

<%--                                    message: "<spring:message code="msg.postGroup.notFound"/>",--%>
<%--                                    icon: "[SKIN]ask.png",--%>
<%--                                    title: "پیام",--%>
<%--                                    buttons: [isc.Button.create({title: "تائید"})],--%>
<%--                                    buttonClick: function (button, index) {--%>
<%--                                        this.close();--%>
<%--                                    }--%>
<%--                                });--%>

<%--                            } else {--%>


<%--                                "<spring:url value="/post-group/printSelected/pdf/" var="printUrl"/>"--%>
<%--                                window.open('${printUrl}' + strPostrecords);--%>
<%--                            }--%>

<%--                        }--%>
<%--                    },--%>
<%--                    {--%>
<%--                        title: "<spring:message code="format.excel"/>", icon: "<spring:url value="excel.png"/>",--%>
<%--                        click: function () {--%>
<%--                            var strPostrecords = "";--%>
<%--                            var selectedPostGroup = new Array();--%>
<%--                            var selectedPostGroup = ListGrid_Post_Grade_Group_Jsp.getSelectedRecords();--%>
<%--                            for (i = 0; i < selectedPostGroup.length; i++)--%>
<%--                                if (i == 0)--%>
<%--                                    strPostrecords += selectedPostGroup[i].id;--%>
<%--                                else--%>
<%--                                    strPostrecords += "," + selectedPostGroup[i].id--%>

<%--                            if (strPostrecords == "") {--%>
<%--                                isc.Dialog.create({--%>

<%--                                    message: "<spring:message code="msg.postGroup.notFound"/>",--%>
<%--                                    icon: "[SKIN]ask.png",--%>
<%--                                    title: "پیام",--%>
<%--                                    buttons: [isc.Button.create({title: "تائید"})],--%>
<%--                                    buttonClick: function (button, index) {--%>
<%--                                        this.close();--%>
<%--                                    }--%>
<%--                                });--%>

<%--                            } else {--%>


<%--                                "<spring:url value="/post-group/printSelected/excel/" var="printUrl"/>"--%>
<%--                                window.open('${printUrl}' + strPostrecords);--%>
<%--                            }--%>

<%--                        }--%>
<%--                    },--%>
<%--                    {--%>
<%--                        title: "<spring:message code="format.html"/>", icon: "<spring:url value="html.png"/>",--%>
<%--                        click: function () {--%>
<%--                            var strPostrecords = "";--%>
<%--                            var selectedPostGroup = new Array();--%>
<%--                            var selectedPostGroup = ListGrid_Post_Grade_Group_Jsp.getSelectedRecords();--%>
<%--                            for (i = 0; i < selectedPostGroup.length; i++)--%>
<%--                                if (i == 0)--%>
<%--                                    strPostrecords += selectedPostGroup[i].id;--%>
<%--                                else--%>
<%--                                    strPostrecords += "," + selectedPostGroup[i].id--%>

<%--                            if (strPostrecords == "") {--%>
<%--                                isc.Dialog.create({--%>

<%--                                    message: "<spring:message code="msg.postGroup.notFound"/>",--%>
<%--                                    icon: "[SKIN]ask.png",--%>
<%--                                    title: "پیام",--%>
<%--                                    buttons: [isc.Button.create({title: "تائید"})],--%>
<%--                                    buttonClick: function (button, index) {--%>
<%--                                        this.close();--%>
<%--                                    }--%>
<%--                                });--%>

<%--                            } else {--%>


<%--                                "<spring:url value="/post-group/printSelected/html/" var="printUrl"/>"--%>
<%--                                window.open('${printUrl}' + strPostrecords);--%>
<%--                            }--%>

<%--                        }--%>
<%--                    }--%>
<%--                ]--%>
<%--            }--%>
<%--        ]--%>
<%--    })--%>
<%--});--%>

//////////////////////////////////////////////////////////////////////////////////////////////