<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>

    var postGroupPostList_Post_Group_Jsp = null;
    var naPostGroup_Post_Group_Jsp = null;
    var PersonnelPostGroup_Post_Group_Jsp = null;


    PostDS_PostGroup = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "jobTitleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postGradeTitleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competenceCount", title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCount", title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},

        ],
        fetchDataURL: viewPostUrl + "/iscList"
    });

    PostLG_PostGroup = isc.TrLG.create({
        dataSource: PostDS_PostGroup,
        fields: [
            {name: "code",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {name: "titleFa",},
            {name: "jobTitleFa",},
            {name: "postGradeTitleFa",},
            {name: "area",},
            {name: "assistance",},
            {name: "affairs",},
            {name: "section",},
            {name: "unit",},
            {name: "costCenterCode",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "costCenterTitleFa"},
            {name: "competenceCount"},
            {name: "personnelCount"}
        ],
        autoFetchData: true,
        showResizeBar: true,
        sortField: 0,
    });

    window_unGroupedPosts_PostGroup = isc.Window.create({
        minWidth: 1024,
        autoCenter: true,
        showMaximizeButton: false,
        autoSize: false,
        keepInParentRect: true,
        isModal: false,
        placement: "fillScreen",
        items: [PostLG_PostGroup],
    });

    if(Window_NeedsAssessment_Edit === undefined) {
        var Window_NeedsAssessment_Edit = isc.Window.create({
            title: "<spring:message code="needs.assessment"/>",
            placement: "fillScreen",
            minWidth: 1024,
            items: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/edit-needs-assessment/"})],
            showUs(record, objectType) {
                loadEditNeedsAssessment(record, objectType);
                this.Super("show", arguments);
            },
        });
    }
    if(Window_NeedsAssessment_Tree === undefined) {
        var Window_NeedsAssessment_Tree = isc.Window.create({
            title: "<spring:message code="needs.assessment"/>",
            placement: "fillScreen",
            minWidth: 1024,
            items: [isc.ViewLoader.create({autoDraw: true, viewURL: "web/tree-needs-assessment/"})],
            showUs(record, objectType) {
                loadNeedsAssessmentTree(record, objectType);
                this.Super("show", arguments);
            },
        });
    }

    var RestDataSource_Post_Group_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "<spring:message code='code'/>", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "titleFa", title: "نام گروه پست", align: "center", filterOperator: "iContains"},
            {name: "titleEn", title: "نام لاتین گروه پست ", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "description", title: "توضیحات", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "competenceCount", title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCount", title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        fetchDataURL: viewPostGroupUrl + "/iscList"
    });
    var Menu_ListGrid_Post_Group_Jsp = isc.Menu.create({
        width: 150,
        data: [{
            title: "بازخوانی اطلاعات", icon: "<spring:url value="refresh.png"/>", click: function () {
                ListGrid_Post_Group_refresh();
            }
        }, {
            title: " ایجاد", icon: "<spring:url value="create.png"/>", click: function () {
                ListGrid_Post_Group_add();
            }
        }, {
            title: "ویرایش", icon: "<spring:url value="edit.png"/>", click: function () {
                ListGrid_Post_Group_edit();
            }
        }, {
            title: "حذف", icon: "<spring:url value="remove.png"/>", click: function () {
                ListGrid_Post_Group_remove();
                <%--var postGrouprecord = ListGrid_Post_Group_Jsp.getSelectedRecord();--%>
                <%--if (postGrouprecord == null || postGrouprecord.id == null) {--%>

                <%--simpleDialog("پیغام", "گروه پستی انتخاب نشده است.", 0, "stop");--%>

                <%--} else {--%>
                <%--isc.RPCManager.sendRequest({--%>
                <%--actionURL: postGroupUrl + postGrouprecord.id + "/canDelete",--%>
                <%--httpMethod: "GET",--%>
                <%--httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},--%>
                <%--useSimpleHttp: true,--%>
                <%--contentType: "application/json; charset=utf-8",--%>
                <%--showPrompt: false,--%>
                <%--// data: JSON.stringify(data1),--%>
                <%--serverOutputAsString: false,--%>
                <%--callback: function (resp) {--%>

                <%--if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {--%>

                <%--if (resp.data == "true") {--%>

                <%--ListGrid_Post_Group_remove();--%>

                <%--} else {--%>
                <%--msg = " گروه پست " + getFormulaMessage(postGrouprecord.titleFa, "2", "red", "B") + " بدلیل مرتبط بودن با شایستگی قابل حذف نمی باشد ";--%>
                <%--simpleDialog("خطا در حذف", msg, 0, "stop");--%>
                <%--}--%>
                <%--}--%>

                <%--}--%>
                <%--});--%>
                <%--}--%>
            }
        },
            <%--{isSeparator: true},--%>
            <%--{--%>
            <%--    title: "چاپ همه گروه پست ها", icon: "<spring:url value="pdf.png"/>",--%>
            <%--    click: "window.open('post-group/print/pdf/<%=accessToken%>/')"--%>
            <%--},--%>
            <%--{--%>
            <%--    title: "چاپ با جزئیات", icon: "<spring:url value="pdf.png"/>",--%>
            <%--    click: "window.open('post-group/printDetail/pdf/<%=accessToken%>/'+ListGrid_Post_Group_Jsp.getSelectedRecord().id)"--%>
            <%--},--%>
            {isSeparator: true},
            {
                title: "لیست پست ها", icon: "<spring:url value="post.png"/>", click: function () {
                    let record = ListGrid_Post_Group_Jsp.getSelectedRecord();
                    if (record == null || record.id == null) {

                        isc.Dialog.create({

                            message: "<spring:message code="msg.no.records.selected"/>",
                            icon: "[SKIN]ask.png",
                            title: "پیام",
                            buttons: [isc.IButtonSave.create({title: "تائید"})],
                            buttonClick: function (button, index) {
                                this.close();
                            }
                        });
                    } else {
                        ListGrid_AllPosts.fetchData();
                        ListGrid_AllPosts.invalidateCache();
                        RestDataSource_ForThisPostGroup_GetPosts.fetchDataURL = postGroupUrl + "/" + record.id + "/getPosts";
                        ListGrid_ForThisPostGroup_GetPosts.invalidateCache();
                        ListGrid_ForThisPostGroup_GetPosts.fetchData();
                        DynamicForm_thisPostGroupHeader_Jsp.setValue("sgTitle", getFormulaMessage(record.titleFa, "2", "red", "B"));
                        Window_Add_Post_to_PostGroup.show();
                    }
                }
            }
        ]
    });
    var ListGrid_Post_Group_Jsp = isc.TrLG.create({
        color: "red",
        selectionType: "multiple",
        dataSource: RestDataSource_Post_Group_Jsp,
        contextMenu: Menu_ListGrid_Post_Group_Jsp,
        sortField: 5,
        autoFetchData: true,
        selectionUpdated: function() {
            postGroupPostList_Post_Group_Jsp = null;
            selectionUpdated_Post_Group_Jsp();
        },
        doubleClick: function () {
            ListGrid_Post_Group_edit();
        },
        getCellCSSText: function (record) {
            if (record.competenceCount === 0)
                return "color:red;font-size: 12px;";
        },
    });
    var method = "POST";
    var Menu_ListGrid_Post_Group_Competences = isc.Menu.create({
        width: 150,
        data: [{
            title: "بازخوانی اطلاعات", icon: "<spring:url value="refresh.png"/>", click: function () {
                ListGrid_Post_Group_Competence_refresh();
            }
        }, {
            title: " حذف گروه پست از  شایستگی مربوطه", icon: "<spring:url value="remove.png"/>", click: function () {
                activePostGroup = ListGrid_Post_Group_Jsp.getSelectedRecord();
                activeCompetence = ListGrid_Post_Group_Competence.getSelectedRecord();
                if (activePostGroup == null || activeCompetence == null) {
                    simpleDialog("پیام", "شایستگی یا گروه پست انتخاب نشده است.", 0, "confirm");

                } else {
                    var Dialog_Delete = isc.Dialog.create({
                        message: getFormulaMessage("آیا از حذف  گروه پست:' ", "2", "black", "c") + getFormulaMessage(activePostGroup.titleFa, "3", "red", "U") + getFormulaMessage(" از  شایستگی:' ", "2", "black", "c") + getFormulaMessage(activeCompetence.titleFa, "3", "red", "U") + getFormulaMessage(" ' مطمئن هستید؟", "2", "black", "c"),//"<font size='2' color='red'>"+"آیا از حذف گروه پست:' " +record.titleFa+ " ' مطمئن هستید؟" +"</font>",
                        icon: "[SKIN]ask.png",
                        title: "تائید حذف",
                        buttons: [isc.IButtonSave.create({title: "بله"}), isc.IButtonCancel.create({
                            title: "خیر"
                        })],
                        buttonClick: function (button, index) {
                            this.close();

                            if (index == 0) {
                                deleteCompetenceFromPostGroup(activeCompetence.id, activePostGroup.id);
                            }
                        }
                    });

                }
            }
        },

        ]
    });
    var Menu_ListGrid_Post_Group_Posts = isc.Menu.create({
        width: 150,
        data: [{
            title: "بازخوانی اطلاعات", icon: "<spring:url value="refresh.png"/>", click: function () {
                ListGrid_Post_Group_Posts_refresh();
            }
        }, {
            title: " حذف پست از گروه پست مربوطه", icon: "<spring:url value="remove.png"/>", click: function () {
                activePostGroup = ListGrid_Post_Group_Jsp.getSelectedRecord();
                activePost = ListGrid_Post_Group_Posts.getSelectedRecord();
                if (activePostGroup == null || activePost == null) {
                    simpleDialog("پیام", "پست یا گروه پست انتخاب نشده است.", 0, "confirm");

                } else {
                    var Dialog_Delete = isc.Dialog.create({
                        message: getFormulaMessage("آیا از حذف  پست:' ", "2", "black", "c") + getFormulaMessage(activePost.titleFa, "3", "red", "U") + getFormulaMessage(" از گروه پست:' ", "2", "black", "c") + getFormulaMessage(activePostGroup.titleFa, "3", "red", "U") + getFormulaMessage(" ' مطمئن هستید؟", "2", "black", "c"),//"<font size='2' color='red'>"+"آیا از حذف گروه پست:' " +record.titleFa+ " ' مطمئن هستید؟" +"</font>",
                        icon: "[SKIN]ask.png",
                        title: "تائید حذف",
                        buttons: [isc.IButtonSave.create({title: "بله"}), isc.IButtonCancel.create({
                            title: "خیر"
                        })],
                        buttonClick: function (button, index) {
                            this.close();

                            if (index == 0) {
                                deletePostFromPostGroup(activePost.id, activePostGroup.id);
                            }
                        }
                    });

                }
            }
        },

        ]
    });

    var RestDataSource_Post_Group_Posts_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "titleFa", filterOperator: "iContains"},
            {name: "code", filterOperator: "iContains"},
            // {name: "description"},
            // {name: "version"}
        ]
    });
    var RestDataSource_All_Posts = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "titleEn", title: "<spring:message code="title.en"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
        ]
        , fetchDataURL: postUrl + "/iscList"
    });
    var RestDataSource_ForThisPostGroup_GetPosts = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "titleEn", title: "<spring:message code="title.en"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
        ]
    });
    var DynamicForm_thisPostGroupHeader_Jsp = isc.DynamicForm.create({
        height: "5%",
        align: "center",
        fields: [{name: "sgTitle", type: "staticText", title: "افزودن پست به گروه پست ", wrapTitle: false}]
    });

    Lable_AllPosts = isc.LgLabel.create({contents:"لیست تمامی پست ها", customEdges: ["R","L","T", "B"]});
    var ListGrid_AllPosts = isc.TrLG.create({
        height: "45%",
        canDragResize: true,
        canDragRecordsOut: true,
        canAcceptDroppedRecords: true,
        dataSource: RestDataSource_All_Posts,
        selectionAppearance: "checkbox",
        selectionType: "multiple",
        sortField: 1,
        dragTrackerMode: "title",
        canDrag: true,
        gridComponents: [Lable_AllPosts, "filterEditor", "header", "body"],
        fields: [
            {name: "code", filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }},
            {name: "titleFa"},
            {name: "area"},
            {name: "assistance"},
            {name: "affairs"},
            {name: "section"},
            {name: "unit"}
        ],
        recordDrop: function (dropRecords) {
            var postGroupRecord = ListGrid_Post_Group_Jsp.getSelectedRecord();
            var postGroupId = postGroupRecord.id;
            var postIds = [];
            for (let i = 0; i < dropRecords.getLength(); i++) {
                postIds.add(dropRecords[i].id);
            }
            var JSONObj = {"ids": postIds};
            isc.RPCManager.sendRequest({
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: postGroupUrl + "/removePosts/" + postGroupId + "/" + postIds,
                httpMethod: "DELETE",
                data: JSON.stringify(JSONObj),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

                        ListGrid_ForThisPostGroup_GetPosts.invalidateCache();
                        ListGrid_AllPosts.invalidateCache();


                    } else {
                        isc.say("خطا");
                    }
                }
            });
        }
    });

    Lable_ForThisPostGroup_GetPosts = isc.LgLabel.create({contents:"لیست پست های این گروه پست", customEdges: ["R","L","T", "B"]});
    var ListGrid_ForThisPostGroup_GetPosts = isc.TrLG.create({
        height: "45%",
        canDragRecordsOut: true,
        canAcceptDroppedRecords: true,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        gridComponents: [Lable_ForThisPostGroup_GetPosts, "filterEditor", "header", "body"],
        dataSource: RestDataSource_ForThisPostGroup_GetPosts,
        sortField: 1,
        fields: [
            {name: "code", filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }},
            {name: "titleFa"},
            {name: "area"},
            {name: "assistance"},
            {name: "affairs"},
            {name: "section"},
            {name: "unit"},
            {name: "OnDelete", title: "حذف", align: "center", autoFitWidth: true, autoFitWidthApproach: "both"}
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
                    src: "[SKIN]/actions/remove.png",
                    prompt: "remove",
                    height: 16,
                    width: 16,
                    grid: this,
                    click: function () {
                        var activePost = record;
                        var activePostId = activePost.id;
                        var activePostGroup = ListGrid_Post_Group_Jsp.getSelectedRecord();
                        var activePostGroupId = activePostGroup.id;
                        isc.RPCManager.sendRequest({
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            actionURL: postGroupUrl + "/removePost/" + activePostGroupId + "/" + activePostId,
                            httpMethod: "DELETE",
                            serverOutputAsString: false,
                            callback: function (resp) {
                                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

                                    // RestDataSource_ForThisPostGroup_GetPosts.removeRecord(activePost);
                                    ListGrid_AllPosts.invalidateCache();
                                    ListGrid_ForThisPostGroup_GetPosts.invalidateCache();
                                } else {
                                    isc.say("خطا در پاسخ سرویس دهنده");
                                }
                            }
                        });
                    }
                });
                recordCanvas.addMember(removeIcon);
                return recordCanvas;
            } else
                return null;
        },
        recordDrop: function (dropRecords) {
            var postGroupRecord = ListGrid_Post_Group_Jsp.getSelectedRecord();
            var postGroupId = postGroupRecord.id;
            var postIds = [];
            for (let i = 0; i < dropRecords.getLength(); i++) {
                postIds.add(dropRecords[i].id);
            }
            var JSONObj = {"ids": postIds};


            TrDSRequest();


            isc.RPCManager.sendRequest({
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                actionURL: postGroupUrl + "/addPosts/" + postGroupId + "/" + postIds, //"${restApiUrl}/api/tclass/addStudents/" + ClassID,
                httpMethod: "POST",
                data: JSON.stringify(JSONObj),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {

                        ListGrid_ForThisPostGroup_GetPosts.invalidateCache();
                        ListGrid_AllPosts.invalidateCache();

                        // var OK = isc.Dialog.create({
                        //     message: "عملیات با موفقیت انجام شد",
                        //     icon: "[SKIN]say.png",
                        //     title: "پیام موفقیت"
                        // });
                        // setTimeout(function () {
                        //     // OK.close();
                        // }, 3000);
                    } else {
                        isc.say("خطا");
                    }
                }
            });
        },
    });

    var VLayOut_PostGroup_Posts_Jsp = isc.VLayout.create({
        width: "100%",
        height: "100%",
        border: "3px solid gray", layoutMargin: 5,
        members: [
            DynamicForm_thisPostGroupHeader_Jsp,
            ListGrid_AllPosts,
            isc.LayoutSpacer.create({ID: "spacer", height: "5%"}),
            ListGrid_ForThisPostGroup_GetPosts
        ]
    });

    var Window_Add_Post_to_PostGroup = isc.Window.create({
        title: "لیست پست ها",
        align: "center",
        placement: "fillScreen",
        minWidth: 1024,
        closeClick: function () {
            ListGrid_Post_Group_Competence.invalidateCache();
            ListGrid_Post_Group_Posts.invalidateCache();
            this.hide();
        },
        items: [
            VLayOut_PostGroup_Posts_Jsp
        ]
    });

    var RestDataSource_Post_Group_Competencies_Jsp = isc.TrDS.create({
        fields: [
            {name: "id"},
            {name: "titleFa"},
            {name: "titleEn"},
            {name: "description"},
            {name: "version"}
        ]
        //,fetchDataURL:"${restApiUrl}/api/post-group/?/getCompetences"
    });

    var ListGrid_Post_Group_Posts = isc.TrLG.create({
        width: "100%",
        height: "100%",
        allowAdvancedCriteria: true,
        allowFilterExpressions: true,
        showResizeBars: true,
        filterOnKeypress: true,
        dataSource: RestDataSource_Post_Group_Posts_Jsp,
        contextMenu: Menu_ListGrid_Post_Group_Posts,
        doubleClick: function () {
            //    ListGrid_Post_Group_edit();
        },
        dataArrived: function () {
            postGroupPostList_Post_Group_Jsp = ListGrid_Post_Group_Posts.data.localData;
            fetchPersonnelData_Post_Group_Jsp();
        },
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "job.titleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postGrade.titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 22,
        autoFetchData: false,
        showFilterEditor: true,
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن"
    });

    var ListGrid_Post_Group_Competence = isc.TrLG.create({
        width: "100%",
        height: "100%",
        showResizeBars: true,
        dataSource: RestDataSource_Post_Group_Competencies_Jsp,
        contextMenu: Menu_ListGrid_Post_Group_Competences,
        doubleClick: function () {
            //    ListGrid_Post_Group_edit();
        },
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "titleFa", title: "نام شایستگی", align: "center"},
            {name: "titleEn", title: "نام لاتین شایستگی ", align: "center"},
            {name: "description", title: "توضیحات", align: "center"},
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        sortField: 1,
        sortDirection: "descending",
        dataPageSize: 22,
        autoFetchData: false,
        showFilterEditor: true,
        filterOnKeypress: true,
        sortFieldAscendingText: "مرتب سازی صعودی ",
        sortFieldDescendingText: "مرتب سازی نزولی",
        configureSortText: "تنظیم مرتب سازی",
        autoFitAllText: "متناسب سازی ستون ها براساس محتوا ",
        autoFitFieldText: "متناسب سازی ستون بر اساس محتوا",
        filterUsingText: "فیلتر کردن",
        groupByText: "گروه بندی",
        freezeFieldText: "ثابت نگه داشتن"
    });

    var DynamicForm_Post_Group_Jsp = isc.DynamicForm.create({
        width: "750",
        height: "150",
        align: "center",
        canSubmit: true,
        showInlineErrors: true,
        showErrorText: false,
        showErrorStyle: true,
        errorOrientation: "right",
        titleAlign: "right",
        requiredMessage: "فیلد اجباری است.",
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
                title: "نام گروه پست",
                type: "text",
                required: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9 ]",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber],
                hint: "Persian/فارسی",
                showHintInField: true,
                length: "250",
                width: "*",
                height: "40"
            },
            {
                name: "code",
                title: "<spring:message code='code'/>",
                type: "text",
            },
            {
                name: "titleEn",
                type: "text",
                length: "250",
                width: "*",
                height: "40",
                title: "نام لاتین گروه پست ",
                hint: "English/انگلیسی",
                showHintInField: true,
                keyPressFilter: "[a-z|A-Z|0-9 |]",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber],
            },
            {
                name: "description",
                type: "text",
                length: "250",
                width: "*",
                height: "40",
                title: "توضیحات",
                hint: "توضیحات",
                showHintInField: true,
                keyPressFilter: "[\u0600-\u06FF\uFB8A\u067E\u0686\u06AF\u200C\u200F|0-9 ]",
                validators: [TrValidators.NotEmpty, TrValidators.NotStartWithSpecialChar, TrValidators.NotStartWithNumber],
            }
        ]
    });

    var IButton_Post_Group_Exit_Jsp = isc.IButtonCancel.create({
        top: 260, title: "لغو",
        //icon: "<spring:url value="remove.png"/>",
        align: "center",
        click: function () {
            Window_Post_Group_Jsp.close();
        }
    });

    var IButton_Post_Group_Save_Jsp = isc.IButtonSave.create({
        top: 260, title: "ذخیره",
        //icon: "pieces/16/save.png",
        align: "center", click: function () {

            DynamicForm_Post_Group_Jsp.validate();
            if (DynamicForm_Post_Group_Jsp.hasErrors()) {
                return;
            }
            var data = DynamicForm_Post_Group_Jsp.getValues();

            isc.RPCManager.sendRequest({
                actionURL: url,
                httpMethod: method,
                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                useSimpleHttp: true,
                contentType: "application/json; charset=utf-8",
                showPrompt: false,
                data: JSON.stringify(data),
                serverOutputAsString: false,
                callback: function (resp) {
                    if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                        var OK = isc.Dialog.create({
                            message: "عملیات با موفقیت انجام شد.",
                            icon: "[SKIN]say.png",
                            title: "انجام فرمان"
                        });
                        setTimeout(function () {
                            OK.close();
                        }, 3000);
                        ListGrid_Post_Group_refresh();
                        Window_Post_Group_Jsp.close();
                    } else {
                        var ERROR = isc.Dialog.create({
                            message: ("اجرای عملیات با مشکل مواجه شده است!"),
                            icon: "[SKIN]stop.png",
                            title: "پیغام"
                        });
                        setTimeout(function () {
                            ERROR.close();
                        }, 3000);
                    }

                }
            });
        }
    });

    var HLayOut_Post_GroupSaveOrExit_Jsp = isc.HLayout.create({
        layoutMargin: 5,
        showEdges: false,
        edgeImage: "",
        width: "700",
        height: "10",
        alignLayout: "center",
        align: "center",
        padding: 10,
        membersMargin: 10,
        members: [IButton_Post_Group_Save_Jsp, IButton_Post_Group_Exit_Jsp]
    });

    var Window_Post_Group_Jsp = isc.Window.create({
        title: " گروه پست ",
        width: 700,
        height: 200,
        autoSize: true,
        autoCenter: true,
        isModal: true,
        showModalMask: true,
        align: "center",
        autoDraw: false,
        dismissOnEscape: false,
        border: "1px solid gray",
        closeClick: function () {
            this.Super("closeClick", arguments);
        },
        items: [isc.VLayout.create({
            width: "100%",
            height: "100%",
            members: [DynamicForm_Post_Group_Jsp, HLayOut_Post_GroupSaveOrExit_Jsp]
        })]
    });

    ToolStripButton_unGroupedPosts_Jsp = isc.ToolStripButton.create({
        title: "پست های فاقد گروه پستی",
        click: function () {
            loadPostData({
                _constructor: "AdvancedCriteria",
                operator: "and",
                criteria: [{fieldName: "postGroupSet", operator: "isNull"}]
            }, this.title);
        }
    });
    ToolStripButton_newPosts_Jsp = isc.ToolStripButton.create({
        title: "پست های جدید",
        click: function () {
            loadPostData({
                _constructor: "AdvancedCriteria",
                operator: "or",
                criteria: [
                    {fieldName: "createdDate", operator: "greaterOrEqual", value: Date.create(today-6048e5).toUTCString()},
                    {fieldName: "lastModifiedDate", operator: "greaterOrEqual", value: Date.create(today-6048e5).toUTCString()}
                ]
            }, this.title);
        }
    });
    ToolStripButton_EditNA_Jsp = isc.ToolStripButton.create({
        title: "ویرایش نیازسنجی",
        click: function () {
            if (ListGrid_Post_Group_Jsp.getSelectedRecord() == null){
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            Window_NeedsAssessment_Edit.showUs(ListGrid_Post_Group_Jsp.getSelectedRecord(), "PostGroup");
            Window_NeedsAssessment_Edit.setProperties({
                close() {
                    ListGrid_Post_Group_Jsp.invalidateCache()
                    this.Super("close", arguments)
                }
            })
            // createTab(this.title, "web/edit-needs-assessment/", "loadEditNeedsAssessment(ListGrid_Post_Group_Jsp.getSelectedRecord(), 'PostGroup')");
            // Window_NeedsAssessment_Edit.show();
        }
    });
    ToolStripButton_TreeNA_JspPostGroup = isc.ToolStripButton.create({
        title: "درخت نیازسنجی",
        click: function () {
            if (ListGrid_Post_Group_Jsp.getSelectedRecord() == null){
                createDialog("info", "<spring:message code='msg.no.records.selected'/>");
                return;
            }
            Window_NeedsAssessment_Tree.showUs(ListGrid_Post_Group_Jsp.getSelectedRecord(), "PostGroup");
        }
    });
    ToolStrip_NA_Post_Group_Jsp = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            ToolStripButton_unGroupedPosts_Jsp,
            ToolStripButton_newPosts_Jsp,
            ToolStripButton_EditNA_Jsp,
            ToolStripButton_TreeNA_JspPostGroup
        ]
    });

    var ToolStripButton_Refresh_Post_Group_Jsp = isc.ToolStripButtonRefresh.create({
        // icon: "<spring:url value="refresh.png"/>",
        title: "بازخوانی اطلاعات",
        click: function () {
            ListGrid_Post_Group_refresh();
        }
    });
    var ToolStripButton_Edit_Post_Group_Jsp = isc.ToolStripButtonEdit.create({

        title: "ویرایش",
        click: function () {

            ListGrid_Post_Group_edit();
        }
    });
    var ToolStripButton_Add_Post_Group_Jsp = isc.ToolStripButtonAdd.create({

        title: "ایجاد",
        click: function () {

            ListGrid_Post_Group_add();
        }
    });
    var ToolStripButton_Remove_Post_Group_Jsp = isc.ToolStripButtonRemove.create({
        // icon: "[SKIN]/actions/remove.png",
        title: "حذف",
        click: function () {
            ListGrid_Post_Group_remove();
        }
    });
    var ToolStripButton_Add_Post_Group_AddPost_Jsp = isc.ToolStripButton.create({
        title: "لیست پست ها",
        click: function () {
            let record = ListGrid_Post_Group_Jsp.getSelectedRecord();
            if (record == null || record.id == null) {
                isc.Dialog.create({
                    message: "<spring:message code="msg.no.records.selected"/>",
                    icon: "[SKIN]ask.png",
                    title: "پیام",
                    buttons: [isc.IButtonSave.create({title: "تائید"})],
                    buttonClick: function () {
                        this.close();
                    }
                });

            } else {
                ListGrid_AllPosts.fetchData();
                ListGrid_AllPosts.invalidateCache();
                RestDataSource_ForThisPostGroup_GetPosts.fetchDataURL = postGroupUrl + "/" + record.id + "/getPosts";
                ListGrid_ForThisPostGroup_GetPosts.invalidateCache();
                ListGrid_ForThisPostGroup_GetPosts.fetchData();
                DynamicForm_thisPostGroupHeader_Jsp.setValue("sgTitle", getFormulaMessage(record.titleFa, "2", "red", "B"));
                Lable_ForThisPostGroup_GetPosts.setContents("لیست پست های گروه پست " + getFormulaMessage(record.titleFa, "2", "red", "B"));
                Window_Add_Post_to_PostGroup.show();


                //Window_Add_Post_to_PostGroup.
                //   Window_Add_Post_to_PostGroup.show();

            }
        }
    });
    var ToolStrip_Actions_Post_Group_Jsp = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            ToolStripButton_Add_Post_Group_Jsp,
            ToolStripButton_Edit_Post_Group_Jsp,
            ToolStripButton_Remove_Post_Group_Jsp,
            ToolStripButton_Add_Post_Group_AddPost_Jsp,
            isc.ToolStrip.create({
                width: "100%",
                align: "left",
                border: '0px',
                members: [
                    ToolStripButton_Refresh_Post_Group_Jsp,
                ]
            }),
        ]
    });

    var HLayout_Actions_Post_Group_Jsp = isc.VLayout.create({
        width: "100%",
        members: [ToolStrip_Actions_Post_Group_Jsp, ToolStrip_NA_Post_Group_Jsp]
    });

    ////////////////////////////////////////////////////////////personnel/////////////////////////////////////////////////
    PersonnelDS_Post_Group_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "firstName", title: "<spring:message code="firstName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "lastName", title: "<spring:message code="lastName"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "nationalCode", title: "<spring:message code="national.code"/>", filterOperator: "iContains", autoFitWidth: true,
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "companyName", title: "<spring:message code="company.name"/>", filterOperator: "iContains", autoFitWidth: true},
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
            {name: "postTitle", title: "<spring:message code="post"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postCode", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpArea", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpAssistant", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpAffairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpSection", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "ccpUnit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        fetchDataURL: personnelUrl + "/iscList",
    });

    PersonnelLG_Post_Group_Jsp = isc.TrLG.create({
        dataSource: PersonnelDS_Post_Group_Jsp,
        selectionType: "single",
        alternateRecordStyles: true,
        fields: [
            {name: "firstName"},
            {name: "lastName"},
            {name: "nationalCode",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "companyName"},
            {name: "personnelNo",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "personnelNo2",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "postCode"},
            {name: "postTitle"},
            {name: "ccpArea"},
            {name: "ccpAssistant"},
            {name: "ccpAffairs"},
            {name: "ccpSection"},
            {name: "ccpUnit"},
        ]
    });

    ///////////////////////////////////////////////////////////needs assessment/////////////////////////////////////////
    PriorityDS_Post_Group_Jsp = isc.TrDS.create({
        fields:
            [
                {name: "id", primaryKey: true, hidden: true},
                {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
                {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
            ],
        autoFetchData: false,
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/NeedsAssessmentPriority"
    });

    DomainDS_Post_Group_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/NeedsAssessmentDomain"
    });

    CompetenceTypeDS_Post_Group_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "title", title: "<spring:message code="title"/>", filterOperator: "iContains"},
            {name: "code", title: "<spring:message code="code"/>", filterOperator: "iContains"}
        ],
        autoCacheAllData: true,
        fetchDataURL: parameterUrl + "/iscList/competenceType"
    });

    CourseDS_Post_Group_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "needsAssessmentPriorityId", title: "<spring:message code='priority'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "needsAssessmentDomainId", title: "<spring:message code='domain'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "competence.title", title: "<spring:message code="competence"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "competence.competenceTypeId", title: "<spring:message code="competence.type"/>", filterOperator: "equals", autoFitWidth: true},
            {name: "skill.code", title: "<spring:message code="skill.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "skill.titleFa", title: "<spring:message code="skill"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "skill.course.theoryDuration", title: "<spring:message code="duration"/>", filterOperator: "equals", autoFitWidth: true},
            {name: "skill.course.scoresState", title: "<spring:message code='status'/>", filterOperator: "equals", autoFitWidth: true},
            {name: "skill.course.code", title: "<spring:message code="course.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "skill.course.titleFa", title: "<spring:message code="course"/>", filterOperator: "iContains", autoFitWidth: true},
        ],
        cacheAllData: true,
        fetchDataURL: null
    });

    CourseLG_Post_Group_Jsp = isc.TrLG.create({
        dataSource: CourseDS_Post_Group_Jsp,
        selectionType: "none",
        autoFetchData: false,
        alternateRecordStyles: true,
        showAllRecords: true,
        fields: [
            {name: "competence.title"},
            {
                name: "competence.competenceTypeId",
                type: "SelectItem",
                filterOnKeypress: true,
                displayField: "title",
                valueField: "id",
                optionDataSource: CompetenceTypeDS_Post_Group_Jsp,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
            {
                name: "needsAssessmentPriorityId",
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: PriorityDS_Post_Group_Jsp,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
            {
                name: "needsAssessmentDomainId",
                filterOnKeypress: true,
                editorType: "SelectItem",
                displayField: "title",
                valueField: "id",
                optionDataSource: DomainDS_Post_Group_Jsp,
                pickListProperties: {
                    showFilterEditor: false
                },
                pickListFields: [
                    {name: "title", width: "30%"}
                ],
            },
            {name: "skill.code"},
            {name: "skill.titleFa"},
            {name: "skill.course.code"},
            {name: "skill.course.titleFa"}
        ],
    });

    //////////////////////////////////////////////////////////Form///////////////////////////////////////////////////////
    var Detail_Tab_Post_Group = isc.TabSet.create({
        tabBarPosition: "top",
        width: "100%",
        height: "100%",
        tabs: [
            {name: "TabPane_Post_Post_Group_Jsp", title: "لیست پست ها", pane: ListGrid_Post_Group_Posts},
            {name: "TabPane_Personnel_Post_Group_Jsp", title: "لیست پرسنل", pane: PersonnelLG_Post_Group_Jsp},
            {name: "TabPane_NA_Post_Group_Jsp", title: "<spring:message code='need.assessment'/>", pane: CourseLG_Post_Group_Jsp}
        ],
        tabSelected: function (){
            selectionUpdated_Post_Group_Jsp();
        }
    });

    var HLayout_Tab_Post_Group = isc.HLayout.create({
        width: "100%",
        height: "100%",
        <%--border: "2px solid blue",--%>
        members: [Detail_Tab_Post_Group]
    });

    var HLayout_Grid_Post_Group_Jsp = isc.HLayout.create({
        width: "100%",
        height: "100%",
        members: [ListGrid_Post_Group_Jsp]
    });

    var VLayout_Body_Post_Group_Jsp = isc.VLayout.create({
        width: "100%",
        height: "100%",
        members: [
            HLayout_Actions_Post_Group_Jsp
            , HLayout_Grid_Post_Group_Jsp
            , HLayout_Tab_Post_Group
        ]

    });

    function ListGrid_Post_Group_Posts_refresh() {

        if (ListGrid_Post_Group_Jsp.getSelectedRecord() == null)
            ListGrid_Post_Group_Posts.setData([]);
        else
            ListGrid_Post_Group_Posts.invalidateCache();
        CourseLG_Post_Group_Jsp.setData([]);
        PersonnelLG_Post_Group_Jsp.setData([]);
    }

    function ListGrid_Post_Group_Competence_refresh() {

        if (ListGrid_Post_Group_Jsp.getSelectedRecord() == null)
            ListGrid_Post_Group_Competence.setData([]);
        else
            ListGrid_Post_Group_Competence.invalidateCache();
    }

    function ListGrid_Post_Group_edit() {
        var record = ListGrid_Post_Group_Jsp.getSelectedRecord();
        if (record == null || record.id == null) {

            simpleDialog("پیغام", "گروه پستی انتخاب نشده است.", 0, "say");

        } else {
            DynamicForm_Post_Group_Jsp.clearValues();
            method = "PUT";
            url = postGroupUrl + "/" + record.id;
            DynamicForm_Post_Group_Jsp.editRecord(record);
            Window_Post_Group_Jsp.show();
        }
    }

    function ListGrid_Post_Group_remove() {
        var record = ListGrid_Post_Group_Jsp.getSelectedRecord();
        if (record == null) {
            simpleDialog("پیغام", "گروه پستی انتخاب نشده است.", 0, "ask");
        } else {
            var Dialog_Delete = isc.Dialog.create({
                message: getFormulaMessage("آیا از حذف گروه پست:' ", "2", "black", "c") + getFormulaMessage(record.titleFa, "3", "red", "U") + getFormulaMessage(" ' مطمئن هستید؟", "2", "black", "c"),//"<font size='2' color='red'>"+"آیا از حذف گروه پست:' " +record.titleFa+ " ' مطمئن هستید؟" +"</font>",
                icon: "[SKIN]ask.png",
                title: "تائید حذف",
                buttons: [isc.IButtonSave.create({title: "بله"}), isc.IButtonCancel.create({
                    title: "خیر"
                })],
                buttonClick: function (button, index) {
                    this.close();
                    if (index == 0) {
                        var wait = isc.Dialog.create({
                            message: "در حال انجام عملیات...",
                            icon: "[SKIN]say.png",
                            title: "پیام"
                        });
                        isc.RPCManager.sendRequest({
                            actionURL: postGroupUrl + "/" + record.id,
                            httpMethod: "DELETE",
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            showPrompt: true,
                            serverOutputAsString: false,
                            callback: function (resp) {
                                wait.close();
                                if (resp.httpResponseCode == 200) {
                                    ListGrid_Post_Group_Jsp.invalidateCache();
                                    simpleDialog("انجام فرمان", "حذف با موفقیت انجام شد", 2000, "say");
                                    ListGrid_Post_Group_Posts.setData([]);
                                    ListGrid_Post_Group_Competence.setData([]);

                                } else {
                                    simpleDialog("پیام خطا", "حذف با خطا مواجه شد", 2000, "stop");

                                }
                            }
                        });
                    }
                }
            });
        }
    }

    function ListGrid_Post_Group_refresh() {
        postGroupPostList_Post_Group_Jsp = null;
        naPostGroup_Post_Group_Jsp = null;
        PersonnelPostGroup_Post_Group_Jsp = null;
        ListGrid_Post_Group_Jsp.invalidateCache();
        ListGrid_Post_Group_Posts_refresh();
        ListGrid_Post_Group_Competence_refresh();


    }

    function ListGrid_Post_Group_add() {
        method = "POST";
        url = postGroupUrl;
        DynamicForm_Post_Group_Jsp.clearValues();
        Window_Post_Group_Jsp.show();
    }

    function deletePostFromPostGroup(postId, postGroupId) {

        isc.RPCManager.sendRequest({
            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
            useSimpleHttp: true,
            contentType: "application/json; charset=utf-8",
            actionURL: postGroupUrl + "/removePost/" + postGroupId + "/" + postId,
            httpMethod: "DELETE",
            serverOutputAsString: false,
            callback: function (resp) {
                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                    ListGrid_Post_Group_Posts.invalidateCache();

                } else {
                    isc.say("خطا در پاسخ سرویس دهنده");
                }
            }
        });
    }

    function deleteCompetenceFromPostGroup(competenceId, postGroupId) {
        isc.RPCManager.sendRequest({
            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
            useSimpleHttp: true,
            contentType: "application/json; charset=utf-8",
            actionURL: postGroupUrl + "/removeCompetence/" + postGroupId + "/" + competenceId,
            httpMethod: "DELETE",
            serverOutputAsString: false,
            callback: function (resp) {
                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                    ListGrid_Post_Group_Competence.invalidateCache();

                } else {
                    isc.say("خطا در پاسخ سرویس دهنده");
                }
            }
        });
    }

    function deletePostGroupFromAllCompetence(postGroupId) {


        isc.RPCManager.sendRequest({
            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
            useSimpleHttp: true,
            contentType: "application/json; charset=utf-8",
            actionURL: postGroupUrl + "/removeAllCompetence/" + postGroupId + "/",
            httpMethod: "DELETE",
            serverOutputAsString: false,
            callback: function (resp) {
                if (resp.httpResponseCode == 200 || resp.httpResponseCode == 201) {
                    ListGrid_Post_Group_Competence.invalidateCache();

                } else {
                    isc.say("خطا در پاسخ سرویس دهنده");
                }
            }
        });
    }

    function selectionUpdated_Post_Group_Jsp(){
        let postGroup = ListGrid_Post_Group_Jsp.getSelectedRecord();
        let tab = Detail_Tab_Post_Group.getSelectedTab();
        if (postGroup == null && tab.pane != null){
            tab.pane.setData([]);
            return;
        }
        
        switch (tab.name) {
            case "TabPane_Post_Post_Group_Jsp":{
                RestDataSource_Post_Group_Posts_Jsp.fetchDataURL = postGroupUrl + "/" + postGroup.id + "/getPosts";
                if (postGroupPostList_Post_Group_Jsp == null)
                    refreshLG(ListGrid_Post_Group_Posts);
                break;
            }
            case "TabPane_Personnel_Post_Group_Jsp":{
                if (PersonnelPostGroup_Post_Group_Jsp === postGroup.id)
                    return;
                PersonnelPostGroup_Post_Group_Jsp = postGroup.id;
                RestDataSource_Post_Group_Posts_Jsp.fetchDataURL = postGroupUrl + "/" + postGroup.id + "/getPosts";
                if (postGroupPostList_Post_Group_Jsp == null)
                    refreshLG(ListGrid_Post_Group_Posts);
                else
                    fetchPersonnelData_Post_Group_Jsp();
                break;
            }
            case "TabPane_NA_Post_Group_Jsp":{
                if (naPostGroup_Post_Group_Jsp === postGroup.id)
                    return;
                naPostGroup_Post_Group_Jsp = postGroup.id;
                CourseDS_Post_Group_Jsp.fetchDataURL = needsAssessmentReportsUrl + "?objectId=" + postGroup.id + "&objectType=PostGroup";
                CourseDS_Post_Group_Jsp.invalidateCache();
                CourseDS_Post_Group_Jsp.fetchData();
                CourseLG_Post_Group_Jsp.invalidateCache();
                CourseLG_Post_Group_Jsp.fetchData();
                break;
            }
        }
    }

    function fetchPersonnelData_Post_Group_Jsp() {
        if (Detail_Tab_Post_Group.getSelectedTab().name !== "TabPane_Personnel_Post_Group_Jsp")
            return;
        if (postGroupPostList_Post_Group_Jsp == null) {
            PersonnelLG_Post_Group_Jsp.setData([]);
            return;
        }
        PersonnelLG_Post_Group_Jsp.implicitCriteria = {
            _constructor: "AdvancedCriteria",
            operator: "and",
            criteria: [{fieldName: "postCode", operator: "equals", value: postGroupPostList_Post_Group_Jsp.map(p => p.code)}]
        };
        PersonnelLG_Post_Group_Jsp.invalidateCache();
        PersonnelLG_Post_Group_Jsp.fetchData();
    }

    function loadPostData(criteria, title){
        PostLG_PostGroup.setImplicitCriteria(criteria);
        PostLG_PostGroup.invalidateCache();
        PostLG_PostGroup.fetchData();
        window_unGroupedPosts_PostGroup.setTitle(title);
        window_unGroupedPosts_PostGroup.show();
    }

    // </script>