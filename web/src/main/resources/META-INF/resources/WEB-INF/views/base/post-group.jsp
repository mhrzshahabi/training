<%@ page import="com.nicico.copper.common.domain.ConstantVARs" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="Spring" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    final String accessToken = (String) session.getAttribute(ConstantVARs.ACCESS_TOKEN);
%>

// <script>
    var naPostGroup_Post_Group_Jsp = null;
    var PersonnelPostGroup_Post_Group_Jsp = null;
    var PostPostGroup_Post_Group_Jsp = null;
    var wait_PostGroup = null;
    var postsSelection=false;
    let LoadAttachments_Post_Group = null;

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
            {
                name: "enabled",
                title: "<spring:message code="active.status"/>",
                align: "center",
                filterOperator: "equals",
                autoFitWidth: true,
                autoFitWidthApproach: "both",
            },

        ],
        fetchDataURL: viewPostUrl + "/iscList"
    });

    PostLG_PostGroup = isc.TrLG.create({
        dataSource: PostDS_PostGroup,
        autoFetchData: true,
        sortField: 0,
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
            {name: "personnelCount"},
            {name: "enabled",
                valueMap:{
                    // undefined : "فعال",
                    74 : "غیر فعال"
                },filterOnKeypress: true,
            },
        ],
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

    var RestDataSource_Post_Group_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", title: "id", primaryKey: true, canEdit: false, hidden: true},
            {name: "code", title: "<spring:message code='code'/>", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "titleFa", title: "نام گروه پست", align: "center", filterOperator: "iContains"},
            {name: "titleEn", title: "نام لاتین گروه پست ", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "description", title: "توضیحات", align: "center", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "competenceCount", title: "تعداد شایستگی", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "personnelCount", title: "تعداد پرسنل", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "lastModifiedDateNA", title: "<spring:message code="update.date"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "modifiedByNA", title: "<spring:message code="updated.by"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "version", title: "version", canEdit: false, hidden: true}
        ],
        fetchDataURL: viewPostGroupUrl + "/iscList"
    });
    var Menu_ListGrid_Post_Group_Jsp = isc.Menu.create({
        width: 150,
        data: [{
            title: "بازخوانی اطلاعات", icon: "<spring:url value="refresh.png"/>", click: function () {

                LoadAttachments_Post_Group.ListGrid_JspAttachment.setData([]);
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
                title: "لیست پست های انفرادی", icon: "<spring:url value="post.png"/>", click: function () {
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
                        postsSelection=true;
                        RestDataSource_ForThisPostGroup_GetPosts.fetchDataURL = postGroupUrl + "/" + record.id + "/getPosts";
                        ListGrid_ForThisPostGroup_GetPosts.invalidateCache();
                        ListGrid_ForThisPostGroup_GetPosts.fetchData();
                        DynamicForm_thisPostGroupHeader_Jsp.setValue("sgTitle", getFormulaMessage(record.titleFa, "2", "red", "B"));
                        Window_Add_Post_to_PostGroup.show();
                    }
                }
            },
            {
                title: "لیست پست ها", icon: "<spring:url value="post.png"/>", click: function () {
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
                        postsSelection=true;
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
        selectionType: "single",
        dataSource: RestDataSource_Post_Group_Jsp,
        contextMenu: Menu_ListGrid_Post_Group_Jsp,
        canMultiSort: true,
        initialSort: [
            {property: "competenceCount", direction: "ascending"},
            {property: "id", direction: "descending"}
        ],
        autoFetchData: true,
        selectionUpdated: function() {
            selectionUpdated_Post_Group_Jsp();
        },
        doubleClick: function () {
            ListGrid_Post_Group_edit();
        },
        getCellCSSText: function (record) {
            return setColorForListGrid(record)
        },
    });

    defineWindowsEditNeedsAssessment(ListGrid_Post_Group_Jsp);
    defineWindowTreeNeedsAssessment();

    var method = "POST";

    /****************************************************************************************************************************************************************************/

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
                    simpleDialog("پیام", "پست انفرادی یا گروه پست انتخاب نشده است.", 0, "confirm");

                } else if (activePost.type==1) {
                    simpleDialog("پیام", "پست انفرادی انتخاب شده مربوط به يکي از پست ها است. لطفا جهت حذف، پست مرتبط را حذف نماييد.", 0, "confirm");
                } else {
                    isc.Dialog.create({
                        message: getFormulaMessage("آیا از حذف  پست انفرادی:' ", "2", "black", "c") + getFormulaMessage(activePost.titleFa, "3", "red", "U") + getFormulaMessage(" از گروه پست:' ", "2", "black", "c") + getFormulaMessage(activePostGroup.titleFa, "3", "red", "U") + getFormulaMessage(" ' مطمئن هستید؟", "2", "black", "c"),//"<font size='2' color='red'>"+"آیا از حذف گروه پست:' " +record.titleFa+ " ' مطمئن هستید؟" +"</font>",
                        icon: "[SKIN]ask.png",
                        title: "تائید حذف",
                        buttons: [isc.IButtonSave.create({title: "بله"}), isc.IButtonCancel.create({
                            title: "خیر"
                        })],
                        buttonClick: function (button, index) {
                            this.close();

                            if (index === 0) {
                                deletePostFromPostGroup(activePost.postId, activePostGroup.id);
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
            {name: "postId"},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "jobTitle", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},
            //{name: "job.code", title: "<spring:message code="job.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postGradeTitle", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true,autoFitWidthApproach: "both",},

        ],
        fetchDataURL: viewAllPostUrl + "/iscList"
    });
    var RestDataSource_All_Posts = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains"},
            {name: "titleEn", title: "<spring:message code="title.en"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "job.code", title: "<spring:message code="job.code"/>", filterOperator: "iContains"},
            {name: "job.titleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains"},
            {name: "postGrade.code", title: "<spring:message code="post.grade.code"/>", filterOperator: "iContains"},
            {name: "postGrade.titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains"},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both",},
        ]
        , fetchDataURL: postUrl + "/iscList"
    });
    var RestDataSource_ForThisPostGroup_GetPosts = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains"},
            {name: "titleEn", title: "<spring:message code="title.en"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "job.code", title: "<spring:message code="job.code"/>", filterOperator: "iContains"},
            {name: "job.titleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains"},
            {name: "postGrade.code", title: "<spring:message code="post.grade.code"/>", filterOperator: "iContains"},
            {name: "postGrade.titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains"},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both",},
            ]
    });
    var DynamicForm_thisPostGroupHeader_Jsp = isc.DynamicForm.create({
        height: "5%",
        align: "center",
        fields: [{name: "sgTitle", type: "staticText", title: "افزودن پست انفرادی به گروه پست ", wrapTitle: false}]
    });

    Lable_AllPosts = isc.LgLabel.create({contents:"لیست تمامی پست های انفرادی", customEdges: ["R","L","T", "B"]});
    var ListGrid_AllPosts = isc.TrLG.create({
        height: "45%",
        dataSource: RestDataSource_All_Posts,
        selectionAppearance: "checkbox",
        selectionType: "simple",
        sortField: 1,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        gridComponents: [Lable_AllPosts, "filterEditor", "header", "body"],
        fields: [
            {name: "code", filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }},
            {name: "titleFa"},
            {name: "job.code"},
            {name: "job.titleFa"},
            {name: "postGrade.code"},
            {name: "postGrade.titleFa"},
            {name: "area"},
            {name: "assistance"},
            {name: "affairs"},
            {name: "section"},
            {name: "unit"},
            {name: "costCenterCode"},
            {name: "costCenterTitleFa"},
            {name: "enabled",
                valueMap:{
                    //undefined : "فعال",
                    74 : "غیر فعال"
                },filterOnKeypress: true,
            },
            {name: "OnAdd", title: " ",canSort:false,canFilter:false, width:30}
        ],
        dataArrived:function(){
            let lgIds = ListGrid_ForThisPostGroup_GetPosts.data.getAllCachedRows().map(function(item) {
                return item.id;
            });

            let findRows=ListGrid_AllPosts.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"inSet",value:lgIds}]});
            ListGrid_AllPosts.setSelectedState(findRows);
            findRows.setProperty("enabled", false);
        },
        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);
            if (fieldName === "OnAdd") {
                var recordCanvas = isc.HLayout.create({
                    height: 20,
                    width: "100%",
                    layoutMargin: 5,
                    membersMargin: 10,
                    align: "center"
                });
                var addIcon = isc.ImgButton.create({
                    showDown: false,
                    showRollOver: false,
                    layoutAlign: "center",
                    src: "[SKIN]/actions/add.png",
                    prompt: "اضافه کردن",
                    height: 16,
                    width: 16,
                    grid: this,
                    click: function () {
                        let current = record;
                        let selected=ListGrid_ForThisPostGroup_GetPosts.data.getAllCachedRows().map(function(item) {return item.id;});

                        let ids = [];

                        if ($.inArray(current.id, selected) === -1){
                            ids.push(current.id);
                        }

                        if(ids.length!==0){
                            let findRows=ListGrid_AllPosts.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"equals",value:current.id}]});

                            let groupRecord = ListGrid_Post_Group_Jsp.getSelectedRecord();
                            let groupId = groupRecord.id;

                            let JSONObj = {"ids": ids};
                            wait.show();

                            isc.RPCManager.sendRequest({
                                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                useSimpleHttp: true,
                                contentType: "application/json; charset=utf-8",
                                actionURL: postGroupUrl + "/addPosts/" + groupId + "/" + ids,
                                httpMethod: "POST",
                                data: JSON.stringify(JSONObj),
                                serverOutputAsString: false,
                                callback: function (resp) {
                                    wait.close();
                                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                        ListGrid_AllPosts.selectRecord(findRows);
                                        findRows.setProperty("enabled", false);
                                        ListGrid_AllPosts.redraw();

                                        ListGrid_ForThisPostGroup_GetPosts.invalidateCache();
                                        ListGrid_ForThisPostGroup_GetPosts.fetchData();
                                    } else {
                                        isc.say("خطا");
                                    }
                                }
                            });

                        }
                    }
                });
                recordCanvas.addMember(addIcon);
                return recordCanvas;
            } else
                return null;
        }
    });

    Lable_ForThisPostGroup_GetPosts = isc.LgLabel.create({contents:"لیست پست های انفرادی این گروه پست", customEdges: ["R","L","T", "B"]});
    var ListGrid_ForThisPostGroup_GetPosts = isc.TrLG.create({
        height: "45%",
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        gridComponents: [Lable_ForThisPostGroup_GetPosts, "filterEditor", "header", "body"],
        dataSource: RestDataSource_ForThisPostGroup_GetPosts,
        sortField: 1,
        selectionAppearance: "checkbox",
        selectionType: "simple",
        fields: [
            {name: "id", hidden:true},
            {name: "code", filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }},
            {name: "titleFa"},
            {name: "job.code"},
            {name: "job.titleFa"},
            {name: "postGrade.code"},
            {name: "postGrade.titleFa"},
            {name: "area"},
            {name: "assistance"},
            {name: "affairs"},
            {name: "section"},
            {name: "unit"},
            {name: "costCenterCode"},
            {name: "costCenterTitleFa"},
            {name: "enabled",
                valueMap:{
                    // undefined : "فعال",
                    74 : "غیر فعال"
                },filterOnKeypress: true,
            },
            {name: "OnDelete", title: " ", align: "center", width:30}
        ],
        dataArrived:function(){
            if(postsSelection) {
                ListGrid_AllPosts.invalidateCache();
                ListGrid_AllPosts.fetchData();
                postsSelection=false;
            }
        },
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
                    prompt: "حذف کردن",
                    height: 16,
                    width: 16,
                    grid: this,
                    click: function () {
                        var activeId = record.id;
                        var activeGroup = ListGrid_Post_Group_Jsp.getSelectedRecord();
                        var activeGroupId = activeGroup.id;
                        isc.RPCManager.sendRequest({
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            actionURL:  postGroupUrl + "/removePost/" + activeGroupId + "/" + activeId,
                            httpMethod: "DELETE",
                            serverOutputAsString: false,
                            callback: function (resp) {
                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                                    ListGrid_ForThisPostGroup_GetPosts.invalidateCache();

                                    let findRows=ListGrid_AllPosts.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"inSet",value:[activeId]}]});

                                    if(typeof (findRows)!='undefined' && findRows.length>0){
                                        findRows.setProperty("enabled", true);
                                        ListGrid_AllPosts.deselectRecord(findRows[0]);
                                    }

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
        }
    });

    var VLayOut_PostGroup_Posts_Jsp = isc.VLayout.create({
        width: "100%",
        height: "100%",
        border: "3px solid gray",
        layoutMargin: 5,
        members: [
            DynamicForm_thisPostGroupHeader_Jsp,
            ListGrid_AllPosts,
            isc.ToolStripButtonAdd.create({
                width:"100%",
                height:25,
                title:"اضافه کردن گروهی",
                click: function () {
                    let dialog = createDialog('ask', "<spring:message code="msg.record.adds.ask"/>");
                    dialog.addProperties({
                        buttonClick: function (button, index) {
                            this.close();
                            if (index === 0) {
                                var ids = ListGrid_AllPosts.getSelection().filter(function(x){return x.enabled!==false}).map(function(item) {return item.id;});
                                var activeGroup = ListGrid_Post_Group_Jsp.getSelectedRecord();
                                var activeGroupId = activeGroup.id;
                                let JSONObj = {"ids": ids};
                                isc.RPCManager.sendRequest({
                                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                    useSimpleHttp: true,
                                    contentType: "application/json; charset=utf-8",
                                    actionURL: postGroupUrl + "/addPosts/" + activeGroupId + "/" + ids,
                                    httpMethod: "POST",
                                    data: JSON.stringify(JSONObj),
                                    serverOutputAsString: false,
                                    callback: function (resp) {
                                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                            ListGrid_ForThisPostGroup_GetPosts.invalidateCache();

                                            let findRows=ListGrid_AllPosts.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"inSet",value:ids}]});

                                            if(typeof (findRows)!='undefined' && findRows.length>0){
                                                findRows.setProperty("enabled", false);
                                                ListGrid_AllPosts.redraw();
                                            }
                                            isc.say("عملیات با موفقیت انجام شد.");

                                        } else {
                                            isc.say("خطا در پاسخ سرویس دهنده");
                                        }
                                    }
                                });
                            }
                        }
                    })

                }
            }),
            isc.LayoutSpacer.create({ID: "spacer", height: "5%"}),
            ListGrid_ForThisPostGroup_GetPosts,
            isc.ToolStripButtonRemove.create({
                width:"100%",
                height:25,
                title:"حذف گروهی",
                click: function () {
                    let dialog = createDialog('ask', "<spring:message code="msg.record.remove.ask"/>");
                    dialog.addProperties({
                        buttonClick: function (button, index) {
                            this.close();
                            if (index === 0) {
                                var ids = ListGrid_ForThisPostGroup_GetPosts.getSelection().map(function(item) {return item.id;});
                                var activeGroup = ListGrid_Post_Group_Jsp.getSelectedRecord();
                                var activeGroupId = activeGroup.id;
                                let JSONObj = {"ids": ids};
                                isc.RPCManager.sendRequest({
                                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                    useSimpleHttp: true,
                                    contentType: "application/json; charset=utf-8",
                                    actionURL: postGroupUrl + "/removePosts/" + activeGroupId + "/" + ids,
                                    httpMethod: "DELETE",
                                    data: JSON.stringify(JSONObj),
                                    serverOutputAsString: false,
                                    callback: function (resp) {
                                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                                            ListGrid_ForThisPostGroup_GetPosts.invalidateCache();
                                            let findRows=ListGrid_AllPosts.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"inSet",value:ids}]});

                                            if(typeof (findRows)!='undefined' && findRows.length>0){
                                                findRows.setProperty("enabled", true);
                                                ListGrid_AllPosts.deselectRecord(findRows);
                                                ListGrid_AllPosts.redraw();
                                            }
                                            isc.say("عملیات با موفقیت انجام شد.");
                                        } else {
                                            isc.say("خطا در پاسخ سرویس دهنده");
                                        }
                                    }
                                });
                            }
                        }
                    })

                }
            })
        ]
    });

    var Window_Add_Post_to_PostGroup = isc.Window.create({
        title: "لیست پست های انفرادی",
        align: "center",
        placement: "fillScreen",
        minWidth: 1024,
        closeClick: function () {
            ListGrid_Post_Group_Posts.invalidateCache();
            this.hide();
        },
        items: [
            VLayOut_PostGroup_Posts_Jsp
        ]
    });


   let ToolStrip_Post_Post_Group_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = ListGrid_Post_Group_Posts.getCriteria();

                    if(typeof(criteria.operator)=='undefined'){
                        criteria._constructor="AdvancedCriteria";
                        criteria.operator="and";
                    }

                    if(typeof(criteria.criteria)=='undefined'){
                        criteria.criteria=[];
                    }
                    criteria.criteria.push({fieldName: "postGroup", operator: "equals", value: ListGrid_Post_Group_Jsp.getSelectedRecord().id});

                    ExportToFile.downloadExcel(null, ListGrid_Post_Group_Posts , "Post_Group_Post", 0, null, '',"لیست پست های انفرادی - گروه پستی"  , criteria, null);
                }
            })
        ]
    });

    let ActionsTS_Post_Post_Group = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStrip_Post_Post_Group_Export2EXcel
        ]
    });

    var ListGrid_Post_Group_Posts = isc.TrLG.create({
        dataSource: RestDataSource_Post_Group_Posts_Jsp,
        contextMenu: Menu_ListGrid_Post_Group_Posts,
        autoFetchData: false,
        sortField: 1,
        gridComponents: [ActionsTS_Post_Post_Group, "header", "filterEditor", "body",],
        fields: [
            {name: "code",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {name: "titleFa"},
            {name: "jobTitle"},
            {name: "postGradeTitle"},
            {name: "area"},
            {name: "assistance"},
            {name: "affairs"},
            {name: "section"},
            {name: "unit"},
            {name: "costCenterCode",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "costCenterTitleFa"},
            {name: "enabled",
                valueMap:{
                    // undefined : "فعال",
                    74 : "غیر فعال"
                },filterOnKeypress: true,
            },
        ],
        getCellCSSText: function (record) {
            if (record.type == 1)
                return "background-color:#babaf5;";
        },
    });



    /****************************************************************************************************************************************************************************/
    var Menu_ListGrid_Post_Group_TrainingPosts = isc.Menu.create({
        width: 150,
        data: [{
            title: "بازخوانی اطلاعات", icon: "<spring:url value="refresh.png"/>", click: function () {
                ListGrid_Post_Group_TrainingPosts_refresh();
            }
        }, {
            title: " حذف پست از گروه پست مربوطه", icon: "<spring:url value="remove.png"/>", click: function () {
                activePostGroup = ListGrid_Post_Group_Jsp.getSelectedRecord();
                activeTrainingPost = ListGrid_Post_Group_TrainingPosts.getSelectedRecord();
                if (activePostGroup == null || activeTrainingPost == null) {
                    simpleDialog("پیام", "پست یا گروه پست انتخاب نشده است.", 0, "confirm");

                } else {
                    isc.Dialog.create({
                        message: getFormulaMessage("آیا از حذف  پست:' ", "2", "black", "c") + getFormulaMessage(activeTrainingPost.titleFa, "3", "red", "U") + getFormulaMessage(" از گروه پست:' ", "2", "black", "c") + getFormulaMessage(activePostGroup.titleFa, "3", "red", "U") + getFormulaMessage(" ' مطمئن هستید؟", "2", "black", "c"),//"<font size='2' color='red'>"+"آیا از حذف گروه پست:' " +record.titleFa+ " ' مطمئن هستید؟" +"</font>",
                        icon: "[SKIN]ask.png",
                        title: "تائید حذف",
                        buttons: [isc.IButtonSave.create({title: "بله"}), isc.IButtonCancel.create({
                            title: "خیر"
                        })],
                        buttonClick: function (button, index) {
                            this.close();

                            if (index === 0) {
                                deleteTrainingPostFromPostGroup(activeTrainingPost.id, activePostGroup.id);
                            }
                        }
                    });

                }
            }
        },

        ]
    });

    var RestDataSource_Post_Group_TrainingPosts_Jsp = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true, hidden: true},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "job.titleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "job.code", title: "<spring:message code="job.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "postGrade.titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true,autoFitWidthApproach: "both",},

        ],
        fetchDataURL: trainingPostUrl + "/spec-list"
    });
    var RestDataSource_All_Training_Posts = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains"},
            {name: "titleEn", title: "<spring:message code="title.en"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "job.code", title: "<spring:message code="job.code"/>", filterOperator: "iContains"},
            {name: "job.titleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains"},
            {name: "postGrade.code", title: "<spring:message code="post.grade.code"/>", filterOperator: "iContains"},
            {name: "postGrade.titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains"},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both",},
        ]
        , fetchDataURL: trainingPostUrl + "/spec-list"
    });
    var RestDataSource_ForThisPostGroup_GetTrainingPosts = isc.TrDS.create({
        fields: [
            {name: "id", primaryKey: true},
            {name: "code", title: "<spring:message code="post.code"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "titleFa", title: "<spring:message code="post.title"/>", filterOperator: "iContains"},
            {name: "titleEn", title: "<spring:message code="title.en"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "description", title: "<spring:message code="description"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "job.code", title: "<spring:message code="job.code"/>", filterOperator: "iContains"},
            {name: "job.titleFa", title: "<spring:message code="job.title"/>", filterOperator: "iContains"},
            {name: "postGrade.code", title: "<spring:message code="post.grade.code"/>", filterOperator: "iContains"},
            {name: "postGrade.titleFa", title: "<spring:message code="post.grade.title"/>", filterOperator: "iContains"},
            {name: "area", title: "<spring:message code="area"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "assistance", title: "<spring:message code="assistance"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "affairs", title: "<spring:message code="affairs"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "section", title: "<spring:message code="section"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "unit", title: "<spring:message code="unit"/>", filterOperator: "iContains", autoFitWidth: true, autoFitWidthApproach: "both"},
            {name: "costCenterCode", title: "<spring:message code="reward.cost.center.code"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "costCenterTitleFa", title: "<spring:message code="reward.cost.center.title"/>", filterOperator: "iContains", autoFitWidth: true},
            {name: "enabled", title: "<spring:message code="active.status"/>", align: "center", filterOperator: "equals", autoFitWidth: true, autoFitWidthApproach: "both",},
        ]
    });
    var DynamicForm_thisTrainingPostGroupHeader_Jsp = isc.DynamicForm.create({
        height: "5%",
        align: "center",
        fields: [{name: "sgTitle", type: "staticText", title: "افزودن پست به گروه پست ", wrapTitle: false}]
    });

    Lable_AllTrainingPosts = isc.LgLabel.create({contents:"لیست تمامی پست ها", customEdges: ["R","L","T", "B"]});
    var ListGrid_AllTrainingPosts = isc.TrLG.create({
        height: "45%",
        dataSource: RestDataSource_All_Training_Posts,
        selectionAppearance: "checkbox",
        selectionType: "simple",
        sortField: 1,
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        gridComponents: [Lable_AllTrainingPosts, "filterEditor", "header", "body"],
        fields: [
            {name: "code", filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }},
            {name: "titleFa"},
            {name: "job.code"},
            {name: "job.titleFa"},
            {name: "postGrade.code"},
            {name: "postGrade.titleFa"},
            {name: "area"},
            {name: "assistance"},
            {name: "affairs"},
            {name: "section"},
            {name: "unit"},
            {name: "costCenterCode"},
            {name: "costCenterTitleFa"},
            {name: "enabled",
                valueMap:{
                    //undefined : "فعال",
                    74 : "غیر فعال"
                },filterOnKeypress: true,
            },
            {name: "OnAdd", title: " ",canSort:false,canFilter:false, width:30}
        ],
        dataArrived:function(){
            let lgIds = ListGrid_ForThisPostGroup_GetTrainingPosts.data.getAllCachedRows().map(function(item) {
                return item.id;
            });

            let findRows=ListGrid_AllTrainingPosts.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"inSet",value:lgIds}]});
            ListGrid_AllTrainingPosts.setSelectedState(findRows);
            findRows.setProperty("enabled", false);
        },
        createRecordComponent: function (record, colNum) {
            var fieldName = this.getFieldName(colNum);
            if (fieldName === "OnAdd") {
                var recordCanvas = isc.HLayout.create({
                    height: 20,
                    width: "100%",
                    layoutMargin: 5,
                    membersMargin: 10,
                    align: "center"
                });
                var addIcon = isc.ImgButton.create({
                    showDown: false,
                    showRollOver: false,
                    layoutAlign: "center",
                    src: "[SKIN]/actions/add.png",
                    prompt: "اضافه کردن",
                    height: 16,
                    width: 16,
                    grid: this,
                    click: function () {
                        let current = record;
                        let selected=ListGrid_ForThisPostGroup_GetTrainingPosts.data.getAllCachedRows().map(function(item) {return item.id;});

                        let ids = [];

                        if ($.inArray(current.id, selected) === -1){
                            ids.push(current.id);
                        }

                        if(ids.length!==0){
                            let findRows=ListGrid_AllTrainingPosts.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"equals",value:current.id}]});

                            let groupRecord = ListGrid_Post_Group_Jsp.getSelectedRecord();
                            let groupId = groupRecord.id;

                            let JSONObj = {"ids": ids};
                            wait.show();

                            isc.RPCManager.sendRequest({
                                httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                useSimpleHttp: true,
                                contentType: "application/json; charset=utf-8",
                                actionURL: postGroupUrl + "/addTrainingPosts/" + groupId + "/" + ids,
                                httpMethod: "POST",
                                data: JSON.stringify(JSONObj),
                                serverOutputAsString: false,
                                callback: function (resp) {
                                    wait.close();
                                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                        ListGrid_AllTrainingPosts.selectRecord(findRows);
                                        findRows.setProperty("enabled", false);
                                        ListGrid_AllTrainingPosts.redraw();

                                        ListGrid_ForThisPostGroup_GetTrainingPosts.invalidateCache();
                                        ListGrid_ForThisPostGroup_GetTrainingPosts.fetchData();
                                    } else {
                                        isc.say("خطا");
                                    }
                                }
                            });

                        }
                    }
                });
                recordCanvas.addMember(addIcon);
                return recordCanvas;
            } else
                return null;
        }
    });

    Lable_ForThisPostGroup_GetTrainingPosts = isc.LgLabel.create({contents:"لیست پست های این گروه پست", customEdges: ["R","L","T", "B"]});
    var ListGrid_ForThisPostGroup_GetTrainingPosts = isc.TrLG.create({
        height: "45%",
        showRecordComponents: true,
        showRecordComponentsByCell: true,
        gridComponents: [Lable_ForThisPostGroup_GetTrainingPosts, "filterEditor", "header", "body"],
        dataSource: RestDataSource_ForThisPostGroup_GetTrainingPosts,
        sortField: 1,
        selectionAppearance: "checkbox",
        selectionType: "simple",
        fields: [
            {name: "id", hidden:true},
            {name: "code", filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }},
            {name: "titleFa"},
            {name: "job.code"},
            {name: "job.titleFa"},
            {name: "postGrade.code"},
            {name: "postGrade.titleFa"},
            {name: "area"},
            {name: "assistance"},
            {name: "affairs"},
            {name: "section"},
            {name: "unit"},
            {name: "costCenterCode"},
            {name: "costCenterTitleFa"},
            {name: "enabled",
                valueMap:{
                    // undefined : "فعال",
                    74 : "غیر فعال"
                },filterOnKeypress: true,
            },
            {name: "OnDelete", title: " ", align: "center", width:30}
        ],
        dataArrived:function(){
            if(postsSelection) {
                ListGrid_AllTrainingPosts.invalidateCache();
                ListGrid_AllTrainingPosts.fetchData();
                postsSelection=false;
            }
        },
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
                    prompt: "حذف کردن",
                    height: 16,
                    width: 16,
                    grid: this,
                    click: function () {
                        var activeId = record.id;
                        var activeGroup = ListGrid_Post_Group_Jsp.getSelectedRecord();
                        var activeGroupId = activeGroup.id;
                        isc.RPCManager.sendRequest({
                            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                            useSimpleHttp: true,
                            contentType: "application/json; charset=utf-8",
                            actionURL:  postGroupUrl + "/removeTrainingPost/" + activeGroupId + "/" + activeId,
                            httpMethod: "DELETE",
                            serverOutputAsString: false,
                            callback: function (resp) {
                                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                                    ListGrid_ForThisPostGroup_GetTrainingPosts.invalidateCache();

                                    let findRows=ListGrid_AllTrainingPosts.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"inSet",value:[activeId]}]});

                                    if(typeof (findRows)!='undefined' && findRows.length>0){
                                        findRows.setProperty("enabled", true);
                                        ListGrid_AllTrainingPosts.deselectRecord(findRows[0]);
                                    }

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
        }
    });


    var VLayOut_PostGroup_Training_Posts_Jsp = isc.VLayout.create({
        width: "100%",
        height: "100%",
        border: "3px solid gray",
        layoutMargin: 5,
        members: [
            DynamicForm_thisTrainingPostGroupHeader_Jsp,
            ListGrid_AllTrainingPosts,
            isc.ToolStripButtonAdd.create({
                width:"100%",
                height:25,
                title:"اضافه کردن گروهی",
                click: function () {
                    let dialog = createDialog('ask', "<spring:message code="msg.record.adds.ask"/>");
                    dialog.addProperties({
                        buttonClick: function (button, index) {
                            this.close();
                            if (index === 0) {
                                var ids = ListGrid_AllTrainingPosts.getSelection().filter(function(x){return x.enabled!==false}).map(function(item) {return item.id;});
                                var activeGroup = ListGrid_Post_Group_Jsp.getSelectedRecord();
                                var activeGroupId = activeGroup.id;
                                let JSONObj = {"ids": ids};
                                isc.RPCManager.sendRequest({
                                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                    useSimpleHttp: true,
                                    contentType: "application/json; charset=utf-8",
                                    actionURL: postGroupUrl + "/addTrainingPosts/" + activeGroupId + "/" + ids,
                                    httpMethod: "POST",
                                    data: JSON.stringify(JSONObj),
                                    serverOutputAsString: false,
                                    callback: function (resp) {
                                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                                            ListGrid_ForThisPostGroup_GetTrainingPosts.invalidateCache();

                                            let findRows=ListGrid_AllTrainingPosts.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"inSet",value:ids}]});

                                            if(typeof (findRows)!='undefined' && findRows.length>0){
                                                findRows.setProperty("enabled", false);
                                                ListGrid_AllTrainingPosts.redraw();
                                            }
                                            isc.say("عملیات با موفقیت انجام شد.");

                                        } else {
                                            isc.say("خطا در پاسخ سرویس دهنده");
                                        }
                                    }
                                });
                            }
                        }
                    })

                }
            }),
            isc.LayoutSpacer.create({ID: "spacer", height: "5%"}),
            ListGrid_ForThisPostGroup_GetTrainingPosts,
            isc.ToolStripButtonRemove.create({
                width:"100%",
                height:25,
                title:"حذف گروهی",
                click: function () {
                    let dialog = createDialog('ask', "<spring:message code="msg.record.remove.ask"/>");
                    dialog.addProperties({
                        buttonClick: function (button, index) {
                            this.close();
                            if (index === 0) {
                                var ids = ListGrid_ForThisPostGroup_GetTrainingPosts.getSelection().map(function(item) {return item.id;});
                                var activeGroup = ListGrid_Post_Group_Jsp.getSelectedRecord();
                                var activeGroupId = activeGroup.id;
                                let JSONObj = {"ids": ids};
                                isc.RPCManager.sendRequest({
                                    httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
                                    useSimpleHttp: true,
                                    contentType: "application/json; charset=utf-8",
                                    actionURL: postGroupUrl + "/removeTrainingPosts/" + activeGroupId + "/" + ids,
                                    httpMethod: "DELETE",
                                    data: JSON.stringify(JSONObj),
                                    serverOutputAsString: false,
                                    callback: function (resp) {
                                        if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {

                                            ListGrid_ForThisPostGroup_GetTrainingPosts.invalidateCache();
                                            let findRows=ListGrid_AllTrainingPosts.findAll({_constructor:"AdvancedCriteria",operator:"and",criteria:[{fieldName:"id",operator:"inSet",value:ids}]});

                                            if(typeof (findRows)!='undefined' && findRows.length>0){
                                                findRows.setProperty("enabled", true);
                                                ListGrid_AllTrainingPosts.deselectRecord(findRows);
                                                ListGrid_AllTrainingPosts.redraw();
                                            }
                                            isc.say("عملیات با موفقیت انجام شد.");
                                        } else {
                                            isc.say("خطا در پاسخ سرویس دهنده");
                                        }
                                    }
                                });
                            }
                        }
                    })

                }
            })
        ]
    });

    var Window_Add_Training_Post_to_PostGroup = isc.Window.create({
        title: "لیست پست ها",
        align: "center",
        placement: "fillScreen",
        minWidth: 1024,
        closeClick: function () {
            ListGrid_Post_Group_Posts.invalidateCache();
            this.hide();
        },
        items: [
            VLayOut_PostGroup_Training_Posts_Jsp
        ]
    });

    let ToolStrip_TrainingPost_Post_Group_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = ListGrid_Post_Group_TrainingPosts.getCriteria();

                    if(typeof(criteria.operator)=='undefined'){
                        criteria._constructor="AdvancedCriteria";
                        criteria.operator="and";
                    }

                    if(typeof(criteria.criteria)=='undefined'){
                        criteria.criteria=[];
                    }
                    criteria.criteria.push({fieldName: "postGroupSet", operator: "inSet", value: ListGrid_Post_Group_Jsp.getSelectedRecord().id});

                    ExportToFile.downloadExcel(null, ListGrid_Post_Group_TrainingPosts , "Training_Post_Group_Post", 0, null, '',"لیست پست ها - گروه پستی"  , criteria, null);
                }
            })
        ]
    });

    let ActionsTS_TrainingPost_Post_Group = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStrip_TrainingPost_Post_Group_Export2EXcel
        ]
    });

    var ListGrid_Post_Group_TrainingPosts = isc.TrLG.create({
        dataSource: RestDataSource_Post_Group_TrainingPosts_Jsp,
        contextMenu: Menu_ListGrid_Post_Group_TrainingPosts,
        autoFetchData: false,
        sortField: 1,
        gridComponents: [ActionsTS_TrainingPost_Post_Group, "header", "filterEditor", "body",],
        fields: [
            {name: "code",
                filterEditorProperties: {
                    keyPressFilter: "[0-9/]"
                }
            },
            {name: "titleFa"},
            {name: "job.titleFa"},
            {name: "postGrade.titleFa"},
            {name: "area"},
            {name: "assistance"},
            {name: "affairs"},
            {name: "section"},
            {name: "unit"},
            {name: "costCenterCode",
                filterEditorProperties: {
                    keyPressFilter: "[0-9]"
                }
            },
            {name: "costCenterTitleFa"},
            {name: "enabled",
                valueMap:{
                    // undefined : "فعال",
                    74 : "غیر فعال"
                },filterOnKeypress: true,
            },
        ]
    });


    /****************************************************************************************************************************************************************************/
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
                    if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
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
            // Window_NeedsAssessment_Edit.setProperties({
            //     close() {
            //         ListGrid_Post_Group_Jsp.invalidateCache()
            //         this.Super("close", arguments)
            //     }
            // })
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

            LoadAttachments_Post_Group.ListGrid_JspAttachment.setData([]);
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
        title: "لیست پست های انفرادی",
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
                postsSelection=true;
                RestDataSource_ForThisPostGroup_GetPosts.fetchDataURL = postGroupUrl + "/" + record.id + "/getPosts";
                ListGrid_ForThisPostGroup_GetPosts.invalidateCache();
                ListGrid_ForThisPostGroup_GetPosts.fetchData();
                DynamicForm_thisPostGroupHeader_Jsp.setValue("sgTitle", getFormulaMessage(record.titleFa, "2", "red", "B"));
                Lable_ForThisPostGroup_GetPosts.setContents("لیست پست های انفرادی گروه پست " + getFormulaMessage(record.titleFa, "2", "red", "B"));
                Window_Add_Post_to_PostGroup.show();


                //Window_Add_Post_to_PostGroup.
                //   Window_Add_Post_to_PostGroup.show();

            }
        }
    });

    var ToolStripButton_Add_Traininng_Post_Group_AddPost_Jsp = isc.ToolStripButton.create({
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
                postsSelection=true;
                RestDataSource_ForThisPostGroup_GetTrainingPosts.fetchDataURL = postGroupUrl + "/" + record.id + "/getTrainingPosts";
                ListGrid_ForThisPostGroup_GetTrainingPosts.invalidateCache();
                ListGrid_ForThisPostGroup_GetTrainingPosts.fetchData();
                DynamicForm_thisTrainingPostGroupHeader_Jsp.setValue("sgTitle", getFormulaMessage(record.titleFa, "2", "red", "B"));
                Lable_ForThisPostGroup_GetTrainingPosts.setContents("لیست پست های گروه پست " + getFormulaMessage(record.titleFa, "2", "red", "B"));
                Window_Add_Training_Post_to_PostGroup.show();


                //Window_Add_Post_to_PostGroup.
                //   Window_Add_Post_to_PostGroup.show();

            }
        }
    });

    let ToolStrip_Post_Group_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = ListGrid_Post_Group_Jsp.getCriteria();
                    ExportToFile.downloadExcel(null, ListGrid_Post_Group_Jsp , "View_Post_Group", 0, null, '',"لیست گروه پست - آموزش"  , criteria, null);
                }
            })
        ]
    });

    var ToolStrip_Actions_Post_Group_Jsp = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            ToolStripButton_Add_Post_Group_Jsp,
            ToolStripButton_Edit_Post_Group_Jsp,
            ToolStripButton_Remove_Post_Group_Jsp,
            ToolStripButton_Add_Post_Group_AddPost_Jsp,
            ToolStripButton_Add_Traininng_Post_Group_AddPost_Jsp,
            ToolStrip_Post_Group_Export2EXcel,
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
    });

    let ToolStrip_Post_Group_Personnel_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = PersonnelLG_Post_Group_Jsp.getCriteria();

                    if(typeof(criteria.operator)=='undefined'){
                        criteria._constructor="AdvancedCriteria";
                        criteria.operator="and";
                    }

                    if(typeof(criteria.criteria)=='undefined'){
                        criteria.criteria=[];
                    }
                    criteria.criteria.push({fieldName: "postGroupId", operator: "equals", value:ListGrid_Post_Group_Jsp.getSelectedRecord().id});

                    console.log(criteria);
                    ExportToFile.downloadExcel(null, PersonnelLG_Post_Group_Jsp , "PersonnelPostGroup", 0, null, '',"لیست پرسنل - آموزش"  , criteria, null);
                }
            })
        ]
    });

    let ActionsTS_Personnel_Post_Group = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStrip_Post_Group_Personnel_Export2EXcel
        ]
    });

    PersonnelLG_Post_Group_Jsp = isc.TrLG.create({
        dataSource: PersonnelDS_Post_Group_Jsp,
        selectionType: "single",
        alternateRecordStyles: true,
        gridComponents: [ActionsTS_Personnel_Post_Group, "header", "filterEditor", "body",],
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

    let ToolStrip_Post_Group_NA_Export2EXcel = isc.ToolStrip.create({
        width: "100%",
        membersMargin: 5,
        members: [
            isc.ToolStripButtonExcel.create({
                click: function () {
                    let criteria = CourseLG_Post_Group_Jsp.getCriteria();

                    if(typeof(criteria.operator)=='undefined'){
                        criteria._constructor="AdvancedCriteria";
                        criteria.operator="and";
                    }

                    if(typeof(criteria.criteria)=='undefined'){
                        criteria.criteria=[];
                    }
                    criteria.criteria.push({fieldName: "objectId", operator: "equals", value: ListGrid_Post_Group_Jsp.getSelectedRecord().id});
                    criteria.criteria.push({fieldName: "objectType", operator: "equals", value: "PostGroup"});
                    // criteria.criteria.push({fieldName: "personnelNo", operator: "equals", value: null});

                    ExportToFile.downloadExcel(null, CourseLG_Post_Group_Jsp , "NeedsAssessmentReport", 0, null, '',"لیست نیازسنجی - آموزش"  , criteria, null);
                }
            })
        ]
    });

    let ActionsTS_NA_Post_Group = isc.ToolStrip.create({
        width: "100%",
        members: [
            ToolStrip_Post_Group_NA_Export2EXcel
        ]
    });

    CourseLG_Post_Group_Jsp = isc.TrLG.create({
        dataSource: CourseDS_Post_Group_Jsp,
        selectionType: "none",
        autoFetchData: false,
        alternateRecordStyles: true,
        showAllRecords: true,
        gridComponents: [
            ActionsTS_NA_Post_Group,
            "header", "filterEditor", "body",],
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
            {name: "TabPane_Post_Post_Group_Jsp", title: "لیست پست های انفرادی", pane: ListGrid_Post_Group_Posts},
            {name: "TabPane_Training_Post_Post_Group_Jsp", title: "لیست پست ها", pane: ListGrid_Post_Group_TrainingPosts},
            {name: "TabPane_Personnel_Post_Group_Jsp", title: "لیست پرسنل", pane: PersonnelLG_Post_Group_Jsp},
            {name: "TabPane_NA_Post_Group_Jsp", title: "<spring:message code='need.assessment'/>", pane: CourseLG_Post_Group_Jsp},
            {
                ID: "PostGroup_AttachmentsTab",
                title: "<spring:message code="attachments"/>",
            },
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
        showResizeBar:true,
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

    function ListGrid_Post_Group_TrainingPosts_refresh() {

        if (ListGrid_Post_Group_Jsp.getSelectedRecord() == null)
            ListGrid_Post_Group_TrainingPosts.setData([]);
        else
            ListGrid_Post_Group_TrainingPosts.invalidateCache();
        CourseLG_Post_Group_Jsp.setData([]);
        PersonnelLG_Post_Group_Jsp.setData([]);
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
            isc.Dialog.create({
                message: getFormulaMessage("آیا از حذف گروه پست:' ", "2", "black", "c") + getFormulaMessage(record.titleFa, "3", "red", "U") + getFormulaMessage(" ' مطمئن هستید؟", "2", "black", "c"),//"<font size='2' color='red'>"+"آیا از حذف گروه پست:' " +record.titleFa+ " ' مطمئن هستید؟" +"</font>",
                icon: "[SKIN]ask.png",
                title: "تائید حذف",
                buttons: [isc.IButtonSave.create({title: "بله"}), isc.IButtonCancel.create({
                    title: "خیر"
                })],
                buttonClick: function (button, index) {
                    this.close();
                    if (index === 0) {
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
                                if (resp.httpResponseCode === 200) {
                                    ListGrid_Post_Group_Jsp.invalidateCache();
                                    simpleDialog("انجام فرمان", "حذف با موفقیت انجام شد", 2000, "say");
                                    ListGrid_Post_Group_Posts.setData([]);
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
        objectIdAttachment=null;
        naPostGroup_Post_Group_Jsp = null;
        PersonnelPostGroup_Post_Group_Jsp = null;
        PostPostGroup_Post_Group_Jsp = null;
        ListGrid_Post_Group_Jsp.invalidateCache();
        ListGrid_Post_Group_Posts_refresh();
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
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    ListGrid_Post_Group_Posts.invalidateCache();

                } else {
                    isc.say("خطا در پاسخ سرویس دهنده");
                }
            }
        });
    }

    function deleteTrainingPostFromPostGroup(trainingPostId, postGroupId) {

        isc.RPCManager.sendRequest({
            httpHeaders: {"Authorization": "Bearer <%= accessToken %>"},
            useSimpleHttp: true,
            contentType: "application/json; charset=utf-8",
            actionURL: postGroupUrl + "/removeTrainingPost/" + postGroupId + "/" + trainingPostId,
            httpMethod: "DELETE",
            serverOutputAsString: false,
            callback: function (resp) {
                if (resp.httpResponseCode === 200 || resp.httpResponseCode === 201) {
                    ListGrid_Post_Group_TrainingPosts.invalidateCache();

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
        
        switch (tab.name || tab.ID) {
            case "TabPane_Post_Post_Group_Jsp":{
                if (PostPostGroup_Post_Group_Jsp === postGroup.id){
                    return;
                }
                PostPostGroup_Post_Group_Jsp = postGroup.id;
                ListGrid_Post_Group_Posts.setImplicitCriteria({
                    _constructor: "AdvancedCriteria",
                    operator: "and",
                    criteria: [{fieldName: "groupid", operator: "equals", value: postGroup.id}]
                });
                ListGrid_Post_Group_Posts.invalidateCache();
                ListGrid_Post_Group_Posts.fetchData();
                break;
            }
            case "TabPane_Training_Post_Post_Group_Jsp":{
                ListGrid_Post_Group_TrainingPosts.setImplicitCriteria({
                    _constructor: "AdvancedCriteria",
                    operator: "and",
                    criteria: [{fieldName: "postGroupSet", operator: "equals", value: postGroup.id}]
                });
                ListGrid_Post_Group_TrainingPosts.invalidateCache();
                ListGrid_Post_Group_TrainingPosts.fetchData();
                break;
            }
            case "TabPane_Personnel_Post_Group_Jsp":{
                if (PersonnelPostGroup_Post_Group_Jsp === postGroup.id)
                    return;
                PersonnelDS_Post_Group_Jsp.fetchDataURL = postGroupUrl + "/" + postGroup.id + "/getPersonnel";
                PersonnelPostGroup_Post_Group_Jsp = postGroup.id;
                PersonnelLG_Post_Group_Jsp.invalidateCache();
                PersonnelLG_Post_Group_Jsp.fetchData();
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
            case "PostGroup_AttachmentsTab": {
                if (typeof LoadAttachments_Post_Group.loadPage_attachment_Job !== "undefined")
                    LoadAttachments_Post_Group.loadPage_attachment_Job("PostGroup", postGroup.id, "<spring:message code="attachment"/>", {
                        1: "جزوه",
                        2: "لیست نمرات",
                        3: "لیست حضور و غیاب",
                        4: "نامه غیبت موجه"
                    }, false);
                break;
            }
        }
    }

    if (!loadjs.isDefined('load_Attachments_post_Group')) {
        loadjs('<spring:url value='tclass/attachments-tab' />', 'load_Attachments_post_Group');
    }

    loadjs.ready('load_Attachments_post_Group', function () {
        setTimeout(()=> {
            LoadAttachments_Post_Group = new loadAttachments();
            Detail_Tab_Post_Group.updateTab(PostGroup_AttachmentsTab, LoadAttachments_Post_Group.VLayout_Body_JspAttachment)
        },0);

    });

    function loadPostData(criteria, title){
        PostLG_PostGroup.setImplicitCriteria(criteria);
        PostLG_PostGroup.invalidateCache();
        PostLG_PostGroup.fetchData();
        window_unGroupedPosts_PostGroup.setTitle(title);
        window_unGroupedPosts_PostGroup.show();
    }

    // </script>